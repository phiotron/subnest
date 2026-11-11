import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/features/calendar/calendar_screen.dart';
import 'package:subnest/features/calendar/widgets/month_grid.dart';

import 'screen_harness.dart';

Finder dayCell(int day) => find.descendant(of: find.byType(MonthGrid), matching: find.text('$day')).first;

/// Mockup v14 071–073 with the product.md §6 data (today Tue 10 Nov 2026, USD).
void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('071 month view — November', () {
    testWidgets('header: real money of the month, counts, legend, today', (tester) async {
      await pumpScreen(tester, const CalendarScreen());
      expect(find.text('Calendar'), findsWidgets);
      expect(find.text('November 2026'), findsOneWidget);
      expect(find.text('November:'), findsOneWidget);
      expect(find.text(r'≈ $116.57'), findsOneWidget, reason: r'Paid $41.99 + Still to pay $74.58');
      expect(find.text('2 paid · 5 to come'), findsOneWidget);
      for (final w in ['Mon', 'Sun', 'Paid', 'Expected', 'To confirm']) {
        expect(find.text(w), findsWidgets, reason: w);
      }
      expect(find.text('List'), findsOneWidget);
      expect(find.text('TODAY · TUE, 10 NOV'), findsOneWidget);
      expect(find.text('Nothing due this day.'), findsOneWidget);
      // Mini logos: up to 3 a day, real tiles.
      expect(find.byType(MiniLogo), findsNWidgets(7));
    });

    testWidgets('a day lists its rows with price + cycle chip; a row opens the subscription', (tester) async {
      await pumpScreen(tester, const CalendarScreen());
      await tester.tap(dayCell(12));
      await tester.pumpAndSettle();
      expect(find.text('THU, 12 NOV'), findsOneWidget);
      expect(find.text('ChatGPT Plus'), findsOneWidget);
      expect(find.text(r'$20.00'), findsOneWidget);
      expect(find.widgetWithText(CycleChip, 'Monthly'), findsOneWidget);
      await tester.tap(dayCell(13));
      await tester.pumpAndSettle();
      expect(find.text('First charge after trial'), findsOneWidget);
      await tester.tap(dayCell(8));
      await tester.pumpAndSettle();
      expect(find.text('Claude Pro'), findsOneWidget);
      expect(find.widgetWithText(StatusBadge, 'To confirm'), findsOneWidget);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Claude Pro'));
      await tester.pumpAndSettle();
      expect(pushed.last, '/subscription/claude');
    });

    testWidgets('day cells: ≥ 48dp, labelled for screen readers', (tester) async {
      await pumpScreen(tester, const CalendarScreen(), setup: const ScreenSetup(width: 360));
      final size = tester.getSize(find.bySemanticsLabel(RegExp(r'^Tue, 10 Nov, today')));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(find.bySemanticsLabel('Sun, 8 Nov, Claude Pro (To confirm)'), findsOneWidget);
      expect(find.bySemanticsLabel('Thu, 12 Nov, ChatGPT Plus (Expected)'), findsOneWidget);
      expect(find.bySemanticsLabel('Thu, 5 Nov, iCloud+ 200 GB (Paid)'), findsOneWidget);
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      // Tall frame: nothing sits under the FAB / tab bar, which the contrast check would sample.
      await pumpScreen(tester, const CalendarScreen(), setup: const ScreenSetup(width: 360, height: 1600));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    });

    testWidgets('month arrows move between months', (tester) async {
      await pumpScreen(tester, const CalendarScreen());
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('December 2026'), findsOneWidget);
      expect(find.text('December:'), findsOneWidget);
      await tester.tap(find.byTooltip('Previous month'));
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
      expect(find.text('October 2026'), findsOneWidget);
    });
  });

  testWidgets('073 past month — October shows the real payments', (tester) async {
    await pumpScreen(tester, const CalendarScreen(initialMonthOffset: -1));
    expect(find.text('October:'), findsOneWidget);
    expect(find.text(r'≈ $114.57'), findsOneWidget);
    expect(find.text('7 paid'), findsOneWidget);
    await tester.tap(dayCell(12));
    await tester.pumpAndSettle();
    expect(find.text('MON, 12 OCT'), findsOneWidget);
    expect(find.text('ChatGPT Plus'), findsOneWidget);
    expect(find.text('Paid'), findsWidgets);
    await tester.tap(dayCell(15));
    await tester.pumpAndSettle();
    expect(find.text(r'$17.99'), findsOneWidget, reason: 'Netflix paid the new price from 15 Oct');
  });

  group('072 list', () {
    testWidgets('To confirm · This week · Later in November · December, every price with its cycle chip', (
      tester,
    ) async {
      await pumpScreen(
        tester,
        const CalendarScreen(initialView: CalendarView.agenda),
        setup: const ScreenSetup(height: 2200),
      );
      for (final h in ['TO CONFIRM', 'THIS WEEK', 'LATER IN NOVEMBER', 'DECEMBER']) {
        expect(find.text(h), findsOneWidget, reason: h);
      }
      expect(find.text('EARLIER IN NOVEMBER'), findsNothing, reason: 'payments already made stay in the grid');
      expect(find.byType(MonthGrid), findsNothing);
      expect(find.byType(CycleChip), findsNWidgets(find.byType(ServiceTile).evaluate().length));
      await tester.tap(find.text('Month'));
      await tester.pumpAndSettle();
      expect(find.byType(MonthGrid), findsOneWidget);
    });

    testWidgets('empty month says so', (tester) async {
      await pumpScreen(
        tester,
        const CalendarScreen(initialView: CalendarView.agenda),
        subscriptions: const [],
        periods: const [],
      );
      expect(find.text('Nothing due'), findsOneWidget);
      expect(find.text('Nothing due this month.'), findsOneWidget);
      expect(find.text(r'≈ $0.00'), findsOneWidget);
    });
  });

  testWidgets('Vietnamese wording', (tester) async {
    await pumpScreen(tester, const CalendarScreen(), setup: const ScreenSetup(locale: 'vi'));
    expect(find.text('Tháng 11, 2026'), findsOneWidget);
    expect(find.text('Tháng 11:'), findsOneWidget);
    expect(find.text('2 đã trả · 5 sắp tới'), findsOneWidget);
    expect(find.text('Dự kiến'), findsOneWidget);
    expect(find.text('T2'), findsOneWidget);
    expect(find.text('CN'), findsOneWidget);
    await tester.tap(find.text('Danh sách'));
    await tester.pumpAndSettle();
    expect(find.text('CHỜ XÁC NHẬN'), findsOneWidget);
    expect(find.text('CUỐI THÁNG 11'), findsOneWidget);
  });

  group('no overflow: 360/390 × EN/VI × light/dark × 100/130/200% + 320 × 200%', () {
    for (final s in layoutMatrix) {
      testWidgets(s.name, (tester) async {
        for (final screen in const [
          CalendarScreen(),
          CalendarScreen(initialView: CalendarView.agenda),
          CalendarScreen(initialMonthOffset: -1),
        ]) {
          await pumpScreen(tester, screen, setup: s);
          await scrollThrough(tester);
          expectNoLayoutErrors(tester);
        }
      });
    }
  });

  group('golden renders', skip: !uiShots, () {
    for (final dark in [false, true]) {
      final t = dark ? 'dark' : 'light';
      testWidgets('compare $t', (tester) async {
        await pumpScreen(tester, const CalendarScreen(), setup: ScreenSetup(dark: dark));
        await tester.tap(dayCell(12));
        await tester.pumpAndSettle();
        await shot('071-calendar-$t');
        await pumpScreen(
          tester,
          const CalendarScreen(initialView: CalendarView.agenda),
          setup: ScreenSetup(dark: dark),
        );
        await shot('072-calendar-list-$t');
        await pumpScreen(tester, const CalendarScreen(initialMonthOffset: -1), setup: ScreenSetup(dark: dark));
        await tester.tap(dayCell(12));
        await tester.pumpAndSettle();
        await shot('073-calendar-october-$t');
        await pumpScreen(
          tester,
          const CalendarScreen(),
          setup: ScreenSetup(dark: dark, locale: 'vi', width: 360),
        );
        await shot('071-calendar-vi-360-$t');
      });
    }
  });
}
