import 'package:collection/collection.dart';

import 'billing_rules.dart';
import 'category.dart';
import 'confirmed_period.dart';
import 'exchange_rates.dart';
import 'local_date.dart';
import 'money.dart';
import 'subscription.dart';

/// Totals for the Home header (amounts in the Primary currency, major units).
class SpendingSummary {
  const SpendingSummary({
    required this.monthly,
    required this.trialMonthly,
    required this.savingsYearly,
    required this.activeCount,
    required this.trialCount,
    required this.cancelledCount,
    required this.awaitingCount,
    required this.awaitingTotal,
    required this.missingRates,
  });

  /// Sum of Monthly cost of `Active` subscriptions.
  final double monthly;
  double get yearly => monthly * 12;

  /// Monthly cost of Trials ("will be charged soon"), shown separately.
  final double trialMonthly;

  /// Savings: yearly cost of Cancelled subscriptions.
  final double savingsYearly;

  final int activeCount;
  final int trialCount;
  final int cancelledCount;

  /// Number of pending Billing periods (all subscriptions) and their total at current My share.
  final int awaitingCount;
  final double awaitingTotal;

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
class SpendingCalculator {
  const SpendingCalculator({required this.rates, required this.primaryCurrency});

  final ExchangeRates rates;
  final String primaryCurrency;

  double? _toPrimary(Money m) => rates.convert(m.major, m.currency, primaryCurrency);

  /// My share converted to Primary currency for one period; `null` when the rate is unknown.
  double? periodCost(Subscription s) => _toPrimary(s.myShare);

  /// Monthly cost: My share per period × periods per month, in Primary currency.
  double? monthlyCost(Subscription s) {
    final p = periodCost(s);
    return p == null ? null : p * s.cycle.periodsPerMonth;
  }

  double? yearlyCost(Subscription s) {
    final m = monthlyCost(s);
    return m == null ? null : m * 12;
  }

  SpendingSummary summary(Iterable<Subscription> subs, LocalDate today) {
    var monthly = 0.0, trialMonthly = 0.0, savings = 0.0, awaitingTotal = 0.0;
    var active = 0, trial = 0, cancelled = 0, awaiting = 0;
    final missing = <String>{};
    for (final s in subs) {
      final status = BillingRules.effectiveStatus(s, today);
      final cost = monthlyCost(s);
      if (cost == null) missing.add(s.currency);
      switch (status) {
        case SubscriptionStatus.active:
          active++;
          monthly += cost ?? 0;
        case SubscriptionStatus.trial:
          trial++;
          trialMonthly += cost ?? 0;
        case SubscriptionStatus.cancelled:
          cancelled++;
          savings += (cost ?? 0) * 12;
      }
      final pending = BillingRules.pendingDueDates(s, today).length;
      if (pending > 0) {
        awaiting += pending;
        awaitingTotal += (periodCost(s) ?? 0) * pending;
      }
    }
    return SpendingSummary(
      monthly: monthly,
      trialMonthly: trialMonthly,
      savingsYearly: savings,
      activeCount: active,
      trialCount: trial,
      cancelledCount: cancelled,
      awaitingCount: awaiting,
      awaitingTotal: awaitingTotal,
      missingRates: missing,
    );
  }

  /// Monthly cost of Active subscriptions grouped by category, largest first.
  List<MapEntry<SubscriptionCategory, double>> byCategory(Iterable<Subscription> subs, LocalDate today) {
    final totals = <SubscriptionCategory, double>{};
    for (final s in subs) {
      if (BillingRules.effectiveStatus(s, today) != SubscriptionStatus.active) continue;
      totals.update(s.category, (v) => v + (monthlyCost(s) ?? 0), ifAbsent: () => monthlyCost(s) ?? 0);
    }
    return totals.entries.sorted((a, b) => b.value.compareTo(a.value));
  }

  /// Most expensive Active subscriptions by Monthly cost.
  List<(Subscription, double)> top(Iterable<Subscription> subs, LocalDate today, {int count = 5}) {
    return subs
        .where((s) => BillingRules.effectiveStatus(s, today) == SubscriptionStatus.active)
        .map((s) => (s, monthlyCost(s) ?? 0))
        .sorted((a, b) => b.$2.compareTo(a.$2))
        .take(count)
        .toList();
  }

  /// Actual spending (sum of Payments) with due date in the given month.
  double actualInMonth(Iterable<ConfirmedPeriod> periods, LocalDate month) {
    var sum = 0.0;
    for (final p in periods) {
      if (!p.isPayment) continue;
      if (p.dueDate.year != month.year || p.dueDate.month != month.month) continue;
      sum += _toPrimary(p.amount) ?? 0;
    }
    return sum;
  }

  /// Projected spending in a month: unconfirmed/future periods of non-cancelled subscriptions
  /// (Trials included — they will be charged on their end date).
  double projectedInMonth(Iterable<Subscription> subs, LocalDate month) {
    final from = month.firstOfMonth;
    final to = from.addMonths(1).addDays(-1);
    var sum = 0.0;
    for (final s in subs) {
      final n = BillingRules.dueDatesBetween(s, from, to).length;
      if (n > 0) sum += (periodCost(s) ?? 0) * n;
    }
    return sum;
  }

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

  /// Total paid over the life of one subscription (its Payments), in Primary currency.
  double totalPaid(Iterable<ConfirmedPeriod> periods) =>
      periods.where((p) => p.isPayment).map((p) => _toPrimary(p.amount) ?? 0).sum;
}
