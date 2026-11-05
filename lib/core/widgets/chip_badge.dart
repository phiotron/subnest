import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'touch.dart';

/// Selectable chip (category filters, cycle quick-chips, payment method): 36px pill.
/// Rest: `surface-2` / `ink` 14/500. Selected: `brand` / `on-brand` 14/600 with a check.
///
/// Layout height is 48 (36 visible + 6 transparent above and below; narrow chips get transparent
/// sides up to 48 wide) so the touch target meets S-50. Put chips in
/// `Wrap(spacing: 8, runSpacing: -4)` for the design's 8px visible row gap (hit areas then overlap
/// by 4px, which is fine), or `runSpacing: 0` for a 12px gap.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.showCheck = true,
    this.fit = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  /// Leading icon at rest (replaced by the check when selected and [showCheck]).
  final IconData? icon;
  final bool showCheck;

  /// Grid cell variant (4 cycle chips on one row at 360 width): fills the cell, centred, 13px.
  final bool fit;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = selected ? c.onBrand : c.ink;
    final lead = selected && showCheck ? AppIcons.check : icon;
    final style = AppType.label.copyWith(
      fontSize: fit ? 13 : 14,
      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      color: fg,
    );
    final pill = AnimatedContainer(
      duration: AppMotion.of(context, AppMotion.fast),
      curve: AppMotion.ease,
      constraints: const BoxConstraints(minHeight: 36, minWidth: 44),
      padding: EdgeInsets.symmetric(horizontal: fit ? 4 : 14, vertical: 6),
      decoration: ShapeDecoration(color: selected ? c.brand : c.surface2, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: fit ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (lead != null && !fit) ...[Icon(lead, size: 16, color: fg), const SizedBox(width: 6)],
          Flexible(
            child: Text(label, style: style, maxLines: 1, overflow: TextOverflow.ellipsis, softWrap: false),
          ),
        ],
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: AppTouch.min),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: (AppTouch.min - 36) / 2),
            child: fit ? pill : Center(widthFactor: 1, child: pill),
          ),
        ),
      ),
    );
  }
}

enum BadgeKind { warning, neutral, success, brand, danger }

/// 22px status badge (radius-full, 12/600, icon 13): never truncates.
/// Use [StatusBadge.awaiting] for "To confirm" — amber, always with the clock icon.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, this.kind = BadgeKind.neutral, this.icon, this.large = false});

  /// "To confirm" / "Chờ xác nhận" — `warning-soft` + `warning-ink` + clock.
  const StatusBadge.awaiting({super.key, required this.label})
    : kind = BadgeKind.warning,
      icon = AppIcons.awaiting,
      large = false;

  /// "Trial" — neutral + hourglass.
  const StatusBadge.trial({super.key, required this.label})
    : kind = BadgeKind.neutral,
      icon = AppIcons.trial,
      large = false;

  /// "Paid" pill (28px, 13px) — `success-soft` + `success` + circle-check.
  const StatusBadge.paid({super.key, required this.label})
    : kind = BadgeKind.success,
      icon = AppIcons.paid,
      large = true;

  final String label;
  final BadgeKind kind;
  final IconData? icon;

  /// 28px / 13px variant (paid pill, stale-rates chip).
  final bool large;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg) = switch (kind) {
      BadgeKind.warning => (c.warningSoft, c.warningInk),
      BadgeKind.neutral => (c.surface2, c.inkMuted),
      BadgeKind.success => (c.successSoft, c.success),
      BadgeKind.brand => (c.brandSoft, c.onBrandSoft),
      BadgeKind.danger => (c.dangerSoft, c.danger),
    };
    return Container(
      constraints: BoxConstraints(minHeight: large ? 28 : 22),
      padding: EdgeInsets.fromLTRB(icon == null ? 8 : (large ? 10 : 6), 2, large ? 12 : 8, 2),
      decoration: ShapeDecoration(color: bg, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: large ? 14 : 13, color: fg), SizedBox(width: large ? 6 : 4)],
          // Never truncated: in an extremely narrow slot the label wraps instead of overflowing.
          Flexible(
            child: Text(
              label,
              style:
                  (large
                          ? AppType.meta.copyWith(fontWeight: FontWeight.w600)
                          : AppType.caption.copyWith(letterSpacing: 0))
                      .copyWith(color: fg),
            ),
          ),
        ],
      ),
    );
  }
}

/// "÷4" with the users icon — a shared plan (12/600 `ink-muted`).
class ShareMark extends StatelessWidget {
  const ShareMark({super.key, required this.count, this.semanticLabel});

  final int count;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(AppIcons.shared, size: 14, color: c.inkMuted),
          const SizedBox(width: 2),
          Text('÷$count', style: AppType.caption.copyWith(letterSpacing: 0, color: c.inkMuted).tabular),
        ],
      ),
    );
  }
}
