import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/rates/exchange_rate_repository.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';

import '../domain/fixtures.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late AppDatabase db;
  late DateTime now;
  late SubscriptionRepository subs;
  late SettingsRepository settings;
  late ExchangeRateRepository rates;
  late int fetches;

  ExchangeRateRepository ratesRepo(String body, {int status = 200}) => ExchangeRateRepository(
    db,
    settings,
    clock: () => now,
    client: MockClient((req) async {
      fetches++;
      return http.Response(body, status);
    }),
  );

  const apiBody =
      '{"result":"success","base_code":"USD","time_last_update_unix":1,"rates":{"USD":1,"VND":25400,"EUR":0.9}}';

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    now = DateTime(2026, 11, 4, 10);
    var n = 0;
    subs = SubscriptionRepository(db, clock: () => now, newId: () => 'id${++n}');
    settings = SettingsRepository(db);
    fetches = 0;
    rates = ratesRepo(apiBody);
  });

  tearDown(() => db.close());

  group('SubscriptionRepository', () {
    test('save → watch → confirm → history; due date moves only after confirming', () async {
      await subs.save(sub(anchor: const LocalDate(2026, 10, 4), sharedWith: 4));
      expect((await subs.all()).single.dueDate, const LocalDate(2026, 10, 4));

      final p = await subs.confirm('s1', PeriodOutcome.payment);
      expect(p.amountMinor, 65000);
      expect((await subs.get('s1'))!.dueDate, const LocalDate(2026, 11, 4));

      await subs.confirm('s1', PeriodOutcome.skipped);
      final history = await subs.watchPeriods(subscriptionId: 's1').first;
      expect(history.map((e) => e.outcome), [PeriodOutcome.skipped, PeriodOutcome.payment]);
      expect((await subs.get('s1'))!.dueDate, const LocalDate(2026, 12, 4));
    });

    test('confirmAll across subscriptions', () async {
      await subs.save(sub(id: 'a', anchor: const LocalDate(2026, 9, 4)));
      await subs.save(sub(id: 'b', anchor: const LocalDate(2026, 11, 1)));
      await subs.save(sub(id: 'c', anchor: const LocalDate(2026, 12, 1)));
      expect(await subs.confirmAll(), 4);
      expect((await subs.allPeriods()).length, 4);
    });

    test('upsert does not wipe history (no REPLACE cascade)', () async {
      await subs.save(sub(anchor: const LocalDate(2026, 11, 4)));
      await subs.confirm('s1', PeriodOutcome.payment);
      final s = (await subs.get('s1'))!;
      await subs.save(s.copyWith(name: 'Netflix Premium'));
      expect((await subs.allPeriods()), hasLength(1));
    });

    test('delete cascades to history', () async {
      await subs.save(sub(anchor: const LocalDate(2026, 11, 4)));
      await subs.confirm('s1', PeriodOutcome.payment);
      await subs.delete('s1');
      expect(await subs.allPeriods(), isEmpty);
    });

    test('edit payment amount, cancel and restore', () async {
      await subs.save(sub(anchor: const LocalDate(2026, 11, 4)));
      final p = await subs.confirm('s1', PeriodOutcome.payment);
      await subs.updatePeriodAmount(p.id, 300000);
      expect((await subs.allPeriods()).single.amountMinor, 300000);
      await subs.cancel('s1');
      expect((await subs.get('s1'))!.status, SubscriptionStatus.cancelled);
      await subs.restore('s1');
      expect((await subs.get('s1'))!.status, SubscriptionStatus.active);
    });

    test('normalizeAll persists Trial → Active', () async {
      await subs.save(BillingRules.startTrial(sub(), const LocalDate(2026, 11, 3), now));
      expect(await subs.normalizeAll(), 1);
      expect((await subs.get('s1'))!.status, SubscriptionStatus.active);
    });
  });

  group('SettingsRepository', () {
    test('defaults: USD (S-90), 3 days at 09:00', () async {
      final s = await settings.load();
      expect(s.primaryCurrency, 'USD');
      expect(s.localeCode, isNull, reason: 'English until the user picks a language');
      expect(s.defaultReminderDays, 3);
      expect((s.reminderHour, s.reminderMinute), (9, 0));
      expect(s.onboardingDone, isFalse);
    });

    test('writes', () async {
      await settings.setPrimaryCurrency('usd');
      await settings.setReminderTime(20, 30);
      await settings.setDefaultReminderDays(ReminderDays.off);
      await settings.setOnboardingDone(true);
      final s = await settings.load();
      expect(s.primaryCurrency, 'USD');
      expect((s.reminderHour, s.reminderMinute), (20, 30));
      expect(s.defaultReminderDays, ReminderDays.off);
      expect(s.onboardingDone, isTrue);
    });

    test('defaults to USD for every new install (S-90)', () async {
      final fresh = SettingsRepository(AppDatabase(NativeDatabase.memory()));
      expect((await fresh.load()).primaryCurrency, 'USD');
      expect((await fresh.load()).localeCode, isNull);
    });
  });

  group('ExchangeRateRepository', () {
    test('uses bundled fallback before the first refresh', () async {
      final r = await rates.load();
      expect(r.fetchedAt, isNull);
      expect(r.rate('USD', 'VND'), greaterThan(20000));
    });

    test('refreshes once a day, caches, keeps working offline', () async {
      expect(await rates.refreshIfStale(), RatesRefreshResult.updated);
      expect((await rates.load()).rate('USD', 'VND'), 25400);
      expect(await rates.refreshIfStale(), RatesRefreshResult.notNeeded);
      expect(fetches, 1);

      now = now.add(const Duration(days: 1));
      final offline = ratesRepo('', status: 500);
      expect(await offline.refreshIfStale(), RatesRefreshResult.failed);
      expect((await offline.load()).rate('USD', 'VND'), 25400, reason: 'cache survives a failed refresh');
    });

    test('manual override wins and can be cleared', () async {
      await rates.refreshIfStale();
      await rates.setOverride('USD', 'VND', 26000);
      expect((await rates.load()).rate('USD', 'VND'), 26000);
      await rates.clearOverride('VND', 'USD');
      expect((await rates.load()).rate('USD', 'VND'), 25400);
    });

    test('watch emits updates', () async {
      final stream = rates.watch();
      expect((await stream.first).fetchedAt, isNull);
      await rates.refreshIfStale();
      expect((await rates.watch().first).fetchedAt, now);
    });

    test('parseResponse rejects bad payloads', () {
      expect(ExchangeRateRepository.parseResponse('nope'), isEmpty);
      expect(ExchangeRateRepository.parseResponse('{"result":"error"}'), isEmpty);
      expect(ExchangeRateRepository.parseResponse(apiBody)['VND'], 25400);
    });
  });

  group('BackupService', () {
    BackupService backupFor(AppDatabase d, SubscriptionRepository s, SettingsRepository st) =>
        BackupService(d, s, st, ExchangeRateRepository(d, st, clock: () => now), clock: () => now);

    Future<String> seedAndExport() async {
      await subs.save(sub(id: 'netflix', anchor: const LocalDate(2026, 10, 4), sharedWith: 4));
      await subs.save(BillingRules.startTrial(sub(id: 'spotify', name: 'Spotify, "Duo"'), const LocalDate(2026, 11, 20), now));
      await subs.confirm('netflix', PeriodOutcome.payment);
      await settings.setPrimaryCurrency('EUR');
      await rates.setOverride('USD', 'VND', 26000);
      return (await backupFor(db, subs, settings).exportJson()).content;
    }

    test('JSON round-trip into an empty database (replace)', () async {
      final json = await seedAndExport();
      expect((await settings.load()).lastBackupAt, isNull, reason: 'only a completed share counts as a backup');
      await backupFor(db, subs, settings).markBackedUp();
      expect((await settings.load()).lastBackupAt, now);

      final db2 = AppDatabase(NativeDatabase.memory());
      addTearDown(db2.close);
      final subs2 = SubscriptionRepository(db2, clock: () => now);
      final settings2 = SettingsRepository(db2);
      final r = await backupFor(db2, subs2, settings2).importJson(json, ImportMode.replace);
      expect((r.subscriptions, r.periods), (2, 1));
      final restored = {for (final s in await subs2.all()) s.id: s};
      expect(restored['netflix']!.dueDate, const LocalDate(2026, 11, 4));
      expect(restored['netflix']!.sharedWith, 4);
      expect(restored['spotify']!.status, SubscriptionStatus.trial);
      expect(restored['spotify']!.trialEndDate, const LocalDate(2026, 11, 20));
      expect((await subs2.allPeriods()).single.amountMinor, 65000);
      expect((await settings2.load()).primaryCurrency, 'EUR');
      expect((await ExchangeRateRepository(db2, settings2).load()).rate('USD', 'VND'), 26000);
    });

    test('replace wipes current data; merge keeps it', () async {
      final json = await seedAndExport();
      await subs.save(sub(id: 'local-only', anchor: const LocalDate(2026, 12, 1)));

      await backupFor(db, subs, settings).importJson(json, ImportMode.merge);
      expect((await subs.all()).map((s) => s.id).toSet(), {'netflix', 'spotify', 'local-only'});
      expect(await subs.allPeriods(), hasLength(1), reason: 'no duplicate history');

      await backupFor(db, subs, settings).importJson(json, ImportMode.replace);
      expect((await subs.all()).map((s) => s.id).toSet(), {'netflix', 'spotify'});
    });

    test('merge: newer local edit wins; imported history moves the due date forward', () async {
      final json = await seedAndExport();
      // Simulate a device that has the subscription but not its confirmed period.
      await db.delete(db.confirmedPeriods).go();
      final local = (await subs.get('netflix'))!;
      now = now.add(const Duration(hours: 1));
      await subs.save(local.copyWith(name: 'Netflix (local)', periodIndex: 0, updatedAt: now));

      await backupFor(db, subs, settings).importJson(json, ImportMode.merge);
      final merged = (await subs.get('netflix'))!;
      expect(merged.name, 'Netflix (local)');
      expect(merged.dueDate, const LocalDate(2026, 11, 4), reason: 'already-confirmed 10/04 period is skipped');
    });

    test('rejects files that are not Subnest backups', () {
      final b = backupFor(db, subs, settings);
      expect(() => b.parse('hello'), throwsA(isA<BackupFormatException>()));
      expect(() => b.parse('{"format":"other"}'), throwsA(isA<BackupFormatException>()));
      expect(() => b.parse('{"format":"subnest-backup","version":99}'), throwsA(isA<BackupFormatException>()));
      expect(
        () => b.parse('{"format":"subnest-backup","version":1,"subscriptions":[{"id":1}]}'),
        throwsA(isA<BackupFormatException>()),
      );
    });

    test('CSV export: two files, BOM, escaping', () async {
      await seedAndExport();
      final files = await backupFor(db, subs, settings).exportCsv();
      expect(files.map((f) => f.name), ['subnest-subscriptions-2026-11-04.csv', 'subnest-payments-2026-11-04.csv']);
      final csv = files.first.content;
      expect(csv.startsWith('﻿'), isTrue);
      expect(csv, contains('"Spotify, ""Duo"""'));
      expect(files.last.content, contains('Netflix,2026-10-04,payment,65000,VND'));
    });
  });
}
