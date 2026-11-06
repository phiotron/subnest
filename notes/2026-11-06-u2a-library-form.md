# [A001-subnest] U2a Thư viện + Form — mockup v13 (2026-11-06)

Phiên điều phối #4 · phiên con "U2a Thư viện + Form" · màn v13 22–37 (S3 Thư viện, S4 Form).
Phạm vi: `lib/features/catalog/**`, `lib/features/subscription_form/**`, `lib/l10n/parts/{catalog,subscription_form}_{en,vi}.arb`,
test của 2 feature. Không đụng domain/data/router/core/pubspec.

## Đã làm
**S3 Thư viện (22–25, 34–35)**
- Tab **Chung / Việt Nam** (`AppSegmentedControl`) chỉ hiện khi `showVietnamSectionProvider`; máy VN mở sẵn tab Việt Nam
  (giữ hành vi "giá địa phương trước"), máy khác không có tab. `CatalogView.forTab`: Chung = mục global, giá **US**;
  Việt Nam = mục `vn` + dịch vụ global có giá VN ở gói đang bán (Netflix, Spotify…), giá **VND**.
- Dòng thư viện: logo qua `logoDomain` (ServiceTile của P3, lỗi → monogram); meta "from $8.99/month · ≈ ₫228,346 · 3 plans"
  (≈ quy đổi sang tiền tệ chính khi khác tiền); chip **Reference price / Giá tham khảo** (`price.isReference`, widget
  `ReferencePriceChip` theo `.ref-chip`); TalkBack đọc tên + meta + "Giá tham khảo".
- Gói `closedToNew`/`discontinued` không bao giờ hiện (`CatalogView.plans` lọc `plan.isOnSale` → áp cho cả S1 onboarding).
- Plan sheet: phụ đề gói có "· Reference price" khi giá chưa xác minh. Ô tìm "Search 500+ services".
- Chọn dịch vụ → S4 điền giá **đúng vùng của tab** (Chung → USD + ≈, Việt Nam → VND) qua `libraryPickRegionProvider`
  (Notifier trong `catalog_helpers.dart`, form đọc một lần rồi xoá) — vì route `/subscription/new` không có tham số vùng.
**S4 Form (26–33, 36–37)**
- Danh mục = **Category của người dùng** (`categoriesProvider`, `l.categoryName`, lưu `categoryId`) — có danh mục tuỳ biến.
- Nhóm **Nhãn** (chọn nhiều, chip chấm màu, "+ Nhãn mới" → sheet → `organizeRepositoryProvider.addLabel`, trùng tên thì dùng nhãn cũ)
  + hàng **Phương thức thanh toán** → sheet (png 37): danh sách + số subscription đang dùng, "Không chọn", thêm nhanh
  (`addPaymentMethod`, trùng tên chuẩn hoá thì dùng cái cũ). Chọn từ danh sách đặt **cả** `paymentMethodId` + `paymentMethod`.
- **Nhắc trước** nhiều mốc: 4 chip bật/tắt riêng (Đúng ngày · 1 · 3 · 7 ngày, `ReminderOffsets.choices`), mặc định =
  `settings.defaultReminderOffsets`; không chọn mốc nào = tắt; ≥150% chữ → lưới 2×2. Lưu `reminderOffsets`.
- **Đáng tiền?** 4 ô (Chưa · Đáng · Phân vân · Không đáng) màu theo `.worth-o` (brand/warning/danger), lưu `worthIt`.
- **Thêm chi tiết** chỉ còn link huỷ + ghi chú (phương thức thanh toán chuyển lên nhóm Nhãn như mockup).
- Giá điền sẵn là giá tham khảo → chip "Giá tham khảo · Hãy đối chiếu với hoá đơn" dưới ô giá (mất khi sửa giá).
- Sửa: nút **Xoá subscription** cuối form (`dangerText`) → hộp xác nhận → `repo.delete` → về Tổng quan.
- UI chỉ dùng `categoryId`/`reminderOffsets` — không còn dùng shim `category`/`reminderDays` trong 2 feature này.

**File đã đổi:** `lib/features/catalog/{catalog_helpers,catalog_screen}.dart`, `widgets/{library_rows,plan_sheet}.dart`,
`lib/features/subscription_form/subscription_form_screen.dart`, **mới** `widgets/organize_parts.dart`
(`DotChip`, `WorthItPicker`, `showPaymentMethodSheet`, `showNewLabelSheet`), ARB catalog + subscription_form EN/VI
(+19 khoá, bỏ 3 khoá không dùng), `test/features/catalog/{add_harness,catalog_screen_test}.dart`,
`test/features/subscription_form/subscription_form_screen_test.dart`.

## Kiểm tra thế nào
- `flutter analyze` sạch; `dart run tool/merge_arb.dart --check` OK; `flutter test` toàn bộ — kết quả ở mục cuối.
- Test mới: CatalogView (gói ngừng bán ẩn, `forTab`, meta ≈ + cờ tham khảo); widget: tab Chung/VN + chọn từ Chung ra USD ≈ VND,
  không tab ngoài VN + chip Giá tham khảo; S4 nhắc nhiều mốc; S4 organize (danh mục tuỳ biến, nhãn + nhãn mới, sheet phương thức
  + thêm nhanh, Đáng tiền → lưu đủ `categoryId/labelIds/paymentMethodId/paymentMethod/worthIt`); S4 xoá.
- Ma trận bố cục mới `layoutMatrixNarrow` = EN/VI × sáng/tối × 360/390 × 100/130/200% **+ 320dp × 200%** (EN/VI × sáng/tối);
  S3 thêm tab Chung cuộn sâu (chip tham khảo), S4 thêm sheet nhãn mới, sheet phương thức, nhóm Đáng tiền, cuối màn sửa.
- Ảnh render (tuỳ chọn): `flutter test test/features/catalog test/features/subscription_form --dart-define=ADD_SHOTS=true`
  → `notes/img/2026-11-05-ui-add/render/` (tên mới: `s3-general-*`, `s3-vietnam-*`, `s3-reference-*`, `s4-organize-*`,
  `s4-method-sheet-*`). Phiên này **không** mở PNG mockup (đủ thông tin từ `bundle.js`/`bundle.css`) để tiết kiệm token.

**Kết quả cuối (2026-11-06):** analyze sạch · merge_arb --check OK · `flutter test` toàn bộ **780 xanh, 97 bỏ qua, 2 đỏ** —
2 đỏ là `test/a11y/approx_spoken_test.dart` en/vi `/home`: thẻ "Sắp trừ tuần này" của **U1** (`features/home/`) có nhãn
TalkBack chứa "≈" (cần `l10n.spoken`), không thuộc phạm vi U2a — đã báo U1. Catalog 44/44, Form 41/41 xanh
(gồm ma trận 320dp × 200%). Dòng thư viện của U2a đã đọc "≈" thành chữ (có test).

## Việc dở / rủi ro
- Sheet phương thức chưa có icon từng dòng (mockup: thẻ/ví) — `RadioOption` của core không có leading; thêm khi gom component.
- `libraryPickRegionProvider` là cách tạm; gọn hơn: router nhận `?region=` cho `/subscription/new` (phiên điều phối/router).
- Máy VN mở mặc định tab **Việt Nam** (mockup 34 vẽ tab Chung đang chọn) — chọn vậy để người VN thấy giá VND trước; đổi 1 dòng
  (`_tab ??= LibraryTab.vietnam`) nếu muốn mặc định Chung.
- Tìm kiếm chỉ trong tab đang chọn (tab vẫn hiện khi tìm).
- **Nên gom lên `core/widgets`:** `ReferencePriceChip` (S5 banner giá, S10 Giới thiệu), `DotChip` (bộ lọc S2, S5, S10 Nhãn),
  `WorthItPicker` (S5), sheet phương thức thanh toán (S5 "Sửa thanh toán" png 50), `AppChip` có leading tuỳ ý.
- Shim `SubscriptionDraft.category/reminderDays` không còn được 2 feature này dùng → có thể gỡ khi U2b/U4 xong.

## Đề xuất cải tiến xưởng
- Phiên song song dùng chung thư mục: file l10n sinh ra (`app_*.arb`, `generated/`) bị phiên khác commit kèm khoá của mình trước
  khi part ARB của mình được commit → `merge_arb --check` đỏ ở commit đó. Đề xuất: file sinh ra không commit (sinh trong CI/build)
  hoặc luật "chỉ commit part ARB của mình + chạy lại merge, không commit file sinh ra nếu có khoá lạ".
- Test widget dùng drift: tránh `stream.first` trong `testWidgets` (treo 10 phút tới timeout) — đọc bằng `select().get()`; nên
  ghi vào template test Flutter.
