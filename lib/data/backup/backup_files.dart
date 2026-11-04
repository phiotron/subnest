import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'backup_service.dart';

/// Platform side of backups: write files to a temp folder and open the system share sheet;
/// pick a backup file to restore.
abstract final class BackupFiles {
  static Future<ShareResult> share(List<ExportFile> files, {String? subject}) async {
    final dir = await getTemporaryDirectory();
    final xfiles = <XFile>[];
    for (final f in files) {
      final file = File(p.join(dir.path, f.name));
      await file.writeAsString(f.content, encoding: utf8, flush: true);
      xfiles.add(XFile(file.path, mimeType: f.mimeType, name: f.name));
    }
    return SharePlus.instance.share(ShareParams(files: xfiles, subject: subject));
  }

  /// Lets the user pick a backup; returns its text or `null` when cancelled.
  /// Uses `FileType.any` because `.json` is not a reliable MIME filter on Android.
  static Future<String?> pickJson() async {
    final file = await FilePicker.pickFile(type: FileType.any);
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return utf8.decode(bytes, allowMalformed: true);
  }
}
