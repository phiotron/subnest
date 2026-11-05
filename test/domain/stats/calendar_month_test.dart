import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';
import 'package:subnest/domain/stats/calendar_month.dart';

import 'sample_data.dart';

CalendarMonth monthOf(LocalDate m, {List<Subscription>? subs, List<ConfirmedPeriod>? periods}) => CalendarMonth.build(
  subscriptions: subs ?? Sample.subscriptions,
  periods: periods ?? Sample.periods,
  month: m,
  today: Sample.today,
  rates: Sample.rates,
  primaryCurrency: Sample.primary,
);

void main() {
  group('CalendarMonth — current month (Nov 2026)', () {
    final nov = monthOf(const LocalDate(2026, 11, 20));

    test('normalises to the first day and knows it is current', () {
      expect(nov.month, const LocalDate(2026, 11, 1));
      expect(nov.isCurrent, isTrue);
      expect(nov.isPast, isFalse);
      expect(nov.daysInMonth, 30);
    });

    test('entries: 2 awaiting (1 and 4 Nov), 4 upcoming, cancelled ones left out', () {
      expect(nov.awaitingCount, 2);
      expect(nov.upcomingCount, 4);
      expect(nov.paidCount, 0);
      expect(nov.paymentCount, 6);
      expect(nov.hasAwaiting(1), isTrue);
      expect(nov.hasAwaiting(4), isTrue);
      expect(nov.hasAwaiting(6), isFalse);
      expect(nov.onDay(6).single.subscription.id, 'spotify');
      expect(nov.entries.any((e) => e.subscription.id == 'applemusic'), isFalse);
    });

    test('total = expected periods at My share, converted to VND, approximate', () {
      // 150,000 + 65,000 + 59,000 + $20 (508,000) + 59,000 + 35,800
      expect(nov.total, closeTo(876800, 1e-6));
      expect(nov.approx, isTrue);
      expect(nov.converted, isTrue);
      expect(nov.missingRates, isEmpty);
    });

    test('agenda: To confirm · This week (to Sunday 8th) · Later · next month', () {
      final groups = nov.agenda(next: monthOf(const LocalDate(2026, 12, 1)));
      expect(groups.map((g) => g.kind), [
        AgendaGroupKind.toConfirm,
        AgendaGroupKind.thisWeek,
        AgendaGroupKind.later,
        AgendaGroupKind.nextMonth,
      ]);
      expect(groups[0].entries.map((e) => e.subscription.id), ['viettel', 'netflix']);
      expect(groups[1].entries.map((e) => e.subscription.id), ['spotify', 'chatgpt']);
      expect(groups[2].entries.map((e) => e.subscription.id), ['icloud', 'youtube']);
      expect(groups[3].entries.first.date, const LocalDate(2026, 12, 1));
    });

    test('agenda: payments earlier in the month go last', () {
      final paidViettel = ConfirmedPeriod(
        id: 'x',
        subscriptionId: 'viettel',
        dueDate: const LocalDate(2026, 11, 1),
        outcome: PeriodOutcome.payment,
        amountMinor: 150000,
        currency: 'VND',
        confirmedAt: Sample.now,
      );
      final subs = [Sample.viettel.copyWith(periodIndex: 1)];
      final m = monthOf(const LocalDate(2026, 11, 1), subs: subs, periods: [paidViettel]);
      expect(m.paidCount, 1);
      expect(m.agenda().map((g) => g.kind), [AgendaGroupKind.earlier]);
      expect(m.total, 150000);
      expect(m.approx, isFalse);
    });
  });

  group('CalendarMonth — past month (Oct 2026)', () {
    final oct = monthOf(const LocalDate(2026, 10, 1));

    test('shows Payments (solid) and the Skipped period (outlined)', () {
      expect(oct.isPast, isTrue);
      expect(oct.paidCount, 4);
      expect(oct.skippedCount, 1);
      expect(oct.onDay(22).single.kind, CalendarEntryKind.skipped);
    });

    test('total counts Payments only, in the Primary currency', () {
      // 150,000 + 65,000 + $20 + 59,000
      expect(oct.total, closeTo(782000, 1e-6));
      expect(oct.approx, isTrue, reason: r'the $20 ChatGPT payment is converted');
    });

    test('a Skipped entry shows the My share it would have cost', () {
      expect(CalendarMonth.amountOf(oct.onDay(22).single), Sample.youtube.myShare);
      expect(CalendarMonth.amountOf(oct.onDay(4).single), const Money(65000, 'VND'));
    });

    test('any month other than the current one is one agenda section', () {
      expect(oct.agenda().single.kind, AgendaGroupKind.month);
      expect(oct.agenda().single.entries, hasLength(5));
    });

    test('a period still awaiting from a past month is counted but not totalled', () {
      final late = [Sample.viettel.copyWith(anchorDate: const LocalDate(2026, 10, 1))];
      final m = monthOf(const LocalDate(2026, 10, 1), subs: late, periods: const []);
      expect(m.awaitingCount, 1);
      expect(m.total, 0);
    });
  });

  test('future month: projections only, unknown currencies reported', () {
    final eur = Sample.icloud.copyWith(currency: 'EUR', priceMinor: 299);
    final m = monthOf(const LocalDate(2027, 1, 1), subs: [Sample.viettel, eur], periods: const []);
    expect(m.isPast, isFalse);
    expect(m.isCurrent, isFalse);
    expect(m.upcomingCount, 2);
    expect(m.total, 150000);
    expect(m.missingRates, {'EUR'});
  });

  test('empty month', () {
    final m = monthOf(const LocalDate(2026, 11, 1), subs: const [], periods: const []);
    expect(m.entries, isEmpty);
    expect(m.total, 0);
    expect(m.approx, isFalse);
    expect(m.agenda(), isEmpty);
  });
}
