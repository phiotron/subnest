import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/backup/backup_files.dart';
import '../../data/backup/backup_service.dart';

/// A backup file the user picked: its name (shown in the restore dialog) and text.
typedef PickedBackup = ({String name, String text});

/// Everything Settings asks of the OS — links, mail, the share sheet, the file picker and the
/// system notification settings — behind one seam so widget tests can fake it.
class SettingsPlatform {
  const SettingsPlatform();

  bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Opens [uri] outside the app (browser, mail app, store). `false` when nothing can handle it.
  Future<bool> openExternal(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  /// Subnest's page in the system notification settings (Android 8+ / iOS 15.4+; falls back to
  /// the app's settings page). Uses the notifications plugin singleton — no new dependency.
  Future<bool> openNotificationSettings() async {
    if (kIsWeb) return false;
    try {
      final plugin = FlutterLocalNotificationsPlugin();
      if (Platform.isAndroid) {
        final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
        return await android?.openAppNotificationSettings() ?? false;
      }
      if (Platform.isIOS) {
        final ios = plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
        return await ios?.openAppNotificationSettings() ?? false;
      }
    } catch (_) {
      // Plugin not initialised / channel missing → caller shows the manual path.
    }
    return false;
  }

  /// Shares exported files through the system share sheet. `true` when the user completed it.
  Future<bool> share(List<ExportFile> files, {String? subject}) async {
    final r = await BackupFiles.share(files, subject: subject);
    return r.status == ShareResultStatus.success;
  }

  /// Lets the user pick a backup; `null` when cancelled. `FileType.any` because `.json` is not a
  /// reliable MIME filter on Android (same as `BackupFiles.pickJson`, which drops the file name).
  Future<PickedBackup?> pickBackup() async {
    final file = await FilePicker.pickFile(type: FileType.any);
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return (name: file.name, text: utf8.decode(bytes, allowMalformed: true));
  }
}

final settingsPlatformProvider = Provider<SettingsPlatform>((ref) => const SettingsPlatform());
