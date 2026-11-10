import '../billing_rules.dart';
import '../labels.dart';
import '../local_date.dart';
import '../money.dart';
import '../price_history.dart';
import '../spending.dart';
import '../subscription.dart';

/// One expected charge on a real Due date.
class ForecastItem {
  const ForecastItem(this.subscription, this.date, this.amountMinor, this.currency, {this.rateMissing = false});
  final Subscription subscription;
  final LocalDate date;

  /// My share as a Converted amount in the Primary currency, minor units (0 when the rate is unknown).
  final int amountMinor;

  /// Primary currency.
  final String currency;

  /// The subscription's currency has no rate to the Primary currency ([amountMinor] is 0).
  final bool rateMissing;

  /// Due on or before [today] and not confirmed yet (Awaiting confirmation).
  bool isAwaiting(LocalDate today) => !date.isAfter(today);

  double get amount => toMajorUnits(amountMinor, currency);
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
  const WeekStrip(this.start, this.days, this.totalMinor, this.currency);
  final LocalDate start;

  /// Exactly 7 entries, `days[i]` = items due on `start + i`.
  final List<List<ForecastItem>> days;

  /// Sum of the items' amounts (minor units of [currency]).
  final int totalMinor;
  final String currency;

  double get total => toMajorUnits(totalMinor, currency);

  bool hasDueOn(int i) => days[i].isNotEmpty;
}

/// Budget usage (glossary: Budget) against Monthly cost of Active subscriptions.
class BudgetUsage {
  const BudgetUsage(this.budget, this.spent, this.limit);
  final Budget budget;

  /// Monthly cost in the Primary currency (major units; a sum of Converted amounts).
  final double spent;

  /// Budget amount in the Primary currency (major units); `null` when its currency cannot be converted.
  final double? limit;

  /// 0..∞ (1.0 = 100 %); `null` without a limit.
  double? get ratio => (limit == null || limit! <= 0) ? null : spent / limit!;
  bool get isOver => ratio != null && ratio! > 1;
}

/// Forecast, cost rates, week strip, budgets and "drop Not worth" savings. Pure; Primary currency.
class ForecastCalculator {
  const ForecastCalculator(this.calc, {this.history = PriceHistory.empty});
  final SpendingCalculator calc;

  /// Prices each period at the price in effect on its Due date (empty = current price).
  final PriceHistory history;

  /// My share of one period of [s] due on [date] (price in effect then), converted; `null` when the
  /// rate is unknown.
  int? periodCostAtMinor(Subscription s, LocalDate date) {
    final p = history.myShareAt(s, date);
    return calc.rates.convertMinor(p.priceMinor, p.currency, calc.primaryCurrency);
  }

  /// Expected charges with Due date in [[from], [to]] (pending ones included when ≥ [from]),
  /// Paused/Cancelled excluded, oldest first. Pass a [from] far in the past to include every period
  /// still awaiting confirmation.
  List<ForecastItem> items(Iterable<Subscription> subs, LocalDate from, LocalDate to) {
    final out = <ForecastItem>[];
    for (final s in subs) {
      for (final d in BillingRules.dueDatesBetween(s, from, to)) {
        final cost = periodCostAtMinor(s, d);
        out.add(ForecastItem(s, d, cost ?? 0, calc.primaryCurrency, rateMissing: cost == null));
      }
    }
    out.sort((a, b) => a.date.compareTo(b.date));
    return out;
  }

  static int _sumMinor(Iterable<ForecastItem> items) => items.fold(0, (a, i) => a + i.amountMinor);

  /// Total due in the next [days] days starting [today] (default 30, today included), minor units.
  int nextDaysMinor(Iterable<Subscription> subs, LocalDate today, {int days = 30}) =>
      _sumMinor(items(subs, today, today.addDays(days - 1)));

  /// Total due in the next [days] days starting [today] (default 30, today included).
  double nextDays(Iterable<Subscription> subs, LocalDate today, {int days = 30}) =>
      toMajorUnits(nextDaysMinor(subs, today, days: days), calc.primaryCurrency);

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
          return (m, toMajorUnits(_sumMinor(items(subs, from, to)), calc.primaryCurrency));
        }(),
    ];
  }

  /// Cost of Active subscriptions per day / week / month / year.
  CostRates rates(Iterable<Subscription> subs, LocalDate today) => CostRates(calc.summary(subs, today).monthly);

  WeekStrip week(Iterable<Subscription> subs, LocalDate start) {
    final list = items(subs, start, start.addDays(6));
    final days = List.generate(7, (_) => <ForecastItem>[]);
    var total = 0;
    for (final it in list) {
      days[start.daysUntil(it.date)].add(it);
      total += it.amountMinor;
    }
    return WeekStrip(start, days, total, calc.primaryCurrency);
  }

  /// Usage of each budget. A category budget counts Active subscriptions of that category; the total
  /// budget counts all Active subscriptions.
  List<BudgetUsage> budgets(Iterable<Budget> budgets, Iterable<Subscription> subs, LocalDate today) {
    final primary = calc.primaryCurrency;
    final byCat = {for (final e in calc.byCategoryIdMinor(subs, today)) e.key: e.value};
    final total = calc.summary(subs, today).monthlyMinor;
    return [
      for (final b in budgets)
        () {
          final limit = calc.rates.convertMinor(b.amountMinor, b.currency, primary);
          return BudgetUsage(
            b,
            toMajorUnits(b.isTotal ? total : (byCat[b.categoryId] ?? 0), primary),
            limit == null ? null : toMajorUnits(limit, primary),
          );
        }(),
    ];
  }

  /// Yearly savings if every Trial/Active subscription rated Not worth were dropped.
  double notWorthSavingsYearly(Iterable<Subscription> subs, LocalDate today) {
    var sum = 0;
    for (final s in subs) {
      if (s.worthIt != WorthIt.notWorth) continue;
      if (!BillingRules.hasSchedule(BillingRules.statusForTotals(s, today))) continue;
      sum += calc.yearlyCostMinor(s) ?? 0;
    }
    return toMajorUnits(sum, calc.primaryCurrency);
  }
}
