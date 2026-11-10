import 'local_date.dart';
import 'ratio.dart';

/// Unit of a [BillingCycle].
enum CycleUnit { day, week, month, year }

/// Billing cycle: "every [every] [unit]" (e.g. every 1 month, every 28 days).
class BillingCycle {
  const BillingCycle(this.every, this.unit) : assert(every > 0);

  const BillingCycle.monthly() : this(1, CycleUnit.month);
  const BillingCycle.yearly() : this(1, CycleUnit.year);
  const BillingCycle.weekly() : this(1, CycleUnit.week);
  const BillingCycle.quarterly() : this(3, CycleUnit.month);

  final int every;
  final CycleUnit unit;

  /// Due date of the billing period with [index] (0-based) counted from [anchor].
  ///
  /// Always computed from the anchor (never from the previous due date) so that a
  /// subscription started on the 31st returns to the 31st after short months,
  /// and one started on Feb 29 returns to Feb 29 in leap years.
  LocalDate occurrence(LocalDate anchor, int index) {
    assert(index >= 0);
    switch (unit) {
      case CycleUnit.day:
        return anchor.addDays(every * index);
      case CycleUnit.week:
        return anchor.addDays(7 * every * index);
      case CycleUnit.month:
        return anchor.addMonths(every * index);
      case CycleUnit.year:
        return anchor.addMonths(12 * every * index);
    }
  }

  /// How many billing periods fit in one month (used for Monthly cost).
  /// Year ÷ 12, week × 52 ÷ 12, day × 365 ÷ 12.
  double get periodsPerMonth {
    switch (unit) {
      case CycleUnit.day:
        return 365 / 12 / every;
      case CycleUnit.week:
        return 52 / 12 / every;
      case CycleUnit.month:
        return 1 / every;
      case CycleUnit.year:
        return 1 / (12 * every);
    }
  }

  /// [periodsPerMonth] as an exact fraction, for money maths (Monthly cost is rounded once).
  Ratio get periodsPerMonthRatio => switch (unit) {
    CycleUnit.day => Ratio.ints(365, 12 * every),
    CycleUnit.week => Ratio.ints(52, 12 * every),
    CycleUnit.month => Ratio.ints(1, every),
    CycleUnit.year => Ratio.ints(1, 12 * every),
  };

  @override
  bool operator ==(Object other) => other is BillingCycle && other.every == every && other.unit == unit;

  @override
  int get hashCode => Object.hash(every, unit);

  @override
  String toString() => 'every $every ${unit.name}';
}
