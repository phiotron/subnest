import 'package:collection/collection.dart';

import '../confirmed_period.dart';
import '../local_date.dart';
import '../money.dart';
import '../price_history.dart';
import '../ratio.dart';
import '../spending.dart';
import '../subscription.dart';
import 'forecast.dart';

/// Last day of [month]'s month.
LocalDate lastOfMonth(LocalDate month) => month.firstOfMonth.addMonths(1).addDays(-1);

/// One subscription's share of a Month spend (or Year spend): its Monthly cost in that month.
class SpendLine {
  const SpendLine(this.subscription, this.amountMinor);
  final Subscription subscription;

  /// Converted amount in the Primary currency (minor units).
  final int amountMinor;
}

/// Glossary: Month spend — what month [month] costs (each subscription paying in that month adds its
/// Monthly cost at the price in effect then), with the Daily average and the change from the month
/// before. All amounts in the Primary currency [currency], minor units; totals are sums of lines.
class MonthSpend {
  const MonthSpend({
    required this.month,
    required this.currency,
    required this.lines,
    required this.missingRates,
    this.previousTotalMinor,
  });

  /// First day of the month.
  final LocalDate month;
  final String currency;

  /// Subscriptions paying in the month, dearest first (the "most expensive" list).
  final List<SpendLine> lines;

  /// Currencies without a rate (their subscriptions are left out of [lines]).
  final Set<String> missingRates;

  /// [totalMinor] of the month before; `null` when not computed.
  final int? previousTotalMinor;

  int get totalMinor => lines.fold(0, (a, l) => a + l.amountMinor);

  /// Number of subscriptions counted in the month.
  int get count => lines.length;

  int get daysInMonth => LocalDate.daysInMonth(month.year, month.month);

  /// Glossary: Daily average — [totalMinor] ÷ days of this month (28–31), rounded half-up.
  int get dailyAverageMinor => roundHalfUp(BigInt.from(totalMinor), BigInt.from(daysInMonth));

  /// Change from the month before (positive = more); `null` without [previousTotalMinor].
  int? get changeMinor => previousTotalMinor == null ? null : totalMinor - previousTotalMinor!;

  /// Month spend per Category id, largest first.
  List<MapEntry<String, int>> get byCategoryIdMinor => _byCategory(lines);

  double get total => toMajorUnits(totalMinor, currency);
  double get dailyAverage => toMajorUnits(dailyAverageMinor, currency);
}

List<MapEntry<String, int>> _byCategory(Iterable<SpendLine> lines) {
  final m = <String, int>{};
  for (final l in lines) {
    m.update(l.subscription.categoryId, (v) => v + l.amountMinor, ifAbsent: () => l.amountMinor);
  }
  return m.entries.sorted((a, b) => b.value.compareTo(a.value));
}

/// A calendar year = the 12 Month spends of January–December added up.
class YearSpend {
  const YearSpend({required this.year, required this.currency, required this.months, this.previousTotalMinor});

  final int year;
  final String currency;

  /// January … December.
  final List<MonthSpend> months;

  /// [totalMinor] of the year before; `null` when not computed.
  final int? previousTotalMinor;

  int get totalMinor => months.fold(0, (a, m) => a + m.totalMinor);

  int get daysInYear => LocalDate.isLeapYear(year) ? 366 : 365;

  /// Year total ÷ days of the year, rounded half-up.
  int get dailyAverageMinor => roundHalfUp(BigInt.from(totalMinor), BigInt.from(daysInYear));

  int? get changeMinor => previousTotalMinor == null ? null : totalMinor - previousTotalMinor!;

  /// Per subscription, the sum of its 12 months, dearest first.
  List<SpendLine> get lines {
    final sums = <String, int>{};
    final subs = <String, Subscription>{};
    for (final m in months) {
      for (final l in m.lines) {
        subs[l.subscription.id] = l.subscription;
        sums.update(l.subscription.id, (v) => v + l.amountMinor, ifAbsent: () => l.amountMinor);
      }
    }
    return [for (final e in sums.entries) SpendLine(subs[e.key]!, e.value)]
        .sorted((a, b) => b.amountMinor.compareTo(a.amountMinor));
  }

  /// Subscriptions counted in at least one month.
  int get count => {for (final m in months) ...m.lines.map((l) => l.subscription.id)}.length;

  List<MapEntry<String, int>> get byCategoryIdMinor => _byCategory(months.expand((m) => m.lines));

  Set<String> get missingRates => {for (final m in months) ...m.missingRates};

  double get total => toMajorUnits(totalMinor, currency);
}

/// A Payment of the month with its Converted amount.
class PaidItem {
  const PaidItem(this.period, this.amountMinor, {this.rateMissing = false});
  final ConfirmedPeriod period;
  final int amountMinor;
  final bool rateMissing;
}

/// Glossary: Month cash flow — money actually charged in [month]: [paidMinor] (Payments of periods
/// due in the month) and [remainingMinor] (Due dates still ahead in the month + periods of the month
/// Awaiting confirmation, each at the full period price — a yearly plan renewing this month counts
/// its whole yearly price). Can differ from the Month spend.
class MonthCashFlow {
  const MonthCashFlow({
    required this.month,
    required this.today,
    required this.currency,
    required this.paid,
    required this.remaining,
  });

  final LocalDate month;
  final LocalDate today;
  final String currency;

  /// Payments with a Due date in the month, oldest first.
  final List<PaidItem> paid;

  /// Unconfirmed periods due in the month (awaiting and upcoming), oldest first.
  final List<ForecastItem> remaining;

  int get paidMinor => paid.fold(0, (a, p) => a + p.amountMinor);
  int get remainingMinor => remaining.fold(0, (a, i) => a + i.amountMinor);

  /// Part of [remainingMinor] already due (Awaiting confirmation).
  int get awaitingMinor => remaining.where((i) => i.isAwaiting(today)).fold(0, (a, i) => a + i.amountMinor);

  int get totalMinor => paidMinor + remainingMinor;

  /// 0…1 share paid (for the Paid / Remaining bar); 0 when nothing is due.
  double get paidShare => totalMinor == 0 ? 0 : paidMinor / totalMinor;

  Set<String> get missingRates => {
    for (final p in paid)
      if (p.rateMissing) p.period.currency,
    for (final i in remaining)
      if (i.rateMissing) i.subscription.currency,
  };
}

/// Month spend, Year spend, Daily average and Month cash flow (product.md v2 / CONTEXT.md). Pure.
class MonthStatsCalculator {
  const MonthStatsCalculator(this.calc, {this.history = PriceHistory.empty});

  final SpendingCalculator calc;
  final PriceHistory history;

  String get currency => calc.primaryCurrency;

  /// First day the subscription is paid for: the Trial end when it had a Trial, else the start date.
  static LocalDate paidFrom(Subscription s) {
    final trialEnd = s.trialEndDate;
    return trialEnd != null && trialEnd.isAfter(s.startDate) ? trialEnd : s.startDate;
  }

  /// Day the subscription stopped (cancelled or pause date), `null` while it runs.
  static LocalDate? _stoppedOn(Subscription s) => switch (s.status) {
    SubscriptionStatus.cancelled => s.cancelledOn ?? LocalDate.fromDateTime(s.updatedAt),
    SubscriptionStatus.paused => s.pausedFrom ?? LocalDate.fromDateTime(s.updatedAt),
    _ => null,
  };

  /// Whether [s] is paid for in [month] (glossary: Month spend):
  /// - started (or its Trial ended) on/before the last day of the month — a month still fully in
  ///   Trial, or before the start, is 0;
  /// - Cancelled: counts up to and including the month of the cancel date, 0 after;
  /// - Paused: 0 for months that start on/after the pause date (paused the whole month); the month
  ///   the pause starts in still counts;
  /// - stopped before it was ever paid (cancelled/paused during the Trial) = never.
  static bool isPayingIn(Subscription s, LocalDate month) {
    final first = month.firstOfMonth;
    final start = paidFrom(s);
    if (start.isAfter(lastOfMonth(first))) return false;
    final stop = _stoppedOn(s);
    if (stop == null) return true;
    if (s.status == SubscriptionStatus.cancelled) {
      if (stop.isBefore(start)) return false;
      return !first.isAfter(stop.firstOfMonth);
    }
    // Paused.
    if (!stop.isAfter(start)) return false;
    return first.isBefore(stop);
  }

  /// Monthly cost of [s] in [month] at the price in effect on the month's last day (Price history),
  /// converted and rounded once; 0 when not paying in the month, `null` when the rate is unknown.
  int? monthCostMinor(Subscription s, LocalDate month) {
    if (!isPayingIn(s, month)) return 0;
    final p = history.myShareAt(s, lastOfMonth(month));
    return calc.rates.convertMinor(p.priceMinor, p.currency, currency, times: s.cycle.periodsPerMonthRatio);
  }

  /// Month spend of [month]; with [withPrevious] the month before is computed for the change.
  MonthSpend month(Iterable<Subscription> subs, LocalDate month, {bool withPrevious = true}) {
    final first = month.firstOfMonth;
    final lines = <SpendLine>[];
    final missing = <String>{};
    for (final s in subs) {
      if (!isPayingIn(s, first)) continue;
      final cost = monthCostMinor(s, first);
      if (cost == null) {
        missing.add(s.currency);
        continue;
      }
      lines.add(SpendLine(s, cost));
    }
    lines.sort((a, b) {
      final d = b.amountMinor.compareTo(a.amountMinor);
      return d != 0 ? d : a.subscription.name.toLowerCase().compareTo(b.subscription.name.toLowerCase());
    });
    return MonthSpend(
      month: first,
      currency: currency,
      lines: lines,
      missingRates: missing,
      previousTotalMinor: withPrevious ? this.month(subs, first.addMonths(-1), withPrevious: false).totalMinor : null,
    );
  }

  /// [count] Month spends ending with [lastMonth] (oldest first) — e.g. the 6 bars on Home.
  List<MonthSpend> series(Iterable<Subscription> subs, LocalDate lastMonth, {int count = 6}) {
    final last = lastMonth.firstOfMonth;
    return [for (var i = count - 1; i >= 0; i--) month(subs, last.addMonths(-i), withPrevious: false)];
  }

  /// Year spend of [year] (January–December), with the year before for the change.
  YearSpend year(Iterable<Subscription> subs, int year, {bool withPrevious = true}) {
    final months = [for (var m = 1; m <= 12; m++) month(subs, LocalDate(year, m, 1), withPrevious: false)];
    return YearSpend(
      year: year,
      currency: currency,
      months: months,
      previousTotalMinor: withPrevious ? this.year(subs, year - 1, withPrevious: false).totalMinor : null,
    );
  }

  /// Month cash flow of [month] seen on [today].
  MonthCashFlow cashFlow(
    Iterable<Subscription> subs,
    Iterable<ConfirmedPeriod> periods,
    LocalDate month,
    LocalDate today,
  ) {
    final first = month.firstOfMonth;
    final last = lastOfMonth(first);
    final paid = <PaidItem>[];
    for (final p in periods) {
      if (!p.isPayment || p.dueDate.isBefore(first) || p.dueDate.isAfter(last)) continue;
      final v = calc.toPrimaryMinor(p.amount);
      paid.add(PaidItem(p, v ?? 0, rateMissing: v == null));
    }
    paid.sort((a, b) => a.period.dueDate.compareTo(b.period.dueDate));
    final remaining = ForecastCalculator(calc, history: history).items(subs, first, last);
    return MonthCashFlow(month: first, today: today, currency: currency, paid: paid, remaining: remaining);
  }
}
