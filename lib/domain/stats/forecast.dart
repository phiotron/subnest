import '../billing_rules.dart';
import '../labels.dart';
import '../local_date.dart';
import '../money.dart';
import '../spending.dart';
import '../subscription.dart';

/// One expected charge on a real Due date.
class ForecastItem {
  const ForecastItem(this.subscription, this.date, this.amount);
  final Subscription subscription;
  final LocalDate date;

  /// My share in the Primary currency (0 when the rate is unknown).
  final double amount;
}

/// Monthly cost expressed per day / week / month / year (product.md §10.4).
class CostRates {
  const CostRates(this.monthly);
  final double monthly;
  double get yearly => monthly * 12;
  double get daily => yearly / 365;
  double get weekly => yearly / 52;
}

/// "Due this week" card (product.md §10.2): 7 days from [start], items per day and the total.
class WeekStrip {
  const WeekStrip(this.start, this.days, this.total);
  final LocalDate start;

  /// Exactly 7 entries, `days[i]` = items due on `start + i`.
  final List<List<ForecastItem>> days;
  final double total;

  bool hasDueOn(int i) => days[i].isNotEmpty;
}

/// Budget usage (glossary: Budget) against Monthly cost of Active subscriptions.
class BudgetUsage {
  const BudgetUsage(this.budget, this.spent, this.limit);
  final Budget budget;

  /// Monthly cost in the Primary currency (major units).
  final double spent;

  /// Budget amount in the Primary currency (major units); `null` when its currency cannot be converted.
  final double? limit;

  /// 0..∞ (1.0 = 100 %); `null` without a limit.
  double? get ratio => (limit == null || limit! <= 0) ? null : spent / limit!;
  bool get isOver => ratio != null && ratio! > 1;
}

/// Forecast, cost rates, week strip, budgets and "drop Not worth" savings. Pure; Primary currency.
class ForecastCalculator {
  const ForecastCalculator(this.calc);
  final SpendingCalculator calc;

  /// Expected charges with Due date in [[from], [to]] (pending ones included when ≥ [from]),
  /// Paused/Cancelled excluded, oldest first.
  List<ForecastItem> items(Iterable<Subscription> subs, LocalDate from, LocalDate to) {
    final out = <ForecastItem>[];
    for (final s in subs) {
      final cost = calc.periodCost(s) ?? 0;
      for (final d in BillingRules.dueDatesBetween(s, from, to)) {
        out.add(ForecastItem(s, d, cost));
      }
    }
    out.sort((a, b) => a.date.compareTo(b.date));
    return out;
  }

  /// Total due in the next [days] days starting [today] (default 30, today included).
  double nextDays(Iterable<Subscription> subs, LocalDate today, {int days = 30}) =>
      items(subs, today, today.addDays(days - 1)).fold(0.0, (a, i) => a + i.amount);

  /// Next [count] calendar months starting with the month of [today] (the current month counts
  /// from today on). Returns (first day of month, total).
  List<(LocalDate, double)> nextMonths(Iterable<Subscription> subs, LocalDate today, {int count = 12}) {
    final first = today.firstOfMonth;
    return [
      for (var i = 0; i < count; i++)
        () {
          final m = first.addMonths(i);
          final from = i == 0 ? today : m;
          final to = m.addMonths(1).addDays(-1);
          return (m, items(subs, from, to).fold(0.0, (a, it) => a + it.amount));
        }(),
    ];
  }

  /// Cost of Active subscriptions per day / week / month / year.
  CostRates rates(Iterable<Subscription> subs, LocalDate today) => CostRates(calc.summary(subs, today).monthly);

  WeekStrip week(Iterable<Subscription> subs, LocalDate start) {
    final list = items(subs, start, start.addDays(6));
    final days = List.generate(7, (_) => <ForecastItem>[]);
    var total = 0.0;
    for (final it in list) {
      days[start.daysUntil(it.date)].add(it);
      total += it.amount;
    }
    return WeekStrip(start, days, total);
  }

  /// Usage of each budget. A category budget counts Active subscriptions of that category; the total
  /// budget counts all Active subscriptions.
  List<BudgetUsage> budgets(Iterable<Budget> budgets, Iterable<Subscription> subs, LocalDate today) {
    final byCat = {for (final e in calc.byCategoryId(subs, today)) e.key: e.value};
    final total = calc.summary(subs, today).monthly;
    return [
      for (final b in budgets)
        BudgetUsage(
          b,
          b.isTotal ? total : (byCat[b.categoryId] ?? 0),
          calc.rates.convert(toMajorUnits(b.amountMinor, b.currency), b.currency, calc.primaryCurrency),
        ),
    ];
  }

  /// Yearly savings if every Trial/Active subscription rated Not worth were dropped.
  double notWorthSavingsYearly(Iterable<Subscription> subs, LocalDate today) {
    var sum = 0.0;
    for (final s in subs) {
      if (s.worthIt != WorthIt.notWorth) continue;
      if (!BillingRules.hasSchedule(BillingRules.effectiveStatus(s, today))) continue;
      sum += calc.yearlyCost(s) ?? 0;
    }
    return sum;
  }
}
