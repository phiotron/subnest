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

/// Summary card numbers for a range: the total (Payments made + periods still expected), its
/// split, and the same total for the equal span before — only when the history covers it.
class RangeTotals {
  const RangeTotals({required this.paid, required this.expected, this.previousTotal});

  /// Sum of Payments with a due date in the range.
  final double paid;

  /// Periods in the range not confirmed yet (awaiting + future) at the current My share.
  final double expected;

  /// What the card shows in big: [paid] + [expected] (= the bars of the range).
  double get total => paid + expected;

  /// [total] of the span right before (same length), or `null` when the history (confirmed
  /// periods) does not reach back to its first month — comparing with a span the user did not
  /// track gives "+3240%" (2026-11-06, phone).
  final double? previousTotal;

  /// The span before is fully tracked, so a change can be stated.
  bool get comparable => previousTotal != null;

  /// Whole-percent change of [total] against [previousTotal]; `null` when not [comparable] or
  /// nothing was spent before.
  int? get changePercent {
    final before = previousTotal;
    if (before == null || before <= 0) return null;
    return ((total - before) / before * 100).round();
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
/// Months that already happened and months still ahead get separate notes ("jumped" vs
/// "will jump").
class PeakNote {
  const PeakNote({required this.months, required this.causes, required this.allYearly, required this.expected});

  /// Oldest first.
  final List<LocalDate> months;

  /// Subscriptions billed less than monthly with a period in a peak month, in the order of
  /// [months] (so "February and March … Canva and Google One" pairs up).
  final List<Subscription> causes;

  /// Every cause is billed yearly ("the yearly Canva and Google One renewals").
  final bool allYearly;

  /// The months are still ahead (mostly expected periods, drawn hatched): "will jump".
  final bool expected;
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
    final start = historyStart(periods);
    final covered = start != null && !start.isAfter(prev.first);
    return RangeTotals(
      paid: _paid(periods, span),
      expected: _expected(subs, span),
      previousTotal: covered ? _paid(periods, prev) + _expected(subs, prev) : null,
    );
  }

  /// First month of the user's history: the month of the oldest confirmed period (Payment or
  /// Skipped). `null` when nothing was confirmed yet.
  static LocalDate? historyStart(Iterable<ConfirmedPeriod> periods) =>
      periods.map((p) => p.dueDate.firstOfMonth).minOrNull;

  /// Some slice holds a plan not billed every month (yearly, weekly…), so its Monthly cost is
  /// a spread share, not what is paid in any given month.
  static bool hasLongCycles(Iterable<CategorySlice> slices) =>
      slices.expand((s) => s.subscriptions).any((e) => e.$1.cycle != const BillingCycle.monthly());

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
  /// months, with the less-than-monthly plans billed in them. One note for months already gone
  /// and one for months still ahead (from [today]'s month on, mostly expected); empty when
  /// nothing stands out.
  List<PeakNote> peaks(
    Iterable<Subscription> subs,
    Iterable<ConfirmedPeriod> periods,
    List<MonthSpending> series,
    LocalDate today,
  ) {
    final totals = series.map((m) => m.actual + m.projected).where((v) => v > 0).sorted((a, b) => a.compareTo(b));
    if (totals.length < 3) return const [];
    final mid = totals.length ~/ 2;
    final median = totals.length.isOdd ? totals[mid] : (totals[mid - 1] + totals[mid]) / 2;
    final picked = series
        .where((m) => m.actual + m.projected >= median * 1.5)
        .sorted((a, b) => (b.actual + b.projected).compareTo(a.actual + a.projected))
        .take(2)
        .sorted((a, b) => a.month.compareTo(b.month));
    if (picked.isEmpty) return const [];

    final current = today.firstOfMonth;
    bool ahead(MonthSpending m) => !m.month.isBefore(current) && m.projected > m.actual;
    final byId = {for (final s in subs) s.id: s};

    // Less-than-monthly plans billed in [month] (Payments or periods still expected), dearest first.
    List<Subscription> causesIn(LocalDate month) {
      final found = <Subscription>[];
      void add(Subscription? s) {
        if (s != null && s.cycle.periodsPerMonth < 1 && !found.any((c) => c.id == s.id)) found.add(s);
      }

      for (final p in periods) {
        if (p.isPayment && p.dueDate.firstOfMonth == month) add(byId[p.subscriptionId]);
      }
      for (final s in subs) {
        if (BillingRules.dueDatesBetween(s, month, month.addMonths(1).addDays(-1)).isNotEmpty) add(s);
      }
      return found.sorted((a, b) => (calc.periodCost(b) ?? 0).compareTo(calc.periodCost(a) ?? 0));
    }

    PeakNote note(List<MonthSpending> months, {required bool expected}) {
      final perMonth = [for (final m in months) causesIn(m.month)];
      // The dearest cause of each month first, then the rest; at most two, in month order.
      final chosen = <Subscription>[];
      for (final list in [for (final l in perMonth) l.take(1), ...perMonth]) {
        for (final s in list) {
          if (chosen.length < 2 && !chosen.any((c) => c.id == s.id)) chosen.add(s);
        }
      }
      int firstMonth(Subscription s) => perMonth.indexWhere((l) => l.any((c) => c.id == s.id));
      final causes = [...chosen]..sort((a, b) => firstMonth(a).compareTo(firstMonth(b)));
      return PeakNote(
        months: [for (final m in months) m.month],
        causes: causes,
        allYearly: causes.isNotEmpty && causes.every((s) => s.cycle == const BillingCycle.yearly()),
        expected: expected,
      );
    }

    final gone = picked.where((m) => !ahead(m)).toList();
    final coming = picked.where(ahead).toList();
    return [
      if (gone.isNotEmpty) note(gone, expected: false),
      if (coming.isNotEmpty) note(coming, expected: true),
    ];
  }

  /// Cancelled subscriptions (Savings card), most expensive first.
  List<Subscription> cancelled(Iterable<Subscription> subs, LocalDate today) => subs
      .where((s) => BillingRules.effectiveStatus(s, today) == SubscriptionStatus.cancelled)
      .sorted((a, b) => (calc.yearlyCost(b) ?? 0).compareTo(calc.yearlyCost(a) ?? 0));
}
