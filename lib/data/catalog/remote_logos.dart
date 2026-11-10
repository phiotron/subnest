import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../logos/app_logo_source.dart';
import 'catalog_cache.dart';

/// Logos that came with the remote Catalog for services the app has no bundled logo for
/// (glossary: Service logo). Files live in [CatalogCache.logosDir]; the list of which exist is held
/// in memory after [load] so tiles can ask synchronously.
///
/// Plugs into the app's logo source as [AppLogoSource.remote] ([attachTo]); bundled logos always win
/// there, so a cached file for a service that later got bundled is never shown.
class RemoteLogoStore extends ChangeNotifier {
  RemoteLogoStore(this._cache);

  final CatalogCache? _cache;
  Map<String, File> _files = const {};
  AppLogoSource? _source;

  /// Service ids with a cached logo.
  Set<String> get ids => _files.keys.toSet();

  /// Path of the cached logo of [serviceId], `null` when there is none.
  String? pathOf(String serviceId) => _files[serviceId]?.path;

  /// The image for a service tile, `null` = none (→ bundled/monogram decided by the logo source).
  ImageProvider? logoFor(String serviceId) {
    final f = _files[serviceId];
    return f == null ? null : FileImage(f);
  }

  /// Reads which logos are cached (after start-up and after each Catalog refresh).
  Future<void> load() async {
    final cache = _cache;
    if (cache == null) return;
    try {
      final state = await cache.readState();
      final out = <String, File>{};
      for (final e in state.logos.entries) {
        final f = await cache.logoFile(e.value.file);
        if (f.existsSync()) out[e.key] = f;
      }
      _files = out;
    } catch (_) {
      _files = const {};
    }
    notifyListeners();
    _source?.remote = logoFor; // re-set so tiles redraw
  }

  /// Serves [logoFor] through [source] (the app passes `AppLogoSource.instance`).
  void attachTo(AppLogoSource source) {
    _source = source;
    source.remote = logoFor;
  }
}
