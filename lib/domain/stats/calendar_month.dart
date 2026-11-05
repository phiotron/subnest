import '../calendar.dart';
import '../confirmed_period.dart';
import '../exchange_rates.dart';
import '../local_date.dart';
import '../money.dart';
import '../subscription.dart';

/// Agenda section of the Calendar list view (S8, design png 43).
enum AgendaGroupKind {
  /// Payments / Skipped periods earlier in the current month.
  earlier,

  /// Periods awaiting confirmation in the month.
  toConfirm,

  /// Upcoming from tomorrow to the end of this week (Sunday).
  thisWeek,

  /// Upcoming after this week, still in the month.
  later,

  /// Next month's upcoming periods (only below the current month).
  nextMonth,

  /// Every entry of a past or future month, in date order.
  month,
}

class AgendaGroup {
  const AgendaGroup(this.kind, this.entries);

  final AgendaGroupKind kind;
  final List<CalendarEntry> entries;
}

/// One month of the Calendar (S8): entries per day plus the header total.
///
/// Past months (before today's month) total the **Payments** made ("Paid in October");
/// the current and future months total Payments + periods still expected (awaiting and
/// upcoming, at the current My share) — the same as `SpendingCalculator.actualInMonth +
/// projectedInMonth`. Amounts are converted to the Primary currency; unknown rates are left out
/// and listed in [missingRates].
class CalendarMonth {
  CalendarMonth._({
    required this.month,
    required this.today,
    required this.entries,
    required this.total,
    required this.converted,
    required this.missingRates,
  });

  /// Builds the month containing [month] (any day of it).
  factory CalendarMonth.build({
    required Iterable<Subscription> subscriptions,
    required Iterable<ConfirmedPeriod> periods,
    required LocalDate month,
    required LocalDate today,
    required ExchangeRates rates,
    required String primaryCurrency,
  }) {
    final first = month.firstOfMonth;
    final last = first.addMonths(1).addDays(-1);
    final entries = CalendarBuilder.entries(
      subscriptions: subscriptions,
      periods: periods,
      from: first,
      to: last,
      today: today,
    );
    final past = first.isBefore(today.firstOfMonth);
    var total = 0.0;
    var converted = false;
    final missing = <String>{};
    for (final e in entries) {
      final counts = past ? e.kind == CalendarEntryKind.paid : e.kind != CalendarEntryKind.skipped;
      if (!counts) continue;
      final m = amountOf(e);
      if (m.currency.toUpperCase() != primaryCurrency.toUpperCase()) converted = true;
      final v = rates.convert(m.major, m.currency, primaryCurrency);
      if (v == null) {
        missing.add(m.currency);
      } else {
        total += v;
      }
    }
    return CalendarMonth._(
      month: first,
      today: today,
      entries: List.unmodifiable(entries),
      total: total,
      converted: converted,
      missingRates: missing,
    );
  }

  /// First day of the month.
  final LocalDate month;
  final LocalDate today;

  /// Every entry of the month, by date then name (see [CalendarBuilder.entries]).
  final List<CalendarEntry> entries;

  /// Header total in the Primary currency (see class doc).
  final double total;

  /// Whether any counted amount was converted from another currency.
  final bool converted;

  /// Currencies without a rate to the Primary currency (left out of [total]).
  final Set<String> missingRates;

  LocalDate get lastDay => month.addMonths(1).addDays(-1);
  int get daysInMonth => LocalDate.daysInMonth(month.year, month.month);

  /// Before today's month: the header shows "Paid in …" and only Payments count.
  bool get isPast => month.isBefore(today.firstOfMonth);
  bool get isCurrent => month == today.firstOfMonth;

  /// The total is an estimate ("≈"): it holds expected periods or converted amounts.
  bool get approx =>
      converted ||
      (!isPast && entries.any((e) => e.kind == CalendarEntryKind.awaiting || e.kind == CalendarEntryKind.upcoming));

  int _count(CalendarEntryKind k) => entries.where((e) => e.kind == k).length;
  int get paidCount => _count(CalendarEntryKind.paid);
  int get skippedCount => _count(CalendarEntryKind.skipped);
  int get awaitingCount => _count(CalendarEntryKind.awaiting);
  int get upcomingCount => _count(CalendarEntryKind.upcoming);

  /// Entries that cost money (everything but Skipped periods): "6 payments".
  int get paymentCount => entries.length - skippedCount;

  /// Entries on [day] (1-based day of this month).
  List<CalendarEntry> onDay(int day) => entries.where((e) => e.date.day == day).toList();

  /// Days of this month that have an entry awaiting confirmation.
  bool hasAwaiting(int day) => entries.any((e) => e.date.day == day && e.kind == CalendarEntryKind.awaiting);

  /// Amount shown for an entry in its own currency: the Payment amount when paid, otherwise
  /// the current My share (also for Skipped periods, drawn struck through).
  static Money amountOf(CalendarEntry e) =>
      e.kind == CalendarEntryKind.paid && e.period != null ? e.period!.amount : e.subscription.myShare;

  /// Agenda sections. The current month splits into Earlier · To confirm · This week · Later
  /// (+ [next] month's upcoming periods when given); any other month is one [AgendaGroupKind.month]
  /// section. Empty sections are dropped.
  List<AgendaGroup> agenda({CalendarMonth? next}) {
    if (!isCurrent) {
      return [if (entries.isNotEmpty) AgendaGroup(AgendaGroupKind.month, entries)];
    }
    // ISO week: Monday = 1 … Sunday = 7.
    final weekday = DateTime.utc(today.year, today.month, today.day).weekday;
    final endOfWeek = today.addDays(7 - weekday);
    final earlier = <CalendarEntry>[],
        toConfirm = <CalendarEntry>[],
        week = <CalendarEntry>[],
        later = <CalendarEntry>[];
    for (final e in entries) {
      switch (e.kind) {
        case CalendarEntryKind.paid || CalendarEntryKind.skipped:
          earlier.add(e);
        case CalendarEntryKind.awaiting:
          toConfirm.add(e);
        case CalendarEntryKind.upcoming:
          (e.date.isOnOrBefore(endOfWeek) ? week : later).add(e);
      }
    }
    final nextUpcoming = next?.entries.where((e) => e.kind == CalendarEntryKind.upcoming).toList() ?? const [];
    return [
      if (toConfirm.isNotEmpty) AgendaGroup(AgendaGroupKind.toConfirm, toConfirm),
      if (week.isNotEmpty) AgendaGroup(AgendaGroupKind.thisWeek, week),
      if (later.isNotEmpty) AgendaGroup(AgendaGroupKind.later, later),
      if (nextUpcoming.isNotEmpty) AgendaGroup(AgendaGroupKind.nextMonth, nextUpcoming),
      if (earlier.isNotEmpty) AgendaGroup(AgendaGroupKind.earlier, earlier),
    ];
  }
}
