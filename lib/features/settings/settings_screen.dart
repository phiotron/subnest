import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../data/settings_repository.dart';
import '../../domain/domain.dart';
import 'app_info.dart';
import 'appearance_sheet.dart';
import 'auto_backup_section.dart';
import 'backup_actions.dart';
import 'reminders_screen.dart';
import 'security_section.dart';
import 'settings_actions.dart';
import 'settings_format.dart';
import 'settings_platform.dart';
import 'widgets/settings_bits.dart';

/// S10 Settings (png 48, 49): Money · Reminders · Appearance · Data · Security · About + privacy card.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    if (settings == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final notificationsOn = ref.watch(notificationsEnabledProvider).value;
    final now = ref.watch(clockProvider)();
    final platform = ref.watch(settingsPlatformProvider);

    void openReminders() => Navigator.of(context).push(RemindersScreen.route());

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
          children: [
            LargeTitle(title: l.commonTabSettings),
            // ---- Money ----
            SectionHeader(label: l.settingsSectionMoney),
            AppGroup(
              dividerIndent: 52,
              children: [
                ValueRow(
                  icon: AppIcons.currency,
                  label: l.settingsPrimaryCurrency,
                  value: settings.primaryCurrency,
                  onTap: () => context.push(AppRoutes.settingsCurrency),
                ),
                ValueRow(
                  icon: AppIcons.refresh,
                  label: l.settingsRates,
                  value: _ratesSummary(ref, l, now),
                  onTap: () => context.push(AppRoutes.settingsRates),
                ),
              ],
            ),
            // ---- Reminders ----
            SectionHeader(label: l.settingsSectionReminders),
            AppGroup(
              dividerIndent: 52,
              children: [
                ValueRow(
                  icon: AppIcons.reminder,
                  label: l.settingsRemindMe,
                  value: reminderValue(l, settings.defaultReminderDays),
                  onTap: openReminders,
                ),
                ValueRow(
                  icon: AppIcons.awaiting,
                  label: l.settingsReminderTime,
                  value: TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute).format(context),
                  onTap: () => SettingsActions.pickReminderTime(context, ref, settings),
                ),
                ValueRow(
                  icon: AppIcons.reminderRing,
                  label: l.settingsNotifications,
                  value: switch (notificationsOn) {
                    null => '',
                    true => l.settingsNotificationsOn,
                    false => l.settingsNotificationsOff,
                  },
                  valueColor: notificationsOn == false ? c.warningInk : null,
                  valueWeight: notificationsOn == false ? FontWeight.w600 : null,
                  onTap: openReminders,
                ),
              ],
            ),
            // ---- Appearance ----
            SectionHeader(label: l.settingsSectionAppearance),
            AppGroup(
              dividerIndent: 52,
              children: [
                ValueRow(
                  icon: AppIcons.theme,
                  label: l.settingsTheme,
                  value: switch (settings.themeMode) {
                    AppThemeMode.system => l.settingsSystem,
                    AppThemeMode.light => l.settingsThemeLight,
                    AppThemeMode.dark => l.settingsThemeDark,
                  },
                  onTap: () => showAppearanceSheet(context),
                ),
                ValueRow(
                  icon: AppIcons.language,
                  label: l.settingsLanguage,
                  value: SettingsFormat.languageName(settings.localeCode ?? 'en'),
                  onTap: () => showAppearanceSheet(context),
                ),
              ],
            ),
            // ---- Data ----
            SectionHeader(label: l.settingsSectionData),
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: AppIcons.backup,
                  label: l.settingsExportBackup,
                  subtitle: l.settingsExportBackupHint,
                  trailing: Icon(AppIcons.restoreFile, size: 18, color: c.inkMuted),
                  onTap: () => BackupActions.exportJson(context, ref),
                ),
                SettingRow(
                  icon: AppIcons.restore,
                  label: l.settingsRestore,
                  onTap: () => BackupActions.restore(context, ref),
                ),
                SettingRow(
                  icon: AppIcons.csv,
                  label: l.settingsExportCsv,
                  subtitle: l.settingsExportCsvHint,
                  trailing: Icon(AppIcons.restoreFile, size: 18, color: c.inkMuted),
                  onTap: () => BackupActions.exportCsv(context, ref),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.s2),
            AutoBackupSection(
              extraRows: [
                Divider(height: 1, thickness: 1, indent: 52, color: c.line),
                SettingRow(
                  icon: AppIcons.delete,
                  label: l.settingsDeleteAll,
                  subtitle: l.settingsDeleteAllHint,
                  danger: true,
                  onTap: () => BackupActions.deleteAll(context, ref),
                ),
              ],
            ),
            ListNote(l.settingsDataNote),
            // ---- Security ----
            const SecuritySection(),
            // ---- About ----
            SectionHeader(label: l.settingsSectionAbout),
            AppGroup(
              dividerIndent: 52,
              children: [
                ValueRow(icon: AppIcons.info, label: l.settingsVersion, value: appVersionLabel, chevron: false),
                SettingRow(
                  icon: AppIcons.secure,
                  label: l.settingsPrivacyPolicy,
                  external: kPrivacyPolicyUrl != null,
                  onTap: () => SettingsActions.openPrivacyPolicy(context, ref),
                ),
                SettingRow(
                  icon: LucideIcons.fileText,
                  label: l.settingsTerms,
                  external: kTermsUrl != null,
                  onTap: () => SettingsActions.openTerms(context, ref),
                ),
                SettingRow(
                  icon: LucideIcons.scrollText,
                  label: l.settingsLicenses,
                  onTap: () => SettingsActions.openLicenses(context),
                ),
                SettingRow(
                  icon: LucideIcons.image,
                  label: l.settingsLogosTitle,
                  subtitle: l.settingsLogosOwnership,
                  chevron: false,
                ),
                if (SettingsActions.canRate(platform))
                  SettingRow(
                    icon: AppIcons.rate,
                    label: l.settingsRateApp,
                    external: true,
                    onTap: () => SettingsActions.rateApp(context, ref),
                  ),
                SettingRow(
                  icon: AppIcons.mail,
                  label: l.settingsFeedback,
                  external: true,
                  onTap: () => SettingsActions.sendFeedback(context, ref),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.s6),
            PrivacyNote(l.settingsPrivacyNote),
          ],
        ),
      ),
    );
  }

  /// "Auto · 2 h ago" · "Built-in" · "Set by you" (when every converted pair is overridden).
  String _ratesSummary(WidgetRef ref, AppLocalizations l, DateTime now) {
    final rates = ref.watch(ratesProvider).value ?? ExchangeRates.empty;
    final primary = ref.watch(primaryCurrencyProvider);
    final used = usedForeignCurrencies(ref.watch(subscriptionsProvider).value, primary);
    if (used.isNotEmpty && used.every((c) => rates.isOverridden(c, primary))) return l.settingsRatesSummaryManual;
    final at = rates.fetchedAt;
    if (at == null) return l.settingsRatesSummaryBuiltIn;
    return l.settingsRatesSummaryAuto(SettingsFormat.ago(l, at, now, short: true));
  }
}

/// "3 days before" / "On the day" / "Off".
String reminderValue(AppLocalizations l, int days) =>
    days == ReminderDays.off ? l.settingsReminderOff : l.settingsReminderValue(days);

/// Currencies (other than [primary]) used by the subscriptions, sorted.
List<String> usedForeignCurrencies(List<Subscription>? subs, String primary) =>
    ({for (final s in subs ?? const <Subscription>[]) s.currency}..remove(primary)).toList()..sort();
