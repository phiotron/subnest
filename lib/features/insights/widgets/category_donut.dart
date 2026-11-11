import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'insights_format.dart';

/// One category of the selected month / year.
class DonutSlice {
  const DonutSlice({required this.id, required this.label, required this.color, required this.minor});

  /// Category id.
  final String id;
  final String label;
  final Color color;
  final int minor;
}

/// Donut by category (design `donut()`): 132px ring, ~21px stroke with small gaps, colour per
/// category (never by rank); the legend lists every slice with %, and amount — light chart slots
/// 3–5 are under 3:1, so the labels carry the meaning. Tapping a slice or a legend row calls
/// [onOpen]; legend rows are the accessible targets (≥ 48dp), the ring is decorative. The legend
/// drops under the ring when it would get narrower than its text (360dp, large text).
class CategoryDonut extends StatelessWidget {
  const CategoryDonut({super.key, required this.slices, required this.currency, required this.onOpen});

  final List<DonutSlice> slices;
  final String currency;
  final ValueChanged<DonutSlice> onOpen;

  static const size = 132.0;

  int get _total => slices.fold(0, (a, s) => a + s.minor);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final scaler = MediaQuery.textScalerOf(context);
    double w(String t, TextStyle st) => (TextPainter(
      text: TextSpan(text: t, style: st),
      textDirection: TextDirection.ltr,
      textScaler: scaler,
      maxLines: 1,
    )..layout()).width;
    final total = _total;
    final ring = SizedBox.square(
      dimension: size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (d) {
          final i = _hit(d.localPosition, total);
          if (i != null) onOpen(slices[i]);
        },
        child: ExcludeSemantics(
          child: CustomPaint(
            painter: _DonutPainter([
              for (final s in slices) (s.color, total == 0 ? 0.0 : s.minor / total),
            ], context.colors.surface2),
          ),
        ),
      ),
    );
    final legend = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in slices) _LegendRow(slice: s, total: total, currency: currency, onTap: () => onOpen(s)),
      ],
    );
    return LayoutBuilder(
      builder: (context, box) {
        // Side by side only when the widest legend row (swatch, ≥ 48dp of name, %, amount) fits.
        final amounts = slices.map(
          (x) => w(l.minor(x.minor, currency), AppType.label.copyWith(fontWeight: FontWeight.w700)),
        );
        final need =
            10 +
            8 +
            48 * scaler.scale(14) / 14 +
            8 +
            w('88%', AppType.meta) +
            8 +
            amounts.fold(64.0, (a, b) => a > b ? a : b);
        if (box.maxWidth - size - 14 < need) {
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
            const SizedBox(width: 14),
            Expanded(child: legend),
          ],
        );
      },
    );
  }

  int? _hit(Offset p, int total) {
    if (total == 0) return null;
    const center = Offset(size / 2, size / 2);
    final v = p - center;
    final dist = v.distance;
    if (dist < _DonutPainter.r - 17 || dist > _DonutPainter.r + 17) return null;
    var a = (math.atan2(v.dy, v.dx) + math.pi / 2) / (2 * math.pi);
    if (a < 0) a += 1;
    var acc = 0.0;
    for (var i = 0; i < slices.length; i++) {
      acc += slices[i].minor / total;
      if (a <= acc + 1e-9) return i;
    }
    return slices.length - 1;
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.slice, required this.total, required this.currency, required this.onTap});

  final DonutSlice slice;
  final int total;
  final String currency;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final percent = total == 0 ? 0 : (slice.minor / total * 100).round();
    final amount = l.minor(slice.minor, currency);
    return Semantics(
      container: true,
      button: true,
      label: l.spoken(l.insightsSliceLabel(slice.label, amount, percent)),
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: AppTouch.min),
          child: LayoutBuilder(
            builder: (context, box) {
              final scaler = MediaQuery.textScalerOf(context);
              double w(String t, TextStyle st) => (TextPainter(
                text: TextSpan(text: t, style: st),
                textDirection: TextDirection.ltr,
                textScaler: scaler,
                maxLines: 1,
              )..layout()).width;
              final pct = Text('$percent%', style: AppType.meta.copyWith(color: c.inkMuted).tabular);
              final value = ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 64),
                child: Text(
                  amount,
                  textAlign: TextAlign.end,
                  style: AppType.label.copyWith(fontWeight: FontWeight.w700, color: c.ink).tabular,
                ),
              );
              final name = Text(
                slice.label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppType.body.copyWith(fontSize: 14, height: 20 / 14, color: c.ink),
              );
              final fixed =
                  10 +
                  3 * AppSpace.s2 +
                  w('$percent%', AppType.meta) +
                  w(amount, AppType.label.copyWith(fontWeight: FontWeight.w700));
              // Too narrow for a readable name (320dp, large text): % and amount go on a second line.
              final twoLines = box.maxWidth - fixed < 64 * scaler.scale(14) / 14;
              final swatch = SizedBox.square(
                dimension: 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: slice.color, borderRadius: BorderRadius.circular(3)),
                ),
              );
              if (twoLines) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      swatch,
                      const SizedBox(width: AppSpace.s2),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            name,
                            Row(children: [pct, const Spacer(), value]),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Row(
                children: [
                  swatch,
                  const SizedBox(width: AppSpace.s2),
                  Expanded(child: name),
                  const SizedBox(width: AppSpace.s2),
                  pct,
                  const SizedBox(width: AppSpace.s2),
                  value,
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.parts, this.empty);

  /// (colour, share 0…1)
  final List<(Color, double)> parts;
  final Color empty;

  static const r = 49.0, stroke = 21.0, gap = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: r);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    final visibleParts = parts.where((p) => p.$2 > 0).toList();
    if (visibleParts.isEmpty) {
      canvas.drawCircle(center, r, paint..color = empty);
      return;
    }
    const circumference = 2 * math.pi * r;
    var start = -math.pi / 2;
    for (final (color, share) in visibleParts) {
      final sweep = share * 2 * math.pi;
      final visible = visibleParts.length == 1 ? sweep : math.max(0.0, sweep - gap / circumference * 2 * math.pi);
      canvas.drawArc(rect, start, visible, false, paint..color = color);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) {
    if (old.empty != empty || old.parts.length != parts.length) return true;
    for (var i = 0; i < parts.length; i++) {
      if (parts[i] != old.parts[i]) return true;
    }
    return false;
  }
}
