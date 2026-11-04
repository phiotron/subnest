import 'dart:convert';

import 'package:flutter/services.dart';

import '../domain/domain.dart';

/// Loads the bundled service Catalog (`assets/catalog/services.json`, owned by the Catalog session).
/// Tolerant: an invalid service is skipped, a missing file gives an empty catalog
/// (the "custom service" path always works).
class CatalogRepository {
  CatalogRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  static const assetPath = 'assets/catalog/services.json';

  final AssetBundle _bundle;
  List<CatalogService>? _cache;

  Future<List<CatalogService>> load() async {
    if (_cache != null) return _cache!;
    try {
      _cache = parse(await _bundle.loadString(assetPath));
    } catch (_) {
      _cache = const [];
    }
    return _cache!;
  }

  Future<CatalogService?> byId(String id) async {
    for (final s in await load()) {
      if (s.id == id) return s;
    }
    return null;
  }

  static List<CatalogService> parse(String text) {
    final json = jsonDecode(text) as Map<String, Object?>;
    final out = <CatalogService>[];
    for (final raw in (json['services'] as List? ?? const [])) {
      try {
        out.add(_service(raw as Map<String, Object?>));
      } catch (_) {
        // Skip malformed entries; the validator in assets/catalog/tool catches them at authoring time.
      }
    }
    return out;
  }

  static CatalogService _service(Map<String, Object?> j) => CatalogService(
    id: j['id'] as String,
    name: j['name'] as String,
    category: SubscriptionCategory.fromKey(j['category'] as String?),
    colorValue: _color(j['color'] as String),
    monogram: j['monogram'] as String,
    isVietnamese: j['market'] == 'vn',
    aliases: [for (final a in (j['aliases'] as List? ?? const [])) a as String],
    cancelUrl: j['cancelUrl'] as String?,
    manageUrl: j['manageUrl'] as String?,
    plans: [for (final p in j['plans'] as List) _plan(p as Map<String, Object?>)],
  );

  static CatalogPlan _plan(Map<String, Object?> j) {
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
        for (final e in prices.entries)
          e.key: CatalogPrice(
            ((e.value as Map)['currency'] as String).toUpperCase(),
            ((e.value as Map)['amount'] as num).toDouble(),
          ),
      },
      members: j['members'] as int?,
    );
  }

  static int _color(String hex) => 0xFF000000 | int.parse(hex.replaceFirst('#', ''), radix: 16);
}
