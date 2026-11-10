import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/data/catalog_repository.dart';
import 'package:subnest/domain/domain.dart';

import 'fixtures.dart';

LocalDate d(int y, int m, int day) => LocalDate(y, m, day);

const _vnd = SpendingCalculator(rates: ExchangeRates(usdRates: {'USD': 1, 'VND': 25000}), primaryCurrency: 'VND');

void main() {
  group('Paused', () {
    final today = d(2026, 11, 10);
    test('pause takes effect from the next Due date; nothing due, no totals, no reminders', () {
      final s = BillingRules.pause(sub(anchor: d(2026, 11, 15)), today, fixedNow);
      expect(s.status, SubscriptionStatus.paused);
      expect(s.pausedFrom, d(2026, 11, 15));
      expect(BillingRules.isAwaitingConfirmation(s, d(2026, 12, 1)), isFalse);
      expect(BillingRules.pendingDueDates(s, d(2027, 1, 1)), isEmpty);
      expect(BillingRules.dueDatesBetween(s, today, d(2027, 1, 1)), isEmpty);
      final sum = _vnd.summary([s], today);
      expect(sum.monthly, 0);
      expect(sum.pausedCount, 1);
      expect(ReminderPlanner.plan([s], now: fixedNow, hour: 9, minute: 0), isEmpty);
    });

    test('resume re-anchors on the picked Due date', () {
      final paused = BillingRules.pause(sub(anchor: d(2026, 11, 15), periodIndex: 3), today, fixedNow);
      final s = BillingRules.resume(paused, d(2027, 2, 1), fixedNow);
      expect(s.status, SubscriptionStatus.active);
      expect(s.pausedFrom, isNull);
      expect(s.dueDate, d(2027, 2, 1));
      expect(s.periodIndex, 0);
    });

    test('pause/resume are no-ops in the wrong state', () {
      final c = sub(status: SubscriptionStatus.cancelled);
      expect(identical(BillingRules.pause(c, today, fixedNow), c), isTrue);
      final a = sub();
      expect(identical(BillingRules.resume(a, today, fixedNow), a), isTrue);
    });
  });

  group('Reminder offsets', () {
    test('legacy single value ↔ set', () {
      expect(ReminderOffsets.fromLegacyDays(null), isNull);
      expect(ReminderOffsets.fromLegacyDays(ReminderDays.off), isEmpty);
      expect(ReminderOffsets.fromLegacyDays(0), {0});
      expect(ReminderOffsets.fromLegacyDays(3), {0, 3});
      expect(ReminderOffsets.toLegacyDays({0, 1, 7}), 7);
      expect(ReminderOffsets.toLegacyDays(const {}), ReminderDays.off);
      expect(ReminderOffsets.encode({7, 0, 3}), '0,3,7');
      expect(ReminderOffsets.decode(''), isEmpty);
      expect(ReminderOffsets.decode('0,x,3'), {0, 3});
    });

    test('planner schedules one reminder per offset', () {
      final s = sub(anchor: d(2026, 11, 20)).copyWith(reminderOffsets: {0, 1, 3, 7});
      final plan = ReminderPlanner.plan([s], now: fixedNow, hour: 9, minute: 0);
      expect(plan.map((r) => r.daysBefore), [7, 3, 1, 0]);
      expect(plan.last.kind, ReminderKind.dueToday);
      expect(plan.first.kind, ReminderKind.renewalSoon);
    });

    test('null on the subscription uses Settings offsets; empty = off', () {
      final s = sub(anchor: d(2026, 11, 20));
      expect(ReminderPlanner.plan([s], now: fixedNow, defaultOffsets: {1}, hour: 9, minute: 0).single.daysBefore, 1);
      expect(ReminderPlanner.plan([s], now: fixedNow, defaultOffsets: const {}, hour: 9, minute: 0), isEmpty);
    });
  });

  group('Category', () {
    test('seed has the 11 built-ins with id = key', () {
      final seed = CategoryRules.seed();
      expect(seed, hasLength(11));
      expect(seed.every((c) => c.id == c.builtInKey && c.isBuiltIn), isTrue);
    });

    test('deleting moves subscriptions to the target (default other); other cannot be deleted', () {
      expect(CategoryRules.reassignTarget('video', null), 'other');
      expect(CategoryRules.reassignTarget('custom-1', 'music'), 'music');
      expect(() => CategoryRules.reassignTarget('other', 'music'), throwsStateError);
      expect(() => CategoryRules.reassignTarget('music', 'music'), throwsArgumentError);
      expect(CategoryRules.resolve('gone', {'video', 'other'}), 'other');
    });

    test('legacy category argument maps to categoryId', () {
      expect(sub(category: SubscriptionCategory.music).categoryId, 'music');
      expect(sub().copyWith(categoryId: 'custom-1').category, SubscriptionCategory.other);
    });
  });

  group('Auto-detection (ADR 0003)', () {
    final netflix = CatalogService(
      id: 'netflix',
      name: 'Netflix',
      category: SubscriptionCategory.video,
      colorValue: 0xFFE50914,
      monogram: 'N',
      aliases: const ['nf'],
      storeNames: const ['Netflix Premium'],
      plans: [
        CatalogPlan(id: 'basic', name: 'Basic', cycle: const BillingCycle.monthly(), prices: const {'VN': CatalogPrice('VND', 114000)}),
        CatalogPlan(id: 'premium', name: 'Premium', cycle: const BillingCycle.monthly(), prices: const {'VN': CatalogPrice('VND', 260000)}),
      ],
    );
    final matcher = ChargeMatcher(catalog: [netflix], region: 'VN');
    final today = d(2026, 11, 20);

    DetectedCharge charge(String name, int amount, LocalDate date, {bool renewal = false}) => DetectedCharge(
      name: name,
      amountMinor: amount,
      currency: 'VND',
      date: date,
      source: DetectionSource.scan,
      isRenewal: renewal,
    );

    List<DetectionAction> run(List<DetectedCharge> c, {List<Subscription> subs = const [], List<DetectedCharge> unmatched = const [], Set<String> dismissed = const {}}) =>
        matcher.match(c, subscriptions: subs, unmatched: unmatched, dismissed: dismissed, today: today, now: fixedNow, newId: idGen());

    test('Catalog match → auto-add with Auto-detected source and first Payment; plan closest by price', () {
      final a = run([charge('NETFLIX.COM', 260000, d(2026, 11, 18))]).single as AutoAddAction;
      expect(a.subscription.serviceId, 'netflix');
      expect(a.subscription.name, 'Netflix Premium');
      expect(a.subscription.isAutoDetected, isTrue);
      expect(a.subscription.detectionSource, DetectionSource.scan);
      expect(a.subscription.categoryId, 'video');
      expect(a.subscription.dueDate, d(2026, 12, 18));
      expect(a.payment!.source, DetectionSource.scan);
      expect(a.payment!.dueDate, d(2026, 11, 18));
    });

    test('renewal date from a store page → added without Payment, Due date = renewal', () {
      final a = run([charge('Netflix Premium', 260000, d(2026, 12, 3), renewal: true)]).single as AutoAddAction;
      expect(a.payment, isNull);
      expect(a.subscription.dueDate, d(2026, 12, 3));
    });

    test('dismissed service is never re-added', () {
      final a = run([charge('Netflix', 260000, d(2026, 11, 18))], dismissed: {DismissKey.service('netflix')}).single;
      expect((a as SkipAction).reason, DetectionSkipReason.dismissed);
    });

    test('unknown payee: first charge kept, second ~1 month later with same amount → added monthly', () {
      expect(run([charge('ACME CLOUD', 99000, d(2026, 10, 19))]).single, isA<KeepUnmatchedAction>());
      final first = charge('ACME CLOUD', 99000, d(2026, 10, 19)).withId('c1');
      final a = run([charge('ACME CLOUD', 99000, d(2026, 11, 19))], unmatched: [first]).single as AutoAddAction;
      expect(a.subscription.cycle, const BillingCycle.monthly());
      expect(a.subscription.name, 'Acme cloud');
      expect(a.consumedChargeIds, ['c1']);
      // Different amount → still unknown.
      expect(run([charge('ACME CLOUD', 120000, d(2026, 11, 19))], unmatched: [first]).single, isA<KeepUnmatchedAction>());
      // Same amount but 10 days apart → not a cycle.
      expect(run([charge('ACME CLOUD', 99000, d(2026, 10, 29))], unmatched: [first]).single, isA<KeepUnmatchedAction>());
    });

    test('sure match confirms the pending period with the charged amount; price unchanged', () {
      final s = sub(anchor: d(2026, 11, 18)).copyWith(serviceId: 'netflix');
      final a = run([charge('Netflix', 280000, d(2026, 11, 19))], subs: [s]).single as AutoConfirmAction;
      expect(a.result.period.amountMinor, 280000);
      expect(a.result.period.source, DetectionSource.scan);
      expect(a.result.period.dueDate, d(2026, 11, 18));
      expect(a.result.subscription.priceMinor, 260000);
      expect(a.result.subscription.dueDate, d(2026, 12, 18));
    });

    test('window [Due−3, Due+5] and ±20 % are the limits of a sure match', () {
      final s = sub(anchor: d(2026, 11, 18));
      expect(ChargeMatcher.isSureMatch(s, charge('Netflix', 260000, d(2026, 11, 15)), today), isTrue);
      expect(ChargeMatcher.isSureMatch(s, charge('Netflix', 260000, d(2026, 11, 14)), today), isFalse);
      expect(ChargeMatcher.isSureMatch(s, charge('Netflix', 260000, d(2026, 11, 23)), d(2026, 11, 25)), isTrue);
      expect(ChargeMatcher.isSureMatch(s, charge('Netflix', 260000, d(2026, 11, 24)), d(2026, 11, 25)), isFalse);
      expect(ChargeMatcher.isSureMatch(s, charge('Netflix', 312000, d(2026, 11, 18)), today), isTrue);
      expect(ChargeMatcher.isSureMatch(s, charge('Netflix', 313000, d(2026, 11, 18)), today), isFalse);
      final usd = DetectedCharge(name: 'Netflix', amountMinor: 260000, currency: 'USD', date: d(2026, 11, 18), source: DetectionSource.scan);
      expect(ChargeMatcher.isSureMatch(s, usd, today), isFalse);
    });

    test('unsure match is left to the user; paused subscription is not billed', () {
      final s = sub(anchor: d(2026, 11, 18));
      final a = run([charge('Netflix', 100000, d(2026, 11, 18))], subs: [s]).single as SkipAction;
      expect(a.reason, DetectionSkipReason.unsure);
      expect(a.candidate!.id, s.id);
      final p = BillingRules.pause(s, today, fixedNow);
      expect((run([charge('Netflix', 260000, d(2026, 11, 18))], subs: [p]).single as SkipAction).reason, DetectionSkipReason.notBilling);
    });

    test('several pending periods → not sure (backlog)', () {
      final s = sub(anchor: d(2026, 9, 18));
      expect(ChargeMatcher.isSureMatch(s, charge('Netflix', 260000, d(2026, 9, 18)), today), isFalse);
    });

    test('two charges of one batch never confirm the same period', () {
      final s = sub(anchor: d(2026, 11, 18));
      final r = run([charge('Netflix', 260000, d(2026, 11, 18)), charge('Netflix', 260000, d(2026, 11, 19))], subs: [s]);
      expect(r.first, isA<AutoConfirmAction>());
      expect(r.last, isA<SkipAction>());
    });

    test('undoConfirm steps back only for the latest period', () {
      final s = sub(anchor: d(2026, 11, 18));
      final r = BillingRules.confirmDetected(s, amountMinor: 1, source: DetectionSource.scan, today: today, now: fixedNow, newId: idGen());
      expect(BillingRules.undoConfirm(r.subscription, r.period, fixedNow).dueDate, d(2026, 11, 18));
      final rebased = BillingRules.rebase(r.subscription, d(2027, 1, 1), fixedNow);
      expect(identical(BillingRules.undoConfirm(rebased, r.period, fixedNow), rebased), isTrue);
    });

    test('alias matches only the whole read name', () {
      expect(matcher.matchService('NF'), isNull); // alias shorter than 3
      expect(matcher.matchService('Google Netflix Premium plan')?.id, 'netflix');
      expect(matcher.matchService('Netflixer'), isNull);
    });
  });

  group('Forecast & stats', () {
    final today = d(2026, 11, 10);
    final calc = ForecastCalculator(_vnd);
    final a = sub(id: 'a', anchor: d(2026, 11, 12), priceMinor: 100000);
    final b = sub(id: 'b', anchor: d(2026, 11, 25), priceMinor: 300000, category: SubscriptionCategory.music)
        .copyWith(worthIt: WorthIt.notWorth);
    final paused = BillingRules.pause(sub(id: 'c', anchor: d(2026, 11, 11)), today, fixedNow);

    test('next 30 days and 12 months come from real Due dates; Paused excluded', () {
      expect(calc.nextDays([a, b, paused], today), 400000);
      final months = calc.nextMonths([a, b, paused], today);
      expect(months, hasLength(12));
      expect(months.first.$2, 400000);
      expect(months[1].$1, d(2026, 12, 1));
      expect(months[1].$2, 400000);
    });

    test('week strip: 7 days from start with dots and total', () {
      final w = calc.week([a, b], today);
      expect(w.days, hasLength(7));
      expect(w.hasDueOn(2), isTrue);
      expect(w.total, 100000);
    });

    test('cost per day / week / month / year', () {
      final r = calc.rates([a], today);
      expect(r.monthly, 100000);
      expect(r.yearly, 1200000);
      expect(r.weekly, closeTo(1200000 / 52, 1e-6));
      expect(r.daily, closeTo(1200000 / 365, 1e-6));
    });

    test('budgets by category and overall; over → isOver', () {
      final usage = calc.budgets(
        const [
          Budget(id: 't', amountMinor: 350000, currency: 'VND'),
          Budget(id: 'm', categoryId: 'music', amountMinor: 200000, currency: 'VND'),
        ],
        [a, b],
        today,
      );
      expect(usage[0].spent, 400000);
      expect(usage[0].isOver, isTrue);
      expect(usage[1].ratio, 1.5);
    });

    test('dropping Not worth saves its yearly cost', () {
      expect(calc.notWorthSavingsYearly([a, b], today), 3600000);
    });
  });

  group('Catalog parse v3 / v4', () {
    const v3 = '''{"version":3,"services":[{"id":"x","name":"X","category":"video","color":"#112233","monogram":"X",
      "market":"vn","aliases":["x"],"plans":[{"id":"p","name":"P","cycle":{"unit":"month","count":1},
      "prices":{"VN":{"currency":"VND","amount":1000,"approx":true},"US":{"currency":"usd","amount":2}}}]}]}''';
    const v4 = '''{"schemaVersion":4,"version":4,"staleAfterDays":90,"services":[{"id":"y","name":"Y","category":"ai",
      "color":"#112233","monogram":"Y","market":"global","logoDomain":"y.com","storeNames":["Y Pro"],"aliases":[],
      "plans":[{"id":"a","name":"A","status":"closed_to_new","cycle":{"unit":"year","count":1},"prices":{
        "US":{"currency":"USD","amount":10,"verifiedAt":"2026-11-01","source":"https://y.com","method":"manual"},
        "VN":{"currency":"VND","amount":100000,"verifiedAt":"2026-01-01","source":"https://y.com","method":"manual"}}},
        {"id":"b","name":"B","status":"weird","cycle":{"unit":"month","count":1},"prices":{"US":{"currency":"USD","amount":1,"method":"manual"}}}]}]}''';

    test('v3: approx → reference; market vn → section vn', () {
      final s = CatalogRepository.parse(v3).single;
      expect(s.section, CatalogSection.vn);
      expect(s.isVietnamese, isTrue);
      expect(s.plans.single.prices['VN']!.isReference, isTrue);
      expect(s.plans.single.prices['US']!.isReference, isFalse);
      expect(s.plans.single.status, CatalogPlanStatus.active);
    });

    test('v4: logoDomain, storeNames, status, stale/missing verifiedAt → reference', () {
      final s = CatalogRepository.parse(v4, today: d(2026, 11, 6)).single;
      expect(s.logoDomain, 'y.com');
      expect(s.storeNames, ['Y Pro']);
      expect(s.section, CatalogSection.global);
      expect(s.plans[0].status, CatalogPlanStatus.closedToNew);
      expect(s.plans[1].status, CatalogPlanStatus.active);
      expect(s.plans[0].prices['US']!.isReference, isFalse);
      expect(s.plans[0].prices['VN']!.isReference, isTrue);
      expect(s.plans[1].prices['US']!.isReference, isTrue);
    });

  });

  test('Entitlement 1.0 opens Pro', () {
    expect(Entitlement.launch.isPro, isTrue);
    expect(Entitlement.free.canAutoDetect, isFalse);
  });
}
