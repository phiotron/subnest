import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../settings/auto_backup_providers.dart' show secretStoreProvider;
import 'pin_service.dart';

/// App lock (CONTEXT.md "App lock"): PIN service, "is it on?", and the lock state of the app.

final pinServiceProvider = Provider<PinService>(
  (ref) => PinService(ref.watch(secretStoreProvider), settings: () => ref.read(settingsRepositoryProvider)),
);

/// Whether App lock is on: the Settings switch and the home-screen widget (`appLockEnabledProvider`
/// in `widget_sync.dart`) follow it. Invalidate after turning the PIN on or off.
///
/// No secure storage at all (widget tests, desktop) means no PIN can have been set → off. Any
/// other error stays an error: the widget then shows only "Locked with PIN".
final pinEnabledProvider = FutureProvider<bool>((ref) async {
  try {
    return await ref.watch(pinServiceProvider).isEnabled();
  } on MissingPluginException {
    return false;
  }
});

enum AppLockState {
  /// Cold start, reading secure storage: nothing of the app is shown yet.
  checking,
  locked,
  unlocked,
}

/// Locks on a cold start and when the app comes back after MORE than [relockAfter] in the
/// background (AC-32). Unlocked by the right PIN, or after "Forgot PIN" deleted everything.
class LockNotifier extends Notifier<AppLockState> {
  static const relockAfter = Duration(minutes: 1);

  DateTime? _hiddenAt;

  @override
  AppLockState build() {
    unawaited(_init());
    return AppLockState.checking;
  }

  Future<void> _init() async {
    final pin = ref.read(pinServiceProvider);
    var maybeOn = true;
    try {
      maybeOn = await pin.hasInstallIdInDatabase();
    } catch (_) {
      // Database unreadable: ask secure storage below.
    }
    if (!maybeOn) {
      // No PIN was ever set with this database: open now. A Keychain PIN left from before an iOS
      // reinstall is dropped in the background (D-017); it can never lock this install.
      state = AppLockState.unlocked;
      unawaited(_dropStalePin(pin));
      return;
    }
    try {
      // Reinstalled on iOS: the Keychain still has the old PIN but the database is new (D-017).
      if (await pin.clearIfReinstalled()) ref.invalidate(pinEnabledProvider);
    } catch (_) {
      // Secure storage or database unreadable: delete nothing.
    }
    var enabled = true;
    try {
      enabled = await pin.isEnabled();
    } on MissingPluginException {
      enabled = false; // No secure storage (tests, desktop): no PIN can exist.
    } catch (_) {
      // Secure storage broken (Keystore error): stay locked so the user sees the lock screen and
      // its "Forgot PIN", not a blank app.
    }
    state = enabled ? AppLockState.locked : AppLockState.unlocked;
  }

  Future<void> _dropStalePin(PinService pin) async {
    try {
      if (await pin.clearIfReinstalled()) ref.invalidate(pinEnabledProvider);
    } catch (_) {
      // Secure storage unreadable: try again next start.
    }
  }

  /// The app went to the background (not just a notification shade over it).
  void onHidden() => _hiddenAt ??= ref.read(clockProvider)();

  /// Back from the background: lock again when it stayed away more than [relockAfter].
  Future<void> onResumed() async {
    final hiddenAt = _hiddenAt;
    _hiddenAt = null;
    if (state != AppLockState.unlocked || hiddenAt == null) return;
    if (ref.read(clockProvider)().difference(hiddenAt) <= relockAfter) return;
    var enabled = true;
    try {
      enabled = await ref.read(pinServiceProvider).isEnabled();
    } on MissingPluginException {
      enabled = false;
    } catch (_) {
      // Unreadable: lock (same reasoning as on a cold start).
    }
    if (enabled) state = AppLockState.locked;
  }

  /// Checks [pin]; unlocks and returns true when it is right.
  Future<bool> unlock(String pin) async {
    var ok = false;
    try {
      ok = await ref.read(pinServiceProvider).verify(pin);
    } catch (_) {
      // Secure storage error: stay locked.
    }
    if (ok) state = AppLockState.unlocked;
    return ok;
  }

  /// The user deleted all data because the PIN was forgotten (AC-34): the PIN is gone too.
  void unlockAfterReset() => state = AppLockState.unlocked;
}

final lockProvider = NotifierProvider<LockNotifier, AppLockState>(LockNotifier.new);
