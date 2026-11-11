import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';
import 'insights_format.dart';

/// Card of S9 (design `.card.c-*`): 14/16 padding, 12 below.
class StatsCard extends StatelessWidget {
  const StatsCard({super.key, required this.child, this.color});

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpace.s3),
    child: AppCard(color: color, padding: const EdgeInsets.fromLTRB(AppSpace.s4, 14, AppSpace.s4, 14), child: child),
  );
}

/// Card header (design `.ch-h`): label (+ icon) left, [trailing] right; wraps when there is no room.
class StatsCardHeader extends StatelessWidget {
  const StatsCardHeader({super.key, required this.title, this.icon, this.iconColor, this.trailing});

  final String title;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final label = Semantics(
      header: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 18, color: iconColor ?? c.ink), const SizedBox(width: 6)],
          Flexible(
            child: Text(title, style: AppType.label.copyWith(color: c.ink)),
          ),
        ],
      ),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: trailing == null
          ? Align(alignment: AlignmentDirectional.centerStart, child: label)
          : Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpace.s2,
              runSpacing: AppSpace.s1,
              children: [label, trailing!],
            ),
    );
  }
}

/// Muted hint text on the right of a card header ("Tap a bar", "November 2026").
class StatsHint extends StatelessWidget {
  const StatsHint(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(text, style: AppType.meta.copyWith(color: context.colors.inkMuted));
}

/// Change against the period before (design `delta()`): ↓ `success` · ↑ `warning` · = muted.
class ChangeChip extends StatelessWidget {
  const ChangeChip({
    super.key,
    required this.changeMinor,
    required this.currency,
    required this.vs,
    required this.same,
  });

  final int changeMinor;
  final String currency;

  /// "vs Oct" / "so với thg 10".
  final String vs;

  /// "Same as Oct" / "Bằng thg 10".
  final String same;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final amount = l.minor(changeMinor.abs(), currency);
    final (bg, fg, icon, text, dir) = switch (changeMinor.sign) {
      0 => (c.surface2, c.inkMuted, LucideIcons.equal, same, 'same'),
      1 => (c.warningSoft, c.warningInk, LucideIcons.arrowUp, '$amount $vs', 'up'),
      _ => (c.successSoft, c.success, LucideIcons.arrowDown, '$amount $vs', 'down'),
    };
    return Semantics(
      container: true,
      label: changeMinor == 0 ? same : l.insightsChangeLabel(dir, amount, vs),
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 24),
        padding: const EdgeInsets.fromLTRB(6, 2, 9, 2),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: fg),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                text,
                style: AppType.caption
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0, color: fg)
                    .tabular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Projected" tag for a month still ahead (design `.proj-tag`: brand-soft hatch, brand edge).
class ProjectedTag extends StatelessWidget {
  const ProjectedTag({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.brand),
        color: c.surface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.sparkles, size: 12, color: c.onBrandSoft),
          const SizedBox(width: 4),
          Text(
            context.l10n.insightsProjected,
            style: AppType.caption.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
              color: c.onBrandSoft,
            ),
          ),
        ],
      ),
    );
  }
}

/// 135° `brand` hatch (design "Still to pay" / projected): 2px stripes every 5px on `brand` 22% over
/// [ground]; [outline] draws a 1px edge and leaves the gaps clear (future bars).
class HatchPainter extends CustomPainter {
  const HatchPainter({required this.color, required this.ground, this.outline = false, this.radius = 0});

  final Color color;
  final Color ground;
  final bool outline;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rr = RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(radius),
      topRight: Radius.circular(radius),
      bottomLeft: Radius.circular(radius > 2 ? 2 : radius),
      bottomRight: Radius.circular(radius > 2 ? 2 : radius),
    );
    canvas.save();
    canvas.clipRRect(rr);
    if (!outline) canvas.drawRect(rect, Paint()..color = Color.lerp(ground, color, .22)!);
    final stripe = Paint()
      ..color = outline ? color.withValues(alpha: .55) : color
      ..strokeWidth = 2;
    for (var x = -size.height; x < size.width + size.height; x += 5) {
      canvas.drawLine(Offset(x, size.height), Offset(x + size.height, 0), stripe);
    }
    canvas.restore();
    if (outline) {
      canvas.drawRRect(
        rr.deflate(.5),
        Paint()
          ..style = PaintingStyle.stroke
          ..color = color.withValues(alpha: .55),
      );
    }
  }

  @override
  bool shouldRepaint(HatchPainter old) =>
      old.color != color || old.ground != ground || old.outline != outline || old.radius != radius;
}

/// [HatchPainter] in the theme's `brand` over `surface`.
class Hatch extends StatelessWidget {
  const Hatch({super.key, this.outline = false, this.radius = 0});

  final bool outline;
  final double radius;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: HatchPainter(
      color: context.colors.brand,
      ground: context.colors.surface,
      outline: outline,
      radius: radius,
    ),
    child: const SizedBox.expand(),
  );
}

/// 10px legend square: solid [color], or the hatch when `null`.
class LegendSquare extends StatelessWidget {
  const LegendSquare({super.key, this.color, this.outline = false});

  final Color? color;
  final bool outline;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: 10,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: color == null ? Hatch(outline: outline) : ColoredBox(color: color!),
    ),
  );
}

/// Legend item: square + muted label.
class LegendItem extends StatelessWidget {
  const LegendItem({super.key, required this.mark, required this.label});

  final Widget mark;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      mark,
      const SizedBox(width: 6),
      Flexible(
        child: Text(label, style: AppType.meta.copyWith(color: context.colors.inkMuted)),
      ),
    ],
  );
}

/// (i) "How this is calculated" (design `.info-b`): 32px disc in a 48dp hit box.
class StatsInfoButton extends StatelessWidget {
  const StatsInfoButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final label = context.l10n.insightsHowCalculated;
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onPressed,
      child: Tooltip(
        message: label,
        excludeFromSemantics: true,
        child: InkResponse(
          onTap: onPressed,
          radius: 24,
          child: SizedBox.square(
            dimension: AppTouch.min,
            child: Center(
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: c.surface2, shape: BoxShape.circle),
                child: Icon(AppIcons.info, size: 16, color: c.inkMuted),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Text where [bold] parts (amounts, names) are drawn in `ink` w700/800 inside a muted sentence.
class BoldText extends StatelessWidget {
  const BoldText(
    this.text, {
    super.key,
    required this.bold,
    this.style,
    this.boldWeight = FontWeight.w700,
    this.boldColor,
  });

  final String text;
  final List<String> bold;
  final TextStyle? style;
  final FontWeight boldWeight;

  /// Defaults to `ink`.
  final Color? boldColor;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final base = style ?? AppType.meta.copyWith(color: context.colors.inkMuted);
    final strong = base.copyWith(color: boldColor ?? context.colors.ink, fontWeight: boldWeight).tabular;
    final spans = <TextSpan>[];
    var rest = text;
    while (rest.isNotEmpty) {
      var at = -1;
      String? hit;
      for (final b in bold) {
        if (b.isEmpty) continue;
        final i = rest.indexOf(b);
        if (i >= 0 && (at < 0 || i < at)) {
          at = i;
          hit = b;
        }
      }
      if (hit == null) {
        spans.add(TextSpan(text: rest));
        break;
      }
      if (at > 0) spans.add(TextSpan(text: rest.substring(0, at)));
      spans.add(TextSpan(text: hit, style: strong));
      rest = rest.substring(at + hit.length);
    }
    return Text.rich(
      TextSpan(style: base, children: spans),
      semanticsLabel: l.spokenLabel(text),
    );
  }
}
