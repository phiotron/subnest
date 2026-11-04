import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../data/backup/backup_files.dart';
import '../../data/backup/backup_service.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// Backup & restore (S10, F7) — PLACEHOLDER UI. Owned by the Settings session (J).
class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final settings = ref.watch(settingsProvider).value;
    final backup = ref.read(backupServiceProvider);
    final last = settings?.lastBackupAt;
    final overdue = last == null || DateTime.now().difference(last).inDays > 30;

    void snack(String text) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsBackup)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(last == null ? l.settingsNeverBackedUp : l.settingsLastBackup(l.date(LocalDate.fromDateTime(last)))),
            subtitle: overdue ? Text(l.settingsBackupNudge) : null,
          ),
          ListTile(
            leading: const Icon(Icons.save_alt),
            title: Text(l.settingsExportJson),
            onTap: () async => BackupFiles.share([await backup.exportJson()], subject: l.settingsExportJson),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: Text(l.settingsExportCsv),
            onTap: () async => BackupFiles.share(await backup.exportCsv(), subject: l.settingsExportCsv),
          ),
          ListTile(
            leading: const Icon(Icons.restore),
            title: Text(l.settingsRestore),
            subtitle: Text(l.settingsRestoreHint),
            onTap: () async {
              final text = await BackupFiles.pickJson();
              if (text == null || !context.mounted) return;
              final int count;
              try {
                count = backup.parse(text).subscriptions.length;
              } on BackupFormatException {
                snack(l.settingsRestoreInvalid);
                return;
              }
              final mode = await showDialog<ImportMode>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(l.settingsRestoreTitle(count)),
                  content: Text(l.settingsRestoreBody),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.commonCancel)),
                    TextButton(onPressed: () => Navigator.pop(ctx, ImportMode.merge), child: Text(l.settingsRestoreMerge)),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, ImportMode.replace),
                      child: Text(l.settingsRestoreReplace),
                    ),
                  ],
                ),
              );
              if (mode == null) return;
              final r = await backup.importJson(text, mode);
              if (context.mounted) snack(l.settingsRestoreDone(r.subscriptions));
            },
          ),
        ],
      ),
    );
  }
}
