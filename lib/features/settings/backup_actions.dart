import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/backup/backup_service.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import 'settings_platform.dart';

/// Backup flows shared by S10 and the Backup & restore screen (F7).
abstract final class BackupActions {
  /// Full JSON backup → system share sheet.
  static Future<void> exportJson(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    await _share(context, () async => [await ref.read(backupServiceProvider).exportJson()], l.settingsExportJson, ref);
  }

  /// Two CSV files (subscriptions + payments) → system share sheet.
  static Future<void> exportCsv(BuildContext context, WidgetRef ref) async {
    final l = context.l10n;
    await _share(context, () => ref.read(backupServiceProvider).exportCsv(), l.settingsExportCsv, ref);
  }

  static Future<void> _share(
    BuildContext context,
    Future<List<ExportFile>> Function() build,
    String subject,
    WidgetRef ref,
  ) async {
    final l = context.l10n;
    final platform = ref.read(settingsPlatformProvider);
    try {
      final files = await build();
      final done = await platform.share(files, subject: subject);
      if (done && context.mounted) showAppToast(context, l.settingsExported);
    } catch (_) {
      if (context.mounted) showAppToast(context, l.settingsExportFailed, icon: AppIcons.alert);
    }
  }

  /// Pick a file → check it → ask Merge / Replace (S10 restore dialog) → import.
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
    final int subs;
    final int payments;
    try {
      final parsed = backup.parse(picked.text);
      subs = parsed.subscriptions.length;
      payments = parsed.periods.where((p) => p.outcome == PeriodOutcome.payment).length;
    } on BackupFormatException {
      showAppToast(context, l.settingsRestoreInvalid, icon: AppIcons.alert);
      return;
    }
    final mode = await showRestoreDialog(context, fileName: picked.name, subscriptions: subs, payments: payments);
    if (mode == null || !context.mounted) return;
    try {
      final r = await backup.importJson(picked.text, mode);
      if (context.mounted) showAppToast(context, l.settingsRestoreDone(r.subscriptions));
    } catch (_) {
      if (context.mounted) showAppToast(context, l.settingsRestoreFailed, icon: AppIcons.alert);
    }
  }
}

/// "Restore this backup?" (png 56): file name, what it holds, Merge (default) / Replace.
/// Replace deletes the current data, so its button turns `danger` and says so.
Future<ImportMode?> showRestoreDialog(
  BuildContext context, {
  required String fileName,
  required int subscriptions,
  required int payments,
}) {
  final l = context.l10n;
  final c = context.colors;
  // Not disposed: the dialog still listens while it animates out; it is garbage once closed.
  final mode = ValueNotifier(ImportMode.merge);
  return showAppDialog<ImportMode>(
    context,
    title: l.settingsRestoreTitle,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(fileName, style: AppType.meta.copyWith(color: c.inkMuted)),
        const SizedBox(height: 2),
        Text(l.settingsRestoreHolds(subscriptions, payments), style: AppType.body.copyWith(color: c.inkMuted)),
        const SizedBox(height: AppSpace.s4),
        ValueListenableBuilder(
          valueListenable: mode,
          builder: (_, value, _) => RadioRowGroup<ImportMode>(
            value: value,
            onChanged: (m) => mode.value = m,
            options: [
              RadioOption(value: ImportMode.merge, title: l.settingsRestoreMerge, subtitle: l.settingsRestoreMergeHint),
              RadioOption(
                value: ImportMode.replace,
                title: l.settingsRestoreReplace,
                subtitle: l.settingsRestoreReplaceHint,
              ),
            ],
          ),
        ),
      ],
    ),
    actions: [
      ValueListenableBuilder(
        valueListenable: mode,
        builder: (ctx, value, _) => value == ImportMode.replace
            ? AppButton.danger(
                label: l.settingsRestoreReplaceAction,
                expand: true,
                onPressed: () => Navigator.pop(ctx, ImportMode.replace),
              )
            : AppButton.primary(
                label: l.settingsRestoreAction,
                expand: true,
                onPressed: () => Navigator.pop(ctx, ImportMode.merge),
              ),
      ),
      Builder(
        builder: (ctx) => AppButton.text(label: l.commonCancel, expand: true, onPressed: () => Navigator.pop(ctx)),
      ),
    ],
  );
}
