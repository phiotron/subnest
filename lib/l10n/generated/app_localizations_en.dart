// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonAppName => 'Subnest';

  @override
  String get commonTabHome => 'Home';

  @override
  String get commonTabCalendar => 'Calendar';

  @override
  String get commonTabInsights => 'Insights';

  @override
  String get commonTabSettings => 'Settings';

  @override
  String get commonSave => 'Save';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonDone => 'Done';

  @override
  String get commonPerMonth => 'per month';

  @override
  String get commonPerYear => 'per year';

  @override
  String commonCycleDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Daily',
    );
    return '$_temp0';
  }

  @override
  String commonCycleWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Weekly',
    );
    return '$_temp0';
  }

  @override
  String commonCycleMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Monthly',
    );
    return '$_temp0';
  }

  @override
  String commonCycleYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Yearly',
    );
    return '$_temp0';
  }

  @override
  String get commonCycleQuarterly => 'Quarterly';

  @override
  String get commonUnitDay => 'days';

  @override
  String get commonUnitWeek => 'weeks';

  @override
  String get commonUnitMonth => 'months';

  @override
  String get commonUnitYear => 'years';

  @override
  String get commonStatusTrial => 'Free trial';

  @override
  String get commonStatusActive => 'Active';

  @override
  String get commonStatusCancelled => 'Cancelled';

  @override
  String get commonStatusAwaiting => 'To confirm';

  @override
  String commonCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'video': 'Video',
      'music': 'Music',
      'ai': 'AI',
      'storage': 'Storage',
      'software': 'Software',
      'gaming': 'Games',
      'reading': 'Reading',
      'health': 'Health',
      'education': 'Learning',
      'telecom': 'Telecom',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get commonCategoryAll => 'All';

  @override
  String commonDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count days',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String commonDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get commonReminderDefault => 'Default';

  @override
  String get commonReminderOff => 'Off';

  @override
  String get commonReminderOnTheDay => 'On the day';

  @override
  String commonReminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days before',
      one: '1 day before',
    );
    return '$_temp0';
  }

  @override
  String commonSharedWith(int count) {
    return '÷$count';
  }

  @override
  String get commonNotFound => 'This subscription no longer exists.';

  @override
  String calendarMonthTotal(String amount) {
    return 'Month total: $amount';
  }

  @override
  String get calendarEmpty => 'Nothing due this month.';

  @override
  String get calendarPaid => 'Paid';

  @override
  String get calendarSkipped => 'Not paid';

  @override
  String get calendarUpcoming => 'Upcoming';

  @override
  String get catalogSearchHint => 'Search services';

  @override
  String get catalogCustom => '+ Create a custom service';

  @override
  String catalogCustomNamed(String name) {
    return 'Not listed? Create “$name”';
  }

  @override
  String catalogFromPerMonth(String amount) {
    return 'from $amount/month';
  }

  @override
  String catalogChoosePlan(String name) {
    return 'Choose a $name plan';
  }

  @override
  String confirmTitle(String name, String date) {
    return '$name · period $date';
  }

  @override
  String confirmMorePending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more periods to confirm',
      one: '1 more period to confirm',
    );
    return '$_temp0';
  }

  @override
  String get confirmAmount => 'Amount paid';

  @override
  String get confirmPaid => 'Paid';

  @override
  String get confirmSkip => 'Not paying this period';

  @override
  String get confirmLater => 'Later';

  @override
  String confirmNext(String date) {
    return 'Next renewal: $date';
  }

  @override
  String confirmNothing(String name) {
    return '$name has nothing to confirm.';
  }

  @override
  String get confirmAwaitingTitle => 'To confirm';

  @override
  String get confirmAllDone => 'You\'re all caught up 🎉';

  @override
  String confirmAll(String amount) {
    return 'Confirm all · $amount';
  }

  @override
  String confirmAllDialogTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Confirm $count payments?',
      one: 'Confirm 1 payment?',
    );
    return '$_temp0';
  }

  @override
  String get confirmAllDialogBody =>
      'All of them will be marked as paid at their current price.';

  @override
  String get homeAdd => 'Add subscription';

  @override
  String homeCounts(int active, int trial) {
    return '$active paying · $trial on trial';
  }

  @override
  String homeTrialSoon(String amount) {
    return '$amount/month after trials end';
  }

  @override
  String get homeRatesOffline => 'Approximate exchange rates (not updated yet)';

  @override
  String homeRatesStale(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Exchange rates updated $days days ago',
      one: 'Exchange rates updated 1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get homeRatesFresh => 'Exchange rates updated today';

  @override
  String get homeNotificationsOff => 'Reminders are off';

  @override
  String get homeEnable => 'Turn on';

  @override
  String homeAwaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments to confirm',
      one: '1 payment to confirm',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'View';

  @override
  String homeTrialEnding(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'in $days days',
      one: 'tomorrow',
      zero: 'today',
    );
    return '$name trial ends $_temp0';
  }

  @override
  String get homeHowToCancel => 'How to cancel';

  @override
  String get homeUpcoming => 'Next 7 days';

  @override
  String get homeTabActive => 'Paying';

  @override
  String get homeTabTrial => 'Trial';

  @override
  String get homeTabCancelled => 'Cancelled';

  @override
  String get homeTabEmpty => 'Nothing here.';

  @override
  String get homeSort => 'Sort';

  @override
  String get homeSortDueDate => 'Renewal date';

  @override
  String get homeSortPrice => 'Price';

  @override
  String get homeSortName => 'Name';

  @override
  String homeSavings(String amount) {
    return 'You\'re saving $amount/year';
  }

  @override
  String homeCancelledOn(String date) {
    return 'Cancelled $date';
  }

  @override
  String get homeEmpty => 'Track every subscription in one nest.';

  @override
  String get homeAddFirst => 'Add your first subscription';

  @override
  String get insightsEmpty => 'Add subscriptions to see insights.';

  @override
  String get insightsThisMonth => 'This month';

  @override
  String insightsActualVsProjected(String actual, String projected) {
    return 'Paid $actual · expected $projected';
  }

  @override
  String insightsLastMonth(String amount) {
    return 'Last month paid: $amount';
  }

  @override
  String get insightsTwelveMonths => '12 months (paid · expected)';

  @override
  String get insightsByCategory => 'By category (monthly)';

  @override
  String get insightsTop => 'Most expensive';

  @override
  String get insightsSavingsTitle => 'Savings';

  @override
  String insightsSavings(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You\'re saving $amount/year by cancelling $count services',
      one: 'You\'re saving $amount/year by cancelling 1 service',
    );
    return '$_temp0';
  }

  @override
  String get notificationsChannelName => 'Reminders';

  @override
  String get notificationsChannelDescription =>
      'Renewal and free-trial reminders';

  @override
  String notificationsRenewalSoon(String name, int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$name renews in $_temp0 — $amount';
  }

  @override
  String notificationsTrialEndingTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Your $name trial ends in $_temp0.';
  }

  @override
  String get notificationsTrialEndingBody =>
      'Cancel now if you don\'t want to be charged.';

  @override
  String notificationsDueToday(String name) {
    return '$name renews today — tap to confirm';
  }

  @override
  String get notificationsTestTitle => 'Subnest reminders are on';

  @override
  String get notificationsTestScheduledTitle => 'Scheduled test reminder';

  @override
  String get notificationsTestBody =>
      'This is how renewal reminders will look.';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingWelcomeTitle => 'All your subscriptions, one nest';

  @override
  String get onboardingBenefitRemind => 'Get reminded before you\'re charged';

  @override
  String get onboardingBenefitTotal => 'Know exactly what you spend each month';

  @override
  String get onboardingBenefitPrivate =>
      'Private — your data stays on your phone';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingCurrencyTitle => 'Your primary currency';

  @override
  String get onboardingCurrencyHint =>
      'Used to add up your totals. Each subscription keeps its own currency.';

  @override
  String get onboardingQuickAddTitle => 'What do you pay for?';

  @override
  String get onboardingLater => 'Later';

  @override
  String onboardingSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Add $count · Continue',
      zero: 'Continue',
    );
    return '$_temp0';
  }

  @override
  String get onboardingRemindersTitle => 'Turn on reminders';

  @override
  String get onboardingRemindersExample =>
      '“Netflix renews in 3 days — ₫260,000”';

  @override
  String get onboardingEnableReminders => 'Turn on reminders';

  @override
  String get onboardingNoThanks => 'No, thanks';

  @override
  String get settingsCurrencySection => 'Currency';

  @override
  String get settingsPrimaryCurrency => 'Primary currency';

  @override
  String get settingsSearchCurrency => 'Search currency';

  @override
  String get settingsRates => 'Exchange rates';

  @override
  String get settingsRatesNeverUpdated => 'Using built-in approximate rates';

  @override
  String settingsRatesUpdatedAt(String date) {
    return 'Updated $date';
  }

  @override
  String get settingsRatesUpdateNow => 'Update now';

  @override
  String get settingsRatesUpdated => 'Exchange rates updated';

  @override
  String get settingsRatesFailed => 'Couldn\'t update — check your connection';

  @override
  String get settingsRatesNoneUsed =>
      'All your subscriptions use your primary currency.';

  @override
  String get settingsRatesAuto => 'Automatic';

  @override
  String get settingsRatesManual => 'Set by you';

  @override
  String get settingsRatesUseAuto => 'Use automatic';

  @override
  String get settingsRatesAttribution => 'Rates by Exchange Rate API';

  @override
  String get settingsRemindersSection => 'Reminders';

  @override
  String get settingsDefaultReminder => 'Remind me by default';

  @override
  String get settingsReminderTime => 'Reminder time';

  @override
  String get settingsPermission => 'Notifications';

  @override
  String get settingsPermissionOn => 'Allowed';

  @override
  String get settingsPermissionOff => 'Blocked in system settings';

  @override
  String get settingsPermissionAllow => 'Allow';

  @override
  String get settingsTestReminder => 'Send a test reminder';

  @override
  String get settingsTestReminderHint => 'One now and one in 10 seconds';

  @override
  String get settingsTestReminderSent => 'Test reminder sent';

  @override
  String get settingsAppearanceSection => 'Appearance & language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsFollowSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsBackupSection => 'Backup & restore';

  @override
  String get settingsBackup => 'Backup & restore';

  @override
  String get settingsNeverBackedUp => 'Never backed up';

  @override
  String settingsLastBackup(String date) {
    return 'Last backup: $date';
  }

  @override
  String get settingsBackupNudge =>
      'It\'s been a while — save a backup somewhere safe.';

  @override
  String get settingsExportJson => 'Export backup (JSON)';

  @override
  String get settingsExportCsv => 'Export spreadsheet (CSV)';

  @override
  String get settingsRestore => 'Restore from file';

  @override
  String get settingsRestoreHint => 'Pick a Subnest backup (.json)';

  @override
  String get settingsRestoreInvalid => 'That file isn\'t a Subnest backup.';

  @override
  String settingsRestoreTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restore $count subscriptions?',
      one: 'Restore 1 subscription?',
    );
    return '$_temp0';
  }

  @override
  String get settingsRestoreBody =>
      'Replace deletes your current data first. Merge keeps it and adds what\'s missing.';

  @override
  String get settingsRestoreReplace => 'Replace';

  @override
  String get settingsRestoreMerge => 'Merge';

  @override
  String settingsRestoreDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restored $count subscriptions',
      one: 'Restored 1 subscription',
    );
    return '$_temp0';
  }

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsPrivacyNote =>
      'Your data stays on this device. Subnest collects nothing.';

  @override
  String subscriptionDetailMyShare(String share, String price, int count) {
    return 'Your share $share · plan $price ÷ $count';
  }

  @override
  String subscriptionDetailAwaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count periods to confirm',
      one: '1 period to confirm',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailConfirm => 'Confirm';

  @override
  String get subscriptionDetailNextDue => 'Next renewal';

  @override
  String get subscriptionDetailTrialEnds => 'Trial ends';

  @override
  String get subscriptionDetailCycle => 'Billing cycle';

  @override
  String get subscriptionDetailReminder => 'Reminder';

  @override
  String get subscriptionDetailCategory => 'Category';

  @override
  String get subscriptionDetailPaymentMethod => 'Payment method';

  @override
  String get subscriptionDetailStarted => 'Started';

  @override
  String get subscriptionDetailCancelledOn => 'Cancelled on';

  @override
  String get subscriptionDetailTotalPaid => 'Total paid';

  @override
  String get subscriptionDetailNotes => 'Notes';

  @override
  String get subscriptionDetailHistory => 'Payment history';

  @override
  String get subscriptionDetailPaid => 'Paid';

  @override
  String get subscriptionDetailSkipped => 'Not paid this period';

  @override
  String get subscriptionDetailNoHistory => 'No payments yet.';

  @override
  String get subscriptionDetailHowToCancel => 'How to cancel this service';

  @override
  String get subscriptionDetailMarkCancelled => 'Mark as cancelled';

  @override
  String get subscriptionDetailRestore => 'Restore';

  @override
  String subscriptionDetailSaved(String amount) {
    return 'Nice! You\'re saving $amount/year';
  }

  @override
  String get subscriptionDetailEditAmount => 'Amount paid';

  @override
  String subscriptionDetailDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get subscriptionDetailDeleteBody =>
      'This removes the subscription and its whole payment history. To keep the history, mark it as cancelled instead.';

  @override
  String get subscriptionFormAddTitle => 'New subscription';

  @override
  String get subscriptionFormEditTitle => 'Edit subscription';

  @override
  String get subscriptionFormName => 'Name';

  @override
  String get subscriptionFormNameRequired => 'Enter a name';

  @override
  String get subscriptionFormPrice => 'Price';

  @override
  String get subscriptionFormPriceAfterTrial => 'Price after trial';

  @override
  String get subscriptionFormPriceRequired => 'Price must be greater than 0';

  @override
  String get subscriptionFormEvery => 'Every';

  @override
  String get subscriptionFormNextDue => 'Next renewal date';

  @override
  String subscriptionFormThen(String dates) {
    return 'Then: $dates';
  }

  @override
  String get subscriptionFormTrial => 'On a free trial';

  @override
  String get subscriptionFormTrialEnds => 'Trial ends on';

  @override
  String get subscriptionFormTrialEndInvalid =>
      'Trial end can\'t be in the past';

  @override
  String get subscriptionFormShared => 'Shared with others';

  @override
  String subscriptionFormPeople(int count) {
    return '$count people';
  }

  @override
  String subscriptionFormMyShare(String amount) {
    return 'Your share: $amount';
  }

  @override
  String get subscriptionFormCategory => 'Category';

  @override
  String get subscriptionFormReminder => 'Remind me';

  @override
  String get subscriptionFormAdvanced => 'More';

  @override
  String get subscriptionFormPaymentMethod =>
      'Payment method (e.g. Visa ••4242, MoMo)';

  @override
  String get subscriptionFormManageUrl => 'Cancel / manage link';

  @override
  String get subscriptionFormNotes => 'Notes';

  @override
  String get subscriptionFormAddButton => 'Add subscription';

  @override
  String get subscriptionFormSaveChanges => 'Save changes';

  @override
  String get subscriptionFormPriceFromNext =>
      'New price applies from the next period. Past payments are unchanged.';
}
