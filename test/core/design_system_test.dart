import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/l10n/l10n.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/dev/gallery_screen.dart';

/// Wraps [child] in a MaterialApp with the Subnest theme + localizations.
Future<void> pumpUi(
  WidgetTester tester,
  Widget child, {
  bool dark = false,
  String locale = 'en',
  double textScale = 1,
  Size size = const Size(390, 844),
  bool scroll = true,
  bool settle = true,
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(locale),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, w) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: w!,
      ),
      home: Scaffold(
        body: scroll
            ? SingleChildScrollView(padding: const EdgeInsets.all(16), child: child)
            : Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump(const Duration(milliseconds: 500));
  }
}

AppLocalizations l10n(String code) => lookupAppLocalizations(Locale(code));

/// Loads the bundled Be Vietnam Pro so text measures like on a device (the default test font
/// draws every glyph 1em wide, which would report false overflows).
Future<void> loadAppFonts() async {
  final loader = FontLoader(AppType.fontFamily);
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    final bytes = File('assets/fonts/BeVietnamPro/BeVietnamPro-$w.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadAppFonts();
  });

  group('tokens → theme', () {
    test('generated colours match tokens.json', () {
      expect(AppColors.light.brand, const Color(0xFF0E6B63));
      expect(AppColors.dark.brand, const Color(0xFF46CDB9));
      expect(AppColors.light.focus, AppColors.light.brand, reason: '{brand} alias resolved');
      expect(AppColors.dark.focus, AppColors.dark.brand);
      expect(AppColors.light.scrim, const Color(0x660B1114));
      expect(AppColors.light.tileRing, const Color(0x0F000000));
      expect(AppColors.tilePalette, hasLength(12));
      expect(AppColors.light.byName['surface-sheet'], AppColors.light.surfaceSheet);
    });

    test('ColorScheme mapping (design README § Flutter mapping)', () {
      for (final (theme, c) in [(AppTheme.light(), AppColors.light), (AppTheme.dark(), AppColors.dark)]) {
        final s = theme.colorScheme;
        expect(s.primary, c.brand);
        expect(s.onPrimary, c.onBrand);
        expect(s.primaryContainer, c.brandSoft);
        expect(s.onPrimaryContainer, c.onBrandSoft);
        expect(s.surface, c.surface);
        expect(s.surfaceContainerHighest, c.surface2);
        expect(s.onSurface, c.ink);
        expect(s.onSurfaceVariant, c.inkMuted);
        expect(s.outlineVariant, c.line);
        expect(s.outline, c.lineStrong);
        expect(s.error, c.danger);
        expect(theme.scaffoldBackgroundColor, c.bg);
        expect(theme.extension<AppColors>(), c);
        expect(theme.extension<AppElevation>(), isNotNull);
        expect(theme.textTheme.bodyMedium!.fontFamily, AppType.fontFamily);
      }
      expect(AppTheme.dark().brightness, Brightness.dark);
    });

    test('type scale and dark card ring', () {
      expect(AppType.display.fontSize, 40);
      expect(AppType.display.height! * 40, closeTo(48, .001));
      expect(AppType.display.letterSpacing, closeTo(-0.8, .001));
      expect(AppType.caption.fontWeight, FontWeight.w600);
      expect(AppElevation.dark.card.single.spreadRadius, 1, reason: 'dark card = 1px line ring');
      expect(AppType.titleSm.tabular.fontFeatures, contains(const FontFeature.tabularFigures()));
    });
  });

  group('ServiceTile', () {
    test('letter colour reaches the higher contrast for every custom tile', () {
      const expectLight = {0xFFD21F3C, 0xFF2856D8, 0xFF7A3FE0, 0xFF8A5A3C, 0xFF2D3438};
      for (final tile in AppColors.tilePalette) {
        final on = ServiceTile.onTileColor(tile);
        expect(
          on,
          expectLight.contains(tile.toARGB32()) ? AppColors.light.onTileLight : AppColors.light.onTileDark,
          reason: tile.toString(),
        );
        expect(ServiceTile.contrast(tile, on), greaterThanOrEqualTo(4.5), reason: tile.toString());
      }
    });

    test('radius and monogram size per tile size', () {
      expect(ServiceTile.radiusFor(24), 7);
      expect(ServiceTile.radiusFor(40), 11);
      expect(ServiceTile.radiusFor(80), 22);
      expect(ServiceTile.fontSizeFor(40, 1), 19);
      expect(ServiceTile.fontSizeFor(40, 2), 15);
      expect(ServiceTile.initials('YouTube Premium'), 'YP');
    });

    testWidgets('does not grow with system text and keeps its badges', (tester) async {
      await pumpUi(
        tester,
        const Row(
          children: [
            ServiceTile(name: 'Viettel', colorValue: 0xFFD21F3C, awaiting: true),
            SizedBox(width: 16),
            ServiceTile(name: 'Spotify', colorValue: 0xFF1DB954, trial: true, size: 56),
          ],
        ),
        textScale: 1.3,
      );
      expect(tester.getSize(find.byType(ServiceTile).first), const Size(40, 40));
      expect(tester.getSize(find.byType(ServiceTile).last), const Size(56, 56));
      expect(find.text('V'), findsOneWidget);
      expect(find.byIcon(AppIcons.trial), findsOneWidget);
      expect(find.bySemanticsLabel('Viettel'), findsOneWidget);
    });
  });

  group('formatters', () {
    const today = LocalDate(2026, 11, 4);
    test('relative dates up to 30 days, then a date', () {
      final en = l10n('en'), vi = l10n('vi');
      expect(AppDates.relative(en, today, today: today), 'today');
      expect(AppDates.relative(en, today.addDays(1), today: today), 'tomorrow');
      expect(AppDates.relative(en, today.addDays(3), today: today), 'in 3 days');
      expect(AppDates.relative(vi, today.addDays(3), today: today), 'còn 3 ngày');
      expect(AppDates.relative(en, today.addDays(30), today: today), 'in 30 days');
      expect(AppDates.relative(en, today.addDays(-2), today: today), '2 days ago');
      expect(AppDates.relative(en, const LocalDate(2026, 12, 20), today: today), '20 Dec');
      expect(AppDates.relative(en, const LocalDate(2027, 2, 2), today: today), '2 Feb 2027');
      expect(AppDates.relative(vi, const LocalDate(2027, 2, 2), today: today), '2/2/2027');
    });

    test('weekday and full dates', () {
      final en = l10n('en'), vi = l10n('vi');
      expect(AppDates.weekdayShort(en, const LocalDate(2026, 11, 6), today: today), 'Fri, 6 Nov');
      expect(AppDates.weekdayShort(vi, const LocalDate(2026, 11, 6), today: today), 'T6, 6/11');
      expect(AppDates.weekdayShort(vi, const LocalDate(2026, 11, 8), today: today), 'CN, 8/11');
      expect(AppDates.weekdayLong(en, today), 'Wednesday, 4 November');
      expect(AppDates.weekdayLong(vi, today), 'Thứ Tư, 4 tháng 11');
      expect(AppDates.full(en, today), '4 Nov 2026');
      expect(AppDates.full(vi, today), '04/11/2026');
      expect(AppDates.monthTitle(vi, 2026, 12), 'Tháng 12 2026');
      expect(AppDates.weekdayHeaders(vi).first, 'T2');
    });

    test('per-cycle suffix and money by locale', () {
      final en = l10n('en'), vi = l10n('vi');
      expect(perCycle(en, const BillingCycle.monthly()), '/month');
      expect(perCycle(vi, const BillingCycle.yearly()), '/năm');
      expect(perCycle(en, const BillingCycle.quarterly()), '/quarter');
      expect(perCycle(en, const BillingCycle(2, CycleUnit.week)), '/2 weeks');
      expect(en.amount(260000, 'VND'), '₫260,000');
      expect(vi.amount(260000, 'VND'), '260.000đ');
      expect(en.amount(20, 'USD'), r'$20.00');
    });
  });

  group('components', () {
    testWidgets('date picker starts weeks on Monday and reports taps', (tester) async {
      LocalDate? picked;
      await pumpUi(
        tester,
        AppDatePicker(
          selected: const LocalDate(2026, 11, 4),
          today: const LocalDate(2026, 11, 4),
          onChanged: (d) => picked = d,
        ),
      );
      expect(find.text('November 2026'), findsOneWidget);
      // 1 Nov 2026 is a Sunday → last column; 2 Nov (Monday) starts the next row.
      expect(tester.getCenter(find.text('1')).dx, greaterThan(tester.getCenter(find.text('2')).dx));
      expect(tester.getCenter(find.text('2')).dx, closeTo(tester.getCenter(find.text('9')).dx, .1));
      await tester.tap(find.text('20'));
      expect(picked, const LocalDate(2026, 11, 20));
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('December 2026'), findsOneWidget);
    });

    testWidgets('subscription row swipe reveals Confirm + Cancel; full swipe confirms', (tester) async {
      var confirmed = 0, cancelled = 0, opened = 0;
      await pumpUi(
        tester,
        AppGroup(
          children: [
            SubscriptionRow(
              name: 'Netflix Premium',
              colorValue: 0xFFE50914,
              state: SubscriptionRowState.awaiting,
              awaitingCount: 2,
              sharedCount: 4,
              amount: '₫65,000',
              amountMeta: 'plan ₫260,000',
              onTap: () => opened++,
              onConfirm: () => confirmed++,
              onCancel: () => cancelled++,
            ),
          ],
        ),
      );
      expect(find.text('To confirm'), findsOneWidget);
      expect(find.text('×2'), findsOneWidget);
      expect(find.text('÷4'), findsOneWidget);
      await tester.tap(find.text('Netflix Premium'));
      expect(opened, 1);

      await tester.drag(find.text('Netflix Premium'), const Offset(-140, 0));
      await tester.pumpAndSettle();
      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(cancelled, 1);
      expect(find.text('Confirm'), findsNothing, reason: 'closes after an action');

      await tester.drag(find.text('Netflix Premium'), const Offset(-300, 0));
      await tester.pumpAndSettle();
      expect(confirmed, 1, reason: 'full swipe triggers the first action');
    });

    testWidgets('cancelled rows have no swipe actions', (tester) async {
      await pumpUi(
        tester,
        SubscriptionRow(
          name: 'Canva',
          colorValue: 0xFF7D2AE8,
          state: SubscriptionRowState.cancelled,
          meta: 'Cancelled 4 Nov 2026',
          amount: '₫1,390,000',
          onCancel: () {},
        ),
      );
      await tester.drag(find.text('Canva'), const Offset(-200, 0));
      await tester.pumpAndSettle();
      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets('hero total counts up to the new value', (tester) async {
      Widget hero(double v) => SpendHero(
        label: 'Monthly spend',
        amount: v,
        approx: true,
        format: (x) => '₫${x.round()}',
        onPeriodChanged: (_) {},
      );
      await pumpUi(tester, hero(100));
      expect(find.text('₫100'), findsOneWidget);
      expect(find.text('≈'), findsOneWidget);
      await pumpUi(tester, hero(1200));
      // pumpUi settles: final value shown.
      expect(find.text('₫1200'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
    });

    testWidgets('spend strip segments fill the strip height, proportional widths', (tester) async {
      await pumpUi(
        tester,
        const SpendStrip(
          segments: [
            SpendSegment(color: Color(0xFF202123), value: 300),
            SpendSegment(color: Color(0xFFE50914), value: 100),
          ],
        ),
      );
      final boxes = find.descendant(of: find.byType(SpendStrip), matching: find.byType(DecoratedBox));
      final a = tester.getSize(boxes.at(0)), b = tester.getSize(boxes.at(1));
      expect(a.height, 8);
      expect(b.height, 8);
      expect(a.width / b.width, closeTo(3, .05));
    });

    testWidgets('count-up passes through intermediate values', (tester) async {
      final v = ValueNotifier<double>(0);
      await pumpUi(
        tester,
        ValueListenableBuilder<double>(
          valueListenable: v,
          builder: (_, x, _) => CountUpText(value: x, format: (n) => 'N${n.round()}'),
        ),
      );
      v.value = 1000;
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      final mid = tester.widget<Text>(find.textContaining('N')).data!;
      expect(mid, isNot('N0'));
      expect(mid, isNot('N1000'));
      await tester.pumpAndSettle();
      expect(find.text('N1000'), findsOneWidget);
    });

    testWidgets('banner action drops under the text when narrow', (tester) async {
      Future<(double, double)> layout(Size size) async {
        await pumpUi(
          tester,
          AppBanner(
            kind: BannerKind.neutral,
            icon: AppIcons.remindersOff,
            title: 'Nhắc nhở đang tắt',
            body: 'Bạn sẽ không được báo trước khi gia hạn hay hết dùng thử.',
            actionLabel: 'Bật lại',
            onAction: () {},
          ),
          size: size,
          locale: 'vi',
        );
        return (tester.getTopLeft(find.text('Bật lại')).dy, tester.getTopLeft(find.text('Nhắc nhở đang tắt')).dy);
      }

      final (wideAction, wideTitle) = await layout(const Size(600, 800));
      expect(wideAction - wideTitle, lessThan(30), reason: 'beside the text');
      final (narrowAction, _) = await layout(const Size(280, 800));
      final bodyBottom = tester.getBottomLeft(find.textContaining('Bạn sẽ không')).dy;
      expect(narrowAction, greaterThan(bodyBottom), reason: 'dropped under the text');
    });

    testWidgets('segmented control, toggle and stepper report changes', (tester) async {
      var seg = 0;
      var on = false;
      var n = 2;
      await pumpUi(
        tester,
        StatefulBuilder(
          builder: (context, set) => Column(
            children: [
              AppSegmentedControl<int>(
                selected: seg,
                onChanged: (v) => set(() => seg = v),
                segments: const [
                  AppSegment(value: 0, label: 'Active', count: 7),
                  AppSegment(value: 1, label: 'Trials', count: 1),
                ],
              ),
              AppToggle(value: on, onChanged: (v) => set(() => on = v)),
              AppStepper(value: n, min: 2, onChanged: (v) => set(() => n = v)),
            ],
          ),
        ),
      );
      await tester.tap(find.textContaining('Trials'));
      await tester.tap(find.byType(AppToggle));
      await tester.tap(find.byIcon(AppIcons.add));
      await tester.pumpAndSettle();
      expect((seg, on, n), (1, true, 3));
      await tester.tap(find.byIcon(AppIcons.remove));
      await tester.tap(find.byIcon(AppIcons.remove)); // at min: ignored
      await tester.pumpAndSettle();
      expect(n, 2);
    });

    testWidgets('tab bar: labels fixed size, selection callback', (tester) async {
      var index = 0;
      await pumpUi(
        tester,
        StatefulBuilder(
          builder: (context, set) => AppTabBar(
            currentIndex: index,
            onSelected: (i) => set(() => index = i),
            items: const [
              AppTabItem(icon: AppIcons.tabHome, label: 'Overview'),
              AppTabItem(icon: AppIcons.tabCalendar, label: 'Calendar'),
              AppTabItem(icon: AppIcons.tabInsights, label: 'Insights'),
              AppTabItem(icon: AppIcons.tabSettings, label: 'Settings'),
            ],
          ),
        ),
        textScale: 1.3,
      );
      expect(tester.getSize(find.byType(AppTabBar)).height, AppSize.tabbarH);
      await tester.tap(find.text('Insights'));
      await tester.pumpAndSettle();
      expect(index, 2);
    });

    testWidgets('dialog and sheet open with the theme surfaces', (tester) async {
      await pumpUi(
        tester,
        Builder(
          builder: (context) => Column(
            children: [
              AppButton(
                label: 'dialog',
                onPressed: () => showAppDialog<void>(
                  context,
                  title: 'Delete Netflix?',
                  body: 'History goes too.',
                  actions: [AppButton.danger(label: 'Delete', expand: true, onPressed: () => Navigator.pop(context))],
                ),
              ),
              AppButton(
                label: 'sheet',
                onPressed: () => showAppSheet<void>(context, builder: (_) => const Text('Sheet body')),
              ),
            ],
          ),
        ),
        dark: true,
      );
      await tester.tap(find.text('dialog'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Netflix?'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Netflix?'), findsNothing);
      await tester.tap(find.text('sheet'));
      await tester.pumpAndSettle();
      expect(find.text('Sheet body'), findsOneWidget);
    });
  });

  group('gallery (overflow at 360 × 800, VI, 130%, light + dark)', () {
    for (var page = 0; page < GalleryScreen.pages.length; page++) {
      for (final dark in [false, true]) {
        testWidgets('${GalleryScreen.pages[page]} ${dark ? 'dark' : 'light'}', (tester) async {
          await pumpUi(
            tester,
            GalleryScreen(initialPage: page, initialDark: dark),
            size: const Size(360, 800),
            locale: 'vi',
            textScale: 1.3,
            scroll: false,
            settle: false, // the loading button spins forever
          );
          // Scroll through the whole page so every component lays out.
          final list = find.byType(ListView);
          for (var i = 0; i < 12; i++) {
            await tester.drag(list, const Offset(0, -500));
            await tester.pump();
          }
          expect(tester.takeException(), isNull);
        });
      }
    }

    for (var page = 1; page < GalleryScreen.pages.length; page++) {
      testWidgets('${GalleryScreen.pages[page]}: controls meet the 44px touch target (iOS guideline)', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpUi(tester, GalleryScreen(initialPage: page), size: const Size(390, 3000), scroll: false, settle: false);
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        handle.dispose();
      });
    }
  });
}
