import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../data/settings_repository.dart';
import 'app_info.dart';
import 'legal_screen.dart';
import 'licenses.dart';
import 'settings_platform.dart';
import 'widgets/app_mark.dart';

/// Small flows behind Settings rows (reminder time, system settings, About links).
abstract final class SettingsActions {
  /// Reminder time picker. `dialOnly`: the keyboard-input mode overflows (BoxConstraints not
  /// normalized) on small phones when the soft keyboard opens — seen on a Galaxy A13, Flutter 3.47.
  static Future<void> pickReminderTime(BuildContext context, WidgetRef ref, AppSettings settings) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute),
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null) await ref.read(settingsRepositoryProvider).setReminderTime(picked.hour, picked.minute);
  }

  /// Opens Subnest's notification page in system settings (S-40: we explain and link, never nag).
  /// The banner refreshes on resume (`app.dart` invalidates `notificationsEnabledProvider`).
  static Future<void> openNotificationSettings(BuildContext context, WidgetRef ref) async {
    final ok = await ref.read(settingsPlatformProvider).openNotificationSettings();
    if (!ok && context.mounted) {
      showAppToast(context, context.l10n.settingsOpenSystemSettingsFailed, icon: AppIcons.info);
    }
  }

  /// Public page when [url] is set and opens; otherwise (or offline) the bundled copy.
  static Future<void> openLegal(BuildContext context, WidgetRef ref, LegalDoc doc, {String? url}) async {
    if (url != null && await ref.read(settingsPlatformProvider).openExternal(Uri.parse(url))) return;
    if (context.mounted) await Navigator.of(context).push(LegalScreen.route(doc));
  }

  static Future<void> openPrivacyPolicy(BuildContext context, WidgetRef ref) =>
      openLegal(context, ref, LegalDoc.privacy, url: kPrivacyPolicyUrl);

  static Future<void> openTerms(BuildContext context, WidgetRef ref) =>
      openLegal(context, ref, LegalDoc.terms, url: kTermsUrl);

  /// Flutter's licence page + the font/icon licences it can't find on its own (S-70).
  static void openLicenses(BuildContext context) {
    AppLicenses.register();
    final l = context.l10n;
    showLicensePage(
      context: context,
      applicationName: l.commonAppName,
      applicationVersion: appVersionLabel,
      applicationIcon: const Padding(padding: EdgeInsets.all(AppSpace.s2), child: AppMark(size: 56, radius: 13)),
      applicationLegalese: l.settingsLegalese,
    );
  }

  /// Whether "Rate Subnest" has somewhere to go on this platform.
  static bool canRate(SettingsPlatform platform) => !platform.isIOS || kAppStoreId != null;

  /// Store page: Play (market:// then https) or the App Store review sheet.
  static Future<void> rateApp(BuildContext context, WidgetRef ref) async {
    final platform = ref.read(settingsPlatformProvider);
    final candidates = platform.isIOS
        ? [Uri.parse('https://apps.apple.com/app/id$kAppStoreId?action=write-review')]
        : [
            Uri.parse('market://details?id=$kAndroidPackage'),
            Uri.parse('https://play.google.com/store/apps/details?id=$kAndroidPackage'),
          ];
    for (final uri in candidates) {
      if (await platform.openExternal(uri)) return;
    }
    if (context.mounted) showAppToast(context, context.l10n.settingsLinkFailed, icon: AppIcons.alert);
  }

  /// `mailto:` with the version in the subject; without a mail app, shows the address instead.
  static Future<void> sendFeedback(BuildContext context, WidgetRef ref) =>
      _mail(context, ref, context.l10n.settingsFeedbackSubject(appVersionLabel));

  /// "Join early access" (Pro sheet, mockup 113): an email to support; nothing is stored or billed.
  static Future<void> joinEarlyAccess(BuildContext context, WidgetRef ref) =>
      _mail(context, ref, context.l10n.settingsEarlyAccessSubject);

  static Future<void> _mail(BuildContext context, WidgetRef ref, String subject) async {
    final l = context.l10n;
    final uri = Uri(scheme: 'mailto', path: kSupportEmail, query: 'subject=${Uri.encodeComponent(subject)}');
    final ok = await ref.read(settingsPlatformProvider).openExternal(uri);
    if (!ok && context.mounted) showAppToast(context, l.settingsNoEmailApp(kSupportEmail), icon: AppIcons.mail);
  }
}
