import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../domain/domain.dart';
import '../logos/app_logo_source.dart';
import '../logos/bundled_logos.g.dart';
import '../providers.dart';
import 'catalog_data.dart';
import 'catalog_notice_store.dart';
import 'catalog_sync.dart';
import 'price_notices.dart';
import 'remote_logos.dart';

export 'catalog_data.dart';
export 'catalog_sync.dart' show CatalogRefreshResult;
export 'price_notices.dart' show PriceChangeNotice, CatalogPlanNote, CatalogPlanNoteKind;

// =============================================================================================
// Remote Catalog, Price change notices, Discontinued plans (P2, ADR 0002). API for the UI (screens
// 21, 55–57): notes/2026-11-10-p2-remote-catalog.md. The Catalog itself is still `catalogProvider`
// (providers.dart) — it now returns the newest valid of bundled and downloaded.
// =============================================================================================

/// The Catalog in use with its header: origin (bundled/remote), data `version`, `updatedOn`
/// ("Library updated 3 days ago" in About), `downloadedAt`.
final catalogDataProvider = FutureProvider<CatalogData>((ref) => ref.watch(catalogRepositoryProvider).loadData());

/// Day the Catalog data in use last changed; `null` while loading (or a file without `updatedAt`).
final catalogUpdatedOnProvider = Provider<LocalDate?>((ref) => ref.watch(catalogDataProvider).value?.updatedOn);

/// HTTP client of the Catalog download (overridden in tests).
final catalogHttpClientProvider = Provider<http.Client>((ref) {
  final c = http.Client();
  ref.onDispose(c.close);
  return c;
});

/// Logo source the remote logos plug into; `null` in tests that do not want the app-wide one.
final catalogLogoSourceProvider = Provider<AppLogoSource?>((ref) => AppLogoSource.instance);

/// Price ledger + "keep old price" decisions (file next to the Catalog cache; memory-only without one).
final catalogNoticeStoreProvider = Provider<CatalogNoticeStore>(
  (ref) => CatalogNoticeStore(ref.watch(catalogRepositoryProvider).cache),
);

/// Logos downloaded with the remote Catalog for services without a bundled logo.
final remoteLogoStoreProvider = Provider<RemoteLogoStore>((ref) {
  final s = RemoteLogoStore(ref.watch(catalogRepositoryProvider).cache);
  ref.onDispose(s.dispose);
  return s;
});

/// The downloader; `null` when the repository has no cache (tests/screenshots: bundled only).
final catalogSyncProvider = Provider<CatalogSync?>((ref) {
  final repo = ref.watch(catalogRepositoryProvider);
  final cache = repo.cache;
  if (cache == null) return null;
  final notices = ref.watch(catalogNoticeStoreProvider);
  return CatalogSync(
    cache: cache,
    current: repo.loadData,
    bundledLogoIds: ref.watch(catalogLogoSourceProvider)?.bundled ?? bundledLogoIds,
    client: ref.watch(catalogHttpClientProvider),
    clock: ref.watch(clockProvider),
    beforeReplace: (old) => notices.recordSeen(old.services),
  );
});

/// Start-up / resume entry point: `ref.read(catalogUpdaterProvider).refreshIfDue()` (see the note).
final catalogUpdaterProvider = Provider<CatalogUpdater>(CatalogUpdater.new);

class CatalogUpdater {
  CatalogUpdater(this._ref);
  final Ref _ref;
  bool _attached = false;

  /// Plugs the cached remote logos into the logo source, checks the server at most once a day, and on a
  /// new Catalog reloads `catalogProvider` / [catalogDataProvider] (notices follow). Never throws, never
  /// shows anything: errors keep the Catalog in use.
  Future<CatalogRefreshResult> refreshIfDue({bool force = false}) async {
    final logos = _ref.read(remoteLogoStoreProvider);
    if (!_attached) {
      _attached = true;
      final source = _ref.read(catalogLogoSourceProvider);
      if (source != null) logos.attachTo(source);
      await logos.load();
    }
    await _pruneDecisions();
    final sync = _ref.read(catalogSyncProvider);
    if (sync == null) return CatalogRefreshResult.notDue;
    final r = await sync.refreshIfDue(force: force);
    if (r == CatalogRefreshResult.updated) {
      _ref.read(catalogRepositoryProvider).reset();
      _ref.invalidate(catalogDataProvider);
      _ref.invalidate(catalogProvider);
    }
    if (r == CatalogRefreshResult.updated || r == CatalogRefreshResult.upToDate) await logos.load();
    return r;
  }

  Future<void> _pruneDecisions() async {
    try {
      final ids = {for (final s in await _ref.read(subscriptionRepositoryProvider).all()) s.id};
      await _ref.read(catalogNoticeStoreProvider).keepOnly(ids);
    } catch (_) {}
  }
}

// ---- Price change notice (screens 55–57) -----------------------------------------------------

/// Ledger of Catalog prices seen + decisions; records the prices of the Catalog in use on load.
final catalogNoticeMemoryProvider = FutureProvider<CatalogNoticeMemory>((ref) async {
  final store = ref.watch(catalogNoticeStoreProvider);
  final data = await ref.watch(catalogDataProvider.future);
  await store.recordSeen(data.services);
  return store.load();
});

/// Every open Price change notice (empty while loading).
final priceChangeNoticesProvider = Provider<List<PriceChangeNotice>>((ref) {
  final subs = ref.watch(subscriptionsProvider).value;
  final data = ref.watch(catalogDataProvider).value;
  final memory = ref.watch(catalogNoticeMemoryProvider).value;
  if (subs == null || data == null || memory == null) return const [];
  return findPriceChangeNotices(
    subscriptions: subs,
    services: data.services,
    ledger: memory.ledger,
    kept: memory.kept,
  );
});

/// Open notice of one Subscription (detail screen banner), `null` = none.
final subscriptionPriceNoticeProvider = Provider.family<PriceChangeNotice?, String>(
  (ref, id) => ref.watch(priceChangeNoticesProvider).firstWhereOrNull((n) => n.subscription.id == id),
);

final priceNoticeActionsProvider = Provider<PriceNoticeActions>(PriceNoticeActions.new);

class PriceNoticeActions {
  PriceNoticeActions(this._ref);
  final Ref _ref;

  /// *Update*: the new Catalog price from the next Billing period (Payments already made keep their
  /// amount), recorded in Price history as "Library update". Returns `false` when the Subscription
  /// changed meanwhile (price edited, deleted) — nothing is written then.
  Future<bool> update(PriceChangeNotice notice) async {
    final repo = _ref.read(subscriptionRepositoryProvider);
    final s = await repo.get(notice.subscription.id);
    if (s == null || s.priceMinor != notice.oldPriceMinor || s.currency != notice.currency) return false;
    await repo.changePrice(s.id, notice.newPriceMinor, currency: notice.currency, source: PriceChangeSource.catalog);
    return true;
  }

  /// *Update all* (list screen).
  Future<int> updateAll(Iterable<PriceChangeNotice> notices) async {
    var n = 0;
    for (final x in notices) {
      if (await update(x)) n++;
    }
    return n;
  }

  /// *Keep old price*: not asked again for this new price (a later, different Catalog price asks again).
  Future<void> keepOldPrice(PriceChangeNotice notice) async {
    await _ref.read(catalogNoticeStoreProvider).keep(notice);
    _ref.invalidate(catalogNoticeMemoryProvider);
  }
}

// ---- Discontinued plan ------------------------------------------------------------------------

/// Notes on the plan of each Subscription with a Catalog link: closed to new customers, discontinued
/// or renamed (empty while loading).
final catalogPlanNotesProvider = Provider<Map<String, CatalogPlanNote>>((ref) {
  final subs = ref.watch(subscriptionsProvider).value;
  final data = ref.watch(catalogDataProvider).value;
  final memory = ref.watch(catalogNoticeMemoryProvider).value;
  if (subs == null || data == null || memory == null) return const {};
  return findPlanNotes(subscriptions: subs, services: data.services, ledger: memory.ledger);
});

/// Plan note of one Subscription (detail screen), `null` = none.
final subscriptionPlanNoteProvider = Provider.family<CatalogPlanNote?, String>(
  (ref, id) => ref.watch(catalogPlanNotesProvider)[id],
);
