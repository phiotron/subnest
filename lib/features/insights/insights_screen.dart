import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../domain/stats/insights_stats.dart';
import 'category_month_screen.dart';
import 'forecast_list_screen.dart';
import 'widgets/category_donut.dart';
import 'widgets/insights_cards.dart';
import 'widgets/insights_cost_card.dart';
import 'widgets/insights_format.dart';
import 'widgets/month_bars.dart';
import 'widgets/stats_parts.dart';
import 'widgets/stats_picker.dart';

/// S9 Insights (mockup v14 074–086, product.md §4.9): Month | Year + `‹ November 2026 ›`
/// ([selectedStatsMonthProvider], also set by Overview's bars) — every card below follows the
/// selected month or year: cost card (Month spend, change, ≈ per day, Paid / Still to pay),
/// 12 bars (tap = select), by category (tap → [CategoryMonthScreen]), most expensive; then price
/// rises, next 12 months, coming up (→ [ForecastListScreen]), budgets, savings and a light hint.
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key, this.initialYear = false});

  /// Opens in Year mode (tests / deep links); the tab opens in Month mode.
  final bool initialYear;

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  late bool _year = widget.initialYear;

  SelectedStatsMonthNotifier get _month => ref.read(selectedStatsMonthProvider.notifier);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final today = ref.watch(todayProvider);
    final subs = ref.watch(subscriptionsProvider).value;
    final month = ref.watch(selectedStatsMonthProvider);

    final children = <Widget>[
      LargeTitle(title: l.commonTabInsights),
      const SizedBox(height: AppSpace.s2),
      StatsPicker(
        year: _year,
        title: _year ? '${month.year}' : l.statsMonthYear(month),
        projected: _year ? month.year > today.year : month.isAfter(today.firstOfMonth),
        onMode: (y) => setState(() => _year = y),
        onPrevious: () => _year ? _month.select(month.addMonths(-12)) : _month.previous(),
        onNext: () => _year ? _month.select(month.addMonths(12)) : _month.next(),
      ),
      const SizedBox(height: AppSpace.s2),
    ];

    if (subs == null) {
      children.add(_loading);
    } else if (subs.isEmpty) {
      children.add(
        EmptyState(
          art: const NestArt(kind: NestArtKind.chart, width: 180),
          title: l.insightsEmptyTitle,
          body: l.insightsEmptyBody,
          actionLabel: l.insightsEmptyAction,
          onAction: () => context.push(AppRoutes.catalog),
        ),
      );
    } else {
      children.addAll(_content(context, subs, month, today));
    }

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
          children: children,
        ),
      ),
    );
  }

  static const _loading = Padding(
    padding: EdgeInsets.all(AppSpace.s8),
    child: Center(child: CircularProgressIndicator()),
  );

  void _open(Subscription s) => context.push(AppRoutes.subscriptionDetail(s.id));

  void _openList(YearForecast f) =>
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ForecastListScreen(forecast: f)));

  List<Widget> _content(BuildContext context, List<Subscription> subs, LocalDate month, LocalDate today) {
    final l = context.l10n;
    final c = context.colors;
    final calc = ref.watch(spendingCalculatorProvider);
    final cur = calc.primaryCurrency;
    final categories = ref.watch(categoryByIdProvider);
    final year = month.year;

    // ---- the selected period ----
    final int totalMinor, count, perMinor, paidMinor, dueMinor;
    final int? changeMinor;
    final List<SpendLine> lines;
    final List<MapEntry<String, int>> byCategory;
    final List<MonthSpend> bars;
    final Set<String> missing;
    final bool past;
    if (_year) {
      final ys = ref.watch(yearSpendProvider(year));
      if (ys == null) return [_loading];
      final flows = [for (var m = 1; m <= 12; m++) ref.watch(monthCashFlowProvider(LocalDate(year, m, 1)))];
      totalMinor = ys.totalMinor;
      count = ys.count;
      perMinor = (ys.totalMinor / 12).round();
      changeMinor = (ys.previousTotalMinor ?? 0) > 0 ? ys.changeMinor : null;
      lines = ys.lines;
      byCategory = ys.byCategoryIdMinor;
      bars = ys.months;
      paidMinor = flows.fold(0, (a, f) => a + (f?.paidMinor ?? 0));
      dueMinor = flows.fold(0, (a, f) => a + (f?.remainingMinor ?? 0));
      missing = {...ys.missingRates, for (final f in flows) ...?f?.missingRates};
      past = false;
    } else {
      final spend = ref.watch(monthSpendProvider(month));
      final cash = ref.watch(monthCashFlowProvider(month));
      final series = ref.watch(monthSpendSeriesProvider((LocalDate(year, 12, 1), 12)));
      if (spend == null || series == null) return [_loading];
      past = month.isBefore(today.firstOfMonth);
      totalMinor = spend.totalMinor;
      count = spend.count;
      perMinor = spend.dailyAverageMinor;
      changeMinor = (spend.previousTotalMinor ?? 0) > 0 ? spend.changeMinor : null;
      lines = spend.lines;
      byCategory = spend.byCategoryIdMinor;
      bars = series;
      paidMinor = cash?.paidMinor ?? 0;
      dueMinor = past ? _skippedMinor(calc, month) + (cash?.remainingMinor ?? 0) : (cash?.remainingMinor ?? 0);
      missing = {...spend.missingRates, ...?cash?.missingRates};
    }
    final paying = lines.where((x) => x.amountMinor > 0).toList();
    final periodLabel = _year ? '$year' : l.statsMonthYear(month);
    final perAmount = l.minor(perMinor, cur, approx: true);
    final prev = month.addMonths(-1);

    // ---- cards not tied to the period ----
    final rises = ref.watch(priceIncreasesProvider);
    final forecast = ref.watch(yearForecastProvider);
    final budgets = ref.watch(budgetsProvider).value ?? const <Budget>[];
    final summary = ref.watch(spendingSummaryProvider);

    final slices = [
      for (final e in byCategory)
        if (e.value > 0)
          DonutSlice(
            id: e.key,
            label: l.categoryOf(e.key, categories),
            color: statsCategoryColor(c, e.key, categories),
            minor: e.value,
          ),
    ];

    final budgetLines = <BudgetLine>[
      for (final b in budgets)
        if (b.categoryId != null)
          if (calc.toPrimaryMinor(Money(b.amountMinor, b.currency)) case final limit?)
            BudgetLine(
              categoryId: b.categoryId!,
              label: l.categoryOf(b.categoryId!, categories),
              color: statsCategoryColor(c, b.categoryId!, categories),
              spentMinor: byCategory.where((e) => e.key == b.categoryId).fold(0, (a, e) => a + e.value),
              limitMinor: _year ? limit * 12 : limit,
            ),
    ];

    final notWorth = [
      for (final s in subs)
        if (s.worthIt == WorthIt.notWorth && BillingRules.hasSchedule(BillingRules.statusForTotals(s, today))) s,
    ];
    final notWorthMinor = notWorth.fold(0, (a, s) => a + (calc.yearlyCostMinor(s) ?? 0));
    final cancelled = subs.where((s) => BillingRules.statusForTotals(s, today) == SubscriptionStatus.cancelled).length;
    final savings = summary?.savingsYearlyMinor ?? 0;
    final overlaps = InsightsStats(calc).overlaps(subs, today);

    return [
      InsightsCostCard(
        title: _year ? l.insightsCostOfYear('$year') : l.costOfMonth(month),
        totalMinor: totalMinor,
        currency: cur,
        count: count,
        perText: _year ? l.insightsPerMonth(perAmount) : l.insightsPerDay(perAmount),
        perAmount: perAmount.replaceFirst('≈ ', ''),
        paidMinor: paidMinor,
        dueMinor: dueMinor,
        past: past,
        onInfo: () => showStatsInfoSheet(context),
        changeMinor: changeMinor,
        vs: _year ? l.insightsVsYear('${year - 1}') : l.vsMonth(prev),
        same: _year ? l.insightsSameYear('${year - 1}') : l.sameMonth(prev),
        emptyText: totalMinor == 0 ? (_year ? l.insightsNothingInYear('$year') : l.nothingInMonth(month)) : null,
        missingRates: missing,
      ),
      MonthBarsCard(
        months: bars,
        selected: _year ? null : month,
        currentMonth: today.firstOfMonth,
        title: _year ? l.insightsBarsYear('$year') : l.insightsBars12,
        onSelect: (m) {
          setState(() => _year = false);
          _month.select(m);
        },
      ),
      if (slices.isNotEmpty)
        StatsCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StatsCardHeader(title: l.insightsByCategory, trailing: StatsHint(periodLabel)),
              CategoryDonut(
                slices: slices,
                currency: cur,
                onOpen: (s) => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => CategoryMonthScreen(
                      categoryId: s.id,
                      categoryLabel: s.label,
                      color: s.color,
                      period: _year ? '$year' : l.statsMonthTitle(month),
                      periodInline: _year ? '$year' : l.statsMonthInline(month),
                      lines: [
                        for (final x in paying)
                          if (x.subscription.categoryId == s.id) x,
                      ],
                      periodTotalMinor: totalMinor,
                      currency: cur,
                      periodStart: _year ? LocalDate(year, 1, 1) : month,
                      periodEnd: _year ? LocalDate(year, 12, 31) : lastOfMonth(month),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      if (paying.isNotEmpty) TopExpensiveCard(lines: paying, currency: cur, year: _year, onOpen: _open),
      if (rises != null) PriceRisesCard(report: rises, onOpen: _open),
      if (forecast != null) ...[
        NextYearCard(forecast: forecast, onOpen: _open, onList: () => _openList(forecast)),
        ComingUpCard(forecast: forecast, onList: () => _openList(forecast)),
      ],
      if (budgetLines.isNotEmpty)
        BudgetsCard(lines: budgetLines, currency: cur, onEdit: () => context.push(AppRoutes.settingsBudgets)),
      if (savings > 0 || (notWorth.isNotEmpty && notWorthMinor > 0))
        SavingsCard(
          savingsMinor: savings,
          cancelledCount: cancelled,
          notWorth: notWorth,
          notWorthMinor: notWorthMinor,
          currency: cur,
        ),
      for (final o in overlaps)
        OverlapHintCard(
          text: o.category == SubscriptionCategory.music
              ? l.insightsOverlapMusic(o.subscriptions.length)
              : l.insightsOverlapVideo(o.subscriptions.length),
        ),
    ];
  }

  /// Skipped periods of a past month ("Not paid"), in the Primary currency.
  int _skippedMinor(SpendingCalculator calc, LocalDate month) {
    final periods = ref.watch(periodsProvider).value ?? const <ConfirmedPeriod>[];
    final last = lastOfMonth(month);
    return periods
        .where((p) => p.isSkipped && !p.dueDate.isBefore(month) && !p.dueDate.isAfter(last))
        .fold(0, (a, p) => a + (calc.toPrimaryMinor(p.amount) ?? 0));
  }
}
