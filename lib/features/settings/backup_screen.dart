import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';
import 'backup_actions.dart';
import 'settings_format.dart';
import 'widgets/settings_bits.dart';

/// S10 › Backup & restore (png 55, restore dialog png 56) — F7.
class BackupScreen extends ConsumerWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final c = context.colors;
    final settings = ref.watch(settingsProvider).value;
    final now = ref.watch(clockProvider)();
    final last = settings?.lastBackupAt;
    final overdue = settings != null && SettingsFormat.backupOverdue(last, now);
    final upload = Icon(AppIcons.restoreFile, size: 18, color: c.inkMuted);

    return Scaffold(
      appBar: AppTopBar(title: l.settingsBackupTitle),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpace.s4, AppSpace.s2, AppSpace.s4, AppSpace.s6),
          children: [
            if (overdue) ...[
              AppBanner(
                kind: BannerKind.warning,
                icon: AppIcons.awaiting,
                title: last == null
                    ? l.settingsBackupNeverTitle
                    : l.settingsBackupDaysTitle(SettingsFormat.daysBetween(last, now)),
                body: l.settingsBackupWhyBody,
              ),
              const SizedBox(height: AppSpace.s4),
            ],
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: AppIcons.json,
                  label: l.settingsExportJson,
                  subtitle: l.settingsExportJsonLong,
                  trailing: upload,
                  onTap: () => BackupActions.exportJson(context, ref),
                ),
                SettingRow(
                  icon: AppIcons.csv,
                  label: l.settingsExportCsv,
                  subtitle: l.settingsExportCsvLong,
                  trailing: upload,
                  onTap: () => BackupActions.exportCsv(context, ref),
                ),
              ],
            ),
            const SizedBox(height: AppSpace.s4),
            AppGroup(
              dividerIndent: 52,
              children: [
                SettingRow(
                  icon: AppIcons.backup,
                  label: l.settingsRestore,
                  subtitle: l.settingsRestoreHint,
                  onTap: () => BackupActions.restore(context, ref),
                ),
              ],
            ),
            if (settings != null)
              ListNote(
                last == null
                    ? l.settingsNeverBackedUp
                    : l.settingsLastBackupFile(
                        AppDates.full(l, LocalDate.fromDateTime(last)),
                        SettingsFormat.backupFileName(last),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
