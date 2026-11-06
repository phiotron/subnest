import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers.dart';
import '../l10n/l10n.dart';
import '../theme/app_theme.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_tab_bar.dart';
import 'routes.dart';

/// Bottom tab bar: Overview · Calendar · Insights · Settings (product.md §4, design TabBar).
/// Debug builds only: long-press the Settings tab to open the component gallery.
///
/// Optional (Settings › `hideTabBarOnScroll`, product.md §10.2, png 19): the bar slides away while
/// a list scrolls down and comes back on the first scroll up, at the top of a list, and on a tab
/// change. The body grows into its place, so a screen's FAB drops with it. Never hides while a
/// screen reader / switch access is on (`accessibleNavigation`).
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _hidden = false;

  void _setHidden(bool hidden) {
    if (hidden != _hidden) setState(() => _hidden = hidden);
  }

  bool _onScroll(UserScrollNotification n) {
    if (n.metrics.axis != Axis.vertical) return false;
    if (n.metrics.pixels <= n.metrics.minScrollExtent) {
      _setHidden(false);
    } else if (n.direction == ScrollDirection.reverse) {
      _setHidden(true);
    } else if (n.direction == ScrollDirection.forward) {
      _setHidden(false);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final shell = widget.shell;
    // Only this one setting: rebuilding the shell on every Settings write restarts route work below it.
    final enabled =
        ref.watch(settingsProvider.select((a) => a.value?.hideTabBarOnScroll ?? false)) &&
        !MediaQuery.accessibleNavigationOf(context);
    final hidden = enabled && _hidden;
    final bar = AppTabBar(
      currentIndex: shell.currentIndex,
      onSelected: (i) {
        _setHidden(false);
        shell.goBranch(i, initialLocation: i == shell.currentIndex);
      },
      onLongPress: kDebugMode ? (i) => i == 3 ? context.push(AppRoutes.devGallery) : null : null,
      items: [
        AppTabItem(icon: AppIcons.tabHome, label: l.coreTabOverview),
        AppTabItem(icon: AppIcons.tabCalendar, label: l.commonTabCalendar),
        AppTabItem(icon: AppIcons.tabInsights, label: l.commonTabInsights),
        AppTabItem(icon: AppIcons.tabSettings, label: l.commonTabSettings),
      ],
    );
    return Scaffold(
      body: enabled ? NotificationListener<UserScrollNotification>(onNotification: _onScroll, child: shell) : shell,
      bottomNavigationBar: !enabled
          ? bar
          : TweenAnimationBuilder<double>(
              tween: Tween(end: hidden ? 0 : 1),
              duration: AppMotion.of(context, AppMotion.sheet),
              curve: AppMotion.ease,
              builder: (context, t, child) => ClipRect(
                child: Align(alignment: Alignment.topCenter, heightFactor: t, child: child),
              ),
              child: ExcludeSemantics(excluding: hidden, child: bar),
            ),
    );
  }
}
