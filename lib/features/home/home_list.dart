import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/domain.dart';

/// Which list the Overview shows (segmented control).
enum HomeTab { active, trials, cancelled }

/// Sort order of the Overview list (sort sheet).
enum HomeSort { dueDate, price, name }

/// Asks the Overview to show a tab the next time it builds — set by "See cancelled" on the
/// celebration screen before navigating home. The Overview clears it once applied.
final homeTabRequestProvider = NotifierProvider<HomeTabRequest, HomeTab?>(HomeTabRequest.new);

class HomeTabRequest extends Notifier<HomeTab?> {
  @override
  HomeTab? build() => null;

  void request(HomeTab tab) => state = tab;

  void clear() => state = null;
}

HomeTab tabOf(Subscription s, LocalDate today) => switch (BillingRules.effectiveStatus(s, today)) {
  SubscriptionStatus.active => HomeTab.active,
  SubscriptionStatus.trial => HomeTab.trials,
  SubscriptionStatus.cancelled => HomeTab.cancelled,
};

/// Subscriptions of [tab], sorted. Due date: awaiting first (oldest due first), then soonest;
/// cancelled ones by cancellation date, newest first. Price: highest Monthly cost first. Name: A → Z.
List<Subscription> listFor(
  Iterable<Subscription> all,
  HomeTab tab,
  HomeSort sort, {
  required LocalDate today,
  required SpendingCalculator calc,
}) {
  final list = all.where((s) => tabOf(s, today) == tab).toList();
  int byName(Subscription a, Subscription b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());
  switch (sort) {
    case HomeSort.dueDate:
      if (tab == HomeTab.cancelled) {
        const far = LocalDate(1970, 1, 1);
        list.sort((a, b) {
          final c = (b.cancelledOn ?? far).compareTo(a.cancelledOn ?? far);
          return c != 0 ? c : byName(a, b);
        });
      } else {
        list.sort((a, b) {
          final wa = BillingRules.isAwaitingConfirmation(a, today) ? 0 : 1;
          final wb = BillingRules.isAwaitingConfirmation(b, today) ? 0 : 1;
          if (wa != wb) return wa - wb;
          final c = a.dueDate.compareTo(b.dueDate);
          return c != 0 ? c : byName(a, b);
        });
      }
    case HomeSort.price:
      list.sort((a, b) {
        final c = (calc.monthlyCost(b) ?? 0).compareTo(calc.monthlyCost(a) ?? 0);
        return c != 0 ? c : byName(a, b);
      });
    case HomeSort.name:
      list.sort(byName);
  }
  return list;
}

/// Name search (accent-insensitive: "viet" finds "Viettel", "huy" finds "Huỷ"), sorted by name.
List<Subscription> search(Iterable<Subscription> all, String query) {
  final q = normalizeForSearch(query);
  if (q.isEmpty) return const [];
  return all.where((s) => normalizeForSearch(s.name).contains(q)).toList()
    ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
}

/// Active subscriptions by Monthly cost, largest first (hero strip + "Biggest").
List<(Subscription, double)> activeByCost(Iterable<Subscription> all, LocalDate today, SpendingCalculator calc) =>
    calc.top(all, today, count: 1 << 20).where((e) => e.$2 > 0).toList();

/// The trial whose first charge comes soonest within [days] (and that the user hasn't kept).
Subscription? endingTrial(Iterable<Subscription> all, LocalDate today, Set<String> kept, {int days = 7}) {
  Subscription? best;
  for (final s in all) {
    if (kept.contains(s.id)) continue;
    if (BillingRules.effectiveStatus(s, today) != SubscriptionStatus.trial) continue;
    final n = BillingRules.daysUntilDue(s, today);
    if (n < 0 || n > days) continue;
    if (best == null || s.dueDate.isBefore(best.dueDate)) best = s;
  }
  return best;
}
