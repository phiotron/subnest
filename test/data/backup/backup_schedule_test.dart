// Backup time in the phone's local time (A002 D-026): the "Next" slot, catch-up after a missed
// slot, never twice for one slot; time-zone changes and daylight saving.
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/auto_backup_background.dart';
import 'package:subnest/data/backup/auto_backup_service.dart';
import 'package:subnest/data/backup/backup_folder_service.dart';
import 'package:subnest/data/backup/backup_schedule.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/secret_store.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'backup_test_utils.dart';

const nine = BackupTime(21, 0);

void main() {
  tzdata.initializeTimeZones();

  LocalDateTimeBuilder inZone(tz.Location loc) => (y, mo, d, h, mi) => tz.TZDateTime(loc, y, mo, d, h, mi);

  group('BackupTime', () {
    test('21:00 by default; stored as HH:MM', () {
      expect(BackupTime.defaultTime, nine);
      expect(const BackupTime(7, 5).encode(), '07:05');
      expect(BackupTime.parse('07:05'), const BackupTime(7, 5));
      expect(BackupTime.parse('23:59'), const BackupTime(23, 59));
      for (final bad in [null, '', '24:00', '12:60', 'ab:cd', '7:5', '1200']) {
        expect(BackupTime.parse(bad), isNull, reason: '$bad');
      }
    });
  });

  group('next slot (local time)', () {
    test('before the time: today; at or after it: tomorrow', () {
      expect(nextSlot(DateTime(2026, 11, 6, 20, 59), nine), DateTime(2026, 11, 6, 21));
      expect(nextSlot(DateTime(2026, 11, 6, 21), nine), DateTime(2026, 11, 7, 21));
      expect(nextSlot(DateTime(2026, 11, 6, 23), nine), DateTime(2026, 11, 7, 21));
      expect(isToday(DateTime(2026, 11, 6, 8), DateTime(2026, 11, 6, 21)), isTrue);
      expect(isToday(DateTime(2026, 11, 6, 22), DateTime(2026, 11, 7, 21)), isFalse);
    });

    test('across midnight, month end, year end', () {
      const early = BackupTime(0, 15);
      expect(nextSlot(DateTime(2026, 11, 30, 23, 30), early), DateTime(2026, 12, 1, 0, 15));
      expect(nextSlot(DateTime(2026, 12, 31, 0, 20), early), DateTime(2027, 1, 1, 0, 15));
      expect(lastSlot(DateTime(2027, 1, 1, 0, 10), early), DateTime(2026, 12, 31, 0, 15));
      expect(lastSlot(DateTime(2026, 3, 1, 8), nine), DateTime(2026, 2, 28, 21));
    });
  });

  group('catch-up', () {
    test('never backed up: due now', () {
      expect(isBackupDue(now: DateTime(2026, 11, 6, 8), time: nine), isTrue);
    });

    test('before the time, yesterday handled: not due', () {
      expect(
        isBackupDue(now: DateTime(2026, 11, 6, 20, 59), time: nine, handledAt: DateTime(2026, 11, 5, 21, 4)),
        isFalse,
      );
    });

    test('after the time, today not handled: due (catch-up)', () {
      expect(
        isBackupDue(now: DateTime(2026, 11, 6, 21), time: nine, handledAt: DateTime(2026, 11, 5, 21, 4)),
        isTrue,
      );
    });

    test('one slot is handled once', () {
      for (final later in [
        DateTime(2026, 11, 6, 21, 30),
        DateTime(2026, 11, 7, 8),
        DateTime(2026, 11, 7, 20, 59),
      ]) {
        expect(
          isBackupDue(now: later, time: nine, handledAt: DateTime(2026, 11, 6, 21, 2)),
          isFalse,
          reason: '$later',
        );
      }
    });

    test('phone off for days: one catch-up when it opens, then the next slot', () {
      final open = DateTime(2026, 11, 5, 9);
      expect(isBackupDue(now: open, time: nine, handledAt: DateTime(2026, 11, 1, 21, 3)), isTrue);
      expect(isBackupDue(now: DateTime(2026, 11, 5, 12), time: nine, handledAt: open), isFalse);
      expect(isBackupDue(now: DateTime(2026, 11, 5, 21), time: nine, handledAt: open), isTrue);
    });

    test('a manual backup before the time does not replace the scheduled one', () {
      expect(
        isBackupDue(now: DateTime(2026, 11, 6, 21, 1), time: nine, handledAt: DateTime(2026, 11, 6, 20)),
        isTrue,
      );
    });
  });

  group('time zones', () {
    final hcm = tz.getLocation('Asia/Ho_Chi_Minh');
    final tokyo = tz.getLocation('Asia/Tokyo');
    final london = tz.getLocation('Europe/London');

    test('after a time-zone change the time follows the new local time', () {
      final instant = DateTime.utc(2026, 11, 6, 13, 30); // 20:30 Hanoi = 22:30 Tokyo
      expect(
        nextSlot(tz.TZDateTime.from(instant, hcm), nine, at: inZone(hcm)).toUtc(),
        DateTime.utc(2026, 11, 6, 14),
      );
      expect(
        nextSlot(tz.TZDateTime.from(instant, tokyo), nine, at: inZone(tokyo)).toUtc(),
        DateTime.utc(2026, 11, 7, 12),
      );
    });

    test('flying east after the backup does not run it twice', () {
      final handled = DateTime.utc(2026, 11, 6, 14, 5); // 21:05 Hanoi
      expect(
        isBackupDue(now: tz.TZDateTime(tokyo, 2026, 11, 6, 23, 30), time: nine, handledAt: handled, at: inZone(tokyo)),
        isFalse,
      );
      expect(
        isBackupDue(now: tz.TZDateTime(tokyo, 2026, 11, 7, 21, 1), time: nine, handledAt: handled, at: inZone(tokyo)),
        isTrue,
      );
    });

    test('daylight saving: no lost slot, no double run', () {
      const t = BackupTime(1, 30);
      final springBefore = tz.TZDateTime(london, 2026, 3, 28, 23);
      final spring = nextSlot(springBefore, t, at: inZone(london));
      expect(spring.isAfter(springBefore), isTrue);
      expect(spring.difference(springBefore), lessThanOrEqualTo(const Duration(hours: 4)));
      final fall = nextSlot(tz.TZDateTime(london, 2026, 10, 24, 23), t, at: inZone(london));
      final afterRepeat = tz.TZDateTime.from(fall.toUtc().add(const Duration(hours: 1, minutes: 5)), london);
      expect(
        isBackupDue(
          now: afterRepeat,
          time: t,
          handledAt: fall.toUtc().add(const Duration(minutes: 1)),
          at: inZone(london),
        ),
        isFalse,
      );
      final a = nextSlot(tz.TZDateTime(london, 2026, 6, 1, 12), nine, at: inZone(london));
      expect(nextSlot(a, nine, at: inZone(london)).difference(a), const Duration(hours: 24));
    });
  });

  group('AutoBackupService: time and state', () {
    late BackupWorld w;
    late FakeFolder folder;
    late MemorySecretStore secrets;
    late DateTime now;
    late AutoBackupService service;
    const picked = PickedFolder(uri: 'content://tree/a');

    setUp(() {
      now = DateTime(2026, 11, 6, 15);
      w = BackupWorld(clock: () => now);
      folder = FakeFolder();
      secrets = MemorySecretStore();
      service = w.autoBackup(folder: folder, secrets: secrets);
    });
    tearDown(() => w.close());

    test('the time lives in secure storage, never in the settings table', () async {
      await service.enable(folder: picked, password: 'password-123', time: const BackupTime(22, 15));
      expect(secrets.values[AutoBackupService.timeKey], '22:15');
      expect((await service.state()).time, const BackupTime(22, 15));
      await service.setTime(const BackupTime(6, 0));
      expect((await service.state()).time, const BackupTime(6, 0));
      for (final s in await w.db.select(w.db.settings).get()) {
        expect(s.key.contains('auto_backup'), isFalse);
      }
      await service.disable();
      expect(secrets.values, isEmpty);
    });

    test('no or broken time saved: 21:00', () async {
      secrets.values[AutoBackupService.enabledKey] = '1';
      expect((await service.state()).time, nine);
      secrets.values[AutoBackupService.timeKey] = 'junk';
      expect((await service.state()).time, nine);
    });

    test('lastAt is stored in UTC; an old value without a zone still reads', () async {
      await service.enable(folder: picked, password: 'password-123');
      await service.backupNow();
      expect(secrets.values[AutoBackupService.lastAtKey], endsWith('Z'));
      expect((await service.state()).lastAt, now);
      secrets.values[AutoBackupService.lastAtKey] = '2026-11-05T21:04:00.000';
      expect((await service.state()).lastAt, DateTime(2026, 11, 5, 21, 4));
    });

    test('"Next" line and pending catch-up', () async {
      await service.enable(folder: picked, password: 'password-123');
      await service.backupNow(); // 15:00
      var s = await service.state();
      expect(s.isDue(now), isFalse);
      expect(s.nextAt(now), DateTime(2026, 11, 6, 21));
      final late = DateTime(2026, 11, 6, 22);
      expect(s.isDue(late), isTrue);
      expect(s.nextAt(late), DateTime(2026, 11, 7, 21));
      await service.disable();
      s = await service.state();
      expect(s.isDue(late), isFalse);
    });

    test('changing the time moves the next slot', () async {
      await service.enable(folder: picked, password: 'password-123');
      await service.backupNow(); // 15:00
      await service.setTime(const BackupTime(14, 0)); // already passed today, handled at 15:00
      var s = await service.state();
      expect(s.isDue(now), isFalse);
      expect(s.nextAt(now), DateTime(2026, 11, 7, 14));
      await service.setTime(const BackupTime(16, 30));
      s = await service.state();
      expect(s.nextAt(now), DateTime(2026, 11, 6, 16, 30));
      expect(s.isDue(DateTime(2026, 11, 6, 16, 31)), isTrue);
    });

    test('maybeRunIfDue: a result when it ran, null when it did nothing', () async {
      expect(await service.maybeRunIfDue(), isNull, reason: 'off');
      await service.enable(folder: picked, password: 'password-123');
      expect(await service.maybeRunIfDue(), AutoBackupResult.ok);
      expect(await service.maybeRunIfDue(), isNull, reason: 'same slot');
      now = DateTime(2026, 11, 6, 21, 3);
      expect(await service.maybeRunIfDue(), isNull, reason: 'data unchanged');
      expect(secrets.values[AutoBackupService.lastCheckKey], isNotNull);
      now = DateTime(2026, 11, 7, 21, 3);
      await w.addSub('new');
      folder.failWith = BackupFolderError.folderMissing;
      expect(await service.maybeRunIfDue(), AutoBackupResult.folderMissing);
      folder.failWith = null;
      now = DateTime(2026, 11, 7, 23);
      expect(await service.maybeRunIfDue(), isNull, reason: 'a failed attempt counts for its slot');
    });
  });

  group('Android background run (runScheduledAutoBackup)', () {
    late FakeFolder folder;
    late MemorySecretStore secrets;
    late List<AppDatabase> opened;

    setUp(() {
      folder = FakeFolder();
      secrets = MemorySecretStore();
      opened = [];
    });

    AppDatabase open() {
      final w = BackupWorld(clock: DateTime.now);
      opened.add(w.db);
      return w.db;
    }

    Future<AutoBackupResult?> run(DateTime now) => runScheduledAutoBackup(
      openDatabase: open,
      secrets: secrets,
      folder: folder,
      clock: () => now,
      encrypt: encryptFast,
    );

    Future<void> enable() async {
      final w = BackupWorld(clock: () => DateTime(2026, 11, 5, 21, 2));
      await w.autoBackup(folder: folder, secrets: secrets).enable(
        folder: const PickedFolder(uri: 'content://tree/a'),
        password: 'password-123',
      );
      // The first backup (when turned on) ran at 21:02 yesterday.
      secrets.values[AutoBackupService.lastAtKey] = DateTime(2026, 11, 5, 21, 2).toUtc().toIso8601String();
      secrets.values[AutoBackupService.lastResultKey] = 'failed';
      await w.close();
    }

    test('off: does nothing', () async {
      expect(await run(DateTime(2026, 11, 6, 21)), isNull);
      expect(folder.writes, 0);
    });

    test('alarm on time: opens the database, encrypts, writes, closes', () async {
      await enable();
      expect(await run(DateTime(2026, 11, 6, 21, 4)), AutoBackupResult.ok);
      expect(folder.files.keys, ['subnest-auto-20261106-2104.subnest']);
      expect(opened, hasLength(1));
      await expectLater(opened.single.select(opened.single.settings).get(), throwsA(anything));
    });

    test('the alarm fires again the same evening: no second file', () async {
      await enable();
      await run(DateTime(2026, 11, 6, 21, 4));
      expect(await run(DateTime(2026, 11, 6, 21, 40)), isNull);
      expect(folder.writes, 1);
    });

    test('fires before the chosen time (time-zone change): does not run', () async {
      await enable();
      expect(await run(DateTime(2026, 11, 6, 19)), isNull);
      expect(folder.writes, 0);
    });
  });
}
