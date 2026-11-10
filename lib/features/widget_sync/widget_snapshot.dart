import 'dart:ui' show Color;

import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/formatters.dart';
import '../../core/widgets/service_tile.dart';
import '../../domain/domain.dart';

/// What the home-screen widgets show (product.md §10.7, mockups v13 89/91/92), as ready-to-draw
/// strings: the native side (Android `SubnestWidgetProvider.kt`, iOS `SubnestWidget.swift`) never
/// formats money, never reads the database and never sees anything the snapshot leaves out.
///
/// Stored as ONE JSON string under [WidgetSnapshot.storageKey], so switching to the locked state
/// overwrites everything that was there (App lock: nothing but "Locked with PIN" may remain).
///
/// Format (`v` 1):
/// * every state: `v`, `state` (`list` | `empty` | `locked`), `lang`, `open` (a11y "Open Subnest");
/// * `locked`: `locked` text — and nothing else;
/// * `empty`: `emptyTitle`, `emptyBody`, `title`, `upcoming`;
/// * `list`: `title`, `upcoming`, `next`, `total`, `totalPerMonth`, `totalA11y`, `badge` (or absent),
///   `awaiting`, `tomorrow`, `inDays` (template with `{n}`), `firstCharge`, and `items` (≤ [maxItems],
///   soonest first): `id`, `name`, `mono`, `color`/`onColor` (ARGB ints), `price`, `date` (e.g.
///   "Fri, 6 Nov"), `due` (ISO date — the widget works out "In 3 days" / "To confirm" itself, so it
///   stays right after midnight while the app is closed), `trial` (bool).
abstract final class WidgetSnapshot {
  static const version = 1;

  /// Key in the `home_widget` store (Android SharedPreferences / iOS App Group UserDefaults).
  static const storageKey = 'subnest.widget';

  /// Rows the large widget can show; small uses 1, medium 3.
  static const maxItems = 5;

  /// Snapshot while App lock is on (or its state is not known yet): no names, no amounts, no dates.
  static Map<String, Object?> locked(AppLocalizations l) => {
    'v': version,
    'state': 'locked',
    'lang': _lang(l),
    'locked': l.widgetLocked,
    'open': l.widgetOpenApp,
  };

  /// Snapshot of the user's data. [summary] is the Overview's `spendingSummaryProvider` value, so
  /// the monthly total is the very number the Overview shows.
  static Map<String, Object?> build({
    required AppLocalizations l,
    required List<Subscription> subscriptions,
    required SpendingSummary summary,
    required String primaryCurrency,
    required LocalDate today,
  }) {
    final upcoming = upcomingOf(subscriptions, today);
    final base = <String, Object?>{
      'v': version,
      'lang': _lang(l),
      'open': l.widgetOpenApp,
      'title': l.widgetThisMonth,
      'upcoming': l.widgetUpcoming,
    };
    if (upcoming.isEmpty) {
      return {...base, 'state': 'empty', 'emptyTitle': l.widgetEmptyTitle, 'emptyBody': l.widgetEmptyBody};
    }
    // Same rule as the Overview hero: "≈" when an Active subscription is billed in another currency.
    final approx = subscriptions.any(
      (s) => BillingRules.effectiveStatus(s, today) == SubscriptionStatus.active && s.currency != primaryCurrency,
    );
    final total = Fmt.money(summary.monthly, primaryCurrency, l.localeName, approx: approx);
    return {
      ...base,
      'state': 'list',
      'next': l.widgetNext,
      'total': total,
      'totalPerMonth': l.widgetPerMonth(total),
      'totalA11y': l.widgetMonthlyTotalA11y(total),
      if (summary.awaitingCount > 0) 'badge': l.widgetToConfirm(summary.awaitingCount),
      'awaiting': l.widgetAwaiting,
      'tomorrow': l.widgetDueTomorrow,
      'inDays': l.widgetDueInDays('{n}'),
      'firstCharge': l.widgetFirstCharge,
      'items': [for (final s in upcoming.take(maxItems)) _item(l, s, today)],
    };
  }

  /// Subscriptions with a Due date (Active and Trial; Paused and Cancelled have none), soonest
  /// first — so anything awaiting confirmation comes before what is still ahead.
  static List<Subscription> upcomingOf(Iterable<Subscription> subscriptions, LocalDate today) {
    final list = subscriptions.where((s) => BillingRules.hasSchedule(BillingRules.effectiveStatus(s, today))).toList()
      ..sort((a, b) {
        final byDate = a.dueDate.compareTo(b.dueDate);
        return byDate != 0 ? byDate : a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return list;
  }

  /// Text the widget shows for a Due date [days] away (mirrors the native code, used by tests).
  static String dueText(Map<String, Object?> snapshot, int days) {
    if (days <= 0) return snapshot['awaiting']! as String;
    if (days == 1) return snapshot['tomorrow']! as String;
    return (snapshot['inDays']! as String).replaceAll('{n}', '$days');
  }

  static Map<String, Object?> _item(AppLocalizations l, Subscription s, LocalDate today) {
    final tile = Color(s.colorValue).withValues(alpha: 1);
    final icon = s.iconText?.trim();
    return {
      'id': s.id,
      'name': s.name,
      'mono': icon != null && icon.isNotEmpty ? icon : ServiceTile.initials(s.name),
      'color': tile.toARGB32(),
      'onColor': ServiceTile.onTileColor(tile).toARGB32(),
      'price': Fmt.moneyOf(s.myShare, l.localeName),
      'date': AppDates.weekdayShort(l, s.dueDate, today: today),
      'due': s.dueDate.toString(),
      'trial': BillingRules.effectiveStatus(s, today) == SubscriptionStatus.trial,
    };
  }

  static String _lang(AppLocalizations l) => l.localeName.split(RegExp('[_-]')).first;
}
