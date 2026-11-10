import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/service_tile_logo.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/logos/app_logo_source.dart';
import 'package:subnest/data/logos/bundled_logos.g.dart';

import '../design_system_test.dart' show loadAppFonts, pumpUi;

/// A valid 8×8 PNG.
final Uint8List fakePng = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAgAAAAICAIAAABLbSncAAAAEUlEQVR4nGMQVHqHFTEMLQkABCxIQSPERjoAAAAASUVORK5CYII=',
);

/// In-memory logo source — no assets, no files. Records what tiles asked for.
class FakeLogoSource extends ChangeNotifier implements ServiceLogoSource {
  FakeLogoSource({Map<String, Uint8List>? services, Map<String, Uint8List>? custom})
    : services = services ?? {},
      custom = custom ?? {};

  final Map<String, Uint8List> services;
  final Map<String, Uint8List> custom;
  final asked = <String>[];

  @override
  ImageProvider? serviceLogo(String serviceId) {
    asked.add('service:$serviceId');
    final b = services[serviceId];
    return b == null ? null : MemoryImage(b);
  }

  @override
  ImageProvider? customLogo(String fileName) {
    asked.add('custom:$fileName');
    final b = custom[fileName];
    return b == null ? null : MemoryImage(b);
  }

  void changed() => notifyListeners();
}

const netflix = 0xFFE50914;

/// Lets the engine decode the PNG, then draws the next frames.
Future<void> decode(WidgetTester tester) async {
  await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

double logoOpacity(WidgetTester tester) => tester
    .widget<AnimatedOpacity>(find.descendant(of: find.byType(ServiceTileLogo), matching: find.byType(AnimatedOpacity)).first)
    .opacity;

ImageProvider? drawn(WidgetTester tester) {
  final f = find.byType(ServiceTileLogo);
  return f.evaluate().isEmpty ? null : tester.widget<ServiceTileLogo>(f.first).image;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadAppFonts();
  });

  testWidgets('no scope (default source) → monogram, no image', (tester) async {
    await pumpUi(tester, const ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix'));
    expect(find.text('N'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(tester.getSize(find.byType(ServiceTile)), const Size(40, 40));
  });

  testWidgets('no serviceId / customLogoFile → never asks', (tester) async {
    final source = FakeLogoSource();
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const ServiceTile(name: 'My gym', colorValue: 0xFF0F8B8D),
      ),
    );
    expect(source.asked, isEmpty);
    expect(find.byType(ServiceTileLogo), findsNothing);
    expect(find.text('MG'), findsOneWidget);
  });

  testWidgets('bundled logo by serviceId → drawn; badges, size, semantics kept', (tester) async {
    final source = FakeLogoSource(services: {'netflix': fakePng});
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const Row(
          children: [
            ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix', awaiting: true),
            SizedBox(width: 16),
            ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix', trial: true, size: 80),
          ],
        ),
      ),
      textScale: 2,
      settle: false,
    );
    await decode(tester);
    expect(find.byType(Image), findsNWidgets(2));
    expect(logoOpacity(tester), 1);
    expect(tester.getSize(find.byType(ServiceTile).first), const Size(40, 40));
    expect(tester.getSize(find.byType(ServiceTile).last), const Size(80, 80));
    expect(find.byIcon(AppIcons.trial), findsOneWidget);
    expect(find.bySemanticsLabel('Netflix'), findsNWidgets(2));
    expect(tester.getSemantics(find.byType(ServiceTile).first).label, 'Netflix');
    expect(find.text('N'), findsNWidgets(2), reason: 'monogram stays underneath (no blank frame)');
  });

  testWidgets('priority: explicit logo → bundled → custom → monogram', (tester) async {
    final bundled = Uint8List.fromList(fakePng), custom = Uint8List.fromList(fakePng), picked = Uint8List.fromList(fakePng);
    final source = FakeLogoSource(services: {'netflix': bundled}, custom: {'a.png': custom, 'b.png': custom});
    Future<void> show(Widget tile) => pumpUi(tester, ServiceLogoScope(source: source, child: tile), settle: false);

    await show(const ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix', customLogoFile: 'a.png'));
    expect((drawn(tester)! as MemoryImage).bytes, same(bundled));

    await show(const ServiceTile(name: 'Old', colorValue: netflix, serviceId: 'gone-from-catalog', customLogoFile: 'b.png'));
    expect((drawn(tester)! as MemoryImage).bytes, same(custom));

    await show(const ServiceTile(name: 'Gym', colorValue: netflix, customLogoFile: 'a.png'));
    expect((drawn(tester)! as MemoryImage).bytes, same(custom));

    await show(ServiceTile(name: 'Gym', colorValue: netflix, customLogoFile: 'a.png', logo: MemoryImage(picked)));
    expect((drawn(tester)! as MemoryImage).bytes, same(picked));

    await show(const ServiceTile(name: 'Gym', colorValue: netflix, customLogoFile: 'missing.png'));
    expect(drawn(tester), isNull);
    expect(find.text('G'), findsOneWidget);
  });

  testWidgets('source notifies (custom logo added / removed) → tile redraws', (tester) async {
    final source = FakeLogoSource();
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const ServiceTile(name: 'Gym', colorValue: 0xFF0F8B8D, customLogoFile: 'a.png'),
      ),
      settle: false,
    );
    expect(drawn(tester), isNull);
    source.custom['a.png'] = fakePng;
    source.changed();
    await tester.pump();
    expect(drawn(tester), isNotNull);
    source.custom.remove('a.png');
    source.changed();
    await tester.pump();
    expect(drawn(tester), isNull);
  });

  testWidgets('undecodable bytes → monogram (no white plate)', (tester) async {
    final source = FakeLogoSource(services: {'bad': Uint8List.fromList([1, 2, 3])});
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const ServiceTile(name: 'Bad', colorValue: netflix, serviceId: 'bad'),
      ),
      settle: false,
    );
    await decode(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ColoredBox).evaluate().where((e) => (e.widget as ColoredBox).color == Colors.white), isEmpty);
    expect(find.text('B'), findsOneWidget);
  });

  group('AppLogoSource (bundled assets)', () {
    late Directory tmp;
    setUp(() => tmp = Directory.systemTemp.createTempSync('logos'));
    tearDown(() => tmp.deleteSync(recursive: true));

    test('bundled ids → AssetImage under assets/logos/png; others → remote hook → null', () {
      final source = AppLogoSource(custom: CustomLogoStore(() async => tmp), bundled: {'netflix'});
      expect((source.serviceLogo('netflix')! as AssetImage).assetName, 'assets/logos/png/netflix.png');
      expect(source.serviceLogo('nope'), isNull);
      expect(source.hasBundled('netflix'), isTrue);
      var notified = 0;
      source.addListener(() => notified++);
      final remote = MemoryImage(fakePng);
      source.remote = (id) => id == 'nope' ? remote : null;
      expect(notified, 1);
      expect(source.serviceLogo('nope'), same(remote));
      expect(source.serviceLogo('netflix'), isA<AssetImage>(), reason: 'bundled wins over remote');
    });

    test('custom logo file → FileImage once the folder is known (store load notifies)', () async {
      final store = CustomLogoStore(() async => tmp);
      final source = AppLogoSource(custom: store, bundled: const {});
      expect(source.customLogo('a.png'), isNull, reason: 'folder not resolved yet');
      var notified = 0;
      source.addListener(() => notified++);
      await store.load();
      expect(notified, 1);
      final name = await store.save('sub-1', fakePng);
      expect((source.customLogo(name)! as FileImage).file.path, endsWith(name));
      expect(source.customLogo('../x.png'), isNull);
    });

    test('every bundled id is a Catalog service with a PNG; bundle stays small', () {
      final catalog = jsonDecode(File('assets/catalog/services.json').readAsStringSync()) as Map<String, Object?>;
      final ids = {for (final s in catalog['services']! as List) (s as Map)['id'] as String};
      expect(bundledLogoIds, isNotEmpty);
      var total = 0;
      for (final id in bundledLogoIds) {
        expect(ids, contains(id));
        final f = File('assets/logos/png/$id.png');
        expect(f.existsSync(), isTrue, reason: id);
        final b = f.readAsBytesSync();
        expect(b.sublist(1, 4), utf8.encode('PNG'), reason: id);
        total += b.length;
      }
      expect(total, lessThan(4 * 1024 * 1024));
      final extra = Directory('assets/logos/png').listSync().map((e) => e.uri.pathSegments.last.replaceAll('.png', ''));
      expect(extra.toSet().difference(bundledLogoIds), isEmpty, reason: 'PNG without an index entry');
    });

    testWidgets('real bundled asset decodes in a tile (no network)', (tester) async {
      final id = bundledLogoIds.first;
      final source = AppLogoSource(custom: CustomLogoStore(() async => tmp));
      await pumpUi(
        tester,
        ServiceLogoScope(
          source: source,
          child: ServiceTile(name: id, colorValue: netflix, serviceId: id, size: 80),
        ),
        settle: false,
      );
      await tester.runAsync(() async {
        await precacheImage(source.serviceLogo(id)!, tester.element(find.byType(ServiceTile)));
      });
      await decode(tester);
      expect(tester.takeException(), isNull);
      expect(logoOpacity(tester), 1);
    });
  });

  // Images for the notes: flutter test test/core/widgets/service_tile_logo_test.dart
  //   --dart-define=SHOTS=true --update-goldens  → notes/img/2026-11-10-l-logo/
  for (final dark in [false, true]) {
    testWidgets('golden: sizes and states with a logo (${dark ? 'dark' : 'light'})', (tester) async {
      final source = FakeLogoSource(services: {'netflix': fakePng, 'spotify': fakePng});
      await pumpUi(
        tester,
        ServiceLogoScope(
          source: source,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 20,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix', size: 24),
                ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix'),
                ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix', size: 56),
                ServiceTile(name: 'Netflix', colorValue: netflix, serviceId: 'netflix', size: 80),
                ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, serviceId: 'spotify', trial: true),
                ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, serviceId: 'spotify', awaiting: true),
                ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, serviceId: 'spotify', off: true),
                ServiceTile(name: 'Viettel', colorValue: 0xFFD21F3C, serviceId: 'no-logo', iconText: 'V'),
              ],
            ),
          ),
        ),
        dark: dark,
        size: const Size(390, 260),
        settle: false,
      );
      await decode(tester);
      expect(find.byType(Image), findsNWidgets(7));
      if (const bool.fromEnvironment('SHOTS')) {
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('../../../notes/img/2026-11-10-l-logo/tiles-${dark ? 'dark' : 'light'}.png'),
        );
      }
    });
  }
}
