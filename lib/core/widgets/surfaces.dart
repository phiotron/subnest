import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icons.dart';
import 'touch.dart';

/// Card: `surface`, radius-lg, `shadow-card` (light) / 1px `line` ring (dark).
/// [color] overrides the fill (e.g. `warning-soft` cards drop the shadow).
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpace.s4),
    this.color,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final tinted = color != null && color != c.surface;
    const radius = BorderRadius.all(Radius.circular(AppRadius.lg));
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: radius, boxShadow: tinted ? null : context.elevation.card),
      child: Material(
        color: color ?? c.surface,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: onTap == null
            ? Padding(padding: padding, child: child)
            : InkWell(
                onTap: onTap,
                child: Padding(padding: padding, child: child),
              ),
      ),
    );
  }
}

/// List group: a card holding rows separated by 1px `line` hairlines that start at
/// [dividerIndent] (68 for subscription rows = after the 40px tile, 52 for settings rows,
/// 16 for form fields).
class AppGroup extends StatelessWidget {
  const AppGroup({super.key, required this.children, this.dividerIndent = 68, this.padding = EdgeInsets.zero});

  final List<Widget> children;
  final double dividerIndent;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return AppCard(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) Divider(height: 1, thickness: 1, indent: dividerIndent, color: c.line),
            children[i],
          ],
        ],
      ),
    );
  }
}

/// Section eyebrow: caption 12/600 uppercase `ink-muted` (+ optional trailing link/action).
/// "UPCOMING · 7 DAYS" … "Calendar".
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.label, this.actionLabel, this.onAction, this.padding});

  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s6, AppSpace.s1, AppSpace.s2),
      child: Row(
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(label.toUpperCase(), style: AppType.caption.copyWith(color: c.inkMuted)),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.s1),
                minimumSize: const Size(AppTouch.min, AppTouch.min),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!, style: AppType.label.copyWith(color: c.brand)),
            ),
        ],
      ),
    );
  }
}

/// Settings / option row (`srow`): ≥ 56px, 24px icon slot (`ink-muted`), label 15/500, optional
/// meta sub-line, value (`ink-muted`, may wrap at 130%), then chevron / external-link / [trailing].
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.label,
    this.icon,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.external = false,
    this.chevron = true,
    this.danger = false,
  });

  final String label;
  final IconData? icon;
  final String? subtitle;
  final String? value;

  /// Replaces the chevron (a toggle, a check, a badge).
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Shows external-link instead of the chevron (opens a browser).
  final bool external;
  final bool chevron;

  /// `danger` label + icon (Delete).
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final fg = danger ? c.danger : c.ink;
    final iconColor = danger ? c.danger : c.inkMuted;
    final end =
        trailing ??
        (onTap != null && chevron
            ? Icon(external ? AppIcons.external : AppIcons.next, size: 18, color: c.inkMuted)
            : null);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
          child: Row(
            children: [
              if (icon != null) ...[
                SizedBox(width: 24, child: Icon(icon, size: 20, color: iconColor)),
                const SizedBox(width: AppSpace.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: AppType.body.copyWith(fontWeight: FontWeight.w500, height: 20 / 15, color: fg),
                    ),
                    if (subtitle != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(subtitle!, style: AppType.meta.copyWith(color: c.inkMuted)),
                      ),
                  ],
                ),
              ),
              if (value != null) ...[
                const SizedBox(width: AppSpace.s3),
                Flexible(
                  child: Text(
                    value!,
                    textAlign: TextAlign.end,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppType.body.copyWith(color: c.inkMuted),
                  ),
                ),
              ],
              if (end != null) ...[const SizedBox(width: AppSpace.s2), end],
            ],
          ),
        ),
      ),
    );
  }
}

/// Large tab title (S2/S8/S9/S10): optional meta eyebrow ("Wednesday, 4 November"), `headline`
/// title (grows ≤ 32px at 130%), optional trailing action.
class LargeTitle extends StatelessWidget {
  const LargeTitle({super.key, required this.title, this.eyebrow, this.trailing});

  final String title;
  final String? eyebrow;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.s2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (eyebrow != null) Text(eyebrow!, style: AppType.meta.copyWith(color: c.inkMuted)),
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    style: AppType.headline.copyWith(color: c.ink),
                    textScaler: AppTextScale.capped(context, AppTextScale.headline),
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// Pushed-screen top bar: 52px, 44px back (or close) button, centred `title-sm`, optional trailing.
/// Use as `Scaffold(appBar: AppTopBar(...))`.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.title, this.close = false, this.onBack, this.trailing, this.backTooltip});

  final String title;

  /// Shows ✕ (modal flows) instead of ‹.
  final bool close;
  final VoidCallback? onBack;
  final Widget? trailing;

  /// Accessible label; defaults to the Material "Back"/"Close" strings.
  final String? backTooltip;

  @override
  Size get preferredSize => const Size.fromHeight(52);

  @override
  Widget build(BuildContext context) {
    final m = MaterialLocalizations.of(context);
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 52,
      leading: Padding(
        padding: const EdgeInsetsDirectional.only(start: 4),
        child: IconButton(
          tooltip: backTooltip ?? (close ? m.closeButtonTooltip : m.backButtonTooltip),
          icon: Icon(close ? AppIcons.close : AppIcons.back, size: 24),
          onPressed: onBack ?? () => Navigator.maybePop(context),
        ),
      ),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [if (trailing != null) Padding(padding: const EdgeInsetsDirectional.only(end: 4), child: trailing)],
    );
  }
}
