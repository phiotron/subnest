# [A001-subnest] R Làm tròn tiền — 2026-11-10 (phiên con R)

Theo APP.md "Quyết định 2026-11-10" ý 10 + CONTEXT.md "Converted amount" (giống A002 D-029).
Commit trên `dev` (chưa push): `a34b264` (WIP domain + sửa kỳ vọng test) · `1b14b2c` (test làm tròn + onboarding) · commit cuối (tổng năm + test UI + notes).

## API mới
- **`lib/domain/ratio.dart`** (mới, export qua `domain.dart`): `Ratio` = phân số dương BigInt, rút gọn.
  - `Ratio.fromDouble(v)` đọc **đúng số thập phân đã ghi** (dạng ngắn nhất của double: `25769.065289`,
    `0.0000394`, `1e-7`) → tỷ giá từ JSON nhà cung cấp, bảng dự phòng, ghi đè tay đều giữ nguyên từng chữ số,
    không mất do double. `tryParse('26000.5' | '3.85e-5' | '1/3')`, `inverse`, `*`, `/`, `toDouble()` (chỉ để hiển thị).
  - `roundHalfUp(BigInt n, BigInt d) → int` — làm tròn nửa ra xa 0 (0,005 → 0,01; −0,005 → −0,01).
- **`ExchangeRates`** (`lib/domain/exchange_rates.dart`) — constructor/kiểu lưu không đổi (`Map<String,double>`):
  - `Ratio? exactRate(from, to)` — ghi đè thắng; tỷ giá chéo = `rate(to)/rate(from)` phân số chính xác ⇒
    `exactRate(a,b) * exactRate(b,a) == Ratio.one` với mọi cặp.
  - **`int? convertMinor(int minor, String from, String to, {Ratio? times})`** — quy đổi chính xác rồi
    half-up tới đơn vị nhỏ nhất của `to` (`currencyDecimals`). `times` nhân trước khi làm tròn (kỳ/tháng).
  - `Money? convertMoney(Money m, String to)`.
  - `double? rate(from,to)` giữ cho màn Tỷ giá (= `exactRate.toDouble()`).
  - `double? convert(double amount, from, to)` giữ cho chỗ "≈" (form, catalog, confirm, currency sheet)
    nhưng **giờ làm tròn giống `convertMinor`** ⇒ số "≈" khớp số vào tổng.
- **`BillingCycle.periodsPerMonthRatio`** — số kỳ/tháng dạng phân số (365/12, 52/12, 1/n, 1/12n).
- **`SpendingCalculator`**: thêm `toPrimaryMinor(Money)`, `periodCostMinor`, `monthlyCostMinor`, `yearlyCostMinor`,
  `byCategoryIdMinor`, `actualInMonthMinor`, `projectedInMonthMinor`, `totalPaidMinor`. Các hàm `double` cũ
  (`periodCost`, `monthlyCost`, `yearlyCost`, `actualInMonth`, `projectedInMonth`, `totalPaid`, `byCategory*`, `top`)
  giữ nguyên chữ ký, giờ = số int đã làm tròn đổi ra đơn vị chính ⇒ UI không phải sửa.
  - Monthly cost / Yearly cost là **một dòng làm tròn một lần** từ số chính xác (yearly 100 USD → tháng 8,33, năm 100,00 — không phải 8,33×12).
- **`SpendingSummary`**: trường gốc giờ là int minor + `currency`: `monthlyMinor`, `yearlyMinor` (= **Σ Yearly cost** các gói Active, không phải monthly×12),
  `trialMonthlyMinor`, `savingsYearlyMinor` (= Σ Yearly cost các gói Huỷ), `awaitingTotalMinor`; getter `double` cũ giữ nguyên tên.
- **`ForecastItem(sub, date, amountMinor, currency)`**, **`WeekStrip(start, days, totalMinor, currency)`** (getter `amount`/`total` giữ),
  `ForecastCalculator.nextDaysMinor`; `nextDays`/`nextMonths`/`budgets`/`notWorthSavingsYearly` cộng int.
- **`CalendarMonth.totalMinor`** + `currency` (getter `total` giữ); mỗi mục quy đổi bằng `convertMinor` rồi cộng.
- `InsightsStats`: `totals`, `categories`, `overlaps` cộng int minor; `RangeTotals`/`CategorySlice`/`MonthSpending` giữ kiểu double (test dựng trực tiếp).

### Hàm cho W Widget ("tổng tháng")
Dùng **`spendingSummaryProvider` → `SpendingSummary.monthlyMinor`** (int, đơn vị nhỏ nhất của `summary.currency`)
— đúng số hero Tổng quan hiện (`summary.monthly`). Từng dòng: `calc.periodCostMinor(s)` (giá kỳ quy đổi) hoặc
`calc.monthlyCostMinor(s)`. Định dạng: `l.money(Money(summary.monthlyMinor, summary.currency))`. Không tự cộng double.

## Chỗ đã đổi
- `lib/domain/{ratio (mới), exchange_rates, spending, billing_cycle, domain}.dart`, `lib/domain/stats/{forecast, insights_stats, calendar_month}.dart`.
- UI: `lib/features/onboarding/onboarding_screen.dart` (`_monthlyTotal` cộng `monthlyCostMinor`); `lib/features/home/home_screen.dart`
  hero "Năm" dùng `summary.yearly` thay `total * 12` (gói năm giữ đúng giá năm: ₫12,893,600 thay vì 12,893,592). Các chỗ khác dùng API double cũ — đã tự làm tròn.
- `lib/data/rates/**`: **không cần sửa** — DB vẫn lưu double; `Ratio.fromDouble` đọc lại đúng số thập phân (giới hạn: ≤ ~15 chữ số có nghĩa, dư cho tỷ giá).
- Không đụng file của B, không sửa `pubspec.yaml`/ARB.

## Test
- Mới `test/domain/rounding_test.dart` (14 ca): `Ratio` đọc/parse; half-up (0,005 → 0,01, âm, 0,00495 → 0);
  nghịch đảo chính xác mọi cặp USD/VND/JPY/EUR/KWD/BHD/GBP/IDR trên bảng dự phòng; ghi đè 26000,5 hai chiều;
  A→B→A: JPY 1000→EUR 5,64→1000, USD 9,99→KWD 3,109→9,99, KWD 4,990→VND→4,990, EUR↔USD; đổi Tiền tệ chính VND→USD→VND ra cùng tổng;
  tổng = cộng dòng (3 × 10 000 ₫ ≈ 0,39 USD ⇒ 1,17 chứ không 1,18) ở summary, theo danh mục, top, Payments/tổng đã trả,
  dự báo/tuần/ngân sách, Insights, Lịch; cặp thiếu tỷ giá (null, loại khỏi tổng, `missingRates`).
- **Test cũ đổi kỳ vọng** (đều do mỗi dòng giờ làm tròn trước khi cộng):
  - `test/domain/spending_test.dart` "summary totals…": Google One 1 690 000 ₫/năm ÷ 12 = 140 833,33 → **140 833** (lệch 0,33 ₫).
  - `test/domain/stats/insights_stats_test.dart` "categories…": cùng lý do, `59000 + 140833`.
  - `test/features/home/home_screen_test.dart`: hero tháng ₫1,074,467 → **₫1,074,466** (VI 1.074.466đ) — Google One 140 833,33 + Canva 115 833,33 giờ mỗi dòng làm tròn xuống; hero năm giữ ₫12,893,600.
  - `test/features/insights/insights_screen_test.dart` #1: ≈ 34,35 → **≈ 34,36** USD (cộng dòng đã làm tròn cent; % vẫn +12).
  - `spending_test` thêm: `yearly` = Σ Yearly cost (Google One giữ 1 690 000).
  - `test/domain/stats/insights_consistency_test.dart` (5 chỗ, primary USD, 25 701 ₫/USD): kỳ vọng trước là
    tổng VND rồi mới chia tỷ giá (34,3496 USD); giờ là cộng từng dòng đã làm tròn cent (34,36). Thêm helper `cents()`/`usdSum()` trong test.
- Lệnh: `flutter test test/domain` xanh (152 ca); `flutter analyze lib/domain lib/data/rates lib/features/onboarding test/domain` sạch.
  `flutter test` toàn bộ (2026-11-10, sau commit 36fc5ee của B): **+921 ~97 −3** — 3 lỗi đều ở `test/features/widget_sync/widget_sync_test.dart`
  (file untracked + `widget_sync.dart` đang sửa = WIP của phiên W, lỗi định dạng `≈ 12,56 $` / `FakeStore.last` rỗng — không liên quan làm tròn).
  Mọi test domain/home/insights/onboarding/settings xanh.

## Việc dở / rủi ro
- **A→B→A với tiền B thô hơn A** (vd 50 000 ₫ → 1,94 USD → 49 992 ₫) không về số cũ nếu đổi lại *từ số đã làm tròn* —
  A001 không gặp vì giá gốc không bao giờ bị ghi đè (đổi Tiền tệ chính chỉ đổi cách cộng). Ai sau này ghi số đã quy đổi
  (vd import/export) phải giữ giá gốc, không quy đổi chồng.
- `toMinorUnits(double)` (số người dùng gõ) vẫn `(major × 10^d).round()` bằng double như cũ — ngoài phạm vi.
- Hero "Tháng" × 12 có thể khác hero "Năm" vài đồng/cent (mỗi bên là tổng các dòng đã làm tròn riêng) — chủ ý, để năm khớp giá năm từng gói.
  `CostRates` (forecast) vẫn yearly = monthly × 12 — chưa có UI dùng.
- Lúc làm, `analyze` toàn app có lỗi ở file WIP của phiên B (đã hết sau commit 36fc5ee của B). Analyze phần của R sạch.

## Đề xuất cải tiến xưởng
- `Ratio` + `convertMinor` là bản thứ hai của cùng một thứ (A002 `ExchangeRate` + `convertMinorUnits`). Đáng đưa vào gói dùng chung
  của xưởng (`money` package: Ratio, roundHalfUp, currencyDecimals, convertMinor) khi có app thứ 3 đa tiền tệ.
- Heredoc Python dài trong Git Bash hay vỡ (dấu `'''`/`$`) — viết script ra scratchpad rồi chạy.
