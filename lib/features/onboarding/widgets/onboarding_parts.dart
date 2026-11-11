import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';

/// Layout shared by the S1 steps (design `.ob`): progress bar (+ Skip) on top, scrollable
/// [body], fixed [footer] at the bottom. Never overflows at 200% text: only the body scrolls.
class OnboardingStepScaffold extends StatelessWidget {
  const OnboardingStepScaffold({
    super.key,
    required this.step,
    required this.body,
    required this.footer,
    this.onSkip,
    this.scrollBody = true,
  });

  /// 1-based step (of [OnboardingProgress.total]).
  final int step;
  final Widget body;
  final Widget footer;
  final VoidCallback? onSkip;

  /// `false` when [body] scrolls by itself (the service grid).
  final bool scrollBody;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingProgress(step: step, onSkip: onSkip),
          Expanded(
            child: scrollBody
                ? SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpace.s5),
                    child: body,
                  )
                : body,
          ),
          footer,
        ],
      ),
    );
  }
}

/// Four-segment progress bar + "Skip" (design `ob-top`). The bar reads as "Step 2 of 4".
class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({super.key, required this.step, this.onSkip});

  static const total = 5;

  final int step;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpace.s5, AppSpace.s2, AppSpace.s3, AppSpace.s2),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              label: l.onboardingStep(step, total),
              excludeSemantics: true,
              child: Row(
                children: [
                  for (var i = 1; i <= total; i++) ...[
                    if (i > 1) const SizedBox(width: 6),
                    Expanded(
                      child: AnimatedContainer(
                        duration: AppMotion.of(context, AppMotion.fast),
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= step ? c.brand : c.surface2,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: AppSpace.s4),
          // Keeps the bar the same width on every step, with or without Skip.
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 64, minHeight: 48),
            child: onSkip == null
                ? null
                : TextButton(
                    onPressed: onSkip,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(64, 48),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(l.onboardingSkip, style: AppType.label.copyWith(color: c.brand)),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Bottom area with the primary action(s): 20px sides, 16px below.
class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpace.s5, AppSpace.s3, AppSpace.s5, AppSpace.s4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[if (i > 0) const SizedBox(height: AppSpace.s2), children[i]],
      ],
    ),
  );
}

/// Step title (`headline`, grows ≤ 32px).
class OnboardingTitle extends StatelessWidget {
  const OnboardingTitle(this.text, {super.key, this.center = false});

  final String text;
  final bool center;

  @override
  Widget build(BuildContext context) => Semantics(
    header: true,
    child: Text(
      text,
      textAlign: center ? TextAlign.center : TextAlign.start,
      textScaler: AppTextScale.capped(context, AppTextScale.headline),
      style: AppType.headline.copyWith(color: context.colors.ink),
    ),
  );
}

/// One choice in an onboarding list (design `.srow` in a `.group`, png 005/008): 36px badge
/// (`surface-2`, bold text) · title + meta · ✓ circle when selected, empty radio otherwise.
class OnboardingChoiceRow extends StatelessWidget {
  const OnboardingChoiceRow({
    super.key,
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String badge;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      button: true,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
            child: Row(
              children: [
                ExcludeSemantics(child: OnboardingBadge(badge)),
                const SizedBox(width: AppSpace.s3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppType.body.copyWith(color: c.ink, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpace.s3),
                selected ? const CheckCircle() : const _EmptyRadio(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 36px square badge with a code or symbol (design `.cur-badge`).
class OnboardingBadge extends StatelessWidget {
  const OnboardingBadge(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Text(
        text,
        maxLines: 1,
        textScaler: TextScaler.noScaling,
        style: AppType.label.copyWith(color: c.ink, fontWeight: FontWeight.w700, fontSize: 15).tabular,
      ),
    );
  }
}

/// `brand` circle with a check (design `.check-c`).
class CheckCircle extends StatelessWidget {
  const CheckCircle({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: c.brand, shape: BoxShape.circle),
      child: Icon(AppIcons.check, size: size * .62, color: c.onBrand),
    );
  }
}

class _EmptyRadio extends StatelessWidget {
  const _EmptyRadio();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(3),
    child: Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.colors.lineStrong, width: 2),
      ),
    ),
  );
}

/// The Subnest mark (app icon in miniature: three tiles over a mint nest on the teal field).
/// Fixed brand colours like the real icon — not theme-dependent.
class SubnestMark extends StatelessWidget {
  const SubnestMark({super.key, this.size = 38});

  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: CustomPaint(size: Size.square(size), painter: _MarkPainter()),
  );
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const t = AppColors.light;
    final s = size.width;
    final field = RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(s * .24));
    canvas.drawRRect(field, Paint()..color = t.brand);
    void tile(double x, double y, double w, Color color, double angle) {
      canvas.save();
      canvas.translate(s * x, s * y);
      canvas.rotate(angle);
      final r = RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: s * w, height: s * w),
        Radius.circular(s * w * .28),
      );
      canvas.drawRRect(r, Paint()..color = color);
      canvas.restore();
    }

    tile(.36, .44, .26, t.tileSky, -.18);
    tile(.64, .42, .26, t.tileOrange, .16);
    tile(.5, .36, .26, t.surface, 0);
    final bowl = Path()
      ..moveTo(s * .16, s * .55)
      ..quadraticBezierTo(s * .5, s * 1.02, s * .84, s * .55)
      ..close();
    canvas.drawPath(bowl, Paint()..color = t.brandSoft);
    canvas.drawPath(
      Path()
        ..moveTo(s * .26, s * .66)
        ..quadraticBezierTo(s * .5, s * .78, s * .74, s * .66),
      Paint()
        ..color = t.brand.withValues(alpha: .35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * .04
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
