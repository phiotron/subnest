import 'dart:async';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/app.dart';
import 'package:subnest/core/router/app_router.dart';
import 'package:subnest/core/router/routes.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/db/app_database.dart';
import 'package:subnest/data/notifications/notification_service.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';

/// End-to-end smoke test of the placeholder flow (brief step 6):
/// add → list → detail → confirm → cancel → insights, on an in-memory DB.
void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  setUpAll(initializeDateFormatting);

  testWidgets('core flow works end to end', (tester) async {
    Future<void> settle() => tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 10),
    );
    tester.view
      ..physicalSize = const Size(420, 1400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        notificationServiceProvider.overrideWithValue(NotificationService()),
      ],
    );
    final today = LocalDate.today();
    final now = DateTime.now();
    await container.read(settingsRepositoryProvider).setOnboardingDone(true);
    // A subscription whose period is due today → awaiting confirmation.
    await container.read(subscriptionRepositoryProvider).save(
      Subscription(
        id: 'netflix',
        name: 'Netflix',
        priceMinor: 1599,
        currency: 'USD',
        cycle: const BillingCycle.monthly(),
        anchorDate: today,
        startDate: today,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: SubnestApp(router: createRouter(initialLocation: AppRoutes.home)),
      ),
    );
    await settle();

    // Home: list + awaiting card.
    expect(find.text('Netflix'), findsWidgets);
    expect(find.text('1 payment to confirm'), findsOneWidget);

    // Awaiting card → S7 → confirm sheet → Paid → Done.
    await tester.tap(find.text('Review'));
    await settle();
    await tester.tap(find.text('Netflix'));
    await settle();
    expect(find.text('Amount paid'), findsOneWidget);
    await tester.tap(find.text('Paid'));
    await settle();
    expect(find.text('Payment saved'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await settle();
    expect(find.text('You’re all caught up 🎉'), findsOneWidget);
    final periods = await container.read(subscriptionRepositoryProvider).allPeriods();
    expect(periods.single.amountMinor, 1599);
    await tester.pageBack();
    await settle();
    expect(find.text('1 payment to confirm'), findsNothing);

    // Add a custom subscription: FAB → catalog → custom → form → save → home.
    await tester.tap(find.byType(AppFab));
    await settle();
    await tester.tap(find.text('Create a custom service'));
    await settle();
    await tester.enterText(find.byType(TextField).first, 'Gym');
    await tester.enterText(find.descendant(of: find.byType(AmountField), matching: find.byType(TextField)), '25');
    await settle();
    await tester.ensureVisible(find.text('Add subscription').last);
    await tester.tap(find.text('Add subscription').last);
    await settle();
    expect(find.text('Gym'), findsWidgets);

    // Detail → mark as cancelled → celebration (063) → Done → the detail, now cancelled → Overview.
    await tester.ensureVisible(find.text('Gym').last);
    await tester.tap(find.text('Gym').last);
    await settle();
    expect(find.text('PAYMENT HISTORY'), findsOneWidget);
    await tester.ensureVisible(find.text('Mark as cancelled'));
    await tester.tap(find.text('Mark as cancelled'));
    await settle();
    await tester.tap(find.text('Mark as cancelled').last); // dialog
    await settle();
    expect(find.textContaining('a year saved'), findsOneWidget);
    expect(find.text('Total saving'), findsOneWidget);
    await tester.tap(find.text('Done'));
    await settle();
    expect(find.text('Cancelled'), findsOneWidget); // detail status chip
    expect(find.textContaining('Saving'), findsOneWidget); // savings banner
    await tester.pageBack();
    await settle();

    // Insights tab shows numbers.
    await tester.tap(find.text('Insights'));
    await settle();
    expect(find.text('Month'), findsOneWidget);
    expect(find.text('Year'), findsOneWidget);
    expect(find.textContaining('Paid'), findsWidgets);

    // Tear down: dispose providers (cancels timers) and close the DB.
    await tester.pumpWidget(const SizedBox());
    container.dispose();
    // Awaiting close() inside the test zone never completes; the in-memory DB is simply dropped.
    unawaited(db.close());
    await tester.pump(const Duration(seconds: 1));
  });
}
