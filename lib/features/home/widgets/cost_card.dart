import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';

/// One column of the Cost card chart (`mcols`): a month and its Month spend.
class CostColumn {
  const CostColumn({
    required this.label,
    required this.value,
    required this.valueText,
    required this.semanticLabel,
    this.selected = false,
    this.future = false,
    this.onTap,
  });

  /// "Nov" / "T11".
  final String label;

  /// Month spend (major units) — bar height relative to the largest column.
  final double value;

  /// Shown above the selected column ("$144.89").
  final String valueText;
  final String semanticLabel;
  final bool selected;

  /// Months after the current one: hatched outline (projected).
  final bool future;
  final VoidCallback? onTap;
}

/// "↓ $4.00 vs Oct" chip (`delta`): increases `warning-ink` on `warning-soft` with ↑, decreases
/// `success` on `success-soft` with ↓, no change neutral "= Same as Oct" — never colour alone.
class DeltaChip extends StatelessWidget {
  const DeltaChip({super.key, required this.change, required this.amount, required this.period});

  /// Change in minor units (sign only matters).
  final int change;

  /// Formatted absolute change ("$4.00").
  final String amount;

  /// "Oct" / "thg 10" / "2025".
  final String period;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final up = change > 0;
    final same = change == 0;
    final (bg, fg, icon, text, spoken) = same
        ? (c.surface2, c.inkMuted, LucideIcons.equal, l.homeDeltaSame(period), l.homeDeltaSame(period))
        : up
        ? (
            c.warningSoft,
            c.warningInk,
            LucideIcons.arrowUp,
            l.homeDeltaVs(amount, period),
            l.homeDeltaUpLabel(amount, period),
          )
        : (
            c.successSoft,
            c.success,
            LucideIcons.arrowDown,
            l.homeDeltaVs(amount, period),
            l.homeDeltaDownLabel(amount, period),
          );
    return Semantics(
      label: spoken,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 24),
        padding: const EdgeInsetsDirectional.fromSTEB(6, 2, 9, 2),
        decoration: ShapeDecoration(color: bg, shape: const StadiumBorder()),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                text,
                style: AppType.caption.copyWith(letterSpacing: 0, fontWeight: FontWeight.w700, color: fg).tabular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// S2 Cost card (mockup v14 png 012/015/020/021, `costCard()`): Monthly | Yearly segment, change
/// chip (or "First month — no comparison yet"), ≈ total with the (i) button, per-day / per-month
/// line, Paid / Still to pay with the solid-vs-hatched bar and the date range, then 6 month columns
/// (12 in Yearly) — tapping one opens Insights on that month.
class CostCard extends StatelessWidget {
  const CostCard({
    super.key,
    required this.yearly,
    required this.onYearlyChanged,
    required this.total,
    required this.format,
    required this.approx,
    required this.subline,
    this.sublineBold,
    this.delta,
    this.noComparison,
    this.onInfo,
    this.paid,
    this.due,
    this.paidValue = 0,
    this.dueValue = 0,
    this.range,
    this.columns = const [],
  }) : empty = false;

  /// No subscriptions (png 021): segment, muted 0 and "No subscriptions yet" only.
  const CostCard.empty({super.key, required this.total, required this.format, required this.subline})
    : yearly = false,
      onYearlyChanged = null,
      approx = false,
      sublineBold = null,
      delta = null,
      noComparison = null,
      onInfo = null,
      paid = null,
      due = null,
      paidValue = 0,
      dueValue = 0,
      range = null,
      columns = const [],
      empty = true;

  final bool empty;
  final bool yearly;
  final ValueChanged<bool>? onYearlyChanged;

  /// Total in major units of the primary currency (counts up when it changes).
  final double total;
  final String Function(double value) format;
  final bool approx;

  /// "10 active subscriptions · ≈ $4.83 a day"; [sublineBold] is drawn bold (`ink`) inside it.
  final String subline;
  final String? sublineBold;

  /// Change chip; when `null`, [noComparison] (if any) is shown instead.
  final Widget? delta;
  final String? noComparison;
  final VoidCallback? onInfo;

  /// "Paid" amount text / "Still to pay" amount text — the cash block is hidden when both are null.
  final String? paid;
  final String? due;
  final double paidValue;
  final double dueValue;

  /// "1 Nov to 30 Nov".
  final String? range;
  final List<CostColumn> columns;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final mutedTotal = empty || total == 0;
    final children = <Widget>[
      AppSegmentedControl<bool>(
        selected: yearly,
        onChanged: onYearlyChanged == null ? null : (v) => onYearlyChanged!(v),
        segments: [
          AppSegment(value: false, label: l.homeCostMonthly),
          AppSegment(value: true, label: l.homeCostYearly),
        ],
      ),
      const SizedBox(height: AppSpace.s1),
    ];
    if (!empty && (delta != null || noComparison != null)) {
      children.add(
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: delta ?? Text(noComparison!, style: AppType.meta.copyWith(color: c.inkMuted)),
        ),
      );
    }
    children.add(
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: LayoutBuilder(
          builder: (context, box) {
            final size = box.maxWidth < 300 ? 36.0 : 40.0;
            final style = AppType.display.copyWith(fontSize: size, color: mutedTotal ? c.inkMuted : c.ink).tabular;
            return Row(
              children: [
                Flexible(
                  child: TextScaleCap(
                    max: AppTextScale.display,
                    child: Semantics(
                      liveRegion: true,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            if (approx && !mutedTotal) ...[
                              Text('≈', semanticsLabel: l.coreApproximately, style: style),
                              const SizedBox(width: 4),
                            ],
                            CountUpText(value: total, format: format, style: style),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if (onInfo != null) ...[const SizedBox(width: 2), _InfoButton(onPressed: onInfo!)],
              ],
            );
          },
        ),
      ),
    );
    children.add(
      Padding(
        padding: const EdgeInsets.only(top: 2),
        child: _boldText(subline, sublineBold, AppType.meta.copyWith(color: c.inkMuted), c.ink, l.spokenLabel(subline)),
      ),
    );
    if (!empty && (paid != null || due != null)) {
      children.add(
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: _CashBlock(paid: paid ?? '', due: due ?? '', paidValue: paidValue, dueValue: dueValue, range: range),
        ),
      );
    }
    if (!empty && columns.isNotEmpty) {
      children.add(_MonthColumns(columns: columns, twelve: columns.length > 6));
    }
    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: context.elevation.card,
      ),
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, 6, AppSpace.s4, 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

/// [text] with the first occurrence of [bold] drawn `ink` w700 (mockup `<b>` in meta lines).
Widget _boldText(String text, String? bold, TextStyle style, Color boldColor, String? semanticsLabel) {
  final i = bold == null || bold.isEmpty ? -1 : text.indexOf(bold);
  if (i < 0) return Text(text, style: style, semanticsLabel: semanticsLabel);
  final b = style.copyWith(color: boldColor, fontWeight: FontWeight.w700).tabular;
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(text: text.substring(0, i)),
        TextSpan(text: bold, style: b),
        TextSpan(text: text.substring(i + bold!.length)),
      ],
    ),
    style: style,
    semanticsLabel: semanticsLabel,
  );
}

/// 32px round (i) on `surface-2` (`info-b`), 48dp hit area.
class _InfoButton extends StatelessWidget {
  const _InfoButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      button: true,
      label: context.l10n.homeInfoButton,
      excludeSemantics: true,
      onTap: onPressed,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          width: AppTouch.min,
          height: AppTouch.min,
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: c.surface2, shape: BoxShape.circle),
              child: Icon(LucideIcons.info, size: 16, color: c.inkMuted),
            ),
          ),
        ),
      ),
    );
  }
}

/// Paid / Still to pay rows, the 10px bar (solid `brand` vs 135° hatch) and the range line.
class _CashBlock extends StatelessWidget {
  const _CashBlock({
    required this.paid,
    required this.due,
    required this.paidValue,
    required this.dueValue,
    this.range,
  });

  final String paid;
  final String due;
  final double paidValue;
  final double dueValue;
  final String? range;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final rowStyle = AppType.label.copyWith(fontWeight: FontWeight.w500, color: c.inkMuted);
    final amountStyle = AppType.label.copyWith(fontWeight: FontWeight.w700, color: c.ink).tabular;
    Widget line(Widget dot, String label, String amount) => Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpace.s2,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            dot,
            const SizedBox(width: AppSpace.s2),
            Flexible(child: Text(label, style: rowStyle)),
          ],
        ),
        Text(amount, style: amountStyle, semanticsLabel: l.spokenLabel(amount)),
      ],
    );
    final total = paidValue + dueValue;
    final paidFlex = total <= 0 ? 0 : (paidValue / total * 1000).round();
    final dueFlex = total <= 0 ? 0 : 1000 - paidFlex;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        line(_Dot(color: c.brand), l.homePaid, paid),
        const SizedBox(height: 6),
        line(const _Dot(), l.homeStillToPay, due),
        const SizedBox(height: 10),
        Semantics(
          label: l.spoken(l.homeCashLabel(paid, due)),
          excludeSemantics: true,
          child: SizedBox(
            height: 10,
            child: total <= 0
                ? DecoratedBox(
                    decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(5)),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (paidFlex > 0)
                          Expanded(
                            flex: math.max(paidFlex, 12),
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: c.brand, borderRadius: BorderRadius.circular(2)),
                            ),
                          ),
                        if (paidFlex > 0 && dueFlex > 0) const SizedBox(width: 3),
                        if (dueFlex > 0)
                          Expanded(
                            flex: math.max(dueFlex, 12),
                            child: ClipRRect(borderRadius: BorderRadius.circular(2), child: const Hatch()),
                          ),
                      ],
                    ),
                  ),
          ),
        ),
        if (range != null) ...[
          const SizedBox(height: 6),
          Text(range!, style: AppType.meta.copyWith(color: c.inkMuted)),
        ],
      ],
    );
  }
}

/// 10px rounded legend square: solid [color], or the hatch when `null`.
class _Dot extends StatelessWidget {
  const _Dot({this.color});
  final Color? color;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(3),
    child: SizedBox(width: 10, height: 10, child: color == null ? const Hatch() : ColoredBox(color: color!)),
  );
}

/// 135° `brand` hatch (2px stripe, 5px period) on `brand` 22% over [ground] — "Still to pay" /
/// projected, readable in greyscale. [outline]: transparent ground, 40% stripes and a 1px 40% ring
/// (future month columns).
class HatchPainter extends CustomPainter {
  const HatchPainter({required this.brand, required this.ground, this.outline = false});

  final Color brand;
  final Color ground;
  final bool outline;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    if (!outline) canvas.drawRect(rect, Paint()..color = Color.lerp(ground, brand, 0.22)!);
    final stripe = Paint()
      ..color = outline ? brand.withValues(alpha: 0.4) : brand
      ..strokeWidth = 2;
    canvas.save();
    canvas.clipRect(rect);
    const step = 5 * math.sqrt2;
    for (var x = -size.height; x < size.width + size.height; x += step) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), stripe);
    }
    canvas.restore();
    if (outline) {
      canvas.drawRRect(
        RRect.fromRectAndCorners(
          rect.deflate(0.5),
          topLeft: const Radius.circular(6),
          topRight: const Radius.circular(6),
          bottomLeft: const Radius.circular(3),
          bottomRight: const Radius.circular(3),
        ),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = brand.withValues(alpha: 0.4),
      );
    }
  }

  @override
  bool shouldRepaint(HatchPainter old) => old.outline != outline || old.brand != brand || old.ground != ground;
}

/// [HatchPainter] in the current theme's colours.
class Hatch extends StatelessWidget {
  const Hatch({super.key, this.outline = false});
  final bool outline;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: HatchPainter(brand: context.colors.brand, ground: context.colors.surface, outline: outline),
    child: const SizedBox.expand(),
  );
}

/// 6 (or 12) month columns under a top rule (`mcols`); the selected one is solid `brand` with its
/// value above, past ones `brand` 22% on `surface-2`, future ones hatched.
class _MonthColumns extends StatelessWidget {
  const _MonthColumns({required this.columns, required this.twelve});

  final List<CostColumn> columns;
  final bool twelve;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final scaler = MediaQuery.textScalerOf(context);
    final labelStyle = AppType.caption.copyWith(
      letterSpacing: 0,
      fontSize: twelve ? 10 : 11,
      height: 14 / 11,
      color: c.inkMuted,
    );
    final valueStyle = AppType.caption
        .copyWith(letterSpacing: 0, fontSize: 11, height: 14 / 11, fontWeight: FontWeight.w700, color: c.brand)
        .tabular;
    final textH = scaler.scale(14);
    final height = 112 + (textH - 14) * 2;
    final max = columns.fold<double>(0, (a, x) => math.max(a, x.value));
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [for (final col in columns) Expanded(child: _column(context, col, max, labelStyle, valueStyle))],
        ),
      ),
    );
  }

  Widget _column(BuildContext context, CostColumn col, double max, TextStyle labelStyle, TextStyle valueStyle) {
    final c = context.colors;
    final ratio = max <= 0 ? 0.0 : col.value / max;
    final bar = FractionallySizedBox(
      heightFactor: math.max(0.04, ratio),
      child: col.future
          ? const Hatch(outline: true)
          : DecoratedBox(
              decoration: BoxDecoration(
                color: col.selected ? c.brand : Color.alphaBlend(c.brand.withValues(alpha: 0.22), c.surface2),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(6), bottom: Radius.circular(3)),
              ),
            ),
    );
    final content = Padding(
      padding: EdgeInsets.symmetric(horizontal: twelve ? 2 : 4),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.textScalerOf(context).scale(14),
            child: col.selected && !twelve
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(col.valueText, maxLines: 1, style: valueStyle),
                  )
                : null,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 34),
                child: SizedBox(width: double.infinity, child: bar),
              ),
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              col.label,
              maxLines: 1,
              style: labelStyle.copyWith(
                color: col.selected ? c.brand : c.inkMuted,
                fontWeight: col.selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    final tap = GestureDetector(behavior: HitTestBehavior.opaque, onTap: col.onTap, child: content);
    if (twelve) return ExcludeSemantics(child: tap);
    return Semantics(
      button: col.onTap != null,
      selected: col.selected,
      label: col.semanticLabel,
      excludeSemantics: true,
      onTap: col.onTap,
      child: tap,
    );
  }
}

/// (i) sheet "How the numbers work" (png 016).
Future<void> showHowNumbersWorkSheet(BuildContext context) {
  final l = context.l10n;
  return showAppSheet<void>(
    context,
    bare: true,
    builder: (ctx) {
      final c = ctx.colors;
      Widget ex(IconData icon, String title, String body, {bool first = false}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: first ? null : Border(top: BorderSide(color: c.line)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 20, color: c.onBrandSoft),
            ),
            const SizedBox(width: AppSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppType.label.copyWith(color: c.ink)),
                  const SizedBox(height: 2),
                  Text(body, style: AppType.meta.copyWith(color: c.inkMuted)),
                ],
              ),
            ),
          ],
        ),
      );
      return AppSheet(
        title: l.homeInfoTitle,
        actions: [AppButton.tonal(label: l.homeInfoGotIt, expand: true, onPressed: () => Navigator.pop(ctx))],
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ex(LucideIcons.calendarRange, l.homeCostMonthly, l.homeInfoMonthlyBody, first: true),
              ex(LucideIcons.wallet, l.homeInfoCashTitle, l.homeInfoCashBody),
              ex(LucideIcons.equalApproximately, l.homeInfoApproxTitle, l.homeInfoApproxBody),
              Container(
                margin: const EdgeInsets.only(top: AppSpace.s3),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(color: c.brandSoft, borderRadius: BorderRadius.circular(AppRadius.md)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: Icon(LucideIcons.info, size: 16, color: c.onBrandSoft),
                    ),
                    const SizedBox(width: AppSpace.s2),
                    Expanded(
                      child: Text(l.homeInfoNote, style: AppType.meta.copyWith(color: c.onBrandSoft)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
