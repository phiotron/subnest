import 'billing_cycle.dart';
import 'category.dart';
import 'local_date.dart';
import 'money.dart';
import 'subscription.dart';

/// Suggested price of a catalog plan in one region.
class CatalogPrice {
  const CatalogPrice(this.currency, this.amount);
  final String currency;

  /// Major units (74000 = 74.000đ, 12.99 = $12.99).
  final double amount;

  int get minor => toMinorUnits(amount, currency);
}

class CatalogPlan {
  const CatalogPlan({required this.id, required this.name, required this.cycle, required this.prices, this.members});

  final String id;
  final String name;
  final BillingCycle cycle;

  /// Region code (`VN`, `US`) → price.
  final Map<String, CatalogPrice> prices;

  /// Max members of a Family/Duo plan → pre-fills "share with N people".
  final int? members;

  /// Price for [region]; falls back to `US` (catalog README: international services sell in USD).
  CatalogPrice? priceFor(String region) => prices[region] ?? prices['US'];
}

/// A Service from the bundled Catalog (assets/catalog/services.json, schema in its README).
class CatalogService {
  const CatalogService({
    required this.id,
    required this.name,
    required this.category,
    required this.colorValue,
    required this.monogram,
    required this.plans,
    this.isVietnamese = false,
    this.aliases = const [],
    this.cancelUrl,
    this.manageUrl,
  });

  final String id;
  final String name;
  final SubscriptionCategory category;
  final int colorValue;
  final String monogram;
  final bool isVietnamese;
  final List<String> aliases;
  final String? cancelUrl;
  final String? manageUrl;
  final List<CatalogPlan> plans;

  /// Search match on name + aliases, accent-insensitive ("nghe nhac" finds "nghe nhạc").
  bool matches(String query) {
    final q = normalizeForSearch(query);
    if (q.isEmpty) return true;
    if (normalizeForSearch(name).contains(q)) return true;
    return aliases.any((a) => normalizeForSearch(a).contains(q));
  }

  /// Cheapest plan's Monthly cost in [region] (for "from X/month"), as (currency, major amount).
  (String, double)? fromPerMonth(String region) {
    (String, double)? best;
    for (final p in plans) {
      final price = p.priceFor(region);
      if (price == null) continue;
      final monthly = price.amount * p.cycle.periodsPerMonth;
      if (best == null || (best.$1 == price.currency && monthly < best.$2)) best = (price.currency, monthly);
    }
    return best;
  }
}

/// Lower-case and strip Vietnamese diacritics (đ → d) for search.
String normalizeForSearch(String input) {
  const from = 'àáạảãâầấậẩẫăằắặẳẵèéẹẻẽêềếệểễìíịỉĩòóọỏõôồốộổỗơờớợởỡùúụủũưừứựửữỳýỵỷỹđ';
  const to = 'aaaaaaaaaaaaaaaaaeeeeeeeeeeeiiiiiooooooooooooooooouuuuuuuuuuuyyyyyd';
  final lower = input.toLowerCase().trim();
  final buf = StringBuffer();
  for (final ch in lower.split('')) {
    final i = from.indexOf(ch);
    buf.write(i >= 0 ? to[i] : ch);
  }
  return buf.toString();
}

/// Builds a new Subscription from a Catalog plan with its suggested price for [region].
/// The first Due date defaults to one cycle after [today] (the user adjusts it in the form).
/// Returns `null` when the plan has no price for the region nor in USD.
Subscription? subscriptionFromCatalog(
  CatalogService service,
  CatalogPlan plan, {
  required String region,
  required String id,
  required LocalDate today,
  required DateTime now,
}) {
  final price = plan.priceFor(region);
  if (price == null) return null;
  return Subscription(
    id: id,
    name: service.plans.length > 1 ? '${service.name} ${plan.name}' : service.name,
    serviceId: service.id,
    colorValue: service.colorValue,
    iconText: service.monogram,
    category: service.category,
    priceMinor: price.minor,
    currency: price.currency,
    cycle: plan.cycle,
    anchorDate: plan.cycle.occurrence(today, 1),
    manageUrl: service.cancelUrl ?? service.manageUrl,
    startDate: today,
    createdAt: now,
    updatedAt: now,
  );
}
