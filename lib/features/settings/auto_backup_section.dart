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
import 'backup_password_dialogs.dart';
import 'widgets/settings_bits.dart';

/// "Automatic backup" card in Settings → Data: switch + subtitle; when on, the folder, a status
/// line (✓ / warning), the "Next" line and the pair of buttons, then the "Backup time" row.
/// [extraRows] are appended at the end of the card so Settings can put "Delete all data" as the
/// last row of the Data group.
class AutoBackupSection extends ConsumerStatefulWidget {
  const AutoBackupSection({super.key, this.extraRows = const []});

  final List<Widget> extraRows;

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
    final running = ref.watch(autoBackupRunningProvider);
    final now = ref.watch(clockProvider)();
    final ios = Theme.of(context).platform == TargetPlatform.iOS;
    final folderError =
        state.lastFailed &&
        (state.lastResult == AutoBackupResult.permissionDenied || state.lastResult == AutoBackupResult.folderMissing);
    final backupNow = AppButton.tonal(
      label: l.settingsAutoBackupNow,
      icon: AppIcons.backupNow,
      loading: running,
      onPressed: running ? null : () => backupNowFromSettings(context, ref),
    );
    final chooseAgain = AppButton.outline(
      label: l.settingsAutoBackupChooseFolder,
      icon: AppIcons.folder,
      onPressed: running ? null : () => repickFolder(context, ref),
    );

    void toggle() => state.enabled ? disableAutoBackup(context, ref, l) : enableAutoBackup(context, ref);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingRow(
            icon: AppIcons.autoBackup,
            label: l.settingsAutoBackup,
            subtitle: ios ? l.settingsAutoBackupNoteIos : l.settingsAutoBackupNote,
            onTap: toggle,
            trailing: AppToggle(
              value: state.enabled,
              semanticLabel: l.settingsAutoBackup,
              onChanged: (_) => toggle(),
            ),
          ),
          if (state.enabled) ...[
            Divider(height: 1, thickness: 1, indent: 52, color: c.line),
            ValueRow(
              icon: AppIcons.schedule,
              label: l.settingsAutoBackupTime,
              value: _timeOfDay(state.time).format(context),
              onTap: running ? null : () => pickBackupTime(context, ref),
            ),
            Divider(height: 1, thickness: 1, indent: 52, color: c.line),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s3, AppSpace.s4, AppSpace.s4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (ios)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpace.s2),
                      child: Text(l.settingsAutoBackupRunsOnOpenIos, style: AppType.meta.copyWith(color: c.inkMuted)),
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(AppIcons.folder, size: 18, color: c.inkMuted),
                      const SizedBox(width: AppSpace.s2),
                      Expanded(
                        child: Text(
                          l.settingsAutoBackupFolder(state.folderName ?? l.settingsAutoBackupFolderUnknown),
                          style: AppType.meta.copyWith(color: c.inkMuted),
                        ),
                      ),
                    ],
                  ),
                  if (ios && state.folderInICloud != true)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpace.s2),
                      child: Text(
                        l.settingsAutoBackupLocalFolderWarningIos,
                        style: AppType.meta.copyWith(color: c.danger),
                      ),
                    ),
                  const SizedBox(height: AppSpace.s2),
                  Text(
                    _lastText(context, l, state),
                    style: AppType.meta.copyWith(
                      color: state.lastFailed ? c.danger : c.inkMuted,
                      fontWeight: state.lastFailed ? FontWeight.w600 : null,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(_nextText(context, l, state, ios, now), style: AppType.meta.copyWith(color: c.inkMuted)),
                  const SizedBox(height: AppSpace.s3),
                  Row(
                    children: [
                      Expanded(child: folderError ? chooseAgain : backupNow),
                      const SizedBox(width: AppSpace.s2),
                      Expanded(child: folderError ? backupNow : chooseAgain),
                    ],
                  ),
                ],
              ),
            ),
          ],
          ...widget.extraRows,
        ],
      ),
    );
  }
}

TimeOfDay _timeOfDay(BackupTime t) => TimeOfDay(hour: t.hour, minute: t.minute);

String _formatWhen(BuildContext context, DateTime d) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat.MMMd(locale).add_Hm().format(d);
}

String _lastText(BuildContext context, AppLocalizations l, AutoBackupState s) {
  final at = s.lastAt;
  final time = at == null ? null : _formatWhen(context, at);
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
    return l.settingsAutoBackupLastUnchanged(time, _formatWhen(context, checked));
  }
  return l.settingsAutoBackupLast(time);
}

String _nextText(BuildContext context, AppLocalizations l, AutoBackupState s, bool ios, DateTime now) {
  if (s.isDue(now)) return ios ? l.settingsAutoBackupNextSoonIos : l.settingsAutoBackupNextSoon;
  final next = s.nextAt(now);
  final time = TimeOfDay.fromDateTime(next).format(context);
  return isToday(now, next) ? l.settingsAutoBackupNextToday(time) : l.settingsAutoBackupNextTomorrow(time);
}

/// Pick a folder, set a password and turn it on; the first backup runs right away.
Future<void> enableAutoBackup(BuildContext context, WidgetRef ref) async {
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
    // The folder permission was kept when picking but there is no screen left to ask for the
    // password: release it.
    await _releaseQuietly(folders, folder.uri);
    return;
  }
  final password = await showDialog<String>(
    context: context,
    builder: (_) => const AutoBackupPasswordDialog(),
  );
  if (password == null) {
    await _releaseQuietly(folders, folder.uri);
    return;
  }
  var time = BackupTime.defaultTime;
  if (context.mounted) {
    final picked = await showTimePicker(
      context: context,
      initialTime: _timeOfDay(time),
      helpText: l.settingsAutoBackupTime,
    );
    if (picked != null) time = BackupTime(picked.hour, picked.minute);
  }
  try {
    await service.enable(folder: folder, password: password, time: time);
  } catch (_) {
    // Secure storage (Keystore) failed: cannot turn it on.
    await service.disable();
    await _releaseQuietly(folders, folder.uri);
    if (context.mounted) showAppToast(context, l.settingsAutoBackupErrorOther, icon: AppIcons.alert);
    return;
  }
  ref.invalidate(autoBackupStateProvider);
  if (!context.mounted) return;
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
    initialTime: _timeOfDay(current),
    helpText: l.settingsAutoBackupTime,
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

Future<void> _releaseQuietly(BackupFolderService folders, String uri) async {
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
  showAppToast(
    context,
    switch (result) {
      AutoBackupResult.ok => l.settingsAutoBackupDone,
      AutoBackupResult.busy => l.settingsAutoBackupBusy,
      AutoBackupResult.permissionDenied || AutoBackupResult.folderMissing => l.settingsAutoBackupErrorFolder,
      _ => l.settingsAutoBackupErrorOther,
    },
    icon: result == AutoBackupResult.ok ? AppIcons.paid : AppIcons.alert,
  );
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
    if (folder.uri != (await service.state()).folderUri) await _releaseQuietly(folders, folder.uri);
    return;
  }
  await service.changeFolder(folder);
  ref.invalidate(autoBackupStateProvider);
  if (!context.mounted) return;
  await backupNowFromSettings(context, ref);
}
