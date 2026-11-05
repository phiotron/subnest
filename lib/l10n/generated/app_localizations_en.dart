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
  String get coreRelToday => 'today';

  @override
  String get coreRelTomorrow => 'tomorrow';

  @override
  String coreRelInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'in $count days',
      one: 'in 1 day',
    );
    return '$_temp0';
  }

  @override
  String coreRelDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String corePer(String unit) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'day': '/day',
      'week': '/week',
      'month': '/month',
      'quarter': '/quarter',
      'year': '/year',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String corePerEvery(int count, String unit) {
    return '/$count $unit';
  }

  @override
  String corePlanPrice(String price) {
    return 'plan $price';
  }

  @override
  String get coreSwipeConfirm => 'Confirm';

  @override
  String get coreSwipeCancel => 'Cancel';

  @override
  String coreSharedWith(int count) {
    return 'Shared by $count';
  }

  @override
  String get coreAddSubscription => 'Add subscription';

  @override
  String get coreMonth => 'Month';

  @override
  String get coreYear => 'Year';

  @override
  String get corePrevMonth => 'Previous month';

  @override
  String get coreNextMonth => 'Next month';

  @override
  String get coreFewer => 'Fewer';

  @override
  String get coreMore => 'More';

  @override
  String get coreTabOverview => 'Overview';

  @override
  String get coreChangeCurrency => 'Change currency';

  @override
  String get coreEditAmount => 'Edit amount';

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
      'Cancel now if you don’t want to be charged.';

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
  String get settingsSectionMoney => 'Money';

  @override
  String get settingsPrimaryCurrency => 'Main currency';

  @override
  String get settingsSearchCurrency => 'Search currency or country';

  @override
  String get settingsCurrencyNote =>
      'Totals and insights add up in this currency. Each subscription keeps its own.';

  @override
  String settingsCurrencyNoMatch(String query) {
    return 'No currency matches “$query”';
  }

  @override
  String get settingsRates => 'Exchange rates';

  @override
  String settingsRatesSummaryAuto(String ago) {
    return 'Auto · $ago';
  }

  @override
  String get settingsRatesSummaryBuiltIn => 'Built-in';

  @override
  String get settingsRatesSummaryManual => 'Set by you';

  @override
  String settingsRatesIntro(String currency) {
    return 'Totals convert to $currency. Rates update once a day when you’re online; set your own to override.';
  }

  @override
  String settingsRateAuto(String ago) {
    return 'Auto · updated $ago';
  }

  @override
  String settingsRateAutoOffline(String ago) {
    return 'Auto · from $ago (offline)';
  }

  @override
  String get settingsRateBuiltIn => 'Auto · built-in estimate';

  @override
  String get settingsRateManual => 'Set by you';

  @override
  String settingsRatePairLabel(String from, String rate, String to) {
    return '1 $from equals $rate $to';
  }

  @override
  String get settingsRatesUpdateNow => 'Update now';

  @override
  String get settingsRatesUpdated => 'Exchange rates updated';

  @override
  String get settingsRatesOfflineTitle => 'You’re offline';

  @override
  String get settingsRatesOfflineBody =>
      'Using the last rates we fetched. They update when you’re back online.';

  @override
  String get settingsRatesListedNote =>
      'Only currencies your subscriptions use are listed.';

  @override
  String settingsRatesNoneUsed(String currency) {
    return 'All your subscriptions are in $currency, so nothing needs converting.';
  }

  @override
  String get settingsRatesAttribution => 'Rates by Exchange Rate API';

  @override
  String get settingsAgoJustNow => 'just now';

  @override
  String settingsAgoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count min ago',
      one: '1 min ago',
    );
    return '$_temp0';
  }

  @override
  String settingsAgoHoursShort(int count) {
    return '$count h ago';
  }

  @override
  String settingsAgoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String settingsAgoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateUseAuto => 'Use automatic rate';

  @override
  String settingsRateAutoValue(String rate, String ago) {
    return '$rate · updated $ago';
  }

  @override
  String settingsRateAutoValueBuiltIn(String rate) {
    return '$rate · built-in estimate';
  }

  @override
  String settingsRateYours(String from) {
    return 'Your rate · 1 $from =';
  }

  @override
  String settingsRatePreview(String name, String amount) {
    return '$name becomes $amount/month';
  }

  @override
  String get settingsRateInvalid => 'Enter a rate above 0';

  @override
  String get settingsRateSave => 'Save my rate';

  @override
  String get settingsRateRestoreAuto => 'Restore automatic';

  @override
  String get settingsSectionReminders => 'Reminders';

  @override
  String get settingsRemindMe => 'Remind me';

  @override
  String settingsReminderValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days before',
      one: '1 day before',
      zero: 'On the day',
    );
    return '$_temp0';
  }

  @override
  String get settingsReminderOff => 'Off';

  @override
  String get settingsReminderTime => 'Reminder time';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsNotificationsOn => 'On';

  @override
  String get settingsNotificationsOff => 'Off';

  @override
  String get settingsNotificationsOffTitle =>
      'Notifications are off for Subnest';

  @override
  String get settingsNotificationsOffBody =>
      'Reminders can’t reach you until you allow them in system settings.';

  @override
  String get settingsOpenSystemSettings => 'Open settings';

  @override
  String get settingsOpenSystemSettingsFailed =>
      'Open your phone’s Settings › Apps › Subnest › Notifications.';

  @override
  String get settingsRemindBefore => 'Remind me before a renewal';

  @override
  String settingsRemindChoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: 'On day',
    );
    return '$_temp0';
  }

  @override
  String get settingsRemindTrialNote =>
      'Trials get the same reminder before they end.';

  @override
  String get settingsReminderTimeShort => 'Time';

  @override
  String get settingsRemindersNote =>
      'You can change this for a single subscription from its edit screen. Applies to new reminders; existing ones move to the new time.';

  @override
  String get settingsPreview => 'Preview';

  @override
  String get settingsPreviewOff =>
      'Reminders are off. Renewals still show up in the app as they come due.';

  @override
  String get settingsTestReminder => 'Send a test reminder';

  @override
  String get settingsTestReminderHint =>
      'Debug only · one now and one in 10 seconds';

  @override
  String get settingsTestReminderSent => 'Test reminder sent';

  @override
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsSystem => 'System';

  @override
  String get settingsSystemShort => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String settingsLanguageFromPhone(String language) {
    return '$language (from your phone)';
  }

  @override
  String get settingsSectionBackup => 'Backup';

  @override
  String get settingsBackupTitle => 'Backup & restore';

  @override
  String settingsBackupOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'Last backup was $_temp0 ago';
  }

  @override
  String get settingsBackupNeverTitle => 'You haven’t backed up yet';

  @override
  String get settingsBackupOverdueBody =>
      'Your data lives only on this phone. Export a copy now.';

  @override
  String get settingsBackupAction => 'Back up';

  @override
  String settingsBackupDaysTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return 'It’s been $_temp0 since your last backup';
  }

  @override
  String get settingsBackupWhyBody =>
      'Subnest keeps nothing online, so a backup is the only way to move to a new phone.';

  @override
  String get settingsExportJson => 'Export backup';

  @override
  String get settingsExportJsonHint => 'JSON · everything, to restore later';

  @override
  String get settingsExportJsonLong =>
      'Everything, as a .json file to restore later';

  @override
  String get settingsExportCsv => 'Export spreadsheet';

  @override
  String get settingsExportCsvHint => 'CSV · opens in Excel or Sheets';

  @override
  String get settingsExportCsvLong => 'Subscriptions and payments as .csv';

  @override
  String get settingsExported => 'Saved — keep it somewhere safe';

  @override
  String get settingsExportFailed =>
      'Couldn’t create the file. Please try again.';

  @override
  String get settingsRestore => 'Restore from file';

  @override
  String get settingsRestoreHint => 'Pick a Subnest .json backup';

  @override
  String settingsLastBackup(String date) {
    return 'Last backup: $date';
  }

  @override
  String settingsLastBackupFile(String date, String file) {
    return 'Last backup: $date · $file';
  }

  @override
  String get settingsNeverBackedUp => 'No backup yet';

  @override
  String get settingsRestoreTitle => 'Restore this backup?';

  @override
  String settingsRestoreHolds(int subs, int payments) {
    String _temp0 = intl.Intl.pluralLogic(
      subs,
      locale: localeName,
      other: '$subs subscriptions',
      one: '1 subscription',
    );
    String _temp1 = intl.Intl.pluralLogic(
      payments,
      locale: localeName,
      other: '$payments payments',
      one: '1 payment',
    );
    return 'It holds $_temp0 and $_temp1.';
  }

  @override
  String get settingsRestoreMerge => 'Merge';

  @override
  String get settingsRestoreMergeHint =>
      'Add what’s missing, keep your current data';

  @override
  String get settingsRestoreReplace => 'Replace';

  @override
  String get settingsRestoreReplaceHint =>
      'Delete current data and use the backup';

  @override
  String get settingsRestoreAction => 'Restore';

  @override
  String get settingsRestoreReplaceAction => 'Replace my data';

  @override
  String get settingsRestoreInvalid => 'That file isn’t a Subnest backup.';

  @override
  String get settingsRestoreFailed =>
      'Couldn’t restore that backup. Nothing was changed.';

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
  String get settingsSectionAbout => 'About';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsTerms => 'Terms of use';

  @override
  String get settingsLicenses => 'Open-source licenses';

  @override
  String get settingsRateApp => 'Rate Subnest';

  @override
  String get settingsFeedback => 'Send feedback';

  @override
  String settingsFeedbackSubject(String version) {
    return 'Subnest feedback ($version)';
  }

  @override
  String settingsNoEmailApp(String email) {
    return 'No email app found. Write to $email';
  }

  @override
  String get settingsLinkFailed => 'Couldn’t open the page.';

  @override
  String get settingsLegalese =>
      'Made by Phiotron. Subnest keeps your data on this device.';

  @override
  String get settingsPrivacyNote =>
      'Your data stays on this phone. Subnest collects nothing.';

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
