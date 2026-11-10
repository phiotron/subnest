import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subnest/data/catalog/catalog_cache.dart';
import 'package:subnest/data/catalog/catalog_providers.dart';
import 'package:subnest/data/catalog/catalog_sync.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';

import '../../domain/fixtures.dart';
import 'catalog_fixtures.dart';

void main() {
  late Directory tmp;
  late AppDatabase db;
  late Map<String, String> server;
  final now = DateTime(2026, 11, 10, 9);

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('catalog_providers_test');
    db = AppDatabase(NativeDatabase.memory());
    server = {};
  });
  tearDown(() async {
    await db.close();
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  /// A fresh app run on the same database and catalog folder.
  ProviderContainer app() {
    final c = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(() => now),
        catalogRepositoryProvider.overrideWithValue(
          CatalogRepository(bundle: StringBundle(catalogJson(version: 12)), cache: CatalogCache(() async => tmp)),
        ),
        catalogLogoSourceProvider.overrideWithValue(null),
        catalogHttpClientProvider.overrideWithValue(
          MockClient((req) async {
            final path = req.url.toString().replaceFirst(CatalogSync.defaultBase.toString(), '');
            final body = server[path];
            return body == null ? http.Response('', 404) : http.Response.bytes(utf8.encode(body), 200);
          }),
        ),
      ],
    );
    addTearDown(c.dispose);
    c.listen(subscriptionsProvider, (_, _) {});
    c.listen(catalogDataProvider, (_, _) {});
    c.listen(catalogNoticeMemoryProvider, (_, _) {});
    c.listen(priceChangeNoticesProvider, (_, _) {});
    c.listen(catalogPlanNotesProvider, (_, _) {});
    return c;
  }

  /// Lets drift streams and futures settle, then reads the notices.
  Future<List<PriceChangeNotice>> notices(ProviderContainer c) async {
    for (var i = 0; i < 5; i++) {
      await c.read(subscriptionsProvider.future);
      await c.read(catalogNoticeMemoryProvider.future);
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
    return c.read(priceChangeNoticesProvider);
  }

  void publish(String text) {
    server['meta.json'] = metaJson(text);
    server['services.min.json'] = text;
  }

  Subscription netflix(String id, String plan, int price) =>
      sub(id: id, name: 'Netflix $plan', priceMinor: price, currency: 'USD', anchor: const LocalDate(2026, 11, 25))
          .copyWith(serviceId: 'netflix');

  test('remote update → notice; Update writes Price history (source catalog, from the next period)', () async {
    final c = app();
    final repo = c.read(subscriptionRepositoryProvider);
    await repo.save(netflix('a', 'Premium', 2499));
    expect(await notices(c), isEmpty);
    expect(c.read(catalogUpdatedOnProvider), isNotNull);

    publish(catalogJson(version: 13, premiumUs: 26.99));
    expect(await c.read(catalogUpdaterProvider).refreshIfDue(), CatalogRefreshResult.updated);
    final data = await c.read(catalogDataProvider.future);
    expect((data.origin, data.version), (CatalogOrigin.remote, 13));
    expect((await c.read(catalogProvider.future)).firstWhere((s) => s.id == 'netflix').plans[1].prices['US']!.minor, 2699);

    final n = (await notices(c)).single;
    expect((n.subscription.id, n.oldPriceMinor, n.newPriceMinor), ('a', 2499, 2699));
    expect(c.read(subscriptionPriceNoticeProvider('a')), isNotNull);

    expect(await c.read(priceNoticeActionsProvider).update(n), isTrue);
    final change = (await repo.allPriceChanges()).single;
    expect((change.oldPriceMinor, change.newPriceMinor, change.source), (2499, 2699, PriceChangeSource.catalog));
    expect(change.effectiveFrom, const LocalDate(2026, 11, 25));
    expect((await repo.get('a'))!.priceMinor, 2699);
    expect(await notices(c), isEmpty);
    // A stale notice (already applied) writes nothing.
    expect(await c.read(priceNoticeActionsProvider).update(n), isFalse);
    expect(await repo.allPriceChanges(), hasLength(1));
  });

  test('Keep old price is remembered across app runs; price untouched', () async {
    var c = app();
    final repo = c.read(subscriptionRepositoryProvider);
    await repo.save(netflix('b', 'Standard', 1799));
    await notices(c);
    publish(catalogJson(version: 13, standardUs: 19.99));
    await c.read(catalogUpdaterProvider).refreshIfDue();
    final n = (await notices(c)).single;
    await c.read(priceNoticeActionsProvider).keepOldPrice(n);
    expect(await notices(c), isEmpty);
    expect((await repo.get('b'))!.priceMinor, 1799);
    expect(await repo.allPriceChanges(), isEmpty);

    c.dispose();
    c = app();
    expect(await notices(c), isEmpty, reason: 'decision stored on disk');
  });

  test('a price the user typed never gets a notice', () async {
    final c = app();
    await c.read(subscriptionRepositoryProvider).save(netflix('c', 'Premium', 2199));
    await notices(c);
    publish(catalogJson(version: 13, premiumUs: 26.99));
    await c.read(catalogUpdaterProvider).refreshIfDue();
    expect(await notices(c), isEmpty);
  });

  test('offline → no change, no error; bundled-only repository (no cache) → nothing to do', () async {
    final c = app();
    expect(await c.read(catalogUpdaterProvider).refreshIfDue(), CatalogRefreshResult.failed, reason: '404 meta');
    expect((await c.read(catalogDataProvider.future)).origin, CatalogOrigin.bundled);

    final bare = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        catalogRepositoryProvider.overrideWithValue(CatalogRepository(bundle: StringBundle(catalogJson()))),
        catalogLogoSourceProvider.overrideWithValue(null),
      ],
    );
    addTearDown(bare.dispose);
    expect(bare.read(catalogSyncProvider), isNull);
    expect(await bare.read(catalogUpdaterProvider).refreshIfDue(), CatalogRefreshResult.notDue);
  });

  test('discontinued plan note follows the Catalog in use', () async {
    final c = app();
    await c.read(subscriptionRepositoryProvider).save(
      sub(id: 'd', name: 'Old Box Basic', priceMinor: 500, currency: 'USD').copyWith(serviceId: 'old-box'),
    );
    await notices(c);
    expect(c.read(catalogPlanNotesProvider), isEmpty);
    publish(jsonEncode(catalogMap(version: 13, boxStatus: 'discontinued')));
    await c.read(catalogUpdaterProvider).refreshIfDue();
    await notices(c);
    expect(c.read(subscriptionPlanNoteProvider('d'))!.kind, CatalogPlanNoteKind.discontinued);
  });
}
