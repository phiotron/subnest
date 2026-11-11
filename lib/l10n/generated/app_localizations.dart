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

  /// No description provided for @commonLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get commonLanguageEnglish;

  /// No description provided for @commonLanguageVietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get commonLanguageVietnamese;

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

  /// No description provided for @commonStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get commonStatusPaused;

  /// No description provided for @commonWorthItUnrated.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get commonWorthItUnrated;

  /// No description provided for @commonWorthItWorth.
  ///
  /// In en, this message translates to:
  /// **'Worth it'**
  String get commonWorthItWorth;

  /// No description provided for @commonWorthItUnsure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get commonWorthItUnsure;

  /// No description provided for @commonWorthItNotWorth.
  ///
  /// In en, this message translates to:
  /// **'Not worth it'**
  String get commonWorthItNotWorth;

  /// No description provided for @commonAutoDetected.
  ///
  /// In en, this message translates to:
  /// **'Auto-detected'**
  String get commonAutoDetected;

  /// No description provided for @commonDetectionScan.
  ///
  /// In en, this message translates to:
  /// **'Screenshot'**
  String get commonDetectionScan;

  /// No description provided for @commonDetectionNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get commonDetectionNotification;

  /// No description provided for @commonDetectionGmail.
  ///
  /// In en, this message translates to:
  /// **'Gmail'**
  String get commonDetectionGmail;

  /// No description provided for @commonReferencePrice.
  ///
  /// In en, this message translates to:
  /// **'Reference price'**
  String get commonReferencePrice;

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

  /// No description provided for @calendarViewMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get calendarViewMonth;

  /// No description provided for @calendarViewAgenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get calendarViewAgenda;

  /// Month navigator title. name = month name (EN), number = month number (VI).
  ///
  /// In en, this message translates to:
  /// **'{name} {year}'**
  String calendarMonthYear(String name, String number, String year);

  /// Agenda section for the next month.
  ///
  /// In en, this message translates to:
  /// **'{name}'**
  String calendarMonthName(String name, String number);

  /// No description provided for @calendarMonthTotal.
  ///
  /// In en, this message translates to:
  /// **'{name} total'**
  String calendarMonthTotal(String name, String number);

  /// No description provided for @calendarPaidIn.
  ///
  /// In en, this message translates to:
  /// **'Paid in {name}'**
  String calendarPaidIn(String name, String number);

  /// No description provided for @calendarCountPayments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing due} =1{1 payment} other{{count} payments}}'**
  String calendarCountPayments(int count);

  /// No description provided for @calendarCountPaid.
  ///
  /// In en, this message translates to:
  /// **'{count} paid'**
  String calendarCountPaid(int count);

  /// No description provided for @calendarCountSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count} skipped'**
  String calendarCountSkipped(int count);

  /// No description provided for @calendarCountToConfirm.
  ///
  /// In en, this message translates to:
  /// **'{count} to confirm'**
  String calendarCountToConfirm(int count);

  /// No description provided for @calendarEmpty.
  ///
  /// In en, this message translates to:
  /// **'Nothing due this month.'**
  String get calendarEmpty;

  /// No description provided for @calendarNothingDue.
  ///
  /// In en, this message translates to:
  /// **'Nothing due this day.'**
  String get calendarNothingDue;

  /// No description provided for @calendarPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get calendarPaid;

  /// No description provided for @calendarSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get calendarSkipped;

  /// No description provided for @calendarUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get calendarUpcoming;

  /// No description provided for @calendarDidNotPay.
  ///
  /// In en, this message translates to:
  /// **'Didn’t pay this period'**
  String get calendarDidNotPay;

  /// No description provided for @calendarFirstCharge.
  ///
  /// In en, this message translates to:
  /// **'First charge after trial'**
  String get calendarFirstCharge;

  /// No description provided for @calendarConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get calendarConfirm;

  /// No description provided for @calendarTodayPrefix.
  ///
  /// In en, this message translates to:
  /// **'Today · {date}'**
  String calendarTodayPrefix(String date);

  /// No description provided for @calendarGroupThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get calendarGroupThisWeek;

  /// No description provided for @calendarGroupLater.
  ///
  /// In en, this message translates to:
  /// **'Later in {name}'**
  String calendarGroupLater(String name, String number);

  /// No description provided for @calendarGroupEarlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier in {name}'**
  String calendarGroupEarlier(String name, String number);

  /// Screen-reader label of a calendar day cell.
  ///
  /// In en, this message translates to:
  /// **'{date}, {items}'**
  String calendarDayLabel(String date, String items);

  /// No description provided for @calendarLegendLabel.
  ///
  /// In en, this message translates to:
  /// **'Legend'**
  String get calendarLegendLabel;

  /// No description provided for @calendarMissingRates.
  ///
  /// In en, this message translates to:
  /// **'Amounts in {currencies} aren’t in the total — no exchange rate yet.'**
  String calendarMissingRates(String currencies);

  /// No description provided for @catalogTitle.
  ///
  /// In en, this message translates to:
  /// **'Add subscription'**
  String get catalogTitle;

  /// No description provided for @catalogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search 500+ services'**
  String get catalogSearchHint;

  /// No description provided for @catalogClearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get catalogClearSearch;

  /// No description provided for @catalogCustom.
  ///
  /// In en, this message translates to:
  /// **'Create a custom service'**
  String get catalogCustom;

  /// No description provided for @catalogCustomSub.
  ///
  /// In en, this message translates to:
  /// **'Anything not in the library'**
  String get catalogCustomSub;

  /// No description provided for @catalogCustomNamed.
  ///
  /// In en, this message translates to:
  /// **'Not seeing it? Create “{name}”'**
  String catalogCustomNamed(String name);

  /// No description provided for @catalogCreateNamed.
  ///
  /// In en, this message translates to:
  /// **'Create “{name}”'**
  String catalogCreateNamed(String name);

  /// No description provided for @catalogCustomService.
  ///
  /// In en, this message translates to:
  /// **'Custom service'**
  String get catalogCustomService;

  /// No description provided for @catalogPopularVietnam.
  ///
  /// In en, this message translates to:
  /// **'Popular in Vietnam'**
  String get catalogPopularVietnam;

  /// No description provided for @catalogPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get catalogPopular;

  /// No description provided for @catalogMore.
  ///
  /// In en, this message translates to:
  /// **'More services'**
  String get catalogMore;

  /// No description provided for @catalogResults.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 result} other{{count} results}}'**
  String catalogResults(int count);

  /// No description provided for @catalogNoResultTitle.
  ///
  /// In en, this message translates to:
  /// **'No service called “{name}”'**
  String catalogNoResultTitle(String name);

  /// No description provided for @catalogNoResultBody.
  ///
  /// In en, this message translates to:
  /// **'Create it — you can pick the colour and letters.'**
  String get catalogNoResultBody;

  /// No description provided for @catalogFrom.
  ///
  /// In en, this message translates to:
  /// **'from {price}'**
  String catalogFrom(String price);

  /// No description provided for @catalogPlans.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 plan} other{{count} plans}}'**
  String catalogPlans(int count);

  /// No description provided for @catalogAddService.
  ///
  /// In en, this message translates to:
  /// **'Add {name}'**
  String catalogAddService(String name);

  /// No description provided for @catalogPlanSubVietnam.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan · suggested prices for Vietnam'**
  String get catalogPlanSubVietnam;

  /// No description provided for @catalogPlanSub.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan · suggested prices'**
  String get catalogPlanSub;

  /// No description provided for @catalogPlanMembers.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} people'**
  String catalogPlanMembers(int count);

  /// No description provided for @catalogPlanNote.
  ///
  /// In en, this message translates to:
  /// **'You can change the price on the next screen.'**
  String get catalogPlanNote;

  /// No description provided for @catalogContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with {plan}'**
  String catalogContinueWith(String plan);

  /// No description provided for @catalogTabGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get catalogTabGeneral;

  /// No description provided for @catalogTabVietnam.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get catalogTabVietnam;

  /// No description provided for @confirmQuestion.
  ///
  /// In en, this message translates to:
  /// **'Did you pay {name}?'**
  String confirmQuestion(String name);

  /// No description provided for @confirmDueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get confirmDueToday;

  /// No description provided for @confirmOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get confirmOverdue;

  /// No description provided for @confirmMoreAfter.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more after this} other{{count} more after this}}'**
  String confirmMoreAfter(int count);

  /// No description provided for @confirmPeriodOf.
  ///
  /// In en, this message translates to:
  /// **'Period of {date}'**
  String confirmPeriodOf(String date);

  /// No description provided for @confirmAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get confirmAmount;

  /// No description provided for @confirmYourShare.
  ///
  /// In en, this message translates to:
  /// **'Your share · plan {price} ÷ {count}'**
  String confirmYourShare(String price, int count);

  /// No description provided for @confirmCurrentPrice.
  ///
  /// In en, this message translates to:
  /// **'Current price · edit if it changed'**
  String get confirmCurrentPrice;

  /// No description provided for @confirmMovesNext.
  ///
  /// In en, this message translates to:
  /// **'Confirming moves the next renewal to {date}.'**
  String confirmMovesNext(String date);

  /// No description provided for @confirmNextUp.
  ///
  /// In en, this message translates to:
  /// **'Next up: the {date} period, also waiting.'**
  String confirmNextUp(String date);

  /// No description provided for @confirmPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get confirmPaid;

  /// No description provided for @confirmSkip.
  ///
  /// In en, this message translates to:
  /// **'Didn’t pay this period'**
  String get confirmSkip;

  /// No description provided for @confirmLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get confirmLater;

  /// No description provided for @confirmAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you paid.'**
  String get confirmAmountRequired;

  /// No description provided for @confirmSaved.
  ///
  /// In en, this message translates to:
  /// **'Payment saved'**
  String get confirmSaved;

  /// No description provided for @confirmSkippedTitle.
  ///
  /// In en, this message translates to:
  /// **'Marked as not paid'**
  String get confirmSkippedTitle;

  /// No description provided for @confirmNextPeriod.
  ///
  /// In en, this message translates to:
  /// **'Next period: {date}'**
  String confirmNextPeriod(String date);

  /// No description provided for @confirmDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get confirmDone;

  /// No description provided for @confirmSavedStep.
  ///
  /// In en, this message translates to:
  /// **'{date} saved · {amount}'**
  String confirmSavedStep(String date, String amount);

  /// No description provided for @confirmSkippedStep.
  ///
  /// In en, this message translates to:
  /// **'{date} marked as not paid'**
  String confirmSkippedStep(String date);

  /// No description provided for @confirmNothingTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing to confirm'**
  String get confirmNothingTitle;

  /// No description provided for @confirmNothingBody.
  ///
  /// In en, this message translates to:
  /// **'{name} is up to date. Next renewal: {date}.'**
  String confirmNothingBody(String name, String date);

  /// No description provided for @confirmNothingCancelled.
  ///
  /// In en, this message translates to:
  /// **'{name} is cancelled, so there is nothing to confirm.'**
  String confirmNothingCancelled(String name);

  /// No description provided for @confirmAwaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get confirmAwaitingTitle;

  /// No description provided for @confirmAwaitingIntro.
  ///
  /// In en, this message translates to:
  /// **'Oldest first. Each period is confirmed one at a time, so the next date only moves once the earlier one is settled.'**
  String get confirmAwaitingIntro;

  /// No description provided for @confirmAwaitingFooter.
  ///
  /// In en, this message translates to:
  /// **'Tap a row to change the amount or mark it unpaid.'**
  String get confirmAwaitingFooter;

  /// No description provided for @confirmAgo.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{today} other{{days}d ago}}'**
  String confirmAgo(int days);

  /// No description provided for @confirmAfter.
  ///
  /// In en, this message translates to:
  /// **'After {date}'**
  String confirmAfter(String date);

  /// No description provided for @confirmMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark {name}, {date} as paid'**
  String confirmMarkPaid(String name, String date);

  /// No description provided for @confirmQueued.
  ///
  /// In en, this message translates to:
  /// **'Confirm the {date} period first'**
  String confirmQueued(String date);

  /// No description provided for @confirmQuickSaved.
  ///
  /// In en, this message translates to:
  /// **'{name} · {date} saved as paid'**
  String confirmQuickSaved(String name, String date);

  /// No description provided for @confirmAllButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm all · {amount}'**
  String confirmAllButton(String amount);

  /// No description provided for @confirmAllTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Confirm 1 payment?} other{Confirm {count} payments?}}'**
  String confirmAllTitle(int count);

  /// No description provided for @confirmAllBody.
  ///
  /// In en, this message translates to:
  /// **'Each period is saved as paid at its current price:'**
  String get confirmAllBody;

  /// No description provided for @confirmAllFooter.
  ///
  /// In en, this message translates to:
  /// **'You can edit any payment later.'**
  String get confirmAllFooter;

  /// No description provided for @confirmAllAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm all'**
  String get confirmAllAction;

  /// No description provided for @confirmAllCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get confirmAllCancel;

  /// No description provided for @confirmAllSaved.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment saved} other{{count} payments saved}}'**
  String confirmAllSaved(int count);

  /// No description provided for @confirmCaughtUp.
  ///
  /// In en, this message translates to:
  /// **'You’re all caught up 🎉'**
  String get confirmCaughtUp;

  /// No description provided for @confirmCaughtUpBody.
  ///
  /// In en, this message translates to:
  /// **'New periods show up here on their due date.'**
  String get confirmCaughtUpBody;

  /// No description provided for @confirmBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Overview'**
  String get confirmBackHome;

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

  /// No description provided for @coreApproximately.
  ///
  /// In en, this message translates to:
  /// **'approximately'**
  String get coreApproximately;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get homeTitle;

  /// No description provided for @homeSearch.
  ///
  /// In en, this message translates to:
  /// **'Search subscriptions'**
  String get homeSearch;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name'**
  String get homeSearchHint;

  /// No description provided for @homeSearchClose.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get homeSearchClose;

  /// No description provided for @homeSearchEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subscription matches “{query}”.'**
  String homeSearchEmpty(String query);

  /// No description provided for @homeMonthlySpend.
  ///
  /// In en, this message translates to:
  /// **'Monthly spend'**
  String get homeMonthlySpend;

  /// No description provided for @homeYearlySpend.
  ///
  /// In en, this message translates to:
  /// **'Yearly spend'**
  String get homeYearlySpend;

  /// No description provided for @homeActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String homeActiveCount(int count);

  /// No description provided for @homeTrialCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 trial} other{{count} trials}}'**
  String homeTrialCount(int count);

  /// No description provided for @homeBiggest.
  ///
  /// In en, this message translates to:
  /// **'Biggest: {name} · {percent}%'**
  String homeBiggest(String name, int percent);

  /// No description provided for @homeRatesStale.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{Offline · rates from yesterday} other{Offline · rates from {days} days ago}}'**
  String homeRatesStale(int days);

  /// No description provided for @homeRatesNever.
  ///
  /// In en, this message translates to:
  /// **'Offline · approximate rates'**
  String get homeRatesNever;

  /// No description provided for @homeRemindersOffTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders are off'**
  String get homeRemindersOffTitle;

  /// No description provided for @homeRemindersOffBody.
  ///
  /// In en, this message translates to:
  /// **'You won’t hear about renewals or trials ending.'**
  String get homeRemindersOffBody;

  /// No description provided for @homeRemindersTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get homeRemindersTurnOn;

  /// No description provided for @homeAwaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 payment to confirm} other{{count} payments to confirm}}'**
  String homeAwaitingTitle(int count);

  /// No description provided for @homeAwaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get homeAwaitingReview;

  /// No description provided for @homeTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'{name} trial ends {days, plural, =0{today} =1{tomorrow} other{in {days} days}}'**
  String homeTrialEnds(String name, int days);

  /// No description provided for @homeTrialThen.
  ///
  /// In en, this message translates to:
  /// **'Then {price} from {date}'**
  String homeTrialThen(String price, String date);

  /// No description provided for @homeHowToCancel.
  ///
  /// In en, this message translates to:
  /// **'How to cancel'**
  String get homeHowToCancel;

  /// No description provided for @homeKeepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get homeKeepIt;

  /// No description provided for @homeViewSubscription.
  ///
  /// In en, this message translates to:
  /// **'View subscription'**
  String get homeViewSubscription;

  /// No description provided for @homeTrialSavings.
  ///
  /// In en, this message translates to:
  /// **'Cancel before the first charge to save {amount} a year'**
  String homeTrialSavings(String amount);

  /// No description provided for @homeKept.
  ///
  /// In en, this message translates to:
  /// **'Keeping {name}. The first charge is on {date}.'**
  String homeKept(String name, String date);

  /// No description provided for @homeUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming · 7 days'**
  String get homeUpcoming;

  /// No description provided for @homeCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get homeCalendar;

  /// No description provided for @homeFirstCharge.
  ///
  /// In en, this message translates to:
  /// **'First charge'**
  String get homeFirstCharge;

  /// No description provided for @homeSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get homeSubscriptions;

  /// No description provided for @homeTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get homeTabActive;

  /// No description provided for @homeTabTrials.
  ///
  /// In en, this message translates to:
  /// **'Trials'**
  String get homeTabTrials;

  /// No description provided for @homeTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get homeTabCancelled;

  /// No description provided for @homeSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort subscriptions'**
  String get homeSortTitle;

  /// No description provided for @homeSortDue.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get homeSortDue;

  /// No description provided for @homeSortDueHint.
  ///
  /// In en, this message translates to:
  /// **'Soonest first · awaiting always on top'**
  String get homeSortDueHint;

  /// No description provided for @homeSortPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get homeSortPrice;

  /// No description provided for @homeSortPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Highest monthly cost first'**
  String get homeSortPriceHint;

  /// No description provided for @homeSortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get homeSortName;

  /// No description provided for @homeSortNameHint.
  ///
  /// In en, this message translates to:
  /// **'A → Z'**
  String get homeSortNameHint;

  /// No description provided for @homeSortDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get homeSortDone;

  /// No description provided for @homeSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by {by}'**
  String homeSortLabel(String by);

  /// No description provided for @homeSaving.
  ///
  /// In en, this message translates to:
  /// **'You’re saving'**
  String get homeSaving;

  /// No description provided for @homePerYear.
  ///
  /// In en, this message translates to:
  /// **'{amount}/year'**
  String homePerYear(String amount);

  /// No description provided for @homeCancelledOn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {date}'**
  String homeCancelledOn(String date);

  /// No description provided for @homeTrialEndsWhen.
  ///
  /// In en, this message translates to:
  /// **'ends {when}'**
  String homeTrialEndsWhen(String when);

  /// No description provided for @homeTrialBadge.
  ///
  /// In en, this message translates to:
  /// **'Trial'**
  String get homeTrialBadge;

  /// No description provided for @homeEmptyActive.
  ///
  /// In en, this message translates to:
  /// **'No active subscriptions.'**
  String get homeEmptyActive;

  /// No description provided for @homeEmptyTrials.
  ///
  /// In en, this message translates to:
  /// **'No trials right now.'**
  String get homeEmptyTrials;

  /// No description provided for @homeEmptyCancelled.
  ///
  /// In en, this message translates to:
  /// **'Nothing cancelled yet.'**
  String get homeEmptyCancelled;

  /// No description provided for @homeTrialsNote.
  ///
  /// In en, this message translates to:
  /// **'Trials aren’t in your monthly total until they turn into paid subscriptions.'**
  String get homeTrialsNote;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first subscription'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Pick from 100+ popular services — most take three taps.'**
  String get homeEmptyBody;

  /// No description provided for @homeBrowse.
  ///
  /// In en, this message translates to:
  /// **'Browse services'**
  String get homeBrowse;

  /// No description provided for @homeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add subscription'**
  String get homeAdd;

  /// No description provided for @homePausedSince.
  ///
  /// In en, this message translates to:
  /// **'since {date}'**
  String homePausedSince(String date);

  /// No description provided for @homePausesOn.
  ///
  /// In en, this message translates to:
  /// **'Pauses {date}'**
  String homePausesOn(String date);

  /// No description provided for @homeAutoBadge.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get homeAutoBadge;

  /// No description provided for @homeMoreLabels.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more label} other{{count} more labels}}'**
  String homeMoreLabels(int count);

  /// No description provided for @homeFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get homeFilter;

  /// No description provided for @homeFilterButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Filter} =1{Filter, 1 selected} other{Filter, {count} selected}}'**
  String homeFilterButtonLabel(int count);

  /// No description provided for @homeFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get homeFilterReset;

  /// No description provided for @homeFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get homeFilterStatus;

  /// No description provided for @homeFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get homeFilterCategory;

  /// No description provided for @homeFilterLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get homeFilterLabels;

  /// No description provided for @homeFilterPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get homeFilterPayment;

  /// No description provided for @homeFilterRemember.
  ///
  /// In en, this message translates to:
  /// **'Subnest remembers your filter and sort order next time.'**
  String get homeFilterRemember;

  /// No description provided for @homeFilterShow.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No subscriptions match} =1{Show 1 subscription} other{Show {count} subscriptions}}'**
  String homeFilterShow(int count);

  /// No description provided for @homeFilterChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Label: {name}'**
  String homeFilterChipLabel(String name);

  /// No description provided for @homeFilterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get homeFilterClear;

  /// No description provided for @homeFilterRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove filter {name}'**
  String homeFilterRemove(String name);

  /// No description provided for @homeEmptyFiltered.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions match this filter.'**
  String get homeEmptyFiltered;

  /// No description provided for @homeWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'Due this week'**
  String get homeWeekTitle;

  /// No description provided for @homeWeekToConfirm.
  ///
  /// In en, this message translates to:
  /// **'+{amount} to confirm'**
  String homeWeekToConfirm(String amount);

  /// No description provided for @homeWeekNothing.
  ///
  /// In en, this message translates to:
  /// **'nothing due'**
  String get homeWeekNothing;

  /// No description provided for @homeBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget {amount}'**
  String homeBudget(String amount);

  /// No description provided for @homeBudgetUsed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% used'**
  String homeBudgetUsed(int percent);

  /// No description provided for @homeAutoAddedScan.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Added 1 from your screenshot} other{Added {count} from your screenshot}}'**
  String homeAutoAddedScan(int count);

  /// No description provided for @homeAutoAdded.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Added 1 automatically} other{Added {count} automatically}}'**
  String homeAutoAdded(int count);

  /// No description provided for @homeAutoConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Confirmed 1 payment automatically} other{Confirmed {count} payments automatically}}'**
  String homeAutoConfirmed(int count);

  /// No description provided for @homeUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get homeUndo;

  /// No description provided for @homeUndone.
  ///
  /// In en, this message translates to:
  /// **'Undone'**
  String get homeUndone;

  /// No description provided for @insightsRangeMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get insightsRangeMonth;

  /// No description provided for @insightsRange12.
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get insightsRange12;

  /// No description provided for @insightsRangeYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get insightsRangeYear;

  /// Big number of the summary card: Payments + periods still expected in the range (= the bars).
  ///
  /// In en, this message translates to:
  /// **'{range, select, month{Total · this month} year{Total · this year} other{Total · last 12 months}}'**
  String insightsTotalLabel(String range);

  /// No description provided for @insightsTrendMore.
  ///
  /// In en, this message translates to:
  /// **'{range, select, month{{percent}% more than last month} year{{percent}% more than last year} other{{percent}% more than the 12 months before}}'**
  String insightsTrendMore(String range, int percent);

  /// No description provided for @insightsTrendLess.
  ///
  /// In en, this message translates to:
  /// **'{range, select, month{{percent}% less than last month} year{{percent}% less than last year} other{{percent}% less than the 12 months before}}'**
  String insightsTrendLess(String range, int percent);

  /// No description provided for @insightsTrendSame.
  ///
  /// In en, this message translates to:
  /// **'{range, select, month{Same as last month} year{Same as last year} other{Same as the 12 months before}}'**
  String insightsTrendSame(String range);

  /// Shown instead of a % when the history does not reach back to the start of the span before.
  ///
  /// In en, this message translates to:
  /// **'{range, select, month{Not enough data from last month to compare} year{Not enough data from last year to compare} other{Not enough data from the 12 months before to compare}}'**
  String insightsTrendNoData(String range);

  /// No description provided for @insightsLegendPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get insightsLegendPaid;

  /// No description provided for @insightsLegendExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected, not yet confirmed'**
  String get insightsLegendExpected;

  /// No description provided for @insightsByMonth.
  ///
  /// In en, this message translates to:
  /// **'By month'**
  String get insightsByMonth;

  /// No description provided for @insightsTapBar.
  ///
  /// In en, this message translates to:
  /// **'Tap a bar'**
  String get insightsTapBar;

  /// No description provided for @insightsTipPaid.
  ///
  /// In en, this message translates to:
  /// **'{amount} paid'**
  String insightsTipPaid(String amount);

  /// No description provided for @insightsTipExpected.
  ///
  /// In en, this message translates to:
  /// **'{amount} expected'**
  String insightsTipExpected(String amount);

  /// No description provided for @insightsChartLabel.
  ///
  /// In en, this message translates to:
  /// **'Spending per month, paid and expected, {from} to {to}'**
  String insightsChartLabel(String from, String to);

  /// Short axis/centre number: 1.07M, 500K.
  ///
  /// In en, this message translates to:
  /// **'{unit, select, k{{n}K} m{{n}M} b{{n}B} other{{n}}}'**
  String insightsCompact(String unit, String n);

  /// No description provided for @insightsAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get insightsAnd;

  /// Months in a sentence: EN names ('February and March'), VI numbers ('Tháng 2 và 3').
  ///
  /// In en, this message translates to:
  /// **'{names}'**
  String insightsMonthList(String names, String numbers);

  /// No description provided for @insightsPeakYearly.
  ///
  /// In en, this message translates to:
  /// **'{months} jump with the yearly {names} renewals.'**
  String insightsPeakYearly(String months, String names);

  /// No description provided for @insightsPeak.
  ///
  /// In en, this message translates to:
  /// **'{months} jump with the {names} renewals.'**
  String insightsPeak(String months, String names);

  /// No description provided for @insightsPeakPlain.
  ///
  /// In en, this message translates to:
  /// **'Spending was higher than usual in {months}.'**
  String insightsPeakPlain(String months);

  /// Peak months still ahead (expected, hatched bars).
  ///
  /// In en, this message translates to:
  /// **'{months} will jump with the yearly {names} renewals.'**
  String insightsPeakYearlyAhead(String months, String names);

  /// No description provided for @insightsPeakAhead.
  ///
  /// In en, this message translates to:
  /// **'{months} will jump with the {names} renewals.'**
  String insightsPeakAhead(String months, String names);

  /// No description provided for @insightsPeakPlainAhead.
  ///
  /// In en, this message translates to:
  /// **'Spending will be higher than usual in {months}.'**
  String insightsPeakPlainAhead(String months);

  /// No description provided for @insightsByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get insightsByCategory;

  /// No description provided for @insightsMonthlyActive.
  ///
  /// In en, this message translates to:
  /// **'monthly equivalent, active plans'**
  String get insightsMonthlyActive;

  /// Under the donut when a plan is not billed monthly.
  ///
  /// In en, this message translates to:
  /// **'Yearly and other non-monthly plans are spread evenly per month here, so this is not what you pay this month.'**
  String get insightsCategoryNote;

  /// No description provided for @insightsSliceLabel.
  ///
  /// In en, this message translates to:
  /// **'{category}: {amount} per month, {percent}%'**
  String insightsSliceLabel(String category, String amount, int percent);

  /// No description provided for @insightsCategoryShare.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of your monthly spend'**
  String insightsCategoryShare(int percent);

  /// No description provided for @insightsPerMonthShort.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get insightsPerMonthShort;

  /// No description provided for @insightsCycleNoteOne.
  ///
  /// In en, this message translates to:
  /// **'{name} is billed {price} — counted here as its monthly share.'**
  String insightsCycleNoteOne(String name, String price);

  /// No description provided for @insightsCycleNoteMany.
  ///
  /// In en, this message translates to:
  /// **'Plans not billed monthly are counted here as their monthly share.'**
  String get insightsCycleNoteMany;

  /// No description provided for @insightsTop.
  ///
  /// In en, this message translates to:
  /// **'Most expensive'**
  String get insightsTop;

  /// No description provided for @insightsSaving.
  ///
  /// In en, this message translates to:
  /// **'You’re saving'**
  String get insightsSaving;

  /// No description provided for @insightsSavingBy.
  ///
  /// In en, this message translates to:
  /// **'by cancelling {names}'**
  String insightsSavingBy(String names);

  /// No description provided for @insightsSavingByCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{by cancelling 1 service} other{by cancelling {count} services}}'**
  String insightsSavingByCount(int count);

  /// No description provided for @insightsOverlapTitle.
  ///
  /// In en, this message translates to:
  /// **'{category, select, music{You pay for {count} music services} other{You pay for {count} video services}}'**
  String insightsOverlapTitle(String category, int count);

  /// No description provided for @insightsOverlapBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{{names} together are {amount}/month. Need both?} other{{names} together are {amount}/month. Need all of them?}}'**
  String insightsOverlapBody(int count, String names, String amount);

  /// No description provided for @insightsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add subscriptions to see insights'**
  String get insightsEmptyTitle;

  /// No description provided for @insightsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Your spending by month and category shows up here once you’ve added a few.'**
  String get insightsEmptyBody;

  /// No description provided for @insightsEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Add a subscription'**
  String get insightsEmptyAction;

  /// No description provided for @manageCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get manageCategoriesTitle;

  /// No description provided for @manageLabelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get manageLabelsTitle;

  /// No description provided for @managePaymentMethodsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment methods'**
  String get managePaymentMethodsTitle;

  /// No description provided for @manageBudgetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get manageBudgetsTitle;

  /// No description provided for @managePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get managePlaceholder;

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

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStep(int step, int total);

  /// No description provided for @onboardingLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Subnest speaks English and Vietnamese. You can change this any time in Settings.'**
  String get onboardingLanguageHint;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'All your subscriptions, one nest'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingBenefitRemind.
  ///
  /// In en, this message translates to:
  /// **'Reminders before you’re charged'**
  String get onboardingBenefitRemind;

  /// No description provided for @onboardingBenefitRemindSub.
  ///
  /// In en, this message translates to:
  /// **'3 days ahead, and before trials end.'**
  String get onboardingBenefitRemindSub;

  /// No description provided for @onboardingBenefitTotal.
  ///
  /// In en, this message translates to:
  /// **'Know exactly what each month costs'**
  String get onboardingBenefitTotal;

  /// No description provided for @onboardingBenefitTotalSub.
  ///
  /// In en, this message translates to:
  /// **'In your currency, shared plans split fairly.'**
  String get onboardingBenefitTotalSub;

  /// No description provided for @onboardingBenefitPrivate.
  ///
  /// In en, this message translates to:
  /// **'Private — data stays on your phone'**
  String get onboardingBenefitPrivate;

  /// No description provided for @onboardingBenefitPrivateSub.
  ///
  /// In en, this message translates to:
  /// **'No account, no bank link, no tracking.'**
  String get onboardingBenefitPrivateSub;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @onboardingCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your main currency'**
  String get onboardingCurrencyTitle;

  /// No description provided for @onboardingCurrencyHint.
  ///
  /// In en, this message translates to:
  /// **'Used to add up your totals. Each subscription still keeps its own currency.'**
  String get onboardingCurrencyHint;

  /// No description provided for @onboardingCurrencyDefault.
  ///
  /// In en, this message translates to:
  /// **'Default — change it any time'**
  String get onboardingCurrencyDefault;

  /// No description provided for @onboardingCurrencyChosen.
  ///
  /// In en, this message translates to:
  /// **'Your choice'**
  String get onboardingCurrencyChosen;

  /// No description provided for @onboardingCurrencyChange.
  ///
  /// In en, this message translates to:
  /// **'Choose another currency'**
  String get onboardingCurrencyChange;

  /// No description provided for @onboardingCurrencyRatesNote.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates update once a day when you’re online. You can set your own in Settings.'**
  String get onboardingCurrencyRatesNote;

  /// No description provided for @onboardingCurrencySheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Main currency'**
  String get onboardingCurrencySheetTitle;

  /// No description provided for @onboardingCurrencySearch.
  ///
  /// In en, this message translates to:
  /// **'Search currency or country'**
  String get onboardingCurrencySearch;

  /// No description provided for @onboardingPickTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you pay for?'**
  String get onboardingPickTitle;

  /// No description provided for @onboardingPickSearch.
  ///
  /// In en, this message translates to:
  /// **'Search 100+ services'**
  String get onboardingPickSearch;

  /// No description provided for @onboardingPickSelected.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nothing selected yet} =1{1 selected} other{{count} selected}}'**
  String onboardingPickSelected(int count);

  /// No description provided for @onboardingPickNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No service called “{name}”. You can add it later with +.'**
  String onboardingPickNoMatch(String name);

  /// No description provided for @onboardingPickMeta.
  ///
  /// In en, this message translates to:
  /// **'{price} · {cycle}'**
  String onboardingPickMeta(String price, String cycle);

  /// No description provided for @onboardingPickEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get onboardingPickEdit;

  /// No description provided for @onboardingPickEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit price and cycle of {name}'**
  String onboardingPickEditLabel(String name);

  /// No description provided for @onboardingLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get onboardingLater;

  /// No description provided for @onboardingQuickPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get onboardingQuickPlan;

  /// No description provided for @onboardingQuickPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get onboardingQuickPrice;

  /// No description provided for @onboardingQuickCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle'**
  String get onboardingQuickCycle;

  /// No description provided for @onboardingQuickRemove.
  ///
  /// In en, this message translates to:
  /// **'Don’t add it'**
  String get onboardingQuickRemove;

  /// No description provided for @onboardingRemindersTitle.
  ///
  /// In en, this message translates to:
  /// **'A heads-up before every charge'**
  String get onboardingRemindersTitle;

  /// No description provided for @onboardingRemindersBody.
  ///
  /// In en, this message translates to:
  /// **'We’ll remind you 3 days before a renewal or a trial ending, at {time}. Change it any time.'**
  String onboardingRemindersBody(String time);

  /// No description provided for @onboardingDemoNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get onboardingDemoNow;

  /// No description provided for @onboardingDemoAgo.
  ///
  /// In en, this message translates to:
  /// **'2d ago'**
  String get onboardingDemoAgo;

  /// No description provided for @onboardingDemoRenews.
  ///
  /// In en, this message translates to:
  /// **'{name} renews in 3 days — {price}'**
  String onboardingDemoRenews(String name, String price);

  /// No description provided for @onboardingDemoTrial.
  ///
  /// In en, this message translates to:
  /// **'Your {name} trial ends in 3 days.'**
  String onboardingDemoTrial(String name);

  /// No description provided for @onboardingDemoLabel.
  ///
  /// In en, this message translates to:
  /// **'Example reminders'**
  String get onboardingDemoLabel;

  /// No description provided for @onboardingEnableReminders.
  ///
  /// In en, this message translates to:
  /// **'Turn on reminders'**
  String get onboardingEnableReminders;

  /// No description provided for @onboardingNoThanks.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get onboardingNoThanks;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan screenshots'**
  String get scanTitle;

  /// No description provided for @scanPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get scanPlaceholder;

  /// Settings: section header after Data (PIN lock, Privacy screen).
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securitySection;

  /// Settings: switch row for App lock (4-digit PIN); also the title bar of the PIN screens.
  ///
  /// In en, this message translates to:
  /// **'PIN lock'**
  String get securityPinLock;

  /// Under the PIN lock switch and on the first step of choosing a PIN.
  ///
  /// In en, this message translates to:
  /// **'If you forget the PIN, the only way back in is to delete all data in the app.'**
  String get securityPinWarning;

  /// Lock screen title; also when turning the PIN lock off.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get securityEnterPin;

  /// No description provided for @securityNewPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN'**
  String get securityNewPin;

  /// No description provided for @securityConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Enter the PIN again'**
  String get securityConfirmPin;

  /// Choosing a PIN: the second entry differs; the user starts over.
  ///
  /// In en, this message translates to:
  /// **'The PINs do not match. Try again.'**
  String get securityPinMismatch;

  /// No description provided for @securityWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN'**
  String get securityWrongPin;

  /// Text button at the bottom of the lock screen.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN'**
  String get securityForgotPin;

  /// No description provided for @securityForgotPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your PIN?'**
  String get securityForgotPinTitle;

  /// Dialog from Forgot PIN; the next step is Delete all data (two more confirmations).
  ///
  /// In en, this message translates to:
  /// **'Subnest has no server, so a PIN cannot be recovered. You can delete all data in the app to use it again.'**
  String get securityForgotPinBody;

  /// Screen reader label of a PIN keypad key.
  ///
  /// In en, this message translates to:
  /// **'Digit {digit}'**
  String securityKeypadDigit(String digit);

  /// Screen reader label of the PIN keypad backspace key.
  ///
  /// In en, this message translates to:
  /// **'Delete last digit'**
  String get securityKeypadBackspace;

  /// Screen reader label of the PIN dots.
  ///
  /// In en, this message translates to:
  /// **'{count} of 4 digits entered'**
  String securityPinProgress(int count);

  /// Settings: Privacy screen switch (independent of PIN lock, off by default).
  ///
  /// In en, this message translates to:
  /// **'Hide content when switching apps'**
  String get securityPrivacyScreen;

  /// Under the Privacy screen switch on Android.
  ///
  /// In en, this message translates to:
  /// **'Blocks screenshots and hides content in the recent apps list'**
  String get securityPrivacyScreenNote;

  /// No description provided for @securityPrivacyScreenNoteIos.
  ///
  /// In en, this message translates to:
  /// **'Hides content in the app switcher. iPhone does not let apps block screenshots.'**
  String get securityPrivacyScreenNoteIos;

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
  /// **'Offline · rates from {ago}'**
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

  /// No description provided for @settingsPreviewSampleName.
  ///
  /// In en, this message translates to:
  /// **'Your subscription'**
  String get settingsPreviewSampleName;

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
  /// **'Pick a Subnest backup (.subnest)'**
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

  /// No description provided for @settingsRestoreReplaceAction.
  ///
  /// In en, this message translates to:
  /// **'Replace my data'**
  String get settingsRestoreReplaceAction;

  /// No description provided for @settingsRestoreReplaceNote.
  ///
  /// In en, this message translates to:
  /// **'Everything on this phone — subscriptions, payments, lists and settings — will be replaced by this backup. Automatic backup stays as it is.'**
  String get settingsRestoreReplaceNote;

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

  /// No description provided for @settingsLogosTitle.
  ///
  /// In en, this message translates to:
  /// **'Service logos'**
  String get settingsLogosTitle;

  /// No description provided for @settingsLogosOwnership.
  ///
  /// In en, this message translates to:
  /// **'Service names and logos belong to their owners and are shown only to identify the service.'**
  String get settingsLogosOwnership;

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

  /// No description provided for @settingsSectionData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get settingsSectionData;

  /// No description provided for @settingsDataNote.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this phone. Back it up before changing phones.'**
  String get settingsDataNote;

  /// No description provided for @settingsExportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export backup'**
  String get settingsExportBackup;

  /// No description provided for @settingsExportBackupHint.
  ///
  /// In en, this message translates to:
  /// **'Encrypted .subnest file to restore later'**
  String get settingsExportBackupHint;

  /// No description provided for @settingsAutoBackup.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup'**
  String get settingsAutoBackup;

  /// No description provided for @settingsAutoBackupNote.
  ///
  /// In en, this message translates to:
  /// **'Backs up once a day to a folder you choose. Uploading to Google Drive or Dropbox is done by that app.'**
  String get settingsAutoBackupNote;

  /// No description provided for @settingsAutoBackupNoteIos.
  ///
  /// In en, this message translates to:
  /// **'Subnest only writes files to the folder you choose in the Files app, for example in iCloud Drive.'**
  String get settingsAutoBackupNoteIos;

  /// No description provided for @settingsAutoBackupRunsOnOpenIos.
  ///
  /// In en, this message translates to:
  /// **'iPhone does not let closed apps run on their own. At the time you chose, Subnest sends a notification; tap it or open the app to back up. If the time is missed, the backup catches up when you open the app, at most once a day.'**
  String get settingsAutoBackupRunsOnOpenIos;

  /// No description provided for @settingsAutoBackupFolder.
  ///
  /// In en, this message translates to:
  /// **'Folder: {name}'**
  String settingsAutoBackupFolder(String name);

  /// No description provided for @settingsAutoBackupFolderUnknown.
  ///
  /// In en, this message translates to:
  /// **'Chosen folder'**
  String get settingsAutoBackupFolderUnknown;

  /// No description provided for @settingsAutoBackupLocalFolderWarningIos.
  ///
  /// In en, this message translates to:
  /// **'This folder may be stored only on this iPhone. If so, losing the phone means losing these files. To keep them safe, choose a folder in iCloud Drive or Google Drive.'**
  String get settingsAutoBackupLocalFolderWarningIos;

  /// No description provided for @settingsAutoBackupLast.
  ///
  /// In en, this message translates to:
  /// **'Last backup {time}'**
  String settingsAutoBackupLast(String time);

  /// No description provided for @settingsAutoBackupLastUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Checked {checked}: data unchanged, kept the earlier copy. Last backup {last}.'**
  String settingsAutoBackupLastUnchanged(String checked, String last);

  /// No description provided for @settingsAutoBackupNever.
  ///
  /// In en, this message translates to:
  /// **'No automatic backup yet'**
  String get settingsAutoBackupNever;

  /// No description provided for @settingsAutoBackupFailedAt.
  ///
  /// In en, this message translates to:
  /// **'Last attempt {time}: {error}'**
  String settingsAutoBackupFailedAt(String time, String error);

  /// No description provided for @settingsAutoBackupErrorFolder.
  ///
  /// In en, this message translates to:
  /// **'folder unavailable — choose it again'**
  String get settingsAutoBackupErrorFolder;

  /// No description provided for @settingsAutoBackupErrorOther.
  ///
  /// In en, this message translates to:
  /// **'backup failed'**
  String get settingsAutoBackupErrorOther;

  /// No description provided for @settingsAutoBackupNextToday.
  ///
  /// In en, this message translates to:
  /// **'Next: today, {time}'**
  String settingsAutoBackupNextToday(String time);

  /// No description provided for @settingsAutoBackupNextTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Next: tomorrow, {time}'**
  String settingsAutoBackupNextTomorrow(String time);

  /// No description provided for @settingsAutoBackupNextSoon.
  ///
  /// In en, this message translates to:
  /// **'Due now — runs when you leave the app'**
  String get settingsAutoBackupNextSoon;

  /// No description provided for @settingsAutoBackupNextSoonIos.
  ///
  /// In en, this message translates to:
  /// **'Due now — runs when you open the app'**
  String get settingsAutoBackupNextSoonIos;

  /// No description provided for @settingsAutoBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get settingsAutoBackupNow;

  /// No description provided for @settingsAutoBackupChooseFolder.
  ///
  /// In en, this message translates to:
  /// **'Choose folder'**
  String get settingsAutoBackupChooseFolder;

  /// No description provided for @settingsAutoBackupTime.
  ///
  /// In en, this message translates to:
  /// **'Backup time'**
  String get settingsAutoBackupTime;

  /// No description provided for @settingsAutoBackupTurnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get settingsAutoBackupTurnOn;

  /// No description provided for @settingsAutoBackupOffDone.
  ///
  /// In en, this message translates to:
  /// **'Automatic backup turned off'**
  String get settingsAutoBackupOffDone;

  /// No description provided for @settingsAutoBackupDone.
  ///
  /// In en, this message translates to:
  /// **'Backup saved'**
  String get settingsAutoBackupDone;

  /// No description provided for @settingsAutoBackupBusy.
  ///
  /// In en, this message translates to:
  /// **'A backup is already running'**
  String get settingsAutoBackupBusy;

  /// No description provided for @settingsAutoBackupPickFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open the folder picker'**
  String get settingsAutoBackupPickFailed;

  /// No description provided for @settingsAutoBackupPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Password for automatic backups'**
  String get settingsAutoBackupPasswordTitle;

  /// No description provided for @settingsAutoBackupPasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'If you forget this password, the backup cannot be opened. Subnest cannot recover it.'**
  String get settingsAutoBackupPasswordWarning;

  /// No description provided for @settingsAutoBackupNotifyTitleIos.
  ///
  /// In en, this message translates to:
  /// **'Allow backup reminders?'**
  String get settingsAutoBackupNotifyTitleIos;

  /// No description provided for @settingsAutoBackupNotifyBodyIos.
  ///
  /// In en, this message translates to:
  /// **'Subnest sends one reminder at your backup time. Tapping it backs up your data.'**
  String get settingsAutoBackupNotifyBodyIos;

  /// No description provided for @settingsAutoBackupNotifyDeniedIos.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off. Automatic backup still runs when you open the app.'**
  String get settingsAutoBackupNotifyDeniedIos;

  /// No description provided for @settingsAutoBackupNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time to back up your subscriptions.'**
  String get settingsAutoBackupNotificationBody;

  /// No description provided for @settingsBackupPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsBackupPassword;

  /// No description provided for @settingsBackupPasswordConfirm.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get settingsBackupPasswordConfirm;

  /// No description provided for @settingsBackupPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 6 characters'**
  String get settingsBackupPasswordTooShort;

  /// No description provided for @settingsBackupPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords don’t match'**
  String get settingsBackupPasswordMismatch;

  /// No description provided for @settingsBackupPasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'Without this password the file cannot be opened. Keep it somewhere safe.'**
  String get settingsBackupPasswordWarning;

  /// No description provided for @settingsBackupProtect.
  ///
  /// In en, this message translates to:
  /// **'Protect with a password'**
  String get settingsBackupProtect;

  /// No description provided for @settingsBackupExportNote.
  ///
  /// In en, this message translates to:
  /// **'The file holds everything: subscriptions, payments, categories and settings.'**
  String get settingsBackupExportNote;

  /// No description provided for @settingsBackupExportAction.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get settingsBackupExportAction;

  /// No description provided for @settingsBackupWorking.
  ///
  /// In en, this message translates to:
  /// **'Working…'**
  String get settingsBackupWorking;

  /// No description provided for @settingsBackupEnterPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter backup password'**
  String get settingsBackupEnterPasswordTitle;

  /// No description provided for @settingsBackupEnterPasswordBody.
  ///
  /// In en, this message translates to:
  /// **'This backup is encrypted. Enter the password you set when exporting it.'**
  String get settingsBackupEnterPasswordBody;

  /// No description provided for @settingsBackupWrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password, or the file was changed'**
  String get settingsBackupWrongPassword;

  /// No description provided for @settingsBackupOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get settingsBackupOpen;

  /// No description provided for @settingsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get settingsDeleteAll;

  /// No description provided for @settingsDeleteAllHint.
  ///
  /// In en, this message translates to:
  /// **'Everything, like a new install'**
  String get settingsDeleteAllHint;

  /// No description provided for @settingsDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get settingsDeleteAllTitle;

  /// No description provided for @settingsDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'This removes all subscriptions, payments, categories, labels, budgets and settings from this phone and turns off automatic backup and PIN lock. Files already backed up stay in their folder. Subnest then starts again like a new install.'**
  String get settingsDeleteAllConfirm;

  /// No description provided for @settingsDeleteAllConfirm2.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. Export a backup first if you might need it.'**
  String get settingsDeleteAllConfirm2;

  /// No description provided for @settingsCannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone'**
  String get settingsCannotUndo;

  /// No description provided for @settingsDeleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get settingsDeleteEverything;

  /// No description provided for @settingsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDelete;

  /// No description provided for @settingsDeleteAllDone.
  ///
  /// In en, this message translates to:
  /// **'All data deleted'**
  String get settingsDeleteAllDone;

  /// No description provided for @subscriptionDetailEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get subscriptionDetailEdit;

  /// No description provided for @subscriptionDetailStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get subscriptionDetailStatusActive;

  /// No description provided for @subscriptionDetailStatusTrial.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Trial · ends today} =1{Trial · 1 day left} other{Trial · {days} days left}}'**
  String subscriptionDetailStatusTrial(int days);

  /// No description provided for @subscriptionDetailStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get subscriptionDetailStatusCancelled;

  /// No description provided for @subscriptionDetailYourShare.
  ///
  /// In en, this message translates to:
  /// **'Your share · plan {price} ÷ {count}'**
  String subscriptionDetailYourShare(String price, int count);

  /// No description provided for @subscriptionDetailAwaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Renewal on {date} needs confirming} other{{count} renewals need confirming, from {date}}}'**
  String subscriptionDetailAwaitingTitle(int count, String date);

  /// No description provided for @subscriptionDetailAwaitingBody.
  ///
  /// In en, this message translates to:
  /// **'Did {amount} go out? The next date waits until you say.'**
  String subscriptionDetailAwaitingBody(String amount);

  /// No description provided for @subscriptionDetailConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get subscriptionDetailConfirm;

  /// No description provided for @subscriptionDetailTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial ends {date}'**
  String subscriptionDetailTrialEnds(String date);

  /// No description provided for @subscriptionDetailTrialBody.
  ///
  /// In en, this message translates to:
  /// **'After that it renews at {price}. Cancel before then if you don’t want it.'**
  String subscriptionDetailTrialBody(String price);

  /// No description provided for @subscriptionDetailHowToCancel.
  ///
  /// In en, this message translates to:
  /// **'How to cancel'**
  String get subscriptionDetailHowToCancel;

  /// No description provided for @subscriptionDetailKeepIt.
  ///
  /// In en, this message translates to:
  /// **'Keep it'**
  String get subscriptionDetailKeepIt;

  /// No description provided for @subscriptionDetailKept.
  ///
  /// In en, this message translates to:
  /// **'Keeping {name}. The first charge is on {date}.'**
  String subscriptionDetailKept(String name, String date);

  /// No description provided for @subscriptionDetailSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving {amount}/year'**
  String subscriptionDetailSaving(String amount);

  /// No description provided for @subscriptionDetailCancelledBody.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {date}. No more reminders.'**
  String subscriptionDetailCancelledBody(String date);

  /// No description provided for @subscriptionDetailRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore subscription'**
  String get subscriptionDetailRestore;

  /// No description provided for @subscriptionDetailRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored. Next renewal: {date}.'**
  String subscriptionDetailRestored(String date);

  /// No description provided for @subscriptionDetailNextRenewal.
  ///
  /// In en, this message translates to:
  /// **'Next renewal'**
  String get subscriptionDetailNextRenewal;

  /// No description provided for @subscriptionDetailFirstCharge.
  ///
  /// In en, this message translates to:
  /// **'First charge'**
  String get subscriptionDetailFirstCharge;

  /// No description provided for @subscriptionDetailWaits.
  ///
  /// In en, this message translates to:
  /// **'Waits for your confirmation'**
  String get subscriptionDetailWaits;

  /// No description provided for @subscriptionDetailCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle'**
  String get subscriptionDetailCycle;

  /// No description provided for @subscriptionDetailEveryDay.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every day} other{Every {count} days}}'**
  String subscriptionDetailEveryDay(int count);

  /// No description provided for @subscriptionDetailEveryWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every week} other{Every {count} weeks}}'**
  String subscriptionDetailEveryWeek(int count);

  /// No description provided for @subscriptionDetailEveryMonth.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every month} other{Every {count} months}}'**
  String subscriptionDetailEveryMonth(int count);

  /// No description provided for @subscriptionDetailEveryYear.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Every year} other{Every {count} years}}'**
  String subscriptionDetailEveryYear(int count);

  /// No description provided for @subscriptionDetailRemindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get subscriptionDetailRemindMe;

  /// No description provided for @subscriptionDetailRemindValue.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{On the day, {time}} =1{1 day before, {time}} other{{days} days before, {time}}}'**
  String subscriptionDetailRemindValue(int days, String time);

  /// No description provided for @subscriptionDetailRemindOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get subscriptionDetailRemindOff;

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

  /// No description provided for @subscriptionDetailSince.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get subscriptionDetailSince;

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

  /// No description provided for @subscriptionDetailDidntPay.
  ///
  /// In en, this message translates to:
  /// **'Didn’t pay'**
  String get subscriptionDetailDidntPay;

  /// No description provided for @subscriptionDetailNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No payments yet — the first charge is on {date}.'**
  String subscriptionDetailNoHistory(String date);

  /// No description provided for @subscriptionDetailNoHistoryCancelled.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded.'**
  String get subscriptionDetailNoHistoryCancelled;

  /// No description provided for @subscriptionDetailEditPayment.
  ///
  /// In en, this message translates to:
  /// **'Edit payment of {date}'**
  String subscriptionDetailEditPayment(String date);

  /// No description provided for @subscriptionDetailConfirmPeriod.
  ///
  /// In en, this message translates to:
  /// **'Confirm the period of {date}'**
  String subscriptionDetailConfirmPeriod(String date);

  /// No description provided for @subscriptionDetailHowToCancelRow.
  ///
  /// In en, this message translates to:
  /// **'How to cancel this service'**
  String get subscriptionDetailHowToCancelRow;

  /// No description provided for @subscriptionDetailOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens {host} account settings'**
  String subscriptionDetailOpens(String host);

  /// No description provided for @subscriptionDetailLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open {host}.'**
  String subscriptionDetailLinkFailed(String host);

  /// No description provided for @subscriptionDetailMarkCancelled.
  ///
  /// In en, this message translates to:
  /// **'Mark as cancelled'**
  String get subscriptionDetailMarkCancelled;

  /// No description provided for @subscriptionDetailDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete subscription'**
  String get subscriptionDetailDelete;

  /// No description provided for @subscriptionDetailCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Mark {name} as cancelled?'**
  String subscriptionDetailCancelTitle(String name);

  /// No description provided for @subscriptionDetailCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Reminders stop and {amount}/year moves into your savings. You can restore it any time.'**
  String subscriptionDetailCancelBody(String amount);

  /// No description provided for @subscriptionDetailNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not yet'**
  String get subscriptionDetailNotYet;

  /// No description provided for @subscriptionDetailDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String subscriptionDetailDeleteTitle(String name);

  /// No description provided for @subscriptionDetailDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{This removes it for good. To stop reminders but keep it, mark it as cancelled instead.} =1{This removes it and its 1 payment record for good. To stop reminders but keep the history, mark it as cancelled instead.} other{This removes it and its {count} payment records for good. To stop reminders but keep the history, mark it as cancelled instead.}}'**
  String subscriptionDetailDeleteBody(int count);

  /// No description provided for @subscriptionDetailDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get subscriptionDetailDeleteAction;

  /// No description provided for @subscriptionDetailDeleted.
  ///
  /// In en, this message translates to:
  /// **'{name} deleted'**
  String subscriptionDetailDeleted(String name);

  /// No description provided for @subscriptionDetailCelebrateCancelled.
  ///
  /// In en, this message translates to:
  /// **'{name} cancelled'**
  String subscriptionDetailCelebrateCancelled(String name);

  /// No description provided for @subscriptionDetailCelebrateYear.
  ///
  /// In en, this message translates to:
  /// **'a year saved'**
  String get subscriptionDetailCelebrateYear;

  /// No description provided for @subscriptionDetailCelebrateNow.
  ///
  /// In en, this message translates to:
  /// **'You’re now saving'**
  String get subscriptionDetailCelebrateNow;

  /// No description provided for @subscriptionDetailPerYear.
  ///
  /// In en, this message translates to:
  /// **'{amount}/year'**
  String subscriptionDetailPerYear(String amount);

  /// No description provided for @subscriptionDetailSeeCancelled.
  ///
  /// In en, this message translates to:
  /// **'See cancelled'**
  String get subscriptionDetailSeeCancelled;

  /// No description provided for @subscriptionDetailPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment · {date}'**
  String subscriptionDetailPaymentTitle(String date);

  /// No description provided for @subscriptionDetailAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get subscriptionDetailAmountPaid;

  /// No description provided for @subscriptionDetailWas.
  ///
  /// In en, this message translates to:
  /// **'Was {old} — saving updates Total paid to {total}.'**
  String subscriptionDetailWas(String old, String total);

  /// No description provided for @subscriptionDetailAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you paid.'**
  String get subscriptionDetailAmountRequired;

  /// No description provided for @subscriptionDetailPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid on'**
  String get subscriptionDetailPaidOn;

  /// No description provided for @subscriptionDetailPaidWith.
  ///
  /// In en, this message translates to:
  /// **'Paid with'**
  String get subscriptionDetailPaidWith;

  /// No description provided for @subscriptionDetailSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get subscriptionDetailSave;

  /// No description provided for @subscriptionDetailMarkNotPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as not paid'**
  String get subscriptionDetailMarkNotPaid;

  /// No description provided for @subscriptionDetailCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get subscriptionDetailCancel;

  /// No description provided for @subscriptionDetailPaymentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Payment updated'**
  String get subscriptionDetailPaymentUpdated;

  /// No description provided for @subscriptionDetailMarkedNotPaid.
  ///
  /// In en, this message translates to:
  /// **'Marked as not paid'**
  String get subscriptionDetailMarkedNotPaid;

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

  /// No description provided for @subscriptionFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'Service name'**
  String get subscriptionFormNameHint;

  /// No description provided for @subscriptionFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get subscriptionFormNameRequired;

  /// No description provided for @subscriptionFormEditTile.
  ///
  /// In en, this message translates to:
  /// **'Change tile'**
  String get subscriptionFormEditTile;

  /// No description provided for @subscriptionFormPlan.
  ///
  /// In en, this message translates to:
  /// **'Plan: {name}'**
  String subscriptionFormPlan(String name);

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
  /// **'Price must be more than 0'**
  String get subscriptionFormPriceRequired;

  /// No description provided for @subscriptionFormPriceWas.
  ///
  /// In en, this message translates to:
  /// **'Was {old}. The new price applies from the next period ({date}). Past payments stay as they were.'**
  String subscriptionFormPriceWas(String old, String date);

  /// No description provided for @subscriptionFormCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle'**
  String get subscriptionFormCycle;

  /// No description provided for @subscriptionFormEvery.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get subscriptionFormEvery;

  /// No description provided for @subscriptionFormEveryCount.
  ///
  /// In en, this message translates to:
  /// **'Number of units in one billing cycle'**
  String get subscriptionFormEveryCount;

  /// No description provided for @subscriptionFormUnitDay.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{days}}'**
  String subscriptionFormUnitDay(int count);

  /// No description provided for @subscriptionFormUnitWeek.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{week} other{weeks}}'**
  String subscriptionFormUnitWeek(int count);

  /// No description provided for @subscriptionFormUnitMonth.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{month} other{months}}'**
  String subscriptionFormUnitMonth(int count);

  /// No description provided for @subscriptionFormUnitYear.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{year} other{years}}'**
  String subscriptionFormUnitYear(int count);

  /// No description provided for @subscriptionFormUnitLabel.
  ///
  /// In en, this message translates to:
  /// **'Cycle unit: {unit}'**
  String subscriptionFormUnitLabel(String unit);

  /// No description provided for @subscriptionFormChipWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get subscriptionFormChipWeekly;

  /// No description provided for @subscriptionFormChipMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subscriptionFormChipMonthly;

  /// No description provided for @subscriptionFormChipQuarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get subscriptionFormChipQuarterly;

  /// No description provided for @subscriptionFormChipYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get subscriptionFormChipYearly;

  /// No description provided for @subscriptionFormNextDue.
  ///
  /// In en, this message translates to:
  /// **'Next renewal'**
  String get subscriptionFormNextDue;

  /// No description provided for @subscriptionFormFirstCharge.
  ///
  /// In en, this message translates to:
  /// **'First charge'**
  String get subscriptionFormFirstCharge;

  /// No description provided for @subscriptionFormThen.
  ///
  /// In en, this message translates to:
  /// **'Then {dates}…'**
  String subscriptionFormThen(String dates);

  /// No description provided for @subscriptionFormTrial.
  ///
  /// In en, this message translates to:
  /// **'Free trial'**
  String get subscriptionFormTrial;

  /// No description provided for @subscriptionFormTrialSub.
  ///
  /// In en, this message translates to:
  /// **'Remind me before it ends'**
  String get subscriptionFormTrialSub;

  /// No description provided for @subscriptionFormTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial ends'**
  String get subscriptionFormTrialEnds;

  /// No description provided for @subscriptionFormTrialEndInvalid.
  ///
  /// In en, this message translates to:
  /// **'Trial end can’t be in the past'**
  String get subscriptionFormTrialEndInvalid;

  /// No description provided for @subscriptionFormShared.
  ///
  /// In en, this message translates to:
  /// **'Split with others'**
  String get subscriptionFormShared;

  /// No description provided for @subscriptionFormSharedSub.
  ///
  /// In en, this message translates to:
  /// **'Totals use your share'**
  String get subscriptionFormSharedSub;

  /// No description provided for @subscriptionFormPeople.
  ///
  /// In en, this message translates to:
  /// **'People, including you'**
  String get subscriptionFormPeople;

  /// No description provided for @subscriptionFormYourShare.
  ///
  /// In en, this message translates to:
  /// **'Your share'**
  String get subscriptionFormYourShare;

  /// No description provided for @subscriptionFormShareOf.
  ///
  /// In en, this message translates to:
  /// **'{price} ÷ {count}'**
  String subscriptionFormShareOf(String price, int count);

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

  /// No description provided for @subscriptionFormRemindOnDay.
  ///
  /// In en, this message translates to:
  /// **'On day'**
  String get subscriptionFormRemindOnDay;

  /// No description provided for @subscriptionFormRemindDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String subscriptionFormRemindDays(int count);

  /// No description provided for @subscriptionFormRemindNone.
  ///
  /// In en, this message translates to:
  /// **'No reminder for this subscription'**
  String get subscriptionFormRemindNone;

  /// No description provided for @subscriptionFormMore.
  ///
  /// In en, this message translates to:
  /// **'More details'**
  String get subscriptionFormMore;

  /// No description provided for @subscriptionFormMoreSub.
  ///
  /// In en, this message translates to:
  /// **'Cancel link, notes'**
  String get subscriptionFormMoreSub;

  /// No description provided for @subscriptionFormPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get subscriptionFormPaymentMethod;

  /// No description provided for @subscriptionFormManageUrl.
  ///
  /// In en, this message translates to:
  /// **'Cancel / manage link'**
  String get subscriptionFormManageUrl;

  /// No description provided for @subscriptionFormManageUrlFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Filled in from the library. Opens from “How to cancel”.'**
  String get subscriptionFormManageUrlFromLibrary;

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

  /// No description provided for @subscriptionFormPriceDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Use {price} from the next period?'**
  String subscriptionFormPriceDialogTitle(String price);

  /// No description provided for @subscriptionFormPriceDialogBody.
  ///
  /// In en, this message translates to:
  /// **'The {date} renewal and later ones use the new price.'**
  String subscriptionFormPriceDialogBody(String date);

  /// No description provided for @subscriptionFormPriceDialogPast.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Your past payment stays at what you actually paid.} other{Your {count} past payments stay at what you actually paid.}}'**
  String subscriptionFormPriceDialogPast(int count);

  /// No description provided for @subscriptionFormPriceApply.
  ///
  /// In en, this message translates to:
  /// **'Apply from next period'**
  String get subscriptionFormPriceApply;

  /// No description provided for @subscriptionFormPriceKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep {price}'**
  String subscriptionFormPriceKeep(String price);

  /// No description provided for @subscriptionFormTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Tile'**
  String get subscriptionFormTileTitle;

  /// No description provided for @subscriptionFormTilePreview.
  ///
  /// In en, this message translates to:
  /// **'Preview in a list'**
  String get subscriptionFormTilePreview;

  /// No description provided for @subscriptionFormTileLetters.
  ///
  /// In en, this message translates to:
  /// **'Letters'**
  String get subscriptionFormTileLetters;

  /// No description provided for @subscriptionFormTileEmoji.
  ///
  /// In en, this message translates to:
  /// **'Emoji'**
  String get subscriptionFormTileEmoji;

  /// No description provided for @subscriptionFormTileLettersHint.
  ///
  /// In en, this message translates to:
  /// **'1–2 characters'**
  String get subscriptionFormTileLettersHint;

  /// No description provided for @subscriptionFormTileColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get subscriptionFormTileColour;

  /// No description provided for @subscriptionFormTileColourNote.
  ///
  /// In en, this message translates to:
  /// **'The first swatch is {name}’s own colour from the library. Letter colour is picked for contrast automatically.'**
  String subscriptionFormTileColourNote(String name);

  /// No description provided for @subscriptionFormTileColourNoteCustom.
  ///
  /// In en, this message translates to:
  /// **'Letter colour is picked for contrast automatically.'**
  String get subscriptionFormTileColourNoteCustom;

  /// No description provided for @subscriptionFormTileOrEmoji.
  ///
  /// In en, this message translates to:
  /// **'Or an emoji'**
  String get subscriptionFormTileOrEmoji;

  /// No description provided for @subscriptionFormTileSwatch.
  ///
  /// In en, this message translates to:
  /// **'Colour {index}'**
  String subscriptionFormTileSwatch(int index);

  /// No description provided for @subscriptionFormTileLibraryColour.
  ///
  /// In en, this message translates to:
  /// **'Library colour'**
  String get subscriptionFormTileLibraryColour;

  /// No description provided for @subscriptionFormCurrencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Currency for this subscription'**
  String get subscriptionFormCurrencyTitle;

  /// No description provided for @subscriptionFormCurrencySearch.
  ///
  /// In en, this message translates to:
  /// **'Search currency'**
  String get subscriptionFormCurrencySearch;

  /// No description provided for @subscriptionFormCurrencyUsed.
  ///
  /// In en, this message translates to:
  /// **'Used by your subscriptions'**
  String get subscriptionFormCurrencyUsed;

  /// No description provided for @subscriptionFormCurrencyAll.
  ///
  /// In en, this message translates to:
  /// **'All currencies'**
  String get subscriptionFormCurrencyAll;

  /// No description provided for @subscriptionFormCurrencyMain.
  ///
  /// In en, this message translates to:
  /// **'Main currency'**
  String get subscriptionFormCurrencyMain;

  /// No description provided for @subscriptionFormCurrencyRate.
  ///
  /// In en, this message translates to:
  /// **'1 {code} ≈ {amount}'**
  String subscriptionFormCurrencyRate(String code, String amount);

  /// No description provided for @subscriptionFormCurrencyNote.
  ///
  /// In en, this message translates to:
  /// **'Totals still add up in {code}, shown with ≈ when converted.'**
  String subscriptionFormCurrencyNote(String code);

  /// No description provided for @subscriptionFormCurrencyNoMatch.
  ///
  /// In en, this message translates to:
  /// **'No currency matches “{query}”'**
  String subscriptionFormCurrencyNoMatch(String query);

  /// No description provided for @subscriptionFormReferenceHint.
  ///
  /// In en, this message translates to:
  /// **'Check it against your bill'**
  String get subscriptionFormReferenceHint;

  /// No description provided for @subscriptionFormReferenceNote.
  ///
  /// In en, this message translates to:
  /// **'Reference price from the library, not verified. Check it against your bill.'**
  String get subscriptionFormReferenceNote;

  /// No description provided for @subscriptionFormLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get subscriptionFormLabels;

  /// No description provided for @subscriptionFormNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New label'**
  String get subscriptionFormNewLabel;

  /// No description provided for @subscriptionFormNewLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Family, Work'**
  String get subscriptionFormNewLabelHint;

  /// No description provided for @subscriptionFormMethodNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get subscriptionFormMethodNone;

  /// No description provided for @subscriptionFormMethodUsage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Not used yet} =1{1 subscription} other{{count} subscriptions}}'**
  String subscriptionFormMethodUsage(int count);

  /// No description provided for @subscriptionFormMethodAddHint.
  ///
  /// In en, this message translates to:
  /// **'Add a card or wallet'**
  String get subscriptionFormMethodAddHint;

  /// No description provided for @subscriptionFormMethodNote.
  ///
  /// In en, this message translates to:
  /// **'Free text — Subnest never connects to your bank.'**
  String get subscriptionFormMethodNote;

  /// No description provided for @subscriptionFormAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get subscriptionFormAdd;

  /// No description provided for @subscriptionFormRemindMany.
  ///
  /// In en, this message translates to:
  /// **'Pick any — each one sends its own reminder at {time}.'**
  String subscriptionFormRemindMany(String time);

  /// No description provided for @subscriptionFormWorthIt.
  ///
  /// In en, this message translates to:
  /// **'Worth it?'**
  String get subscriptionFormWorthIt;

  /// No description provided for @subscriptionFormWorthNotRated.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get subscriptionFormWorthNotRated;

  /// No description provided for @subscriptionFormDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete subscription'**
  String get subscriptionFormDelete;

  /// No description provided for @subscriptionFormDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String subscriptionFormDeleteTitle(String name);

  /// No description provided for @subscriptionFormDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Its payment history goes too. This can\'t be undone.'**
  String get subscriptionFormDeleteBody;

  /// No description provided for @subscriptionFormDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get subscriptionFormDeleteAction;

  /// No description provided for @subscriptionFormTilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get subscriptionFormTilePhoto;

  /// No description provided for @subscriptionFormTilePhotoPick.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get subscriptionFormTilePhotoPick;

  /// No description provided for @subscriptionFormTilePhotoChange.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get subscriptionFormTilePhotoChange;

  /// No description provided for @subscriptionFormTilePhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get subscriptionFormTilePhotoRemove;

  /// No description provided for @subscriptionFormTilePhotoNote.
  ///
  /// In en, this message translates to:
  /// **'Shown instead of the letters. It stays on this phone and in your backups.'**
  String get subscriptionFormTilePhotoNote;

  /// No description provided for @subscriptionFormTilePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open that photo.'**
  String get subscriptionFormTilePhotoFailed;

  /// No description provided for @subscriptionFormCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Move and zoom'**
  String get subscriptionFormCropTitle;

  /// No description provided for @subscriptionFormCropHint.
  ///
  /// In en, this message translates to:
  /// **'Pinch to zoom, drag to move. The square is your logo.'**
  String get subscriptionFormCropHint;

  /// No description provided for @subscriptionFormCropUse.
  ///
  /// In en, this message translates to:
  /// **'Use photo'**
  String get subscriptionFormCropUse;

  /// Home widget (small): eyebrow above the next subscription to be charged.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get widgetNext;

  /// Home widget (medium): title of the list of next charges.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get widgetUpcoming;

  /// Home widget (large): title above the monthly total.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get widgetThisMonth;

  /// Home widget (medium): monthly total with a short 'per month'.
  ///
  /// In en, this message translates to:
  /// **'{amount}/mo'**
  String widgetPerMonth(String amount);

  /// Home widget: screen reader label of the monthly total.
  ///
  /// In en, this message translates to:
  /// **'Monthly total {amount}'**
  String widgetMonthlyTotalA11y(String amount);

  /// Home widget (large): badge with the number of Billing periods waiting for confirmation.
  ///
  /// In en, this message translates to:
  /// **'{count} to confirm'**
  String widgetToConfirm(int count);

  /// Home widget: the Due date has come and the payment waits for the user.
  ///
  /// In en, this message translates to:
  /// **'To confirm'**
  String get widgetAwaiting;

  /// No description provided for @widgetDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get widgetDueTomorrow;

  /// Home widget: days left until the Due date (2 or more). The widget fills {days} itself, so it stays right after midnight.
  ///
  /// In en, this message translates to:
  /// **'In {days} days'**
  String widgetDueInDays(String days);

  /// Home widget (small): after the days left, when the subscription is a Trial.
  ///
  /// In en, this message translates to:
  /// **'first charge'**
  String get widgetFirstCharge;

  /// No description provided for @widgetEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No renewals yet'**
  String get widgetEmptyTitle;

  /// No description provided for @widgetEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Open Subnest to add your first subscription'**
  String get widgetEmptyBody;

  /// Home widget when App lock is on: the only text shown (no names, no amounts).
  ///
  /// In en, this message translates to:
  /// **'Locked with PIN'**
  String get widgetLocked;

  /// Home widget: screen reader label of the parts that open the Overview.
  ///
  /// In en, this message translates to:
  /// **'Open Subnest'**
  String get widgetOpenApp;
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
