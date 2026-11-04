import 'package:subnest/domain/domain.dart';

final DateTime fixedNow = DateTime(2026, 11, 4, 10);

/// Sequential ids: p1, p2, …
String Function() idGen() {
  var i = 0;
  return () => 'p${++i}';
}

Subscription sub({
  String id = 's1',
  String name = 'Netflix',
  int priceMinor = 260000,
  String currency = 'VND',
  BillingCycle cycle = const BillingCycle.monthly(),
  LocalDate? anchor,
  int periodIndex = 0,
  SubscriptionStatus status = SubscriptionStatus.active,
  LocalDate? trialEnd,
  int sharedWith = 1,
  int? reminderDays,
  SubscriptionCategory category = SubscriptionCategory.video,
}) => Subscription(
  id: id,
  name: name,
  priceMinor: priceMinor,
  currency: currency,
  cycle: cycle,
  anchorDate: anchor ?? const LocalDate(2026, 11, 4),
  periodIndex: periodIndex,
  status: status,
  trialEndDate: trialEnd,
  sharedWith: sharedWith,
  reminderDays: reminderDays,
  category: category,
  startDate: const LocalDate(2026, 1, 1),
  createdAt: fixedNow,
  updatedAt: fixedNow,
);
