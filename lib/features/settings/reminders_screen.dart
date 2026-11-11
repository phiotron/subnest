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

/// S10 › Reminders (mockup 095–096): permission banner, the default offsets (any combination of
/// On the day · 1 · 3 · 7 days), time, note, preview.
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
                padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
                children: [
                  const SizedBox(height: AppSpace.s2),
                  if (notificationsOn == false) ...[
                    AppBanner(
                      kind: BannerKind.warning,
                      icon: AppIcons.remindersOff,
                      title: l.settingsNotificationsOffTitle,
                      body: l.settingsNotificationsOffBody,
                      actionLabel: l.settingsOpenSystemSettings,
                      onAction: () => SettingsActions.openNotificationSettings(context, ref),
                    ),
                    const SizedBox(height: AppSpace.s2),
                  ],
                  AppGroup(
                    dividerIndent: 0,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(AppSpace.s4, 14, AppSpace.s4, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(l.settingsRemindBefore, style: AppType.label.copyWith(color: c.ink)),
                            const SizedBox(height: AppSpace.s2),
                            _OffsetChips(
                              selected: settings.defaultReminderOffsets,
                              onChanged: repo.setDefaultReminderOffsets,
                            ),
                            const SizedBox(height: AppSpace.s1),
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
                    offsets: settings.defaultReminderOffsets,
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

/// `.chips.fit`: four chips on one row (6 px apart), each on or off; at large text they wrap.
class _OffsetChips extends StatelessWidget {
  const _OffsetChips({required this.selected, required this.onChanged});

  final Set<int> selected;
  final ValueChanged<Set<int>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final large = MediaQuery.textScalerOf(context).scale(10) >= 13;
    Widget chip(int d, {required bool fit}) => AppChip(
      label: l.settingsRemindChoice(d),
      selected: selected.contains(d),
      fit: fit,
      showCheck: false,
      onTap: () => onChanged(selected.contains(d) ? ({...selected}..remove(d)) : {...selected, d}),
    );
    if (large) {
      return Wrap(spacing: 6, children: [for (final d in ReminderOffsets.choices) chip(d, fit: false)]);
    }
    return Row(
      children: [
        for (final (i, d) in ReminderOffsets.choices.indexed) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(child: chip(d, fit: true)),
        ],
      ],
    );
  }
}

/// The reminder the user would get, built from the real notification strings (S12) and their
/// next renewal — or a sample when there is none yet. Shows the earliest reminder (largest offset).
class _Preview extends ConsumerWidget {
  const _Preview({required this.offsets, required this.hour, required this.minute});

  final Set<int> offsets;
  final int hour;
  final int minute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    if (offsets.isEmpty) return ListNote(l.settingsPreviewOff, top: 0);
    final days = offsets.reduce((a, b) => a > b ? a : b);
    final today = ref.watch(todayProvider);
    // The next real renewal it would be about: Active, not waiting for a confirmation (that one
    // already had its reminder — real phone QA showed "Gym Fit renews in 3 days" for a period due today).
    final subs = [
      for (final s in ref.watch(subscriptionsProvider).value ?? const <Subscription>[])
        if (BillingRules.effectiveStatus(s, today) == SubscriptionStatus.active &&
            !BillingRules.isAwaitingConfirmation(s, today))
          s,
    ]..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final primary = ref.watch(primaryCurrencyProvider);
    final name = subs.isEmpty ? l.settingsPreviewSampleName : subs.first.name;
    final share = subs.isEmpty ? Money.major(primary == 'VND' ? 260000 : 15.49, primary) : subs.first.myShare;
    final body = days == 0 ? l.notificationsDueToday(name) : l.notificationsRenewalSoon(name, days, l.money(share));
    return NotificationPreview(
      appName: l.commonAppName,
      time: TimeOfDay(hour: hour, minute: minute).format(context),
      body: body,
    );
  }
}
