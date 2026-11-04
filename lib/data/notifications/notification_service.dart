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
  Timer? _debounce;
  bool _ready = false;

  static const _channelId = 'reminders';

  /// Router locations from notification taps while the app is running.
  Stream<String> get taps => _taps.stream;

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
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (r) {
        final p = r.payload;
        if (p != null && p.startsWith('/')) _taps.add(p);
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
      defaultDays: settings.defaultReminderDays,
      hour: settings.reminderHour,
      minute: settings.reminderMinute,
    );
    final l10n = _l10n(settings);
    final byId = {for (final s in subs) s.id: s};
    await _plugin.cancelAllPendingNotifications();
    for (final r in plan) {
      final s = byId[r.subscriptionId]!;
      await _plugin.zonedSchedule(
        id: notificationId(r.subscriptionId, r.kind),
        scheduledDate: tz.TZDateTime(
          tz.local,
          r.fireAt.year,
          r.fireAt.month,
          r.fireAt.day,
          r.fireAt.hour,
          r.fireAt.minute,
        ),
        notificationDetails: _details(l10n),
        // Inexact: no SCHEDULE_EXACT_ALARM permission (Play policy); may arrive a few minutes late.
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        title: _title(l10n, r, s),
        body: _body(l10n, r, s),
        payload: r.route,
      );
    }
    lastScheduledCount = plan.length;
  }

  /// Stable id per (subscription, kind): a later reminder of the same kind replaces the old one,
  /// but never a delivered notification of another subscription. Range 1..2^28 (test ids are 900001+
  /// — a collision is possible but harmless).
  static int notificationId(String subscriptionId, ReminderKind kind) {
    var h = 0x811c9dc5; // FNV-1a 32-bit
    for (final c in subscriptionId.codeUnits) {
      h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
    }
    return (h & 0x3FFFFFF) * 4 + kind.index + 1;
  }

  /// Developer/QA helper: shows one notification now and schedules one in [delay].
  /// Tapping either opens [route].
  Future<void> sendTest(AppSettings settings, {String route = '/home', Duration delay = const Duration(seconds: 10)}) async {
    if (!_ready) return;
    final l10n = _l10n(settings);
    await _plugin.show(
      id: 900001,
      title: l10n.notificationsTestTitle,
      body: l10n.notificationsTestBody,
      notificationDetails: _details(l10n),
      payload: route,
    );
    await _plugin.zonedSchedule(
      id: 900002,
      scheduledDate: tz.TZDateTime.now(tz.local).add(delay),
      notificationDetails: _details(l10n),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      title: l10n.notificationsTestScheduledTitle,
      body: l10n.notificationsTestBody,
      payload: route,
    );
  }

  NotificationDetails _details(AppLocalizations l10n) => NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      l10n.notificationsChannelName,
      channelDescription: l10n.notificationsChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: const DarwinNotificationDetails(),
  );

  String _title(AppLocalizations l10n, PlannedReminder r, Subscription s) {
    final amount = Fmt.moneyOf(s.myShare, l10n.localeName);
    switch (r.kind) {
      case ReminderKind.renewalSoon:
        return l10n.notificationsRenewalSoon(s.name, r.daysBefore, amount);
      case ReminderKind.trialEnding:
        return l10n.notificationsTrialEndingTitle(s.name, r.daysBefore);
      case ReminderKind.dueToday:
        return l10n.notificationsDueToday(s.name);
    }
  }

  String? _body(AppLocalizations l10n, PlannedReminder r, Subscription s) =>
      r.kind == ReminderKind.trialEnding ? l10n.notificationsTrialEndingBody : null;

  static AppLocalizations _l10n(AppSettings settings) {
    final code = settings.localeCode ?? PlatformDispatcher.instance.locale.languageCode;
    final supported = AppLocalizations.supportedLocales.any((l) => l.languageCode == code);
    return lookupAppLocalizations(Locale(supported ? code : 'en'));
  }

  void dispose() {
    _debounce?.cancel();
    _taps.close();
  }
}
