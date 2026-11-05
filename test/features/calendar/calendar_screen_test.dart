import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/features/calendar/calendar_screen.dart';
import 'package:subnest/features/calendar/widgets/month_grid.dart';

import 'screen_harness.dart';

Finder dayCell(int day) => find.descendant(of: find.byType(MonthGrid), matching: find.text('$day')).first;

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('S8 month view — current month', () {
    testWidgets('header, total, legend and today\'s list (png 41)', (tester) async {
      await pumpScreen(tester, const CalendarScreen());
      expect(find.text('Calendar'), findsWidgets);
      expect(find.text('November 2026'), findsOneWidget);
      expect(find.text('November total'), findsOneWidget);
      expect(find.text('≈ ₫876,800'), findsOneWidget);
      expect(find.text('6 payments · 2 to confirm'), findsOneWidget);
      for (final w in ['Mon', 'Sun', 'Paid', 'Upcoming', 'Skipped']) {
        expect(find.text(w), findsWidgets, reason: w);
      }
      expect(find.text('TODAY · WED, 4 NOV'), findsOneWidget);
      expect(find.text('Netflix Premium'), findsOneWidget);
      expect(find.text('₫65,000'), findsOneWidget);
      expect(find.text('Confirm'), findsOneWidget);
      // Amber clock: days 1 and 4, the legend, the row's badge.
      expect(find.byIcon(AppIcons.awaiting), findsNWidgets(4));
    });

    testWidgets('Confirm opens the confirm sheet, a row opens the subscription', (tester) async {
      await pumpScreen(tester, const CalendarScreen());
      // The list scrolls clear of the FAB.
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -400));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(pushed, ['/confirm/netflix']);
      tester.state<NavigatorState>(find.byType(Navigator).first).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Netflix Premium'));
      await tester.pumpAndSettle();
      expect(pushed.last, '/subscription/netflix');
    });

    testWidgets('tapping a day shows its entries; an empty day says so', (tester) async {
      await pumpScreen(tester, const CalendarScreen());
      await tester.tap(dayCell(6));
      await tester.pumpAndSettle();
      expect(find.text('FRI, 6 NOV'), findsOneWidget);
      expect(find.text('Spotify Premium'), findsOneWidget);
      expect(find.text('First charge after trial'), findsOneWidget);
      await tester.tap(dayCell(7));
      await tester.pumpAndSettle();
      expect(find.text(r'$20.00'), findsOneWidget);
      expect(find.text('in 3 days'), findsOneWidget);
      await tester.tap(dayCell(10));
      await tester.pumpAndSettle();
      expect(find.text('Nothing due this day.'), findsOneWidget);
    });

    testWidgets('day cells: ≥ 48dp, labelled for screen readers', (tester) async {
      await pumpScreen(tester, const CalendarScreen(), setup: const ScreenSetup(width: 360));
      final size = tester.getSize(find.bySemanticsLabel(RegExp(r'^Wed, 4 Nov, today')));
      expect(size.width, greaterThanOrEqualTo(48));
      expect(size.height, greaterThanOrEqualTo(48));
      expect(find.bySemanticsLabel('Wed, 4 Nov, today, Netflix Premium (To confirm)'), findsOneWidget);
      expect(find.bySemanticsLabel('Tue, 10 Nov, Nothing due'), findsOneWidget);
      await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
      await expectLater(tester, meetsGuideline(textContrastGuideline));
    });

    testWidgets('month arrows move between months', (tester) async {
      await pumpScreen(tester, const CalendarScreen());
      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();
      expect(find.text('December 2026'), findsOneWidget);
      expect(find.text('December total'), findsOneWidget);
      await tester.tap(find.byTooltip('Previous month'));
      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();
      expect(find.text('October 2026'), findsOneWidget);
    });
  });

  group('S8 past month (png 42)', () {
    testWidgets('Payments total, paid / skipped counts, skipped row struck through', (tester) async {
      await pumpScreen(tester, const CalendarScreen(initialMonthOffset: -1));
      expect(find.text('Paid in October'), findsOneWidget);
      expect(find.text('≈ ₫782,000'), findsOneWidget, reason: r'the $20 ChatGPT payment is converted');
      expect(find.text('4 paid · 1 skipped'), findsOneWidget);
      // Default selection: first day with an entry (1 Oct, Viettel paid).
      expect(find.text('Viettel 5G'), findsOneWidget);
      await tester.tap(dayCell(22));
      await tester.pumpAndSettle();
      expect(find.text('THU, 22 OCT'), findsOneWidget);
      expect(find.text('Didn’t pay this period'), findsOneWidget);
      final amount = tester.widget<Text>(find.text('₫35,800'));
      expect(amount.style?.decoration, TextDecoration.lineThrough);
      expect(find.text('Confirm'), findsNothing);
    });
  });

  group('S8 agenda (png 43)', () {
    testWidgets('sections: To confirm · This week · Later · next month', (tester) async {
      await pumpScreen(
        tester,
        const CalendarScreen(initialView: CalendarView.agenda),
        setup: const ScreenSetup(height: 1800),
      );
      for (final h in ['TO CONFIRM', 'THIS WEEK', 'LATER IN NOVEMBER', 'DECEMBER']) {
        expect(find.text(h), findsOneWidget, reason: h);
      }
      expect(find.byType(MonthGrid), findsNothing);
      expect(find.text('First charge after trial'), findsOneWidget);
      expect(find.text('Sun'), findsWidgets); // 1 Nov
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
      expect(find.text('₫0'), findsOneWidget);
    });
  });

  testWidgets('Vietnamese wording', (tester) async {
    await pumpScreen(tester, const CalendarScreen(), setup: const ScreenSetup(locale: 'vi'));
    expect(find.text('Tháng 11/2026'), findsOneWidget);
    expect(find.text('Tổng tháng 11'), findsOneWidget);
    expect(find.text('≈ 876.800đ'), findsOneWidget);
    expect(find.text('6 khoản · 2 chờ xác nhận'), findsOneWidget);
    expect(find.text('HÔM NAY · T4, 4/11'), findsOneWidget);
    expect(find.text('T2'), findsOneWidget);
    expect(find.text('CN'), findsOneWidget);
    await tester.tap(find.text('Danh sách'));
    await tester.pumpAndSettle();
    expect(find.text('CHỜ XÁC NHẬN'), findsOneWidget);
    expect(find.text('CUỐI THÁNG 11'), findsOneWidget);
  });

  group('no overflow: 360/390 × EN/VI × light/dark × 100/130/200%', () {
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
    Future<void> render(
      WidgetTester tester,
      String name,
      Widget screen,
      ScreenSetup s, {
      Future<void> Function()? then,
    }) async {
      await pumpScreen(tester, screen, setup: s);
      if (then != null) await then();
      await shot(name);
    }

    for (final dark in [false, true]) {
      final t = dark ? 'dark' : 'light';
      testWidgets('compare $t', (tester) async {
        await render(tester, '41-s8-calendar-$t', const CalendarScreen(), ScreenSetup(dark: dark));
        await render(
          tester,
          '42-s8-past-month-$t',
          const CalendarScreen(initialMonthOffset: -1),
          ScreenSetup(dark: dark),
          then: () async {
            await tester.tap(dayCell(22));
            await tester.pumpAndSettle();
          },
        );
        await render(
          tester,
          '43-s8-agenda-$t',
          const CalendarScreen(initialView: CalendarView.agenda),
          ScreenSetup(dark: dark),
        );
        await render(tester, 'vi-41-s8-calendar-$t', const CalendarScreen(), ScreenSetup(dark: dark, locale: 'vi'));
        await render(
          tester,
          'vi-43-s8-agenda-$t',
          const CalendarScreen(initialView: CalendarView.agenda),
          ScreenSetup(dark: dark, locale: 'vi'),
        );
        for (final scale in [1.3, 2.0]) {
          for (final lang in ['vi', 'en']) {
            final s = ScreenSetup(dark: dark, locale: lang, width: 360, height: 1900, textScale: scale);
            await render(tester, 's8-month-${s.name}', const CalendarScreen(), s);
            await render(tester, 's8-agenda-${s.name}', const CalendarScreen(initialView: CalendarView.agenda), s);
          }
        }
      });
    }
  });
}
