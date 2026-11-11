import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'insights_format.dart';
import 'stats_parts.dart';

/// "12 months" card of S9 (design `bars12()`): one bar per month of the selected year — the
/// selected month solid `brand`, others `brand` 25% on `surface-2`, months still ahead hatched
/// (projected). Tapping a bar selects that month ([onSelect]). Every bar is a Semantics button
/// with its month and amount.
class MonthBarsCard extends StatelessWidget {
  const MonthBarsCard({
    super.key,
    required this.months,
    required this.selected,
    required this.currentMonth,
    required this.title,
    required this.onSelect,
  });

  /// Twelve Month spends, oldest first.
  final List<MonthSpend> months;

  /// Highlighted month (`null` in Year mode: no bar stands out).
  final LocalDate? selected;

  /// First day of today's month: later months are projected.
  final LocalDate currentMonth;
  final String title;
  final ValueChanged<LocalDate> onSelect;

  static const barsHeight = 120.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final max = months.fold<int>(0, (a, m) => m.totalMinor > a ? m.totalMinor : a);
    final labelScaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.3);

    TextStyle labelStyle(bool on) => AppType.caption.copyWith(
      fontSize: 10,
      height: 1.2,
      letterSpacing: 0,
      fontWeight: on ? FontWeight.w800 : FontWeight.w600,
      color: on ? c.brand : c.inkMuted,
    );
    final column = statsColumnWidth(MediaQuery.sizeOf(context).width, 12, 5);
    final narrow = months.any((m) => textWidth(l.barLabel(m.month), labelStyle(true), labelScaler) > column + 3);

    Widget bar(MonthSpend m) {
      final on = m.month == selected;
      final future = m.month.isAfter(currentMonth);
      final f = max == 0 ? 0.0 : m.totalMinor / max;
      final amount = l.minor(m.totalMinor, m.currency, approx: true);
      const radius = BorderRadius.vertical(top: Radius.circular(5), bottom: Radius.circular(2));
      final Widget fill = future
          ? CustomPaint(
              painter: HatchPainter(color: c.brand, ground: c.surface, outline: !on, radius: 5),
              child: const SizedBox.expand(),
            )
          : DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                color: on ? c.brand : Color.lerp(c.surface2, c.brand, .25),
              ),
            );
      return Expanded(
        child: Semantics(
          container: true,
          button: true,
          selected: on,
          label: l.spoken(l.insightsBarLabel(l.spokenMonth(m.month), amount, future ? 'yes' : 'no')),
          excludeSemantics: true,
          onTap: () => onSelect(m.month),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelect(m.month),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: (f < .03 ? .03 : f).clamp(0.0, 1.0),
                      widthFactor: 1,
                      child: fill,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  narrow ? l.barLabelNarrow(m.month) : l.barLabel(m.month),
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.visible,
                  textScaler: labelScaler,
                  style: labelStyle(on),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StatsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StatsCardHeader(title: title, trailing: StatsHint(l.insightsTapBar)),
          Semantics(
            container: true,
            label: months.isEmpty
                ? null
                : l.insightsChartLabel(l.spokenMonth(months.first.month), l.spokenMonth(months.last.month)),
            child: SizedBox(
              height: barsHeight + 5 + labelScaler.scale(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final (i, m) in months.indexed) ...[if (i > 0) const SizedBox(width: 5), bar(m)],
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              LegendItem(
                mark: LegendSquare(color: c.brand),
                label: l.insightsLegendMonthly,
              ),
              LegendItem(mark: const LegendSquare(outline: true), label: l.insightsProjected),
            ],
          ),
        ],
      ),
    );
  }
}
