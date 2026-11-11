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
import '../../domain/domain.dart';
import '../lock/app_lock.dart';
import 'auto_backup_providers.dart';
import 'backup_password_dialogs.dart';
import 'settings_platform.dart';

String _stamp(DateTime d) =>
    '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}'
    '-${d.hour.toString().padLeft(2, '0')}${d.minute.toString().padLeft(2, '0')}';

/// Backup, restore and delete flows shared by Settings (F7).
abstract final class BackupActions {
  /// Full backup → optional password → system share sheet. No password is required here; when the
  /// user protects the file it is encrypted with AES-256-GCM before leaving the app.
  static Future<void> exportJson(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    final backup = ref.read(backupServiceProvider);
    final now = ref.read(clockProvider)();
    final String plain;
    try {
      plain = await backup.exportJsonText();
    } catch (_) {
      if (context.mounted) showAppToast(context, l.settingsExportFailed, icon: AppIcons.alert);
      return;
    }
    if (!context.mounted) return;
    final result = await showDialog<String>(
      context: context,
      builder: (_) => BackupExportDialog(encrypt: (password) => encryptBackupOffThread(plain, password)),
    );
    if (result == null || !context.mounted) return;
    final content = result.isEmpty ? plain : result;
    final done = await ref.read(settingsPlatformProvider).share([
      ExportFile('subnest-${_stamp(now)}.subnest', content, 'application/json'),
    ], subject: l.settingsExportBackup);
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

  /// Pick a file → encrypted: ask for its password (any Subnest file, automatic ones too) → check
  /// the whole file → ONE confirmation (file name, what it holds) → replace all data and the
  /// settings in the file. A bad file never reaches the confirmation and changes nothing. The
  /// automatic-backup configuration of this phone (secure storage) is not touched.
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
    var text = picked.text;
    if (isEncryptedBackup(text)) {
      try {
        checkEncryptedBackup(text);
      } on BackupFormatException {
        showAppToast(context, l.settingsRestoreInvalid, icon: AppIcons.alert);
        return;
      }
      final envelope = text;
      final plain = await showDialog<String>(
        context: context,
        builder: (_) => BackupUnlockDialog(envelope: envelope),
      );
      if (plain == null || !context.mounted) return;
      text = plain;
    }
    final int subs;
    final int payments;
    try {
      final parsed = backup.parse(text);
      subs = parsed.subscriptions.length;
      payments = parsed.periods.where((p) => p.outcome == PeriodOutcome.payment).length;
    } on BackupFormatException {
      showAppToast(context, l.settingsRestoreInvalid, icon: AppIcons.alert);
      return;
    }
    final ok = await showRestoreDialog(context, fileName: picked.name, subscriptions: subs, payments: payments);
    if (ok != true || !context.mounted) return;
    try {
      final r = await backup.importJson(text);
      if (context.mounted) showAppToast(context, l.settingsRestoreDone(r.subscriptions));
    } catch (_) {
      if (context.mounted) showAppToast(context, l.settingsRestoreFailed, icon: AppIcons.alert);
    }
  }

  /// "Delete all data" after two confirmations: [eraseEverything], then straight to onboarding
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
              AppButton.danger(label: l.settingsDelete, expand: true, onPressed: () => Navigator.pop(ctx, true)),
        ),
        Builder(
          builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
        ),
      ],
    );
    if (first != true || !context.mounted) return false;
    final second = await showAppDialog<bool>(
      context,
      title: l.settingsCannotUndo,
      body: l.settingsDeleteAllConfirm2,
      actions: [
        Builder(
          builder: (ctx) => AppButton.danger(
            label: l.settingsDeleteEverything,
            expand: true,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ),
        Builder(
          builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
        ),
      ],
    );
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

/// "Restore this backup?" (png 56, without the Merge/Replace choice — restore always replaces):
/// file name, what it holds, what happens, then a `danger` "Replace my data".
Future<bool?> showRestoreDialog(
  BuildContext context, {
  required String fileName,
  required int subscriptions,
  required int payments,
}) {
  final l = context.l10n;
  final c = context.colors;
  return showAppDialog<bool>(
    context,
    title: l.settingsRestoreTitle,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(fileName, style: AppType.meta.copyWith(color: c.inkMuted)),
        const SizedBox(height: 2),
        Text(l.settingsRestoreHolds(subscriptions, payments), style: AppType.body.copyWith(color: c.inkMuted)),
        const SizedBox(height: AppSpace.s3),
        Text(l.settingsRestoreReplaceNote, style: AppType.body.copyWith(color: c.ink)),
      ],
    ),
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
