import 'dart:async';
import 'dart:ui' show DartPluginRegistrant;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/router/app_router.dart';
import 'core/router/routes.dart';
import 'data/backup/auto_backup_background.dart';
import 'data/backup/auto_backup_service.dart';
import 'data/db/app_database.dart';
import 'data/notifications/notification_service.dart';
import 'data/providers.dart';
import 'data/settings_repository.dart';
import 'features/settings/auto_backup_providers.dart';

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
  AutoBackupService.onAutomaticFailure = (_) async =>
      notifications.showBackupFailed(await container.read(settingsRepositoryProvider).load());
  final router = createRouter(initialLocation: settings.onboardingDone ? AppRoutes.home : AppRoutes.onboarding);

  runAutoBackupOnOpen(container);
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: SubnestApp(router: router),
    ),
  );
}

/// Automatic backup (F7) inside the app:
/// - keeps the schedule (Android background alarm, iOS notification) in step with the saved
///   configuration;
/// - CATCH-UP when a slot was missed: on app OPEN (a few seconds after the first frame, so it
///   does not compete with startup) and on every RESUME, on both platforms; on Android it also
///   catches up when the app goes to the background;
/// - iOS: tapping the "Time to back up" notification also runs the catch-up.
/// The "at most once per slot, only when data changed" rule lives in
/// `AutoBackupService.maybeRunIfDue`; it never throws.
void runAutoBackupOnOpen(ProviderContainer container, {Duration delay = const Duration(seconds: 3)}) {
  void run() => unawaited(container.read(autoBackupServiceProvider).maybeRunOnOpen());
  container.listen(autoBackupScheduleSyncProvider, (_, _) {});
  container.read(notificationServiceProvider).autoBackupTaps.listen((_) => run());
  WidgetsBinding.instance.addPostFrameCallback((_) => Timer(delay, run));
  // Lives with the app; nothing to remove.
  AppLifecycleListener(
    onResume: run,
    onPause: () => unawaited(container.read(autoBackupServiceProvider).maybeRunDaily()),
  );
}

/// Dart entrypoint while the app is CLOSED (Android): `BackupJobService.kt` builds a headless
/// FlutterEngine and runs this when the backup alarm fires. When done (success or failure) it
/// reports `done` so Kotlin finishes the job and destroys the engine.
@pragma('vm:entry-point')
Future<void> autoBackupBackgroundMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  final result = await runScheduledAutoBackup(openDatabase: AppDatabase.defaults);
  if (AutoBackupService.isFailure(result)) await _notifyBackupFailed();
  try {
    await const MethodChannel(backupJobChannel).invokeMethod<void>('done', result?.name);
  } catch (_) {
    // Kotlin finishes after the timeout.
  }
}

/// Background engine: "Backup failed" notification in the user's language. Never throws.
Future<void> _notifyBackupFailed() async {
  AppDatabase? db;
  try {
    db = AppDatabase.defaults();
    final settings = await SettingsRepository(db).load();
    final notifications = NotificationService();
    await notifications.init();
    await notifications.showBackupFailed(settings);
  } catch (_) {
  } finally {
    try {
      await db?.close();
    } catch (_) {}
  }
}

/// Channel that reports completion to `BackupJobService.kt`.
const backupJobChannel = 'subnest/backup_job';
