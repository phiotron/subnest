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
  String calendarMonthTotal(String amount) {
    return 'Tổng tháng: $amount';
  }

  @override
  String get calendarEmpty => 'Tháng này không có khoản nào.';

  @override
  String get calendarPaid => 'Đã trả';

  @override
  String get calendarSkipped => 'Không trả';

  @override
  String get calendarUpcoming => 'Sắp tới';

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
  String get insightsEmpty => 'Thêm subscription để xem thống kê.';

  @override
  String get insightsThisMonth => 'Tháng này';

  @override
  String insightsActualVsProjected(String actual, String projected) {
    return 'Thực trả $actual · dự kiến $projected';
  }

  @override
  String insightsLastMonth(String amount) {
    return 'Tháng trước đã trả: $amount';
  }

  @override
  String get insightsTwelveMonths => '12 tháng (thực trả · dự kiến)';

  @override
  String get insightsByCategory => 'Theo danh mục (mỗi tháng)';

  @override
  String get insightsTop => 'Đắt nhất';

  @override
  String get insightsSavingsTitle => 'Tiết kiệm';

  @override
  String insightsSavings(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Bạn đang tiết kiệm $amount/năm nhờ huỷ $count dịch vụ',
    );
    return '$_temp0';
  }

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
  String get settingsCurrencySection => 'Tiền tệ';

  @override
  String get settingsPrimaryCurrency => 'Tiền tệ chính';

  @override
  String get settingsSearchCurrency => 'Tìm tiền tệ';

  @override
  String get settingsRates => 'Tỷ giá';

  @override
  String get settingsRatesNeverUpdated => 'Đang dùng tỷ giá gần đúng có sẵn';

  @override
  String settingsRatesUpdatedAt(String date) {
    return 'Cập nhật $date';
  }

  @override
  String get settingsRatesUpdateNow => 'Cập nhật ngay';

  @override
  String get settingsRatesUpdated => 'Đã cập nhật tỷ giá';

  @override
  String get settingsRatesFailed =>
      'Không cập nhật được — kiểm tra kết nối mạng';

  @override
  String get settingsRatesNoneUsed =>
      'Mọi subscription đều dùng tiền tệ chính.';

  @override
  String get settingsRatesAuto => 'Tự động';

  @override
  String get settingsRatesManual => 'Bạn đặt tay';

  @override
  String get settingsRatesUseAuto => 'Dùng tự động';

  @override
  String get settingsRatesAttribution => 'Tỷ giá từ Exchange Rate API';

  @override
  String get settingsRemindersSection => 'Nhắc nhở';

  @override
  String get settingsDefaultReminder => 'Mặc định nhắc trước';

  @override
  String get settingsReminderTime => 'Giờ nhắc';

  @override
  String get settingsPermission => 'Thông báo';

  @override
  String get settingsPermissionOn => 'Đã cho phép';

  @override
  String get settingsPermissionOff => 'Đang bị chặn trong cài đặt hệ thống';

  @override
  String get settingsPermissionAllow => 'Cho phép';

  @override
  String get settingsTestReminder => 'Gửi nhắc thử';

  @override
  String get settingsTestReminderHint => 'Một cái ngay và một cái sau 10 giây';

  @override
  String get settingsTestReminderSent => 'Đã gửi nhắc thử';

  @override
  String get settingsAppearanceSection => 'Giao diện & ngôn ngữ';

  @override
  String get settingsTheme => 'Giao diện';

  @override
  String get settingsFollowSystem => 'Theo hệ thống';

  @override
  String get settingsThemeLight => 'Sáng';

  @override
  String get settingsThemeDark => 'Tối';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsBackupSection => 'Sao lưu & khôi phục';

  @override
  String get settingsBackup => 'Sao lưu & khôi phục';

  @override
  String get settingsNeverBackedUp => 'Chưa sao lưu lần nào';

  @override
  String settingsLastBackup(String date) {
    return 'Lần sao lưu gần nhất: $date';
  }

  @override
  String get settingsBackupNudge =>
      'Đã lâu chưa sao lưu — hãy lưu một bản ở nơi an toàn.';

  @override
  String get settingsExportJson => 'Xuất bản sao lưu (JSON)';

  @override
  String get settingsExportCsv => 'Xuất bảng tính (CSV)';

  @override
  String get settingsRestore => 'Khôi phục từ file';

  @override
  String get settingsRestoreHint => 'Chọn file sao lưu Subnest (.json)';

  @override
  String get settingsRestoreInvalid =>
      'File này không phải bản sao lưu Subnest.';

  @override
  String settingsRestoreTitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Khôi phục $count subscription?',
    );
    return '$_temp0';
  }

  @override
  String get settingsRestoreBody =>
      'Thay thế sẽ xoá dữ liệu hiện tại trước. Gộp giữ dữ liệu hiện tại và thêm phần còn thiếu.';

  @override
  String get settingsRestoreReplace => 'Thay thế';

  @override
  String get settingsRestoreMerge => 'Gộp';

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
  String get settingsAboutSection => 'Giới thiệu';

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
