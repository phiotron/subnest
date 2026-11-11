import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';

/// 063 "cancelled" moment: confetti falls once (1.4 s; none under reduce-motion), the party nest,
/// "Nice — that's $215.88 a year saved", a reminder to cancel with the provider too (Subnest can't),
/// the Total saving card ("from 3 cancelled subscriptions"), then Done · Undo.
class CelebrateScreen extends StatefulWidget {
  const CelebrateScreen({
    super.key,
    required this.name,
    required this.savedYearly,
    required this.totalYearly,
    required this.cancelledCount,
    required this.host,
    required this.onDone,
    required this.onUndo,
  });

  final String name;

  /// "$215.88" (formatted, may start with "≈ ").
  final String savedYearly;

  /// "$191.87" — savings after this cancellation.
  final String totalYearly;
  final int cancelledCount;

  /// "canva.com" — where to cancel for real; `null` = no known link.
  final String? host;
  final VoidCallback onDone;
  final VoidCallback onUndo;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpace.s1, top: AppSpace.s1),
                    child: AppIconButton(
                      icon: AppIcons.close,
                      tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                      onPressed: widget.onDone,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpace.s6),
                        const NestArt(kind: NestArtKind.party, width: 220),
                        const SizedBox(height: AppSpace.s2),
                        Semantics(
                          header: true,
                          liveRegion: true,
                          child: Text(
                            l.subscriptionDetailCelebrateTitle(widget.savedYearly),
                            textAlign: TextAlign.center,
                            style: AppType.headline.copyWith(color: c.ink),
                            textScaler: AppTextScale.capped(context, AppTextScale.headline),
                          ),
                        ),
                        const SizedBox(height: AppSpace.s2),
                        Text(
                          widget.host == null
                              ? l.subscriptionDetailCelebrateBodyNoHost(widget.name)
                              : l.subscriptionDetailCelebrateBody(widget.name, widget.host!),
                          textAlign: TextAlign.center,
                          style: AppType.body.copyWith(color: c.inkMuted),
                        ),
                        const SizedBox(height: AppSpace.s4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
                          decoration: BoxDecoration(color: c.successSoft, borderRadius: BorderRadius.circular(16)),
                          child: MergeSemantics(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(l.subscriptionDetailTotalSaving, style: AppType.meta.copyWith(color: c.success)),
                                const SizedBox(height: 2),
                                Text(
                                  l.subscriptionDetailPerYear(widget.totalYearly),
                                  textAlign: TextAlign.center,
                                  semanticsLabel: l.spokenLabel(l.subscriptionDetailPerYear(widget.totalYearly)),
                                  style: AppType.title.copyWith(color: c.success).tabular,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  l.subscriptionDetailFromCancelled(widget.cancelledCount),
                                  textAlign: TextAlign.center,
                                  style: AppType.meta.copyWith(color: c.success),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpace.s6),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpace.s6, 0, AppSpace.s6, AppSpace.s6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppButton.primary(label: l.subscriptionDetailDone, expand: true, onPressed: widget.onDone),
                      const SizedBox(height: AppSpace.s2),
                      AppButton.text(label: l.subscriptionDetailUndo, expand: true, onPressed: widget.onUndo),
                    ],
                  ),
                ),
              ],
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
