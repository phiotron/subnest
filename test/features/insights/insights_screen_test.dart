import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/features/insights/category_month_screen.dart';
import 'package:subnest/features/insights/forecast_list_screen.dart';
import 'package:subnest/features/insights/insights_screen.dart';
import 'package:subnest/features/insights/widgets/insights_cards.dart';
import 'package:subnest/features/insights/widgets/month_bars.dart';
import 'package:subnest/features/insights/widgets/stats_parts.dart';

import '../calendar/screen_harness.dart';
import 'product_sample.dart';

final videoSlice = RegExp(r'^Video: [^,]+(,\d+)?[^,]*, \d+%$');

Finder rich(String text) => find.text(text, findRichText: true);

Future<void> scrollTo(WidgetTester tester, Finder f) async {
  await tester.scrollUntilVisible(f, 300, scrollable: find.byType(Scrollable).first);
  await tester.pumpAndSettle();
}

const insights = ScreenSetup(tab: 2);
const tall = ScreenSetup(tab: 2, height: 4200);

/// Mockup v14 074–086 with the product.md §6 data (today 10 Nov 2026, USD).
void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('074–078 November', () {
    testWidgets('074 cost card: ≈ \$144.89, −\$4.00 vs Oct, ≈ \$4.83 a day, Paid / Still to pay, 12 bars', (
      tester,
    ) async {
      await pumpScreen(tester, const InsightsScreen(), setup: insights);
      expect(find.text('Insights'), findsWidgets);
      expect(find.text('Month'), findsOneWidget);
      expect(find.text('Year'), findsOneWidget);
      expect(find.text('November 2026'), findsWidgets);
      expect(find.text('Projected'), findsOneWidget, reason: 'legend only — November is not ahead');
      expect(find.text('Cost of November'), findsOneWidget);
      expect(rich(r'≈ $144.89'), findsOneWidget);
      expect(find.text(r'$4.00 vs Oct'), findsOneWidget);
      expect(rich(r'10 subscriptions · ≈ $4.83 a day'), findsOneWidget);
      expect(find.text(r'$41.99'), findsOneWidget);
      expect(find.text(r'$74.58'), findsOneWidget);
      expect(find.text('Still to pay'), findsOneWidget);
      expect(find.bySemanticsLabel(r'Paid $41.99, still to pay $74.58'), findsOneWidget);
      expect(find.text('12 months'), findsWidgets);
      expect(find.bySemanticsLabel(r'November 2026: approximately $144.89'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp(r'^December 2026: approximately \$[\d.,]+, projected$')), findsOneWidget);
    });

    testWidgets('tapping a bar or ‹ › selects the month; every card follows', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: insights);
      await tester.tap(find.bySemanticsLabel(RegExp(r'^August 2026')));
      await tester.pumpAndSettle();
      expect(find.text('August 2026'), findsWidgets);
      expect(find.text('Cost of August'), findsOneWidget);
      expect(find.text('Not paid'), findsOneWidget, reason: '079: a past month shows Paid / Not paid');
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('September 2026'), findsWidgets);
      await tester.tap(find.byTooltip('Previous month'));
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
      expect(find.text('July 2026'), findsWidgets);
    });

    testWidgets('075 by category + most expensive of the month', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: tall);
      expect(find.text('By category'), findsOneWidget);
      for (final c in ['Video', 'AI', 'Health', 'Storage', 'Software', 'Music']) {
        expect(find.text(c), findsWidgets, reason: c);
      }
      expect(find.bySemanticsLabel(r'Health: $39.00, 27%'), findsOneWidget);
      expect(find.text('Most expensive'), findsOneWidget);
      expect(find.text('share of the month'), findsOneWidget);
      final top = find.byType(TopExpensiveCard);
      expect(find.descendant(of: top, matching: find.text('Gym')), findsOneWidget);
      expect(
        find.descendant(of: top, matching: find.text('Yearly')),
        findsNothing,
        reason: 'top 5 are monthly plans',
      );
    });

    testWidgets('076 price rises + next 12 months', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: tall);
      expect(find.text('Price rises'), findsWidgets);
      expect(rich(r'+$3.50 more a month than a year ago'), findsOneWidget);
      expect(rich(r'That’s $42.00 a year · Netflix Standard changed the most'), findsOneWidget);
      expect(find.text(r'$15.49 → $17.99'), findsOneWidget);
      expect(find.text(r'+$2.50'), findsOneWidget);
      expect(find.text(r'+$1.00'), findsOneWidget);
      expect(find.text('Review Netflix Standard'), findsOneWidget);
      expect(find.text('Next 12 months'), findsOneWidget);
      expect(find.text('Last 12 months'), findsOneWidget);
      expect(find.textContaining('a year compared with the last 12 months', findRichText: true), findsOneWidget);
      expect(find.textContaining('New this year', findRichText: true), findsOneWidget);
      expect(rich('Other'), findsOneWidget);
    });

    testWidgets('077 coming up 13 weeks ↔ 12 months (082), budgets', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: tall);
      expect(find.text('Coming up'), findsOneWidget);
      expect(find.text('W46'), findsOneWidget);
      expect(find.textContaining('Biggest: W', findRichText: true), findsOneWidget);
      await tester.tap(find.descendant(of: find.byType(ComingUpCard), matching: find.text('12 months')));
      await tester.pumpAndSettle();
      expect(find.text('Mar'), findsWidgets);
      expect(find.textContaining('renews)', findRichText: true), findsOneWidget, reason: '082: a yearly renewal peaks');
      expect(find.text('Budgets'), findsOneWidget);
      expect(find.text(r'$40.00 / $35.00'), findsOneWidget, reason: 'AI over budget');
      expect(find.bySemanticsLabel(r'AI: $40.00 of $35.00, over budget'), findsOneWidget);
    });

    testWidgets('078 savings, Not worth it, overlap hint', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: tall);
      expect(rich(r'You’re saving $191.87 a year'), findsOneWidget);
      expect(find.text('by cancelling 2 subscriptions'), findsOneWidget);
      expect(rich(r'Dropping the 2 you marked “Not worth it” would save $587.88 more a year.'), findsOneWidget);
      expect(find.text('You pay for 3 video services — do you need all of them?'), findsOneWidget);
    });

    testWidgets('(i) opens how the numbers work', (tester) async {
      await pumpScreen(tester, const InsightsScreen(), setup: insights);
      await tester.tap(find.bySemanticsLabel('How this is calculated'));
      await tester.pumpAndSettle();
      expect(find.text('How the numbers work'), findsOneWidget);
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
      expect(find.text('How the numbers work'), findsNothing);
    });
  });

  testWidgets('079 August: Paid / Not paid; Netflix still at the old price', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: tall);
    for (var i = 0; i < 3; i++) {
      await tester.tap(find.byTooltip('Previous month'));
    }
    await tester.pumpAndSettle();
    expect(find.text('Cost of August'), findsOneWidget);
    expect(find.text('Not paid'), findsOneWidget);
    expect(find.text('Still to pay'), findsNothing);
    expect(find.descendant(of: find.byType(TopExpensiveCard), matching: find.text(r'$15.49')), findsOneWidget);
  });

  testWidgets('080 December: Projected tag, Disney+ drops out after its pause', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: tall);
    await tester.tap(find.byTooltip('Next month'));
    await tester.pumpAndSettle();
    expect(find.text('December 2026'), findsWidgets);
    expect(find.byType(ProjectedTag), findsOneWidget);
    expect(find.descendant(of: find.byType(TopExpensiveCard), matching: find.text('Disney+')), findsNothing);
  });

  testWidgets('081 Year 2026: 12 months added up, ≈ per month', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: tall);
    await tester.tap(find.text('Year'));
    await tester.pumpAndSettle();
    expect(find.text('2026'), findsWidgets);
    expect(find.text('Cost in 2026'), findsOneWidget);
    expect(find.text('Each month of 2026'), findsOneWidget);
    expect(find.textContaining(' a month', findRichText: true), findsWidgets);
    expect(find.text('share of the year'), findsOneWidget);
    // A bar goes back to Month mode on that month.
    await tester.tap(find.bySemanticsLabel(RegExp(r'^March 2026')));
    await tester.pumpAndSettle();
    expect(find.text('Cost of March'), findsOneWidget);
  });

  testWidgets('083 tap a slice: Video in November', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: tall);
    await tester.tap(find.bySemanticsLabel(videoSlice));
    await tester.pumpAndSettle();
    expect(find.byType(CategoryMonthScreen), findsOneWidget);
    expect(find.text('Video · November'), findsOneWidget);
    expect(find.text('3 subscriptions · 22% of November'), findsOneWidget);
    expect(find.text('Netflix Standard'), findsOneWidget);
    expect(find.textContaining('Disney+ still counts in November'), findsOneWidget);
    await tester.tap(find.text('Netflix Standard'));
    await tester.pumpAndSettle();
    expect(pushed.last, '/subscription/netflix');
  });

  testWidgets('084 next 12 months as a list', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: tall);
    await tester.tap(find.descendant(of: find.byType(NextYearCard), matching: find.text('View as list')));
    await tester.pumpAndSettle();
    expect(find.byType(ForecastListScreen), findsOneWidget);
    expect(find.textContaining('expected charges from real due dates'), findsOneWidget);
    expect(find.text('NOVEMBER 2026'), findsOneWidget);
    expect(find.text('To confirm'), findsOneWidget, reason: 'Claude Pro, 8 Nov');
  });

  testWidgets('085 empty', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: insights, subscriptions: const [], periods: const []);
    expect(find.text('Add subscriptions to see insights'), findsOneWidget);
    expect(find.text('Browse services'), findsOneWidget);
    expect(find.byType(MonthBarsCard), findsNothing);
    await tester.tap(find.text('Browse services'));
    await tester.pumpAndSettle();
    expect(pushed, ['/catalog']);
  });

  testWidgets('086 only yearly plans: spread monthly, nothing to pay this month', (tester) async {
    await pumpScreen(
      tester,
      const InsightsScreen(),
      setup: insights,
      subscriptions: [Product.googleOne, Product.canva],
      periods: [
        for (final p in Product.periods)
          if (p.subscriptionId == 'googleone' || p.subscriptionId == 'canva') p,
      ],
    );
    expect(rich(r'≈ $18.33'), findsOneWidget);
    expect(find.text(r'$0.00'), findsNWidgets(2));
  });

  testWidgets('Vietnamese wording', (tester) async {
    await pumpScreen(tester, const InsightsScreen(), setup: const ScreenSetup(tab: 2, locale: 'vi', height: 4200));
    expect(find.text('Thống kê'), findsWidgets);
    expect(find.text('Tháng 11, 2026'), findsWidgets);
    expect(find.text('Chi phí tháng 11'), findsOneWidget);
    expect(find.textContaining('so với thg 10'), findsOneWidget);
    expect(find.text('Còn phải thanh toán'), findsOneWidget);
    expect(find.text('Theo danh mục'), findsOneWidget);
    expect(find.text('Tăng giá'), findsOneWidget);
    expect(find.text('12 tháng tới'), findsOneWidget);
    expect(find.text('T46'), findsOneWidget);
    expect(find.text('Bạn trả 3 dịch vụ video — cần hết không?'), findsOneWidget);
  });

  testWidgets('numbers on screen are spoken: no "≈" in labels, bars and rows labelled', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpScreen(tester, const InsightsScreen(), setup: tall);
    expect(find.bySemanticsLabel(RegExp('≈')), findsNothing);
    expect(
      find.bySemanticsLabel(RegExp(r'^Netflix Standard: \$15\.49 to \$17\.99, \+\$2\.50 a month$')),
      findsOneWidget,
    );
    handle.dispose();
  });

  group('no overflow: 360/390 × EN/VI × light/dark × 100/130/200% + 320 × 200%', () {
    for (final s in layoutMatrix) {
      testWidgets(s.name, (tester) async {
        final setup = ScreenSetup(
          tab: 2,
          width: s.width,
          height: s.height,
          locale: s.locale,
          dark: s.dark,
          textScale: s.textScale,
        );
        for (final screen in const [InsightsScreen(), InsightsScreen(initialYear: true)]) {
          await pumpScreen(tester, screen, setup: setup);
          await scrollThrough(tester);
          expectNoLayoutErrors(tester);
        }
        // 080 + the pushed pages (083, 084).
        await pumpScreen(tester, const InsightsScreen(), setup: setup);
        await tester.tap(find.byTooltip(s.locale == 'vi' ? 'Tháng sau' : 'Next month'));
        await tester.pumpAndSettle();
        await scrollThrough(tester);
        expectNoLayoutErrors(tester);
        await pumpScreen(tester, const InsightsScreen(), setup: setup);
        await scrollTo(tester, find.bySemanticsLabel(videoSlice));
        await tester.tap(find.bySemanticsLabel(videoSlice));
        await tester.pumpAndSettle();
        expectNoLayoutErrors(tester);
        Navigator.of(tester.element(find.byType(CategoryMonthScreen))).pop();
        await tester.pumpAndSettle();
        final list = find.descendant(
          of: find.byType(NextYearCard),
          matching: find.text(s.locale == 'vi' ? 'Xem dạng danh sách' : 'View as list'),
        );
        await scrollTo(tester, list);
        await tester.tap(list);
        await tester.pumpAndSettle();
        await scrollThrough(tester);
        expectNoLayoutErrors(tester);
        await pumpScreen(tester, const InsightsScreen(), setup: setup, subscriptions: const [], periods: const []);
        expectNoLayoutErrors(tester);
      });
    }
  });

  group('golden renders', skip: !uiShots, () {
    for (final dark in [false, true]) {
      final t = dark ? 'dark' : 'light';
      testWidgets('compare $t', (tester) async {
        final s = ScreenSetup(tab: 2, dark: dark, height: 4200);
        await pumpScreen(tester, const InsightsScreen(), setup: s);
        await shot('074-078-insights-november-$t');
        await tester.tap(find.byTooltip('Next month'));
        await tester.pumpAndSettle();
        await shot('080-insights-december-$t');
        await pumpScreen(tester, const InsightsScreen(initialYear: true), setup: s);
        await shot('081-insights-year-$t');
        await pumpScreen(
          tester,
          const InsightsScreen(),
          setup: ScreenSetup(tab: 2, dark: dark, height: 4200, locale: 'vi', width: 360),
        );
        await shot('074-insights-vi-360-$t');
        await pumpScreen(
          tester,
          const InsightsScreen(),
          setup: ScreenSetup(tab: 2, dark: dark, height: 6000, width: 320, textScale: 2),
        );
        await shot('074-insights-320-200-$t');
        await pumpScreen(tester, const InsightsScreen(), setup: s);
        await tester.tap(find.bySemanticsLabel(videoSlice));
        await tester.pumpAndSettle();
        await shot('083-insights-video-$t');
        await pumpScreen(tester, const InsightsScreen(), setup: s);
        await tester.tap(find.descendant(of: find.byType(NextYearCard), matching: find.text('View as list')));
        await tester.pumpAndSettle();
        await shot('084-insights-list-$t');
      });
    }
  });
}
