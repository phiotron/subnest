import 'dart:io';
import 'dart:typed_data';

/// What is on disk for one domain.
class CachedLogo {
  const CachedLogo.logo(Uint8List this.bytes, this.savedAt);
  const CachedLogo.missing(this.savedAt) : bytes = null;

  /// PNG bytes; `null` = Logo.dev has no logo for this domain (remembered "missing").
  final Uint8List? bytes;
  final DateTime savedAt;

  bool get isMissing => bytes == null;
}

/// Logo files in the app's cache directory (the OS may clear it; nothing here is user data).
///
/// One file per normalized domain: `<domain>.png` (a logo) or `<domain>.none` (empty — no logo).
/// The save time is the file's modified time, so no index file can get out of sync.
class LogoDiskCache {
  LogoDiskCache(this._directory);

  final Future<Directory> Function() _directory;
  Directory? _dir;

  Future<Directory> _resolve() async {
    final dir = _dir ??= await _directory();
    if (!dir.existsSync()) await dir.create(recursive: true);
    return dir;
  }

  Future<File> _file(String domain, String ext) async => File('${(await _resolve()).path}/$domain.$ext');

  Future<CachedLogo?> read(String domain) async {
    final png = await _file(domain, 'png');
    if (png.existsSync()) {
      final bytes = await png.readAsBytes();
      if (bytes.isNotEmpty) return CachedLogo.logo(bytes, (await png.stat()).modified);
    }
    final none = await _file(domain, 'none');
    if (none.existsSync()) return CachedLogo.missing((await none.stat()).modified);
    return null;
  }

  Future<void> writeLogo(String domain, Uint8List bytes, DateTime at) async {
    await _delete(await _file(domain, 'none'));
    final png = await _file(domain, 'png');
    // Write next to it, then rename: a half-written file is never read as a logo.
    final tmp = File('${png.path}.part');
    await tmp.writeAsBytes(bytes, flush: true);
    await tmp.rename(png.path);
    await png.setLastModified(at);
  }

  Future<void> writeMissing(String domain, DateTime at) async {
    await _delete(await _file(domain, 'png'));
    final none = await _file(domain, 'none');
    await none.writeAsBytes(const [], flush: true);
    await none.setLastModified(at);
  }

  /// Drops "missing" marks older than [missingTtl], logos older than [maxAge], leftover `.part`
  /// files, then the oldest logos until the folder is at most [keepBytes] when it exceeds [maxBytes].
  Future<void> prune({
    required DateTime now,
    required Duration missingTtl,
    required Duration maxAge,
    required int maxBytes,
    required int keepBytes,
  }) async {
    final dir = await _resolve();
    final logos = <(File, DateTime, int)>[];
    var total = 0;
    await for (final e in dir.list()) {
      if (e is! File) continue;
      final stat = await e.stat();
      final age = now.difference(stat.modified);
      if (e.path.endsWith('.part') ||
          (e.path.endsWith('.none') && age > missingTtl) ||
          (e.path.endsWith('.png') && age > maxAge)) {
        await _delete(e);
      } else if (e.path.endsWith('.png')) {
        logos.add((e, stat.modified, stat.size));
        total += stat.size;
      }
    }
    if (total <= maxBytes) return;
    logos.sort((a, b) => a.$2.compareTo(b.$2));
    for (final (file, _, size) in logos) {
      if (total <= keepBytes) break;
      await _delete(file);
      total -= size;
    }
  }

  static Future<void> _delete(File f) async {
    try {
      if (f.existsSync()) await f.delete();
    } on FileSystemException {
      // Another isolate/OS cleanup got there first — fine.
    }
  }
}
