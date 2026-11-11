import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../secret_store.dart';
import 'backup_crypto.dart';
import 'backup_folder_service.dart';
import 'backup_schedule.dart';
import 'backup_service.dart';

/// Result of the latest automatic backup attempt.
enum AutoBackupResult {
  ok,

  /// Write permission for the folder was revoked.
  permissionDenied,

  /// The folder was deleted or cannot be reached.
  folderMissing,

  /// Anything else (encryption, writing, secure storage…).
  failed,

  /// Turned off or missing folder/password; nothing was done.
  notConfigured,

  /// Another backup is running; nothing was done and the previous result is kept.
  busy,
}

/// Configuration and latest result, read from [SecretStore].
class AutoBackupState {
  const AutoBackupState({
    this.enabled = false,
    this.folderUri,
    this.folderName,
    this.folderInICloud,
    this.lastAt,
    this.lastResult,
    this.time = BackupTime.defaultTime,
    this.lastCheckAt,
  });

  final bool enabled;
  final String? folderUri;
  final String? folderName;

  /// iOS only: the folder is in iCloud Drive ([PickedFolder.inICloud]); null
  /// when unknown (Android, old configuration).
  final bool? folderInICloud;

  /// The latest attempt (successful or not).
  final DateTime? lastAt;
  final AutoBackupResult? lastResult;

  /// Daily backup time in local time; 21:00 when never saved.
  final BackupTime time;

  /// The latest time a slot was skipped because the data was unchanged (no file written).
  final DateTime? lastCheckAt;

  /// The latest handled slot: tried a backup (success or failure) or found the
  /// data unchanged.
  DateTime? get handledAt {
    final a = lastAt;
    final b = lastCheckAt;
    if (a == null) return b;
    if (b == null) return a;
    return a.isAfter(b) ? a : b;
  }

  /// A passed slot that has not been handled yet: the next open/resume catches up.
  bool isDue(DateTime now) => enabled && isBackupDue(now: now, time: time, handledAt: handledAt);

  /// The next scheduled run (the "Next" line in Settings).
  DateTime nextAt(DateTime now) => nextSlot(now, time);

  bool get lastFailed =>
      lastResult != null &&
      lastResult != AutoBackupResult.ok &&
      lastResult != AutoBackupResult.notConfigured &&
      lastResult != AutoBackupResult.busy;
}

/// Encrypts backup content; tests replace it with a low-iteration version.
typedef BackupEncryptor = Future<String> Function(String json, String password);

/// Automatic backup into a folder the user picked (F7).
///
/// All state lives in [SecretStore] (Keystore/Keychain), NOT in the `settings`
/// table: that table travels inside a backup and is wiped on restore, while the
/// folder and password only make sense on this phone. The password never goes
/// into a file, a log or the database. Every file written is encrypted
/// (AES-256-GCM). [backupNow] and [maybeRunIfDue] never throw; the result is
/// recorded for Settings.
class AutoBackupService {
  AutoBackupService({
    required this.backup,
    required this.folder,
    required this.secrets,
    required this.clock,
    this.encrypt = encryptBackupOffThread,
  });

  final BackupService backup;
  final BackupFolderService folder;
  final SecretStore secrets;
  final DateTime Function() clock;
  final BackupEncryptor encrypt;

  static const enabledKey = 'auto_backup_enabled';
  static const uriKey = 'auto_backup_uri';
  static const nameKey = 'auto_backup_name';
  static const passwordKey = 'auto_backup_password';
  static const lastAtKey = 'auto_backup_last_at';
  static const lastResultKey = 'auto_backup_last_result';
  static const lastHashKey = 'auto_backup_last_hash';
  static const iCloudKey = 'auto_backup_icloud';
  static const timeKey = 'auto_backup_time';
  static const lastCheckKey = 'auto_backup_last_check';

  /// Number of automatic files kept in the folder: the one just written plus one
  /// earlier one, in case data was deleted by mistake and would be overwritten.
  static const keepFiles = 2;

  /// File names this app creates: `subnest-auto-YYYYMMDD-HHmm.subnest`. Only
  /// files matching this exact pattern are pruned; other files in the folder are
  /// never touched.
  static final fileNamePattern = RegExp(r'^subnest-auto-\d{8}-\d{4}\.subnest$');

  bool _running = false;

  /// Called when an AUTOMATIC attempt ([maybeRunIfDue]: open/resume catch-up, iOS notification)
  /// fails, so the user hears about it (product.md §4.13 "Backup failed"). Set once by `main.dart`
  /// in the app; the Android background engine notifies from `autoBackupBackgroundMain` instead.
  /// "Back up now" in Settings shows its own result and does not call it.
  static Future<void> Function(AutoBackupResult result)? onAutomaticFailure;

  /// Results worth a "Backup failed" notification.
  static bool isFailure(AutoBackupResult? r) =>
      r == AutoBackupResult.failed || r == AutoBackupResult.permissionDenied || r == AutoBackupResult.folderMissing;

  static String fileName(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return 'subnest-auto-${d.year}${two(d.month)}${two(d.day)}-${two(d.hour)}${two(d.minute)}.subnest';
  }

  /// Stored as UTC (`...Z`) so a time-zone change does not shift it; old values
  /// without `Z` are read as local time. Returns local time.
  static DateTime? _readTime(String? text) => DateTime.tryParse(text ?? '')?.toLocal();

  static String _writeTime(DateTime t) => t.toUtc().toIso8601String();

  Future<AutoBackupState> state() async {
    try {
      final lastAt = _readTime(await secrets.read(lastAtKey));
      final result = await secrets.read(lastResultKey);
      final iCloud = await secrets.read(iCloudKey);
      return AutoBackupState(
        time: BackupTime.parse(await secrets.read(timeKey)) ?? BackupTime.defaultTime,
        lastCheckAt: _readTime(await secrets.read(lastCheckKey)),
        enabled: await secrets.read(enabledKey) == '1',
        folderUri: await secrets.read(uriKey),
        folderName: await secrets.read(nameKey),
        folderInICloud: iCloud == null ? null : iCloud == '1',
        lastAt: lastAt,
        lastResult: AutoBackupResult.values.asNameMap()[result],
      );
    } catch (_) {
      return const AutoBackupState();
    }
  }

  /// Turns it on: saves the folder (picked, permission held), the password and
  /// the time. Does not back up yet; the caller runs [backupNow] right after.
  Future<void> enable({
    required PickedFolder folder,
    required String password,
    BackupTime time = BackupTime.defaultTime,
  }) async {
    await secrets.write(passwordKey, password);
    await secrets.write(uriKey, folder.uri);
    await _saveFolderInfo(folder);
    await secrets.write(timeKey, time.encode());
    await secrets.delete(lastAtKey);
    await secrets.delete(lastResultKey);
    await secrets.delete(lastHashKey);
    await secrets.delete(lastCheckKey);
    await secrets.write(enabledKey, '1');
  }

  /// Changes the backup time. Does not back up now; the schedule is refreshed
  /// from the new state (`autoBackupScheduleSyncProvider`).
  Future<void> setTime(BackupTime time) => secrets.write(timeKey, time.encode());

  Future<void> _saveFolderInfo(PickedFolder folder) async {
    if (folder.name == null) {
      await secrets.delete(nameKey);
    } else {
      await secrets.write(nameKey, folder.name!);
    }
    if (folder.inICloud == null) {
      await secrets.delete(iCloudKey);
    } else {
      await secrets.write(iCloudKey, folder.inICloud! ? '1' : '0');
    }
  }

  /// Changes the folder, keeps the password; releases the old folder's permission.
  Future<void> changeFolder(PickedFolder folder) async {
    final old = await secrets.read(uriKey);
    await secrets.write(uriKey, folder.uri);
    await _saveFolderInfo(folder);
    await secrets.delete(lastHashKey);
    if (old != null && old != folder.uri) await _release(old);
  }

  /// Turns it off: removes the password from Keystore, releases the folder and
  /// clears the configuration. Does NOT delete files already written.
  Future<void> disable() async {
    String? uri;
    try {
      uri = await secrets.read(uriKey);
    } catch (_) {}
    for (final key in [
      passwordKey,
      enabledKey,
      uriKey,
      nameKey,
      lastAtKey,
      lastResultKey,
      lastHashKey,
      iCloudKey,
      timeKey,
      lastCheckKey,
    ]) {
      try {
        await secrets.delete(key);
      } catch (_) {}
    }
    if (uri != null) await _release(uri);
  }

  Future<void> _release(String uri) async {
    try {
      await folder.releaseFolder(uri);
    } catch (_) {
      // Permission already lost or no channel: treat as released.
    }
  }

  /// Catch-up when the app goes to the BACKGROUND (Android, called from the app
  /// lifecycle listener). See [maybeRunIfDue]. On iOS it does nothing because iOS
  /// may suspend the app immediately (catch-up happens when it opens/returns).
  Future<void> maybeRunDaily() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) return;
    await maybeRunIfDue();
  }

  /// Catch-up when the app OPENS or RETURNS (both platforms); on iOS also when the
  /// user taps the "Time to back up" notification. See [maybeRunIfDue].
  Future<void> maybeRunOnOpen() => maybeRunIfDue();

  /// Backs up if enabled, the latest slot (the time the user chose) has not been
  /// handled, and the data changed since the last successful backup. Shared by
  /// the Android background schedule, the iOS notification and the open/resume
  /// catch-up. Each slot is handled at most once: a failed attempt counts, and a
  /// check that found the data unchanged writes [lastCheckKey] so it does not
  /// re-export on every resume. Returns the result if a backup was attempted,
  /// null otherwise. Never throws.
  Future<AutoBackupResult?> maybeRunIfDue() async {
    if (_running) return null;
    try {
      final s = await state();
      final now = clock();
      if (!s.isDue(now)) return null;
      final lastHash = await secrets.read(lastHashKey);
      if (s.lastResult == AutoBackupResult.ok && lastHash != null && lastHash == await _dataHash()) {
        await secrets.write(lastCheckKey, _writeTime(now));
        return null;
      }
      final result = await backupNow();
      if (isFailure(result)) {
        try {
          await onAutomaticFailure?.call(result);
        } catch (_) {}
      }
      return result;
    } catch (_) {
      // Never let a background error escape.
      return null;
    }
  }

  /// Data fingerprint: the SHA-256 checksum of the backup's data part.
  Future<String> _dataHash() async {
    final root = jsonDecode(await backup.exportJsonText()) as Map<String, dynamic>;
    return root['checksum'] as String;
  }

  /// Backs up now (regardless of the day or whether the data changed). Never
  /// throws; the result is recorded and returned. If another run is in progress,
  /// returns [AutoBackupResult.busy] and leaves the previous result untouched.
  Future<AutoBackupResult> backupNow() async {
    if (_running) return AutoBackupResult.busy;
    _running = true;
    try {
      return await _backupOnce();
    } finally {
      _running = false;
    }
  }

  Future<AutoBackupResult> _backupOnce() async {
    final now = clock();
    var result = AutoBackupResult.failed;
    String? hash;
    try {
      final s = await state();
      final password = await secrets.read(passwordKey);
      final uri = s.folderUri;
      if (!s.enabled || uri == null || password == null) {
        return AutoBackupResult.notConfigured;
      }
      final json = await backup.exportJsonText();
      hash = (jsonDecode(json) as Map<String, dynamic>)['checksum'] as String;
      final sealed = await encrypt(json, password);
      final name = fileName(now);
      await folder.writeFile(uri, name, Uint8List.fromList(utf8.encode(sealed)));
      result = AutoBackupResult.ok;
      await _prune(uri, name);
    } on BackupFolderException catch (e) {
      result = switch (e.error) {
        BackupFolderError.permissionDenied => AutoBackupResult.permissionDenied,
        BackupFolderError.folderMissing => AutoBackupResult.folderMissing,
        BackupFolderError.unavailable => AutoBackupResult.failed,
      };
    } catch (_) {
      result = AutoBackupResult.failed;
    }
    try {
      await secrets.write(lastAtKey, _writeTime(now));
      await secrets.write(lastResultKey, result.name);
      if (result == AutoBackupResult.ok && hash != null) {
        await secrets.write(lastHashKey, hash);
      }
    } catch (_) {
      // Could not record the result: accept it; the next run tries again.
    }
    return result;
  }

  /// Only runs AFTER the new file is written: always keeps [justWritten] plus
  /// `keepFiles - 1` newest remaining automatic files (sorted by name, which
  /// carries the date/time), deletes the rest. Does not assume [justWritten] is
  /// the newest by name (the phone clock may be behind). Clean-up errors never
  /// spoil a backup that was already written.
  Future<void> _prune(String uri, String justWritten) async {
    try {
      final others = [
        for (final n in await folder.listFiles(uri))
          if (fileNamePattern.hasMatch(n) && n != justWritten) n,
      ]..sort((a, b) => b.compareTo(a));
      for (final old in others.skip(keepFiles - 1)) {
        await folder.deleteFile(uri, old);
      }
    } catch (_) {}
  }
}
