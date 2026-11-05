import '../../core/l10n/l10n.dart';
import '../../core/widgets/formatters.dart';
import '../../domain/domain.dart';

/// Catalog presentation rules for S1 (quick pick) and S3 (library). Pure helpers on top of the
/// domain [CatalogService] — no business rules (prices are only suggestions the user edits).
abstract final class CatalogView {
  /// Services most people track first (product.md §8 sample data + mockup order). Missing ids are
  /// skipped; Vietnamese-market ids are skipped outside VN.
  static const popularIds = [
    'netflix',
    'spotify',
    'youtube-premium',
    'chatgpt',
    'icloud',
    'google-one',
    'canva',
    'disney-plus',
    'apple-music',
    'duolingo',
    'viettel-mobile',
    'microsoft-365',
    'notion',
    'adobe-cc',
    'prime-video',
    'zing-mp3',
    'claude',
    'gemini',
    'fpt-play',
    'xbox-game-pass',
  ];

  /// How many services the S3 "Popular" section shows.
  static const popularCount = 12;

  /// Plans offered in [region]: those with a price there; when none has one, every plan that has
  /// any usable price (the catalog falls back to `US`).
  static List<CatalogPlan> plans(CatalogService s, String region) {
    final local = [
      for (final p in s.plans)
        if (p.prices.containsKey(region)) p,
    ];
    if (local.isNotEmpty) return local;
    return [
      for (final p in s.plans)
        if (p.priceFor(region) != null) p,
    ];
  }

  /// Default plan for a one-tap add: the first plan offered in [region] (catalog README).
  static CatalogPlan? defaultPlan(CatalogService s, String region) => plans(s, region).firstOrNull;

  /// Popular services first (in [popularIds] order), then — in VN — Vietnamese services, then
  /// the rest in catalog order. Services without any price for [region] stay (custom price).
  static List<CatalogService> ordered(List<CatalogService> catalog, String region) {
    final vn = region == 'VN';
    final byId = {for (final s in catalog) s.id: s};
    final out = <CatalogService>[];
    final seen = <String>{};
    for (final id in popularIds) {
      final s = byId[id];
      if (s == null || (!vn && s.isVietnamese)) continue;
      out.add(s);
      seen.add(id);
    }
    if (vn) {
      for (final s in catalog) {
        if (s.isVietnamese && seen.add(s.id)) out.add(s);
      }
    }
    for (final s in catalog) {
      if (seen.add(s.id)) out.add(s);
    }
    return out;
  }

  /// Search on name + aliases, accent-insensitive; names starting with the query rank first.
  static List<CatalogService> search(List<CatalogService> ordered, String query) {
    final q = normalizeForSearch(query);
    if (q.isEmpty) return ordered;
    final hits = [
      for (final s in ordered)
        if (s.matches(query)) s,
    ];
    final starts = [
      for (final s in hits)
        if (normalizeForSearch(s.name).startsWith(q)) s,
    ];
    return [...starts, ...hits.where((s) => !starts.contains(s))];
  }

  /// "₫74,000/month" for a plan's suggested price, or `null` without a price.
  static String? planPrice(AppLocalizations l, CatalogPlan p, String region) {
    final price = p.priceFor(region);
    if (price == null) return null;
    return '${l.amount(price.amount, price.currency)}${perCycle(l, p.cycle)}';
  }

  /// Library row meta: "from ₫74,000/month · 4 plans", "$20/month", or the category when the
  /// service has no price at all.
  static String rowMeta(AppLocalizations l, CatalogService s, String region) {
    final offered = plans(s, region);
    final price = _cheapest(l, offered, region);
    final count = offered.length;
    if (price == null) return l.category(s.category);
    final head = count > 1 ? l.catalogFrom(price) : price;
    return count > 1 ? '$head · ${l.catalogPlans(count)}' : head;
  }

  /// Cheapest plan by Monthly cost, shown with its own price and cycle ("from ₫1,390,000/year").
  static String? _cheapest(AppLocalizations l, List<CatalogPlan> plans, String region) {
    CatalogPlan? best;
    double? bestMonthly;
    String? currency;
    for (final p in plans) {
      final price = p.priceFor(region);
      if (price == null) continue;
      currency ??= price.currency;
      if (price.currency != currency) continue;
      final monthly = price.amount * p.cycle.periodsPerMonth;
      if (bestMonthly == null || monthly < bestMonthly) {
        best = p;
        bestMonthly = monthly;
      }
    }
    return best == null ? null : planPrice(l, best, region);
  }

  /// Plan sheet subtitle: "Up to 6 people · Monthly" or just the cycle.
  static String planSubtitle(AppLocalizations l, CatalogPlan p) {
    final cycle = l.cycle(p.cycle);
    return p.members == null ? cycle : '${l.catalogPlanMembers(p.members!)} · $cycle';
  }

  /// Name stored on the Subscription for [plan] of [service] (same rule as `subscriptionFromCatalog`).
  static String subscriptionName(CatalogService service, CatalogPlan plan) =>
      service.plans.length > 1 ? '${service.name} ${plan.name}' : service.name;
}
