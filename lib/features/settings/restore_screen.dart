import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/backup/backup_crypto.dart';
import '../../data/backup/backup_service.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import 'backup_password_dialogs.dart';
import 'settings_format.dart';
import 'widgets/settings_bits.dart';

/// What a checked backup file holds (Restore › "In this file").
class BackupSummary {
  const BackupSummary({required this.subscriptions, required this.payments, required this.priceChanges});

  /// Counts from `BackupService.parse` (throws [BackupFormatException] on a bad file).
  factory BackupSummary.of(BackupService backup, String text) {
    final parsed = backup.parse(text);
    final changes = parsed.json['priceChanges'];
    return BackupSummary(
      subscriptions: parsed.subscriptions.length,
      payments: parsed.periods.where((p) => p.outcome == PeriodOutcome.payment).length,
      priceChanges: changes is List ? changes.length : 0,
    );
  }

  final int subscriptions;
  final int payments;
  final int priceChanges;
}

/// Restore (mockup 099–101). The file was picked and checked before this screen opens; restoring
/// always replaces everything (APP.md 2026-11-10 item 3).
/// * plain file: "Valid" chip, what it holds, the warning, Continue → "Replace all data?";
/// * encrypted file: the password field ("Wrong password" stays on the screen), "Unlock and
///   restore" → the same confirmation.
/// Pops `true` once the data was replaced.
class RestoreScreen extends ConsumerStatefulWidget {
  const RestoreScreen({
    super.key,
    required this.fileName,
    required this.text,
    this.summary,
    this.decrypt = decryptBackupOffThread,
  });

  final String fileName;

  /// The file content: a plain backup, or an encrypted envelope when [summary] is null.
  final String text;
  final BackupSummary? summary;
  final BackupDecryptor decrypt;

  bool get encrypted => summary == null;

  @override
  ConsumerState<RestoreScreen> createState() => _RestoreScreenState();
}

class _RestoreScreenState extends ConsumerState<RestoreScreen> {
  final _password = TextEditingController();
  bool _busy = false;
  bool _wrong = false;

  @override
  void dispose() {
    _password.clear();
    _password.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    if (_busy) return;
    final l = context.l10n;
    final backup = ref.read(backupServiceProvider);
    var text = widget.text;
    var summary = widget.summary;
    if (widget.encrypted) {
      if (_password.text.isEmpty) {
        setState(() => _wrong = true);
        return;
      }
      setState(() {
        _busy = true;
        _wrong = false;
      });
      try {
        text = await widget.decrypt(widget.text, _password.text);
      } catch (_) {
        // A wrong password and a modified file cannot be told apart.
        if (mounted) {
          setState(() {
            _busy = false;
            _wrong = true;
          });
        }
        return;
      }
      if (!mounted) return;
      try {
        summary = BackupSummary.of(backup, text);
      } on BackupFormatException {
        setState(() => _busy = false);
        showAppToast(context, l.settingsRestoreInvalid, icon: AppIcons.alert);
        return;
      }
      setState(() => _busy = false);
    }
    final current = ref.read(subscriptionsProvider).value?.length ?? 0;
    final ok = await showRestoreDialog(context, current: current, count: summary!.subscriptions);
    if (ok != true || !mounted) return;
    setState(() => _busy = true);
    try {
      final r = await backup.importJson(text);
      if (!mounted) return;
      showAppToast(context, l.settingsRestoreDone(r.subscriptions));
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _busy = false);
      showAppToast(context, l.settingsRestoreFailed, icon: AppIcons.alert);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final s = widget.summary;
    final size = SettingsFormat.fileSize(widget.text.length);
    return PopScope(
      canPop: !_busy,
      child: Scaffold(
        backgroundColor: c.bg,
        appBar: AppTopBar(title: l.settingsRestore),
        body: SafeArea(
          top: false,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpace.s4, 0, AppSpace.s4, AppSpace.s6),
            children: [
              FileChip(
                big: true,
                name: widget.fileName,
                meta: widget.encrypted ? l.settingsRestoreProtected(size) : size,
                trailing: StatusBadge(label: l.settingsRestoreValid, kind: BadgeKind.success, icon: LucideIcons.check),
              ),
              if (widget.encrypted) ...[
                SectionHeader(label: l.settingsRestoreHasPassword),
                AppCard(
                  padding: const EdgeInsets.all(AppSpace.s4),
                  child: PasswordInput(
                    controller: _password,
                    hint: l.settingsBackupPassword,
                    enabled: !_busy,
                    autofocus: true,
                    textInputAction: TextInputAction.done,
                    errorText: _wrong ? l.settingsBackupWrongPassword : null,
                    onSubmitted: (_) => _go(),
                    onChanged: (_) {
                      if (_wrong) setState(() => _wrong = false);
                    },
                  ),
                ),
              ] else ...[
                SectionHeader(label: l.settingsRestoreInFile),
                AppGroup(
                  dividerIndent: 52,
                  children: [
                    ValueRow(
                      icon: LucideIcons.layers,
                      label: l.settingsRestoreSubs,
                      value: '${s!.subscriptions}',
                      chevron: false,
                    ),
                    ValueRow(
                      icon: LucideIcons.receipt,
                      label: l.settingsRestorePayments,
                      value: '${s.payments}',
                      chevron: false,
                    ),
                    ValueRow(
                      icon: LucideIcons.history,
                      label: l.settingsRestorePriceChanges,
                      value: '${s.priceChanges}',
                      chevron: false,
                    ),
                    ValueRow(
                      icon: LucideIcons.settings,
                      label: l.settingsRestoreSettings,
                      value: l.settingsRestoreIncluded,
                      chevron: false,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpace.s4),
              AppBanner(
                kind: BannerKind.warning,
                icon: LucideIcons.triangleAlert,
                title: l.settingsRestoreWarnTitle,
                body: l.settingsRestoreWarnBody,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomActionBar(
          child: AppButton.primary(
            label: widget.encrypted ? l.settingsRestoreUnlock : l.commonContinue,
            expand: true,
            loading: _busy,
            onPressed: _busy ? null : _go,
          ),
        ),
      ),
    );
  }
}

/// "Replace all data?" (mockup 101): how many subscriptions go and come, `danger` "Replace and
/// restore", Cancel.
Future<bool?> showRestoreDialog(BuildContext context, {required int current, required int count}) {
  final l = context.l10n;
  return showAppDialog<bool>(
    context,
    title: l.settingsRestoreTitle,
    body: l.settingsRestoreReplaceBody(current, count),
    actions: [
      Builder(
        builder: (ctx) => AppButton.danger(
          label: l.settingsRestoreReplaceAction,
          expand: true,
          onPressed: () => Navigator.pop(ctx, true),
        ),
      ),
      Builder(
        builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
      ),
    ],
  );
}
