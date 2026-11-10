import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Custom logos: images the user picked for a subscription (CONTEXT "Custom logo").
///
/// One square PNG per subscription in `<app support>/custom_logos/<subscriptionId>.png` — the file
/// name is the subscription id, so no database column is needed and "has a custom logo" is "the
/// file exists". Kept in memory as a set of ids (loaded once by [load]) so tiles can ask
/// synchronously. User data: part of the backup ([readAll] / [replaceAll]), wiped by "Delete all
/// data" ([clear]), and pruned when the subscription is gone ([keepOnly]).
class CustomLogoStore extends ChangeNotifier {
  CustomLogoStore(this._directory);

  /// The app's store: `<application support>/custom_logos` (not the cache: the OS must not clear it).
  static final CustomLogoStore instance = CustomLogoStore(
    () async => Directory(p.join((await getApplicationSupportDirectory()).path, 'custom_logos')),
  );

  /// Side of the stored PNG in px (crisp on the 80 px detail tile at 3×).
  static const side = 256;

  /// Larger files are refused (picker output is ~256 px; this guards backups edited by hand).
  static const maxBytes = 1024 * 1024;

  final Future<Directory> Function() _directory;
  Directory? _dir;
  final _ids = <String>{};
  Future<void>? _loading;

  /// Subscription ids are UUIDs; anything else (path tricks in a hand-edited backup) is refused.
  static bool validId(String id) => RegExp(r'^[A-Za-z0-9_-]{1,64}$').hasMatch(id);

  /// PNG, JPEG or WebP signature — the only formats written or restored.
  static bool looksLikeImage(Uint8List b) =>
      b.length > 12 &&
      ((b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) ||
          (b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) ||
          (b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46 && b[8] == 0x57 && b[9] == 0x45));

  bool get loaded => _dir != null;

  /// Reads which subscriptions have a logo. Safe to call many times; tiles show monograms until done.
  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    final dir = await _directory();
    if (!dir.existsSync()) await dir.create(recursive: true);
    _ids.clear();
    await for (final e in dir.list()) {
      final name = p.basename(e.path);
      if (e is! File) continue;
      if (name.endsWith('.part')) {
        await _delete(e);
      } else if (name.endsWith('.png')) {
        _ids.add(p.basenameWithoutExtension(name));
      }
    }
    _dir = dir;
    if (_ids.isNotEmpty) notifyListeners();
  }

  Future<Directory> _ready() async {
    await load();
    return _dir!;
  }

  bool has(String subscriptionId) => _ids.contains(subscriptionId);

  /// Ids with a logo (loaded ones only).
  Set<String> get ids => Set.unmodifiable(_ids);

  /// The file of [subscriptionId]'s logo, or `null` when it has none (or [load] has not finished).
  File? fileOf(String subscriptionId) {
    final dir = _dir;
    if (dir == null || !_ids.contains(subscriptionId)) return null;
    return File(p.join(dir.path, '$subscriptionId.png'));
  }

  /// Saves (or replaces) the logo of [subscriptionId].
  Future<void> save(String subscriptionId, Uint8List bytes) async {
    if (!validId(subscriptionId)) throw ArgumentError.value(subscriptionId, 'subscriptionId');
    if (bytes.length > maxBytes || !looksLikeImage(bytes)) throw ArgumentError('Not a logo image');
    await _write(await _ready(), subscriptionId, bytes);
    notifyListeners();
  }

  Future<void> _write(Directory dir, String id, Uint8List bytes) async {
    final file = File(p.join(dir.path, '$id.png'));
    final tmp = File('${file.path}.part'); // write next to it, then rename: never a half file
    await tmp.writeAsBytes(bytes, flush: true);
    await tmp.rename(file.path);
    _evict(file);
    _ids.add(id);
  }

  /// Removes the logo of [subscriptionId] (no-op when it has none).
  Future<void> remove(String subscriptionId) async {
    final dir = await _ready();
    if (!validId(subscriptionId)) return;
    final file = File(p.join(dir.path, '$subscriptionId.png'));
    final had = _ids.remove(subscriptionId);
    await _delete(file);
    _evict(file);
    if (had) notifyListeners();
  }

  /// Deletes every custom logo ("Delete all data").
  Future<void> clear() async {
    final dir = await _ready();
    for (final id in _ids.toList()) {
      final file = File(p.join(dir.path, '$id.png'));
      await _delete(file);
      _evict(file);
    }
    final had = _ids.isNotEmpty;
    _ids.clear();
    if (had) notifyListeners();
  }

  /// Deletes logos of subscriptions not in [subscriptionIds] (deleted elsewhere).
  Future<void> keepOnly(Set<String> subscriptionIds) async {
    final dir = await _ready();
    final gone = _ids.difference(subscriptionIds);
    for (final id in gone) {
      final file = File(p.join(dir.path, '$id.png'));
      await _delete(file);
      _evict(file);
    }
    _ids.removeAll(gone);
    if (gone.isNotEmpty) notifyListeners();
  }

  /// Every logo's bytes, keyed by subscription id (for the backup file).
  Future<Map<String, Uint8List>> readAll({Set<String>? only}) async {
    final dir = await _ready();
    final out = <String, Uint8List>{};
    for (final id in _ids.toList()..sort()) {
      if (only != null && !only.contains(id)) continue;
      try {
        out[id] = await File(p.join(dir.path, '$id.png')).readAsBytes();
      } on FileSystemException {
        // Vanished meanwhile — skip.
      }
    }
    return out;
  }

  /// Restore: deletes every logo, then writes [logos] (invalid ids/images are skipped).
  /// Returns how many were written.
  Future<int> replaceAll(Map<String, Uint8List> logos) async {
    final dir = await _ready();
    for (final id in _ids.toList()) {
      final file = File(p.join(dir.path, '$id.png'));
      await _delete(file);
      _evict(file);
    }
    _ids.clear();
    var n = 0;
    for (final e in logos.entries) {
      if (!validId(e.key) || e.value.length > maxBytes || !looksLikeImage(e.value)) continue;
      await _write(dir, e.key, e.value);
      n++;
    }
    notifyListeners();
    return n;
  }

  /// Drops the decoded image so a replaced file is read again (same path → same cache key).
  static void _evict(File file) {
    try {
      FileImage(file).evict();
    } catch (_) {
      // No painting binding (pure Dart use) — nothing cached.
    }
  }

  static Future<void> _delete(File f) async {
    try {
      if (f.existsSync()) await f.delete();
    } on FileSystemException {
      // Already gone.
    }
  }
}
