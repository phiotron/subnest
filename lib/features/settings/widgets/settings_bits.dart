import 'package:flutter/material.dart';

import '../../../core/widgets/widgets.dart';
import 'app_mark.dart';

/// Meta note under a group (`list-note`): "Last backup: 23 Sep 2026", "Only currencies … are listed."
class ListNote extends StatelessWidget {
  const ListNote(this.text, {super.key, this.top = AppSpace.s2});

  final String text;
  final double top;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.fromLTRB(AppSpace.s1, top, AppSpace.s1, 0),
    child: Text(text, style: AppType.meta.copyWith(color: context.colors.inkMuted)),
  );
}

/// Bottom card of S10 (`.privacy`): `surface-2`, lock in `brand`, 13px `ink-muted`.
class PrivacyNote extends StatelessWidget {
  const PrivacyNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
        decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.lg)),
        child: Row(
          children: [
            Icon(AppIcons.privacy, size: 18, color: c.brand),
            const SizedBox(width: 10),
            Expanded(
              child: Text(text, style: AppType.meta.copyWith(color: c.inkMuted)),
            ),
          ],
        ),
      ),
    );
  }
}

/// A local notification as the phone will show it (S10 Reminders › Preview, `.notif.solo`).
class NotificationPreview extends StatelessWidget {
  const NotificationPreview({super.key, required this.appName, required this.time, required this.body});

  final String appName;
  final String time;
  final String body;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpace.s3),
        decoration: BoxDecoration(
          color: c.surfaceSheet,
          borderRadius: BorderRadius.circular(18),
          boxShadow: context.elevation.card,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppMark(),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          appName,
                          style: AppType.meta.copyWith(color: c.ink, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: AppSpace.s2),
                      Text(time, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    body,
                    style: AppType.label.copyWith(fontWeight: FontWeight.w400, color: c.ink),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// [SettingRow] with a right-aligned value (png 48: "VND ›", "Auto · 2 h ago ›").
///
/// Works around core `SettingRow(value:)`, which gives the label (`Expanded`) and the value
/// (`Flexible`) half the row each, so a short value stops mid-row. Here the value takes what it
/// needs up to 45% of the row; at ≥ 150% text it moves under the label so neither is squeezed
/// (same rule as core `RadioRow`). See notes 2026-11-05.
class ValueRow extends StatelessWidget {
  const ValueRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.onTap,
    this.chevron = true,
    this.valueColor,
    this.valueWeight,
  });

  final String label;
  final String value;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool chevron;
  final Color? valueColor;
  final FontWeight? valueWeight;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final style = AppType.body.copyWith(color: valueColor ?? c.inkMuted, fontWeight: valueWeight);
    if (MediaQuery.textScalerOf(context).scale(10) >= 15) {
      // Same paddings/styles as SettingRow, value as a second line.
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 10),
          child: Row(
            children: [
              if (icon != null) ...[
                SizedBox(width: 24, child: Icon(icon, size: 20, color: c.inkMuted)),
                const SizedBox(width: AppSpace.s3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppType.body.copyWith(fontWeight: FontWeight.w500, height: 20 / 15, color: c.ink),
                    ),
                    if (value.isNotEmpty) Text(value, style: style),
                  ],
                ),
              ),
              if (chevron && onTap != null) ...[
                const SizedBox(width: AppSpace.s2),
                Icon(AppIcons.next, size: 18, color: c.inkMuted),
              ],
            ],
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, box) => SettingRow(
        icon: icon,
        label: label,
        onTap: onTap,
        trailing: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: box.maxWidth * .45),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: style,
                ),
              ),
              if (chevron && onTap != null) ...[
                const SizedBox(width: AppSpace.s2),
                Icon(AppIcons.next, size: 18, color: c.inkMuted),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// `.pro`: 18 px dark chip "PRO" (`ink` on `bg`; inverted on a brand card with [onBrand]).
class ProBadge extends StatelessWidget {
  const ProBadge({super.key, this.onBrand = false});

  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      height: 18,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: onBrand ? c.onBrand : c.ink, borderRadius: BorderRadius.circular(5)),
      child: Text(
        'PRO',
        textScaler: TextScaler.noScaling,
        style: TextStyle(
          fontFamily: AppType.fontFamily,
          fontSize: 10,
          height: 1.2,
          fontWeight: FontWeight.w800,
          letterSpacing: .6,
          color: onBrand ? c.brand : c.bg,
        ),
      ),
    );
  }
}

/// `.soon`: 24 px `surface-2` pill, 12/600 `ink-muted` ("Soon").
class SoonChip extends StatelessWidget {
  const SoonChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 24),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(color: c.surface2, borderRadius: BorderRadius.circular(AppRadius.full)),
      child: Text(label, style: AppType.caption.copyWith(color: c.inkMuted)),
    );
  }
}

/// [SectionHeader] look with a [ProBadge] after the label ("AUTOMATION PRO").
class ProSectionHeader extends StatelessWidget {
  const ProSectionHeader(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s6, AppSpace.s1, AppSpace.s2),
    child: Semantics(
      header: true,
      child: Row(
        children: [
          Flexible(
            child: Text(label.toUpperCase(), style: AppType.caption.copyWith(color: context.colors.inkMuted)),
          ),
          const SizedBox(width: 6),
          const ExcludeSemantics(child: ProBadge()),
        ],
      ),
    ),
  );
}

/// Two-column key/value list (`.ab-grid`, `.ab-kv`): muted keys, values in `ink`. At ≥ 150 % text
/// the value goes under its key so neither is squeezed.
class KeyValueGrid extends StatelessWidget {
  const KeyValueGrid({super.key, required this.rows, this.rowGap = 6, this.columnGap = 10});

  final List<(String, Widget)> rows;
  final double rowGap;
  final double columnGap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final key = AppType.meta.copyWith(color: c.inkMuted);
    final stacked = MediaQuery.textScalerOf(context).scale(10) >= 15;
    if (stacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final (i, (k, v)) in rows.indexed) ...[if (i > 0) SizedBox(height: rowGap), Text(k, style: key), v],
        ],
      );
    }
    return Table(
      columnWidths: const {0: IntrinsicColumnWidth(), 1: FlexColumnWidth()},
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        for (final (i, (k, v)) in rows.indexed)
          TableRow(
            children: [
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : rowGap, right: columnGap),
                child: Text(k, style: key),
              ),
              Padding(
                padding: EdgeInsets.only(top: i == 0 ? 0 : rowGap),
                child: v,
              ),
            ],
          ),
      ],
    );
  }
}

/// Meta text in `ink` for a [KeyValueGrid] value.
class KvText extends StatelessWidget {
  const KvText(this.text, {super.key, this.icon, this.color});

  final String text;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = AppType.meta.copyWith(color: color ?? context.colors.ink);
    if (icon == null) return Text(text, style: style);
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: '$text '),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(icon, size: 12, color: style.color),
          ),
        ],
      ),
    );
  }
}

/// `.file-chip`: file-lock icon in `brand`, file name (label) and a meta line; `surface-2`, 14 px
/// corners. [big] = the Restore screen version on a `surface` card with [trailing] (Valid badge).
class FileChip extends StatelessWidget {
  const FileChip({super.key, required this.name, required this.meta, this.big = false, this.trailing});

  final String name;
  final String meta;
  final bool big;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      margin: EdgeInsets.only(top: big ? 12 : 8, bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: big ? c.surface : c.surface2,
        borderRadius: BorderRadius.circular(14),
        boxShadow: big ? context.elevation.card : null,
      ),
      child: Row(
        children: [
          Icon(LucideIcons.fileLock, size: big ? 26 : 22, color: c.brand),
          const SizedBox(width: AppSpace.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppType.label.copyWith(color: c.ink)),
                Text(meta, style: AppType.meta.copyWith(color: c.inkMuted)),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: AppSpace.s2), trailing!],
        ],
      ),
    );
  }
}

/// `.bottom-bar`: `surface` strip with a 1 px `line` hairline on top, 12 px above the button and
/// the safe-area inset below.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.line)),
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.only(bottom: AppSpace.s3),
        child: Padding(padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, 0), child: child),
      ),
    );
  }
}
