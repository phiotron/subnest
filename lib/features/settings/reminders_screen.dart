import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import 'settings_actions.dart';
import 'widgets/settings_bits.dart';

/// S10 › Reminders (png 54): permission banner, default "remind before", time, preview.
/// Pushed with [route] (no go_router path yet — see notes).
class RemindersScreen extends ConsumerWidget {
  const RemindersScreen({super.key});

  static Route<void> route() => MaterialPageRoute(builder: (_) => const RemindersScreen());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    final notificationsOn = ref.watch(notificationsEnabledProvider).value;
    final repo = ref.read(settingsRepositoryProvider);

    return Scaffold(
      appBar: AppTopBar(title: l.settingsSectionReminders),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s6),
                children: [
                  if (notificationsOn == false) ...[
                    AppBanner(
                      kind: BannerKind.warning,
                      icon: AppIcons.remindersOff,
                      title: l.settingsNotificationsOffTitle,
                      body: l.settingsNotificationsOffBody,
                      actionLabel: l.settingsOpenSystemSettings,
                      onAction: () => SettingsActions.openNotificationSettings(context, ref),
                    ),
                    const SizedBox(height: AppSpace.s4),
                  ],
                  AppGroup(
                    dividerIndent: 0,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s4, AppSpace.s4, AppSpace.s2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(l.settingsRemindBefore, style: AppType.label.copyWith(color: c.ink)),
                            const SizedBox(height: AppSpace.s2),
                            AppSegmentedControl<int>(
                              selected: settings.defaultReminderDays,
                              onChanged: repo.setDefaultReminderDays,
                              segments: [
                                for (final d in ReminderDays.choices)
                                  AppSegment(
                                    value: d,
                                    label: d == ReminderDays.off ? l.settingsReminderOff : l.settingsRemindChoice(d),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpace.s2),
                            Text(l.settingsRemindTrialNote, style: AppType.meta.copyWith(color: c.inkMuted)),
                          ],
                        ),
                      ),
                      ValueRow(
                        icon: AppIcons.awaiting,
                        label: l.settingsReminderTimeShort,
                        value: TimeOfDay(hour: settings.reminderHour, minute: settings.reminderMinute).format(context),
                        onTap: () => SettingsActions.pickReminderTime(context, ref, settings),
                      ),
                    ],
                  ),
                  ListNote(l.settingsRemindersNote),
                  SectionHeader(label: l.settingsPreview),
                  _Preview(
                    days: settings.defaultReminderDays,
                    hour: settings.reminderHour,
                    minute: settings.reminderMinute,
                  ),
                  if (kDebugMode) ...[
                    const SizedBox(height: AppSpace.s6),
                    AppGroup(
                      dividerIndent: 52,
                      children: [
                        SettingRow(
                          icon: AppIcons.reminderRing,
                          label: l.settingsTestReminder,
                          subtitle: l.settingsTestReminderHint,
                          onTap: () async {
                            await ref.read(notificationServiceProvider).sendTest(settings, route: AppRoutes.awaiting);
                            if (context.mounted) showAppToast(context, l.settingsTestReminderSent);
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

/// The reminder the user would get, built from the real notification strings (S12) and their
/// next renewal — or a Netflix sample when there is none yet.
class _Preview extends ConsumerWidget {
  const _Preview({required this.days, required this.hour, required this.minute});

  final int days;
  final int hour;
  final int minute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (days == ReminderDays.off) return ListNote(l.settingsPreviewOff, top: 0);
    final today = ref.watch(todayProvider);
    final subs = [
      for (final s in ref.watch(subscriptionsProvider).value ?? const <Subscription>[])
        if (BillingRules.effectiveStatus(s, today) != SubscriptionStatus.cancelled) s,
    ]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final primary = ref.watch(primaryCurrencyProvider);
    final name = subs.isEmpty ? 'Netflix' : subs.first.name;
    final share = subs.isEmpty ? Money.major(primary == 'VND' ? 260000 : 15.49, primary) : subs.first.myShare;
    final body = days == ReminderDays.onTheDay
        ? l.notificationsDueToday(name)
        : l.notificationsRenewalSoon(name, days, l.money(share));
    return NotificationPreview(
      appName: l.commonAppName,
      time: TimeOfDay(hour: hour, minute: minute).format(context),
      body: body,
    );
  }
}
