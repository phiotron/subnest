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
  String get commonLanguageEnglish => 'English';

  @override
  String get commonLanguageVietnamese => 'Tiếng Việt';

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
  String calendarMonthColon(String name, String number) {
    return 'Tháng $number:';
  }

  @override
  String calendarToCome(int count) {
    return '$count sắp tới';
  }

  @override
  String get calendarExpected => 'Dự kiến';

  @override
  String calendarMonthYear(String name, String number, String year) {
    return 'Tháng $number, $year';
  }

  @override
  String calendarMonthName(String name, String number) {
    return 'Tháng $number';
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
  String get calendarEmpty => 'Tháng này không có khoản nào.';

  @override
  String get calendarNothingDue => 'Không có khoản nào ngày này.';

  @override
  String get calendarPaid => 'Đã trả';

  @override
  String get calendarSkipped => 'Bỏ qua';

  @override
  String get calendarDidNotPay => 'Không trả kỳ này';

  @override
  String get calendarFirstCharge => 'Lần trừ đầu sau dùng thử';

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
  String get catalogTitle => 'Thêm gói đăng ký';

  @override
  String get catalogSearchHint => 'Tìm trong 500+ dịch vụ';

  @override
  String get catalogClearSearch => 'Xoá tìm kiếm';

  @override
  String get catalogCustom => 'Tạo dịch vụ tuỳ chỉnh';

  @override
  String get catalogCustomSub => 'Tên, màu, chữ hoặc ảnh của riêng bạn';

  @override
  String catalogCustomNamed(String name) {
    return 'Không phải? Tạo “$name”';
  }

  @override
  String catalogCreateNamed(String name) {
    return 'Tạo “$name”';
  }

  @override
  String get catalogCustomService => 'Dịch vụ tuỳ chỉnh';

  @override
  String get catalogPopularVietnam => 'Việt Nam · giá VND';

  @override
  String get catalogPopular => 'Phổ biến · giá US';

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
  String get catalogNoResultBody => 'Tạo mới — chọn màu, chữ cái hoặc ảnh.';

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
  String get catalogPlanSubVietnam => 'Chọn gói · giá VND';

  @override
  String get catalogPlanSub => 'Chọn gói · giá US';

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
  String get catalogTabGeneral => 'Chung';

  @override
  String get catalogTabVietnam => 'Việt Nam';

  @override
  String catalogUpdated(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Thư viện cập nhật $days ngày trước',
      one: 'Thư viện cập nhật hôm qua',
      zero: 'Thư viện cập nhật hôm nay',
    );
    return '$_temp0';
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
  String get confirmCurrentPrice =>
      'Giá hiện tại · sửa nếu số tiền thực trả khác';

  @override
  String confirmDueOn(String date) {
    return 'Đến hạn $date';
  }

  @override
  String confirmChainMore(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Còn $count kỳ chưa xác nhận — mở tiếp',
    );
    return '$_temp0';
  }

  @override
  String get confirmNextPeriodButton => 'Kỳ tiếp theo';

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
      other: 'trong $days ngày',
      one: 'ngày mai',
      zero: 'hôm nay',
    );
    return 'Dùng thử $name kết thúc $_temp0';
  }

  @override
  String get homeHowToCancel => 'Cách huỷ';

  @override
  String get homeKeepIt => 'Giữ lại';

  @override
  String get homeViewSubscription => 'Xem gói';

  @override
  String homeTrialSavings(String amount) {
    return 'Huỷ trước khi tính phí sẽ tiết kiệm $amount mỗi năm';
  }

  @override
  String homeKept(String name, String date) {
    return 'Giữ $name. Lần trừ đầu vào $date.';
  }

  @override
  String get homeSubscriptions => 'Gói đăng ký';

  @override
  String get homeTabActive => 'Đang trả';

  @override
  String get homeTabTrials => 'Dùng thử';

  @override
  String get homeTabCancelled => 'Đã huỷ';

  @override
  String get homeSortTitle => 'Sắp xếp theo';

  @override
  String get homeSortDue => 'Thanh toán tiếp theo';

  @override
  String get homeSortPrice => 'Giá';

  @override
  String get homeSortName => 'Tên';

  @override
  String homeSortLabel(String by) {
    return 'Sắp xếp theo $by';
  }

  @override
  String homeCancelledOn(String date) {
    return 'Đã huỷ $date';
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
      'Chọn từ hơn 500 dịch vụ có sẵn logo và giá — thường chỉ 3 chạm.';

  @override
  String get homeBrowse => 'Xem thư viện dịch vụ';

  @override
  String get homeAdd => 'Thêm subscription';

  @override
  String homePausedSince(String date) {
    return 'từ $date';
  }

  @override
  String homePausesOn(String date) {
    return 'Dừng từ $date';
  }

  @override
  String get homeAutoBadge => 'Tự động';

  @override
  String homeMoreLabels(int count) {
    return 'thêm $count nhãn';
  }

  @override
  String get homeFilter => 'Lọc';

  @override
  String homeFilterButtonLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lọc, đã chọn $count',
      zero: 'Lọc',
    );
    return '$_temp0';
  }

  @override
  String get homeFilterReset => 'Đặt lại';

  @override
  String get homeFilterStatus => 'Trạng thái';

  @override
  String get homeFilterCategory => 'Danh mục';

  @override
  String get homeFilterLabels => 'Nhãn';

  @override
  String get homeFilterPayment => 'Phương thức thanh toán';

  @override
  String get homeFilterRemember =>
      'Subnest nhớ bộ lọc và cách sắp xếp cho lần sau.';

  @override
  String homeFilterShow(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hiện $count subscription',
      zero: 'Không có subscription nào khớp',
    );
    return '$_temp0';
  }

  @override
  String homeFilterChipLabel(String name) {
    return 'Nhãn: $name';
  }

  @override
  String get homeFilterClear => 'Xoá lọc';

  @override
  String homeFilterRemove(String name) {
    return 'Bỏ lọc $name';
  }

  @override
  String get homeEmptyFiltered => 'Không có subscription nào khớp bộ lọc.';

  @override
  String homeBudgetUsed(int percent) {
    return '$percent% đã dùng';
  }

  @override
  String homeAutoAddedScan(int count) {
    return 'Đã thêm $count gói từ ảnh chụp';
  }

  @override
  String homeAutoAdded(int count) {
    return 'Đã tự động thêm $count gói';
  }

  @override
  String homeAutoConfirmed(int count) {
    return 'Đã tự động xác nhận $count khoản';
  }

  @override
  String get homeUndo => 'Hoàn tác';

  @override
  String get homeUndone => 'Đã hoàn tác';

  @override
  String get homeCostMonthly => 'Chi phí hàng tháng';

  @override
  String get homeCostYearly => 'Chi phí hàng năm';

  @override
  String homeDeltaVs(String amount, String period) {
    return '$amount so với $period';
  }

  @override
  String homeDeltaUpLabel(String amount, String period) {
    return 'Tăng $amount so với $period';
  }

  @override
  String homeDeltaDownLabel(String amount, String period) {
    return 'Giảm $amount so với $period';
  }

  @override
  String homeDeltaSame(String period) {
    return 'Bằng $period';
  }

  @override
  String get homeFirstMonth => 'Tháng đầu — chưa có để so sánh';

  @override
  String homeCostActive(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gói đang hoạt động',
    );
    return '$_temp0';
  }

  @override
  String homeCostPerDay(String amount) {
    return '$amount mỗi ngày';
  }

  @override
  String homeCostYearSub(String year, String amount) {
    return 'Năm $year · $amount mỗi tháng';
  }

  @override
  String get homeCostNone => 'Chưa có gói nào';

  @override
  String get homePaid => 'Đã thanh toán';

  @override
  String get homeStillToPay => 'Còn phải thanh toán';

  @override
  String homeCashLabel(String paid, String due) {
    return 'Đã thanh toán $paid, còn phải thanh toán $due';
  }

  @override
  String homeRange(String from, String to) {
    return '$from đến $to';
  }

  @override
  String homeColumnLabel(String month, String amount) {
    return '$month: $amount. Mở Thống kê của tháng này';
  }

  @override
  String get homeInfoButton => 'Cách tính';

  @override
  String get homeInfoTitle => 'Cách tính các con số';

  @override
  String get homeInfoMonthlyBody =>
      'Mọi gói đang trả trong tháng, chia đều: gói năm tính 1/12 mỗi tháng. Dùng thử chỉ tính từ tháng trả phí đầu; tạm dừng thì ngừng tính từ tháng sau.';

  @override
  String get homeInfoCashTitle => 'Đã thanh toán · Còn phải thanh toán';

  @override
  String get homeInfoCashBody =>
      'Tiền thật bị trừ trong tháng: các khoản đã xác nhận, cộng kỳ sắp tới và kỳ đang chờ. Gói năm gia hạn trong tháng tính đủ giá năm.';

  @override
  String get homeInfoApproxTitle => 'Vì sao có ≈';

  @override
  String get homeInfoApproxBody =>
      'Tiền tệ khác được quy đổi theo tỷ giá hôm nay và làm tròn từng dòng, nên các dòng luôn cộng đúng bằng tổng.';

  @override
  String get homeInfoNote =>
      'Vì vậy Đã + Còn phải thanh toán có thể khác Chi phí hàng tháng.';

  @override
  String get homeInfoGotIt => 'Đã hiểu';

  @override
  String homeTrialThenOn(String price, String date) {
    return 'Sẽ có giá $price vào $date';
  }

  @override
  String homeNoticeTitle(String name) {
    return '$name đổi giá';
  }

  @override
  String homeNoticeShare(String before, String after, String date) {
    return 'Phần của bạn từ $before lên $after, từ kỳ $date.';
  }

  @override
  String homeNoticeFrom(String date) {
    return 'Áp dụng từ kỳ $date. Các kỳ đã trả giữ nguyên.';
  }

  @override
  String get homeNoticeReference => 'Giá tham khảo — kiểm lại';

  @override
  String get homeNoticeUpdate => 'Cập nhật';

  @override
  String get homeNoticeKeep => 'Giữ giá cũ';

  @override
  String homeNoticeUpdated(String name, String price, String date) {
    return '$name: $price từ $date';
  }

  @override
  String homeNoticeKept(String name, String price) {
    return 'Giữ $name ở giá $price';
  }

  @override
  String get homeNoticeStale => 'Giá đã được đổi trước đó — không cập nhật gì';

  @override
  String get homeUpcomingTitle => 'Thanh toán sắp tới';

  @override
  String get homeSeeAll => 'Xem tất cả';

  @override
  String homeNext30(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lần tính phí',
    );
    return '30 ngày tới: $amount trong $_temp0';
  }

  @override
  String get homeNext30None => 'Không có khoản nào trong 30 ngày tới';

  @override
  String homeDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Còn $days ngày',
      one: 'Ngày mai',
      zero: 'Hôm nay',
    );
    return '$_temp0';
  }

  @override
  String homeFirstChargeWhen(String when) {
    return 'Lần trừ đầu · $when';
  }

  @override
  String homeMarkPaid(String name) {
    return 'Đánh dấu $name đã trả';
  }

  @override
  String get homeBudgetTitle => 'Ngân sách';

  @override
  String homeBudgetOf(String spent, String limit) {
    return '$spent / $limit';
  }

  @override
  String homeBudgetOver(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count danh mục vượt ngân sách: $names',
    );
    return '$_temp0';
  }

  @override
  String get homeTabPaused => 'Tạm dừng';

  @override
  String get homeEmptyPaused =>
      'Không có gói tạm dừng. Tạm dừng từ trang chi tiết — gói ngừng tính từ ngày thanh toán kế tiếp.';

  @override
  String get homeSortButton => 'Sắp xếp';

  @override
  String get homeSortRecent => 'Mới thêm';

  @override
  String homeSavingYear(String amount) {
    return 'Bạn đang tiết kiệm $amount/năm';
  }

  @override
  String get homeRise => 'Giá vừa tăng';

  @override
  String get homeSearchYours => 'Gói của bạn';

  @override
  String get homeSearchLibrary => 'Thêm từ thư viện';

  @override
  String get homeSearchCancel => 'Huỷ';

  @override
  String get insightsModeMonth => 'Tháng';

  @override
  String get insightsModeYear => 'Năm';

  @override
  String insightsPrevious(String mode) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'year': 'Năm trước',
      'other': 'Tháng trước',
    });
    return '$_temp0';
  }

  @override
  String insightsNext(String mode) {
    String _temp0 = intl.Intl.selectLogic(mode, {
      'year': 'Năm sau',
      'other': 'Tháng sau',
    });
    return '$_temp0';
  }

  @override
  String get insightsProjected => 'Dự kiến';

  @override
  String insightsCostOfMonth(String name, String number) {
    return 'Chi phí tháng $number';
  }

  @override
  String insightsCostOfYear(String year) {
    return 'Chi phí năm $year';
  }

  @override
  String insightsVsMonth(String name, String number) {
    return 'so với thg $number';
  }

  @override
  String insightsVsYear(String year) {
    return 'so với $year';
  }

  @override
  String insightsSameMonth(String name, String number) {
    return 'Bằng thg $number';
  }

  @override
  String insightsSameYear(String year) {
    return 'Bằng $year';
  }

  @override
  String insightsChangeLabel(String direction, String amount, String vs) {
    String _temp0 = intl.Intl.selectLogic(direction, {
      'up': 'Tăng $amount $vs',
      'down': 'Giảm $amount $vs',
      'other': '$vs',
    });
    return '$_temp0';
  }

  @override
  String insightsCount(int count) {
    return '$count gói';
  }

  @override
  String insightsPerDay(String amount) {
    return '$amount mỗi ngày';
  }

  @override
  String insightsPerMonth(String amount) {
    return '$amount mỗi tháng';
  }

  @override
  String get insightsHowCalculated => 'Cách tính';

  @override
  String get insightsPaid => 'Đã thanh toán';

  @override
  String get insightsStillToPay => 'Còn phải thanh toán';

  @override
  String get insightsNotPaid => 'Không trả';

  @override
  String insightsCashLabel(String paid, String due) {
    return 'Đã thanh toán $paid, còn phải thanh toán $due';
  }

  @override
  String insightsCashLabelPast(String paid, String due) {
    return 'Đã thanh toán $paid, không trả $due';
  }

  @override
  String insightsNothingInMonth(String name, String number) {
    return 'Chưa có gói nào phải trả trong tháng $number.';
  }

  @override
  String insightsNothingInYear(String year) {
    return 'Chưa có gói nào phải trả trong năm $year.';
  }

  @override
  String insightsMissingRates(String currencies) {
    return 'Chưa tính các khoản bằng $currencies — chưa có tỷ giá.';
  }

  @override
  String get insightsInfoTitle => 'Cách tính các con số';

  @override
  String get insightsInfoMonthlyTitle => 'Chi phí hàng tháng';

  @override
  String get insightsInfoMonthlyBody =>
      'Mọi gói đang trả trong tháng, chia đều: gói năm tính 1/12 mỗi tháng. Dùng thử chỉ tính từ tháng trả phí đầu; tạm dừng thì ngừng tính từ tháng sau.';

  @override
  String get insightsInfoCashTitle => 'Đã thanh toán · Còn phải thanh toán';

  @override
  String get insightsInfoCashBody =>
      'Tiền thật bị trừ trong tháng: các khoản đã xác nhận, cộng kỳ sắp tới và kỳ đang chờ. Gói năm gia hạn trong tháng tính đủ giá năm.';

  @override
  String get insightsInfoApproxTitle => 'Vì sao có ≈';

  @override
  String get insightsInfoApproxBody =>
      'Tiền tệ khác được quy đổi theo tỷ giá hôm nay và làm tròn từng dòng, nên các dòng luôn cộng đúng bằng tổng.';

  @override
  String get insightsInfoNote =>
      'Vì vậy Đã + Còn phải thanh toán có thể khác Chi phí hàng tháng.';

  @override
  String get insightsInfoOk => 'Đã hiểu';

  @override
  String get insightsBars12 => '12 tháng';

  @override
  String insightsBarsYear(String year) {
    return 'Từng tháng năm $year';
  }

  @override
  String get insightsTapBar => 'Chạm một cột';

  @override
  String get insightsLegendMonthly => 'Chi phí tháng';

  @override
  String insightsBarLabel(String month, String amount, String projected) {
    String _temp0 = intl.Intl.selectLogic(projected, {
      'yes': ', dự kiến',
      'other': '',
    });
    return '$month: $amount$_temp0';
  }

  @override
  String insightsChartLabel(String from, String to) {
    return 'Chi phí tháng, từ $from đến $to';
  }

  @override
  String get insightsByCategory => 'Theo danh mục';

  @override
  String insightsSliceLabel(String category, String amount, int percent) {
    return '$category: $amount, $percent%';
  }

  @override
  String get insightsTop => 'Đắt nhất';

  @override
  String get insightsShareOfMonth => 'phần trong tháng';

  @override
  String get insightsShareOfYear => 'phần trong năm';

  @override
  String get insightsRises => 'Tăng giá';

  @override
  String get insightsRisesPerMonth => 'mỗi tháng so với một năm trước';

  @override
  String insightsRisesYearly(String amount, String name) {
    return 'Tức là $amount mỗi năm · $name thay đổi nhiều nhất';
  }

  @override
  String get insightsRisesEmpty => 'Không gói nào tăng giá trong 12 tháng qua.';

  @override
  String insightsRiseLabel(String name, String from, String to, String delta) {
    return '$name: từ $from lên $to, $delta mỗi tháng';
  }

  @override
  String insightsReview(String name) {
    return 'Xem xét $name';
  }

  @override
  String get insightsNext12 => '12 tháng tới';

  @override
  String get insightsForecastProjected => 'Dự tính';

  @override
  String get insightsLast12 => '12 tháng qua';

  @override
  String insightsForecastChange(String amount) {
    return '$amount mỗi năm so với 12 tháng qua';
  }

  @override
  String get insightsForecastPartial =>
      'Các khoản đã ghi chưa phủ hết 12 tháng qua nên phép so sánh này chỉ tương đối.';

  @override
  String get insightsForecastNew => 'Gói đăng ký thêm năm nay';

  @override
  String get insightsForecastRises => 'Gói tăng giá';

  @override
  String get insightsForecastOther => 'Khác';

  @override
  String get insightsViewList => 'Xem dạng danh sách';

  @override
  String get insightsComingUp => 'Sắp tới';

  @override
  String get insightsWeeks13 => '13 tuần';

  @override
  String insightsWeekShort(int week) {
    return 'T$week';
  }

  @override
  String insightsWeekLabel(int week, String amount) {
    return 'Tuần $week: $amount';
  }

  @override
  String insightsBiggest(String when, String amount) {
    return 'Lớn nhất: $when · $amount';
  }

  @override
  String insightsRenews(String name) {
    return '($name gia hạn)';
  }

  @override
  String get insightsNothingAhead => 'Không có khoản nào trong khoảng này.';

  @override
  String get insightsBudgets => 'Ngân sách';

  @override
  String get insightsEdit => 'Sửa';

  @override
  String insightsBudgetLabel(
    String category,
    String spent,
    String limit,
    String over,
  ) {
    String _temp0 = intl.Intl.selectLogic(over, {
      'yes': ', vượt ngân sách',
      'other': '',
    });
    return '$category: $spent trên $limit$_temp0';
  }

  @override
  String insightsSavingTitle(String amount) {
    return 'Bạn đang tiết kiệm $amount/năm';
  }

  @override
  String insightsSavingBy(int count) {
    return 'nhờ huỷ $count gói';
  }

  @override
  String insightsNotWorthHint(int count, String amount) {
    return 'Bỏ $count gói bạn đánh giá “Không đáng” sẽ tiết kiệm thêm $amount/năm.';
  }

  @override
  String insightsOverlapVideo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn trả $count dịch vụ video — cần hết không?',
      two: 'Bạn trả 2 dịch vụ video — cần cả hai không?',
    );
    return '$_temp0';
  }

  @override
  String insightsOverlapMusic(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn trả $count dịch vụ nhạc — cần hết không?',
      two: 'Bạn trả 2 dịch vụ nhạc — cần cả hai không?',
    );
    return '$_temp0';
  }

  @override
  String insightsCategoryTitle(String category, String period) {
    return '$category · $period';
  }

  @override
  String insightsCategoryShare(int count, int percent, String period) {
    return '$count gói · $percent% của $period';
  }

  @override
  String insightsPauseNote(String name, String period, String date) {
    return '$name vẫn tính trong $period — tạm dừng từ $date.';
  }

  @override
  String insightsForecastCount(int count) {
    return '$count lần trừ dự kiến theo ngày thanh toán thật';
  }

  @override
  String get insightsEmptyTitle => 'Thêm gói để xem thống kê';

  @override
  String get insightsEmptyBody =>
      'Chi phí tháng, danh mục, tăng giá và 12 tháng tới sẽ hiện ở đây.';

  @override
  String get insightsEmptyAction => 'Xem thư viện dịch vụ';

  @override
  String get manageCategoriesTitle => 'Danh mục';

  @override
  String get manageLabelsTitle => 'Nhãn';

  @override
  String get managePaymentMethodsTitle => 'Phương thức thanh toán';

  @override
  String get manageBudgetsTitle => 'Ngân sách';

  @override
  String manageSubCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gói',
      zero: 'Chưa có gói',
    );
    return '$_temp0';
  }

  @override
  String get manageCategoriesIntro =>
      'Kéo để sắp xếp. Màu dùng trong biểu đồ và bộ lọc.';

  @override
  String get manageNewCategory => 'Thêm danh mục';

  @override
  String get manageEditCategory => 'Sửa danh mục';

  @override
  String get manageName => 'Tên';

  @override
  String get manageNameRequired => 'Nhập tên';

  @override
  String get manageColour => 'Màu';

  @override
  String get manageIcon => 'Biểu tượng';

  @override
  String get manageDeleteCategory => 'Xoá danh mục';

  @override
  String manageDeleteTitle(String name) {
    return 'Xoá “$name”?';
  }

  @override
  String manageDeleteMoveBody(int count) {
    return '$count gói đang dùng danh mục này. Chuyển sang:';
  }

  @override
  String get manageDeleteUnusedBody => 'Không gói nào dùng danh mục này.';

  @override
  String get manageMoveAndDelete => 'Chuyển và xoá';

  @override
  String manageMoveCategory(String name) {
    return 'Chuyển sang $name';
  }

  @override
  String get manageReorderHint => 'Kéo để đổi thứ tự';

  @override
  String get manageLabelsIntro =>
      'Nhãn dùng chéo danh mục — một gói có thể có nhiều nhãn.';

  @override
  String get manageNewLabel => 'Thêm nhãn';

  @override
  String get manageEditLabel => 'Sửa nhãn';

  @override
  String get manageDeleteLabel => 'Xoá nhãn';

  @override
  String get manageDeleteLabelBody =>
      'Nhãn được gỡ khỏi các gói đang gắn. Các gói vẫn giữ nguyên.';

  @override
  String get managePaymentMethodsIntro =>
      'Chỉ là tên gọi — Subnest không kết nối ngân hàng hay thẻ.';

  @override
  String get manageAddPaymentMethod => 'Thêm phương thức';

  @override
  String get manageEditPaymentMethod => 'Sửa phương thức';

  @override
  String get manageDeletePaymentMethod => 'Xoá phương thức';

  @override
  String get manageDeletePaymentMethodBody =>
      'Các gói đang dùng sẽ không còn phương thức thanh toán.';

  @override
  String get manageBudgetTotal => 'Ngân sách tháng, tất cả gói';

  @override
  String manageBudgetUsed(int percent, String amount) {
    return '$percent% đã dùng tháng này · $amount';
  }

  @override
  String get manageBudgetPerCategory => 'Theo danh mục · tuỳ chọn';

  @override
  String manageBudgetThisMonth(String amount) {
    return '$amount tháng này';
  }

  @override
  String get manageBudgetSet => 'Đặt';

  @override
  String get manageBudgetNote =>
      'Ngân sách so với chi phí tháng. Vượt thì thanh chuyển đỏ — không gửi thông báo.';

  @override
  String manageBudgetFor(String name) {
    return 'Ngân sách · $name';
  }

  @override
  String get manageBudgetAmount => 'Mỗi tháng';

  @override
  String get manageBudgetRemove => 'Bỏ ngân sách';

  @override
  String get manageBudgetInvalid => 'Nhập số tiền lớn hơn 0';

  @override
  String get manageBudgetTotalNone => 'Chưa đặt ngân sách tháng';

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
  String get notificationsBackupFailed =>
      'Sao lưu lỗi — mở Subnest để kiểm tra';

  @override
  String get onboardingSkip => 'Bỏ qua';

  @override
  String onboardingStep(int step, int total) {
    return 'Bước $step/$total';
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
  String get onboardingWelcomeTitle => 'Mọi gói đăng ký, một tổ';

  @override
  String get onboardingBenefitRemind => 'Nhắc trước khi bị trừ tiền';

  @override
  String get onboardingBenefitRemindSub =>
      'Trước kỳ gia hạn và trước khi hết dùng thử.';

  @override
  String get onboardingBenefitTotal => 'Biết mỗi tháng tốn bao nhiêu';

  @override
  String get onboardingBenefitTotalSub =>
      'Mọi giá đều ghi rõ chu kỳ — hết đoán.';

  @override
  String get onboardingBenefitPrivate => 'Dữ liệu chỉ nằm trên máy';

  @override
  String get onboardingBenefitPrivateSub =>
      'Không tài khoản, không ngân hàng, không theo dõi.';

  @override
  String get onboardingStart => 'Bắt đầu';

  @override
  String get onboardingCurrencyTitle => 'Tiền tệ chính của bạn';

  @override
  String get onboardingCurrencyHint =>
      'Dùng để cộng tổng. Mỗi gói vẫn giữ tiền tệ riêng.';

  @override
  String get onboardingCurrencyChange => 'Chọn tiền tệ khác…';

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
  String get onboardingPickSearch => 'Tìm trong 500+ dịch vụ';

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
  String get onboardingPickEdit => 'Giá & chu kỳ';

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
    return 'Trước 3 ngày khi sắp gia hạn hoặc hết dùng thử, lúc $time. Đổi được bất cứ lúc nào.';
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
  String get securitySection => 'Bảo mật';

  @override
  String get securityPinLock => 'Khoá mã PIN';

  @override
  String get securityPinWarning =>
      'Nếu quên mã, cách duy nhất để dùng lại là xóa toàn bộ dữ liệu trong app.';

  @override
  String get securityEnterPin => 'Nhập mã PIN';

  @override
  String get securityNewPin => 'Đặt mã PIN 4 số';

  @override
  String get securityConfirmPin => 'Nhập lại mã PIN';

  @override
  String get securityPinMismatch => 'Hai mã không khớp. Đặt lại mã.';

  @override
  String get securityWrongPin => 'Sai mã PIN. Thử lại.';

  @override
  String get securityForgotPin => 'Quên mã?';

  @override
  String get securityForgotPinTitle => 'Quên mã PIN?';

  @override
  String get securityForgotPinBody =>
      'Subnest không có tài khoản hay máy chủ nên không thể đặt lại PIN. Cách duy nhất là xoá toàn bộ dữ liệu trên máy và bắt đầu lại. Sau đó bạn có thể khôi phục từ file sao lưu.';

  @override
  String securityKeypadDigit(String digit) {
    return 'Số $digit';
  }

  @override
  String get securityKeypadBackspace => 'Xóa số cuối';

  @override
  String securityPinProgress(int count) {
    return 'Đã nhập $count trên 4 số';
  }

  @override
  String get securityPrivacyScreen => 'Che nội dung khi chuyển app';

  @override
  String get securityPrivacyScreenNote => 'Đồng thời chặn chụp màn hình';

  @override
  String get securityPrivacyScreenNoteIos =>
      'Ẩn nội dung trong màn chuyển app. iPhone không cho app chặn chụp màn hình.';

  @override
  String get securityTryAgain => 'Thử lại';

  @override
  String get securityPinSetNote =>
      'Bạn sẽ nhập khi mở Subnest và khi quay lại sau 1 phút.';

  @override
  String get securityPinOffNote => '4 số, hỏi khi mở Subnest';

  @override
  String get securityPinOnNote => 'Bật · hỏi khi quay lại sau 1 phút';

  @override
  String get securityChangePin => 'Đổi mã PIN';

  @override
  String get securityPinChanged => 'Đã đổi mã PIN';

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
  String get settingsNotificationsOn => 'Đã cho phép';

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
  String get settingsRemindBefore => 'Nhắc trước kỳ thanh toán';

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
      'Chọn bao nhiêu mốc tuỳ ý. Dùng thử cũng được nhắc như vậy trước khi hết.';

  @override
  String get settingsReminderTimeShort => 'Giờ nhắc';

  @override
  String get settingsRemindersNote =>
      'Từng gói có thể chỉnh riêng trong màn sửa. Bật PIN không đổi nội dung thông báo.';

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
  String get settingsExportCsv => 'Xuất CSV';

  @override
  String get settingsExportCsvHint => 'Gói và thanh toán, mở bằng bảng tính';

  @override
  String get settingsExportCsvLong => 'Subscription và thanh toán dạng .csv';

  @override
  String get settingsExported => 'Đã lưu — hãy cất ở nơi an toàn';

  @override
  String get settingsExportFailed => 'Không tạo được file. Hãy thử lại.';

  @override
  String get settingsRestore => 'Khôi phục';

  @override
  String get settingsRestoreHint => 'Thay thế toàn bộ dữ liệu trên máy';

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
  String get settingsRestoreTitle => 'Thay thế toàn bộ dữ liệu?';

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
  String get settingsRestoreReplaceAction => 'Thay thế và khôi phục';

  @override
  String get settingsRestoreReplaceNote =>
      'Mọi thứ trên máy này — subscription, thanh toán, danh sách và cài đặt — sẽ được thay bằng bản sao lưu. Sao lưu tự động giữ nguyên.';

  @override
  String get settingsRestoreInvalid =>
      'File này không phải bản sao lưu Subnest.';

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
  String get settingsTerms => 'Điều khoản';

  @override
  String get settingsLicenses => 'Giấy phép';

  @override
  String get settingsLogosTitle => 'Logo dịch vụ';

  @override
  String get settingsLogosOwnership =>
      'Tên và logo dịch vụ thuộc chủ sở hữu tương ứng.';

  @override
  String get settingsRateApp => 'Đánh giá app';

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
  String get settingsSectionData => 'Dữ liệu';

  @override
  String get settingsDataNote =>
      'Dữ liệu của bạn nằm trên máy này. Hãy sao lưu trước khi đổi máy.';

  @override
  String get settingsExportBackup => 'Xuất bản sao lưu';

  @override
  String get settingsExportBackupHint =>
      'File .subnest mã hóa để khôi phục sau';

  @override
  String get settingsAutoBackup => 'Sao lưu tự động';

  @override
  String get settingsAutoBackupNote =>
      'Sao lưu mỗi ngày một lần vào thư mục bạn chọn. Việc tải lên Google Drive hay Dropbox do app đó thực hiện.';

  @override
  String get settingsAutoBackupNoteIos =>
      'Subnest chỉ ghi file vào thư mục bạn chọn trong app Tệp, ví dụ trong iCloud Drive.';

  @override
  String get settingsAutoBackupRunsOnOpenIos =>
      'iPhone không cho app tự chạy khi đã đóng. Đúng giờ bạn chọn, Subnest gửi thông báo; chạm vào hoặc mở app để sao lưu. Lỡ giờ thì sao lưu bù khi bạn mở app, mỗi ngày tối đa một lần.';

  @override
  String settingsAutoBackupFolder(String name) {
    return 'Thư mục: $name';
  }

  @override
  String get settingsAutoBackupFolderUnknown => 'Thư mục đã chọn';

  @override
  String get settingsAutoBackupLocalFolderWarningIos =>
      'Thư mục này có thể chỉ nằm trên iPhone. Nếu vậy, mất máy là mất luôn các file này. Để giữ an toàn, hãy chọn thư mục trong iCloud Drive hoặc Google Drive.';

  @override
  String settingsAutoBackupLast(String time) {
    return 'Gần nhất: $time';
  }

  @override
  String settingsAutoBackupLastUnchanged(String checked, String last) {
    return 'Gần nhất: $last · kiểm $checked, không đổi';
  }

  @override
  String get settingsAutoBackupNever => 'Chưa sao lưu lần nào';

  @override
  String settingsAutoBackupFailedAt(String time, String error) {
    return 'Lần thử $time: $error';
  }

  @override
  String get settingsAutoBackupErrorFolder =>
      'không mở được thư mục — chạm Thư mục để chọn lại';

  @override
  String get settingsAutoBackupErrorOther => 'sao lưu lỗi';

  @override
  String settingsAutoBackupNextToday(String time) {
    return 'Lần tới: hôm nay, $time';
  }

  @override
  String settingsAutoBackupNextTomorrow(String time) {
    return 'Lần tới: ngày mai, $time';
  }

  @override
  String get settingsAutoBackupNextSoon => 'Đến giờ — sẽ chạy khi bạn rời app';

  @override
  String get settingsAutoBackupNextSoonIos =>
      'Đến giờ — sẽ chạy khi bạn mở app';

  @override
  String get settingsAutoBackupNow => 'Sao lưu ngay';

  @override
  String get settingsAutoBackupChooseFolder => 'Chọn thư mục';

  @override
  String get settingsAutoBackupTime => 'Giờ sao lưu';

  @override
  String get settingsAutoBackupTurnOn => 'Bật sao lưu tự động';

  @override
  String get settingsAutoBackupOffDone => 'Đã tắt sao lưu tự động';

  @override
  String get settingsAutoBackupDone => 'Đã lưu bản sao lưu';

  @override
  String get settingsAutoBackupBusy => 'Đang có một lần sao lưu chạy';

  @override
  String get settingsAutoBackupPickFailed => 'Không mở được bộ chọn thư mục';

  @override
  String get settingsAutoBackupPasswordTitle => 'Mật khẩu cho sao lưu tự động';

  @override
  String get settingsAutoBackupPasswordWarning =>
      'Quên mật khẩu này thì không mở được bản sao lưu. Subnest không khôi phục được.';

  @override
  String get settingsAutoBackupNotifyTitleIos => 'Cho phép nhắc sao lưu?';

  @override
  String get settingsAutoBackupNotifyBodyIos =>
      'Subnest báo một lần đúng giờ sao lưu. Chạm vào để sao lưu dữ liệu.';

  @override
  String get settingsAutoBackupNotifyDeniedIos =>
      'Thông báo đang tắt. Sao lưu tự động vẫn chạy khi bạn mở app.';

  @override
  String get settingsAutoBackupNotificationBody =>
      'Đến giờ sao lưu các gói đăng ký.';

  @override
  String get settingsBackupPassword => 'Mật khẩu';

  @override
  String get settingsBackupPasswordConfirm => 'Nhập lại mật khẩu';

  @override
  String get settingsBackupPasswordTooShort => 'Dùng ít nhất 6 ký tự';

  @override
  String get settingsBackupPasswordMismatch => 'Hai mật khẩu không khớp';

  @override
  String get settingsBackupPasswordWarning =>
      'Không có mật khẩu này thì không mở được file. Hãy giữ nó cẩn thận.';

  @override
  String get settingsBackupProtect => 'Đặt mật khẩu';

  @override
  String get settingsBackupExportNote =>
      'File chứa mọi thứ: gói đăng ký, thanh toán, danh mục và cài đặt.';

  @override
  String get settingsBackupExportAction => 'Xuất';

  @override
  String get settingsBackupWorking => 'Đang xử lý…';

  @override
  String get settingsBackupEnterPasswordTitle => 'Nhập mật khẩu bản sao lưu';

  @override
  String get settingsBackupEnterPasswordBody =>
      'Bản sao lưu này đã mã hóa. Nhập mật khẩu bạn đặt khi xuất file.';

  @override
  String get settingsBackupWrongPassword => 'Sai mật khẩu';

  @override
  String get settingsBackupOpen => 'Mở';

  @override
  String get settingsDeleteAll => 'Xoá toàn bộ dữ liệu';

  @override
  String get settingsDeleteAllHint => 'Mọi thứ, như mới cài';

  @override
  String get settingsDeleteAllTitle => 'Xoá toàn bộ dữ liệu?';

  @override
  String get settingsDeleteAllConfirm =>
      'Mọi gói, thanh toán, lịch sử giá, nhãn và cài đặt trên máy bị xoá. Subnest quay về màn hình lần đầu. File sao lưu tự động trong thư mục vẫn được giữ.';

  @override
  String get settingsDeleteAllConfirm2 => 'Không thể hoàn tác.';

  @override
  String get settingsCannotUndo => 'Không thể hoàn tác';

  @override
  String get settingsDeleteEverything => 'Xoá tất cả';

  @override
  String get settingsDelete => 'Xóa';

  @override
  String get settingsDeleteAllDone => 'Đã xoá toàn bộ dữ liệu';

  @override
  String get settingsThemeNote => 'Hệ thống: theo chế độ sáng/tối của máy.';

  @override
  String get settingsLanguageNote =>
      'Cả app đổi ngay. Ngày và số tiền định dạng theo ngôn ngữ.';

  @override
  String get settingsHideTabBar => 'Ẩn thanh tab khi cuộn';

  @override
  String get settingsSectionOrganize => 'Sắp xếp gói';

  @override
  String settingsBudgetValue(String amount) {
    return '$amount/tháng';
  }

  @override
  String get settingsBudgetNotSet => 'Chưa đặt';

  @override
  String get settingsSectionAutomation => 'Tự động';

  @override
  String get settingsScan => 'Quét ảnh chụp';

  @override
  String get settingsScanHint => 'Thêm từ trang cửa hàng và hoá đơn';

  @override
  String get settingsBankNotifications => 'Thông báo ngân hàng/ví';

  @override
  String get settingsSoon => 'Sắp có';

  @override
  String get settingsAutoBackupOffNote => 'Tắt — dữ liệu chỉ nằm trên máy';

  @override
  String get settingsAutoBackupFolderLabel => 'Thư mục';

  @override
  String get settingsAutoBackupTimeLabel => 'Giờ';

  @override
  String settingsAutoBackupDaily(String time) {
    return '$time mỗi ngày';
  }

  @override
  String get settingsAutoBackupPasswordLabel => 'Mật khẩu';

  @override
  String get settingsAutoBackupKeepsLabel => 'Giữ';

  @override
  String get settingsAutoBackupKeepsValue => '2 file mới nhất';

  @override
  String get settingsAutoBackupIntro =>
      'Mỗi ngày Subnest lưu một file .subnest đã mã hoá vào thư mục bạn chọn — trên máy, thẻ nhớ hoặc thư mục đồng bộ như Google Drive.';

  @override
  String get settingsAutoBackupSetupTime => 'Giờ sao lưu';

  @override
  String get settingsAutoBackupKeep => 'Giữ lại';

  @override
  String get settingsAutoBackupKeepValue => '2 file mới nhất';

  @override
  String get settingsAutoBackupChoose => 'Chọn…';

  @override
  String get settingsAutoBackupPasswordRule => 'Ít nhất 6 ký tự';

  @override
  String get settingsAutoBackupWriteDownTitle => 'Ghi lại mật khẩu';

  @override
  String get settingsAutoBackupWriteDownBody =>
      'Không có mật khẩu thì không mở được file — không thể đặt lại.';

  @override
  String get settingsAutoBackupFolderNeeded => 'Hãy chọn thư mục trước';

  @override
  String get settingsBackupNow => 'Sao lưu ngay';

  @override
  String get settingsBackupNowHint => 'File .subnest, có hoặc không mật khẩu';

  @override
  String settingsBackupFileMeta(int subs, int payments, String size) {
    return '$subs gói · $payments thanh toán · $size';
  }

  @override
  String get settingsBackupProtectHint => 'Nên bật nếu lưu lên đám mây';

  @override
  String get settingsBackupSave => 'Lưu file…';

  @override
  String get settingsRestoreValid => 'Hợp lệ';

  @override
  String settingsRestoreProtected(String size) {
    return 'Có mật khẩu · $size';
  }

  @override
  String get settingsRestoreInFile => 'Trong file';

  @override
  String get settingsRestoreSubs => 'Gói đăng ký';

  @override
  String get settingsRestorePayments => 'Thanh toán';

  @override
  String get settingsRestorePriceChanges => 'Lần đổi giá';

  @override
  String get settingsRestoreSettings => 'Cài đặt và nhãn';

  @override
  String get settingsRestoreIncluded => 'Có';

  @override
  String get settingsRestoreWarnTitle => 'Khôi phục sẽ thay thế toàn bộ';

  @override
  String get settingsRestoreWarnBody =>
      'Dữ liệu hiện có trên máy bị xoá và thay bằng dữ liệu trong file.';

  @override
  String get settingsRestoreHasPassword => 'File có mật khẩu';

  @override
  String get settingsRestoreUnlock => 'Mở khoá và khôi phục';

  @override
  String settingsRestoreReplaceBody(int current, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      current,
      locale: localeName,
      other: '$current gói hiện tại',
      zero: 'Dữ liệu hiện tại',
    );
    return '$_temp0 sẽ được thay bằng $count gói trong bản sao lưu này.';
  }

  @override
  String settingsDeleteAllTypeTitle(String word) {
    return 'Gõ $word để xác nhận';
  }

  @override
  String get settingsDeleteAllWord => 'XOA';

  @override
  String settingsVersionValue(String version) {
    return 'Phiên bản $version';
  }

  @override
  String get settingsLibrary => 'Thư viện dịch vụ';

  @override
  String settingsLibraryValue(String ago, int count) {
    return 'Cập nhật $ago · $count dịch vụ';
  }

  @override
  String settingsLibraryCount(int count) {
    return '$count dịch vụ';
  }

  @override
  String get settingsAgoToday => 'hôm nay';

  @override
  String get settingsPriceLists => 'Bảng giá';

  @override
  String get settingsPriceListsValue => 'US + Việt Nam';

  @override
  String get settingsAutomationHero => 'Để Subnest tự tìm gói đăng ký';

  @override
  String get settingsAutomationHeroBody =>
      'Mọi thứ được đọc ngay trên máy. Không tải gì lên.';

  @override
  String get settingsAutomationScanHint =>
      'Trang gói Google Play / App Store, hoá đơn';

  @override
  String get settingsOpen => 'Mở';

  @override
  String get settingsGmailHint => 'Email hoá đơn và gia hạn';

  @override
  String get settingsAutomationFound => 'Khi tìm thấy';

  @override
  String get settingsAutoAdd => 'Tự thêm gói mới';

  @override
  String get settingsAutoConfirm => 'Tự xác nhận kỳ';

  @override
  String get settingsAutomationNote =>
      'Mọi thay đổi tự động đều gắn nhãn Tự động và có Hoàn tác.';

  @override
  String get settingsEarlyAccessCta => 'Đăng ký dùng sớm';

  @override
  String get settingsProBody =>
      'Tự tìm và tự xác nhận gói cho bạn. Nhập tay luôn miễn phí.';

  @override
  String get settingsProNow => 'Có ngay';

  @override
  String get settingsProUndo => 'Hoàn tác mọi thay đổi';

  @override
  String get settingsEarlyAccessTitle => 'Đăng ký sớm';

  @override
  String get settingsEarlyAccessBody =>
      'Đăng ký ngay, app sẽ báo giá trước khi Pro bắt đầu tính phí. Không trừ tiền khi chưa hỏi bạn.';

  @override
  String get settingsJoinEarlyAccess => 'Đăng ký dùng sớm';

  @override
  String get settingsNotNow => 'Để sau';

  @override
  String get settingsEarlyAccessSubject => 'Đăng ký dùng sớm Subnest Pro';

  @override
  String settingsWhenToday(String time) {
    return 'hôm nay, $time';
  }

  @override
  String settingsWhenYesterday(String time) {
    return 'hôm qua, $time';
  }

  @override
  String get settingsBackupPasswordShow => 'Hiện mật khẩu';

  @override
  String get settingsBackupPasswordHide => 'Ẩn mật khẩu';

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
  String get subscriptionDetailStatusPaused => 'Tạm dừng';

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
  String get subscriptionDetailAwaitingBody =>
      'Ngày thanh toán tiếp theo chỉ chạy khi bạn xác nhận.';

  @override
  String get subscriptionDetailConfirm => 'Xác nhận';

  @override
  String subscriptionDetailTrialEnds(String date) {
    return 'Hết dùng thử $date';
  }

  @override
  String subscriptionDetailTrialSave(String price, String yearly) {
    return 'Sau đó $price. Huỷ trước để tiết kiệm $yearly/năm.';
  }

  @override
  String get subscriptionDetailHowToCancel => 'Cách huỷ';

  @override
  String get subscriptionDetailKeepIt => 'Giữ lại';

  @override
  String subscriptionDetailSaving(String amount) {
    return 'Tiết kiệm $amount/năm';
  }

  @override
  String subscriptionDetailCancelledBody(String date) {
    return 'Đã huỷ $date. Không còn nhắc nữa.';
  }

  @override
  String get subscriptionDetailRestoreShort => 'Khôi phục';

  @override
  String get subscriptionDetailRestore => 'Khôi phục gói';

  @override
  String subscriptionDetailRestored(String date) {
    return 'Đã khôi phục. Thanh toán tiếp theo: $date.';
  }

  @override
  String subscriptionDetailPausedTitle(String date) {
    return 'Tạm dừng từ $date';
  }

  @override
  String get subscriptionDetailPausedBody =>
      'Không trừ tiền, không nhắc, không tính vào tổng.';

  @override
  String get subscriptionDetailResume => 'Bật lại';

  @override
  String subscriptionDetailPausesTitle(String date) {
    return 'Tạm dừng từ $date';
  }

  @override
  String get subscriptionDetailPausesBody =>
      'Trước ngày đó vẫn tính — kỳ đó là kỳ đầu tiên được bỏ qua.';

  @override
  String get subscriptionDetailUndo => 'Hoàn tác';

  @override
  String subscriptionDetailPauseUndone(String date) {
    return 'Đã bỏ tạm dừng. Thanh toán tiếp theo: $date.';
  }

  @override
  String subscriptionDetailNoticeTitle(String price) {
    return 'Giá mới trong thư viện: $price';
  }

  @override
  String subscriptionDetailNoticeBody(String price) {
    return 'Bạn đang trả $price. Cập nhật từ kỳ tới, hoặc giữ giá của bạn.';
  }

  @override
  String get subscriptionDetailNoticeReview => 'Xem';

  @override
  String get subscriptionDetailPlanGoneTitle => 'Gói này đã ngừng bán';

  @override
  String get subscriptionDetailPlanGoneBody =>
      'Gói không còn bán cho khách mới. Gói của bạn giữ nguyên giá và ngày.';

  @override
  String get subscriptionDetailPlanClosedTitle => 'Không còn bán cho khách mới';

  @override
  String get subscriptionDetailPlanClosedBody =>
      'Khách đang dùng vẫn giữ được. Gói của bạn giữ nguyên giá và ngày.';

  @override
  String subscriptionDetailPlanRenamedTitle(String name) {
    return 'Nay có tên $name';
  }

  @override
  String subscriptionDetailPlanRenamedBody(String old) {
    return 'Thư viện đã đổi tên gói $old. Gói của bạn không đổi gì.';
  }

  @override
  String get subscriptionDetailLibrary => 'Thư viện dịch vụ';

  @override
  String get subscriptionDetailLibraryGone => 'Ngừng bán';

  @override
  String get subscriptionDetailLibraryClosed => 'Ngừng bán cho khách mới';

  @override
  String get subscriptionDetailLibraryRenamed => 'Đã đổi tên';

  @override
  String get subscriptionDetailAutoTitle => 'Được thêm tự động';

  @override
  String subscriptionDetailAutoBody(String source, String date) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'scan': 'Tìm thấy trong ảnh chụp',
      'notification': 'Tìm thấy trong thông báo ngân hàng',
      'other': 'Tìm thấy trong email',
    });
    return '$_temp0 ngày $date. Không phải của bạn? Gỡ đi — app sẽ không thêm lại.';
  }

  @override
  String get subscriptionDetailAutoRemove => 'Gỡ';

  @override
  String subscriptionDetailAutoRemoveTitle(String name) {
    return 'Gỡ $name?';
  }

  @override
  String subscriptionDetailAutoRemoveBody(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'scan': 'từ ảnh chụp',
      'notification': 'từ thông báo ngân hàng',
      'other': 'từ email',
    });
    return 'Gói này được thêm $_temp0. Subnest sẽ ghi nhớ và không tự thêm lại.';
  }

  @override
  String subscriptionDetailAutoRemoved(String name) {
    return 'Đã gỡ $name';
  }

  @override
  String get subscriptionDetailNextPayment => 'Thanh toán tiếp theo';

  @override
  String get subscriptionDetailFirstPayment => 'Lần trả đầu';

  @override
  String get subscriptionDetailWaits => 'Chờ bạn xác nhận';

  @override
  String get subscriptionDetailCycle => 'Chu kỳ';

  @override
  String get subscriptionDetailReminders => 'Nhắc';

  @override
  String get subscriptionDetailRemindOff => 'Tắt';

  @override
  String get subscriptionDetailCategory => 'Danh mục';

  @override
  String get subscriptionDetailLabels => 'Nhãn';

  @override
  String get subscriptionDetailPaymentMethod => 'Phương thức';

  @override
  String get subscriptionDetailSince => 'Bắt đầu từ';

  @override
  String get subscriptionDetailTotalPaid => 'Tổng đã trả';

  @override
  String get subscriptionDetailWorthIt => 'Đáng tiền?';

  @override
  String get subscriptionDetailNotes => 'Ghi chú';

  @override
  String get subscriptionDetailPriceHistory => 'Lịch sử giá';

  @override
  String get subscriptionDetailPriceNeverChanged => 'Giá chưa từng đổi.';

  @override
  String subscriptionDetailPriceFrom(String date) {
    return 'Từ $date';
  }

  @override
  String get subscriptionDetailPriceNext => 'kỳ tới';

  @override
  String get subscriptionDetailPriceSourceManual => 'Bạn sửa';

  @override
  String get subscriptionDetailPriceSourceCatalog => 'Thư viện cập nhật';

  @override
  String get subscriptionDetailPriceSourceBackfill => 'Từ các kỳ đã trả';

  @override
  String subscriptionDetailPriceStarted(String price) {
    return 'Bắt đầu với giá $price';
  }

  @override
  String subscriptionDetailPriceRose(String amount) {
    return 'tăng $amount';
  }

  @override
  String subscriptionDetailPriceFell(String amount) {
    return 'giảm $amount';
  }

  @override
  String get subscriptionDetailHistory => 'Lịch sử thanh toán';

  @override
  String get subscriptionDetailPaid => 'Đã trả';

  @override
  String get subscriptionDetailDidntPay => 'Không trả';

  @override
  String subscriptionDetailPaidFrom(String source) {
    String _temp0 = intl.Intl.selectLogic(source, {
      'scan': 'Từ ảnh chụp',
      'notification': 'Từ thông báo',
      'other': 'Từ email',
    });
    return '$_temp0';
  }

  @override
  String get subscriptionDetailAutoUndone =>
      'Đã gỡ thanh toán — kỳ đó lại chờ xác nhận.';

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
  String subscriptionDetailOpens(String host) {
    return 'Mở trang tài khoản $host';
  }

  @override
  String subscriptionDetailLinkFailed(String host) {
    return 'Không mở được $host.';
  }

  @override
  String get subscriptionDetailPause => 'Tạm dừng';

  @override
  String get subscriptionDetailMarkCancelled => 'Đánh dấu đã huỷ';

  @override
  String get subscriptionDetailDelete => 'Xoá gói đăng ký';

  @override
  String subscriptionDetailCancelTitle(String name) {
    return 'Đánh dấu $name đã huỷ?';
  }

  @override
  String subscriptionDetailCancelBody(String amount) {
    return 'Subnest ngừng nhắc và cộng $amount/năm vào khoản tiết kiệm. Khôi phục được bất cứ lúc nào.';
  }

  @override
  String get subscriptionDetailNotYet => 'Chưa';

  @override
  String subscriptionDetailDeleteTitle(String name) {
    return 'Xoá $name?';
  }

  @override
  String get subscriptionDetailDeleteBody =>
      'Gói này cùng lịch sử thanh toán và lịch sử giá sẽ bị xoá vĩnh viễn. Muốn tắt nhắc mà vẫn giữ lịch sử, hãy đánh dấu đã huỷ.';

  @override
  String get subscriptionDetailDeleteAction => 'Xoá';

  @override
  String subscriptionDetailDeleted(String name) {
    return 'Đã xoá $name';
  }

  @override
  String subscriptionDetailPauseTitle(String name) {
    return 'Tạm dừng $name?';
  }

  @override
  String get subscriptionDetailPauseBody =>
      'Không huỷ gì với nhà cung cấp — chỉ ngừng theo dõi.';

  @override
  String subscriptionDetailPauseNow(String date) {
    return 'Bây giờ → $date';
  }

  @override
  String get subscriptionDetailPauseNowBody => 'Vẫn tính — kỳ này bạn đã trả';

  @override
  String get subscriptionDetailPauseFromBody =>
      'Không trừ tiền, không nhắc, không tính tổng';

  @override
  String subscriptionDetailPauseAction(String date) {
    return 'Tạm dừng từ $date';
  }

  @override
  String subscriptionDetailPaused(String name, String date) {
    return '$name tạm dừng từ $date';
  }

  @override
  String subscriptionDetailResumeTitle(String name) {
    return 'Bật lại $name';
  }

  @override
  String get subscriptionDetailResumeAsk =>
      'Kỳ thanh toán tiếp theo vào ngày nào?';

  @override
  String get subscriptionDetailResumeNote =>
      'Mặc định là hôm nay. Chu kỳ bắt đầu lại từ ngày bạn chọn.';

  @override
  String get subscriptionDetailResumeToday => 'Bật lại từ hôm nay';

  @override
  String subscriptionDetailResumeFrom(String date) {
    return 'Bật lại từ $date';
  }

  @override
  String subscriptionDetailResumed(String date) {
    return 'Đã bật lại. Thanh toán tiếp theo: $date.';
  }

  @override
  String get subscriptionDetailPriceSheetTitle => 'Cập nhật giá?';

  @override
  String subscriptionDetailPriceSheetSub(String plan) {
    return '$plan · giá thư viện';
  }

  @override
  String get subscriptionDetailYouPayNow => 'Bạn đang trả';

  @override
  String get subscriptionDetailNewPrice => 'Giá mới';

  @override
  String subscriptionDetailShareOf(String amount) {
    return 'phần bạn $amount';
  }

  @override
  String subscriptionDetailPriceSheetNote(String date) {
    return 'Áp dụng từ kỳ $date và được ghi vào Lịch sử giá. Các khoản đã trả giữ nguyên.';
  }

  @override
  String get subscriptionDetailReferencePrice =>
      'Giá tham khảo — kiểm lại trên trang của hãng.';

  @override
  String subscriptionDetailUpdateFrom(String date) {
    return 'Cập nhật từ $date';
  }

  @override
  String subscriptionDetailKeepPrice(String price) {
    return 'Giữ $price';
  }

  @override
  String subscriptionDetailPriceUpdated(String date) {
    return 'Giá mới từ $date';
  }

  @override
  String subscriptionDetailPriceKept(String price) {
    return 'Giữ $price. Sẽ không hỏi lại về giá này.';
  }

  @override
  String get subscriptionDetailPriceStale =>
      'Giá vừa đổi trong lúc này — chưa cập nhật gì.';

  @override
  String subscriptionDetailCelebrateTitle(String amount) {
    return 'Tuyệt — thêm $amount mỗi năm';
  }

  @override
  String subscriptionDetailCelebrateBody(String name, String host) {
    return '$name đã được đánh dấu huỷ. Nhớ huỷ cả trên $host — Subnest không làm thay được.';
  }

  @override
  String subscriptionDetailCelebrateBodyNoHost(String name) {
    return '$name đã được đánh dấu huỷ. Nhớ huỷ cả với nhà cung cấp — Subnest không làm thay được.';
  }

  @override
  String get subscriptionDetailTotalSaving => 'Tổng tiết kiệm';

  @override
  String subscriptionDetailPerYear(String amount) {
    return '$amount/năm';
  }

  @override
  String subscriptionDetailFromCancelled(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'từ $count gói đã huỷ',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionDetailDone => 'Xong';

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
  String subscriptionFormPriceWas(String old) {
    return 'Giá cũ $old. Khi lưu, app hỏi giá mới áp dụng từ kỳ nào và ghi vào Lịch sử giá.';
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
  String get subscriptionFormRemindOnDay => 'Đúng ngày';

  @override
  String subscriptionFormRemindDays(int count) {
    return '$count ngày';
  }

  @override
  String get subscriptionFormRemindNone => 'Không nhắc subscription này';

  @override
  String get subscriptionFormMore => 'Thêm chi tiết';

  @override
  String get subscriptionFormMoreSub =>
      'Thanh toán, link huỷ, ghi chú, đáng tiền?';

  @override
  String get subscriptionFormPaymentMethod => 'Phương thức thanh toán';

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
    return 'Kỳ $date và các kỳ sau dùng giá mới. Các khoản đã trả giữ nguyên, thay đổi được ghi vào Lịch sử giá.';
  }

  @override
  String subscriptionFormPriceApply(String date) {
    return 'Áp dụng từ $date';
  }

  @override
  String get subscriptionFormTileTitle => 'Đổi biểu tượng';

  @override
  String get subscriptionFormTileColour => 'Màu';

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

  @override
  String get subscriptionFormReferenceHint => 'Hãy đối chiếu với hoá đơn';

  @override
  String get subscriptionFormReferenceNote =>
      'Giá tham khảo từ thư viện, chưa xác minh. Hãy đối chiếu với hoá đơn.';

  @override
  String get subscriptionFormLabels => 'Nhãn';

  @override
  String get subscriptionFormNewLabel => 'Nhãn mới';

  @override
  String get subscriptionFormNewLabelHint => 'vd: Gia đình, Công việc';

  @override
  String subscriptionFormMethodUsage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subscription',
      zero: 'Chưa dùng',
    );
    return '$_temp0';
  }

  @override
  String get subscriptionFormMethodAddHint => 'Thêm thẻ hoặc ví';

  @override
  String get subscriptionFormMethodNote =>
      'Chữ tự do — Subnest không bao giờ kết nối ngân hàng.';

  @override
  String get subscriptionFormAdd => 'Thêm';

  @override
  String get subscriptionFormWorthIt => 'Đáng tiền không?';

  @override
  String get subscriptionFormWorthNotRated => 'Chưa';

  @override
  String get subscriptionFormDelete => 'Xoá subscription';

  @override
  String subscriptionFormDeleteTitle(String name) {
    return 'Xoá $name?';
  }

  @override
  String get subscriptionFormDeleteBody =>
      'Lịch sử thanh toán cũng bị xoá. Không thể hoàn tác.';

  @override
  String get subscriptionFormDeleteAction => 'Xoá';

  @override
  String get subscriptionFormTilePhotoPick => 'Chọn ảnh';

  @override
  String get subscriptionFormTilePhotoRemove => 'Gỡ ảnh';

  @override
  String get subscriptionFormTilePhotoFailed => 'Không mở được ảnh này.';

  @override
  String get subscriptionFormCropTitle => 'Di chuyển và thu phóng';

  @override
  String get subscriptionFormCropHint =>
      'Phần trong khung vuông sẽ là biểu tượng';

  @override
  String get subscriptionFormCropUse => 'Dùng ảnh';

  @override
  String get subscriptionFormPriceNow => 'Hiện tại';

  @override
  String subscriptionFormPriceFrom(String date) {
    return 'Từ $date';
  }

  @override
  String subscriptionFormRemindAt(String time) {
    return 'lúc $time';
  }

  @override
  String get subscriptionFormCustomSub =>
      'Dịch vụ tự tạo · chạm biểu tượng để chọn ảnh';

  @override
  String get subscriptionFormAddMethod => 'Thêm';

  @override
  String get subscriptionFormTileLetterPreview => 'Chữ trên nền màu';

  @override
  String get subscriptionFormTilePhotoPreview => 'Ảnh của bạn, cắt vuông';

  @override
  String get subscriptionFormTileTakePhoto => 'Chụp ảnh';

  @override
  String get subscriptionFormTileLetterOrEmoji => 'Chữ cái hoặc emoji';

  @override
  String get subscriptionFormCropRotate => 'Xoay';

  @override
  String get subscriptionFormMethodNone => 'Không chọn';

  @override
  String get widgetThisMonth => 'Tháng này';

  @override
  String get widgetPerMonthShort => '/tháng';

  @override
  String widgetMonthlyTotalA11y(String amount) {
    return 'Tổng mỗi tháng $amount';
  }

  @override
  String get widgetPaid => 'Đã thanh toán';

  @override
  String get widgetStillToPay => 'Còn phải thanh toán';

  @override
  String widgetToConfirm(int count) {
    return '$count chờ xác nhận';
  }

  @override
  String get widgetAwaiting => 'Chờ xác nhận';

  @override
  String get widgetTapToConfirm => 'Chạm để xác nhận';

  @override
  String get widgetDueTomorrow => 'Ngày mai';

  @override
  String widgetDueInDays(String days) {
    return '$days ngày';
  }

  @override
  String get widgetLeftTomorrow => 'ngày mai';

  @override
  String widgetLeftDays(String days) {
    return 'còn $days ngày';
  }

  @override
  String widgetTrialEnds(String date) {
    return 'Hết dùng thử $date';
  }

  @override
  String get widgetEmptyTitle => 'Chưa có gói';

  @override
  String get widgetEmptyBody => 'Chạm để thêm gói đầu tiên';

  @override
  String get widgetLocked => 'Đã khoá bằng PIN';

  @override
  String get widgetLockedLong =>
      'Đã khoá bằng PIN — mở Subnest để xem các khoản';

  @override
  String get widgetOpenApp => 'Mở Subnest';
}
