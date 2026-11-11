import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/confirm/confirm_sheet.dart';

import 'ui_harness.dart';

/// product.md §6 flows 3–6 end to end on the real router + in-memory DB.
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

  testWidgets('flow 3: "due today" notification → S6 → Paid → S2 updated', (tester) async {
    // SubnestApp pushes the notification's route (`/confirm/:id`) on top of the current screen.
    final app = await pumpApp(tester, push: '/confirm/netflix');
    expect(find.text('Did you pay Netflix?'), findsOneWidget);
    await tester.tap(find.text('Paid').last); // the sheet's button (the cost card's "Paid" is under it)
    await settle(tester);
    expect(find.text('Payment saved'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await settle(tester);
    expect(find.byType(ConfirmSheet), findsNothing);
    expect(find.text('1 payment to confirm'), findsOneWidget);
    expect(find.text('₫150,000'), findsOneWidget);
    expect((await app.sub('netflix'))!.dueDate, const LocalDate(2026, 12, 4));
    await closeApp(tester);
  });

  testWidgets('flow 4: "3 payments to confirm" → S7 → Confirm all', (tester) async {
    final app = await pumpApp(tester, subscriptions: Mock.many);
    await tester.tap(find.text('3 payments to confirm'));
    await settle(tester);
    await tester.tap(find.text('Confirm all · ₫365,000'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm all'));
    await settle(tester);
    expect(find.text('You’re all caught up 🎉'), findsOneWidget);
    await tester.tap(find.text('Back to Overview'));
    await settle(tester);
    expect(find.textContaining('to confirm'), findsNothing);
    expect((await app.sub('viettel'))!.dueDate, const LocalDate(2026, 12, 1));
    await closeApp(tester);
  });

  testWidgets('flow 5: S5 → How to cancel → Mark as cancelled → celebration → Cancelled tab', (tester) async {
    final app = await pumpApp(tester);
    await scrollToFinder(tester, find.byKey(const ValueKey('row-canva')));
    await tester.tap(find.byKey(const ValueKey('row-canva')));
    await settle(tester);
    await scrollToFinder(tester, find.text('How to cancel this service'));
    await tester.tap(find.text('How to cancel this service'));
    await settle(tester);
    expect(launched, ['https://www.canva.com/settings/billing-and-plans']);
    await tester.tap(find.text('Mark as cancelled'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mark as cancelled').last);
    await settle(tester);
    expect(find.text('+₫1,390,000'), findsOneWidget);
    expect(find.text('₫2,869,000/year'), findsOneWidget);
    await tester.tap(find.text('See cancelled'));
    await settle(tester);
    expect(find.byKey(const ValueKey('row-canva')), findsOneWidget);
    expect(find.text('You’re saving ₫2,869,000 a year'), findsOneWidget); // saving line on the Cancelled tab
    expect((await app.sub('canva'))!.status, SubscriptionStatus.cancelled);
    await closeApp(tester);
  });

  testWidgets('flow 6: trial card → S5 → How to cancel / Keep it', (tester) async {
    await pumpApp(tester);
    await scrollToFinder(tester, find.text('Spotify trial ends in 2 days'));
    await tester.tap(find.text('Spotify trial ends in 2 days'));
    await settle(tester);
    expect(find.text('Trial ends Fri, 6 Nov'), findsOneWidget);
    await tester.tap(find.text('How to cancel'));
    await settle(tester);
    expect(launched, ['https://www.spotify.com/account/subscription/']);
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await settle(tester);
    expect(find.text('Spotify trial ends in 2 days'), findsNothing); // kept → card hidden
    await closeApp(tester);
  });

  testWidgets('trial card: savings line + Keep it / View / How to cancel', (tester) async {
    await pumpApp(tester);
    await scrollToFinder(tester, find.text('Keep it'));
    expect(find.textContaining('Cancel before it charges to save'), findsOneWidget);
    expect(find.text('How to cancel'), findsOneWidget);
    await tester.tap(find.text('View'));
    await settle(tester);
    expect(find.text('Trial ends Fri, 6 Nov'), findsOneWidget); // S5 Detail
    await tester.pageBack();
    await settle(tester);
    await scrollToFinder(tester, find.text('Keep it'));
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(find.text('Spotify trial ends in 2 days'), findsNothing);
    await closeApp(tester);
  });
}
