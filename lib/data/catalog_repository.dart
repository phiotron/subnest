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

  /// Parses the bundled v3 file and the v4 schema (`D:\Mobile App\catalog\README.md`).
  /// Reference prices: v4 → no `verifiedAt` or older than `staleAfterDays` (relative to [today], default
  /// the clock); v3 → `approx: true`. Unknown regions are kept but only `US`/`VN` are ever looked up.
  static List<CatalogService> parse(String text, {LocalDate? today}) {
    final json = jsonDecode(text) as Map<String, Object?>;
    final ctx = _Ctx(
      v4: (json['schemaVersion'] as int? ?? 3) >= 4,
      staleAfterDays: json['staleAfterDays'] as int? ?? 90,
      today: today ?? LocalDate.fromDateTime(DateTime.now()),
    );
    final out = <CatalogService>[];
    for (final raw in (json['services'] as List? ?? const [])) {
      try {
        out.add(_service(raw as Map<String, Object?>, ctx));
      } catch (_) {
        // Skip malformed entries; the validator in assets/catalog/tool catches them at authoring time.
      }
    }
    return out;
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
