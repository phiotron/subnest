import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../core/l10n/l10n.dart';
import '../../core/widgets/widgets.dart';
import '../../data/providers.dart';
import '../../domain/domain.dart';

/// Presentation helpers shared by S2 Overview, S5 Detail, S6 Confirm and S7 To confirm.
/// No business rules here — status/pending/dates come from [BillingRules]; this only turns them
/// into the strings and amounts the mockups show.

/// Catalog services by id (empty while the catalog loads), for short names and cancel links.
final catalogByIdProvider = Provider<Map<String, CatalogService>>((ref) {
  final list = ref.watch(catalogProvider).value ?? const <CatalogService>[];
  return {for (final s in list) s.id: s};
});

/// Trials the user chose to keep ("Keep it") — hides the trial-ending card. Stored in Settings so it
/// survives restarts (real phone QA: the card came back after reopening the app); ids of trials that
/// became Active, were cancelled or deleted are dropped from the store.
final keptTrialsProvider = NotifierProvider<KeptTrials, Set<String>>(KeptTrials.new);

class KeptTrials extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final stored = ref.watch(settingsProvider).value?.keptTrials ?? const <String>{};
    final subs = ref.watch(subscriptionsProvider).value;
    if (subs == null || stored.isEmpty) return stored;
    final today = ref.watch(todayProvider);
    final live = {
      for (final s in subs)
        if (stored.contains(s.id) && BillingRules.effectiveStatus(s, today) == SubscriptionStatus.trial) s.id,
    };
    if (live.length != stored.length) {
      final repo = ref.read(settingsRepositoryProvider);
      Future.microtask(() => repo.setKeptTrials(live));
    }
    return live;
  }

  Future<void> keep(String id) async {
    final next = {...state, id};
    state = next;
    await ref.read(settingsRepositoryProvider).setKeptTrials(next);
  }
}

/// Short service name for sentences ("Did you pay Netflix?"): the Catalog service name when the
/// subscription comes from the Catalog, otherwise the subscription name.
String shortName(Subscription s, Map<String, CatalogService> catalog) {
  final service = s.serviceId == null ? null : catalog[s.serviceId];
  if (service == null) return s.name;
  return s.name.toLowerCase().startsWith(service.name.toLowerCase()) ? service.name : s.name;
}

/// "How to cancel" link: the Catalog's cancel page, else the subscription's own manage link.
Uri? cancelLink(Subscription s, Map<String, CatalogService> catalog) {
  final service = s.serviceId == null ? null : catalog[s.serviceId];
  final raw = service?.cancelUrl ?? s.manageUrl ?? service?.manageUrl;
  if (raw == null || raw.trim().isEmpty) return null;
  final uri = Uri.tryParse(raw.trim());
  if (uri == null || !uri.hasScheme) return Uri.tryParse('https://${raw.trim()}');
  return uri;
}

/// "netflix.com" from a link.
String linkHost(Uri uri) => uri.host.startsWith('www.') ? uri.host.substring(4) : uri.host;

/// Amount column of a subscription row (design `row()`): foreign currency → full price +
/// "≈ converted"; shared → My share + "plan …"; otherwise price + "/month".
(String, String?) rowAmounts(
  AppLocalizations l,
  Subscription s, {
  required String primary,
  required SpendingCalculator calc,
}) {
  if (s.currency != primary) {
    final converted = calc.periodCost(s);
    return (l.money(s.myShare), converted == null ? perCycle(l, s.cycle) : l.amount(converted, primary, approx: true));
  }
  if (s.isShared) return (l.money(s.myShare), l.corePlanPrice(l.money(s.price)));
  return (l.money(s.price), perCycle(l, s.cycle));
}

/// Price with its cycle suffix: "₫59,000/month".
String pricePerCycle(AppLocalizations l, Subscription s) => '${l.money(s.myShare)}${perCycle(l, s.cycle)}';

/// A pause scheduled from a later Due date (png 20): the row still looks Active and says
/// "Pauses 15 Nov" until then. `null` when not pausing.
LocalDate? pausesOn(Subscription s, LocalDate today) {
  final from = s.pausedFrom;
  if (s.status != SubscriptionStatus.paused || from == null || !from.isAfter(today)) return null;
  return from;
}

/// Row state for [SubscriptionRow].
SubscriptionRowState rowState(Subscription s, LocalDate today) {
  if (BillingRules.isAwaitingConfirmation(s, today)) return SubscriptionRowState.awaiting;
  return switch (BillingRules.effectiveStatus(s, today)) {
    SubscriptionStatus.trial => SubscriptionRowState.trial,
    SubscriptionStatus.cancelled => SubscriptionRowState.cancelled,
    SubscriptionStatus.paused => pausesOn(s, today) != null ? SubscriptionRowState.normal : SubscriptionRowState.paused,
    SubscriptionStatus.active => SubscriptionRowState.normal,
  };
}

/// Category name of [s] (user's Category by `categoryId`; built-in name while categories load).
String categoryLabel(AppLocalizations l, Subscription s, Map<String, Category> categories) {
  final c = categories[s.categoryId];
  return c != null ? l.categoryName(c) : l.commonCategory(SubscriptionCategory.fromKey(s.categoryId).key);
}

/// Second line of a row: "in 3 days · AI" / "2 Feb 2027 · Software" / "ends in 2 days" /
/// "Cancelled 12 Oct 2026" / "since 1 Nov" (Paused). Awaiting rows show only the badge; a pausing
/// row only its "Pauses 15 Nov" badge (added by the Overview).
String? rowMeta(AppLocalizations l, Subscription s, LocalDate today, {Map<String, Category> categories = const {}}) {
  switch (rowState(s, today)) {
    case SubscriptionRowState.awaiting:
      return null;
    case SubscriptionRowState.trial:
      return l.homeTrialEndsWhen(AppDates.relative(l, s.dueDate, today: today));
    case SubscriptionRowState.cancelled:
      final on = s.cancelledOn;
      return on == null ? l.homeTabCancelled : l.homeCancelledOn(AppDates.full(l, on));
    case SubscriptionRowState.paused:
      final from = s.pausedFrom;
      return from == null ? null : l.homePausedSince(AppDates.short(l, from, today: today));
    case SubscriptionRowState.normal:
      if (pausesOn(s, today) != null) return null;
      final days = today.daysUntil(s.dueDate);
      final when = days <= 30
          ? AppDates.relative(l, s.dueDate, today: today)
          : AppDates.short(l, s.dueDate, today: today);
      return '$when · ${categoryLabel(l, s, categories)}';
  }
}

/// "Fri, 4 Dec 2026" / "T6, 04/12/2026" (design `fd(…, 'wdmy')`).
String weekdayFull(AppLocalizations l, LocalDate d) {
  final lang = l.localeName.split(RegExp('[_-]')).first;
  final dt = DateTime(d.year, d.month, d.day);
  final wd = lang == 'vi'
      ? (dt.weekday == DateTime.sunday ? 'CN' : 'T${dt.weekday + 1}')
      : DateFormat('EEE', 'en').format(dt);
  return '$wd, ${AppDates.full(l, d)}';
}

/// Whether any of [subs] is priced in another currency than [primary] (totals then show "≈").
bool anyConverted(Iterable<Subscription> subs, String primary) => subs.any((s) => s.currency != primary);
