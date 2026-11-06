import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/data/settings_repository.dart';
import 'package:subnest/data/subscription_repository.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/home/home_list.dart';

import 'ui_harness.dart';

// S2 Overview, mockup v13 additions (png 14–20; product.md §10.2): row extras, filter, budget bar,
// due-this-week, auto Undo, Paused / pausing rows, tab bar hidden on scroll.

Finder row(String id) => find.byKey(ValueKey('row-$id'));

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
  // Keep the target clear of the status-bar inset.
  await tester.drag(find.byType(Scrollable).first, const Offset(0, 120), warnIfMissed: false);
  await tester.pumpAndSettle();
}

/// v13 sample: ChatGPT auto-detected from a screenshot, Canva Paused since 1 Nov, iCloud+ pausing
/// from 15 Nov, YouTube with labels Work + Family, a ₫1,200,000 total budget.
Future<TestApp> pumpRich(
  WidgetTester tester, {
  Setup setup = const Setup(),
  bool budget = true,
  Future<void> Function(SettingsRepository settings)? settings,
}) async {
  final subs = [
    for (final s in Mock.all)
      switch (s.id) {
        'chatgpt' => s.copyWith(detectionSource: DetectionSource.scan, detectedAt: now),
        'canva' => s.copyWith(status: SubscriptionStatus.paused, pausedFrom: const LocalDate(2026, 11, 1)),
        'icloud' => s.copyWith(status: SubscriptionStatus.paused, pausedFrom: const LocalDate(2026, 11, 15)),
        _ => s,
      },
  ];
  final app = await pumpApp(
    tester,
    setup: setup,
    subscriptions: subs,
    seed: (container) async {
      final org = container.read(organizeRepositoryProvider);
      final work = await org.addLabel(setup.locale == 'vi' ? 'Công việc' : 'Work', colorValue: 0xFF2856D8);
      final family = await org.addLabel(setup.locale == 'vi' ? 'Gia đình' : 'Family', colorValue: 0xFFD9468F);
      final repo = container.read(subscriptionRepositoryProvider);
      await repo.save(Mock.youtube.copyWith(labelIds: {work.id, family.id}));
      await repo.save(Mock.netflix.copyWith(labelIds: {work.id}));
      if (budget) await org.setBudget(amountMinor: 1200000, currency: 'VND');
      if (settings != null) await settings(container.read(settingsRepositoryProvider));
    },
  );
  return app;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('HomeFilter / HomeSort', () {
    test('encode → decode round trip; empty → null; junk → none', () {
      const f = HomeFilter(
        statuses: {HomeStatus.paused, HomeStatus.active},
        categoryIds: {'ai'},
        labelIds: {'l2', 'l1'},
        paymentMethodIds: {'p'},
      );
      expect(HomeFilter.decode(f.encode()), f);
      expect(f.count, 6);
      expect(HomeFilter.none.encode(), isNull);
      expect(HomeFilter.decode('{"s":["nope"],"c":[1]}'), HomeFilter.none);
      expect(HomeFilter.decode('not json'), HomeFilter.none);
      expect(HomeSort.parse('price'), HomeSort.price);
      expect(HomeSort.parse(null), HomeSort.dueDate);
      expect(HomeSort.parse('junk'), HomeSort.dueDate);
    });

    test('matches: AND across groups, OR inside a group; prune drops deleted ids', () {
      final yt = Mock.youtube.copyWith(labelIds: {'work'});
      expect(const HomeFilter(labelIds: {'work', 'x'}).matches(yt, today), isTrue);
      expect(const HomeFilter(labelIds: {'work'}, categoryIds: {'ai'}).matches(yt, today), isFalse);
      expect(const HomeFilter(statuses: {HomeStatus.trial}).matches(Mock.spotify, today), isTrue);
      expect(const HomeFilter(paymentMethodIds: {'p'}).matches(yt, today), isFalse);
      expect(const HomeFilter(labelIds: {'gone', 'work'}).prune(labelIds: {'work'}).labelIds, {'work'});
    });
  });

  group('S2 Overview v13', () {
    testWidgets('rows: label chip + "+1", Auto badge, Paused, Pauses 15 Nov, progress bars (png 08, 18, 20)', (
      tester,
    ) async {
      await pumpRich(tester);
      await scrollToFinder(tester, row('youtube'));
      expect(find.descendant(of: row('youtube'), matching: find.text('Work')), findsOneWidget);
      expect(find.descendant(of: row('youtube'), matching: find.text('+1')), findsOneWidget);
      expect(find.descendant(of: row('youtube'), matching: find.byType(CycleProgressBar)), findsOneWidget);
      expect(find.descendant(of: row('chatgpt'), matching: find.text('Auto')), findsOneWidget);
      // iCloud+ pauses later: still looks Active, says when, keeps its bar.
      expect(find.descendant(of: row('icloud'), matching: find.text('Pauses 15 Nov')), findsOneWidget);
      expect(find.descendant(of: row('icloud'), matching: find.byType(CycleProgressBar)), findsOneWidget);
      // Canva is paused now: muted, "Paused" + since, no bar, listed after the rest.
      await scrollToFinder(tester, row('canva'));
      expect(find.descendant(of: row('canva'), matching: find.text('Paused')), findsOneWidget);
      expect(find.descendant(of: row('canva'), matching: find.text('since 1 Nov')), findsOneWidget);
      expect(find.descendant(of: row('canva'), matching: find.byType(CycleProgressBar)), findsNothing);
      expect(tester.getTopLeft(row('canva')).dy, greaterThan(tester.getTopLeft(row('youtube')).dy));
      await closeApp(tester);
    });

    testWidgets('filter sheet → filtered list with chips, remembered, Clear (png 16–17)', (tester) async {
      final app = await pumpRich(tester);
      await scrollToFinder(tester, find.text('Filter'));
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      expect(find.text('STATUS'), findsOneWidget);
      expect(find.text('LABELS'), findsOneWidget);
      expect(find.text('Subnest remembers your filter and sort order next time.'), findsOneWidget);
      expect(find.text('Show 10 subscriptions'), findsOneWidget);
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();
      expect(find.text('Show 2 subscriptions'), findsOneWidget);
      await tester.tap(find.text('Show 2 subscriptions'));
      await settle(tester);
      expect(find.text('Label: Work'), findsOneWidget);
      expect(row('youtube'), findsOneWidget);
      expect(row('netflix'), findsOneWidget);
      expect(row('chatgpt'), findsNothing);
      final stored = await tester.runAsync(() => app.container.read(settingsRepositoryProvider).load());
      expect(HomeFilter.decode(stored!.homeFilter).labelIds, hasLength(1));
      await tester.tap(find.text('Clear'));
      await settle(tester);
      expect(find.text('Label: Work'), findsNothing);
      expect(row('chatgpt'), findsOneWidget);
      final cleared = await tester.runAsync(() => app.container.read(settingsRepositoryProvider).load());
      expect(cleared!.homeFilter, isNull);
      await closeApp(tester);
    });

    testWidgets('filter + sort remembered from the last launch', (tester) async {
      await pumpRich(
        tester,
        settings: (s) async {
          await s.setHomeFilter(const HomeFilter(statuses: {HomeStatus.paused}).encode());
          await s.setHomeSort('name');
        },
      );
      await scrollToFinder(tester, row('canva'));
      expect(find.bySemanticsLabel('Remove filter Paused'), findsOneWidget);
      expect(find.text('Name'), findsOneWidget); // sort button label
      expect(row('canva'), findsOneWidget);
      expect(row('icloud'), findsOneWidget);
      expect(row('youtube'), findsNothing);
      expect(tester.getTopLeft(row('canva')).dy, lessThan(tester.getTopLeft(row('icloud')).dy));
      await closeApp(tester);
    });

    testWidgets('status filter Cancelled from the Active tab jumps to Cancelled; × removes it', (tester) async {
      await pumpRich(tester);
      await scrollToFinder(tester, find.text('Filter'));
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancelled').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show 2 subscriptions'));
      await settle(tester);
      expect(row('duolingo'), findsOneWidget);
      expect(row('youtube'), findsNothing);
      await tester.tap(find.bySemanticsLabel('Remove filter Cancelled'));
      await settle(tester);
      expect(find.bySemanticsLabel('Remove filter Cancelled'), findsNothing);
      await closeApp(tester);
    });

    testWidgets('budget bar: ₫1,200,000 + % used, opens Budgets (png 08)', (tester) async {
      await pumpRich(tester);
      expect(find.text('Budget ₫1,200,000'), findsOneWidget);
      // Canva and iCloud+ are Paused → their cost leaves the total (75 %, below the amber 85 %).
      final pct = find.textContaining('% used');
      expect(pct, findsOneWidget);
      await tester.tap(find.text('Budget ₫1,200,000'));
      await settle(tester);
      expect(location(tester), '/settings/budgets');
      await closeApp(tester);
    });

    testWidgets('no budget → colour strip, no budget bar', (tester) async {
      await pumpRich(tester, budget: false);
      expect(find.textContaining('Budget '), findsNothing);
      expect(find.byType(SpendStrip), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('auto add → rows flash + Undo snackbar; Undo removes them (png 18)', (tester) async {
      final app = await pumpRich(tester);
      final chatgpt = (await tester.runAsync(() => app.sub('chatgpt')))!;
      app.container.read(homeAutoUndoProvider.notifier).show(DetectionReport(added: [chatgpt]));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Added 1 from your screenshot'), findsOneWidget);
      expect(app.container.read(homeAutoUndoProvider), isNull);
      await tester.tap(find.text('Undo'));
      await settle(tester);
      expect(await tester.runAsync(() => app.sub('chatgpt')), isNull);
      expect(find.text('Undone'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('tab bar hides on scroll down, returns on scroll up (setting on, png 19)', (tester) async {
      final app = await pumpRich(tester);
      final tab = find.text('Insights');
      expect(tab.hitTestable(), findsOneWidget);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tab.hitTestable(), findsOneWidget, reason: 'setting off → stays');
      await tester.runAsync(() => app.container.read(settingsRepositoryProvider).setHideTabBarOnScroll(true));
      await settle(tester);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tab.hitTestable(), findsNothing);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 100));
      await tester.pumpAndSettle();
      expect(tab.hitTestable(), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('Vietnamese: labels, Auto, Paused, budget', (tester) async {
      await pumpRich(tester, setup: const Setup(locale: 'vi'));
      expect(find.text('Ngân sách 1.200.000đ'), findsOneWidget);
      await scrollToFinder(tester, row('youtube'));
      expect(find.descendant(of: row('chatgpt'), matching: find.text('Tự động')), findsOneWidget);
      expect(find.descendant(of: row('icloud'), matching: find.text('Dừng từ 15/11')), findsOneWidget);
      expect(find.descendant(of: row('youtube'), matching: find.text('Công việc')), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('touch targets ≥ 48dp and labelled with filter on (S-50)', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpRich(tester);
      await scrollToFinder(tester, find.text('Filter'));
      await tester.tap(find.text('Filter'));
      await tester.pumpAndSettle();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await tester.tap(find.text('Work').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show 2 subscriptions'));
      await settle(tester);
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
      await closeApp(tester);
    });

    group('no overflow with v13 extras: 320dp × 200% + 360/390 × EN/VI × light/dark × 100/130/200%', () {
      for (final s in [
        for (final locale in ['en', 'vi'])
          for (final dark in [false, true]) Setup(width: 320, height: 640, locale: locale, dark: dark, textScale: 2),
        ...layoutMatrix,
      ]) {
        testWidgets(s.name, (tester) async {
          await pumpRich(tester, setup: s);
          await scrollThrough(tester);
          expectNoLayoutErrors(tester);
          await closeApp(tester);
        });
      }
    });
  });
}
