import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import '../../../domain/domain.dart';
import 'insights_format.dart';

/// 12-month bar chart (design `barChart()`): `brand` solid = paid, `brand` hatch on `brand-soft`
/// stacked on top = expected / not yet confirmed. Three grid lines with compact labels on the
/// right, month initials below (the current month bold). Tap a column → tooltip with its
/// amounts, other columns dim. Every column is also a Semantics button with its numbers.
///
/// Drawn by hand (not fl_chart) to match the hatch, the top-only rounding and the axis layout.
class MonthBarChart extends StatefulWidget {
  const MonthBarChart({
    super.key,
    required this.series,
    required this.current,
    required this.currency,
    this.approx = false,
  });

  final List<MonthSpending> series;

  /// First day of today's month (bold label).
  final LocalDate current;
  final String currency;
  final bool approx;

  static const chartHeight = 150.0;

  @override
  State<MonthBarChart> createState() => _MonthBarChartState();
}

class _MonthBarChartState extends State<MonthBarChart> {
  int? _selected;

  @override
  void didUpdateWidget(MonthBarChart old) {
    super.didUpdateWidget(old);
    if (old.series.length != widget.series.length || old.series.first.month != widget.series.first.month) {
      _selected = null;
    }
  }

  String _tip(AppLocalizations l, MonthSpending m) {
    final parts = <String>[
      if (m.actual > 0 || m.projected <= 0)
        l.insightsTipPaid(l.amount(m.actual, widget.currency, approx: widget.approx)),
      if (m.projected > 0) l.insightsTipExpected(l.amount(m.projected, widget.currency, approx: widget.approx)),
    ];
    return '${l.shortMonth(m.month)} · ${parts.join(' · ')}';
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final scaler = MediaQuery.textScalerOf(context);
    final axisStyle = AppType.caption.copyWith(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 0,
      color: c.inkMuted,
    );
    final labelH = scaler.scale(10) * 1.3;
    final topPad = labelH + 4;
    final bottomPad = labelH + 8;
    final max = widget.series.fold<double>(0, (a, m) => math.max(a, m.actual + m.projected));
    final ticks = niceTicks(max);
    final series = widget.series;

    return LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final slot = w / series.length;
        final sel = _selected;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(
              container: true,
              label: l.insightsChartLabel(l.shortMonth(series.first.month), l.shortMonth(series.last.month)),
              child: SizedBox(
                height: topPad + MonthBarChart.chartHeight + bottomPad,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _BarsPainter(
                          series: series,
                          ticks: ticks,
                          current: widget.current,
                          selected: sel,
                          colors: c,
                          axisStyle: axisStyle,
                          scaler: scaler,
                          tickLabel: l.compactNumber,
                          barLabel: l.barLabel,
                          topPad: topPad,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < series.length; i++)
                          Expanded(
                            child: Semantics(
                              button: true,
                              selected: sel == i,
                              label: l.spoken(_tip(l, series[i])),
                              excludeSemantics: true,
                              onTap: () => setState(() => _selected = sel == i ? null : i),
                              child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () => setState(() => _selected = sel == i ? null : i),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (sel != null)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Align(
                            alignment: Alignment((((sel + .5) * slot) / w * 2 - 1).clamp(-1.0, 1.0), 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: c.ink,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                _tip(l, series[sel]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppType.caption.copyWith(letterSpacing: 0, color: c.bg).tabular,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required this.series,
    required this.ticks,
    required this.current,
    required this.selected,
    required this.colors,
    required this.axisStyle,
    required this.scaler,
    required this.tickLabel,
    required this.barLabel,
    required this.topPad,
  });

  final List<MonthSpending> series;
  final List<double> ticks;
  final LocalDate current;
  final int? selected;
  final AppColors colors;
  final TextStyle axisStyle;
  final TextScaler scaler;
  final String Function(double) tickLabel;
  final String Function(LocalDate) barLabel;
  final double topPad;

  @override
  void paint(Canvas canvas, Size size) {
    const h = MonthBarChart.chartHeight;
    final w = size.width;
    final base = topPad + h;
    final top = ticks.isEmpty ? 1.0 : ticks.last;
    double y(double v) => base - v / top * h;

    final grid = Paint()
      ..color = colors.line
      ..strokeWidth = 1;
    for (final t in ticks) {
      final ty = y(t).roundToDouble() + .5;
      canvas.drawLine(Offset(0, ty), Offset(w, ty), grid);
    }

    final slot = w / series.length;
    final bw = math.min(18.0, slot * .66);
    for (var i = 0; i < series.length; i++) {
      final m = series[i];
      final x = i * slot + (slot - bw) / 2;
      final dim = selected != null && selected != i;
      final a = m.actual / top * h, p = m.projected / top * h;
      canvas.saveLayer(
        Rect.fromLTWH(x - 1, topPad - 2, bw + 2, h + 4),
        Paint()..color = Color.fromRGBO(0, 0, 0, dim ? .35 : 1),
      );
      if (a > 0) {
        final r = Rect.fromLTWH(x, base - a, bw, a);
        canvas.drawRRect(_topRounded(r, p > 0 ? 0 : 4), Paint()..color = colors.brand);
      }
      if (p > 0) {
        final r = Rect.fromLTWH(x, base - a - p, bw, p);
        final rr = _topRounded(r, 4);
        canvas.save();
        canvas.clipRRect(rr);
        canvas.drawRect(r, Paint()..color = colors.brandSoft);
        final line = Paint()
          ..color = colors.brand
          ..strokeWidth = 2;
        for (var d = -r.height; d < r.width + r.height; d += 6) {
          canvas.drawLine(Offset(r.left + d, r.bottom), Offset(r.left + d + r.height, r.top), line);
        }
        canvas.restore();
        canvas.drawRRect(
          rr.deflate(.5),
          Paint()
            ..style = PaintingStyle.stroke
            ..color = colors.brand
            ..strokeWidth = 1,
        );
      }
      canvas.restore();

      final isCurrent = m.month == current;
      final lp = _text(
        barLabel(m.month),
        axisStyle.copyWith(
          color: isCurrent ? colors.ink : colors.inkMuted,
          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
        ),
      );
      lp.paint(canvas, Offset(x + bw / 2 - lp.width / 2, base + 6));
    }

    canvas.drawLine(
      Offset(0, base + .5),
      Offset(w, base + .5),
      Paint()
        ..color = colors.lineStrong
        ..strokeWidth = 1,
    );

    // Tick labels last, on a card-coloured chip: the right-most bar used to hide them
    // (real phone: "500k" showed only as "k" behind a tall current-month bar).
    for (final t in ticks) {
      final ty = y(t).roundToDouble() + .5;
      final tp = _text(tickLabel(t), axisStyle);
      final at = Offset(w - tp.width, ty - 4 - tp.height);
      canvas.drawRRect(
        RRect.fromRectAndRadius((at & tp.size).inflate(2), const Radius.circular(4)),
        Paint()..color = colors.surface,
      );
      tp.paint(canvas, at);
    }
  }

  static RRect _topRounded(Rect r, double radius) {
    final rad = Radius.circular(math.min(radius, math.min(r.width / 2, r.height)));
    return RRect.fromRectAndCorners(r, topLeft: rad, topRight: rad);
  }

  TextPainter _text(String s, TextStyle style) => TextPainter(
    text: TextSpan(text: s, style: style),
    textDirection: TextDirection.ltr,
    textScaler: scaler,
  )..layout();

  @override
  bool shouldRepaint(_BarsPainter old) =>
      old.series != series ||
      old.selected != selected ||
      old.colors != colors ||
      old.scaler != scaler ||
      old.ticks != ticks;
}

/// 12px legend swatch: solid `brand`, or the hatch used for expected amounts.
class ChartSwatch extends StatelessWidget {
  const ChartSwatch({super.key, this.hatch = false});

  final bool hatch;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(width: 12, height: 12, child: CustomPaint(painter: _SwatchPainter(c, hatch)));
  }
}

class _SwatchPainter extends CustomPainter {
  _SwatchPainter(this.c, this.hatch);

  final AppColors c;
  final bool hatch;

  @override
  void paint(Canvas canvas, Size size) {
    final rr = RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(3));
    if (!hatch) {
      canvas.drawRRect(rr, Paint()..color = c.brand);
      return;
    }
    canvas.save();
    canvas.clipRRect(rr);
    canvas.drawRect(Offset.zero & size, Paint()..color = c.brandSoft);
    final line = Paint()
      ..color = c.brand
      ..strokeWidth = 2;
    for (var d = -size.height; d < size.width + size.height; d += 5) {
      canvas.drawLine(Offset(d, size.height), Offset(d + size.height, 0), line);
    }
    canvas.restore();
    canvas.drawRRect(
      rr.deflate(.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..color = c.brand
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_SwatchPainter old) => old.c != c || old.hatch != hatch;
}
