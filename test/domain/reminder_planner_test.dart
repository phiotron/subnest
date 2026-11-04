import 'package:flutter_test/flutter_test.dart';
import 'package:subnest/domain/domain.dart';

import 'fixtures.dart';

void main() {
  const d = LocalDate.new;
  final now = DateTime(2026, 11, 4, 10); // after 9:00 today

  List<PlannedReminder> plan(List<Subscription> subs, {int defaultDays = 3, DateTime? at}) =>
      ReminderPlanner.plan(subs, now: at ?? now, defaultDays: defaultDays, hour: 9, minute: 0);

  test('default: 3 days before at 9:00 + due-day notification', () {
    final r = plan([sub(anchor: d(2026, 11, 20))]);
    expect(r.map((e) => e.kind), [ReminderKind.renewalSoon, ReminderKind.dueToday]);
    expect(r[0].fireAt, DateTime(2026, 11, 17, 9));
    expect(r[0].daysBefore, 3);
    expect(r[1].fireAt, DateTime(2026, 11, 20, 9));
    expect(r[1].route, '/confirm/s1');
    expect(r[0].route, '/subscription/s1');
  });

  test('per-subscription setting overrides the default', () {
    expect(plan([sub(anchor: d(2026, 11, 20), reminderDays: 7)]).first.fireAt, DateTime(2026, 11, 13, 9));
    expect(plan([sub(anchor: d(2026, 11, 20), reminderDays: 1)]).first.fireAt, DateTime(2026, 11, 19, 9));
  });

  test('"on the day" only schedules the due-day notification', () {
    final r = plan([sub(anchor: d(2026, 11, 20), reminderDays: ReminderDays.onTheDay)]);
    expect(r.map((e) => e.kind), [ReminderKind.dueToday]);
  });

  test('off → nothing', () {
    expect(plan([sub(anchor: d(2026, 11, 20), reminderDays: ReminderDays.off)]), isEmpty);
    expect(plan([sub(anchor: d(2026, 11, 20))], defaultDays: ReminderDays.off), isEmpty);
  });

  test('reminders in the past are not scheduled', () {
    // Due in 2 days with a 3-day reminder: the "before" reminder already passed.
    final r = plan([sub(anchor: d(2026, 11, 6))]);
    expect(r.map((e) => e.kind), [ReminderKind.dueToday]);
  });

  test('awaiting confirmation: no reminders for the next period until confirmed', () {
    final awaiting = sub(anchor: d(2026, 10, 4));
    expect(plan([awaiting]), isEmpty);
    // Due today but before 9:00 → the due-day notification is still ahead.
    final early = plan([sub(anchor: d(2026, 11, 4))], at: DateTime(2026, 11, 4, 8));
    expect(early.map((e) => e.kind), [ReminderKind.dueToday]);

    // After confirming, the next period's reminders appear.
    final ids = idGen();
    var s = awaiting;
    while (BillingRules.isAwaitingConfirmation(s, d(2026, 11, 4))) {
      s = BillingRules.confirm(s, outcome: PeriodOutcome.payment, today: d(2026, 11, 4), now: now, newId: ids).subscription;
    }
    final after = plan([s]);
    expect(after.map((e) => e.fireAt), [DateTime(2026, 12, 1, 9), DateTime(2026, 12, 4, 9)]);
  });

  test('Trial: "trial ending" reminder before the end date + due-day on the end date', () {
    final t = BillingRules.startTrial(sub(id: 'spotify'), d(2026, 11, 10), now);
    final r = plan([t]);
    expect(r.map((e) => e.kind), [ReminderKind.trialEnding, ReminderKind.dueToday]);
    expect(r.first.fireAt, DateTime(2026, 11, 7, 9));
  });

  test('cancelled → nothing', () {
    expect(plan([sub(anchor: d(2026, 11, 20), status: SubscriptionStatus.cancelled)]), isEmpty);
  });

  test('sorted by time and capped for the iOS 64-pending limit', () {
    final subs = [
      for (var i = 0; i < 40; i++) sub(id: 's$i', anchor: d(2026, 11, 10).addDays(i)),
    ];
    final r = plan(subs);
    expect(r, hasLength(ReminderPlanner.maxPending));
    for (var i = 1; i < r.length; i++) {
      expect(r[i].fireAt.isBefore(r[i - 1].fireAt), isFalse);
    }
  });
}
