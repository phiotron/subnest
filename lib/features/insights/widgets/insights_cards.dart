import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../../domain/stats/insights_stats.dart';
import 'insights_format.dart';
import 'month_bar_chart.dart';

/// Card heading: `title-sm` + muted hint on the right (wraps under on narrow / large text).
class InsightsCardHeader extends StatelessWidget {
  const InsightsCardHeader({super.key, required this.title, this.hint});

  final String title;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s3),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.end,
        spacing: AppSpace.s2,
        children: [
          Semantics(
            header: true,
            child: Text(title, style: AppType.titleSm.copyWith(color: c.ink)),
          ),
          if (hint != null) Text(hint!, style: AppType.meta.copyWith(color: c.inkMuted)),
        ],
      ),
    );
  }
}

/// Summary card: the range total (big) = Paid + Expected-not-yet-confirmed (= the bars of the
/// range), the change of that same total against the span before (or "not enough data" when the
/// history does not cover it), then the legend of the bar chart with the two parts.
class InsightsSummaryCard extends StatelessWidget {
  const InsightsSummaryCard({
    super.key,
    required this.range,
    required this.totals,
    required this.currency,
    this.approx = false,
  });

  final InsightsRange range;
  final RangeTotals totals;
  final String currency;
  final bool approx;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final key = InsightsFormat.rangeKey(range);
    final change = totals.changePercent;
    final trend = !totals.comparable
        ? l.insightsTrendNoData(key)
        : change == null
        ? null
        : change > 0
        ? l.insightsTrendMore(key, change)
        : change < 0
        ? l.insightsTrendLess(key, -change)
        : l.insightsTrendSame(key);
    String money(double v) => l.amount(v, currency, approx: approx);
    // Expected periods are an estimate too (same "≈" as the Calendar header).
    final total = l.amount(totals.total, currency, approx: approx || totals.expected > 0);
    final lg = AppType.meta.copyWith(color: c.inkMuted);
    final value = AppType.label.copyWith(color: c.ink).tabular;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.insightsTotalLabel(key), style: lg),
                const SizedBox(height: 2),
                Text(
                  total,
                  semanticsLabel: l.spokenLabel(total),
                  style: AppType.headline.copyWith(color: c.ink).tabular,
                  textScaler: AppTextScale.capped(context, AppTextScale.headline),
                ),
                if (trend != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 1),
                        child: Icon(
                          change == null
                              ? AppIcons.info
                              : change < 0
                              ? LucideIcons.trendingDown
                              : AppIcons.trend,
                          size: 16,
                          color: c.inkMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(child: Text(trend, style: lg)),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpace.s3),
          Divider(height: 1, thickness: 1, color: c.line),
          const SizedBox(height: AppSpace.s3),
          for (final (hatch, label, v) in [
            (false, l.insightsLegendPaid, totals.paid),
            (true, l.insightsLegendExpected, totals.expected),
          ])
            Padding(
              padding: EdgeInsets.only(top: hatch ? 6 : 0),
              child: MergeSemantics(
                // ≥ 150% text the amount goes under the label (real phone, 320dp at 200%: the label
                // was squeezed to one letter per line).
                child: MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(padding: const EdgeInsets.only(top: 4), child: ChartSwatch(hatch: hatch)),
                          const SizedBox(width: AppSpace.s2),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(label, style: lg),
                                Text(money(v), key: ValueKey('legend-value-$hatch'), semanticsLabel: l.spokenLabel(money(v)), style: value),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          ChartSwatch(hatch: hatch),
                          const SizedBox(width: AppSpace.s2),
                          Expanded(child: Text(label, style: lg)),
                          const SizedBox(width: AppSpace.s3),
                          Text(money(v), semanticsLabel: l.spokenLabel(money(v)), style: value),
                        ],
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

/// "Most expensive": rank, 24px tile, name over a share bar, Monthly cost. Rows open the
/// subscription (≥ 48dp).
class TopExpensiveCard extends StatelessWidget {
  const TopExpensiveCard({super.key, required this.top, required this.calc, required this.onOpen});

  final List<(Subscription, double)> top;
  final SpendingCalculator calc;
  final ValueChanged<Subscription> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final max = top.isEmpty ? 1.0 : top.first.$2;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s4, AppSpace.s4, AppSpace.s2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InsightsCardHeader(title: l.insightsTop, hint: l.commonPerMonth),
          for (final (i, (s, cost)) in top.indexed)
            InkWell(
              onTap: () => onOpen(s),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 14,
                        child: Text(
                          '${i + 1}',
                          style: AppType.meta.copyWith(fontWeight: FontWeight.w600, color: c.inkMuted).tabular,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, size: 24, serviceId: s.serviceId, customLogoFile: s.customLogoFile),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              s.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppType.label.copyWith(color: c.ink),
                            ),
                            const SizedBox(height: 4),
                            ExcludeSemantics(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: max <= 0 ? 0 : (cost / max).clamp(0.0, 1.0),
                                  minHeight: 4,
                                  color: c.brand,
                                  backgroundColor: c.surface2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Builder(
                        builder: (context) {
                          final text = l.amount(
                            cost,
                            calc.primaryCurrency,
                            approx: s.currency.toUpperCase() != calc.primaryCurrency.toUpperCase(),
                          );
                          return Text(
                            text,
                            semanticsLabel: l.spokenLabel(text),
                            style: AppType.label.copyWith(color: c.ink).tabular,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Savings card on `success-soft`: "You're saving ₫1,479,000/year by cancelling …".
class SavingsCard extends StatelessWidget {
  const SavingsCard({
    super.key,
    required this.yearly,
    required this.cancelled,
    required this.currency,
    this.approx = false,
  });

  final double yearly;
  final List<Subscription> cancelled;
  final String currency;
  final bool approx;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final by = cancelled.length <= 2
        ? l.insightsSavingBy(l.joinNames([for (final s in cancelled) s.name]))
        : l.insightsSavingByCount(cancelled.length);
    return AppCard(
      color: c.successSoft,
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      child: MergeSemantics(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.surface, shape: BoxShape.circle),
              child: Icon(AppIcons.savings, size: 24, color: c.success),
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l.insightsSaving, style: AppType.meta.copyWith(color: c.success)),
                  Text(
                    '${l.amount(yearly, currency, approx: approx)}${l.corePer('year')}',
                    style: AppType.title.copyWith(color: c.ink).tabular,
                  ),
                  Text(by, style: AppType.meta.copyWith(color: c.success)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Light insight: "You pay for 2 video services — Netflix and YouTube Premium together are
/// ₫100,800/month. Need both?" with the services' tiles overlapping on the right.
class OverlapHintCard extends StatelessWidget {
  const OverlapHintCard({super.key, required this.hint, required this.currency, this.approx = false});

  final OverlapHint hint;
  final String currency;
  final bool approx;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final subs = hint.subscriptions;
    final shown = subs.take(3).toList();
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      child: MergeSemantics(
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: c.brandSoft, shape: BoxShape.circle),
              child: Icon(AppIcons.tip, size: 20, color: c.onBrandSoft),
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.insightsOverlapTitle(hint.category.key, subs.length),
                    style: AppType.label.copyWith(color: c.ink),
                  ),
                  Text(
                    l.insightsOverlapBody(
                      subs.length,
                      l.joinNames([for (final s in subs) s.name]),
                      l.amount(hint.monthly, currency, approx: approx),
                    ),
                    style: AppType.meta.copyWith(color: c.inkMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpace.s2),
            ExcludeSemantics(
              child: SizedBox(
                width: 24.0 + (shown.length - 1) * 20 + 4,
                height: 28,
                child: Stack(
                  children: [
                    for (final (i, s) in shown.indexed)
                      Positioned(
                        left: i * 20.0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: c.surface,
                            borderRadius: BorderRadius.circular(AppRadius.tile24 + 2),
                          ),
                          child: ServiceTile(name: s.name, colorValue: s.colorValue, iconText: s.iconText, size: 24, serviceId: s.serviceId, customLogoFile: s.customLogoFile),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
