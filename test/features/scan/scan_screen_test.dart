import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/features/home/home_list.dart';
import 'package:subnest/features/scan/scan_service.dart';

import '../home/ui_harness.dart';

// S13 Scan (mockups v14 114–121): intro → explainer → reading → results with Undo → Done hands the
// result to the Overview's Undo bar; nothing found; backing out of the pickers.

class FakeImages implements ScanImageSource {
  FakeImages({this.screens = const [], this.receipt});
  List<String> screens;
  String? receipt;
  var picks = 0;

  @override
  Future<List<String>> pickScreenshots() async {
    picks++;
    return screens;
  }

  @override
  Future<String?> takeReceiptPhoto() async => receipt;
}

class FakeReader implements ScanTextReader {
  FakeReader(this.pages);
  final Map<String, List<String>> pages;

  @override
  Future<List<String>> read(String path) async => pages[path] ?? const [];

  @override
  Future<void> close() async {}
}

/// Dropbox + Notion are new Catalog services; Netflix (due 4 Nov, own share ₫65,000) is confirmed.
const page1 = [
  'Subscriptions',
  'Dropbox',
  r'$11.99/month',
  'Renews on Nov 24, 2026',
  'Notion',
  r'$10.00/month',
  'Next payment Nov 25, 2026',
];
const page2 = ['Netflix', '65.000đ/tháng', 'Nov 4, 2026'];
const empty = ['Photos', 'Hello world'];

Finder text(String s) => find.text(s);

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
    await initializeDateFormatting('vi');
    await loadTestFonts();
  });

  Future<TestApp> pump(WidgetTester tester, FakeImages images, FakeReader reader, {Setup setup = const Setup()}) =>
      pumpApp(
        tester,
        setup: setup,
        location: '/scan',
        overrides: [
          scanImageSourceProvider.overrideWithValue(images),
          scanTextReaderProvider.overrideWithValue(reader),
        ],
      );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 20)));
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pumpAndSettle();
  }

  testWidgets('114 how it works: three steps, store buttons, privacy line, two actions', (tester) async {
    await pump(tester, FakeImages(), FakeReader({}));
    expect(text('Scan screenshots'), findsOneWidget);
    expect(text('Open your subscriptions page'), findsOneWidget);
    expect(text('Pick them here'), findsOneWidget);
    expect(text('Open Google Play'), findsOneWidget);
    expect(text('Open App Store'), findsOneWidget);
    expect(find.textContaining('never leave it'), findsOneWidget);
    expect(text('Choose screenshots'), findsOneWidget);
    expect(text('Photograph a receipt'), findsOneWidget);
    expect(layoutErrors, isEmpty);

    await tester.tap(text('Open Google Play'));
    await tester.pumpAndSettle();
    expect(launched.single, startsWith('https://play.google.com/'));
  });

  testWidgets('115 explainer comes first; "Not now" goes back; Continue opens the picker', (tester) async {
    final images = FakeImages();
    await pump(tester, images, FakeReader({}));
    await tester.tap(text('Choose screenshots'));
    await tester.pumpAndSettle();
    expect(text('Subnest only sees the photos you pick'), findsOneWidget);
    expect(images.picks, 0);
    await tester.tap(text('Not now'));
    await tester.pumpAndSettle();
    expect(text('Open your subscriptions page'), findsOneWidget);

    // Seen once: the next tap goes straight to the system picker.
    await tester.tap(text('Choose screenshots'));
    await tester.pumpAndSettle();
    expect(images.picks, 1);
    expect(text('Open your subscriptions page'), findsOneWidget); // backed out of the picker
    expect(layoutErrors, isEmpty);
  });

  testWidgets('118–120 results: added with Auto + Undo, confirmed, Undo one row, Done → Overview Undo bar', (
    tester,
  ) async {
    final images = FakeImages(screens: ['a.png', 'b.png']);
    final app = await pump(tester, images, FakeReader({'a.png': page1, 'b.png': page2}));
    await tester.tap(text('Choose screenshots'));
    await tester.pumpAndSettle();
    await tester.tap(text('Continue'));
    await settle(tester);

    expect(text('Scan results'), findsOneWidget);
    expect(find.textContaining('Added 2, confirmed 1'), findsOneWidget);
    expect(text('From 2 screenshots'), findsOneWidget);
    expect(text('ADDED'), findsOneWidget);
    expect(text('CONFIRMED'), findsOneWidget);
    expect(find.text('Auto'), findsNWidgets(2));
    expect(text('Undo'), findsNWidgets(3));
    expect(text('Done'), findsOneWidget);
    expect(text('Undo all'), findsOneWidget);
    expect(find.byType(CycleChip), findsWidgets);
    expect(layoutErrors, isEmpty);

    final subs = (await tester.runAsync(() => app.container.read(subscriptionRepositoryProvider).all()))!;
    expect(subs.where((s) => s.isAutoDetected).map((s) => s.serviceId).toSet(), {'dropbox', 'notion'});

    // Undo Notion's row → "Removed", the subscription is gone (and never auto-added again).
    await tester.tap(text('Undo').at(1));
    await settle(tester);
    expect(text('Removed'), findsOneWidget);
    expect(find.textContaining('Added 1, confirmed 1'), findsOneWidget);
    final after = (await tester.runAsync(() => app.container.read(subscriptionRepositoryProvider).all()))!;
    expect(after.where((s) => s.isAutoDetected).length, 1);

    // Done → Overview; the auto Undo bar offers Undo for what is kept.
    await tester.tap(text('Done'));
    await tester.pump();
    expect(app.container.read(homeAutoUndoProvider), isNotNull);
    await tester.pumpAndSettle();
    expect(find.byType(SnackBar), findsOneWidget);
  });

  testWidgets('"Undo all" removes every kept row', (tester) async {
    final app = await pump(tester, FakeImages(screens: ['a.png']), FakeReader({'a.png': page1}));
    await tester.tap(text('Choose screenshots'));
    await tester.pumpAndSettle();
    await tester.tap(text('Continue'));
    await settle(tester);
    expect(find.textContaining('Added 2'), findsOneWidget);
    await tester.tap(text('Undo all'));
    await settle(tester);
    expect(text('Removed'), findsNWidgets(2));
    expect(text('Undo all'), findsNothing);
    final subs = (await tester.runAsync(() => app.container.read(subscriptionRepositoryProvider).all()))!;
    expect(subs.where((s) => s.isAutoDetected), isEmpty);
  });

  testWidgets('121 nothing found: tips, other screenshots, add by hand', (tester) async {
    await pump(tester, FakeImages(screens: ['a.png']), FakeReader({'a.png': empty}));
    await tester.tap(text('Choose screenshots'));
    await tester.pumpAndSettle();
    await tester.tap(text('Continue'));
    await settle(tester);
    expect(text('No subscriptions found'), findsOneWidget);
    expect(text('In 1 picture · nothing was added'), findsOneWidget);
    expect(text('TRY THIS'), findsOneWidget);
    expect(text('Open the subscriptions list'), findsOneWidget);
    expect(text('Choose other screenshots'), findsOneWidget);
    expect(text('Add by hand'), findsOneWidget);
    expect(layoutErrors, isEmpty);
  });

  testWidgets('117 receipt photo goes straight to reading and results (From a receipt)', (tester) async {
    await pump(
      tester,
      FakeImages(receipt: 'r.jpg'),
      FakeReader({
        'r.jpg': ['Order receipt', 'Dropbox · Monthly', r'$11.99', 'Nov 3, 2026'],
      }),
    );
    await tester.tap(text('Photograph a receipt'));
    await settle(tester);
    expect(find.textContaining('Added 1'), findsOneWidget);
    expect(text('From a receipt'), findsOneWidget);
  });

  for (final setup in [
    const Setup(locale: 'vi'),
    const Setup(dark: true, textScale: 1.3, width: 360),
    const Setup(locale: 'vi', textScale: 2, width: 360),
  ]) {
    testWidgets('layout: ${setup.locale} dark=${setup.dark} x${setup.textScale} @${setup.width}', (tester) async {
      await pump(
        tester,
        FakeImages(screens: ['a.png', 'b.png']),
        FakeReader({'a.png': page1, 'b.png': page2}),
        setup: setup,
      );
      expect(layoutErrors, isEmpty, reason: 'intro');
      await tester.tap(find.byType(AppButton).first);
      await tester.pumpAndSettle();
      expect(layoutErrors, isEmpty, reason: 'explainer');
      await tester.tap(find.byType(AppButton).first);
      await settle(tester);
      expect(layoutErrors, isEmpty, reason: 'results');
    });
  }
}
