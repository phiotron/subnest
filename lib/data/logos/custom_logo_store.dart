import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Custom logos: pictures the user picked for a subscription (CONTEXT "Custom logo").
///
/// Square PNG files in `<app support>/custom_logos/`. The subscription keeps the file NAME in
/// `Subscription.customLogoFile`; every new picture gets a new name ([save] →
/// `<subscriptionId>-<millis>.png`), so a decoded image in the image cache is never stale.
/// User data: part of the backup ([readAll] / [replaceAll]), wiped by "Delete all data" ([clear]),
/// and files no subscription points at are removed ([keepOnly], at start-up).
class CustomLogoStore extends ChangeNotifier {
  CustomLogoStore(this._directory, {DateTime Function()? clock}) : _clock = clock ?? DateTime.now;

  /// The app's store: `<application support>/custom_logos` (not the cache: the OS must not clear it).
  static final CustomLogoStore instance = CustomLogoStore(
    () async => Directory(p.join((await getApplicationSupportDirectory()).path, 'custom_logos')),
  );

  /// Side of the stored PNG in px (crisp on the 80 px detail tile at 3×).
  static const side = 256;

  /// Larger files are refused (picker output is ~256 px; this guards backups edited by hand).
  static const maxBytes = 1024 * 1024;

  final Future<Directory> Function() _directory;
  final DateTime Function() _clock;
  Directory? _dir;
  Future<void>? _loading;

  /// File names this store writes: `<id>-<digits>.png` (no folders, no `..` — a hand-edited backup
  /// cannot write outside the folder).
  static bool validName(String name) => RegExp(r'^[A-Za-z0-9_-]{1,80}\.png$').hasMatch(name);

  /// PNG, JPEG or WebP signature — the only formats written or restored.
  static bool looksLikeImage(Uint8List b) =>
      b.length > 12 &&
      ((b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47) ||
          (b[0] == 0xFF && b[1] == 0xD8 && b[2] == 0xFF) ||
          (b[0] == 0x52 && b[1] == 0x49 && b[2] == 0x46 && b[3] == 0x46 && b[8] == 0x57 && b[9] == 0x45));

  bool get loaded => _dir != null;

  /// Resolves the folder (tiles show letters until then) and drops half-written files.
  /// Safe to call many times.
  Future<void> load() => _loading ??= _load();

  Future<void> _load() async {
    final dir = await _directory();
    if (!dir.existsSync()) await dir.create(recursive: true);
    await for (final e in dir.list()) {
      if (e is File && e.path.endsWith('.part')) await _delete(e);
    }
    _dir = dir;
    notifyListeners();
  }

  Future<Directory> _ready() async {
    await load();
    return _dir!;
  }

  /// The file for a `customLogoFile` name, or `null` (not loaded yet / invalid name). The file may
  /// be missing (e.g. a backup restored without its pictures) — the tile then keeps its letters.
  File? fileOf(String name) {
    final dir = _dir;
    if (dir == null || !validName(name)) return null;
    return File(p.join(dir.path, name));
  }

  /// Saves a new picture for [subscriptionId]; returns its file name (store it in
  /// `Subscription.customLogoFile`, then [delete] the previous one).
  Future<String> save(String subscriptionId, Uint8List bytes) async {
    if (bytes.length > maxBytes || !looksLikeImage(bytes)) throw ArgumentError('Not a logo image');
    final safeId = subscriptionId.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '');
    final base = safeId.isEmpty ? 'logo' : (safeId.length > 60 ? safeId.substring(0, 60) : safeId);
    final dir = await _ready();
    var stamp = _clock().millisecondsSinceEpoch;
    while (File(p.join(dir.path, '$base-$stamp.png')).existsSync()) {
      stamp++;
    }
    final name = '$base-$stamp.png';
    await _write(dir, name, bytes);
    return name;
  }

  Future<void> _write(Directory dir, String name, Uint8List bytes) async {
    final file = File(p.join(dir.path, name));
    final tmp = File('${file.path}.part'); // write next to it, then rename: never a half file
    await tmp.writeAsBytes(bytes, flush: true);
    await tmp.rename(file.path);
    _evict(file);
  }

  /// Deletes one picture (no-op for `null`, invalid or missing names).
  Future<void> delete(String? name) async {
    if (name == null || !validName(name)) return;
    final file = File(p.join((await _ready()).path, name));
    await _delete(file);
    _evict(file);
  }

  Future<List<File>> _files() async {
    final dir = await _ready();
    return [
      await for (final e in dir.list())
        if (e is File && validName(p.basename(e.path))) e,
    ];
  }

  /// Every picture's name.
  Future<Set<String>> names() async => {for (final f in await _files()) p.basename(f.path)};

  /// Deletes every picture ("Delete all data").
  Future<void> clear() async {
    for (final f in await _files()) {
      await _delete(f);
      _evict(f);
    }
    notifyListeners();
  }

  /// Deletes pictures no subscription points at ([used] = every `customLogoFile`).
  Future<void> keepOnly(Set<String> used) async {
    for (final f in await _files()) {
      if (used.contains(p.basename(f.path))) continue;
      await _delete(f);
      _evict(f);
    }
  }

  /// The bytes of [only] (names; missing files skipped), for the backup file.
  Future<Map<String, Uint8List>> readAll(Set<String> only) async {
    final dir = await _ready();
    final out = <String, Uint8List>{};
    for (final name in only.toList()..sort()) {
      if (!validName(name)) continue;
      try {
        out[name] = await File(p.join(dir.path, name)).readAsBytes();
      } on FileSystemException {
        // Missing — skip.
      }
    }
    return out;
  }

  /// Restore: deletes every picture, then writes [logos] (name → bytes; invalid names/images are
  /// skipped). Returns how many were written.
  Future<int> replaceAll(Map<String, Uint8List> logos) async {
    final dir = await _ready();
    for (final f in await _files()) {
      await _delete(f);
      _evict(f);
    }
    var n = 0;
    for (final e in logos.entries) {
      if (!validName(e.key) || e.value.length > maxBytes || !looksLikeImage(e.value)) continue;
      await _write(dir, e.key, e.value);
      n++;
    }
    notifyListeners();
    return n;
  }

  /// Drops a decoded image of [file] (same path → same cache key).
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
