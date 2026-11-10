import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';

/// Privacy screen (CONTEXT.md; A002 F-22 AC-56): hide the app in the app switcher and block
/// screenshots — Android `FLAG_SECURE`, iOS a cover view while the app is not active (iOS cannot
/// block screenshots). Independent of App lock, off by default.
///
/// The switch is a row of the `settings` table (key [privacyScreenKey]) but NOT one of
/// `SettingsRepository.backupKeys`: it belongs to this phone, a restore does not change it, and
/// "Delete all data" (which deletes every settings row) turns it off like a new install.
const privacyScreenKey = 'privacyScreen';

/// Native side over the `subnest/secure` channel (`MainActivity.kt`, `AppDelegate.swift`).
class SecureWindow {
  const SecureWindow([this.channel = const MethodChannel(channelName)]);

  static const channelName = 'subnest/secure';

  final MethodChannel channel;

  Future<void> setSecure(bool on) async {
    try {
      await channel.invokeMethod<void>('setSecure', on);
    } on MissingPluginException {
      // No native side (tests, desktop): nothing to do.
    } on PlatformException {
      // Refused: keep the previous state.
    }
  }
}

final secureWindowProvider = Provider<SecureWindow>((ref) => const SecureWindow());

/// Whether Privacy screen is on; follows the database (switch, restore, delete all).
final privacyScreenProvider = StreamProvider<bool>((ref) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.settings)..where((t) => t.key.equals(privacyScreenKey));
  return query.watchSingleOrNull().map((row) => row?.value == 'true');
});

Future<void> setPrivacyScreen(WidgetRef ref, bool on) =>
    ref.read(settingsRepositoryProvider).set(privacyScreenKey, on ? 'true' : null);

/// Pushes the saved value to the native side when the app opens and whenever it changes.
/// Watched once by the root widget.
final privacyScreenSyncProvider = Provider<void>((ref) {
  final window = ref.watch(secureWindowProvider);
  ref.listen<AsyncValue<bool>>(privacyScreenProvider, (_, next) {
    final on = next.value;
    if (on != null && !next.isLoading) unawaited(window.setSecure(on));
  }, fireImmediately: true);
});
