import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/domain.dart';
import 'catalog/catalog_cache.dart';
import 'catalog/catalog_data.dart';
import 'catalog/catalog_validator.dart';

export 'catalog/catalog_data.dart' show CatalogData, CatalogOrigin;

/// Loads the service Catalog: the bundled file (`assets/catalog/services.json`, owned by the Catalog
/// session) or, when newer and valid, the copy downloaded from the remote Catalog ([cache], ADR 0002).
/// Tolerant for the bundled file: an invalid service is skipped, a missing file gives an empty catalog
/// (the "custom service" path always works). The cached copy must pass [CatalogValidator] or it is ignored.
class CatalogRepository {
  CatalogRepository({AssetBundle? bundle, this.cache}) : _bundle = bundle ?? rootBundle;

  /// The app's repository: bundled file + the device cache of the remote Catalog.
  factory CatalogRepository.device() => CatalogRepository(cache: CatalogCache.instance);

  static const assetPath = 'assets/catalog/services.json';

  final AssetBundle _bundle;

  /// Remote Catalog cache; `null` = bundled file only (tests, screenshots).
  final CatalogCache? cache;

  Future<CatalogData>? _data;
  Future<CatalogData>? _bundled;

  /// Services of [loadData].
  Future<List<CatalogService>> load() async => (await loadData()).services;

  /// The Catalog in use: the newest valid of bundled and cached (glossary: Catalog source).
  Future<CatalogData> loadData() => _data ??= _loadBest();

  /// The bundled file alone.
  Future<CatalogData> loadBundled() => _bundled ??= _loadBundled();

  /// Forget what was loaded (after a remote update) so the next [loadData] reads again.
  void reset() => _data = null;

  Future<CatalogService?> byId(String id) async => (await loadData()).byId(id);

  Future<CatalogData> _loadBundled() async {
    try {
      return parseData(await _bundle.loadString(assetPath), origin: CatalogOrigin.bundled);
    } catch (_) {
      return CatalogData.empty;
    }
  }

  Future<CatalogData> _loadBest() async {
    final bundled = await loadBundled();
    final cached = await _loadCached();
    return cached != null && cached.version > bundled.version ? cached : bundled;
  }

  Future<CatalogData?> _loadCached() async {
    final c = cache;
    if (c == null) return null;
    try {
      final text = await c.readCatalog();
      if (text == null) return null;
      final state = await c.readState();
      return CatalogValidator.validate(text).withDownloadedAt(state.downloadedAt);
    } catch (_) {
      return null; // Broken cache: the bundled file is used; the next refresh writes a good copy.
    }
  }

  /// Services of [parseData] (tolerant).
  static List<CatalogService> parse(String text, {LocalDate? today}) => parseData(text, today: today).services;

  /// Parses the bundled v3 file and the v4 schema (`D:\Mobile App\catalog\README.md`).
  /// Reference prices: v4 → no `verifiedAt` or older than `staleAfterDays` (relative to [today], default
  /// the clock); v3 → `approx: true`. Unknown regions are kept but only `US`/`VN` are ever looked up.
  ///
  /// Tolerant by default (a malformed service is skipped); [strict] throws [CatalogFormatException]
  /// on the first malformed one instead (remote files, see [CatalogValidator]).
  static CatalogData parseData(
    String text, {
    LocalDate? today,
    CatalogOrigin origin = CatalogOrigin.bundled,
    bool strict = false,
  }) {
    final decoded = jsonDecode(text);
    if (decoded is! Map<String, Object?>) throw const CatalogFormatException('root is not an object');
    final json = decoded;
    final schema = json['schemaVersion'] as int? ?? 3;
    final ctx = _Ctx(
      v4: schema >= 4,
      staleAfterDays: json['staleAfterDays'] as int? ?? 90,
      today: today ?? LocalDate.fromDateTime(DateTime.now()),
    );
    final out = <CatalogService>[];
    for (final (i, raw) in (json['services'] as List? ?? const []).indexed) {
      try {
        out.add(_service(raw as Map<String, Object?>, ctx));
      } catch (e) {
        // Bundled: skip malformed entries; the validator in assets/catalog/tool catches them at authoring time.
        if (strict) throw CatalogFormatException('service #$i: $e');
      }
    }
    return CatalogData(
      services: out,
      origin: origin,
      schemaVersion: schema,
      version: json['version'] as int? ?? 0,
      updatedOn: LocalDate.tryParse(json['updatedAt'] as String?),
    );
  }

  static List<String> _strings(Object? v) => [for (final a in (v as List? ?? const [])) a as String];

  static CatalogService _service(Map<String, Object?> j, _Ctx ctx) => CatalogService(
    id: j['id'] as String,
    name: j['name'] as String,
    category: SubscriptionCategory.fromKey(j['category'] as String?),
    colorValue: _color(j['color'] as String),
    monogram: j['monogram'] as String,
    section: j['market'] == 'vn' ? CatalogSection.vn : CatalogSection.global,
    aliases: _strings(j['aliases']),
    storeNames: _strings(j['storeNames']),
    logoDomain: j['logoDomain'] as String?,
    cancelUrl: j['cancelUrl'] as String?,
    manageUrl: j['manageUrl'] as String?,
    plans: [for (final p in j['plans'] as List) _plan(p as Map<String, Object?>, ctx)],
  );

  static CatalogPlan _plan(Map<String, Object?> j, _Ctx ctx) {
    final cycle = j['cycle'] as Map<String, Object?>;
    final prices = j['prices'] as Map<String, Object?>;
    return CatalogPlan(
      id: j['id'] as String,
      name: j['name'] as String,
      cycle: BillingCycle(
        cycle['count'] as int,
        CycleUnit.values.firstWhere((u) => u.name == cycle['unit']),
      ),
      prices: {
        for (final e in prices.entries) e.key: _price(e.value as Map<String, Object?>, ctx),
      },
      members: j['members'] as int?,
      status: CatalogPlanStatus.parse(j['status'] as String?),
      renamedFrom: j['renamedFrom'] as String?,
    );
  }

  static CatalogPrice _price(Map<String, Object?> j, _Ctx ctx) {
    final bool reference;
    if (j['approx'] == true) {
      reference = true;
    } else if (ctx.v4) {
      final verified = LocalDate.tryParse(j['verifiedAt'] as String?);
      reference = verified == null || verified.daysUntil(ctx.today) > ctx.staleAfterDays;
    } else {
      reference = false;
    }
    return CatalogPrice(
      (j['currency'] as String).toUpperCase(),
      (j['amount'] as num).toDouble(),
      isReference: reference,
    );
  }

  static int _color(String hex) => 0xFF000000 | int.parse(hex.replaceFirst('#', ''), radix: 16);
}

class _Ctx {
  const _Ctx({required this.v4, required this.staleAfterDays, required this.today});
  final bool v4;
  final int staleAfterDays;
  final LocalDate today;
}
