# [A001-subnest] UD Chi tiết + Xác nhận — 2026-11-11 (phiên con, điều phối #7)

Dựng lại S5 Chi tiết gói (044–064) và S6/S7 Xác nhận (065–070) theo mockup v14 (`design/system/bundle.js` › SCR.detail,
SCR.priceSheet, SCR.confirm, SCR.pending, SCR.celebrate). Commit `43a5d87` (WIP) + `225a070` trên `dev`.

## File
- `lib/features/subscription_detail/subscription_detail_screen.dart` — viết lại: hero (logo 80, tên, chip trạng thái
  Đang trả / Dùng thử / **Tạm dừng** / Đã huỷ / Chờ xác nhận + thẻ **Tự phát hiện**, giá + `CycleChip`, "Phần của bạn" / "≈");
  banner theo thứ tự mockup: chờ xác nhận · dùng thử ("Huỷ trước để tiết kiệm X/năm") · đã tạm dừng (Bật lại) · tạm dừng từ
  ngày tới (Hoàn tác) · đã huỷ (Khôi phục) · **Báo đổi giá** (Xem → sheet) · **Gói ngừng bán / ngừng bán cho khách mới / đổi
  tên** · **Được thêm tự động** (Gỡ); thẻ thông tin (Thanh toán tiếp theo, Chu kỳ = chip viền brand, Nhắc = các mốc
  "Đúng ngày, 3 ngày trước", Danh mục + icon theo danh mục, Nhãn = chip chấm màu, Phương thức, Bắt đầu từ, Tổng đã trả,
  Đáng tiền? có màu, Thư viện dịch vụ khi có ghi chú gói, Ghi chú); **Lịch sử giá**; Lịch sử thanh toán; Cách huỷ ·
  Tạm dừng / Bật lại · Đánh dấu đã huỷ / Khôi phục gói · Xoá.
- `detail_parts.dart` (mới) — `DetailInfoRow`, `SelectedCycleChip`, `DetailLabelChip`, `DetailSection`, `PriceHistoryList`
  (mới nhất trước; ↑ `warning-ink` "+", ↓ `success` "−", đọc "tăng/giảm X"; kỳ tương lai viền amber "Từ 22/11 · … · kỳ tới";
  dòng cuối "Bắt đầu với giá …"; đổi tiền tệ → không tính chênh), `PaymentHistoryRow` (kỳ chờ có nút Xác nhận; Payment tự
  xác nhận có "Từ ảnh chụp · Hoàn tác" → `undoAutoConfirm`; chữ ≥ 130% số tiền + nút xuống dưới).
- `detail_sheets.dart` (mới) — sheet Tạm dừng (059, mốc "Bây giờ → ngày" / "Từ ngày"), Bật lại (060, `AppDatePicker` mặc định
  hôm nay), Cập nhật giá? (055, Bạn đang trả → Giá mới + phần bạn khi chia sẻ, ghi chú Lịch sử giá, ghi chú *Giá tham khảo*),
  `askTwoWay` (Xoá 062, Gỡ 058), `InfoNote`, `SheetHead`.
- `cancel_flow.dart` / `celebrate_screen.dart` — 061/063: "Tuyệt — thêm X mỗi năm", nhắc huỷ cả trên <host>, thẻ Tổng tiết
  kiệm "từ N gói đã huỷ", **Xong** (về lại chỗ cũ) + **Hoàn tác** (khôi phục). Bỏ "Xem mục đã huỷ". Ẩn toast cũ trước khi mở
  (toast "Đã khôi phục…" từng đè lên nút Hoàn tác). Không còn import `home/widgets/overview_cards.dart`.
- `confirm_sheet.dart` — 065–067: tiêu đề = tên gói, chip "Đến hạn 8/11" / "Còn 1 kỳ sau", "Kỳ …" + chip chu kỳ, "Giá hiện tại ·
  sửa nếu số tiền thực trả khác"; sau Đã trả luôn hiện ✓ "Đã lưu thanh toán"; còn kỳ cũ → "Còn 1 kỳ chưa xác nhận — mở tiếp" +
  nút **Kỳ tiếp theo** (thay cho nhảy thẳng). Bỏ dòng "Xác nhận xong, ngày gia hạn…".
- `awaiting_screen.dart` — 068–070: chip chu kỳ dưới số tiền mỗi hàng; nút Xác nhận tất cả icon `check-check`.
- ARB: `subscription_detail_{en,vi}.arb` (viết lại, bỏ khoá không dùng), `confirm_{en,vi}.arb` (+`confirmDueOn`,
  `confirmChainMore`, `confirmNextPeriodButton`; bỏ `confirmQuestion/MovesNext/NextUp/SavedStep/SkippedStep`).
  Đã chạy merge_arb + gen-l10n **nhưng không commit** `app_*.arb` / `generated/` (điều phối gen + commit).
- Test: `test/features/subscription_detail/detail_harness.dart` (mới — `pumpDetail` = pumpApp + `overrides` + `priceChanges`),
  `subscription_detail_screen_test.dart` (viết lại: 044–063 + VI + 320×200% + a11y sáng/tối + ma trận 24 cấu hình với các
  trạng thái tạm dừng / tự phát hiện / báo đổi giá / ngừng bán + sheet), `confirm_test.dart` (cập nhật 065–070).

## API dùng (không sửa domain/data)
`subscriptionPriceHistoryProvider(id)`, `subscriptionPriceNoticeProvider(id)` + `priceNoticeActionsProvider.update/keepOldPrice`,
`subscriptionPlanNoteProvider(id)`, repo `pause/resume/restore/cancel/delete/undoAutoConfirm`. **Hoàn tác tạm dừng** (banner
"Tạm dừng từ …") = `repo.resume(id, pausedFrom)` → về Active với đúng Due date cũ (chưa có API "unpause" riêng — đủ dùng vì
pausedFrom = Due date lúc dừng). Gỡ tự phát hiện = `repo.delete` (đã tự ghi nhớ không thêm lại).

## Kiểm tra
- `flutter analyze`: sạch phần của tôi (toàn dự án còn 1 info ở `test/features/insights/tmp/dbg_test.dart` của phiên khác).
- `flutter test test/features/subscription_detail test/features/confirm`: **89 xanh** (gồm ma trận 360/390 × EN/VI × sáng/tối ×
  100/130/200% + 320×200%). `merge_arb --check` OK. Ảnh render thử 044/045/054/055/059/065 sáng + tối khớp mockup.
- **Đỏ không do phần của tôi:** `test/a11y/approx_spoken_test.dart` (/home, /insights — chữ ≈ trong thẻ Chi phí/Sắp tới của UH/UI),
  `test/a11y/semantics_tap_action_test.dart` (overview_cards.dart:113, upcoming_budget.dart:246, insights stats_parts.dart:273).
- **Đỏ do đổi chữ của tôi, file ngoài phạm vi (cần sửa):**
  - `test/app_flow_test.dart` dòng 102–116: "Gym cancelled" + "See cancelled" → nay "Nice — that’s … a year saved", thẻ
    "Total saving", nút "Done"/"Undo" (Done về lại Chi tiết). File đang có sửa chưa commit của phiên khác nên tôi không đụng.
  - `test/features/home/flows_test.dart:28`, `home_screen_test.dart:287` — "Did you pay Netflix?" → tiêu đề sheet nay là tên
    gói ("Netflix Premium"; dùng `find.descendant(of: find.byType(ConfirmSheet), …)` vì Tổng quan phía sau cũng có tên).
  - `flows_test.dart:72`, `home_screen_test.dart:291–309` — "… cancelled" / "See cancelled" như trên.

## Lệch / việc dở
- Tấm xác nhận: chip chu kỳ đặt cạnh "Kỳ …" (mockup đặt cạnh số tiền) vì `AmountField` (core) chưa có chỗ gắn đuôi — thêm
  tham số `trailing` vào `AmountField` nếu muốn đúng mockup. Chip được đọc kèm dòng kỳ (ExcludeSemantics) — một nút ngữ nghĩa
  riêng cho chip 12px làm kiểm tương phản lấy viền làm màu thứ hai.
- Sheet Tạm dừng: chưa vẽ đường nối 2px giữa hai mốc (mockup `.pause-tl::before`) — nhỏ.
- Font test (Be Vietnam Pro) không có glyph "→" nên ảnh render test thiếu mũi tên; máy thật dùng font dự phòng.
- Thẻ dùng thử ở Chi tiết theo mockup 047 chỉ còn banner (không còn nút Giữ lại/Cách huỷ trong banner; Cách huỷ ở cuối trang).
  `keptTrialsProvider` vẫn dùng ở Tổng quan.
- **Form sửa** đọc dịch vụ bằng `catalogRepositoryProvider.byId()` (`lib/features/subscription_form/subscription_form_screen.dart:104`)
  — ngoài phạm vi UD → giao **UF**: đổi sang `ref.read(catalogProvider.future)` rồi tìm theo id. Test "Edit mở form" của tôi không
  `settle` nữa vì form có thể còn quay spinner trong test.
- Lịch sử thanh toán hiện **mọi** kỳ (mockup cắt 5 dòng) — gói dùng lâu sẽ dài; cân nhắc "Xem tất cả" sau.
