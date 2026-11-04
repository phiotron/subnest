import 'package:flutter/widgets.dart';

import '../../domain/domain.dart';
import '../../l10n/generated/app_localizations.dart';
import '../utils/format.dart';

export '../../l10n/generated/app_localizations.dart';

/// `context.l10n.homeTitle` shorthand.
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// Labels for domain values, shared by every feature (strings live in parts/common_*.arb).
extension DomainLabels on AppLocalizations {
  String cycle(BillingCycle c) => switch (c.unit) {
    CycleUnit.day => commonCycleDays(c.every),
    CycleUnit.week => commonCycleWeeks(c.every),
    CycleUnit.month => c.every == 3 ? commonCycleQuarterly : commonCycleMonths(c.every),
    CycleUnit.year => commonCycleYears(c.every),
  };

  String status(SubscriptionStatus s) => switch (s) {
    SubscriptionStatus.trial => commonStatusTrial,
    SubscriptionStatus.active => commonStatusActive,
    SubscriptionStatus.cancelled => commonStatusCancelled,
  };

  String category(SubscriptionCategory c) => commonCategory(c.key);

  String reminder(int? days) => switch (days) {
    null => commonReminderDefault,
    ReminderDays.off => commonReminderOff,
    ReminderDays.onTheDay => commonReminderOnTheDay,
    final d => commonReminderDaysBefore(d),
  };

  String money(Money m, {bool approx = false}) => Fmt.moneyOf(m, localeName, approx: approx);

  String amount(double major, String currency, {bool approx = false}) =>
      Fmt.money(major, currency, localeName, approx: approx);

  String date(LocalDate d) => Fmt.date(d, localeName);
}
