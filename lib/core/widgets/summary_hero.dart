import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import 'segmented_control.dart';

/// One coloured piece of the hero's spend strip (a subscription's share of the total).
class SpendSegment {
  const SpendSegment({required this.color, required this.value});

  final Color color;

  /// Relative weight (e.g. monthly cost in minor units).
  final double value;
}

/// Total-spend hero / SummaryCard (design S2 `hero`): label + Month/Year mini toggle, the
/// `display` total (prefixed by a muted "≈" when converted) that **counts up over 240 ms** when the
/// value changes, the spend strip (8px, service colours, largest first) and two meta phrases that
/// wrap as whole phrases. At < 340px wide the total steps down to 36px; at 130% text it grows to
/// 44px at most.
class SpendHero extends StatelessWidget {
  const SpendHero({
    super.key,
    required this.label,
    required this.amount,
    required this.format,
    this.approx = false,
    this.yearly = false,
    this.onPeriodChanged,
    this.segments = const [],
    this.leadingMeta,
    this.trailingMeta,
    this.footer,
  });

  /// "Monthly spend" / "Yearly spend".
  final String label;

  /// Total in major units of the primary currency.
  final double amount;

  /// Formats a (possibly mid-animation) amount, e.g. `(v) => l10n.amount(v, 'VND')`.
  final String Function(double value) format;

  /// Totals that include converted amounts show "≈".
  final bool approx;

  final bool yearly;

  /// Month ↔ Year toggle; `null` hides the toggle.
  final ValueChanged<bool>? onPeriodChanged;

  final List<SpendSegment> segments;

  /// "7 active · 1 trial".
  final String? leadingMeta;

  /// "Biggest: ChatGPT Plus · 47%".
  final String? trailingMeta;

  /// Under the meta row, e.g. the "Offline · rates from 3 days ago" chip.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    final zero = amount == 0;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.s6, bottom: AppSpace.s5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: AppType.meta.copyWith(color: c.inkMuted))),
              if (onPeriodChanged != null)
                AppSegmentedControl<bool>(
                  mini: true,
                  selected: yearly,
                  onChanged: onPeriodChanged,
                  segments: [
                    AppSegment(value: false, label: l.coreMonth),
                    AppSegment(value: true, label: l.coreYear),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 4),
          LayoutBuilder(
            builder: (context, box) {
              final size = box.maxWidth < 340 ? 36.0 : 40.0;
              final style = AppType.display.copyWith(fontSize: size, color: zero ? c.inkMuted : c.ink).tabular;
              return TextScaleCap(
                max: AppTextScale.display,
                child: Semantics(
                  liveRegion: true,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (approx && !zero) ...[
                        Text('≈', style: AppType.display.copyWith(fontSize: 28, fontWeight: FontWeight.w500, color: c.inkMuted)),
                        const SizedBox(width: 6),
                      ],
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: CountUpText(value: amount, format: format, style: style),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (segments.isNotEmpty && !zero) ...[
            const SizedBox(height: AppSpace.s4),
            SpendStrip(segments: segments),
          ],
          if (leadingMeta != null || trailingMeta != null) ...[
            const SizedBox(height: AppSpace.s2),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: AppSpace.s2,
              runSpacing: 2,
              children: [
                if (leadingMeta != null) Text(leadingMeta!, style: AppType.meta.copyWith(color: c.inkMuted)),
                if (trailingMeta != null) Text(trailingMeta!, style: AppType.meta.copyWith(color: c.inkMuted)),
              ],
            ),
          ],
          if (footer != null) ...[const SizedBox(height: AppSpace.s3), Align(alignment: AlignmentDirectional.centerStart, child: footer)],
        ],
      ),
    );
  }
}

/// Animated number: tweens from the previous [value] to the new one over [AppMotion.countUp]
/// (instant under reduce-motion) and renders each frame with [format].
class CountUpText extends StatelessWidget {
  const CountUpText({super.key, required this.value, required this.format, this.style});

  final double value;
  final String Function(double value) format;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) => TweenAnimationBuilder<double>(
    tween: Tween(end: value),
    duration: AppMotion.of(context, AppMotion.countUp),
    curve: AppMotion.ease,
    builder: (context, v, _) => Text(
      format(v),
      maxLines: 1,
      softWrap: false,
      style: style,
      semanticsLabel: format(value),
    ),
  );
}

/// 8px rounded strip of coloured segments (2px gaps, each with the `tile-ring` edge).
class SpendStrip extends StatelessWidget {
  const SpendStrip({super.key, required this.segments, this.height = 8});

  final List<SpendSegment> segments;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final total = segments.fold<double>(0, (a, s) => a + s.value);
    if (total <= 0) return SizedBox(height: height);
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < segments.length; i++) ...[
                if (i > 0) const SizedBox(width: 2),
                Expanded(
                  flex: (segments[i].value / total * 1000).round().clamp(1, 1000),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: segments[i].color,
                      border: Border.all(color: c.tileRing, width: 1),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
