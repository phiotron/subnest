import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import 'fixtures.dart';

void main() {
  const d = LocalDate.new;
  const today = LocalDate(2026, 11, 4);

  group('Due date and Awaiting confirmation (ADR 0001)', () {
    test('future due date is not awaiting', () {
      final s = sub(anchor: d(2026, 11, 10));
      expect(BillingRules.isAwaitingConfirmation(s, today), isFalse);
      expect(BillingRules.pendingDueDates(s, today), isEmpty);
      expect(BillingRules.daysUntilDue(s, today), 6);
    });

    test('due date today → awaiting', () {
      final s = sub(anchor: today);
      expect(BillingRules.isAwaitingConfirmation(s, today), isTrue);
      expect(BillingRules.pendingDueDates(s, today), [today]);
    });

    test('due date stands still while awaiting (no auto roll-over)', () {
      final s = sub(anchor: d(2026, 9, 4));
      // Two months later the due date is still the old one.
      expect(s.dueDate, d(2026, 9, 4));
      expect(BillingRules.pendingDueDates(s, today), [d(2026, 9, 4), d(2026, 10, 4), d(2026, 11, 4)]);
    });

    test('cancelled subscription is never awaiting', () {
      final s = sub(anchor: d(2026, 10, 1), status: SubscriptionStatus.cancelled);
      expect(BillingRules.isAwaitingConfirmation(s, today), isFalse);
      expect(BillingRules.pendingDueDates(s, today), isEmpty);
    });
  });

  group('confirm', () {
    test('Paid creates a Payment with My share by default and moves to next period', () {
      final s = sub(anchor: today, sharedWith: 4);
      final r = BillingRules.confirm(
        s,
        outcome: PeriodOutcome.payment,
        today: today,
        now: fixedNow,
        newId: idGen(),
      );
      expect(r.period.isPayment, isTrue);
      expect(r.period.amountMinor, 65000);
      expect(r.period.dueDate, today);
      expect(r.period.currency, 'VND');
      expect(r.subscription.dueDate, d(2026, 12, 4));
      expect(BillingRules.isAwaitingConfirmation(r.subscription, today), isFalse);
    });

    test('Paid with an edited amount keeps that amount', () {
      final r = BillingRules.confirm(
        sub(anchor: today),
        outcome: PeriodOutcome.payment,
        amountMinor: 270000,
        today: today,
        now: fixedNow,
        newId: idGen(),
      );
      expect(r.period.amountMinor, 270000);
    });

    test('Skipped period creates no spending', () {
      final r = BillingRules.confirm(
        sub(anchor: today),
        outcome: PeriodOutcome.skipped,
        amountMinor: 999,
        today: today,
        now: fixedNow,
        newId: idGen(),
      );
      expect(r.period.isSkipped, isTrue);
      expect(r.period.amountMinor, 0);
      expect(r.subscription.dueDate, d(2026, 12, 4));
    });

    test('cannot confirm a period before its due date ("Later" = do nothing)', () {
      expect(
        () => BillingRules.confirm(
          sub(anchor: d(2026, 11, 5)),
          outcome: PeriodOutcome.payment,
          today: today,
          now: fixedNow,
          newId: idGen(),
        ),
        throwsStateError,
      );
    });

    test('catching up one by one: next overdue period becomes awaiting immediately', () {
      var s = sub(anchor: d(2026, 9, 4));
      final ids = idGen();
      final confirmed = <LocalDate>[];
      while (BillingRules.isAwaitingConfirmation(s, today)) {
        final r = BillingRules.confirm(s, outcome: PeriodOutcome.payment, today: today, now: fixedNow, newId: ids);
        confirmed.add(r.period.dueDate);
        s = r.subscription;
        if (confirmed.length == 1) {
          // After the first one the next (also past) period is pending right away.
          expect(BillingRules.pendingDueDates(s, today), [d(2026, 10, 4), today]);
        }
      }
      expect(confirmed, [d(2026, 9, 4), d(2026, 10, 4), d(2026, 11, 4)]);
      expect(s.dueDate, d(2026, 12, 4));
    });

    test('catching up preserves the 31st across short months', () {
      var s = sub(anchor: d(2026, 1, 31));
      final (after, periods) = BillingRules.confirmAll(
        s,
        today: d(2026, 4, 30),
        now: fixedNow,
        newId: idGen(),
      );
      s = after;
      expect(periods.map((p) => p.dueDate), [d(2026, 1, 31), d(2026, 2, 28), d(2026, 3, 31), d(2026, 4, 30)]);
      expect(s.dueDate, d(2026, 5, 31));
    });
  });

  group('confirmAll', () {
    test('confirms every pending period at the current My share', () {
      final s = sub(anchor: d(2026, 8, 4), sharedWith: 2, priceMinor: 100000);
      final (after, periods) = BillingRules.confirmAll(s, today: today, now: fixedNow, newId: idGen());
      expect(periods, hasLength(4));
      expect(periods.every((p) => p.isPayment && p.amountMinor == 50000), isTrue);
      expect(periods.map((p) => p.id).toSet(), hasLength(4));
      expect(after.dueDate, d(2026, 12, 4));
      expect(BillingRules.isAwaitingConfirmation(after, today), isFalse);
    });

    test('nothing pending → no records, unchanged', () {
      final s = sub(anchor: d(2026, 12, 1));
      final (after, periods) = BillingRules.confirmAll(s, today: today, now: fixedNow, newId: idGen());
      expect(periods, isEmpty);
      expect(after.dueDate, s.dueDate);
    });

    test('daily cycle left alone for a long time is bounded', () {
      final s = sub(anchor: d(2020, 1, 1), cycle: const BillingCycle(1, CycleUnit.day));
      final pending = BillingRules.pendingDueDates(s, today);
      expect(pending.length, BillingRules.maxCatchUp);
    });
  });

  group('Trial', () {
    Subscription trial() => BillingRules.startTrial(sub(), d(2026, 11, 6), fixedNow);

    test('trial end date is the first paid Due date', () {
      final s = trial();
      expect(s.status, SubscriptionStatus.trial);
      expect(s.dueDate, d(2026, 11, 6));
      expect(BillingRules.effectiveStatus(s, today), SubscriptionStatus.trial);
      expect(BillingRules.isAwaitingConfirmation(s, today), isFalse);
    });

    test('trial automatically becomes Active on its end date and that period awaits confirmation', () {
      final s = trial();
      final end = d(2026, 11, 6);
      expect(BillingRules.effectiveStatus(s, end), SubscriptionStatus.active);
      expect(BillingRules.isAwaitingConfirmation(s, end), isTrue);
      expect(BillingRules.normalize(s, end, fixedNow).status, SubscriptionStatus.active);
      expect(BillingRules.normalize(s, today, fixedNow), same(s));
    });

    test('confirming the first paid period persists Active', () {
      final end = d(2026, 11, 6);
      final r = BillingRules.confirm(trial(), outcome: PeriodOutcome.payment, today: end, now: fixedNow, newId: idGen());
      expect(r.subscription.status, SubscriptionStatus.active);
      expect(r.subscription.dueDate, d(2026, 12, 6));
    });
  });

  group('Cancel / restore', () {
    test('cancel keeps the subscription and drops pending periods', () {
      final s = BillingRules.cancel(sub(anchor: d(2026, 10, 4)), today, fixedNow);
      expect(s.status, SubscriptionStatus.cancelled);
      expect(s.cancelledOn, today);
      expect(BillingRules.pendingDueDates(s, today), isEmpty);
      expect(BillingRules.dueDatesBetween(s, today, d(2027, 1, 1)), isEmpty);
    });

    test('restore moves the Due date to the first occurrence on/after today', () {
      final cancelled = BillingRules.cancel(sub(anchor: d(2026, 6, 10)), d(2026, 6, 1), fixedNow);
      final r = BillingRules.restore(cancelled, today, fixedNow);
      expect(r.status, SubscriptionStatus.active);
      expect(r.cancelledOn, isNull);
      expect(r.dueDate, d(2026, 11, 10));
    });

    test('restore during the trial goes back to Trial', () {
      final t = BillingRules.startTrial(sub(), d(2026, 11, 20), fixedNow);
      final r = BillingRules.restore(BillingRules.cancel(t, today, fixedNow), today, fixedNow);
      expect(r.status, SubscriptionStatus.trial);
      expect(r.dueDate, d(2026, 11, 20));
    });
  });

  group('rebase / schedule', () {
    test('editing the next due date re-anchors', () {
      final s = BillingRules.rebase(sub(anchor: d(2026, 1, 31), periodIndex: 5), d(2026, 11, 15), fixedNow);
      expect(s.dueDate, d(2026, 11, 15));
      expect(s.periodIndex, 0);
    });

    test('dueDatesBetween lists projected periods including pending ones', () {
      final s = sub(anchor: d(2026, 10, 20));
      expect(BillingRules.dueDatesBetween(s, d(2026, 10, 1), d(2027, 1, 31)), [
        d(2026, 10, 20),
        d(2026, 11, 20),
        d(2026, 12, 20),
        d(2027, 1, 20),
      ]);
    });
  });

  group('Shared plan', () {
    test('My share = price ÷ people, rounded to minor units', () {
      expect(sub(priceMinor: 260000, sharedWith: 4).myShareMinor, 65000);
      expect(sub(priceMinor: 179000, sharedWith: 5).myShareMinor, 35800);
      expect(sub(priceMinor: 1000, currency: 'USD', sharedWith: 3).myShareMinor, 333);
      expect(sub(priceMinor: 1000, sharedWith: 1).myShareMinor, 1000);
    });
  });
}
