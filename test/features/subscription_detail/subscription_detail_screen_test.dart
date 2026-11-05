import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/domain/domain.dart';

import '../home/ui_harness.dart';

String location(WidgetTester tester) {
  final config = GoRouter.of(tester.element(find.byType(Navigator).first)).routerDelegate.currentConfiguration;
  final last = config.last;
  return last is ImperativeRouteMatch ? last.matches.uri.toString() : config.uri.toString();
}

Future<void> scrollToFinder(WidgetTester tester, Finder f) async {
  for (var i = 0; i < 30 && f.evaluate().isEmpty; i++) {
    await tester.drag(find.byType(Scrollable).first, const Offset(0, -200), warnIfMissed: false);
    await tester.pumpAndSettle();
  }
  await tester.ensureVisible(f.first);
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('S5 Detail', () {
    testWidgets('awaiting + shared: hero, banner, info card, history (png 28–29)', (tester) async {
      await pumpApp(tester, location: '/subscription/netflix');
      expect(find.text('Netflix Premium'), findsOneWidget);
      expect(find.text('To confirm'), findsWidgets);
      expect(find.text('Your share · plan ₫260,000 ÷ 4'), findsOneWidget);
      expect(find.text('Renewal on 4 Nov needs confirming'), findsOneWidget);
      expect(find.text('Did ₫65,000 go out? The next date waits until you say.'), findsOneWidget);
      expect(find.text('Next renewal'), findsOneWidget);
      expect(find.text('Waits for your confirmation'), findsOneWidget);
      expect(find.text('Wed, 4 Nov'), findsOneWidget);
      expect(find.text('Every month'), findsOneWidget);
      expect(find.text('3 days before, 9:00'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
      expect(find.text('Visa ••4242'), findsOneWidget);
      await scrollToFinder(tester, find.text('4 Jun 2026'));
      expect(find.text('₫260,000'), findsOneWidget); // total paid (4 × ₫65,000)
      expect(find.text('Shared with Minh, Lan and Huy'), findsOneWidget);
      await scrollToFinder(tester, find.text('4 Jun 2026').last);
      expect(find.text('PAYMENT HISTORY'), findsOneWidget);
      expect(find.text('4 Nov 2026'), findsOneWidget);
      expect(find.text('Paid'), findsNWidgets(4));
      expect(find.text('Didn’t pay'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('banner Confirm opens the confirm sheet', (tester) async {
      await pumpApp(tester, location: '/subscription/netflix');
      await tester.tap(find.text('Confirm'));
      await settle(tester);
      expect(find.text('Did you pay Netflix?'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('edit a payment amount (png 40)', (tester) async {
      final app = await pumpApp(tester, location: '/subscription/netflix');
      await scrollToFinder(tester, find.text('4 Oct 2026'));
      await tester.tap(find.text('4 Oct 2026'));
      await tester.pumpAndSettle();
      expect(find.text('Payment · 4 Oct 2026'), findsOneWidget);
      expect(find.text('Sun, 4 Oct 2026'), findsOneWidget);
      await tester.enterText(find.byType(EditableText).first, '70000');
      await tester.pumpAndSettle();
      expect(find.text('Was ₫65,000 — saving updates Total paid to ₫265,000.'), findsOneWidget);
      await tester.tap(find.text('Save'));
      await settle(tester);
      expect(find.text('Payment updated'), findsOneWidget);
      final p = (await app.periods()).firstWhere((p) => p.dueDate == const LocalDate(2026, 10, 4));
      expect(p.amountMinor, 70000);
      await closeApp(tester);
    });

    testWidgets('mark a payment as not paid', (tester) async {
      final app = await pumpApp(tester, location: '/subscription/netflix');
      await scrollToFinder(tester, find.text('4 Sep 2026'));
      await tester.tap(find.text('4 Sep 2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as not paid'));
      await settle(tester);
      final p = (await app.periods()).firstWhere((p) => p.dueDate == const LocalDate(2026, 9, 4));
      expect(p.outcome, PeriodOutcome.skipped);
      expect(p.amountMinor, 0);
      expect(find.text('Didn’t pay'), findsNWidgets(2));
      // The subscription's Due date did not move.
      expect((await app.sub('netflix'))!.dueDate, const LocalDate(2026, 11, 4));
      await closeApp(tester);
    });

    testWidgets('payment sheet Cancel changes nothing; empty amount is refused', (tester) async {
      final app = await pumpApp(tester, location: '/subscription/netflix');
      await scrollToFinder(tester, find.text('4 Oct 2026'));
      await tester.tap(find.text('4 Oct 2026'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(EditableText).first, '');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Save'));
      await settle(tester);
      expect(find.text('Enter the amount you paid.'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await settle(tester);
      final p = (await app.periods()).firstWhere((p) => p.dueDate == const LocalDate(2026, 10, 4));
      expect(p.amountMinor, 65000);
      await closeApp(tester);
    });

    testWidgets('How to cancel this service opens the Catalog cancel page', (tester) async {
      await pumpApp(tester, location: '/subscription/netflix');
      await scrollToFinder(tester, find.text('How to cancel this service'));
      expect(find.text('Opens netflix.com account settings'), findsOneWidget);
      await tester.tap(find.text('How to cancel this service'));
      await settle(tester);
      expect(launched, ['https://www.netflix.com/cancelplan']);
      await closeApp(tester);
    });

    testWidgets('Edit opens the form route', (tester) async {
      await pumpApp(tester, location: '/home', push: '/subscription/netflix');
      await tester.tap(find.text('Edit'));
      await settle(tester);
      expect(location(tester), '/subscription/netflix/edit');
      await closeApp(tester);
    });

    testWidgets('delete: dialog (png 32) → removed, back to Overview', (tester) async {
      final app = await pumpApp(tester, location: '/home', push: '/subscription/netflix');
      await scrollToFinder(tester, find.text('Delete subscription'));
      await tester.tap(find.text('Delete subscription'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Netflix Premium?'), findsOneWidget);
      expect(
        find.text(
          'This removes it and its 5 payment records for good. To stop reminders but keep the history, '
          'mark it as cancelled instead.',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Keep it'));
      await tester.pumpAndSettle();
      expect(await app.sub('netflix'), isNotNull);
      await tester.tap(find.text('Delete subscription'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await settle(tester);
      expect(await app.sub('netflix'), isNull);
      expect((await app.periods()).where((p) => p.subscriptionId == 'netflix'), isEmpty);
      expect(location(tester), '/home');
      expect(find.text('1 payment to confirm'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('trial (png 30): banner, How to cancel, Keep it', (tester) async {
      await pumpApp(tester, location: '/subscription/spotify');
      expect(find.text('Trial · 2 days left'), findsOneWidget);
      expect(find.text('Trial ends Fri, 6 Nov'), findsOneWidget);
      expect(find.text('After that it renews at ₫59,000/month. Cancel before then if you don’t want it.'), findsOneWidget);
      expect(find.text('First charge'), findsOneWidget);
      expect(find.text('in 2 days'), findsOneWidget);
      await tester.tap(find.text('How to cancel'));
      await settle(tester);
      expect(launched, ['https://www.spotify.com/account/subscription/']);
      await tester.tap(find.text('Keep it'));
      await tester.pumpAndSettle();
      expect(find.text('Keeping Spotify. The first charge is on Fri, 6 Nov.'), findsOneWidget);
      await scrollToFinder(tester, find.text('No payments yet — the first charge is on Fri, 6 Nov.'));
      await closeApp(tester);
    });

    testWidgets('cancelled (png 31): savings banner, Restore', (tester) async {
      final app = await pumpApp(tester, location: '/subscription/duolingo');
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Saving ₫699,000/year'), findsOneWidget);
      expect(find.text('Cancelled 12 Oct 2026. No more reminders.'), findsOneWidget);
      expect(find.text('Next renewal'), findsNothing);
      expect(find.text('Remind me'), findsNothing);
      expect(find.text('Mark as cancelled'), findsNothing);
      await tester.tap(find.text('Restore subscription'));
      await settle(tester);
      final s = (await app.sub('duolingo'))!;
      expect(s.status, SubscriptionStatus.active);
      expect(s.dueDate, const LocalDate(2027, 10, 12));
      expect(find.text('Restored. Next renewal: Tue, 12 Oct 2027.'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('mark as cancelled → celebration (png 33) → See cancelled', (tester) async {
      final app = await pumpApp(tester, location: '/home', push: '/subscription/canva');
      await scrollToFinder(tester, find.text('Mark as cancelled'));
      await tester.tap(find.text('Mark as cancelled'));
      await tester.pumpAndSettle();
      expect(find.text('Mark Canva Pro as cancelled?'), findsOneWidget);
      await tester.tap(find.text('Mark as cancelled').last);
      await settle(tester);
      expect(find.text('Canva Pro cancelled'), findsOneWidget);
      expect(find.text('+₫1,390,000'), findsOneWidget);
      expect(find.text('a year saved'), findsOneWidget);
      expect(find.text('₫2,869,000/year'), findsOneWidget);
      expect((await app.sub('canva'))!.status, SubscriptionStatus.cancelled);
      await tester.tap(find.text('See cancelled'));
      await settle(tester);
      expect(location(tester), '/home');
      expect(find.byKey(const ValueKey('row-canva')), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('foreign currency shows the converted amount', (tester) async {
      await pumpApp(tester, location: '/subscription/chatgpt');
      expect(find.textContaining(r'$20.00', findRichText: true), findsWidgets);
      expect(find.text('≈ ₫508,000'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('Vietnamese (png 28 VI)', (tester) async {
      await pumpApp(tester, setup: const Setup(locale: 'vi'), location: '/subscription/netflix');
      expect(find.text('Chờ xác nhận'), findsWidgets);
      expect(find.text('Phần của bạn · gói 260.000đ ÷ 4'), findsOneWidget);
      expect(find.text('Kỳ 4/11 đang chờ xác nhận'), findsOneWidget);
      expect(find.text('Gia hạn tiếp theo'), findsOneWidget);
      expect(find.text('Mỗi tháng'), findsOneWidget);
      expect(find.text('3 ngày, lúc 9:00'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('unknown id shows a message, not a crash', (tester) async {
      await pumpApp(tester, location: '/subscription/nope');
      expect(find.text('This subscription no longer exists.'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('touch targets ≥ 48dp, labelled; text contrast', (tester) async {
      for (final id in ['netflix', 'spotify', 'duolingo']) {
        await pumpApp(tester, location: '/subscription/$id');
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
        await closeApp(tester);
      }
    });

    group('no overflow: 360/390 × EN/VI × light/dark × 100/130/200%', () {
      for (final s in layoutMatrix) {
        testWidgets(s.name, (tester) async {
          for (final id in ['netflix', 'spotify', 'duolingo', 'chatgpt']) {
            await pumpApp(tester, setup: s, location: '/subscription/$id');
            await scrollThrough(tester);
            expectNoLayoutErrors(tester);
            await closeApp(tester);
          }
          // Payment sheet + delete dialog.
          await pumpApp(tester, setup: s, location: '/subscription/netflix');
          await scrollToFinder(tester, find.byIcon(AppIcons.edit));
          await tester.tap(find.byIcon(AppIcons.edit).first);
          await tester.pumpAndSettle();
          expectNoLayoutErrors(tester);
          await closeApp(tester);
        });
      }
    });
  });
}
