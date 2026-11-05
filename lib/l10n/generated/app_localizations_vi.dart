// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get commonAppName => 'Subnest';

  @override
  String get commonTabHome => 'Tổng quan';

  @override
  String get commonTabCalendar => 'Lịch';

  @override
  String get commonTabInsights => 'Thống kê';

  @override
  String get commonTabSettings => 'Cài đặt';

  @override
  String get commonSave => 'Lưu';

  @override
  String get commonCancel => 'Huỷ';

  @override
  String get commonDelete => 'Xoá';

  @override
  String get commonEdit => 'Sửa';

  @override
  String get commonClose => 'Đóng';

  @override
  String get commonContinue => 'Tiếp tục';

  @override
  String get commonDone => 'Xong';

  @override
  String get commonPerMonth => 'mỗi tháng';

  @override
  String get commonPerYear => 'mỗi năm';

  @override
  String commonCycleDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count ngày',
      one: 'Hằng ngày',
    );
    return '$_temp0';
  }

  @override
  String commonCycleWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count tuần',
      one: 'Hằng tuần',
    );
    return '$_temp0';
  }

  @override
  String commonCycleMonths(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count tháng',
      one: 'Hằng tháng',
    );
    return '$_temp0';
  }

  @override
  String commonCycleYears(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count năm',
      one: 'Hằng năm',
    );
    return '$_temp0';
  }

  @override
  String get commonCycleQuarterly => 'Hằng quý';

  @override
  String get commonUnitDay => 'ngày';

  @override
  String get commonUnitWeek => 'tuần';

  @override
  String get commonUnitMonth => 'tháng';

  @override
  String get commonUnitYear => 'năm';

  @override
  String get commonStatusTrial => 'Dùng thử';

  @override
  String get commonStatusActive => 'Đang trả';

  @override
  String get commonStatusCancelled => 'Đã huỷ';

  @override
  String get commonStatusAwaiting => 'Chờ xác nhận';

  @override
  String commonCategory(String category) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'video': 'Video',
      'music': 'Nhạc',
      'ai': 'AI',
      'storage': 'Lưu trữ',
      'software': 'Phần mềm',
      'gaming': 'Game',
      'reading': 'Đọc',
      'health': 'Sức khoẻ',
      'education': 'Học tập',
      'telecom': 'Viễn thông',
      'other': 'Khác',
    });
    return '$_temp0';
  }

  @override
  String get commonCategoryAll => 'Tất cả';

  @override
  String commonDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count ngày',
      one: 'Ngày mai',
      zero: 'Hôm nay',
    );
    return '$_temp0';
  }

  @override
  String commonDaysOverdue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
    );
    return '$_temp0';
  }

  @override
  String get commonReminderDefault => 'Mặc định';

  @override
  String get commonReminderOff => 'Tắt';

  @override
  String get commonReminderOnTheDay => 'Đúng ngày';

  @override
  String commonReminderDaysBefore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
    );
    return '$_temp0';
  }

  @override
  String commonSharedWith(int count) {
    return '÷$count';
  }

  @override
  String get commonNotFound => 'Subscription này không còn tồn tại.';

  @override
  String get calendarViewMonth => 'Tháng';

  @override
  String get calendarViewAgenda => 'Danh sách';

  @override
  String calendarMonthYear(String name, String number, String year) {
    return 'Tháng $number/$year';
  }

  @override
  String calendarMonthName(String name, String number) {
    return 'Tháng $number';
  }

  @override
  String calendarMonthTotal(String name, String number) {
    return 'Tổng tháng $number';
  }

  @override
  String calendarPaidIn(String name, String number) {
    return 'Đã trả trong tháng $number';
  }

  @override
  String calendarCountPayments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khoản',
      zero: 'Không có khoản nào',
    );
    return '$_temp0';
  }

  @override
  String calendarCountPaid(int count) {
    return '$count đã trả';
  }

  @override
  String calendarCountSkipped(int count) {
    return '$count bỏ qua';
  }

  @override
  String calendarCountToConfirm(int count) {
    return '$count chờ xác nhận';
  }

  @override
  String get calendarEmpty => 'Tháng này không có khoản nào.';

  @override
  String get calendarNothingDue => 'Không có khoản nào ngày này.';

  @override
  String get calendarPaid => 'Đã trả';

  @override
  String get calendarSkipped => 'Bỏ qua';

  @override
  String get calendarUpcoming => 'Sắp tới';

  @override
  String get calendarDidNotPay => 'Không trả kỳ này';

  @override
  String get calendarFirstCharge => 'Lần trừ đầu';

  @override
  String get calendarConfirm => 'Xác nhận';

  @override
  String calendarTodayPrefix(String date) {
    return 'Hôm nay · $date';
  }

  @override
  String get calendarGroupThisWeek => 'Tuần này';

  @override
  String calendarGroupLater(String name, String number) {
    return 'Cuối tháng $number';
  }

  @override
  String calendarGroupEarlier(String name, String number) {
    return 'Đầu tháng $number';
  }

  @override
  String calendarDayLabel(String date, String items) {
    return '$date, $items';
  }

  @override
  String get calendarLegendLabel => 'Chú thích';

  @override
  String calendarMissingRates(String currencies) {
    return 'Khoản bằng $currencies chưa được cộng vào tổng — chưa có tỷ giá.';
  }

  @override
  String get catalogSearchHint => 'Tìm dịch vụ';

  @override
  String get catalogCustom => '+ Tạo dịch vụ tuỳ chỉnh';

  @override
  String catalogCustomNamed(String name) {
    return 'Không thấy? Tạo “$name”';
  }

  @override
  String catalogFromPerMonth(String amount) {
    return 'từ $amount/tháng';
  }

  @override
  String catalogChoosePlan(String name) {
    return 'Chọn gói $name';
  }

  @override
  String confirmTitle(String name, String date) {
    return '$name · kỳ $date';
  }

  @override
  String confirmMorePending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count kỳ chưa xác nhận',
    );
    return '$_temp0';
  }

  @override
  String get confirmAmount => 'Số tiền đã trả';

  @override
  String get confirmPaid => 'Đã trả';

  @override
  String get confirmSkip => 'Không trả kỳ này';

  @override
  String get confirmLater => 'Để sau';

  @override
  String confirmNext(String date) {
    return 'Kỳ tới: $date';
  }

  @override
  String confirmNothing(String name) {
    return '$name không có kỳ nào cần xác nhận.';
  }

  @override
  String get confirmAwaitingTitle => 'Chờ xác nhận';

  @override
  String get confirmAllDone => 'Bạn đã xác nhận hết 🎉';

  @override
  String confirmAll(String amount) {
    return 'Xác nhận tất cả · $amount';
  }

  @override
  String confirmAllDialogTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xác nhận $count khoản?',
    );
    return '$_temp0';
  }

  @override
  String get confirmAllDialogBody =>
      'Tất cả sẽ được đánh dấu đã trả theo giá hiện tại.';

  @override
  String get coreRelToday => 'hôm nay';

  @override
  String get coreRelTomorrow => 'ngày mai';

  @override
  String coreRelInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'còn $count ngày',
      one: 'còn 1 ngày',
    );
    return '$_temp0';
  }

  @override
  String coreRelDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
      one: '1 ngày trước',
    );
    return '$_temp0';
  }

  @override
  String corePer(String unit) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'day': '/ngày',
      'week': '/tuần',
      'month': '/tháng',
      'quarter': '/quý',
      'year': '/năm',
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
    return 'gói $price';
  }

  @override
  String get coreSwipeConfirm => 'Xác nhận';

  @override
  String get coreSwipeCancel => 'Huỷ';

  @override
  String coreSharedWith(int count) {
    return 'Chia $count người';
  }

  @override
  String get coreAddSubscription => 'Thêm subscription';

  @override
  String get coreMonth => 'Tháng';

  @override
  String get coreYear => 'Năm';

  @override
  String get corePrevMonth => 'Tháng trước';

  @override
  String get coreNextMonth => 'Tháng sau';

  @override
  String get coreFewer => 'Bớt';

  @override
  String get coreMore => 'Thêm';

  @override
  String get coreTabOverview => 'Tổng quan';

  @override
  String get coreChangeCurrency => 'Đổi tiền tệ';

  @override
  String get coreEditAmount => 'Sửa số tiền';

  @override
  String get homeAdd => 'Thêm subscription';

  @override
  String homeCounts(int active, int trial) {
    return '$active đang trả · $trial dùng thử';
  }

  @override
  String homeTrialSoon(String amount) {
    return '$amount/tháng khi hết dùng thử';
  }

  @override
  String get homeRatesOffline => 'Tỷ giá gần đúng (chưa cập nhật)';

  @override
  String homeRatesStale(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tỷ giá cập nhật $days ngày trước',
    );
    return '$_temp0';
  }

  @override
  String get homeRatesFresh => 'Tỷ giá cập nhật hôm nay';

  @override
  String get homeNotificationsOff => 'Nhắc nhở đang tắt';

  @override
  String get homeEnable => 'Bật lại';

  @override
  String homeAwaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khoản cần xác nhận',
    );
    return '$_temp0';
  }

  @override
  String get homeView => 'Xem';

  @override
  String homeTrialEnding(String name, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'sau $days ngày',
      one: 'ngày mai',
      zero: 'hôm nay',
    );
    return 'Dùng thử $name hết $_temp0';
  }

  @override
  String get homeHowToCancel => 'Cách huỷ';

  @override
  String get homeUpcoming => '7 ngày tới';

  @override
  String get homeTabActive => 'Đang trả';

  @override
  String get homeTabTrial => 'Dùng thử';

  @override
  String get homeTabCancelled => 'Đã huỷ';

  @override
  String get homeTabEmpty => 'Chưa có gì ở đây.';

  @override
  String get homeSort => 'Sắp xếp';

  @override
  String get homeSortDueDate => 'Ngày gia hạn';

  @override
  String get homeSortPrice => 'Giá';

  @override
  String get homeSortName => 'Tên';

  @override
  String homeSavings(String amount) {
    return 'Bạn đang tiết kiệm $amount/năm';
  }

  @override
  String homeCancelledOn(String date) {
    return 'Đã huỷ $date';
  }

  @override
  String get homeEmpty => 'Mọi subscription, một tổ.';

  @override
  String get homeAddFirst => 'Thêm subscription đầu tiên';

  @override
  String get insightsRangeMonth => 'Tháng này';

  @override
  String get insightsRange12 => '12 tháng';

  @override
  String get insightsRangeYear => 'Năm nay';

  @override
  String insightsPaidLabel(String range) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Đã trả · tháng này',
      'year': 'Đã trả · năm nay',
      'other': 'Đã trả · 12 tháng qua',
    });
    return '$_temp0';
  }

  @override
  String insightsTrendMore(String range, int percent) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Nhiều hơn $percent% so với tháng trước',
      'year': 'Nhiều hơn $percent% so với năm ngoái',
      'other': 'Nhiều hơn $percent% so với 12 tháng trước đó',
    });
    return '$_temp0';
  }

  @override
  String insightsTrendLess(String range, int percent) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Ít hơn $percent% so với tháng trước',
      'year': 'Ít hơn $percent% so với năm ngoái',
      'other': 'Ít hơn $percent% so với 12 tháng trước đó',
    });
    return '$_temp0';
  }

  @override
  String insightsTrendSame(String range) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Bằng tháng trước',
      'year': 'Bằng năm ngoái',
      'other': 'Bằng 12 tháng trước đó',
    });
    return '$_temp0';
  }

  @override
  String get insightsLegendPaid => 'Đã trả';

  @override
  String get insightsLegendExpected => 'Dự kiến, chưa xác nhận';

  @override
  String get insightsByMonth => 'Theo tháng';

  @override
  String get insightsTapBar => 'Chạm vào cột';

  @override
  String insightsTipPaid(String amount) {
    return '$amount đã trả';
  }

  @override
  String insightsTipExpected(String amount) {
    return '$amount dự kiến';
  }

  @override
  String insightsChartLabel(String from, String to) {
    return 'Số đã trả mỗi tháng, từ $from đến $to';
  }

  @override
  String insightsCompact(String unit, String n) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'k': '${n}k',
      'm': '${n}tr',
      'b': '$n tỷ',
      'other': '$n',
    });
    return '$_temp0';
  }

  @override
  String get insightsAnd => 'và';

  @override
  String insightsMonthList(String names, String numbers) {
    return 'Tháng $numbers';
  }

  @override
  String insightsPeakYearly(String months, String names) {
    return '$months tăng vọt vì gia hạn gói năm $names.';
  }

  @override
  String insightsPeak(String months, String names) {
    return '$months tăng vọt vì gia hạn $names.';
  }

  @override
  String insightsPeakPlain(String months) {
    return '$months cao hơn bình thường.';
  }

  @override
  String get insightsByCategory => 'Theo danh mục';

  @override
  String get insightsMonthlyActive => 'mỗi tháng, đang trả';

  @override
  String insightsSliceLabel(String category, String amount, int percent) {
    return '$category: $amount mỗi tháng, $percent%';
  }

  @override
  String insightsCategoryShare(int percent) {
    return '$percent% chi tiêu mỗi tháng';
  }

  @override
  String get insightsPerMonthShort => '/th';

  @override
  String insightsCycleNoteOne(String name, String price) {
    return '$name trả $price — ở đây tính theo tháng.';
  }

  @override
  String get insightsCycleNoteMany =>
      'Các gói không trả theo tháng được tính theo tháng ở đây.';

  @override
  String get insightsTop => 'Đắt nhất';

  @override
  String get insightsSaving => 'Bạn đang tiết kiệm';

  @override
  String insightsSavingBy(String names) {
    return 'nhờ huỷ $names';
  }

  @override
  String insightsSavingByCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nhờ huỷ $count dịch vụ',
    );
    return '$_temp0';
  }

  @override
  String insightsOverlapTitle(String category, int count) {
    String _temp0 = intl.Intl.selectLogic(category, {
      'music': 'Bạn trả $count dịch vụ nhạc',
      'other': 'Bạn trả $count dịch vụ video',
    });
    return '$_temp0';
  }

  @override
  String insightsOverlapBody(int count, String names, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$names tổng cộng $amount/tháng. Cần tất cả không?',
      two: '$names tổng cộng $amount/tháng. Cần cả hai?',
    );
    return '$_temp0';
  }

  @override
  String get insightsEmptyTitle => 'Thêm subscription để xem thống kê';

  @override
  String get insightsEmptyBody =>
      'Chi tiêu theo tháng và danh mục sẽ hiện ở đây khi bạn đã thêm vài subscription.';

  @override
  String get insightsEmptyAction => 'Thêm subscription';

  @override
  String get notificationsChannelName => 'Nhắc nhở';

  @override
  String get notificationsChannelDescription => 'Nhắc gia hạn và hết dùng thử';

  @override
  String notificationsRenewalSoon(String name, int count, String amount) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
    );
    return '$name gia hạn sau $_temp0 — $amount';
  }

  @override
  String notificationsTrialEndingTitle(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
    );
    return 'Dùng thử $name hết sau $_temp0.';
  }

  @override
  String get notificationsTrialEndingBody =>
      'Huỷ ngay nếu không muốn bị tính phí.';

  @override
  String notificationsDueToday(String name) {
    return 'Hôm nay gia hạn $name — chạm để xác nhận';
  }

  @override
  String get notificationsTestTitle => 'Nhắc nhở Subnest đã bật';

  @override
  String get notificationsTestScheduledTitle => 'Nhắc thử đã hẹn giờ';

  @override
  String get notificationsTestBody => 'Nhắc gia hạn sẽ trông như thế này.';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String get onboardingWelcomeTitle => 'Mọi subscription, một tổ';

  @override
  String get onboardingBenefitRemind => 'Nhắc trước khi bị trừ tiền';

  @override
  String get onboardingBenefitTotal => 'Biết chính xác mỗi tháng tốn bao nhiêu';

  @override
  String get onboardingBenefitPrivate => 'Riêng tư — dữ liệu chỉ trên máy bạn';

  @override
  String get onboardingStart => 'Bắt đầu';

  @override
  String get onboardingCurrencyTitle => 'Tiền tệ chính';

  @override
  String get onboardingCurrencyHint =>
      'Dùng để cộng tổng chi. Mỗi subscription vẫn có tiền tệ riêng.';

  @override
  String get onboardingQuickAddTitle => 'Bạn đang dùng gì?';

  @override
  String get onboardingLater => 'Để sau';

  @override
  String onboardingSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Thêm $count · Tiếp tục',
      zero: 'Tiếp tục',
    );
    return '$_temp0';
  }

  @override
  String get onboardingRemindersTitle => 'Bật nhắc nhở';

  @override
  String get onboardingRemindersExample =>
      '“Netflix gia hạn sau 3 ngày — 260.000đ”';

  @override
  String get onboardingEnableReminders => 'Bật nhắc nhở';

  @override
  String get onboardingNoThanks => 'Không, cảm ơn';

  @override
  String get settingsSectionMoney => 'Tiền';

  @override
  String get settingsPrimaryCurrency => 'Tiền tệ chính';

  @override
  String get settingsSearchCurrency => 'Tìm tiền tệ hoặc quốc gia';

  @override
  String get settingsCurrencyNote =>
      'Tổng chi và thống kê được cộng theo loại tiền này. Mỗi subscription vẫn giữ loại tiền riêng.';

  @override
  String settingsCurrencyNoMatch(String query) {
    return 'Không có loại tiền nào khớp “$query”';
  }

  @override
  String get settingsRates => 'Tỷ giá';

  @override
  String settingsRatesSummaryAuto(String ago) {
    return 'Tự động · $ago';
  }

  @override
  String get settingsRatesSummaryBuiltIn => 'Có sẵn';

  @override
  String get settingsRatesSummaryManual => 'Bạn đặt tay';

  @override
  String settingsRatesIntro(String currency) {
    return 'Tổng chi quy về $currency. Tỷ giá tự cập nhật mỗi ngày khi có mạng; bạn có thể tự đặt để ghi đè.';
  }

  @override
  String settingsRateAuto(String ago) {
    return 'Tự động · cập nhật $ago';
  }

  @override
  String settingsRateAutoOffline(String ago) {
    return 'Tự động · từ $ago (offline)';
  }

  @override
  String get settingsRateBuiltIn => 'Tự động · tỷ giá ước tính có sẵn';

  @override
  String get settingsRateManual => 'Bạn đặt tay';

  @override
  String settingsRatePairLabel(String from, String rate, String to) {
    return '1 $from bằng $rate $to';
  }

  @override
  String get settingsRatesUpdateNow => 'Cập nhật ngay';

  @override
  String get settingsRatesUpdated => 'Đã cập nhật tỷ giá';

  @override
  String get settingsRatesOfflineTitle => 'Bạn đang offline';

  @override
  String get settingsRatesOfflineBody =>
      'Đang dùng tỷ giá gần nhất. Sẽ cập nhật khi có mạng trở lại.';

  @override
  String get settingsRatesListedNote =>
      'Chỉ hiện các loại tiền mà subscription của bạn đang dùng.';

  @override
  String settingsRatesNoneUsed(String currency) {
    return 'Mọi subscription của bạn đều tính bằng $currency, không cần quy đổi.';
  }

  @override
  String get settingsRatesAttribution => 'Rates by Exchange Rate API';

  @override
  String get settingsAgoJustNow => 'vừa xong';

  @override
  String settingsAgoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count phút trước',
    );
    return '$_temp0';
  }

  @override
  String settingsAgoHoursShort(int count) {
    return '$count giờ trước';
  }

  @override
  String settingsAgoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giờ trước',
    );
    return '$_temp0';
  }

  @override
  String settingsAgoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày trước',
    );
    return '$_temp0';
  }

  @override
  String get settingsRateUseAuto => 'Dùng tỷ giá tự động';

  @override
  String settingsRateAutoValue(String rate, String ago) {
    return '$rate · cập nhật $ago';
  }

  @override
  String settingsRateAutoValueBuiltIn(String rate) {
    return '$rate · ước tính có sẵn';
  }

  @override
  String settingsRateYours(String from) {
    return 'Tỷ giá của bạn · 1 $from =';
  }

  @override
  String settingsRatePreview(String name, String amount) {
    return '$name thành $amount/tháng';
  }

  @override
  String get settingsRateInvalid => 'Nhập tỷ giá lớn hơn 0';

  @override
  String get settingsRateSave => 'Lưu tỷ giá này';

  @override
  String get settingsRateRestoreAuto => 'Khôi phục tự động';

  @override
  String get settingsSectionReminders => 'Nhắc nhở';

  @override
  String get settingsRemindMe => 'Nhắc trước';

  @override
  String settingsReminderValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
      zero: 'Đúng ngày',
    );
    return '$_temp0';
  }

  @override
  String get settingsReminderOff => 'Tắt';

  @override
  String get settingsReminderTime => 'Giờ nhắc';

  @override
  String get settingsNotifications => 'Thông báo';

  @override
  String get settingsNotificationsOn => 'Bật';

  @override
  String get settingsNotificationsOff => 'Tắt';

  @override
  String get settingsNotificationsOffTitle => 'Thông báo của Subnest đang tắt';

  @override
  String get settingsNotificationsOffBody =>
      'Bạn sẽ không nhận được nhắc cho tới khi cho phép trong cài đặt hệ thống.';

  @override
  String get settingsOpenSystemSettings => 'Mở cài đặt';

  @override
  String get settingsOpenSystemSettingsFailed =>
      'Mở Cài đặt của máy › Ứng dụng › Subnest › Thông báo.';

  @override
  String get settingsRemindBefore => 'Nhắc trước khi gia hạn';

  @override
  String settingsRemindChoice(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
      zero: 'Đúng ngày',
    );
    return '$_temp0';
  }

  @override
  String get settingsRemindTrialNote =>
      'Dùng thử cũng được nhắc như vậy trước khi hết.';

  @override
  String get settingsReminderTimeShort => 'Giờ nhắc';

  @override
  String get settingsRemindersNote =>
      'Có thể chỉnh riêng từng subscription trong màn sửa. Áp dụng cho nhắc mới; nhắc đã lên lịch sẽ chuyển sang giờ mới.';

  @override
  String get settingsPreview => 'Xem trước';

  @override
  String get settingsPreviewOff =>
      'Nhắc đang tắt. Các khoản tới hạn vẫn hiện trong app.';

  @override
  String get settingsTestReminder => 'Gửi nhắc thử';

  @override
  String get settingsTestReminderHint =>
      'Chỉ bản debug · 1 ngay và 1 sau 10 giây';

  @override
  String get settingsTestReminderSent => 'Đã gửi nhắc thử';

  @override
  String get settingsSectionAppearance => 'Giao diện & ngôn ngữ';

  @override
  String get settingsAppearanceTitle => 'Giao diện & ngôn ngữ';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsSystem => 'Theo hệ thống';

  @override
  String get settingsSystemShort => 'Hệ thống';

  @override
  String get settingsThemeLight => 'Sáng';

  @override
  String get settingsThemeDark => 'Tối';

  @override
  String settingsLanguageFromPhone(String language) {
    return '$language (theo máy)';
  }

  @override
  String get settingsSectionBackup => 'Sao lưu';

  @override
  String get settingsBackupTitle => 'Sao lưu & khôi phục';

  @override
  String settingsBackupOverdueTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
    );
    return 'Lần sao lưu gần nhất cách đây $_temp0';
  }

  @override
  String get settingsBackupNeverTitle => 'Bạn chưa sao lưu lần nào';

  @override
  String get settingsBackupOverdueBody =>
      'Dữ liệu chỉ nằm trên máy này. Hãy xuất một bản ngay.';

  @override
  String get settingsBackupAction => 'Sao lưu';

  @override
  String settingsBackupDaysTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ngày',
    );
    return 'Đã $_temp0 kể từ lần sao lưu gần nhất';
  }

  @override
  String get settingsBackupWhyBody =>
      'Subnest không lưu gì trên mạng, nên sao lưu là cách duy nhất để chuyển sang máy mới.';

  @override
  String get settingsExportJson => 'Xuất bản sao lưu';

  @override
  String get settingsExportJsonHint => 'JSON · đầy đủ, để khôi phục sau';

  @override
  String get settingsExportJsonLong =>
      'Toàn bộ dữ liệu, file .json để khôi phục sau';

  @override
  String get settingsExportCsv => 'Xuất bảng tính';

  @override
  String get settingsExportCsvHint => 'CSV · mở bằng Excel hoặc Sheets';

  @override
  String get settingsExportCsvLong => 'Subscription và thanh toán dạng .csv';

  @override
  String get settingsExported => 'Đã lưu — hãy cất ở nơi an toàn';

  @override
  String get settingsExportFailed => 'Không tạo được file. Hãy thử lại.';

  @override
  String get settingsRestore => 'Khôi phục từ file';

  @override
  String get settingsRestoreHint => 'Chọn file sao lưu .json của Subnest';

  @override
  String settingsLastBackup(String date) {
    return 'Sao lưu gần nhất: $date';
  }

  @override
  String settingsLastBackupFile(String date, String file) {
    return 'Sao lưu gần nhất: $date · $file';
  }

  @override
  String get settingsNeverBackedUp => 'Chưa sao lưu lần nào';

  @override
  String get settingsRestoreTitle => 'Khôi phục bản sao lưu này?';

  @override
  String settingsRestoreHolds(int subs, int payments) {
    String _temp0 = intl.Intl.pluralLogic(
      subs,
      locale: localeName,
      other: '$subs subscription',
    );
    String _temp1 = intl.Intl.pluralLogic(
      payments,
      locale: localeName,
      other: '$payments khoản thanh toán',
    );
    return 'Gồm $_temp0 và $_temp1.';
  }

  @override
  String get settingsRestoreMerge => 'Gộp';

  @override
  String get settingsRestoreMergeHint =>
      'Thêm phần còn thiếu, giữ dữ liệu hiện tại';

  @override
  String get settingsRestoreReplace => 'Thay thế';

  @override
  String get settingsRestoreReplaceHint =>
      'Xoá dữ liệu hiện tại và dùng bản sao lưu';

  @override
  String get settingsRestoreAction => 'Khôi phục';

  @override
  String get settingsRestoreReplaceAction => 'Thay dữ liệu của tôi';

  @override
  String get settingsRestoreInvalid =>
      'File này không phải bản sao lưu của Subnest.';

  @override
  String get settingsRestoreFailed =>
      'Không khôi phục được bản sao lưu này. Dữ liệu chưa bị thay đổi.';

  @override
  String settingsRestoreDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã khôi phục $count subscription',
    );
    return '$_temp0';
  }

  @override
  String get settingsSectionAbout => 'Giới thiệu';

  @override
  String get settingsVersion => 'Phiên bản';

  @override
  String get settingsPrivacyPolicy => 'Chính sách quyền riêng tư';

  @override
  String get settingsTerms => 'Điều khoản sử dụng';

  @override
  String get settingsLicenses => 'Giấy phép mã nguồn mở';

  @override
  String get settingsRateApp => 'Đánh giá Subnest';

  @override
  String get settingsFeedback => 'Gửi góp ý';

  @override
  String settingsFeedbackSubject(String version) {
    return 'Góp ý Subnest ($version)';
  }

  @override
  String settingsNoEmailApp(String email) {
    return 'Không tìm thấy ứng dụng email. Hãy viết tới $email';
  }

  @override
  String get settingsLinkFailed => 'Không mở được trang.';

  @override
  String get settingsLegalese =>
      'Phát triển bởi Phiotron. Subnest giữ dữ liệu của bạn trên máy này.';

  @override
  String get settingsPrivacyNote =>
      'Dữ liệu của bạn chỉ nằm trên máy này. Subnest không thu thập gì.';

  @override
  String subscriptionDetailMyShare(String share, String price, int count) {
    return 'Phần của bạn $share · gói $price ÷ $count';
  }

  @override
  String subscriptionDetailAwaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kỳ cần xác nhận',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailConfirm => 'Xác nhận';

  @override
  String get subscriptionDetailNextDue => 'Ngày gia hạn tiếp';

  @override
  String get subscriptionDetailTrialEnds => 'Hết dùng thử';

  @override
  String get subscriptionDetailCycle => 'Chu kỳ';

  @override
  String get subscriptionDetailReminder => 'Nhắc trước';

  @override
  String get subscriptionDetailCategory => 'Danh mục';

  @override
  String get subscriptionDetailPaymentMethod => 'Phương thức thanh toán';

  @override
  String get subscriptionDetailStarted => 'Bắt đầu từ';

  @override
  String get subscriptionDetailCancelledOn => 'Đã huỷ ngày';

  @override
  String get subscriptionDetailTotalPaid => 'Tổng đã trả';

  @override
  String get subscriptionDetailNotes => 'Ghi chú';

  @override
  String get subscriptionDetailHistory => 'Lịch sử thanh toán';

  @override
  String get subscriptionDetailPaid => 'Đã trả';

  @override
  String get subscriptionDetailSkipped => 'Không trả kỳ này';

  @override
  String get subscriptionDetailNoHistory => 'Chưa có thanh toán nào.';

  @override
  String get subscriptionDetailHowToCancel => 'Cách huỷ dịch vụ này';

  @override
  String get subscriptionDetailMarkCancelled => 'Đánh dấu đã huỷ';

  @override
  String get subscriptionDetailRestore => 'Khôi phục';

  @override
  String subscriptionDetailSaved(String amount) {
    return 'Tuyệt! Bạn tiết kiệm $amount/năm';
  }

  @override
  String get subscriptionDetailEditAmount => 'Số tiền đã trả';

  @override
  String subscriptionDetailDeleteTitle(String name) {
    return 'Xoá $name?';
  }

  @override
  String get subscriptionDetailDeleteBody =>
      'Thao tác này xoá subscription và toàn bộ lịch sử thanh toán. Muốn giữ lịch sử, hãy đánh dấu đã huỷ.';

  @override
  String get subscriptionFormAddTitle => 'Subscription mới';

  @override
  String get subscriptionFormEditTitle => 'Sửa subscription';

  @override
  String get subscriptionFormName => 'Tên';

  @override
  String get subscriptionFormNameRequired => 'Nhập tên';

  @override
  String get subscriptionFormPrice => 'Giá';

  @override
  String get subscriptionFormPriceAfterTrial => 'Giá sau dùng thử';

  @override
  String get subscriptionFormPriceRequired => 'Giá phải lớn hơn 0';

  @override
  String get subscriptionFormEvery => 'Mỗi';

  @override
  String get subscriptionFormNextDue => 'Ngày gia hạn tiếp theo';

  @override
  String subscriptionFormThen(String dates) {
    return 'Sau đó: $dates';
  }

  @override
  String get subscriptionFormTrial => 'Đang dùng thử';

  @override
  String get subscriptionFormTrialEnds => 'Hết dùng thử ngày';

  @override
  String get subscriptionFormTrialEndInvalid =>
      'Ngày hết dùng thử không được ở quá khứ';

  @override
  String get subscriptionFormShared => 'Chia với người khác';

  @override
  String subscriptionFormPeople(int count) {
    return '$count người';
  }

  @override
  String subscriptionFormMyShare(String amount) {
    return 'Phần của bạn: $amount';
  }

  @override
  String get subscriptionFormCategory => 'Danh mục';

  @override
  String get subscriptionFormReminder => 'Nhắc trước';

  @override
  String get subscriptionFormAdvanced => 'Nâng cao';

  @override
  String get subscriptionFormPaymentMethod =>
      'Phương thức thanh toán (vd Visa ••4242, MoMo)';

  @override
  String get subscriptionFormManageUrl => 'Link huỷ / quản lý';

  @override
  String get subscriptionFormNotes => 'Ghi chú';

  @override
  String get subscriptionFormAddButton => 'Thêm subscription';

  @override
  String get subscriptionFormSaveChanges => 'Lưu thay đổi';

  @override
  String get subscriptionFormPriceFromNext =>
      'Giá mới áp dụng từ kỳ tới. Các thanh toán cũ giữ nguyên.';
}
