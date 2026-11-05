import 'package:collection/collection.dart';

import '../billing_cycle.dart';
import '../billing_rules.dart';
import '../category.dart';
import '../confirmed_period.dart';
import '../local_date.dart';
import '../spending.dart';
import '../subscription.dart';

/// Period picked at the top of Insights (S9): This month · 12 months · This year.
enum InsightsRange { thisMonth, last12Months, thisYear }

/// Months covered by a range (first days, inclusive) and the equal span before it.
class RangeMonths {
  const RangeMonths(this.first, this.last);

  final LocalDate first;
  final LocalDate last;

  int get length => (last.year - first.year) * 12 + last.month - first.month + 1;

  Iterable<LocalDate> get months sync* {
    for (var i = 0; i < length; i++) {
      yield first.addMonths(i);
    }
  }

  /// The same number of months right before this span.
  RangeMonths get previous => RangeMonths(first.addMonths(-length), first.addMonths(-1));

  bool contains(LocalDate d) => !d.firstOfMonth.isBefore(first) && !d.firstOfMonth.isAfter(last);
}

/// Summary card numbers: Payments made (actual) vs periods still expected in the range.
class RangeTotals {
  const RangeTotals({required this.paid, required this.expected, required this.previousTotal});

  /// Sum of Payments with a due date in the range.
  final double paid;

  /// Periods in the range not confirmed yet (awaiting + future) at the current My share.
  final double expected;

  double get total => paid + expected;

  /// [total] of the span right before (same length), for "+14%".
  final double previousTotal;

  /// Whole-percent change of [total] against [previousTotal]; `null` when there is nothing to
  /// compare with (no spending before).
  int? get changePercent {
    if (previousTotal <= 0) return null;
    return ((total - previousTotal) / previousTotal * 100).round();
  }
}

/// One donut slice: the Monthly cost of Active subscriptions in a category.
class CategorySlice {
  const CategorySlice({
    required this.category,
    required this.monthly,
    required this.share,
    required this.subscriptions,
  });

  /// [SubscriptionCategory.other] also holds every category folded into "Other".
  final SubscriptionCategory category;
  final double monthly;

  /// 0…1 of the total.
  final double share;

  /// Members, most expensive first.
  final List<(Subscription, double)> subscriptions;
}

/// "You pay for 2 video services — need both?" (only Music / Video, ≥ 2 Active).
class OverlapHint {
  const OverlapHint({required this.category, required this.subscriptions, required this.monthly});

  final SubscriptionCategory category;
  final List<Subscription> subscriptions;
  final double monthly;
}

/// Months that stand out in the 12-month chart, and the longer-cycle plans behind them.
class PeakNote {
  const PeakNote({required this.months, required this.causes, required this.allYearly});

  final List<LocalDate> months;

  /// Subscriptions billed less than monthly with a period in a peak month.
  final List<Subscription> causes;

  /// Every cause is billed yearly ("the yearly Canva and Google One renewals").
  final bool allYearly;
}

/// Insights maths on top of [SpendingCalculator]. Pure; amounts in the Primary currency.
class InsightsStats {
  const InsightsStats(this.calc);

  final SpendingCalculator calc;

  /// Months of [range] seen from [today]: this month · the 12 months ending this month ·
  /// January–December of this year (future months hold expected periods).
  static RangeMonths monthsOf(InsightsRange range, LocalDate today) {
    final m = today.firstOfMonth;
    return switch (range) {
      InsightsRange.thisMonth => RangeMonths(m, m),
      InsightsRange.last12Months => RangeMonths(m.addMonths(-11), m),
      InsightsRange.thisYear => RangeMonths(LocalDate(today.year, 1, 1), LocalDate(today.year, 12, 1)),
    };
  }

  double _paid(Iterable<ConfirmedPeriod> periods, RangeMonths span) =>
      span.months.map((m) => calc.actualInMonth(periods, m)).sum;

  double _expected(Iterable<Subscription> subs, RangeMonths span) =>
      span.months.map((m) => calc.projectedInMonth(subs, m)).sum;

  RangeTotals totals(
    Iterable<Subscription> subs,
    Iterable<ConfirmedPeriod> periods,
    InsightsRange range,
    LocalDate today,
  ) {
    final span = monthsOf(range, today);
    final prev = span.previous;
    return RangeTotals(
      paid: _paid(periods, span),
      expected: _expected(subs, span),
      previousTotal: _paid(periods, prev) + _expected(subs, prev),
    );
  }

  /// Bars for the chart: the 12 months of the range (This month shows the 12 months ending
  /// with it, for context).
  List<MonthSpending> chart(
    Iterable<Subscription> subs,
    Iterable<ConfirmedPeriod> periods,
    InsightsRange range,
    LocalDate today,
  ) {
    final last = range == InsightsRange.thisYear ? LocalDate(today.year, 12, 1) : today.firstOfMonth;
    return calc.monthlySeries(subs, periods, last);
  }

  /// Donut slices of Active Monthly cost. Categories without their own chart slot
  /// ([hasOwnSlot] false) fold into one [SubscriptionCategory.other] slice, always listed last;
  /// the rest are largest first.
  List<CategorySlice> categories(
    Iterable<Subscription> subs,
    LocalDate today, {
    required bool Function(SubscriptionCategory) hasOwnSlot,
  }) {
    final groups = <SubscriptionCategory, List<(Subscription, double)>>{};
    for (final s in subs) {
      if (BillingRules.effectiveStatus(s, today) != SubscriptionStatus.active) continue;
      final cost = calc.monthlyCost(s);
      if (cost == null || cost <= 0) continue;
      final key = hasOwnSlot(s.category) ? s.category : SubscriptionCategory.other;
      groups.putIfAbsent(key, () => []).add((s, cost));
    }
    final total = groups.values.expand((g) => g).map((e) => e.$2).sum;
    final slices = [
      for (final MapEntry(:key, :value) in groups.entries)
        CategorySlice(
          category: key,
          monthly: value.map((e) => e.$2).sum,
          share: total == 0 ? 0 : value.map((e) => e.$2).sum / total,
          subscriptions: value.sorted((a, b) => b.$2.compareTo(a.$2)),
        ),
    ];
    return slices.sorted((a, b) {
      final ao = a.category == SubscriptionCategory.other, bo = b.category == SubscriptionCategory.other;
      if (ao != bo) return ao ? 1 : -1;
      return b.monthly.compareTo(a.monthly);
    });
  }

  /// Music / Video categories where the user pays for two or more Active subscriptions.
  List<OverlapHint> overlaps(Iterable<Subscription> subs, LocalDate today) {
    const watched = [SubscriptionCategory.video, SubscriptionCategory.music];
    return [
      for (final cat in watched)
        if (subs
                .where((s) => s.category == cat && BillingRules.effectiveStatus(s, today) == SubscriptionStatus.active)
                .sorted((a, b) => (calc.monthlyCost(b) ?? 0).compareTo(calc.monthlyCost(a) ?? 0))
                .toList()
            case final list when list.length >= 2)
          OverlapHint(category: cat, subscriptions: list, monthly: list.map((s) => calc.monthlyCost(s) ?? 0).sum),
    ];
  }

  /// Up to two months whose total (paid + expected) is ≥ 1.5× the median of the non-empty
  /// months, with the less-than-monthly plans that fall in them. `null` when nothing stands out.
  PeakNote? peaks(Iterable<Subscription> subs, Iterable<ConfirmedPeriod> periods, List<MonthSpending> series) {
    final totals = series.map((m) => m.actual + m.projected).where((v) => v > 0).sorted((a, b) => a.compareTo(b));
    if (totals.length < 3) return null;
    final mid = totals.length ~/ 2;
    final median = totals.length.isOdd ? totals[mid] : (totals[mid - 1] + totals[mid]) / 2;
    final peakMonths = series
        .where((m) => m.actual + m.projected >= median * 1.5)
        .sorted((a, b) => (b.actual + b.projected).compareTo(a.actual + a.projected))
        .take(2)
        .map((m) => m.month)
        .sorted((a, b) => a.compareTo(b));
    if (peakMonths.isEmpty) return null;

    bool inPeak(LocalDate d) => peakMonths.any((m) => m.year == d.year && m.month == d.month);
    final byId = {for (final s in subs) s.id: s};
    final causes = <Subscription>[];
    void add(Subscription? s) {
      if (s != null && s.cycle.periodsPerMonth < 1 && !causes.any((c) => c.id == s.id)) causes.add(s);
    }

    for (final p in periods) {
      if (p.isPayment && inPeak(p.dueDate)) add(byId[p.subscriptionId]);
    }
    for (final m in peakMonths) {
      for (final s in subs) {
        if (BillingRules.dueDatesBetween(s, m, m.addMonths(1).addDays(-1)).isNotEmpty) add(s);
      }
    }
    causes.sort((a, b) => (calc.periodCost(b) ?? 0).compareTo(calc.periodCost(a) ?? 0));
    final shown = causes.take(2).toList();
    return PeakNote(
      months: peakMonths,
      causes: shown,
      allYearly: shown.isNotEmpty && shown.every((s) => s.cycle == const BillingCycle.yearly()),
    );
  }

  /// Cancelled subscriptions (Savings card), most expensive first.
  List<Subscription> cancelled(Iterable<Subscription> subs, LocalDate today) => subs
      .where((s) => BillingRules.effectiveStatus(s, today) == SubscriptionStatus.cancelled)
      .sorted((a, b) => (calc.yearlyCost(b) ?? 0).compareTo(calc.yearlyCost(a) ?? 0));
}
