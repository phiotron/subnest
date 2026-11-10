import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/auto_backup_service.dart';
import 'package:subnest/data/backup/backup_crypto.dart';
import 'package:subnest/data/backup/backup_folder_service.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/secret_store.dart';
import 'package:subnest/data/settings_repository.dart';

import 'backup_test_utils.dart';

/// Restore always REPLACES (no merge) and "Delete all data" returns to a new install.
void main() {
  final now = DateTime(2026, 11, 10, 9);
  late BackupWorld source;
  late BackupWorld target;

  setUp(() async {
    source = BackupWorld(clock: () => now);
    target = BackupWorld(clock: () => now);
    await source.addSub('netflix', name: 'Netflix', price: 1599);
    await source.addSub('spotify', name: 'Spotify', price: 1199);
    await source.settings.setPrimaryCurrency('EUR');
    await source.settings.set(SettingsRepository.kLocale, 'vi');
    await source.settings.set(SettingsRepository.kThemeMode, 'dark');
  });
  tearDown(() async {
    await source.close();
    await target.close();
  });

  test('an encrypted automatic file replaces all data and the settings in it', () async {
    // The phone being restored has its own data and settings.
    await target.addSub('local-only', name: 'Local only');
    await target.settings.setPrimaryCurrency('VND');
    await target.settings.set(SettingsRepository.kHomeSort, 'price');
    await target.settings.setOnboardingDone(true);
    final lastBackup = DateTime(2026, 11, 1, 20);
    await target.settings.setLastBackupAt(lastBackup);

    // Its automatic backup configuration (secure storage) must survive the restore.
    final secrets = MemorySecretStore();
    final auto = target.autoBackup(folder: FakeFolder(), secrets: secrets);
    await auto.enable(folder: const PickedFolder(uri: 'content://tree/t', name: 'T'), password: 'target-pass');

    final folder = FakeFolder();
    final sourceAuto = source.autoBackup(folder: folder, secrets: MemorySecretStore());
    await sourceAuto.enable(folder: const PickedFolder(uri: 'content://tree/s'), password: 'source-pass');
    expect(await sourceAuto.backupNow(), AutoBackupResult.ok);
    final envelope = String.fromCharCodes(folder.files.values.single);
    expect(isEncryptedBackup(envelope), isTrue);

    final plain = await decryptBackup(envelope, 'source-pass');
    final r = await target.backup.importJson(plain);

    expect(r.subscriptions, 2);
    expect((await target.subs.all()).map((s) => s.id).toSet(), {'netflix', 'spotify'});
    final settings = await target.settings.load();
    expect(settings.primaryCurrency, 'EUR');
    expect(settings.localeCode, 'vi');
    expect(settings.themeMode, AppThemeMode.dark);
    expect(settings.homeSort, isNull, reason: 'a backed-up setting absent from the file goes back to its default');
    expect(settings.onboardingDone, isTrue, reason: 'device state stays');
    expect(settings.lastBackupAt, lastBackup);
    final state = await auto.state();
    expect(state.enabled, isTrue);
    expect(state.folderUri, 'content://tree/t');
    expect(secrets.values[AutoBackupService.passwordKey], 'target-pass');
  });

  test('a corrupted file changes nothing', () async {
    await target.addSub('keep', name: 'Keep me');
    final json = await source.backup.exportJsonText();
    final broken = json.replaceFirst('"name": "Spotify"', '"name": 42');
    expect(() => target.backup.parse(broken), throwsA(isA<BackupFormatException>()));
    await expectLater(target.backup.importJson(broken), throwsA(isA<BackupFormatException>()));
    expect((await target.subs.all()).single.id, 'keep');
  });

  test('wipeEverything = a new install: no data, no settings, built-in categories back', () async {
    await source.settings.setOnboardingDone(true);
    await source.settings.setLastBackupAt(now);
    await source.settings.setRatesFetchedAt(now);
    final builtIn = (await target.db.select(target.db.categories).get()).length;

    await source.db.wipeEverything();

    expect(await source.subs.all(), isEmpty);
    final settings = await source.settings.load();
    expect(settings.onboardingDone, isFalse);
    expect(settings.localeCode, isNull, reason: 'null = English for a new install');
    expect(settings.primaryCurrency, 'USD');
    expect(settings.themeMode, AppThemeMode.system);
    expect(settings.lastBackupAt, isNull);
    expect(settings.ratesFetchedAt, now, reason: 'the rates cache is not user data');
    expect(await source.db.select(source.db.categories).get(), hasLength(builtIn));
  });
}
