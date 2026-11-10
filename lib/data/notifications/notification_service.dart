import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../core/utils/format.dart';
import '../../domain/domain.dart';
import '../../l10n/generated/app_localizations.dart';
import '../backup/backup_schedule.dart';
import '../settings_repository.dart';

/// Local reminders (F3). Strategy: after any change to subscriptions/settings, on app start
/// and on resume, cancel all *pending* notifications and schedule exactly `ReminderPlanner.plan(...)`.
/// Already-delivered notifications stay in the shade (never `cancelAll`, which removes them too).
/// The plugin's boot receiver restores pending notifications after a reboot on Android;
/// iOS keeps them across reboots natively.
///
/// Notifications have no action buttons (ADR 0001). The payload is a router location
/// (`/confirm/<id>` or `/subscription/<id>`), delivered through [taps] or [launchRoute].
class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final _taps = StreamController<String>.broadcast();
  final _autoBackupTaps = StreamController<void>.broadcast();
  Timer? _debounce;
  bool _ready = false;

  static const _channelId = 'reminders';

  /// Router locations from notification taps while the app is running.
  Stream<String> get taps => _taps.stream;

  /// Taps on the iOS "time to back up" notification ([autoBackupPayload]); `main.dart` runs the
  /// backup catch-up. Kept apart from [taps], which only carries router locations.
  Stream<void> get autoBackupTaps => _autoBackupTaps.stream;

  /// Location to open when the app was launched by tapping a notification.
  String? launchRoute;

  /// Number of notifications scheduled by the last [sync] (for diagnostics).
  int lastScheduledCount = 0;

  bool get _supported => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  Future<void> init() async {
    if (!_supported) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (_) {
      // Unknown zone id → keep timezone's default (UTC); reminders may shift by the offset.
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/$smallIcon'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) {
        final p = r.payload;
        if (p == autoBackupPayload) {
          _autoBackupTaps.add(null);
        } else if (p != null && p.startsWith('/')) {
          _taps.add(p);
        }
      },
    );
    final launch = await _plugin.getNotificationAppLaunchDetails();
    if (launch?.didNotificationLaunchApp ?? false) {
      final p = launch!.notificationResponse?.payload;
      if (p != null && p.startsWith('/')) launchRoute = p;
    }
    _ready = true;
  }

  /// Shows the OS permission prompt (Android 13+ / iOS). Returns whether notifications are allowed.
  Future<bool> requestPermission() async {
    if (!_ready) return false;
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(alert: true, badge: true, sound: true) ?? false;
  }

  /// Asks for permission; when the OS no longer shows its prompt (Android after the user denied it,
  /// iOS after the first answer) the request returns "no" at once — then open Subnest's page in
  /// the system settings instead, so "Turn on" is never a dead button (S-31). A denial in the
  /// prompt itself takes the user's time, so it is respected (S-40: never nag).
  Future<bool> requestPermissionOrOpenSettings({Duration promptShownAfter = const Duration(milliseconds: 600)}) async {
    final watch = Stopwatch()..start();
    if (await requestPermission()) return true;
    if (watch.elapsed < promptShownAfter) await openSettings();
    return false;
  }

  /// Subnest's notification page in the system settings (falls back to the app's settings page).
  Future<bool> openSettings() async {
    if (!_ready) return false;
    try {
      if (Platform.isAndroid) {
        final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        return await android?.openAppNotificationSettings() ?? false;
      }
      final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
      return await ios?.openAppNotificationSettings() ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Whether the user currently allows notifications (for the "Reminders are off" banner).
  Future<bool> areEnabled() async {
    if (!_ready) return false;
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      return await android?.areNotificationsEnabled() ?? false;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    final opts = await ios?.checkPermissions();
    return opts?.isEnabled ?? false;
  }

  /// Id of the iOS "time to back up" notification, separate from reminders.
  static const autoBackupNotificationId = 1002;

  /// iOS: iOS does not let a closed app run at an exact time, so a daily local
  /// notification at the chosen time; tapping it (or opening the app any time
  /// after) runs the backup catch-up. Android runs a background job instead and
  /// never calls this.
  Future<void> scheduleAutoBackup(BackupTime time, {required String title, required String body}) async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: autoBackupNotificationId);
      await _plugin.zonedSchedule(
        id: autoBackupNotificationId,
        scheduledDate: tz.TZDateTime.from(
          nextSlot(
            tz.TZDateTime.now(tz.local),
            time,
            at: (y, mo, d, h, mi) => tz.TZDateTime(tz.local, y, mo, d, h, mi),
          ),
          tz.local,
        ),
        title: title,
        body: body,
        payload: autoBackupPayload,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails('auto_backup', 'Auto backup'),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (_) {}
  }

  Future<void> cancelAutoBackup() async {
    if (!_ready) return;
    try {
      await _plugin.cancel(id: autoBackupNotificationId);
    } catch (_) {}
  }

  /// Debounced re-schedule of all reminders.
  void scheduleSync(List<Subscription> subs, AppSettings settings, {Duration delay = const Duration(milliseconds: 400)}) {
    _debounce?.cancel();
    _debounce = Timer(delay, () => sync(subs, settings));
  }

  Future<void> sync(List<Subscription> subs, AppSettings settings, {DateTime? now}) async {
    if (!_ready) return;
    final plan = ReminderPlanner.plan(
      subs,
      now: now ?? DateTime.now(),
      defaultOffsets: settings.defaultReminderOffsets,
      hour: settings.reminderHour,
      minute: settings.reminderMinute,
    );
    final l10n = _l10n(settings);
    final byId = {for (final s in subs) s.id: s};
    await _cancelPendingReminders();
    for (final r in plan) {
      final s = byId[r.subscriptionId]!;
      await _plugin.zonedSchedule(
        id: notificationId(r.subscriptionId, r.kind, daysBefore: r.daysBefore),
        scheduledDate: tz.TZDateTime(
          tz.local,
          r.fireAt.year,
          r.fireAt.month,
          r.fireAt.day,
          r.fireAt.hour,
          r.fireAt.minute,
        ),
        notificationDetails: details(l10n, reminderText(l10n, r, s)),
        // Inexact: no SCHEDULE_EXACT_ALARM permission (Play policy); may arrive a few minutes late.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        // No title: the OS shows "Subnest" above the sentence, as in design png 58 (S12). The
        // sentence as title was bold, heavy and cut to one line in the shade.
        title: null,
        body: reminderText(l10n, r, s),
        payload: r.route,
      );
    }
    lastScheduledCount = plan.length;
  }

  /// Cancels every pending reminder ("Delete all data"); delivered ones stay in the shade.
  Future<void> cancelReminders() async {
    if (!_ready) return;
    try {
      await _cancelPendingReminders();
    } catch (_) {}
  }

  /// Every pending notification except the iOS "time to back up" one, which has its own schedule
  /// (`autoBackupScheduleSyncProvider`) and must survive a reminder re-sync.
  Future<void> _cancelPendingReminders() async {
    final pending = await _plugin.pendingNotificationRequests();
    for (final p in pending) {
      if (p.id != autoBackupNotificationId) await _plugin.cancel(id: p.id);
    }
  }

  /// Stable id per (subscription, kind, days before — multi-point reminders): a later reminder of the same kind replaces the old one,
  /// but never a delivered notification of another subscription. Range 1..2^28 (test ids are 900001+
  /// — a collision is possible but harmless).
  static int notificationId(String subscriptionId, ReminderKind kind, {int daysBefore = 0}) {
    var h = 0x811c9dc5; // FNV-1a 32-bit
    for (final c in subscriptionId.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
    }
    return (h & 0x1FFFFF) * 128 + kind.index * 32 + daysBefore.clamp(0, 31) + 1;
  }

  /// Developer/QA helper: shows one notification now and schedules one in [delay].
  /// Tapping either opens [route].
  Future<void> sendTest(AppSettings settings, {String route = '/home', Duration delay = const Duration(seconds: 10)}) async {
    if (!_ready) return;
    final l10n = _l10n(settings);
    await _plugin.show(
      id: 900001,
      title: null,
      body: '${l10n.notificationsTestTitle}. ${l10n.notificationsTestBody}',
      notificationDetails: details(l10n, '${l10n.notificationsTestTitle}. ${l10n.notificationsTestBody}'),
      payload: route,
    );
    await _plugin.zonedSchedule(
      id: 900002,
      scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
      notificationDetails: details(l10n, '${l10n.notificationsTestScheduledTitle}. ${l10n.notificationsTestBody}'),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: null,
      body: '${l10n.notificationsTestScheduledTitle}. ${l10n.notificationsTestBody}',
      payload: route,
    );
  }

  /// Monochrome status-bar icon (android/app/src/main/res/drawable-*/ic_stat_subnest.png, made by
  /// assets/icons/brand/make_notification_icon.py). A full-colour launcher icon is tinted into a blob.
  static const smallIcon = 'ic_stat_subnest';

  /// Brand teal (`brand` light token) for the small icon and app name — not a coloured background.
  static const accent = Color(0xFF0E6B63);

  /// Big-text style for every reminder so a long sentence (trial ending, long names, VI) is never cut
  /// when expanded; `color` tints the icon and "Subnest" in the brand teal.
  @visibleForTesting
  static NotificationDetails details(AppLocalizations l10n, String text) => NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      l10n.notificationsChannelName,
      channelDescription: l10n.notificationsChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: smallIcon,
      color: accent,
      styleInformation: BigTextStyleInformation(text),
    ),
    iOS: const DarwinNotificationDetails(),
  );

  /// The one sentence of a reminder (product.md S12), shown as the notification body.
  @visibleForTesting
  static String reminderText(AppLocalizations l10n, PlannedReminder r, Subscription s) {
    final amount = Fmt.moneyOf(s.myShare, l10n.localeName);
    return switch (r.kind) {
      ReminderKind.renewalSoon => l10n.notificationsRenewalSoon(s.name, r.daysBefore, amount),
      ReminderKind.trialEnding =>
        '${l10n.notificationsTrialEndingTitle(s.name, r.daysBefore)} ${l10n.notificationsTrialEndingBody}',
      ReminderKind.dueToday => l10n.notificationsDueToday(s.name),
    };
  }

  static AppLocalizations _l10n(AppSettings settings) {
    final code = settings.localeCode ?? PlatformDispatcher.instance.locale.languageCode;
    final supported = AppLocalizations.supportedLocales.any((l) => l.languageCode == code);
    return lookupAppLocalizations(Locale(supported ? code : 'en'));
  }

  void dispose() {
    _debounce?.cancel();
    _taps.close();
    _autoBackupTaps.close();
  }
}
