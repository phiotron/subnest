import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/app.dart';
import 'package:subnest/core/router/app_router.dart';
import 'package:subnest/core/router/routes.dart';
import 'package:subnest/core/widgets/widgets.dart';

import '../catalog/add_harness.dart';
import 'onboarding_helpers.dart';

/// product.md §6 flows 1 and 2 on the real app (router, shell, Overview) with an in-memory DB.
/// Overview belongs to another session, so these only check what any Overview must show.
Future<void> pumpApp(WidgetTester tester, AddFixture f, String initial) async {
  tester.view
    ..physicalSize = const Size(390, 844) * 2
    ..devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: f.overrides(),
      child: SubnestApp(router: createRouter(initialLocation: initial)),
    ),
  );
  await settle(tester);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadFonts();
  });

  addTest('Flow 1 — first launch: language → welcome → currency → pick 5 → reminders → Overview with data', (tester) async {
    final f = await AddFixture.create(onboardingDone: false, primary: null);
    await pumpApp(tester, f, AppRoutes.onboarding);
    expect(find.text('Language'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    expect(find.text('All your subscriptions, one nest'), findsOneWidget);
    await tester.tap(find.text('Get started'));
    await settle(tester);
    expect(find.text('USD — US dollar'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await pickFive(tester);
    expect(find.text('5 selected'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await settle(tester);
    await tester.tap(find.text('Turn on reminders'));
    await settle(tester);

    expect(f.notifications.permissionRequests, 1);
    expect(find.text('All your subscriptions, one nest'), findsNothing);
    // Overview lists what was just picked.
    for (final name in ['Netflix Standard with ads', 'Spotify Individual', 'ChatGPT Go']) {
      expect(find.textContaining(name), findsWidgets, reason: name);
    }
    expect((await f.subs.all()), hasLength(5));
    expect((await f.settings.load()).onboardingDone, isTrue);
  });

  addTest('Flow 2 — add: + → search “netf” → Netflix → Premium → split 4 → saved → Overview', (tester) async {
    final f = await AddFixture.create();
    await pumpApp(tester, f, AppRoutes.home);
    await tester.tap(find.byType(AppFab));
    await settle(tester);
    expect(find.text('Add subscription'), findsWidgets);
    await tester.enterText(find.byType(TextField), 'netf');
    await settle(tester);
    await tester.tap(find.text('Netflix'));
    await settle(tester);
    await tester.tap(find.text('Premium'));
    await settle(tester);
    await tester.tap(find.text('Continue with Premium'));
    await settle(tester);
    expect(find.text('New subscription'), findsOneWidget);

    final list = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(find.text('Split with others'), 200, scrollable: list);
    await tester.tap(find.text('Split with others'));
    await settle(tester);
    await tester.scrollUntilVisible(find.text('Your share'), 200, scrollable: list);
    Scrollable.ensureVisible(tester.element(find.text('Your share')), alignment: .5);
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('More'));
    await settle(tester);
    await tester.tap(find.bySemanticsLabel('More'));
    await settle(tester);
    expect(find.text('\$26.99 ÷ 4'), findsOneWidget);
    await tester.tap(find.text('Add subscription').last);
    await settle(tester);

    expect(find.text('New subscription'), findsNothing);
    expect(find.textContaining('Netflix Premium'), findsWidgets);
    final saved = (await f.subs.all()).single;
    expect(saved.name, 'Netflix Premium');
    expect(saved.sharedWith, 4);
    expect(saved.myShare.minor, 675);
  });
}
