# [A001-subnest] SW · Quét ảnh + Widget + Thông báo — 2026-11-11

Theo mockup v14 114–126, product.md §4.11–4.13, ADR 0003, APP.md "Quyết định 2026-11-10 (2)". Commit trên `dev`:
`1418166` (widget), `31f204f` (parser + chuỗi thông báo), `5c80b7c` (màn Quét).

## Quét ảnh 114–121 — `lib/features/scan/`
- `scan_parser.dart` (thuần Dart, 17 test): dòng chữ OCR → `DetectedCharge`. Neo theo số tiền (ký hiệu/mã/"đ"), tên từ cùng dòng
  hoặc dòng trên, ngày EN/VI/số (không nhầm "12.11" thành ngày), chu kỳ ("/month", "/năm", "every 3 months"…). Bỏ dòng thuế/tạm
  tính; thiếu tên hoặc ngày thì **bỏ**, không đoán. Ngày sắp tới hoặc sau "Renews/Gia hạn" = `isRenewal`.
- `scan_service.dart`: `ScanImageSource` (photo picker hệ thống / camera) + `ScanTextReader` (ML Kit Latin, gom block → hàng theo toạ độ),
  đều có provider để test thay.
- `scan_controller.dart`: intro → giải thích trước bộ chọn (một lần/lượt) → đọc → `applyDetections` → nhóm: Đã thêm · Đã xác nhận ·
  Cần bạn kiểm (khớp không chắc → "Đúng kỳ này" gọi `confirm` với số tiền thấy trên ảnh) · Số tiền khác (đã xác nhận nhưng khác giá thường) ·
  Không thêm (thấy 1 lần / tạm dừng-huỷ / đã gỡ trước đó / đã có). Hoàn tác từng dòng (`undoAutoAdd`/`undoAutoConfirm`) và Hoàn tác tất cả.
- `scan_screen.dart`: 114–121 (cả chụp hoá đơn bằng camera hệ thống thay cho màn camera 117 tự vẽ — dùng camera hệ thống, không thêm
  quyền CAMERA). **Xong → `homeAutoUndoProvider.notifier.show(report)`** với phần còn giữ (đóng bằng ✕/Back khi ở kết quả cũng gọi) —
  đã đóng việc dở APP.md "S phải gọi homeAutoUndoProvider". Test xác nhận Overview hiện SnackBar Hoàn tác.
- Test: `test/features/scan/scan_parser_test.dart`, `scan_screen_test.dart` (9 luồng + ma trận vi/tối/130%/200% 360dp).

## Widget 122–125
- Snapshot **v2** (`widget_snapshot.dart`, ghi trong class doc): tổng = **Month spend** tháng này (cùng số thẻ Chi phí Tổng quan) + "/mo",
  `paid/due/paidShare` từ `monthCashFlowProvider`, `cycle` chip mỗi giá, `dateShort`, `trialEnds`, `logo` (asset `assets/logos/png/<id>.png`)
  / `logoFile` (Custom logo trên máy), tối đa **6** dòng. Khoá: thêm `lockedLong`. Rỗng: "Chưa có gói" + chạm → `subnest://widget/add`
  → `/catalog` (`widget_link.dart`). Ghi ARB `widget_{en,vi}.arb` (bỏ mấy chuỗi cũ).
- **Android** (`SubnestWidgetProvider.kt` + layout/res): thẻ `brand-soft`/`on-brand-soft` như mockup; nhỏ = logo 32, "2 ngày"/"Ngày mai",
  tên, giá + chip chu kỳ, "12 Nov · còn 2 ngày" / "Hết dùng thử …"; chờ xác nhận = nền `warning-soft` + đồng hồ + "Chạm để xác nhận";
  vừa 3 dòng; lớn: tháng + tổng + chip "N chờ xác nhận" + Đã thanh toán/Còn phải thanh toán + thanh + 6 dòng; khoá: lock giữa thẻ,
  chữ dài ở vừa/lớn. **Logo thật**: đọc bitmap từ `flutter_assets/assets/logos/png/<id>.png` trong APK (hoặc file Custom logo), vẽ lên nền
  trắng bo 28% rồi `setImageViewBitmap`; không có → monogram. Không dùng `<Space>`/`<View>` (bẫy RemoteViews); `ProgressBar` ngang cho thanh.
- **iOS** (`ios/SubnestWidget/SubnestWidget.swift`, viết lại theo v2): cùng bố cục, thẻ nền `surface` (mockup 122/123). **Logo iOS**: thử đọc
  `Runner.app/Frameworks/App.framework/flutter_assets/assets/logos/png/<id>.png` từ extension (không cần App Group); nếu không đọc được →
  monogram. **Custom logo trên iOS chưa có** (cần App Group → chờ Apple Developer). **Chưa biên dịch Swift** (Windows):
  điều phối chạy workflow `iOS` (workflow_dispatch). Điểm dễ lỗi: `String(localized:)` iOS 16, `Image(uiImage:)`, `.overlay` trên `locked.hidden()`
  ở trạng thái `.missing`; nếu CI lỗi gửi log cho phiên SW.
- Test: `test/features/widget_sync` 18 test (v2: Month spend, cash flow, logo, trial, VI, link `add`, khoá chỉ 6 khoá, không chữ số/ký hiệu tiền).
- Chưa thử trên máy thật (không dùng adb theo brief) → điều phối: 3 widget Android sáng/tối, rỗng, chờ xác nhận, khoá; kiểm logo xuất hiện;
  `high_text_contrast` trên A13 vẫn ép màu chữ (đã biết).

## Thông báo 126
- Ba mẫu (nhắc / hết dùng thử / đến ngày) **khớp đúng §4.13** EN + VI; kênh giữ tên "Reminders"/"Nhắc nhở" (fact `doi-chu-hien-thi`).
- **Sao lưu lỗi ✅** (điều phối làm, `e986e92`): SW thêm chuỗi `notificationsBackupFailed` (EN+VI) trong `notifications_{en,vi}.arb`;
  điều phối thêm `NotificationService.showBackupFailed(settings)` (id 1003, kênh reminders, chỉ chữ, chạm mở /settings), gọi khi tự sao
  lưu `failed/permissionDenied/folderMissing` — trong app qua `AutoBackupService.onAutomaticFailure` (main.dart), nền Android trong
  `autoBackupBackgroundMain`. Mục 126 hoàn tất.

## Việc dở / ghi chú cho điều phối
- **Chưa có lối vào `/scan`** trong UI (không ai gọi `AppRoutes.scan`) — gắn ở Thêm (+)/Cài đặt (phiên UF/US hoặc điều phối); chỉ Pro
  (`isProProvider`, launch = Pro).
- `AutoBadge` (home/widgets/overview_v13.dart) tràn ở 200% khi hẹp — SW bọc `FittedBox` bên phía mình; nên sửa gốc ở UH.
- Parser dựa trên OCR thực: chưa thử ảnh thật Google Play/App Store trên máy (không có ML Kit trong test). Cần thử A13 với vài ảnh thật; chỉnh
  `ScanParser` (có test) nếu sai tên/ngày. Locale vi dùng ngày-trước-tháng cho ngày số; EN tháng-trước.
- iOS Info.plist đã có NSPhotoLibraryUsageDescription/NSCameraUsageDescription; Android photo picker không cần quyền.
- So khớp mockup chỉ bằng đọc `bundle.css/js` (không mở PNG, không chụp màn): kích thước/spacing theo token; cần mắt người so 114–126 sáng/tối.

## Kết quả
`flutter analyze`: No issues. `flutter test test/features/scan test/features/widget_sync test/a11y`: 59 qua. `merge_arb --check` OK.
`flutter build apk --debug` OK. (Không commit `app_*.arb`/`generated`.)
