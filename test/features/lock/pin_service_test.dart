import 'dart:math';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/rates/exchange_rate_repository.dart';
import 'package:subnest/data/secret_store.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/features/lock/pin_service.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late SettingsRepository settings;
  late MemorySecretStore secrets;

  PinService service({SettingsRepository? repo, Random? random}) =>
      PinService(secrets, settings: () => repo ?? settings, random: random, iterations: 50);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    settings = SettingsRepository(db);
    secrets = MemorySecretStore();
  });

  tearDown(() => db.close());

  test('off until a PIN is set; the right PIN matches, others do not', () async {
    final pin = service();
    expect(await pin.isEnabled(), isFalse);
    expect(await pin.verify('1234'), isFalse, reason: 'no PIN → nothing matches');

    await pin.setPin('1234');
    expect(await pin.isEnabled(), isTrue);
    expect(await pin.verify('1234'), isTrue);
    for (final wrong in ['1235', '4321', '0000', '123', '12345', '']) {
      expect(await pin.verify(wrong), isFalse, reason: wrong);
    }
  });

  test('only 4 digits are accepted', () async {
    final pin = service();
    for (final bad in ['123', '12345', 'abcd', '12a4', ' 1234', '١٢٣٤']) {
      expect(() => pin.setPin(bad), throwsArgumentError, reason: bad);
    }
    expect(await pin.isEnabled(), isFalse);
  });

  test('stores a salted hash in secure storage only — never the PIN, never the database', () async {
    final pin = service();
    await pin.setPin('2468');
    expect(secrets.values.keys, unorderedEquals([PinService.hashKey, PinService.saltKey, PinService.installKey]));
    expect(secrets.values.values.any((v) => v.contains('2468')), isFalse);
    final raw = await settings.raw();
    expect(raw.keys, [PinService.settingsInstallKey], reason: 'the database only gets the install id');
    expect(raw.values.single, secrets.values[PinService.installKey]);
    expect(raw.values.single.contains('2468'), isFalse);

    // Same PIN again → a new salt → a different hash.
    final firstHash = secrets.values[PinService.hashKey];
    await pin.setPin('2468');
    expect(secrets.values[PinService.hashKey], isNot(firstHash));
    expect(await pin.verify('2468'), isTrue);
  });

  test('hash is deterministic for a salt and depends on salt and PIN', () {
    final a = PinService.hashPin('1234', 'salt', iterations: 10);
    expect(PinService.hashPin('1234', 'salt', iterations: 10), a);
    expect(PinService.hashPin('1235', 'salt', iterations: 10), isNot(a));
    expect(PinService.hashPin('1234', 'salu', iterations: 10), isNot(a));
    expect(PinService.hashPin('1234', 'salt', iterations: 11), isNot(a));
  });

  test('disable removes everything from secure storage', () async {
    final pin = service();
    await pin.setPin('1234');
    await pin.disable();
    expect(secrets.values, isEmpty);
    expect(await pin.isEnabled(), isFalse);
    expect(await pin.verify('1234'), isFalse);
  });

  test('changing the PIN keeps the install id (a half-written Keychain is not wiped next start)', () async {
    final pin = service();
    await pin.setPin('1234');
    final id = (await settings.raw())[PinService.settingsInstallKey];
    await pin.setPin('5678');
    expect((await settings.raw())[PinService.settingsInstallKey], id);
    expect(secrets.values[PinService.installKey], id);
    expect(await pin.verify('5678'), isTrue);
    expect(await pin.verify('1234'), isFalse);
  });

  group('reinstall (D-017)', () {
    test('Keychain PIN with a NEW database: off at once, dropped on start', () async {
      await service().setPin('1234');
      // Delete + reinstall on iOS: the Keychain survives, the database does not.
      final freshDb = AppDatabase(NativeDatabase.memory());
      addTearDown(freshDb.close);
      final fresh = service(repo: SettingsRepository(freshDb));
      expect(await fresh.hasInstallIdInDatabase(), isFalse);
      expect(await fresh.isEnabled(), isFalse, reason: 'the old PIN never counts for this install');
      expect(await fresh.clearIfReinstalled(), isTrue);
      expect(secrets.values, isEmpty);
    });

    test('same database: the PIN is kept', () async {
      final pin = service();
      await pin.setPin('1234');
      expect(await pin.clearIfReinstalled(), isFalse);
      expect(await pin.isEnabled(), isTrue);
    });

    test('database restored with ANOTHER install id: the old PIN is dropped', () async {
      final pin = service();
      await pin.setPin('1234');
      await settings.set(PinService.settingsInstallKey, 'other-phone');
      expect(await pin.clearIfReinstalled(), isTrue);
      expect(await pin.isEnabled(), isFalse);
    });

    test('nothing in secure storage: nothing to drop', () async {
      expect(await service().clearIfReinstalled(), isFalse);
    });
  });

  test('the install id is not in a backup file, and a restore keeps this phone\'s id', () async {
    final pin = service();
    await pin.setPin('1234');
    final id = (await settings.raw())[PinService.settingsInstallKey];
    expect(SettingsRepository.backupKeys, isNot(contains(PinService.settingsInstallKey)));
    final backup = BackupService(db, SubscriptionRepository(db), settings, ExchangeRateRepository(db, settings));
    final text = await backup.exportJsonText();
    expect(text.contains(PinService.settingsInstallKey), isFalse);
    expect(text.contains(id!), isFalse);
    await backup.importJson(text);
    expect((await settings.raw())[PinService.settingsInstallKey], id);
    expect(await pin.isEnabled(), isTrue);
  });
}
