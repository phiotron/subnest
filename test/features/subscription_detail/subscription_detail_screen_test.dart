import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:subnest/core/widgets/widgets.dart';
import 'package:subnest/data/catalog/catalog_providers.dart';
import 'package:subnest/data/providers.dart';
import 'package:subnest/domain/domain.dart';

import 'detail_harness.dart';

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

Finder rich(String text) => find.textContaining(text, findRichText: true);

/// Netflix: ₫200,000 (backfill, Nov 2025) → ₫220,000 → ₫260,000 (you changed it, Aug 2026).
final netflixHistory = [
  priceChange(
    Mock.netflix,
    from: 200000,
    to: 220000,
    on: const LocalDate(2025, 11, 4),
    source: PriceChangeSource.backfill,
  ),
  priceChange(Mock.netflix, from: 220000, to: 260000, on: const LocalDate(2026, 8, 4)),
];

/// YouTube: library raised ₫179,000 → ₫199,000 from the next payment (22 Nov), and a decrease before.
final youtubeHistory = [
  priceChange(
    Mock.youtube,
    from: 189000,
    to: 179000,
    on: const LocalDate(2026, 3, 22),
    source: PriceChangeSource.manual,
  ),
  priceChange(
    Mock.youtube,
    from: 179000,
    to: 199000,
    on: const LocalDate(2026, 11, 22),
    source: PriceChangeSource.catalog,
  ),
];

final pausedIcloud = Mock.icloud.copyWith(status: SubscriptionStatus.paused, pausedFrom: const LocalDate(2026, 10, 15));
final autoChatgpt = Mock.chatgpt.copyWith(detectionSource: DetectionSource.scan, detectedAt: now);

/// Every subscription with [replace] swapped in by id.
List<Subscription> withSubs(List<Subscription> replace) => [
  for (final s in Mock.all) replace.firstWhere((r) => r.id == s.id, orElse: () => s),
];

PriceChangeNotice youtubeNotice() {
  const plan = CatalogPlan(
    id: 'family',
    name: 'Family',
    cycle: BillingCycle.monthly(),
    prices: {'VN': CatalogPrice('VND', 199000)},
  );
  const service = CatalogService(
    id: 'youtube-premium',
    name: 'YouTube Premium',
    category: SubscriptionCategory.video,
    colorValue: 0xFFE6002E,
    monogram: 'YT',
    plans: [plan],
  );
  return PriceChangeNotice(
    subscription: Mock.youtube,
    service: service,
    plan: plan,
    region: 'VN',
    oldPriceMinor: 179000,
    newPrice: plan.prices['VN']!,
  );
}

class RecordingNoticeActions extends PriceNoticeActions {
  RecordingNoticeActions(super.ref);

  final kept = <PriceChangeNotice>[];

  @override
  Future<void> keepOldPrice(PriceChangeNotice notice) async => kept.add(notice);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await loadTestFonts();
  });

  group('S5 Detail', () {
    testWidgets('044/048/049 awaiting + shared: hero, cycle chips, banner, info card, history', (tester) async {
      await pumpDetail(tester, location: '/subscription/netflix');
      expect(find.text('Netflix Premium'), findsOneWidget);
      expect(find.text('To confirm'), findsWidgets);
      expect(find.text('Monthly'), findsNWidgets(2)); // hero chip + Billing cycle row
      expect(find.text('Your share · plan ₫260,000 ÷ 4'), findsOneWidget);
      expect(find.text('Payment on 4 Nov needs confirming'), findsOneWidget);
      expect(find.text('The next date waits until you say whether it was paid.'), findsOneWidget);
      expect(find.text('Next payment'), findsOneWidget);
      expect(find.text('Waiting for your confirmation'), findsOneWidget);
      expect(find.text('Wed, 4 Nov'), findsOneWidget);
      expect(find.text('Billing cycle'), findsOneWidget);
      expect(find.text('On the day, 3 days before'), findsOneWidget);
      expect(find.text('Video'), findsOneWidget);
      expect(find.text('Visa ••4242'), findsOneWidget);
      await scrollToFinder(tester, find.text('Worth it?'));
      expect(find.text('₫260,000'), findsOneWidget); // total paid (4 × ₫65,000)
      expect(find.text('Not rated'), findsOneWidget);
      expect(find.text('Shared with Minh, Lan and Huy'), findsOneWidget);
      await scrollToFinder(tester, find.text('4 Jun 2026'));
      expect(find.text('PRICE HISTORY'), findsOneWidget);
      expect(find.text('The price has never changed.'), findsOneWidget);
      expect(find.text('PAYMENT HISTORY'), findsOneWidget);
      expect(find.text('4 Nov 2026'), findsOneWidget);
      expect(find.text('Paid'), findsNWidgets(4));
      expect(find.text('Didn’t pay'), findsOneWidget);
      expect(find.text('—'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('045 price history: newest first, ↑ amber +, source, started at', (tester) async {
      await pumpDetail(tester, location: '/subscription/netflix', priceChanges: netflixHistory);
      await scrollToFinder(tester, find.text('PRICE HISTORY'));
      await scrollToFinder(tester, rich('Started at'));
      final rows = [
        find.text('₫220,000 → ₫260,000'),
        find.text('₫200,000 → ₫220,000'),
        find.text('Started at ₫200,000'),
      ];
      for (final r in rows) {
        expect(r, findsOneWidget);
      }
      expect(tester.getTopLeft(rows[0]).dy, lessThan(tester.getTopLeft(rows[1]).dy));
      expect(tester.getTopLeft(rows[1]).dy, lessThan(tester.getTopLeft(rows[2]).dy));
      expect(find.text('+₫40,000'), findsOneWidget);
      expect(find.text('+₫20,000'), findsOneWidget);
      expect(rich('4 Aug 2026 · '), findsOneWidget);
      expect(rich('You changed it'), findsOneWidget);
      expect(rich('From past payments'), findsNWidgets(2)); // backfill row + started at
      final plus = tester.widget<Text>(find.text('+₫40,000'));
      expect(plus.style?.color, AppTheme.light().extension<AppColors>()!.warningInk);
      await closeApp(tester);
    });

    testWidgets('046 upcoming library change and a decrease (↓ green −)', (tester) async {
      await pumpDetail(tester, location: '/subscription/youtube', priceChanges: youtubeHistory);
      await scrollToFinder(tester, rich('Started at'));
      expect(find.text('₫179,000 → ₫199,000'), findsOneWidget);
      expect(rich('From 22 Nov 2026 · '), findsOneWidget);
      expect(rich('Library update · next payment'), findsOneWidget);
      expect(find.text('−₫10,000'), findsOneWidget);
      final minus = tester.widget<Text>(find.text('−₫10,000'));
      expect(minus.style?.color, AppTheme.light().extension<AppColors>()!.success);
      expect(find.text('Started at ₫189,000'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('payment row Confirm opens the confirm sheet', (tester) async {
      await pumpDetail(tester, location: '/subscription/netflix');
      await tester.tap(find.text('Confirm').first);
      await settle(tester);
      expect(find.text('Amount paid'), findsOneWidget);
      expect(find.text('Due today'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('edit a payment amount', (tester) async {
      final app = await pumpDetail(tester, location: '/subscription/netflix');
      await scrollToFinder(tester, find.text('4 Oct 2026'));
      await tester.tap(find.text('4 Oct 2026'));
      await tester.pumpAndSettle();
      expect(find.text('Payment · 4 Oct 2026'), findsOneWidget);
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

    testWidgets('mark a payment as not paid; the Due date does not move', (tester) async {
      final app = await pumpDetail(tester, location: '/subscription/netflix');
      await scrollToFinder(tester, find.text('4 Sep 2026'));
      await tester.tap(find.text('4 Sep 2026'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Mark as not paid'));
      await settle(tester);
      final p = (await app.periods()).firstWhere((p) => p.dueDate == const LocalDate(2026, 9, 4));
      expect(p.outcome, PeriodOutcome.skipped);
      expect(find.text('Didn’t pay'), findsNWidgets(2));
      expect((await app.sub('netflix'))!.dueDate, const LocalDate(2026, 11, 4));
      await closeApp(tester);
    });

    testWidgets('auto-confirmed payment: From screenshot · Undo removes it', (tester) async {
      final auto = ConfirmedPeriod(
        id: 'auto-oct',
        subscriptionId: 'icloud',
        dueDate: const LocalDate(2026, 10, 15),
        outcome: PeriodOutcome.payment,
        amountMinor: 59000,
        currency: 'VND',
        confirmedAt: now,
        source: DetectionSource.scan,
      );
      final app = await pumpDetail(tester, location: '/subscription/icloud', periods: [...Mock.periods, auto]);
      await scrollToFinder(tester, find.text('From screenshot'));
      await tester.tap(find.text('Undo'));
      await settle(tester);
      expect((await app.periods()).where((p) => p.id == 'auto-oct'), isEmpty);
      expect(find.text('Payment removed — that period waits for confirmation again.'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('How to cancel opens the Catalog cancel page', (tester) async {
      await pumpDetail(tester, location: '/subscription/netflix');
      await scrollToFinder(tester, find.text('How to cancel'));
      expect(find.text('Opens netflix.com account page'), findsOneWidget);
      await tester.tap(find.text('How to cancel'));
      await settle(tester);
      expect(launched, ['https://www.netflix.com/cancelplan']);
      await closeApp(tester);
    });

    testWidgets('Edit opens the form route', (tester) async {
      await pumpDetail(tester, location: '/home', push: '/subscription/netflix');
      await tester.tap(find.text('Edit'));
      // The form may still show its loading spinner (it reads the Catalog itself), so no settle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(location(tester), '/subscription/netflix/edit');
      await closeApp(tester);
    });

    testWidgets('062 delete: dialog → removed, back to Overview', (tester) async {
      final app = await pumpDetail(tester, location: '/home', push: '/subscription/netflix');
      await scrollToFinder(tester, find.text('Delete subscription'));
      await tester.tap(find.text('Delete subscription'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Netflix Premium?'), findsOneWidget);
      expect(
        find.text(
          'It and its payment and price history are removed for good. To stop reminders but keep the history, '
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
      expect(location(tester), '/home');
      await closeApp(tester);
    });

    testWidgets('047 trial: banner with the yearly saving, first payment', (tester) async {
      await pumpDetail(tester, location: '/subscription/spotify');
      expect(find.text('Trial · 2 days left'), findsOneWidget);
      expect(find.text('Trial ends Fri, 6 Nov'), findsOneWidget);
      expect(find.text('Then ₫59,000/month. Cancel before to save ₫708,000 a year.'), findsOneWidget);
      expect(find.text('First payment'), findsOneWidget);
      expect(find.text('in 2 days'), findsOneWidget);
      await scrollToFinder(tester, find.text('No payments yet — the first charge is on Fri, 6 Nov.'));
      expect(find.text('Pause'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('052 cancelled: savings banner, Restore', (tester) async {
      final app = await pumpDetail(tester, location: '/subscription/duolingo');
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Saving ₫699,000 a year'), findsOneWidget);
      expect(find.text('Cancelled 12 Oct 2026. No more reminders.'), findsOneWidget);
      expect(find.text('Next payment'), findsNothing);
      expect(find.text('Reminders'), findsNothing);
      await scrollToFinder(tester, find.text('Restore subscription'));
      expect(find.text('Mark as cancelled'), findsNothing);
      expect(find.text('Pause'), findsNothing);
      await tester.tap(find.text('Restore subscription'));
      await settle(tester);
      final s = (await app.sub('duolingo'))!;
      expect(s.status, SubscriptionStatus.active);
      expect(find.text('Restored. Next payment: Tue, 12 Oct 2027.'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('061/063 mark as cancelled → celebration → Done; Undo restores', (tester) async {
      final app = await pumpDetail(tester, location: '/home', push: '/subscription/canva');
      await scrollToFinder(tester, find.text('Mark as cancelled'));
      await tester.tap(find.text('Mark as cancelled'));
      await tester.pumpAndSettle();
      expect(find.text('Mark Canva Pro as cancelled?'), findsOneWidget);
      await tester.tap(find.text('Mark as cancelled').last);
      await settle(tester);
      expect(find.text('Nice — that’s ₫1,390,000 a year saved'), findsOneWidget);
      expect(find.textContaining('Canva Pro is marked as cancelled. Remember to cancel it on'), findsOneWidget);
      expect(find.text('Total saving'), findsOneWidget);
      expect(find.text('₫2,869,000 a year'), findsOneWidget);
      expect(find.text('from 3 cancelled subscriptions'), findsOneWidget);
      expect((await app.sub('canva'))!.status, SubscriptionStatus.cancelled);
      await tester.tap(find.text('Done'));
      await settle(tester);
      expect(find.text('Saving ₫1,390,000 a year'), findsOneWidget);
      // Again, then Undo.
      await tester.tap(find.text('Restore').first);
      await settle(tester);
      expect((await app.sub('canva'))!.status, SubscriptionStatus.active);
      await scrollToFinder(tester, find.text('Mark as cancelled'));
      await tester.tap(find.text('Mark as cancelled'));
      await tester.pumpAndSettle();
      expect(find.text('Mark Canva Pro as cancelled?'), findsOneWidget);
      await tester.tap(find.text('Mark as cancelled').last);
      await settle(tester);
      expect(find.text('Total saving'), findsOneWidget);
      expect((await app.sub('canva'))!.status, SubscriptionStatus.cancelled);
      await tester.tap(find.text('Undo'));
      await settle(tester);
      expect((await app.sub('canva'))!.status, SubscriptionStatus.active);
      await closeApp(tester);
    });

    testWidgets('059/050 pause from the next payment, then Undo', (tester) async {
      final app = await pumpDetail(tester, location: '/subscription/icloud');
      await scrollToFinder(tester, find.text('Pause'));
      await tester.tap(find.text('Pause'));
      await tester.pumpAndSettle();
      expect(find.text('Pause iCloud+ 200GB?'), findsOneWidget);
      expect(find.text('Now → 15 Nov'), findsOneWidget);
      expect(find.text('Still counted — you paid for this period'), findsOneWidget);
      expect(find.text('From Sun, 15 Nov'), findsOneWidget);
      await tester.tap(find.text('Pause from 15 Nov'));
      await settle(tester);
      final s = (await app.sub('icloud'))!;
      expect(s.status, SubscriptionStatus.paused);
      expect(s.pausedFrom, const LocalDate(2026, 11, 15));
      await tester.drag(find.byType(Scrollable).first, const Offset(0, 2000));
      await tester.pumpAndSettle();
      expect(find.text('Active'), findsOneWidget); // still counted until then
      expect(find.text('Pauses from Sun, 15 Nov'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      await settle(tester);
      final back = (await app.sub('icloud'))!;
      expect(back.status, SubscriptionStatus.active);
      expect(back.dueDate, const LocalDate(2026, 11, 15));
      await closeApp(tester);
    });

    testWidgets('051/060 paused: banner, Resume sheet picks the next payment', (tester) async {
      final app = await pumpDetail(tester, subscriptions: withSubs([pausedIcloud]), location: '/subscription/icloud');
      expect(find.text('Paused'), findsOneWidget);
      expect(find.text('Paused since 15 Oct 2026'), findsOneWidget);
      expect(find.text('No payments, no reminders, not counted.'), findsOneWidget);
      expect(find.text('Next payment'), findsNothing);
      await tester.tap(find.text('Resume').first);
      await tester.pumpAndSettle();
      expect(find.text('Resume iCloud+ 200GB'), findsOneWidget);
      expect(find.text('When is the next payment?'), findsOneWidget);
      await tester.tap(find.text('20'));
      await tester.pumpAndSettle();
      expect(find.text('Resume from 20 Nov'), findsOneWidget);
      await tester.tap(find.text('Resume from 20 Nov'));
      await settle(tester);
      final s = (await app.sub('icloud'))!;
      expect(s.status, SubscriptionStatus.active);
      expect(s.dueDate, const LocalDate(2026, 11, 20));
      expect(find.text('Resumed. Next payment: Fri, 20 Nov.'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('057/058 auto-detected: tag, banner, Remove → gone, back to Overview', (tester) async {
      final app = await pumpDetail(
        tester,
        subscriptions: withSubs([autoChatgpt]),
        location: '/home',
        push: '/subscription/chatgpt',
      );
      expect(find.text('Auto-detected'), findsOneWidget);
      expect(find.text('Added automatically'), findsOneWidget);
      expect(find.textContaining('Found in a screenshot on 4 Nov.'), findsOneWidget);
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(find.text('Remove ChatGPT Plus?'), findsOneWidget);
      expect(
        find.text('It was added from a screenshot. Subnest will remember and won’t add it again.'),
        findsOneWidget,
      );
      await tester.tap(find.text('Remove').last);
      await settle(tester);
      expect(await app.sub('chatgpt'), isNull);
      expect(location(tester), '/home');
      await closeApp(tester);
    });

    testWidgets('054/055 library price notice: Review → Update from the next payment', (tester) async {
      final app = await pumpDetail(
        tester,
        location: '/subscription/youtube',
        overrides: [subscriptionPriceNoticeProvider('youtube').overrideWithValue(youtubeNotice())],
      );
      expect(find.text('New library price: ₫199,000'), findsOneWidget);
      expect(find.text('You pay ₫179,000. Update from the next payment, or keep your price.'), findsOneWidget);
      await tester.tap(find.text('Review'));
      await tester.pumpAndSettle();
      expect(find.text('Update the price?'), findsOneWidget);
      expect(find.text('You pay now'), findsOneWidget);
      expect(find.text('New price'), findsOneWidget);
      expect(find.text('your share ₫35,800'), findsOneWidget);
      expect(find.text('your share ₫39,800'), findsOneWidget);
      expect(find.text('Keep ₫179,000'), findsOneWidget);
      await tester.tap(find.text('Update from 22 Nov'));
      await settle(tester);
      expect((await app.sub('youtube'))!.priceMinor, 199000);
      expect(find.text('New price from 22 Nov'), findsOneWidget);
      final history = await app.container
          .read(subscriptionRepositoryProvider)
          .allPriceChanges(subscriptionId: 'youtube');
      expect(history.single.source, PriceChangeSource.catalog);
      await closeApp(tester);
    });

    testWidgets('055 Keep the old price is remembered', (tester) async {
      late RecordingNoticeActions actions;
      final app = await pumpDetail(
        tester,
        location: '/subscription/youtube',
        overrides: [
          subscriptionPriceNoticeProvider('youtube').overrideWithValue(youtubeNotice()),
          priceNoticeActionsProvider.overrideWith((ref) => actions = RecordingNoticeActions(ref)),
        ],
      );
      await tester.tap(find.text('Review'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Keep ₫179,000'));
      await settle(tester);
      expect(actions.kept, hasLength(1));
      expect((await app.sub('youtube'))!.priceMinor, 179000);
      expect(find.text('Keeping ₫179,000. We won’t ask about this price again.'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('056 plan no longer sold: banner + library row', (tester) async {
      final notice = youtubeNotice();
      await pumpDetail(
        tester,
        location: '/subscription/youtube',
        overrides: [
          subscriptionPlanNoteProvider('youtube').overrideWithValue(
            CatalogPlanNote(kind: CatalogPlanNoteKind.discontinued, service: notice.service, plan: notice.plan),
          ),
        ],
      );
      expect(find.text('This plan is no longer sold'), findsOneWidget);
      expect(find.text('It left the library for new customers. Yours keeps its price and dates.'), findsOneWidget);
      await scrollToFinder(tester, find.text('Service library'));
      expect(find.text('No longer sold'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('foreign currency shows the converted amount', (tester) async {
      await pumpDetail(tester, location: '/subscription/chatgpt');
      expect(find.text(r'$20.00'), findsOneWidget);
      expect(find.text('≈ ₫508,000'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('Vietnamese', (tester) async {
      await pumpDetail(
        tester,
        setup: const Setup(locale: 'vi'),
        location: '/subscription/netflix',
      );
      expect(find.text('Chờ xác nhận'), findsWidgets);
      expect(find.text('Phần của bạn · gói 260.000đ ÷ 4'), findsOneWidget);
      expect(find.text('Kỳ 4/11 đang chờ xác nhận'), findsOneWidget);
      expect(find.text('Thanh toán tiếp theo'), findsOneWidget);
      expect(find.text('Hằng tháng'), findsNWidgets(2));
      expect(find.text('Đúng ngày, 3 ngày trước'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('320dp × 200% VI: info values sit under their labels (no mid-word breaks)', (tester) async {
      await pumpDetail(
        tester,
        setup: const Setup(width: 320, height: 700, locale: 'vi', textScale: 2),
        location: '/subscription/netflix',
        priceChanges: netflixHistory,
      );
      final label = find.text('Danh mục');
      await scrollToFinder(tester, label);
      final value = find.text('Video');
      expect(tester.getTopLeft(value).dy, greaterThan(tester.getBottomLeft(label).dy));
      expect(tester.getTopLeft(value).dx, tester.getTopLeft(label).dx);
      await scrollThrough(tester);
      expectNoLayoutErrors(tester);
      await closeApp(tester);
    });

    testWidgets('unknown id shows a message, not a crash', (tester) async {
      await pumpDetail(tester, location: '/subscription/nope');
      expect(find.text('This subscription no longer exists.'), findsOneWidget);
      await closeApp(tester);
    });

    testWidgets('touch targets ≥ 48dp, labelled; text contrast (light + dark)', (tester) async {
      for (final dark in [false, true]) {
        for (final id in ['netflix', 'spotify', 'duolingo', 'icloud']) {
          await pumpDetail(
            tester,
            setup: Setup(dark: dark),
            subscriptions: withSubs([pausedIcloud]),
            location: '/subscription/$id',
            priceChanges: id == 'netflix' ? netflixHistory : const [],
          );
          final handle = tester.ensureSemantics();
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
          handle.dispose();
          await closeApp(tester);
        }
      }
    });

    group('no overflow: 360/390 × EN/VI × light/dark × 100/130/200%', () {
      for (final s in layoutMatrix) {
        testWidgets(s.name, (tester) async {
          final notice = youtubeNotice();
          for (final id in ['netflix', 'spotify', 'duolingo', 'chatgpt', 'icloud', 'youtube']) {
            await pumpDetail(
              tester,
              setup: s,
              subscriptions: withSubs([pausedIcloud, autoChatgpt]),
              priceChanges: [...netflixHistory, ...youtubeHistory],
              location: '/subscription/$id',
              overrides: [
                subscriptionPriceNoticeProvider('youtube').overrideWithValue(notice),
                subscriptionPlanNoteProvider('youtube').overrideWithValue(
                  CatalogPlanNote(kind: CatalogPlanNoteKind.closedToNew, service: notice.service, plan: notice.plan),
                ),
              ],
            );
            await scrollThrough(tester);
            expectNoLayoutErrors(tester);
            await closeApp(tester);
          }
          // Sheets: pause, price notice; dialog: delete.
          await pumpDetail(tester, setup: s, location: '/subscription/icloud');
          await scrollToFinder(tester, find.byIcon(LucideIcons.pause));
          await tester.tap(find.byIcon(LucideIcons.pause).last);
          await tester.pumpAndSettle();
          expectNoLayoutErrors(tester);
          await closeApp(tester);
          await pumpDetail(
            tester,
            setup: s,
            location: '/subscription/youtube',
            overrides: [subscriptionPriceNoticeProvider('youtube').overrideWithValue(notice)],
          );
          await tester.tap(find.text(s.locale == 'vi' ? 'Xem' : 'Review'));
          await tester.pumpAndSettle();
          expectNoLayoutErrors(tester);
          await closeApp(tester);
          await pumpDetail(tester, setup: s, subscriptions: withSubs([pausedIcloud]), location: '/subscription/icloud');
          await tester.tap(find.text(s.locale == 'vi' ? 'Bật lại' : 'Resume').first);
          await tester.pumpAndSettle();
          expectNoLayoutErrors(tester);
          await closeApp(tester);
        });
      }
    });
  });
}
