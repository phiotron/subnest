import 'package:collection/collection.dart';

import 'billing_rules.dart';
import 'category.dart';
import 'confirmed_period.dart';
import 'exchange_rates.dart';
import 'local_date.dart';
import 'money.dart';
import 'ratio.dart';
import 'subscription.dart';

/// Totals for the Home header, in the Primary currency.
///
/// Every total is a sum of Converted amounts (each line rounded to the smallest unit of the
/// Primary currency), kept as integer minor units in the `*Minor` fields; the `double` getters
/// are the same numbers in major units for display.
class SpendingSummary {
  const SpendingSummary({
    required this.currency,
    required this.monthlyMinor,
    required this.yearlyMinor,
    required this.trialMonthlyMinor,
    required this.savingsYearlyMinor,
    required this.activeCount,
    required this.trialCount,
    required this.cancelledCount,
    this.pausedCount = 0,
    required this.awaitingCount,
    required this.awaitingTotalMinor,
    required this.missingRates,
  });

  /// Primary currency of every amount here.
  final String currency;

  /// Sum of Monthly cost of `Active` subscriptions (minor units) — the "monthly total".
  final int monthlyMinor;

  /// Sum of Yearly cost of `Active` subscriptions (minor units) — the "yearly total". Each
  /// Yearly cost is its own rounded line, so this is not always [monthlyMinor] × 12.
  final int yearlyMinor;

  /// Monthly cost of Trials ("will be charged soon"), shown separately.
  final int trialMonthlyMinor;

  /// Savings: sum of the Yearly cost of Cancelled subscriptions.
  final int savingsYearlyMinor;

  /// Pending Billing periods (all subscriptions) at current My share.
  final int awaitingTotalMinor;

  double get monthly => toMajorUnits(monthlyMinor, currency);
  double get yearly => toMajorUnits(yearlyMinor, currency);
  double get trialMonthly => toMajorUnits(trialMonthlyMinor, currency);
  double get savingsYearly => toMajorUnits(savingsYearlyMinor, currency);
  double get awaitingTotal => toMajorUnits(awaitingTotalMinor, currency);

  final int activeCount;
  final int trialCount;
  final int cancelledCount;

  /// Paused subscriptions (not in any total).
  final int pausedCount;

  /// Number of pending Billing periods (all subscriptions).
  final int awaitingCount;

  /// Currencies with no known rate to the Primary currency (excluded from totals).
  final Set<String> missingRates;
}

/// One month of the 12-month chart: actual (from Payments) vs projected (unconfirmed / future).
class MonthSpending {
  const MonthSpending(this.month, this.actual, this.projected);

  /// First day of the month.
  final LocalDate month;
  final double actual;
  final double projected;
}

/// Spending maths (Monthly cost, totals, Savings, insights). Pure; amounts in Primary currency.
///
/// Each line (a subscription's My share / Monthly cost / Yearly cost, a Payment) is converted
/// exactly and rounded half-up to the smallest unit of the Primary currency (a Converted
/// amount, `*Minor` methods); every total is the integer sum of those lines, so totals always
/// match the lines on screen. The `double` methods return the same numbers in major units.
/// A line whose currency has no rate is `null` and left out of totals.
class SpendingCalculator {
  const SpendingCalculator({required this.rates, required this.primaryCurrency});

  final ExchangeRates rates;
  final String primaryCurrency;

  double? _major(int? minor) => minor == null ? null : toMajorUnits(minor, primaryCurrency);
  double _majorOf(int minor) => toMajorUnits(minor, primaryCurrency);

  /// [m] as a Converted amount in the Primary currency (minor units); `null` when the rate is unknown.
  int? toPrimaryMinor(Money m) => rates.convertMinor(m.minor, m.currency, primaryCurrency);

  /// My share for one period, converted (minor units).
  int? periodCostMinor(Subscription s) => toPrimaryMinor(s.myShare);

  /// Monthly cost: My share × periods per month, converted and rounded once (minor units).
  int? monthlyCostMinor(Subscription s) =>
      rates.convertMinor(s.myShareMinor, s.currency, primaryCurrency, times: s.cycle.periodsPerMonthRatio);

  /// Yearly cost: My share × periods per year, converted and rounded once (minor units).
  int? yearlyCostMinor(Subscription s) => rates.convertMinor(
    s.myShareMinor,
    s.currency,
    primaryCurrency,
    times: s.cycle.periodsPerMonthRatio * Ratio.ints(12),
  );

  /// My share converted to Primary currency for one period; `null` when the rate is unknown.
  double? periodCost(Subscription s) => _major(periodCostMinor(s));

  /// Monthly cost: My share per period × periods per month, in Primary currency.
  double? monthlyCost(Subscription s) => _major(monthlyCostMinor(s));

  double? yearlyCost(Subscription s) => _major(yearlyCostMinor(s));

  SpendingSummary summary(Iterable<Subscription> subs, LocalDate today) {
    var monthly = 0, yearly = 0, trialMonthly = 0, savings = 0, awaitingTotal = 0;
    var active = 0, trial = 0, cancelled = 0, paused = 0, awaiting = 0;
    final missing = <String>{};
    for (final s in subs) {
      final status = BillingRules.effectiveStatus(s, today);
      final cost = monthlyCostMinor(s);
      if (cost == null) missing.add(s.currency);
      switch (status) {
        case SubscriptionStatus.active:
          active++;
          monthly += cost ?? 0;
          yearly += yearlyCostMinor(s) ?? 0;
        case SubscriptionStatus.trial:
          trial++;
          trialMonthly += cost ?? 0;
        case SubscriptionStatus.cancelled:
          cancelled++;
          savings += yearlyCostMinor(s) ?? 0;
        case SubscriptionStatus.paused:
          paused++;
      }
      final pending = BillingRules.pendingDueDates(s, today).length;
      if (pending > 0) {
        awaiting += pending;
        awaitingTotal += (periodCostMinor(s) ?? 0) * pending;
      }
    }
    return SpendingSummary(
      currency: primaryCurrency,
      monthlyMinor: monthly,
      yearlyMinor: yearly,
      trialMonthlyMinor: trialMonthly,
      savingsYearlyMinor: savings,
      activeCount: active,
      trialCount: trial,
      cancelledCount: cancelled,
      pausedCount: paused,
      awaitingCount: awaiting,
      awaitingTotalMinor: awaitingTotal,
      missingRates: missing,
    );
  }

  /// Monthly cost (minor units) of Active subscriptions grouped by [keyOf], largest first.
  List<MapEntry<K, int>> _byKeyMinor<K>(Iterable<Subscription> subs, LocalDate today, K Function(Subscription) keyOf) {
    final totals = <K, int>{};
    for (final s in subs) {
      if (BillingRules.effectiveStatus(s, today) != SubscriptionStatus.active) continue;
      final cost = monthlyCostMinor(s) ?? 0;
      totals.update(keyOf(s), (v) => v + cost, ifAbsent: () => cost);
    }
    return totals.entries.sorted((a, b) => b.value.compareTo(a.value));
  }

  /// Monthly cost of Active subscriptions grouped by category, largest first.
  List<MapEntry<SubscriptionCategory, double>> byCategory(Iterable<Subscription> subs, LocalDate today) => [
    for (final e in _byKeyMinor(subs, today, (s) => s.category)) MapEntry(e.key, _majorOf(e.value)),
  ];

  /// Monthly cost (minor units) of Active subscriptions grouped by Category id, largest first.
  List<MapEntry<String, int>> byCategoryIdMinor(Iterable<Subscription> subs, LocalDate today) =>
      _byKeyMinor(subs, today, (s) => s.categoryId);

  /// Monthly cost of Active subscriptions grouped by Category id (custom categories included), largest first.
  List<MapEntry<String, double>> byCategoryId(Iterable<Subscription> subs, LocalDate today) => [
    for (final e in byCategoryIdMinor(subs, today)) MapEntry(e.key, _majorOf(e.value)),
  ];

  /// Most expensive Active subscriptions by Monthly cost.
  List<(Subscription, double)> top(Iterable<Subscription> subs, LocalDate today, {int count = 5}) {
    return subs
        .where((s) => BillingRules.effectiveStatus(s, today) == SubscriptionStatus.active)
        .map((s) => (s, monthlyCostMinor(s) ?? 0))
        .sorted((a, b) => b.$2.compareTo(a.$2))
        .take(count)
        .map((e) => (e.$1, _majorOf(e.$2)))
        .toList();
  }

  /// Actual spending (sum of converted Payments) with due date in the given month, minor units.
  int actualInMonthMinor(Iterable<ConfirmedPeriod> periods, LocalDate month) {
    var sum = 0;
    for (final p in periods) {
      if (!p.isPayment) continue;
      if (p.dueDate.year != month.year || p.dueDate.month != month.month) continue;
      sum += toPrimaryMinor(p.amount) ?? 0;
    }
    return sum;
  }

  /// Actual spending (sum of Payments) with due date in the given month.
  double actualInMonth(Iterable<ConfirmedPeriod> periods, LocalDate month) =>
      _majorOf(actualInMonthMinor(periods, month));

  /// Projected spending in a month (minor units): unconfirmed/future periods of non-cancelled
  /// subscriptions (Trials included — they will be charged on their end date), each at the
  /// converted My share.
  int projectedInMonthMinor(Iterable<Subscription> subs, LocalDate month) {
    final from = month.firstOfMonth;
    final to = from.addMonths(1).addDays(-1);
    var sum = 0;
    for (final s in subs) {
      final n = BillingRules.dueDatesBetween(s, from, to).length;
      if (n > 0) sum += (periodCostMinor(s) ?? 0) * n;
    }
    return sum;
  }

  /// Projected spending in a month (see [projectedInMonthMinor]).
  double projectedInMonth(Iterable<Subscription> subs, LocalDate month) =>
      _majorOf(projectedInMonthMinor(subs, month));

  /// [count] months ending with the month of [lastMonth] (oldest first).
  List<MonthSpending> monthlySeries(
    Iterable<Subscription> subs,
    Iterable<ConfirmedPeriod> periods,
    LocalDate lastMonth, {
    int count = 12,
  }) {
    final last = lastMonth.firstOfMonth;
    return [
      for (var i = count - 1; i >= 0; i--)
        () {
          final m = last.addMonths(-i);
          return MonthSpending(m, actualInMonth(periods, m), projectedInMonth(subs, m));
        }(),
    ];
  }

  /// Total paid over the life of one subscription (sum of its converted Payments), minor units.
  int totalPaidMinor(Iterable<ConfirmedPeriod> periods) =>
      periods.where((p) => p.isPayment).fold(0, (a, p) => a + (toPrimaryMinor(p.amount) ?? 0));

  /// Total paid over the life of one subscription (its Payments), in Primary currency.
  double totalPaid(Iterable<ConfirmedPeriod> periods) => _majorOf(totalPaidMinor(periods));
}
