import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/generated/app_localizations.dart';

/// Bottom tab bar: Home · Calendar · Insights · Settings (product.md §4).
/// Restyled by the Design-system session (F).
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) => shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: l.commonTabHome),
          NavigationDestination(icon: const Icon(Icons.calendar_month_outlined), label: l.commonTabCalendar),
          NavigationDestination(icon: const Icon(Icons.insights_outlined), label: l.commonTabInsights),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: l.commonTabSettings),
        ],
      ),
    );
  }
}
