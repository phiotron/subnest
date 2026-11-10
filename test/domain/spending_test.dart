import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import 'fixtures.dart';

void main() {
  const d = LocalDate.new;
  const today = LocalDate(2026, 11, 4);
  const rates = ExchangeRates(usdRates: {'USD': 1, 'VND': 25400, 'EUR': 0.9});

  group('ExchangeRates', () {
    test('converts via USD base', () {
      expect(rates.convert(20, 'USD', 'VND'), 508000);
      expect(rates.convert(25400, 'VND', 'USD'), closeTo(1, 1e-9));
      expect(rates.convert(9, 'EUR', 'USD'), closeTo(10, 1e-9));
      expect(rates.convert(5, 'VND', 'VND'), 5);
    });

    test('unknown currency → null', () {
      expect(rates.convert(1, 'XYZ', 'VND'), isNull);
    });

    test('manual override wins, inverse override is used too', () {
      final r = rates.copyWith(overrides: {ExchangeRates.pairKey('USD', 'VND'): 26000});
      expect(r.convert(1, 'USD', 'VND'), 26000);
      expect(r.convert(26000, 'VND', 'USD'), closeTo(1, 1e-9));
      expect(r.isOverridden('VND', 'USD'), isTrue);
      expect(r.convert(9, 'EUR', 'USD'), closeTo(10, 1e-9));
    });

    test('staleness', () {
      final r = rates.copyWith(fetchedAt: DateTime(2026, 11, 3, 9));
      expect(r.isStale(DateTime(2026, 11, 4, 8)), isFalse);
      expect(r.isStale(DateTime(2026, 11, 4, 9)), isTrue);
      expect(ExchangeRates.empty.isStale(DateTime(2026)), isTrue);
    });
  });

  group('Monthly cost', () {
    const calc = SpendingCalculator(rates: rates, primaryCurrency: 'VND');

    test('uses My share and the cycle', () {
      expect(calc.monthlyCost(sub(priceMinor: 260000, sharedWith: 4)), 65000);
      expect(calc.monthlyCost(sub(priceMinor: 1200000, cycle: const BillingCycle.yearly())), closeTo(100000, 1e-6));
      expect(calc.monthlyCost(sub(priceMinor: 12000, cycle: const BillingCycle.weekly())), closeTo(52000, 1e-6));
      expect(calc.yearlyCost(sub(priceMinor: 100000)), closeTo(1200000, 1e-6));
    });

    test('converts other currencies to the Primary currency', () {
      expect(calc.monthlyCost(sub(priceMinor: 2000, currency: 'USD')), closeTo(508000, 1e-6));
    });

    test('unknown rate → null', () {
      expect(calc.monthlyCost(sub(currency: 'XYZ')), isNull);
    });
  });

  group('summary', () {
    const calc = SpendingCalculator(rates: rates, primaryCurrency: 'VND');

    final subs = [
      sub(id: 'netflix', priceMinor: 260000, sharedWith: 4, anchor: today), // awaiting
      sub(id: 'chatgpt', priceMinor: 2000, currency: 'USD', anchor: d(2026, 11, 7)),
      sub(id: 'google', priceMinor: 1690000, cycle: const BillingCycle.yearly(), anchor: d(2027, 3, 20)),
      BillingRules.startTrial(sub(id: 'spotify', priceMinor: 59000), d(2026, 11, 6), fixedNow),
      sub(id: 'duolingo', priceMinor: 699000, cycle: const BillingCycle.yearly(), status: SubscriptionStatus.cancelled),
      sub(id: 'applemusic', priceMinor: 65000, status: SubscriptionStatus.cancelled),
      sub(id: 'viettel', priceMinor: 150000, anchor: d(2026, 10, 1)), // 2 pending: 10/01, 11/01
      sub(id: 'odd', currency: 'XYZ', anchor: d(2026, 12, 1)),
    ];

    test('totals Active only; Trial shown separately; Savings from Cancelled', () {
      final s = calc.summary(subs, today);
      // Google One yearly 1 690 000 ÷ 12 = 140 833.33 → each Monthly cost is rounded to whole đồng.
      const expectedMonthly = 65000 + 508000 + 140833 + 150000;
      expect(s.monthly, closeTo(expectedMonthly, 1e-6));
      // Yearly = Σ each Yearly cost (Google One stays 1 690 000, not 140 833 × 12).
      expect(s.yearly, (65000 + 508000 + 150000) * 12 + 1690000);
      expect(s.trialMonthly, closeTo(59000, 1e-6));
      expect(s.savingsYearly, closeTo(699000 + 65000 * 12, 1e-6));
      expect(s.activeCount, 5);
      expect(s.trialCount, 1);
      expect(s.cancelledCount, 2);
      expect(s.awaitingCount, 3);
      expect(s.awaitingTotal, closeTo(65000 + 150000 * 2, 1e-6));
      expect(s.missingRates, {'XYZ'});
    });

    test('Trial counts as Active once its end date arrives', () {
      final s = calc.summary(subs, d(2026, 11, 6));
      expect(s.trialCount, 0);
      expect(s.activeCount, 6);
    });

    test('byCategory and top', () {
      final cats = calc.byCategory(subs, today);
      expect(cats.first.key, SubscriptionCategory.video);
      final top = calc.top(subs, today, count: 2);
      expect(top.map((e) => e.$1.id), ['chatgpt', 'viettel']);
    });
  });

  group('actual vs projected', () {
    const calc = SpendingCalculator(rates: rates, primaryCurrency: 'VND');

    ConfirmedPeriod p(LocalDate due, int amount, {String cur = 'VND', bool paid = true}) => ConfirmedPeriod(
      id: '$due',
      subscriptionId: 's1',
      dueDate: due,
      outcome: paid ? PeriodOutcome.payment : PeriodOutcome.skipped,
      amountMinor: paid ? amount : 0,
      currency: cur,
      confirmedAt: fixedNow,
    );

    test('actual spending only counts Payments', () {
      final periods = [
        p(d(2026, 10, 4), 270000),
        p(d(2026, 10, 7), 2000, cur: 'USD'),
        p(d(2026, 10, 20), 0, paid: false),
        p(d(2026, 9, 4), 260000),
      ];
      expect(calc.actualInMonth(periods, d(2026, 10, 1)), closeTo(270000 + 508000, 1e-6));
      expect(calc.totalPaid(periods), closeTo(270000 + 508000 + 260000, 1e-6));
    });

    test('projection counts unconfirmed and future periods of non-cancelled subs', () {
      final subs = [
        sub(anchor: d(2026, 11, 4)),
        sub(id: 'w', priceMinor: 10000, cycle: const BillingCycle.weekly(), anchor: d(2026, 11, 2)),
        sub(id: 'c', status: SubscriptionStatus.cancelled, anchor: d(2026, 11, 10)),
      ];
      // Nov: 260k + 5 weekly (2, 9, 16, 23, 30) × 10k.
      expect(calc.projectedInMonth(subs, d(2026, 11, 1)), closeTo(310000, 1e-6));
      final series = calc.monthlySeries(subs, const [], d(2026, 12, 1), count: 3);
      expect(series.map((m) => m.month), [d(2026, 10, 1), d(2026, 11, 1), d(2026, 12, 1)]);
      expect(series.first.projected, 0);
    });
  });
}
