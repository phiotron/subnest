import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'logo_dev.dart';
import 'logo_disk_cache.dart';

/// Where [ServiceTile] gets logo bytes from. Tests and the gallery inject their own through
/// `ServiceLogoScope` (core/widgets/service_tile_logo.dart); the app uses [LogoRepository.instance].
abstract interface class ServiceLogoSource {
  /// `false` → tiles never ask (no key in this build): monogram only, no network.
  bool get enabled;

  /// Bytes already in memory — lets a tile that scrolls back into view draw its logo in the
  /// first frame (no monogram → logo flash).
  Uint8List? peek(String logoDomain);

  /// Memory → disk → Logo.dev. `null` = no logo (missing, offline, error, invalid domain). Never throws.
  Future<Uint8List?> load(String logoDomain);
}

/// Service logos from Logo.dev, cached on the device (ADR 0002 §5).
///
/// * Lazy: only domains a visible tile asks for; at most [maxConcurrent] downloads at once and
///   one per domain at a time.
/// * Kept [logoTtl] (then refreshed when shown; the old file is still used if that fails),
///   folder capped at [maxCacheBytes].
/// * 404 → remembered as missing for [missingTtl]; offline/timeout/5xx → not retried for
///   [retryDelay] (memory only); 429 → all downloads pause (Retry-After); 401/403 → logos off
///   until the next launch (bad key). Only HTTPS, no redirects.
/// * The key is never logged; errors are swallowed (tile falls back to the monogram).
class LogoRepository implements ServiceLogoSource {
  LogoRepository({
    required String apiKey,
    required Future<Directory> Function() cacheDirectory,
    http.Client? client,
    DateTime Function()? clock,
  }) : _key = apiKey.trim(),
       _disk = LogoDiskCache(cacheDirectory),
       _clientOverride = client,
       _clock = clock ?? DateTime.now;

  /// The app's instance: key from `--dart-define=LOGO_DEV_KEY`, files in `<app cache>/service_logos`.
  static final LogoRepository instance = LogoRepository(
    apiKey: LogoDev.keyFromEnvironment,
    cacheDirectory: () async => Directory('${(await getApplicationCacheDirectory()).path}/service_logos'),
  );

  static const logoTtl = Duration(days: 30);
  static const missingTtl = Duration(days: 7);
  static const retryDelay = Duration(minutes: 15);
  static const maxRateLimitPause = Duration(hours: 1);
  static const requestTimeout = Duration(seconds: 15);

  /// Unused logos are deleted after this (stale ones still beat a monogram while offline).
  static const maxAge = Duration(days: 90);
  static const maxCacheBytes = 20 * 1024 * 1024;
  static const _keepBytes = 15 * 1024 * 1024;
  static const maxLogoBytes = 512 * 1024;
  static const maxConcurrent = 4;
  static const _memoryEntries = 200;
  static const _writesPerPrune = 25;

  final String _key;
  final LogoDiskCache _disk;
  final http.Client? _clientOverride;
  final DateTime Function() _clock;
  http.Client? _ownClient;

  http.Client get _client => _clientOverride ?? (_ownClient ??= http.Client());

  final _memory = <String, Uint8List>{}; // insertion-ordered: LRU
  final _inFlight = <String, Future<Uint8List?>>{};
  final _retryAt = <String, DateTime>{};
  DateTime? _pausedUntil;
  bool _rejected = false;
  bool _pruned = false;
  int _writes = 0;

  int _active = 0;
  final _waiting = Queue<Completer<void>>();

  @override
  bool get enabled => !_rejected && LogoDev.isPublishableKey(_key);

  @override
  Uint8List? peek(String logoDomain) {
    final d = LogoDev.normalizeDomain(logoDomain);
    if (d == null || !enabled) return null;
    final bytes = _memory.remove(d);
    if (bytes != null) _memory[d] = bytes; // most recently used last
    return bytes;
  }

  @override
  Future<Uint8List?> load(String logoDomain) {
    final d = LogoDev.normalizeDomain(logoDomain);
    if (d == null || !enabled) return Future.value();
    final hit = peek(d);
    if (hit != null && !_needsRefresh.contains(d)) return Future.value(hit);
    return _inFlight[d] ??= _load(d).whenComplete(() {
      _inFlight.remove(d); // block body: returning the removed future would make it wait on itself
    });
  }

  /// Domains whose bytes in memory came from a file older than [logoTtl].
  final _needsRefresh = <String>{};

  Future<Uint8List?> _load(String d) async {
    Uint8List? stale = _memory[d];
    try {
      if (!_pruned) {
        _pruned = true;
        await _prune();
      }
      if (stale == null) {
        final cached = await _disk.read(d);
        final now = _clock();
        if (cached != null) {
          final age = now.difference(cached.savedAt);
          if (cached.isMissing) {
            if (age < missingTtl) return null;
          } else {
            _remember(d, cached.bytes!);
            if (age < logoTtl) return cached.bytes;
            stale = cached.bytes;
            _needsRefresh.add(d);
          }
        }
      }
      return await _download(d) ?? stale;
    } catch (_) {
      return stale;
    }
  }

  /// Bytes on success; `null` when not downloaded (the caller keeps any stale copy, except 404).
  Future<Uint8List?> _download(String d) async {
    final now = _clock();
    if (_pausedUntil?.isAfter(now) ?? false) return null;
    if (_retryAt[d]?.isAfter(now) ?? false) return null;
    if (!enabled) return null;

    await _acquire();
    late final http.Response res;
    try {
      final uri = LogoDev.imageUri(d, _key);
      assert(uri.scheme == 'https');
      final req = http.Request('GET', uri)..followRedirects = false;
      final streamed = await _client.send(req).timeout(requestTimeout);
      res = await http.Response.fromStream(streamed).timeout(requestTimeout);
    } catch (_) {
      _retryAt[d] = _clock().add(retryDelay); // offline, DNS, timeout, TLS
      return null;
    } finally {
      _release();
    }

    final at = _clock();
    final type = res.headers['content-type'] ?? '';
    switch (res.statusCode) {
      case 200 when type.startsWith('image/') && res.bodyBytes.isNotEmpty && res.bodyBytes.length <= maxLogoBytes:
        final bytes = res.bodyBytes;
        _retryAt.remove(d);
        _needsRefresh.remove(d);
        _remember(d, bytes);
        await _disk.writeLogo(d, bytes, at);
        if (++_writes % _writesPerPrune == 0) await _prune();
        return bytes;
      case 404:
        _memory.remove(d);
        _needsRefresh.remove(d);
        await _disk.writeMissing(d, at);
        return null;
      case 401 || 403:
        _rejected = true; // bad/disabled key or paused account — stop for this launch
        _memory.clear();
        return null;
      case 429:
        final seconds = int.tryParse(res.headers['retry-after'] ?? '');
        final pause = seconds == null ? retryDelay : Duration(seconds: seconds);
        _pausedUntil = at.add(pause > maxRateLimitPause ? maxRateLimitPause : pause);
        return null;
      default: // 202 (first request, temporary image), 3xx, 5xx, unexpected body
        _retryAt[d] = at.add(retryDelay);
        return null;
    }
  }

  void _remember(String d, Uint8List bytes) {
    _memory.remove(d);
    _memory[d] = bytes;
    while (_memory.length > _memoryEntries) {
      _memory.remove(_memory.keys.first);
    }
  }

  Future<void> _prune() => _disk.prune(
    now: _clock(),
    missingTtl: missingTtl,
    maxAge: maxAge,
    maxBytes: maxCacheBytes,
    keepBytes: _keepBytes,
  );

  Future<void> _acquire() async {
    if (_active < maxConcurrent) {
      _active++;
      return;
    }
    final c = Completer<void>();
    _waiting.add(c);
    await c.future; // slot handed over by _release
  }

  void _release() {
    if (_waiting.isNotEmpty) {
      _waiting.removeFirst().complete();
    } else {
      _active--;
    }
  }
}
