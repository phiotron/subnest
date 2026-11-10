import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import '../fixtures.dart';

LocalDate d(int y, int m, [int day = 1]) => LocalDate(y, m, day);

const _calc = SpendingCalculator(
  rates: ExchangeRates(usdRates: {'USD': 1}),
  primaryCurrency: 'USD',
);

ConfirmedPeriod pay(String sub, LocalDate due, int amount) => ConfirmedPeriod(
  id: '$sub-$due',
  subscriptionId: sub,
  dueDate: due,
  outcome: PeriodOutcome.payment,
  amountMinor: amount,
  currency: 'USD',
  confirmedAt: fixedNow,
);

void main() {
  final today = d(2026, 11, 10);

  // Old: monthly since 2025, 8.00 → 10.00 in May 2026, next due 2026-11-15.
  final old = sub(id: 'old', name: 'Old', priceMinor: 1000, currency: 'USD', anchor: d(2026, 11, 15))
      .copyWith(startDate: d(2025, 1, 15));
  // New: added in August at 5.00, the 2026-11-01 period still awaits confirmation.
  final added = sub(id: 'new', name: 'New', priceMinor: 500, currency: 'USD', anchor: d(2026, 11, 1))
      .copyWith(startDate: d(2026, 8, 1));
  // Gone: cancelled in spring.
  final gone = sub(id: 'gone', name: 'Gone', priceMinor: 300, currency: 'USD', status: SubscriptionStatus.cancelled)
      .copyWith(startDate: d(2025, 1, 1), cancelledOn: d(2026, 3, 20));

  final periods = [
    for (var i = 0; i < 12; i++) pay('old', d(2025, 11, 15).addMonths(i), i < 6 ? 800 : 1000),
    for (final m in [8, 9, 10]) pay('new', d(2026, m), 500),
    for (final m in [1, 2, 3]) pay('gone', d(2026, m), 300),
  ];
  final history = PriceHistory([
    PriceChange(
      id: 'c1',
      subscriptionId: 'old',
      oldPriceMinor: 800,
      newPriceMinor: 1000,
      currency: 'USD',
      effectiveFrom: d(2026, 5, 15),
      source: PriceChangeSource.backfill,
      createdAt: fixedNow,
    ),
  ]);
  final f = YearForecastCalculator(_calc, history: history).build([old, added, gone], periods, today);

  test('next 12 months (real Due dates, awaiting included) vs last 12 months (Payments)', () {
    expect(f.nextMinor, 12 * 1000 + 13 * 500); // old: 2026-11-15…2027-10-15; new: 2026-11-01…2027-11-01
    expect(f.pastMinor, 6 * 800 + 6 * 1000 + 3 * 500 + 3 * 300);
    expect(f.changeMinor, 18500 - 13200);
    expect(f.items.first.date, d(2026, 11, 1));
    expect(f.items.first.isAwaiting(today), isTrue);
  });

  test('change split: new subscriptions · price increases · other add up', () {
    expect(f.newSubscriptionsMinor, 6500 - 1500);
    expect(f.priceIncreasesMinor, 12 * 200); // each of the next 12 periods costs 2.00 more than a year ago
    expect(f.otherMinor, (12000 - 10800 - 2400) + (0 - 900));
    expect(f.newSubscriptionsMinor + f.priceIncreasesMinor + f.otherMinor, f.changeMinor);
    expect(f.top!.subscription.id, 'old');
    expect(f.contributors.map((c) => c.subscription.id), ['old', 'new', 'gone']);
    expect(f.historyCoversPast, isFalse); // first Payment 2025-11-15 is after 2025-11-11
  });

  test('Coming up: 13 weeks and 12 months, awaiting periods in the first bar', () {
    expect(f.weeks, hasLength(13));
    expect(f.weeks.first.start, today);
    expect(f.weeks.first.end, d(2026, 11, 16));
    expect(f.weeks.first.totalMinor, 1500); // new (awaiting 11-01) + old (11-15)
    expect(f.weeks[1].totalMinor, 0);
    expect(f.months, hasLength(12));
    expect(f.months.first.totalMinor, 1500);
    expect(f.months[1].start, d(2026, 12, 1));
    expect(f.months[1].totalMinor, 1500);
    expect(f.months.last.end, d(2027, 10, 31));
  });
}
