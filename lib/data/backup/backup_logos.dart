import 'dart:convert';
import 'dart:typed_data';

import '../logos/custom_logo_store.dart';

/// Custom logos in the backup file: optional top-level `customLogos` = `{fileName: base64 PNG}`,
/// where `fileName` is a subscription's `customLogoFile` (added 2026-11-10 without a version bump —
/// older files simply lack it; older app versions ignore it). It is part of the data the v3
/// checksum covers and of the text that is encrypted when the backup has a password.
abstract final class BackupLogos {
  static const key = 'customLogos';

  /// The JSON value for the pictures named in [fileNames], or `null` when there are none (the key
  /// is then left out). Never throws: a store that cannot be read means no pictures in this backup.
  static Future<Map<String, String>?> export(CustomLogoStore store, Set<String> fileNames) async {
    if (fileNames.isEmpty) return null;
    try {
      final logos = await store.readAll(fileNames);
      if (logos.isEmpty) return null;
      return {for (final e in logos.entries) e.key: base64Encode(e.value)};
    } catch (_) {
      return null;
    }
  }

  /// Decodes the file's pictures named in [fileNames]; bad entries are skipped.
  static Map<String, Uint8List> decode(Object? value, Set<String> fileNames) {
    if (value is! Map) return const {};
    final out = <String, Uint8List>{};
    for (final e in value.entries) {
      final name = e.key, data = e.value;
      if (name is! String || data is! String || !fileNames.contains(name)) continue;
      try {
        out[name] = base64Decode(data);
      } on FormatException {
        // Corrupt entry — that subscription keeps its letters.
      }
    }
    return out;
  }

  /// Restore: the folder ends up holding exactly the file's pictures (none when the file has none —
  /// a restore replaces everything). Returns how many were restored; never throws.
  static Future<int> restore(CustomLogoStore store, Object? value, Set<String> fileNames) async {
    try {
      return await store.replaceAll(decode(value, fileNames));
    } catch (_) {
      return 0;
    }
  }
}
