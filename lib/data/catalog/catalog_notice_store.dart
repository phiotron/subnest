import '../../domain/domain.dart';
import 'catalog_cache.dart';
import 'price_notices.dart';

/// Snapshot of what the Price change notice logic remembers.
class CatalogNoticeMemory {
  const CatalogNoticeMemory({required this.ledger, required this.kept});
  final PriceLedger ledger;

  /// [PriceChangeNotice.decisionKey]s the user answered with *Keep old price*.
  final Set<String> kept;
}

/// Persists [CatalogNoticeMemory] in `<catalog cache>/notices.json`; memory-only without a cache
/// (tests, screenshots). Not part of the Backup file (a restore only means a notice may be asked again).
class CatalogNoticeStore {
  CatalogNoticeStore(this._cache);

  static const fileName = 'notices.json';

  final CatalogCache? _cache;
  PriceLedger? _ledger;
  Set<String>? _kept;
  Future<void>? _loading;

  Future<CatalogNoticeMemory> load() async {
    await (_loading ??= _load());
    return CatalogNoticeMemory(ledger: _ledger!, kept: {..._kept!});
  }

  Future<void> _load() async {
    final j = await _cache?.readJson(fileName);
    _ledger = PriceLedger.fromJson(j?['ledger']);
    _kept = {...((j?['kept'] as List?) ?? const []).whereType<String>()};
  }

  /// Remembers the prices of [services] (each Catalog the app uses). Returns whether anything was new.
  Future<bool> recordSeen(Iterable<CatalogService> services) async {
    await load();
    final changed = _ledger!.record(services);
    if (changed) await _save();
    return changed;
  }

  /// *Keep old price*: never ask again for this new price.
  Future<void> keep(PriceChangeNotice notice) async {
    await load();
    if (_kept!.add(notice.decisionKey)) await _save();
  }

  /// Forgets decisions of Subscriptions that no longer exist.
  Future<void> keepOnly(Set<String> subscriptionIds) async {
    await load();
    final before = _kept!.length;
    _kept!.removeWhere((k) => !subscriptionIds.contains(k.split('|').first));
    if (_kept!.length != before) await _save();
  }

  /// Delete all data: forget the user's decisions (the price ledger is Catalog data and stays).
  Future<void> clearDecisions() async {
    await load();
    _kept!.clear();
    await _save();
  }

  Future<void> _save() async {
    try {
      await _cache?.writeJson(fileName, {'ledger': _ledger!.toJson(), 'kept': _kept!.toList()..sort()});
    } catch (_) {
      // Disk full / no folder: kept in memory for this run, asked again after a restart at worst.
    }
  }
}
