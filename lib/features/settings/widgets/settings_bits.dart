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
