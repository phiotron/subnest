import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/backup/backup_service.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/rates/exchange_rate_repository.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';

import '../domain/fixtures.dart';

void main() {
  late AppDatabase db;
  late SubscriptionRepository repo;
  late SettingsRepository settings;
  var now = DateTime(2026, 11, 10, 10);

  setUp(() {
    now = DateTime(2026, 11, 10, 10);
    db = AppDatabase(NativeDatabase.memory());
    repo = SubscriptionRepository(db, clock: () => now, newId: idGen());
    settings = SettingsRepository(db);
  });
  tearDown(() => db.close());

  BackupService backup() =>
      BackupService(db, repo, settings, ExchangeRateRepository(db, settings, clock: () => now), clock: () => now);

  // Monthly 10.00 USD, next Due date 2026-11-25.
  Subscription base() => sub(id: 'a', priceMinor: 1000, currency: 'USD', anchor: const LocalDate(2026, 11, 25));

  test('save records a manual price change effective from the next Due date; same price records nothing', () async {
    await repo.save(base());
    expect(await repo.allPriceChanges(), isEmpty);
    await repo.save(base().copyWith(name: 'Renamed'));
    expect(await repo.allPriceChanges(), isEmpty);
    await repo.save(base().copyWith(priceMinor: 1200));
    final c = (await repo.allPriceChanges()).single;
    expect((c.oldPriceMinor, c.newPriceMinor, c.currency, c.oldCurrency), (1000, 1200, 'USD', null));
    expect(c.effectiveFrom, const LocalDate(2026, 11, 25));
    expect(c.source, PriceChangeSource.manual);
  });

  test('a typo fixed right after updates the same row; going back to the start removes it', () async {
    await repo.save(base());
    await repo.save(base().copyWith(priceMinor: 1300));
    await repo.save(base().copyWith(priceMinor: 1200));
    final c = (await repo.allPriceChanges()).single;
    expect((c.oldPriceMinor, c.newPriceMinor), (1000, 1200));
    await repo.save(base());
    expect(await repo.allPriceChanges(), isEmpty);
  });

  test('changePrice (Catalog notice) records source catalog; currency change keeps the old currency', () async {
    await repo.save(base());
    await repo.changePrice('a', 1100, source: PriceChangeSource.catalog);
    expect((await repo.get('a'))!.priceMinor, 1100);
    await repo.changePrice('a', 30000, currency: 'VND', effectiveFrom: const LocalDate(2027, 1, 1));
    final list = await repo.allPriceChanges(subscriptionId: 'a');
    expect(list.map((c) => c.source), [PriceChangeSource.catalog, PriceChangeSource.manual]);
    expect((list.last.oldPriceMinor, list.last.oldCurrency, list.last.newPriceMinor, list.last.currency), (
      1100,
      'USD',
      30000,
      'VND',
    ));
  });

  test('Cancelled subscription: change dated today (no next Due date)', () async {
    await repo.save(base().copyWith(status: SubscriptionStatus.cancelled, cancelledOn: const LocalDate(2026, 11, 1)));
    await repo.changePrice('a', 900);
    expect((await repo.allPriceChanges()).single.effectiveFrom, const LocalDate(2026, 11, 10));
  });

  test('backup round-trip keeps Price history; CSV gets a price history file', () async {
    await repo.save(base());
    await repo.changePrice('a', 1200);
    final text = await backup().exportJsonText();
    expect((jsonDecode(text) as Map)['priceChanges'], hasLength(1));
    final files = await backup().exportCsv();
    expect(files.map((f) => f.name), [
      'subnest-subscriptions-2026-11-10.csv',
      'subnest-payments-2026-11-10.csv',
      'subnest-price-history-2026-11-10.csv',
    ]);
    expect(files.last.content, contains('Netflix,2026-11-25,10.00,USD,12.00,USD,manual'));

    await db.wipeUserData();
    expect(await repo.allPriceChanges(), isEmpty);
    await backup().importJson(text);
    final c = (await repo.allPriceChanges()).single;
    expect((c.oldPriceMinor, c.newPriceMinor, c.effectiveFrom), (1000, 1200, const LocalDate(2026, 11, 25)));
  });

  test('restoring a file made before Price history backfills it from the Payments', () async {
    await repo.save(base().copyWith(priceMinor: 1200));
    for (final (i, (m, amount)) in [(7, 1000), (8, 1000), (9, 1200), (10, 1200)].indexed) {
      await db.into(db.confirmedPeriods).insert(
        ConfirmedPeriodsCompanion.insert(
          id: 'p$i',
          subscriptionId: 'a',
          dueDate: LocalDate(2026, m, 25).toString(),
          outcome: 'payment',
          amountMinor: amount,
          currency: 'USD',
          confirmedAt: now,
        ),
      );
    }
    final json = jsonDecode(await backup().exportJsonText()) as Map<String, Object?>;
    json.remove('priceChanges');
    json['checksum'] = BackupService.checksumOf({...json}..remove('format')..remove('version')..remove('exportedAt')..remove('checksum'));
    await backup().importJson(jsonEncode(json));
    final c = (await repo.allPriceChanges()).single;
    expect((c.oldPriceMinor, c.newPriceMinor, c.effectiveFrom, c.source), (
      1000,
      1200,
      const LocalDate(2026, 9, 25),
      PriceChangeSource.backfill,
    ));
  });

  test('a bad Price history in a file fails before anything is replaced', () async {
    await repo.save(base());
    final json = jsonDecode(await backup().exportJsonText()) as Map<String, Object?>;
    json['priceChanges'] = [
      {'id': 'x', 'subscriptionId': 'a'},
    ];
    json.remove('checksum');
    expect(() => backup().parse(jsonEncode(json)), throwsA(isA<BackupFormatException>()));
  });
}
