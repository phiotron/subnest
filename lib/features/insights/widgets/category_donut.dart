import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/stats/insights_stats.dart';
import 'insights_format.dart';

/// Donut by category (design `donut()`): 140px ring, 22px stroke, 2.5px gaps, colours fixed per
/// category (`chartFor`), total in the middle. The legend always lists every slice with its
/// label, amount and percent (light slots 3–5 are under 3:1). Tapping a slice or a legend row
/// calls [onOpen]. Legend rows are the accessible targets (≥ 48dp); the ring is decorative.
/// The legend drops under the ring when it would get narrower than its text (360dp, large text).
class CategoryDonut extends StatelessWidget {
  const CategoryDonut({
    super.key,
    required this.slices,
    required this.currency,
    required this.onOpen,
    this.approx = false,
  });

  final List<CategorySlice> slices;
  final String currency;
  final bool approx;
  final ValueChanged<CategorySlice> onOpen;

  static const size = 140.0;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final total = slices.fold<double>(0, (a, s) => a + s.monthly);
    final scale = MediaQuery.textScalerOf(context).scale(14) / 14;

    final ring = SizedBox.square(
      dimension: size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) {
          final i = _hit(d.localPosition);
          if (i != null) onOpen(slices[i]);
        },
        child: ExcludeSemantics(
          child: CustomPaint(
            painter: _DonutPainter([for (final s in slices) (c.chartFor(s.category), s.share)], context.colors),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(34),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l.compactMoney(total, currency, approx: approx),
                        textScaler: TextScaler.noScaling,
                        style: AppType.label.copyWith(fontSize: 15, fontWeight: FontWeight.w700, color: c.ink).tabular,
                      ),
                      Text(
                        l.commonPerMonth,
                        textScaler: TextScaler.noScaling,
                        style: AppType.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0,
                          color: c.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    final legend = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in slices) _LegendRow(slice: s, currency: currency, approx: approx, onTap: () => onOpen(s)),
      ],
    );

    return LayoutBuilder(
      builder: (context, box) {
        final stacked = box.maxWidth - size - AppSpace.s4 < 130 * scale;
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: ring),
              const SizedBox(height: AppSpace.s3),
              legend,
            ],
          );
        }
        return Row(
          children: [
            ring,
            const SizedBox(width: AppSpace.s4),
            Expanded(child: legend),
          ],
        );
      },
    );
  }

  int? _hit(Offset p) {
    const center = Offset(size / 2, size / 2);
    final v = p - center;
    final dist = v.distance;
    if (dist < 52 - 11 - 6 || dist > 52 + 11 + 6) return null;
    // Angle from 12 o'clock, clockwise, 0…1.
    var a = (math.atan2(v.dy, v.dx) + math.pi / 2) / (2 * math.pi);
    if (a < 0) a += 1;
    var acc = 0.0;
    for (var i = 0; i < slices.length; i++) {
      acc += slices[i].share;
      if (a <= acc + 1e-9) return i;
    }
    return slices.isEmpty ? null : slices.length - 1;
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.slice, required this.currency, required this.approx, required this.onTap});

  final CategorySlice slice;
  final String currency;
  final bool approx;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final percent = (slice.share * 100).round();
    final amount = l.amount(slice.monthly, currency, approx: approx);
    return Semantics(
      button: true,
      label: l.insightsSliceLabel(l.category(slice.category), amount, percent),
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: (MediaQuery.textScalerOf(context).scale(20) - 10) / 2),
                        child: SizedBox.square(
                          dimension: 10,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: c.chartFor(slice.category),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpace.s2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(l.category(slice.category), style: AppType.label.copyWith(color: c.ink)),
                            Text(amount, style: AppType.meta.copyWith(color: c.inkMuted).tabular),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s2),
                Text('$percent%', style: AppType.label.copyWith(color: c.ink).tabular),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.parts, this.colors);

  /// (colour, share 0…1)
  final List<(Color, double)> parts;
  final AppColors colors;

  static const r = 52.0, stroke = 22.0, gap = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: r);
    if (parts.isEmpty) {
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = colors.surface2,
      );
      return;
    }
    const circumference = 2 * math.pi * r;
    var start = -math.pi / 2;
    for (final (color, share) in parts) {
      final sweep = share * 2 * math.pi;
      final visible = parts.length == 1 ? sweep : math.max(0.0, sweep - gap / circumference * 2 * math.pi);
      canvas.drawArc(
        rect,
        start,
        visible,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke
          ..color = color,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) =>
      old.colors != colors || old.parts.length != parts.length || !_same(old.parts);

  bool _same(List<(Color, double)> o) {
    for (var i = 0; i < parts.length; i++) {
      if (parts[i] != o[i]) return false;
    }
    return true;
  }
}
