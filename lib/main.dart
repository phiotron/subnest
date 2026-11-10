import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'data/db/app_database.dart';
import 'data/notifications/notification_service.dart';
import 'data/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  final notifications = NotificationService();
  await notifications.init();

  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(AppDatabase.defaults()),
      notificationServiceProvider.overrideWithValue(notifications),
    ],
  );

  final settings = await container.read(settingsRepositoryProvider).load();
  final router = createRouter(initialLocation: settings.onboardingDone ? AppRoutes.home : AppRoutes.onboarding);

  runApp(UncontrolledProviderScope(container: container, child: SubnestApp(router: router)));
}
