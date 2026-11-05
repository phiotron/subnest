import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'touch.dart';

/// One segment of [AppSegmentedControl].
class AppSegment<T> {
  const AppSegment({required this.value, required this.label, this.count});

  final T value;
  final String label;

  /// Optional count shown after the label in a lighter weight ("Active 7").
  final int? count;
}

/// Segmented control (design Components › SegmentedControl).
///
/// * Default: `surface-2` track, radius-md, 4px padding, equal-width 36px segments (radius-sm),
///   label 14/600 `ink-muted`; selected = `brand-soft` / `on-brand-soft`. 44px visible, 48dp hit area.
/// * [mini]: pill track (3px padding), 30px pill segments ≥ 56 wide, 13/600 — the hero's Month/Year.
///   Laid out 48dp tall (transparent margin) for the touch target (S-50).
///
/// Labels never wrap: on narrow widths they scale down to fit.
class AppSegmentedControl<T> extends StatelessWidget {
  const AppSegmentedControl({
    super.key,
    required this.segments,
    required this.selected,
    required this.onChanged,
    this.mini = false,
  });

  final List<AppSegment<T>> segments;
  final T selected;
  final ValueChanged<T>? onChanged;
  final bool mini;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = mini ? AppRadius.full : AppRadius.md;
    // The track is painted behind; each segment's hit area spans the full 48dp height
    // (track padding + mini margin) so taps on the track edge still select it.
    final margin = mini ? (AppTouch.min - 36) / 2 : (AppTouch.min - 44) / 2;
    final items = [for (var i = 0; i < segments.length; i++) _segment(context, segments[i], i)];
    return Semantics(
      container: true,
      child: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: margin),
              child: DecoratedBox(
                decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(radius)),
              ),
            ),
          ),
          if (mini)
            Row(mainAxisSize: MainAxisSize.min, children: items)
          else
            Row(children: [for (final i in items) Expanded(child: i)]),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, AppSegment<T> s, int index) {
    final c = context.colors;
    final on = s.value == selected;
    final pad = mini ? 3.0 : 4.0;
    final margin = mini ? (AppTouch.min - 36) / 2 : (AppTouch.min - 44) / 2;
    final fg = on ? c.onBrandSoft : c.inkMuted;
    final style = AppType.label.copyWith(fontSize: mini ? 13 : 14, color: fg);
    final text = Text.rich(
      TextSpan(
        text: s.label,
        children: [
          if (s.count != null)
            TextSpan(
              text: ' ${s.count}',
              style: TextStyle(fontWeight: FontWeight.w500, color: fg.withValues(alpha: .85)),
            ),
        ],
      ),
      style: style,
      maxLines: 1,
      softWrap: false,
    );
    return Semantics(
      button: true,
      selected: on,
      inMutuallyExclusiveGroup: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onChanged == null || on ? null : () => onChanged!(s.value),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            index == 0 ? pad : 0,
            pad + margin,
            index == segments.length - 1 ? pad : 0,
            pad + margin,
          ),
          child: AnimatedContainer(
            duration: AppMotion.of(context, AppMotion.fast),
            curve: AppMotion.ease,
            constraints: BoxConstraints(minHeight: mini ? 30 : 36, minWidth: mini ? 56 : 0),
            padding: EdgeInsets.symmetric(horizontal: mini ? 12 : 6, vertical: 4),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: on ? c.brandSoft : Colors.transparent,
              borderRadius: BorderRadius.circular(mini ? AppRadius.full : AppRadius.sm),
            ),
            child: mini ? text : FittedBox(fit: BoxFit.scaleDown, child: text),
          ),
        ),
      ),
    );
  }
}
