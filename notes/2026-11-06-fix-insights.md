# [A001-subnest] Fix insights numbers — 2026-11-06

Phiên con của phiên điều phối #2. Việc: sửa mọi số liệu sai/mâu thuẫn ở màn Thống kê S9.
Trạng thái: **code + test xong, đã push `dev` (`efd1fbf`)**. **Phần kiểm trên máy CHƯA làm**: máy Galaxy A13
đang được dùng cho A002 (Ví Gọn), phiên chính bảo chờ. Kịch bản sẵn ở §5.

## 1. Từng lỗi — nguyên nhân gốc, sửa, test

Test tái hiện viết **trước** khi sửa, trên fixture mô phỏng dữ liệu máy (`test/domain/stats/device_sample.dart`:
dữ liệu mẫu VI của `make_demo_backup.py` ngày 2026-11-05, tiền chính USD, 1 USD = 25.701 VND, thêm
"ChatGPT Pro 100" gói năm gia hạn tháng 12 chưa có Payment). Code cũ trên fixture này cho: năm nay **+6910%**,
câu tăng vọt "Tháng 3 và 12 … ChatGPT Pro 100, Google One 2TB" (đúng dạng lỗi trên máy).

| # | Triệu chứng | Nguyên nhân gốc | Sửa | Test |
|---|-------------|-----------------|-----|------|
| 1 | Tháng này: "Đã trả ≈ 0,00 $" mà "Nhiều hơn 87% so với tháng trước" | `InsightsSummaryCard` hiện `totals.paid`, còn `changePercent` tính trên `total` (đã trả + dự kiến). Hai số khác đại lượng. | Số lớn = **Tổng** của kỳ (đã trả + dự kiến, = tổng các cột, = đầu Lịch S8 tháng này), nhãn "Tổng · tháng này"; % so **cùng** tổng đó; 2 dòng Đã trả / Dự kiến bên dưới là phần chia. Có "≈" khi còn phần dự kiến (như Lịch). | `insights_consistency_test` #1; widget "#1 this month…" (VI, USD) + "range picker" (EN) |
| 2 | Năm nay "+3240% so với năm ngoái" | So với kỳ trước bất kể kỳ đó có được theo dõi không (năm 2025 chỉ có vài Payment tháng 12). | `RangeTotals.previousTotal` = `null` khi lịch sử chưa phủ kỳ trước → hiện "Chưa đủ dữ liệu năm ngoái để so sánh" (+ biến thể tháng trước / 12 tháng trước đó), icon info. Quy tắc ở §3. | consistency #2 (5 test); widget "#2 this year…", "summary…" |
| 3 | "Theo danh mục — mỗi tháng, đang trả": AI ≈ 232,53 $ (89%) > dự kiến tháng này 57,42 $ | **Cách tính đúng** (Monthly cost = phần của tôi × số kỳ/tháng: gói năm ÷ 12, tuần × 52/12; chỉ Active; Trial, Cancelled bị loại; quy đổi tỷ giá hiện tại; tổng = Home S2). Sai ở **tên gọi**: "mỗi tháng, đang trả" đọc như "tháng này trả". AI lớn vì ChatGPT Pro 100 (gói năm) được chia đều theo tháng, còn tháng 11 không có kỳ của nó. | Nhãn → "quy ra mỗi tháng, gói đang dùng" / "monthly equivalent, active plans"; thêm dòng chú thích dưới donut khi có gói không trả theo tháng (`InsightsStats.hasLongCycles`). | consistency #3 (AI = Plus + Pro/12, My share video, slices = Home monthly, Top 5); widget "#3", "donut legend…" |
| 4 | Câu "Tháng X và Y tăng vọt vì…" khác giữa tab; tháng 12 (dự kiến, sọc) nói như đã xảy ra | (a) Tên dịch vụ xếp theo **giá kỳ**, không theo tháng → "Tháng 2 và 3 … Google One, Canva" ghép sai (Canva là tháng 2). Test cũ còn cài cứng thứ tự sai này. (b) Không phân biệt tháng đã qua / tháng dự kiến. (c) Khác giữa tab là **đúng**: mỗi tab mô tả biểu đồ của nó (Năm nay = T1–T12/2026, 12 tháng = T12/2025–T11/2026), chọn 2 tháng cao nhất ≥ 1,5× trung vị. | `peaks()` trả **danh sách** `PeakNote`: một câu cho tháng đã qua, một câu cho tháng còn tới (từ tháng này, phần dự kiến > đã trả) với "dự kiến tăng vọt…"; nguyên nhân chọn mỗi tháng một (đắt nhất) rồi xếp theo tháng. EN sửa luôn "{months} are higher" (sai số ít) → "Spending was/will be higher than usual in {months}." | consistency #4; widget "#4 peaks…", "bar chart…", "Vietnamese wording" |
| 5 | Rà toàn S9 | — | Thêm kiểm chéo: tổng thẻ = tổng cột (3 tab); cột tháng đã qua = Lịch "Đã trả tháng …" (Payment theo due date, quy đổi); tháng này S9 = Lịch; tháng tương lai = Lịch; danh mục = Home monthly; Tiết kiệm = chi phí năm của gói Cancelled. **Tất cả khớp, không cần sửa thêm.** Nhãn a11y biểu đồ "Paid per month" → "Spending per month, paid and expected" (cột gồm cả phần dự kiến). | consistency #5 (7 test) |

Kiểm: `flutter analyze` sạch · `flutter test` 664 pass (~96 skip golden/UI_SHOTS như cũ) · `dart run tool/merge_arb.dart --check` OK.

File đổi (commit `efd1fbf`): `lib/domain/stats/insights_stats.dart`, `lib/features/insights/insights_screen.dart`,
`lib/features/insights/widgets/insights_cards.dart`, `lib/l10n/parts/insights_{en,vi}.arb` + merged/generated l10n,
`test/domain/stats/{device_sample,insights_consistency_test,insights_stats_test}.dart`,
`test/features/insights/insights_screen_test.dart`. Không đụng domain/data/core.

Thêm (commit sau): `test/domain/stats/s9_backup_report_test.dart` — in mọi số S9 từ **một file backup thật** và
kiểm các đẳng thức ở #5; tự skip khi không truyền `--dart-define=S9_BACKUP=…` (file backup có dữ liệu cá nhân,
không commit).

## 2. Chưa giải thích hết (cần backup thật)

Fixture cho tháng này dự kiến **34,35 $**, AI **130,85 $**; máy báo **57,42 $** và **232,53 $**. Tháng trước khớp
(máy 57,42/1,87 ≈ 30,7 $; fixture 30,66 $) → trên máy có gói nhập tay khác fixture (ChatGPT Pro 100 giá/chu kỳ
thật, có thể thêm gói tháng ≈ 23 $ trong tháng 11). Không phải lỗi công thức (các đẳng thức #5 đúng trên mọi dữ
liệu), nhưng phải chạy `s9_backup_report_test` với backup thật để xác nhận (§5 bước 2).

## 3. Quy tắc so sánh đã chốt

- Số so sánh = **Tổng của kỳ** (đã trả + dự kiến, cùng số lớn trên thẻ) với **Tổng của kỳ trước cùng độ dài**
  (Tháng này ↔ tháng trước; 12 tháng ↔ 12 tháng trước đó; Năm nay ↔ năm ngoái).
- Chỉ hiện % khi **lịch sử phủ kỳ trước**: tháng của kỳ đã xác nhận (Đã trả hoặc Bỏ qua) sớm nhất ≤ tháng đầu kỳ
  trước. Không thì "Chưa đủ dữ liệu … để so sánh". Kỳ trước phủ nhưng tổng = 0 → ẩn dòng.
- Hạn chế đã biết: người chỉ có gói năm, Payment đầu tiên giữa năm ngoái → năm nay vẫn chưa so (chặt hơn cần thiết,
  nhưng không bao giờ ra % ảo). `startDate` không dùng vì là ngày người dùng nhập, không có Payment đi kèm.

## 4. Ảnh trước/sau

CHƯA chụp (máy bận cho A002). Sẽ lưu `notes/img/2026-11-06-fix-insights/{before,after}-{month,year,12m,category}.png`
(đã cắt thanh trạng thái/điều hướng — chỉ phần app).

## 5. Kịch bản kiểm trên máy (chạy khi phiên chính báo máy rảnh)

APK sẵn: `build/app/outputs/flutter-apk/app-release.apk` (build 09:04 từ `efd1fbf`, release **ký debug key** —
bản đang cài cũng ký debug key, SHA-256 `fa9b88c7…be0b`, đã kiểm bằng `apksigner` → `install -r` giữ dữ liệu).
**Không** gỡ cài đặt, **không** `pm clear`.

```bash
ADB="$LOCALAPPDATA/Android/Sdk/platform-tools/adb.exe"; D="-s R58TC12SRZW"
IMG="notes/img/2026-11-06-fix-insights"; mkdir -p "$IMG"
shot() { "$ADB" $D exec-out screencap -p > "$IMG/raw-$1.png"
  python -I -c "import sys;from PIL import Image;Image.open(sys.argv[1]).crop((0,70,1080,2273)).save(sys.argv[2])" \
    "$IMG/raw-$1.png" "$IMG/$1.png" && rm "$IMG/raw-$1.png"; }
tap_text() { "$ADB" $D shell uiautomator dump /sdcard/ui.xml >/dev/null; "$ADB" $D pull /sdcard/ui.xml ui.xml >/dev/null
  python -I -c "import re,sys;x=open('ui.xml',encoding='utf-8').read();m=re.search(r'(?:text|content-desc)=\"'+re.escape(sys.argv[1])+r'[^\"]*\"[^>]*bounds=\"\[(\d+),(\d+)\]\[(\d+),(\d+)\]',x);a=list(map(int,m.groups()));print((a[0]+a[2])//2,(a[1]+a[3])//2)" "$1" \
    | { read X Y; "$ADB" $D shell input tap $X $Y; }; sleep 1; }
```

1. **Trước** (bản cũ): `"$ADB" $D shell monkey -p com.phiotron.subnest 1` → `tap_text "Thống kê"` →
   `tap_text "Tháng này"; shot before-month` · `tap_text "Năm nay"; shot before-year` · `tap_text "12 tháng"; shot before-12m`
   · cuộn tới donut (`input swipe 540 1800 540 700`) `shot before-category`. Ghi lại các số trên màn.
2. **Backup thật**: Cài đặt → Xuất bản sao lưu (không đặt mật khẩu) → share sheet → "Lưu vào…"/Files → Download.
   `"$ADB" $D pull /sdcard/Download/subnest-backup-2026-11-06.json <scratchpad>/` (KHÔNG để trong repo), rồi
   `flutter test test/domain/stats/s9_backup_report_test.dart --dart-define=S9_BACKUP=<file> --dart-define=S9_VND_PER_USD=<tỷ giá trong Cài đặt>`
   → so với số trên màn trước; giải thích 57,42 $ / 232,53 $; xoá file backup + file trên máy sau khi xong.
3. **Cài bản mới**: `"$ADB" $D install -r build/app/outputs/flutter-apk/app-release.apk` (giữ dữ liệu).
4. **Sau**: lặp bước 1 với tên `after-*`. Kỳ vọng: "Tổng · tháng này ≈ X" với X = Đã trả + Dự kiến, % so tháng
   trước; Năm nay/12 tháng: "Chưa đủ dữ liệu … để so sánh"; donut "quy ra mỗi tháng, gói đang dùng" + chú thích;
   câu tăng vọt Năm nay: "Tháng 3 tăng vọt … Google One 2TB. Tháng 12 dự kiến tăng vọt … ChatGPT Pro 100."
5. **Trả máy**: về màn đang mở trước đó (Ví Gọn) bằng `"$ADB" $D shell monkey -p com.phiotron.vigon 1`; xoá
   `/sdcard/ui.xml`, file backup trong Download.

## 6. Việc dở / rủi ro

- Bước máy (§5) chưa làm → chưa có ảnh trước/sau, chưa xác nhận số trên dữ liệu thật.
- Đổi nghĩa số lớn S9 (Đã trả → Tổng): ảnh store `store/screenshots/{en,vi}/04-insights.png` và
  `08-insights-dark.png` giờ lệch chữ ("Paid · …" / "Đã trả · …", câu tăng vọt) → **phiên điều phối cần cho chụp
  lại** trước khi nộp store (ngoài phạm vi phiên này).

## 7. Đề xuất cải tiến xưởng

1. **Test "đẳng thức chéo" cho mọi màn thống kê** (thẻ = tổng cột, màn A = màn B cùng tháng, tổng danh mục = tổng
   trang chủ): rẻ, bắt được cả lớp lỗi "mỗi chỗ một số". Đưa vào PLAYBOOK như checklist cho màn có số liệu.
2. **Quy tắc "so sánh trung thực"** cho mọi app có % so kỳ trước (Ví Gọn, RevLog…): chỉ so khi lịch sử phủ kỳ trước,
   so cùng đại lượng với số đang hiện; tháng tương lai/dự kiến luôn viết thì tương lai. Nên thành mục STANDARDS.
3. **Báo cáo số từ backup thật** (`s9_backup_report_test` dạng skip-unless-define): mỗi app có backup JSON nên có
   công cụ in số liệu từ backup để đối chiếu màn hình mà không phải đọc tay trên máy.
4. **Máy test dùng chung**: nhiều app cùng một Galaxy A13 → cần "khoá máy" (ai đang dùng, tới khi nào) trong
   TASKS/notes chung để phiên con không phải hỏi/chờ mù; phiên con làm phần không cần máy trước.
5. Test cũ đã **cài cứng một lỗi** (thứ tự tên trong câu tăng vọt) → khi viết test câu chữ ghép từ danh sách, kiểm
   cả *cặp* (tháng ↔ tên), không chỉ chép output hiện tại.
