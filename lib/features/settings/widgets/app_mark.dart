import 'package:flutter/material.dart';

/// The Subnest app icon (mint nest holding three tiles on the teal field), drawn from the same
/// geometry as `design/brand` / the mockups' `mark()`. Used in the reminder preview and on the
/// licence page. Fixed brand colours on purpose — the icon does not follow the theme
/// (design README › App icon), so they are not tokens.
class AppMark extends StatelessWidget {
  const AppMark({super.key, this.size = 38, this.radius = 9});

  final double size;

  /// Corner radius at this size (the mockup notifications use 9px at 38).
  final double radius;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CustomPaint(size: Size.square(size), painter: const _MarkPainter()),
    ),
  );
}

class _MarkPainter extends CustomPainter {
  const _MarkPainter();

  static const _field = Color(0xFF0E6B63);
  static const _shadow = Color(0xFF0A4F49);
  static const _mint = Color(0xFF8FE8D9);
  static const _amber = Color(0xFFF5A524);
  static const _white = Color(0xFFFFFFFF);
  static const _nest = Color(0xFF46CDB9);
  static const _weave = Color(0xFF2FAE9C);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 1024);
    final p = Paint()..isAntiAlias = true;
    canvas.drawRect(const Rect.fromLTWH(0, 0, 1024, 1024), p..color = _field);
    canvas.drawOval(Rect.fromCenter(center: const Offset(512, 566), width: 600, height: 128), p..color = _shadow);
    void tile(double x, double y, double s, double r, double deg, Color color) {
      canvas.save();
      final c = Offset(x + s / 2, y + s / 2);
      canvas.translate(c.dx, c.dy);
      canvas.rotate(deg * 3.141592653589793 / 180);
      canvas.drawRRect(
        RRect.fromRectAndRadius(Rect.fromCenter(center: Offset.zero, width: s, height: s), Radius.circular(r)),
        p..color = color,
      );
      canvas.restore();
    }

    tile(252, 332, 210, 58, -12, _mint);
    tile(562, 332, 210, 58, 12, _amber);
    tile(397, 262, 230, 64, 0, _white);
    // Nest bowl: the lower half of the 300×64 ellipse plus a deep curve to y=800.
    final bowl = Path()
      ..moveTo(212, 566)
      ..arcTo(
        Rect.fromCenter(center: const Offset(512, 566), width: 600, height: 128),
        3.141592653589793,
        -3.141592653589793,
        false,
      )
      ..cubicTo(812, 712, 676, 800, 512, 800)
      ..cubicTo(348, 800, 212, 712, 212, 566)
      ..close();
    canvas.drawPath(bowl, p..color = _nest);
    final weave = Path()
      ..moveTo(262, 650)
      ..cubicTo(380, 712, 644, 712, 762, 650)
      ..moveTo(322, 734)
      ..cubicTo(420, 770, 604, 770, 702, 734);
    canvas.drawPath(
      weave,
      Paint()
        ..isAntiAlias = true
        ..color = _weave
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
