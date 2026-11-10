import 'package:collection/collection.dart';

import '../billing_rules.dart';
import '../local_date.dart';
import '../price_history.dart';
import '../ratio.dart';
import '../spending.dart';
import '../subscription.dart';

/// One subscription whose price went up (glossary: Price increase).
class PriceIncrease {
  const PriceIncrease({
    required this.subscription,
    required this.before,
    required this.now,
    required this.oldMonthlyMinor,
    required this.newMonthlyMinor,
    required this.oldYearlyMinor,
    required this.newYearlyMinor,
    this.changedOn,
  });

  final Subscription subscription;

  /// Plan price at the start of the window (or when the subscription started, if later).
  final PlanPrice before;

  /// Current plan price.
  final PlanPrice now;

  /// Monthly / Yearly cost (My share, Primary currency, minor units) at [before] and [now], each
  /// converted with today's rates and rounded on its own.
  final int oldMonthlyMinor;
  final int newMonthlyMinor;
  final int oldYearlyMinor;
  final int newYearlyMinor;

  /// Effective date of the latest change in the window; `null` when the price changed without a record.
  final LocalDate? changedOn;

  int get monthlyDeltaMinor => newMonthlyMinor - oldMonthlyMinor;
  int get yearlyDeltaMinor => newYearlyMinor - oldYearlyMinor;
}

/// Insights card "Price increases": subscriptions costing more than [months] months ago. Only
/// increases are listed; the detail screen shows the full history (ups and downs).
class PriceIncreaseReport {
  const PriceIncreaseReport({required this.since, required this.currency, required this.items});

  /// Start of the window (today − [months] months).
  final LocalDate since;
  final String currency;

  /// Biggest monthly increase first.
  final List<PriceIncrease> items;

  /// "You pay X more each month than a year ago".
  int get monthlyDeltaMinor => items.fold(0, (a, i) => a + i.monthlyDeltaMinor);

  /// "… Y more each year".
  int get yearlyDeltaMinor => items.fold(0, (a, i) => a + i.yearlyDeltaMinor);

  PriceIncrease? get biggest => items.firstOrNull;

  bool get isEmpty => items.isEmpty;
}

/// Price increase maths. Pure; Primary currency.
class PriceIncreaseCalculator {
  const PriceIncreaseCalculator(this.calc, this.history);

  final SpendingCalculator calc;
  final PriceHistory history;

  int? _monthly(Subscription s, PlanPrice p, {bool yearly = false}) {
    final share = s.isShared ? (p.priceMinor / s.sharedWith).round() : p.priceMinor;
    final times = yearly ? s.cycle.periodsPerMonthRatio * Ratio.ints(12) : s.cycle.periodsPerMonthRatio;
    return calc.rates.convertMinor(share, p.currency, calc.primaryCurrency, times: times);
  }

  /// Subscriptions still being paid (Trial/Active by [BillingRules.statusForTotals]) whose current
  /// price costs more per month than the price [months] months ago (or at their start, if later).
  /// Prices in another currency are compared after conversion with today's rates; a missing rate
  /// leaves the subscription out.
  PriceIncreaseReport report(Iterable<Subscription> subs, LocalDate today, {int months = 12}) {
    final since = today.addMonths(-months);
    final items = <PriceIncrease>[];
    for (final s in subs) {
      final status = BillingRules.statusForTotals(s, today);
      if (status != SubscriptionStatus.active && status != SubscriptionStatus.trial) continue;
      final from = s.startDate.isAfter(since) ? s.startDate : since;
      final before = history.priceAt(s, from);
      final now = (priceMinor: s.priceMinor, currency: s.currency);
      if (before == now) continue;
      final oldM = _monthly(s, before), newM = _monthly(s, now);
      final oldY = _monthly(s, before, yearly: true), newY = _monthly(s, now, yearly: true);
      if (oldM == null || newM == null || oldY == null || newY == null) continue;
      if (newM <= oldM) continue;
      final changedOn = history.of(s.id).lastWhereOrNull((c) => c.effectiveFrom.isAfter(from))?.effectiveFrom;
      items.add(
        PriceIncrease(
          subscription: s,
          before: before,
          now: now,
          oldMonthlyMinor: oldM,
          newMonthlyMinor: newM,
          oldYearlyMinor: oldY,
          newYearlyMinor: newY,
          changedOn: changedOn,
        ),
      );
    }
    items.sort((a, b) {
      final d = b.monthlyDeltaMinor.compareTo(a.monthlyDeltaMinor);
      return d != 0 ? d : a.subscription.name.toLowerCase().compareTo(b.subscription.name.toLowerCase());
    });
    return PriceIncreaseReport(since: since, currency: calc.primaryCurrency, items: items);
  }

  /// Whether a price increase of [s] was noticed in the last [days] days (the ↑ on its row): a change
  /// up with [PriceChange.noticedOn] in [today − days, today]. A change of currency counts when the
  /// new price converts to more.
  bool recentlyIncreased(Subscription s, LocalDate today, {int days = 90}) {
    final from = today.addDays(-days);
    for (final c in history.of(s.id)) {
      final on = c.noticedOn;
      if (on.isBefore(from) || on.isAfter(today)) continue;
      final up =
          c.isIncrease ??
          (() {
            final o = calc.rates.convertMinor(c.oldPriceMinor, c.fromCurrency, calc.primaryCurrency);
            final n = calc.rates.convertMinor(c.newPriceMinor, c.currency, calc.primaryCurrency);
            return o != null && n != null && n > o;
          })();
      if (up) return true;
    }
    return false;
  }

  /// Ids of [subs] with [recentlyIncreased].
  Set<String> recentlyIncreasedIds(Iterable<Subscription> subs, LocalDate today, {int days = 90}) => {
    for (final s in subs)
      if (recentlyIncreased(s, today, days: days)) s.id,
  };
}
