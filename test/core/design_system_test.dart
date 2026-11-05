import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      // November 2026 needs 6 week rows, December 5: the grid keeps its height so the arrows stay put.
      final novHeight = tester.getSize(find.byType(AppDatePicker)).height;
      final arrow = tester.getCenter(find.byTooltip('Next month'));
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('December 2026'), findsOneWidget);
      expect(tester.getSize(find.byType(AppDatePicker)).height, novHeight);
      expect(tester.getCenter(find.byTooltip('Next month')), arrow);
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

    for (var page = 0; page < GalleryScreen.pages.length; page++) {
      testWidgets('${GalleryScreen.pages[page]}: controls meet the 48dp touch target (S-50, Android guideline)', (
        tester,
      ) async {
        final handle = tester.ensureSemantics();
        // pumpUi adds 16px padding around the page → 422 wide = a 390dp phone.
        await pumpUi(tester, GalleryScreen(initialPage: page), size: const Size(422, 3000), scroll: false, settle: false);
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        handle.dispose();
      });
    }
  });

  group('form inputs (S-50: 48dp, 200% text)', () {
    test('amount format per locale and currency', () {
      final en = AmountFormat(currency: 'VND', localeName: 'en');
      final vi = AmountFormat(currency: 'VND', localeName: 'vi');
      final usd = AmountFormat(currency: 'USD', localeName: 'en');
      expect((en.prefix, en.suffix, en.group, en.decimals), ('₫', '', ',', 0));
      expect((vi.prefix, vi.suffix, vi.group), ('', 'đ', '.'));
      expect((usd.prefix, usd.decimal, usd.decimals, usd.zero), (r'$', '.', 2, '0.00'));
      expect(en.editText(260000), '260,000');
      expect(vi.editText(1690000), '1.690.000');
      expect(usd.editText(9.99), '9.99');
      expect(usd.editText(null), '');
      expect(vi.parse('1.690.000'), 1690000);
      expect(AmountFormat(currency: 'USD', localeName: 'vi').parse('12,5'), 12.5);
    });

    TextEditingValue edit(AmountFormat f, String old, int oldCaret, String text, int caret) =>
        AmountInputFormatter(f).formatEditUpdate(
          TextEditingValue(text: old, selection: TextSelection.collapsed(offset: oldCaret)),
          TextEditingValue(text: text, selection: TextSelection.collapsed(offset: caret)),
        );

    test('formatter groups while typing and keeps the caret', () {
      final en = AmountFormat(currency: 'VND', localeName: 'en');
      expect(edit(en, '123', 3, '1234', 4).text, '1,234');
      // Insert in the middle: "1|,234" + 5 -> "15,|234" (caret keeps its place counted from the right)
      final mid = edit(en, '1,234', 1, '15,234', 2);
      expect((mid.text, mid.selection.baseOffset), ('15,234', 3));
      // Backspace over the group separator deletes the digit before it.
      final back = edit(en, '1,234', 2, '1234', 1);
      expect((back.text, back.selection.baseOffset), ('234', 0));
      // Decimals: '.' or ',' typed -> locale decimal; extra digits cut; VND ignores separators.
      final usd = AmountFormat(currency: 'USD', localeName: 'en');
      expect(edit(usd, '12', 2, '12,', 3).text, '12.');
      expect(edit(usd, '12.5', 4, '12.567', 6).text, '12.56');
      final viUsd = AmountFormat(currency: 'USD', localeName: 'vi');
      expect(edit(viUsd, '1.234', 5, '1.234.', 6).text, '1.234,');
      expect(edit(en, '12', 2, '12.', 3).text, '12');
      expect(edit(en, '999,999,999,999', 15, '999,999,999,9999', 16).text, '999,999,999,999', reason: 'max 12 digits');
    });

    testWidgets('amount field reports major units and shows symbol, error and pill', (tester) async {
      double? value = 260000;
      var currencyTaps = 0;
      await pumpUi(
        tester,
        StatefulBuilder(
          builder: (context, set) => AmountField(
            label: 'Price',
            value: value,
            currency: 'VND',
            onChanged: (v) => set(() => value = v),
            onCurrencyTap: () => currencyTaps++,
            errorText: (value ?? 0) > 0 ? null : 'Price must be more than 0',
          ),
        ),
      );
      expect(find.text('₫'), findsOneWidget);
      expect(find.text('260,000'), findsOneWidget);
      expect(find.text('Price must be more than 0'), findsNothing);
      await tester.enterText(find.byType(TextField), '1234567');
      await tester.pumpAndSettle();
      expect(value, 1234567);
      expect(find.text('1,234,567'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(value, isNull);
      expect(find.text('Price must be more than 0'), findsOneWidget);
      await tester.tap(find.text('VND'));
      expect(currencyTaps, 1);
    });

    testWidgets('boxed amount field: pencil focuses the input; VI puts đ after', (tester) async {
      await pumpUi(
        tester,
        AmountField(boxed: true, value: 65000, currency: 'VND', onChanged: (_) {}, showEditButton: true, helper: 'x'),
        locale: 'vi',
      );
      expect(find.text('65.000'), findsOneWidget);
      expect(find.text('đ'), findsOneWidget);
      await tester.tap(find.byTooltip('Sửa số tiền'));
      await tester.pump();
      final editable = tester.state<EditableTextState>(find.byType(EditableText));
      expect(editable.widget.focusNode.hasFocus, isTrue);
    });

    testWidgets('radio rows select one; trailing moves under the text at 200%', (tester) async {
      var plan = 'b';
      Future<void> pump(double scale) => pumpUi(
        tester,
        StatefulBuilder(
          builder: (context, set) => RadioRowGroup<String>(
            value: plan,
            onChanged: (v) => set(() => plan = v),
            options: [
              RadioOption(
                value: 'a',
                title: 'Mobile',
                subtitle: '480p',
                trailing: RadioRow.price(context, '₫74,000', suffix: '/mo'),
              ),
              RadioOption(
                value: 'b',
                title: 'Premium',
                subtitle: '4K',
                trailing: RadioRow.price(context, '₫260,000', suffix: '/mo'),
              ),
            ],
          ),
        ),
        textScale: scale,
        size: const Size(360, 800),
      );
      await pump(1);
      await tester.tap(find.text('Mobile'));
      await tester.pumpAndSettle();
      expect(plan, 'a');
      expect(tester.getTopLeft(find.textContaining('74,000')).dy, lessThan(tester.getBottomLeft(find.text('480p')).dy));
      await pump(2);
      expect(tester.getTopLeft(find.textContaining('74,000')).dy, greaterThan(tester.getBottomLeft(find.text('480p')).dy));
      expect(tester.takeException(), isNull);
    });

    for (final dark in [false, true]) {
      testWidgets('Form inputs page at 200% VI 360 ${dark ? 'dark' : 'light'} has no overflow', (tester) async {
        await pumpUi(
          tester,
          GalleryScreen(initialPage: 6, initialDark: dark),
          size: const Size(360, 800),
          locale: 'vi',
          textScale: 2,
          scroll: false,
          settle: false,
        );
        for (var i = 0; i < 14; i++) {
          await tester.drag(find.byType(ListView), const Offset(0, -400));
          await tester.pump();
        }
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('form inputs meet the 48dp touch target (Android guideline, S-50)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpUi(
        tester,
        Column(
          children: [
            AmountField(label: 'Price', value: 20, currency: 'USD', onChanged: (_) {}, onCurrencyTap: () {}),
            AmountField(boxed: true, value: 65000, currency: 'VND', onChanged: (_) {}, showEditButton: true),
            RadioRowGroup<int>(
              value: 0,
              onChanged: (_) {},
              options: const [RadioOption(value: 0, title: 'A'), RadioOption(value: 1, title: 'B')],
            ),
            RadioRowGroup<int>(
              style: RadioRowStyle.flat,
              value: 0,
              onChanged: (_) {},
              options: const [RadioOption(value: 0, title: 'A'), RadioOption(value: 1, title: 'B')],
            ),
          ],
        ),
      );
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });
  });

  group('touch targets + screen readers (S-50)', () {
    testWidgets('visible sizes stay as in the mockup while hit areas are 48dp', (tester) async {
      await pumpUi(
        tester,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppChip(label: 'AI', selected: false, onTap: () {}),
            AppSegmentedControl<int>(
              selected: 0,
              onChanged: (_) {},
              segments: const [AppSegment(value: 0, label: 'A'), AppSegment(value: 1, label: 'B')],
            ),
            AppSegmentedControl<int>(
              mini: true,
              selected: 0,
              onChanged: (_) {},
              segments: const [AppSegment(value: 0, label: 'Month'), AppSegment(value: 1, label: 'Year')],
            ),
            AppToggle(value: true, onChanged: (_) {}),
            AppStepper(value: 2, onChanged: (_) {}),
          ],
        ),
      );
      // Layout (hit) sizes
      expect(tester.getSize(find.byType(AppChip)).height, AppTouch.min);
      expect(tester.getSize(find.byType(AppChip)).width, greaterThanOrEqualTo(AppTouch.min));
      expect(tester.getSize(find.byType(AppSegmentedControl<int>).first).height, AppTouch.min);
      expect(tester.getSize(find.byType(AppSegmentedControl<int>).last).height, AppTouch.min);
      expect(tester.getSize(find.byType(AppToggle)).height, AppTouch.min);
      expect(tester.getSize(find.byType(AppStepper)).height, AppTouch.min);
      // Visible sizes (mockup): chip pill 36, toggle 52×32, stepper circles 36.
      final pill = find.descendant(of: find.byType(AppChip), matching: find.byType(AnimatedContainer));
      expect(tester.getSize(pill).height, 36);
      final toggle = find.descendant(of: find.byType(AppToggle), matching: find.byType(AnimatedContainer)).first;
      expect(tester.getSize(toggle), const Size(52, 32));
      final circles = find.descendant(of: find.byType(AppStepper), matching: find.byType(Container));
      expect(tester.getSize(circles.first), const Size(36, 36));
    });

    testWidgets('date picker sheet: 48dp day cells even on a 360dp screen', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpUi(
        tester,
        Builder(
          builder: (context) => AppButton(
            label: 'open',
            onPressed: () => showAppDatePicker(
              context,
              initial: const LocalDate(2026, 11, 4),
              today: const LocalDate(2026, 11, 4),
              doneLabel: 'Done',
            ),
          ),
        ),
        size: const Size(360, 800),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      final cell = find.ancestor(of: find.text('20'), matching: find.byType(GestureDetector)).first;
      expect(tester.getSize(cell).width, greaterThanOrEqualTo(AppTouch.min));
      expect(tester.getSize(cell).height, greaterThanOrEqualTo(AppTouch.min));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('screen readers can activate tabs, day cells and the currency pill', (tester) async {
      final handle = tester.ensureSemantics();
      var tab = 0;
      LocalDate? day;
      var currency = 0;
      await pumpUi(
        tester,
        Column(
          children: [
            AppTabBar(
              currentIndex: tab,
              onSelected: (i) => tab = i,
              items: const [
                AppTabItem(icon: AppIcons.tabHome, label: 'Overview'),
                AppTabItem(icon: AppIcons.tabCalendar, label: 'Calendar'),
              ],
            ),
            AppDatePicker(selected: null, today: const LocalDate(2026, 11, 4), onChanged: (d) => day = d),
            AmountField(value: 1, currency: 'VND', onChanged: (_) {}, onCurrencyTap: () => currency++),
          ],
        ),
      );
      void tapNode(Finder f) {
        final node = tester.getSemantics(f);
        final owner = tester.renderObject(find.byType(AppTabBar)).owner!.semanticsOwner!;
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue, reason: node.toString());
        owner.performAction(node.id, SemanticsAction.tap);
      }

      tapNode(find.bySemanticsLabel('Calendar'));
      tapNode(find.bySemanticsLabel('20 Nov 2026'));
      tapNode(find.bySemanticsLabel(RegExp('Change currency')));
      expect((tab, day, currency), (1, const LocalDate(2026, 11, 20), 1));
      handle.dispose();
    });
  });

  group('subscription row at large text (bug from session G)', () {
    Widget rows() => AppGroup(
      children: [
        SubscriptionRow(
          name: 'Netflix Premium',
          colorValue: 0xFFE50914,
          state: SubscriptionRowState.awaiting,
          awaitingCount: 2,
          sharedCount: 4,
          amount: '₫65,000',
          amountMeta: 'plan ₫260,000',
        ),
        const SubscriptionRow(
          name: 'Viettel 5G',
          colorValue: 0xFFD21F3C,
          state: SubscriptionRowState.awaiting,
          amount: '₫150,000',
          amountMeta: '/month',
        ),
        const SubscriptionRow(
          name: 'Spotify',
          colorValue: 0xFF1DB954,
          state: SubscriptionRowState.trial,
          meta: 'ends in 2 days',
          amount: '₫59,000',
          amountMeta: '/month',
        ),
      ],
    );

    // pumpUi pads 16px each side → screen width = size − 32.
    for (final (screen, scale, locale) in [
      (360.0, 1.3, 'en'),
      (360.0, 1.3, 'vi'),
      (390.0, 2.0, 'en'),
      (390.0, 2.0, 'vi'),
      (360.0, 2.0, 'vi'),
    ]) {
      testWidgets('no overflow at ${screen.toInt()}dp × ${(scale * 100).round()}% $locale', (tester) async {
        await pumpUi(tester, rows(), size: Size(screen + 32, 1200), textScale: scale, locale: locale);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('amount sits beside the name at 100%, under it when there is no room', (tester) async {
      await pumpUi(tester, rows(), size: const Size(422, 900));
      final name = tester.getRect(find.text('Netflix Premium'));
      expect(tester.getRect(find.text('₫65,000')).top, lessThan(name.bottom), reason: 'same line at 100%');
      await pumpUi(tester, rows(), size: const Size(422, 1200), textScale: 2);
      final badge = tester.getRect(find.text('To confirm').first);
      expect(tester.getRect(find.text('₫65,000')).top, greaterThan(badge.bottom), reason: 'stacked at 200%');
    });
  });
}
