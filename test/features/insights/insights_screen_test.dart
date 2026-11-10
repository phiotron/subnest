import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/domain/stats/insights_stats.dart';
import 'package:subnest/features/insights/insights_screen.dart';
import 'package:subnest/features/insights/widgets/category_sheet.dart';
import 'package:subnest/features/insights/widgets/month_bar_chart.dart';

import '../../domain/stats/device_sample.dart';
import '../../domain/stats/sample_data.dart';
import '../calendar/screen_harness.dart';

const _tall = ScreenSetup(tab: 2, height: 2600);

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('S9 with data (png 44, 45)', () {
    testWidgets('summary: total = paid + expected over the last 12 months', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      expect(find.text('Insights'), findsWidgets);
      expect(find.text('Total · last 12 months'), findsOneWidget);
      // Paid: 10 × 817,800 + 782,000 + Canva 1,390,000 + Google One 1,690,000 (ChatGPT in USD → ≈);
      // the big number adds this month's 876,800 still expected.
      expect(find.text('≈ ₫12,916,800'), findsOneWidget);
      expect(find.text('≈ ₫12,040,000'), findsOneWidget);
      expect(find.text('Expected, not yet confirmed'), findsOneWidget);
      expect(find.text('≈ ₫876,800'), findsOneWidget);
      expect(find.textContaining('more than'), findsNothing);
      expect(
        find.text('Not enough data from the 12 months before to compare'),
        findsOneWidget,
        reason: 'history starts Dec 2025',
      );
    });

    testWidgets('320dp × 200% VI: legend amounts sit under their labels', (tester) async {
      // Real phone (2026-11-05), largest display + font: "Đã trả" was squeezed to one letter per line.
      await pumpScreen(
        tester,
        const InsightsScreen(),
        setup: const ScreenSetup(tab: 2, width: 320, height: 2600, locale: 'vi', textScale: 2),
      );
      final label = find.text('Đã trả');
      final value = find.byKey(const ValueKey('legend-value-false'));
      expect(tester.getTopLeft(value).dy, greaterThanOrEqualTo(tester.getBottomLeft(label).dy));
      expect(tester.getTopLeft(value).dx, tester.getTopLeft(label).dx);
      expect(tester.takeException(), isNull);
    });

    testWidgets('range picker: this month compares with last month, this year', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      await tester.tap(find.text('This month'));
      await tester.pumpAndSettle();
      expect(find.text('Total · this month'), findsOneWidget);
      // Big number and % are the same quantity: 876,800 this month vs 782,000 in October.
      expect(find.text('≈ ₫876,800'), findsNWidgets(2));
      expect(find.text('12% more than last month'), findsOneWidget);
      await tester.tap(find.text('This year'));
      await tester.pumpAndSettle();
      expect(find.text('Total · this year'), findsOneWidget);
      expect(find.text('Not enough data from last year to compare'), findsOneWidget);
      expect(find.textContaining('more than last year'), findsNothing);
    });

    testWidgets('bar chart: tap a bar for its amounts; peaks explained', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      expect(find.text('By month'), findsOneWidget);
      expect(find.text('Tap a bar'), findsOneWidget);
      expect(
        find.text('February and March jump with the yearly Canva Pro and Google One 2TB renewals.'),
        findsOneWidget,
      );
      expect(
        find.bySemanticsLabel(RegExp(r'^Spending per month, paid and expected, Dec 2025 to Nov 2026')),
        findsOneWidget,
      );
      final nov = find.bySemanticsLabel('Nov 2026 · approximately ₫876,800 expected');
      expect(nov, findsOneWidget);
      await tester.tap(nov);
      await tester.pumpAndSettle();
      expect(find.text('Nov 2026 · ≈ ₫876,800 expected'), findsOneWidget);
      await tester.tap(find.bySemanticsLabel('Mar 2026 · approximately ₫2,507,800 paid'));
      await tester.pumpAndSettle();
      expect(find.text('Mar 2026 · ≈ ₫2,507,800 paid'), findsOneWidget);
    });

    testWidgets('donut legend lists every category with amount and percent', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      expect(find.text('By category'), findsOneWidget);
      expect(find.text('monthly equivalent, active plans'), findsOneWidget);
      expect(
        find.text(
          'Yearly and other non-monthly plans are spread evenly per month here, so this is not what you pay this month.',
        ),
        findsOneWidget,
        reason: 'Google One and Canva are yearly',
      );
      for (final (cat, pct) in [('AI', 47), ('Storage', 19), ('Telecom', 14), ('Software', 11), ('Video', 9)]) {
        expect(find.bySemanticsLabel(RegExp('^$cat: .* per month, $pct%\$')), findsOneWidget, reason: cat);
      }
      expect(find.text('≈ ₫1.07M'), findsOneWidget);
      expect(find.text('Music'), findsNothing, reason: 'Spotify is still a Trial');
    });

    testWidgets('tapping a category opens its sheet (png 47)', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      await tester.tap(find.bySemanticsLabel(RegExp('^Storage: ')));
      await tester.pumpAndSettle();
      expect(find.byType(CategorySheet), findsOneWidget);
      expect(find.text('19% of your monthly spend'), findsOneWidget);
      expect(find.text('Google One 2TB'), findsWidgets);
      expect(find.text('₫1,690,000'), findsOneWidget);
      expect(find.text('/year'), findsOneWidget);
      expect(
        find.text('Google One 2TB is billed ₫1,690,000/year — counted here as its monthly share.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.byType(CategorySheet), findsNothing);
    });

    testWidgets('a subscription in the sheet opens its detail', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      await tester.tap(find.bySemanticsLabel(RegExp('^Storage: ')));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: find.byType(CategorySheet), matching: find.text('iCloud+ 200GB')));
      await tester.pumpAndSettle();
      expect(pushed, ['/subscription/icloud']);
    });

    testWidgets('most expensive, savings and the overlap hint', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      expect(find.text('Most expensive'), findsOneWidget);
      final names = ['ChatGPT Plus', 'Viettel 5G', 'Google One 2TB', 'Canva Pro', 'Netflix Premium'];
      final ys = [for (final n in names) tester.getTopLeft(find.text(n).first).dy];
      expect(ys, orderedEquals([...ys]..sort()));
      expect(find.text('≈ ₫508,000'), findsWidgets);
      expect(find.text('You’re saving'), findsOneWidget);
      expect(find.text('₫1,479,000/year'), findsOneWidget);
      expect(find.text('by cancelling Duolingo Super and Apple Music'), findsOneWidget);
      expect(find.text('You pay for 2 video services'), findsOneWidget);
      expect(
        find.text('Netflix Premium and YouTube Premium Family together are ₫100,800/month. Need both?'),
        findsOneWidget,
      );
      await tester.tap(find.text('Canva Pro'));
      await tester.pumpAndSettle();
      expect(pushed, ['/subscription/canva']);
    });

    testWidgets('touch targets and contrast', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: _tall);
      await expectLater(tester, meetsGuideline(textContrastGuideline));
      // Legend rows and Top rows are ≥ 48dp; bars are 1/12 of the chart wide (see notes).
      expect(tester.getSize(find.bySemanticsLabel(RegExp('^AI: '))).height, greaterThanOrEqualTo(48));
      final top = find.ancestor(of: find.text('ChatGPT Plus').last, matching: find.byType(InkWell)).first;
      expect(tester.getSize(top).height, greaterThanOrEqualTo(48));
    });
  });

  group('phone data 2026-11-06 (USD Primary, VI) — fix-insights', () {
    Future<void> pump(WidgetTester tester, InsightsRange range) => pumpScreen(
      tester,
      InsightsScreen(initialRange: range),
      setup: const ScreenSetup(tab: 2, height: 2600, locale: 'vi'),
      subscriptions: DeviceSample.subscriptions,
      periods: DeviceSample.periods,
      today: DeviceSample.today,
      rates: DeviceSample.rates,
      primary: DeviceSample.primary,
    );

    testWidgets('#1 this month: big number and % are the same total', (tester) async {
      await pump(tester, InsightsRange.thisMonth);
      expect(find.text('Tổng · tháng này'), findsOneWidget);
      expect(find.text('Đã trả · tháng này'), findsNothing);
      // Nothing paid yet; ≈ $34.36 expected vs $30.67 in October → +12% (each line rounded to cents).
      expect(find.textContaining(RegExp(r'^≈ 34,36\s')), findsNWidgets(2), reason: 'headline + Expected row');
      expect(find.text('Nhiều hơn 12% so với tháng trước'), findsOneWidget);
    });

    testWidgets('#2 this year: no % against an untracked last year', (tester) async {
      await pump(tester, InsightsRange.thisYear);
      expect(find.textContaining('so với năm ngoái'), findsNothing);
      expect(find.text('Chưa đủ dữ liệu năm ngoái để so sánh'), findsOneWidget);
    });

    testWidgets('#3 by category says it is a monthly equivalent', (tester) async {
      await pump(tester, InsightsRange.thisMonth);
      expect(find.text('quy ra mỗi tháng, gói đang dùng'), findsOneWidget);
      expect(
        find.text(
          'Gói trả theo năm (hoặc không theo tháng) được chia đều ra mỗi tháng, nên đây không phải số phải trả trong tháng này.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('#4 peaks: month order, December worded as expected', (tester) async {
      await pump(tester, InsightsRange.thisYear);
      expect(
        find.text(
          'Tháng 3 tăng vọt vì gia hạn gói năm Google One 2TB. '
          'Tháng 12 dự kiến tăng vọt vì gia hạn gói năm ChatGPT Pro 100.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('12 tháng'));
      await tester.pumpAndSettle();
      expect(find.text('Tháng 2 và 3 tăng vọt vì gia hạn gói năm Canva Pro và Google One 2TB.'), findsOneWidget);
    });
  });

  testWidgets('empty state (png 46)', (tester) async {
    await pumpScreen(
      tester,
      const InsightsScreen(),
      setup: const ScreenSetup(tab: 2),
      subscriptions: const [],
      periods: const [],
    );
    expect(find.text('Add subscriptions to see insights'), findsOneWidget);
    expect(find.byType(MonthBarChart), findsNothing);
    await tester.tap(find.text('Add a subscription'));
    await tester.pumpAndSettle();
    expect(pushed, ['/catalog']);
  });

  testWidgets('only cancelled subscriptions: history and savings, no donut', (tester) async {
    await pumpScreen(
      tester,
      const InsightsScreen(),
      setup: _tall,
      subscriptions: [Sample.duolingo, Sample.appleMusic],
      periods: const [],
    );
    expect(find.text('By month'), findsOneWidget);
    expect(find.text('By category'), findsNothing);
    expect(find.text('Most expensive'), findsNothing);
    expect(find.text('You’re saving'), findsOneWidget);
  });

  testWidgets('Vietnamese wording', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: const ScreenSetup(tab: 2, height: 2600, locale: 'vi'));
    expect(find.text('Tổng · 12 tháng qua'), findsOneWidget);
    expect(find.text('Dự kiến, chưa xác nhận'), findsOneWidget);
    expect(find.text('Tháng 2 và 3 tăng vọt vì gia hạn gói năm Canva Pro và Google One 2TB.'), findsOneWidget);
    expect(find.text('quy ra mỗi tháng, gói đang dùng'), findsOneWidget);
    expect(find.text('≈ 1,07tr'), findsOneWidget);
    expect(find.text('Bạn trả 2 dịch vụ video'), findsOneWidget);
    expect(find.text('nhờ huỷ Duolingo Super và Apple Music'), findsOneWidget);
  });

  group('no overflow: 360/390 × EN/VI × light/dark × 100/130/200%', () {
    for (final s in layoutMatrix) {
      testWidgets(s.name, (tester) async {
        for (final range in InsightsRange.values) {
          await pumpScreen(tester, InsightsScreen(initialRange: range), setup: s);
          await scrollThrough(tester);
          expectNoLayoutErrors(tester);
        }
        await pumpScreen(tester, const InsightsScreen(), setup: s, subscriptions: const [], periods: const []);
        expectNoLayoutErrors(tester);
        // Category sheet.
        await pumpScreen(
          tester,
          const InsightsScreen(),
          setup: ScreenSetup(
            width: s.width,
            locale: s.locale,
            dark: s.dark,
            textScale: s.textScale,
            height: 3200,
            tab: 2,
          ),
        );
        await tester.tap(find.bySemanticsLabel(RegExp(s.locale == 'vi' ? '^Lưu trữ: ' : '^Storage: ')));
        await tester.pumpAndSettle();
        expectNoLayoutErrors(tester);
      });
    }
  });

  group('golden renders', skip: !uiShots, () {
    for (final dark in [false, true]) {
      final t = dark ? 'dark' : 'light';
      testWidgets('compare $t', (tester) async {
        final s = ScreenSetup(tab: 2, dark: dark);
        await pumpScreen(tester, const InsightsScreen(), setup: s);
        await shot('44-s9-insights-$t');
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -760));
        await tester.pumpAndSettle();
        await shot('45-s9-insights-more-$t');
        await pumpScreen(tester, const InsightsScreen(), setup: s, subscriptions: const [], periods: const []);
        await shot('46-s9-empty-$t');
        await pumpScreen(tester, const InsightsScreen(), setup: s);
        await tester.ensureVisible(find.bySemanticsLabel(RegExp('^Storage: ')));
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel(RegExp('^Storage: ')));
        await tester.pumpAndSettle();
        await shot('47-s9-category-$t');
        final vi = ScreenSetup(tab: 2, dark: dark, locale: 'vi', height: 2300);
        await pumpScreen(tester, const InsightsScreen(), setup: vi);
        await shot('vi-s9-insights-full-$t');
        for (final scale in [1.3, 2.0]) {
          for (final lang in ['vi', 'en']) {
            final big = ScreenSetup(
              tab: 2,
              dark: dark,
              locale: lang,
              width: 360,
              height: scale > 1.5 ? 3600 : 2700,
              textScale: scale,
            );
            await pumpScreen(tester, const InsightsScreen(), setup: big);
            await shot('s9-full-${big.name}');
          }
        }
      });
    }
  });
}
