import 'dart:async';
import 'dart:ui' show Locale;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/backup/auto_backup_service.dart';
import '../../data/backup/backup_folder_service.dart';
import '../../data/providers.dart';
import '../../data/secret_store.dart';
import '../../l10n/generated/app_localizations.dart';
import 'auto_backup_scheduler.dart';

export 'auto_backup_scheduler.dart';

/// Secure storage for the auto-backup password and configuration.
final secretStoreProvider = Provider<SecretStore>((ref) => const SecureSecretStore());

/// Channel that writes into the folder the user picked; tests override it.
final backupFolderServiceProvider = Provider<BackupFolderService>((ref) => const BackupFolderService());

final autoBackupServiceProvider = Provider<AutoBackupService>(
  (ref) => AutoBackupService(
    backup: ref.watch(backupServiceProvider),
    folder: ref.watch(backupFolderServiceProvider),
    secrets: ref.watch(secretStoreProvider),
    clock: ref.watch(clockProvider),
  ),
);

/// Configuration and latest result for the "Automatic backup" card; invalidate
/// after each action.
final autoBackupStateProvider = FutureProvider<AutoBackupState>((ref) => ref.watch(autoBackupServiceProvider).state());

/// "Back up now" is running from Settings: the button shows a spinner and
/// ignores taps until it finishes.
class AutoBackupRunning extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final autoBackupRunningProvider = NotifierProvider<AutoBackupRunning, bool>(AutoBackupRunning.new);

/// The backup schedule: Android uses a background alarm, iOS a local
/// notification. Tests override it with a fake.
final autoBackupSchedulerProvider = Provider<AutoBackupScheduler>(
  (ref) => platformAutoBackupScheduler(ref.watch(notificationServiceProvider)),
);

/// Keeps the schedule in step with the saved configuration: runs on app start
/// (restores a schedule the system may have dropped, e.g. after a force stop)
/// and whenever it is turned on/off, the time changes or the language changes
/// (iOS notification copy). `main.dart` keeps this provider alive.
final autoBackupScheduleSyncProvider = Provider<void>((ref) {
  final state = ref.watch(autoBackupStateProvider);
  final settings = ref.watch(settingsProvider);
  final scheduler = ref.watch(autoBackupSchedulerProvider);
  if (!state.hasValue || !settings.hasValue) return;
  final s = state.value!;
  if (!s.enabled) {
    unawaited(scheduler.cancel());
    return;
  }
  final code = settings.value!.localeCode ?? 'en';
  final l = lookupAppLocalizations(Locale(code));
  unawaited(scheduler.schedule(s.time, title: l.commonAppName, body: l.settingsAutoBackupNotificationBody));
});
