import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../home/widgets/overview_cards.dart';

/// S5 "cancelled" moment (png 33): confetti falls once (1.4 s; none under reduce-motion), the
/// party nest, "+₫1,390,000 a year saved", the new savings total and "See cancelled".
class CelebrateScreen extends StatefulWidget {
  const CelebrateScreen({
    super.key,
    required this.name,
    required this.savedYearly,
    required this.totalYearly,
    required this.onSeeCancelled,
  });

  final String name;

  /// "₫1,390,000" (formatted, may start with "≈ ").
  final String savedYearly;

  /// "₫2,869,000" — savings after this cancellation.
  final String totalYearly;
  final VoidCallback onSeeCancelled;

  @override
  State<CelebrateScreen> createState() => _CelebrateScreenState();
}

class _CelebrateScreenState extends State<CelebrateScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _fall = AnimationController(vsync: this, duration: AppMotion.confetti);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!AppMotion.reduced(context) && !_fall.isAnimating && _fall.value == 0) _fall.forward();
  }

  @override
  void dispose() {
    _fall.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Scaffold(
      backgroundColor: c.bg,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _fall,
                builder: (context, _) => CustomPaint(painter: _ConfettiPainter(_fall.value, c)),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.s5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpace.s10 + AppSpace.s10),
                          const NestArt(kind: NestArtKind.party, width: 200),
                          const SizedBox(height: AppSpace.s2),
                          Text(
                            l.subscriptionDetailCelebrateCancelled(widget.name),
                            textAlign: TextAlign.center,
                            style: AppType.meta.copyWith(color: c.inkMuted),
                          ),
                          const SizedBox(height: AppSpace.s4),
                          Semantics(
                            liveRegion: true,
                            child: TextScaleCap(
                              max: AppTextScale.display,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '+${widget.savedYearly}',
                                  maxLines: 1,
                                  style: AppType.display.copyWith(color: c.success).tabular,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            l.subscriptionDetailCelebrateYear,
                            textAlign: TextAlign.center,
                            style: AppType.titleSm.copyWith(color: c.inkMuted),
                          ),
                          const SizedBox(height: AppSpace.s6),
                          SavingsCard(
                            label: l.subscriptionDetailCelebrateNow,
                            amount: l.subscriptionDetailPerYear(widget.totalYearly),
                          ),
                          const SizedBox(height: AppSpace.s6),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpace.s4),
                    child: AppButton.primary(
                      label: l.subscriptionDetailSeeCancelled,
                      expand: true,
                      onPressed: widget.onSeeCancelled,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.t, this.c);

  final double t;
  final AppColors c;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0 || t >= 1) return;
    final colors = [c.brand, c.warning, c.success, c.onBrandSoft];
    final paint = Paint();
    for (var i = 0; i < 26; i++) {
      final delay = (i % 7) * 0.043;
      final p = ((t - delay) / (1 - delay)).clamp(0.0, 1.0);
      if (p <= 0) continue;
      final x = size.width * ((i * 37) % 100) / 100;
      final y = -12 + (size.height * 0.75) * Curves.easeIn.transform(p);
      final angle = ((i * 47) % 180) * math.pi / 180 + p * math.pi * 2;
      paint.color = colors[i % 4].withValues(alpha: 1 - math.max(0, p - 0.8) * 5);
      canvas
        ..save()
        ..translate(x, y)
        ..rotate(angle)
        ..drawRRect(RRect.fromRectAndRadius(const Rect.fromLTWH(-4, -6, 8, 12), const Radius.circular(2)), paint)
        ..restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.t != t || old.c != c;
}
