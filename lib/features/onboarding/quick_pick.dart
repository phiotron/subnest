import '../../domain/domain.dart';
import '../catalog/catalog_helpers.dart';

/// One service ticked on S1.3 "What do you pay for?", with the price/cycle the user may adjust
/// with the quick editor. Turned into a Subscription when onboarding finishes.
class QuickPick {
  QuickPick({
    required this.service,
    required this.plan,
    required this.priceMinor,
    required this.currency,
    required this.cycle,
  });

  /// Default plan + suggested price for [region]; without any price the amount stays 0 (the
  /// quick editor opens so the user can type one) in [fallbackCurrency].
  factory QuickPick.suggested(CatalogService service, String region, String fallbackCurrency) {
    final plan = CatalogView.defaultPlan(service, region);
    return QuickPick(
      service: service,
      plan: plan,
      priceMinor: 0,
      currency: fallbackCurrency,
      cycle: const BillingCycle.monthly(),
    )..applyPlan(plan, region);
  }

  final CatalogService service;
  CatalogPlan? plan;
  int priceMinor;
  String currency;
  BillingCycle cycle;

  bool get hasPrice => priceMinor > 0;

  /// "Netflix" / "iCloud+ 200 GB" (catalog naming rule).
  String get name => plan == null ? service.name : CatalogView.subscriptionName(service, plan!);

  /// Switches to [p] and its suggested price/cycle for [region] (keeps the old price when the
  /// plan has none).
  void applyPlan(CatalogPlan? p, String region) {
    plan = p;
    if (p == null) return;
    cycle = p.cycle;
    final price = p.priceFor(region);
    if (price != null) {
      priceMinor = price.minor;
      currency = price.currency;
    }
  }

  /// The Subscription created when onboarding finishes: Active, first Due date one cycle after
  /// [today] (same default as the Catalog → S4 path; editable later).
  Subscription toSubscription({required String id, required LocalDate today, required DateTime now}) => Subscription(
    id: id,
    name: name,
    serviceId: service.id,
    colorValue: service.colorValue,
    iconText: service.monogram,
    category: service.category,
    priceMinor: priceMinor,
    currency: currency,
    cycle: cycle,
    anchorDate: cycle.occurrence(today, 1),
    manageUrl: service.cancelUrl ?? service.manageUrl,
    startDate: today,
    createdAt: now,
    updatedAt: now,
  );
}
