import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/calendar_screen.dart';
import '../../features/catalog/catalog_screen.dart';
import '../../features/confirm/awaiting_screen.dart';
import '../../features/confirm/confirm_sheet.dart';
import '../../features/dev/gallery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/insights/insights_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/scan/scan_screen.dart';
import '../../features/settings/currency_screen.dart';
import '../../features/settings/manage/manage_screens.dart';
import '../../features/settings/rates_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/subscription_detail/subscription_detail_screen.dart';
import '../../features/subscription_form/subscription_form_screen.dart';
import 'app_shell.dart';
import 'routes.dart';
import 'sheet_page.dart';

/// Route table. Owned by the Core session: feature sessions replace the *screen widgets*
/// inside their feature folder but keep the class names/constructors used here.
/// Need a new route? Ask the coordinator (write it in your notes).
GoRouter createRouter({required String initialLocation, GlobalKey<NavigatorState>? navigatorKey}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: AppRoutes.onboarding, builder: (_, _) => const OnboardingScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.home, builder: (_, _) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.calendar, builder: (_, _) => const CalendarScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: AppRoutes.insights, builder: (_, _) => const InsightsScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, _) => const SettingsScreen(),
                routes: [
                  GoRoute(path: 'currency', builder: (_, _) => const CurrencyScreen()),
                  GoRoute(path: 'rates', builder: (_, _) => const RatesScreen()),
                  GoRoute(path: 'categories', builder: (_, _) => const ManageCategoriesScreen()),
                  GoRoute(path: 'labels', builder: (_, _) => const ManageLabelsScreen()),
                  GoRoute(path: 'payment-methods', builder: (_, _) => const ManagePaymentMethodsScreen()),
                  GoRoute(path: 'budgets', builder: (_, _) => const ManageBudgetsScreen()),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(path: AppRoutes.catalog, builder: (_, _) => const CatalogScreen()),
      GoRoute(path: AppRoutes.awaiting, builder: (_, _) => const AwaitingScreen()),
      GoRoute(path: AppRoutes.scan, builder: (_, _) => const ScanScreen()),
      // `new` must come before `:id`.
      GoRoute(
        path: '/subscription/new',
        builder: (_, state) => SubscriptionFormScreen(
          serviceId: state.uri.queryParameters['service'],
          planId: state.uri.queryParameters['plan'],
          initialName: state.uri.queryParameters['name'],
        ),
      ),
      GoRoute(
        path: '/subscription/:id',
        builder: (_, state) => SubscriptionDetailScreen(subscriptionId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, state) => SubscriptionFormScreen(subscriptionId: state.pathParameters['id']),
          ),
        ],
      ),
      if (kDebugMode)
        GoRoute(path: AppRoutes.devGallery, builder: (_, state) => GalleryScreen.fromQuery(state.uri.queryParameters)),
      GoRoute(
        path: '/confirm/:id',
        pageBuilder: (_, state) => BottomSheetPage(
          key: state.pageKey,
          child: ConfirmSheet(subscriptionId: state.pathParameters['id']!),
        ),
      ),
    ],
  );
}
