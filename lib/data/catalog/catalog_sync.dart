import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../../domain/domain.dart';
import 'catalog_cache.dart';
import 'catalog_data.dart';
import 'catalog_validator.dart';

/// Result of [CatalogSync.refreshIfDue].
enum CatalogRefreshResult {
  /// A newer Catalog was downloaded, checked and cached — reload the Catalog.
  updated,

  /// The server has nothing newer than the Catalog in use.
  upToDate,

  /// Already checked today.
  notDue,

  /// No network / timeout — try again next time the app opens.
  offline,

  /// The server answered something unusable (bad meta, checksum, schema, validator…). The Catalog in
  /// use stays; the check counts for today.
  failed,
}

/// Downloads the remote Catalog (ADR 0002) — plain GETs of static files on GitHub Pages, no query, no
/// header, nothing about the user (S-42):
///
/// 1. at most once a day: `meta.json` → when its `version` is newer than the Catalog in use,
/// 2. `services.min.json`, checked against `meta.files["services.min.json"].sha256`, then
///    [CatalogValidator] (schema, entries, no removed ids) → cached ([CatalogCache]),
/// 3. logos for services that are not bundled: `logos/index.json` (`{"files": {serviceId: sha256}}`),
///    then `logos/<serviceId>.png` for new/changed ones, each checked (sha256, PNG, size).
///
/// Never throws; any failure keeps what the app already has, silently.
class CatalogSync {
  CatalogSync({
    required this.cache,
    required this.current,
    required this.bundledLogoIds,
    http.Client? client,
    DateTime Function()? clock,
    Uri? base,
    this.beforeReplace,
  }) : _client = client ?? http.Client(),
       _clock = clock ?? DateTime.now,
       base = base ?? defaultBase;

  /// Folder served by GitHub Pages for this app (repo `phamphuongphuongnd/catalog`).
  static final Uri defaultBase = Uri.parse('https://phamphuongphuongnd.github.io/catalog/subnest/v1/');

  static const metaPath = 'meta.json';
  static const catalogPath = 'services.min.json';
  static const logoIndexPath = 'logos/index.json';
  static String logoPath(String serviceId) => 'logos/$serviceId.png';

  static const timeout = Duration(seconds: 15);
  static const maxMetaBytes = 64 * 1024;
  static const maxCatalogBytes = 8 * 1024 * 1024;
  static const maxLogoIndexBytes = 512 * 1024;
  static const maxLogoBytes = 256 * 1024;

  /// Logos fetched per refresh (the rest come the next day).
  static const maxLogosPerRun = 60;

  final CatalogCache cache;

  /// The Catalog in use (newest valid of bundled and cached).
  final Future<CatalogData> Function() current;

  /// Services that already have a logo in the app.
  final Set<String> bundledLogoIds;

  /// Called with the Catalog in use right before a newer one replaces it (the notice store records
  /// its prices as "old Catalog prices").
  final Future<void> Function(CatalogData old)? beforeReplace;

  final Uri base;
  final http.Client _client;
  final DateTime Function() _clock;

  Future<CatalogRefreshResult>? _running;

  /// Checks the server when not checked today (or [force]). Concurrent calls share one run.
  Future<CatalogRefreshResult> refreshIfDue({bool force = false}) => _running ??= _refresh(force).whenComplete(() {
    _running = null;
  });

  Future<CatalogRefreshResult> _refresh(bool force) async {
    try {
      final now = _clock();
      var state = await cache.readState();
      if (!force && !isDue(state.lastCheckAt, now)) return CatalogRefreshResult.notDue;

      final inUse = await current();
      final http.Response metaRes;
      try {
        metaRes = await _get(metaPath);
      } catch (_) {
        return CatalogRefreshResult.offline;
      }
      // The server answered: this counts as today's check whatever comes next.
      state = state.copyWith(lastCheckAt: now);
      await cache.writeState(state);

      final meta = _parseMeta(metaRes);
      if (meta == null) return CatalogRefreshResult.failed;

      var result = CatalogRefreshResult.upToDate;
      var catalog = inUse;
      if (meta.version > inUse.version) {
        final downloaded = await _download(meta, inUse);
        if (downloaded == null) return CatalogRefreshResult.failed;
        await beforeReplace?.call(inUse);
        await cache.writeCatalog(downloaded.text);
        state = state.copyWith(downloadedAt: now, version: downloaded.data.version, sha256: meta.sha256);
        await cache.writeState(state);
        catalog = downloaded.data;
        result = CatalogRefreshResult.updated;
      }
      await _syncLogos(catalog);
      return result;
    } catch (_) {
      return CatalogRefreshResult.failed;
    }
  }

  /// Once per calendar day (device time); a clock set back also allows a check.
  static bool isDue(DateTime? lastCheckAt, DateTime now) {
    if (lastCheckAt == null || now.isBefore(lastCheckAt)) return true;
    return LocalDate.fromDateTime(lastCheckAt) != LocalDate.fromDateTime(now);
  }

  Future<http.Response> _get(String path) => _client.get(base.resolve(path)).timeout(timeout);

  ({int version, String sha256, int? bytes})? _parseMeta(http.Response res) {
    if (res.statusCode != 200 || res.bodyBytes.length > maxMetaBytes) return null;
    try {
      final j = jsonDecode(utf8.decode(res.bodyBytes));
      if (j is! Map) return null;
      if (!CatalogValidator.supportedSchemas.contains(j['schemaVersion'])) return null;
      final version = j['version'];
      final file = (j['files'] as Map?)?[catalogPath];
      final sha = file is Map ? file['sha256'] : null;
      if (version is! int || sha is! String || !RegExp(r'^[0-9a-f]{64}$').hasMatch(sha)) return null;
      final bytes = file['bytes'];
      return (version: version, sha256: sha, bytes: bytes is int ? bytes : null);
    } catch (_) {
      return null;
    }
  }

  Future<({String text, CatalogData data})?> _download(
    ({int version, String sha256, int? bytes}) meta,
    CatalogData inUse,
  ) async {
    final http.Response res;
    try {
      res = await _get(catalogPath);
    } catch (_) {
      return null;
    }
    final body = res.bodyBytes;
    if (res.statusCode != 200 || body.length > maxCatalogBytes) return null;
    if (meta.bytes != null && body.length != meta.bytes) return null;
    if (sha256.convert(body).toString() != meta.sha256) return null;
    try {
      final text = utf8.decode(body);
      final data = CatalogValidator.validate(text, previous: inUse);
      if (data.version != meta.version || data.version <= inUse.version) return null;
      return (text: text, data: data.withDownloadedAt(_clock()));
    } catch (_) {
      return null;
    }
  }

  // ---- Logos ----------------------------------------------------------------------------------

  Future<void> _syncLogos(CatalogData catalog) async {
    var state = await cache.readState();
    final wanted = {for (final s in catalog.services) s.id}.difference(bundledLogoIds);

    // Drop logos of services that are bundled now (app update) or gone from the Catalog in use.
    final kept = <String, ({String file, String sha256})>{};
    for (final e in state.logos.entries) {
      if (wanted.contains(e.key)) {
        kept[e.key] = e.value;
      } else {
        await cache.deleteLogo(e.value.file);
      }
    }
    if (kept.length != state.logos.length) {
      state = state.copyWith(logos: kept);
      await cache.writeState(state);
    }
    if (state.logosVersion == catalog.version || wanted.isEmpty) return;

    final http.Response res;
    try {
      res = await _get(logoIndexPath);
    } catch (_) {
      return; // retry next check
    }
    if (res.statusCode == 404) {
      // No logo folder published (yet): nothing to fetch for this version.
      await cache.writeState(state.copyWith(logosVersion: catalog.version));
      return;
    }
    final index = _parseLogoIndex(res);
    if (index == null) return;

    final logos = Map.of(kept);
    var fetched = 0;
    var complete = true;
    for (final e in index.entries) {
      if (!wanted.contains(e.key) || logos[e.key]?.sha256 == e.value) continue;
      if (fetched >= maxLogosPerRun) {
        complete = false;
        break;
      }
      fetched++;
      final bytes = await _downloadLogo(e.key, e.value);
      if (bytes == null) {
        complete = false;
        continue;
      }
      final file = '${e.key}-${e.value.substring(0, 8)}.png';
      try {
        await cache.writeLogo(file, bytes);
      } catch (_) {
        complete = false;
        continue;
      }
      final old = logos[e.key];
      if (old != null && old.file != file) await cache.deleteLogo(old.file);
      logos[e.key] = (file: file, sha256: e.value);
    }
    await cache.writeState(
      (await cache.readState()).copyWith(logos: logos, logosVersion: complete ? catalog.version : null),
    );
  }

  Map<String, String>? _parseLogoIndex(http.Response res) {
    if (res.statusCode != 200 || res.bodyBytes.length > maxLogoIndexBytes) return null;
    try {
      final j = jsonDecode(utf8.decode(res.bodyBytes));
      final files = j is Map ? j['files'] : null;
      if (files is! Map) return null;
      final sha = RegExp(r'^[0-9a-f]{64}$');
      return {
        for (final e in files.entries)
          if (e.key is String &&
              CatalogValidator.slug.hasMatch(e.key as String) &&
              e.value is String &&
              sha.hasMatch(e.value as String))
            e.key as String: e.value as String,
      };
    } catch (_) {
      return null;
    }
  }

  Future<Uint8List?> _downloadLogo(String serviceId, String expectedSha) async {
    try {
      final res = await _get(logoPath(serviceId));
      final b = res.bodyBytes;
      if (res.statusCode != 200 || b.length > maxLogoBytes || !isPng(b)) return null;
      if (sha256.convert(b).toString() != expectedSha) return null;
      return b;
    } catch (_) {
      return null;
    }
  }

  static bool isPng(Uint8List b) =>
      b.length > 8 && b[0] == 0x89 && b[1] == 0x50 && b[2] == 0x4E && b[3] == 0x47 && b[4] == 0x0D && b[5] == 0x0A;
}
