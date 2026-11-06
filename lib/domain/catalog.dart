import 'billing_cycle.dart';
import 'category.dart';
import 'local_date.dart';
import 'money.dart';
import 'subscription.dart';

/// Suggested price of a catalog plan in one region.
class CatalogPrice {
  const CatalogPrice(this.currency, this.amount, {this.isReference = false});
  final String currency;

  /// Reference price (glossary): not verified from the provider's page — v4: no `verifiedAt` or older
  /// than `staleAfterDays`; v3: `approx: true`. Still pre-filled, shown with a "check it" chip.
  final bool isReference;

  /// Major units (74000 = 74.000đ, 12.99 = $12.99).
  final double amount;

  int get minor => toMinorUnits(amount, currency);
}

/// Plan status in the Catalog (v4). Unknown values read as [active].
enum CatalogPlanStatus {
  active,

  /// Existing customers keep it; not sold to new ones (hidden from pickers, id still resolves).
  closedToNew,

  /// Gone (glossary: Discontinued plan).
  discontinued;

  static CatalogPlanStatus parse(String? v) => switch (v) {
    'closed_to_new' => closedToNew,
    'discontinued' => discontinued,
    _ => active,
  };
}

class CatalogPlan {
  const CatalogPlan({
    required this.id,
    required this.name,
    required this.cycle,
    required this.prices,
    this.members,
    this.status = CatalogPlanStatus.active,
    this.renamedFrom,
  });

  final CatalogPlanStatus status;

  /// Old plan name when the provider renamed it (id kept).
  final String? renamedFrom;

  bool get isOnSale => status == CatalogPlanStatus.active;

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

/// Catalog section (glossary): global services for everyone, Vietnamese ones only on devices in VN.
enum CatalogSection { global, vn }

/// Catalog price region from a device locale: only `VN` and `US` have prices; VN devices use VN
/// (falling back to US per plan), everyone else US (converted "≈" to the Primary currency).
String catalogRegionForLocale(String localeName) {
  final parts = localeName.split(RegExp('[_-]'));
  return parts.length > 1 && parts[1].toUpperCase() == 'VN' ? 'VN' : 'US';
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
    this.section = CatalogSection.global,
    this.aliases = const [],
    this.storeNames = const [],
    this.logoDomain,
    this.cancelUrl,
    this.manageUrl,
  });

  final String id;
  final String name;
  final SubscriptionCategory category;
  final int colorValue;
  final String monogram;
  final CatalogSection section;
  bool get isVietnamese => section == CatalogSection.vn;
  final List<String> aliases;

  /// Names shown on Google Play / App Store subscription pages ("YouTube Premium") — used by detection.
  final List<String> storeNames;

  /// Host for the logo service (`netflix.com`); `null` = monogram tile.
  final String? logoDomain;
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
