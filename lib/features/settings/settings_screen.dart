import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../data/providers.dart';
import '../../data/settings_repository.dart';
import '../../domain/domain.dart';

/// S10 Settings — PLACEHOLDER UI. Owned by the Settings & backup session (J).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final repo = ref.read(settingsRepositoryProvider);
    final notificationsOn = ref.watch(notificationsEnabledProvider).value;
    if (settings == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final time = TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute);

    return Scaffold(
      appBar: AppBar(title: Text(l.commonTabSettings)),
      body: ListView(
        children: [
          _Header(l.settingsCurrencySection),
          ListTile(
            title: Text(l.settingsPrimaryCurrency),
            trailing: Text(settings.primaryCurrency),
            onTap: () => context.push(AppRoutes.settingsCurrency),
          ),
          ListTile(
            title: Text(l.settingsRates),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.settingsRates),
          ),
          _Header(l.settingsRemindersSection),
          ListTile(
            title: Text(l.settingsDefaultReminder),
            trailing: DropdownButton<int>(
              value: settings.defaultReminderDays,
              items: [for (final d in ReminderDays.choices) DropdownMenuItem(value: d, child: Text(l.reminder(d)))],
              onChanged: (d) => repo.setDefaultReminderDays(d!),
            ),
          ),
          ListTile(
            title: Text(l.settingsReminderTime),
            trailing: Text(time.format(context)),
            onTap: () async {
              // dialOnly: the keyboard-input mode overflows (BoxConstraints not normalized) on small
              // phones when the soft keyboard opens — seen on a Galaxy A13, Flutter 3.47.
              final picked = await showTimePicker(
                context: context,
                initialTime: time,
                initialEntryMode: TimePickerEntryMode.dialOnly,
              );
              if (picked != null) await repo.setReminderTime(picked.hour, picked.minute);
            },
          ),
          ListTile(
            title: Text(l.settingsPermission),
            subtitle: Text(notificationsOn == false ? l.settingsPermissionOff : l.settingsPermissionOn),
            trailing: notificationsOn == false
                ? TextButton(
                    onPressed: () async {
                      await ref.read(notificationServiceProvider).requestPermission();
                      ref.invalidate(notificationsEnabledProvider);
                    },
                    child: Text(l.settingsPermissionAllow),
                  )
                : null,
          ),
          ListTile(
            title: Text(l.settingsTestReminder),
            subtitle: Text(l.settingsTestReminderHint),
            onTap: () async {
              await ref.read(notificationServiceProvider).sendTest(settings, route: AppRoutes.awaiting);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.settingsTestReminderSent)));
              }
            },
          ),
          _Header(l.settingsAppearanceSection),
          ListTile(
            title: Text(l.settingsTheme),
            trailing: DropdownButton<AppThemeMode>(
              value: settings.themeMode,
              items: [
                DropdownMenuItem(value: AppThemeMode.system, child: Text(l.settingsFollowSystem)),
                DropdownMenuItem(value: AppThemeMode.light, child: Text(l.settingsThemeLight)),
                DropdownMenuItem(value: AppThemeMode.dark, child: Text(l.settingsThemeDark)),
              ],
              onChanged: (m) => repo.setThemeMode(m!),
            ),
          ),
          ListTile(
            title: Text(l.settingsLanguage),
            trailing: DropdownButton<String?>(
              value: settings.localeCode,
              items: [
                DropdownMenuItem<String?>(value: null, child: Text(l.settingsFollowSystem)),
                const DropdownMenuItem<String?>(value: 'en', child: Text('English')),
                const DropdownMenuItem<String?>(value: 'vi', child: Text('Tiếng Việt')),
              ],
              onChanged: repo.setLocale,
            ),
          ),
          _Header(l.settingsBackupSection),
          ListTile(
            title: Text(l.settingsBackup),
            subtitle: Text(
              settings.lastBackupAt == null
                  ? l.settingsNeverBackedUp
                  : l.settingsLastBackup(l.date(LocalDate.fromDateTime(settings.lastBackupAt!))),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.settingsBackup),
          ),
          _Header(l.settingsAboutSection),
          ListTile(title: Text(l.settingsPrivacyNote), leading: const Icon(Icons.lock_outline)),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}
