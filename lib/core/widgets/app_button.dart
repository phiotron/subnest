import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'touch.dart';

/// Button variants (design Components › Button).
enum AppButtonKind {
  /// `brand` fill — the ONE primary action of a view.
  primary,

  /// `brand-soft` fill, `on-brand-soft` label — secondary actions ("How to cancel", "Done" in sheets).
  tonal,

  /// Transparent, 1.5px `line-strong` border, `ink` label.
  outline,

  /// Transparent, `brand` label ("Keep it", "Later", links).
  text,

  /// `danger` fill, `on-danger` label — delete only.
  danger,

  /// Transparent, `danger` label — destructive secondary ("Delete" row in a dialog list).
  dangerText,
}

/// Subnest button: 52px tall, radius-md, label 16/600 — or [small]: 40px pill, label 14.
/// Every size keeps a ≥ 44px (Material 48) touch target. `onPressed: null` = disabled (45% opacity).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.kind = AppButtonKind.primary,
    this.icon,
    this.trailingIcon,
    this.small = false,
    this.expand = false,
    this.loading = false,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.small = false,
    this.expand = false,
    this.loading = false,
  }) : kind = AppButtonKind.primary;

  const AppButton.tonal({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.small = false,
    this.expand = false,
    this.loading = false,
  }) : kind = AppButtonKind.tonal;

  const AppButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.small = false,
    this.expand = false,
    this.loading = false,
  }) : kind = AppButtonKind.outline;

  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.small = false,
    this.expand = false,
    this.loading = false,
  }) : kind = AppButtonKind.text;

  const AppButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.small = false,
    this.expand = false,
    this.loading = false,
  }) : kind = AppButtonKind.danger;

  final String label;
  final VoidCallback? onPressed;
  final AppButtonKind kind;
  final IconData? icon;
  final IconData? trailingIcon;

  /// 40px pill (row actions, banner/trial-card actions).
  final bool small;

  /// Full width (sheet/dialog/bottom-bar actions).
  final bool expand;

  /// Shows a spinner instead of the icon and ignores taps.
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final (bg, fg, side) = switch (kind) {
      AppButtonKind.primary => (c.brand, c.onBrand, BorderSide.none),
      AppButtonKind.tonal => (c.brandSoft, c.onBrandSoft, BorderSide.none),
      AppButtonKind.outline => (Colors.transparent, c.ink, BorderSide(color: c.lineStrong, width: 1.5)),
      AppButtonKind.text => (Colors.transparent, c.brand, BorderSide.none),
      AppButtonKind.danger => (c.danger, c.onDanger, BorderSide.none),
      AppButtonKind.dangerText => (Colors.transparent, c.danger, BorderSide.none),
    };
    final height = small ? 40.0 : AppSize.buttonH;
    final iconSize = small ? 16.0 : 20.0;
    final shape = small
        ? const StadiumBorder()
        : const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)));
    final textStyle = small ? AppType.label : AppType.label.copyWith(fontSize: 16, height: 20 / 16);

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled) && bg != Colors.transparent ? bg.withValues(alpha: .45) : bg,
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.disabled) ? fg.withValues(alpha: .45) : fg,
      ),
      overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: .10)),
      side: WidgetStatePropertyAll(side),
      shape: WidgetStatePropertyAll(shape),
      elevation: const WidgetStatePropertyAll(0),
      minimumSize: WidgetStatePropertyAll(Size(small ? 40 : 64, height)),
      padding: WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: small ? 14 : AppSpace.s5)),
      textStyle: WidgetStatePropertyAll(textStyle),
      iconSize: WidgetStatePropertyAll(iconSize),
      tapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
    );

    final lead = loading
        ? SizedBox.square(
            dimension: iconSize,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          )
        : (icon == null ? null : Icon(icon, size: iconSize));

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (lead != null) ...[lead, const SizedBox(width: AppSpace.s2)],
        Flexible(
          // ≥ 150% text the label may take two lines: real phone (320dp, 200%) cut S7's
          // "Confirm all" to "Xác nhận tất …".
          child: Text(
            label,
            maxLines: MediaQuery.textScalerOf(context).scale(16) / 16 >= 1.5 ? 2 : 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
        if (trailingIcon != null) ...[const SizedBox(width: AppSpace.s1), Icon(trailingIcon, size: 16)],
      ],
    );

    final button = TextButton(onPressed: loading ? null : onPressed, style: style, child: child);
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Floating add button: 56px, radius-lg, `brand`, `shadow-float`, plus 26.
class AppFab extends StatelessWidget {
  const AppFab({super.key, required this.onPressed, required this.tooltip, this.icon});

  final VoidCallback? onPressed;

  /// Accessible label ("Add subscription").
  final String tooltip;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: AppSize.fabSize,
      height: AppSize.fabSize,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.lg), boxShadow: context.elevation.float),
      child: Material(
        color: c.brand,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: onPressed,
          child: Tooltip(
            message: tooltip,
            excludeFromSemantics: true,
            child: Semantics(
              button: true,
              label: tooltip,
              child: Center(child: Icon(icon ?? AppIcons.add, size: 26, color: c.onBrand)),
            ),
          ),
        ),
      ),
    );
  }
}

/// 48 × 48dp round icon button (top bars, date-picker arrows). [color] defaults to `ink`.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 24,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: onPressed,
    tooltip: tooltip,
    iconSize: size,
    color: color ?? context.colors.ink,
    constraints: const BoxConstraints.tightFor(width: AppTouch.min, height: AppTouch.min),
    padding: EdgeInsets.zero,
    icon: Icon(icon),
  );
}
