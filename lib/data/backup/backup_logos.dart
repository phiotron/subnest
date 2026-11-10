import 'dart:convert';
import 'dart:typed_data';

import '../logos/custom_logo_store.dart';

/// Custom logos in the backup file: optional top-level `customLogos` = `{subscriptionId: base64 PNG}`
/// (added 2026-11-10 without a version bump — older files simply lack it; older app versions
/// ignore it, and it is covered by the v3 checksum like every other data key).
abstract final class BackupLogos {
  static const key = 'customLogos';

  /// The JSON value for the logos of [subscriptionIds], or `null` when there are none (the key is
  /// then left out, so backups without logos are byte-for-byte what they were before).
  /// Never throws: a store that cannot be read means no logos in this backup.
  static Future<Map<String, String>?> export(CustomLogoStore store, Set<String> subscriptionIds) async {
    try {
      final logos = await store.readAll(only: subscriptionIds);
      if (logos.isEmpty) return null;
      return {for (final e in logos.entries) e.key: base64Encode(e.value)};
    } catch (_) {
      return null;
    }
  }

  /// Decodes the file's logos for [subscriptionIds]; bad entries are skipped.
  static Map<String, Uint8List> decode(Object? value, Set<String> subscriptionIds) {
    if (value is! Map) return const {};
    final out = <String, Uint8List>{};
    for (final e in value.entries) {
      final id = e.key, data = e.value;
      if (id is! String || data is! String || !subscriptionIds.contains(id)) continue;
      try {
        out[id] = base64Decode(data);
      } on FormatException {
        // Corrupt entry — that subscription keeps its letters.
      }
    }
    return out;
  }

  /// Restore: the store ends up holding exactly the file's logos (none when the file has none —
  /// a restore replaces everything). Returns how many were restored; never throws.
  static Future<int> restore(CustomLogoStore store, Object? value, Set<String> subscriptionIds) async {
    try {
      return await store.replaceAll(decode(value, subscriptionIds));
    } catch (_) {
      return 0;
    }
  }
}
