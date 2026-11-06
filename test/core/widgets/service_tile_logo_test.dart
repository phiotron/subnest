import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/service_tile_logo.dart';
import 'package:subnest/core/widgets/widgets.dart';

import '../../data/logos/logo_repository_test.dart' show fakePng;
import '../design_system_test.dart' show loadAppFonts, pumpUi;

/// In-memory logo source — no network, no files.
class FakeLogoSource implements ServiceLogoSource {
  FakeLogoSource({this.memory = const {}, this.enabled = true});

  @override
  final bool enabled;
  final Map<String, Uint8List> memory;
  final pending = <String, Completer<Uint8List?>>{};
  final asked = <String>[];

  @override
  Uint8List? peek(String logoDomain) => memory[logoDomain];

  @override
  Future<Uint8List?> load(String logoDomain) {
    asked.add(logoDomain);
    final hit = memory[logoDomain];
    if (hit != null) return Future.value(hit);
    return (pending[logoDomain] ??= Completer<Uint8List?>()).future;
  }
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

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadAppFonts();
  });

  testWidgets('no key in the build (default source) → monogram, nothing loaded', (tester) async {
    await pumpUi(tester, const ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com'));
    expect(find.text('N'), findsOneWidget);
    expect(find.byType(Image), findsNothing);
    expect(tester.getSize(find.byType(ServiceTile)), const Size(40, 40));
  });

  testWidgets('custom service (no logoDomain) never asks for a logo', (tester) async {
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

  testWidgets('logo in memory → drawn on the first frame, no fade; badges, size, semantics kept', (tester) async {
    final source = FakeLogoSource(memory: {'netflix.com': fakePng});
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const Row(
          children: [
            ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', awaiting: true),
            SizedBox(width: 16),
            ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', trial: true, size: 80),
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
    // Logo image adds no semantics of its own.
    final node = tester.getSemantics(find.byType(ServiceTile).first);
    expect(node.label, 'Netflix');
  });

  testWidgets('while loading the monogram shows; then the logo fades in over it', (tester) async {
    final source = FakeLogoSource();
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, logoDomain: 'spotify.com', size: 56),
      ),
      settle: false,
    );
    expect(source.asked, ['spotify.com']);
    expect(find.text('S'), findsOneWidget);
    expect(find.byType(Image), findsNothing);

    source.pending['spotify.com']!.complete(fakePng);
    await tester.pump(); // completes the load
    await tester.pump(); // rebuilds with the bytes
    expect(find.byType(Image), findsOneWidget);
    await decode(tester);
    expect(logoOpacity(tester), 1);
    expect(find.text('S'), findsOneWidget, reason: 'monogram stays underneath (no blank frame)');
  });

  testWidgets('no logo / offline → monogram stays', (tester) async {
    final source = FakeLogoSource();
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const ServiceTile(name: 'Viettel', colorValue: 0xFFD21F3C, logoDomain: 'viettel.vn', iconText: 'V'),
      ),
      settle: false,
    );
    source.pending['viettel.vn']!.complete(null);
    await tester.pumpAndSettle();
    expect(find.byType(Image), findsNothing);
    expect(find.text('V'), findsOneWidget);
  });

  testWidgets('a disabled source is never asked', (tester) async {
    final source = FakeLogoSource(memory: {'netflix.com': fakePng}, enabled: false);
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com'),
      ),
    );
    expect(source.asked, isEmpty);
    expect(find.byType(Image), findsNothing);
  });

  testWidgets('undecodable bytes → monogram (no white plate)', (tester) async {
    final source = FakeLogoSource(
      memory: {
        'bad.com': Uint8List.fromList([1, 2, 3]),
      },
    );
    await pumpUi(
      tester,
      ServiceLogoScope(
        source: source,
        child: const ServiceTile(name: 'Bad', colorValue: netflix, logoDomain: 'bad.com'),
      ),
      settle: false,
    );
    await decode(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(ColoredBox).evaluate().where((e) => (e.widget as ColoredBox).color == Colors.white), isEmpty);
    expect(find.text('B'), findsOneWidget);
  });

  // Images for the notes: flutter test test/core/widgets/service_tile_logo_test.dart
  //   --dart-define=SHOTS=true --update-goldens  → notes/img/2026-11-06-p3-logos/
  for (final dark in [false, true]) {
    testWidgets('golden: sizes and states with a logo (${dark ? 'dark' : 'light'})', (tester) async {
      final source = FakeLogoSource(memory: {'netflix.com': fakePng, 'spotify.com': fakePng});
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
                ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', size: 24),
                ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com'),
                ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', size: 56),
                ServiceTile(name: 'Netflix', colorValue: netflix, logoDomain: 'netflix.com', size: 80),
                ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, logoDomain: 'spotify.com', trial: true),
                ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, logoDomain: 'spotify.com', awaiting: true),
                ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, logoDomain: 'spotify.com', off: true),
                ServiceTile(name: 'Viettel', colorValue: 0xFFD21F3C, logoDomain: 'viettel.vn', iconText: 'V'),
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
          matchesGoldenFile('../../../notes/img/2026-11-06-p3-logos/tiles-${dark ? 'dark' : 'light'}.png'),
        );
      }
    });
  }
}
