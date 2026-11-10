import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/data/secret_store.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/features/lock/app_lock.dart';
import 'package:subnest/features/lock/pin_service.dart';
import 'package:subnest/features/settings/auto_backup_providers.dart';
import 'package:subnest/features/widget_sync/widget_sync.dart';

/// Secure storage that fails like a broken Keystore, or like a platform without the plugin.
class FailingSecretStore implements SecretStore {
  FailingSecretStore(this.error);

  final Object error;

  @override
  Future<String?> read(String key) async => throw error;

  @override
  Future<void> write(String key, String value) async => throw error;

  @override
  Future<void> delete(String key) async => throw error;
}

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late MemorySecretStore secrets;
  late DateTime now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    secrets = MemorySecretStore();
    now = DateTime(2026, 11, 10, 9);
  });

  tearDown(() => db.close());

  ProviderContainer container({SecretStore? store}) {
    final c = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        secretStoreProvider.overrideWithValue(store ?? secrets),
        pinServiceProvider.overrideWith(
          (ref) => PinService(
            ref.watch(secretStoreProvider),
            settings: () => ref.read(settingsRepositoryProvider),
            iterations: 50,
          ),
        ),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<void> setPin(String pin) => PinService(secrets, settings: () => SettingsRepository(db), iterations: 50).setPin(pin);

  /// Lets the cold-start check finish.
  Future<AppLockState> started(ProviderContainer c) async {
    c.listen(lockProvider, (_, _) {});
    for (var i = 0; i < 20 && c.read(lockProvider) == AppLockState.checking; i++) {
      await Future<void>.delayed(Duration.zero);
    }
    return c.read(lockProvider);
  }

  group('cold start', () {
    test('no PIN → unlocked', () async {
      final c = container();
      expect(c.read(lockProvider), AppLockState.checking, reason: 'nothing shown before the check');
      expect(await started(c), AppLockState.unlocked);
    });

    test('PIN set → locked; wrong PIN stays locked; right PIN unlocks', () async {
      await setPin('1234');
      final c = container();
      expect(await started(c), AppLockState.locked);
      expect(await c.read(lockProvider.notifier).unlock('0000'), isFalse);
      expect(c.read(lockProvider), AppLockState.locked);
      expect(await c.read(lockProvider.notifier).unlock('1234'), isTrue);
      expect(c.read(lockProvider), AppLockState.unlocked);
    });

    test('Keychain PIN from before an iOS reinstall (new database) → unlocked and the old PIN dropped', () async {
      await setPin('1234');
      await SettingsRepository(db).set(PinService.settingsInstallKey, null); // the new database
      final c = container();
      expect(await started(c), AppLockState.unlocked);
      await Future<void>.delayed(Duration.zero);
      expect(secrets.values, isEmpty);
      expect(await c.read(pinEnabledProvider.future), isFalse);
    });

    test('broken secure storage with a PIN set → locked (lock screen + Forgot PIN, not a blank app)', () async {
      await setPin('1234');
      final c = container(store: FailingSecretStore(PlatformException(code: 'keystore')));
      expect(await started(c), AppLockState.locked);
      expect(await c.read(lockProvider.notifier).unlock('1234'), isFalse);
    });

    test('no secure-storage plugin (desktop, tests) → unlocked, switch off', () async {
      await SettingsRepository(db).set(PinService.settingsInstallKey, 'x');
      final c = container(store: FailingSecretStore(MissingPluginException()));
      expect(await started(c), AppLockState.unlocked);
      expect(await c.read(pinEnabledProvider.future), isFalse);
    });
  });

  group('back from the background (AC-32)', () {
    Future<ProviderContainer> unlocked() async {
      await setPin('1234');
      final c = container();
      await started(c);
      await c.read(lockProvider.notifier).unlock('1234');
      return c;
    }

    test('exactly 1 minute away → still unlocked', () async {
      final c = await unlocked();
      c.read(lockProvider.notifier).onHidden();
      now = now.add(const Duration(minutes: 1));
      await c.read(lockProvider.notifier).onResumed();
      expect(c.read(lockProvider), AppLockState.unlocked);
    });

    test('more than 1 minute away → locked', () async {
      final c = await unlocked();
      c.read(lockProvider.notifier).onHidden();
      now = now.add(const Duration(minutes: 1, seconds: 1));
      await c.read(lockProvider.notifier).onResumed();
      expect(c.read(lockProvider), AppLockState.locked);
    });

    test('the time counts from the FIRST hide (several hide events do not restart it)', () async {
      final c = await unlocked();
      c.read(lockProvider.notifier).onHidden();
      now = now.add(const Duration(seconds: 50));
      c.read(lockProvider.notifier).onHidden();
      now = now.add(const Duration(seconds: 50));
      await c.read(lockProvider.notifier).onResumed();
      expect(c.read(lockProvider), AppLockState.locked);
    });

    test('resume without a hide (notification shade) → nothing happens', () async {
      final c = await unlocked();
      now = now.add(const Duration(hours: 1));
      await c.read(lockProvider.notifier).onResumed();
      expect(c.read(lockProvider), AppLockState.unlocked);
    });

    test('PIN turned off meanwhile → no lock', () async {
      final c = await unlocked();
      c.read(lockProvider.notifier).onHidden();
      await c.read(pinServiceProvider).disable();
      now = now.add(const Duration(minutes: 5));
      await c.read(lockProvider.notifier).onResumed();
      expect(c.read(lockProvider), AppLockState.unlocked);
    });

    test('no PIN → never locks', () async {
      final c = container();
      await started(c);
      c.read(lockProvider.notifier).onHidden();
      now = now.add(const Duration(minutes: 5));
      await c.read(lockProvider.notifier).onResumed();
      expect(c.read(lockProvider), AppLockState.unlocked);
    });
  });

  test('pinEnabledProvider follows the PIN once invalidated', () async {
    final c = container();
    expect(await c.read(pinEnabledProvider.future), isFalse);
    await c.read(pinServiceProvider).setPin('1234');
    c.invalidate(pinEnabledProvider);
    expect(await c.read(pinEnabledProvider.future), isTrue);
    await c.read(pinServiceProvider).disable();
    c.invalidate(pinEnabledProvider);
    expect(await c.read(pinEnabledProvider.future), isFalse);
  });

  test('the home-screen widget lock flag follows the PIN (on → only "Locked with PIN")', () async {
    final c = container();
    c.listen(appLockEnabledProvider, (_, _) {});
    await c.read(pinEnabledProvider.future);
    expect(c.read(appLockEnabledProvider).value, isFalse);
    await c.read(pinServiceProvider).setPin('1234');
    c.invalidate(pinEnabledProvider);
    expect(c.read(appLockEnabledProvider).isLoading, isTrue, reason: 'loading counts as locked for the widget');
    await c.read(pinEnabledProvider.future);
    expect(c.read(appLockEnabledProvider).value, isTrue);
    await c.read(pinServiceProvider).disable();
    c.invalidate(pinEnabledProvider);
    await c.read(pinEnabledProvider.future);
    expect(c.read(appLockEnabledProvider).value, isFalse);
  });

  test('unlockAfterReset opens the app (Forgot PIN → everything deleted)', () async {
    await setPin('1234');
    final c = container();
    expect(await started(c), AppLockState.locked);
    c.read(lockProvider.notifier).unlockAfterReset();
    expect(c.read(lockProvider), AppLockState.unlocked);
  });
}
