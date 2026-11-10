import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:subnest/data/backup/auto_backup_service.dart';
import 'package:subnest/data/backup/backup_crypto.dart';
import 'package:subnest/data/backup/backup_folder_service.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/rates/exchange_rate_repository.dart';
import 'package:subnest/data/secret_store.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';

/// In-memory folder standing in for the Storage Access Framework / Files-app channel.
class FakeFolder implements BackupFolderService {
  final files = <String, Uint8List>{};
  final released = <String>[];
  int writes = 0;
  BackupFolderError? failWith;
  PickedFolder? pickResult;

  @override
  MethodChannel get channel => throw UnimplementedError();

  void _check() {
    final e = failWith;
    if (e != null) throw BackupFolderException(e);
  }

  @override
  Future<PickedFolder?> pickFolder() async {
    _check();
    return pickResult;
  }

  @override
  Future<void> writeFile(String treeUri, String name, Uint8List bytes) async {
    _check();
    writes++;
    files[name] = bytes;
  }

  @override
  Future<List<String>> listFiles(String treeUri) async {
    _check();
    return files.keys.toList();
  }

  @override
  Future<void> deleteFile(String treeUri, String name) async {
    _check();
    files.remove(name);
  }

  @override
  Future<void> releaseFolder(String treeUri) async => released.add(treeUri);
}

/// Low work factor so tests stay fast; the real default runs in one dedicated test.
Future<String> encryptFast(String json, String password) => encryptBackup(json, password, iterations: 1000);

/// One in-memory database with the repositories a backup needs, all on the same [clock].
class BackupWorld {
  BackupWorld({required this.clock}) : db = _openDb() {
    settings = SettingsRepository(db);
    subs = SubscriptionRepository(db, clock: clock);
    backup = BackupService(db, subs, settings, ExchangeRateRepository(db, settings, clock: clock), clock: clock);
  }

  static AppDatabase _openDb() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    return AppDatabase(NativeDatabase.memory());
  }

  final AppDatabase db;
  final DateTime Function() clock;
  late final SettingsRepository settings;
  late final SubscriptionRepository subs;
  late final BackupService backup;

  AutoBackupService autoBackup({
    required BackupFolderService folder,
    required SecretStore secrets,
    BackupEncryptor encrypt = encryptFast,
  }) => AutoBackupService(backup: backup, folder: folder, secrets: secrets, clock: clock, encrypt: encrypt);

  Future<void> addSub(String id, {String name = 'Netflix', int price = 1599, String currency = 'USD'}) =>
      subs.save(sampleSub(id, name: name, price: price, currency: currency));

  Future<void> close() => db.close();
}

Subscription sampleSub(String id, {String name = 'Netflix', int price = 1599, String currency = 'USD'}) =>
    Subscription(
      id: id,
      name: name,
      priceMinor: price,
      currency: currency,
      cycle: const BillingCycle.monthly(),
      anchorDate: const LocalDate(2026, 11, 20),
      startDate: const LocalDate(2026, 1, 1),
      createdAt: DateTime(2026, 11, 1, 9),
      updatedAt: DateTime(2026, 11, 1, 9),
    );
