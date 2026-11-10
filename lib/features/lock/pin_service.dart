import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import '../../data/secret_store.dart';
import '../../data/settings_repository.dart';

/// The 4-digit App lock PIN (APP.md decision 2026-11-10 item 6; same as A002 F-11, AC-31..34).
///
/// Only a random salt and an iterated SHA-256 hash are kept, in the OS secure storage (Android
/// Keystore, iOS Keychain) through [SecretStore] — never the PIN, never the database or a backup
/// file.
///
/// iOS keeps the Keychain after the app is deleted while the database goes (A002 D-017). So when
/// the PIN is set, a random install id is written to BOTH the secure storage and the `settings`
/// table; [clearIfReinstalled] turns the PIN off when the two differ (a fresh database), so a
/// reinstall never locks the user out with an old PIN. The install id is not one of
/// `SettingsRepository.backupKeys`: a restore never brings another phone's id.
class PinService {
  PinService(this._store, {this._settings, Random? random, this._iterations = defaultIterations})
    : _random = random ?? Random.secure();

  final SecretStore _store;
  final SettingsRepository Function()? _settings;
  final Random _random;
  final int _iterations;

  static const hashKey = 'pin_hash';
  static const saltKey = 'pin_salt';
  static const installKey = 'pin_install_id';

  /// `settings` row holding the install id (see the class comment).
  static const settingsInstallKey = 'pinInstallId';

  /// Slows down guessing the 10,000 possible PINs from a stolen hash.
  static const defaultIterations = 20000;

  static bool isValidPin(String pin) => RegExp(r'^\d{4}$').hasMatch(pin);

  /// On when the database has this install's id (written by every [setPin]) AND secure storage
  /// has a hash. The database is read first: no id means no PIN was ever set on this install, so
  /// secure storage is not touched (fast cold start; a stale iOS Keychain PIN does not count).
  Future<bool> isEnabled() async {
    if (!await hasInstallIdInDatabase()) return false;
    return await _store.read(hashKey) != null;
  }

  /// Whether the database holds an install id (always true without [SettingsRepository]).
  Future<bool> hasInstallIdInDatabase() async {
    final settings = _settings;
    if (settings == null) return true;
    return (await settings().raw())[settingsInstallKey] != null;
  }

  Future<void> setPin(String pin) async {
    if (!isValidPin(pin)) throw ArgumentError('The PIN must be 4 digits');
    final settings = _settings?.call();
    if (settings != null) {
      // Reuse the id already in the database: if writing the Keychain fails half-way while
      // changing the PIN, the old PIN still matches and is not wiped by mistake on next open.
      var installId = (await settings.raw())[settingsInstallKey];
      if (installId == null) {
        installId = _randomBase64();
        await settings.set(settingsInstallKey, installId);
      }
      await _store.write(installKey, installId);
    }
    final salt = _randomBase64();
    await _store.write(saltKey, salt);
    await _store.write(hashKey, hashPin(pin, salt, iterations: _iterations));
  }

  /// Called once when the app opens, before asking for the PIN. Secure storage holds an install
  /// id the database does not have → the database was just created (deleted and reinstalled on
  /// iOS): drop the old PIN. A PIN set before install ids existed is kept. True when dropped.
  Future<bool> clearIfReinstalled() async {
    final settings = _settings;
    if (settings == null) return false;
    final installId = await _store.read(installKey);
    if (installId == null) return false;
    if ((await settings().raw())[settingsInstallKey] == installId) return false;
    await disable();
    return true;
  }

  Future<bool> verify(String pin) async {
    final salt = await _store.read(saltKey);
    final hash = await _store.read(hashKey);
    if (salt == null || hash == null) return false;
    return _constantTimeEquals(hashPin(pin, salt, iterations: _iterations), hash);
  }

  /// Turns the lock off: removes the hash, the salt and the install id from secure storage.
  Future<void> disable() async {
    await _store.delete(hashKey);
    await _store.delete(saltKey);
    await _store.delete(installKey);
  }

  String _randomBase64() => base64Encode(List<int>.generate(16, (_) => _random.nextInt(256)));

  /// SHA-256 of salt + PIN, iterated [iterations] times with the salt.
  static String hashPin(String pin, String salt, {int iterations = defaultIterations}) {
    final saltBytes = utf8.encode(salt);
    var digest = sha256.convert(utf8.encode('$salt:$pin')).bytes;
    for (var i = 1; i < iterations; i++) {
      digest = sha256.convert([...digest, ...saltBytes]).bytes;
    }
    return base64Encode(digest);
  }

  static bool _constantTimeEquals(String a, String b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
    }
    return diff == 0;
  }
}
