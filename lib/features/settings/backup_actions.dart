import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/l10n.dart';
import '../../core/router/routes.dart';
import '../../core/widgets/widgets.dart';
import '../../data/backup/backup_crypto.dart';
import '../../data/backup/backup_service.dart';
import '../../data/catalog/catalog_providers.dart';
import '../../data/logos/logo_providers.dart';
import '../../data/providers.dart';
import '../lock/app_lock.dart';
import 'auto_backup_providers.dart';
import 'backup_password_dialogs.dart';
import 'restore_screen.dart';
import 'settings_format.dart';
import 'settings_platform.dart';

String _stamp(DateTime d) =>
    '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}'
    '-${d.hour.toString().padLeft(2, '0')}${d.minute.toString().padLeft(2, '0')}';

/// Backup, restore and delete flows shared by Settings (F7).
abstract final class BackupActions {
  /// "Back up now" (mockup 098): full backup → the sheet (file name, what it holds, optional
  /// password) → system share sheet. When the user protects the file it is encrypted with
  /// AES-256-GCM before leaving the app.
  static Future<void> exportJson(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final backup = ref.read(backupServiceProvider);
    final now = ref.read(clockProvider)();
    final String plain;
    final BackupSummary summary;
    try {
      plain = await backup.exportJsonText();
      summary = BackupSummary.of(backup, plain);
    } catch (_) {
      if (context.mounted) showAppToast(context, l.settingsExportFailed, icon: AppIcons.alert);
      return;
    }
    if (!context.mounted) return;
    final name = 'subnest-${_stamp(now)}.subnest';
    final result = await showAppSheet<String>(
      context,
      builder: (_) => BackupNowSheet(
        fileName: name,
        meta: l.settingsBackupFileMeta(summary.subscriptions, summary.payments, SettingsFormat.fileSize(plain.length)),
        encrypt: (password) => encryptBackupOffThread(plain, password),
      ),
    );
    if (result == null || !context.mounted) return;
    final content = result.isEmpty ? plain : result;
    final done = await ref.read(settingsPlatformProvider).share([
      ExportFile(name, content, 'application/json'),
    ], subject: l.settingsBackupNow);
    if (!done) return;
    await backup.markBackedUp();
    if (context.mounted) showAppToast(context, l.settingsExported);
  }

  /// Two CSV files (subscriptions + payments) → system share sheet.
  static Future<void> exportCsv(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    try {
      final files = await ref.read(backupServiceProvider).exportCsv();
      final done = await ref.read(settingsPlatformProvider).share(files, subject: l.settingsExportCsv);
      if (done && context.mounted) showAppToast(context, l.settingsExported);
    } catch (_) {
      if (context.mounted) showAppToast(context, l.settingsExportFailed, icon: AppIcons.alert);
    }
  }

  /// Pick a file → check it → the Restore screen (mockup 099–101): an encrypted file asks for its
  /// password there (any Subnest file, automatic ones too), then ONE confirmation, then all data
  /// and the settings in the file replace what is on the phone. A bad file never reaches the
  /// screen and changes nothing. The automatic-backup configuration of this phone (secure
  /// storage) is not touched.
  static Future<void> restore(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final backup = ref.read(backupServiceProvider);
    final PickedBackup? picked;
    try {
      picked = await ref.read(settingsPlatformProvider).pickBackup();
    } catch (_) {
      if (context.mounted) showAppToast(context, l.settingsRestoreInvalid, icon: AppIcons.alert);
      return;
    }
    if (picked == null || !context.mounted) return;
    final text = picked.text;
    BackupSummary? summary;
    try {
      if (isEncryptedBackup(text)) {
        checkEncryptedBackup(text);
      } else {
        summary = BackupSummary.of(backup, text);
      }
    } on BackupFormatException {
      showAppToast(context, l.settingsRestoreInvalid, icon: AppIcons.alert);
      return;
    }
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => RestoreScreen(fileName: picked!.name, text: text, summary: summary),
      ),
    );
  }

  /// "Erase all data" after two confirmations (mockup 102–103): [eraseEverything], then straight to onboarding
  /// (English + USD, like a new install). Also steps 2–3 of "Forgot PIN" on the lock screen
  /// (session S). Returns true when everything was deleted.
  ///
  /// Why `go(onboarding)` here rather than a router redirect: the router is built once in
  /// `main.dart` with an initial location and has no redirect; onboarding is only needed again
  /// right after this action, so one `go` is enough and leaves the router (where session S adds
  /// the lock) untouched.
  static Future<bool> deleteAll(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final first = await showAppDialog<bool>(
      context,
      title: l.settingsDeleteAllTitle,
      body: l.settingsDeleteAllConfirm,
      actions: [
        Builder(
          builder: (ctx) =>
              AppButton.danger(label: l.commonContinue, expand: true, onPressed: () => Navigator.pop(ctx, true)),
        ),
        Builder(
          builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
        ),
      ],
    );
    if (first != true || !context.mounted) return false;
    final second = await showDialog<bool>(context: context, builder: (_) => const EraseConfirmDialog());
    if (second != true || !context.mounted) return false;
    // Read before the wipe: the language goes back to English with the settings.
    final done = l.settingsDeleteAllDone;
    final router = GoRouter.maybeOf(context);
    await eraseEverything(ref);
    // The toast lives in the app-wide ScaffoldMessenger, so it stays up over onboarding.
    if (context.mounted) showAppToast(context, done);
    router?.go(AppRoutes.onboarding);
    return true;
  }

  /// Everything "Delete all data" removes, without asking (the caller confirmed) — like a new
  /// install: data AND every setting (onboarding, language, currency…); automatic backup turned
  /// off (password and folder permission forgotten; files already in the folder stay, and an empty
  /// backup can never push good copies out of the folder); pending reminders cancelled; Custom logo
  /// pictures deleted. Each step
  /// outside the database runs even if an earlier one failed.
  static Future<void> eraseEverything(WidgetRef ref) async {
    await ref.read(databaseProvider).wipeEverything();
    final steps = <Future<void> Function()>[
      () => ref.read(autoBackupServiceProvider).disable(),
      () => ref.read(autoBackupSchedulerProvider).cancel(),
      () => ref.read(notificationServiceProvider).cancelReminders(),
      // ---- Hooks for later sessions: add the step to this list ----------------------------------
      // [S · App lock] turn the PIN off (hash, salt and install id leave secure storage).
      () => ref.read(pinServiceProvider).disable(),
      // [L · Custom logo] the pictures the user picked for subscriptions.
      () => ref.read(customLogoStoreProvider).clear(),
      // [P2 · Remote Catalog] the user's "Keep old price" answers (the cached Catalog itself stays).
      // Not awaited: it lives in the catalog cache folder, whose path lookup must not hold up the
      // return to onboarding (and never resolves in widget tests).
      () async => unawaited(ref.read(catalogNoticeStoreProvider).clearDecisions().catchError((_) {})),
      // [W · Widget] clear the home-screen widget data (e.g. `WidgetSync.clear()`), so the widget
      //   shows its empty state instead of old amounts.
    ];
    for (final step in steps) {
      try {
        await step();
      } catch (_) {
        // Keep going: the data is already gone; a leftover is cleaned up by its own feature.
      }
    }
    ref.invalidate(autoBackupStateProvider);
    // [S · App lock] Settings switch and home-screen widget follow the PIN being gone.
    ref.invalidate(pinEnabledProvider);
  }
}

/// Erase all data, step 2 (mockup 103): "Type ERASE to confirm" (XOA in Vietnamese, any case),
/// "This can't be undone.", `danger` "Erase everything" enabled once the word matches.
class EraseConfirmDialog extends StatefulWidget {
  const EraseConfirmDialog({super.key});

  @override
  State<EraseConfirmDialog> createState() => _EraseConfirmDialogState();
}

class _EraseConfirmDialogState extends State<EraseConfirmDialog> {
  final _text = TextEditingController();

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = context.colors;
    final word = l.settingsDeleteAllWord;
    final ok = _text.text.trim().toUpperCase() == word;
    return AppDialog(
      title: l.settingsDeleteAllTypeTitle(word),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            key: const ValueKey('erase-word'),
            controller: _text,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            textCapitalization: TextCapitalization.characters,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) {
              if (ok) Navigator.pop(context, true);
            },
            style: AppType.body.copyWith(color: c.ink, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: word,
              hintStyle: AppType.body.copyWith(color: c.inkMuted),
              filled: true,
              fillColor: c.surface2,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: c.line),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                borderSide: BorderSide(color: c.brand, width: 2),
              ),
            ),
          ),
          const SizedBox(height: AppSpace.s2),
          Text(l.settingsDeleteAllConfirm2, style: AppType.meta.copyWith(color: c.inkMuted)),
        ],
      ),
      actions: [
        AppButton.danger(
          label: l.settingsDeleteEverything,
          expand: true,
          onPressed: ok ? () => Navigator.pop(context, true) : null,
        ),
        AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(context)),
      ],
    );
  }
}
