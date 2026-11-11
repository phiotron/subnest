import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'insights_format.dart';
import 'stats_parts.dart';

/// Lucide icon of a built-in category (design `CAT_IC`); custom categories get a generic shape.
IconData statsCategoryIcon(String id) => switch (SubscriptionCategory.tryKey(id)) {
  SubscriptionCategory.video => LucideIcons.film,
  SubscriptionCategory.music => LucideIcons.music,
  SubscriptionCategory.ai => LucideIcons.bot,
  SubscriptionCategory.storage => LucideIcons.cloud,
  SubscriptionCategory.software => LucideIcons.cpu,
  SubscriptionCategory.telecom => LucideIcons.signal,
  SubscriptionCategory.education => LucideIcons.graduationCap,
  SubscriptionCategory.gaming => LucideIcons.gamepad2,
  SubscriptionCategory.reading => LucideIcons.bookOpen,
  SubscriptionCategory.health => LucideIcons.heartPulse,
  _ => LucideIcons.shapes,
};

/// 26px category square (design `.ci`): white icon on the category colour.
class CategoryIconTile extends StatelessWidget {
  const CategoryIconTile({super.key, required this.id, required this.color, this.size = 26});

  final String id;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size > 40 ? 14 : 8)),
    child: Icon(statsCategoryIcon(id), size: size * .54, color: ServiceTile.onTileColor(color, context.colors)),
  );
}

/// Service logo of a subscription (greyed when cancelled).
ServiceTile statsTile(Subscription s, {double size = 32}) => ServiceTile(
  name: s.name,
  colorValue: s.colorValue,
  iconText: s.iconText,
  size: size,
  serviceId: s.serviceId,
  customLogoFile: s.customLogoFile,
  off: s.status == SubscriptionStatus.cancelled,
);

/// A tappable row (design `.srow`): 16px sides in a group, none inside a card ([inCard]).
class StatsRow extends StatelessWidget {
  const StatsRow({super.key, required this.children, this.onTap, this.label, this.inCard = false});

  final List<Widget> children;
  final VoidCallback? onTap;
  final String? label;
  final bool inCard;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    button: onTap != null,
    label: label,
    excludeSemantics: label != null,
    child: InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: inCard ? 0 : AppSpace.s4, vertical: 10),
          child: Row(children: children),
        ),
      ),
    ),
  );
}

/// Rows inside a card (design `.group.flat`) separated by hairlines.
class FlatGroup extends StatelessWidget {
  const FlatGroup({super.key, required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (final (i, r) in rows.indexed) ...[
        if (i > 0) Divider(height: 1, thickness: 1, indent: 36, color: context.colors.line),
        r,
      ],
    ],
  );
}

/// Name over "price + cycle chip" (design `.srow .grow`) with the row's amount ([trailing]) on the
/// right — or under the price when the row is too narrow for both (320dp, large text), so amounts
/// never wrap or truncate.
class NameAndPrice extends StatelessWidget {
  const NameAndPrice({super.key, required this.name, required this.price, required this.cycle, this.trailing});

  final String name;
  final String price;
  final BillingCycle cycle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final main = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppType.body.copyWith(fontSize: 15, height: 20 / 15, fontWeight: FontWeight.w500, color: c.ink),
        ),
        const SizedBox(height: 2),
        Wrap(
          spacing: 6,
          runSpacing: 2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(price, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
            CycleChip(cycle: cycle),
          ],
        ),
      ],
    );
    if (trailing == null) return main;
    return LayoutBuilder(
      builder: (context, box) {
        if (box.maxWidth < 190 * scale) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [main, const SizedBox(height: 4), trailing!],
          );
        }
        return Row(
          children: [
            Expanded(child: main),
            const SizedBox(width: AppSpace.s2),
            trailing!,
          ],
        );
      },
    );
  }
}

/// "Most expensive" (design `.c-top`): top 5 of the selected month / year — rank, logo, name,
/// price + cycle chip, the amount it adds to the period.
class TopExpensiveCard extends StatelessWidget {
  const TopExpensiveCard({
    super.key,
    required this.lines,
    required this.currency,
    required this.year,
    required this.onOpen,
  });

  final List<SpendLine> lines;
  final String currency;
  final bool year;
  final ValueChanged<Subscription> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCardHeader(
            title: l.insightsTop,
            trailing: StatsHint(year ? l.insightsShareOfYear : l.insightsShareOfMonth),
          ),
          FlatGroup(
            rows: [
              for (final (i, line) in lines.take(5).indexed)
                () {
                  final s = line.subscription;
                  final price = l.money(s.myShare);
                  final amount = l.minor(line.amountMinor, currency);
                  return StatsRow(
                    inCard: true,
                    onTap: () => onOpen(s),
                    label: l.spoken('${i + 1}. ${s.name}, $price ${l.cycle(s.cycle)}, $amount'),
                    children: [
                      SizedBox(
                        width: 16,
                        child: Text(
                          '${i + 1}',
                          textAlign: TextAlign.center,
                          style: AppType.label.copyWith(fontSize: 13, fontWeight: FontWeight.w800, color: c.inkMuted),
                        ),
                      ),
                      const SizedBox(width: AppSpace.s3),
                      statsTile(s),
                      const SizedBox(width: AppSpace.s3),
                      Expanded(
                        child: NameAndPrice(
                          name: s.name,
                          price: price,
                          cycle: s.cycle,
                          trailing: Text(amount, style: AppType.label.copyWith(color: c.ink).tabular),
                        ),
                      ),
                    ],
                  );
                }(),
            ],
          ),
        ],
      ),
    );
  }
}

/// "Price rises" (design `riseCard()`, product.md §4.9.5): "+$3.50 more a month than a year ago",
/// "That's $42.00 a year · Netflix changed the most", rows old → new with the monthly rise, and
/// Review [biggest]. Empty: one muted line.
class PriceRisesCard extends StatelessWidget {
  const PriceRisesCard({super.key, required this.report, required this.onOpen});

  final PriceIncreaseReport report;
  final ValueChanged<Subscription> onOpen;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final cur = report.currency;
    if (report.isEmpty) {
      return StatsCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StatsCardHeader(title: l.insightsRises),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpace.s3),
              child: Text(
                l.insightsRisesEmpty,
                textAlign: TextAlign.center,
                style: AppType.meta.copyWith(color: c.inkMuted),
              ),
            ),
          ],
        ),
      );
    }
    final biggest = report.biggest!;
    final monthly = l.signedMinor(report.monthlyDeltaMinor, cur);
    final yearly = l.minor(report.yearlyDeltaMinor, cur);
    final bigStyle = AppType.title.copyWith(fontSize: 28, height: 34 / 28, color: c.warningInk).tabular;
    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCardHeader(title: l.insightsRises, icon: LucideIcons.trendingUp, iconColor: c.warningInk),
          MergeSemantics(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: monthly, style: bigStyle),
                  TextSpan(
                    text: ' ${l.insightsRisesPerMonth}',
                    style: AppType.meta.copyWith(color: c.ink),
                  ),
                ],
              ),
              textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.6),
            ),
          ),
          BoldText(l.insightsRisesYearly(yearly, biggest.subscription.name), bold: [yearly]),
          const SizedBox(height: AppSpace.s2),
          FlatGroup(
            rows: [
              for (final i in report.items)
                () {
                  final s = i.subscription;
                  final from = l.money(Money(i.before.priceMinor, i.before.currency));
                  final to = l.money(Money(i.now.priceMinor, i.now.currency));
                  final delta = l.signedMinor(i.monthlyDeltaMinor, cur);
                  return StatsRow(
                    inCard: true,
                    onTap: () => onOpen(s),
                    label: l.spoken(l.insightsRiseLabel(s.name, from, to, delta)),
                    children: [
                      statsTile(s),
                      const SizedBox(width: AppSpace.s3),
                      Expanded(
                        child: NameAndPrice(
                          name: s.name,
                          price: '$from → $to',
                          cycle: s.cycle,
                          trailing: Text(
                            delta,
                            style: AppType.label.copyWith(fontWeight: FontWeight.w800, color: c.warningInk).tabular,
                          ),
                        ),
                      ),
                      Icon(AppIcons.next, size: 18, color: c.inkMuted),
                    ],
                  );
                }(),
            ],
          ),
          const SizedBox(height: AppSpace.s3),
          AppButton.tonal(
            label: l.insightsReview(biggest.subscription.name),
            small: true,
            expand: true,
            onPressed: () => onOpen(biggest.subscription),
          ),
        ],
      ),
    );
  }
}

/// "Next 12 months" (design `next12Card()`, product.md §4.9.6): projected vs the last 12 months,
/// the change split into new subscriptions · price rises · other, Review [top] and View as list.
/// When the recorded history doesn't reach a year back the comparison is worded softly.
class NextYearCard extends StatelessWidget {
  const NextYearCard({super.key, required this.forecast, required this.onOpen, required this.onList});

  final YearForecast forecast;
  final ValueChanged<Subscription> onOpen;
  final VoidCallback onList;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final f = forecast;
    final cur = f.currency;
    final max = f.nextMinor > f.pastMinor ? f.nextMinor : f.pastMinor;

    Widget bar(String label, int v, {required bool projected}) => Semantics(
      container: true,
      label: l.spoken('$label: ${l.minor(v, cur, approx: true)}'),
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label, style: AppType.meta.copyWith(color: c.inkMuted)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 14,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(7)),
                  alignment: AlignmentDirectional.centerStart,
                  child: FractionallySizedBox(
                    widthFactor: max == 0 ? 0 : v / max,
                    heightFactor: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: projected ? const Hatch() : ColoredBox(color: c.lineStrong),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                l.minor(v, cur, approx: true),
                style: AppType.label.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: c.ink).tabular,
              ),
            ],
          ),
        ],
      ),
    );

    Widget line(String label, String? count, int v) => Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: label,
                children: [
                  if (count != null)
                    TextSpan(
                      text: ' · $count',
                      style: AppType.meta.copyWith(color: c.inkMuted),
                    ),
                ],
              ),
              style: AppType.body.copyWith(fontSize: 14, height: 20 / 14, color: c.ink),
            ),
          ),
          const SizedBox(width: AppSpace.s2),
          Text(
            l.signedMinor(v, cur),
            style: AppType.label
                .copyWith(fontWeight: FontWeight.w700, color: v > 0 ? c.warningInk : (v < 0 ? c.success : c.ink))
                .tabular,
          ),
        ],
      ),
    );

    final change = l.signedMinor(f.changeMinor, cur);
    final newCount = f.contributors.where((x) => x.isNew && x.deltaMinor != 0).length;
    final riseCount = f.contributors.where((x) => x.priceIncreaseMinor > 0).length;
    final top = f.top;
    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCardHeader(title: l.insightsNext12, icon: LucideIcons.calendarRange),
          bar(l.insightsForecastProjected, f.nextMinor, projected: true),
          const SizedBox(height: 10),
          bar(l.insightsLast12, f.pastMinor, projected: false),
          const SizedBox(height: 14),
          BoldText(
            '≈ ${l.insightsForecastChange(change)}',
            bold: [change],
            boldWeight: FontWeight.w800,
            style: AppType.body.copyWith(fontSize: 15, height: 22 / 15, color: c.ink),
          ),
          if (!f.historyCoversPast)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l.insightsForecastPartial, style: AppType.meta.copyWith(color: c.inkMuted)),
            ),
          const SizedBox(height: 8),
          Divider(height: 1, thickness: 1, color: c.line),
          line(l.insightsForecastNew, newCount > 0 ? l.insightsCount(newCount) : null, f.newSubscriptionsMinor),
          line(l.insightsForecastRises, riseCount > 0 ? l.insightsCount(riseCount) : null, f.priceIncreasesMinor),
          line(l.insightsForecastOther, null, f.otherMinor),
          const SizedBox(height: AppSpace.s3),
          _TwoButtons(
            labels: [if (top != null) l.insightsReview(top.subscription.name), l.insightsViewList],
            first: top == null
                ? null
                : AppButton.tonal(
                    label: l.insightsReview(top.subscription.name),
                    small: true,
                    expand: true,
                    onPressed: () => onOpen(top.subscription),
                  ),
            second: AppButton.text(label: l.insightsViewList, small: true, expand: true, onPressed: onList),
          ),
        ],
      ),
    );
  }
}

/// Two buttons side by side (design `.two-btn`), stacked when the labels don't fit.
class _TwoButtons extends StatelessWidget {
  const _TwoButtons({required this.labels, required this.first, required this.second});

  /// Button labels, measured to decide between side by side and stacked.
  final List<String> labels;
  final Widget? first;
  final Widget second;

  @override
  Widget build(BuildContext context) {
    if (first == null) return second;
    final scaler = MediaQuery.textScalerOf(context);
    final widest = labels
        .map(
          (t) => (TextPainter(
            text: TextSpan(text: t, style: AppType.label),
            textDirection: TextDirection.ltr,
            textScaler: scaler,
            maxLines: 1,
          )..layout()).width,
        )
        .fold(0.0, (a, b) => a > b ? a : b);
    return LayoutBuilder(
      builder: (context, box) {
        // 14px button padding each side + a little slack.
        if ((box.maxWidth - AppSpace.s2) / 2 < widest + 2 * 14 + 4) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              first!,
              const SizedBox(height: AppSpace.s2),
              second,
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: first!),
            const SizedBox(width: AppSpace.s2),
            Expanded(child: second),
          ],
        );
      },
    );
  }
}

/// "Coming up" (design `upcomingCard()`, §4.9.7): 13 weeks | 12 months of expected charges, the
/// biggest bar in `chart-1`, "Biggest: W47 · ≈ $X (Google One renews)", View as list.
class ComingUpCard extends StatefulWidget {
  const ComingUpCard({super.key, required this.forecast, required this.onList, this.initialWeeks = true});

  final YearForecast forecast;
  final VoidCallback onList;
  final bool initialWeeks;

  @override
  State<ComingUpCard> createState() => _ComingUpCardState();
}

class _ComingUpCardState extends State<ComingUpCard> {
  late bool _weeks = widget.initialWeeks;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final f = widget.forecast;
    final buckets = _weeks ? f.weeks : f.months;
    String label(ForecastBucket b) =>
        _weeks ? l.insightsWeekShort(isoWeek(b.start)) : l.upcomingMonthLabel(b.start.firstOfMonth);
    String spoken(ForecastBucket b) => _weeks
        ? l.spoken(l.insightsWeekLabel(isoWeek(b.start), l.minor(b.totalMinor, f.currency, approx: true)))
        : l.spoken('${l.spokenMonth(b.start.firstOfMonth)}: ${l.minor(b.totalMinor, f.currency, approx: true)}');
    final max = buckets.fold<int>(0, (a, b) => b.totalMinor > a ? b.totalMinor : a);
    final peak = max == 0 ? null : buckets.firstWhere((b) => b.totalMinor == max);
    final peakItem = peak?.items.reduce((a, b) => b.amountMinor > a.amountMinor ? b : a);
    final renews = peakItem != null && peakItem.subscription.cycle != const BillingCycle.monthly();
    final labelScaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3);
    final labelStyle = AppType.caption.copyWith(
      fontSize: _weeks ? 9 : 10,
      height: 1.2,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
      color: c.inkMuted,
    );
    // Labels that don't fit their column (320dp, large text) show on every other bar.
    final column = statsColumnWidth(MediaQuery.sizeOf(context).width, buckets.length, _weeks ? 3 : 5);
    final sparse = buckets.any((b) => textWidth(label(b), labelStyle, labelScaler) > column + 2);

    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCardHeader(
            title: l.insightsComingUp,
            // Scales down instead of overflowing on a 320dp screen at 200% text.
            trailing: FittedBox(
              fit: BoxFit.scaleDown,
              child: AppSegmentedControl<bool>(
                mini: true,
                segments: [
                  AppSegment(value: true, label: l.insightsWeeks13),
                  AppSegment(value: false, label: l.insightsBars12),
                ],
                selected: _weeks,
                onChanged: (v) => setState(() => _weeks = v),
              ),
            ),
          ),
          SizedBox(
            height: MonthBarsHeight.value + 5 + labelScaler.scale(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, b) in buckets.indexed) ...[
                  if (i > 0) SizedBox(width: _weeks ? 3 : 5),
                  Expanded(
                    child: Semantics(
                      container: true,
                      label: spoken(b),
                      excludeSemantics: true,
                      child: Column(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: FractionallySizedBox(
                                widthFactor: 1,
                                heightFactor: max == 0 || b.totalMinor == 0 ? 0 : (b.totalMinor / max).clamp(.04, 1.0),
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(5),
                                      bottom: Radius.circular(2),
                                    ),
                                    color: b == peak ? c.chart1 : Color.lerp(c.surface2, c.chart1, .35),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            sparse && i.isOdd ? '' : label(b),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.visible,
                            textScaler: labelScaler,
                            style: labelStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          if (peak == null)
            Text(l.insightsNothingAhead, style: AppType.meta.copyWith(color: c.inkMuted))
          else
            () {
              final when = _weeks ? l.insightsWeekShort(isoWeek(peak.start)) : l.upcomingMonthLabel(peak.start);
              final amount = l.minor(peak.totalMinor, f.currency, approx: true);
              final text = l.insightsBiggest(when, amount);
              return BoldText(
                renews ? '$text ${l.insightsRenews(peakItem.subscription.name)}' : text,
                bold: [when, amount.replaceFirst('≈ ', '')],
              );
            }(),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: AppButton.text(label: l.insightsViewList, small: true, onPressed: widget.onList),
          ),
        ],
      ),
    );
  }
}

/// Bar area height shared by the 12-month and the coming-up charts.
abstract final class MonthBarsHeight {
  static const value = 120.0;
}

/// One budget line of [BudgetsCard].
class BudgetLine {
  const BudgetLine({
    required this.categoryId,
    required this.label,
    required this.color,
    required this.spentMinor,
    required this.limitMinor,
  });

  final String categoryId;
  final String label;
  final Color color;
  final int spentMinor;
  final int limitMinor;

  double get ratio => limitMinor <= 0 ? 0 : spentMinor / limitMinor;
  bool get over => ratio > 1;
}

/// "Budgets" (design `budgetCard()`, §4.9.8): one bar per category budget against the selected
/// period's Month spend; near (> 85%) `warning`, over `danger` + alert icon. Edit → Settings.
class BudgetsCard extends StatelessWidget {
  const BudgetsCard({super.key, required this.lines, required this.currency, required this.onEdit});

  final List<BudgetLine> lines;
  final String currency;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCardHeader(
            title: l.insightsBudgets,
            trailing: AppButton.text(label: l.insightsEdit, small: true, onPressed: onEdit),
          ),
          for (final b in lines)
            () {
              final spent = l.minor(b.spentMinor, currency);
              final limit = l.minor(b.limitMinor, currency);
              final near = !b.over && b.ratio > .85;
              final tone = b.over ? c.danger : (near ? c.warning : c.brand);
              return Semantics(
                container: true,
                label: l.spoken(l.insightsBudgetLabel(b.label, spent, limit, b.over ? 'yes' : 'no')),
                excludeSemantics: true,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      LayoutBuilder(
                        builder: (context, box) {
                          final scale = MediaQuery.textScalerOf(context).scale(14) / 14;
                          final value = Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (b.over) ...[
                                Icon(AppIcons.alert, size: 13, color: c.danger),
                                const SizedBox(width: 4),
                              ],
                              Flexible(
                                child: Text(
                                  '$spent / $limit',
                                  textAlign: TextAlign.end,
                                  style: AppType.meta.copyWith(color: b.over ? c.danger : c.inkMuted).tabular,
                                ),
                              ),
                            ],
                          );
                          final head = [
                            CategoryIconTile(id: b.categoryId, color: b.color),
                            const SizedBox(width: AppSpace.s2),
                            Expanded(
                              child: Text(b.label, style: AppType.label.copyWith(color: c.ink)),
                            ),
                          ];
                          if (box.maxWidth < 260 * scale) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(children: head),
                                const SizedBox(height: 2),
                                value,
                              ],
                            );
                          }
                          return Row(
                            children: [
                              ...head,
                              const SizedBox(width: AppSpace.s2),
                              value,
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: SizedBox(
                          height: 6,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              ColoredBox(color: c.surface2),
                              FractionallySizedBox(
                                alignment: AlignmentDirectional.centerStart,
                                widthFactor: b.ratio.clamp(0.0, 1.0),
                                child: ColoredBox(color: tone),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }(),
        ],
      ),
    );
  }
}

/// Savings (design `saveCard()`, §4.9.9): "You're saving $X a year by cancelling N subscriptions"
/// on `success-soft`, and — when some Active subscriptions are rated Not worth it — what dropping
/// them would add, with their logos.
class SavingsCard extends StatelessWidget {
  const SavingsCard({
    super.key,
    required this.savingsMinor,
    required this.cancelledCount,
    required this.notWorth,
    required this.notWorthMinor,
    required this.currency,
  });

  final int savingsMinor;
  final int cancelledCount;
  final List<Subscription> notWorth;
  final int notWorthMinor;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final saving = l.minor(savingsMinor, currency);
    final hint = l.minor(notWorthMinor, currency);
    return StatsCard(
      color: c.successSoft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: c.surface, borderRadius: BorderRadius.circular(12)),
            child: Icon(AppIcons.savings, size: 22, color: c.success),
          ),
          const SizedBox(width: AppSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (savingsMinor > 0) ...[
                  BoldText(
                    l.insightsSavingTitle(saving),
                    bold: [saving],
                    boldWeight: FontWeight.w800,
                    style: AppType.label.copyWith(color: c.success),
                    boldColor: c.success,
                  ),
                  Text(l.insightsSavingBy(cancelledCount), style: AppType.meta.copyWith(color: c.success)),
                ],
                if (notWorth.isNotEmpty && notWorthMinor > 0) ...[
                  if (savingsMinor > 0) ...[
                    const SizedBox(height: 10),
                    Divider(height: 1, thickness: 1, color: c.success.withValues(alpha: .25)),
                    const SizedBox(height: 10),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: BoldText(
                          l.insightsNotWorthHint(notWorth.length, hint),
                          bold: [hint],
                          boldWeight: FontWeight.w800,
                          style: AppType.meta.copyWith(color: c.ink),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ExcludeSemantics(
                        child: SizedBox(
                          height: 24,
                          width: 24 + 18.0 * (notWorth.take(3).length - 1),
                          child: Stack(
                            children: [
                              for (final (i, s) in notWorth.take(3).indexed)
                                Positioned(
                                  left: 18.0 * i,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: c.successSoft, width: 2),
                                    ),
                                    child: statsTile(s, size: 24),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Gentle overlap hint (design `.c-hint`): "You pay for 3 video services — do you need all of them?"
class OverlapHintCard extends StatelessWidget {
  const OverlapHintCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.s3),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: AppSpace.s3),
        child: Row(
          children: [
            Icon(AppIcons.tip, size: 20, color: c.warningInk),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: AppType.meta.copyWith(color: c.ink)),
            ),
          ],
        ),
      ),
    );
  }
}
