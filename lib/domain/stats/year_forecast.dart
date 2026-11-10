import 'package:collection/collection.dart';

import '../confirmed_period.dart';
import '../local_date.dart';
import '../price_history.dart';
import '../spending.dart';
import '../subscription.dart';
import 'forecast.dart';
import 'month_stats.dart';

/// Expected charges between [start] and [end] (inclusive) — one bar of "Coming up".
class ForecastBucket {
  const ForecastBucket(this.start, this.end, this.items);

  final LocalDate start;
  final LocalDate end;

  /// Oldest first. The first bucket also holds periods still Awaiting confirmation.
  final List<ForecastItem> items;

  int get totalMinor => items.fold(0, (a, i) => a + i.amountMinor);
}

/// One subscription's part of the 12-months-ahead vs 12-months-back comparison.
class ForecastContributor {
  const ForecastContributor({
    required this.subscription,
    required this.nextMinor,
    required this.pastMinor,
    required this.isNew,
    required this.priceIncreaseMinor,
  });

  final Subscription subscription;

  /// Expected in the next 12 months (real Due dates; awaiting periods included).
  final int nextMinor;

  /// Paid in the last 12 months (Payments).
  final int pastMinor;

  /// Started (or its Trial ended) within the last 12 months.
  final bool isNew;

  /// Part of [deltaMinor] due to a higher price than 12 months ago (≥ 0; 0 for new subscriptions).
  final int priceIncreaseMinor;

  int get deltaMinor => nextMinor - pastMinor;

  /// Part of [deltaMinor] explained by neither a new subscription nor a price increase (timing of
  /// yearly renewals, cancellations, pauses, price drops, odd amounts…).
  int get otherMinor => isNew ? 0 : deltaMinor - priceIncreaseMinor;
}

/// Glossary: Forecast — card "Next 12 months": expected vs the last 12 months, the change split
/// into new subscriptions · price increases · other, the subscriptions behind it, and the "Coming
/// up" bars (13 weeks / 12 months) with their list.
class YearForecast {
  const YearForecast({
    required this.today,
    required this.currency,
    required this.contributors,
    required this.items,
    required this.weeks,
    required this.months,
    required this.historyCoversPast,
  });

  final LocalDate today;
  final String currency;

  /// Every subscription with something next or past, biggest [ForecastContributor.nextMinor] first.
  final List<ForecastContributor> contributors;

  /// Expected charges of the next 12 months (awaiting ones first), oldest first.
  final List<ForecastItem> items;

  /// 13 weeks from today (week 0 = today … today + 6, plus everything awaiting).
  final List<ForecastBucket> weeks;

  /// 12 calendar months from this month (month 0 = today → month end, plus everything awaiting).
  final List<ForecastBucket> months;

  /// The user's history (first confirmed period) reaches back to the start of the past window, so
  /// "vs the last 12 months" compares like with like.
  final bool historyCoversPast;

  int get nextMinor => contributors.fold(0, (a, c) => a + c.nextMinor);
  int get pastMinor => contributors.fold(0, (a, c) => a + c.pastMinor);
  int get changeMinor => nextMinor - pastMinor;

  /// Change due to subscriptions added in the last 12 months.
  int get newSubscriptionsMinor => contributors.where((c) => c.isNew).fold(0, (a, c) => a + c.deltaMinor);

  /// Change due to price increases of older subscriptions.
  int get priceIncreasesMinor => contributors.fold(0, (a, c) => a + c.priceIncreaseMinor);

  /// The rest of the change ([newSubscriptionsMinor] + [priceIncreasesMinor] + this = [changeMinor]).
  int get otherMinor => contributors.fold(0, (a, c) => a + c.otherMinor);

  /// The subscription that adds the most to the next 12 months.
  ForecastContributor? get top => contributors.firstWhereOrNull((c) => c.nextMinor > 0);

  Set<String> get missingRates => {
    for (final i in items)
      if (i.rateMissing) i.subscription.currency,
  };
}

/// Builds [YearForecast]. Pure; Primary currency; periods priced by Price history.
class YearForecastCalculator {
  const YearForecastCalculator(this.calc, {this.history = PriceHistory.empty});

  final SpendingCalculator calc;
  final PriceHistory history;

  static const LocalDate _epoch = LocalDate(1970, 1, 1);

  YearForecast build(
    Iterable<Subscription> subs,
    Iterable<ConfirmedPeriod> periods,
    LocalDate today, {
    int weekCount = 13,
    int monthCount = 12,
  }) {
    final forecast = ForecastCalculator(calc, history: history);
    final pastFrom = today.addMonths(-12).addDays(1);
    final nextTo = today.addMonths(12);
    final monthsEnd = lastOfMonth(today.firstOfMonth.addMonths(monthCount - 1));
    final weeksEnd = today.addDays(7 * weekCount - 1);
    final horizon = [nextTo, monthsEnd, weeksEnd].reduce((a, b) => a.isAfter(b) ? a : b);
    // Every unconfirmed period from the oldest awaiting one up to the horizon.
    final all = forecast.items(subs, _epoch, horizon);
    final next = all.where((i) => !i.date.isAfter(nextTo)).toList();

    // Past 12 months: Payments.
    final pastBySub = <String, int>{};
    for (final p in periods) {
      if (!p.isPayment || p.dueDate.isBefore(pastFrom) || p.dueDate.isAfter(today)) continue;
      final v = calc.toPrimaryMinor(p.amount) ?? 0;
      pastBySub.update(p.subscriptionId, (x) => x + v, ifAbsent: () => v);
    }
    final nextBySub = <String, List<ForecastItem>>{};
    for (final i in next) {
      nextBySub.putIfAbsent(i.subscription.id, () => []).add(i);
    }

    final contributors = <ForecastContributor>[];
    for (final s in subs) {
      final items = nextBySub[s.id] ?? const <ForecastItem>[];
      final nextMinor = items.fold(0, (a, i) => a + i.amountMinor);
      final pastMinor = pastBySub[s.id] ?? 0;
      if (nextMinor == 0 && pastMinor == 0) continue;
      final isNew = !MonthStatsCalculator.paidFrom(s).isBefore(pastFrom);
      var increase = 0;
      if (!isNew) {
        // Each expected period at its price vs at the price of 12 months ago.
        final old = history.myShareAt(s, pastFrom);
        final oldCost = calc.rates.convertMinor(old.priceMinor, old.currency, calc.primaryCurrency);
        if (oldCost != null) {
          for (final i in items) {
            if (!i.rateMissing) increase += i.amountMinor - oldCost;
          }
        }
        if (increase < 0) increase = 0;
      }
      contributors.add(
        ForecastContributor(
          subscription: s,
          nextMinor: nextMinor,
          pastMinor: pastMinor,
          isNew: isNew,
          priceIncreaseMinor: increase,
        ),
      );
    }
    contributors.sort((a, b) {
      final d = b.nextMinor.compareTo(a.nextMinor);
      return d != 0 ? d : b.pastMinor.compareTo(a.pastMinor);
    });

    List<ForecastBucket> buckets(List<(LocalDate, LocalDate)> ranges) => [
      for (final (i, (start, end)) in ranges.indexed)
        ForecastBucket(start, end, [
          for (final it in all)
            if ((i == 0 ? true : !it.date.isBefore(start)) && !it.date.isAfter(end)) it,
        ]),
    ];

    final weekRanges = [
      for (var i = 0; i < weekCount; i++) (today.addDays(7 * i), today.addDays(7 * i + 6)),
    ];
    final first = today.firstOfMonth;
    final monthRanges = [
      for (var i = 0; i < monthCount; i++)
        (i == 0 ? today : first.addMonths(i), lastOfMonth(first.addMonths(i))),
    ];

    final historyStart = periods.map((p) => p.dueDate).minOrNull;
    return YearForecast(
      today: today,
      currency: calc.primaryCurrency,
      contributors: contributors,
      items: next,
      weeks: buckets(weekRanges),
      months: buckets(monthRanges),
      historyCoversPast: historyStart != null && !historyStart.isAfter(pastFrom),
    );
  }
}
