import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';

// S2 pieces added by the v13 mockup (product.md §10.2). Kept in the feature for now; candidates for
// core/widgets once S5/S7/S8 need them (label chip, Auto badge).

/// Label chip on a row (`lbl`): 20px pill on `surface-2`, 8px colour dot, 12/600 `ink`. Never truncates.
class LabelChip extends StatelessWidget {
  const LabelChip({super.key, required this.name, this.colorValue});

  final String name;

  /// Label colour; `null` → neutral `line-strong` dot.
  final int? colorValue;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 20),
      padding: const EdgeInsetsDirectional.fromSTEB(6, 2, 8, 2),
      decoration: ShapeDecoration(color: c.surface2, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorValue == null ? c.lineStrong : Color(colorValue!),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: AppType.caption.copyWith(letterSpacing: 0, fontSize: 12, height: 16 / 12, color: c.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// "✦ Auto" badge beside the name of an auto-detected subscription (`auto-b`): `brand-soft` pill,
/// 11/700 `on-brand-soft`. Read as "Auto-detected".
class AutoBadge extends StatelessWidget {
  const AutoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Semantics(
      label: l.commonAutoDetected,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 20),
        padding: const EdgeInsetsDirectional.fromSTEB(5, 2, 7, 2),
        decoration: ShapeDecoration(color: c.brandSoft, shape: const StadiumBorder()),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.sparkles, size: 12, color: c.onBrandSoft),
            const SizedBox(width: 3),
            Text(
              l.homeAutoBadge,
              maxLines: 1,
              softWrap: false,
              style: AppType.caption.copyWith(
                letterSpacing: .1,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c.onBrandSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One day of the "Due this week" strip.
class WeekDay {
  const WeekDay({required this.date, required this.subscriptions, this.awaitingIds = const {}});

  final LocalDate date;

  /// Subscriptions due that day (first two show as 24px tiles).
  final List<Subscription> subscriptions;

  /// Ids among [subscriptions] whose period waits for confirmation (tile gets the warning dot).
  final Set<String> awaitingIds;
}

/// "Due this week" card (png 08, `wk`): eyebrow + week total, "+₫65,000 to confirm" in amber,
/// then 7 equal day columns (2-letter weekday, date, up to two 24px tiles or a 4px dot); today on
/// `brand-soft`. The whole card opens the calendar.
class WeekCard extends StatelessWidget {
  const WeekCard({super.key, required this.total, required this.days, required this.today, this.toConfirm, this.onTap});

  /// Formatted total due this week (awaiting amounts excluded).
  final String total;

  /// Formatted amount still awaiting confirmation this week; `null` = none.
  final String? toConfirm;
  final List<WeekDay> days;
  final LocalDate today;
  final VoidCallback? onTap;

  static String weekday2(AppLocalizations l, LocalDate d) {
    final dt = DateTime(d.year, d.month, d.day);
    if (l.localeName.startsWith('vi')) return dt.weekday == DateTime.sunday ? 'CN' : 'T${dt.weekday + 1}';
    return DateFormat('EEE', 'en').format(dt).substring(0, 2);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final title = l.homeWeekTitle;
    final head = Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: AppSpace.s2,
      runSpacing: 2,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title.toUpperCase(), style: AppType.caption.copyWith(color: c.inkMuted)),
            const SizedBox(height: 2),
            Text(
              total,
              semanticsLabel: l.spokenLabel(total),
              style: AppType.title.copyWith(color: c.ink).tabular,
            ),
          ],
        ),
        if (toConfirm != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(AppIcons.awaiting, size: 14, color: c.warningInk),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    l.homeWeekToConfirm(toConfirm!),
                    semanticsLabel: l.spokenLabel(l.homeWeekToConfirm(toConfirm!)),
                    style: AppType.meta.copyWith(color: c.warningInk).tabular,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
    return Semantics(
      container: true,
      child: AppCard(
        onTap: onTap,
        padding: const EdgeInsets.fromLTRB(AppSpace.s4, 14, AppSpace.s4, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            head,
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < days.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(child: _day(context, days[i])),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _day(BuildContext context, WeekDay d) {
    final c = context.colors;
    final l = context.l10n;
    final isToday = d.date == today;
    final fgW = isToday ? c.onBrandSoft : c.inkMuted;
    final fgN = isToday ? c.onBrandSoft : c.ink;
    final names = d.subscriptions.map((s) => s.name).join(', ');
    return Semantics(
      label: '${AppDates.weekdayShort(l, d.date, today: today)}: ${names.isEmpty ? l.homeWeekNothing : names}',
      excludeSemantics: true,
      child: TextScaleCap(
        max: 1.3,
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 6, 0, 8),
          decoration: BoxDecoration(color: isToday ? c.brandSoft : null, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  weekday2(l, d.date).toUpperCase(),
                  maxLines: 1,
                  style: AppType.caption.copyWith(letterSpacing: 0, fontSize: 11, color: fgW),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${d.date.day}',
                style: AppType.titleSm.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: fgN).tabular,
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 26),
                child: d.subscriptions.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(color: c.line, shape: BoxShape.circle),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final (i, s) in d.subscriptions.take(2).indexed) ...[
                            if (i > 0) const SizedBox(height: 3),
                            ServiceTile(
                              name: s.name,
                              colorValue: s.colorValue,
                              iconText: s.iconText,
                              size: 24,
                              awaiting: d.awaitingIds.contains(s.id),
                              serviceId: s.serviceId,
                              subscriptionId: s.id,
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Budget bar in the hero (png 08, `budget`): 10px track on `surface-2` with a `line` ring; the
/// fill (= share of the budget used, capped at 100 %) is split by subscription colour. Under it
/// "Budget ₫1,200,000" and "90% used" — amber + gauge from 85 %, red + alert (and a red ring) over 100 %.
class BudgetBar extends StatelessWidget {
  const BudgetBar({super.key, required this.ratio, required this.budget, required this.segments, this.onTap});

  /// Spent / budget (0…∞).
  final double ratio;

  /// Formatted budget amount.
  final String budget;
  final List<SpendSegment> segments;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final over = ratio > 1;
    final near = !over && ratio >= .85;
    final pct = (ratio * 100).round();
    final pctColor = over ? c.danger : (near ? c.warningInk : c.inkMuted);
    final total = segments.fold<double>(0, (a, s) => a + s.value);
    final fill = ratio.clamp(0.0, 1.0);
    final bar = Container(
      height: 10,
      decoration: ShapeDecoration(
        color: c.surface2,
        shape: StadiumBorder(
          side: BorderSide(color: over ? c.danger : c.line, width: over ? 2 : 1),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: FractionallySizedBox(
          widthFactor: fill,
          heightFactor: 1,
          child: total <= 0
              ? ColoredBox(color: c.brand)
              : Row(
                  children: [
                    for (final (i, s) in segments.where((s) => s.value > 0).indexed) ...[
                      if (i > 0) const SizedBox(width: 2),
                      Expanded(
                        flex: (s.value / total * 1000).round().clamp(1, 1000),
                        child: ColoredBox(color: s.color),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
    final row = Wrap(
      alignment: WrapAlignment.spaceBetween,
      spacing: AppSpace.s2,
      runSpacing: 2,
      children: [
        Text(l.homeBudget(budget), style: AppType.meta.copyWith(color: c.inkMuted).tabular),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (over || near) ...[
              Icon(over ? AppIcons.alert : LucideIcons.gauge, size: 14, color: pctColor),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                l.homeBudgetUsed(pct),
                style: AppType.meta
                    .copyWith(color: pctColor, fontWeight: over ? FontWeight.w700 : (near ? FontWeight.w600 : null))
                    .tabular,
              ),
            ),
          ],
        ),
      ],
    );
    return Semantics(
      container: true,
      button: onTap != null,
      label: '${l.homeBudget(budget)}, ${l.homeBudgetUsed(pct)}',
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppTouch.min),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [bar, const SizedBox(height: 6), row],
            ),
          ),
        ),
      ),
    );
  }
}

/// One removable chip of an active filter (png 17).
class ActiveFilter {
  const ActiveFilter(this.label, this.onRemove);
  final String label;
  final VoidCallback onRemove;
}

/// Active filters above the list (`fchips`): selected chips with an ×, then "Clear".
class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({super.key, required this.filters, required this.onClear});

  final List<ActiveFilter> filters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Wrap(
      spacing: AppSpace.s2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final f in filters)
          Semantics(
            button: true,
            label: l.homeFilterRemove(f.label),
            excludeSemantics: true,
            onTap: f.onRemove,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: f.onRemove,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: (AppTouch.min - 32) / 2),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 32),
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 10, 4),
                  decoration: ShapeDecoration(color: c.brand, shape: const StadiumBorder()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          f.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.label.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: c.onBrand),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(LucideIcons.x, size: 16, color: c.onBrand),
                    ],
                  ),
                ),
              ),
            ),
          ),
        TextButton(onPressed: onClear, child: Text(l.homeFilterClear)),
      ],
    );
  }
}
