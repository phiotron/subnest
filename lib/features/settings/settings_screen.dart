import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../data/settings_repository.dart';
import '../../domain/domain.dart';
import 'about_card.dart';
import 'appearance_sheet.dart';
import 'auto_backup_section.dart';
import 'automation_screen.dart';
import 'backup_actions.dart';
import 'reminders_screen.dart';
import 'security_section.dart';
import 'settings_actions.dart';
import 'settings_format.dart';
import 'widgets/settings_bits.dart';

/// S10 Settings (mockup v14 087–093), product.md §4.10 in this order: Money · Reminders ·
/// Appearance & language · Organize · Automation (Pro) · Data (Automatic backup card, Back up now,
/// Restore, Export CSV, Erase all data) · Security · About (inline card) + the privacy note.
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
    final repo = ref.read(settingsRepositoryProvider);

    void openReminders() => Navigator.of(context).push(RemindersScreen.route());
    void toggleTabBar() => repo.setHideTabBarOnScroll(!settings.hideTabBarOnScroll);

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
                  value: reminderValue(l, settings.defaultReminderOffsets),
                  onTap: openReminders,
                ),
                ValueRow(
                  icon: LucideIcons.clock,
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
            // ---- Appearance & language ----
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
                  onTap: () => showThemeSheet(context),
                ),
                ValueRow(
                  icon: AppIcons.language,
                  label: l.settingsLanguage,
                  value: SettingsFormat.languageName(settings.localeCode ?? 'en'),
                  onTap: () => showLanguageSheet(context),
                ),
                SettingRow(
                  icon: LucideIcons.panelBottom,
                  label: l.settingsHideTabBar,
                  onTap: toggleTabBar,
                  trailing: AppToggle(
                    value: settings.hideTabBarOnScroll,
                    semanticLabel: l.settingsHideTabBar,
                    onChanged: (_) => toggleTabBar(),
                  ),
                ),
              ],
            ),
            // ---- Organize ----
            SectionHeader(label: l.settingsSectionOrganize),
            const _OrganizeGroup(),
            // ---- Automation (Pro) ----
            ProSectionHeader(l.settingsSectionAutomation),
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: LucideIcons.scanLine,
                  label: l.settingsScan,
                  subtitle: l.settingsScanHint,
                  onTap: () => Navigator.of(context).push(AutomationScreen.route()),
                ),
                SettingRow(
                  icon: AppIcons.reminderRing,
                  label: l.settingsBankNotifications,
                  trailing: SoonChip(l.settingsSoon),
                ),
                SettingRow(icon: AppIcons.mail, label: 'Gmail', trailing: SoonChip(l.settingsSoon)),
              ],
            ),
            // ---- Data ----
            SectionHeader(label: l.settingsSectionData),
            const AutoBackupSection(),
            const SizedBox(height: AppSpace.s2),
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: AppIcons.backupNow,
                  label: l.settingsBackupNow,
                  subtitle: l.settingsBackupNowHint,
                  onTap: () => BackupActions.exportJson(context, ref),
                ),
                SettingRow(
                  icon: LucideIcons.folderOpen,
                  label: l.settingsRestore,
                  subtitle: l.settingsRestoreHint,
                  onTap: () => BackupActions.restore(context, ref),
                ),
                SettingRow(
                  icon: AppIcons.csv,
                  label: l.settingsExportCsv,
                  subtitle: l.settingsExportCsvHint,
                  trailing: Icon(LucideIcons.share, size: 18, color: c.inkMuted),
                  onTap: () => BackupActions.exportCsv(context, ref),
                ),
                SettingRow(
                  icon: AppIcons.delete,
                  label: l.settingsDeleteAll,
                  danger: true,
                  onTap: () => BackupActions.deleteAll(context, ref),
                ),
              ],
            ),
            // ---- Security ----
            const SecuritySection(),
            // ---- About ----
            SectionHeader(label: l.settingsSectionAbout),
            const AboutCard(),
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

/// Categories · Labels · Payment methods (counts) · Budget (monthly total or "Not set").
class _OrganizeGroup extends ConsumerWidget {
  const _OrganizeGroup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    String count<T>(AsyncValue<List<T>> v) => v.value == null ? '' : '${v.value!.length}';
    final total = (ref.watch(budgetsProvider).value ?? const <Budget>[]).where((b) => b.isTotal).firstOrNull;
    return AppGroup(
      dividerIndent: 52,
      children: [
        ValueRow(
          icon: LucideIcons.shapes,
          label: l.manageCategoriesTitle,
          value: count(ref.watch(categoriesProvider)),
          onTap: () => context.push(AppRoutes.settingsCategories),
        ),
        ValueRow(
          icon: LucideIcons.tag,
          label: l.manageLabelsTitle,
          value: count(ref.watch(labelsProvider)),
          onTap: () => context.push(AppRoutes.settingsLabels),
        ),
        ValueRow(
          icon: LucideIcons.creditCard,
          label: l.managePaymentMethodsTitle,
          value: count(ref.watch(paymentMethodsProvider)),
          onTap: () => context.push(AppRoutes.settingsPaymentMethods),
        ),
        ValueRow(
          icon: LucideIcons.target,
          label: l.manageBudgetsTitle,
          value: total == null
              ? l.settingsBudgetNotSet
              : l.settingsBudgetValue(
                  SettingsFormat.moneyWhole(Money(total.amountMinor, total.currency), l.localeName),
                ),
          onTap: () => context.push(AppRoutes.settingsBudgets),
        ),
      ],
    );
  }
}

/// "On the day, 3 days" (each chosen offset, smallest first) / "Off".
String reminderValue(AppLocalizations l, Set<int> offsets) {
  if (offsets.isEmpty) return l.settingsReminderOff;
  return (offsets.toList()..sort()).map(l.settingsRemindChoice).join(', ');
}

/// Currencies (other than [primary]) used by the subscriptions, sorted.
List<String> usedForeignCurrencies(List<Subscription>? subs, String primary) =>
    ({for (final s in subs ?? const <Subscription>[]) s.currency}..remove(primary)).toList()..sort();
