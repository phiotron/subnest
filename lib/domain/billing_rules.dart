import 'confirmed_period.dart';
import 'local_date.dart';
import 'subscription.dart';

/// Result of confirming one Billing period.
class ConfirmResult {
  const ConfirmResult(this.subscription, this.period);

  /// The subscription with its Due date moved to the next period.
  final Subscription subscription;

  /// The new Payment / Skipped period record.
  final ConfirmedPeriod period;
}

/// Pure business rules for Billing periods (CONTEXT.md, ADR 0001).
///
/// Nothing here touches the clock or storage: callers pass `today` / `now` and an id
/// generator, so every rule is unit-testable.
abstract final class BillingRules {
  /// Upper bound when catching up overdue periods (daily cycle left alone for years).
  static const int maxCatchUp = 1000;

  /// Status to show: a Trial whose end date has arrived is `active` (rule: Trial auto-becomes Active).
  static SubscriptionStatus effectiveStatus(Subscription s, LocalDate today) {
    if (s.status == SubscriptionStatus.trial) {
      final end = s.trialEndDate;
      if (end == null || today.isOnOrAfter(end)) return SubscriptionStatus.active;
    }
    return s.status;
  }

  /// Persists the Trial → Active transition. Returns [s] unchanged when nothing to do.
  static Subscription normalize(Subscription s, LocalDate today, DateTime now) {
    final effective = effectiveStatus(s, today);
    if (effective == s.status) return s;
    return s.copyWith(status: effective, updatedAt: now);
  }

  /// Whether the current Billing period has reached its Due date and waits for the user.
  static bool isAwaitingConfirmation(Subscription s, LocalDate today) {
    if (effectiveStatus(s, today) == SubscriptionStatus.cancelled) return false;
    return s.dueDate.isOnOrBefore(today);
  }

  /// Due dates of all periods that are due (≤ [today]) and not yet confirmed, oldest first.
  /// The first one is the current Due date. Empty when nothing is awaiting.
  static List<LocalDate> pendingDueDates(Subscription s, LocalDate today) {
    if (!isAwaitingConfirmation(s, today)) return const [];
    final result = <LocalDate>[];
    for (var i = s.periodIndex; i < s.periodIndex + maxCatchUp; i++) {
      final d = s.cycle.occurrence(s.anchorDate, i);
      if (d.isAfter(today)) break;
      result.add(d);
    }
    return result;
  }

  /// Days from [today] until the current Due date (negative when overdue).
  static int daysUntilDue(Subscription s, LocalDate today) => today.daysUntil(s.dueDate);

  /// Confirms the current (oldest pending) Billing period.
  ///
  /// [amountMinor] is the amount actually paid; defaults to the current My share.
  /// Throws [StateError] when the period is not awaiting confirmation yet ("Later" is
  /// simply not calling this).
  static ConfirmResult confirm(
    Subscription s, {
    required PeriodOutcome outcome,
    int? amountMinor,
    required LocalDate today,
    required DateTime now,
    required String Function() newId,
  }) {
    if (!isAwaitingConfirmation(s, today)) {
      throw StateError('${s.name}: period ${s.dueDate} is not awaiting confirmation on $today');
    }
    final period = ConfirmedPeriod(
      id: newId(),
      subscriptionId: s.id,
      dueDate: s.dueDate,
      outcome: outcome,
      amountMinor: outcome == PeriodOutcome.payment ? (amountMinor ?? s.myShareMinor) : 0,
      currency: s.currency,
      confirmedAt: now,
    );
    final next = normalize(s, today, now).copyWith(periodIndex: s.periodIndex + 1, updatedAt: now);
    return ConfirmResult(next, period);
  }

  /// "Confirm all": marks every pending period as paid at the current My share.
  static (Subscription, List<ConfirmedPeriod>) confirmAll(
    Subscription s, {
    required LocalDate today,
    required DateTime now,
    required String Function() newId,
  }) {
    var current = s;
    final periods = <ConfirmedPeriod>[];
    while (isAwaitingConfirmation(current, today) && periods.length < maxCatchUp) {
      final r = confirm(current, outcome: PeriodOutcome.payment, today: today, now: now, newId: newId);
      current = r.subscription;
      periods.add(r.period);
    }
    return (current, periods);
  }

  /// Due dates from the current period on that fall in [[from], [to]] (inclusive).
  /// Includes pending periods; empty for cancelled subscriptions. Used by Calendar,
  /// Upcoming and projections.
  static List<LocalDate> dueDatesBetween(Subscription s, LocalDate from, LocalDate to) {
    if (s.status == SubscriptionStatus.cancelled) return const [];
    final result = <LocalDate>[];
    for (var i = s.periodIndex; i < s.periodIndex + 100000; i++) {
      final d = s.cycle.occurrence(s.anchorDate, i);
      if (d.isAfter(to)) break;
      if (d.isOnOrAfter(from)) result.add(d);
    }
    return result;
  }

  /// Re-anchors the schedule so the current Due date becomes [newDueDate]
  /// (user edited the next due date or the cycle in the form).
  static Subscription rebase(Subscription s, LocalDate newDueDate, DateTime now) =>
      s.copyWith(anchorDate: newDueDate, periodIndex: 0, updatedAt: now);

  /// Starts a Trial ending on [trialEnd]: the Trial end is the Due date of the first paid period.
  static Subscription startTrial(Subscription s, LocalDate trialEnd, DateTime now) => s.copyWith(
    status: SubscriptionStatus.trial,
    trialEndDate: trialEnd,
    anchorDate: trialEnd,
    periodIndex: 0,
    updatedAt: now,
  );

  /// Marks as Cancelled. Pending periods are dropped (nothing more to pay); history is kept.
  static Subscription cancel(Subscription s, LocalDate today, DateTime now) =>
      s.copyWith(status: SubscriptionStatus.cancelled, cancelledOn: today, updatedAt: now);

  /// Restores a Cancelled subscription. The time spent cancelled is skipped silently:
  /// the Due date moves to the first occurrence on or after [today].
  static Subscription restore(Subscription s, LocalDate today, DateTime now) {
    if (s.status != SubscriptionStatus.cancelled) return s;
    final trialEnd = s.trialEndDate;
    final status = (trialEnd != null && today.isBefore(trialEnd))
        ? SubscriptionStatus.trial
        : SubscriptionStatus.active;
    var index = s.periodIndex;
    while (s.cycle.occurrence(s.anchorDate, index).isBefore(today) && index < s.periodIndex + 100000) {
      index++;
    }
    return s.copyWith(status: status, cancelledOn: null, periodIndex: index, updatedAt: now);
  }
}
