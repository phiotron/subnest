import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n.dart';
import '../widgets/app_icons.dart';
import '../widgets/app_tab_bar.dart';
import 'routes.dart';

/// Bottom tab bar: Overview · Calendar · Insights · Settings (product.md §4, design TabBar).
/// Debug builds only: long-press the Settings tab to open the component gallery.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      body: shell,
      bottomNavigationBar: AppTabBar(
        currentIndex: shell.currentIndex,
        onSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        onLongPress: kDebugMode ? (i) => i == 3 ? context.push(AppRoutes.devGallery) : null : null,
        items: [
          AppTabItem(icon: AppIcons.tabHome, label: l.coreTabOverview),
          AppTabItem(icon: AppIcons.tabCalendar, label: l.commonTabCalendar),
          AppTabItem(icon: AppIcons.tabInsights, label: l.commonTabInsights),
          AppTabItem(icon: AppIcons.tabSettings, label: l.commonTabSettings),
        ],
      ),
    );
  }
}
