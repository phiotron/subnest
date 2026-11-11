# [A001-subnest] UI Thống kê + Lịch — 2026-11-11 (phiên điều phối #7, đợt 2a)

Phạm vi: Lịch (S8) 071–073, Thống kê (S9) 074–086 theo mockup v14 (`954ef01`).

## Commit (nhánh `dev`, chưa push)
- `fe47654` Lịch 071–073 + bộ dữ liệu product.md §6 cho test.
- `010f86b` Thống kê 074–086, xoá biểu đồ cũ; sửa 1 dòng `test/app_flow_test.dart` (đã báo điều phối, phương án A).
- KHÔNG commit `lib/l10n/app_*.arb`, `lib/l10n/generated/` → điều phối chạy `dart run tool/merge_arb.dart` + `flutter gen-l10n`.

## Đã làm
### Lịch (`lib/features/calendar/`)
- Header "November:" / "Tháng 11:" + **≈ tiền trừ thật của tháng** = `monthCashFlowProvider` (Đã + Còn phải thanh toán;
  Nov = $116.57) + "2 paid · 5 to come" (tháng qua: "7 paid", + "n skipped").
- Ô ngày: **logo mini 13px** (`MiniLogo`, dùng `ServiceTile` thật): đủ = đã trả, mờ = dự kiến, viền amber = chờ xác
  nhận, khung rỗng = bỏ qua; tối đa 3 + "+N". Chú thích: Paid · Expected · (Skipped nếu có) · To confirm.
- Hàng ngày: giá + `CycleChip` (bỏ nút Confirm cũ — mockup chạm hàng mở chi tiết).
- Toggle "Month | List"; List bỏ nhóm "Earlier" (dòng thời gian cái còn tới: Chờ xác nhận · Tuần này · Cuối tháng · tháng sau).
- VI: "Tháng 11, 2026" (đổi từ "Tháng 11/2026"), "Lần trừ đầu sau dùng thử".
### Thống kê (`lib/features/insights/`)
- `insights_screen.dart`: Tháng | Năm (state cục bộ) + `‹ November 2026 ›` = `selectedStatsMonthProvider` (‹ › ở chế độ
  Năm nhảy ±12 tháng); tag "Projected" cho kỳ sau tháng này. Mọi thẻ theo kỳ chọn.
- `widgets/insights_cost_card.dart` — thẻ chi phí (`monthSpendProvider`/`yearSpendProvider`, chip chênh — ẩn khi kỳ
  trước = 0, ≈/ngày hoặc ≈/tháng ở chế độ Năm, (i) → `showStatsInfoSheet`), `CashBlock` Đã/Còn (tháng quá khứ: Đã/Không
  trả = kỳ Skipped + kỳ còn chờ); chế độ Năm cộng 12 `monthCashFlowProvider`.
- `widgets/month_bars.dart` — 12 cột Jan–Dec của năm chọn (`monthSpendSeriesProvider`), cột chọn `brand`, tháng tới
  sọc; chạm cột = chọn tháng (từ chế độ Năm thì về Tháng). Nhãn TalkBack "November 2026: approximately $144.89[, projected]".
- `widgets/category_donut.dart` — donut theo `byCategoryIdMinor`, màu theo danh mục (README v2: AI chart-1, Lưu trữ
  chart-2, Sức khoẻ chart-3, Phần mềm chart-4, Video chart-5, Nhạc tile-violet, Viễn thông tile-sky; danh mục tự tạo =
  màu người dùng chọn) — hàm `statsCategoryColor` trong feature (không đổi `chartFor` của core).
- `widgets/insights_cards.dart` — Đắt nhất (top 5 `lines`), Tăng giá (`priceIncreasesProvider`), 12 tháng tới
  (`yearForecastProvider`, `historyCoversPast == false` → câu "chỉ tương đối"), Sắp tới 13 tuần | 12 tháng, Ngân sách
  theo danh mục (Month spend của kỳ vs ngân sách quy Tiền tệ chính, ×12 ở chế độ Năm), Tiết kiệm + "Không đáng", gợi ý trùng.
- `category_month_screen.dart` (083), `forecast_list_screen.dart` (084) — mở bằng `Navigator.push` (không sửa router).
- Xoá: `month_bar_chart.dart`, `category_sheet.dart`, test ticks cũ. Chuỗi ARB cũ không dùng đã xoá.

## Kiểm tra
- `flutter analyze` toàn project: sạch. `merge_arb --check`: OK.
- `flutter test test/features/insights test/features/calendar test/a11y test/app_flow_test.dart`: **95 xanh** (4 skip = golden).
- Dữ liệu product.md §6: `test/features/insights/product_sample.dart` (USD, hôm nay 10/11/2026) — `product_numbers_test`
  khớp Nov **$144.89** (10 gói), −$4.00 so thg 10, ≈ $4.83/ngày, Đã **$41.99**, Còn **$74.58**, tăng giá +$3.50.
  Harness (`test/features/calendar/screen_harness.dart`) mặc định dùng bộ này; override thêm priceChanges/budgets/categories,
  `UniqueKey` cho ProviderScope mỗi lần pump.
- Ma trận bố cục 360/390 × EN/VI × sáng/tối × 100/130/200% **+ 320 × 200%** cho 071–073 và 074/080/081/083/084/085: không tràn.
- Ảnh render (golden, chỉ cục bộ, không commit — 7 MB): `notes/img/2026-11-11-ui-insights-calendar/` — chạy lại:
  `flutter test --update-goldens --dart-define=UI_SHOTS=true test/features/insights/insights_screen_test.dart test/features/calendar/calendar_screen_test.dart --plain-name golden`.

## Việc dở / lưu ý
- Số "12 tháng tới" trong test (≈ $1,638.83 vs $1,388.22) khác mockup ($1,618.83 vs $1,544.22) vì lịch sử Payment mẫu
  tôi dựng ngắn hơn — luật tính là của M; không ảnh hưởng UI.
- Domain còn code chỉ test dùng: `InsightsRange`, `InsightsStats.totals/chart/peaks/categories` (`lib/domain/stats/insights_stats.dart`)
  — Thống kê mới chỉ dùng `InsightsStats.overlaps`. Phiên domain sau có thể dọn.
- `HatchPainter` trùng ý với `features/home/widgets/cost_card.dart` (UH) → nên gom lên `core/widgets` khi rảnh.
- Cột 12 tháng/Sắp tới < 48dp (12–13 cột trên 296dp) — chỉ là lối tắt; ‹ › vẫn là đường chính (đạt S-50 qua nút mũi tên).
- Ở 320dp × 200%: tên danh mục/nhãn tuần rút gọn (J F M…, nhãn tuần cách một), số tiền xuống dòng dưới tên — không cắt số.

## Đề xuất cải tiến xưởng
- Bộ dữ liệu product.md §6 nên ở chỗ chung (`test/fixtures/product_sample.dart`) cho mọi phiên UI — hiện mỗi phiên tự dựng.
- `Semantics(label…, excludeSemantics: true)` không có `container: true` bị gộp vào node cha → `find.bySemanticsLabel` hụt.
  Nên ghi vào memory fact UI.
