import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import '../fixtures.dart';

LocalDate d(int y, int m, [int day = 1]) => LocalDate(y, m, day);

const _rates = ExchangeRates(usdRates: {'USD': 1, 'VND': 25000, 'EUR': 0.9});
const _vndCalc = SpendingCalculator(rates: _rates, primaryCurrency: 'VND');
const _usdCalc = SpendingCalculator(rates: _rates, primaryCurrency: 'USD');

Subscription s0({
  String id = 's1',
  int price = 260000,
  String currency = 'VND',
  BillingCycle cycle = const BillingCycle.monthly(),
  LocalDate? start,
  LocalDate? anchor,
  int periodIndex = 0,
  LocalDate? trialEnd,
  SubscriptionStatus status = SubscriptionStatus.active,
  int sharedWith = 1,
  SubscriptionCategory category = SubscriptionCategory.video,
}) => sub(
  id: id,
  name: id,
  priceMinor: price,
  currency: currency,
  cycle: cycle,
  anchor: anchor,
  periodIndex: periodIndex,
  trialEnd: trialEnd,
  status: status,
  sharedWith: sharedWith,
  category: category,
).copyWith(startDate: start ?? d(2026, 1, 1));

void main() {
  const vnd = MonthStatsCalculator(_vndCalc);
  const usd = MonthStatsCalculator(_usdCalc);

  group('Month spend — which months a subscription counts in', () {
    test('monthly plan = its monthly price in every month since it started', () {
      final m = vnd.month([s0()], d(2026, 11));
      expect(m.totalMinor, 260000);
      expect(m.count, 1);
      expect(vnd.month([s0(start: d(2026, 12, 3))], d(2026, 11)).totalMinor, 0);
    });

    test('yearly plan: ÷ 12 only from the month it was subscribed (before / in / after)', () {
      final y = s0(price: 1200000, cycle: const BillingCycle.yearly(), start: d(2026, 3, 10));
      expect(vnd.month([y], d(2026, 2)).totalMinor, 0); // subscribed after February
      expect(vnd.month([y], d(2026, 3)).totalMinor, 100000); // subscribed in March
      expect(vnd.month([y], d(2026, 4)).totalMinor, 100000); // subscribed before April
      expect(vnd.month([y], d(2027, 6)).totalMinor, 100000); // future months too
    });

    test('Trial: months still in Trial are 0; the month the Trial ends counts', () {
      final t = s0(start: d(2026, 9, 1), trialEnd: d(2026, 10, 15), status: SubscriptionStatus.trial);
      expect(vnd.month([t], d(2026, 9)).totalMinor, 0);
      expect(vnd.month([t], d(2026, 10)).totalMinor, 260000);
      expect(vnd.month([t], d(2026, 11)).totalMinor, 260000);
    });

    test('Cancelled mid-month: that month counts, the months after are 0', () {
      final c = s0(status: SubscriptionStatus.cancelled).copyWith(cancelledOn: d(2026, 10, 20));
      expect(vnd.month([c], d(2026, 9)).totalMinor, 260000);
      expect(vnd.month([c], d(2026, 10)).totalMinor, 260000);
      expect(vnd.month([c], d(2026, 11)).totalMinor, 0);
      // Cancelled during the Trial: never paid.
      final t = s0(start: d(2026, 11, 1), trialEnd: d(2026, 11, 20), status: SubscriptionStatus.cancelled)
          .copyWith(cancelledOn: d(2026, 11, 10));
      expect(vnd.month([t], d(2026, 11)).totalMinor, 0);
    });

    test('Paused: the month the pause starts counts; months paused whole are 0', () {
      final p = s0(status: SubscriptionStatus.paused).copyWith(pausedFrom: d(2026, 11, 15));
      expect(vnd.month([p], d(2026, 10)).totalMinor, 260000);
      expect(vnd.month([p], d(2026, 11)).totalMinor, 260000);
      expect(vnd.month([p], d(2026, 12)).totalMinor, 0);
      final whole = s0(status: SubscriptionStatus.paused).copyWith(pausedFrom: d(2026, 11, 1));
      expect(vnd.month([whole], d(2026, 11)).totalMinor, 0);
    });

    test('My share, weekly plan and categories', () {
      final shared = s0(id: 'fam', price: 2000, currency: 'USD', sharedWith: 2);
      final weekly = s0(id: 'wk', price: 300, currency: 'USD', cycle: const BillingCycle.weekly(),
          category: SubscriptionCategory.music);
      final m = usd.month([shared, weekly], d(2026, 11));
      expect(m.lines.map((l) => (l.subscription.id, l.amountMinor)), [('wk', 1300), ('fam', 1000)]); // 300×52/12
      expect(m.byCategoryIdMinor.map((e) => (e.key, e.value)), [('music', 1300), ('video', 1000)]);
    });
  });

  group('Month spend — money', () {
    test('multi-currency: each line rounded to the cent, total = sum of the rounded lines', () {
      final a = s0(id: 'a', price: 1000000, cycle: const BillingCycle.yearly()); // 1,000,000 ₫/yr → $3.333…/mo
      final b = s0(id: 'b', price: 1000000, cycle: const BillingCycle.yearly());
      final c = s0(id: 'c', price: 999, currency: 'EUR'); // €9.99 → $11.10
      final m = usd.month([a, b, c], d(2026, 11));
      expect(m.lines.map((l) => l.amountMinor), [1110, 333, 333]);
      expect(m.totalMinor, 1776);
    });

    test('unknown rate: left out and reported', () {
      final m = usd.month([s0(price: 500, currency: 'XYZ'), s0(id: 'b', price: 100, currency: 'USD')], d(2026, 11));
      expect(m.totalMinor, 100);
      expect(m.missingRates, {'XYZ'});
    });

    test('Daily average ÷ days of the month (28 vs 31) and change from the month before', () {
      final a = s0(id: 'a', price: 3100, currency: 'USD');
      final jan = usd.month([a], d(2026, 1));
      expect(jan.daysInMonth, 31);
      expect(jan.dailyAverageMinor, 100);
      final feb = usd.month([a, s0(id: 'b', price: 500, currency: 'USD', start: d(2026, 2, 27))], d(2026, 2));
      expect(feb.daysInMonth, 28);
      expect(feb.totalMinor, 3600);
      expect(feb.dailyAverageMinor, 129); // 36.00 / 28 = 1.2857
      expect(feb.previousTotalMinor, 3100);
      expect(feb.changeMinor, 500);
      expect(usd.month([a], d(2028, 2)).dailyAverageMinor, 107); // leap February: 31.00 / 29 = 1.069
    });

    test('price in effect in the month comes from Price history', () {
      final a = s0(price: 1200, currency: 'USD');
      final h = PriceHistory([
        PriceChange(
          id: 'c1',
          subscriptionId: 's1',
          oldPriceMinor: 1000,
          newPriceMinor: 1200,
          currency: 'USD',
          effectiveFrom: d(2026, 9, 15),
          source: PriceChangeSource.manual,
          createdAt: fixedNow,
        ),
      ]);
      final calc = MonthStatsCalculator(_usdCalc, history: h);
      expect(calc.month([a], d(2026, 8)).totalMinor, 1000);
      expect(calc.month([a], d(2026, 9)).totalMinor, 1200); // price at the month's last day
      expect(calc.month([a], d(2026, 12)).totalMinor, 1200);
    });

    test('year = the 12 months added up; series for the Home bars', () {
      final a = s0(price: 1000, currency: 'USD', start: d(2026, 3, 1));
      final y = usd.year([a], 2026);
      expect(y.months, hasLength(12));
      expect(y.totalMinor, 10000);
      expect(y.count, 1);
      expect(y.lines.single.amountMinor, 10000);
      expect(y.previousTotalMinor, 0);
      expect(y.dailyAverageMinor, 27); // 100.00 / 365
      final bars = usd.series([a], d(2026, 4), count: 6);
      expect(bars.map((m) => m.month), [d(2025, 11), d(2025, 12), d(2026, 1), d(2026, 2), d(2026, 3), d(2026, 4)]);
      expect(bars.map((m) => m.totalMinor), [0, 0, 0, 0, 1000, 1000]);
    });
  });

  group('Month cash flow', () {
    test('Paid = Payments of the month; Remaining = awaiting + still ahead (yearly at full price)', () {
      final today = d(2026, 11, 10);
      final pending = s0(id: 'pend', price: 1000, currency: 'USD', anchor: d(2026, 11, 5));
      final yearly = s0(id: 'yr', price: 12000, currency: 'USD', cycle: const BillingCycle.yearly(),
          anchor: d(2026, 11, 25));
      final paid = s0(id: 'paid', price: 500, currency: 'USD', anchor: d(2026, 12, 1));
      final pausing = s0(id: 'pause', price: 700, currency: 'USD', status: SubscriptionStatus.paused,
          anchor: d(2026, 11, 20)).copyWith(pausedFrom: d(2026, 11, 20));
      ConfirmedPeriod pay(String id, LocalDate due, int amount) => ConfirmedPeriod(
        id: '$id-$due',
        subscriptionId: id,
        dueDate: due,
        outcome: PeriodOutcome.payment,
        amountMinor: amount,
        currency: 'USD',
        confirmedAt: fixedNow,
      );
      final periods = [pay('paid', d(2026, 11, 1), 500), pay('paid', d(2026, 10, 1), 500)];
      final f = usd.cashFlow([pending, yearly, paid, pausing], periods, d(2026, 11), today);
      expect(f.paidMinor, 500);
      expect(f.remaining.map((i) => (i.subscription.id, i.date, i.amountMinor)), [
        ('pend', d(2026, 11, 5), 1000),
        ('yr', d(2026, 11, 25), 12000),
      ]);
      expect(f.remainingMinor, 13000);
      expect(f.awaitingMinor, 1000);
      expect(f.totalMinor, 13500);
      // The Month spend of the same month spreads the yearly plan: different on purpose.
      expect(usd.month([pending, yearly, paid, pausing], d(2026, 11)).totalMinor, 1000 + 1000 + 500 + 700);
      // A past month: only its Payments (nothing awaiting there).
      final oct = usd.cashFlow([pending, yearly, paid, pausing], periods, d(2026, 10), today);
      expect((oct.paidMinor, oct.remainingMinor), (500, 0));
    });
  });
}
