import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_button.dart';
import 'app_icons.dart';

enum BannerKind {
  /// `warning-soft` — awaiting confirmation, trial ending.
  warning,

  /// `brand-soft` — tips, info notes.
  info,

  /// `success-soft` — paid, savings.
  success,

  /// `danger-soft` — errors that need attention.
  danger,

  /// `surface` card with shadow — reminders off, offline rates.
  neutral,
}

/// Banner (design Components › Banner): 20px icon, title (label 14/600) + optional body (meta),
/// optional pill action. When the line is too narrow for the text (< 170px beside the action —
/// VI, 360 width, 130% text) the action drops under the text, right-aligned.
class AppBanner extends StatelessWidget {
  const AppBanner({
    super.key,
    required this.kind,
    required this.icon,
    required this.title,
    this.body,
    this.actionLabel,
    this.onAction,
  });

  final BannerKind kind;
  final IconData icon;
  final String title;
  final String? body;
  final String? actionLabel;
  final VoidCallback? onAction;

  static const _minTextWidth = 170.0;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg, titleColor, bodyColor) = switch (kind) {
      BannerKind.warning => (c.warningSoft, c.warningInk, c.ink, c.warningInk),
      BannerKind.info => (c.brandSoft, c.onBrandSoft, c.onBrandSoft, c.onBrandSoft),
      BannerKind.success => (c.successSoft, c.success, c.ink, c.success),
      BannerKind.danger => (c.dangerSoft, c.danger, c.danger, c.danger),
      BannerKind.neutral => (c.surface, c.inkMuted, c.ink, c.inkMuted),
    };
    final actionBg = kind == BannerKind.neutral ? c.brandSoft : c.surface;
    final actionFg = kind == BannerKind.neutral ? c.onBrandSoft : fg;
    final actionStyle = AppType.label.copyWith(color: actionFg);

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: AppType.label.copyWith(color: titleColor)),
        if (body != null) ...[
          const SizedBox(height: 2),
          Text(body!, style: AppType.meta.copyWith(color: bodyColor)),
        ],
      ],
    );

    Widget? action;
    if (actionLabel != null) {
      action = Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onAction,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: ShapeDecoration(color: actionBg, shape: const StadiumBorder()),
              child: Text(actionLabel!, style: actionStyle, maxLines: 1, softWrap: false),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: kind == BannerKind.neutral ? context.elevation.card : null,
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final iconPart = Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 20, color: fg),
          );
          if (action == null) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [iconPart, const SizedBox(width: AppSpace.s3), Expanded(child: text)],
            );
          }
          final tp = TextPainter(
            text: TextSpan(text: actionLabel, style: actionStyle),
            textDirection: Directionality.of(context),
            textScaler: MediaQuery.textScalerOf(context),
            maxLines: 1,
          )..layout();
          final actionWidth = tp.width + 28;
          tp.dispose();
          final room = box.maxWidth - 20 - AppSpace.s3 * 2 - actionWidth;
          if (room >= _minTextWidth) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                iconPart,
                const SizedBox(width: AppSpace.s3),
                Expanded(child: text),
                const SizedBox(width: AppSpace.s3),
                Align(alignment: Alignment.center, child: action),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [iconPart, const SizedBox(width: AppSpace.s3), Expanded(child: text)],
              ),
              const SizedBox(height: 6),
              Align(alignment: AlignmentDirectional.centerEnd, child: action),
            ],
          );
        },
      ),
    );
  }
}

/// Empty state (design Components › EmptyState): illustration, title (20/600), body (muted,
/// ≤ 290 wide), optional primary action with icon.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.body,
    this.art = const NestArt(kind: NestArtKind.nest),
    this.actionLabel,
    this.actionIcon = AppIcons.add,
    this.onAction,
  });

  final String title;
  final String? body;

  /// Usually a [NestArt]; `null` for none.
  final Widget? art;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s8, AppSpace.s4, AppSpace.s6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ?art,
          const SizedBox(height: AppSpace.s4 + AppSpace.s2),
          Text(title, style: AppType.title.copyWith(color: c.ink), textAlign: TextAlign.center),
          if (body != null) ...[
            const SizedBox(height: AppSpace.s2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 290),
              child: Text(body!, style: AppType.body.copyWith(color: c.inkMuted), textAlign: TextAlign.center),
            ),
          ],
          if (actionLabel != null) ...[
            const SizedBox(height: AppSpace.s4 + AppSpace.s2),
            AppButton(label: actionLabel!, icon: actionIcon, onPressed: onAction),
          ],
        ],
      ),
    );
  }
}

enum NestArtKind {
  /// Nest holding three tiles (generic empty state).
  nest,

  /// Empty nest with a dashed "+" tile (no subscriptions yet).
  empty,

  /// Nest with sparkles (all caught up 🎉).
  party,

  /// Nest with bars (no insights yet).
  chart,

  /// Seven tiles (onboarding welcome).
  welcome,
}

/// The mockup's token-coloured nest illustration (`art()` in design/system/bundle.js), drawn
/// with a CustomPainter so it follows light/dark. Width defaults to 160.
class NestArt extends StatelessWidget {
  const NestArt({super.key, this.kind = NestArtKind.nest, this.width = 160});

  final NestArtKind kind;
  final double width;

  double get _viewHeight => (kind == NestArtKind.welcome ? 96 : 84) + 52;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(
      size: Size(width, width * _viewHeight / 200),
      painter: _NestPainter(kind, context.colors),
    ),
  );
}

class _NestPainter extends CustomPainter {
  _NestPainter(this.kind, this.c);

  final NestArtKind kind;
  final AppColors c;

  // [colour, text, x, y, size, rotation°, darkText]
  static const _three = [
    (0xFFE50914, 'N', 52.0, 46.0, 30.0, -12.0, false),
    (0xFF1DB954, 'S', 85.0, 36.0, 32.0, 6.0, true),
    (0xFF202123, 'C', 118.0, 48.0, 28.0, 12.0, false),
  ];
  static const _seven = [
    (0xFFE50914, 'N', 44.0, 34.0, 34.0, -12.0, false),
    (0xFF1DB954, 'S', 82.0, 20.0, 38.0, 6.0, true),
    (0xFF202123, 'C', 124.0, 36.0, 32.0, 14.0, false),
    (0xFF2A72D4, 'iC', 62.0, 62.0, 28.0, -4.0, false),
    (0xFF7D2AE8, 'C', 104.0, 64.0, 26.0, 10.0, false),
    (0xFF58CC02, 'D', 140.0, 4.0, 22.0, 18.0, true),
    (0xFFE6002E, 'YT', 30.0, 0.0, 22.0, -16.0, false),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 200;
    canvas.scale(s);
    final y0 = kind == NestArtKind.welcome ? 96.0 : 84.0;

    // rim
    canvas.drawOval(
      Rect.fromCenter(center: Offset(100, y0), width: 152, height: 28),
      Paint()..color = c.onBrandSoft.withValues(alpha: .35),
    );

    // extras
    switch (kind) {
      case NestArtKind.empty:
        final dash = Paint()
          ..color = c.lineStrong
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        _dashed(canvas, Path()..addRRect(RRect.fromLTRBR(84, 44, 116, 76, const Radius.circular(9))), dash);
        final plus = Paint()
          ..color = c.lineStrong
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        canvas
          ..drawLine(const Offset(100, 53), const Offset(100, 67), plus)
          ..drawLine(const Offset(93, 60), const Offset(107, 60), plus);
      case NestArtKind.party:
        _spark(canvas, const Offset(34, 30), 11, c.warning);
        _spark(canvas, const Offset(166, 22), 8, c.brand);
        _spark(canvas, const Offset(150, 59.5), 5.5, c.brand);
        canvas
          ..drawCircle(const Offset(58, 12), 3, Paint()..color = c.warning)
          ..drawCircle(const Offset(132, 8), 2.5, Paint()..color = c.brand);
      case NestArtKind.chart:
        final bar = Paint()..color = c.brand;
        canvas
          ..drawRRect(RRect.fromLTRBR(64, 40, 80, 84, const Radius.circular(4)), bar)
          ..drawRRect(RRect.fromLTRBR(92, 18, 108, 84, const Radius.circular(4)), bar)
          ..drawRRect(
            RRect.fromLTRBR(120, 52, 136, 84, const Radius.circular(4)),
            Paint()..color = c.onBrandSoft.withValues(alpha: .5),
          );
      case NestArtKind.nest || NestArtKind.welcome:
        break;
    }

    // tiles
    final tiles = switch (kind) {
      NestArtKind.welcome => _seven,
      NestArtKind.nest || NestArtKind.party => _three,
      _ => const <(int, String, double, double, double, double, bool)>[],
    };
    for (final (color, label, x, y, side, rot, darkText) in tiles) {
      final cx = x + side / 2, cy = y + side / 2;
      canvas
        ..save()
        ..translate(cx, cy)
        ..rotate(rot * math.pi / 180)
        ..drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: side, height: side),
            Radius.circular(side * .27),
          ),
          Paint()..color = Color(color),
        );
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: TextStyle(
            fontFamily: AppType.fontFamily,
            fontWeight: FontWeight.w700,
            fontSize: side * (label.length > 1 ? .38 : .48),
            color: darkText ? const Color(0xFF0D1113) : const Color(0xFFFFFFFF),
            height: 1,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      tp.dispose();
      canvas.restore();
    }

    // bowl
    final bowl = Path()
      ..moveTo(24, y0)
      ..arcToPoint(Offset(176, y0), radius: const Radius.elliptical(76, 14), clockwise: false)
      ..cubicTo(176, y0 + 34, 142, y0 + 48, 100, y0 + 48)
      ..cubicTo(58, y0 + 48, 24, y0 + 34, 24, y0)
      ..close();
    canvas.drawPath(bowl, Paint()..color = c.brand);

    // weave
    final weave = Path()
      ..moveTo(36, y0 + 20)
      ..cubicTo(70, y0 + 34, 130, y0 + 34, 164, y0 + 20)
      ..moveTo(54, y0 + 36)
      ..cubicTo(84, y0 + 44, 116, y0 + 44, 146, y0 + 36);
    canvas.drawPath(
      weave,
      Paint()
        ..color = c.onBrand.withValues(alpha: .28)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
  }

  void _spark(Canvas canvas, Offset o, double r, Color color) {
    final k = r * 0.27;
    final p = Path()
      ..moveTo(o.dx, o.dy - r)
      ..lineTo(o.dx + k, o.dy - k)
      ..lineTo(o.dx + r, o.dy)
      ..lineTo(o.dx + k, o.dy + k)
      ..lineTo(o.dx, o.dy + r)
      ..lineTo(o.dx - k, o.dy + k)
      ..lineTo(o.dx - r, o.dy)
      ..lineTo(o.dx - k, o.dy - k)
      ..close();
    canvas.drawPath(p, Paint()..color = color);
  }

  void _dashed(Canvas canvas, Path path, Paint paint) {
    for (final m in path.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, math.min(d + 5, m.length)), paint);
        d += 9;
      }
    }
  }

  @override
  bool shouldRepaint(_NestPainter old) => old.kind != kind || old.c != c;
}
