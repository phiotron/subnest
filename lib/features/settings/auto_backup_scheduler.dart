import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../data/backup/backup_schedule.dart';
import '../../data/notifications/notification_service.dart';

/// Schedules automatic backups at the time the user chose. Tests replace it with
/// a fake. The real implementations swallow platform errors.
abstract class AutoBackupScheduler {
  /// Sets (or resets) the daily schedule at [time] in local time. [title], [body]
  /// are notification copy (only iOS uses them).
  Future<void> schedule(BackupTime time, {required String title, required String body});

  /// Cancels the schedule (auto backup turned off).
  Future<void> cancel();

  /// Whether this platform needs notification permission (iOS: yes; Android
  /// background job: no).
  bool get usesNotification;

  /// Whether notification permission is already granted (no prompt). Android
  /// always true here.
  Future<bool> hasNotificationPermission();
}

/// Does nothing (other platforms, tests).
class NoopAutoBackupScheduler implements AutoBackupScheduler {
  const NoopAutoBackupScheduler();

  @override
  Future<void> schedule(BackupTime time, {required String title, required String body}) async {}

  @override
  Future<void> cancel() async {}

  @override
  bool get usesNotification => false;

  @override
  Future<bool> hasNotificationPermission() async => true;
}

/// Android: the `subnest/backup_schedule` channel to `BackupSchedule.kt`. Kotlin
/// stores the time (not secret) in its own SharedPreferences so it can restore
/// the schedule after reboot/app update/time-zone change without Dart, then sets
/// an INEXACT alarm (`setAndAllowWhileIdle`, no exact-alarm permission). When it
/// fires, `BackupJobService` runs the Dart background entrypoint
/// (`autoBackupBackgroundMain`).
class AndroidAutoBackupScheduler implements AutoBackupScheduler {
  const AndroidAutoBackupScheduler([this.channel = const MethodChannel(name)]);

  static const name = 'subnest/backup_schedule';

  final MethodChannel channel;

  @override
  Future<void> schedule(BackupTime time, {required String title, required String body}) async {
    try {
      await channel.invokeMethod<void>('schedule', {'hour': time.hour, 'minute': time.minute});
    } catch (_) {
      // No channel (tests) or a system error: the open/resume catch-up still works.
    }
  }

  @override
  Future<void> cancel() async {
    try {
      await channel.invokeMethod<void>('cancel');
    } catch (_) {}
  }

  @override
  bool get usesNotification => false;

  @override
  Future<bool> hasNotificationPermission() async => true;
}

/// iOS: a daily local notification at the chosen time; tapping it (or opening
/// the app any time after) runs the catch-up. Uses the app's single
/// [NotificationService] plugin so the tap handler is never replaced.
class IosAutoBackupScheduler implements AutoBackupScheduler {
  const IosAutoBackupScheduler(this._notifications);

  final NotificationService _notifications;

  @override
  Future<void> schedule(BackupTime time, {required String title, required String body}) =>
      _notifications.scheduleAutoBackup(time, title: title, body: body);

  @override
  Future<void> cancel() => _notifications.cancelAutoBackup();

  @override
  bool get usesNotification => true;

  @override
  Future<bool> hasNotificationPermission() => _notifications.areEnabled();
}

/// The right implementation for the running platform.
AutoBackupScheduler platformAutoBackupScheduler(NotificationService notifications) =>
    switch (defaultTargetPlatform) {
      TargetPlatform.android => const AndroidAutoBackupScheduler(),
      TargetPlatform.iOS => IosAutoBackupScheduler(notifications),
      _ => const NoopAutoBackupScheduler(),
    };
