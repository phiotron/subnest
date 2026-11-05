import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @commonAppName.
  ///
  /// In en, this message translates to:
  /// **'Subnest'**
  String get commonAppName;

  /// No description provided for @commonTabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get commonTabHome;

  /// No description provided for @commonTabCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get commonTabCalendar;

  /// No description provided for @commonTabInsights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get commonTabInsights;

  /// No description provided for @commonTabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get commonTabSettings;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonPerMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get commonPerMonth;

  /// No description provided for @commonPerYear.
  ///
  /// In en, this message translates to:
  /// **'per year'**
  String get commonPerYear;

  /// No description provided for @commonCycleDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Daily} other{Every {count} days}}'**
  String commonCycleDays(int count);

  /// No description provided for @commonCycleWeeks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Weekly} other{Every {count} weeks}}'**
  String commonCycleWeeks(int count);

  /// No description provided for @commonCycleMonths.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Monthly} other{Every {count} months}}'**
  String commonCycleMonths(int count);

  /// No description provided for @commonCycleYears.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Yearly} other{Every {count} years}}'**
  String commonCycleYears(int count);

  /// No description provided for @commonCycleQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get commonCycleQuarterly;

  /// No description provided for @commonUnitDay.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get commonUnitDay;

  /// No description provided for @commonUnitWeek.
  ///
  /// In en, this message translates to:
  /// **'weeks'**
  String get commonUnitWeek;

  /// No description provided for @commonUnitMonth.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get commonUnitMonth;

  /// No description provided for @commonUnitYear.
  ///
  /// In en, this message translates to:
  /// **'years'**
  String get commonUnitYear;

  /// No description provided for @commonStatusTrial.
  ///
  /// In en, this message translates to:
  /// **'Free trial'**
  String get commonStatusTrial;

  /// No description provided for @commonStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonStatusActive;

  /// No description provided for @commonStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get commonStatusCancelled;

  /// No description provided for @commonStatusAwaiting.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get commonStatusAwaiting;

  /// No description provided for @commonCategory.
  ///
  /// In en, this message translates to:
  /// **'{category, select, video{Video} music{Music} ai{AI} storage{Storage} software{Software} gaming{Games} reading{Reading} health{Health} education{Learning} telecom{Telecom} other{Other}}'**
  String commonCategory(String category);

  /// No description provided for @commonCategoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonCategoryAll;

  /// No description provided for @commonDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Today} =1{Tomorrow} other{In {count} days}}'**
  String commonDaysLeft(int count);

  /// No description provided for @commonDaysOverdue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String commonDaysOverdue(int count);

  /// No description provided for @commonReminderDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get commonReminderDefault;

  /// No description provided for @commonReminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get commonReminderOff;

  /// No description provided for @commonReminderOnTheDay.
  ///
  /// In en, this message translates to:
  /// **'On the day'**
  String get commonReminderOnTheDay;

  /// No description provided for @commonReminderDaysBefore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day before} other{{count} days before}}'**
  String commonReminderDaysBefore(int count);

  /// No description provided for @commonSharedWith.
  ///
  /// In en, this message translates to:
  /// **'÷{count}'**
  String commonSharedWith(int count);

  /// No description provided for @commonNotFound.
  ///
  /// In en, this message translates to:
  /// **'This subscription no longer exists.'**
  String get commonNotFound;

  /// No description provided for @calendarMonthTotal.
  ///
  /// In en, this message translates to:
  /// **'Month total: {amount}'**
  String calendarMonthTotal(String amount);

  /// No description provided for @calendarEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing due this month.'**
  String get calendarEmpty;

  /// No description provided for @calendarPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get calendarPaid;

  /// No description provided for @calendarSkipped.
  ///
  /// In en, this message translates to:
  /// **'Not paid'**
  String get calendarSkipped;

  /// No description provided for @calendarUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get calendarUpcoming;

  /// No description provided for @catalogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search services'**
  String get catalogSearchHint;

  /// No description provided for @catalogCustom.
  ///
  /// In en, this message translates to:
  /// **'+ Create a custom service'**
  String get catalogCustom;

  /// No description provided for @catalogCustomNamed.
  ///
  /// In en, this message translates to:
  /// **'Not listed? Create “{name}”'**
  String catalogCustomNamed(String name);

  /// No description provided for @catalogFromPerMonth.
  ///
  /// In en, this message translates to:
  /// **'from {amount}/month'**
  String catalogFromPerMonth(String amount);

  /// No description provided for @catalogChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a {name} plan'**
  String catalogChoosePlan(String name);

  /// No description provided for @confirmTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} · period {date}'**
  String confirmTitle(String name, String date);

  /// No description provided for @confirmMorePending.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more period to confirm} other{{count} more periods to confirm}}'**
  String confirmMorePending(int count);

  /// No description provided for @confirmAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get confirmAmount;

  /// No description provided for @confirmPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get confirmPaid;

  /// No description provided for @confirmSkip.
  ///
  /// In en, this message translates to:
  /// **'Not paying this period'**
  String get confirmSkip;

  /// No description provided for @confirmLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get confirmLater;

  /// No description provided for @confirmNext.
  ///
  /// In en, this message translates to:
  /// **'Next renewal: {date}'**
  String confirmNext(String date);

  /// No description provided for @confirmNothing.
  ///
  /// In en, this message translates to:
  /// **'{name} has nothing to confirm.'**
  String confirmNothing(String name);

  /// No description provided for @confirmAwaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get confirmAwaitingTitle;

  /// No description provided for @confirmAllDone.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up 🎉'**
  String get confirmAllDone;

  /// No description provided for @confirmAll.
  ///
  /// In en, this message translates to:
  /// **'Confirm all · {amount}'**
  String confirmAll(String amount);

  /// No description provided for @confirmAllDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Confirm 1 payment?} other{Confirm {count} payments?}}'**
  String confirmAllDialogTitle(int count);

  /// No description provided for @confirmAllDialogBody.
  ///
  /// In en, this message translates to:
  /// **'All of them will be marked as paid at their current price.'**
  String get confirmAllDialogBody;

  /// No description provided for @coreRelToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get coreRelToday;

  /// No description provided for @coreRelTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get coreRelTomorrow;

  /// No description provided for @coreRelInDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{in 1 day} other{in {count} days}}'**
  String coreRelInDays(int count);

  /// No description provided for @coreRelDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String coreRelDaysAgo(int count);

  /// No description provided for @corePer.
  ///
  /// In en, this message translates to:
  /// **'{unit, select, day{/day} week{/week} month{/month} quarter{/quarter} year{/year} other{}}'**
  String corePer(String unit);

  /// No description provided for @corePerEvery.
  ///
  /// In en, this message translates to:
  /// **'/{count} {unit}'**
  String corePerEvery(int count, String unit);

  /// No description provided for @corePlanPrice.
  ///
  /// In en, this message translates to:
  /// **'plan {price}'**
  String corePlanPrice(String price);

  /// No description provided for @coreSwipeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get coreSwipeConfirm;

  /// No description provided for @coreSwipeCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get coreSwipeCancel;

  /// No description provided for @coreSharedWith.
  ///
  /// In en, this message translates to:
  /// **'Shared by {count}'**
  String coreSharedWith(int count);

  /// No description provided for @coreAddSubscription.
  ///
  /// In en, this message translates to:
  /// **'Add subscription'**
  String get coreAddSubscription;

  /// No description provided for @coreMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get coreMonth;

  /// No description provided for @coreYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get coreYear;

  /// No description provided for @corePrevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get corePrevMonth;

  /// No description provided for @coreNextMonth.
  ///
  /// In en, this message translates to:
  /// **'Next month'**
  String get coreNextMonth;

  /// No description provided for @coreFewer.
  ///
  /// In en, this message translates to:
  /// **'Fewer'**
  String get coreFewer;

  /// No description provided for @coreMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get coreMore;

  /// No description provided for @coreTabOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get coreTabOverview;

  /// No description provided for @coreChangeCurrency.
  ///
  /// In en, this message translates to:
  /// **'Change currency'**
  String get coreChangeCurrency;

  /// No description provided for @coreEditAmount.
  ///
  /// In en, this message translates to:
  /// **'Edit amount'**
  String get coreEditAmount;

  /// No description provided for @homeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add subscription'**
  String get homeAdd;

  /// No description provided for @homeCounts.
  ///
  /// In en, this message translates to:
  /// **'{active} paying · {trial} on trial'**
  String homeCounts(int active, int trial);

  /// No description provided for @homeTrialSoon.
  ///
  /// In en, this message translates to:
  /// **'{amount}/month after trials end'**
  String homeTrialSoon(String amount);

  /// No description provided for @homeRatesOffline.
  ///
  /// In en, this message translates to:
  /// **'Approximate exchange rates (not updated yet)'**
  String get homeRatesOffline;

  /// No description provided for @homeRatesStale.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Exchange rates updated 1 day ago} other{Exchange rates updated {days} days ago}}'**
  String homeRatesStale(int days);

  /// No description provided for @homeRatesFresh.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates updated today'**
  String get homeRatesFresh;

  /// No description provided for @homeNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Reminders are off'**
  String get homeNotificationsOff;

  /// No description provided for @homeEnable.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get homeEnable;

  /// No description provided for @homeAwaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment to confirm} other{{count} payments to confirm}}'**
  String homeAwaiting(int count);

  /// No description provided for @homeView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get homeView;

  /// No description provided for @homeTrialEnding.
  ///
  /// In en, this message translates to:
  /// **'{name} trial ends {days, plural, =0{today} =1{tomorrow} other{in {days} days}}'**
  String homeTrialEnding(String name, int days);

  /// No description provided for @homeHowToCancel.
  ///
  /// In en, this message translates to:
  /// **'How to cancel'**
  String get homeHowToCancel;

  /// No description provided for @homeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Next 7 days'**
  String get homeUpcoming;

  /// No description provided for @homeTabActive.
  ///
  /// In en, this message translates to:
  /// **'Paying'**
  String get homeTabActive;

  /// No description provided for @homeTabTrial.
  ///
  /// In en, this message translates to:
  /// **'Trial'**
  String get homeTabTrial;

  /// No description provided for @homeTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get homeTabCancelled;

  /// No description provided for @homeTabEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing here.'**
  String get homeTabEmpty;

  /// No description provided for @homeSort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get homeSort;

  /// No description provided for @homeSortDueDate.
  ///
  /// In en, this message translates to:
  /// **'Renewal date'**
  String get homeSortDueDate;

  /// No description provided for @homeSortPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get homeSortPrice;

  /// No description provided for @homeSortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get homeSortName;

  /// No description provided for @homeSavings.
  ///
  /// In en, this message translates to:
  /// **'You\'re saving {amount}/year'**
  String homeSavings(String amount);

  /// No description provided for @homeCancelledOn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {date}'**
  String homeCancelledOn(String date);

  /// No description provided for @homeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Track every subscription in one nest.'**
  String get homeEmpty;

  /// No description provided for @homeAddFirst.
  ///
  /// In en, this message translates to:
  /// **'Add your first subscription'**
  String get homeAddFirst;

  /// No description provided for @insightsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Add subscriptions to see insights.'**
  String get insightsEmpty;

  /// No description provided for @insightsThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get insightsThisMonth;

  /// No description provided for @insightsActualVsProjected.
  ///
  /// In en, this message translates to:
  /// **'Paid {actual} · expected {projected}'**
  String insightsActualVsProjected(String actual, String projected);

  /// No description provided for @insightsLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last month paid: {amount}'**
  String insightsLastMonth(String amount);

  /// No description provided for @insightsTwelveMonths.
  ///
  /// In en, this message translates to:
  /// **'12 months (paid · expected)'**
  String get insightsTwelveMonths;

  /// No description provided for @insightsByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category (monthly)'**
  String get insightsByCategory;

  /// No description provided for @insightsTop.
  ///
  /// In en, this message translates to:
  /// **'Most expensive'**
  String get insightsTop;

  /// No description provided for @insightsSavingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get insightsSavingsTitle;

  /// No description provided for @insightsSavings.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{You\'re saving {amount}/year by cancelling 1 service} other{You\'re saving {amount}/year by cancelling {count} services}}'**
  String insightsSavings(String amount, int count);

  /// No description provided for @notificationsChannelName.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get notificationsChannelName;

  /// No description provided for @notificationsChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Renewal and free-trial reminders'**
  String get notificationsChannelDescription;

  /// No description provided for @notificationsRenewalSoon.
  ///
  /// In en, this message translates to:
  /// **'{name} renews in {count, plural, =1{1 day} other{{count} days}} — {amount}'**
  String notificationsRenewalSoon(String name, int count, String amount);

  /// No description provided for @notificationsTrialEndingTitle.
  ///
  /// In en, this message translates to:
  /// **'Your {name} trial ends in {count, plural, =1{1 day} other{{count} days}}.'**
  String notificationsTrialEndingTitle(String name, int count);

  /// No description provided for @notificationsTrialEndingBody.
  ///
  /// In en, this message translates to:
  /// **'Cancel now if you don’t want to be charged.'**
  String get notificationsTrialEndingBody;

  /// No description provided for @notificationsDueToday.
  ///
  /// In en, this message translates to:
  /// **'{name} renews today — tap to confirm'**
  String notificationsDueToday(String name);

  /// No description provided for @notificationsTestTitle.
  ///
  /// In en, this message translates to:
  /// **'Subnest reminders are on'**
  String get notificationsTestTitle;

  /// No description provided for @notificationsTestScheduledTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled test reminder'**
  String get notificationsTestScheduledTitle;

  /// No description provided for @notificationsTestBody.
  ///
  /// In en, this message translates to:
  /// **'This is how renewal reminders will look.'**
  String get notificationsTestBody;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'All your subscriptions, one nest'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingBenefitRemind.
  ///
  /// In en, this message translates to:
  /// **'Get reminded before you\'re charged'**
  String get onboardingBenefitRemind;

  /// No description provided for @onboardingBenefitTotal.
  ///
  /// In en, this message translates to:
  /// **'Know exactly what you spend each month'**
  String get onboardingBenefitTotal;

  /// No description provided for @onboardingBenefitPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private — your data stays on your phone'**
  String get onboardingBenefitPrivate;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your primary currency'**
  String get onboardingCurrencyTitle;

  /// No description provided for @onboardingCurrencyHint.
  ///
  /// In en, this message translates to:
  /// **'Used to add up your totals. Each subscription keeps its own currency.'**
  String get onboardingCurrencyHint;

  /// No description provided for @onboardingQuickAddTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you pay for?'**
  String get onboardingQuickAddTitle;

  /// No description provided for @onboardingLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get onboardingLater;

  /// No description provided for @onboardingSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Continue} other{Add {count} · Continue}}'**
  String onboardingSelected(int count);

  /// No description provided for @onboardingRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders'**
  String get onboardingRemindersTitle;

  /// No description provided for @onboardingRemindersExample.
  ///
  /// In en, this message translates to:
  /// **'“Netflix renews in 3 days — ₫260,000”'**
  String get onboardingRemindersExample;

  /// No description provided for @onboardingEnableReminders.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders'**
  String get onboardingEnableReminders;

  /// No description provided for @onboardingNoThanks.
  ///
  /// In en, this message translates to:
  /// **'No, thanks'**
  String get onboardingNoThanks;

  /// No description provided for @settingsSectionMoney.
  ///
  /// In en, this message translates to:
  /// **'Money'**
  String get settingsSectionMoney;

  /// No description provided for @settingsPrimaryCurrency.
  ///
  /// In en, this message translates to:
  /// **'Main currency'**
  String get settingsPrimaryCurrency;

  /// No description provided for @settingsSearchCurrency.
  ///
  /// In en, this message translates to:
  /// **'Search currency or country'**
  String get settingsSearchCurrency;

  /// No description provided for @settingsCurrencyNote.
  ///
  /// In en, this message translates to:
  /// **'Totals and insights add up in this currency. Each subscription keeps its own.'**
  String get settingsCurrencyNote;

  /// No description provided for @settingsCurrencyNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No currency matches “{query}”'**
  String settingsCurrencyNoMatch(String query);

  /// No description provided for @settingsRates.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get settingsRates;

  /// No description provided for @settingsRatesSummaryAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto · {ago}'**
  String settingsRatesSummaryAuto(String ago);

  /// No description provided for @settingsRatesSummaryBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'Built-in'**
  String get settingsRatesSummaryBuiltIn;

  /// No description provided for @settingsRatesSummaryManual.
  ///
  /// In en, this message translates to:
  /// **'Set by you'**
  String get settingsRatesSummaryManual;

  /// No description provided for @settingsRatesIntro.
  ///
  /// In en, this message translates to:
  /// **'Totals convert to {currency}. Rates update once a day when you’re online; set your own to override.'**
  String settingsRatesIntro(String currency);

  /// No description provided for @settingsRateAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto · updated {ago}'**
  String settingsRateAuto(String ago);

  /// No description provided for @settingsRateAutoOffline.
  ///
  /// In en, this message translates to:
  /// **'Auto · from {ago} (offline)'**
  String settingsRateAutoOffline(String ago);

  /// No description provided for @settingsRateBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'Auto · built-in estimate'**
  String get settingsRateBuiltIn;

  /// No description provided for @settingsRateManual.
  ///
  /// In en, this message translates to:
  /// **'Set by you'**
  String get settingsRateManual;

  /// No description provided for @settingsRatePairLabel.
  ///
  /// In en, this message translates to:
  /// **'1 {from} equals {rate} {to}'**
  String settingsRatePairLabel(String from, String rate, String to);

  /// No description provided for @settingsRatesUpdateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get settingsRatesUpdateNow;

  /// No description provided for @settingsRatesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates updated'**
  String get settingsRatesUpdated;

  /// No description provided for @settingsRatesOfflineTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re offline'**
  String get settingsRatesOfflineTitle;

  /// No description provided for @settingsRatesOfflineBody.
  ///
  /// In en, this message translates to:
  /// **'Using the last rates we fetched. They update when you’re back online.'**
  String get settingsRatesOfflineBody;

  /// No description provided for @settingsRatesListedNote.
  ///
  /// In en, this message translates to:
  /// **'Only currencies your subscriptions use are listed.'**
  String get settingsRatesListedNote;

  /// No description provided for @settingsRatesNoneUsed.
  ///
  /// In en, this message translates to:
  /// **'All your subscriptions are in {currency}, so nothing needs converting.'**
  String settingsRatesNoneUsed(String currency);

  /// No description provided for @settingsRatesAttribution.
  ///
  /// In en, this message translates to:
  /// **'Rates by Exchange Rate API'**
  String get settingsRatesAttribution;

  /// No description provided for @settingsAgoJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get settingsAgoJustNow;

  /// No description provided for @settingsAgoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min ago} other{{count} min ago}}'**
  String settingsAgoMinutes(int count);

  /// No description provided for @settingsAgoHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{count} h ago'**
  String settingsAgoHoursShort(int count);

  /// No description provided for @settingsAgoHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String settingsAgoHours(int count);

  /// No description provided for @settingsAgoDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String settingsAgoDays(int count);

  /// No description provided for @settingsRateUseAuto.
  ///
  /// In en, this message translates to:
  /// **'Use automatic rate'**
  String get settingsRateUseAuto;

  /// No description provided for @settingsRateAutoValue.
  ///
  /// In en, this message translates to:
  /// **'{rate} · updated {ago}'**
  String settingsRateAutoValue(String rate, String ago);

  /// No description provided for @settingsRateAutoValueBuiltIn.
  ///
  /// In en, this message translates to:
  /// **'{rate} · built-in estimate'**
  String settingsRateAutoValueBuiltIn(String rate);

  /// No description provided for @settingsRateYours.
  ///
  /// In en, this message translates to:
  /// **'Your rate · 1 {from} ='**
  String settingsRateYours(String from);

  /// No description provided for @settingsRatePreview.
  ///
  /// In en, this message translates to:
  /// **'{name} becomes {amount}/month'**
  String settingsRatePreview(String name, String amount);

  /// No description provided for @settingsRateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a rate above 0'**
  String get settingsRateInvalid;

  /// No description provided for @settingsRateSave.
  ///
  /// In en, this message translates to:
  /// **'Save my rate'**
  String get settingsRateSave;

  /// No description provided for @settingsRateRestoreAuto.
  ///
  /// In en, this message translates to:
  /// **'Restore automatic'**
  String get settingsRateRestoreAuto;

  /// No description provided for @settingsSectionReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsSectionReminders;

  /// No description provided for @settingsRemindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get settingsRemindMe;

  /// No description provided for @settingsReminderValue.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{On the day} =1{1 day before} other{{count} days before}}'**
  String settingsReminderValue(int count);

  /// No description provided for @settingsReminderOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsReminderOff;

  /// No description provided for @settingsReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder time'**
  String get settingsReminderTime;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsNotificationsOn;

  /// No description provided for @settingsNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsNotificationsOff;

  /// No description provided for @settingsNotificationsOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off for Subnest'**
  String get settingsNotificationsOffTitle;

  /// No description provided for @settingsNotificationsOffBody.
  ///
  /// In en, this message translates to:
  /// **'Reminders can’t reach you until you allow them in system settings.'**
  String get settingsNotificationsOffBody;

  /// No description provided for @settingsOpenSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get settingsOpenSystemSettings;

  /// No description provided for @settingsOpenSystemSettingsFailed.
  ///
  /// In en, this message translates to:
  /// **'Open your phone’s Settings › Apps › Subnest › Notifications.'**
  String get settingsOpenSystemSettingsFailed;

  /// No description provided for @settingsRemindBefore.
  ///
  /// In en, this message translates to:
  /// **'Remind me before a renewal'**
  String get settingsRemindBefore;

  /// No description provided for @settingsRemindChoice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{On day} =1{1 day} other{{count} days}}'**
  String settingsRemindChoice(int count);

  /// No description provided for @settingsRemindTrialNote.
  ///
  /// In en, this message translates to:
  /// **'Trials get the same reminder before they end.'**
  String get settingsRemindTrialNote;

  /// No description provided for @settingsReminderTimeShort.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get settingsReminderTimeShort;

  /// No description provided for @settingsRemindersNote.
  ///
  /// In en, this message translates to:
  /// **'You can change this for a single subscription from its edit screen. Applies to new reminders; existing ones move to the new time.'**
  String get settingsRemindersNote;

  /// No description provided for @settingsPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get settingsPreview;

  /// No description provided for @settingsPreviewOff.
  ///
  /// In en, this message translates to:
  /// **'Reminders are off. Renewals still show up in the app as they come due.'**
  String get settingsPreviewOff;

  /// No description provided for @settingsTestReminder.
  ///
  /// In en, this message translates to:
  /// **'Send a test reminder'**
  String get settingsTestReminder;

  /// No description provided for @settingsTestReminderHint.
  ///
  /// In en, this message translates to:
  /// **'Debug only · one now and one in 10 seconds'**
  String get settingsTestReminderHint;

  /// No description provided for @settingsTestReminderSent.
  ///
  /// In en, this message translates to:
  /// **'Test reminder sent'**
  String get settingsTestReminderSent;

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystem;

  /// No description provided for @settingsSystemShort.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystemShort;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageFromPhone.
  ///
  /// In en, this message translates to:
  /// **'{language} (from your phone)'**
  String settingsLanguageFromPhone(String language);

  /// No description provided for @settingsSectionBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get settingsSectionBackup;

  /// No description provided for @settingsBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get settingsBackupTitle;

  /// No description provided for @settingsBackupOverdueTitle.
  ///
  /// In en, this message translates to:
  /// **'Last backup was {count, plural, =1{1 day} other{{count} days}} ago'**
  String settingsBackupOverdueTitle(int count);

  /// No description provided for @settingsBackupNeverTitle.
  ///
  /// In en, this message translates to:
  /// **'You haven’t backed up yet'**
  String get settingsBackupNeverTitle;

  /// No description provided for @settingsBackupOverdueBody.
  ///
  /// In en, this message translates to:
  /// **'Your data lives only on this phone. Export a copy now.'**
  String get settingsBackupOverdueBody;

  /// No description provided for @settingsBackupAction.
  ///
  /// In en, this message translates to:
  /// **'Back up'**
  String get settingsBackupAction;

  /// No description provided for @settingsBackupDaysTitle.
  ///
  /// In en, this message translates to:
  /// **'It’s been {count, plural, =1{1 day} other{{count} days}} since your last backup'**
  String settingsBackupDaysTitle(int count);

  /// No description provided for @settingsBackupWhyBody.
  ///
  /// In en, this message translates to:
  /// **'Subnest keeps nothing online, so a backup is the only way to move to a new phone.'**
  String get settingsBackupWhyBody;

  /// No description provided for @settingsExportJson.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get settingsExportJson;

  /// No description provided for @settingsExportJsonHint.
  ///
  /// In en, this message translates to:
  /// **'JSON · everything, to restore later'**
  String get settingsExportJsonHint;

  /// No description provided for @settingsExportJsonLong.
  ///
  /// In en, this message translates to:
  /// **'Everything, as a .json file to restore later'**
  String get settingsExportJsonLong;

  /// No description provided for @settingsExportCsv.
  ///
  /// In en, this message translates to:
  /// **'Export spreadsheet'**
  String get settingsExportCsv;

  /// No description provided for @settingsExportCsvHint.
  ///
  /// In en, this message translates to:
  /// **'CSV · opens in Excel or Sheets'**
  String get settingsExportCsvHint;

  /// No description provided for @settingsExportCsvLong.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions and payments as .csv'**
  String get settingsExportCsvLong;

  /// No description provided for @settingsExported.
  ///
  /// In en, this message translates to:
  /// **'Saved — keep it somewhere safe'**
  String get settingsExported;

  /// No description provided for @settingsExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t create the file. Please try again.'**
  String get settingsExportFailed;

  /// No description provided for @settingsRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore from file'**
  String get settingsRestore;

  /// No description provided for @settingsRestoreHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a Subnest .json backup'**
  String get settingsRestoreHint;

  /// No description provided for @settingsLastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date}'**
  String settingsLastBackup(String date);

  /// No description provided for @settingsLastBackupFile.
  ///
  /// In en, this message translates to:
  /// **'Last backup: {date} · {file}'**
  String settingsLastBackupFile(String date, String file);

  /// No description provided for @settingsNeverBackedUp.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get settingsNeverBackedUp;

  /// No description provided for @settingsRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore this backup?'**
  String get settingsRestoreTitle;

  /// No description provided for @settingsRestoreHolds.
  ///
  /// In en, this message translates to:
  /// **'It holds {subs, plural, =1{1 subscription} other{{subs} subscriptions}} and {payments, plural, =1{1 payment} other{{payments} payments}}.'**
  String settingsRestoreHolds(int subs, int payments);

  /// No description provided for @settingsRestoreMerge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get settingsRestoreMerge;

  /// No description provided for @settingsRestoreMergeHint.
  ///
  /// In en, this message translates to:
  /// **'Add what’s missing, keep your current data'**
  String get settingsRestoreMergeHint;

  /// No description provided for @settingsRestoreReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get settingsRestoreReplace;

  /// No description provided for @settingsRestoreReplaceHint.
  ///
  /// In en, this message translates to:
  /// **'Delete current data and use the backup'**
  String get settingsRestoreReplaceHint;

  /// No description provided for @settingsRestoreAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get settingsRestoreAction;

  /// No description provided for @settingsRestoreReplaceAction.
  ///
  /// In en, this message translates to:
  /// **'Replace my data'**
  String get settingsRestoreReplaceAction;

  /// No description provided for @settingsRestoreInvalid.
  ///
  /// In en, this message translates to:
  /// **'That file isn’t a Subnest backup.'**
  String get settingsRestoreInvalid;

  /// No description provided for @settingsRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t restore that backup. Nothing was changed.'**
  String get settingsRestoreFailed;

  /// No description provided for @settingsRestoreDone.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Restored 1 subscription} other{Restored {count} subscriptions}}'**
  String settingsRestoreDone(int count);

  /// No description provided for @settingsSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get settingsTerms;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate Subnest'**
  String get settingsRateApp;

  /// No description provided for @settingsFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get settingsFeedback;

  /// No description provided for @settingsFeedbackSubject.
  ///
  /// In en, this message translates to:
  /// **'Subnest feedback ({version})'**
  String settingsFeedbackSubject(String version);

  /// No description provided for @settingsNoEmailApp.
  ///
  /// In en, this message translates to:
  /// **'No email app found. Write to {email}'**
  String settingsNoEmailApp(String email);

  /// No description provided for @settingsLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open the page.'**
  String get settingsLinkFailed;

  /// No description provided for @settingsLegalese.
  ///
  /// In en, this message translates to:
  /// **'Made by Phiotron. Subnest keeps your data on this device.'**
  String get settingsLegalese;

  /// No description provided for @settingsPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this phone. Subnest collects nothing.'**
  String get settingsPrivacyNote;

  /// No description provided for @subscriptionDetailMyShare.
  ///
  /// In en, this message translates to:
  /// **'Your share {share} · plan {price} ÷ {count}'**
  String subscriptionDetailMyShare(String share, String price, int count);

  /// No description provided for @subscriptionDetailAwaiting.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 period to confirm} other{{count} periods to confirm}}'**
  String subscriptionDetailAwaiting(int count);

  /// No description provided for @subscriptionDetailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get subscriptionDetailConfirm;

  /// No description provided for @subscriptionDetailNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next renewal'**
  String get subscriptionDetailNextDue;

  /// No description provided for @subscriptionDetailTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial ends'**
  String get subscriptionDetailTrialEnds;

  /// No description provided for @subscriptionDetailCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle'**
  String get subscriptionDetailCycle;

  /// No description provided for @subscriptionDetailReminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get subscriptionDetailReminder;

  /// No description provided for @subscriptionDetailCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get subscriptionDetailCategory;

  /// No description provided for @subscriptionDetailPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get subscriptionDetailPaymentMethod;

  /// No description provided for @subscriptionDetailStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get subscriptionDetailStarted;

  /// No description provided for @subscriptionDetailCancelledOn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled on'**
  String get subscriptionDetailCancelledOn;

  /// No description provided for @subscriptionDetailTotalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total paid'**
  String get subscriptionDetailTotalPaid;

  /// No description provided for @subscriptionDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get subscriptionDetailNotes;

  /// No description provided for @subscriptionDetailHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get subscriptionDetailHistory;

  /// No description provided for @subscriptionDetailPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get subscriptionDetailPaid;

  /// No description provided for @subscriptionDetailSkipped.
  ///
  /// In en, this message translates to:
  /// **'Not paid this period'**
  String get subscriptionDetailSkipped;

  /// No description provided for @subscriptionDetailNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No payments yet.'**
  String get subscriptionDetailNoHistory;

  /// No description provided for @subscriptionDetailHowToCancel.
  ///
  /// In en, this message translates to:
  /// **'How to cancel this service'**
  String get subscriptionDetailHowToCancel;

  /// No description provided for @subscriptionDetailMarkCancelled.
  ///
  /// In en, this message translates to:
  /// **'Mark as cancelled'**
  String get subscriptionDetailMarkCancelled;

  /// No description provided for @subscriptionDetailRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get subscriptionDetailRestore;

  /// No description provided for @subscriptionDetailSaved.
  ///
  /// In en, this message translates to:
  /// **'Nice! You\'re saving {amount}/year'**
  String subscriptionDetailSaved(String amount);

  /// No description provided for @subscriptionDetailEditAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get subscriptionDetailEditAmount;

  /// No description provided for @subscriptionDetailDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String subscriptionDetailDeleteTitle(String name);

  /// No description provided for @subscriptionDetailDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'This removes the subscription and its whole payment history. To keep the history, mark it as cancelled instead.'**
  String get subscriptionDetailDeleteBody;

  /// No description provided for @subscriptionFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'New subscription'**
  String get subscriptionFormAddTitle;

  /// No description provided for @subscriptionFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit subscription'**
  String get subscriptionFormEditTitle;

  /// No description provided for @subscriptionFormName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get subscriptionFormName;

  /// No description provided for @subscriptionFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get subscriptionFormNameRequired;

  /// No description provided for @subscriptionFormPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get subscriptionFormPrice;

  /// No description provided for @subscriptionFormPriceAfterTrial.
  ///
  /// In en, this message translates to:
  /// **'Price after trial'**
  String get subscriptionFormPriceAfterTrial;

  /// No description provided for @subscriptionFormPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Price must be greater than 0'**
  String get subscriptionFormPriceRequired;

  /// No description provided for @subscriptionFormEvery.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get subscriptionFormEvery;

  /// No description provided for @subscriptionFormNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next renewal date'**
  String get subscriptionFormNextDue;

  /// No description provided for @subscriptionFormThen.
  ///
  /// In en, this message translates to:
  /// **'Then: {dates}'**
  String subscriptionFormThen(String dates);

  /// No description provided for @subscriptionFormTrial.
  ///
  /// In en, this message translates to:
  /// **'On a free trial'**
  String get subscriptionFormTrial;

  /// No description provided for @subscriptionFormTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial ends on'**
  String get subscriptionFormTrialEnds;

  /// No description provided for @subscriptionFormTrialEndInvalid.
  ///
  /// In en, this message translates to:
  /// **'Trial end can\'t be in the past'**
  String get subscriptionFormTrialEndInvalid;

  /// No description provided for @subscriptionFormShared.
  ///
  /// In en, this message translates to:
  /// **'Shared with others'**
  String get subscriptionFormShared;

  /// No description provided for @subscriptionFormPeople.
  ///
  /// In en, this message translates to:
  /// **'{count} people'**
  String subscriptionFormPeople(int count);

  /// No description provided for @subscriptionFormMyShare.
  ///
  /// In en, this message translates to:
  /// **'Your share: {amount}'**
  String subscriptionFormMyShare(String amount);

  /// No description provided for @subscriptionFormCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get subscriptionFormCategory;

  /// No description provided for @subscriptionFormReminder.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get subscriptionFormReminder;

  /// No description provided for @subscriptionFormAdvanced.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get subscriptionFormAdvanced;

  /// No description provided for @subscriptionFormPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method (e.g. Visa ••4242, MoMo)'**
  String get subscriptionFormPaymentMethod;

  /// No description provided for @subscriptionFormManageUrl.
  ///
  /// In en, this message translates to:
  /// **'Cancel / manage link'**
  String get subscriptionFormManageUrl;

  /// No description provided for @subscriptionFormNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get subscriptionFormNotes;

  /// No description provided for @subscriptionFormAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add subscription'**
  String get subscriptionFormAddButton;

  /// No description provided for @subscriptionFormSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get subscriptionFormSaveChanges;

  /// No description provided for @subscriptionFormPriceFromNext.
  ///
  /// In en, this message translates to:
  /// **'New price applies from the next period. Past payments are unchanged.'**
  String get subscriptionFormPriceFromNext;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
