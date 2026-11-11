# [A001-subnest] US Cài đặt + PIN 002–004, 087–113 — 2026-11-11 (phiên con, điều phối #7)

Dựng lại theo mockup v14 (`design/system/bundle.js` `SCR.pin/settings/autoBackup/backupNow/restore/rates/reminders/organize/automation`
+ `bundle.css`). Logic giữ nguyên (backup, PIN, erase: `eraseEverything` còn đủ mọi bước S/L/P2). Chỉ đổi giao diện + chữ.
Commit: `213fbd6` (Cài đặt/PIN), `19a0e70` (hoàn nguyên format 3 file không đổi), `2a871d9` (Sắp xếp gói), `f03ed65` (test + sửa tràn), commit cuối (notes).

## Màn ↔ code
| PNG | Code |
|---|---|
| 002–004 Khoá PIN (logo, 4 chấm brand/đỏ, phím tròn 76, "Quên mã?" → hộp thoại Xoá toàn bộ / Thử lại) | `lock/pin_pad.dart` `PinPad`, `lock/lock_screen.dart` |
| 104–105 đặt PIN (chọn / nhập lại / lệch → đặt lại) | `lock/pin_screens.dart` `PinSetupScreen`; **mới** `PinActions.change` (Đổi mã PIN: PIN cũ → PIN mới 2 lần) |
| 087–089 Cài đặt (Tiền · Nhắc · Giao diện & ngôn ngữ (+Ẩn thanh tab) · Sắp xếp gói · Tự động PRO · Dữ liệu · Bảo mật · Giới thiệu + dòng riêng tư) | `settings/settings_screen.dart`, `widgets/settings_bits.dart` (`ProBadge`, `SoonChip`, `ProSectionHeader`, `KeyValueGrid`, `FileChip`, `BottomActionBar`) |
| 088/091 thẻ Sao lưu tự động (bật: Thư mục/Giờ/Mật khẩu/Giữ; tắt: "Tắt — dữ liệu chỉ nằm trên máy") | `settings/auto_backup_section.dart` |
| 089 Giới thiệu nội tuyến (thư viện cập nhật N ngày trước = `catalogUpdatedOnProvider`, số dịch vụ, bảng giá, 5 chip liên kết, dòng nhãn hiệu; không còn dấu vết Logo.dev) | `settings/about_card.dart` |
| 090 PIN bật (+ hàng Đổi mã PIN) · Che nội dung | `settings/security_section.dart` |
| 092 sheet Ngôn ngữ · 093 sheet Giao diện | `settings/appearance_sheet.dart` `LanguageSheet`, `ThemeSheet` |
| 094 Tỷ giá ("✎ Đặt bởi bạn" màu success) | `settings/rates_screen.dart` |
| 095–096 Nhắc nhở (4 chip chọn nhiều mốc: `defaultReminderOffsets`) | `settings/reminders_screen.dart` |
| 097 Sao lưu tự động: thiết lập (thư mục, giờ, mật khẩu ×2, cảnh báo ghi lại) / đang bật (đổi thư mục, giờ, Sao lưu ngay) | `settings/auto_backup_screen.dart` |
| 098 Sao lưu ngay (sheet: tên file, "12 gói · 148 thanh toán · 41 KB", đặt mật khẩu) | `settings/backup_password_dialogs.dart` `BackupNowSheet`, `PasswordInput` |
| 099–101 Khôi phục (kiểm file → màn Khôi phục; có mật khẩu → ô mật khẩu "Sai mật khẩu" tại chỗ; Tiếp tục → "Thay thế toàn bộ dữ liệu?") | `settings/restore_screen.dart`, `backup_actions.dart` `restore` |
| 102–103 Xoá toàn bộ (Tiếp tục → gõ XOA/ERASE, nút Xoá tất cả chỉ bật khi đúng chữ, không phân biệt hoa/thường) | `backup_actions.dart` `deleteAll`, `EraseConfirmDialog` |
| 106–108 Danh mục (kéo sắp xếp, sheet sửa: tên + màu 12 + biểu tượng 16, Xoá → chuyển gói sang danh mục khác) | `settings/manage/manage_screens.dart`, `manage_sheets.dart`, `manage_widgets.dart` |
| 109 Nhãn · 110 Phương thức thanh toán (sheet thêm/sửa/xoá) · 111 Ngân sách (tổng + từng danh mục, thanh dùng, sheet đặt/bỏ) | như trên |
| 112–113 Tự động (Pro) + Đăng ký sớm (không giá) | `settings/automation_screen.dart` |

## Lệch có chủ ý / quyết định tự đưa ra (điều phối chưa trả lời)
- **2 công tắc "Tự thêm gói mới / Tự xác nhận kỳ" (112):** `lib/data` chưa có cài đặt lưu chúng → hiện **bật, chỉ đọc** (đúng hành vi Quét ảnh hiện tại: luôn
  `applyDetections` + Hoàn tác). Nếu cần chỉnh được: thêm 2 trường vào `AppSettings` + setter rồi nối `AppToggle.onChanged` trong `automation_screen.dart`.
- **"Đăng ký dùng sớm":** mở email tới `kSupportEmail` với tiêu đề "Subnest Pro early access" (`SettingsActions.joinEarlyAccess`), không lưu/không thu gì.
- Sao lưu: bỏ tên cũ "Export backup" → "Sao lưu ngay"; hộp thoại xuất cũ thay bằng sheet 098. Khôi phục không còn hộp thoại "Restore this backup?" (thay bằng màn + hộp 101).
- Đổi mã PIN (090) không có trong mockup ngoài hàng; tôi làm theo A002 (nhập PIN cũ rồi PIN mới). Có toast "Đã đổi mã PIN".
- Xoá toàn bộ: bước 1 nút **Tiếp tục** (không còn "Xoá"/"Không thể hoàn tác" làm bước 2 — bước 2 là gõ XOA). Toast sau khi xong: "Đã xoá toàn bộ dữ liệu".
- Quên mã (004): hộp thoại cũ giữ, nút huỷ đổi thành **Thử lại**; vẫn Xoá toàn bộ (+ 2 bước) → onboarding.
- `AppRoutes` không có đường dẫn cho Tự động / Sao lưu tự động / Khôi phục — mở bằng `Navigator.push` (như `RemindersScreen`). Nếu cần deep link: điều phối thêm route.
- Hàng "Đổi mã PIN", "Ẩn thanh tab khi cuộn" dùng `AppToggle` thật; thẻ sao lưu tự động: chạm thẻ (khi bật) mở màn 097-chế độ-đang-bật; công tắc bật → màn thiết lập, tắt → tắt ngay (như cũ).
- Giờ thử máy: `showTimePicker` vẫn `dialOnly` (màn thiết lập + đổi giờ).
- Font test thiếu glyph "→"/"✎" không dùng: mũi tên là biểu tượng, bút chì là `LucideIcons.pencil`.

## Kiểm tra
- `flutter analyze lib test/features/settings test/features/lock test/a11y`: sạch cho phạm vi mình (lúc làm `subscription_form` của UF có lỗi tạm do chuỗi chưa gen — sau khi gen lại thì sạch).
- `flutter test test/features/settings test/features/lock test/a11y`: **481 qua** — gồm ma trận 360/390 × EN/VI × sáng/tối × 100/130/200% + 320 × 200% EN/VI cho **mọi** cảnh 002–004, 087–113 (+ biến thể: sao lưu bật / lỗi thư mục, rates offline, PIN lệch…).
  `test/app_flow_test.dart` vẫn xanh. `dart run tool/merge_arb.dart --check` OK.
- Sửa test: `security_settings_test`, `settings_screens_test`, `settings_harness` (route cho màn mới), `settings_shots_test` (cảnh theo số màn v14, ảnh ra `notes/img/2026-11-11-us-settings-pin/`, **không commit**), `lock_app_test` (Quên mã → Thử lại; Xoá toàn bộ → Tiếp tục → gõ ERASE).
- So ảnh render (light EN 390) với PNG mockup: 003 và 088b khớp bố cục; các màn còn lại kiểm bằng số đo CSS + test không tràn. **Chưa thử máy thật** (không dùng adb theo brief).

## Bẫy gặp
- `SliverFillRemaining(hasScrollBody: false)` ép chiều cao chặt = intrinsic; câu lỗi PIN xuống dòng ở 200% làm Column tràn 19px. Thay bằng `LayoutBuilder` + `SingleChildScrollView` + `ConstrainedBox(minHeight)`.
- `Semantics(excludeSemantics: true)` bao tap phải có `onTap:` (test `semantics_tap_action_test` quét `lib/`).
- `flutter test` tranh khoá `build/native_assets/windows/sqlite3.dll` với phiên khác — chờ rồi chạy lại (vòng `sleep 30`).
- Sửa chuỗi hàng loạt dùng script Python ghi ra file (`arb_patch.py`, giữ 1 mục/dòng) — heredoc Git Bash hỏng dấu tiếng Việt/`'`.
- `dart format` chạy trên cả thư mục feature đã đổi 3 file không thuộc phiên (đã hoàn nguyên) → chỉ format đúng file mình sửa.

## Việc dở / đề xuất
- Điều phối: trả lời 2 câu hỏi (công tắc Tự động, "Đăng ký dùng sớm") — nếu khác đề xuất thì báo lại.
- Chưa có `test` riêng cho sheet Danh mục/Nhãn/Phương thức/Ngân sách (chỉ test bố cục); thêm test luồng (thêm, sửa, xoá → chuyển gói, đặt ngân sách) nếu còn ngân sách.
- ARB `settings_*`: các chuỗi cũ không còn dùng (vd `settingsExportJson*`, `settingsBackup*` đời cũ) chưa xoá — dọn khi gỡ shim.
- Màn Tỷ giá: sheet ghi đè (`rate_override_sheet.dart`) chưa chỉnh theo v14 (mockup không vẽ riêng).
