import 'dart:ui' show Color;

import '../../core/l10n/l10n.dart';
import '../../core/utils/format.dart';
import '../../core/widgets/formatters.dart';
import '../../core/widgets/service_tile.dart';
import '../../domain/domain.dart';

/// Where a widget tile finds its logo (decision 2026-11-10 (2) #5: logos bundled with the app).
/// [asset] is a Flutter asset path (`assets/logos/png/<id>.png`): Android reads it from the APK
/// (`flutter_assets/…`), iOS from the app bundle when it can. [file] is a Custom logo on disk
/// (Android only — iOS needs the App Group). Neither → the monogram.
typedef WidgetLogo = ({String? asset, String? file});

/// What the home-screen widgets show (product.md §4.12, mockups v14 122–125), as ready-to-draw
/// strings: the native side (Android `SubnestWidgetProvider.kt`, iOS `SubnestWidget.swift`) never
/// formats money, never reads the database and never sees anything the snapshot leaves out.
///
/// Stored as ONE JSON string under [WidgetSnapshot.storageKey], so switching to the locked state
/// overwrites everything that was there (App lock: nothing but "Locked with PIN" may remain).
///
/// Format (`v` 2):
/// * every state: `v`, `state` (`list` | `empty` | `locked`), `lang`, `open` (a11y "Open Subnest");
/// * `locked`: `locked` ("Locked with PIN") and `lockedLong` (medium / large) — nothing else;
/// * `empty`: `emptyTitle`, `emptyBody` (tapping opens "+" step 1);
/// * `list`: `title` (month name), `total` ("≈ $144.89" = the Overview's Month spend), `per` ("/mo"),
///   `totalA11y`, `paidLabel`/`paid`, `dueLabel`/`due`, `paidShare` (0…1, large widget bar),
///   `badge` (or absent), `awaiting`, `tapToConfirm`, `tomorrow`, `inDays` ("{n} days"),
///   `leftTomorrow`, `leftDays` ("{n} days left"), and `items` (≤ [maxItems], soonest first):
///   `id`, `name`, `mono`, `color`/`onColor` (ARGB ints), `price`, `cycle` (chip text), `date`
///   ("Thu, 12 Nov"), `dateShort` ("12 Nov"), `due` (ISO date — the widget works out "2 days" /
///   "To confirm" itself, so it stays right after midnight while the app is closed), `trial`
///   (bool), `trialEnds` ("Trial ends 13 Nov", trials only), `logo` / `logoFile` (see [WidgetLogo]).
abstract final class WidgetSnapshot {
  static const version = 2;

  /// Key in the `home_widget` store (Android SharedPreferences / iOS App Group UserDefaults).
  static const storageKey = 'subnest.widget';

  /// Rows the large widget can show (mockup 123); small uses 1, medium 3.
  static const maxItems = 6;

  /// Snapshot while App lock is on (or its state is not known yet): no names, no amounts, no dates.
  static Map<String, Object?> locked(AppLocalizations l) => {
    'v': version,
    'state': 'locked',
    'lang': _lang(l),
    'locked': l.widgetLocked,
    'lockedLong': l.widgetLockedLong,
    'open': l.widgetOpenApp,
  };

  /// Snapshot of the user's data. [month] is the Overview's Month spend of this month (same total
  /// as its Cost card) and [cash] its Month cash flow (Paid / Still to pay); without them the total
  /// falls back to [summary]'s monthly cost. [logoOf] finds each tile's logo.
  static Map<String, Object?> build({
    required AppLocalizations l,
    required List<Subscription> subscriptions,
    required SpendingSummary summary,
    required String primaryCurrency,
    required LocalDate today,
    MonthSpend? month,
    MonthCashFlow? cash,
    WidgetLogo Function(Subscription s)? logoOf,
  }) {
    final upcoming = upcomingOf(subscriptions, today);
    final base = <String, Object?>{'v': version, 'lang': _lang(l), 'open': l.widgetOpenApp};
    if (upcoming.isEmpty) {
      return {...base, 'state': 'empty', 'emptyTitle': l.widgetEmptyTitle, 'emptyBody': l.widgetEmptyBody};
    }
    // Same rule as the Overview's Cost card: "≈" when a counted line is billed in another currency.
    final approx = month != null
        ? month.lines.any((e) => e.subscription.currency != primaryCurrency)
        : subscriptions.any(
            (s) => BillingRules.effectiveStatus(s, today) == SubscriptionStatus.active && s.currency != primaryCurrency,
          );
    final total = month != null
        ? Fmt.moneyOf(Money(month.totalMinor, month.currency), l.localeName, approx: approx)
        : Fmt.money(summary.monthly, primaryCurrency, l.localeName, approx: approx);
    return {
      ...base,
      'state': 'list',
      'title': _monthName(l, today),
      'total': total,
      'per': l.widgetPerMonthShort,
      'totalA11y': l.widgetMonthlyTotalA11y(total),
      if (cash != null) ...{
        'paidLabel': l.widgetPaid,
        'paid': Fmt.moneyOf(Money(cash.paidMinor, cash.currency), l.localeName, approx: approx),
        'dueLabel': l.widgetStillToPay,
        'due': Fmt.moneyOf(Money(cash.remainingMinor, cash.currency), l.localeName, approx: approx),
        'paidShare': cash.paidShare,
      },
      if (summary.awaitingCount > 0) 'badge': l.widgetToConfirm(summary.awaitingCount),
      'awaiting': l.widgetAwaiting,
      'tapToConfirm': l.widgetTapToConfirm,
      'tomorrow': l.widgetDueTomorrow,
      'inDays': l.widgetDueInDays('{n}'),
      'leftTomorrow': l.widgetLeftTomorrow,
      'leftDays': l.widgetLeftDays('{n}'),
      'items': [for (final s in upcoming.take(maxItems)) _item(l, s, today, logoOf?.call(s))],
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

  /// Short "when" of the small widget for a Due date [days] away (mirrors the native code, used
  /// by tests): "To confirm" / "Tomorrow" / "2 days".
  static String dueText(Map<String, Object?> snapshot, int days) {
    if (days <= 0) return snapshot['awaiting']! as String;
    if (days == 1) return snapshot['tomorrow']! as String;
    return (snapshot['inDays']! as String).replaceAll('{n}', '$days');
  }

  /// Small widget's line under the price (mirrors the native code): "Tap to confirm",
  /// "Trial ends 13 Nov", or "12 Nov · 2 days left".
  static String smallMeta(Map<String, Object?> snapshot, Map<String, Object?> item, int days) {
    if (days <= 0) return snapshot['tapToConfirm']! as String;
    final trial = item['trialEnds'] as String?;
    if (trial != null) return trial;
    final left = days == 1
        ? snapshot['leftTomorrow']! as String
        : (snapshot['leftDays']! as String).replaceAll('{n}', '$days');
    return '${item['dateShort']} · $left';
  }

  static Map<String, Object?> _item(AppLocalizations l, Subscription s, LocalDate today, WidgetLogo? logo) {
    final tile = Color(s.colorValue).withValues(alpha: 1);
    final icon = s.iconText?.trim();
    final trial = BillingRules.effectiveStatus(s, today) == SubscriptionStatus.trial;
    return {
      'id': s.id,
      'name': s.name,
      'mono': icon != null && icon.isNotEmpty ? icon : ServiceTile.initials(s.name),
      'color': tile.toARGB32(),
      'onColor': ServiceTile.onTileColor(tile).toARGB32(),
      'price': Fmt.moneyOf(s.myShare, l.localeName),
      'cycle': l.cycle(s.cycle),
      'date': AppDates.weekdayShort(l, s.dueDate, today: today),
      'dateShort': AppDates.short(l, s.dueDate, today: today),
      'due': s.dueDate.toString(),
      'trial': trial,
      if (trial) 'trialEnds': l.widgetTrialEnds(AppDates.short(l, s.trialEndDate ?? s.dueDate, today: today)),
      if (logo?.asset != null) 'logo': logo!.asset,
      if (logo?.file != null) 'logoFile': logo!.file,
    };
  }

  /// "November" / "Tháng 11" (mockups 122–123).
  static String _monthName(AppLocalizations l, LocalDate today) {
    final title = AppDates.monthTitle(l, today.year, today.month);
    return title.substring(0, title.lastIndexOf(' '));
  }

  static String _lang(AppLocalizations l) => l.localeName.split(RegExp('[_-]')).first;
}
