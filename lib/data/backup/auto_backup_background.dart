import '../db/app_database.dart';
import '../rates/exchange_rate_repository.dart';
import '../secret_store.dart';
import '../settings_repository.dart';
import '../subscription_repository.dart';
import 'auto_backup_service.dart';
import 'backup_crypto.dart';
import 'backup_folder_service.dart';
import 'backup_service.dart';

/// One scheduled backup while the app is closed (Android): `BackupJobService.kt`
/// builds a headless FlutterEngine and runs `autoBackupBackgroundMain` in
/// `lib/main.dart`, which calls this.
///
/// Opens the database, reads the password from Keystore ([SecretStore]), encrypts
/// and writes through Storage Access Framework using the same [AutoBackupService]
/// as the app (once per slot, only when data changed, keeps 2 files, failures
/// also record `lastAt`). Kotlin schedules the next run as soon as the alarm
/// fires, so a Dart error or a killed process does not break the schedule.
///
/// Returns the attempt result (null: slot not due, already handled, disabled or
/// data unchanged). Never throws; always closes the database.
Future<AutoBackupResult?> runScheduledAutoBackup({
  required AppDatabase Function() openDatabase,
  SecretStore secrets = const SecureSecretStore(),
  BackupFolderService folder = const BackupFolderService(),
  DateTime Function() clock = DateTime.now,
  BackupEncryptor? encrypt,
}) async {
  AppDatabase? db;
  try {
    db = openDatabase();
    final settings = SettingsRepository(db);
    final backup = BackupService(
      db,
      SubscriptionRepository(db, clock: clock),
      settings,
      ExchangeRateRepository(db, settings, clock: clock),
      clock: clock,
    );
    final service = AutoBackupService(
      backup: backup,
      folder: folder,
      secrets: secrets,
      clock: clock,
      encrypt: encrypt ?? encryptBackupOffThread,
    );
    // Disabled: do not keep the database open longer than needed.
    if (!(await service.state()).enabled) return null;
    return await service.maybeRunIfDue();
  } catch (_) {
    return null;
  } finally {
    try {
      await db?.close();
    } catch (_) {}
  }
}
