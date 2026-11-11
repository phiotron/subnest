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
  String get commonLanguageEnglish => 'English';

  @override
  String get commonLanguageVietnamese => 'Tiếng Việt';

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
  String get commonStatusPaused => 'Paused';

  @override
  String get commonWorthItUnrated => 'Not rated';

  @override
  String get commonWorthItWorth => 'Worth it';

  @override
  String get commonWorthItUnsure => 'Not sure';

  @override
  String get commonWorthItNotWorth => 'Not worth it';

  @override
  String get commonAutoDetected => 'Auto-detected';

  @override
  String get commonDetectionScan => 'Screenshot';

  @override
  String get commonDetectionNotification => 'Notification';

  @override
  String get commonDetectionGmail => 'Gmail';

  @override
  String get commonReferencePrice => 'Reference price';

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
  String get calendarViewMonth => 'Month';

  @override
  String get calendarViewAgenda => 'List';

  @override
  String calendarMonthColon(String name, String number) {
    return '$name:';
  }

  @override
  String calendarToCome(int count) {
    return '$count to come';
  }

  @override
  String get calendarExpected => 'Expected';

  @override
  String calendarMonthYear(String name, String number, String year) {
    return '$name $year';
  }

  @override
  String calendarMonthName(String name, String number) {
    return '$name';
  }

  @override
  String calendarCountPayments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments',
      one: '1 payment',
      zero: 'Nothing due',
    );
    return '$_temp0';
  }

  @override
  String calendarCountPaid(int count) {
    return '$count paid';
  }

  @override
  String calendarCountSkipped(int count) {
    return '$count skipped';
  }

  @override
  String get calendarEmpty => 'Nothing due this month.';

  @override
  String get calendarNothingDue => 'Nothing due this day.';

  @override
  String get calendarPaid => 'Paid';

  @override
  String get calendarSkipped => 'Skipped';

  @override
  String get calendarDidNotPay => 'Didn’t pay this period';

  @override
  String get calendarFirstCharge => 'First charge after trial';

  @override
  String calendarTodayPrefix(String date) {
    return 'Today · $date';
  }

  @override
  String get calendarGroupThisWeek => 'This week';

  @override
  String calendarGroupLater(String name, String number) {
    return 'Later in $name';
  }

  @override
  String calendarGroupEarlier(String name, String number) {
    return 'Earlier in $name';
  }

  @override
  String calendarDayLabel(String date, String items) {
    return '$date, $items';
  }

  @override
  String get calendarLegendLabel => 'Legend';

  @override
  String calendarMissingRates(String currencies) {
    return 'Amounts in $currencies aren’t in the total — no exchange rate yet.';
  }

  @override
  String get catalogTitle => 'Add subscription';

  @override
  String get catalogSearchHint => 'Search 500+ services';

  @override
  String get catalogClearSearch => 'Clear search';

  @override
  String get catalogCustom => 'Create a custom service';

  @override
  String get catalogCustomSub => 'Your own name, colour, letter or photo';

  @override
  String catalogCustomNamed(String name) {
    return 'Not it? Create “$name”';
  }

  @override
  String catalogCreateNamed(String name) {
    return 'Create “$name”';
  }

  @override
  String get catalogCustomService => 'Custom service';

  @override
  String get catalogPopularVietnam => 'Vietnam · prices in VND';

  @override
  String get catalogPopular => 'Popular · US prices';

  @override
  String get catalogMore => 'More services';

  @override
  String catalogResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String catalogNoResultTitle(String name) {
    return 'Nothing called “$name”';
  }

  @override
  String get catalogNoResultBody =>
      'Create it — pick a colour, a letter or a photo.';

  @override
  String catalogFrom(String price) {
    return 'from $price';
  }

  @override
  String catalogPlans(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plans',
      one: '1 plan',
    );
    return '$_temp0';
  }

  @override
  String catalogAddService(String name) {
    return 'Add $name';
  }

  @override
  String get catalogPlanSubVietnam => 'Choose a plan · prices in VND';

  @override
  String get catalogPlanSub => 'Choose a plan · US prices';

  @override
  String catalogPlanMembers(int count) {
    return 'Up to $count people';
  }

  @override
  String get catalogPlanNote => 'You can change the price on the next screen.';

  @override
  String catalogContinueWith(String plan) {
    return 'Continue with $plan';
  }

  @override
  String get catalogTabGeneral => 'General';

  @override
  String get catalogTabVietnam => 'Vietnam';

  @override
  String catalogUpdated(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Library updated $days days ago',
      one: 'Library updated yesterday',
      zero: 'Library updated today',
    );
    return '$_temp0';
  }

  @override
  String get confirmDueToday => 'Due today';

  @override
  String get confirmOverdue => 'Overdue';

  @override
  String confirmMoreAfter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more after this',
      one: '1 more after this',
    );
    return '$_temp0';
  }

  @override
  String confirmPeriodOf(String date) {
    return 'Period of $date';
  }

  @override
  String get confirmAmount => 'Amount paid';

  @override
  String confirmYourShare(String price, int count) {
    return 'Your share · plan $price ÷ $count';
  }

  @override
  String get confirmCurrentPrice =>
      'Current price · change it if you paid a different amount';

  @override
  String confirmDueOn(String date) {
    return 'Due $date';
  }

  @override
  String confirmChainMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more periods to confirm — opening the next',
      one: '1 more period to confirm — opening it next',
    );
    return '$_temp0';
  }

  @override
  String get confirmNextPeriodButton => 'Next period';

  @override
  String get confirmPaid => 'Paid';

  @override
  String get confirmSkip => 'Didn’t pay this period';

  @override
  String get confirmLater => 'Later';

  @override
  String get confirmAmountRequired => 'Enter the amount you paid.';

  @override
  String get confirmSaved => 'Payment saved';

  @override
  String get confirmSkippedTitle => 'Marked as not paid';

  @override
  String confirmNextPeriod(String date) {
    return 'Next period: $date';
  }

  @override
  String get confirmDone => 'Done';

  @override
  String get confirmNothingTitle => 'Nothing to confirm';

  @override
  String confirmNothingBody(String name, String date) {
    return '$name is up to date. Next renewal: $date.';
  }

  @override
  String confirmNothingCancelled(String name) {
    return '$name is cancelled, so there is nothing to confirm.';
  }

  @override
  String get confirmAwaitingTitle => 'To confirm';

  @override
  String get confirmAwaitingIntro =>
      'Oldest first. Each period is confirmed one at a time, so the next date only moves once the earlier one is settled.';

  @override
  String get confirmAwaitingFooter =>
      'Tap a row to change the amount or mark it unpaid.';

  @override
  String confirmAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '${days}d ago',
      zero: 'today',
    );
    return '$_temp0';
  }

  @override
  String confirmAfter(String date) {
    return 'After $date';
  }

  @override
  String confirmMarkPaid(String name, String date) {
    return 'Mark $name, $date as paid';
  }

  @override
  String confirmQueued(String date) {
    return 'Confirm the $date period first';
  }

  @override
  String confirmQuickSaved(String name, String date) {
    return '$name · $date saved as paid';
  }

  @override
  String confirmAllButton(String amount) {
    return 'Confirm all · $amount';
  }

  @override
  String confirmAllTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Confirm $count payments?',
      one: 'Confirm 1 payment?',
    );
    return '$_temp0';
  }

  @override
  String get confirmAllBody =>
      'Each period is saved as paid at its current price:';

  @override
  String get confirmAllFooter => 'You can edit any payment later.';

  @override
  String get confirmAllAction => 'Confirm all';

  @override
  String get confirmAllCancel => 'Cancel';

  @override
  String confirmAllSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments saved',
      one: '1 payment saved',
    );
    return '$_temp0';
  }

  @override
  String get confirmCaughtUp => 'You’re all caught up 🎉';

  @override
  String get confirmCaughtUpBody =>
      'New periods show up here on their due date.';

  @override
  String get confirmBackHome => 'Back to Overview';

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
  String get coreApproximately => 'approximately';

  @override
  String get homeTitle => 'Overview';

  @override
  String get homeSearch => 'Search subscriptions';

  @override
  String get homeSearchHint => 'Search by name';

  @override
  String get homeSearchClose => 'Close search';

  @override
  String homeSearchEmpty(String query) {
    return 'No subscription matches “$query”.';
  }

  @override
  String homeRatesStale(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Offline · rates from $days days ago',
      one: 'Offline · rates from yesterday',
    );
    return '$_temp0';
  }

  @override
  String get homeRatesNever => 'Offline · approximate rates';

  @override
  String get homeRemindersOffTitle => 'Reminders are off';

  @override
  String get homeRemindersOffBody =>
      'You won’t hear about renewals or trials ending.';

  @override
  String get homeRemindersTurnOn => 'Turn on';

  @override
  String homeAwaitingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments to confirm',
      one: '1 payment to confirm',
    );
    return '$_temp0';
  }

  @override
  String get homeAwaitingReview => 'Review';

  @override
  String homeTrialEnds(String name, int days) {
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
  String get homeKeepIt => 'Keep it';

  @override
  String get homeViewSubscription => 'View';

  @override
  String homeTrialSavings(String amount) {
    return 'Cancel before it charges to save $amount a year';
  }

  @override
  String homeKept(String name, String date) {
    return 'Keeping $name. The first charge is on $date.';
  }

  @override
  String get homeSubscriptions => 'Subscriptions';

  @override
  String get homeTabActive => 'Active';

  @override
  String get homeTabTrials => 'Trial';

  @override
  String get homeTabCancelled => 'Cancelled';

  @override
  String get homeSortTitle => 'Sort by';

  @override
  String get homeSortDue => 'Next payment';

  @override
  String get homeSortPrice => 'Price';

  @override
  String get homeSortName => 'Name';

  @override
  String homeSortLabel(String by) {
    return 'Sort by $by';
  }

  @override
  String homeCancelledOn(String date) {
    return 'Cancelled $date';
  }

  @override
  String get homeTrialBadge => 'Trial';

  @override
  String get homeEmptyActive => 'No active subscriptions.';

  @override
  String get homeEmptyTrials => 'No trials right now.';

  @override
  String get homeEmptyCancelled => 'Nothing cancelled yet.';

  @override
  String get homeTrialsNote =>
      'Trials aren’t in your monthly total until they turn into paid subscriptions.';

  @override
  String get homeEmptyTitle => 'Add your first subscription';

  @override
  String get homeEmptyBody =>
      'Pick from 500+ services with their logos and prices — most take three taps.';

  @override
  String get homeBrowse => 'Browse services';

  @override
  String get homeAdd => 'Add subscription';

  @override
  String homePausedSince(String date) {
    return 'since $date';
  }

  @override
  String homePausesOn(String date) {
    return 'Pauses $date';
  }

  @override
  String get homeAutoBadge => 'Auto';

  @override
  String homeMoreLabels(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count more labels',
      one: '1 more label',
    );
    return '$_temp0';
  }

  @override
  String get homeFilter => 'Filter';

  @override
  String homeFilterButtonLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Filter, $count selected',
      one: 'Filter, 1 selected',
      zero: 'Filter',
    );
    return '$_temp0';
  }

  @override
  String get homeFilterReset => 'Reset';

  @override
  String get homeFilterStatus => 'Status';

  @override
  String get homeFilterCategory => 'Category';

  @override
  String get homeFilterLabels => 'Labels';

  @override
  String get homeFilterPayment => 'Payment method';

  @override
  String get homeFilterRemember =>
      'Subnest remembers your filter and sort order next time.';

  @override
  String homeFilterShow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count subscriptions',
      one: 'Show 1 subscription',
      zero: 'No subscriptions match',
    );
    return '$_temp0';
  }

  @override
  String homeFilterChipLabel(String name) {
    return 'Label: $name';
  }

  @override
  String get homeFilterClear => 'Clear';

  @override
  String homeFilterRemove(String name) {
    return 'Remove filter $name';
  }

  @override
  String get homeEmptyFiltered => 'No subscriptions match this filter.';

  @override
  String homeBudgetUsed(int percent) {
    return '$percent% used';
  }

  @override
  String homeAutoAddedScan(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count from your screenshot',
      one: 'Added 1 from your screenshot',
    );
    return '$_temp0';
  }

  @override
  String homeAutoAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Added $count automatically',
      one: 'Added 1 automatically',
    );
    return '$_temp0';
  }

  @override
  String homeAutoConfirmed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Confirmed $count payments automatically',
      one: 'Confirmed 1 payment automatically',
    );
    return '$_temp0';
  }

  @override
  String get homeUndo => 'Undo';

  @override
  String get homeUndone => 'Undone';

  @override
  String get homeCostMonthly => 'Monthly cost';

  @override
  String get homeCostYearly => 'Yearly cost';

  @override
  String homeDeltaVs(String amount, String period) {
    return '$amount vs $period';
  }

  @override
  String homeDeltaUpLabel(String amount, String period) {
    return 'Up $amount compared with $period';
  }

  @override
  String homeDeltaDownLabel(String amount, String period) {
    return 'Down $amount compared with $period';
  }

  @override
  String homeDeltaSame(String period) {
    return 'Same as $period';
  }

  @override
  String get homeFirstMonth => 'First month — no comparison yet';

  @override
  String homeCostActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active subscriptions',
      one: '1 active subscription',
    );
    return '$_temp0';
  }

  @override
  String homeCostPerDay(String amount) {
    return '$amount a day';
  }

  @override
  String homeCostYearSub(String year, String amount) {
    return '$year · $amount a month';
  }

  @override
  String get homeCostNone => 'No subscriptions yet';

  @override
  String get homePaid => 'Paid';

  @override
  String get homeStillToPay => 'Still to pay';

  @override
  String homeCashLabel(String paid, String due) {
    return 'Paid $paid, still to pay $due';
  }

  @override
  String homeRange(String from, String to) {
    return '$from to $to';
  }

  @override
  String homeColumnLabel(String month, String amount) {
    return '$month: $amount. Opens Insights for this month';
  }

  @override
  String get homeInfoButton => 'How this is calculated';

  @override
  String get homeInfoTitle => 'How the numbers work';

  @override
  String get homeInfoMonthlyBody =>
      'Every subscription active this month, spread evenly: a yearly plan counts as 1/12 each month. A trial counts from its first paid month; a pause stops it from the month after.';

  @override
  String get homeInfoCashTitle => 'Paid · Still to pay';

  @override
  String get homeInfoCashBody =>
      'The real money leaving this month: payments you confirmed, plus renewals still ahead and periods waiting for you. A yearly plan renewing this month counts in full.';

  @override
  String get homeInfoApproxTitle => 'Why ≈';

  @override
  String get homeInfoApproxBody =>
      'Other currencies are converted at today’s rate and rounded per line, so the lines always add up to the total.';

  @override
  String get homeInfoNote =>
      'That’s why Paid + Still to pay can differ from the monthly cost.';

  @override
  String get homeInfoGotIt => 'Got it';

  @override
  String homeTrialThenOn(String price, String date) {
    return 'Then $price on $date';
  }

  @override
  String homeNoticeTitle(String name) {
    return '$name changed its price';
  }

  @override
  String homeNoticeShare(String before, String after, String date) {
    return 'Your share goes from $before to $after, from the $date renewal.';
  }

  @override
  String homeNoticeFrom(String date) {
    return 'From the $date renewal. Past payments stay as they were.';
  }

  @override
  String get homeNoticeReference => 'Reference price — check it';

  @override
  String get homeNoticeUpdate => 'Update';

  @override
  String get homeNoticeKeep => 'Keep old price';

  @override
  String homeNoticeUpdated(String name, String price, String date) {
    return '$name: $price from $date';
  }

  @override
  String homeNoticeKept(String name, String price) {
    return 'Keeping $name at $price';
  }

  @override
  String get homeNoticeStale =>
      'The price was already changed — nothing updated';

  @override
  String get homeUpcomingTitle => 'Upcoming payments';

  @override
  String get homeSeeAll => 'See all';

  @override
  String homeNext30(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count charges',
      one: '1 charge',
    );
    return 'Next 30 days: $amount in $_temp0';
  }

  @override
  String get homeNext30None => 'Nothing due in the next 30 days';

  @override
  String homeDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days left',
      one: 'Tomorrow',
      zero: 'Today',
    );
    return '$_temp0';
  }

  @override
  String homeFirstChargeWhen(String when) {
    return 'First charge · $when';
  }

  @override
  String homeMarkPaid(String name) {
    return 'Mark $name paid';
  }

  @override
  String get homeBudgetTitle => 'Budget';

  @override
  String homeBudgetOf(String spent, String limit) {
    return '$spent of $limit';
  }

  @override
  String homeBudgetOver(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count categories over budget: $names',
      one: '1 category over budget: $names',
    );
    return '$_temp0';
  }

  @override
  String get homeTabPaused => 'Paused';

  @override
  String get homeEmptyPaused =>
      'Nothing paused. Pause a subscription from its detail page — it stops counting from its next due date.';

  @override
  String get homeSortButton => 'Sort';

  @override
  String get homeSortRecent => 'Recently added';

  @override
  String homeSavingYear(String amount) {
    return 'You’re saving $amount a year';
  }

  @override
  String get homeRise => 'Price went up';

  @override
  String get homeSearchYours => 'Your subscriptions';

  @override
  String get homeSearchLibrary => 'Add from the library';

  @override
  String get homeSearchCancel => 'Cancel';

  @override
  String get insightsModeMonth => 'Month';

  @override
  String get insightsModeYear => 'Year';

  @override
  String insightsPrevious(String mode) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'year': 'Previous year',
      'other': 'Previous month',
    });
    return '$_temp0';
  }

  @override
  String insightsNext(String mode) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'year': 'Next year',
      'other': 'Next month',
    });
    return '$_temp0';
  }

  @override
  String get insightsProjected => 'Projected';

  @override
  String insightsCostOfMonth(String name, String number) {
    return 'Cost of $name';
  }

  @override
  String insightsCostOfYear(String year) {
    return 'Cost in $year';
  }

  @override
  String insightsVsMonth(String name, String number) {
    return 'vs $name';
  }

  @override
  String insightsVsYear(String year) {
    return 'vs $year';
  }

  @override
  String insightsSameMonth(String name, String number) {
    return 'Same as $name';
  }

  @override
  String insightsSameYear(String year) {
    return 'Same as $year';
  }

  @override
  String insightsChangeLabel(String direction, String amount, String vs) {
    String _temp0 = intl.Intl.selectLogic(direction, {
      'up': 'Up $amount $vs',
      'down': 'Down $amount $vs',
      'other': '$vs',
    });
    return '$_temp0';
  }

  @override
  String insightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscriptions',
      one: '1 subscription',
    );
    return '$_temp0';
  }

  @override
  String insightsPerDay(String amount) {
    return '$amount a day';
  }

  @override
  String insightsPerMonth(String amount) {
    return '$amount a month';
  }

  @override
  String get insightsHowCalculated => 'How this is calculated';

  @override
  String get insightsPaid => 'Paid';

  @override
  String get insightsStillToPay => 'Still to pay';

  @override
  String get insightsNotPaid => 'Not paid';

  @override
  String insightsCashLabel(String paid, String due) {
    return 'Paid $paid, still to pay $due';
  }

  @override
  String insightsCashLabelPast(String paid, String due) {
    return 'Paid $paid, not paid $due';
  }

  @override
  String insightsNothingInMonth(String name, String number) {
    return 'No subscription was being paid in $name.';
  }

  @override
  String insightsNothingInYear(String year) {
    return 'No subscription was being paid in $year.';
  }

  @override
  String insightsMissingRates(String currencies) {
    return 'Amounts in $currencies aren’t included — no exchange rate yet.';
  }

  @override
  String get insightsInfoTitle => 'How the numbers work';

  @override
  String get insightsInfoMonthlyTitle => 'Monthly cost';

  @override
  String get insightsInfoMonthlyBody =>
      'Every subscription active this month, spread evenly: a yearly plan counts as 1/12 each month. A trial counts from its first paid month; a pause stops it from the month after.';

  @override
  String get insightsInfoCashTitle => 'Paid · Still to pay';

  @override
  String get insightsInfoCashBody =>
      'The real money leaving this month: payments you confirmed, plus renewals still ahead and periods waiting for you. A yearly plan renewing this month counts in full.';

  @override
  String get insightsInfoApproxTitle => 'Why ≈';

  @override
  String get insightsInfoApproxBody =>
      'Other currencies are converted at today’s rate and rounded per line, so the lines always add up to the total.';

  @override
  String get insightsInfoNote =>
      'That’s why Paid + Still to pay can differ from the monthly cost.';

  @override
  String get insightsInfoOk => 'Got it';

  @override
  String get insightsBars12 => '12 months';

  @override
  String insightsBarsYear(String year) {
    return 'Each month of $year';
  }

  @override
  String get insightsTapBar => 'Tap a bar';

  @override
  String get insightsLegendMonthly => 'Monthly cost';

  @override
  String insightsBarLabel(String month, String amount, String projected) {
    String _temp0 = intl.Intl.selectLogic(projected, {
      'yes': ', projected',
      'other': '',
    });
    return '$month: $amount$_temp0';
  }

  @override
  String insightsChartLabel(String from, String to) {
    return 'Monthly cost, $from to $to';
  }

  @override
  String get insightsByCategory => 'By category';

  @override
  String insightsSliceLabel(String category, String amount, int percent) {
    return '$category: $amount, $percent%';
  }

  @override
  String get insightsTop => 'Most expensive';

  @override
  String get insightsShareOfMonth => 'share of the month';

  @override
  String get insightsShareOfYear => 'share of the year';

  @override
  String get insightsRises => 'Price rises';

  @override
  String get insightsRisesPerMonth => 'more a month than a year ago';

  @override
  String insightsRisesYearly(String amount, String name) {
    return 'That’s $amount a year · $name changed the most';
  }

  @override
  String get insightsRisesEmpty =>
      'No subscription got more expensive in the last 12 months.';

  @override
  String insightsRiseLabel(String name, String from, String to, String delta) {
    return '$name: $from to $to, $delta a month';
  }

  @override
  String insightsReview(String name) {
    return 'Review $name';
  }

  @override
  String get insightsNext12 => 'Next 12 months';

  @override
  String get insightsForecastProjected => 'Projected';

  @override
  String get insightsLast12 => 'Last 12 months';

  @override
  String insightsForecastChange(String amount) {
    return '$amount a year compared with the last 12 months';
  }

  @override
  String get insightsForecastPartial =>
      'Your recorded payments don’t cover the whole last 12 months yet, so this comparison is rough.';

  @override
  String get insightsForecastNew => 'New this year';

  @override
  String get insightsForecastRises => 'Price rises';

  @override
  String get insightsForecastOther => 'Other';

  @override
  String get insightsViewList => 'View as list';

  @override
  String get insightsComingUp => 'Coming up';

  @override
  String get insightsWeeks13 => '13 weeks';

  @override
  String insightsWeekShort(int week) {
    return 'W$week';
  }

  @override
  String insightsWeekLabel(int week, String amount) {
    return 'Week $week: $amount';
  }

  @override
  String insightsBiggest(String when, String amount) {
    return 'Biggest: $when · $amount';
  }

  @override
  String insightsRenews(String name) {
    return '($name renews)';
  }

  @override
  String get insightsNothingAhead => 'Nothing expected in this time.';

  @override
  String get insightsBudgets => 'Budgets';

  @override
  String get insightsEdit => 'Edit';

  @override
  String insightsBudgetLabel(
    String category,
    String spent,
    String limit,
    String over,
  ) {
    String _temp0 = intl.Intl.selectLogic(over, {
      'yes': ', over budget',
      'other': '',
    });
    return '$category: $spent of $limit$_temp0';
  }

  @override
  String insightsSavingTitle(String amount) {
    return 'You’re saving $amount a year';
  }

  @override
  String insightsSavingBy(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'by cancelling $count subscriptions',
      one: 'by cancelling 1 subscription',
    );
    return '$_temp0';
  }

  @override
  String insightsNotWorthHint(int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Dropping the $count you marked “Not worth it” would save $amount more a year.',
      one:
          'Dropping the one you marked “Not worth it” would save $amount more a year.',
    );
    return '$_temp0';
  }

  @override
  String insightsOverlapVideo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You pay for $count video services — do you need all of them?',
      two: 'You pay for 2 video services — do you need both?',
    );
    return '$_temp0';
  }

  @override
  String insightsOverlapMusic(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You pay for $count music services — do you need all of them?',
      two: 'You pay for 2 music services — do you need both?',
    );
    return '$_temp0';
  }

  @override
  String insightsCategoryTitle(String category, String period) {
    return '$category · $period';
  }

  @override
  String insightsCategoryShare(int count, int percent, String period) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscriptions',
      one: '1 subscription',
    );
    return '$_temp0 · $percent% of $period';
  }

  @override
  String insightsPauseNote(String name, String period, String date) {
    return '$name still counts in $period — its pause starts on $date.';
  }

  @override
  String insightsForecastCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count expected charges from real due dates',
      one: '1 expected charge from real due dates',
    );
    return '$_temp0';
  }

  @override
  String get insightsEmptyTitle => 'Add subscriptions to see insights';

  @override
  String get insightsEmptyBody =>
      'Monthly cost, categories, price rises and the next 12 months show up here.';

  @override
  String get insightsEmptyAction => 'Browse services';

  @override
  String get manageCategoriesTitle => 'Categories';

  @override
  String get manageLabelsTitle => 'Labels';

  @override
  String get managePaymentMethodsTitle => 'Payment methods';

  @override
  String get manageBudgetsTitle => 'Budget';

  @override
  String manageSubCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscriptions',
      one: '1 subscription',
      zero: 'No subscriptions',
    );
    return '$_temp0';
  }

  @override
  String get manageCategoriesIntro =>
      'Drag to reorder. Colours are used in charts and filters.';

  @override
  String get manageNewCategory => 'New category';

  @override
  String get manageEditCategory => 'Edit category';

  @override
  String get manageName => 'Name';

  @override
  String get manageNameRequired => 'Enter a name';

  @override
  String get manageColour => 'Colour';

  @override
  String get manageIcon => 'Icon';

  @override
  String get manageDeleteCategory => 'Delete category';

  @override
  String manageDeleteTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String manageDeleteMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscriptions use it.',
      one: '1 subscription uses it.',
    );
    return '$_temp0 Move them to:';
  }

  @override
  String get manageDeleteUnusedBody => 'No subscription uses it.';

  @override
  String get manageMoveAndDelete => 'Move and delete';

  @override
  String manageMoveCategory(String name) {
    return 'Move to $name';
  }

  @override
  String get manageReorderHint => 'Drag to reorder';

  @override
  String get manageLabelsIntro =>
      'Labels cut across categories — a subscription can have several.';

  @override
  String get manageNewLabel => 'New label';

  @override
  String get manageEditLabel => 'Edit label';

  @override
  String get manageDeleteLabel => 'Delete label';

  @override
  String get manageDeleteLabelBody =>
      'It’s taken off every subscription that has it. The subscriptions stay.';

  @override
  String get managePaymentMethodsIntro =>
      'Names only — Subnest never connects to a bank or card.';

  @override
  String get manageAddPaymentMethod => 'Add payment method';

  @override
  String get manageEditPaymentMethod => 'Edit payment method';

  @override
  String get manageDeletePaymentMethod => 'Delete payment method';

  @override
  String get manageDeletePaymentMethodBody =>
      'Subscriptions that use it are left without a payment method.';

  @override
  String get manageBudgetTotal => 'Monthly budget, all subscriptions';

  @override
  String manageBudgetUsed(int percent, String amount) {
    return '$percent% used this month · $amount';
  }

  @override
  String get manageBudgetPerCategory => 'Per category · optional';

  @override
  String manageBudgetThisMonth(String amount) {
    return '$amount this month';
  }

  @override
  String get manageBudgetSet => 'Set';

  @override
  String get manageBudgetNote =>
      'Budgets compare against the monthly cost. Going over turns the bar red — no notifications.';

  @override
  String manageBudgetFor(String name) {
    return 'Budget · $name';
  }

  @override
  String get manageBudgetAmount => 'Per month';

  @override
  String get manageBudgetRemove => 'Remove budget';

  @override
  String get manageBudgetInvalid => 'Enter an amount above 0';

  @override
  String get manageBudgetTotalNone => 'No monthly budget yet';

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
  String get notificationsBackupFailed =>
      'Backup failed — open Subnest to check';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String onboardingStep(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingLanguageTitle => 'Choose your language';

  @override
  String get onboardingLanguageHint =>
      'You can change it later in Settings. The whole app switches at once.';

  @override
  String get onboardingLanguageEnglishSub => 'English';

  @override
  String get onboardingLanguageVietnameseSub => 'Vietnamese';

  @override
  String get onboardingWelcomeTitle => 'All your subscriptions, one nest';

  @override
  String get onboardingBenefitRemind => 'Reminders before you’re charged';

  @override
  String get onboardingBenefitRemindSub =>
      'Before renewals and before trials end.';

  @override
  String get onboardingBenefitTotal => 'Know what each month really costs';

  @override
  String get onboardingBenefitTotalSub =>
      'Every price shows its cycle — no more guessing.';

  @override
  String get onboardingBenefitPrivate => 'Your data stays on this phone';

  @override
  String get onboardingBenefitPrivateSub =>
      'No account, no bank link, no tracking.';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingCurrencyTitle => 'Your main currency';

  @override
  String get onboardingCurrencyHint =>
      'Totals are added up in it. Each subscription keeps its own currency.';

  @override
  String get onboardingCurrencyChange => 'Choose another currency…';

  @override
  String get onboardingCurrencyRatesNote =>
      'Exchange rates update once a day when you’re online. You can set your own in Settings.';

  @override
  String get onboardingCurrencySheetTitle => 'Main currency';

  @override
  String get onboardingCurrencySearch => 'Search currency or country';

  @override
  String get onboardingPickTitle => 'What do you pay for?';

  @override
  String get onboardingPickSearch => 'Search 500+ services';

  @override
  String onboardingPickSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
      one: '1 selected',
      zero: 'Nothing selected yet',
    );
    return '$_temp0';
  }

  @override
  String onboardingPickNoMatch(String name) {
    return 'No service called “$name”. You can add it later with +.';
  }

  @override
  String get onboardingPickEdit => 'Price & cycle';

  @override
  String onboardingPickEditLabel(String name) {
    return 'Edit price and cycle of $name';
  }

  @override
  String get onboardingLater => 'Later';

  @override
  String get onboardingQuickPlan => 'Plan';

  @override
  String get onboardingQuickPrice => 'Price';

  @override
  String get onboardingQuickCycle => 'Billing cycle';

  @override
  String get onboardingQuickRemove => 'Don’t add it';

  @override
  String get onboardingRemindersTitle => 'A heads-up before every charge';

  @override
  String onboardingRemindersBody(String time) {
    return '3 days before a renewal or a trial ending, at $time. You can change both later.';
  }

  @override
  String get onboardingDemoNow => 'now';

  @override
  String get onboardingDemoAgo => '2d ago';

  @override
  String onboardingDemoRenews(String name, String price) {
    return '$name renews in 3 days — $price';
  }

  @override
  String onboardingDemoTrial(String name) {
    return 'Your $name trial ends in 3 days.';
  }

  @override
  String get onboardingDemoLabel => 'Example reminders';

  @override
  String get onboardingEnableReminders => 'Turn on reminders';

  @override
  String get onboardingNoThanks => 'No thanks';

  @override
  String get scanTitle => 'Scan screenshots';

  @override
  String get scanPlaceholder => 'Coming soon';

  @override
  String get securitySection => 'Security';

  @override
  String get securityPinLock => 'PIN lock';

  @override
  String get securityPinWarning =>
      'If you forget the PIN, the only way back in is to delete all data in the app.';

  @override
  String get securityEnterPin => 'Enter your PIN';

  @override
  String get securityNewPin => 'Choose a 4-digit PIN';

  @override
  String get securityConfirmPin => 'Enter it again';

  @override
  String get securityPinMismatch => 'The PINs don’t match. Choose one again.';

  @override
  String get securityWrongPin => 'Wrong PIN. Try again.';

  @override
  String get securityForgotPin => 'Forgot PIN?';

  @override
  String get securityForgotPinTitle => 'Forgot your PIN?';

  @override
  String get securityForgotPinBody =>
      'Subnest has no account and no server, so the PIN can’t be reset. The only way back in is to erase all data on this phone and start fresh. A backup file can be restored afterwards.';

  @override
  String securityKeypadDigit(String digit) {
    return 'Digit $digit';
  }

  @override
  String get securityKeypadBackspace => 'Delete last digit';

  @override
  String securityPinProgress(int count) {
    return '$count of 4 digits entered';
  }

  @override
  String get securityPrivacyScreen => 'Hide content in app switcher';

  @override
  String get securityPrivacyScreenNote => 'Also blocks screenshots';

  @override
  String get securityPrivacyScreenNoteIos =>
      'Hides content in the app switcher. iPhone doesn’t let apps block screenshots.';

  @override
  String get securityTryAgain => 'Try again';

  @override
  String get securityPinSetNote =>
      'You’ll enter it when Subnest opens, and after 1 minute away.';

  @override
  String get securityPinOffNote => '4 digits, asked when Subnest opens';

  @override
  String get securityPinOnNote => 'On · asks after 1 minute away';

  @override
  String get securityChangePin => 'Change PIN';

  @override
  String get securityPinChanged => 'PIN changed';

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
    return 'Offline · rates from $ago';
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
  String get settingsNotificationsOn => 'Allowed';

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
  String get settingsRemindBefore => 'Remind me before a payment';

  @override
  String settingsRemindChoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: 'On the day',
    );
    return '$_temp0';
  }

  @override
  String get settingsRemindTrialNote =>
      'Pick any combination. Trials get the same reminders before they end.';

  @override
  String get settingsReminderTimeShort => 'Time';

  @override
  String get settingsRemindersNote =>
      'Each subscription can override these on its edit screen. PIN lock doesn’t change what notifications say.';

  @override
  String get settingsPreview => 'Preview';

  @override
  String get settingsPreviewSampleName => 'Your subscription';

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
  String get settingsSectionAppearance => 'Appearance & language';

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
  String get settingsExportCsv => 'Export CSV';

  @override
  String get settingsExportCsvHint =>
      'Subscriptions and payments, for spreadsheets';

  @override
  String get settingsExportCsvLong => 'Subscriptions and payments as .csv';

  @override
  String get settingsExported => 'Saved — keep it somewhere safe';

  @override
  String get settingsExportFailed =>
      'Couldn’t create the file. Please try again.';

  @override
  String get settingsRestore => 'Restore';

  @override
  String get settingsRestoreHint => 'Replaces everything on this phone';

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
  String get settingsRestoreTitle => 'Replace all data?';

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
  String get settingsRestoreReplaceAction => 'Replace and restore';

  @override
  String get settingsRestoreReplaceNote =>
      'Everything on this phone — subscriptions, payments, lists and settings — will be replaced by this backup. Automatic backup stays as it is.';

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
  String get settingsTerms => 'Terms';

  @override
  String get settingsLicenses => 'Licences';

  @override
  String get settingsLogosTitle => 'Service logos';

  @override
  String get settingsLogosOwnership =>
      'Service names and logos belong to their respective owners.';

  @override
  String get settingsRateApp => 'Rate the app';

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
  String get settingsSectionData => 'Data';

  @override
  String get settingsDataNote =>
      'Your data stays on this phone. Back it up before changing phones.';

  @override
  String get settingsExportBackup => 'Export backup';

  @override
  String get settingsExportBackupHint =>
      'Encrypted .subnest file to restore later';

  @override
  String get settingsAutoBackup => 'Automatic backup';

  @override
  String get settingsAutoBackupNote =>
      'Backs up once a day to a folder you choose. Uploading to Google Drive or Dropbox is done by that app.';

  @override
  String get settingsAutoBackupNoteIos =>
      'Subnest only writes files to the folder you choose in the Files app, for example in iCloud Drive.';

  @override
  String get settingsAutoBackupRunsOnOpenIos =>
      'iPhone does not let closed apps run on their own. At the time you chose, Subnest sends a notification; tap it or open the app to back up. If the time is missed, the backup catches up when you open the app, at most once a day.';

  @override
  String settingsAutoBackupFolder(String name) {
    return 'Folder: $name';
  }

  @override
  String get settingsAutoBackupFolderUnknown => 'Chosen folder';

  @override
  String get settingsAutoBackupLocalFolderWarningIos =>
      'This folder may be stored only on this iPhone. If so, losing the phone means losing these files. To keep them safe, choose a folder in iCloud Drive or Google Drive.';

  @override
  String settingsAutoBackupLast(String time) {
    return 'Last: $time';
  }

  @override
  String settingsAutoBackupLastUnchanged(String checked, String last) {
    return 'Last: $last · checked $checked, no changes';
  }

  @override
  String get settingsAutoBackupNever => 'No backup yet';

  @override
  String settingsAutoBackupFailedAt(String time, String error) {
    return 'Last try $time: $error';
  }

  @override
  String get settingsAutoBackupErrorFolder =>
      'folder unavailable — tap Folder to choose it again';

  @override
  String get settingsAutoBackupErrorOther => 'backup failed';

  @override
  String settingsAutoBackupNextToday(String time) {
    return 'Next: today, $time';
  }

  @override
  String settingsAutoBackupNextTomorrow(String time) {
    return 'Next: tomorrow, $time';
  }

  @override
  String get settingsAutoBackupNextSoon =>
      'Due now — runs when you leave the app';

  @override
  String get settingsAutoBackupNextSoonIos =>
      'Due now — runs when you open the app';

  @override
  String get settingsAutoBackupNow => 'Back up now';

  @override
  String get settingsAutoBackupChooseFolder => 'Choose folder';

  @override
  String get settingsAutoBackupTime => 'Backup time';

  @override
  String get settingsAutoBackupTurnOn => 'Turn on automatic backup';

  @override
  String get settingsAutoBackupOffDone => 'Automatic backup turned off';

  @override
  String get settingsAutoBackupDone => 'Backup saved';

  @override
  String get settingsAutoBackupBusy => 'A backup is already running';

  @override
  String get settingsAutoBackupPickFailed => 'Couldn’t open the folder picker';

  @override
  String get settingsAutoBackupPasswordTitle =>
      'Password for automatic backups';

  @override
  String get settingsAutoBackupPasswordWarning =>
      'If you forget this password, the backup cannot be opened. Subnest cannot recover it.';

  @override
  String get settingsAutoBackupNotifyTitleIos => 'Allow backup reminders?';

  @override
  String get settingsAutoBackupNotifyBodyIos =>
      'Subnest sends one reminder at your backup time. Tapping it backs up your data.';

  @override
  String get settingsAutoBackupNotifyDeniedIos =>
      'Notifications are off. Automatic backup still runs when you open the app.';

  @override
  String get settingsAutoBackupNotificationBody =>
      'Time to back up your subscriptions.';

  @override
  String get settingsBackupPassword => 'Password';

  @override
  String get settingsBackupPasswordConfirm => 'Repeat password';

  @override
  String get settingsBackupPasswordTooShort => 'Use at least 6 characters';

  @override
  String get settingsBackupPasswordMismatch => 'Passwords don’t match';

  @override
  String get settingsBackupPasswordWarning =>
      'Without this password the file cannot be opened. Keep it somewhere safe.';

  @override
  String get settingsBackupProtect => 'Protect with a password';

  @override
  String get settingsBackupExportNote =>
      'The file holds everything: subscriptions, payments, categories and settings.';

  @override
  String get settingsBackupExportAction => 'Export';

  @override
  String get settingsBackupWorking => 'Working…';

  @override
  String get settingsBackupEnterPasswordTitle => 'Enter backup password';

  @override
  String get settingsBackupEnterPasswordBody =>
      'This backup is encrypted. Enter the password you set when exporting it.';

  @override
  String get settingsBackupWrongPassword => 'Wrong password';

  @override
  String get settingsBackupOpen => 'Open';

  @override
  String get settingsDeleteAll => 'Erase all data';

  @override
  String get settingsDeleteAllHint => 'Everything, like a new install';

  @override
  String get settingsDeleteAllTitle => 'Erase all data?';

  @override
  String get settingsDeleteAllConfirm =>
      'Every subscription, payment, price history, label and setting on this phone is deleted. Subnest goes back to the first-run screens. Automatic backup files in your folder are kept.';

  @override
  String get settingsDeleteAllConfirm2 => 'This can’t be undone.';

  @override
  String get settingsCannotUndo => 'This cannot be undone';

  @override
  String get settingsDeleteEverything => 'Erase everything';

  @override
  String get settingsDelete => 'Delete';

  @override
  String get settingsDeleteAllDone => 'All data erased';

  @override
  String get settingsThemeNote =>
      'System follows your phone’s light or dark mode.';

  @override
  String get settingsLanguageNote =>
      'The whole app switches right away. Dates and amounts follow the language.';

  @override
  String get settingsHideTabBar => 'Hide tab bar when scrolling';

  @override
  String get settingsSectionOrganize => 'Organize';

  @override
  String settingsBudgetValue(String amount) {
    return '$amount/mo';
  }

  @override
  String get settingsBudgetNotSet => 'Not set';

  @override
  String get settingsSectionAutomation => 'Automation';

  @override
  String get settingsScan => 'Screenshot scan';

  @override
  String get settingsScanHint => 'Add from store pages and receipts';

  @override
  String get settingsBankNotifications => 'Bank & wallet notifications';

  @override
  String get settingsSoon => 'Soon';

  @override
  String get settingsAutoBackupOffNote =>
      'Off — your data lives only on this phone';

  @override
  String get settingsAutoBackupFolderLabel => 'Folder';

  @override
  String get settingsAutoBackupTimeLabel => 'Time';

  @override
  String settingsAutoBackupDaily(String time) {
    return '$time every day';
  }

  @override
  String get settingsAutoBackupPasswordLabel => 'Password';

  @override
  String get settingsAutoBackupKeepsLabel => 'Keeps';

  @override
  String get settingsAutoBackupKeepsValue => '2 newest files';

  @override
  String get settingsAutoBackupIntro =>
      'Once a day Subnest saves an encrypted .subnest file to a folder you choose — on this phone, an SD card or a synced folder like Google Drive.';

  @override
  String get settingsAutoBackupSetupTime => 'Time';

  @override
  String get settingsAutoBackupKeep => 'Keep';

  @override
  String get settingsAutoBackupKeepValue => '2 newest';

  @override
  String get settingsAutoBackupChoose => 'Choose…';

  @override
  String get settingsAutoBackupPasswordRule => 'At least 6 characters';

  @override
  String get settingsAutoBackupWriteDownTitle => 'Write the password down';

  @override
  String get settingsAutoBackupWriteDownBody =>
      'Without it the backup can’t be opened — there’s no reset.';

  @override
  String get settingsAutoBackupFolderNeeded => 'Choose a folder first';

  @override
  String get settingsBackupNow => 'Back up now';

  @override
  String get settingsBackupNowHint =>
      'A .subnest file, with or without a password';

  @override
  String settingsBackupFileMeta(int subs, int payments, String size) {
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
    return '$_temp0 · $_temp1 · $size';
  }

  @override
  String get settingsBackupProtectHint =>
      'Recommended if you save it to the cloud';

  @override
  String get settingsBackupSave => 'Save file…';

  @override
  String get settingsRestoreValid => 'Valid';

  @override
  String settingsRestoreProtected(String size) {
    return 'Password-protected · $size';
  }

  @override
  String get settingsRestoreInFile => 'In this file';

  @override
  String get settingsRestoreSubs => 'Subscriptions';

  @override
  String get settingsRestorePayments => 'Payments';

  @override
  String get settingsRestorePriceChanges => 'Price changes';

  @override
  String get settingsRestoreSettings => 'Settings and labels';

  @override
  String get settingsRestoreIncluded => 'Included';

  @override
  String get settingsRestoreWarnTitle => 'Restoring replaces everything';

  @override
  String get settingsRestoreWarnBody =>
      'What’s on this phone now is removed and the file’s data takes its place.';

  @override
  String get settingsRestoreHasPassword => 'This backup has a password';

  @override
  String get settingsRestoreUnlock => 'Unlock and restore';

  @override
  String settingsRestoreReplaceBody(int current, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      current,
      locale: localeName,
      other: '$current current subscriptions are',
      one: '1 current subscription is',
      zero: 'data',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscriptions',
      one: '1 subscription',
    );
    return 'Your $_temp0 replaced by the $_temp1 in this backup.';
  }

  @override
  String settingsDeleteAllTypeTitle(String word) {
    return 'Type $word to confirm';
  }

  @override
  String get settingsDeleteAllWord => 'ERASE';

  @override
  String settingsVersionValue(String version) {
    return 'Version $version';
  }

  @override
  String get settingsLibrary => 'Service library';

  @override
  String settingsLibraryValue(String ago, int count) {
    return 'Updated $ago · $count services';
  }

  @override
  String settingsLibraryCount(int count) {
    return '$count services';
  }

  @override
  String get settingsAgoToday => 'today';

  @override
  String get settingsPriceLists => 'Price lists';

  @override
  String get settingsPriceListsValue => 'US + Vietnam';

  @override
  String get settingsAutomationHero => 'Let Subnest find your subscriptions';

  @override
  String get settingsAutomationHeroBody =>
      'Everything is read on this phone. Nothing is uploaded.';

  @override
  String get settingsAutomationScanHint =>
      'Google Play / App Store pages, receipts';

  @override
  String get settingsOpen => 'Open';

  @override
  String get settingsGmailHint => 'Receipts and renewal emails';

  @override
  String get settingsAutomationFound => 'When something is found';

  @override
  String get settingsAutoAdd => 'Add new ones automatically';

  @override
  String get settingsAutoConfirm => 'Confirm periods automatically';

  @override
  String get settingsAutomationNote =>
      'Every automatic change is tagged Auto and has Undo.';

  @override
  String get settingsEarlyAccessCta => 'Get early access';

  @override
  String get settingsProBody =>
      'Finds and confirms subscriptions for you. Adding them by hand stays free, always.';

  @override
  String get settingsProNow => 'Now';

  @override
  String get settingsProUndo => 'Undo on every change';

  @override
  String get settingsEarlyAccessTitle => 'Early access';

  @override
  String get settingsEarlyAccessBody =>
      'Join now and we’ll tell you the price before Pro starts charging. Nothing is billed without asking you.';

  @override
  String get settingsJoinEarlyAccess => 'Join early access';

  @override
  String get settingsNotNow => 'Not now';

  @override
  String get settingsEarlyAccessSubject => 'Subnest Pro early access';

  @override
  String settingsWhenToday(String time) {
    return 'today, $time';
  }

  @override
  String settingsWhenYesterday(String time) {
    return 'yesterday, $time';
  }

  @override
  String get settingsBackupPasswordShow => 'Show password';

  @override
  String get settingsBackupPasswordHide => 'Hide password';

  @override
  String get subscriptionDetailEdit => 'Edit';

  @override
  String get subscriptionDetailStatusActive => 'Active';

  @override
  String subscriptionDetailStatusTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Trial · $days days left',
      one: 'Trial · 1 day left',
      zero: 'Trial · ends today',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailStatusCancelled => 'Cancelled';

  @override
  String get subscriptionDetailStatusPaused => 'Paused';

  @override
  String subscriptionDetailYourShare(String price, int count) {
    return 'Your share · plan $price ÷ $count';
  }

  @override
  String subscriptionDetailAwaitingTitle(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments need confirming, from $date',
      one: 'Payment on $date needs confirming',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailAwaitingBody =>
      'The next date waits until you say whether it was paid.';

  @override
  String get subscriptionDetailConfirm => 'Confirm';

  @override
  String subscriptionDetailTrialEnds(String date) {
    return 'Trial ends $date';
  }

  @override
  String subscriptionDetailTrialSave(String price, String yearly) {
    return 'Then $price. Cancel before to save $yearly a year.';
  }

  @override
  String get subscriptionDetailHowToCancel => 'How to cancel';

  @override
  String get subscriptionDetailKeepIt => 'Keep it';

  @override
  String subscriptionDetailSaving(String amount) {
    return 'Saving $amount a year';
  }

  @override
  String subscriptionDetailCancelledBody(String date) {
    return 'Cancelled $date. No more reminders.';
  }

  @override
  String get subscriptionDetailRestoreShort => 'Restore';

  @override
  String get subscriptionDetailRestore => 'Restore subscription';

  @override
  String subscriptionDetailRestored(String date) {
    return 'Restored. Next payment: $date.';
  }

  @override
  String subscriptionDetailPausedTitle(String date) {
    return 'Paused since $date';
  }

  @override
  String get subscriptionDetailPausedBody =>
      'No payments, no reminders, not counted.';

  @override
  String get subscriptionDetailResume => 'Resume';

  @override
  String subscriptionDetailPausesTitle(String date) {
    return 'Pauses from $date';
  }

  @override
  String get subscriptionDetailPausesBody =>
      'Still counted until then — that payment is the first one skipped.';

  @override
  String get subscriptionDetailUndo => 'Undo';

  @override
  String subscriptionDetailPauseUndone(String date) {
    return 'Pause undone. Next payment: $date.';
  }

  @override
  String subscriptionDetailNoticeTitle(String price) {
    return 'New library price: $price';
  }

  @override
  String subscriptionDetailNoticeBody(String price) {
    return 'You pay $price. Update from the next payment, or keep your price.';
  }

  @override
  String get subscriptionDetailNoticeReview => 'Review';

  @override
  String get subscriptionDetailPlanGoneTitle => 'This plan is no longer sold';

  @override
  String get subscriptionDetailPlanGoneBody =>
      'It left the library for new customers. Yours keeps its price and dates.';

  @override
  String get subscriptionDetailPlanClosedTitle =>
      'No longer sold to new customers';

  @override
  String get subscriptionDetailPlanClosedBody =>
      'Existing customers keep it. Yours keeps its price and dates.';

  @override
  String subscriptionDetailPlanRenamedTitle(String name) {
    return 'Now called $name';
  }

  @override
  String subscriptionDetailPlanRenamedBody(String old) {
    return 'The library renamed $old. Nothing changes for you.';
  }

  @override
  String get subscriptionDetailLibrary => 'Service library';

  @override
  String get subscriptionDetailLibraryGone => 'No longer sold';

  @override
  String get subscriptionDetailLibraryClosed => 'Closed to new customers';

  @override
  String get subscriptionDetailLibraryRenamed => 'Renamed';

  @override
  String get subscriptionDetailAutoTitle => 'Added automatically';

  @override
  String subscriptionDetailAutoBody(String source, String date) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'scan': 'Found in a screenshot',
      'notification': 'Found in a bank notification',
      'other': 'Found in an email',
    });
    return '$_temp0 on $date. Not yours? Remove it — it won’t be added again.';
  }

  @override
  String get subscriptionDetailAutoRemove => 'Remove';

  @override
  String subscriptionDetailAutoRemoveTitle(String name) {
    return 'Remove $name?';
  }

  @override
  String subscriptionDetailAutoRemoveBody(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'scan': 'from a screenshot',
      'notification': 'from a bank notification',
      'other': 'from an email',
    });
    return 'It was added $_temp0. Subnest will remember and won’t add it again.';
  }

  @override
  String subscriptionDetailAutoRemoved(String name) {
    return '$name removed';
  }

  @override
  String get subscriptionDetailNextPayment => 'Next payment';

  @override
  String get subscriptionDetailFirstPayment => 'First payment';

  @override
  String get subscriptionDetailWaits => 'Waiting for your confirmation';

  @override
  String get subscriptionDetailCycle => 'Billing cycle';

  @override
  String get subscriptionDetailReminders => 'Reminders';

  @override
  String get subscriptionDetailRemindOff => 'Off';

  @override
  String get subscriptionDetailCategory => 'Category';

  @override
  String get subscriptionDetailLabels => 'Labels';

  @override
  String get subscriptionDetailPaymentMethod => 'Payment method';

  @override
  String get subscriptionDetailSince => 'Since';

  @override
  String get subscriptionDetailTotalPaid => 'Total paid';

  @override
  String get subscriptionDetailWorthIt => 'Worth it?';

  @override
  String get subscriptionDetailNotes => 'Notes';

  @override
  String get subscriptionDetailPriceHistory => 'Price history';

  @override
  String get subscriptionDetailPriceNeverChanged =>
      'The price has never changed.';

  @override
  String subscriptionDetailPriceFrom(String date) {
    return 'From $date';
  }

  @override
  String get subscriptionDetailPriceNext => 'next payment';

  @override
  String get subscriptionDetailPriceSourceManual => 'You changed it';

  @override
  String get subscriptionDetailPriceSourceCatalog => 'Library update';

  @override
  String get subscriptionDetailPriceSourceBackfill => 'From past payments';

  @override
  String subscriptionDetailPriceStarted(String price) {
    return 'Started at $price';
  }

  @override
  String subscriptionDetailPriceRose(String amount) {
    return 'up $amount';
  }

  @override
  String subscriptionDetailPriceFell(String amount) {
    return 'down $amount';
  }

  @override
  String get subscriptionDetailHistory => 'Payment history';

  @override
  String get subscriptionDetailPaid => 'Paid';

  @override
  String get subscriptionDetailDidntPay => 'Didn’t pay';

  @override
  String subscriptionDetailPaidFrom(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'scan': 'From screenshot',
      'notification': 'From notification',
      'other': 'From email',
    });
    return '$_temp0';
  }

  @override
  String get subscriptionDetailAutoUndone =>
      'Payment removed — that period waits for confirmation again.';

  @override
  String subscriptionDetailNoHistory(String date) {
    return 'No payments yet — the first charge is on $date.';
  }

  @override
  String get subscriptionDetailNoHistoryCancelled => 'No payments recorded.';

  @override
  String subscriptionDetailEditPayment(String date) {
    return 'Edit payment of $date';
  }

  @override
  String subscriptionDetailConfirmPeriod(String date) {
    return 'Confirm the period of $date';
  }

  @override
  String subscriptionDetailOpens(String host) {
    return 'Opens $host account page';
  }

  @override
  String subscriptionDetailLinkFailed(String host) {
    return 'Couldn’t open $host.';
  }

  @override
  String get subscriptionDetailPause => 'Pause';

  @override
  String get subscriptionDetailMarkCancelled => 'Mark as cancelled';

  @override
  String get subscriptionDetailDelete => 'Delete subscription';

  @override
  String subscriptionDetailCancelTitle(String name) {
    return 'Mark $name as cancelled?';
  }

  @override
  String subscriptionDetailCancelBody(String amount) {
    return 'Reminders stop and $amount a year moves into your savings. You can restore it any time.';
  }

  @override
  String get subscriptionDetailNotYet => 'Not yet';

  @override
  String subscriptionDetailDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get subscriptionDetailDeleteBody =>
      'It and its payment and price history are removed for good. To stop reminders but keep the history, mark it as cancelled instead.';

  @override
  String get subscriptionDetailDeleteAction => 'Delete';

  @override
  String subscriptionDetailDeleted(String name) {
    return '$name deleted';
  }

  @override
  String subscriptionDetailPauseTitle(String name) {
    return 'Pause $name?';
  }

  @override
  String get subscriptionDetailPauseBody =>
      'Nothing is cancelled with the service — this only stops tracking.';

  @override
  String subscriptionDetailPauseNow(String date) {
    return 'Now → $date';
  }

  @override
  String get subscriptionDetailPauseNowBody =>
      'Still counted — you paid for this period';

  @override
  String get subscriptionDetailPauseFromBody =>
      'No payments, no reminders, not in totals';

  @override
  String subscriptionDetailPauseAction(String date) {
    return 'Pause from $date';
  }

  @override
  String subscriptionDetailPaused(String name, String date) {
    return '$name pauses from $date';
  }

  @override
  String subscriptionDetailResumeTitle(String name) {
    return 'Resume $name';
  }

  @override
  String get subscriptionDetailResumeAsk => 'When is the next payment?';

  @override
  String get subscriptionDetailResumeNote =>
      'Defaults to today. The cycle starts again from the date you pick.';

  @override
  String get subscriptionDetailResumeToday => 'Resume from today';

  @override
  String subscriptionDetailResumeFrom(String date) {
    return 'Resume from $date';
  }

  @override
  String subscriptionDetailResumed(String date) {
    return 'Resumed. Next payment: $date.';
  }

  @override
  String get subscriptionDetailPriceSheetTitle => 'Update the price?';

  @override
  String subscriptionDetailPriceSheetSub(String plan) {
    return '$plan · library price';
  }

  @override
  String get subscriptionDetailYouPayNow => 'You pay now';

  @override
  String get subscriptionDetailNewPrice => 'New price';

  @override
  String subscriptionDetailShareOf(String amount) {
    return 'your share $amount';
  }

  @override
  String subscriptionDetailPriceSheetNote(String date) {
    return 'Applies from the $date payment and is saved to the price history. Past payments stay as paid.';
  }

  @override
  String get subscriptionDetailReferencePrice =>
      'Reference price — check it on the provider’s page.';

  @override
  String subscriptionDetailUpdateFrom(String date) {
    return 'Update from $date';
  }

  @override
  String subscriptionDetailKeepPrice(String price) {
    return 'Keep $price';
  }

  @override
  String subscriptionDetailPriceUpdated(String date) {
    return 'New price from $date';
  }

  @override
  String subscriptionDetailPriceKept(String price) {
    return 'Keeping $price. We won’t ask about this price again.';
  }

  @override
  String get subscriptionDetailPriceStale =>
      'The price changed meanwhile — nothing was updated.';

  @override
  String subscriptionDetailCelebrateTitle(String amount) {
    return 'Nice — that’s $amount a year saved';
  }

  @override
  String subscriptionDetailCelebrateBody(String name, String host) {
    return '$name is marked as cancelled. Remember to cancel it on $host too — Subnest can’t do that for you.';
  }

  @override
  String subscriptionDetailCelebrateBodyNoHost(String name) {
    return '$name is marked as cancelled. Remember to cancel it with the provider too — Subnest can’t do that for you.';
  }

  @override
  String get subscriptionDetailTotalSaving => 'Total saving';

  @override
  String subscriptionDetailPerYear(String amount) {
    return '$amount a year';
  }

  @override
  String subscriptionDetailFromCancelled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'from $count cancelled subscriptions',
      one: 'from 1 cancelled subscription',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailDone => 'Done';

  @override
  String subscriptionDetailPaymentTitle(String date) {
    return 'Payment · $date';
  }

  @override
  String get subscriptionDetailAmountPaid => 'Amount paid';

  @override
  String subscriptionDetailWas(String old, String total) {
    return 'Was $old — saving updates Total paid to $total.';
  }

  @override
  String get subscriptionDetailAmountRequired => 'Enter the amount you paid.';

  @override
  String get subscriptionDetailPaidOn => 'Paid on';

  @override
  String get subscriptionDetailPaidWith => 'Paid with';

  @override
  String get subscriptionDetailSave => 'Save';

  @override
  String get subscriptionDetailMarkNotPaid => 'Mark as not paid';

  @override
  String get subscriptionDetailCancel => 'Cancel';

  @override
  String get subscriptionDetailPaymentUpdated => 'Payment updated';

  @override
  String get subscriptionDetailMarkedNotPaid => 'Marked as not paid';

  @override
  String get subscriptionFormAddTitle => 'New subscription';

  @override
  String get subscriptionFormEditTitle => 'Edit subscription';

  @override
  String get subscriptionFormNameHint => 'Service name';

  @override
  String get subscriptionFormNameRequired => 'Enter a name';

  @override
  String get subscriptionFormEditTile => 'Change tile';

  @override
  String subscriptionFormPlan(String name) {
    return 'Plan: $name';
  }

  @override
  String get subscriptionFormPrice => 'Price';

  @override
  String get subscriptionFormPriceAfterTrial => 'Price after trial';

  @override
  String get subscriptionFormPriceRequired => 'Price must be more than 0';

  @override
  String subscriptionFormPriceWas(String old) {
    return 'Was $old. Saving asks when the new price starts and adds it to the price history.';
  }

  @override
  String get subscriptionFormCycle => 'Billing cycle';

  @override
  String get subscriptionFormEvery => 'Every';

  @override
  String get subscriptionFormEveryCount =>
      'Number of units in one billing cycle';

  @override
  String subscriptionFormUnitDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String subscriptionFormUnitWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String subscriptionFormUnitMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    return '$_temp0';
  }

  @override
  String subscriptionFormUnitYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$_temp0';
  }

  @override
  String subscriptionFormUnitLabel(String unit) {
    return 'Cycle unit: $unit';
  }

  @override
  String get subscriptionFormChipWeekly => 'Weekly';

  @override
  String get subscriptionFormChipMonthly => 'Monthly';

  @override
  String get subscriptionFormChipQuarterly => 'Quarterly';

  @override
  String get subscriptionFormChipYearly => 'Yearly';

  @override
  String get subscriptionFormNextDue => 'Next renewal';

  @override
  String get subscriptionFormFirstCharge => 'First charge';

  @override
  String subscriptionFormThen(String dates) {
    return 'Then $dates…';
  }

  @override
  String get subscriptionFormTrial => 'Free trial';

  @override
  String get subscriptionFormTrialSub => 'Remind me before it ends';

  @override
  String get subscriptionFormTrialEnds => 'Trial ends';

  @override
  String get subscriptionFormTrialEndInvalid =>
      'Trial end can’t be in the past';

  @override
  String get subscriptionFormShared => 'Split with others';

  @override
  String get subscriptionFormSharedSub => 'Totals use your share';

  @override
  String get subscriptionFormPeople => 'People, including you';

  @override
  String get subscriptionFormYourShare => 'Your share';

  @override
  String subscriptionFormShareOf(String price, int count) {
    return '$price ÷ $count';
  }

  @override
  String get subscriptionFormCategory => 'Category';

  @override
  String get subscriptionFormReminder => 'Remind me';

  @override
  String get subscriptionFormRemindOnDay => 'On the day';

  @override
  String subscriptionFormRemindDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionFormRemindNone => 'No reminder for this subscription';

  @override
  String get subscriptionFormMore => 'More details';

  @override
  String get subscriptionFormMoreSub =>
      'Payment method, cancel link, notes, worth it?';

  @override
  String get subscriptionFormPaymentMethod => 'Payment method';

  @override
  String get subscriptionFormManageUrl => 'Cancel / manage link';

  @override
  String get subscriptionFormManageUrlFromLibrary =>
      'Filled in from the library. Opens from “How to cancel”.';

  @override
  String get subscriptionFormNotes => 'Notes';

  @override
  String get subscriptionFormAddButton => 'Add subscription';

  @override
  String get subscriptionFormSaveChanges => 'Save changes';

  @override
  String subscriptionFormPriceDialogTitle(String price) {
    return 'Use $price from the next payment?';
  }

  @override
  String subscriptionFormPriceDialogBody(String date) {
    return 'The $date payment and later ones use the new price. Your past payments stay exactly as paid, and the change is saved to the price history.';
  }

  @override
  String subscriptionFormPriceApply(String date) {
    return 'Apply from $date';
  }

  @override
  String get subscriptionFormTileTitle => 'Change icon';

  @override
  String get subscriptionFormTileColour => 'Colour';

  @override
  String subscriptionFormTileSwatch(int index) {
    return 'Colour $index';
  }

  @override
  String get subscriptionFormTileLibraryColour => 'Library colour';

  @override
  String get subscriptionFormCurrencyTitle => 'Currency for this subscription';

  @override
  String get subscriptionFormCurrencySearch => 'Search currency';

  @override
  String get subscriptionFormCurrencyUsed => 'Used by your subscriptions';

  @override
  String get subscriptionFormCurrencyAll => 'All currencies';

  @override
  String get subscriptionFormCurrencyMain => 'Main currency';

  @override
  String subscriptionFormCurrencyRate(String code, String amount) {
    return '1 $code ≈ $amount';
  }

  @override
  String subscriptionFormCurrencyNote(String code) {
    return 'Totals still add up in $code, shown with ≈ when converted.';
  }

  @override
  String subscriptionFormCurrencyNoMatch(String query) {
    return 'No currency matches “$query”';
  }

  @override
  String get subscriptionFormReferenceHint => 'Check it against your bill';

  @override
  String get subscriptionFormReferenceNote =>
      'Reference price from the library, not verified. Check it against your bill.';

  @override
  String get subscriptionFormLabels => 'Labels';

  @override
  String get subscriptionFormNewLabel => 'New label';

  @override
  String get subscriptionFormNewLabelHint => 'e.g. Family, Work';

  @override
  String subscriptionFormMethodUsage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscriptions',
      one: '1 subscription',
      zero: 'Not used yet',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionFormMethodAddHint => 'Add a card or wallet';

  @override
  String get subscriptionFormMethodNote =>
      'Free text — Subnest never connects to your bank.';

  @override
  String get subscriptionFormAdd => 'Add';

  @override
  String get subscriptionFormWorthIt => 'Worth it?';

  @override
  String get subscriptionFormWorthNotRated => 'Not rated';

  @override
  String get subscriptionFormDelete => 'Delete subscription';

  @override
  String subscriptionFormDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String get subscriptionFormDeleteBody =>
      'Its payment history goes too. This can\'t be undone.';

  @override
  String get subscriptionFormDeleteAction => 'Delete';

  @override
  String get subscriptionFormTilePhotoPick => 'Choose photo';

  @override
  String get subscriptionFormTilePhotoRemove => 'Remove photo';

  @override
  String get subscriptionFormTilePhotoFailed => 'Couldn’t open that photo.';

  @override
  String get subscriptionFormCropTitle => 'Move and scale';

  @override
  String get subscriptionFormCropHint => 'The square is what shows as the icon';

  @override
  String get subscriptionFormCropUse => 'Use photo';

  @override
  String get subscriptionFormPriceNow => 'Now';

  @override
  String subscriptionFormPriceFrom(String date) {
    return 'From $date';
  }

  @override
  String subscriptionFormRemindAt(String time) {
    return 'at $time';
  }

  @override
  String get subscriptionFormCustomSub =>
      'Custom service · tap the icon for a photo';

  @override
  String get subscriptionFormAddMethod => 'Add';

  @override
  String get subscriptionFormTileLetterPreview => 'Letter on colour';

  @override
  String get subscriptionFormTilePhotoPreview => 'Your photo, cropped square';

  @override
  String get subscriptionFormTileTakePhoto => 'Take photo';

  @override
  String get subscriptionFormTileLetterOrEmoji => 'Letter or emoji';

  @override
  String get subscriptionFormCropRotate => 'Rotate';

  @override
  String get subscriptionFormMethodNone => 'None';

  @override
  String get widgetThisMonth => 'This month';

  @override
  String get widgetPerMonthShort => '/mo';

  @override
  String widgetMonthlyTotalA11y(String amount) {
    return 'Monthly total $amount';
  }

  @override
  String get widgetPaid => 'Paid';

  @override
  String get widgetStillToPay => 'Still to pay';

  @override
  String widgetToConfirm(int count) {
    return '$count to confirm';
  }

  @override
  String get widgetAwaiting => 'To confirm';

  @override
  String get widgetTapToConfirm => 'Tap to confirm';

  @override
  String get widgetDueTomorrow => 'Tomorrow';

  @override
  String widgetDueInDays(String days) {
    return '$days days';
  }

  @override
  String get widgetLeftTomorrow => 'tomorrow';

  @override
  String widgetLeftDays(String days) {
    return '$days days left';
  }

  @override
  String widgetTrialEnds(String date) {
    return 'Trial ends $date';
  }

  @override
  String get widgetEmptyTitle => 'Nothing due';

  @override
  String get widgetEmptyBody => 'Tap to add your first subscription';

  @override
  String get widgetLocked => 'Locked with PIN';

  @override
  String get widgetLockedLong =>
      'Locked with PIN — open Subnest to see your payments';

  @override
  String get widgetOpenApp => 'Open Subnest';
}
