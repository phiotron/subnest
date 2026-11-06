import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import '../../domain/stats/insights_stats.dart';
import 'widgets/category_donut.dart';
import 'widgets/category_sheet.dart';
import 'widgets/insights_cards.dart';
import 'widgets/insights_format.dart';
import 'widgets/month_bar_chart.dart';

/// S9 Insights (design png 44–47): range picker, total (Paid + Expected) summary with the change
/// against the span before (only when the history covers it), 12-month bars, donut by category (tap → [CategorySheet]),
/// Most expensive, Savings and a light Music/Video overlap hint. Empty state when there are no
/// subscriptions. Maths: [SpendingCalculator] + [InsightsStats] (lib/domain/stats).
class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key, this.initialRange = InsightsRange.last12Months});

  final InsightsRange initialRange;

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  late InsightsRange _range = widget.initialRange;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final subsAsync = ref.watch(subscriptionsProvider);
    final subs = subsAsync.value;
    final periods = ref.watch(periodsProvider).value ?? const <ConfirmedPeriod>[];
    final today = ref.watch(todayProvider);
    final calc = ref.watch(spendingCalculatorProvider);
    final summary = ref.watch(spendingSummaryProvider);
    final primary = calc.primaryCurrency;

    final children = <Widget>[
      LargeTitle(title: l.commonTabInsights),
      const SizedBox(height: AppSpace.s4),
      AppSegmentedControl<InsightsRange>(
        segments: [
          AppSegment(value: InsightsRange.thisMonth, label: l.insightsRangeMonth),
          AppSegment(value: InsightsRange.last12Months, label: l.insightsRange12),
          AppSegment(value: InsightsRange.thisYear, label: l.insightsRangeYear),
        ],
        selected: _range,
        onChanged: (r) => setState(() => _range = r),
      ),
      const SizedBox(height: AppSpace.s4),
    ];

    if (subs == null) {
      children.add(
        const Padding(
          padding: EdgeInsets.all(AppSpace.s8),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
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
      children.addAll(_content(context, subs, periods, today, calc, summary, primary));
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

  List<Widget> _content(
    BuildContext context,
    List<Subscription> subs,
    List<ConfirmedPeriod> periods,
    LocalDate today,
    SpendingCalculator calc,
    SpendingSummary? summary,
    String primary,
  ) {
    final l = context.l10n;
    final c = context.colors;
    final stats = InsightsStats(calc);
    bool foreign(String cur) => cur.toUpperCase() != primary.toUpperCase();
    final approx = subs.any((s) => foreign(s.currency)) || periods.any((p) => foreign(p.currency));

    final totals = stats.totals(subs, periods, _range, today);
    final series = stats.chart(subs, periods, _range, today);
    final peaks = stats.peaks(subs, periods, series, today);
    final slices = stats.categories(subs, today, hasOwnSlot: AppChartColors.hasSlot);
    final top = calc.top(subs, today);
    final cancelled = stats.cancelled(subs, today);
    final overlaps = stats.overlaps(subs, today);

    // One sentence for peak months already gone, one for those still ahead (hatched bars).
    String sentence(PeakNote p) {
      final months = l.monthList(p.months);
      final names = l.joinNames([for (final s in p.causes) s.name]);
      return switch ((p.causes.isEmpty, p.allYearly, p.expected)) {
        (true, _, false) => l.insightsPeakPlain(months),
        (true, _, true) => l.insightsPeakPlainAhead(months),
        (false, true, false) => l.insightsPeakYearly(months, names),
        (false, true, true) => l.insightsPeakYearlyAhead(months, names),
        (false, false, false) => l.insightsPeak(months, names),
        (false, false, true) => l.insightsPeakAhead(months, names),
      };
    }

    final peakText = peaks.isEmpty ? null : peaks.map(sentence).join(' ');

    void openSub(Subscription s) => context.push(AppRoutes.subscriptionDetail(s.id));

    return [
      InsightsSummaryCard(range: _range, totals: totals, currency: primary, approx: approx),
      const SizedBox(height: AppSpace.s3),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InsightsCardHeader(title: l.insightsByMonth, hint: l.insightsTapBar),
            MonthBarChart(series: series, current: today.firstOfMonth, currency: primary, approx: approx),
            if (peakText != null) ...[
              const SizedBox(height: AppSpace.s2),
              Text(peakText, style: AppType.meta.copyWith(color: c.inkMuted)),
            ],
          ],
        ),
      ),
      if (slices.isNotEmpty) ...[
        const SizedBox(height: AppSpace.s3),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InsightsCardHeader(title: l.insightsByCategory, hint: l.insightsMonthlyActive),
              CategoryDonut(
                slices: slices,
                currency: primary,
                approx: approx,
                onOpen: (s) => showCategorySheet(context, slice: s, today: today, currency: primary, approx: approx),
              ),
              if (InsightsStats.hasLongCycles(slices)) ...[
                const SizedBox(height: AppSpace.s2),
                Text(l.insightsCategoryNote, style: AppType.meta.copyWith(color: c.inkMuted)),
              ],
            ],
          ),
        ),
      ],
      if (top.isNotEmpty) ...[
        const SizedBox(height: AppSpace.s3),
        TopExpensiveCard(top: top, calc: calc, onOpen: openSub),
      ],
      if (summary != null && summary.savingsYearly > 0) ...[
        const SizedBox(height: AppSpace.s3),
        SavingsCard(
          yearly: summary.savingsYearly,
          cancelled: cancelled,
          currency: primary,
          approx: cancelled.any((s) => foreign(s.currency)),
        ),
      ],
      for (final o in overlaps) ...[
        const SizedBox(height: AppSpace.s3),
        OverlapHintCard(hint: o, currency: primary, approx: o.subscriptions.any((s) => foreign(s.currency))),
      ],
    ];
  }
}
