import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/auto_backup_service.dart';
import 'package:subnest/data/backup/backup_crypto.dart';
import 'package:subnest/data/backup/backup_folder_service.dart';
import 'package:subnest/data/secret_store.dart';

import 'backup_test_utils.dart';

/// Automatic backup into a picked folder (A002 F-24, AC-58..60, D-026, D-027).
void main() {
  late BackupWorld w;
  late FakeFolder folder;
  late MemorySecretStore secrets;
  late DateTime now;
  late AutoBackupService service;
  const tree = 'content://tree/Subnest';
  const password = 'secret-password-123';

  Future<void> enable() =>
      service.enable(folder: const PickedFolder(uri: tree, name: 'Subnest'), password: password);

  List<String> autoFiles() => folder.files.keys.where(AutoBackupService.fileNamePattern.hasMatch).toList()..sort();

  setUp(() {
    now = DateTime(2026, 11, 3, 18, 30);
    w = BackupWorld(clock: () => now);
    folder = FakeFolder();
    secrets = MemorySecretStore();
    service = w.autoBackup(folder: folder, secrets: secrets);
  });
  tearDown(() => w.close());

  test('right name, encrypted file, opens with the password and restores elsewhere', () async {
    await w.addSub('netflix', name: 'Netflix Premium', price: 2299);
    await enable();
    expect(await service.backupNow(), AutoBackupResult.ok);

    expect(folder.files.keys, ['subnest-auto-20261103-1830.subnest']);
    final text = utf8.decode(folder.files.values.single);
    expect(isEncryptedBackup(text), isTrue);
    expect(text, isNot(contains('Netflix')));
    expect(text, isNot(contains('2299')));
    expect(text, isNot(contains(password)));

    final json = await decryptBackup(text, password);
    await expectLater(decryptBackup(text, 'wrong-password'), throwsA(isA<BackupPasswordException>()));

    final other = BackupWorld(clock: () => now);
    addTearDown(other.close);
    final r = await other.backup.importJson(json);
    expect(r.subscriptions, 1);
    expect((await other.subs.get('netflix'))!.name, 'Netflix Premium');
  });

  test('default encryption (isolate, 100,000 rounds) works too', () async {
    service = w.autoBackup(folder: folder, secrets: secrets, encrypt: encryptBackupOffThread);
    await enable();
    expect(await service.backupNow(), AutoBackupResult.ok);
    final text = utf8.decode(folder.files.values.single);
    expect((jsonDecode(text) as Map)['iterations'], backupKdfIterations);
    w.backup.parse(await decryptBackup(text, password));
  });

  test('the password only lives in secure storage: not in settings, not in any file', () async {
    await w.addSub('a');
    await enable();
    await service.backupNow();
    expect(secrets.values[AutoBackupService.passwordKey], password);
    for (final s in await w.db.select(w.db.settings).get()) {
      expect(s.key.contains('auto_backup'), isFalse);
      expect(s.value.contains(password), isFalse);
    }
    for (final bytes in folder.files.values) {
      expect(utf8.decode(bytes).contains(password), isFalse);
    }
    expect(await w.backup.exportJsonText(), isNot(contains(password)));
  });

  test('a failed write never deletes the older files', () async {
    await enable();
    for (var day = 1; day <= 2; day++) {
      now = DateTime(2026, 10, day, 8, 5);
      expect(await service.backupNow(), AutoBackupResult.ok);
    }
    final before = folder.files.keys.toSet();
    expect(before, hasLength(2));
    now = DateTime(2026, 10, 3, 8, 5);
    folder.failWith = BackupFolderError.permissionDenied;
    expect(await service.backupNow(), AutoBackupResult.permissionDenied);
    folder.failWith = null;
    expect(folder.files.keys.toSet(), before);
  });

  test('keeps the 2 newest automatic files and never touches other files', () async {
    final others = [
      'notes.txt',
      'subnest-20261101-0900.subnest',
      'subnest-auto-20261101-1000 (1).subnest',
      'subnest-auto-latest.subnest',
      'subnest-auto-20261031-0900.subnest.bak',
    ];
    for (final n in others) {
      folder.files[n] = Uint8List.fromList([1]);
    }
    await enable();
    for (var day = 1; day <= 10; day++) {
      now = DateTime(2026, 10, day, 8, 5);
      await service.backupNow();
    }
    expect(autoFiles(), ['subnest-auto-20261009-0805.subnest', 'subnest-auto-20261010-0805.subnest']);
    for (final n in others) {
      expect(folder.files.containsKey(n), isTrue, reason: '$n was deleted');
    }
  });

  test('clock set back: still exactly 2 files, including the one just written', () async {
    await enable();
    for (var day = 5; day <= 7; day++) {
      now = DateTime(2026, 10, day, 8, 5);
      await service.backupNow();
    }
    now = DateTime(2026, 10, 1, 8, 5);
    expect(await service.backupNow(), AutoBackupResult.ok);
    expect(autoFiles(), ['subnest-auto-20261001-0805.subnest', 'subnest-auto-20261007-0805.subnest']);
  });

  test('at most once per slot, and only when the data changed', () async {
    await enable(); // 18:30, default time 21:00
    await service.maybeRunDaily();
    expect(folder.writes, 1, reason: 'never backed up: runs');

    await w.addSub('b');
    now = DateTime(2026, 11, 3, 20, 59);
    await service.maybeRunDaily();
    expect(folder.writes, 1, reason: 'before 21:00');

    now = DateTime(2026, 11, 3, 21, 5);
    await service.maybeRunDaily();
    expect(folder.writes, 2, reason: 'after 21:00, data changed');

    await w.addSub('c');
    now = DateTime(2026, 11, 3, 23);
    await service.maybeRunDaily();
    expect(folder.writes, 2, reason: 'same slot');

    now = DateTime(2026, 11, 4, 21, 10);
    await service.maybeRunDaily();
    expect(folder.writes, 3, reason: 'next slot');

    now = DateTime(2026, 11, 5, 21, 10);
    await service.maybeRunDaily();
    expect(folder.writes, 3, reason: 'data unchanged: no file');
    expect(secrets.values[AutoBackupService.lastCheckKey], isNotNull);
    await w.addSub('d');
    now = DateTime(2026, 11, 5, 22);
    await service.maybeRunDaily();
    expect(folder.writes, 3, reason: 'that slot was handled by the unchanged check');

    now = DateTime(2026, 11, 6, 21);
    await service.maybeRunDaily();
    expect(folder.writes, 4);
  });

  test('off: never runs in the background', () async {
    await w.addSub('a');
    await service.maybeRunDaily();
    expect(folder.files, isEmpty);
    expect((await service.state()).enabled, isFalse);
  });

  test('"Back up now" runs even when the data did not change', () async {
    await enable();
    await service.maybeRunDaily();
    now = DateTime(2026, 11, 3, 19);
    expect(await service.backupNow(), AutoBackupResult.ok);
    expect(folder.files, hasLength(2));
    final s = await service.state();
    expect(s.lastAt, now);
    expect(s.lastResult, AutoBackupResult.ok);
    expect(s.lastFailed, isFalse);
    expect(s.folderName, 'Subnest');
  });

  test('permission revoked or folder gone: recorded, never thrown; choose again fixes it', () async {
    await enable();
    await service.backupNow();

    folder.failWith = BackupFolderError.permissionDenied;
    now = DateTime(2026, 11, 4, 9);
    await w.addSub('x');
    await service.maybeRunDaily();
    var s = await service.state();
    expect(s.lastResult, AutoBackupResult.permissionDenied);
    expect(s.lastFailed, isTrue);
    expect(s.enabled, isTrue, reason: 'stays on, waiting for the user to choose the folder again');

    folder.failWith = BackupFolderError.folderMissing;
    expect(await service.backupNow(), AutoBackupResult.folderMissing);
    folder.failWith = BackupFolderError.unavailable;
    expect(await service.backupNow(), AutoBackupResult.failed);

    folder.failWith = null;
    await service.changeFolder(const PickedFolder(uri: 'content://tree/New', name: 'New'));
    expect(folder.released, [tree]);
    expect(await service.backupNow(), AutoBackupResult.ok);
    s = await service.state();
    expect(s.folderUri, 'content://tree/New');
    expect(s.folderName, 'New');
    expect(s.lastFailed, isFalse);
  });

  test('failed today: tries again at the next slot even if the data did not change', () async {
    await enable();
    folder.failWith = BackupFolderError.permissionDenied;
    await service.maybeRunDaily();
    expect(folder.files, isEmpty);
    folder.failWith = null;
    now = DateTime(2026, 11, 3, 20);
    await service.maybeRunDaily();
    expect(folder.files, isEmpty, reason: 'same slot: no retry yet');
    now = DateTime(2026, 11, 4, 21);
    await service.maybeRunDaily();
    expect(folder.files, hasLength(1));
  });

  test('an encryption error or unexpected exception never throws', () async {
    service = w.autoBackup(folder: folder, secrets: secrets, encrypt: (_, _) async => throw StateError('broken'));
    await enable();
    expect(await service.backupNow(), AutoBackupResult.failed);
    expect(folder.files, isEmpty);
    await service.maybeRunDaily();
  });

  test('a second run while one is in progress is "busy" and keeps the earlier result', () async {
    await enable();
    final first = service.backupNow();
    expect(await service.backupNow(), AutoBackupResult.busy);
    expect(await first, AutoBackupResult.ok);
    expect((await service.state()).lastResult, AutoBackupResult.ok);
  });

  test('turning it off forgets the password and folder, keeps the files', () async {
    await enable();
    await service.backupNow();
    await service.disable();
    expect(secrets.values, isEmpty);
    expect(folder.released, [tree]);
    expect(folder.files, hasLength(1), reason: 'files already written stay');
    final s = await service.state();
    expect(s.enabled, isFalse);
    expect(s.folderUri, isNull);
    now = DateTime(2026, 11, 9, 9);
    await w.addSub('late');
    await service.maybeRunDaily();
    expect(folder.files, hasLength(1));
  });

  test('no password: writes nothing, never a plain file', () async {
    await enable();
    secrets.values.remove(AutoBackupService.passwordKey);
    expect(await service.backupNow(), AutoBackupResult.notConfigured);
    expect(folder.files, isEmpty);
  });

  test('the native channel maps error codes to BackupFolderError', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    const channel = MethodChannel('test/backup_folder');
    String? code;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'pickFolder') return {'uri': 'content://x', 'name': 'X', 'inICloud': true};
      if (code == null) throw MissingPluginException();
      throw PlatformException(code: code);
    });
    addTearDown(
      () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null),
    );
    const svc = BackupFolderService(channel);
    final picked = await svc.pickFolder();
    expect(picked?.uri, 'content://x');
    expect(picked?.name, 'X');
    expect(picked?.inICloud, isTrue);

    Future<BackupFolderError> errorOf() async {
      try {
        await svc.listFiles('content://x');
      } on BackupFolderException catch (e) {
        return e.error;
      }
      fail('must throw');
    }

    expect(await errorOf(), BackupFolderError.unavailable);
    code = 'permission_denied';
    expect(await errorOf(), BackupFolderError.permissionDenied);
    code = 'folder_missing';
    expect(await errorOf(), BackupFolderError.folderMissing);
    code = 'io_error';
    expect(await errorOf(), BackupFolderError.unavailable);
  });
}
