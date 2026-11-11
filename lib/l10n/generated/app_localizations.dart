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
  /// **'List'**
  String get calendarViewAgenda;

  /// Label above the month's real-money total. name = month name (EN), number = month number (VI).
  ///
  /// In en, this message translates to:
  /// **'{name}:'**
  String calendarMonthColon(String name, String number);

  /// No description provided for @calendarToCome.
  ///
  /// In en, this message translates to:
  /// **'{count} to come'**
  String calendarToCome(int count);

  /// No description provided for @calendarExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get calendarExpected;

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
  /// **'Your own name, colour, letter or photo'**
  String get catalogCustomSub;

  /// No description provided for @catalogCustomNamed.
  ///
  /// In en, this message translates to:
  /// **'Not it? Create “{name}”'**
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
  /// **'Vietnam · prices in VND'**
  String get catalogPopularVietnam;

  /// No description provided for @catalogPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular · US prices'**
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
  /// **'Nothing called “{name}”'**
  String catalogNoResultTitle(String name);

  /// No description provided for @catalogNoResultBody.
  ///
  /// In en, this message translates to:
  /// **'Create it — pick a colour, a letter or a photo.'**
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
  /// **'Choose a plan · prices in VND'**
  String get catalogPlanSubVietnam;

  /// No description provided for @catalogPlanSub.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan · US prices'**
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

  /// No description provided for @catalogUpdated.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Library updated today} =1{Library updated yesterday} other{Library updated {days} days ago}}'**
  String catalogUpdated(int days);

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
  /// **'Current price · change it if you paid a different amount'**
  String get confirmCurrentPrice;

  /// No description provided for @confirmDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String confirmDueOn(String date);

  /// No description provided for @confirmChainMore.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 more period to confirm — opening it next} other{{count} more periods to confirm — opening the next}}'**
  String confirmChainMore(int count);

  /// No description provided for @confirmNextPeriodButton.
  ///
  /// In en, this message translates to:
  /// **'Next period'**
  String get confirmNextPeriodButton;

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
  /// **'View'**
  String get homeViewSubscription;

  /// No description provided for @homeTrialSavings.
  ///
  /// In en, this message translates to:
  /// **'Cancel before it charges to save {amount} a year'**
  String homeTrialSavings(String amount);

  /// No description provided for @homeKept.
  ///
  /// In en, this message translates to:
  /// **'Keeping {name}. The first charge is on {date}.'**
  String homeKept(String name, String date);

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
  /// **'Trial'**
  String get homeTabTrials;

  /// No description provided for @homeTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get homeTabCancelled;

  /// No description provided for @homeSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get homeSortTitle;

  /// No description provided for @homeSortDue.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get homeSortDue;

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

  /// No description provided for @homeSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort by {by}'**
  String homeSortLabel(String by);

  /// No description provided for @homeCancelledOn.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {date}'**
  String homeCancelledOn(String date);

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
  /// **'Pick from 500+ services with their logos and prices — most take three taps.'**
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

  /// No description provided for @homeCostMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly cost'**
  String get homeCostMonthly;

  /// No description provided for @homeCostYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly cost'**
  String get homeCostYearly;

  /// No description provided for @homeDeltaVs.
  ///
  /// In en, this message translates to:
  /// **'{amount} vs {period}'**
  String homeDeltaVs(String amount, String period);

  /// No description provided for @homeDeltaUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Up {amount} compared with {period}'**
  String homeDeltaUpLabel(String amount, String period);

  /// No description provided for @homeDeltaDownLabel.
  ///
  /// In en, this message translates to:
  /// **'Down {amount} compared with {period}'**
  String homeDeltaDownLabel(String amount, String period);

  /// No description provided for @homeDeltaSame.
  ///
  /// In en, this message translates to:
  /// **'Same as {period}'**
  String homeDeltaSame(String period);

  /// No description provided for @homeFirstMonth.
  ///
  /// In en, this message translates to:
  /// **'First month — no comparison yet'**
  String get homeFirstMonth;

  /// No description provided for @homeCostActive.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active subscription} other{{count} active subscriptions}}'**
  String homeCostActive(int count);

  /// No description provided for @homeCostPerDay.
  ///
  /// In en, this message translates to:
  /// **'{amount} a day'**
  String homeCostPerDay(String amount);

  /// No description provided for @homeCostYearSub.
  ///
  /// In en, this message translates to:
  /// **'{year} · {amount} a month'**
  String homeCostYearSub(String year, String amount);

  /// No description provided for @homeCostNone.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions yet'**
  String get homeCostNone;

  /// No description provided for @homePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get homePaid;

  /// No description provided for @homeStillToPay.
  ///
  /// In en, this message translates to:
  /// **'Still to pay'**
  String get homeStillToPay;

  /// No description provided for @homeCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid {paid}, still to pay {due}'**
  String homeCashLabel(String paid, String due);

  /// No description provided for @homeRange.
  ///
  /// In en, this message translates to:
  /// **'{from} to {to}'**
  String homeRange(String from, String to);

  /// No description provided for @homeColumnLabel.
  ///
  /// In en, this message translates to:
  /// **'{month}: {amount}. Opens Insights for this month'**
  String homeColumnLabel(String month, String amount);

  /// No description provided for @homeInfoButton.
  ///
  /// In en, this message translates to:
  /// **'How this is calculated'**
  String get homeInfoButton;

  /// No description provided for @homeInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'How the numbers work'**
  String get homeInfoTitle;

  /// No description provided for @homeInfoMonthlyBody.
  ///
  /// In en, this message translates to:
  /// **'Every subscription active this month, spread evenly: a yearly plan counts as 1/12 each month. A trial counts from its first paid month; a pause stops it from the month after.'**
  String get homeInfoMonthlyBody;

  /// No description provided for @homeInfoCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Paid · Still to pay'**
  String get homeInfoCashTitle;

  /// No description provided for @homeInfoCashBody.
  ///
  /// In en, this message translates to:
  /// **'The real money leaving this month: payments you confirmed, plus renewals still ahead and periods waiting for you. A yearly plan renewing this month counts in full.'**
  String get homeInfoCashBody;

  /// No description provided for @homeInfoApproxTitle.
  ///
  /// In en, this message translates to:
  /// **'Why ≈'**
  String get homeInfoApproxTitle;

  /// No description provided for @homeInfoApproxBody.
  ///
  /// In en, this message translates to:
  /// **'Other currencies are converted at today’s rate and rounded per line, so the lines always add up to the total.'**
  String get homeInfoApproxBody;

  /// No description provided for @homeInfoNote.
  ///
  /// In en, this message translates to:
  /// **'That’s why Paid + Still to pay can differ from the monthly cost.'**
  String get homeInfoNote;

  /// No description provided for @homeInfoGotIt.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get homeInfoGotIt;

  /// No description provided for @homeTrialThenOn.
  ///
  /// In en, this message translates to:
  /// **'Then {price} on {date}'**
  String homeTrialThenOn(String price, String date);

  /// No description provided for @homeNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} changed its price'**
  String homeNoticeTitle(String name);

  /// No description provided for @homeNoticeShare.
  ///
  /// In en, this message translates to:
  /// **'Your share goes from {before} to {after}, from the {date} renewal.'**
  String homeNoticeShare(String before, String after, String date);

  /// No description provided for @homeNoticeFrom.
  ///
  /// In en, this message translates to:
  /// **'From the {date} renewal. Past payments stay as they were.'**
  String homeNoticeFrom(String date);

  /// No description provided for @homeNoticeReference.
  ///
  /// In en, this message translates to:
  /// **'Reference price — check it'**
  String get homeNoticeReference;

  /// No description provided for @homeNoticeUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get homeNoticeUpdate;

  /// No description provided for @homeNoticeKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep old price'**
  String get homeNoticeKeep;

  /// No description provided for @homeNoticeUpdated.
  ///
  /// In en, this message translates to:
  /// **'{name}: {price} from {date}'**
  String homeNoticeUpdated(String name, String price, String date);

  /// No description provided for @homeNoticeKept.
  ///
  /// In en, this message translates to:
  /// **'Keeping {name} at {price}'**
  String homeNoticeKept(String name, String price);

  /// No description provided for @homeNoticeStale.
  ///
  /// In en, this message translates to:
  /// **'The price was already changed — nothing updated'**
  String get homeNoticeStale;

  /// No description provided for @homeUpcomingTitle.
  ///
  /// In en, this message translates to:
  /// **'Upcoming payments'**
  String get homeUpcomingTitle;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeNext30.
  ///
  /// In en, this message translates to:
  /// **'Next 30 days: {amount} in {count, plural, =1{1 charge} other{{count} charges}}'**
  String homeNext30(String amount, int count);

  /// No description provided for @homeNext30None.
  ///
  /// In en, this message translates to:
  /// **'Nothing due in the next 30 days'**
  String get homeNext30None;

  /// No description provided for @homeDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =0{Today} =1{Tomorrow} other{{days} days left}}'**
  String homeDaysLeft(int days);

  /// No description provided for @homeFirstChargeWhen.
  ///
  /// In en, this message translates to:
  /// **'First charge · {when}'**
  String homeFirstChargeWhen(String when);

  /// No description provided for @homeMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark {name} paid'**
  String homeMarkPaid(String name);

  /// No description provided for @homeBudgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get homeBudgetTitle;

  /// No description provided for @homeBudgetOf.
  ///
  /// In en, this message translates to:
  /// **'{spent} of {limit}'**
  String homeBudgetOf(String spent, String limit);

  /// No description provided for @homeBudgetOver.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 category over budget: {names}} other{{count} categories over budget: {names}}}'**
  String homeBudgetOver(int count, String names);

  /// No description provided for @homeTabPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get homeTabPaused;

  /// No description provided for @homeEmptyPaused.
  ///
  /// In en, this message translates to:
  /// **'Nothing paused. Pause a subscription from its detail page — it stops counting from its next due date.'**
  String get homeEmptyPaused;

  /// No description provided for @homeSortButton.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get homeSortButton;

  /// No description provided for @homeSortRecent.
  ///
  /// In en, this message translates to:
  /// **'Recently added'**
  String get homeSortRecent;

  /// No description provided for @homeSavingYear.
  ///
  /// In en, this message translates to:
  /// **'You’re saving {amount} a year'**
  String homeSavingYear(String amount);

  /// No description provided for @homeRise.
  ///
  /// In en, this message translates to:
  /// **'Price went up'**
  String get homeRise;

  /// No description provided for @homeSearchYours.
  ///
  /// In en, this message translates to:
  /// **'Your subscriptions'**
  String get homeSearchYours;

  /// No description provided for @homeSearchLibrary.
  ///
  /// In en, this message translates to:
  /// **'Add from the library'**
  String get homeSearchLibrary;

  /// No description provided for @homeSearchCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get homeSearchCancel;

  /// No description provided for @insightsModeMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get insightsModeMonth;

  /// No description provided for @insightsModeYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get insightsModeYear;

  /// No description provided for @insightsPrevious.
  ///
  /// In en, this message translates to:
  /// **'{mode, select, year{Previous year} other{Previous month}}'**
  String insightsPrevious(String mode);

  /// No description provided for @insightsNext.
  ///
  /// In en, this message translates to:
  /// **'{mode, select, year{Next year} other{Next month}}'**
  String insightsNext(String mode);

  /// No description provided for @insightsProjected.
  ///
  /// In en, this message translates to:
  /// **'Projected'**
  String get insightsProjected;

  /// Cost card title. name = month name (EN), number = month number (VI).
  ///
  /// In en, this message translates to:
  /// **'Cost of {name}'**
  String insightsCostOfMonth(String name, String number);

  /// No description provided for @insightsCostOfYear.
  ///
  /// In en, this message translates to:
  /// **'Cost in {year}'**
  String insightsCostOfYear(String year);

  /// Change chip. name = short month name (EN), number = month number (VI).
  ///
  /// In en, this message translates to:
  /// **'vs {name}'**
  String insightsVsMonth(String name, String number);

  /// No description provided for @insightsVsYear.
  ///
  /// In en, this message translates to:
  /// **'vs {year}'**
  String insightsVsYear(String year);

  /// No description provided for @insightsSameMonth.
  ///
  /// In en, this message translates to:
  /// **'Same as {name}'**
  String insightsSameMonth(String name, String number);

  /// No description provided for @insightsSameYear.
  ///
  /// In en, this message translates to:
  /// **'Same as {year}'**
  String insightsSameYear(String year);

  /// Screen-reader label of the change chip.
  ///
  /// In en, this message translates to:
  /// **'{direction, select, up{Up {amount} {vs}} down{Down {amount} {vs}} other{{vs}}}'**
  String insightsChangeLabel(String direction, String amount, String vs);

  /// No description provided for @insightsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 subscription} other{{count} subscriptions}}'**
  String insightsCount(int count);

  /// No description provided for @insightsPerDay.
  ///
  /// In en, this message translates to:
  /// **'{amount} a day'**
  String insightsPerDay(String amount);

  /// No description provided for @insightsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount} a month'**
  String insightsPerMonth(String amount);

  /// No description provided for @insightsHowCalculated.
  ///
  /// In en, this message translates to:
  /// **'How this is calculated'**
  String get insightsHowCalculated;

  /// No description provided for @insightsPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get insightsPaid;

  /// No description provided for @insightsStillToPay.
  ///
  /// In en, this message translates to:
  /// **'Still to pay'**
  String get insightsStillToPay;

  /// No description provided for @insightsNotPaid.
  ///
  /// In en, this message translates to:
  /// **'Not paid'**
  String get insightsNotPaid;

  /// No description provided for @insightsCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid {paid}, still to pay {due}'**
  String insightsCashLabel(String paid, String due);

  /// No description provided for @insightsCashLabelPast.
  ///
  /// In en, this message translates to:
  /// **'Paid {paid}, not paid {due}'**
  String insightsCashLabelPast(String paid, String due);

  /// No description provided for @insightsNothingInMonth.
  ///
  /// In en, this message translates to:
  /// **'No subscription was being paid in {name}.'**
  String insightsNothingInMonth(String name, String number);

  /// No description provided for @insightsNothingInYear.
  ///
  /// In en, this message translates to:
  /// **'No subscription was being paid in {year}.'**
  String insightsNothingInYear(String year);

  /// No description provided for @insightsMissingRates.
  ///
  /// In en, this message translates to:
  /// **'Amounts in {currencies} aren’t included — no exchange rate yet.'**
  String insightsMissingRates(String currencies);

  /// No description provided for @insightsInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'How the numbers work'**
  String get insightsInfoTitle;

  /// No description provided for @insightsInfoMonthlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Monthly cost'**
  String get insightsInfoMonthlyTitle;

  /// No description provided for @insightsInfoMonthlyBody.
  ///
  /// In en, this message translates to:
  /// **'Every subscription active this month, spread evenly: a yearly plan counts as 1/12 each month. A trial counts from its first paid month; a pause stops it from the month after.'**
  String get insightsInfoMonthlyBody;

  /// No description provided for @insightsInfoCashTitle.
  ///
  /// In en, this message translates to:
  /// **'Paid · Still to pay'**
  String get insightsInfoCashTitle;

  /// No description provided for @insightsInfoCashBody.
  ///
  /// In en, this message translates to:
  /// **'The real money leaving this month: payments you confirmed, plus renewals still ahead and periods waiting for you. A yearly plan renewing this month counts in full.'**
  String get insightsInfoCashBody;

  /// No description provided for @insightsInfoApproxTitle.
  ///
  /// In en, this message translates to:
  /// **'Why ≈'**
  String get insightsInfoApproxTitle;

  /// No description provided for @insightsInfoApproxBody.
  ///
  /// In en, this message translates to:
  /// **'Other currencies are converted at today’s rate and rounded per line, so the lines always add up to the total.'**
  String get insightsInfoApproxBody;

  /// No description provided for @insightsInfoNote.
  ///
  /// In en, this message translates to:
  /// **'That’s why Paid + Still to pay can differ from the monthly cost.'**
  String get insightsInfoNote;

  /// No description provided for @insightsInfoOk.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get insightsInfoOk;

  /// No description provided for @insightsBars12.
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get insightsBars12;

  /// No description provided for @insightsBarsYear.
  ///
  /// In en, this message translates to:
  /// **'Each month of {year}'**
  String insightsBarsYear(String year);

  /// No description provided for @insightsTapBar.
  ///
  /// In en, this message translates to:
  /// **'Tap a bar'**
  String get insightsTapBar;

  /// No description provided for @insightsLegendMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly cost'**
  String get insightsLegendMonthly;

  /// Screen-reader label of one bar.
  ///
  /// In en, this message translates to:
  /// **'{month}: {amount}{projected, select, yes{, projected} other{}}'**
  String insightsBarLabel(String month, String amount, String projected);

  /// No description provided for @insightsChartLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly cost, {from} to {to}'**
  String insightsChartLabel(String from, String to);

  /// No description provided for @insightsByCategory.
  ///
  /// In en, this message translates to:
  /// **'By category'**
  String get insightsByCategory;

  /// No description provided for @insightsSliceLabel.
  ///
  /// In en, this message translates to:
  /// **'{category}: {amount}, {percent}%'**
  String insightsSliceLabel(String category, String amount, int percent);

  /// No description provided for @insightsTop.
  ///
  /// In en, this message translates to:
  /// **'Most expensive'**
  String get insightsTop;

  /// No description provided for @insightsShareOfMonth.
  ///
  /// In en, this message translates to:
  /// **'share of the month'**
  String get insightsShareOfMonth;

  /// No description provided for @insightsShareOfYear.
  ///
  /// In en, this message translates to:
  /// **'share of the year'**
  String get insightsShareOfYear;

  /// No description provided for @insightsRises.
  ///
  /// In en, this message translates to:
  /// **'Price rises'**
  String get insightsRises;

  /// No description provided for @insightsRisesPerMonth.
  ///
  /// In en, this message translates to:
  /// **'more a month than a year ago'**
  String get insightsRisesPerMonth;

  /// No description provided for @insightsRisesYearly.
  ///
  /// In en, this message translates to:
  /// **'That’s {amount} a year · {name} changed the most'**
  String insightsRisesYearly(String amount, String name);

  /// No description provided for @insightsRisesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No subscription got more expensive in the last 12 months.'**
  String get insightsRisesEmpty;

  /// No description provided for @insightsRiseLabel.
  ///
  /// In en, this message translates to:
  /// **'{name}: {from} to {to}, {delta} a month'**
  String insightsRiseLabel(String name, String from, String to, String delta);

  /// No description provided for @insightsReview.
  ///
  /// In en, this message translates to:
  /// **'Review {name}'**
  String insightsReview(String name);

  /// No description provided for @insightsNext12.
  ///
  /// In en, this message translates to:
  /// **'Next 12 months'**
  String get insightsNext12;

  /// No description provided for @insightsForecastProjected.
  ///
  /// In en, this message translates to:
  /// **'Projected'**
  String get insightsForecastProjected;

  /// No description provided for @insightsLast12.
  ///
  /// In en, this message translates to:
  /// **'Last 12 months'**
  String get insightsLast12;

  /// No description provided for @insightsForecastChange.
  ///
  /// In en, this message translates to:
  /// **'{amount} a year compared with the last 12 months'**
  String insightsForecastChange(String amount);

  /// No description provided for @insightsForecastPartial.
  ///
  /// In en, this message translates to:
  /// **'Your recorded payments don’t cover the whole last 12 months yet, so this comparison is rough.'**
  String get insightsForecastPartial;

  /// No description provided for @insightsForecastNew.
  ///
  /// In en, this message translates to:
  /// **'New this year'**
  String get insightsForecastNew;

  /// No description provided for @insightsForecastRises.
  ///
  /// In en, this message translates to:
  /// **'Price rises'**
  String get insightsForecastRises;

  /// No description provided for @insightsForecastOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get insightsForecastOther;

  /// No description provided for @insightsViewList.
  ///
  /// In en, this message translates to:
  /// **'View as list'**
  String get insightsViewList;

  /// No description provided for @insightsComingUp.
  ///
  /// In en, this message translates to:
  /// **'Coming up'**
  String get insightsComingUp;

  /// No description provided for @insightsWeeks13.
  ///
  /// In en, this message translates to:
  /// **'13 weeks'**
  String get insightsWeeks13;

  /// No description provided for @insightsWeekShort.
  ///
  /// In en, this message translates to:
  /// **'W{week}'**
  String insightsWeekShort(int week);

  /// No description provided for @insightsWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week {week}: {amount}'**
  String insightsWeekLabel(int week, String amount);

  /// No description provided for @insightsBiggest.
  ///
  /// In en, this message translates to:
  /// **'Biggest: {when} · {amount}'**
  String insightsBiggest(String when, String amount);

  /// No description provided for @insightsRenews.
  ///
  /// In en, this message translates to:
  /// **'({name} renews)'**
  String insightsRenews(String name);

  /// No description provided for @insightsNothingAhead.
  ///
  /// In en, this message translates to:
  /// **'Nothing expected in this time.'**
  String get insightsNothingAhead;

  /// No description provided for @insightsBudgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get insightsBudgets;

  /// No description provided for @insightsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get insightsEdit;

  /// No description provided for @insightsBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'{category}: {spent} of {limit}{over, select, yes{, over budget} other{}}'**
  String insightsBudgetLabel(
    String category,
    String spent,
    String limit,
    String over,
  );

  /// No description provided for @insightsSavingTitle.
  ///
  /// In en, this message translates to:
  /// **'You’re saving {amount} a year'**
  String insightsSavingTitle(String amount);

  /// No description provided for @insightsSavingBy.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{by cancelling 1 subscription} other{by cancelling {count} subscriptions}}'**
  String insightsSavingBy(int count);

  /// No description provided for @insightsNotWorthHint.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Dropping the one you marked “Not worth it” would save {amount} more a year.} other{Dropping the {count} you marked “Not worth it” would save {amount} more a year.}}'**
  String insightsNotWorthHint(int count, String amount);

  /// No description provided for @insightsOverlapVideo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{You pay for 2 video services — do you need both?} other{You pay for {count} video services — do you need all of them?}}'**
  String insightsOverlapVideo(int count);

  /// No description provided for @insightsOverlapMusic.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =2{You pay for 2 music services — do you need both?} other{You pay for {count} music services — do you need all of them?}}'**
  String insightsOverlapMusic(int count);

  /// No description provided for @insightsCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'{category} · {period}'**
  String insightsCategoryTitle(String category, String period);

  /// No description provided for @insightsCategoryShare.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 subscription} other{{count} subscriptions}} · {percent}% of {period}'**
  String insightsCategoryShare(int count, int percent, String period);

  /// No description provided for @insightsPauseNote.
  ///
  /// In en, this message translates to:
  /// **'{name} still counts in {period} — its pause starts on {date}.'**
  String insightsPauseNote(String name, String period, String date);

  /// No description provided for @insightsForecastCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 expected charge from real due dates} other{{count} expected charges from real due dates}}'**
  String insightsForecastCount(int count);

  /// No description provided for @insightsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add subscriptions to see insights'**
  String get insightsEmptyTitle;

  /// No description provided for @insightsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Monthly cost, categories, price rises and the next 12 months show up here.'**
  String get insightsEmptyBody;

  /// No description provided for @insightsEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Browse services'**
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
  /// **'Budget'**
  String get manageBudgetsTitle;

  /// No description provided for @manageSubCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No subscriptions} =1{1 subscription} other{{count} subscriptions}}'**
  String manageSubCount(int count);

  /// No description provided for @manageCategoriesIntro.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder. Colours are used in charts and filters.'**
  String get manageCategoriesIntro;

  /// No description provided for @manageNewCategory.
  ///
  /// In en, this message translates to:
  /// **'New category'**
  String get manageNewCategory;

  /// No description provided for @manageEditCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit category'**
  String get manageEditCategory;

  /// No description provided for @manageName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get manageName;

  /// No description provided for @manageNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get manageNameRequired;

  /// No description provided for @manageColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get manageColour;

  /// No description provided for @manageIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get manageIcon;

  /// No description provided for @manageDeleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete category'**
  String get manageDeleteCategory;

  /// No description provided for @manageDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String manageDeleteTitle(String name);

  /// No description provided for @manageDeleteMoveBody.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 subscription uses it.} other{{count} subscriptions use it.}} Move them to:'**
  String manageDeleteMoveBody(int count);

  /// No description provided for @manageDeleteUnusedBody.
  ///
  /// In en, this message translates to:
  /// **'No subscription uses it.'**
  String get manageDeleteUnusedBody;

  /// No description provided for @manageMoveAndDelete.
  ///
  /// In en, this message translates to:
  /// **'Move and delete'**
  String get manageMoveAndDelete;

  /// No description provided for @manageMoveCategory.
  ///
  /// In en, this message translates to:
  /// **'Move to {name}'**
  String manageMoveCategory(String name);

  /// No description provided for @manageReorderHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get manageReorderHint;

  /// No description provided for @manageLabelsIntro.
  ///
  /// In en, this message translates to:
  /// **'Labels cut across categories — a subscription can have several.'**
  String get manageLabelsIntro;

  /// No description provided for @manageNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New label'**
  String get manageNewLabel;

  /// No description provided for @manageEditLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit label'**
  String get manageEditLabel;

  /// No description provided for @manageDeleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete label'**
  String get manageDeleteLabel;

  /// No description provided for @manageDeleteLabelBody.
  ///
  /// In en, this message translates to:
  /// **'It’s taken off every subscription that has it. The subscriptions stay.'**
  String get manageDeleteLabelBody;

  /// No description provided for @managePaymentMethodsIntro.
  ///
  /// In en, this message translates to:
  /// **'Names only — Subnest never connects to a bank or card.'**
  String get managePaymentMethodsIntro;

  /// No description provided for @manageAddPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Add payment method'**
  String get manageAddPaymentMethod;

  /// No description provided for @manageEditPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Edit payment method'**
  String get manageEditPaymentMethod;

  /// No description provided for @manageDeletePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Delete payment method'**
  String get manageDeletePaymentMethod;

  /// No description provided for @manageDeletePaymentMethodBody.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions that use it are left without a payment method.'**
  String get manageDeletePaymentMethodBody;

  /// No description provided for @manageBudgetTotal.
  ///
  /// In en, this message translates to:
  /// **'Monthly budget, all subscriptions'**
  String get manageBudgetTotal;

  /// No description provided for @manageBudgetUsed.
  ///
  /// In en, this message translates to:
  /// **'{percent}% used this month · {amount}'**
  String manageBudgetUsed(int percent, String amount);

  /// No description provided for @manageBudgetPerCategory.
  ///
  /// In en, this message translates to:
  /// **'Per category · optional'**
  String get manageBudgetPerCategory;

  /// No description provided for @manageBudgetThisMonth.
  ///
  /// In en, this message translates to:
  /// **'{amount} this month'**
  String manageBudgetThisMonth(String amount);

  /// No description provided for @manageBudgetSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get manageBudgetSet;

  /// No description provided for @manageBudgetNote.
  ///
  /// In en, this message translates to:
  /// **'Budgets compare against the monthly cost. Going over turns the bar red — no notifications.'**
  String get manageBudgetNote;

  /// No description provided for @manageBudgetFor.
  ///
  /// In en, this message translates to:
  /// **'Budget · {name}'**
  String manageBudgetFor(String name);

  /// No description provided for @manageBudgetAmount.
  ///
  /// In en, this message translates to:
  /// **'Per month'**
  String get manageBudgetAmount;

  /// No description provided for @manageBudgetRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove budget'**
  String get manageBudgetRemove;

  /// No description provided for @manageBudgetInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount above 0'**
  String get manageBudgetInvalid;

  /// No description provided for @manageBudgetTotalNone.
  ///
  /// In en, this message translates to:
  /// **'No monthly budget yet'**
  String get manageBudgetTotalNone;

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

  /// Notification when an automatic backup failed (product.md §4.13, mockup 126). Only failures are notified; plain text, no action buttons.
  ///
  /// In en, this message translates to:
  /// **'Backup failed — open Subnest to check'**
  String get notificationsBackupFailed;

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
  /// **'Choose your language'**
  String get onboardingLanguageTitle;

  /// No description provided for @onboardingLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'You can change it later in Settings. The whole app switches at once.'**
  String get onboardingLanguageHint;

  /// No description provided for @onboardingLanguageEnglishSub.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get onboardingLanguageEnglishSub;

  /// No description provided for @onboardingLanguageVietnameseSub.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get onboardingLanguageVietnameseSub;

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
  /// **'Before renewals and before trials end.'**
  String get onboardingBenefitRemindSub;

  /// No description provided for @onboardingBenefitTotal.
  ///
  /// In en, this message translates to:
  /// **'Know what each month really costs'**
  String get onboardingBenefitTotal;

  /// No description provided for @onboardingBenefitTotalSub.
  ///
  /// In en, this message translates to:
  /// **'Every price shows its cycle — no more guessing.'**
  String get onboardingBenefitTotalSub;

  /// No description provided for @onboardingBenefitPrivate.
  ///
  /// In en, this message translates to:
  /// **'Your data stays on this phone'**
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
  /// **'Totals are added up in it. Each subscription keeps its own currency.'**
  String get onboardingCurrencyHint;

  /// No description provided for @onboardingCurrencyChange.
  ///
  /// In en, this message translates to:
  /// **'Choose another currency…'**
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
  /// **'Search 500+ services'**
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

  /// No description provided for @onboardingPickEdit.
  ///
  /// In en, this message translates to:
  /// **'Price & cycle'**
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
  /// **'3 days before a renewal or a trial ending, at {time}. You can change both later.'**
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
  /// **'No thanks'**
  String get onboardingNoThanks;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan screenshots'**
  String get scanTitle;

  /// No description provided for @scanResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Scan results'**
  String get scanResultsTitle;

  /// No description provided for @scanStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Open your subscriptions page'**
  String get scanStep1Title;

  /// No description provided for @scanStep1Body.
  ///
  /// In en, this message translates to:
  /// **'Google Play → Payments & subscriptions, or App Store → Subscriptions'**
  String get scanStep1Body;

  /// No description provided for @scanStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Take screenshots'**
  String get scanStep2Title;

  /// No description provided for @scanStep2Body.
  ///
  /// In en, this message translates to:
  /// **'Scroll and capture every subscription. Receipts work too.'**
  String get scanStep2Body;

  /// No description provided for @scanStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Pick them here'**
  String get scanStep3Title;

  /// No description provided for @scanStep3Body.
  ///
  /// In en, this message translates to:
  /// **'Subnest reads them on this phone and fills everything in.'**
  String get scanStep3Body;

  /// No description provided for @scanOpenGooglePlay.
  ///
  /// In en, this message translates to:
  /// **'Open Google Play'**
  String get scanOpenGooglePlay;

  /// No description provided for @scanOpenAppStore.
  ///
  /// In en, this message translates to:
  /// **'Open App Store'**
  String get scanOpenAppStore;

  /// No description provided for @scanPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Text is read on this phone. Your screenshots never leave it.'**
  String get scanPrivacy;

  /// No description provided for @scanChooseScreenshots.
  ///
  /// In en, this message translates to:
  /// **'Choose screenshots'**
  String get scanChooseScreenshots;

  /// No description provided for @scanPhotographReceipt.
  ///
  /// In en, this message translates to:
  /// **'Photograph a receipt'**
  String get scanPhotographReceipt;

  /// No description provided for @scanPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Subnest only sees the photos you pick'**
  String get scanPickerTitle;

  /// No description provided for @scanPicker1Title.
  ///
  /// In en, this message translates to:
  /// **'You choose the screenshots'**
  String get scanPicker1Title;

  /// No description provided for @scanPicker1Body.
  ///
  /// In en, this message translates to:
  /// **'Nothing else in your gallery is opened.'**
  String get scanPicker1Body;

  /// No description provided for @scanPicker2Title.
  ///
  /// In en, this message translates to:
  /// **'Read on this phone'**
  String get scanPicker2Title;

  /// No description provided for @scanPicker2Body.
  ///
  /// In en, this message translates to:
  /// **'Text recognition works offline.'**
  String get scanPicker2Body;

  /// No description provided for @scanPicker3Title.
  ///
  /// In en, this message translates to:
  /// **'Nothing is uploaded or kept'**
  String get scanPicker3Title;

  /// No description provided for @scanPicker3Body.
  ///
  /// In en, this message translates to:
  /// **'Only the subscriptions found are saved.'**
  String get scanPicker3Body;

  /// No description provided for @scanPickerNote.
  ///
  /// In en, this message translates to:
  /// **'Next, your phone asks which photos Subnest may see.'**
  String get scanPickerNote;

  /// No description provided for @scanContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get scanContinue;

  /// No description provided for @scanNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get scanNotNow;

  /// No description provided for @scanReadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading {count, plural, =1{1 picture} other{{count} pictures}}'**
  String scanReadingTitle(int count);

  /// No description provided for @scanFoundSoFar.
  ///
  /// In en, this message translates to:
  /// **'Found {count} so far…'**
  String scanFoundSoFar(int count);

  /// No description provided for @scanOnThisPhone.
  ///
  /// In en, this message translates to:
  /// **'On this phone · about {seconds} seconds'**
  String scanOnThisPhone(int seconds);

  /// Scan results title (mockup 118).
  ///
  /// In en, this message translates to:
  /// **'Added {added}, confirmed {confirmed}'**
  String scanAddedConfirmed(int added, int confirmed);

  /// No description provided for @scanAddedOnly.
  ///
  /// In en, this message translates to:
  /// **'Added {count}'**
  String scanAddedOnly(int count);

  /// No description provided for @scanConfirmedOnly.
  ///
  /// In en, this message translates to:
  /// **'Confirmed {count}'**
  String scanConfirmedOnly(int count);

  /// No description provided for @scanFoundOnly.
  ///
  /// In en, this message translates to:
  /// **'Found {count, plural, =1{1 charge} other{{count} charges}} to check'**
  String scanFoundOnly(int count);

  /// No description provided for @scanFromScreenshots.
  ///
  /// In en, this message translates to:
  /// **'From {count, plural, =1{1 screenshot} other{{count} screenshots}}'**
  String scanFromScreenshots(int count);

  /// No description provided for @scanFromScreenshotsAndReceipts.
  ///
  /// In en, this message translates to:
  /// **'From {screens, plural, =1{1 screenshot} other{{screens} screenshots}} and {receipts, plural, =1{a receipt} other{{receipts} receipts}}'**
  String scanFromScreenshotsAndReceipts(int screens, int receipts);

  /// No description provided for @scanFromReceipts.
  ///
  /// In en, this message translates to:
  /// **'From {count, plural, =1{a receipt} other{{count} receipts}}'**
  String scanFromReceipts(int count);

  /// No description provided for @scanGroupAdded.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get scanGroupAdded;

  /// No description provided for @scanGroupConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get scanGroupConfirmed;

  /// No description provided for @scanGroupReview.
  ///
  /// In en, this message translates to:
  /// **'Needs your check'**
  String get scanGroupReview;

  /// No description provided for @scanGroupDifferent.
  ///
  /// In en, this message translates to:
  /// **'Different amount'**
  String get scanGroupDifferent;

  /// No description provided for @scanGroupNotAdded.
  ///
  /// In en, this message translates to:
  /// **'Not added'**
  String get scanGroupNotAdded;

  /// No description provided for @scanNext.
  ///
  /// In en, this message translates to:
  /// **'next {date}'**
  String scanNext(String date);

  /// No description provided for @scanUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get scanUndo;

  /// No description provided for @scanRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed'**
  String get scanRemoved;

  /// No description provided for @scanUndone.
  ///
  /// In en, this message translates to:
  /// **'Undone'**
  String get scanUndone;

  /// No description provided for @scanPeriodPaid.
  ///
  /// In en, this message translates to:
  /// **'{date} period · paid {amount}'**
  String scanPeriodPaid(String date, String amount);

  /// No description provided for @scanChargedOn.
  ///
  /// In en, this message translates to:
  /// **'{date} · charged {amount}'**
  String scanChargedOn(String date, String amount);

  /// No description provided for @scanUsualPrice.
  ///
  /// In en, this message translates to:
  /// **'Usual {amount} — recorded for this period only; the price isn’t changed.'**
  String scanUsualPrice(String amount);

  /// No description provided for @scanReviewBefore.
  ///
  /// In en, this message translates to:
  /// **'{amount} on {date} — {days, plural, =1{1 day} other{{days} days}} before the {due} payment'**
  String scanReviewBefore(String amount, String date, int days, String due);

  /// No description provided for @scanReviewAfter.
  ///
  /// In en, this message translates to:
  /// **'{amount} on {date} — {days, plural, =1{1 day} other{{days} days}} after the {due} payment'**
  String scanReviewAfter(String amount, String date, int days, String due);

  /// No description provided for @scanReviewAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} on {date} — usually {usual}'**
  String scanReviewAmount(String amount, String date, String usual);

  /// No description provided for @scanItsThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'It’s this period'**
  String get scanItsThisPeriod;

  /// No description provided for @scanNotThis.
  ///
  /// In en, this message translates to:
  /// **'Not this'**
  String get scanNotThis;

  /// No description provided for @scanSeenOnce.
  ///
  /// In en, this message translates to:
  /// **'Seen once. Added if a second charge about a month later matches.'**
  String get scanSeenOnce;

  /// No description provided for @scanNotBilling.
  ///
  /// In en, this message translates to:
  /// **'Matches {name}, which is paused or cancelled.'**
  String scanNotBilling(String name);

  /// No description provided for @scanDismissedBefore.
  ///
  /// In en, this message translates to:
  /// **'You removed it before, so it isn’t added again.'**
  String get scanDismissedBefore;

  /// No description provided for @scanAlreadyTracked.
  ///
  /// In en, this message translates to:
  /// **'{name} is already in your list.'**
  String scanAlreadyTracked(String name);

  /// No description provided for @scanAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get scanAdd;

  /// No description provided for @scanDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get scanDone;

  /// No description provided for @scanUndoAll.
  ///
  /// In en, this message translates to:
  /// **'Undo all'**
  String get scanUndoAll;

  /// No description provided for @scanRemovedToast.
  ///
  /// In en, this message translates to:
  /// **'{name} removed · won’t be added again'**
  String scanRemovedToast(String name);

  /// No description provided for @scanNothingTitle.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions found'**
  String get scanNothingTitle;

  /// No description provided for @scanNothingMeta.
  ///
  /// In en, this message translates to:
  /// **'In {count, plural, =1{1 picture} other{{count} pictures}} · nothing was added'**
  String scanNothingMeta(int count);

  /// No description provided for @scanTryThis.
  ///
  /// In en, this message translates to:
  /// **'Try this'**
  String get scanTryThis;

  /// No description provided for @scanTip1Title.
  ///
  /// In en, this message translates to:
  /// **'Open the subscriptions list'**
  String get scanTip1Title;

  /// No description provided for @scanTip1Body.
  ///
  /// In en, this message translates to:
  /// **'Google Play → Payments & subscriptions → Subscriptions'**
  String get scanTip1Body;

  /// No description provided for @scanTip2Title.
  ///
  /// In en, this message translates to:
  /// **'Keep price and date in view'**
  String get scanTip2Title;

  /// No description provided for @scanTip2Body.
  ///
  /// In en, this message translates to:
  /// **'Each price and renewal date should be on screen.'**
  String get scanTip2Body;

  /// No description provided for @scanTip3Title.
  ///
  /// In en, this message translates to:
  /// **'Avoid cropped or blurry shots'**
  String get scanTip3Title;

  /// No description provided for @scanTip3Body.
  ///
  /// In en, this message translates to:
  /// **'Full-screen screenshots read best.'**
  String get scanTip3Body;

  /// No description provided for @scanChooseOther.
  ///
  /// In en, this message translates to:
  /// **'Choose other screenshots'**
  String get scanChooseOther;

  /// No description provided for @scanAddByHand.
  ///
  /// In en, this message translates to:
  /// **'Add by hand'**
  String get scanAddByHand;

  /// No description provided for @scanReadFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t read that picture. Try another one.'**
  String get scanReadFailed;

  /// No description provided for @scanOpenStoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open the store on this phone.'**
  String get scanOpenStoreFailed;

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
  /// **'Enter your PIN'**
  String get securityEnterPin;

  /// No description provided for @securityNewPin.
  ///
  /// In en, this message translates to:
  /// **'Choose a 4-digit PIN'**
  String get securityNewPin;

  /// No description provided for @securityConfirmPin.
  ///
  /// In en, this message translates to:
  /// **'Enter it again'**
  String get securityConfirmPin;

  /// Choosing a PIN: the second entry differs; the user starts over.
  ///
  /// In en, this message translates to:
  /// **'The PINs don’t match. Choose one again.'**
  String get securityPinMismatch;

  /// No description provided for @securityWrongPin.
  ///
  /// In en, this message translates to:
  /// **'Wrong PIN. Try again.'**
  String get securityWrongPin;

  /// Text button at the bottom of the lock screen.
  ///
  /// In en, this message translates to:
  /// **'Forgot PIN?'**
  String get securityForgotPin;

  /// No description provided for @securityForgotPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your PIN?'**
  String get securityForgotPinTitle;

  /// Dialog from Forgot PIN; the next step is Delete all data (two more confirmations).
  ///
  /// In en, this message translates to:
  /// **'Subnest has no account and no server, so the PIN can’t be reset. The only way back in is to erase all data on this phone and start fresh. A backup file can be restored afterwards.'**
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
  /// **'Hide content in app switcher'**
  String get securityPrivacyScreen;

  /// Under the Privacy screen switch on Android.
  ///
  /// In en, this message translates to:
  /// **'Also blocks screenshots'**
  String get securityPrivacyScreenNote;

  /// No description provided for @securityPrivacyScreenNoteIos.
  ///
  /// In en, this message translates to:
  /// **'Hides content in the app switcher. iPhone doesn’t let apps block screenshots.'**
  String get securityPrivacyScreenNoteIos;

  /// Forgot PIN dialog: back to the keypad.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get securityTryAgain;

  /// Choosing a PIN, first step, under the dots.
  ///
  /// In en, this message translates to:
  /// **'You’ll enter it when Subnest opens, and after 1 minute away.'**
  String get securityPinSetNote;

  /// Settings: under PIN lock while it is off.
  ///
  /// In en, this message translates to:
  /// **'4 digits, asked when Subnest opens'**
  String get securityPinOffNote;

  /// Settings: under PIN lock while it is on.
  ///
  /// In en, this message translates to:
  /// **'On · asks after 1 minute away'**
  String get securityPinOnNote;

  /// Settings row under PIN lock while it is on: current PIN, then a new one twice.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get securityChangePin;

  /// No description provided for @securityPinChanged.
  ///
  /// In en, this message translates to:
  /// **'PIN changed'**
  String get securityPinChanged;

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
  /// **'Allowed'**
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
  /// **'Remind me before a payment'**
  String get settingsRemindBefore;

  /// No description provided for @settingsRemindChoice.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{On the day} =1{1 day} other{{count} days}}'**
  String settingsRemindChoice(int count);

  /// No description provided for @settingsRemindTrialNote.
  ///
  /// In en, this message translates to:
  /// **'Pick any combination. Trials get the same reminders before they end.'**
  String get settingsRemindTrialNote;

  /// No description provided for @settingsReminderTimeShort.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get settingsReminderTimeShort;

  /// No description provided for @settingsRemindersNote.
  ///
  /// In en, this message translates to:
  /// **'Each subscription can override these on its edit screen. PIN lock doesn’t change what notifications say.'**
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
  /// **'Appearance & language'**
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
  /// **'Export CSV'**
  String get settingsExportCsv;

  /// No description provided for @settingsExportCsvHint.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions and payments, for spreadsheets'**
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
  /// **'Restore'**
  String get settingsRestore;

  /// No description provided for @settingsRestoreHint.
  ///
  /// In en, this message translates to:
  /// **'Replaces everything on this phone'**
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
  /// **'Replace all data?'**
  String get settingsRestoreTitle;

  /// No description provided for @settingsRestoreHolds.
  ///
  /// In en, this message translates to:
  /// **'It holds {subs, plural, =1{1 subscription} other{{subs} subscriptions}} and {payments, plural, =1{1 payment} other{{payments} payments}}.'**
  String settingsRestoreHolds(int subs, int payments);

  /// No description provided for @settingsRestoreReplaceAction.
  ///
  /// In en, this message translates to:
  /// **'Replace and restore'**
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
  /// **'Terms'**
  String get settingsTerms;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Licences'**
  String get settingsLicenses;

  /// No description provided for @settingsLogosTitle.
  ///
  /// In en, this message translates to:
  /// **'Service logos'**
  String get settingsLogosTitle;

  /// No description provided for @settingsLogosOwnership.
  ///
  /// In en, this message translates to:
  /// **'Service names and logos belong to their respective owners.'**
  String get settingsLogosOwnership;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
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
  /// **'Last: {time}'**
  String settingsAutoBackupLast(String time);

  /// No description provided for @settingsAutoBackupLastUnchanged.
  ///
  /// In en, this message translates to:
  /// **'Last: {last} · checked {checked}, no changes'**
  String settingsAutoBackupLastUnchanged(String checked, String last);

  /// No description provided for @settingsAutoBackupNever.
  ///
  /// In en, this message translates to:
  /// **'No backup yet'**
  String get settingsAutoBackupNever;

  /// No description provided for @settingsAutoBackupFailedAt.
  ///
  /// In en, this message translates to:
  /// **'Last try {time}: {error}'**
  String settingsAutoBackupFailedAt(String time, String error);

  /// No description provided for @settingsAutoBackupErrorFolder.
  ///
  /// In en, this message translates to:
  /// **'folder unavailable — tap Folder to choose it again'**
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
  /// **'Turn on automatic backup'**
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
  /// **'Wrong password'**
  String get settingsBackupWrongPassword;

  /// No description provided for @settingsBackupOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get settingsBackupOpen;

  /// No description provided for @settingsDeleteAll.
  ///
  /// In en, this message translates to:
  /// **'Erase all data'**
  String get settingsDeleteAll;

  /// No description provided for @settingsDeleteAllHint.
  ///
  /// In en, this message translates to:
  /// **'Everything, like a new install'**
  String get settingsDeleteAllHint;

  /// No description provided for @settingsDeleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase all data?'**
  String get settingsDeleteAllTitle;

  /// No description provided for @settingsDeleteAllConfirm.
  ///
  /// In en, this message translates to:
  /// **'Every subscription, payment, price history, label and setting on this phone is deleted. Subnest goes back to the first-run screens. Automatic backup files in your folder are kept.'**
  String get settingsDeleteAllConfirm;

  /// No description provided for @settingsDeleteAllConfirm2.
  ///
  /// In en, this message translates to:
  /// **'This can’t be undone.'**
  String get settingsDeleteAllConfirm2;

  /// No description provided for @settingsCannotUndo.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone'**
  String get settingsCannotUndo;

  /// No description provided for @settingsDeleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Erase everything'**
  String get settingsDeleteEverything;

  /// No description provided for @settingsDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get settingsDelete;

  /// No description provided for @settingsDeleteAllDone.
  ///
  /// In en, this message translates to:
  /// **'All data erased'**
  String get settingsDeleteAllDone;

  /// Theme sheet, under System / Light / Dark.
  ///
  /// In en, this message translates to:
  /// **'System follows your phone’s light or dark mode.'**
  String get settingsThemeNote;

  /// Language sheet, under English / Tiếng Việt.
  ///
  /// In en, this message translates to:
  /// **'The whole app switches right away. Dates and amounts follow the language.'**
  String get settingsLanguageNote;

  /// No description provided for @settingsHideTabBar.
  ///
  /// In en, this message translates to:
  /// **'Hide tab bar when scrolling'**
  String get settingsHideTabBar;

  /// Settings section: Categories, Labels, Payment methods, Budget.
  ///
  /// In en, this message translates to:
  /// **'Organize'**
  String get settingsSectionOrganize;

  /// Settings › Budget row value.
  ///
  /// In en, this message translates to:
  /// **'{amount}/mo'**
  String settingsBudgetValue(String amount);

  /// No description provided for @settingsBudgetNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get settingsBudgetNotSet;

  /// Settings section (Pro) and the title of the Automation screen.
  ///
  /// In en, this message translates to:
  /// **'Automation'**
  String get settingsSectionAutomation;

  /// No description provided for @settingsScan.
  ///
  /// In en, this message translates to:
  /// **'Screenshot scan'**
  String get settingsScan;

  /// No description provided for @settingsScanHint.
  ///
  /// In en, this message translates to:
  /// **'Add from store pages and receipts'**
  String get settingsScanHint;

  /// No description provided for @settingsBankNotifications.
  ///
  /// In en, this message translates to:
  /// **'Bank & wallet notifications'**
  String get settingsBankNotifications;

  /// Small chip on automation sources that are not built yet.
  ///
  /// In en, this message translates to:
  /// **'Soon'**
  String get settingsSoon;

  /// No description provided for @settingsAutoBackupOffNote.
  ///
  /// In en, this message translates to:
  /// **'Off — your data lives only on this phone'**
  String get settingsAutoBackupOffNote;

  /// No description provided for @settingsAutoBackupFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get settingsAutoBackupFolderLabel;

  /// No description provided for @settingsAutoBackupTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get settingsAutoBackupTimeLabel;

  /// No description provided for @settingsAutoBackupDaily.
  ///
  /// In en, this message translates to:
  /// **'{time} every day'**
  String settingsAutoBackupDaily(String time);

  /// No description provided for @settingsAutoBackupPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsAutoBackupPasswordLabel;

  /// No description provided for @settingsAutoBackupKeepsLabel.
  ///
  /// In en, this message translates to:
  /// **'Keeps'**
  String get settingsAutoBackupKeepsLabel;

  /// No description provided for @settingsAutoBackupKeepsValue.
  ///
  /// In en, this message translates to:
  /// **'2 newest files'**
  String get settingsAutoBackupKeepsValue;

  /// Automatic backup set-up screen (Android), under the icon.
  ///
  /// In en, this message translates to:
  /// **'Once a day Subnest saves an encrypted .subnest file to a folder you choose — on this phone, an SD card or a synced folder like Google Drive.'**
  String get settingsAutoBackupIntro;

  /// No description provided for @settingsAutoBackupSetupTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get settingsAutoBackupSetupTime;

  /// No description provided for @settingsAutoBackupKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get settingsAutoBackupKeep;

  /// No description provided for @settingsAutoBackupKeepValue.
  ///
  /// In en, this message translates to:
  /// **'2 newest'**
  String get settingsAutoBackupKeepValue;

  /// No description provided for @settingsAutoBackupChoose.
  ///
  /// In en, this message translates to:
  /// **'Choose…'**
  String get settingsAutoBackupChoose;

  /// No description provided for @settingsAutoBackupPasswordRule.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get settingsAutoBackupPasswordRule;

  /// No description provided for @settingsAutoBackupWriteDownTitle.
  ///
  /// In en, this message translates to:
  /// **'Write the password down'**
  String get settingsAutoBackupWriteDownTitle;

  /// No description provided for @settingsAutoBackupWriteDownBody.
  ///
  /// In en, this message translates to:
  /// **'Without it the backup can’t be opened — there’s no reset.'**
  String get settingsAutoBackupWriteDownBody;

  /// No description provided for @settingsAutoBackupFolderNeeded.
  ///
  /// In en, this message translates to:
  /// **'Choose a folder first'**
  String get settingsAutoBackupFolderNeeded;

  /// No description provided for @settingsBackupNow.
  ///
  /// In en, this message translates to:
  /// **'Back up now'**
  String get settingsBackupNow;

  /// No description provided for @settingsBackupNowHint.
  ///
  /// In en, this message translates to:
  /// **'A .subnest file, with or without a password'**
  String get settingsBackupNowHint;

  /// Back up now sheet, under the file name.
  ///
  /// In en, this message translates to:
  /// **'{subs, plural, =1{1 subscription} other{{subs} subscriptions}} · {payments, plural, =1{1 payment} other{{payments} payments}} · {size}'**
  String settingsBackupFileMeta(int subs, int payments, String size);

  /// No description provided for @settingsBackupProtectHint.
  ///
  /// In en, this message translates to:
  /// **'Recommended if you save it to the cloud'**
  String get settingsBackupProtectHint;

  /// No description provided for @settingsBackupSave.
  ///
  /// In en, this message translates to:
  /// **'Save file…'**
  String get settingsBackupSave;

  /// No description provided for @settingsRestoreValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get settingsRestoreValid;

  /// No description provided for @settingsRestoreProtected.
  ///
  /// In en, this message translates to:
  /// **'Password-protected · {size}'**
  String settingsRestoreProtected(String size);

  /// No description provided for @settingsRestoreInFile.
  ///
  /// In en, this message translates to:
  /// **'In this file'**
  String get settingsRestoreInFile;

  /// No description provided for @settingsRestoreSubs.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get settingsRestoreSubs;

  /// No description provided for @settingsRestorePayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get settingsRestorePayments;

  /// No description provided for @settingsRestorePriceChanges.
  ///
  /// In en, this message translates to:
  /// **'Price changes'**
  String get settingsRestorePriceChanges;

  /// No description provided for @settingsRestoreSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings and labels'**
  String get settingsRestoreSettings;

  /// No description provided for @settingsRestoreIncluded.
  ///
  /// In en, this message translates to:
  /// **'Included'**
  String get settingsRestoreIncluded;

  /// No description provided for @settingsRestoreWarnTitle.
  ///
  /// In en, this message translates to:
  /// **'Restoring replaces everything'**
  String get settingsRestoreWarnTitle;

  /// No description provided for @settingsRestoreWarnBody.
  ///
  /// In en, this message translates to:
  /// **'What’s on this phone now is removed and the file’s data takes its place.'**
  String get settingsRestoreWarnBody;

  /// No description provided for @settingsRestoreHasPassword.
  ///
  /// In en, this message translates to:
  /// **'This backup has a password'**
  String get settingsRestoreHasPassword;

  /// No description provided for @settingsRestoreUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock and restore'**
  String get settingsRestoreUnlock;

  /// No description provided for @settingsRestoreReplaceBody.
  ///
  /// In en, this message translates to:
  /// **'Your {current, plural, =0{data} =1{1 current subscription is} other{{current} current subscriptions are}} replaced by the {count, plural, =1{1 subscription} other{{count} subscriptions}} in this backup.'**
  String settingsRestoreReplaceBody(int current, int count);

  /// Erase all data, step 2: the word must be typed.
  ///
  /// In en, this message translates to:
  /// **'Type {word} to confirm'**
  String settingsDeleteAllTypeTitle(String word);

  /// The word typed to confirm Erase all data. Plain capitals, no accents.
  ///
  /// In en, this message translates to:
  /// **'ERASE'**
  String get settingsDeleteAllWord;

  /// No description provided for @settingsVersionValue.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersionValue(String version);

  /// No description provided for @settingsLibrary.
  ///
  /// In en, this message translates to:
  /// **'Service library'**
  String get settingsLibrary;

  /// No description provided for @settingsLibraryValue.
  ///
  /// In en, this message translates to:
  /// **'Updated {ago} · {count} services'**
  String settingsLibraryValue(String ago, int count);

  /// No description provided for @settingsLibraryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} services'**
  String settingsLibraryCount(int count);

  /// No description provided for @settingsAgoToday.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get settingsAgoToday;

  /// No description provided for @settingsPriceLists.
  ///
  /// In en, this message translates to:
  /// **'Price lists'**
  String get settingsPriceLists;

  /// No description provided for @settingsPriceListsValue.
  ///
  /// In en, this message translates to:
  /// **'US + Vietnam'**
  String get settingsPriceListsValue;

  /// No description provided for @settingsAutomationHero.
  ///
  /// In en, this message translates to:
  /// **'Let Subnest find your subscriptions'**
  String get settingsAutomationHero;

  /// No description provided for @settingsAutomationHeroBody.
  ///
  /// In en, this message translates to:
  /// **'Everything is read on this phone. Nothing is uploaded.'**
  String get settingsAutomationHeroBody;

  /// No description provided for @settingsAutomationScanHint.
  ///
  /// In en, this message translates to:
  /// **'Google Play / App Store pages, receipts'**
  String get settingsAutomationScanHint;

  /// No description provided for @settingsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get settingsOpen;

  /// No description provided for @settingsGmailHint.
  ///
  /// In en, this message translates to:
  /// **'Receipts and renewal emails'**
  String get settingsGmailHint;

  /// No description provided for @settingsAutomationFound.
  ///
  /// In en, this message translates to:
  /// **'When something is found'**
  String get settingsAutomationFound;

  /// No description provided for @settingsAutoAdd.
  ///
  /// In en, this message translates to:
  /// **'Add new ones automatically'**
  String get settingsAutoAdd;

  /// No description provided for @settingsAutoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm periods automatically'**
  String get settingsAutoConfirm;

  /// No description provided for @settingsAutomationNote.
  ///
  /// In en, this message translates to:
  /// **'Every automatic change is tagged Auto and has Undo.'**
  String get settingsAutomationNote;

  /// No description provided for @settingsEarlyAccessCta.
  ///
  /// In en, this message translates to:
  /// **'Get early access'**
  String get settingsEarlyAccessCta;

  /// No description provided for @settingsProBody.
  ///
  /// In en, this message translates to:
  /// **'Finds and confirms subscriptions for you. Adding them by hand stays free, always.'**
  String get settingsProBody;

  /// No description provided for @settingsProNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get settingsProNow;

  /// No description provided for @settingsProUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo on every change'**
  String get settingsProUndo;

  /// No description provided for @settingsEarlyAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Early access'**
  String get settingsEarlyAccessTitle;

  /// No description provided for @settingsEarlyAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Join now and we’ll tell you the price before Pro starts charging. Nothing is billed without asking you.'**
  String get settingsEarlyAccessBody;

  /// No description provided for @settingsJoinEarlyAccess.
  ///
  /// In en, this message translates to:
  /// **'Join early access'**
  String get settingsJoinEarlyAccess;

  /// No description provided for @settingsNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get settingsNotNow;

  /// Subject of the email opened by Join early access.
  ///
  /// In en, this message translates to:
  /// **'Subnest Pro early access'**
  String get settingsEarlyAccessSubject;

  /// No description provided for @settingsWhenToday.
  ///
  /// In en, this message translates to:
  /// **'today, {time}'**
  String settingsWhenToday(String time);

  /// No description provided for @settingsWhenYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday, {time}'**
  String settingsWhenYesterday(String time);

  /// No description provided for @settingsBackupPasswordShow.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get settingsBackupPasswordShow;

  /// No description provided for @settingsBackupPasswordHide.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get settingsBackupPasswordHide;

  /// Spoken state of the read-only automatic rows on the Automation screen.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsAutoStateOn;

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

  /// No description provided for @subscriptionDetailStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get subscriptionDetailStatusPaused;

  /// No description provided for @subscriptionDetailYourShare.
  ///
  /// In en, this message translates to:
  /// **'Your share · plan {price} ÷ {count}'**
  String subscriptionDetailYourShare(String price, int count);

  /// No description provided for @subscriptionDetailAwaitingTitle.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Payment on {date} needs confirming} other{{count} payments need confirming, from {date}}}'**
  String subscriptionDetailAwaitingTitle(int count, String date);

  /// No description provided for @subscriptionDetailAwaitingBody.
  ///
  /// In en, this message translates to:
  /// **'The next date waits until you say whether it was paid.'**
  String get subscriptionDetailAwaitingBody;

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

  /// No description provided for @subscriptionDetailTrialSave.
  ///
  /// In en, this message translates to:
  /// **'Then {price}. Cancel before to save {yearly} a year.'**
  String subscriptionDetailTrialSave(String price, String yearly);

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

  /// No description provided for @subscriptionDetailSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving {amount} a year'**
  String subscriptionDetailSaving(String amount);

  /// No description provided for @subscriptionDetailCancelledBody.
  ///
  /// In en, this message translates to:
  /// **'Cancelled {date}. No more reminders.'**
  String subscriptionDetailCancelledBody(String date);

  /// No description provided for @subscriptionDetailRestoreShort.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get subscriptionDetailRestoreShort;

  /// No description provided for @subscriptionDetailRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore subscription'**
  String get subscriptionDetailRestore;

  /// No description provided for @subscriptionDetailRestored.
  ///
  /// In en, this message translates to:
  /// **'Restored. Next payment: {date}.'**
  String subscriptionDetailRestored(String date);

  /// No description provided for @subscriptionDetailPausedTitle.
  ///
  /// In en, this message translates to:
  /// **'Paused since {date}'**
  String subscriptionDetailPausedTitle(String date);

  /// No description provided for @subscriptionDetailPausedBody.
  ///
  /// In en, this message translates to:
  /// **'No payments, no reminders, not counted.'**
  String get subscriptionDetailPausedBody;

  /// No description provided for @subscriptionDetailResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get subscriptionDetailResume;

  /// No description provided for @subscriptionDetailPausesTitle.
  ///
  /// In en, this message translates to:
  /// **'Pauses from {date}'**
  String subscriptionDetailPausesTitle(String date);

  /// No description provided for @subscriptionDetailPausesBody.
  ///
  /// In en, this message translates to:
  /// **'Still counted until then — that payment is the first one skipped.'**
  String get subscriptionDetailPausesBody;

  /// No description provided for @subscriptionDetailUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get subscriptionDetailUndo;

  /// No description provided for @subscriptionDetailPauseUndone.
  ///
  /// In en, this message translates to:
  /// **'Pause undone. Next payment: {date}.'**
  String subscriptionDetailPauseUndone(String date);

  /// No description provided for @subscriptionDetailNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'New library price: {price}'**
  String subscriptionDetailNoticeTitle(String price);

  /// No description provided for @subscriptionDetailNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'You pay {price}. Update from the next payment, or keep your price.'**
  String subscriptionDetailNoticeBody(String price);

  /// No description provided for @subscriptionDetailNoticeReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get subscriptionDetailNoticeReview;

  /// No description provided for @subscriptionDetailPlanGoneTitle.
  ///
  /// In en, this message translates to:
  /// **'This plan is no longer sold'**
  String get subscriptionDetailPlanGoneTitle;

  /// No description provided for @subscriptionDetailPlanGoneBody.
  ///
  /// In en, this message translates to:
  /// **'It left the library for new customers. Yours keeps its price and dates.'**
  String get subscriptionDetailPlanGoneBody;

  /// No description provided for @subscriptionDetailPlanClosedTitle.
  ///
  /// In en, this message translates to:
  /// **'No longer sold to new customers'**
  String get subscriptionDetailPlanClosedTitle;

  /// No description provided for @subscriptionDetailPlanClosedBody.
  ///
  /// In en, this message translates to:
  /// **'Existing customers keep it. Yours keeps its price and dates.'**
  String get subscriptionDetailPlanClosedBody;

  /// No description provided for @subscriptionDetailPlanRenamedTitle.
  ///
  /// In en, this message translates to:
  /// **'Now called {name}'**
  String subscriptionDetailPlanRenamedTitle(String name);

  /// No description provided for @subscriptionDetailPlanRenamedBody.
  ///
  /// In en, this message translates to:
  /// **'The library renamed {old}. Nothing changes for you.'**
  String subscriptionDetailPlanRenamedBody(String old);

  /// No description provided for @subscriptionDetailLibrary.
  ///
  /// In en, this message translates to:
  /// **'Service library'**
  String get subscriptionDetailLibrary;

  /// No description provided for @subscriptionDetailLibraryGone.
  ///
  /// In en, this message translates to:
  /// **'No longer sold'**
  String get subscriptionDetailLibraryGone;

  /// No description provided for @subscriptionDetailLibraryClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed to new customers'**
  String get subscriptionDetailLibraryClosed;

  /// No description provided for @subscriptionDetailLibraryRenamed.
  ///
  /// In en, this message translates to:
  /// **'Renamed'**
  String get subscriptionDetailLibraryRenamed;

  /// No description provided for @subscriptionDetailAutoTitle.
  ///
  /// In en, this message translates to:
  /// **'Added automatically'**
  String get subscriptionDetailAutoTitle;

  /// No description provided for @subscriptionDetailAutoBody.
  ///
  /// In en, this message translates to:
  /// **'{source, select, scan{Found in a screenshot} notification{Found in a bank notification} other{Found in an email}} on {date}. Not yours? Remove it — it won’t be added again.'**
  String subscriptionDetailAutoBody(String source, String date);

  /// No description provided for @subscriptionDetailAutoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get subscriptionDetailAutoRemove;

  /// No description provided for @subscriptionDetailAutoRemoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String subscriptionDetailAutoRemoveTitle(String name);

  /// No description provided for @subscriptionDetailAutoRemoveBody.
  ///
  /// In en, this message translates to:
  /// **'It was added {source, select, scan{from a screenshot} notification{from a bank notification} other{from an email}}. Subnest will remember and won’t add it again.'**
  String subscriptionDetailAutoRemoveBody(String source);

  /// No description provided for @subscriptionDetailAutoRemoved.
  ///
  /// In en, this message translates to:
  /// **'{name} removed'**
  String subscriptionDetailAutoRemoved(String name);

  /// No description provided for @subscriptionDetailNextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next payment'**
  String get subscriptionDetailNextPayment;

  /// No description provided for @subscriptionDetailFirstPayment.
  ///
  /// In en, this message translates to:
  /// **'First payment'**
  String get subscriptionDetailFirstPayment;

  /// No description provided for @subscriptionDetailWaits.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your confirmation'**
  String get subscriptionDetailWaits;

  /// No description provided for @subscriptionDetailCycle.
  ///
  /// In en, this message translates to:
  /// **'Billing cycle'**
  String get subscriptionDetailCycle;

  /// No description provided for @subscriptionDetailReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get subscriptionDetailReminders;

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

  /// No description provided for @subscriptionDetailLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get subscriptionDetailLabels;

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

  /// No description provided for @subscriptionDetailWorthIt.
  ///
  /// In en, this message translates to:
  /// **'Worth it?'**
  String get subscriptionDetailWorthIt;

  /// No description provided for @subscriptionDetailNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get subscriptionDetailNotes;

  /// No description provided for @subscriptionDetailPriceHistory.
  ///
  /// In en, this message translates to:
  /// **'Price history'**
  String get subscriptionDetailPriceHistory;

  /// No description provided for @subscriptionDetailPriceNeverChanged.
  ///
  /// In en, this message translates to:
  /// **'The price has never changed.'**
  String get subscriptionDetailPriceNeverChanged;

  /// No description provided for @subscriptionDetailPriceFrom.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String subscriptionDetailPriceFrom(String date);

  /// No description provided for @subscriptionDetailPriceNext.
  ///
  /// In en, this message translates to:
  /// **'next payment'**
  String get subscriptionDetailPriceNext;

  /// No description provided for @subscriptionDetailPriceSourceManual.
  ///
  /// In en, this message translates to:
  /// **'You changed it'**
  String get subscriptionDetailPriceSourceManual;

  /// No description provided for @subscriptionDetailPriceSourceCatalog.
  ///
  /// In en, this message translates to:
  /// **'Library update'**
  String get subscriptionDetailPriceSourceCatalog;

  /// No description provided for @subscriptionDetailPriceSourceBackfill.
  ///
  /// In en, this message translates to:
  /// **'From past payments'**
  String get subscriptionDetailPriceSourceBackfill;

  /// No description provided for @subscriptionDetailPriceStarted.
  ///
  /// In en, this message translates to:
  /// **'Started at {price}'**
  String subscriptionDetailPriceStarted(String price);

  /// No description provided for @subscriptionDetailPriceRose.
  ///
  /// In en, this message translates to:
  /// **'up {amount}'**
  String subscriptionDetailPriceRose(String amount);

  /// No description provided for @subscriptionDetailPriceFell.
  ///
  /// In en, this message translates to:
  /// **'down {amount}'**
  String subscriptionDetailPriceFell(String amount);

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

  /// No description provided for @subscriptionDetailPaidFrom.
  ///
  /// In en, this message translates to:
  /// **'{source, select, scan{From screenshot} notification{From notification} other{From email}}'**
  String subscriptionDetailPaidFrom(String source);

  /// No description provided for @subscriptionDetailAutoUndone.
  ///
  /// In en, this message translates to:
  /// **'Payment removed — that period waits for confirmation again.'**
  String get subscriptionDetailAutoUndone;

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

  /// No description provided for @subscriptionDetailOpens.
  ///
  /// In en, this message translates to:
  /// **'Opens {host} account page'**
  String subscriptionDetailOpens(String host);

  /// No description provided for @subscriptionDetailLinkFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open {host}.'**
  String subscriptionDetailLinkFailed(String host);

  /// No description provided for @subscriptionDetailPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get subscriptionDetailPause;

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
  /// **'Reminders stop and {amount} a year moves into your savings. You can restore it any time.'**
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
  /// **'It and its payment and price history are removed for good. To stop reminders but keep the history, mark it as cancelled instead.'**
  String get subscriptionDetailDeleteBody;

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

  /// No description provided for @subscriptionDetailPauseTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause {name}?'**
  String subscriptionDetailPauseTitle(String name);

  /// No description provided for @subscriptionDetailPauseBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing is cancelled with the service — this only stops tracking.'**
  String get subscriptionDetailPauseBody;

  /// No description provided for @subscriptionDetailPauseNow.
  ///
  /// In en, this message translates to:
  /// **'Now → {date}'**
  String subscriptionDetailPauseNow(String date);

  /// No description provided for @subscriptionDetailPauseNowBody.
  ///
  /// In en, this message translates to:
  /// **'Still counted — you paid for this period'**
  String get subscriptionDetailPauseNowBody;

  /// No description provided for @subscriptionDetailPauseFromBody.
  ///
  /// In en, this message translates to:
  /// **'No payments, no reminders, not in totals'**
  String get subscriptionDetailPauseFromBody;

  /// No description provided for @subscriptionDetailPauseAction.
  ///
  /// In en, this message translates to:
  /// **'Pause from {date}'**
  String subscriptionDetailPauseAction(String date);

  /// No description provided for @subscriptionDetailPaused.
  ///
  /// In en, this message translates to:
  /// **'{name} pauses from {date}'**
  String subscriptionDetailPaused(String name, String date);

  /// No description provided for @subscriptionDetailResumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Resume {name}'**
  String subscriptionDetailResumeTitle(String name);

  /// No description provided for @subscriptionDetailResumeAsk.
  ///
  /// In en, this message translates to:
  /// **'When is the next payment?'**
  String get subscriptionDetailResumeAsk;

  /// No description provided for @subscriptionDetailResumeNote.
  ///
  /// In en, this message translates to:
  /// **'Defaults to today. The cycle starts again from the date you pick.'**
  String get subscriptionDetailResumeNote;

  /// No description provided for @subscriptionDetailResumeToday.
  ///
  /// In en, this message translates to:
  /// **'Resume from today'**
  String get subscriptionDetailResumeToday;

  /// No description provided for @subscriptionDetailResumeFrom.
  ///
  /// In en, this message translates to:
  /// **'Resume from {date}'**
  String subscriptionDetailResumeFrom(String date);

  /// No description provided for @subscriptionDetailResumed.
  ///
  /// In en, this message translates to:
  /// **'Resumed. Next payment: {date}.'**
  String subscriptionDetailResumed(String date);

  /// No description provided for @subscriptionDetailPriceSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Update the price?'**
  String get subscriptionDetailPriceSheetTitle;

  /// No description provided for @subscriptionDetailPriceSheetSub.
  ///
  /// In en, this message translates to:
  /// **'{plan} · library price'**
  String subscriptionDetailPriceSheetSub(String plan);

  /// No description provided for @subscriptionDetailYouPayNow.
  ///
  /// In en, this message translates to:
  /// **'You pay now'**
  String get subscriptionDetailYouPayNow;

  /// No description provided for @subscriptionDetailNewPrice.
  ///
  /// In en, this message translates to:
  /// **'New price'**
  String get subscriptionDetailNewPrice;

  /// No description provided for @subscriptionDetailShareOf.
  ///
  /// In en, this message translates to:
  /// **'your share {amount}'**
  String subscriptionDetailShareOf(String amount);

  /// No description provided for @subscriptionDetailPriceSheetNote.
  ///
  /// In en, this message translates to:
  /// **'Applies from the {date} payment and is saved to the price history. Past payments stay as paid.'**
  String subscriptionDetailPriceSheetNote(String date);

  /// No description provided for @subscriptionDetailReferencePrice.
  ///
  /// In en, this message translates to:
  /// **'Reference price — check it on the provider’s page.'**
  String get subscriptionDetailReferencePrice;

  /// No description provided for @subscriptionDetailUpdateFrom.
  ///
  /// In en, this message translates to:
  /// **'Update from {date}'**
  String subscriptionDetailUpdateFrom(String date);

  /// No description provided for @subscriptionDetailKeepPrice.
  ///
  /// In en, this message translates to:
  /// **'Keep {price}'**
  String subscriptionDetailKeepPrice(String price);

  /// No description provided for @subscriptionDetailPriceUpdated.
  ///
  /// In en, this message translates to:
  /// **'New price from {date}'**
  String subscriptionDetailPriceUpdated(String date);

  /// No description provided for @subscriptionDetailPriceKept.
  ///
  /// In en, this message translates to:
  /// **'Keeping {price}. We won’t ask about this price again.'**
  String subscriptionDetailPriceKept(String price);

  /// No description provided for @subscriptionDetailPriceStale.
  ///
  /// In en, this message translates to:
  /// **'The price changed meanwhile — nothing was updated.'**
  String get subscriptionDetailPriceStale;

  /// No description provided for @subscriptionDetailCelebrateTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice — that’s {amount} a year saved'**
  String subscriptionDetailCelebrateTitle(String amount);

  /// No description provided for @subscriptionDetailCelebrateBody.
  ///
  /// In en, this message translates to:
  /// **'{name} is marked as cancelled. Remember to cancel it on {host} too — Subnest can’t do that for you.'**
  String subscriptionDetailCelebrateBody(String name, String host);

  /// No description provided for @subscriptionDetailCelebrateBodyNoHost.
  ///
  /// In en, this message translates to:
  /// **'{name} is marked as cancelled. Remember to cancel it with the provider too — Subnest can’t do that for you.'**
  String subscriptionDetailCelebrateBodyNoHost(String name);

  /// No description provided for @subscriptionDetailTotalSaving.
  ///
  /// In en, this message translates to:
  /// **'Total saving'**
  String get subscriptionDetailTotalSaving;

  /// No description provided for @subscriptionDetailPerYear.
  ///
  /// In en, this message translates to:
  /// **'{amount} a year'**
  String subscriptionDetailPerYear(String amount);

  /// No description provided for @subscriptionDetailFromCancelled.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{from 1 cancelled subscription} other{from {count} cancelled subscriptions}}'**
  String subscriptionDetailFromCancelled(int count);

  /// No description provided for @subscriptionDetailDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get subscriptionDetailDone;

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
  /// **'Was {old}. Saving asks when the new price starts and adds it to the price history.'**
  String subscriptionFormPriceWas(String old);

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
  /// **'On the day'**
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
  /// **'Payment method, cancel link, notes, worth it?'**
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
  /// **'Use {price} from the next payment?'**
  String subscriptionFormPriceDialogTitle(String price);

  /// No description provided for @subscriptionFormPriceDialogBody.
  ///
  /// In en, this message translates to:
  /// **'The {date} payment and later ones use the new price. Your past payments stay exactly as paid, and the change is saved to the price history.'**
  String subscriptionFormPriceDialogBody(String date);

  /// No description provided for @subscriptionFormPriceApply.
  ///
  /// In en, this message translates to:
  /// **'Apply from {date}'**
  String subscriptionFormPriceApply(String date);

  /// No description provided for @subscriptionFormTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Change icon'**
  String get subscriptionFormTileTitle;

  /// No description provided for @subscriptionFormTileColour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get subscriptionFormTileColour;

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

  /// No description provided for @subscriptionFormTilePhotoPick.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get subscriptionFormTilePhotoPick;

  /// No description provided for @subscriptionFormTilePhotoRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove photo'**
  String get subscriptionFormTilePhotoRemove;

  /// No description provided for @subscriptionFormTilePhotoFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open that photo.'**
  String get subscriptionFormTilePhotoFailed;

  /// No description provided for @subscriptionFormCropTitle.
  ///
  /// In en, this message translates to:
  /// **'Move and scale'**
  String get subscriptionFormCropTitle;

  /// No description provided for @subscriptionFormCropHint.
  ///
  /// In en, this message translates to:
  /// **'The square is what shows as the icon'**
  String get subscriptionFormCropHint;

  /// No description provided for @subscriptionFormCropUse.
  ///
  /// In en, this message translates to:
  /// **'Use photo'**
  String get subscriptionFormCropUse;

  /// No description provided for @subscriptionFormPriceNow.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get subscriptionFormPriceNow;

  /// No description provided for @subscriptionFormPriceFrom.
  ///
  /// In en, this message translates to:
  /// **'From {date}'**
  String subscriptionFormPriceFrom(String date);

  /// No description provided for @subscriptionFormRemindAt.
  ///
  /// In en, this message translates to:
  /// **'at {time}'**
  String subscriptionFormRemindAt(String time);

  /// No description provided for @subscriptionFormCustomSub.
  ///
  /// In en, this message translates to:
  /// **'Custom service · tap the icon for a photo'**
  String get subscriptionFormCustomSub;

  /// No description provided for @subscriptionFormAddMethod.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get subscriptionFormAddMethod;

  /// No description provided for @subscriptionFormTileLetterPreview.
  ///
  /// In en, this message translates to:
  /// **'Letter on colour'**
  String get subscriptionFormTileLetterPreview;

  /// No description provided for @subscriptionFormTilePhotoPreview.
  ///
  /// In en, this message translates to:
  /// **'Your photo, cropped square'**
  String get subscriptionFormTilePhotoPreview;

  /// No description provided for @subscriptionFormTileTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get subscriptionFormTileTakePhoto;

  /// No description provided for @subscriptionFormTileLetterOrEmoji.
  ///
  /// In en, this message translates to:
  /// **'Letter or emoji'**
  String get subscriptionFormTileLetterOrEmoji;

  /// No description provided for @subscriptionFormCropRotate.
  ///
  /// In en, this message translates to:
  /// **'Rotate'**
  String get subscriptionFormCropRotate;

  /// No description provided for @subscriptionFormMethodNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get subscriptionFormMethodNone;

  /// Home widget: fallback title above the monthly total.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get widgetThisMonth;

  /// Home widget (medium / large): short 'per month' after the monthly total (mockups 122–123).
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get widgetPerMonthShort;

  /// Home widget: screen reader label of the monthly total.
  ///
  /// In en, this message translates to:
  /// **'Monthly total {amount}'**
  String widgetMonthlyTotalA11y(String amount);

  /// Home widget (large): money already paid this month (same as the Overview's Cost card).
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get widgetPaid;

  /// Home widget (large): money still to be charged this month.
  ///
  /// In en, this message translates to:
  /// **'Still to pay'**
  String get widgetStillToPay;

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

  /// Home widget (small): the next subscription waits for confirmation (mockup 125).
  ///
  /// In en, this message translates to:
  /// **'Tap to confirm'**
  String get widgetTapToConfirm;

  /// No description provided for @widgetDueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get widgetDueTomorrow;

  /// Home widget (small, top right): days left until the Due date (2 or more). The widget fills {days} itself, so it stays right after midnight.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String widgetDueInDays(String days);

  /// Home widget (small): after the date, the Due date is tomorrow — '12 Nov · tomorrow'.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get widgetLeftTomorrow;

  /// Home widget (small): after the date — '12 Nov · 2 days left'. The widget fills {days} itself.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String widgetLeftDays(String days);

  /// Home widget (small): the next subscription is a free trial.
  ///
  /// In en, this message translates to:
  /// **'Trial ends {date}'**
  String widgetTrialEnds(String date);

  /// No description provided for @widgetEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing due'**
  String get widgetEmptyTitle;

  /// No description provided for @widgetEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap to add your first subscription'**
  String get widgetEmptyBody;

  /// Home widget when App lock is on: the only text shown (no names, no amounts).
  ///
  /// In en, this message translates to:
  /// **'Locked with PIN'**
  String get widgetLocked;

  /// Medium / large home widget when App lock is on (mockup 125).
  ///
  /// In en, this message translates to:
  /// **'Locked with PIN — open Subnest to see your payments'**
  String get widgetLockedLong;

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
