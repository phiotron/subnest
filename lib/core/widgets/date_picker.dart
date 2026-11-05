import 'package:flutter/material.dart';

import '../../domain/domain.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'app_button.dart';
import 'app_icons.dart';
import 'formatters.dart';
import 'sheet_dialog.dart';

/// Month grid date picker (design Components › DatePicker): weeks start on **Monday**, 44px round
/// day cells (tabular 16px), `today` = `brand` ring + bold, selected = `brand` fill, days before
/// [today] muted when [dimPast]. ‹ › change month.
class AppDatePicker extends StatefulWidget {
  const AppDatePicker({
    super.key,
    required this.selected,
    required this.today,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.dimPast = true,
  });

  final LocalDate? selected;
  final LocalDate today;
  final ValueChanged<LocalDate> onChanged;
  final LocalDate? firstDate;
  final LocalDate? lastDate;
  final bool dimPast;

  @override
  State<AppDatePicker> createState() => _AppDatePickerState();
}

class _AppDatePickerState extends State<AppDatePicker> {
  late LocalDate _month = (widget.selected ?? widget.today).firstOfMonth;

  bool _enabled(LocalDate d) =>
      (widget.firstDate == null || !d.isBefore(widget.firstDate!)) &&
      (widget.lastDate == null || !d.isAfter(widget.lastDate!));

  void _shift(int months) => setState(() => _month = _month.addMonths(months).firstOfMonth);

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final offset = (DateTime(_month.year, _month.month).weekday - AppDates.firstDayOfWeek) % 7;
    final days = LocalDate.daysInMonth(_month.year, _month.month);
    final cells = <LocalDate?>[
      for (var i = 0; i < offset; i++) null,
      for (var d = 1; d <= days; d++) LocalDate(_month.year, _month.month, d),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }
    final canPrev = widget.firstDate == null || _month.isAfter(widget.firstDate!.firstOfMonth);
    final canNext = widget.lastDate == null || _month.isBefore(widget.lastDate!.firstOfMonth);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            AppIconButton(icon: AppIcons.back, size: 20, tooltip: l.corePrevMonth, onPressed: canPrev ? () => _shift(-1) : null),
            Expanded(
              child: Text(
                AppDates.monthTitle(l, _month.year, _month.month),
                textAlign: TextAlign.center,
                style: AppType.titleSm.copyWith(color: c.ink),
              ),
            ),
            AppIconButton(icon: AppIcons.next, size: 20, tooltip: l.coreNextMonth, onPressed: canNext ? () => _shift(1) : null),
          ],
        ),
        const SizedBox(height: 6),
        ExcludeSemantics(
          child: Row(
            children: [
              for (final w in AppDates.weekdayHeaders(l))
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      w,
                      textAlign: TextAlign.center,
                      style: AppType.caption.copyWith(letterSpacing: 0, color: c.inkMuted),
                    ),
                  ),
                ),
            ],
          ),
        ),
        for (var r = 0; r < cells.length ~/ 7; r++)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                for (final d in cells.sublist(r * 7, r * 7 + 7))
                  Expanded(child: d == null ? const SizedBox(height: 44) : _day(context, d)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _day(BuildContext context, LocalDate d) {
    final c = context.colors;
    final on = d == widget.selected;
    final today = d == widget.today;
    final past = widget.dimPast && d.isBefore(widget.today);
    final enabled = _enabled(d);
    final color = on ? c.onBrand : (today ? c.brand : (past ? c.inkMuted : c.ink));
    return Semantics(
      button: true,
      selected: on,
      enabled: enabled,
      label: AppDates.full(context.l10n, d),
      excludeSemantics: true,
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => widget.onChanged(d) : null,
          child: Opacity(
            opacity: !enabled ? .35 : (past && !on ? .6 : 1),
            child: AnimatedContainer(
              duration: AppMotion.of(context, AppMotion.fast),
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: on ? c.brand : Colors.transparent,
                border: today && !on ? Border.all(color: c.brand, width: 1.5) : null,
              ),
              child: Text(
                '${d.day}',
                textScaler: AppTextScale.capped(context, 1.15),
                style: AppType.body.copyWith(
                  fontSize: 16,
                  fontWeight: on || today ? FontWeight.w700 : FontWeight.w400,
                  color: color,
                ).tabular,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Date-picker sheet: [AppDatePicker] + a footer (hairline, optional [footer] text such as
/// "Then 4 Jan · 4 Feb · 4 Mar", and a tonal Done button). Returns the picked date, or `null`
/// when dismissed. [footer] is rebuilt with the current selection.
Future<LocalDate?> showAppDatePicker(
  BuildContext context, {
  required LocalDate? initial,
  required LocalDate today,
  required String doneLabel,
  String Function(LocalDate selected)? footer,
  LocalDate? firstDate,
  LocalDate? lastDate,
  bool dimPast = true,
}) {
  var value = initial;
  return showAppSheet<LocalDate>(
    context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final c = ctx.colors;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppDatePicker(
              selected: value,
              today: today,
              firstDate: firstDate,
              lastDate: lastDate,
              dimPast: dimPast,
              onChanged: (d) => setState(() => value = d),
            ),
            const SizedBox(height: AppSpace.s2),
            Divider(height: 1, color: c.line),
            const SizedBox(height: AppSpace.s3),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value != null && footer != null ? footer(value!) : '',
                    style: AppType.body.copyWith(color: c.inkMuted),
                  ),
                ),
                const SizedBox(width: AppSpace.s3),
                AppButton.primary(
                  label: doneLabel,
                  small: true,
                  onPressed: value == null ? null : () => Navigator.pop(ctx, value),
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
