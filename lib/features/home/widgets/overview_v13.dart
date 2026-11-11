import 'package:flutter/material.dart';

import '../../../core/l10n/l10n.dart';
import '../../../core/widgets/widgets.dart';

// S2 pieces added by the v13 mockup (product.md §10.2). Kept in the feature for now; candidates for
// core/widgets once S5/S7/S8 need them (label chip, Auto badge).

/// Label chip on a row (`lbl`): 20px pill on `surface-2`, 8px colour dot, 12/600 `ink`. Never truncates.
class LabelChip extends StatelessWidget {
  const LabelChip({super.key, required this.name, this.colorValue});

  final String name;

  /// Label colour; `null` → neutral `line-strong` dot.
  final int? colorValue;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      constraints: const BoxConstraints(minHeight: 20),
      padding: const EdgeInsetsDirectional.fromSTEB(6, 2, 8, 2),
      decoration: ShapeDecoration(color: c.surface2, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorValue == null ? c.lineStrong : Color(colorValue!),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: AppType.caption.copyWith(letterSpacing: 0, fontSize: 12, height: 16 / 12, color: c.ink),
            ),
          ),
        ],
      ),
    );
  }
}

/// "✦ Auto" badge beside the name of an auto-detected subscription (`auto-b`): `brand-soft` pill,
/// 11/700 `on-brand-soft`. Read as "Auto-detected".
class AutoBadge extends StatelessWidget {
  const AutoBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Semantics(
      label: l.commonAutoDetected,
      excludeSemantics: true,
      child: Container(
        constraints: const BoxConstraints(minHeight: 20),
        padding: const EdgeInsetsDirectional.fromSTEB(5, 2, 7, 2),
        decoration: ShapeDecoration(color: c.brandSoft, shape: const StadiumBorder()),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.sparkles, size: 12, color: c.onBrandSoft),
            const SizedBox(width: 3),
            Text(
              l.homeAutoBadge,
              maxLines: 1,
              softWrap: false,
              style: AppType.caption.copyWith(
                letterSpacing: .1,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: c.onBrandSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One removable chip of an active filter (png 17).
class ActiveFilter {
  const ActiveFilter(this.label, this.onRemove);
  final String label;
  final VoidCallback onRemove;
}

/// Active filters above the list (`fchips`): selected chips with an ×, then "Clear".
class ActiveFilterChips extends StatelessWidget {
  const ActiveFilterChips({super.key, required this.filters, required this.onClear});

  final List<ActiveFilter> filters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final l = context.l10n;
    return Wrap(
      spacing: AppSpace.s2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final f in filters)
          Semantics(
            button: true,
            label: l.homeFilterRemove(f.label),
            excludeSemantics: true,
            onTap: f.onRemove,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: f.onRemove,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: (AppTouch.min - 32) / 2),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 32),
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 10, 4),
                  decoration: ShapeDecoration(color: c.brand, shape: const StadiumBorder()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          f.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.label.copyWith(fontSize: 13, fontWeight: FontWeight.w600, color: c.onBrand),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(LucideIcons.x, size: 16, color: c.onBrand),
                    ],
                  ),
                ),
              ),
            ),
          ),
        TextButton(onPressed: onClear, child: Text(l.homeFilterClear)),
      ],
    );
  }
}
