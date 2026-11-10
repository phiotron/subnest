import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import '../../../domain/stats/calendar_month.dart';
import 'calendar_labels.dart';

/// One Calendar entry as a list row (day list under the grid and the Agenda): 40px tile (amber
/// dot while awaiting), name, state line, amount in the subscription's own currency. Agenda rows
/// lead with the date ([showDate]); day-list rows awaiting confirmation get a small Confirm button.
class CalendarEntryRow extends StatelessWidget {
  const CalendarEntryRow({
    super.key,
    required this.entry,
    required this.today,
    this.showDate = false,
    this.onTap,
    this.onConfirm,
  });

  final CalendarEntry entry;
  final LocalDate today;
  final bool showDate;
  final VoidCallback? onTap;

  /// Shown only for awaiting entries.
  final VoidCallback? onConfirm;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = entry.subscription;
    final kind = entry.kind;
    final skipped = kind == CalendarEntryKind.skipped;

    final Widget second = switch (kind) {
      CalendarEntryKind.awaiting => Align(
        alignment: AlignmentDirectional.centerStart,
        child: StatusBadge.awaiting(label: l.commonStatusAwaiting),
      ),
      CalendarEntryKind.paid => _IconText(icon: AppIcons.paid, text: l.calendarPaid, color: c.success),
      CalendarEntryKind.skipped => _IconText(icon: AppIcons.cancelled, text: l.calendarDidNotPay, color: c.inkMuted),
      CalendarEntryKind.upcoming => Text(
        _upcomingMeta(l),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppType.meta.copyWith(color: c.inkMuted),
      ),
    };

    final amount = Text(
      l.money(CalendarMonth.amountOf(entry)),
      maxLines: 1,
      softWrap: false,
      style: AppType.titleSm
          .copyWith(
            color: skipped ? c.inkMuted : c.ink,
            decoration: skipped ? TextDecoration.lineThrough : null,
            decorationColor: c.inkMuted,
          )
          .tabular,
    );

    // "Monthly" / "Yearly" under the amount — a bare price left the period unclear (2026-11-10 (2) #7).
    final cycleChip = CycleChip(cycle: s.cycle);

    final confirm = kind == CalendarEntryKind.awaiting && onConfirm != null
        // The 40px pill sits in a 48px-high hit area (S-50).
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onConfirm,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: AppButton.tonal(label: l.calendarConfirm, small: true, onPressed: onConfirm),
            ),
          )
        : null;

    final date = showDate
        ? ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${entry.date.day}',
                  style: AppType.titleSm.copyWith(fontWeight: FontWeight.w700, height: 1.1, color: c.ink).tabular,
                ),
                Text(
                  l.calWeekday(DateTime.utc(entry.date.year, entry.date.month, entry.date.day).weekday),
                  style: AppType.caption.copyWith(color: c.inkMuted, letterSpacing: 0, height: 1.2),
                ),
              ],
            ),
          )
        : null;

    return Semantics(
      button: onTap != null,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppSize.rowH),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 12),
            child: LayoutBuilder(
              builder: (context, box) {
                // Narrow row (360dp, VI, large text): the amount (+ Confirm) drops under the state
                // line so the badge never gets squeezed — badges and amounts never truncate.
                final scaler = MediaQuery.textScalerOf(context);
                double w(String t, TextStyle st) => (TextPainter(
                  text: TextSpan(text: t, style: st),
                  textDirection: TextDirection.ltr,
                  textScaler: scaler,
                  maxLines: 1,
                )..layout()).width;
                final fixed = (date != null ? 32 + AppSpace.s3 : 0) + 40 + AppSpace.s3 * 2;
                final right = [
                  w(amount.data!, amount.style!),
                  if (confirm != null) w(l.calendarConfirm, AppType.label) + 32,
                ].reduce((a, b) => a > b ? a : b);
                final needed = kind == CalendarEntryKind.awaiting
                    ? w(l.commonStatusAwaiting, AppType.caption.copyWith(letterSpacing: 0)) + 31
                    : w(s.name.length > 8 ? s.name.substring(0, 8) : s.name, AppType.titleSm);
                final compact = box.maxWidth - fixed - right < needed;

                final main = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.titleSm.copyWith(color: c.ink),
                    ),
                    const SizedBox(height: 3),
                    second,
                    if (compact) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: AppSpace.s3,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [amount, cycleChip, ?confirm],
                      ),
                    ],
                  ],
                );
                return Row(
                  children: [
                    if (date != null) ...[date, const SizedBox(width: AppSpace.s3)],
                    ServiceTile(
                      name: s.name,
                      colorValue: s.colorValue,
                      iconText: s.iconText,
                      awaiting: kind == CalendarEntryKind.awaiting,
                      serviceId: s.serviceId,
                      customLogoFile: s.customLogoFile,
                    ),
                    const SizedBox(width: AppSpace.s3),
                    Expanded(child: main),
                    if (!compact) ...[
                      const SizedBox(width: AppSpace.s3),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          amount,
                          const SizedBox(height: 2),
                          cycleChip,
                          if (confirm != null) ...[const SizedBox(height: 2), confirm],
                        ],
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String _upcomingMeta(AppLocalizations l) {
    final s = entry.subscription;
    final firstCharge =
        BillingRules.effectiveStatus(s, today) == SubscriptionStatus.trial && s.trialEndDate == entry.date;
    return firstCharge ? l.calendarFirstCharge : AppDates.relative(l, entry.date, today: today);
  }
}

class _IconText extends StatelessWidget {
  const _IconText({required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          text,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppType.meta.copyWith(fontWeight: FontWeight.w600, color: color),
        ),
      ),
    ],
  );
}
