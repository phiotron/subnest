import '../../domain/domain.dart';

/// Where the Catalog in use came from (glossary: Catalog source).
enum CatalogOrigin {
  /// `assets/catalog/services.json`, shipped in the app (always there, used offline).
  bundled,

  /// Downloaded from the studio's GitHub Pages (`subnest/v1/services.min.json`) and cached on the device.
  remote,
}

/// One whole Catalog file: its services plus the header fields the app needs.
class CatalogData {
  const CatalogData({
    required this.services,
    required this.origin,
    this.schemaVersion = 4,
    this.version = 0,
    this.updatedOn,
    this.downloadedAt,
  });

  /// No file at all (asset missing): the "custom service" path still works.
  static const empty = CatalogData(services: [], origin: CatalogOrigin.bundled);

  final List<CatalogService> services;
  final CatalogOrigin origin;
  final int schemaVersion;

  /// Data version (`version` in the file) — grows each time the data changes; the app uses the highest
  /// valid one it has.
  final int version;

  /// Day the data last changed (`updatedAt`) — "Library updated 3 days ago" in About.
  final LocalDate? updatedOn;

  /// When this device downloaded it; `null` for the bundled file.
  final DateTime? downloadedAt;

  bool get isRemote => origin == CatalogOrigin.remote;

  CatalogService? byId(String id) {
    for (final s in services) {
      if (s.id == id) return s;
    }
    return null;
  }

  CatalogData withDownloadedAt(DateTime? at) => CatalogData(
    services: services,
    origin: origin,
    schemaVersion: schemaVersion,
    version: version,
    updatedOn: updatedOn,
    downloadedAt: at,
  );
}

/// A Catalog file that must not be used (bad JSON, wrong schema, broken entry, removed ids…).
class CatalogFormatException implements Exception {
  const CatalogFormatException(this.message);
  final String message;

  @override
  String toString() => 'CatalogFormatException: $message';
}
