import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Bookkeeping of the remote Catalog on this device (`state.json`).
class CatalogSyncState {
  const CatalogSyncState({
    this.lastCheckAt,
    this.downloadedAt,
    this.version,
    this.sha256,
    this.logosVersion,
    this.logos = const {},
  });

  /// Last time the app asked the server (`meta.json` answered) — at most one check per day.
  final DateTime? lastCheckAt;

  /// When the cached `services.json` was downloaded.
  final DateTime? downloadedAt;

  /// Data version of the cached file.
  final int? version;
  final String? sha256;

  /// Catalog version whose logo list was synced (`null` = never / retry).
  final int? logosVersion;

  /// Remote logos on disk: service id → `{file, sha256}` (file name inside [CatalogCache.logosDir]).
  final Map<String, ({String file, String sha256})> logos;

  CatalogSyncState copyWith({
    DateTime? lastCheckAt,
    DateTime? downloadedAt,
    int? version,
    String? sha256,
    Object? logosVersion = _keep,
    Map<String, ({String file, String sha256})>? logos,
  }) => CatalogSyncState(
    lastCheckAt: lastCheckAt ?? this.lastCheckAt,
    downloadedAt: downloadedAt ?? this.downloadedAt,
    version: version ?? this.version,
    sha256: sha256 ?? this.sha256,
    logosVersion: identical(logosVersion, _keep) ? this.logosVersion : logosVersion as int?,
    logos: logos ?? this.logos,
  );

  Map<String, Object?> toJson() => {
    'lastCheckAt': lastCheckAt?.toUtc().toIso8601String(),
    'downloadedAt': downloadedAt?.toUtc().toIso8601String(),
    'version': version,
    'sha256': sha256,
    'logosVersion': logosVersion,
    'logos': {for (final e in logos.entries) e.key: {'file': e.value.file, 'sha256': e.value.sha256}},
  };

  static CatalogSyncState fromJson(Map<String, Object?> j) {
    DateTime? time(Object? v) => v is String ? DateTime.tryParse(v)?.toLocal() : null;
    final logos = <String, ({String file, String sha256})>{};
    final raw = j['logos'];
    if (raw is Map) {
      for (final e in raw.entries) {
        final v = e.value;
        if (e.key is String && v is Map && v['file'] is String && v['sha256'] is String) {
          logos[e.key as String] = (file: v['file'] as String, sha256: v['sha256'] as String);
        }
      }
    }
    return CatalogSyncState(
      lastCheckAt: time(j['lastCheckAt']),
      downloadedAt: time(j['downloadedAt']),
      version: j['version'] as int?,
      sha256: j['sha256'] as String?,
      logosVersion: j['logosVersion'] as int?,
      logos: logos,
    );
  }
}

const Object _keep = Object();

/// Files of the remote Catalog in `<application support>/catalog/`:
///
/// * `services.json` — the last valid download (`services.min.json`),
/// * `state.json` — [CatalogSyncState],
/// * `notices.json` — Price change notice memory ([readJson] / [writeJson], owned by the notice store),
/// * `logos/<serviceId>-<sha8>.png` — logos of services that are not bundled.
///
/// Not the OS cache folder (it may be wiped). Every write goes to a `.part` file first, then renames,
/// so a crash never leaves half a file. Never throws on read: a missing or broken file reads as none.
class CatalogCache {
  CatalogCache(this._directory);

  static final CatalogCache instance = CatalogCache(
    () async => Directory(p.join((await getApplicationSupportDirectory()).path, 'catalog')),
  );

  static const catalogFile = 'services.json';
  static const stateFile = 'state.json';

  final Future<Directory> Function() _directory;
  Directory? _dir;

  Future<Directory> dir() async {
    final d = _dir ??= await _directory();
    if (!d.existsSync()) await d.create(recursive: true);
    return d;
  }

  Future<Directory> logosDir() async {
    final d = Directory(p.join((await dir()).path, 'logos'));
    if (!d.existsSync()) await d.create(recursive: true);
    return d;
  }

  Future<String?> readCatalog() => _readText(catalogFile);

  Future<void> writeCatalog(String text) => _write(catalogFile, utf8.encode(text));

  Future<CatalogSyncState> readState() async {
    final j = await readJson(stateFile);
    if (j == null) return const CatalogSyncState();
    try {
      return CatalogSyncState.fromJson(j);
    } catch (_) {
      return const CatalogSyncState();
    }
  }

  Future<void> writeState(CatalogSyncState s) => writeJson(stateFile, s.toJson());

  Future<Map<String, Object?>?> readJson(String name) async {
    final text = await _readText(name);
    if (text == null) return null;
    try {
      final j = jsonDecode(text);
      return j is Map<String, Object?> ? j : null;
    } catch (_) {
      return null;
    }
  }

  Future<void> writeJson(String name, Map<String, Object?> json) => _write(name, utf8.encode(jsonEncode(json)));

  /// File of a cached logo (may not exist).
  Future<File> logoFile(String fileName) async => File(p.join((await logosDir()).path, fileName));

  Future<void> writeLogo(String fileName, Uint8List bytes) async {
    final f = await logoFile(fileName);
    final part = File('${f.path}.part');
    await part.writeAsBytes(bytes, flush: true);
    await part.rename(f.path);
  }

  Future<void> deleteLogo(String fileName) async {
    try {
      final f = await logoFile(fileName);
      if (f.existsSync()) await f.delete();
    } catch (_) {}
  }

  /// Removes everything (tests; a future "reset library" action).
  Future<void> clear() async {
    final d = await dir();
    if (d.existsSync()) await d.delete(recursive: true);
    _dir = null;
  }

  Future<String?> _readText(String name) async {
    try {
      final f = File(p.join((await dir()).path, name));
      if (!f.existsSync()) return null;
      return await f.readAsString();
    } catch (_) {
      return null;
    }
  }

  Future<void> _write(String name, List<int> bytes) async {
    final f = File(p.join((await dir()).path, name));
    final part = File('${f.path}.part');
    await part.writeAsBytes(bytes, flush: true);
    await part.rename(f.path);
  }
}
