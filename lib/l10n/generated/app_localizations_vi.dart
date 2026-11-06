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
  String get commonStatusPaused => 'Tạm dừng';

  @override
  String get commonWorthItUnrated => 'Chưa đánh giá';

  @override
  String get commonWorthItWorth => 'Đáng';

  @override
  String get commonWorthItUnsure => 'Phân vân';

  @override
  String get commonWorthItNotWorth => 'Không đáng';

  @override
  String get commonAutoDetected => 'Tự phát hiện';

  @override
  String get commonDetectionScan => 'Ảnh chụp';

  @override
  String get commonDetectionNotification => 'Thông báo';

  @override
  String get commonDetectionGmail => 'Gmail';

  @override
  String get commonReferencePrice => 'Giá tham khảo';

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
  String get catalogTitle => 'Thêm subscription';

  @override
  String get catalogSearchHint => 'Tìm trong 100+ dịch vụ';

  @override
  String get catalogClearSearch => 'Xoá tìm kiếm';

  @override
  String get catalogCustom => 'Tạo dịch vụ tuỳ chỉnh';

  @override
  String get catalogCustomSub => 'Cho dịch vụ không có trong thư viện';

  @override
  String catalogCustomNamed(String name) {
    return 'Không thấy? Tạo “$name”';
  }

  @override
  String catalogCreateNamed(String name) {
    return 'Tạo “$name”';
  }

  @override
  String get catalogCustomService => 'Dịch vụ tuỳ chỉnh';

  @override
  String get catalogPopularVietnam => 'Phổ biến ở Việt Nam';

  @override
  String get catalogPopular => 'Phổ biến';

  @override
  String get catalogMore => 'Dịch vụ khác';

  @override
  String catalogResults(int count) {
    return '$count kết quả';
  }

  @override
  String catalogNoResultTitle(String name) {
    return 'Không thấy “$name”';
  }

  @override
  String get catalogNoResultBody => 'Tạo mới — bạn tự chọn màu và chữ cái.';

  @override
  String catalogFrom(String price) {
    return 'từ $price';
  }

  @override
  String catalogPlans(int count) {
    return '$count gói';
  }

  @override
  String catalogAddService(String name) {
    return 'Thêm $name';
  }

  @override
  String get catalogPlanSubVietnam => 'Chọn gói · giá gợi ý tại Việt Nam';

  @override
  String get catalogPlanSub => 'Chọn gói · giá gợi ý';

  @override
  String catalogPlanMembers(int count) {
    return 'Tối đa $count người';
  }

  @override
  String get catalogPlanNote => 'Bạn có thể sửa giá ở bước sau.';

  @override
  String catalogContinueWith(String plan) {
    return 'Tiếp tục với $plan';
  }

  @override
  String confirmQuestion(String name) {
    return 'Bạn đã trả $name chưa?';
  }

  @override
  String get confirmDueToday => 'Đến hạn hôm nay';

  @override
  String get confirmOverdue => 'Quá hạn';

  @override
  String confirmMoreAfter(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count kỳ sau',
    );
    return '$_temp0';
  }

  @override
  String confirmPeriodOf(String date) {
    return 'Kỳ $date';
  }

  @override
  String get confirmAmount => 'Số tiền đã trả';

  @override
  String confirmYourShare(String price, int count) {
    return 'Phần của bạn · gói $price ÷ $count';
  }

  @override
  String get confirmCurrentPrice => 'Giá hiện tại · sửa nếu đã đổi';

  @override
  String confirmMovesNext(String date) {
    return 'Xác nhận xong, ngày gia hạn tiếp theo là $date.';
  }

  @override
  String confirmNextUp(String date) {
    return 'Tiếp theo: kỳ $date, cũng đang chờ.';
  }

  @override
  String get confirmPaid => 'Đã trả';

  @override
  String get confirmSkip => 'Không trả kỳ này';

  @override
  String get confirmLater => 'Để sau';

  @override
  String get confirmAmountRequired => 'Nhập số tiền bạn đã trả.';

  @override
  String get confirmSaved => 'Đã lưu thanh toán';

  @override
  String get confirmSkippedTitle => 'Đã ghi là không trả';

  @override
  String confirmNextPeriod(String date) {
    return 'Kỳ tới: $date';
  }

  @override
  String get confirmDone => 'Xong';

  @override
  String confirmSavedStep(String date, String amount) {
    return 'Đã lưu kỳ $date · $amount';
  }

  @override
  String confirmSkippedStep(String date) {
    return 'Kỳ $date: đã ghi không trả';
  }

  @override
  String get confirmNothingTitle => 'Không có gì cần xác nhận';

  @override
  String confirmNothingBody(String name, String date) {
    return '$name đã xác nhận hết. Gia hạn tiếp theo: $date.';
  }

  @override
  String confirmNothingCancelled(String name) {
    return '$name đã huỷ nên không có gì cần xác nhận.';
  }

  @override
  String get confirmAwaitingTitle => 'Chờ xác nhận';

  @override
  String get confirmAwaitingIntro =>
      'Kỳ cũ nhất lên trước. Mỗi kỳ được xác nhận lần lượt, nên ngày gia hạn chỉ nhảy khi kỳ trước đã xong.';

  @override
  String get confirmAwaitingFooter =>
      'Chạm vào một dòng để sửa số tiền hoặc chọn không trả.';

  @override
  String confirmAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ngày trước',
      zero: 'hôm nay',
    );
    return '$_temp0';
  }

  @override
  String confirmAfter(String date) {
    return 'Sau kỳ $date';
  }

  @override
  String confirmMarkPaid(String name, String date) {
    return 'Đánh dấu $name kỳ $date đã trả';
  }

  @override
  String confirmQueued(String date) {
    return 'Xác nhận kỳ $date trước';
  }

  @override
  String confirmQuickSaved(String name, String date) {
    return 'Đã lưu $name kỳ $date là đã trả';
  }

  @override
  String confirmAllButton(String amount) {
    return 'Xác nhận tất cả · $amount';
  }

  @override
  String confirmAllTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xác nhận $count khoản?',
    );
    return '$_temp0';
  }

  @override
  String get confirmAllBody => 'Mỗi kỳ được lưu là đã trả theo giá hiện tại:';

  @override
  String get confirmAllFooter => 'Bạn vẫn sửa được từng khoản sau này.';

  @override
  String get confirmAllAction => 'Xác nhận tất cả';

  @override
  String get confirmAllCancel => 'Huỷ';

  @override
  String confirmAllSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã lưu $count khoản',
    );
    return '$_temp0';
  }

  @override
  String get confirmCaughtUp => 'Bạn đã xác nhận hết 🎉';

  @override
  String get confirmCaughtUpBody =>
      'Kỳ mới sẽ hiện ở đây vào đúng ngày đến hạn.';

  @override
  String get confirmBackHome => 'Về Tổng quan';

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
  String get coreApproximately => 'khoảng';

  @override
  String get homeTitle => 'Tổng quan';

  @override
  String get homeSearch => 'Tìm subscription';

  @override
  String get homeSearchHint => 'Tìm theo tên';

  @override
  String get homeSearchClose => 'Đóng tìm kiếm';

  @override
  String homeSearchEmpty(String query) {
    return 'Không có subscription nào khớp “$query”.';
  }

  @override
  String get homeMonthlySpend => 'Chi mỗi tháng';

  @override
  String get homeYearlySpend => 'Chi mỗi năm';

  @override
  String homeActiveCount(int count) {
    return '$count đang trả';
  }

  @override
  String homeTrialCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dùng thử',
    );
    return '$_temp0';
  }

  @override
  String homeBiggest(String name, int percent) {
    return 'Lớn nhất: $name · $percent%';
  }

  @override
  String homeRatesStale(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Ngoại tuyến · tỷ giá từ $days ngày trước',
      one: 'Ngoại tuyến · tỷ giá từ hôm qua',
    );
    return '$_temp0';
  }

  @override
  String get homeRatesNever => 'Ngoại tuyến · tỷ giá ước tính';

  @override
  String get homeRemindersOffTitle => 'Nhắc nhở đang tắt';

  @override
  String get homeRemindersOffBody =>
      'Bạn sẽ không được báo trước khi gia hạn hay hết dùng thử.';

  @override
  String get homeRemindersTurnOn => 'Bật lại';

  @override
  String homeAwaitingTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khoản cần xác nhận',
    );
    return '$_temp0';
  }

  @override
  String get homeAwaitingReview => 'Xem';

  @override
  String homeTrialEnds(String name, int days) {
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
  String homeTrialThen(String price, String date) {
    return 'Sau đó $price từ $date';
  }

  @override
  String get homeHowToCancel => 'Cách huỷ';

  @override
  String get homeKeepIt => 'Giữ lại';

  @override
  String homeKept(String name, String date) {
    return 'Giữ $name. Lần trừ đầu vào $date.';
  }

  @override
  String get homeUpcoming => 'Sắp tới · 7 ngày';

  @override
  String get homeCalendar => 'Lịch';

  @override
  String get homeFirstCharge => 'Lần trừ đầu';

  @override
  String get homeSubscriptions => 'Subscription của bạn';

  @override
  String get homeTabActive => 'Đang trả';

  @override
  String get homeTabTrials => 'Dùng thử';

  @override
  String get homeTabCancelled => 'Đã huỷ';

  @override
  String get homeSortTitle => 'Sắp xếp subscription';

  @override
  String get homeSortDue => 'Ngày gia hạn';

  @override
  String get homeSortDueHint =>
      'Gần nhất trước · khoản chờ xác nhận luôn ở trên';

  @override
  String get homeSortPrice => 'Giá';

  @override
  String get homeSortPriceHint => 'Chi phí quy tháng cao nhất trước';

  @override
  String get homeSortName => 'Tên';

  @override
  String get homeSortNameHint => 'A → Z';

  @override
  String get homeSortDone => 'Xong';

  @override
  String homeSortLabel(String by) {
    return 'Sắp xếp theo $by';
  }

  @override
  String get homeSaving => 'Bạn đang tiết kiệm';

  @override
  String homePerYear(String amount) {
    return '$amount/năm';
  }

  @override
  String homeCancelledOn(String date) {
    return 'Đã huỷ $date';
  }

  @override
  String homeTrialEndsWhen(String when) {
    return 'hết $when';
  }

  @override
  String get homeTrialBadge => 'Dùng thử';

  @override
  String get homeEmptyActive => 'Chưa có subscription đang trả.';

  @override
  String get homeEmptyTrials => 'Không có dùng thử nào.';

  @override
  String get homeEmptyCancelled => 'Chưa huỷ subscription nào.';

  @override
  String get homeTrialsNote =>
      'Dùng thử chưa tính vào tổng chi cho tới khi chuyển sang trả phí.';

  @override
  String get homeEmptyTitle => 'Thêm subscription đầu tiên';

  @override
  String get homeEmptyBody =>
      'Chọn từ 100+ dịch vụ phổ biến — thường chỉ 3 chạm.';

  @override
  String get homeBrowse => 'Xem thư viện dịch vụ';

  @override
  String get homeAdd => 'Thêm subscription';

  @override
  String get insightsRangeMonth => 'Tháng này';

  @override
  String get insightsRange12 => '12 tháng';

  @override
  String get insightsRangeYear => 'Năm nay';

  @override
  String insightsTotalLabel(String range) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Tổng · tháng này',
      'year': 'Tổng · năm nay',
      'other': 'Tổng · 12 tháng qua',
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
  String insightsTrendNoData(String range) {
    String _temp0 = intl.Intl.selectLogic(range, {
      'month': 'Chưa đủ dữ liệu tháng trước để so sánh',
      'year': 'Chưa đủ dữ liệu năm ngoái để so sánh',
      'other': 'Chưa đủ dữ liệu 12 tháng trước đó để so sánh',
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
    return 'Chi tiêu mỗi tháng, gồm đã trả và dự kiến, từ $from đến $to';
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
  String insightsPeakYearlyAhead(String months, String names) {
    return '$months dự kiến tăng vọt vì gia hạn gói năm $names.';
  }

  @override
  String insightsPeakAhead(String months, String names) {
    return '$months dự kiến tăng vọt vì gia hạn $names.';
  }

  @override
  String insightsPeakPlainAhead(String months) {
    return '$months dự kiến cao hơn bình thường.';
  }

  @override
  String get insightsByCategory => 'Theo danh mục';

  @override
  String get insightsMonthlyActive => 'quy ra mỗi tháng, gói đang dùng';

  @override
  String get insightsCategoryNote =>
      'Gói trả theo năm (hoặc không theo tháng) được chia đều ra mỗi tháng, nên đây không phải số phải trả trong tháng này.';

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
  String get manageCategoriesTitle => 'Danh mục';

  @override
  String get manageLabelsTitle => 'Nhãn';

  @override
  String get managePaymentMethodsTitle => 'Phương thức thanh toán';

  @override
  String get manageBudgetsTitle => 'Ngân sách';

  @override
  String get managePlaceholder => 'Sắp có';

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
  String onboardingStep(int step, int total) {
    return 'Bước $step/$total';
  }

  @override
  String get onboardingWelcomeTitle => 'Mọi subscription, một tổ';

  @override
  String get onboardingBenefitRemind => 'Nhắc trước khi bị trừ tiền';

  @override
  String get onboardingBenefitRemindSub =>
      'Trước 3 ngày, và trước khi hết dùng thử.';

  @override
  String get onboardingBenefitTotal => 'Biết chính xác mỗi tháng tốn bao nhiêu';

  @override
  String get onboardingBenefitTotalSub =>
      'Theo tiền tệ của bạn, gói chia sẻ tính đúng phần.';

  @override
  String get onboardingBenefitPrivate => 'Riêng tư — dữ liệu chỉ trên máy bạn';

  @override
  String get onboardingBenefitPrivateSub =>
      'Không tài khoản, không ngân hàng, không theo dõi.';

  @override
  String get onboardingStart => 'Bắt đầu';

  @override
  String get onboardingCurrencyTitle => 'Tiền tệ chính của bạn';

  @override
  String get onboardingCurrencyHint =>
      'Dùng để cộng tổng chi. Mỗi subscription vẫn có tiền tệ riêng.';

  @override
  String get onboardingCurrencySuggestedVn => 'Gợi ý theo vùng: Việt Nam';

  @override
  String get onboardingCurrencySuggested => 'Gợi ý theo vùng của máy';

  @override
  String get onboardingCurrencyChosen => 'Bạn đã chọn';

  @override
  String get onboardingCurrencyChange => 'Chọn tiền tệ khác';

  @override
  String get onboardingCurrencyRatesNote =>
      'Tỷ giá tự cập nhật mỗi ngày khi có mạng. Bạn có thể tự đặt trong Cài đặt.';

  @override
  String get onboardingCurrencySheetTitle => 'Tiền tệ chính';

  @override
  String get onboardingCurrencySearch => 'Tìm tiền tệ hoặc quốc gia';

  @override
  String get onboardingPickTitle => 'Bạn đang dùng gì?';

  @override
  String get onboardingPickSearch => 'Tìm trong 100+ dịch vụ';

  @override
  String onboardingPickSelected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Đã chọn $count',
      zero: 'Chưa chọn dịch vụ nào',
    );
    return '$_temp0';
  }

  @override
  String onboardingPickNoMatch(String name) {
    return 'Không thấy “$name”. Bạn có thể thêm sau bằng nút +.';
  }

  @override
  String onboardingPickMeta(String price, String cycle) {
    return '$price · $cycle';
  }

  @override
  String get onboardingPickEdit => 'Sửa';

  @override
  String onboardingPickEditLabel(String name) {
    return 'Sửa giá và chu kỳ của $name';
  }

  @override
  String get onboardingLater => 'Để sau';

  @override
  String get onboardingQuickPlan => 'Gói';

  @override
  String get onboardingQuickPrice => 'Giá';

  @override
  String get onboardingQuickCycle => 'Chu kỳ';

  @override
  String get onboardingQuickRemove => 'Không thêm';

  @override
  String get onboardingRemindersTitle => 'Báo trước mỗi lần trừ tiền';

  @override
  String onboardingRemindersBody(String time) {
    return 'Subnest nhắc trước 3 ngày khi sắp gia hạn hoặc hết dùng thử, lúc $time. Đổi bất cứ lúc nào.';
  }

  @override
  String get onboardingDemoNow => 'bây giờ';

  @override
  String get onboardingDemoAgo => '2 ngày trước';

  @override
  String onboardingDemoRenews(String name, String price) {
    return '$name gia hạn sau 3 ngày — $price';
  }

  @override
  String onboardingDemoTrial(String name) {
    return 'Dùng thử $name hết sau 3 ngày.';
  }

  @override
  String get onboardingDemoLabel => 'Ví dụ thông báo nhắc';

  @override
  String get onboardingEnableReminders => 'Bật nhắc nhở';

  @override
  String get onboardingNoThanks => 'Không, cảm ơn';

  @override
  String get scanTitle => 'Quét ảnh chụp';

  @override
  String get scanPlaceholder => 'Sắp có';

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
    return 'Ngoại tuyến · tỷ giá từ $ago';
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
  String get settingsRatesOfflineTitle => 'Bạn đang ngoại tuyến';

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
  String get settingsPreviewSampleName => 'Subscription của bạn';

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
  String get settingsLogosAttribution => 'Logos provided by Logo.dev';

  @override
  String get settingsLogosOwnership =>
      'Tên và logo thuộc chủ sở hữu, chỉ dùng để nhận diện dịch vụ.';

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
  String get subscriptionDetailEdit => 'Sửa';

  @override
  String get subscriptionDetailStatusActive => 'Đang trả';

  @override
  String subscriptionDetailStatusTrial(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Dùng thử · còn $days ngày',
      zero: 'Dùng thử · hết hôm nay',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailStatusCancelled => 'Đã huỷ';

  @override
  String subscriptionDetailYourShare(String price, int count) {
    return 'Phần của bạn · gói $price ÷ $count';
  }

  @override
  String subscriptionDetailAwaitingTitle(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kỳ đang chờ xác nhận, từ $date',
      one: 'Kỳ $date đang chờ xác nhận',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailAwaitingBody(String amount) {
    return 'Bạn đã trả $amount chưa? Ngày gia hạn tiếp chỉ chạy khi bạn xác nhận.';
  }

  @override
  String get subscriptionDetailConfirm => 'Xác nhận';

  @override
  String subscriptionDetailTrialEnds(String date) {
    return 'Hết dùng thử $date';
  }

  @override
  String subscriptionDetailTrialBody(String price) {
    return 'Sau đó gia hạn $price. Huỷ trước ngày này nếu bạn không muốn dùng tiếp.';
  }

  @override
  String get subscriptionDetailHowToCancel => 'Cách huỷ';

  @override
  String get subscriptionDetailKeepIt => 'Giữ lại';

  @override
  String subscriptionDetailKept(String name, String date) {
    return 'Giữ $name. Lần trừ đầu vào $date.';
  }

  @override
  String subscriptionDetailSaving(String amount) {
    return 'Tiết kiệm $amount/năm';
  }

  @override
  String subscriptionDetailCancelledBody(String date) {
    return 'Đã huỷ $date. Không còn nhắc nữa.';
  }

  @override
  String get subscriptionDetailRestore => 'Khôi phục subscription';

  @override
  String subscriptionDetailRestored(String date) {
    return 'Đã khôi phục. Gia hạn tiếp theo: $date.';
  }

  @override
  String get subscriptionDetailNextRenewal => 'Gia hạn tiếp theo';

  @override
  String get subscriptionDetailFirstCharge => 'Lần trừ đầu';

  @override
  String get subscriptionDetailWaits => 'Chờ bạn xác nhận';

  @override
  String get subscriptionDetailCycle => 'Chu kỳ';

  @override
  String subscriptionDetailEveryDay(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count ngày',
      one: 'Mỗi ngày',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailEveryWeek(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count tuần',
      one: 'Mỗi tuần',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailEveryMonth(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count tháng',
      one: 'Mỗi tháng',
    );
    return '$_temp0';
  }

  @override
  String subscriptionDetailEveryYear(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mỗi $count năm',
      one: 'Mỗi năm',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailRemindMe => 'Nhắc trước';

  @override
  String subscriptionDetailRemindValue(int days, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days ngày, lúc $time',
      zero: 'Đúng ngày, lúc $time',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailRemindOff => 'Tắt';

  @override
  String get subscriptionDetailCategory => 'Danh mục';

  @override
  String get subscriptionDetailPaymentMethod => 'Thanh toán bằng';

  @override
  String get subscriptionDetailSince => 'Bắt đầu từ';

  @override
  String get subscriptionDetailTotalPaid => 'Tổng đã trả';

  @override
  String get subscriptionDetailNotes => 'Ghi chú';

  @override
  String get subscriptionDetailHistory => 'Lịch sử thanh toán';

  @override
  String get subscriptionDetailPaid => 'Đã trả';

  @override
  String get subscriptionDetailDidntPay => 'Không trả';

  @override
  String subscriptionDetailNoHistory(String date) {
    return 'Chưa có thanh toán — lần trừ đầu vào $date.';
  }

  @override
  String get subscriptionDetailNoHistoryCancelled => 'Chưa có thanh toán nào.';

  @override
  String subscriptionDetailEditPayment(String date) {
    return 'Sửa thanh toán kỳ $date';
  }

  @override
  String subscriptionDetailConfirmPeriod(String date) {
    return 'Xác nhận kỳ $date';
  }

  @override
  String get subscriptionDetailHowToCancelRow => 'Cách huỷ dịch vụ này';

  @override
  String subscriptionDetailOpens(String host) {
    return 'Mở trang tài khoản $host';
  }

  @override
  String subscriptionDetailLinkFailed(String host) {
    return 'Không mở được $host.';
  }

  @override
  String get subscriptionDetailMarkCancelled => 'Đánh dấu đã huỷ';

  @override
  String get subscriptionDetailDelete => 'Xoá subscription';

  @override
  String subscriptionDetailCancelTitle(String name) {
    return 'Đánh dấu $name đã huỷ?';
  }

  @override
  String subscriptionDetailCancelBody(String amount) {
    return 'Subnest ngừng nhắc và cộng $amount/năm vào khoản tiết kiệm. Bạn có thể khôi phục bất cứ lúc nào.';
  }

  @override
  String get subscriptionDetailNotYet => 'Chưa';

  @override
  String subscriptionDetailDeleteTitle(String name) {
    return 'Xoá $name?';
  }

  @override
  String subscriptionDetailDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Subscription này và $count khoản thanh toán sẽ bị xoá vĩnh viễn. Muốn tắt nhắc mà vẫn giữ lịch sử, hãy đánh dấu đã huỷ.',
      zero: 'Subscription này sẽ bị xoá vĩnh viễn. Muốn tắt nhắc mà vẫn giữ lại, hãy đánh dấu đã huỷ.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailDeleteAction => 'Xoá';

  @override
  String subscriptionDetailDeleted(String name) {
    return 'Đã xoá $name';
  }

  @override
  String subscriptionDetailCelebrateCancelled(String name) {
    return 'Đã huỷ $name';
  }

  @override
  String get subscriptionDetailCelebrateYear => 'tiết kiệm mỗi năm';

  @override
  String get subscriptionDetailCelebrateNow => 'Giờ bạn đang tiết kiệm';

  @override
  String subscriptionDetailPerYear(String amount) {
    return '$amount/năm';
  }

  @override
  String get subscriptionDetailSeeCancelled => 'Xem mục đã huỷ';

  @override
  String subscriptionDetailPaymentTitle(String date) {
    return 'Thanh toán · $date';
  }

  @override
  String get subscriptionDetailAmountPaid => 'Số tiền đã trả';

  @override
  String subscriptionDetailWas(String old, String total) {
    return 'Trước là $old — lưu xong Tổng đã trả thành $total.';
  }

  @override
  String get subscriptionDetailAmountRequired => 'Nhập số tiền bạn đã trả.';

  @override
  String get subscriptionDetailPaidOn => 'Ngày trả';

  @override
  String get subscriptionDetailPaidWith => 'Trả bằng';

  @override
  String get subscriptionDetailSave => 'Lưu';

  @override
  String get subscriptionDetailMarkNotPaid => 'Chuyển thành không trả';

  @override
  String get subscriptionDetailCancel => 'Huỷ';

  @override
  String get subscriptionDetailPaymentUpdated => 'Đã cập nhật thanh toán';

  @override
  String get subscriptionDetailMarkedNotPaid => 'Đã chuyển thành không trả';

  @override
  String get subscriptionFormAddTitle => 'Subscription mới';

  @override
  String get subscriptionFormEditTitle => 'Sửa subscription';

  @override
  String get subscriptionFormNameHint => 'Tên dịch vụ';

  @override
  String get subscriptionFormNameRequired => 'Nhập tên dịch vụ';

  @override
  String get subscriptionFormEditTile => 'Đổi biểu tượng';

  @override
  String subscriptionFormPlan(String name) {
    return 'Gói: $name';
  }

  @override
  String get subscriptionFormPrice => 'Giá';

  @override
  String get subscriptionFormPriceAfterTrial => 'Giá sau dùng thử';

  @override
  String get subscriptionFormPriceRequired => 'Giá phải lớn hơn 0';

  @override
  String subscriptionFormPriceWas(String old, String date) {
    return 'Giá cũ $old. Giá mới áp dụng từ kỳ tới ($date). Các khoản đã trả giữ nguyên.';
  }

  @override
  String get subscriptionFormCycle => 'Chu kỳ';

  @override
  String get subscriptionFormEvery => 'Mỗi';

  @override
  String get subscriptionFormEveryCount => 'Số đơn vị trong một chu kỳ';

  @override
  String subscriptionFormUnitDay(int count) {
    return 'ngày';
  }

  @override
  String subscriptionFormUnitWeek(int count) {
    return 'tuần';
  }

  @override
  String subscriptionFormUnitMonth(int count) {
    return 'tháng';
  }

  @override
  String subscriptionFormUnitYear(int count) {
    return 'năm';
  }

  @override
  String subscriptionFormUnitLabel(String unit) {
    return 'Đơn vị chu kỳ: $unit';
  }

  @override
  String get subscriptionFormChipWeekly => 'Tuần';

  @override
  String get subscriptionFormChipMonthly => 'Tháng';

  @override
  String get subscriptionFormChipQuarterly => 'Quý';

  @override
  String get subscriptionFormChipYearly => 'Năm';

  @override
  String get subscriptionFormNextDue => 'Gia hạn tiếp theo';

  @override
  String get subscriptionFormFirstCharge => 'Lần trừ đầu';

  @override
  String subscriptionFormThen(String dates) {
    return 'Sau đó: $dates…';
  }

  @override
  String get subscriptionFormTrial => 'Đang dùng thử';

  @override
  String get subscriptionFormTrialSub => 'Nhắc trước khi hết dùng thử';

  @override
  String get subscriptionFormTrialEnds => 'Hết dùng thử ngày';

  @override
  String get subscriptionFormTrialEndInvalid =>
      'Ngày hết dùng thử không được ở quá khứ';

  @override
  String get subscriptionFormShared => 'Chia với người khác';

  @override
  String get subscriptionFormSharedSub => 'Tổng chi chỉ tính phần của bạn';

  @override
  String get subscriptionFormPeople => 'Số người, gồm cả bạn';

  @override
  String get subscriptionFormYourShare => 'Phần của bạn';

  @override
  String subscriptionFormShareOf(String price, int count) {
    return '$price ÷ $count';
  }

  @override
  String get subscriptionFormCategory => 'Danh mục';

  @override
  String get subscriptionFormReminder => 'Nhắc trước';

  @override
  String get subscriptionFormRemindOff => 'Tắt';

  @override
  String get subscriptionFormRemindOnDay => 'Đúng ngày';

  @override
  String subscriptionFormRemindDays(int count) {
    return '$count ngày';
  }

  @override
  String subscriptionFormRemindAt(String time, String date) {
    return 'Lúc $time · $date';
  }

  @override
  String get subscriptionFormRemindNone => 'Không nhắc subscription này';

  @override
  String get subscriptionFormMore => 'Thêm chi tiết';

  @override
  String get subscriptionFormMoreSub =>
      'Phương thức thanh toán, link huỷ, ghi chú';

  @override
  String get subscriptionFormPaymentMethod => 'Phương thức thanh toán';

  @override
  String get subscriptionFormPaymentHint => 'vd Visa ••4242';

  @override
  String get subscriptionFormManageUrl => 'Link huỷ / quản lý';

  @override
  String get subscriptionFormManageUrlFromLibrary =>
      'Điền sẵn từ thư viện. Mở khi chạm “Cách huỷ”.';

  @override
  String get subscriptionFormNotes => 'Ghi chú';

  @override
  String get subscriptionFormAddButton => 'Thêm subscription';

  @override
  String get subscriptionFormSaveChanges => 'Lưu thay đổi';

  @override
  String subscriptionFormPriceDialogTitle(String price) {
    return 'Áp dụng giá $price từ kỳ tới?';
  }

  @override
  String subscriptionFormPriceDialogBody(String date) {
    return 'Kỳ $date và các kỳ sau dùng giá mới.';
  }

  @override
  String subscriptionFormPriceDialogPast(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count khoản đã trả vẫn giữ đúng số tiền bạn đã trả.',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionFormPriceApply => 'Áp dụng từ kỳ tới';

  @override
  String subscriptionFormPriceKeep(String price) {
    return 'Giữ $price';
  }

  @override
  String get subscriptionFormTileTitle => 'Biểu tượng';

  @override
  String get subscriptionFormTilePreview => 'Xem trong danh sách';

  @override
  String get subscriptionFormTileLetters => 'Chữ cái';

  @override
  String get subscriptionFormTileEmoji => 'Emoji';

  @override
  String get subscriptionFormTileLettersHint => '1–2 ký tự';

  @override
  String get subscriptionFormTileColour => 'Màu';

  @override
  String subscriptionFormTileColourNote(String name) {
    return 'Ô đầu là màu riêng của $name trong thư viện. Màu chữ tự chọn để đủ tương phản.';
  }

  @override
  String get subscriptionFormTileColourNoteCustom =>
      'Màu chữ tự chọn để đủ tương phản.';

  @override
  String get subscriptionFormTileOrEmoji => 'Hoặc emoji';

  @override
  String subscriptionFormTileSwatch(int index) {
    return 'Màu $index';
  }

  @override
  String get subscriptionFormTileLibraryColour => 'Màu thư viện';

  @override
  String get subscriptionFormCurrencyTitle => 'Tiền tệ của subscription này';

  @override
  String get subscriptionFormCurrencySearch => 'Tìm tiền tệ';

  @override
  String get subscriptionFormCurrencyUsed => 'Bạn đang dùng';

  @override
  String get subscriptionFormCurrencyAll => 'Tất cả tiền tệ';

  @override
  String get subscriptionFormCurrencyMain => 'Tiền tệ chính';

  @override
  String subscriptionFormCurrencyRate(String code, String amount) {
    return '1 $code ≈ $amount';
  }

  @override
  String subscriptionFormCurrencyNote(String code) {
    return 'Tổng chi vẫn cộng theo $code, có dấu ≈ khi quy đổi.';
  }

  @override
  String subscriptionFormCurrencyNoMatch(String query) {
    return 'Không có tiền tệ khớp “$query”';
  }
}
