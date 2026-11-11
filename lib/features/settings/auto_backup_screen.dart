import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/backup/auto_backup_service.dart';
import '../../data/backup/backup_folder_service.dart';
import '../../data/backup/backup_schedule.dart';
import 'auto_backup_providers.dart';
import 'auto_backup_section.dart';
import 'backup_password_dialogs.dart';
import 'widgets/settings_bits.dart';

/// Automatic backup (mockup 097). Two modes:
/// * [setup] — turning it on: Folder (system picker) · Time (21:00) · Keep 2 newest, the password
///   typed twice, the "write it down" warning, then "Turn on automatic backup". Pops `true` once
///   it is on; leaving without turning it on gives the folder permission back.
/// * otherwise — it is on: change the folder or the time, see the last result, "Back up now".
class AutoBackupScreen extends ConsumerStatefulWidget {
  const AutoBackupScreen({super.key, this.setup = false});

  final bool setup;

  static Route<bool> route({bool setup = false}) => MaterialPageRoute(builder: (_) => AutoBackupScreen(setup: setup));

  @override
  ConsumerState<AutoBackupScreen> createState() => _AutoBackupScreenState();
}

class _AutoBackupScreenState extends ConsumerState<AutoBackupScreen> with TwoPasswords {
  PickedFolder? _folder;
  BackupTime _time = BackupTime.defaultTime;
  bool _busy = false;
  bool _done = false;
  late final BackupFolderService _folders = ref.read(backupFolderServiceProvider);

  @override
  void dispose() {
    // Set-up left without turning it on: the folder permission taken when picking is released.
    final folder = _folder;
    if (widget.setup && !_done && folder != null) releaseFolderQuietly(_folders, folder.uri);
    super.dispose();
  }

  Future<void> _pickFolder() async {
    final l = context.l10n;
    final PickedFolder? folder;
    try {
      folder = await _folders.pickFolder();
    } on BackupFolderException {
      if (mounted) showAppToast(context, l.settingsAutoBackupPickFailed, icon: AppIcons.alert);
      return;
    }
    if (folder == null) return;
    final old = _folder;
    if (!mounted) {
      await releaseFolderQuietly(_folders, folder.uri);
      return;
    }
    if (old != null && old.uri != folder.uri) await releaseFolderQuietly(_folders, old.uri);
    setState(() => _folder = folder);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: backupTimeOfDay(_time),
      helpText: context.l10n.settingsAutoBackupTime,
      // The keyboard-input mode throws "BoxConstraints has non-normalized height constraints" when
      // the system font size is small (Galaxy A13 at 0.8).
      initialEntryMode: TimePickerEntryMode.dialOnly,
    );
    if (picked != null && mounted) setState(() => _time = BackupTime(picked.hour, picked.minute));
  }

  Future<void> _turnOn() async {
    final l = context.l10n;
    if (_busy) return;
    final folder = _folder;
    final password = validated(l);
    if (folder == null) {
      showAppToast(context, l.settingsAutoBackupFolderNeeded, icon: AppIcons.folder);
      return;
    }
    if (password == null) return;
    setState(() => _busy = true);
    final service = ref.read(autoBackupServiceProvider);
    try {
      await service.enable(folder: folder, password: password, time: _time);
    } catch (_) {
      // Secure storage (Keystore) failed: cannot turn it on.
      await service.disable();
      if (mounted) {
        setState(() => _busy = false);
        showAppToast(context, l.settingsAutoBackupErrorOther, icon: AppIcons.alert);
      }
      return;
    }
    _done = true;
    ref.invalidate(autoBackupStateProvider);
    if (mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final ios = Theme.of(context).platform == TargetPlatform.iOS;
    final state = ref.watch(autoBackupStateProvider).value ?? const AutoBackupState();
    final running = ref.watch(autoBackupRunningProvider);
    final setup = widget.setup;

    final folderName = setup
        ? (_folder == null ? l.settingsAutoBackupChoose : (_folder!.name ?? l.settingsAutoBackupFolderUnknown))
        : (state.folderName ?? l.settingsAutoBackupFolderUnknown);
    final time = backupTimeOfDay(setup ? _time : state.time).format(context);

    final bottom = setup
        ? AppButton.primary(
            label: l.settingsAutoBackupTurnOn,
            expand: true,
            loading: _busy,
            onPressed: _busy ? null : _turnOn,
          )
        : AppButton.primary(
            label: l.settingsBackupNow,
            icon: AppIcons.backupNow,
            expand: true,
            loading: running,
            onPressed: running ? null : () => backupNowFromSettings(context, ref),
          );

    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        backgroundColor: c.bg,
        appBar: AppTopBar(title: l.settingsAutoBackup),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
            children: [
              // `.ab-hero`: database icon in brand, the explanation centred.
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpace.s2, AppSpace.s4, AppSpace.s2, AppSpace.s4),
                child: Column(
                  children: [
                    Icon(LucideIcons.database, size: 28, color: c.brand),
                    const SizedBox(height: AppSpace.s1),
                    Text(
                      ios ? l.settingsAutoBackupNoteIos : l.settingsAutoBackupIntro,
                      textAlign: TextAlign.center,
                      style: AppType.body.copyWith(color: c.inkMuted),
                    ),
                  ],
                ),
              ),
              AppGroup(
                dividerIndent: 52,
                children: [
                  ValueRow(
                    icon: LucideIcons.folder,
                    label: l.settingsAutoBackupFolderLabel,
                    value: folderName,
                    valueColor: setup && _folder == null ? c.brand : null,
                    onTap: _busy || running ? null : (setup ? _pickFolder : () => repickFolder(context, ref)),
                  ),
                  ValueRow(
                    icon: LucideIcons.clock,
                    label: l.settingsAutoBackupSetupTime,
                    value: time,
                    onTap: _busy || running ? null : (setup ? _pickTime : () => pickBackupTime(context, ref)),
                  ),
                  ValueRow(
                    icon: LucideIcons.layers,
                    label: l.settingsAutoBackupKeep,
                    value: l.settingsAutoBackupKeepValue,
                    chevron: false,
                  ),
                ],
              ),
              if (setup) ...[
                SectionHeader(label: l.settingsAutoBackupPasswordLabel),
                AppCard(
                  padding: const EdgeInsets.all(AppSpace.s4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: passwordFields(l, enabled: !_busy, onSubmit: _turnOn),
                  ),
                ),
                const SizedBox(height: AppSpace.s4),
                AppBanner(
                  kind: BannerKind.warning,
                  icon: LucideIcons.keyRound,
                  title: l.settingsAutoBackupWriteDownTitle,
                  body: l.settingsAutoBackupWriteDownBody,
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpace.s1, AppSpace.s3, AppSpace.s1, 0),
                  child: AutoBackupStatusLine(state: state),
                ),
                ...autoBackupIosNotes(context, state, ios),
              ],
            ],
          ),
        ),
        bottomNavigationBar: BottomActionBar(child: bottom),
      ),
    );
  }
}
