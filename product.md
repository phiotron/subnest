# Subnest — Product spec cho thiết kế Hi-Fi UI

> **Dùng file này để làm gì:** gửi cho Claude Design để làm mockup Hi-Fi (tối ưu UX/UI) cho app mobile
> **Subnest: Subscription Tracker** (Android + iOS). File mô tả *cái gì* và *vì sao*; phần *trông thế nào*
> do Claude Design đề xuất trong khuôn khổ ở §7.
> Mã nội bộ: `A001-subnest` · Bundle ID: `com.phiotron.subnest` · Bản: 1.0 (MVP) · Ngày: 2026-11-04
> Thuật ngữ chuẩn: xem `CONTEXT.md` (Subscription, Billing period, Due date, Awaiting confirmation, Payment…).

---

## 1. Tóm tắt sản phẩm

**Subnest** giúp người dùng biết chính xác mình đang trả bao nhiêu cho các subscription (Netflix, Spotify,
iCloud, ChatGPT, YouTube Premium, gói cước…), được **nhắc trước khi bị trừ tiền** và **trước khi hết dùng thử**,
và thấy rõ đã tiết kiệm được bao nhiêu khi huỷ bớt.

- **Một câu:** "Mọi subscription của bạn trong một tổ — không bị trừ tiền bất ngờ nữa."
- **Người dùng mục tiêu:** người 18–40 tuổi dùng nhiều dịch vụ số, hay đăng ký dùng thử rồi quên huỷ;
  người chia gói Family với bạn bè/gia đình; người trả bằng nhiều loại tiền (USD cho ChatGPT, VND cho Netflix VN).
- **Thị trường:** toàn cầu; ngôn ngữ **English + Tiếng Việt**.
- **Nguyên tắc sản phẩm:**
  1. **Riêng tư tuyệt đối** — không tài khoản, không liên kết ngân hàng, không analytics; dữ liệu chỉ nằm trên máy.
  2. **Nhanh** — thêm một subscription phổ biến trong ≤ 3 chạm nhờ Thư viện dịch vụ.
  3. **Bình tĩnh, rõ ràng** — con số tổng chi là nhân vật chính; không gây lo âu, không dark pattern.
  4. **Miễn phí hoàn toàn** ở bản 1 — không paywall, không quảng cáo.

### Đối thủ & điểm khác biệt
| Đối thủ | Điểm yếu | Subnest làm khác |
|---|---|---|
| **Bobby** (iOS, ~4.7★) | Chỉ có iPhone; ít cập nhật | Có cả Android + iOS; tiếng Việt + VND |
| **Tilla** (Android) | Chỉ Android, nhỏ | Cross-platform, thống kê sâu hơn |
| **Rocket Money** | Phải liên kết ngân hàng, chủ yếu Mỹ | Không cần ngân hàng, dữ liệu ở máy |
| Chung | Ít app hỗ trợ **gói chia sẻ**, **xác nhận từng kỳ**, **tiết kiệm khi huỷ** | Cả ba là tính năng lõi |

---

## 2. Phạm vi bản 1 (MVP)

| # | Tính năng | Ghi chú |
|---|---|---|
| F1 | **Thêm / sửa / xoá Subscription** | Chu kỳ mỗi N ngày/tuần/tháng/năm, Trial, Gói chia sẻ, danh mục, ghi chú |
| F2 | **Tổng chi tháng / năm** đa tiền tệ | Quy đổi về Tiền tệ chính bằng tỷ giá tự cập nhật hằng ngày (ghi đè được) |
| F3 | **Nhắc** trước Due date và trước khi hết Trial | Thông báo trên máy, mặc định 3 ngày trước lúc 9:00 |
| F4 | **Xác nhận từng kỳ** + lịch thanh toán | Tới Due date → kỳ ở trạng thái *Chờ xác nhận* cho tới khi người dùng xác nhận trong app |
| F5 | **Thư viện dịch vụ** (~100 dịch vụ phổ biến) | Thêm 1 chạm, có giá gợi ý, link hướng dẫn huỷ |
| F6 | **Thống kê & biểu đồ** | Theo danh mục, xu hướng 12 tháng, top đắt nhất, Tiết kiệm |
| F7 | **Sao lưu / khôi phục** | Xuất JSON (đầy đủ) và CSV (đọc bằng Excel); nhập JSON |
| F8 *(stretch)* | **Widget màn hình chính** | Chỉ làm nếu kịp tiến độ; vẫn **thiết kế luôn** để sẵn |

**Ngoài phạm vi bản 1** (đừng thiết kế, nhưng bố cục nên chừa chỗ): đồng bộ đám mây, khoá app bằng sinh trắc,
đọc email hoá đơn, chia sẻ với người khác qua link, Pro/IAP, nút hành động trên thông báo.

---

## 3. Luật nghiệp vụ (designer cần hiểu để vẽ đúng trạng thái)

1. **Subscription** có 3 trạng thái: `Trial` (dùng thử) · `Active` (đang trả) · `Cancelled` (đã huỷ).
2. **Chu kỳ**: mỗi N ngày / tuần / tháng / năm (vd "mỗi 1 tháng", "mỗi 3 tháng", "mỗi 1 năm", "mỗi 28 ngày").
3. **Due date (Ngày gia hạn)** là ngày của kỳ kế tiếp cần trả.
4. **Xác nhận từng kỳ — điểm đặc biệt nhất:**
   - Khi tới Due date, kỳ đó chuyển sang **Chờ xác nhận**. App gửi một thông báo "Hôm nay gia hạn Netflix —
     mở app để xác nhận". Thông báo **không có nút**; chạm vào thì mở thẳng tấm xác nhận.
   - Người dùng chọn: **Đã trả** (số tiền điền sẵn = giá hiện tại, sửa được) · **Không trả kỳ này** (bỏ qua) ·
     **Để sau**.
   - **Due date đứng yên cho tới khi xác nhận.** Chỉ sau khi xác nhận, Due date mới nhảy sang kỳ sau và nhắc
     của kỳ sau mới được lên lịch.
   - Nếu quên nhiều kỳ (vd 2 tháng), sau khi xác nhận kỳ cũ, kỳ kế tiếp (cũng đã qua) lập tức thành Chờ xác nhận
     → người dùng xác nhận lần lượt. Cần UI **"Xác nhận tất cả"** để bắt kịp nhanh (mỗi kỳ dùng giá hiện tại).
   - Subscription đang có kỳ Chờ xác nhận phải **nổi bật** ở mọi nơi nó xuất hiện (badge/viền/màu cảnh báo nhẹ).
5. **Payment (Thanh toán)** = một kỳ đã xác nhận "Đã trả", lưu số tiền thực trả. Chi tiêu *thực tế* trong Thống kê
   chỉ tính từ Payment. Kỳ "Không trả" không tạo Payment.
6. **Trial**: có ngày kết thúc. Nhắc trước 3 ngày ("Dùng thử Spotify hết sau 3 ngày — huỷ nếu không muốn bị tính
   phí"). Hết Trial → Subscription **tự thành Active**, ngày hết Trial = Due date của kỳ trả phí đầu tiên (và cũng
   cần xác nhận như mọi kỳ).
7. **Huỷ**: chuyển sang `Cancelled`, giữ lại để xem lịch sử và **khôi phục** được. Không còn nhắc. Số tiền quy năm
   của nó cộng vào **Tiết kiệm** ("Bạn đang tiết kiệm 3.120.000đ/năm").
8. **Gói chia sẻ**: bật "Chia với N người" → **Phần của tôi** = giá ÷ N. Mọi tổng chi dùng Phần của tôi.
   Hiển thị cả hai: "Phần của tôi 65.000đ · gói 260.000đ ÷ 4".
9. **Đa tiền tệ**: mỗi Subscription có tiền tệ riêng. Tổng chi quy về **Tiền tệ chính** (mặc định theo vùng của máy:
   VN → VND, US → USD…). Tỷ giá tự cập nhật 1 lần/ngày khi có mạng; offline dùng tỷ giá gần nhất; người dùng có
   thể ghi đè tỷ giá từng cặp. Số đã quy đổi hiển thị kèm dấu "≈".
10. **Chi phí quy tháng**: giá (Phần của tôi) quy về 1 tháng theo chu kỳ (năm ÷ 12, tuần × 52 ÷ 12…).
    Tổng chi tháng = tổng chi phí quy tháng của các Subscription `Active`. Trial hiển thị riêng là "sắp tính phí".
11. **Nhắc**: mặc định **3 ngày trước Due date, 9:00**; mỗi Subscription chỉnh riêng được
    (Tắt / Đúng ngày / 1 / 3 / 7 ngày trước). Giờ nhắc chung chỉnh trong Cài đặt.

---

## 4. Kiến trúc thông tin

```
Onboarding (lần đầu)
└── Tab bar (4 tab)
    ├── 1. Tổng quan (Home)       ← mặc định
    │     ├── Chi tiết Subscription → Sửa / Huỷ / Khôi phục / Xoá / Lịch sử thanh toán
    │     └── Danh sách Chờ xác nhận → Tấm xác nhận
    ├── 2. Lịch (Calendar)
    ├── 3. Thống kê (Insights)
    └── 4. Cài đặt (Settings)
          ├── Tiền tệ & tỷ giá
          ├── Nhắc nhở
          ├── Giao diện & ngôn ngữ
          ├── Sao lưu & khôi phục
          └── Giới thiệu / Quyền riêng tư
Nút "+" (nổi trên Tổng quan, có thể cả Lịch) → Chọn dịch vụ (Thư viện) → Form Subscription
```

---

## 5. Màn hình chi tiết

> Mỗi màn hình cần: **light + dark**, các trạng thái ghi ở mục "Trạng thái". Ví dụ dữ liệu ở §8.

### S0. Splash
Logo Subnest trên nền thương hiệu. Ngắn (< 1s), không chữ thừa.

### S1. Onboarding (3 bước, có thanh tiến độ, nút "Bỏ qua" ở bước 1–2)
- **S1.1 Chào mừng** — minh hoạ "tổ" gom các thẻ subscription; tiêu đề "All your subscriptions, one nest" /
  "Mọi subscription, một tổ"; 3 lợi ích ngắn kèm icon: *Nhắc trước khi bị trừ tiền* · *Biết chính xác mỗi tháng tốn
  bao nhiêu* · *Riêng tư — dữ liệu chỉ trên máy bạn*. Nút "Bắt đầu".
- **S1.2 Tiền tệ chính** — gợi ý sẵn theo vùng ("VND — Đồng Việt Nam ✓"), nút đổi mở danh sách tiền tệ có tìm kiếm.
  Giải thích 1 dòng: "Dùng để cộng tổng chi. Mỗi subscription vẫn có tiền tệ riêng."
- **S1.3 Bạn đang dùng gì?** — lưới các dịch vụ phổ biến (tile màu + chữ cái, xem §7.4), **chọn nhiều**, ô tìm kiếm.
  Mỗi tile đã chọn có dấu ✓ và khi chọn hiện chip nhỏ cho chỉnh nhanh giá/chu kỳ (mặc định giá gợi ý theo vùng).
  Thanh dưới cùng: "Đã chọn 5 · ≈ 742.000đ/tháng" + nút "Tiếp tục". Cho phép "Để sau".
- **S1.4 Bật nhắc nhở** (màn giải thích trước khi bật hộp thoại xin quyền của hệ điều hành) — minh hoạ thông báo mẫu
  "Netflix gia hạn sau 3 ngày — 260.000đ". Nút "Bật nhắc nhở" / "Không, cảm ơn".
- Kết thúc → vào Tổng quan với dữ liệu vừa chọn (khoảnh khắc "wow": thấy ngay tổng chi).

### S2. Tổng quan (Home) — màn quan trọng nhất
Từ trên xuống:
1. **Header tổng chi**: số lớn "≈ 1.284.000đ" + nhãn "mỗi tháng"; chạm để chuyển **Tháng ↔ Năm**. Dòng phụ:
   "12 subscription đang trả · 2 dùng thử".
2. **Thẻ Chờ xác nhận** (chỉ hiện khi có): "2 khoản cần xác nhận" + avatar các dịch vụ + nút "Xem". Màu cảnh báo
   nhẹ (không đỏ gắt).
3. **Thẻ Dùng thử sắp hết** (khi có Trial trong 7 ngày tới): "Dùng thử Spotify hết sau 2 ngày" + nút "Cách huỷ".
4. **Sắp tới (7 ngày)**: dải ngang hoặc list gọn các khoản sắp gia hạn, mỗi dòng: tile dịch vụ, tên, "Còn 3 ngày",
   số tiền.
5. **Danh sách Subscription**: segmented control **Đang trả · Dùng thử · Đã huỷ**; sắp xếp (Ngày gia hạn / Giá /
   Tên) qua nút nhỏ. Mỗi hàng: tile dịch vụ · tên + danh mục/chu kỳ ("Hằng tháng · Giải trí") · bên phải số tiền
   (tiền tệ gốc) + "≈ quy đổi" nếu khác tiền tệ chính + "Còn 5 ngày". Hàng Chờ xác nhận có badge. Hàng Gói chia sẻ có
   icon người + "÷4". Vuốt hàng: Xác nhận (nếu đang chờ) / Huỷ.
   Tab **Đã huỷ**: hàng mờ hơn, hiển thị "Đã huỷ 12/10/2026" + thẻ đầu tab "Bạn đang tiết kiệm 3.120.000đ/năm".
6. **Nút "+"** nổi (FAB) góc dưới phải.
- **Trạng thái**: rỗng (minh hoạ + "Thêm subscription đầu tiên" + nút mở Thư viện) · có dữ liệu · nhiều kỳ chờ ·
  offline (tỷ giá cũ → nhãn nhỏ "Tỷ giá cập nhật 3 ngày trước") · quyền thông báo bị tắt (banner "Nhắc nhở đang tắt —
  Bật lại").

### S3. Chọn dịch vụ (Thư viện) — bước 1 của "+"
- Ô tìm kiếm luôn ở trên, focus sẵn.
- Hàng chip danh mục: Tất cả · Video · Nhạc · AI · Lưu trữ · Phần mềm · Game · Đọc · Sức khoẻ · Học tập · Viễn thông
  · Khác.
- Lưới/list dịch vụ (tile + tên + giá gợi ý "từ 260.000đ/tháng").
- Mục đầu danh sách: **"+ Tạo dịch vụ tuỳ chỉnh"** (luôn có, và là gợi ý khi tìm không thấy: "Không thấy 'abc'?
  Tạo 'abc'").
- Chọn → sang Form với dữ liệu điền sẵn. Một số dịch vụ có nhiều gói (Netflix: Mobile/Basic/Standard/Premium) →
  hiện bottom sheet chọn gói trước.

### S4. Form Subscription (Thêm / Sửa) — dạng trang đầy đủ hoặc sheet cao
Nhóm trường (ưu tiên trường quan trọng lên trên, phần nâng cao gập lại):
1. **Đầu form**: tile dịch vụ lớn (chạm để đổi màu/chữ/emoji) + tên dịch vụ (sửa được).
2. **Giá** — bàn phím số lớn, định dạng theo tiền tệ; bên cạnh là **chọn tiền tệ** (mặc định Tiền tệ chính hoặc theo
   Thư viện). Hiện "≈ 6,25 USD" nếu khác tiền tệ chính.
3. **Chu kỳ** — "Mỗi [1] [tháng ▾]" (ngày/tuần/tháng/năm), có chip nhanh: Hằng tuần · Hằng tháng · Hằng quý · Hằng năm.
4. **Ngày gia hạn tiếp theo** — date picker; dòng phụ "Sau đó: 04/12, 04/01…".
5. **Đang dùng thử** (toggle) → hiện "Hết dùng thử ngày" (date). Khi bật, nhãn giá đổi thành "Giá sau dùng thử".
6. **Chia với người khác** (toggle) → stepper "Số người: 4" + dòng "Phần của bạn: 65.000đ".
7. **Danh mục** (chips).
8. **Nhắc trước** — Tắt / Đúng ngày / 1 / **3** / 7 ngày (mặc định theo Cài đặt).
9. *Nâng cao (gập)*: Phương thức thanh toán (chữ tự do, vd "Visa ••4242", "MoMo"), Link huỷ/quản lý, Ghi chú.
- Nút lưu cố định dưới cùng: "Thêm subscription" / "Lưu thay đổi". Validate: giá > 0, tên không rỗng, ngày hết Trial ≥
  hôm nay.
- **Khi sửa giá**: hỏi nhẹ "Áp dụng từ kỳ tới" (giá chỉ ảnh hưởng các kỳ chưa xác nhận; Payment cũ giữ nguyên).

### S5. Chi tiết Subscription
1. **Hero**: nền/viền theo màu dịch vụ, tile lớn, tên, chip trạng thái (Đang trả / Dùng thử · còn 5 ngày / Đã huỷ /
   Chờ xác nhận).
2. **Số chính**: "260.000đ / tháng"; nếu chia: "Phần của bạn 65.000đ · ÷4"; nếu khác tiền tệ: "≈ …".
3. **Thẻ thông tin**: Ngày gia hạn tiếp (+ "còn 12 ngày") · Chu kỳ · Nhắc trước · Danh mục · Phương thức thanh toán ·
   Bắt đầu từ · **Tổng đã trả** (tổng Payment) · Ghi chú.
4. **Banner Chờ xác nhận** (nếu có) + nút "Xác nhận".
5. **Lịch sử thanh toán**: list theo thời gian — Đã trả (số tiền thực trả, sửa được khi chạm) · Không trả · kỳ đang chờ.
6. **Hành động**: Sửa (header) · "Cách huỷ dịch vụ này" (mở link) · **Đánh dấu đã huỷ** · Khôi phục (nếu đã huỷ) ·
   Xoá (đỏ, cuối trang, có hộp thoại xác nhận: xoá hẳn cả lịch sử).

### S6. Tấm Xác nhận kỳ (bottom sheet) — mở từ thông báo, banner, vuốt hàng
- Tile + "Netflix · kỳ 04/11/2026".
- Số tiền điền sẵn (lớn, sửa được) + tiền tệ.
- 3 nút: **Đã trả** (chính) · **Không trả kỳ này** (phụ) · **Để sau** (text).
- Sau "Đã trả": phản hồi nhẹ (check animation, haptic) + "Kỳ tới: 04/12/2026".
- Nếu ngay sau đó còn kỳ đã qua → tấm tự chuyển sang kỳ kế tiếp ("Còn 1 kỳ chưa xác nhận").

### S7. Danh sách Chờ xác nhận
List các kỳ đang chờ (cũ nhất trước), mỗi hàng có nút ✓ nhanh. Nút **"Xác nhận tất cả · 1.020.000đ"** ở dưới (hộp thoại
xác nhận: tất cả dùng giá hiện tại). Trạng thái rỗng: "Bạn đã xác nhận hết 🎉".

### S8. Lịch (Calendar)
- Header: tháng hiện tại, mũi tên chuyển tháng, **tổng tháng** ("Tháng 11: ≈ 1.284.000đ").
- Lưới tháng: mỗi ngày có các chấm/tile mini màu dịch vụ (tối đa 3 + "+2"). Ngày hôm nay nổi bật. Ngày có kỳ chờ có
  dấu cảnh báo. Tháng quá khứ hiển thị Payment thực (đặc) và kỳ bỏ qua (rỗng); tháng tương lai hiển thị dự kiến.
- Chạm ngày → list bên dưới (hoặc sheet) các khoản ngày đó.
- Tuỳ chọn chuyển sang chế độ **list theo dòng thời gian** (Agenda).

### S9. Thống kê (Insights)
1. Bộ chọn khoảng: **Tháng này · 12 tháng · Năm nay**.
2. **Thẻ tổng**: Thực trả (từ Payment) vs Dự kiến; so với kỳ trước (+/- %).
3. **Biểu đồ cột 12 tháng**: cột đặc = thực trả, phần sọc/nhạt = dự kiến/chưa xác nhận.
4. **Donut theo danh mục** + chú thích (Giải trí 45%, AI 25%…), chạm vào lát → list subscription trong danh mục.
5. **Top 5 đắt nhất** (theo chi phí quy tháng).
6. **Thẻ Tiết kiệm**: "Bạn đang tiết kiệm 3.120.000đ/năm nhờ huỷ 3 dịch vụ" (minh hoạ vui).
7. *Insight nhẹ (tuỳ chọn)*: "Bạn trả 2 dịch vụ nhạc — cần cả hai?" (chỉ khi ≥ 2 dịch vụ cùng danh mục Nhạc/Video).
- Trạng thái rỗng: minh hoạ + "Thêm subscription để xem thống kê".

### S10. Cài đặt
- **Tiền tệ chính** → danh sách tiền tệ.
- **Tỷ giá** → list cặp tỷ giá đang dùng (USD→VND 25.400 · "Tự động, cập nhật 2 giờ trước" / "Bạn đặt tay"), nút
  "Cập nhật ngay", chạm cặp để ghi đè/khôi phục tự động.
- **Nhắc nhở**: mặc định nhắc trước (Tắt/Đúng ngày/1/3/7), giờ nhắc (9:00), trạng thái quyền thông báo (+ nút mở cài
  đặt hệ thống nếu bị tắt).
- **Giao diện**: Theo hệ thống / Sáng / Tối. **Ngôn ngữ**: Theo hệ thống / English / Tiếng Việt.
- **Sao lưu & khôi phục**: "Xuất bản sao lưu (JSON)" · "Xuất bảng tính (CSV)" (mở share sheet của hệ thống) ·
  "Khôi phục từ file" (cảnh báo: thay thế dữ liệu hiện tại / gộp) · dòng "Lần sao lưu gần nhất: …" + nhắc nhẹ nếu > 30
  ngày chưa sao lưu.
- **Giới thiệu**: phiên bản, Chính sách quyền riêng tư, Đánh giá app, Gửi góp ý (email).
- Thẻ nhỏ cuối trang: "🔒 Dữ liệu của bạn chỉ nằm trên máy này. Subnest không thu thập gì."

### S11. Widget màn hình chính *(stretch — vẫn thiết kế)*
- **Nhỏ (2×2)**: khoản gia hạn gần nhất (tile, tên, "còn 3 ngày", số tiền).
- **Vừa (4×2)**: tổng tháng + 3 khoản sắp tới.
- Light + dark, theo phong cách widget của iOS/Android.

### S12. Thông báo (mẫu nội dung — không cần vẽ chi tiết, chỉ cần icon app chuẩn)
| Loại | EN | VI |
|---|---|---|
| Nhắc gia hạn | "Netflix renews in 3 days — ₫260,000" | "Netflix gia hạn sau 3 ngày — 260.000đ" |
| Hết dùng thử | "Your Spotify trial ends in 3 days. Cancel now if you don't want to be charged." | "Dùng thử Spotify hết sau 3 ngày. Huỷ ngay nếu không muốn bị tính phí." |
| Đến ngày | "Netflix renews today — tap to confirm" | "Hôm nay gia hạn Netflix — chạm để xác nhận" |

---

## 6. Luồng chính cần prototype

1. **Lần đầu mở app**: S1.1 → S1.2 → S1.3 (chọn 5 dịch vụ) → S1.4 → S2 có dữ liệu.
2. **Thêm subscription**: S2 "+" → S3 tìm "netf" → chọn Netflix → chọn gói Premium → S4 (bật chia 4 người) → lưu → S2
   (hàng mới nổi bật nhẹ).
3. **Xác nhận kỳ**: chạm thông báo "đến ngày" → S6 → Đã trả → S2 cập nhật.
4. **Bắt kịp nhiều kỳ**: S2 thẻ "3 khoản cần xác nhận" → S7 → Xác nhận tất cả.
5. **Huỷ dịch vụ**: S5 → "Cách huỷ" → (quay lại) → Đánh dấu đã huỷ → khoảnh khắc ăn mừng "Tiết kiệm thêm
   3.120.000đ/năm" → tab Đã huỷ.
6. **Trial**: S2 thẻ "Dùng thử sắp hết" → S5 → Cách huỷ / Giữ lại.

---

## 7. Định hướng thiết kế

### 7.1 Cảm giác
Sạch, hiện đại, đáng tin như một app tài chính nhẹ nhưng **thân thiện, không khô cứng**. Con số lớn, rõ. Màu thương hiệu
của từng dịch vụ là điểm nhấn — nền app trung tính để các màu đó nổi. Tránh cảm giác "app ngân hàng" nặng nề.

### 7.2 Chế độ & nền tảng
- **Light + Dark theo hệ thống** (cả hai đều là hạng nhất).
- Một thiết kế dùng chung cho Android + iOS (build bằng Flutter, nền Material 3) nhưng tôn trọng thói quen nền tảng:
  bottom sheet, tab bar dưới, vuốt quay lại trên iOS. Không cần hai bộ thiết kế riêng.
- Khung mockup: **390 × 844** (iPhone) là chính; kiểm tra thêm **360 × 800** (Android nhỏ) cho các màn S2, S4.

### 7.3 Hệ thống (yêu cầu bàn giao dạng token để dev map sang Flutter ThemeData)
- **Màu**: 1 màu thương hiệu chính (đề xuất hướng chàm/teal tạo cảm giác tin cậy — Claude Design tự chọn), màu nền/bề
  mặt/viền/chữ cho light & dark, màu ngữ nghĩa: thành công (đã trả, tiết kiệm), cảnh báo (chờ xác nhận, trial sắp hết),
  nguy hiểm (xoá). Tương phản đạt **WCAG AA**.
- **Chữ**: font hỗ trợ **tiếng Việt có dấu** đầy đủ (gợi ý *Be Vietnam Pro* hoặc *Inter*); **số dạng tabular** cho tiền;
  thang chữ rõ ràng (display cho tổng chi, title, body, caption).
- **Khoảng cách** theo lưới 4/8, **bo góc** thẻ ~16, tile ~12; bóng đổ rất nhẹ (dark mode dùng viền/độ sáng bề mặt).
- **Chuyển động**: ngắn (150–250ms), có ý nghĩa — check khi xác nhận, số tổng chi đếm lên khi đổi Tháng/Năm, confetti
  nhẹ khi huỷ (tiết kiệm).

### 7.4 Tile dịch vụ (thành phần quan trọng)
**Không dùng logo thương hiệu thật** ở bản 1 (tránh rủi ro bản quyền và từ chối duyệt). Thay bằng **tile monogram**: hình
vuông bo góc, nền là màu đặc trưng của dịch vụ, chữ cái đầu (hoặc 2 chữ) màu tương phản; người dùng có thể thay bằng emoji
hoặc đổi màu. Cần 4 kích thước: 24 (lịch), 40 (list), 56 (form), 80 (hero). Thiết kế sao cho nhìn đẹp và phân biệt được
khi 10+ tile đứng cạnh nhau.

### 7.5 Khả năng truy cập & ngôn ngữ
- Vùng chạm ≥ 44×44; hỗ trợ cỡ chữ lớn của hệ thống (bố cục không vỡ khi chữ to 130%).
- Không truyền tải thông tin chỉ bằng màu (Chờ xác nhận = màu + icon + chữ).
- **Chuỗi tiếng Việt dài hơn tiếng Anh ~30%** → thiết kế bằng tiếng Anh nhưng vẽ thêm bản tiếng Việt cho S2, S4, S6 để
  kiểm tra tràn chữ.
- Định dạng tiền theo vùng: `₫260,000` (EN) / `260.000đ` (VI) / `$9.99`.

---

## 8. Dữ liệu mẫu cho mockup (Tiền tệ chính VND, hôm nay 04/11/2026)

| Dịch vụ | Giá | Chu kỳ | Danh mục | Ghi chú trạng thái |
|---|---|---|---|---|
| Netflix Premium | 260.000đ | tháng | Video | Chia 4 người → 65.000đ; **Chờ xác nhận** (04/11) |
| Spotify Premium | 59.000đ | tháng | Nhạc | **Dùng thử, hết 06/11** |
| YouTube Premium Family | 179.000đ | tháng | Video | Chia 5 người |
| ChatGPT Plus | $20 | tháng | AI | ≈ 508.000đ; gia hạn 07/11 |
| iCloud+ 200GB | 59.000đ | tháng | Lưu trữ | gia hạn 15/11 |
| Google One 2TB | 1.690.000đ | năm | Lưu trữ | gia hạn 20/03/2027 |
| Canva Pro | 1.390.000đ | năm | Phần mềm | gia hạn 02/02/2027 |
| Duolingo Super | 699.000đ | năm | Học tập | **Đã huỷ** 12/10/2026 |
| Apple Music | 65.000đ | tháng | Nhạc | **Đã huỷ** → góp vào Tiết kiệm |
| Gói cước Viettel 5G | 150.000đ | tháng | Viễn thông | **Chờ xác nhận** (01/11) |

---

## 9. Bàn giao mong muốn từ Claude Design

1. Mockup Hi-Fi tất cả màn S0–S11, **light + dark**, kèm các trạng thái nêu ở từng màn (rỗng, có dữ liệu, chờ xác nhận,
   offline, quyền thông báo tắt).
2. **Prototype** các luồng ở §6.
3. **Trang hệ thống thiết kế**: bảng token màu (light/dark, mã hex), thang chữ (font, size, weight, line-height), spacing,
   radius, bóng, icon set dùng (đề xuất bộ icon miễn phí, vd Phosphor/Lucide/Material Symbols), các component: tile dịch
   vụ, hàng subscription, thẻ tổng, chip, segmented control, bottom sheet, nút (chính/phụ/text/nguy hiểm), toggle,
   stepper, date picker, banner, empty state.
4. **App icon** (1024×1024, ý tưởng "tổ" + subscription) và splash.
5. Xuất dưới dạng **link claude.ai + file export HTML** (để dev đọc chính xác màu, khoảng cách, font).
