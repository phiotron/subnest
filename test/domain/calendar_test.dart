import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import 'fixtures.dart';

void main() {
  const d = LocalDate.new;
  const today = LocalDate(2026, 11, 4);

  test('calendar month mixes Payments, Skipped, awaiting and upcoming', () {
    final s = sub(anchor: d(2026, 11, 1), cycle: const BillingCycle.weekly()); // pending since 11/01
    final periods = [
      ConfirmedPeriod(
        id: 'a',
        subscriptionId: 's1',
        dueDate: d(2026, 10, 25),
        outcome: PeriodOutcome.payment,
        amountMinor: 260000,
        currency: 'VND',
        confirmedAt: fixedNow,
      ),
      ConfirmedPeriod(
        id: 'b',
        subscriptionId: 's1',
        dueDate: d(2026, 10, 18),
        outcome: PeriodOutcome.skipped,
        amountMinor: 0,
        currency: 'VND',
        confirmedAt: fixedNow,
      ),
    ];
    final e = CalendarBuilder.entries(
      subscriptions: [s],
      periods: periods,
      from: d(2026, 10, 15),
      to: d(2026, 11, 15),
      today: today,
    );
    expect(e.map((x) => (x.date, x.kind)), [
      (d(2026, 10, 18), CalendarEntryKind.skipped),
      (d(2026, 10, 25), CalendarEntryKind.paid),
      (d(2026, 11, 1), CalendarEntryKind.awaiting),
      (d(2026, 11, 8), CalendarEntryKind.upcoming),
      (d(2026, 11, 15), CalendarEntryKind.upcoming),
    ]);
  });

  test('upcoming 7 days excludes today/pending and cancelled', () {
    final subs = [
      sub(id: 'a', anchor: today),
      sub(id: 'b', anchor: d(2026, 11, 7)),
      sub(id: 'c', anchor: d(2026, 11, 11)),
      sub(id: 'd', anchor: d(2026, 11, 12)),
      sub(id: 'e', anchor: d(2026, 11, 8), status: SubscriptionStatus.cancelled),
    ];
    final up = CalendarBuilder.upcoming(subscriptions: subs, today: today);
    expect(up.map((x) => x.subscription.id), ['b', 'c']);
  });
}
