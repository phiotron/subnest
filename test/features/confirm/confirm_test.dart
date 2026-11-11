import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/confirm/awaiting_screen.dart';
import 'package:subnest/features/confirm/confirm_sheet.dart';

import '../home/ui_harness.dart';

Finder pending(String id, LocalDate due) => find.byKey(ValueKey('pending-$id-$due'));

/// Text inside the confirm sheet (the Overview behind it shows the same names).
Finder inSheet(String text) => find.descendant(of: find.byType(ConfirmSheet), matching: find.text(text));

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('S6 Confirm sheet', () {
    testWidgets('asks for the period due today (065)', (tester) async {
      await pumpApp(tester, push: '/confirm/netflix');
      expect(inSheet('Netflix Premium'), findsOneWidget);
      expect(find.text('Due today'), findsOneWidget);
      expect(find.text('Period of 4 Nov 2026'), findsOneWidget);
      expect(inSheet('Monthly'), findsOneWidget);
      expect(find.text('Amount paid'), findsOneWidget);
      expect(find.text('Your share · plan ₫260,000 ÷ 4'), findsOneWidget);
      expect(inSheet('Paid'), findsOneWidget);
      expect(find.text('Didn’t pay this period'), findsOneWidget);
      expect(find.text('Later'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('edited amount → Paid → Payment saved + next period (png 35)', (tester) async {
      final app = await pumpApp(tester, push: '/confirm/netflix');
      await tester.enterText(find.descendant(of: find.byType(AmountField), matching: find.byType(TextField)), '70000');
      await tester.pumpAndSettle();
      await tester.tap(inSheet('Paid'));
      await settle(tester);
      expect(find.text('Payment saved'), findsOneWidget);
      expect(find.text('Netflix · ₫70,000 · 4 Nov 2026'), findsOneWidget);
      expect(find.text('Next period: 4 Dec 2026'), findsOneWidget);
      final p = (await app.periods()).firstWhere((p) => p.dueDate == today);
      expect(p.outcome, PeriodOutcome.payment);
      expect(p.amountMinor, 70000);
      expect((await app.sub('netflix'))!.dueDate, const LocalDate(2026, 12, 4));
      await tester.tap(find.text('Done'));
      await settle(tester);
      expect(find.byType(ConfirmSheet), findsNothing);
      expect(find.text('1 payment to confirm'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('prefilled amount follows a changed subscription (price, currency) until edited', (tester) async {
      // Real phone (2026-11-05): after restoring a backup where Netflix was in USD, the sheet first
      // showed the old share (65,000 VND) as "$65,000" — Paid would have saved the wrong amount.
      final app = await pumpApp(tester, push: '/confirm/netflix');
      final field = find.descendant(of: find.byType(AmountField), matching: find.byType(TextField));
      expect(tester.widget<TextField>(field).controller!.text, '65,000');
      final repo = app.container.read(subscriptionRepositoryProvider);
      await tester.runAsync(() async {
        final s = (await repo.get('netflix'))!;
        await repo.save(s.copyWith(priceMinor: 2699, currency: 'USD'));
      });
      await settle(tester);
      expect(tester.widget<TextField>(field).controller!.text, '6.75');
      // Once the user types an amount, a later price change in the same currency keeps it.
      await tester.enterText(field, '7');
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        final s = (await repo.get('netflix'))!;
        await repo.save(s.copyWith(priceMinor: 2999));
      });
      await settle(tester);
      expect(tester.widget<TextField>(field).controller!.text, '7');
      await closeApp(tester);
    });

    testWidgets('empty amount is refused', (tester) async {
      final app = await pumpApp(tester, push: '/confirm/netflix');
      await tester.enterText(find.descendant(of: find.byType(AmountField), matching: find.byType(TextField)), '');
      await tester.pumpAndSettle();
      await tester.tap(inSheet('Paid'));
      await settle(tester);
      expect(find.text('Enter the amount you paid.'), findsOneWidget);
      expect((await app.periods()).where((p) => p.dueDate == today), isEmpty);
      await closeApp(tester);
    });

    testWidgets('Later closes without saving; the Due date stays (ADR 0001)', (tester) async {
      final app = await pumpApp(tester, push: '/confirm/netflix');
      await tester.tap(find.text('Later'));
      await settle(tester);
      expect(find.byType(ConfirmSheet), findsNothing);
      expect((await app.sub('netflix'))!.dueDate, today);
      expect(find.text('2 payments to confirm'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('catch-up (067): Paid → 1 more period → Next period; Didn’t pay finishes', (tester) async {
      final app = await pumpApp(tester, subscriptions: Mock.many, push: '/confirm/viettel');
      expect(inSheet('Viettel 5G'), findsOneWidget);
      expect(find.text('1 more after this'), findsOneWidget);
      expect(find.text('Period of 1 Oct 2026'), findsOneWidget);
      expect(find.text('Current price · change it if you paid a different amount'), findsOneWidget);
      await tester.tap(inSheet('Paid'));
      await settle(tester);
      expect(find.text('Payment saved'), findsOneWidget);
      expect(find.text('1 more period to confirm — opening it next'), findsOneWidget);
      await tester.tap(find.text('Next period'));
      await settle(tester);
      expect(find.text('Due 1 Nov'), findsOneWidget);
      expect(find.text('Period of 1 Nov 2026'), findsOneWidget);
      await tester.tap(find.text('Didn’t pay this period'));
      await settle(tester);
      expect(find.text('Marked as not paid'), findsOneWidget);
      expect(find.text('Next period: 1 Dec 2026'), findsOneWidget);
      final ps = (await app.periods()).where((p) => p.subscriptionId == 'viettel').toList()
        ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
      expect([for (final p in ps) p.outcome], [PeriodOutcome.payment, PeriodOutcome.skipped]);
      expect(ps.last.amountMinor, 0);
      await closeApp(tester);
    });

    testWidgets('nothing pending → message', (tester) async {
      await pumpApp(tester, push: '/confirm/chatgpt');
      expect(find.text('Nothing to confirm'), findsOneWidget);
      expect(find.text('ChatGPT Plus is up to date. Next renewal: Sat, 7 Nov.'), findsOneWidget);
      await tester.tap(find.text('Done'));
      await settle(tester);
      expect(find.byType(ConfirmSheet), findsNothing);
      await closeApp(tester);
    });

    testWidgets('foreign currency shows the conversion', (tester) async {
      final chat = Mock.sub(
        'chatgpt',
        'ChatGPT Plus',
        2000,
        today,
        currency: 'USD',
        serviceId: 'chatgpt',
        color: 0xFF202123,
      );
      await pumpApp(tester, subscriptions: [chat], push: '/confirm/chatgpt');
      expect(inSheet('ChatGPT Plus'), findsOneWidget);
      expect(find.descendant(of: find.byType(ConfirmSheet), matching: find.text('≈ ₫508,000')), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('Vietnamese (png 34 VI)', (tester) async {
      await pumpApp(
        tester,
        setup: const Setup(locale: 'vi'),
        push: '/confirm/netflix',
      );
      expect(inSheet('Netflix Premium'), findsOneWidget);
      expect(find.text('Đến hạn hôm nay'), findsOneWidget);
      expect(find.text('Kỳ 04/11/2026'), findsOneWidget);
      expect(inSheet('Hằng tháng'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('touch targets ≥ 48dp, labelled; contrast', (tester) async {
      for (final dark in [false, true]) {
        await pumpApp(
          tester,
          setup: Setup(dark: dark),
          push: '/confirm/netflix',
        );
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
        await closeApp(tester);
      }
    });
  });

  group('S7 To confirm', () {
    testWidgets('oldest first, queued period locked (png 37)', (tester) async {
      await pumpApp(tester, subscriptions: Mock.many, location: '/awaiting');
      expect(find.text('To confirm'), findsWidgets);
      final rows = [
        pending('viettel', const LocalDate(2026, 10, 1)),
        pending('viettel', const LocalDate(2026, 11, 1)),
        pending('netflix', today),
      ];
      final ys = [for (final r in rows) tester.getTopLeft(r).dy];
      expect(ys, orderedEquals([...ys]..sort()));
      expect(find.text('1 Oct · 34d ago'), findsOneWidget);
      expect(find.text('1 Nov · 3d ago'), findsOneWidget);
      expect(find.text('4 Nov · today'), findsOneWidget);
      expect(find.text('After 1 Oct'), findsOneWidget);
      expect(find.text('Confirm all · ₫365,000'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('quick ✓ pays the oldest period; the queued one unlocks', (tester) async {
      final app = await pumpApp(tester, subscriptions: Mock.many, location: '/awaiting');
      final handle = tester.ensureSemantics();
      // The queued row's button does nothing.
      await tester.tap(find.byTooltip('Confirm the 1 Oct period first'));
      await settle(tester);
      expect(await app.periods(), hasLength(Mock.periods.length));
      expect(find.byType(ConfirmSheet), findsNothing);
      expect(find.text('Confirm the 1 Oct period first'), findsWidgets); // toast
      await tester.tap(find.byTooltip('Mark Viettel 5G, 1 Oct as paid'));
      await settle(tester);
      expect(find.text('Viettel 5G · 1 Oct saved as paid'), findsOneWidget);
      expect(pending('viettel', const LocalDate(2026, 10, 1)), findsNothing);
      expect(find.text('After 1 Oct'), findsNothing);
      final p = (await app.periods()).firstWhere((p) => p.dueDate == const LocalDate(2026, 10, 1));
      expect(p.amountMinor, 150000);
      handle.dispose();
      await closeApp(tester);
    });

    testWidgets('row tap opens the sheet', (tester) async {
      await pumpApp(tester, subscriptions: Mock.many, location: '/awaiting');
      await tester.tap(find.text('4 Nov · today'));
      await settle(tester);
      expect(inSheet('Netflix Premium'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('Confirm all: dialog (png 38) → all paid → caught up (png 39)', (tester) async {
      final app = await pumpApp(tester, subscriptions: Mock.many, location: '/awaiting');
      await tester.tap(find.text('Confirm all · ₫365,000'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm 3 payments?'), findsOneWidget);
      expect(find.text('Each period is saved as paid at its current price:'), findsOneWidget);
      expect(find.text('Viettel 5G × 2'), findsOneWidget);
      expect(find.text('₫300,000'), findsOneWidget);
      expect(find.text('You can edit any payment later.'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(await app.periods(), hasLength(Mock.periods.length));
      await tester.tap(find.text('Confirm all · ₫365,000'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm all'));
      await settle(tester);
      expect(await app.periods(), hasLength(Mock.periods.length + 3));
      expect(find.text('3 payments saved'), findsOneWidget);
      expect(find.text('You’re all caught up 🎉'), findsOneWidget);
      expect(find.text('New periods show up here on their due date.'), findsOneWidget);
      await tester.tap(find.text('Back to Overview'));
      await settle(tester);
      expect(find.byType(AwaitingScreen), findsNothing);
      expect(find.byType(AppTabBar), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('200% text: amounts move under the date, names stay readable, total not cut', (tester) async {
      await pumpApp(
        tester,
        setup: const Setup(locale: 'vi', width: 360, height: 800, textScale: 2),
        subscriptions: Mock.many,
        location: '/awaiting',
      );
      final name = find.text('Viettel 5G').first;
      expect(tester.getSize(name).width, greaterThan(120));
      expect(find.text('Xác nhận tất cả'), findsOneWidget);
      expect(find.text('365.000đ'), findsOneWidget);
      expectNoLayoutErrors(tester);
      await closeApp(tester);
    });

    testWidgets('Vietnamese', (tester) async {
      await pumpApp(
        tester,
        setup: const Setup(locale: 'vi'),
        subscriptions: Mock.many,
        location: '/awaiting',
      );
      expect(find.text('Chờ xác nhận'), findsWidgets);
      expect(find.text('1/10 · 34 ngày trước'), findsOneWidget);
      expect(find.text('Sau kỳ 1/10'), findsOneWidget);
      expect(find.text('Xác nhận tất cả · 365.000đ'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('touch targets ≥ 48dp, labelled; contrast', (tester) async {
      for (final dark in [false, true]) {
        await pumpApp(
          tester,
          setup: Setup(dark: dark),
          subscriptions: Mock.many,
          location: '/awaiting',
        );
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
        await closeApp(tester);
      }
    });
  });

  group('no overflow S6/S7: 360/390 × EN/VI × light/dark × 100/130/200%', () {
    for (final s in layoutMatrix) {
      testWidgets(s.name, (tester) async {
        await pumpApp(tester, setup: s, subscriptions: Mock.many, push: '/confirm/viettel');
        expectNoLayoutErrors(tester);
        await tester.tap(find.byIcon(AppIcons.check).first);
        await settle(tester);
        expectNoLayoutErrors(tester); // chain view
        await tester.tap(find.text(s.locale == 'vi' ? 'Kỳ tiếp theo' : 'Next period'));
        await settle(tester);
        expectNoLayoutErrors(tester);
        await tester.tap(find.byIcon(AppIcons.check).first);
        await settle(tester);
        expectNoLayoutErrors(tester); // done view
        await closeApp(tester);
        await pumpApp(tester, setup: s, subscriptions: Mock.many, location: '/awaiting');
        await scrollThrough(tester);
        expectNoLayoutErrors(tester);
        await closeApp(tester);
        await pumpApp(tester, setup: s, subscriptions: const [], periods: const [], location: '/awaiting');
        expectNoLayoutErrors(tester);
        await closeApp(tester);
      });
    }
  });
}
