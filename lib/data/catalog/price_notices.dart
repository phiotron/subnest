import 'package:collection/collection.dart';

import '../../domain/domain.dart';

/// Every Catalog price this device has ever seen, per plan and region: `service/plan/REGION/CUR` →
/// amounts (minor units). Grows each time a Catalog is loaded (bundled or remote); old prices are kept so
/// a Subscription still on an old Catalog price is recognised after any number of updates.
///
/// Subscriptions store no plan id, so this is also how a Subscription's plan is told apart from the
/// service's other plans with the same cycle (see [CatalogPlanMatcher]).
class PriceLedger {
  PriceLedger([Map<String, List<int>>? seen]) : _seen = {for (final e in (seen ?? const {}).entries) e.key: [...e.value]};

  /// Amounts kept per key (oldest dropped first).
  static const maxPerKey = 12;

  final Map<String, List<int>> _seen;

  static String key(String serviceId, String planId, String region, String currency) =>
      '$serviceId/$planId/$region/$currency';

  bool contains(String key, int minor) => _seen[key]?.contains(minor) ?? false;

  bool get isEmpty => _seen.isEmpty;

  /// Adds the prices of [services]; returns whether anything was new.
  bool record(Iterable<CatalogService> services) {
    var changed = false;
    for (final s in services) {
      for (final p in s.plans) {
        for (final e in p.prices.entries) {
          final list = _seen.putIfAbsent(key(s.id, p.id, e.key, e.value.currency), () => []);
          final minor = e.value.minor;
          if (list.contains(minor)) continue;
          list.add(minor);
          if (list.length > maxPerKey) list.removeAt(0);
          changed = true;
        }
      }
    }
    return changed;
  }

  Map<String, List<int>> toJson() => {for (final e in _seen.entries) e.key: [...e.value]};

  static PriceLedger fromJson(Object? json) {
    final out = <String, List<int>>{};
    if (json is Map) {
      for (final e in json.entries) {
        if (e.key is String && e.value is List) out[e.key as String] = [...(e.value as List).whereType<int>()];
      }
    }
    return PriceLedger(out);
  }
}

/// How a Subscription was matched to a Catalog plan.
class CatalogPlanMatch {
  const CatalogPlanMatch(this.plan, {required this.byName, this.renamed = false});
  final CatalogPlan plan;

  /// The Subscription's name is the Catalog name ("Netflix Premium"); otherwise its price + cycle.
  final bool byName;

  /// The name is the plan's old name ([CatalogPlan.renamedFrom]).
  final bool renamed;
}

/// Finds the Catalog plan behind a Subscription with a Catalog link (only `serviceId` is stored):
///
/// 1. by name, as the form saves it: `"<service> <plan>"`, or `"<service>"` when the service has one plan;
///    the plan's [CatalogPlan.renamedFrom] counts too ([CatalogPlanMatch.renamed]);
/// 2. else by price: the only plan with the Subscription's cycle whose current or past Catalog price
///    ([PriceLedger]) equals the Subscription's price in its currency.
///
/// A name match must also have the same cycle when [sameCycle] is set (price notices). `null` = unknown
/// or ambiguous — nothing is shown for that Subscription.
abstract final class CatalogPlanMatcher {
  static CatalogPlanMatch? match(
    Subscription s,
    CatalogService service,
    PriceLedger ledger, {
    bool sameCycle = true,
  }) {
    final name = normalizeForSearch(s.name).replaceAll(RegExp(r'\s+'), ' ');
    String n(String v) => normalizeForSearch(v).replaceAll(RegExp(r'\s+'), ' ');
    final serviceName = n(service.name);
    bool cycleOk(CatalogPlan p) => !sameCycle || p.cycle == s.cycle;

    for (final p in service.plans) {
      if (name == '$serviceName ${n(p.name)}' && cycleOk(p)) return CatalogPlanMatch(p, byName: true);
    }
    for (final p in service.plans) {
      final old = p.renamedFrom;
      if (old != null && name == '$serviceName ${n(old)}' && cycleOk(p)) {
        return CatalogPlanMatch(p, byName: true, renamed: true);
      }
    }
    if (service.plans.length == 1 && name == serviceName && cycleOk(service.plans.single)) {
      return CatalogPlanMatch(service.plans.single, byName: true);
    }

    final byPrice = service.plans.where((p) {
      if (p.cycle != s.cycle) return false;
      return p.prices.entries.any(
        (e) =>
            e.value.currency == s.currency &&
            (e.value.minor == s.priceMinor ||
                ledger.contains(PriceLedger.key(service.id, p.id, e.key, e.value.currency), s.priceMinor)),
      );
    }).toList();
    return byPrice.length == 1 ? CatalogPlanMatch(byPrice.single, byName: false) : null;
  }
}

/// Glossary: Price change notice — the Catalog price of a Subscription's plan changed while the
/// Subscription still has an old Catalog price. The user picks *Update* (from the next period, old
/// Payments unchanged) or *Keep old price* (not asked again for this new price).
class PriceChangeNotice {
  const PriceChangeNotice({
    required this.subscription,
    required this.service,
    required this.plan,
    required this.region,
    required this.oldPriceMinor,
    required this.newPrice,
  });

  final Subscription subscription;
  final CatalogService service;
  final CatalogPlan plan;

  /// Catalog region of the price (`US`, `VN`).
  final String region;

  /// The Subscription's price now (an earlier Catalog price), minor units of [currency].
  final int oldPriceMinor;

  /// The Catalog price now.
  final CatalogPrice newPrice;

  int get newPriceMinor => newPrice.minor;
  String get currency => newPrice.currency;
  bool get isIncrease => newPriceMinor > oldPriceMinor;

  /// The new price is a Reference price (not verified on the provider's page).
  bool get isReference => newPrice.isReference;

  /// Identity of the decision "keep old price" — same subscription, plan, region and new price.
  String get decisionKey => decisionKeyOf(subscription.id, service.id, plan.id, region, currency, newPriceMinor);

  static String decisionKeyOf(String subId, String serviceId, String planId, String region, String cur, int minor) =>
      '$subId|${PriceLedger.key(serviceId, planId, region, cur)}|$minor';

  @override
  String toString() => 'PriceChangeNotice(${subscription.id} ${service.id}/${plan.id} $oldPriceMinor → $newPriceMinor $currency)';
}

/// Price change notices for [subscriptions] against the Catalog in use. Pure.
///
/// A Subscription gets one when all hold: Catalog link (`serviceId`) to a service in [services]; not
/// cancelled; its plan is found with the same cycle ([CatalogPlanMatcher]); the plan has a price in the
/// Subscription's currency that differs from the Subscription's price; the Subscription's price is a
/// price that plan had in an earlier Catalog ([ledger]) — a price the user typed is never one; and the
/// user did not keep the old price for this new price ([kept]).
List<PriceChangeNotice> findPriceChangeNotices({
  required Iterable<Subscription> subscriptions,
  required Iterable<CatalogService> services,
  required PriceLedger ledger,
  Set<String> kept = const {},
}) {
  final byId = {for (final s in services) s.id: s};
  final out = <PriceChangeNotice>[];
  for (final s in subscriptions) {
    final service = s.serviceId == null ? null : byId[s.serviceId];
    if (service == null || s.status == SubscriptionStatus.cancelled || s.cancelledOn != null) continue;
    final match = CatalogPlanMatcher.match(s, service, ledger);
    if (match == null) continue;
    final entry = match.plan.prices.entries.firstWhereOrNull((e) => e.value.currency == s.currency);
    if (entry == null) continue;
    final price = entry.value;
    if (price.minor == s.priceMinor) continue;
    if (!ledger.contains(PriceLedger.key(service.id, match.plan.id, entry.key, price.currency), s.priceMinor)) continue;
    final notice = PriceChangeNotice(
      subscription: s,
      service: service,
      plan: match.plan,
      region: entry.key,
      oldPriceMinor: s.priceMinor,
      newPrice: price,
    );
    if (kept.contains(notice.decisionKey)) continue;
    out.add(notice);
  }
  return out;
}

/// What the Catalog says about the plan a Subscription is on (glossary: Discontinued plan).
enum CatalogPlanNoteKind {
  /// Existing customers keep it; no longer sold to new ones.
  closedToNew,

  /// The provider dropped the plan.
  discontinued,

  /// The provider renamed the plan (same plan id); [CatalogPlanNote.previousName] is the old name.
  renamed,
}

class CatalogPlanNote {
  const CatalogPlanNote({required this.kind, required this.service, required this.plan, this.previousName});
  final CatalogPlanNoteKind kind;
  final CatalogService service;
  final CatalogPlan plan;

  /// Old plan name for [CatalogPlanNoteKind.renamed].
  final String? previousName;

  @override
  String toString() => 'CatalogPlanNote(${service.id}/${plan.id} ${kind.name})';
}

/// Discontinued-plan notes by Subscription id. Pure. The Subscription itself never changes; the detail
/// screen shows a light note ("this plan is no longer sold to new customers"). Matching ignores the
/// cycle (the user may have changed it). Status beats rename: a renamed plan that is also discontinued
/// reads as discontinued.
Map<String, CatalogPlanNote> findPlanNotes({
  required Iterable<Subscription> subscriptions,
  required Iterable<CatalogService> services,
  required PriceLedger ledger,
}) {
  final byId = {for (final s in services) s.id: s};
  final out = <String, CatalogPlanNote>{};
  for (final s in subscriptions) {
    final service = s.serviceId == null ? null : byId[s.serviceId];
    if (service == null) continue;
    final match = CatalogPlanMatcher.match(s, service, ledger, sameCycle: false);
    if (match == null) continue;
    final plan = match.plan;
    final kind = switch (plan.status) {
      CatalogPlanStatus.discontinued => CatalogPlanNoteKind.discontinued,
      CatalogPlanStatus.closedToNew => CatalogPlanNoteKind.closedToNew,
      CatalogPlanStatus.active => match.renamed ? CatalogPlanNoteKind.renamed : null,
    };
    if (kind == null) continue;
    out[s.id] = CatalogPlanNote(
      kind: kind,
      service: service,
      plan: plan,
      previousName: match.renamed ? plan.renamedFrom : null,
    );
  }
  return out;
}
