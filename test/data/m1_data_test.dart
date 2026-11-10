import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/organize_repository.dart';
import 'package:subnest/data/rates/exchange_rate_repository.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';

import '../domain/fixtures.dart';

void main() {
  late AppDatabase db;
  late SubscriptionRepository repo;
  late OrganizeRepository org;
  late SettingsRepository settings;
  final now = DateTime(2026, 11, 20, 10);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SubscriptionRepository(db, clock: () => now, newId: idGen());
    org = OrganizeRepository(db, clock: () => now);
    settings = SettingsRepository(db);
  });
  tearDown(() => db.close());

  BackupService backup() =>
      BackupService(db, repo, settings, ExchangeRateRepository(db, settings, clock: () => now), clock: () => now);

  test('fresh install seeds 11 categories', () async {
    expect(await org.categories(), hasLength(11));
  });

  test('labels + payment method by name round-trip through save', () async {
    final l1 = await org.addLabel('Work');
    final l2 = await org.addLabel('Ads');
    await repo.save(sub(id: 'a').copyWith(labelIds: {l1.id, l2.id}, paymentMethod: 'Visa ••4821'));
    await repo.save(sub(id: 'b', name: 'Spotify').copyWith(paymentMethod: ' visa  ••4821'));
    final a = (await repo.get('a'))!;
    final b = (await repo.get('b'))!;
    expect(a.labelIds, {l1.id, l2.id});
    expect(a.paymentMethod, 'Visa ••4821');
    expect(a.paymentMethodId, b.paymentMethodId);
    await org.deleteLabel(l1.id);
    expect((await repo.get('a'))!.labelIds, {l2.id});
    await org.deletePaymentMethod(a.paymentMethodId!);
    expect((await repo.get('a'))!.paymentMethodId, isNull);
  });

  test('deleting a category moves its subscriptions and drops its budget', () async {
    final c = await org.addCategory(name: 'Kids', colorValue: 0xFF00FF00);
    await repo.save(sub(id: 'a').copyWith(categoryId: c.id));
    await org.setBudget(categoryId: c.id, amountMinor: 100, currency: 'vnd');
    await org.setBudget(amountMinor: 900, currency: 'VND');
    await org.setBudget(amountMinor: 1000, currency: 'VND');
    await org.deleteCategory(c.id, moveTo: 'music');
    expect((await repo.get('a'))!.categoryId, 'music');
    final budgets = await org.watchBudgets().first;
    expect(budgets.single.isTotal, isTrue);
    expect(budgets.single.amountMinor, 1000);
    expect(() => org.deleteCategory('other'), throwsStateError);
  });

  test('pause / resume / worth-it persist', () async {
    await repo.save(sub(id: 'a', anchor: const LocalDate(2026, 11, 25)));
    await repo.pause('a');
    var a = (await repo.get('a'))!;
    expect(a.status, SubscriptionStatus.paused);
    expect(a.pausedFrom, const LocalDate(2026, 11, 25));
    await repo.resume('a', const LocalDate(2026, 12, 3));
    await repo.setWorthIt('a', WorthIt.unsure);
    a = (await repo.get('a'))!;
    expect(a.dueDate, const LocalDate(2026, 12, 3));
    expect(a.worthIt, WorthIt.unsure);
  });

  group('applyDetections + Undo', () {
    final catalog = [
      CatalogService(
        id: 'netflix',
        name: 'Netflix',
        category: SubscriptionCategory.video,
        colorValue: 0xFFE50914,
        monogram: 'N',
        plans: [
          CatalogPlan(
            id: 'p',
            name: 'Premium',
            cycle: const BillingCycle.monthly(),
            prices: const {'VN': CatalogPrice('VND', 260000)},
          ),
        ],
      ),
    ];
    DetectedCharge c(String name, int amount, LocalDate date) =>
        DetectedCharge(name: name, amountMinor: amount, currency: 'VND', date: date, source: DetectionSource.scan);

    test('auto-add then undo → removed and never re-added', () async {
      final r = await repo.applyDetections([c('NETFLIX', 260000, const LocalDate(2026, 11, 18))], catalog: catalog, region: 'VN');
      expect(r.added, hasLength(1));
      final id = r.added.single.id;
      expect((await repo.get(id))!.isAutoDetected, isTrue);
      expect(await repo.allPeriods(), hasLength(1));
      await repo.undoAutoAdd(id);
      expect(await repo.get(id), isNull);
      final again = await repo.applyDetections([c('NETFLIX', 260000, const LocalDate(2026, 11, 18))], catalog: catalog, region: 'VN');
      expect(again.added, isEmpty);
      expect(again.skipped.single.reason, DetectionSkipReason.dismissed);
    });

    test('auto-confirm then undo → period pending again, price untouched', () async {
      await repo.save(sub(id: 'a', anchor: const LocalDate(2026, 11, 18)).copyWith(serviceId: 'netflix'));
      final r = await repo.applyDetections([c('Netflix', 270000, const LocalDate(2026, 11, 19))], catalog: catalog, region: 'VN');
      expect(r.confirmed.single.amountMinor, 270000);
      var a = (await repo.get('a'))!;
      expect(a.dueDate, const LocalDate(2026, 12, 18));
      expect(a.priceMinor, 260000);
      await repo.undoAutoConfirm(r.confirmed.single.id);
      a = (await repo.get('a'))!;
      expect(a.dueDate, const LocalDate(2026, 11, 18));
      expect(await repo.allPeriods(), isEmpty);
    });

    test('unknown payee is stored, then added on the repeat; evidence consumed', () async {
      final r1 = await repo.applyDetections([c('ACME', 99000, const LocalDate(2026, 10, 19))], catalog: catalog, region: 'VN');
      expect(r1.keptUnmatched, 1);
      final r2 = await repo.applyDetections([c('ACME', 99000, const LocalDate(2026, 11, 19))], catalog: catalog, region: 'VN');
      expect(r2.added.single.name, 'Acme');
      expect(await repo.unmatchedCharges(), isEmpty);
    });
  });

  group('backup v2', () {
    test('round-trip keeps categories, labels, methods, budgets, new fields', () async {
      final cat = await org.addCategory(name: 'Kids', colorValue: 1);
      final l = await org.addLabel('Work');
      await org.setBudget(categoryId: cat.id, amountMinor: 5, currency: 'VND');
      await repo.save(
        sub(id: 'a').copyWith(
          categoryId: cat.id,
          labelIds: {l.id},
          paymentMethod: 'MoMo',
          reminderOffsets: {0, 7},
          worthIt: WorthIt.notWorth,
          detectionSource: DetectionSource.scan,
          detectedAt: now,
        ),
      );
      await repo.pause('a');
      await repo.dismiss('service:x');
      final file = await backup().exportJson();
      expect(jsonDecode(file.content)['version'], 2);

      await db.wipeUserData();
      expect(await repo.all(), isEmpty);
      await backup().importJson(file.content, ImportMode.replace);
      final a = (await repo.get('a'))!;
      expect(a.categoryId, cat.id);
      expect(a.labelIds, {l.id});
      expect(a.paymentMethod, 'MoMo');
      expect(a.reminderOffsets, {0, 7});
      expect(a.worthIt, WorthIt.notWorth);
      expect(a.status, SubscriptionStatus.paused);
      expect(a.detectionSource, DetectionSource.scan);
      expect(await org.watchBudgets().first, hasLength(1));
      expect(await repo.dismissedKeys(), {'service:x'});
    });

    test('a v1 backup restores: category key, payment method text, reminder days', () async {
      const v1 = '''{"format":"subnest-backup","version":1,"settings":{},"rateOverrides":{},
        "subscriptions":[{"id":"a","name":"Netflix","category":"music","priceMinor":1000,"currency":"vnd",
          "cycleEvery":1,"cycleUnit":"month","anchorDate":"2026-11-25","periodIndex":0,"status":"active",
          "sharedWith":1,"reminderDays":3,"paymentMethod":"Visa","startDate":"2026-01-01",
          "createdAt":"2026-01-01T00:00:00Z","updatedAt":"2026-01-01T00:00:00Z"},
          {"id":"b","name":"X","category":"nope","priceMinor":1000,"currency":"VND","cycleEvery":1,
          "cycleUnit":"month","anchorDate":"2026-11-25","status":"active","reminderDays":-1,"paymentMethod":"visa",
          "startDate":"2026-01-01","createdAt":"2026-01-01T00:00:00Z","updatedAt":"2026-01-01T00:00:00Z"}],
        "periods":[{"id":"p","subscriptionId":"a","dueDate":"2026-10-25","outcome":"payment","amountMinor":1000,
          "currency":"VND","confirmedAt":"2026-10-25T00:00:00Z"}]}''';
      final r = await backup().importJson(v1, ImportMode.replace);
      expect(r.subscriptions, 2);
      final a = (await repo.get('a'))!;
      final b = (await repo.get('b'))!;
      expect(a.categoryId, 'music');
      expect(b.categoryId, 'other');
      expect(a.reminderOffsets, {0, 3});
      expect(b.reminderOffsets, isEmpty);
      expect(a.paymentMethodId, b.paymentMethodId);
      expect(a.paymentMethod, 'Visa');
      expect((await repo.allPeriods()).single.source, isNull);
    });

    test('CSV has the new columns', () async {
      await repo.save(sub(id: 'a').copyWith(worthIt: WorthIt.worth));
      final files = await backup().exportCsv();
      expect(files.first.content, contains('worth_it'));
      expect(files.first.content, contains('worth'));
      expect(files.last.content, contains('source'));
    });
  });

  test('settings: offsets stored, legacy setter converts', () async {
    expect((await settings.load()).defaultReminderOffsets, ReminderOffsets.defaults);
    await settings.setDefaultReminderOffsets({1, 7});
    expect((await settings.load()).defaultReminderOffsets, {1, 7});
    await settings.setDefaultReminderDays(ReminderDays.off);
    expect((await settings.load()).defaultReminderDays, ReminderDays.off);
  });
}
