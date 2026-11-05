import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// One tab of [AppTabBar].
class AppTabItem {
  const AppTabItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

/// Bottom tab bar (design Components › TabBar): `surface`, 1px `line` top hairline, 64px +
/// bottom safe-area inset. Each tab: 60×32 pill (selected `brand-soft` / `on-brand-soft`),
/// 22px icon, 12px label (selected 700 `ink`, rest 500 `ink-muted`). Never grows with text size.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    this.onLongPress,
  });

  final List<AppTabItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  /// Optional long-press per tab (debug hooks).
  final ValueChanged<int>? onLongPress;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bottom = MediaQuery.viewPaddingOf(context).bottom;
    return TextScaleCap(
      max: 1,
      child: Container(
        decoration: BoxDecoration(
          color: c.surface,
          border: Border(top: BorderSide(color: c.line)),
        ),
        padding: EdgeInsets.fromLTRB(AppSpace.s2, AppSpace.s2, AppSpace.s2, bottom),
        child: SizedBox(
          height: AppSize.tabbarH - AppSpace.s2 - 1, // 1px top hairline
          child: Row(children: [for (var i = 0; i < items.length; i++) Expanded(child: _tab(context, i))]),
        ),
      ),
    );
  }

  Widget _tab(BuildContext context, int i) {
    final c = context.colors;
    final on = i == currentIndex;
    final item = items[i];
    return Semantics(
      selected: on,
      button: true,
      label: item.label,
      excludeSemantics: true,
      onTap: () => onSelected(i), // excluded children would otherwise drop the tap action
      child: InkResponse(
        onTap: () => onSelected(i),
        onLongPress: onLongPress == null ? null : () => onLongPress!(i),
        radius: 36,
        highlightShape: BoxShape.rectangle,
        containedInkWell: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: AppMotion.of(context, AppMotion.fast),
              curve: AppMotion.ease,
              width: 60,
              height: 32,
              decoration: BoxDecoration(
                color: on ? c.brandSoft : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Icon(item.icon, size: 22, color: on ? c.onBrandSoft : c.inkMuted),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppType.caption.copyWith(
                letterSpacing: 0,
                fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                color: on ? c.ink : c.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
