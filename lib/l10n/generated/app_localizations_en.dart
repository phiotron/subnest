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
  String get calendarViewAgenda => 'Agenda';

  @override
  String calendarMonthYear(String name, String number, String year) {
    return '$name $year';
  }

  @override
  String calendarMonthName(String name, String number) {
    return '$name';
  }

  @override
  String calendarMonthTotal(String name, String number) {
    return '$name total';
  }

  @override
  String calendarPaidIn(String name, String number) {
    return 'Paid in $name';
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
  String calendarCountToConfirm(int count) {
    return '$count to confirm';
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
  String get calendarUpcoming => 'Upcoming';

  @override
  String get calendarDidNotPay => 'Didn’t pay this period';

  @override
  String get calendarFirstCharge => 'First charge after trial';

  @override
  String get calendarConfirm => 'Confirm';

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
  String get catalogSearchHint => 'Search 100+ services';

  @override
  String get catalogClearSearch => 'Clear search';

  @override
  String get catalogCustom => 'Create a custom service';

  @override
  String get catalogCustomSub => 'Anything not in the library';

  @override
  String catalogCustomNamed(String name) {
    return 'Not seeing it? Create “$name”';
  }

  @override
  String catalogCreateNamed(String name) {
    return 'Create “$name”';
  }

  @override
  String get catalogCustomService => 'Custom service';

  @override
  String get catalogPopularVietnam => 'Popular in Vietnam';

  @override
  String get catalogPopular => 'Popular';

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
    return 'No service called “$name”';
  }

  @override
  String get catalogNoResultBody =>
      'Create it — you can pick the colour and letters.';

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
  String get catalogPlanSubVietnam =>
      'Choose a plan · suggested prices for Vietnam';

  @override
  String get catalogPlanSub => 'Choose a plan · suggested prices';

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
  String confirmQuestion(String name) {
    return 'Did you pay $name?';
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
  String get confirmCurrentPrice => 'Current price · edit if it changed';

  @override
  String confirmMovesNext(String date) {
    return 'Confirming moves the next renewal to $date.';
  }

  @override
  String confirmNextUp(String date) {
    return 'Next up: the $date period, also waiting.';
  }

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
  String confirmSavedStep(String date, String amount) {
    return '$date saved · $amount';
  }

  @override
  String confirmSkippedStep(String date) {
    return '$date marked as not paid';
  }

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
  String get homeMonthlySpend => 'Monthly spend';

  @override
  String get homeYearlySpend => 'Yearly spend';

  @override
  String homeActiveCount(int count) {
    return '$count active';
  }

  @override
  String homeTrialCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count trials',
      one: '1 trial',
    );
    return '$_temp0';
  }

  @override
  String homeBiggest(String name, int percent) {
    return 'Biggest: $name · $percent%';
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
  String homeTrialThen(String price, String date) {
    return 'Then $price from $date';
  }

  @override
  String get homeHowToCancel => 'How to cancel';

  @override
  String get homeKeepIt => 'Keep it';

  @override
  String homeKept(String name, String date) {
    return 'Keeping $name. The first charge is on $date.';
  }

  @override
  String get homeUpcoming => 'Upcoming · 7 days';

  @override
  String get homeCalendar => 'Calendar';

  @override
  String get homeFirstCharge => 'First charge';

  @override
  String get homeSubscriptions => 'Subscriptions';

  @override
  String get homeTabActive => 'Active';

  @override
  String get homeTabTrials => 'Trials';

  @override
  String get homeTabCancelled => 'Cancelled';

  @override
  String get homeSortTitle => 'Sort subscriptions';

  @override
  String get homeSortDue => 'Due date';

  @override
  String get homeSortDueHint => 'Soonest first · awaiting always on top';

  @override
  String get homeSortPrice => 'Price';

  @override
  String get homeSortPriceHint => 'Highest monthly cost first';

  @override
  String get homeSortName => 'Name';

  @override
  String get homeSortNameHint => 'A → Z';

  @override
  String get homeSortDone => 'Done';

  @override
  String homeSortLabel(String by) {
    return 'Sort by $by';
  }

  @override
  String get homeSaving => 'You’re saving';

  @override
  String homePerYear(String amount) {
    return '$amount/year';
  }

  @override
  String homeCancelledOn(String date) {
    return 'Cancelled $date';
  }

  @override
  String homeTrialEndsWhen(String when) {
    return 'ends $when';
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
      'Pick from 100+ popular services — most take three taps.';

  @override
  String get homeBrowse => 'Browse services';

  @override
  String get homeAdd => 'Add subscription';

  @override
  String get insightsRangeMonth => 'This month';

  @override
  String get insightsRange12 => '12 months';

  @override
  String get insightsRangeYear => 'This year';

  @override
  String insightsTotalLabel(String range) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Total · this month',
      'year': 'Total · this year',
      'other': 'Total · last 12 months',
    });
    return '$_temp0';
  }

  @override
  String insightsTrendMore(String range, int percent) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': '$percent% more than last month',
      'year': '$percent% more than last year',
      'other': '$percent% more than the 12 months before',
    });
    return '$_temp0';
  }

  @override
  String insightsTrendLess(String range, int percent) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': '$percent% less than last month',
      'year': '$percent% less than last year',
      'other': '$percent% less than the 12 months before',
    });
    return '$_temp0';
  }

  @override
  String insightsTrendSame(String range) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Same as last month',
      'year': 'Same as last year',
      'other': 'Same as the 12 months before',
    });
    return '$_temp0';
  }

  @override
  String insightsTrendNoData(String range) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Not enough data from last month to compare',
      'year': 'Not enough data from last year to compare',
      'other': 'Not enough data from the 12 months before to compare',
    });
    return '$_temp0';
  }

  @override
  String get insightsLegendPaid => 'Paid';

  @override
  String get insightsLegendExpected => 'Expected, not yet confirmed';

  @override
  String get insightsByMonth => 'By month';

  @override
  String get insightsTapBar => 'Tap a bar';

  @override
  String insightsTipPaid(String amount) {
    return '$amount paid';
  }

  @override
  String insightsTipExpected(String amount) {
    return '$amount expected';
  }

  @override
  String insightsChartLabel(String from, String to) {
    return 'Spending per month, paid and expected, $from to $to';
  }

  @override
  String insightsCompact(String unit, String n) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'k': '${n}K',
      'm': '${n}M',
      'b': '${n}B',
      'other': '$n',
    });
    return '$_temp0';
  }

  @override
  String get insightsAnd => 'and';

  @override
  String insightsMonthList(String names, String numbers) {
    return '$names';
  }

  @override
  String insightsPeakYearly(String months, String names) {
    return '$months jump with the yearly $names renewals.';
  }

  @override
  String insightsPeak(String months, String names) {
    return '$months jump with the $names renewals.';
  }

  @override
  String insightsPeakPlain(String months) {
    return 'Spending was higher than usual in $months.';
  }

  @override
  String insightsPeakYearlyAhead(String months, String names) {
    return '$months will jump with the yearly $names renewals.';
  }

  @override
  String insightsPeakAhead(String months, String names) {
    return '$months will jump with the $names renewals.';
  }

  @override
  String insightsPeakPlainAhead(String months) {
    return 'Spending will be higher than usual in $months.';
  }

  @override
  String get insightsByCategory => 'By category';

  @override
  String get insightsMonthlyActive => 'monthly equivalent, active plans';

  @override
  String get insightsCategoryNote =>
      'Yearly and other non-monthly plans are spread evenly per month here, so this is not what you pay this month.';

  @override
  String insightsSliceLabel(String category, String amount, int percent) {
    return '$category: $amount per month, $percent%';
  }

  @override
  String insightsCategoryShare(int percent) {
    return '$percent% of your monthly spend';
  }

  @override
  String get insightsPerMonthShort => '/mo';

  @override
  String insightsCycleNoteOne(String name, String price) {
    return '$name is billed $price — counted here as its monthly share.';
  }

  @override
  String get insightsCycleNoteMany =>
      'Plans not billed monthly are counted here as their monthly share.';

  @override
  String get insightsTop => 'Most expensive';

  @override
  String get insightsSaving => 'You’re saving';

  @override
  String insightsSavingBy(String names) {
    return 'by cancelling $names';
  }

  @override
  String insightsSavingByCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'by cancelling $count services',
      one: 'by cancelling 1 service',
    );
    return '$_temp0';
  }

  @override
  String insightsOverlapTitle(String category, int count) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'music': 'You pay for $count music services',
      'other': 'You pay for $count video services',
    });
    return '$_temp0';
  }

  @override
  String insightsOverlapBody(int count, String names, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$names together are $amount/month. Need all of them?',
      two: '$names together are $amount/month. Need both?',
    );
    return '$_temp0';
  }

  @override
  String get insightsEmptyTitle => 'Add subscriptions to see insights';

  @override
  String get insightsEmptyBody =>
      'Your spending by month and category shows up here once you’ve added a few.';

  @override
  String get insightsEmptyAction => 'Add a subscription';

  @override
  String get manageCategoriesTitle => 'Categories';

  @override
  String get manageLabelsTitle => 'Labels';

  @override
  String get managePaymentMethodsTitle => 'Payment methods';

  @override
  String get manageBudgetsTitle => 'Budgets';

  @override
  String get managePlaceholder => 'Coming soon';

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
  String onboardingStep(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingWelcomeTitle => 'All your subscriptions, one nest';

  @override
  String get onboardingBenefitRemind => 'Reminders before you’re charged';

  @override
  String get onboardingBenefitRemindSub =>
      '3 days ahead, and before trials end.';

  @override
  String get onboardingBenefitTotal => 'Know exactly what each month costs';

  @override
  String get onboardingBenefitTotalSub =>
      'In your currency, shared plans split fairly.';

  @override
  String get onboardingBenefitPrivate => 'Private — data stays on your phone';

  @override
  String get onboardingBenefitPrivateSub =>
      'No account, no bank link, no tracking.';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get onboardingCurrencyTitle => 'Your main currency';

  @override
  String get onboardingCurrencyHint =>
      'Used to add up your totals. Each subscription still keeps its own currency.';

  @override
  String get onboardingCurrencySuggestedVn => 'Suggested for Vietnam';

  @override
  String get onboardingCurrencySuggested => 'Suggested for your region';

  @override
  String get onboardingCurrencyChosen => 'Your choice';

  @override
  String get onboardingCurrencyChange => 'Choose another currency';

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
  String get onboardingPickSearch => 'Search 100+ services';

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
  String onboardingPickMeta(String price, String cycle) {
    return '$price · $cycle';
  }

  @override
  String get onboardingPickEdit => 'Edit';

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
    return 'We’ll remind you 3 days before a renewal or a trial ending, at $time. Change it any time.';
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
  String get onboardingNoThanks => 'Not now';

  @override
  String get scanTitle => 'Scan screenshots';

  @override
  String get scanPlaceholder => 'Coming soon';

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
  String get settingsLogosAttribution => 'Logos provided by Logo.dev';

  @override
  String get settingsLogosOwnership =>
      'Service names and logos belong to their owners and are shown only to identify the service.';

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
  String subscriptionDetailYourShare(String price, int count) {
    return 'Your share · plan $price ÷ $count';
  }

  @override
  String subscriptionDetailAwaitingTitle(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count renewals need confirming, from $date',
      one: 'Renewal on $date needs confirming',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailAwaitingBody(String amount) {
    return 'Did $amount go out? The next date waits until you say.';
  }

  @override
  String get subscriptionDetailConfirm => 'Confirm';

  @override
  String subscriptionDetailTrialEnds(String date) {
    return 'Trial ends $date';
  }

  @override
  String subscriptionDetailTrialBody(String price) {
    return 'After that it renews at $price. Cancel before then if you don’t want it.';
  }

  @override
  String get subscriptionDetailHowToCancel => 'How to cancel';

  @override
  String get subscriptionDetailKeepIt => 'Keep it';

  @override
  String subscriptionDetailKept(String name, String date) {
    return 'Keeping $name. The first charge is on $date.';
  }

  @override
  String subscriptionDetailSaving(String amount) {
    return 'Saving $amount/year';
  }

  @override
  String subscriptionDetailCancelledBody(String date) {
    return 'Cancelled $date. No more reminders.';
  }

  @override
  String get subscriptionDetailRestore => 'Restore subscription';

  @override
  String subscriptionDetailRestored(String date) {
    return 'Restored. Next renewal: $date.';
  }

  @override
  String get subscriptionDetailNextRenewal => 'Next renewal';

  @override
  String get subscriptionDetailFirstCharge => 'First charge';

  @override
  String get subscriptionDetailWaits => 'Waits for your confirmation';

  @override
  String get subscriptionDetailCycle => 'Billing cycle';

  @override
  String subscriptionDetailEveryDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count days',
      one: 'Every day',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailEveryWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count weeks',
      one: 'Every week',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailEveryMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count months',
      one: 'Every month',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailEveryYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Every $count years',
      one: 'Every year',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailRemindMe => 'Remind me';

  @override
  String subscriptionDetailRemindValue(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days before, $time',
      one: '1 day before, $time',
      zero: 'On the day, $time',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailRemindOff => 'Off';

  @override
  String get subscriptionDetailCategory => 'Category';

  @override
  String get subscriptionDetailPaymentMethod => 'Payment method';

  @override
  String get subscriptionDetailSince => 'Since';

  @override
  String get subscriptionDetailTotalPaid => 'Total paid';

  @override
  String get subscriptionDetailNotes => 'Notes';

  @override
  String get subscriptionDetailHistory => 'Payment history';

  @override
  String get subscriptionDetailPaid => 'Paid';

  @override
  String get subscriptionDetailDidntPay => 'Didn’t pay';

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
  String get subscriptionDetailHowToCancelRow => 'How to cancel this service';

  @override
  String subscriptionDetailOpens(String host) {
    return 'Opens $host account settings';
  }

  @override
  String subscriptionDetailLinkFailed(String host) {
    return 'Couldn’t open $host.';
  }

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
    return 'Reminders stop and $amount/year moves into your savings. You can restore it any time.';
  }

  @override
  String get subscriptionDetailNotYet => 'Not yet';

  @override
  String subscriptionDetailDeleteTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String subscriptionDetailDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This removes it and its $count payment records for good. To stop reminders but keep the history, mark it as cancelled instead.',
      one: 'This removes it and its 1 payment record for good. To stop reminders but keep the history, mark it as cancelled instead.',
      zero: 'This removes it for good. To stop reminders but keep it, mark it as cancelled instead.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailDeleteAction => 'Delete';

  @override
  String subscriptionDetailDeleted(String name) {
    return '$name deleted';
  }

  @override
  String subscriptionDetailCelebrateCancelled(String name) {
    return '$name cancelled';
  }

  @override
  String get subscriptionDetailCelebrateYear => 'a year saved';

  @override
  String get subscriptionDetailCelebrateNow => 'You’re now saving';

  @override
  String subscriptionDetailPerYear(String amount) {
    return '$amount/year';
  }

  @override
  String get subscriptionDetailSeeCancelled => 'See cancelled';

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
  String subscriptionFormPriceWas(String old, String date) {
    return 'Was $old. The new price applies from the next period ($date). Past payments stay as they were.';
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
  String get subscriptionFormRemindOff => 'Off';

  @override
  String get subscriptionFormRemindOnDay => 'On day';

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
  String subscriptionFormRemindAt(String time, String date) {
    return 'At $time · $date';
  }

  @override
  String get subscriptionFormRemindNone => 'No reminder for this subscription';

  @override
  String get subscriptionFormMore => 'More details';

  @override
  String get subscriptionFormMoreSub => 'Payment method, cancel link, notes';

  @override
  String get subscriptionFormPaymentMethod => 'Payment method';

  @override
  String get subscriptionFormPaymentHint => 'e.g. Visa ••4242';

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
    return 'Use $price from the next period?';
  }

  @override
  String subscriptionFormPriceDialogBody(String date) {
    return 'The $date renewal and later ones use the new price.';
  }

  @override
  String subscriptionFormPriceDialogPast(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Your $count past payments stay at what you actually paid.',
      one: 'Your past payment stays at what you actually paid.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionFormPriceApply => 'Apply from next period';

  @override
  String subscriptionFormPriceKeep(String price) {
    return 'Keep $price';
  }

  @override
  String get subscriptionFormTileTitle => 'Tile';

  @override
  String get subscriptionFormTilePreview => 'Preview in a list';

  @override
  String get subscriptionFormTileLetters => 'Letters';

  @override
  String get subscriptionFormTileEmoji => 'Emoji';

  @override
  String get subscriptionFormTileLettersHint => '1–2 characters';

  @override
  String get subscriptionFormTileColour => 'Colour';

  @override
  String subscriptionFormTileColourNote(String name) {
    return 'The first swatch is $name’s own colour from the library. Letter colour is picked for contrast automatically.';
  }

  @override
  String get subscriptionFormTileColourNoteCustom =>
      'Letter colour is picked for contrast automatically.';

  @override
  String get subscriptionFormTileOrEmoji => 'Or an emoji';

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
}
