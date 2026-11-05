import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../../domain/stats/calendar_month.dart';
import 'calendar_labels.dart';

/// Month grid card of S8 (design `.cal-card`): weeks start on Monday; each day shows up to three
/// service-coloured marks (solid = paid, faded = upcoming, outline = skipped) and "+N"; today is a
/// `brand` disc, the selected day a `brand-soft` cell, a day with a period to confirm carries the
/// amber clock. Legend underneath. Cells are ≥ 48dp wide from a 352dp-wide screen (see
/// [CalendarScreen] gutter) and grow with the text size.
class MonthGrid extends StatelessWidget {
  const MonthGrid({super.key, required this.month, required this.selectedDay, required this.onSelect});

  final CalendarMonth month;
  final int selectedDay;
  final ValueChanged<int> onSelect;

  static const _maxMarks = 3;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final first = month.month;
    final lead = DateTime.utc(first.year, first.month, 1).weekday - 1; // Monday = 0
    final cells = <Widget>[
      for (var i = 0; i < lead; i++) const SizedBox.shrink(),
      for (var d = 1; d <= month.daysInMonth; d++)
        _DayCell(month: month, day: d, selected: d == selectedDay, onTap: () => onSelect(d)),
    ];
    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }
    return AppCard(
      padding: const EdgeInsets.fromLTRB(6, 10, 6, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ExcludeSemantics(
            child: Row(
              children: [
                for (var wd = 1; wd <= 7; wd++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 6),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          l.calWeekday(wd),
                          style: AppType.caption.copyWith(color: c.inkMuted, letterSpacing: 0),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          for (var r = 0; r < cells.length; r += 7)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [for (final cell in cells.sublist(r, r + 7)) Expanded(child: cell)],
            ),
          const SizedBox(height: 6),
          Divider(height: 1, thickness: 1, color: c.line, indent: 2, endIndent: 2),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Semantics(
              container: true,
              label: l.calendarLegendLabel,
              child: Wrap(
                spacing: 14,
                runSpacing: 6,
                children: [
                  _LegendItem(
                    mark: EventMark(color: c.inkMuted, kind: CalendarEntryKind.paid),
                    label: l.calendarPaid,
                  ),
                  _LegendItem(
                    mark: EventMark(color: c.inkMuted, kind: CalendarEntryKind.upcoming),
                    label: l.calendarUpcoming,
                  ),
                  _LegendItem(
                    mark: EventMark(color: c.inkMuted, kind: CalendarEntryKind.skipped),
                    label: l.calendarSkipped,
                  ),
                  _LegendItem(
                    mark: Icon(AppIcons.awaiting, size: 12, color: c.warningInk),
                    label: l.commonStatusAwaiting,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String semanticsLabel(AppLocalizations l, CalendarMonth month, int day) {
    final date = LocalDate(month.month.year, month.month.month, day);
    final entries = month.onDay(day);
    final when = AppDates.weekdayShort(l, date, today: month.today);
    final today = date == month.today ? ', ${l.coreRelToday}' : '';
    final items = entries.isEmpty
        ? l.calendarCountPayments(0)
        : entries.map((e) => '${e.subscription.name} (${l.entryState(e.kind)})').join(', ');
    return l.calendarDayLabel('$when$today', items);
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.month, required this.day, required this.selected, required this.onTap});

  final CalendarMonth month;
  final int day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final isToday = month.isCurrent && month.today.day == day;
    final entries = month.onDay(day);
    final waiting = month.hasAwaiting(day);
    // Day numbers grow up to 160% so two-digit days keep a gap at 200% (the cell grows with them).
    final numberScaler = MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.6);
    final disc = 28.0 * (numberScaler.scale(14) / 14 > 1 ? 1 + (numberScaler.scale(14) / 14 - 1) * .8 : 1);
    const radius = BorderRadius.all(Radius.circular(12));

    return Semantics(
      button: true,
      selected: selected,
      label: MonthGrid.semanticsLabel(l, month, day),
      excludeSemantics: true,
      onTap: onTap,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.fast),
            constraints: const BoxConstraints(minHeight: 56),
            decoration: BoxDecoration(color: selected ? c.brandSoft : null, borderRadius: radius),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: disc,
                        height: disc,
                        alignment: Alignment.center,
                        decoration: isToday ? BoxDecoration(color: c.brand, shape: BoxShape.circle) : null,
                        child: Text(
                          '$day',
                          textScaler: numberScaler,
                          maxLines: 1,
                          softWrap: false,
                          style: AppType.label
                              .copyWith(
                                color: isToday ? c.onBrand : c.ink,
                                fontWeight: isToday || selected ? FontWeight.w700 : FontWeight.w400,
                                height: 1.1,
                              )
                              .tabular,
                        ),
                      ),
                      const SizedBox(height: 4),
                      SizedBox(
                        height: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (final (i, e) in entries.take(MonthGrid._maxMarks).indexed) ...[
                              if (i > 0) const SizedBox(width: 2),
                              EventMark(color: Color(e.subscription.colorValue), kind: e.kind),
                            ],
                            if (entries.length > MonthGrid._maxMarks) ...[
                              const SizedBox(width: 2),
                              Text(
                                '+${entries.length - MonthGrid._maxMarks}',
                                textScaler: TextScaler.noScaling,
                                style: AppType.caption.copyWith(
                                  fontSize: 10,
                                  height: 1,
                                  letterSpacing: 0,
                                  color: c.inkMuted,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (waiting)
                  Positioned(
                    top: 2,
                    right: 3,
                    child: Container(
                      width: 14,
                      height: 14,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: c.warningSoft, shape: BoxShape.circle),
                      child: Icon(AppIcons.awaiting, size: 10, color: c.warningInk),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 10×10 day mark: solid for a Payment, 40% for an upcoming / awaiting period, 2px outline for a
/// Skipped period; `tile-ring` keeps dark colours edged on dark surfaces.
class EventMark extends StatelessWidget {
  const EventMark({super.key, required this.color, required this.kind});

  final Color color;
  final CalendarEntryKind kind;

  @override
  Widget build(BuildContext context) {
    final ring = context.colors.tileRing;
    const r = BorderRadius.all(Radius.circular(3));
    final mark = switch (kind) {
      CalendarEntryKind.skipped => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: r,
          border: Border.all(color: color, width: 2),
        ),
      ),
      _ => DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: r,
          border: Border.all(color: ring),
        ),
      ),
    };
    return SizedBox(
      width: 10,
      height: 10,
      child: kind == CalendarEntryKind.upcoming ? Opacity(opacity: .4, child: mark) : mark,
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.mark, required this.label});

  final Widget mark;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      mark,
      const SizedBox(width: 6),
      Flexible(
        child: Text(label, style: AppType.meta.copyWith(color: context.colors.inkMuted)),
      ),
    ],
  );
}
