import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subnest/data/catalog/catalog_cache.dart';
import 'package:subnest/data/catalog/catalog_data.dart';
import 'package:subnest/data/catalog/catalog_sync.dart';
import 'package:subnest/data/catalog/catalog_validator.dart';
import 'package:subnest/data/catalog/remote_logos.dart';
import 'package:subnest/data/catalog_repository.dart';

import 'catalog_fixtures.dart';

void main() {
  late Directory tmp;
  late CatalogCache cache;
  late CatalogRepository repo;
  late Map<String, http.Response Function()> server;
  late List<String> requested;
  var offline = false;
  var now = DateTime(2026, 11, 10, 9);

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('catalog_sync_test');
    cache = CatalogCache(() async => tmp);
    repo = CatalogRepository(bundle: StringBundle(catalogJson(version: 12)), cache: cache);
    server = {};
    requested = [];
    offline = false;
    now = DateTime(2026, 11, 10, 9);
  });
  tearDown(() {
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  final base = CatalogSync.defaultBase;

  CatalogSync sync({Set<String> bundled = const {'netflix', 'spotify', 'old-box'}, List<int>? replaced}) => CatalogSync(
    cache: cache,
    current: () {
      repo.reset(); // the app's CatalogUpdater resets after an update
      return repo.loadData();
    },
    bundledLogoIds: bundled,
    clock: () => now,
    beforeReplace: (old) async => replaced?.add(old.version),
    client: MockClient((req) async {
      requested.add(req.url.toString());
      expect(req.method, 'GET');
      expect(req.url.hasQuery, isFalse, reason: 'nothing about the user is sent (S-42)');
      if (offline) throw const SocketException('offline');
      final path = req.url.toString().replaceFirst(base.toString(), '');
      return server[path]?.call() ?? http.Response('not found', 404);
    }),
  );

  void publish(String catalogText, {String? meta}) {
    server['meta.json'] = () => http.Response(meta ?? metaJson(catalogText), 200);
    server['services.min.json'] = () => http.Response.bytes(utf8.encode(catalogText), 200);
  }

  Future<CatalogData> reload() {
    repo.reset();
    return repo.loadData();
  }

  test('newer valid Catalog → downloaded, cached, used (origin remote, version, updatedOn, downloadedAt)', () async {
    final text = catalogJson(version: 13, premiumUs: 26.99);
    publish(text);
    final replaced = <int>[];
    expect(await sync(replaced: replaced).refreshIfDue(), CatalogRefreshResult.updated);
    expect(replaced, [12], reason: 'old Catalog handed over before it is replaced');
    expect(await cache.readCatalog(), text);
    final data = await reload();
    expect(data.origin, CatalogOrigin.remote);
    expect(data.version, 13);
    expect(data.updatedOn.toString(), '2026-11-05');
    expect(data.downloadedAt, now);
    expect(data.byId('netflix')!.plans[1].prices['US']!.amount, 26.99);
    expect(requested.first, '${base}meta.json');
  });

  test('at most once a day: same day → notDue (no request); next day → checks again', () async {
    publish(catalogJson(version: 12));
    expect(await sync().refreshIfDue(), CatalogRefreshResult.upToDate);
    requested.clear();
    now = DateTime(2026, 11, 10, 23, 59);
    expect(await sync().refreshIfDue(), CatalogRefreshResult.notDue);
    expect(requested, isEmpty);
    now = DateTime(2026, 11, 11, 0, 1);
    expect(await sync().refreshIfDue(), CatalogRefreshResult.upToDate);
    expect(requested, ['${base}meta.json'], reason: 'every service has a bundled logo');
    expect(CatalogSync.isDue(DateTime(2026, 11, 12), now), isTrue, reason: 'clock set back');
  });

  test('offline → offline, nothing recorded (retried next launch), bundled file stays in use', () async {
    offline = true;
    expect(await sync().refreshIfDue(), CatalogRefreshResult.offline);
    expect((await cache.readState()).lastCheckAt, isNull);
    final data = await reload();
    expect((data.origin, data.version), (CatalogOrigin.bundled, 12));
  });

  test('server errors / bad files → failed, Catalog in use unchanged, check counted for today', () async {
    var step = 0;
    Future<void> expectFailed(void Function() setup) async {
      step++;
      await cache.clear();
      setup();
      expect(await sync().refreshIfDue(force: true), CatalogRefreshResult.failed, reason: 'case $step');
      expect(await cache.readCatalog(), isNull);
      expect((await reload()).version, 12);
    }

    final good = catalogJson(version: 13);
    // 500 on meta.
    await expectFailed(() => server['meta.json'] = () => http.Response('oops', 500));
    expect((await cache.readState()).lastCheckAt, now);
    // Meta not JSON.
    await expectFailed(() => server['meta.json'] = () => http.Response('<html>', 200));
    // Unsupported schema in meta.
    await expectFailed(() => publish(good, meta: metaJson(good, schemaVersion: 5)));
    // Checksum mismatch (truncated/corrupted download).
    await expectFailed(() => publish(good, meta: metaJson(good, overrideSha: sha(utf8.encode('x')))));
    // File is not JSON (checksum matches the broken file).
    const truncated = '{"schemaVersion": 4, "version": 13, "serv';
    await expectFailed(() => publish(truncated, meta: metaJson(truncated, version: 13)));
    // Valid JSON but a broken service.
    final broken = catalogMap(version: 13)..['services'] = [{'id': 'netflix'}];
    await expectFailed(() => publish(jsonEncode(broken)));
    // A service id removed (Catalog links would break).
    await expectFailed(() => publish(jsonEncode(catalogMap(version: 13, withSpotify: false))));
    // http:// cancel URL.
    await expectFailed(() => publish(jsonEncode(catalogMap(version: 13, netflixCancelUrl: 'http://netflix.com'))));
    // meta says 13, file says 14.
    await expectFailed(() => publish(catalogJson(version: 14), meta: metaJson(catalogJson(version: 14), version: 13)));
    // services.min.json missing.
    await expectFailed(() {
      publish(good);
      server.remove('services.min.json');
    });
  });

  test('meta not newer than the Catalog in use → upToDate, no download', () async {
    publish(catalogJson(version: 11));
    expect(await sync().refreshIfDue(), CatalogRefreshResult.upToDate);
    expect(requested.where((u) => u.endsWith('services.min.json')), isEmpty);
  });

  test('broken or older cache → bundled file used; newer bundled (app update) beats an older cache', () async {
    await cache.writeCatalog('{"schemaVersion": 4, "version": 99, "services": [');
    expect((await reload()).origin, CatalogOrigin.bundled);
    await cache.writeCatalog(catalogJson(version: 11));
    expect((await reload()).version, 12);
    await cache.writeCatalog(catalogJson(version: 13));
    expect(((await reload()).origin, (await reload()).version), (CatalogOrigin.remote, 13));
  });

  test('missing asset → empty catalog, never throws', () async {
    final r = CatalogRepository(bundle: StringBundle(null));
    expect((await r.loadData()).services, isEmpty);
    expect(await r.load(), isEmpty);
  });

  group('logos', () {
    Map<String, Object?> svc(String id) => {
      'id': id,
      'name': 'New $id',
      'category': 'other',
      'color': '#123456',
      'monogram': 'N',
      'market': 'global',
      'aliases': <String>[],
      'cancelUrl': null,
      'plans': [
        {
          'id': 'pro',
          'name': 'Pro',
          'status': 'active',
          'cycle': {'unit': 'month', 'count': 1},
          'prices': {
            'US': {'currency': 'USD', 'amount': 3, 'method': 'manual'},
          },
        },
      ],
    };

    test('remote-only services get their logo (sha + PNG checked); bundled ones are skipped', () async {
      final text = jsonEncode(catalogMap(version: 13, extraServices: [svc('new-a'), svc('new-b'), svc('new-c')]));
      publish(text);
      final a = png(1), b = png(2);
      server['logos/index.json'] = () => http.Response(
        jsonEncode({
          'files': {'new-a': sha(a), 'new-b': sha(b), 'new-c': sha(png(3)), 'netflix': sha(png(4)), '../x': sha(a)},
        }),
        200,
      );
      server['logos/new-a.png'] = () => http.Response.bytes(a, 200);
      server['logos/new-b.png'] = () => http.Response.bytes([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 200); // not a PNG
      server['logos/new-c.png'] = () => http.Response.bytes(png(9), 200); // wrong checksum
      expect(await sync().refreshIfDue(), CatalogRefreshResult.updated);
      expect(requested, isNot(contains('${base}logos/netflix.png')));

      final store = RemoteLogoStore(cache);
      await store.load();
      expect(store.ids, {'new-a'});
      expect(File(store.pathOf('new-a')!).readAsBytesSync(), a);
      expect(store.logoFor('new-a'), isNotNull);
      expect(store.logoFor('netflix'), isNull);
      expect((await cache.readState()).logosVersion, isNull, reason: 'incomplete → retried at the next check');

      // Next day the fixed logo arrives; new-a is not downloaded again.
      server['logos/new-b.png'] = () => http.Response.bytes(b, 200);
      server['logos/new-c.png'] = () => http.Response.bytes(png(3), 200);
      requested.clear();
      now = now.add(const Duration(days: 1));
      expect(await sync().refreshIfDue(), CatalogRefreshResult.upToDate);
      expect(requested, isNot(contains('${base}logos/new-a.png')));
      await store.load();
      expect(store.ids, {'new-a', 'new-b', 'new-c'});
      expect((await cache.readState()).logosVersion, 13);

      // App update bundles new-a → its cached file is dropped.
      now = now.add(const Duration(days: 1));
      await sync(bundled: {'netflix', 'spotify', 'old-box', 'new-a'}).refreshIfDue();
      await store.load();
      expect(store.ids, {'new-b', 'new-c'});
    });

    test('no logo folder published (404) → nothing fetched, not asked again for this version', () async {
      publish(jsonEncode(catalogMap(version: 13, extraServices: [svc('new-a')])));
      expect(await sync().refreshIfDue(), CatalogRefreshResult.updated);
      expect((await cache.readState()).logosVersion, 13);
      requested.clear();
      now = now.add(const Duration(days: 1));
      await sync().refreshIfDue();
      expect(requested, ['${base}meta.json']);
    });
  });

  test('validator: previous ids must stay; schema 5 refused', () {
    final prev = CatalogValidator.validate(catalogJson(version: 12));
    expect(() => CatalogValidator.validate(jsonEncode(catalogMap(version: 13, withSpotify: false)), previous: prev),
        throwsA(isA<CatalogFormatException>()));
    expect(() => CatalogValidator.validate(jsonEncode(catalogMap(schemaVersion: 5))), throwsA(isA<CatalogFormatException>()));
    expect(CatalogValidator.validate(catalogJson(version: 13), previous: prev).version, 13);
  });
}
