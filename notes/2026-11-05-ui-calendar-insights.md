# [A001-subnest] UI Calendar & Insights — báo cáo phiên con I

> Phiên điều phối #2 · 2026-11-05 · Màn S8 Lịch + S9 Thống kê thay placeholder, đúng mockup png 41–47.

## Kết quả nhanh

- **S8 Lịch**: lưới tháng (tuần bắt đầu T2), tối đa 3 chấm màu dịch vụ + "+N" (đặc = đã trả, mờ 40% = sắp tới, viền = bỏ qua,
  chờ xác nhận = đặc), hôm nay đĩa `brand`, ngày chọn `brand-soft`, ngày có kỳ chờ có đồng hồ hổ phách; header tổng tháng
  (tháng quá khứ "Paid in October" = chỉ Payment; tháng này/tương lai "November total" = Payment + kỳ còn dự kiến, có "≈");
  chạm ngày → danh sách khoản (kỳ chờ có nút **Xác nhận** → `/confirm/:id`, chạm hàng → `/subscription/:id`);
  chế độ **Agenda** (Chờ xác nhận · Tuần này · Cuối tháng · tháng sau · Đầu tháng); toggle Month/Agenda tự rơi xuống dòng.
  FAB "+" → `/catalog`.
- **S9 Thống kê**: chọn khoảng (Tháng này · 12 tháng · Năm nay); thẻ Đã trả vs Dự kiến + % so kỳ trước; cột 12 tháng vẽ tay
  (brand đặc = đã trả, sọc brand trên brand-soft xếp chồng = dự kiến/chưa xác nhận), chạm cột → tooltip; câu giải thích tháng
  tăng vọt (gói năm); donut theo danh mục, màu `chartFor` cố định, legend đủ nhãn/số tiền/% — chạm lát hoặc dòng legend →
  sheet danh mục (png 47); Top 5 đắt nhất (chạm → chi tiết); thẻ Tiết kiệm; insight ≥ 2 dịch vụ Video/Nhạc; trạng thái rỗng.
- `flutter analyze` sạch · `flutter test` **363 xanh** (toàn bộ thư mục làm việc lúc 2026-11-05, gồm file của phiên khác) —
  phần của tôi: 23 unit test stats + 68 widget test (33 S8, 35 S9) + 4 test ảnh golden (bỏ qua mặc định).
- **Không** dùng điện thoại/adb. Kiểm bằng widget test + ảnh render từ test với font thật (Be Vietnam Pro + Lucide).
- **Không sửa** file có sẵn trong `lib/domain`, `lib/data`, `lib/core` — mọi tính toán mới nằm trong file mới `lib/domain/stats/`.

## Đã làm / file

| File | Nội dung |
|---|---|
| `lib/domain/stats/calendar_month.dart` | **MỚI** `CalendarMonth.build(...)`: entry theo ngày (dựa `CalendarBuilder.entries`), tổng tháng quy đổi Primary currency (quá khứ = Payment; còn lại = Payment + chờ + sắp tới — trùng `actualInMonth + projectedInMonth`), đếm paid/skipped/awaiting/upcoming, `approx`, `missingRates`, `amountOf(entry)`, `agenda(next:)` → `AgendaGroup` |
| `lib/domain/stats/insights_stats.dart` | **MỚI** `InsightsRange`, `RangeMonths`, `RangeTotals` (paid, expected, previousTotal, `changePercent`), `InsightsStats(calc)`: `monthsOf`, `totals`, `chart`, `categories(hasOwnSlot:)` (gộp danh mục không có slot vào Other, Other luôn cuối), `overlaps` (Video/Nhạc ≥ 2 Active), `peaks` (tháng ≥ 1,5× trung vị + gói chu kỳ dài gây ra), `cancelled` |
| `lib/features/calendar/calendar_screen.dart` | màn S8 (`CalendarScreen` giữ tên/constructor; thêm tham số tuỳ chọn `initialView`, `initialMonthOffset` cho test) |
| `lib/features/calendar/widgets/month_grid.dart` | `MonthGrid`, `EventMark`, ô ngày + Semantics ("Wed, 4 Nov, today, Netflix Premium (To confirm)") |
| `lib/features/calendar/widgets/entry_row.dart` | `CalendarEntryRow` (cột ngày cho Agenda, nút Xác nhận 40px trong vùng chạm 48px, tự chuyển bố cục gọn khi hẹp) |
| `lib/features/calendar/widgets/calendar_labels.dart` | tên tháng/thứ EN–VI ("November 2026" / "Tháng 11/2026", Mon…/T2…CN) |
| `lib/features/insights/insights_screen.dart` | màn S9 (`InsightsScreen` giữ tên; thêm `initialRange` tuỳ chọn) |
| `lib/features/insights/widgets/month_bar_chart.dart` | biểu đồ cột vẽ tay (CustomPainter) + `ChartSwatch` (đặc / sọc) |
| `lib/features/insights/widgets/category_donut.dart` | donut + legend chạm được (≥ 48dp), legend tự xuống dưới donut khi hẹp/chữ to |
| `lib/features/insights/widgets/category_sheet.dart` | sheet danh mục (png 47) dùng `SubscriptionRow` |
| `lib/features/insights/widgets/insights_cards.dart` | thẻ tổng, Top 5, Tiết kiệm, insight |
| `lib/features/insights/widgets/insights_format.dart` | số gọn trục/tâm donut ("1.07M"/"1,07tr"), nối tên "A, B and C"/"A, B và C", tên tháng, `niceTicks` |
| `lib/l10n/parts/calendar_{en,vi}.arb`, `insights_{en,vi}.arb` | viết lại toàn bộ chuỗi (bỏ key cũ của placeholder — không phiên nào khác dùng) + `app_*.arb`, `generated/` sinh lại |
| `test/domain/stats/sample_data.dart` | dữ liệu mẫu §8 của design (hôm nay 4/11/2026, VND, 1 USD = 25.400) dùng chung unit + widget test |
| `test/domain/stats/{calendar_month,insights_stats}_test.dart` | 23 unit test |
| `test/features/calendar/screen_harness.dart` | khung test màn tab: font thật, override provider (data, tỷ giá, `todayProvider` cố định), router ghi lại đường dẫn được `push`, ma trận bố cục, `shot()` |
| `test/features/calendar/calendar_screen_test.dart`, `test/features/insights/insights_screen_test.dart` | widget test từng trạng thái + ma trận không tràn + ảnh golden |

### Chạy lại ảnh
```bash
flutter test --update-goldens --dart-define=UI_SHOTS=true test/features/calendar/calendar_screen_test.dart test/features/insights/insights_screen_test.dart --plain-name golden
```
Ảnh render ghi vào `notes/img/2026-11-05-ui-calendar/render/` (khác nhau theo hệ điều hành nên test thường **không** so golden,
chỉ kiểm bố cục). Ảnh ghép so sánh `compare-*.png` tạo bằng PIL (mockup trái, render phải), đã nén 256 màu.

## Kiểm tra

- **Ma trận không tràn** (fail nếu có bất kỳ lỗi layout): 360/390 × EN/VI × sáng/tối × chữ 100/130/200% = 24 cấu hình × (S8: tháng
  này, Agenda, tháng trước · S9: 3 khoảng, rỗng, sheet danh mục), cuộn hết trang.
  Ma trận bắt được 2 lỗi thật đã sửa: badge "Chờ xác nhận" bị ép trong hàng hẹp (VI/360, 130–200%) → hàng tự chuyển bố cục gọn
  (số tiền + nút xuống dưới badge); tiêu đề sheet danh mục tràn 9px ở 360/200% → số tiền xuống dòng khi chiếm > 55% dòng.
- Ô lịch ≥ 48×48dp ở 360 (test), legend donut + hàng Top 5 ≥ 48dp (test), `iOSTapTargetGuideline` + `textContrastGuideline` qua.
- Semantics: ô ngày có nhãn đầy đủ; mỗi cột biểu đồ là nút có nhãn "Nov 2026 · ≈ ₫876,800 expected"; biểu đồ có nhãn tổng; dòng legend
  đọc "AI: ≈ ₫508,000 per month, 47%"; donut ẩn khỏi trình đọc (legend thay thế); tiêu đề tháng là live region.

### Ảnh (`notes/img/2026-11-05-ui-calendar/`)
| Ảnh | Nội dung |
|---|---|
| `compare-41-s8-calendar-{light,dark}.png` | S8 tháng này |
| `compare-42-s8-past-month-{light,dark}.png` | S8 tháng 10, chọn ngày 22 (kỳ bỏ qua) |
| `compare-43-s8-agenda-{light,dark}.png` | S8 Agenda |
| `compare-44/45-s9-insights(-more)-{light,dark}.png` | S9 đầu trang / cuộn xuống |
| `compare-46-s9-empty-…`, `compare-47-s9-category-…` | S9 rỗng / sheet danh mục |
| `render/vi-*.png` | tiếng Việt 390 (S8 tháng + Agenda, S9 cả trang) |
| `render/s8-{month,agenda}-360-{en,vi}-{light,dark}-{130,200}.png`, `render/s9-full-360-…` | 360dp, chữ 130% và 200%, cả trang |

## Chỗ lệch mockup và lý do

1. **Dấu "≈"** xuất hiện ở tổng tháng quá khứ, tổng S9, Top 5 (ChatGPT) khi có khoản USD: theo luật dev §3.5 "số đã quy đổi luôn
   approx". Mockup không vẽ ≈ ở các chỗ đó dù cùng dữ liệu USD. Số liệu khác mockup (vd 12 tháng = ≈ ₫12,040,000, mockup ₫11,166,000)
   vì là dữ liệu mẫu của test, không phải số vẽ tay.
2. **Không có dòng "+14% so với 12 tháng trước"** khi kỳ trước không có chi tiêu (dữ liệu mẫu không có lịch sử 2024–25). Có test cho
   "This month": "12% more than last month". So sánh dùng **tổng (đã trả + dự kiến)** của kỳ này với kỳ trước cùng độ dài — "Năm nay"
   = T1–T12 năm nay (tháng tương lai là dự kiến) so với cả năm ngoái; "Tháng này" so với tháng trước.
3. **Cỡ số tổng S9**: dùng token `headline` 28/34 (mockup class `display-sm` 30/36 không có trong tokens.json).
4. **Ô lịch ≥ 48dp (S-50)**: ở màn < 380dp, thẻ lưới lùi lề còn 6dp (360) thay vì 16 để mỗi ô đủ 48dp. Ở 390 giống mockup.
5. **Số ngày** lớn tối đa 160% (ô vẫn cao lên) để số 2 chữ số không dính nhau ở 200%.
6. **Dòng legend donut cao ≥ 48dp** (mockup ~44) → thẻ danh mục cao hơn mockup ~20px.
7. **Cột biểu đồ**: vùng chạm = 1/12 chiều rộng (~27dp) × cao 170dp — không thể đạt 48dp với 12 cột ở 360; đạt WCAG 2.5.8 (24px).
   Bù bằng Semantics từng cột. Cột đặt giữa ô 1/12 (cột đầu cách mép ~5px thay vì sát mép).
8. **Thứ tự hàng trong sheet danh mục**: đắt nhất trước (Google One rồi iCloud); mockup iCloud trước.
9. **Hàng kỳ chờ trong danh sách ngày** ở màn hẹp/chữ to: số tiền + nút Xác nhận chuyển xuống dưới badge (mockup chỉ vẽ 390/100%).
10. **Ghi chú chu kỳ trong sheet**: "Google One 2TB is billed ₫1,690,000/year — counted here as its monthly share." (câu chung cho mọi
    chu kỳ; mockup "renews yearly … shown here as its monthly share").
11. **Agenda**: mockup chỉ vẽ tháng hiện tại. Tôi thêm: kỳ đã xác nhận đầu tháng vào nhóm "Đầu tháng" (cuối danh sách); tháng
    quá khứ/tương lai = một nhóm theo tên tháng; nhóm "tháng sau" chỉ hiện dưới tháng hiện tại.
12. Status bar/home indicator của mockup không có trong ảnh render (test đặt inset trên 47dp, dưới 0).

## Hàm/truy vấn mới (đều trong file MỚI `lib/domain/stats/`, có unit test)

`CalendarMonth.build / agenda / amountOf / onDay / hasAwaiting` · `InsightsStats.monthsOf / totals / chart / categories / overlaps /
peaks / cancelled` · `RangeTotals.changePercent` · `RangeMonths.previous`. Dùng lại `CalendarBuilder`, `BillingRules`,
`SpendingCalculator` (actualInMonth, projectedInMonth, monthlySeries, monthlyCost, top) — **không cần sửa lõi**.
`lib/domain/domain.dart` chưa export `stats/` (file có sẵn, ngoài phạm vi) → import trực tiếp `domain/stats/...`.

## Việc dở / rủi ro

- Tỷ giá thiếu: S8 hiện dòng "Amounts in EUR aren't in the total — no exchange rate yet."; S9 bỏ qua lặng lẽ (giống `SpendingCalculator`).
- Chưa kiểm trên máy thật/TalkBack/VoiceOver (máy dùng chung; S-50 yêu cầu thử trước khi phát hành).
- Chưa có cử chỉ vuốt ngang để đổi tháng (chỉ mũi tên).
- File l10n sinh ra (`app_*.arb`, `generated/`) chứa key của các phiên khác đang làm (đúng theo docs/dev §4).

## Đề xuất cải tiến

**Cho phiên điều phối / core:**
1. **S-50 (48dp) vs design `tap-min` 44**: `AppIconButton`, `AppSegmentedControl`, `AppButton(small)` là 44/40 → test
   `androidTapTargetGuideline` (48) sẽ fail toàn app. Cần chốt: nâng core lên 48 hay ghi ngoại lệ trong STANDARDS.
2. **`StatusBadge` không xuống dòng/thu nhỏ** → tràn khi cột hẹp (VI, chữ to). Đề xuất core cho badge `Flexible` + `maxLines: 2`,
   hoặc các phiên UI dùng mẫu "hàng gọn" như `CalendarEntryRow`.
3. Đưa `lib/domain/domain.dart` export thêm `stats/calendar_month.dart`, `stats/insights_stats.dart`.
4. `SubscriptionRow` nên có tham số `leading` (cột ngày) để Agenda dùng thẳng thay vì hàng riêng.

**Cho xưởng:**
5. **Ma trận bố cục tự động** (`layoutMatrix` × cuộn hết trang × fail khi có lỗi layout) bắt lỗi tràn thật mà không cần máy — đưa
   `screen_harness.dart` (font thật + override provider + router ghi `push`) vào template test Flutter của xưởng.
6. **Ảnh golden opt-in** (`--dart-define=UI_SHOTS=true` + `--update-goldens`, ghi vào notes) thay cho chụp máy thật khi máy dùng chung;
   ghép so sánh mockup ↔ render bằng PIL rồi nén 256 màu (8,9 MB → 3,2 MB).
7. Khi nhiều phiên chạy `flutter test` cùng thư mục, `build/native_assets/windows/sqlite3.dll` bị khoá → test lỗi "failed to delete".
   Dùng vòng thử lại (chờ 15 s) hoặc mỗi phiên UI một worktree.
