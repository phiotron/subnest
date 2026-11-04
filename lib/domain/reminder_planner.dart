import 'billing_rules.dart';
import 'local_date.dart';
import 'subscription.dart';

/// Kind of local notification (product.md §5 S12).
enum ReminderKind {
  /// "Netflix renews in 3 days — ₫260,000"
  renewalSoon,

  /// "Your Spotify trial ends in 3 days…"
  trialEnding,

  /// "Netflix renews today — tap to confirm" (no buttons; tap opens the confirm sheet).
  dueToday,
}

/// A notification to schedule. [route] is the deep link opened on tap.
class PlannedReminder {
  const PlannedReminder({
    required this.kind,
    required this.subscriptionId,
    required this.fireAt,
    required this.dueDate,
    required this.daysBefore,
  });

  final ReminderKind kind;
  final String subscriptionId;

  /// Local wall-clock time to show the notification.
  final DateTime fireAt;
  final LocalDate dueDate;
  final int daysBefore;

  String get route =>
      kind == ReminderKind.dueToday ? '/confirm/$subscriptionId' : '/subscription/$subscriptionId';

  @override
  String toString() => 'PlannedReminder(${kind.name} $subscriptionId at $fireAt)';
}

/// Decides which reminders should be pending right now. The notification service
/// cancels everything and schedules exactly this list after every data change,
/// on app start and after confirmations (ADR 0001: the next period's reminders
/// only exist once the current one is confirmed — they derive from the Due date).
abstract final class ReminderPlanner {
  /// iOS keeps at most 64 pending notifications per app; stay below it.
  static const int maxPending = 60;

  static List<PlannedReminder> plan(
    Iterable<Subscription> subs, {
    required DateTime now,
    required int defaultDays,
    required int hour,
    required int minute,
  }) {
    final today = LocalDate.fromDateTime(now);
    final out = <PlannedReminder>[];
    for (final s in subs) {
      final status = BillingRules.effectiveStatus(s, today);
      if (status == SubscriptionStatus.cancelled) continue;
      final days = s.reminderDays ?? defaultDays;
      if (days == ReminderDays.off) continue;
      final due = s.dueDate;

      void add(ReminderKind kind, int daysBefore) {
        final fireAt = due.addDays(-daysBefore).atTime(hour, minute);
        if (fireAt.isAfter(now)) {
          out.add(PlannedReminder(
            kind: kind,
            subscriptionId: s.id,
            fireAt: fireAt,
            dueDate: due,
            daysBefore: daysBefore,
          ));
        }
      }

      if (days > 0) {
        add(status == SubscriptionStatus.trial ? ReminderKind.trialEnding : ReminderKind.renewalSoon, days);
      }
      add(ReminderKind.dueToday, 0);
    }
    out.sort((a, b) => a.fireAt.compareTo(b.fireAt));
    return out.length > maxPending ? out.sublist(0, maxPending) : out;
  }
}
