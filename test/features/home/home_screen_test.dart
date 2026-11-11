import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/l10n/l10n.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/catalog/catalog_providers.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/features/home/home_screen.dart';
import 'package:subnest/features/home/subscription_labels.dart';
import 'package:subnest/features/home/widgets/cost_card.dart';

import 'ui_harness.dart';

Finder segment(String label) => find.textContaining(RegExp('^$label [0-9]'), findRichText: true);

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
}

List<String> order(WidgetTester tester, List<String> ids) {
  final visible = ids.where((id) => row(id).evaluate().isNotEmpty).toList()
    ..sort((a, b) => tester.getTopLeft(row(a)).dy.compareTo(tester.getTopLeft(row(b)).dy));
  return visible;
}

/// Records Update / Keep old price taps (the real store writes to app-support files).
class FakeNoticeActions extends PriceNoticeActions {
  FakeNoticeActions(super.ref);
  final updated = <String>[];
  final kept = <String>[];

  @override
  Future<bool> update(PriceChangeNotice notice) async {
    updated.add(notice.subscription.id);
    return true;
  }

  @override
  Future<void> keepOldPrice(PriceChangeNotice notice) async => kept.add(notice.subscription.id);
}

/// YouTube Premium Family: ₫179,000 → ₫199,000 in the library (shared ÷5).
PriceChangeNotice youtubeNotice() {
  final catalog = CatalogRepository.parse(File(CatalogRepository.assetPath).readAsStringSync());
  final service = catalog.firstWhere((s) => s.id == 'youtube-premium');
  return PriceChangeNotice(
    subscription: Mock.youtube,
    service: service,
    plan: service.plans.first,
    region: 'VN',
    oldPriceMinor: 179000,
    newPrice: const CatalogPrice('VND', 199000),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('S2 Overview', () {
    testWidgets('cost card, to confirm, trial card with 3 buttons (png 012)', (tester) async {
      await pumpApp(tester);
      expect(find.text('Wednesday, 4 November'), findsOneWidget);
      expect(find.text('Monthly cost'), findsOneWidget);
      expect(find.text('Yearly cost'), findsOneWidget);
      expect(find.text('₫1,133,466'), findsNWidgets(2)); // total + the selected column
      expect(find.text('≈'), findsOneWidget); // ChatGPT is in USD → the total is approximate
      expect(find.text('₫750 vs Oct'), findsOneWidget);
      expect(find.text('8 active subscriptions · ≈ ₫37,782 a day'), findsOneWidget);
      expect(find.text('Paid'), findsOneWidget);
      expect(find.text('Still to pay'), findsOneWidget);
      expect(find.text('≈ ₫876,800'), findsOneWidget);
      expect(find.text('1 Nov to 30 Nov'), findsOneWidget);
      for (final m in ['Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov']) {
        expect(find.text(m), findsOneWidget, reason: m);
      }
      final semantics = tester.ensureSemantics();
      await tester.pump();
      expect(find.bySemanticsLabel(RegExp('Up ₫750 compared with Oct')), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp(r'^October 2026: ₫[0-9,]+\. Opens Insights')), findsOneWidget);
      semantics.dispose();
      await scrollToFinder(tester, find.text('2 payments to confirm'));
      expect(find.text('₫215,000'), findsOneWidget);
      await scrollToFinder(tester, find.text('Keep it'));
      expect(find.text('Spotify trial ends in 2 days'), findsOneWidget);
      expect(find.text('Then ₫59,000 on 6 Nov'), findsOneWidget);
      expect(find.text('Cancel before it charges to save ₫708,000 a year'), findsOneWidget);
      expect(find.text('View'), findsOneWidget);
      expect(find.text('How to cancel'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('(i) explains how the numbers work (png 016)', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byIcon(LucideIcons.info).first);
      await tester.pumpAndSettle();
      expect(find.text('How the numbers work'), findsOneWidget);
      expect(find.text('Paid · Still to pay'), findsOneWidget);
      expect(find.text('Why ≈'), findsOneWidget);
      expect(find.text('That’s why Paid + Still to pay can differ from the monthly cost.'), findsOneWidget);
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
      expect(find.text('How the numbers work'), findsNothing);
      await closeApp(tester);
    });

    testWidgets('Monthly ↔ Yearly counts up to the year; 12 columns, future ones hatched (png 015)', (tester) async {
      final app = await pumpApp(tester);
      await tester.tap(find.text('Yearly cost'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('₫1,133,466'), findsNothing); // mid count-up
      await tester.pumpAndSettle();
      final year = app.container.read(yearSpendProvider(2026))!;
      final l = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(l.money(Money(year.totalMinor, 'VND'))), findsOneWidget);
      expect(find.textContaining('2026 · ≈ '), findsOneWidget);
      expect(find.text('1 Jan to 31 Dec 2026'), findsOneWidget);
      expect(find.text('Jan'), findsOneWidget);
      expect(find.text('Dec'), findsOneWidget);
      expect(find.byWidgetPredicate((w) => w is Hatch && w.outline), findsOneWidget); // December
      await tester.tap(find.text('Monthly cost'));
      await tester.pumpAndSettle();
      expect(find.text('₫1,133,466'), findsNWidgets(2)); // total + the selected column
      await closeApp(tester);
    });

    testWidgets('a month column opens Insights on that month', (tester) async {
      final app = await pumpApp(tester);
      await tester.tap(find.text('Oct'));
      await settle(tester);
      expect(location(tester), '/insights');
      expect(app.container.read(selectedStatsMonthProvider), const LocalDate(2026, 10, 1));
      await closeApp(tester);
    });

    testWidgets('first month: no comparison, only the months with spending (png 020)', (tester) async {
      final subs = [
        for (final s in Mock.all)
          if (s.status == SubscriptionStatus.active) s.copyWith(startDate: const LocalDate(2026, 11, 1)),
      ];
      await pumpApp(tester, subscriptions: subs, periods: const []);
      expect(find.text('First month — no comparison yet'), findsOneWidget);
      expect(find.textContaining(' vs '), findsNothing);
      expect(find.text('Oct'), findsOneWidget);
      expect(find.text('Nov'), findsOneWidget);
      expect(find.text('Sep'), findsNothing);
      await closeApp(tester);
    });

    testWidgets('upcoming payments strip + See all → Calendar (png 013)', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, find.text('Upcoming payments'));
      expect(find.text('Next 30 days: ≈ ₫876,800 in 6 charges'), findsOneWidget);
      expect(find.text('To confirm'), findsWidgets);
      expect(find.text('First charge · 2 days left'), findsOneWidget);
      expect(find.text('3 days left'), findsOneWidget);
      final semantics = tester.ensureSemantics();
      await tester.pump();
      expect(find.bySemanticsLabel('Mark Viettel 5G paid'), findsOneWidget);
      semantics.dispose();
      await tester.tap(find.text('See all'));
      await settle(tester);
      expect(location(tester), '/calendar');
      await closeApp(tester);
    });

    testWidgets('✓ on an awaiting card opens the confirm sheet', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, find.text('Upcoming payments'));
      await tester.tap(find.byIcon(AppIcons.check).first);
      await settle(tester);
      expect(location(tester), '/confirm/viettel');
      await closeApp(tester);
    });

    testWidgets('library price notice: Update / Keep old price (png 017)', (tester) async {
      late FakeNoticeActions actions;
      await pumpApp(
        tester,
        overrides: [
          priceChangeNoticesProvider.overrideWithValue([youtubeNotice()]),
          priceNoticeActionsProvider.overrideWith((ref) => actions = FakeNoticeActions(ref)),
        ],
      );
      await scrollToFinder(tester, find.text('Keep old price'));
      expect(find.text('YouTube Premium changed its price'), findsOneWidget);
      expect(find.text('₫179,000 → ₫199,000'), findsOneWidget);
      expect(find.text('Your share goes from ₫35,800 to ₫39,800, from the 22 Nov renewal.'), findsOneWidget);
      await tester.tap(find.text('Update'));
      await settle(tester);
      expect(actions.updated, ['youtube']);
      expect(find.text('YouTube Premium: ₫199,000 from 22 Nov'), findsOneWidget);
      await tester.tap(find.text('Keep old price'));
      await settle(tester);
      expect(actions.kept, ['youtube']);
      await closeApp(tester);
    });

    testWidgets('list: Active sorted by due date, awaiting on top; rows per state (png 014)', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, row('google1'));
      expect(order(tester, ['viettel', 'netflix', 'chatgpt', 'icloud', 'youtube', 'canva', 'google1']), [
        'viettel',
        'netflix',
        'chatgpt',
        'icloud',
        'youtube',
        'canva',
        'google1',
      ]);
      expect(find.descendant(of: row('viettel'), matching: find.text('To confirm')), findsOneWidget);
      expect(find.descendant(of: row('viettel'), matching: find.byIcon(AppIcons.awaiting)), findsOneWidget);
      expect(find.descendant(of: row('netflix'), matching: find.text('4 Nov · Visa')), findsOneWidget);
      expect(find.descendant(of: row('netflix'), matching: find.text('₫65,000')), findsOneWidget);
      expect(find.descendant(of: row('netflix'), matching: find.text('÷4')), findsOneWidget);
      expect(find.descendant(of: row('netflix'), matching: find.text('Monthly')), findsOneWidget);
      expect(find.descendant(of: row('chatgpt'), matching: find.text('3 days left · 7 Nov')), findsOneWidget);
      expect(find.descendant(of: row('chatgpt'), matching: find.text(r'$20.00')), findsOneWidget);
      expect(find.descendant(of: row('chatgpt'), matching: find.text('≈ ₫508,000')), findsOneWidget);
      expect(find.descendant(of: row('canva'), matching: find.text('2 Feb 2027')), findsOneWidget);
      expect(find.descendant(of: row('canva'), matching: find.text('Yearly')), findsOneWidget);
      expect(find.descendant(of: row('chatgpt'), matching: find.byIcon(LucideIcons.arrowUp)), findsNothing);
      await closeApp(tester);
    });

    testWidgets('↑ on a row whose price went up in the last 90 days', (tester) async {
      await pumpApp(
        tester,
        overrides: [
          recentlyIncreasedIdsProvider.overrideWithValue({'chatgpt'}),
        ],
      );
      await scrollToFinder(tester, row('chatgpt'));
      expect(find.descendant(of: row('chatgpt'), matching: find.byIcon(LucideIcons.arrowUp)), findsOneWidget);
      final semantics = tester.ensureSemantics();
      await tester.pump();
      expect(find.bySemanticsLabel(RegExp('ChatGPT Plus.*Price went up', dotAll: true)), findsOneWidget);
      semantics.dispose();
      await closeApp(tester);
    });

    testWidgets('sort sheet: Price, Name, Recently added (png 023), remembered', (tester) async {
      final app = await pumpApp(tester);
      Future<void> pick(String label) async {
        await scrollToFinder(tester, find.text('Sort'));
        await tester.tap(find.text('Sort'));
        await tester.pumpAndSettle();
        expect(find.text('Sort by'), findsOneWidget);
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
        expect(find.text('Sort by'), findsNothing, reason: 'a pick closes the sheet');
      }

      await scrollToFinder(tester, find.text('Sort'));
      await tester.tap(find.text('Sort'));
      await tester.pumpAndSettle();
      expect(find.text('Next payment'), findsOneWidget);
      expect(find.text('Recently added'), findsOneWidget);
      await tester.tapAt(const Offset(10, 100)); // scrim closes it
      await tester.pumpAndSettle();
      await pick('Price');
      await scrollToFinder(tester, row('youtube'));
      // Awaiting rows stay on top whatever the order.
      expect(order(tester, ['viettel', 'netflix', 'chatgpt', 'icloud', 'youtube', 'canva', 'google1']), [
        'viettel',
        'netflix',
        'chatgpt',
        'google1',
        'canva',
        'icloud',
        'youtube',
      ]);
      await pick('Name');
      await scrollToFinder(tester, row('youtube'));
      expect(order(tester, ['viettel', 'netflix', 'chatgpt', 'icloud', 'youtube', 'canva', 'google1']), [
        'viettel',
        'netflix',
        'canva',
        'chatgpt',
        'google1',
        'icloud',
        'youtube',
      ]);
      expect(await app.container.read(settingsRepositoryProvider).load().then((s) => s.homeSort), 'name');
      await pick('Recently added');
      expect(await app.container.read(settingsRepositoryProvider).load().then((s) => s.homeSort), 'recent');
      await closeApp(tester);
    });

    testWidgets('Trial tab: note + trial row', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, segment('Trial'));
      await tester.tap(segment('Trial').last);
      await tester.pumpAndSettle();
      await scrollToFinder(tester, row('spotify'));
      expect(find.descendant(of: row('spotify'), matching: find.text('Trial')), findsOneWidget);
      expect(find.descendant(of: row('spotify'), matching: find.text('2 days left · 6 Nov')), findsOneWidget);
      expect(find.text('Trials aren’t in your monthly total until they turn into paid subscriptions.'), findsOneWidget);
      expect(row('netflix'), findsNothing);
      await closeApp(tester);
    });

    testWidgets('Paused tab: empty note (png 027)', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, segment('Paused'));
      await tester.tap(segment('Paused').last);
      await tester.pumpAndSettle();
      await scrollToFinder(tester, find.textContaining('Nothing paused.'));
      expect(
        find.text(
          'Nothing paused. Pause a subscription from its detail page — it stops counting from its next due date.',
        ),
        findsOneWidget,
      );
      await closeApp(tester);
    });

    testWidgets('Cancelled tab: saving line, newest cancellation first (png 026)', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, segment('Cancelled'));
      await tester.tap(segment('Cancelled').last);
      await tester.pumpAndSettle();
      await scrollToFinder(tester, row('applemusic'));
      expect(find.text('You’re saving ₫1,479,000 a year'), findsOneWidget);
      expect(order(tester, ['duolingo', 'applemusic']), ['duolingo', 'applemusic']);
      expect(find.text('Cancelled 12 Oct 2026'), findsOneWidget);
      expect(find.text('Cancelled 28 Sep 2026'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('2 periods waiting: count, total and ×2 (png 018)', (tester) async {
      await pumpApp(tester, subscriptions: Mock.many);
      expect(find.text('3 payments to confirm'), findsOneWidget);
      expect(find.text('₫365,000'), findsOneWidget);
      await tester.tap(find.text('3 payments to confirm'));
      await settle(tester);
      expect(location(tester), '/awaiting');
      await tester.pageBack();
      await settle(tester);
      await scrollToFinder(tester, row('viettel'));
      expect(find.descendant(of: row('viettel'), matching: find.text('×2')), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('offline rates chip + reminders off banner (png 019)', (tester) async {
      final app = await pumpApp(
        tester,
        remindersOn: false,
        rates: Mock.rates.copyWith(fetchedAt: now.subtract(const Duration(days: 3))),
      );
      expect(find.text('Reminders are off'), findsOneWidget);
      await tester.tap(find.text('Turn on'));
      await settle(tester);
      expect(app.notifications.permissionRequests, 1);
      expect(app.notifications.settingsOpened, 0);
      await scrollToFinder(tester, find.text('Offline · rates from 3 days ago'));
      expect(find.byIcon(AppIcons.offline), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('Turn on after the user denied the OS prompt → opens system notification settings', (tester) async {
      // Real phone (2026-11-05): once denied, Android stops showing the prompt and "Turn on" did nothing.
      final app = await pumpApp(tester, remindersOn: false);
      app.notifications.grant = false;
      await tester.tap(find.text('Turn on'));
      await settle(tester);
      expect(app.notifications.permissionRequests, 1);
      expect(app.notifications.settingsOpened, 1);
      await closeApp(tester);
    });

    testWidgets('fresh rates or no foreign currency → no offline chip', (tester) async {
      await pumpApp(tester, rates: Mock.rates.copyWith(fetchedAt: now.subtract(const Duration(hours: 20))));
      expect(find.byIcon(AppIcons.offline), findsNothing);
      await closeApp(tester);
    });

    testWidgets('empty: zero cost card, illustration, Browse services → catalog (png 021)', (tester) async {
      await pumpApp(tester, subscriptions: const [], periods: const []);
      expect(find.text('₫0'), findsOneWidget);
      expect(find.text('Monthly cost'), findsOneWidget);
      expect(find.text('No subscriptions yet'), findsOneWidget);
      expect(find.text('Paid'), findsNothing);
      expect(find.text('Add your first subscription'), findsOneWidget);
      expect(find.text('Pick from 500+ services with their logos and prices — most take three taps.'), findsOneWidget);
      await tester.tap(find.text('Browse services'));
      await settle(tester);
      expect(location(tester), '/catalog');
      await closeApp(tester);
    });

    testWidgets('FAB opens the catalog', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byTooltip('Add subscription'));
      await settle(tester);
      expect(location(tester), '/catalog');
      await closeApp(tester);
    });

    testWidgets('search: own subscriptions, library results, no match, Cancel (png 029)', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byTooltip('Search subscriptions'));
      await tester.pumpAndSettle();
      expect(find.byType(FloatingActionButton), findsNothing);
      await tester.enterText(find.byType(TextField), 'tube');
      await tester.pumpAndSettle();
      expect(row('youtube'), findsOneWidget);
      expect(row('netflix'), findsNothing);
      expect(find.text('YOUR SUBSCRIPTIONS'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'VIET');
      await tester.pumpAndSettle();
      expect(row('viettel'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'disney');
      await tester.pumpAndSettle();
      expect(find.text('ADD FROM THE LIBRARY'), findsOneWidget);
      expect(find.textContaining('Disney+'), findsWidgets);
      await tester.enterText(find.byType(TextField), 'zzzq');
      await tester.pumpAndSettle();
      expect(find.text('No subscription matches “zzzq”.'), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.text('Monthly cost'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('search: a library result opens the form for that service', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byTooltip('Search subscriptions'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'disney');
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('Disney+').first);
      // The form keeps a spinner while the catalog plan loads: pump instead of settling.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(location(tester), startsWith('/subscription/new?service=disney'));
      await closeApp(tester);
    });

    testWidgets('search finds cancelled ones too and opens the detail', (tester) async {
      await pumpApp(tester);
      await tester.tap(find.byTooltip('Search subscriptions'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'duo');
      await tester.pumpAndSettle();
      await tester.tap(row('duolingo'));
      await settle(tester);
      expect(location(tester), '/subscription/duolingo');
      await closeApp(tester);
    });

    testWidgets('swipe → Confirm opens the confirm sheet (png 025)', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, row('netflix'));
      await tester.drag(row('netflix'), const Offset(-170, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: row('netflix'), matching: find.text('Confirm')));
      await settle(tester);
      expect(find.text('Did you pay Netflix?'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('swipe → Cancel → dialog → celebration → See cancelled', (tester) async {
      final app = await pumpApp(tester);
      await scrollToFinder(tester, row('icloud'));
      await tester.drag(row('icloud'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: row('icloud'), matching: find.text('Cancel')));
      await tester.pumpAndSettle();
      expect(find.text('Mark iCloud+ 200GB as cancelled?'), findsOneWidget);
      await tester.tap(find.text('Mark as cancelled'));
      await settle(tester);
      expect(find.text('iCloud+ 200GB cancelled'), findsOneWidget);
      expect((await app.sub('icloud'))!.status, SubscriptionStatus.cancelled);
      await tester.tap(find.text('See cancelled'));
      await settle(tester);
      expect(row('icloud'), findsOneWidget);
      expect(find.text('Cancelled 4 Nov 2026'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('swipe → Cancel → Not yet keeps it', (tester) async {
      final app = await pumpApp(tester);
      await scrollToFinder(tester, row('icloud'));
      await tester.drag(row('icloud'), const Offset(-100, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.descendant(of: row('icloud'), matching: find.text('Cancel')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Not yet'));
      await settle(tester);
      expect((await app.sub('icloud'))!.status, SubscriptionStatus.active);
      await closeApp(tester);
    });

    testWidgets('trial card: How to cancel opens the cancel page; Keep it hides the card', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, find.text('How to cancel'));
      await tester.tap(find.text('How to cancel'));
      await settle(tester);
      expect(launched, ['https://www.spotify.com/account/subscription/']);
      await tester.tap(find.text('Keep it'));
      await tester.pumpAndSettle();
      expect(find.text('Spotify trial ends in 2 days'), findsNothing);
      expect(find.text('Keeping Spotify. The first charge is on Fri, 6 Nov.'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('Keep it is stored: the card stays hidden after a restart; cleared once the trial ends', (
      tester,
    ) async {
      // Real phone QA: "Keep it" only lasted for the session — the card came back after reopening.
      final app = await pumpApp(tester);
      await scrollToFinder(tester, find.text('Keep it'));
      await tester.tap(find.text('Keep it'));
      await settle(tester);
      final settings = app.container.read(settingsRepositoryProvider);
      expect((await tester.runAsync(settings.load))!.keptTrials, {'spotify'});
      // "Restart": a fresh provider reads the stored set.
      app.container.invalidate(keptTrialsProvider);
      await settle(tester);
      expect(app.container.read(keptTrialsProvider), {'spotify'});
      expect(find.text('Spotify trial ends in 2 days'), findsNothing);
      // The trial turns Active (or is cancelled) → the id is dropped from the store.
      final repo = app.container.read(subscriptionRepositoryProvider);
      await tester.runAsync(() async {
        final s = (await repo.get('spotify'))!;
        await repo.save(s.copyWith(status: SubscriptionStatus.active));
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await settle(tester);
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 50)));
      expect((await tester.runAsync(settings.load))!.keptTrials, isEmpty);
      await closeApp(tester);
    });

    testWidgets('the trial card opens its subscription', (tester) async {
      await pumpApp(tester);
      await scrollToFinder(tester, find.text('Spotify trial ends in 2 days'));
      await tester.tap(find.text('Spotify trial ends in 2 days'));
      await settle(tester);
      expect(location(tester), '/subscription/spotify');
      await closeApp(tester);
    });

    testWidgets('Vietnamese strings (png 012 VI)', (tester) async {
      await pumpApp(tester, setup: const Setup(locale: 'vi'));
      expect(find.text('Thứ Tư, 4 tháng 11'), findsOneWidget);
      expect(find.text('Tổng quan'), findsWidgets);
      expect(find.text('Chi phí hàng tháng'), findsOneWidget);
      expect(find.text('1.133.466đ'), findsNWidgets(2));
      expect(find.text('750đ so với thg 10'), findsOneWidget);
      expect(find.text('8 gói đang hoạt động · ≈ 37.782đ mỗi ngày'), findsOneWidget);
      expect(find.text('Còn phải thanh toán'), findsOneWidget);
      expect(find.text('Thg 11'), findsOneWidget);
      await scrollToFinder(tester, find.text('2 khoản cần xác nhận'));
      await scrollToFinder(tester, find.text('Giữ lại'));
      expect(find.text('Dùng thử Spotify kết thúc trong 2 ngày'), findsOneWidget);
      expect(find.text('Sẽ có giá 59.000đ vào 6/11'), findsOneWidget);
      expect(find.text('Xem gói'), findsOneWidget);
      await scrollToFinder(tester, find.text('Thanh toán sắp tới'));
      expect(find.text('Lần trừ đầu · còn 2 ngày'), findsOneWidget);
      await scrollToFinder(tester, find.text('Gói đăng ký'));
      expect(segment('Tạm dừng'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('touch targets ≥ 48dp and labelled (S-50)', (tester) async {
      await pumpApp(tester, remindersOn: false);
      final handle = tester.ensureSemantics();
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await scrollToFinder(tester, find.text('Upcoming payments'));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      await scrollToFinder(tester, row('google1'));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
      await closeApp(tester);
    });

    testWidgets('text contrast (light + dark)', (tester) async {
      for (final dark in [false, true]) {
        await pumpApp(tester, setup: Setup(dark: dark));
        final handle = tester.ensureSemantics();
        await expectLater(tester, meetsGuideline(textContrastGuideline));
        handle.dispose();
        await closeApp(tester);
      }
    });

    // Real phone (2026-11-05): the system's largest display size leaves 320dp; with 200% text the
    // awaiting card squeezed its title one word per line and amounts wrapped between digits.
    group('narrowest phone: 320dp × 200% text', () {
      for (final locale in ['en', 'vi']) {
        for (final dark in [false, true]) {
          final s = Setup(width: 320, height: 700, locale: locale, dark: dark, textScale: 2);
          testWidgets(s.name, (tester) async {
            await pumpApp(tester, setup: s, subscriptions: Mock.all, remindersOn: false);
            final pill = find.byKey(const ValueKey('awaiting-review'));
            await scrollToFinder(tester, pill);
            final title = find.textContaining(locale == 'en' ? 'to confirm' : 'cần xác nhận');
            expect(
              tester.getTopLeft(pill).dy,
              greaterThan(tester.getBottomLeft(title.first).dy),
              reason: 'Review goes under the text at large sizes',
            );
            await scrollThrough(tester);
            expectNoLayoutErrors(tester);
            await closeApp(tester);
          });
        }
      }
    });

    group('no overflow: 360/390 × EN/VI × light/dark × 100/130/200%', () {
      for (final s in layoutMatrix) {
        testWidgets(s.name, (tester) async {
          for (final subs in [Mock.all, Mock.many]) {
            await pumpApp(tester, setup: s, subscriptions: subs, remindersOn: false);
            expect(find.byType(HomeScreen), findsOneWidget);
            await scrollThrough(tester);
            expectNoLayoutErrors(tester);
            // Yearly mode and the Cancelled tab (saving line) too.
            await tester.drag(find.byType(Scrollable).first, const Offset(0, 5000));
            await tester.pumpAndSettle();
            await tester.tap(find.text(s.locale == 'en' ? 'Yearly cost' : 'Chi phí hàng năm'));
            await tester.pumpAndSettle();
            await scrollThrough(tester);
            expectNoLayoutErrors(tester);
            await closeApp(tester);
          }
          await pumpApp(tester, setup: s, subscriptions: const [], periods: const []);
          expectNoLayoutErrors(tester);
          await closeApp(tester);
        });
      }
    });
  });

  test('row helpers: meta line and amounts (mockup v14 row())', () async {
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    expect(dueWhen(l, const LocalDate(2026, 11, 4), today), 'Today · 4 Nov');
    expect(dueWhen(l, const LocalDate(2026, 11, 5), today), 'Tomorrow · 5 Nov');
    expect(dueWhen(l, const LocalDate(2026, 12, 4), today), '30 days left · 4 Dec');
    expect(dueWhen(l, const LocalDate(2027, 2, 2), today), '2 Feb 2027');
  });
}
