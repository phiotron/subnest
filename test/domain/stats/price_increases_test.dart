import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import '../fixtures.dart';

LocalDate d(int y, int m, [int day = 1]) => LocalDate(y, m, day);

const _calc = SpendingCalculator(
  rates: ExchangeRates(usdRates: {'USD': 1, 'VND': 25000}),
  primaryCurrency: 'USD',
);

PriceChange change(
  String sub,
  int from,
  int to,
  LocalDate at, {
  PriceChangeSource source = PriceChangeSource.manual,
  DateTime? createdAt,
  String? oldCurrency,
  String currency = 'USD',
}) => PriceChange(
  id: 'c-$sub-$at',
  subscriptionId: sub,
  oldPriceMinor: from,
  newPriceMinor: to,
  currency: currency,
  oldCurrency: oldCurrency,
  effectiveFrom: at,
  source: source,
  createdAt: createdAt ?? fixedNow,
);

void main() {
  final today = d(2026, 11, 10);
  Subscription s(String id, int price, {BillingCycle cycle = const BillingCycle.monthly(), LocalDate? start,
      SubscriptionStatus status = SubscriptionStatus.active, String currency = 'USD'}) =>
      sub(id: id, name: id, priceMinor: price, currency: currency, cycle: cycle, status: status)
          .copyWith(startDate: start ?? d(2024, 1, 1));

  final subs = [
    s('a', 1200), // 10.00 → 12.00 in March
    s('b', 15000, cycle: const BillingCycle.yearly()), // 120.00 → 150.00 a year, June
    s('c', 1000), // 15.00 → 10.00: a drop, not listed
    s('d', 1000), // 8.00 → 10.00 before the window: not an increase this year
    s('e', 2000, status: SubscriptionStatus.cancelled), // cancelled: not paid any more
    s('f', 900, start: d(2026, 8, 1)), // added in August at 7.00, now 9.00
    s('g', 500), // no history
  ];
  final history = PriceHistory([
    change('a', 1000, 1200, d(2026, 3, 1)),
    change('b', 12000, 15000, d(2026, 6, 1)),
    change('c', 1500, 1000, d(2026, 4, 1)),
    change('d', 800, 1000, d(2025, 8, 1)),
    change('e', 1000, 2000, d(2026, 5, 1)),
    change('f', 700, 900, d(2026, 10, 1)),
  ]);
  final calc = PriceIncreaseCalculator(_calc, history);

  test('report: increases vs 12 months ago, biggest first, totals per month and per year', () {
    final r = calc.report(subs, today);
    expect(r.since, d(2025, 11, 10));
    expect(r.items.map((i) => (i.subscription.id, i.monthlyDeltaMinor, i.yearlyDeltaMinor)), [
      ('b', 250, 3000),
      ('a', 200, 2400),
      ('f', 200, 2400),
    ]);
    expect(r.items.first.before, (priceMinor: 12000, currency: 'USD'));
    expect(r.items.first.now, (priceMinor: 15000, currency: 'USD'));
    expect(r.items.first.changedOn, d(2026, 6, 1));
    expect(r.monthlyDeltaMinor, 650);
    expect(r.yearlyDeltaMinor, 7800);
    expect(r.biggest!.subscription.id, 'b');
  });

  test('a price changed without a record still shows (old price from history, now = current)', () {
    // History says 10.00 → 11.00, but the subscription now costs 12.00 (edited before price history).
    final r = PriceIncreaseCalculator(_calc, PriceHistory([change('x', 1000, 1100, d(2026, 2, 1))]))
        .report([s('x', 1200)], today);
    expect(r.items.single.before.priceMinor, 1000);
    expect(r.items.single.monthlyDeltaMinor, 200);
  });

  test('currency change compares converted amounts', () {
    final r = PriceIncreaseCalculator(
      _calc,
      PriceHistory([change('v', 200000, 1000, d(2026, 5, 1), oldCurrency: 'VND')]),
    ).report([s('v', 1000)], today);
    expect(r.items.single.oldMonthlyMinor, 800); // 200,000 ₫ = $8.00
    expect(r.items.single.monthlyDeltaMinor, 200);
  });

  test('↑ flag: increase noticed in the last 90 days', () {
    final h = PriceHistory([
      change('a', 1000, 1200, d(2026, 3, 1)), // long ago
      change('n', 1000, 1100, d(2026, 12, 1), createdAt: DateTime(2026, 11, 4)), // typed today-ish, from next period
      change('k', 1000, 1100, d(2026, 10, 1), source: PriceChangeSource.backfill, createdAt: DateTime(2026, 11, 10)),
      change('down', 1000, 900, d(2026, 11, 1)),
      change('old', 1000, 1100, d(2026, 8, 1), source: PriceChangeSource.backfill), // 101 days before
    ]);
    final c = PriceIncreaseCalculator(_calc, h);
    expect(
      c.recentlyIncreasedIds([s('a', 1200), s('n', 1100), s('k', 1100), s('down', 900), s('old', 1100)], today),
      {'n', 'k'},
    );
  });
}
