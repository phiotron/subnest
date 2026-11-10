# [A001-subnest] M Lõi số liệu — 2026-11-10 (phiên điều phối #7)

Phạm vi: domain + DB + provider + test cho Month spend, Month cash flow, Daily average, Price history,
Price increase, Forecast 12 tháng; sửa lỗi Tạm dừng. **Không có UI** (chờ mockup v14).

## Commit
- `812c6a7` DB v3: `price_changes` + backfill, cột `custom_logo_file`, `statusForTotals` (lỗi Tạm dừng).
- (commit thứ hai) domain số liệu tháng / tăng giá / dự đoán, provider, backup + CSV, test, notes này.

## DB v3 (migration)
- Bảng `price_changes`: `id, subscription_id (FK cascade), old_price_minor, new_price_minor, currency,
  old_currency (NULL = cùng currency), effective_from (YYYY-MM-DD), source (manual|catalog|backfill), created_at`.
  Giá lưu là **giá gói** (cả gói, không phải My share).
- Cột `subscriptions.custom_logo_file TEXT NULL` (cho phiên L) ↔ `Subscription.customLogoFile`. *Phiên L hiện lưu ảnh
  theo subscriptionId (`BackupLogos`), chưa dùng cột này — dùng hay bỏ là việc của L/điều phối.*
- Migration chuyển sang **stepByStep** (`app_database.steps.dart`, shape `Schema2`/`Schema3`): bước dựng lại bảng
  1→2 dùng shape v2 nên **không còn bẫy `newColumns`** khi thêm cột về sau. Bước dữ liệu (backfill) chạy sau mọi bước,
  với `from < 3 && to >= 3`. Phiên sau thêm v4: `schemaVersion = 4` → `dart run build_runner build` →
  `dart run drift_dev make-migrations` → thêm `from3To4` vào `stepByStep(...)`.
- Test: `test/drift/app/migration_test.dart` (v1→v3, v2→v3 giữ dữ liệu + backfill; test cũ v1→v2 nay migrate tới latest
  vì đọc qua repository hiện tại).

## Luật backfill lịch sử giá (`PriceHistory.backfill`, chạy khi migrate và khi khôi phục file không có `priceChanges`)
1. Chỉ Payment **người dùng xác nhận** (`source == null`); số tiền tự phát hiện = tiền ngân hàng trừ (FX, phí) → bỏ.
2. Chỉ Payment cùng tiền tệ hiện tại của gói (khác tiền tệ = nhiễu tỷ giá).
3. Xếp theo Due date, gom thành **chuỗi cùng số tiền**; chuỗi chỉ 1 kỳ = kỳ lẻ (giảm giá, pro-rata, gõ nhầm) → bỏ,
   trừ chuỗi cuối bằng đúng My share hiện tại.
4. Mỗi lần đổi giữa hai chuỗi giữ lại = 1 thay đổi, hiệu lực từ Due date của Payment đầu chuỗi mới.
5. Chuỗi cuối khác My share hiện tại (đã sửa giá mà không ghi) → thêm 1 thay đổi tới giá hiện tại, hiệu lực từ Payment
   kế sau chuỗi đó, không có thì Due date hiện tại.
6. Số tiền là My share → giá gói = số tiền × sharedWith (số tiền bằng My share hiện tại → đúng giá hiện tại).
Gói đã có lịch sử thì không backfill lại.

## Ghi lịch sử giá
- `SubscriptionRepository.save(s, {priceSource = manual, priceEffectiveFrom})` **tự ghi** khi giá/tiền tệ của gói đã có đổi.
  Hiệu lực mặc định = Due date kế tiếp của gói (khớp hộp thoại form "dùng giá mới từ kỳ tới"); gói không có lịch
  (Huỷ/Tạm dừng) = hôm nay. Sửa lại cùng ngày, cùng nguồn → cập nhật dòng cũ; về đúng giá ban đầu → xoá dòng.
  ⇒ **Form không cần sửa** (`_confirmPrice` "Giữ giá cũ" trả giá về như cũ → không ghi gì).
- Cho **P2** (Báo đổi giá → Cập nhật): `repo.changePrice(id, newPriceMinor, {currency, source: PriceChangeSource.catalog,
  effectiveFrom})` hoặc `repo.save(s, priceSource: PriceChangeSource.catalog)`.
- Đọc: `watchPriceChanges({subscriptionId})`, `allPriceChanges({subscriptionId})` (cũ → mới); `insertPriceChange`,
  `backfillPriceHistory()`.
- Backup: khoá top-level tuỳ chọn `priceChanges` (không tăng version; file cũ không có → backfill khi khôi phục; kiểm
  hợp lệ trong `parse`). CSV: file thứ 3 `subnest-price-history-<ngày>.csv` **chỉ khi có lịch sử**.

## Lỗi Tạm dừng (APP.md "Việc dở đợt 2") — đã sửa
`BillingRules.statusForTotals(s, today)`: gói `paused` mà `pausedFrom` sau hôm nay tính như trước khi dừng (Active, hoặc
Trial nếu còn dùng thử). Dùng trong `SpendingCalculator.summary/byCategory/top`, ngân sách, `InsightsStats.categories/
overlaps`, `notWorthSavingsYearly`. Không đổi `effectiveStatus` (nhãn hàng gói vẫn "Tạm dừng từ …" như U1 làm). Repo
`pause()` giữ nguyên (đặt paused + pausedFrom = Due date hiện tại; kỳ đó không bị trừ).

## API cho UI (`lib/data/providers.dart`, mục "#7") — mọi provider `null` khi đang tải
| Provider | Kiểu | Dùng cho |
|---|---|---|
| `selectedStatsMonthProvider` (+ `.notifier.select(m)/previous()/next()`) | `LocalDate` ngày 1 | `‹ Tháng 11/2026 ›`, chạm cột, Home → Thống kê đúng tháng |
| `monthSpendProvider(month)` | `MonthSpend?` | `totalMinor`, `dailyAverageMinor`, `changeMinor` (so tháng trước, tiền), `count`, `lines` (đắt nhất trước), `byCategoryIdMinor`, `missingRates` |
| `monthSpendSeriesProvider((lastMonth, n))` | `List<MonthSpend>?` | 6 cột Tổng quan / cột Thống kê |
| `yearSpendProvider(year)` | `YearSpend?` | tab Năm: `months` (12), `totalMinor`, `changeMinor`, `lines`, `byCategoryIdMinor`, `count`, `dailyAverageMinor` |
| `monthCashFlowProvider(month)` | `MonthCashFlow?` | Đã thanh toán `paidMinor` (+`paid`), Còn phải thanh toán `remainingMinor` (+`remaining`, `awaitingMinor`), `paidShare` cho thanh |
| `priceIncreasesProvider` | `PriceIncreaseReport?` | thẻ Tăng giá: `items` (cũ → mới, `monthlyDeltaMinor`, `yearlyDeltaMinor`, `changedOn`), `monthlyDeltaMinor`/`yearlyDeltaMinor` tổng, `biggest` |
| `recentlyIncreasedIdsProvider` | `Set<String>` | ↑ ở hàng gói (tăng trong 90 ngày) |
| `subscriptionPriceHistoryProvider(id)` | `AsyncValue<List<PriceChange>>` **mới nhất trước** | Chi tiết: cả tăng/giảm, `source` (Bạn sửa / Thư viện / Từ các kỳ đã trả) |
| `yearForecastProvider` | `YearForecast?` | 12 tháng tới `nextMinor` vs qua `pastMinor`, `changeMinor` = `newSubscriptionsMinor` + `priceIncreasesMinor` + `otherMinor`; `top`, `contributors`; `weeks` (13) / `months` (12) `ForecastBucket` + `items` (danh sách); `historyCoversPast` (false → đừng nói "so với 12 tháng qua" mạnh tay) |
| `priceHistoryProvider` / `monthStatsCalculatorProvider` / `priceIncreaseCalculatorProvider` | | tính trực tiếp nếu cần |
Số tiền đều là minor units của Tiền tệ chính (`primaryCurrencyProvider`); hiển thị bằng `Money(minor, currency)`.

## Luật tính (đã chốt, code ở `lib/domain/stats/month_stats.dart`)
- Đang trả trong M: `paidFrom` (= hết dùng thử nếu có, không thì startDate) ≤ ngày cuối M; Huỷ: tính tới hết tháng có ngày
  huỷ; Tạm dừng: 0 cho tháng bắt đầu từ/sau `pausedFrom`, tháng có ngày dừng vẫn tính; dừng/huỷ trước khi từng trả = 0.
- Giá trong M = giá có hiệu lực **ngày cuối tháng** M (Price history) → My share → Monthly cost, quy đổi + làm tròn mỗi dòng.
- Cash flow: Paid = Payment có Due date trong M; Remaining = `ForecastCalculator.items(subs, đầu M, cuối M)` (kỳ chờ
  xác nhận + sắp tới, giá theo lịch sử, gói năm đủ giá). `ForecastCalculator` nay nhận `history` (provider đã truyền).
- Tăng giá: gói Active/Trial (theo `statusForTotals`); giá hiện tại vs giá tại `max(hôm nay − 12 tháng, startDate)`; so bằng
  Monthly cost quy đổi tỷ giá hôm nay; chỉ liệt kê tăng. ↑: thay đổi tăng có `noticedOn` (backfill = ngày hiệu lực; còn lại
  = min(ngày tạo, ngày hiệu lực)) trong 90 ngày.
- Dự đoán: tới = kỳ chờ xác nhận + Due date tới hôm nay + 12 tháng; qua = Payment có Due date trong (hôm nay − 12 tháng,
  hôm nay]. Gói "mới" = `paidFrom` trong 12 tháng qua → cả chênh vào *gói thêm*; gói cũ: *tăng giá* = Σ kỳ tới × (giá
  kỳ − giá 12 tháng trước), ≥ 0; phần còn lại = *khác* (lịch gia hạn năm, huỷ, dừng, giảm giá…).

## Kiểm tra
- `flutter analyze` (lib/domain, lib/data, test của tôi): sạch. Test domain: 179 xanh; test data + drift của tôi xanh.
- Toàn bộ `flutter test`: xem mục cuối (phụ thuộc WIP của phiên khác).

## Việc dở / lưu ý cho phiên sau
- `SpendingSummary` (header Tổng quan hiện tại) vẫn là tổng Monthly cost theo trạng thái hôm nay, chưa dùng Month spend —
  U-Home đổi sang `monthSpendProvider` khi làm thẻ Chi phí.
- `InsightsStats` (thẻ cũ) chưa chuyển sang Month spend — U-Insights thay bằng provider mới.
- `CalendarMonth` và `SpendingCalculator.projectedInMonthMinor` vẫn dùng giá hiện tại cho kỳ chờ (không theo lịch sử) — nhỏ.
- Lịch sử Tạm dừng/bật lại không được lưu (chỉ lần dừng hiện tại) → tháng đã dừng rồi bật lại vẫn tính như đang trả.
- `backup_actions.dart` ghi chú "Two CSV files" — nay có thể 3 (phiên U4/L sửa chữ nếu cần).
