import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:subnest/data/logos/logo_dev.dart';
import 'package:subnest/data/logos/logo_disk_cache.dart';
import 'package:subnest/data/logos/logo_repository.dart';

/// 8×8 opaque PNG — any image body works for the repository.
final Uint8List fakePng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAEUlEQVR4nGMQVHqHFTEMLQkABCxIQSPERjoAAAAASUVORK5CYII=',
);

/// Test-only publishable-looking key (not a real one).
const testKey = 'pk_TEST0000fake';

/// Logo.dev stand-in: answers per domain, records every request.
class FakeLogoDev {
  final requests = <http.BaseRequest>[];
  final responses = <String, http.Response Function()>{};
  Object? throwError;

  late final client = MockClient((req) async {
    requests.add(req);
    if (throwError != null) throw throwError!;
    final domain = req.url.pathSegments.single;
    return (responses[domain] ?? () => http.Response('{"err":"not found"}', 404))();
  });

  void logo(String domain) =>
      responses[domain] = () => http.Response.bytes(fakePng, 200, headers: {'content-type': 'image/png'});

  int callsFor(String domain) => requests.where((r) => r.url.pathSegments.single == domain).length;
}

void main() {
  late Directory tmp;
  late FakeLogoDev server;
  late DateTime now;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('logos_');
    server = FakeLogoDev();
    now = DateTime(2026, 11, 6, 9);
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  LogoRepository repo({String key = testKey}) => LogoRepository(
    apiKey: key,
    cacheDirectory: () async => Directory('${tmp.path}/service_logos'),
    client: server.client,
    clock: () => now,
  );

  group('LogoDev', () {
    test('URL is only the catalog domain + key + fixed size/format, over HTTPS', () {
      final uri = LogoDev.imageUri('netflix.com', testKey);
      expect(
        uri.toString(),
        'https://img.logo.dev/netflix.com?token=pk_TEST0000fake&size=128&format=png&retina=true&fallback=404',
      );
      expect(uri.queryParameters.keys, unorderedEquals(['token', 'size', 'format', 'retina', 'fallback']));
    });

    test('domains: bare host names only', () {
      expect(LogoDev.normalizeDomain(' Netflix.COM '), 'netflix.com');
      expect(LogoDev.normalizeDomain('one.google.com'), 'one.google.com');
      expect(LogoDev.normalizeDomain('fptplay.vn'), 'fptplay.vn');
      for (final bad in [
        null,
        '',
        'Netflix',
        'my gym',
        'https://netflix.com',
        'netflix.com/watch',
        'netflix.com:443',
        'netflix.com?x=1',
        '1.2.3.4',
        'localhost',
        '-bad.com',
        'a..com',
      ]) {
        expect(LogoDev.normalizeDomain(bad), isNull, reason: '$bad');
      }
    });

    test('only publishable keys', () {
      expect(LogoDev.isPublishableKey(testKey), isTrue);
      expect(LogoDev.isPublishableKey(''), isFalse);
      expect(LogoDev.isPublishableKey('sk_secret00000000'), isFalse);
      expect(LogoDev.isPublishableKey('pk_'), isFalse);
    });

    test('test runs have no key: the app instance is off', () {
      expect(LogoDev.keyFromEnvironment, isEmpty);
      expect(LogoRepository.instance.enabled, isFalse);
    });
  });

  group('LogoRepository', () {
    test('no key (or a secret key) → off, never calls the network', () async {
      for (final key in ['', 'sk_secret00000000']) {
        final r = repo(key: key);
        server.logo('netflix.com');
        expect(r.enabled, isFalse);
        expect(r.peek('netflix.com'), isNull);
        expect(await r.load('netflix.com'), isNull);
      }
      expect(server.requests, isEmpty);
      expect(Directory('${tmp.path}/service_logos').existsSync(), isFalse);
    });

    test('invalid domain → no request', () async {
      final r = repo();
      expect(await r.load('My Gym'), isNull);
      expect(await r.load('https://evil.example/x'), isNull);
      expect(server.requests, isEmpty);
    });

    test('downloads once, the exact URL, no redirects; then memory and disk', () async {
      server.logo('netflix.com');
      final r = repo();
      final bytes = await r.load('netflix.com');
      expect(bytes, fakePng);
      expect(server.requests, hasLength(1));
      final req = server.requests.single;
      expect(req.method, 'GET');
      expect(req.url, LogoDev.imageUri('netflix.com', testKey));
      expect(req.followRedirects, isFalse);
      expect(File('${tmp.path}/service_logos/netflix.com.png').readAsBytesSync(), fakePng);

      expect(r.peek('Netflix.com'), same(bytes), reason: 'same instance → image cache hit, no flicker');
      expect(await r.load('netflix.com'), same(bytes));

      // New launch: from disk, no request.
      final again = repo();
      expect(again.peek('netflix.com'), isNull);
      expect(await again.load('netflix.com'), fakePng);
      expect(server.requests, hasLength(1));
    });

    test('concurrent tiles for one domain share one request', () async {
      server.logo('spotify.com');
      final r = repo();
      final results = await Future.wait([r.load('spotify.com'), r.load('spotify.com'), r.load('SPOTIFY.com')]);
      expect(results, everyElement(fakePng));
      expect(server.callsFor('spotify.com'), 1);
    });

    test('404 → remembered as missing for 7 days', () async {
      final r = repo();
      expect(await r.load('nologo.com'), isNull);
      expect(File('${tmp.path}/service_logos/nologo.com.none').existsSync(), isTrue);

      now = now.add(const Duration(days: 6));
      expect(await repo().load('nologo.com'), isNull);
      expect(server.callsFor('nologo.com'), 1);

      now = now.add(const Duration(days: 2));
      server.logo('nologo.com');
      expect(await repo().load('nologo.com'), fakePng);
      expect(server.callsFor('nologo.com'), 2);
      expect(File('${tmp.path}/service_logos/nologo.com.none').existsSync(), isFalse);
    });

    test('offline → monogram, no retry for 15 minutes', () async {
      final r = repo();
      server.throwError = const SocketException('offline');
      expect(await r.load('netflix.com'), isNull);
      expect(await r.load('netflix.com'), isNull);
      expect(server.requests, hasLength(1));
      expect(File('${tmp.path}/service_logos/netflix.com.none').existsSync(), isFalse, reason: 'not "missing"');

      server.throwError = null;
      server.logo('netflix.com');
      now = now.add(const Duration(minutes: 16));
      expect(await r.load('netflix.com'), fakePng);
      expect(server.requests, hasLength(2));
    });

    test('5xx, 202 and non-image bodies are not cached', () async {
      final r = repo();
      server.responses['a.com'] = () => http.Response('oops', 500);
      server.responses['b.com'] = () => http.Response.bytes(fakePng, 202, headers: {'content-type': 'image/png'});
      server.responses['c.com'] = () => http.Response('<html>', 200, headers: {'content-type': 'text/html'});
      server.responses['d.com'] = () => http.Response('', 302, headers: {'location': 'http://img.logo.dev/d.com'});
      for (final d in ['a.com', 'b.com', 'c.com', 'd.com']) {
        expect(await r.load(d), isNull, reason: d);
      }
      expect(Directory('${tmp.path}/service_logos').listSync(), isEmpty);
    });

    test('401 (bad key) → logos off until next launch', () async {
      server.responses['netflix.com'] = () => http.Response('{"msg":"invalid api token"}', 401);
      server.logo('spotify.com');
      final r = repo();
      expect(await r.load('netflix.com'), isNull);
      expect(r.enabled, isFalse);
      expect(await r.load('spotify.com'), isNull);
      expect(server.requests, hasLength(1));
    });

    test('429 pauses every download for Retry-After', () async {
      server.responses['a.com'] = () => http.Response('', 429, headers: {'retry-after': '60'});
      server.logo('b.com');
      final r = repo();
      expect(await r.load('a.com'), isNull);
      expect(await r.load('b.com'), isNull);
      expect(server.requests, hasLength(1));
      now = now.add(const Duration(seconds: 61));
      expect(await r.load('b.com'), fakePng);
    });

    test('after 30 days the logo is refreshed; the old one is kept if that fails', () async {
      server.logo('netflix.com');
      expect(await repo().load('netflix.com'), fakePng);

      now = now.add(const Duration(days: 31));
      server.throwError = const SocketException('offline');
      final r = repo();
      expect(await r.load('netflix.com'), fakePng, reason: 'stale beats a monogram');
      expect(server.requests, hasLength(2));

      server.throwError = null;
      now = now.add(const Duration(minutes: 16));
      expect(await r.load('netflix.com'), fakePng);
      expect(server.requests, hasLength(3));
      final saved = File('${tmp.path}/service_logos/netflix.com.png').statSync().modified;
      expect(saved.difference(now).inSeconds.abs(), lessThan(2), reason: 'refreshed file');

      expect(await r.load('netflix.com'), fakePng);
      expect(server.requests, hasLength(3), reason: 'fresh again');
    });

    test('at most 4 downloads at once', () async {
      var active = 0, peak = 0;
      final client = MockClient((req) async {
        peak = (++active) > peak ? active : peak;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        active--;
        return http.Response.bytes(fakePng, 200, headers: {'content-type': 'image/png'});
      });
      final r = LogoRepository(
        apiKey: testKey,
        cacheDirectory: () async => Directory('${tmp.path}/service_logos'),
        client: client,
        clock: () => now,
      );
      await Future.wait([for (var i = 0; i < 10; i++) r.load('s$i.com')]);
      expect(peak, LogoRepository.maxConcurrent);
    });
  });

  group('LogoDiskCache.prune', () {
    test('drops old "missing" marks, very old logos, then the oldest logos over the cap', () async {
      final dir = Directory('${tmp.path}/c');
      final cache = LogoDiskCache(() async => dir);
      final kb = Uint8List(1024);
      await cache.writeLogo('old.com', kb, now.subtract(const Duration(days: 100)));
      await cache.writeLogo('a.com', kb, now.subtract(const Duration(days: 3)));
      await cache.writeLogo('b.com', kb, now.subtract(const Duration(days: 2)));
      await cache.writeLogo('c.com', kb, now.subtract(const Duration(days: 1)));
      await cache.writeMissing('gone.com', now.subtract(const Duration(days: 8)));
      await cache.writeMissing('nope.com', now.subtract(const Duration(days: 1)));
      File('${dir.path}/x.com.png.part').writeAsStringSync('half');

      await cache.prune(
        now: now,
        missingTtl: const Duration(days: 7),
        maxAge: const Duration(days: 90),
        maxBytes: 2500,
        keepBytes: 2048,
      );
      final left = dir.listSync().map((e) => e.uri.pathSegments.last).toSet();
      expect(left, {'b.com.png', 'c.com.png', 'nope.com.none'});
    });
  });
}
