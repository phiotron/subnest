import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/backup/auto_backup_service.dart';
import '../../data/backup/backup_folder_service.dart';
import '../../data/backup/backup_schedule.dart';
import '../../data/providers.dart';
import 'auto_backup_providers.dart';
import 'auto_backup_screen.dart';
import 'widgets/settings_bits.dart';

/// "Automatic backup" card at the top of Settings › Data (mockup 088 on, 091 off): database icon,
/// title, a status line (✓ last backup in `success`, a failure in `danger`) and the switch; when on,
/// Folder · Time · Password · Keeps under a hairline. Tapping the card opens the Automatic backup
/// screen (folder, time, Back up now); the switch turns it on (set-up screen) or off.
class AutoBackupSection extends ConsumerStatefulWidget {
  const AutoBackupSection({super.key});

  @override
  ConsumerState<AutoBackupSection> createState() => _AutoBackupSectionState();
}

/// Refreshes the state when Settings opens and when the app returns from the background: a
/// background backup may just have failed (never fail silently).
class _AutoBackupSectionState extends ConsumerState<AutoBackupSection> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      if (mounted) ref.invalidate(autoBackupStateProvider);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) ref.invalidate(autoBackupStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final state = ref.watch(autoBackupStateProvider).value ?? const AutoBackupState();
    final ios = Theme.of(context).platform == TargetPlatform.iOS;
    final on = state.enabled;

    void toggle() => on ? disableAutoBackup(context, ref, l) : enableAutoBackup(context, ref);

    final status = !on
        ? Text(l.settingsAutoBackupOffNote, style: AppType.meta.copyWith(color: c.inkMuted))
        : AutoBackupStatusLine(state: state);

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.s4, vertical: 14),
      onTap: on ? () => Navigator.of(context).push(AutoBackupScreen.route()) : toggle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(LucideIcons.database, size: 20, color: on ? c.brand : c.inkMuted),
              const SizedBox(width: AppSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.settingsAutoBackup, style: AppType.label.copyWith(color: c.ink)),
                    const SizedBox(height: 2),
                    status,
                  ],
                ),
              ),
              const SizedBox(width: AppSpace.s3),
              AppToggle(value: on, semanticLabel: l.settingsAutoBackup, onChanged: (_) => toggle()),
            ],
          ),
          if (on) ...[
            const SizedBox(height: AppSpace.s3),
            Divider(height: 1, thickness: 1, color: c.line),
            const SizedBox(height: AppSpace.s3),
            KeyValueGrid(
              rows: [
                (l.settingsAutoBackupFolderLabel, KvText(state.folderName ?? l.settingsAutoBackupFolderUnknown)),
                (
                  l.settingsAutoBackupTimeLabel,
                  KvText(l.settingsAutoBackupDaily(backupTimeOfDay(state.time).format(context))),
                ),
                (l.settingsAutoBackupPasswordLabel, const KvText('••••••••', icon: LucideIcons.lock)),
                (l.settingsAutoBackupKeepsLabel, KvText(l.settingsAutoBackupKeepsValue)),
              ],
            ),
            ...autoBackupIosNotes(context, state, ios),
          ],
        ],
      ),
    );
  }
}

/// "✓ Last: yesterday, 21:00" in `success`; a failure in `danger` with an alert icon; never in muted.
class AutoBackupStatusLine extends ConsumerWidget {
  const AutoBackupStatusLine({super.key, required this.state});

  final AutoBackupState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final now = ref.watch(clockProvider)();
    final text = _lastText(context, l, state, now);
    final failed = state.lastFailed;
    final ok = !failed && state.lastAt != null;
    final color = failed ? c.danger : (ok ? c.success : c.inkMuted);
    return Text.rich(
      TextSpan(
        style: AppType.meta.copyWith(color: color, fontWeight: failed ? FontWeight.w600 : null),
        children: [
          if (failed || ok) ...[
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Icon(failed ? LucideIcons.circleAlert : LucideIcons.circleCheck, size: 13, color: color),
            ),
            const TextSpan(text: ' '),
          ],
          TextSpan(text: text),
        ],
      ),
    );
  }
}

/// iOS only: backups run when the app opens; a folder that may live only on this iPhone.
List<Widget> autoBackupIosNotes(BuildContext context, AutoBackupState state, bool ios) {
  if (!ios) return const [];
  final l = context.l10n;
  final c = context.colors;
  return [
    const SizedBox(height: AppSpace.s3),
    Text(l.settingsAutoBackupRunsOnOpenIos, style: AppType.meta.copyWith(color: c.inkMuted)),
    if (state.folderInICloud != true) ...[
      const SizedBox(height: AppSpace.s2),
      Text(l.settingsAutoBackupLocalFolderWarningIos, style: AppType.meta.copyWith(color: c.danger)),
    ],
  ];
}

TimeOfDay backupTimeOfDay(BackupTime t) => TimeOfDay(hour: t.hour, minute: t.minute);

/// "yesterday, 21:00" / "today, 09:12" / "Nov 8, 21:00".
String _formatWhen(BuildContext context, DateTime d, DateTime now) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final l = context.l10n;
  final time = DateFormat.Hm(locale).format(d);
  final day = DateTime(d.year, d.month, d.day);
  final today = DateTime(now.year, now.month, now.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return l.settingsWhenToday(time);
  if (diff == 1) return l.settingsWhenYesterday(time);
  return '${DateFormat.MMMd(locale).format(d)}, $time';
}

String _lastText(BuildContext context, AppLocalizations l, AutoBackupState s, DateTime now) {
  final at = s.lastAt;
  final time = at == null ? null : _formatWhen(context, at, now);
  if (s.lastFailed) {
    final error = switch (s.lastResult) {
      AutoBackupResult.permissionDenied || AutoBackupResult.folderMissing => l.settingsAutoBackupErrorFolder,
      _ => l.settingsAutoBackupErrorOther,
    };
    return time == null ? error : l.settingsAutoBackupFailedAt(time, error);
  }
  if (time == null) return l.settingsAutoBackupNever;
  final checked = s.lastCheckAt;
  if (checked != null && checked.isAfter(at!)) {
    return l.settingsAutoBackupLastUnchanged(time, _formatWhen(context, checked, now));
  }
  return l.settingsAutoBackupLast(time);
}

/// Turn it on (mockup 097): the set-up screen picks the folder, the time and the password and
/// switches it on; then the first backup runs right away and iOS asks for notifications.
Future<void> enableAutoBackup(BuildContext context, WidgetRef ref) async {
  final on = await Navigator.of(context).push<bool>(AutoBackupScreen.route(setup: true));
  if (on != true || !context.mounted) return;
  ref.invalidate(autoBackupStateProvider);
  await backupNowFromSettings(context, ref);
  // iOS: ask for notification permission AFTER the first backup so the "Saved" toast does not
  // hide the explanation.
  if (!context.mounted) return;
  await ensureBackupNotificationPermission(context, ref);
}

/// "Backup time": the Material time picker; saved immediately, the schedule is reset through
/// `autoBackupScheduleSyncProvider`.
Future<void> pickBackupTime(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final service = ref.read(autoBackupServiceProvider);
  final current = (await service.state()).time;
  if (!context.mounted) return;
  final picked = await showTimePicker(
    context: context,
    initialTime: backupTimeOfDay(current),
    helpText: l.settingsAutoBackupTime,
    initialEntryMode: TimePickerEntryMode.dialOnly, // see enable flow above
  );
  if (picked == null) return;
  final time = BackupTime(picked.hour, picked.minute);
  if (time != current) {
    await service.setTime(time);
    ref.invalidate(autoBackupStateProvider);
  }
  if (!context.mounted) return;
  await ensureBackupNotificationPermission(context, ref);
}

/// iOS: the backup reminder needs notification permission. Already granted: nothing. Otherwise
/// explain first; only "Continue" shows the iOS prompt. A denial: a gentle toast — automatic
/// backup stays on and still catches up when the app opens. Android runs a background job, so it
/// does nothing here.
Future<void> ensureBackupNotificationPermission(BuildContext context, WidgetRef ref) async {
  final scheduler = ref.read(autoBackupSchedulerProvider);
  if (!scheduler.usesNotification) return;
  if (await scheduler.hasNotificationPermission()) return;
  if (!context.mounted) return;
  final l = context.l10n;
  final agreed = await showAppDialog<bool>(
    context,
    title: l.settingsAutoBackupNotifyTitleIos,
    body: l.settingsAutoBackupNotifyBodyIos,
    actions: [
      AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(context)),
      AppButton.primary(label: l.commonContinue, expand: true, onPressed: () => Navigator.pop(context, true)),
    ],
  );
  final notifications = ref.read(notificationServiceProvider);
  if (agreed == true) {
    final granted = await notifications.requestPermissionOrOpenSettings();
    if (granted) {
      ref.invalidate(autoBackupStateProvider);
      return;
    }
  }
  if (context.mounted) {
    showAppToast(
      context,
      l.settingsAutoBackupNotifyDeniedIos,
      icon: AppIcons.remindersOff,
      action: SnackBarAction(label: l.settingsOpenSystemSettings, onPressed: notifications.openSettings),
    );
  }
}

Future<void> releaseFolderQuietly(BackupFolderService folders, String uri) async {
  try {
    await folders.releaseFolder(uri);
  } catch (_) {
    // Nothing to release.
  }
}

/// Turns it off: removes the password and folder permission; files already written stay.
Future<void> disableAutoBackup(BuildContext context, WidgetRef ref, AppLocalizations l) async {
  await ref.read(autoBackupServiceProvider).disable();
  ref.invalidate(autoBackupStateProvider);
  if (context.mounted) showAppToast(context, l.settingsAutoBackupOffDone);
}

/// "Back up now": runs and reports the result. While running the button spins and ignores taps.
Future<void> backupNowFromSettings(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final service = ref.read(autoBackupServiceProvider);
  if (ref.read(autoBackupRunningProvider)) return;
  final running = ref.read(autoBackupRunningProvider.notifier)..set(true);
  final AutoBackupResult result;
  try {
    result = await service.backupNow();
  } finally {
    running.set(false);
  }
  if (context.mounted) ref.invalidate(autoBackupStateProvider);
  if (!context.mounted) return;
  showAppToast(context, switch (result) {
    AutoBackupResult.ok => l.settingsAutoBackupDone,
    AutoBackupResult.busy => l.settingsAutoBackupBusy,
    AutoBackupResult.permissionDenied || AutoBackupResult.folderMissing => l.settingsAutoBackupErrorFolder,
    _ => l.settingsAutoBackupErrorOther,
  }, icon: result == AutoBackupResult.ok ? AppIcons.paid : AppIcons.alert);
}

/// "Choose folder": changes the folder, keeps the password and backs up right away to check.
Future<void> repickFolder(BuildContext context, WidgetRef ref) async {
  final l = context.l10n;
  final folders = ref.read(backupFolderServiceProvider);
  final service = ref.read(autoBackupServiceProvider);
  final PickedFolder? folder;
  try {
    folder = await folders.pickFolder();
  } on BackupFolderException {
    if (context.mounted) showAppToast(context, l.settingsAutoBackupPickFailed, icon: AppIcons.alert);
    return;
  }
  if (folder == null) return;
  if (!context.mounted) {
    // No screen left to save the choice: release the new permission unless it is the folder
    // already in use (releasing it would break the current backup).
    if (folder.uri != (await service.state()).folderUri) await releaseFolderQuietly(folders, folder.uri);
    return;
  }
  await service.changeFolder(folder);
  ref.invalidate(autoBackupStateProvider);
  if (!context.mounted) return;
  await backupNowFromSettings(context, ref);
}
