import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/subscription_repository.dart' show DetectionReport;
import '../../domain/domain.dart';

/// Which list the Overview shows (segmented control, mockup v14 png 014/026/027).
enum HomeTab { active, trials, paused, cancelled }

/// Sort order of the Overview list (sort sheet). Remembered as its [name] (`settings.homeSort`).
enum HomeSort {
  dueDate,
  price,
  name,

  /// Newest `createdAt` first (png 023 "Recently added").
  recent;

  static HomeSort parse(String? value) => values.where((e) => e.name == value).firstOrNull ?? HomeSort.dueDate;
}

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
  // A pause scheduled from a later Due date stays under Active ("Pauses 21 Nov") until then.
  SubscriptionStatus.paused => (s.pausedFrom?.isAfter(today) ?? false) ? HomeTab.active : HomeTab.paused,
  SubscriptionStatus.trial => HomeTab.trials,
  SubscriptionStatus.cancelled => HomeTab.cancelled,
};

/// Status chips of the filter sheet (png 16). Paused is its own status here (listed under Active).
enum HomeStatus { active, trial, paused, cancelled }

HomeStatus statusOf(Subscription s, LocalDate today) => switch (BillingRules.effectiveStatus(s, today)) {
  SubscriptionStatus.active => HomeStatus.active,
  SubscriptionStatus.trial => HomeStatus.trial,
  SubscriptionStatus.paused => HomeStatus.paused,
  SubscriptionStatus.cancelled => HomeStatus.cancelled,
};

/// The tab a status is listed under.
HomeTab tabOfStatus(HomeStatus s) => switch (s) {
  HomeStatus.active => HomeTab.active,
  HomeStatus.paused => HomeTab.paused,
  HomeStatus.trial => HomeTab.trials,
  HomeStatus.cancelled => HomeTab.cancelled,
};

/// Overview list filter (product.md §10.2, png 16–17): every group is multi-select; a group with
/// nothing picked doesn't filter; groups combine with AND, values inside a group with OR.
/// Remembered as JSON in `settings.homeFilter`.
class HomeFilter {
  const HomeFilter({
    this.statuses = const {},
    this.categoryIds = const {},
    this.labelIds = const {},
    this.paymentMethodIds = const {},
  });

  static const none = HomeFilter();

  final Set<HomeStatus> statuses;
  final Set<String> categoryIds;
  final Set<String> labelIds;
  final Set<String> paymentMethodIds;

  /// Number of picked values (the badge on the Filter button).
  int get count => statuses.length + categoryIds.length + labelIds.length + paymentMethodIds.length;
  bool get isEmpty => count == 0;

  bool matches(Subscription s, LocalDate today) =>
      (statuses.isEmpty || statuses.contains(statusOf(s, today))) &&
      (categoryIds.isEmpty || categoryIds.contains(s.categoryId)) &&
      (labelIds.isEmpty || s.labelIds.any(labelIds.contains)) &&
      (paymentMethodIds.isEmpty || (s.paymentMethodId != null && paymentMethodIds.contains(s.paymentMethodId)));

  HomeFilter copyWith({
    Set<HomeStatus>? statuses,
    Set<String>? categoryIds,
    Set<String>? labelIds,
    Set<String>? paymentMethodIds,
  }) => HomeFilter(
    statuses: statuses ?? this.statuses,
    categoryIds: categoryIds ?? this.categoryIds,
    labelIds: labelIds ?? this.labelIds,
    paymentMethodIds: paymentMethodIds ?? this.paymentMethodIds,
  );

  /// Drops ids that no longer exist (deleted category / label / payment method). `null` = keep as is
  /// (that list hasn't loaded yet).
  HomeFilter prune({Set<String>? categoryIds, Set<String>? labelIds, Set<String>? paymentMethodIds}) => HomeFilter(
    statuses: statuses,
    categoryIds: categoryIds == null ? this.categoryIds : this.categoryIds.intersection(categoryIds),
    labelIds: labelIds == null ? this.labelIds : this.labelIds.intersection(labelIds),
    paymentMethodIds: paymentMethodIds == null
        ? this.paymentMethodIds
        : this.paymentMethodIds.intersection(paymentMethodIds),
  );

  /// `null` when empty (the setting is then removed).
  String? encode() {
    if (isEmpty) return null;
    List<String> sorted(Set<String> v) => v.toList()..sort();
    return jsonEncode({
      if (statuses.isNotEmpty)
        's': [
          for (final x in HomeStatus.values)
            if (statuses.contains(x)) x.name,
        ],
      if (categoryIds.isNotEmpty) 'c': sorted(categoryIds),
      if (labelIds.isNotEmpty) 'l': sorted(labelIds),
      if (paymentMethodIds.isNotEmpty) 'p': sorted(paymentMethodIds),
    });
  }

  /// Unknown / broken values → [none] (never throws).
  static HomeFilter decode(String? text) {
    if (text == null || text.isEmpty) return none;
    try {
      final m = jsonDecode(text);
      if (m is! Map) return none;
      Set<String> ids(String k) => {
        for (final v in (m[k] is List ? m[k] as List : const <Object?>[]))
          if (v is String) v,
      };
      return HomeFilter(
        statuses: {for (final n in ids('s')) ...HomeStatus.values.where((e) => e.name == n)},
        categoryIds: ids('c'),
        labelIds: ids('l'),
        paymentMethodIds: ids('p'),
      );
    } catch (_) {
      return none;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is HomeFilter &&
      _same(other.statuses, statuses) &&
      _same(other.categoryIds, categoryIds) &&
      _same(other.labelIds, labelIds) &&
      _same(other.paymentMethodIds, paymentMethodIds);

  static bool _same<T>(Set<T> a, Set<T> b) => a.length == b.length && a.containsAll(b);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(statuses),
    Object.hashAllUnordered(categoryIds),
    Object.hashAllUnordered(labelIds),
    Object.hashAllUnordered(paymentMethodIds),
  );
}

/// The last automatic add / confirm (screenshot scan now; notifications, Gmail later). Whoever runs
/// `SubscriptionRepository.applyDetections` calls [HomeAutoUndo.show] with the report; the Overview
/// then flashes the new rows and offers **Undo** for 6 s (png 18), and clears it.
final homeAutoUndoProvider = NotifierProvider<HomeAutoUndo, DetectionReport?>(HomeAutoUndo.new);

class HomeAutoUndo extends Notifier<DetectionReport?> {
  @override
  DetectionReport? build() => null;

  void show(DetectionReport report) {
    if (report.added.isEmpty && report.confirmed.isEmpty) return;
    state = report;
  }

  void clear() => state = null;
}

/// Subscriptions of [tab] matching [filter], sorted. Whatever the order, rows awaiting confirmation
/// stay on top (oldest due first). Due date: then soonest, Paused last; cancelled ones by
/// cancellation date, newest first. Price: highest Monthly cost first. Name: A → Z. Recent: newest
/// added first.
List<Subscription> listFor(
  Iterable<Subscription> all,
  HomeTab tab,
  HomeSort sort, {
  required LocalDate today,
  required SpendingCalculator calc,
  HomeFilter filter = HomeFilter.none,
}) {
  final list = all.where((s) => tabOf(s, today) == tab && filter.matches(s, today)).toList();
  int byName(Subscription a, Subscription b) => a.name.toLowerCase().compareTo(b.name.toLowerCase());
  int awaitingFirst(Subscription a, Subscription b, int Function(Subscription, Subscription) then) {
    final wa = BillingRules.isAwaitingConfirmation(a, today);
    final wb = BillingRules.isAwaitingConfirmation(b, today);
    if (wa != wb) return wa ? -1 : 1;
    if (wa) {
      final c = a.dueDate.compareTo(b.dueDate);
      if (c != 0) return c;
    }
    return then(a, b);
  }

  switch (sort) {
    case HomeSort.dueDate:
      if (tab == HomeTab.cancelled) {
        const far = LocalDate(1970, 1, 1);
        list.sort((a, b) {
          final c = (b.cancelledOn ?? far).compareTo(a.cancelledOn ?? far);
          return c != 0 ? c : byName(a, b);
        });
      } else {
        list.sort(
          (a, b) => awaitingFirst(a, b, (a, b) {
            final pa = statusOf(a, today) == HomeStatus.paused ? 1 : 0;
            final pb = statusOf(b, today) == HomeStatus.paused ? 1 : 0;
            if (pa != pb) return pa - pb;
            final c = pa == 1 ? 0 : a.dueDate.compareTo(b.dueDate);
            return c != 0 ? c : byName(a, b);
          }),
        );
      }
    case HomeSort.price:
      list.sort(
        (a, b) => awaitingFirst(a, b, (a, b) {
          final c = (calc.monthlyCost(b) ?? 0).compareTo(calc.monthlyCost(a) ?? 0);
          return c != 0 ? c : byName(a, b);
        }),
      );
    case HomeSort.name:
      list.sort((a, b) => awaitingFirst(a, b, byName));
    case HomeSort.recent:
      list.sort(
        (a, b) => awaitingFirst(a, b, (a, b) {
          final c = b.createdAt.compareTo(a.createdAt);
          return c != 0 ? c : byName(a, b);
        }),
      );
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
