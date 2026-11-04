import 'billing_rules.dart';
import 'confirmed_period.dart';
import 'local_date.dart';
import 'subscription.dart';

/// State of one Calendar / Upcoming entry.
enum CalendarEntryKind {
  /// A Payment (confirmed paid).
  paid,

  /// A Skipped period.
  skipped,

  /// Due date reached, waiting for the user.
  awaiting,

  /// Future Billing period (projection).
  upcoming,
}

class CalendarEntry {
  const CalendarEntry({required this.date, required this.subscription, required this.kind, this.period});

  final LocalDate date;
  final Subscription subscription;
  final CalendarEntryKind kind;

  /// The confirmed record for [CalendarEntryKind.paid] / [CalendarEntryKind.skipped].
  final ConfirmedPeriod? period;
}

/// Builds Calendar (S8) and Upcoming (S2) entries.
abstract final class CalendarBuilder {
  /// All entries with a date in [[from], [to]], sorted by date then name.
  static List<CalendarEntry> entries({
    required Iterable<Subscription> subscriptions,
    required Iterable<ConfirmedPeriod> periods,
    required LocalDate from,
    required LocalDate to,
    required LocalDate today,
  }) {
    final byId = {for (final s in subscriptions) s.id: s};
    final out = <CalendarEntry>[];
    for (final p in periods) {
      final s = byId[p.subscriptionId];
      if (s == null || p.dueDate.isBefore(from) || p.dueDate.isAfter(to)) continue;
      out.add(CalendarEntry(
        date: p.dueDate,
        subscription: s,
        kind: p.isPayment ? CalendarEntryKind.paid : CalendarEntryKind.skipped,
        period: p,
      ));
    }
    for (final s in subscriptions) {
      for (final d in BillingRules.dueDatesBetween(s, from, to)) {
        out.add(CalendarEntry(
          date: d,
          subscription: s,
          kind: d.isOnOrBefore(today) ? CalendarEntryKind.awaiting : CalendarEntryKind.upcoming,
        ));
      }
    }
    out.sort((a, b) {
      final c = a.date.compareTo(b.date);
      return c != 0 ? c : a.subscription.name.toLowerCase().compareTo(b.subscription.name.toLowerCase());
    });
    return out;
  }

  /// Upcoming periods in the next [days] days (excluding pending ones).
  static List<CalendarEntry> upcoming({
    required Iterable<Subscription> subscriptions,
    required LocalDate today,
    int days = 7,
  }) => entries(
    subscriptions: subscriptions,
    periods: const [],
    from: today.addDays(1),
    to: today.addDays(days),
    today: today,
  );
}
