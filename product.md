# Subnest — Product spec v2 cho thiết kế Hi-Fi UI (toàn app)

> **Dùng file này để làm gì:** gửi cho Claude Design để làm lại mockup Hi-Fi **toàn bộ app**, tối ưu UX/UI, cho
> **Subnest: Subscription Tracker** (Android + iOS, Flutter). File mô tả *cái gì*, *vì sao*, *thứ tự ưu tiên* và
> *trạng thái*; *trông thế nào* do Claude Design đề xuất trong khuôn khổ §8.
> Mã nội bộ `A001-subnest` · Bundle `com.phiotron.subnest` · Bản 1.0 · v2 ngày 2026-11-10 (thay bản 2026-11-04,
> lưu ở `docs/product-v1.md`) · Thuật ngữ chuẩn: `CONTEXT.md` · Mockup hiện có: `design/` v13 (99 màn).
>
> **Mới trong v2 (cần thiết kế kỹ nhất):** §4.2 thẻ Chi phí ở Tổng quan · §4.9 Thống kê theo tháng/năm đang chọn ·
> Tăng giá + Lịch sử giá · Dự đoán 12 tháng tới · chip chu kỳ cạnh mọi giá · thẻ Dùng thử 3 nút · **logo thật**
> của dịch vụ (đóng gói trong app) + logo tự chọn ảnh · gộp mọi phần đã thêm sau v13 (màn Ngôn ngữ, sao lưu tự động,
> khoá PIN, che nội dung, widget, Xoá toàn bộ dữ liệu).

---

## 1. Tóm tắt sản phẩm

**Subnest** cho người dùng biết chính xác mình trả bao nhiêu cho mọi gói đăng ký (Netflix, Spotify, iCloud,
ChatGPT, gym, gói cước…), **nhắc trước khi bị trừ tiền / hết dùng thử**, thấy **giá tăng**, **dự đoán 12 tháng
tới**, và biết đã tiết kiệm bao nhiêu khi huỷ.

- **Một câu:** "Mọi gói đăng ký của bạn trong một tổ — không bị trừ tiền bất ngờ nữa."
- **Người dùng:** 18–40 tuổi, nhiều dịch vụ số, hay quên huỷ dùng thử, chia gói Family, trả nhiều loại tiền.
- **Thị trường:** toàn cầu. **English + Tiếng Việt.** Máy mới luôn mở **English + USD** (không suy từ máy).
- **Nguyên tắc:**
  1. **Riêng tư tuyệt đối** — không tài khoản, không ngân hàng, không analytics; dữ liệu chỉ trên máy. Mạng chỉ để
     lấy tỷ giá và cập nhật thư viện dịch vụ.
  2. **Nhanh** — thêm gói phổ biến ≤ 3 chạm.
  3. **Bình tĩnh, rõ ràng** — số tiền là nhân vật chính; mọi giá đều ghi rõ chu kỳ; không dark pattern, không gây lo.
  4. **Nhập tay miễn phí**; phần tự động (quét ảnh) là **Pro** — giá chưa chốt, đừng vẽ giá.

---

## 2. Phạm vi bản 1.0

| # | Tính năng | Ghi chú |
|---|---|---|
| F1 | Thêm / sửa / xoá gói | Chu kỳ N ngày/tuần/tháng/năm, Dùng thử, Gói chia sẻ, Danh mục, Nhãn, Phương thức thanh toán, Ghi chú, Đáng tiền?, Tạm dừng |
| F2 | Chi phí tháng / năm đa tiền tệ | Quy về Tiền tệ chính, tỷ giá tự cập nhật hằng ngày, ghi đè được |
| F3 | Nhắc trước Due date và trước khi hết dùng thử | Nhiều mốc (đúng ngày / 1 / 3 / 7 ngày trước), mặc định 3 ngày, 9:00 |
| F4 | Xác nhận từng kỳ + Lịch | Due date đứng yên tới khi xác nhận |
| F5 | Thư viện 500+ dịch vụ, **logo thật** | Hai mục Chung (giá US) / Việt Nam (VND); cập nhật từ xa hằng tuần |
| F6 | Thống kê **theo tháng/năm đang chọn** | Danh mục, đắt nhất, trung bình/ngày, Đã trả/Còn phải trả, Tăng giá, Dự đoán 12 tháng, Ngân sách, Tiết kiệm |
| F7 | Lịch sử giá + Báo đổi giá | Mọi lần giá đổi lưu "cũ → mới, từ ngày"; thư viện đổi giá thì hỏi người dùng |
| F8 | Sao lưu tự động + khôi phục + CSV | File `.subnest` mã hoá bằng mật khẩu, giờ cố định mỗi ngày |
| F9 | Bảo mật | Khoá mã PIN 4 số · Che nội dung khi chuyển app |
| F10 | Widget màn hình chính | Nhỏ / Vừa / Lớn, Android + iOS |
| F11 | Quét ảnh (Pro) | Ảnh chụp trang gói của Play/App Store hoặc hoá đơn → tự thêm gói / tự xác nhận kỳ, Hoàn tác |

**Ngoài phạm vi** (đừng vẽ): đồng bộ đám mây, tài khoản, vân tay/Face ID, đọc thông báo ngân hàng, Gmail, chia sẻ
qua link, nút hành động trên thông báo, giá Pro.

---

## 3. Luật nghiệp vụ (designer cần hiểu để vẽ đúng số và trạng thái)

1. **Trạng thái gói:** `Dùng thử` · `Đang trả` · `Tạm dừng` · `Đã huỷ`. Kỳ của gói có thể **Chờ xác nhận**.
2. **Chu kỳ:** mỗi N ngày / tuần / tháng / năm. **Mọi chỗ hiện giá phải kèm chu kỳ** bằng một **chip viền nhỏ** ngay
   dưới (hoặc cạnh) giá: *Hàng tuần · Hàng tháng · Hàng quý · Hàng năm · Mỗi 3 tháng · Mỗi 28 ngày*. Áp cho Tổng
   quan, Lịch (lưới + danh sách), Sắp tới, Chờ xác nhận, Thư viện ("từ $8.99" + chip), Chi tiết, widget vừa/lớn.
3. **Due date** = ngày kỳ kế tiếp cần trả; **đứng yên** tới khi xác nhận. Tới ngày → kỳ thành **Chờ xác nhận**,
   thông báo "Hôm nay gia hạn Netflix — chạm để xác nhận". Chọn **Đã trả** (số tiền điền sẵn, sửa được) · **Không
   trả kỳ này** · **Để sau**. Quên nhiều kỳ → xác nhận lần lượt hoặc **Xác nhận tất cả**. Gói có kỳ chờ phải nổi bật
   ở mọi nơi (màu cảnh báo nhẹ + icon + chữ, không chỉ màu).
4. **Payment** = kỳ đã xác nhận Đã trả, lưu số tiền thực trả. Tiền *đã trả* chỉ tính từ Payment.
5. **Dùng thử:** có ngày hết. Hết → tự thành Đang trả, ngày hết = Due date kỳ trả phí đầu. Tháng còn dùng thử không
   tính tiền.
6. **Tạm dừng:** có hiệu lực từ Due date kế tiếp ("Tạm dừng từ 15/11") — trước ngày đó vẫn tính tiền. Khi dừng:
   không Due date, không nhắc, không tính tiền. **Bật lại** → chọn Due date kế tiếp (mặc định hôm nay).
7. **Huỷ:** giữ lịch sử, khôi phục được, hết nhắc. Giá quy năm cộng vào **Tiết kiệm**.
8. **Gói chia sẻ:** chia N người → **Phần của tôi** = giá ÷ N; mọi tổng dùng Phần của tôi. Hiển thị "Phần của bạn
   $4.60 · gói $22.99 ÷ 5".
9. **Đa tiền tệ:** mỗi gói một tiền tệ; tổng quy về **Tiền tệ chính** (mặc định USD). Số quy đổi có dấu **"≈"**,
   mỗi dòng làm tròn tới cent/đồng, tổng = cộng các dòng đã làm tròn (luôn khớp).
10. **Chi phí quy tháng (Monthly cost):** gói tháng = giá; gói năm ÷ 12; tuần × 52 ÷ 12; N tháng ÷ N…
11. **Chi phí của một tháng M (Month spend)** — số chính ở Tổng quan và Thống kê:
    - Gói góp Chi phí quy tháng của nó **chỉ khi đang trả trong M**: đã đăng ký (hoặc hết dùng thử) trước/trong M;
      tháng còn dùng thử = 0; tháng sau tháng có ngày huỷ = 0 (tháng huỷ vẫn tính); tạm dừng cả tháng = 0.
    - Gói năm đăng ký **sau** tháng M thì **không** tính vào M.
    - Giá = giá có hiệu lực trong M (theo Lịch sử giá). Áp cho tháng đã qua, tháng này và tháng tới.
    - **Trung bình mỗi ngày** = Chi phí tháng M ÷ số ngày của M (28–31).
    - **Năm** = cộng 12 tháng của năm đó.
12. **Tiền trừ thật trong tháng (Month cash flow)** — thanh "Đã thanh toán / Còn phải thanh toán":
    - **Đã thanh toán** = các Payment của kỳ rơi vào M. **Còn phải thanh toán** = Due date còn lại trong M + kỳ đang
      chờ xác nhận. Gói năm gia hạn trong M tính **đủ giá năm**.
    - Vì vậy Đã + Còn **có thể khác** Chi phí tháng (gói năm). Cần nút **(i)** giải thích ngắn: "Chi phí tháng chia
      đều gói năm ra 12 tháng; thanh dưới là tiền thật sẽ bị trừ trong tháng này."
13. **Lịch sử giá:** mỗi lần giá đổi (sửa tay áp từ kỳ tới, hoặc nhận Báo đổi giá) lưu *giá cũ → giá mới, từ ngày,
    nguồn*. Dữ liệu cũ được suy từ số tiền các kỳ đã trả. Payment cũ không bao giờ đổi.
14. **Tăng giá (Thống kê):** so giá hiện tại với giá 12 tháng trước, chỉ liệt kê gói **tăng**: "Nhiều hơn **$3.50**
    mỗi tháng so với một năm trước · $42.00 mỗi năm · Netflix thay đổi nhiều nhất". Chi tiết gói thì hiện **cả tăng
    lẫn giảm**. Hàng gói có mũi tên ↑ nhỏ nếu tăng giá trong 90 ngày.
15. **Báo đổi giá:** thư viện đổi giá một gói mà giá của người dùng còn bằng giá thư viện cũ → hỏi *Cập nhật (áp từ
    kỳ tới)* / *Giữ giá cũ*. Giá người dùng tự sửa thì không báo. **Gói ngừng bán:** ghi chú nhẹ ở Chi tiết.
16. **Dự đoán 12 tháng tới:** cộng các lần trừ tiền dự kiến từ Due date thật (gói năm rơi đúng tháng gia hạn), so với
    **12 tháng qua** (Payment thật). Chênh lệch tách: *gói đăng ký thêm trong năm* · *gói tăng giá* · *khác*.
17. **Ngân sách:** mức tối đa mỗi tháng cho tổng và từng danh mục, so với Chi phí tháng; vượt → đỏ.
18. **Đáng tiền?** Đáng · Phân vân · Không đáng · (chưa đánh giá). Gợi ý "Bỏ các gói Không đáng tiết kiệm X/năm".
19. **Nhãn** (nhiều/ gói) khác **Danh mục** (đúng 1/ gói). **Phương thức thanh toán** chọn từ danh sách.
20. **Nhắc:** nhiều mốc mỗi gói; giờ nhắc chung trong Cài đặt. Bật PIN không đổi nội dung thông báo.

---

## 4. Màn hình

> Mỗi màn: **light + dark**, khung 390 × 844 chính, kiểm 360 × 800 cho Tổng quan, Thống kê, Form. Vẽ bản tiếng Việt
> cho Tổng quan, Thống kê, Form, Tấm xác nhận (chuỗi VI dài hơn ~30%). Ví dụ số liệu ở §6.

### 4.0 Khởi động
- **Splash:** logo Subnest, < 1 s.
- **Khoá PIN** (nếu bật): 4 ô số + bàn phím số, "Quên mã?" → cảnh báo chỉ có thể **Xoá toàn bộ dữ liệu**. Hiện khi mở
  app và khi quay lại sau > 1 phút.

### 4.1 Onboarding (5 bước, thanh tiến độ)
1. **Ngôn ngữ** — chữ chỉ tiếng Anh, tên ngôn ngữ bản ngữ; English (chọn sẵn) / Tiếng Việt; đổi là đổi toàn app.
2. **Chào mừng** — minh hoạ "tổ" gom thẻ gói; "All your subscriptions, one nest"; 3 lợi ích có icon (nhắc trước khi
   trừ tiền · biết mỗi tháng tốn bao nhiêu · dữ liệu chỉ trên máy). "Bắt đầu" + Bỏ qua.
3. **Tiền tệ chính** — USD chọn sẵn, hai nút một chạm USD / VND + "Chọn tiền tệ khác…" (danh sách ISO có tìm). Một dòng
   giải thích. Bỏ qua.
4. **Bạn đang dùng gì?** — lưới dịch vụ phổ biến **có logo thật**, chọn nhiều, ô tìm kiếm; tile đã chọn có ✓ và chip
   chỉnh nhanh giá/chu kỳ. Thanh dưới "Đã chọn 5 · ≈ $73.96/tháng" + Tiếp tục / Để sau.
5. **Bật nhắc nhở** — thông báo mẫu bằng USD; "Bật nhắc nhở" (rồi hộp thoại hệ thống) / "Không, cảm ơn".
→ vào Tổng quan có dữ liệu (khoảnh khắc "wow": thấy ngay chi phí tháng).

### 4.2 Tổng quan (tab 1, mặc định) — màn quan trọng nhất
Thứ tự từ trên xuống:
1. **Thẻ Chi phí** (thay header số lớn cũ):
   - Segment **Chi phí hàng tháng | Chi phí hàng năm**.
   - Chip chênh lệch: "↓ $4.00 so với thg 10" (giảm = xanh, tăng = cam nhẹ; năm: so với năm trước).
   - Số lớn **≈ $144.89** + nút (i) (giải thích cách tính, luật §3.11–12).
   - "10 gói đăng ký đang hoạt động" · "≈ **$4.83** mỗi ngày".
   - Hai dòng có chấm màu: **Đã thanh toán $41.99** · **Còn phải thanh toán $74.58** + thanh ngang chia hai màu.
   - Dòng nhỏ khoảng ngày của tháng: "1 thg 11 đến 30 thg 11".
   - **Cột 6 tháng** gần nhất (tháng này nổi bật màu thương hiệu); chạm cột → Thống kê mở đúng tháng đó.
   - Chế độ Năm: số năm, trung bình/tháng thay /ngày, cột 6 năm hoặc 12 tháng của năm (Claude Design chọn).
2. **Thẻ Chờ xác nhận** (khi có): "1 khoản cần xác nhận" + logo các gói + "Xem" → §4.7.
3. **Thẻ Dùng thử sắp hết** (dùng thử hết trong 7 ngày; một thẻ mỗi gói, nhiều thì xếp/cuộn ngang):
   - Icon đồng hồ cát + "Dùng thử Spotify kết thúc trong 3 ngày".
   - "Sẽ có giá $11.99 vào 13 thg 11" + chip Hàng tháng.
   - Dòng nhấn: "Huỷ trước khi tính phí sẽ tiết kiệm **$143.88** mỗi năm".
   - **3 nút:** **Giữ lại** (chính — ẩn thẻ cho lần dùng thử này, vẫn nhắc) · **Xem gói đăng ký** (→ Chi tiết) ·
     **Cách huỷ** (mở link hướng dẫn của hãng; không có link → ẩn).
4. **Thẻ Báo đổi giá** (khi có): "Netflix đổi giá: $15.49 → $17.99" + Cập nhật / Giữ giá cũ.
5. **Thanh toán sắp tới**: "30 ngày tới: ≈ $116.57 trong 7 lần tính phí" + "Xem tất cả"; **dải thẻ ngang** mỗi thẻ: logo,
   tên, giá + chip chu kỳ, nhãn thời gian ("Hôm nay" / "Còn 2 ngày"), nút ✓ nhanh (xác nhận đã trả khi tới ngày).
   (Gộp thẻ "Sắp trừ tuần này" cũ — Claude Design quyết dạng tốt nhất.)
6. **Thanh Ngân sách** (khi đã đặt): % tổng đã dùng; chạm → theo danh mục.
7. **Danh sách gói**: tiêu đề + nút sắp xếp (Thanh toán tiếp theo · Giá · Tên · Mới thêm) + tìm kiếm + lọc (Danh mục /
   Nhãn / Trạng thái gồm Tạm dừng / Phương thức thanh toán; app nhớ lọc và sắp xếp). Segment hoặc nhóm: Đang trả ·
   Dùng thử · Tạm dừng · Đã huỷ.
   **Hàng gói:** logo (§8.4) · tên + huy hiệu (DÙNG THỬ / Tự phát hiện) · dòng phụ "Còn 2 ngày · 15 thg 10 · Visa" ·
   chip nhãn · bên phải **giá + chip chu kỳ** (+ "≈ quy đổi" nếu khác tiền tệ chính, ↑ nếu vừa tăng giá) · thanh tiến
   độ mảnh của kỳ. Gói đến hạn hôm nay: nền nhấn nhẹ. Chờ xác nhận: huy hiệu. Chia sẻ: icon người "÷5". Tạm dừng: mờ +
   "Tạm dừng từ 1 thg 12". Đã huỷ: mờ + "Đã huỷ 12/10/2026"; đầu nhóm "Bạn đang tiết kiệm $191.87/năm".
   Vuốt hàng: Xác nhận (nếu chờ) / Huỷ.
8. **Snackbar Hoàn tác** sau khi app tự thêm gói / tự xác nhận kỳ.
9. **FAB "+"** → Thư viện. Tab bar dưới tự ẩn khi cuộn (tuỳ chọn trong Cài đặt).
- **Trạng thái:** rỗng (minh hoạ + "Thêm gói đầu tiên") · có dữ liệu · nhiều kỳ chờ · offline (tỷ giá cũ: nhãn nhỏ) ·
  quyền thông báo tắt (banner "Nhắc nhở đang tắt — Bật lại") · tháng đầu chưa có tháng trước (ẩn chip chênh lệch).

### 4.3 Thư viện dịch vụ (bước 1 của "+")
- Ô tìm kiếm trên cùng, focus sẵn. Hai tab **Chung** (giá US, quy đổi "≈") / **Việt Nam** (VND) — luôn hiện, mở ở Chung.
- Chip danh mục: Tất cả · Video · Nhạc · AI · Lưu trữ · Phần mềm · Game · Đọc · Sức khoẻ · Học tập · Viễn thông · Khác.
- Hàng/lưới: **logo thật** + tên + "từ $8.99" + chip chu kỳ + chip **Giá tham khảo** khi chưa xác minh.
- Đầu danh sách luôn có **"+ Tạo dịch vụ tuỳ chỉnh"**; tìm không thấy → "Không thấy 'abc'? Tạo 'abc'".
- Dịch vụ nhiều gói → bottom sheet chọn gói (tên gói, giá, chu kỳ) trước khi sang Form.
- Chân trang: "Thư viện cập nhật 3 ngày trước".

### 4.4 Form gói (Thêm / Sửa)
1. **Đầu form:** logo lớn + tên (sửa được). Dịch vụ từ thư viện: logo thật. Dịch vụ tự tạo: chữ cái/emoji trên màu,
   chạm → sheet **Đổi biểu tượng**: Chọn màu · Chữ/emoji · **Chọn ảnh** (từ thư viện ảnh của máy → cắt vuông) ·
   Gỡ ảnh.
2. **Giá** + chọn tiền tệ; "≈ 455.000 ₫" nếu khác tiền tệ chính. Khi bật Dùng thử: nhãn "Giá sau dùng thử".
3. **Chu kỳ** "Mỗi [1] [tháng ▾]" + chip nhanh Hằng tuần · Hằng tháng · Hằng quý · Hằng năm.
4. **Ngày thanh toán tiếp theo** + dòng phụ "Sau đó: 15/12, 15/01…".
5. **Đang dùng thử** (toggle → Ngày hết dùng thử).
6. **Chia với người khác** (toggle → stepper số người + "Phần của bạn …").
7. **Danh mục** (chips) · **Nhãn** (nhiều, thêm nhanh).
8. **Nhắc** nhiều mốc: Đúng ngày / 1 / 3 / 7 ngày trước (mặc định theo Cài đặt).
9. *Nâng cao (gập):* Phương thức thanh toán (danh sách + thêm nhanh), Link huỷ/quản lý, Ghi chú, Đáng tiền?.
- Nút lưu cố định dưới. **Sửa giá** → hộp thoại "Áp dụng giá mới từ kỳ tới (15/12)? Các khoản đã trả giữ nguyên" →
  ghi vào Lịch sử giá.

### 4.5 Chi tiết gói
1. **Hero:** logo lớn, tên, chip trạng thái (Đang trả / Dùng thử · còn 3 ngày / Tạm dừng / Đã huỷ / Chờ xác nhận).
2. **Số chính:** "$17.99" + chip Hàng tháng; chia sẻ: "Phần của bạn …"; khác tiền tệ: "≈ …".
3. **Banner** khi cần: Chờ xác nhận (nút Xác nhận) · Báo đổi giá · Gói ngừng bán · Tự phát hiện (Gỡ).
4. **Thẻ thông tin:** Thanh toán tiếp theo (+ còn N ngày) · Chu kỳ · Nhắc · Danh mục · Nhãn · Phương thức thanh toán ·
   Bắt đầu từ · **Tổng đã trả** · Đáng tiền? · Ghi chú.
5. **Lịch sử giá** (mới): danh sách thời gian "15/10/2026 · $15.49 → $17.99 (+$2.50)" — tăng màu cam nhẹ ↑, giảm màu
   xanh ↓, nguồn (Bạn sửa / Thư viện cập nhật / Từ các kỳ đã trả). Rỗng: "Giá chưa từng đổi".
6. **Lịch sử thanh toán:** Đã trả (số thực trả, chạm để sửa; nguồn ảnh chụp nếu tự xác nhận + Hoàn tác) · Không trả ·
   kỳ đang chờ.
7. **Hành động:** Sửa (header) · Cách huỷ (link) · Tạm dừng / Bật lại (sheet chọn ngày) · Đánh dấu đã huỷ (→ màn ăn
   mừng "Tiết kiệm thêm $215.88/năm") · Khôi phục · Xoá (đỏ, cuối trang, hộp thoại xác nhận).

### 4.6 Tấm xác nhận kỳ (bottom sheet)
Logo + "Netflix · kỳ 15/11/2026" · số tiền điền sẵn lớn, sửa được + tiền tệ + chip chu kỳ · **Đã trả** (chính) ·
**Không trả kỳ này** · **Để sau**. Sau Đã trả: check + haptic + "Kỳ tới: 15/12/2026"; còn kỳ cũ → chuyển tiếp
("Còn 1 kỳ chưa xác nhận").

### 4.7 Danh sách Chờ xác nhận
Cũ nhất trước; mỗi hàng logo, tên, ngày, giá + chip chu kỳ, nút ✓ nhanh. Dưới: **"Xác nhận tất cả · $40.00"** (ví dụ khi có 2 kỳ chờ) (hộp
thoại). Rỗng: "Bạn đã xác nhận hết 🎉".

### 4.8 Lịch (tab 2)
- Header: tháng + mũi tên + **tổng tiền trừ thật của tháng** ("Tháng 11: ≈ $116.57").
- Lưới tháng: logo mini của gói mỗi ngày (tối đa 3 + "+2"), hôm nay nổi bật, ngày có kỳ chờ có dấu cảnh báo; tháng qua
  hiện Payment thật (đặc) + kỳ bỏ qua (rỗng), tháng tới hiện dự kiến.
- Chạm ngày → danh sách ngày đó. Chế độ **Danh sách** (agenda) theo dòng thời gian.
- **Mọi hàng giá có chip chu kỳ** (đây là lỗi người dùng phàn nàn: "không biết giá theo tháng hay theo năm").

### 4.9 Thống kê (tab 3) — làm lại
**Bộ chọn:** segment **Tháng | Năm** + `‹ Tháng 11, 2026 ›` (hoặc `‹ 2026 ›`); chạm một cột ở biểu đồ cũng chọn tháng
đó. **Mọi thẻ bên dưới đổi theo khoảng đang chọn** (tháng quá khứ, tháng này, tháng tới đều chọn được; nhãn nhỏ
"Dự kiến" cho tháng tới). Thứ tự thẻ:
1. **Thẻ Chi phí của tháng:** số lớn (luật §3.11) · chênh so với tháng trước · số gói · **≈ X mỗi ngày** · thanh Đã
   thanh toán / Còn phải thanh toán (luật §3.12, với tháng quá khứ chỉ còn Đã trả + Không trả) · (i).
2. **Biểu đồ cột 12 tháng** quanh tháng chọn (cột chọn nổi bật; tháng tới vẽ sọc/nhạt = dự kiến).
3. **Theo danh mục** của tháng chọn: donut + chú thích %, chạm lát → các gói trong danh mục tháng đó.
4. **Đắt nhất** của tháng chọn: top 5 (logo, tên, giá + chip chu kỳ, phần trong tháng).
5. **Tăng giá** (luật §3.14): tiêu đề "Tăng giá" · "Nhiều hơn **$3.50** mỗi tháng so với một năm trước" · "$42.00 mỗi
   năm" · "Netflix thay đổi nhiều nhất" · danh sách gói (logo, tên, "$15.49 → $17.99", "+$2.50", chevron mở chi tiết
   lịch sử giá) · nút **Xem xét Netflix**. Rỗng: "Không gói nào tăng giá trong 12 tháng qua".
6. **12 tháng tới** (luật §3.16): hai thanh "Dự tính ≈ $1,912.40" và "12 tháng qua ≈ $1,487.20"; câu nhấn "≈ **+$425.20**
   mỗi năm so với 12 tháng qua"; bảng tách: "2 gói đăng ký thêm năm nay +$383.76" · "2 gói tăng giá +$42.00" · "Khác
   ≈ −$0.56"; nút **Xem xét [gói góp nhiều nhất]**; "Xem dưới dạng danh sách".
7. **Sắp tới:** segment **13 tuần | 12 tháng**, biểu đồ cột (nhãn Tuần 46… / Thg 12…), "Xem dưới dạng danh sách".
8. **Ngân sách theo danh mục** (khi có): mỗi danh mục một thanh, vượt → đỏ.
9. **Tiết kiệm:** "Bạn đang tiết kiệm $191.87/năm nhờ huỷ 2 gói" + "Bỏ các gói Không đáng tiết kiệm thêm X/năm".
10. *Gợi ý nhẹ:* "Bạn trả 2 dịch vụ nhạc — cần cả hai?".
- Chế độ **Năm**: các thẻ cộng 12 tháng; "≈ X mỗi tháng" thay mỗi ngày; cột = 12 tháng của năm.
- **Trạng thái:** rỗng · tháng chưa có gói (tháng trước khi đăng ký gói đầu) · chỉ có gói năm · đa tiền tệ (≈).

### 4.10 Cài đặt (tab 4) — các nhóm theo thứ tự
1. **Tiền:** Tiền tệ chính · Tỷ giá (danh sách cặp, tự động/đặt tay, cập nhật ngay, ghi đè/khôi phục).
2. **Nhắc nhở:** mốc mặc định, giờ nhắc (9:00), trạng thái quyền + mở cài đặt hệ thống.
3. **Giao diện & ngôn ngữ:** Theo hệ thống / Sáng / Tối · English / Tiếng Việt · tab bar tự ẩn khi cuộn.
4. **Sắp xếp gói:** Danh mục (thêm/sửa tên, màu, biểu tượng; xoá → chuyển gói sang danh mục khác) · Nhãn ·
   Phương thức thanh toán · Ngân sách.
5. **Tự động (Pro):** Quét ảnh (1.0) · Thông báo ngân hàng/ví (sắp có) · Gmail (sắp có). Sheet "Đăng ký sớm" không giá.
6. **Dữ liệu:** khối **Sao lưu tự động** (bật/tắt, thư mục, mật khẩu ≥ 6 ký tự, giờ sao lưu 21:00, lần gần nhất, giữ 2
   file mới nhất) · Sao lưu ngay (file `.subnest`, có/không mật khẩu) · **Khôi phục** (chỉ Thay thế toàn bộ: kiểm file,
   hỏi mật khẩu nếu có, một xác nhận) · Xuất CSV · **Xoá toàn bộ dữ liệu** (2 bước, như mới cài).
7. **Bảo mật:** Khoá mã PIN (đặt / đổi / tắt) · Che nội dung khi chuyển app (chặn chụp màn hình).
8. **Giới thiệu** (thẻ nội tuyến): phiên bản · thư viện cập nhật lúc · bảng giá (US + Việt Nam) · Chính sách quyền
   riêng tư · Điều khoản · Giấy phép · Đánh giá app · Gửi góp ý · dòng nhãn hiệu ("Tên và logo dịch vụ thuộc chủ sở hữu
   tương ứng").
- Cuối trang: "🔒 Dữ liệu của bạn chỉ nằm trên máy này. Subnest không thu thập gì."

### 4.11 Quét ảnh (Pro)
Giới thiệu → (trước bộ chọn ảnh) "Mở trang gói của Google Play / App Store" → chọn nhiều ảnh hoặc chụp hoá đơn → đang
đọc (trên máy) → kết quả "Đã thêm 4 gói, xác nhận 1 kỳ": từng dòng có Hoàn tác, nhóm "Cần bạn kiểm" / "Số tiền khác" /
"Không thêm"; không thấy gì → hướng dẫn chụp lại.

### 4.12 Widget
- **Nhỏ:** gói sắp trả (logo, tên, giá + chu kỳ, "còn 3 ngày"); biến thể kỳ chờ xác nhận; rỗng.
- **Vừa / Lớn:** chi phí tháng + danh sách sắp trả (3 / 6 dòng).
- **PIN bật:** chỉ hiện "Đã khoá bằng PIN". Chạm gói → Chi tiết; chỗ khác → Tổng quan. Sáng/tối, Android + iOS.

### 4.13 Thông báo (mẫu chữ)
| Loại | EN | VI |
|---|---|---|
| Nhắc | "Netflix renews in 3 days — $17.99" | "Netflix gia hạn sau 3 ngày — 260.000 ₫" |
| Hết dùng thử | "Your Spotify trial ends in 3 days. Cancel now if you don't want to be charged." | "Dùng thử Spotify hết sau 3 ngày. Huỷ ngay nếu không muốn bị tính phí." |
| Đến ngày | "Netflix renews today — tap to confirm" | "Hôm nay gia hạn Netflix — chạm để xác nhận" |
| Sao lưu | "Backup saved" (chỉ khi lỗi mới báo) | "Sao lưu lỗi — mở Subnest để kiểm tra" |

---

## 5. Luồng cần prototype
1. Lần đầu: Ngôn ngữ → Chào mừng → Tiền tệ → chọn 5 dịch vụ (logo thật) → Nhắc → Tổng quan có thẻ Chi phí.
2. Thêm gói: "+" → tìm "netf" → Netflix → chọn gói → Form (chia 4 người) → lưu → hàng mới nổi bật nhẹ.
3. Thêm gói tự tạo "Gym" → Đổi biểu tượng → Chọn ảnh → lưu → hàng có ảnh.
4. Xác nhận: thông báo → Tấm xác nhận → Đã trả → thẻ Chi phí cập nhật Đã/Còn.
5. Dùng thử: thẻ Dùng thử sắp hết → Giữ lại (thẻ biến mất) / Xem gói đăng ký / Cách huỷ.
6. **Thống kê theo tháng:** Thống kê → `‹` về Tháng 8 → mọi thẻ đổi (donut, đắt nhất, /ngày) → chạm cột Tháng 12 →
   nhãn Dự kiến.
7. **Giá tăng:** Sửa giá Netflix → hộp thoại áp từ kỳ tới → Chi tiết hiện Lịch sử giá → Thống kê thẻ Tăng giá → Xem xét.
8. Báo đổi giá từ thư viện → Cập nhật.
9. Huỷ: Chi tiết → Cách huỷ → Đánh dấu đã huỷ → ăn mừng Tiết kiệm.
10. Quét ảnh → kết quả → Hoàn tác một dòng.
11. Bảo mật: bật PIN → thoát ra 2 phút → mở lại → nhập PIN.

---

## 6. Dữ liệu mẫu (hôm nay **10/11/2026**)

**Bộ EN — Tiền tệ chính USD** (bộ chính; dùng cho mọi màn EN):

| Dịch vụ | Giá | Chu kỳ | Danh mục | Trạng thái / ghi chú |
|---|---|---|---|---|
| Netflix Standard | $17.99 | tháng | Video | Due 15/11 · **Lịch sử giá:** $15.49 → $17.99 từ 15/10/2026 · Visa ••4821 |
| Spotify Premium | $11.99 | tháng | Nhạc | **Dùng thử, hết 13/11** · PayPal |
| YouTube Premium Family | $22.99 | tháng | Video | Chia 5 → $4.60 · Due 18/11 |
| ChatGPT Plus | $20.00 | tháng | AI | Due 12/11 · **Lịch sử giá:** $19.00 → $20.00 từ 12/03/2026 |
| Claude Pro | $20.00 | tháng | AI | **Chờ xác nhận** (08/11) · đăng ký 08/06/2026 |
| iCloud+ 200 GB | $2.99 | tháng | Lưu trữ | Đã trả 05/11 · Due 05/12 · Apple Pay |
| Gym (tự tạo, **logo ảnh tự chọn**) | $39.00 | tháng | Sức khoẻ | Đã trả 01/11 · Due 01/12 · nhãn "Sức khoẻ" |
| Disney+ | $9.99 | tháng | Video | Due 21/11 · **Tạm dừng từ 21/11** |
| Google One 2 TB | $99.99 | năm | Lưu trữ | Due 20/03/2027 · quy tháng $8.33 |
| Canva Pro | $120.00 | năm | Phần mềm | Due 02/02/2027 · đăng ký 02/02/2026 |
| Duolingo Super | $59.99 | năm | Học tập | **Đã huỷ** 12/10/2026 |
| Apple Music | $10.99 | tháng | Nhạc | **Đã huỷ** 20/10/2026 → Tiết kiệm |

Số ví dụ đã dùng trong §4 (tháng 11/2026): Chi phí tháng ≈ $144.89 (10 gói; gói năm quy tháng, Disney+ vẫn tính vì dừng từ 21/11) · ≈ $4.83/ngày ·
Đã thanh toán $41.99 · Còn phải thanh toán $74.58 (khác Chi phí tháng vì gói năm không gia hạn tháng này) · so với
thg 10 −$4.00 · Tăng giá +$3.50/tháng (Netflix +$2.50, ChatGPT +$1.00). Không cần khớp từng cent — chỉ cần hợp lý và nhất quán giữa các màn.

**Bộ VI — Tiền tệ chính VND** (ảnh tiếng Việt; minh hoạ tab Việt Nam): Netflix Premium 260.000 ₫/tháng (Lịch sử giá
220.000 → 260.000 từ 15/10) · Spotify 65.000 ₫ (dùng thử) · YouTube Premium Gia đình 179.000 ₫ ÷ 5 · ChatGPT Plus
$20 (≈ 527.000 ₫) · Claude Pro 599.000 ₫ (chờ xác nhận) · iCloud+ 89.000 ₫ · Gym 299.000 ₫ (ảnh tự chọn) · Google One
2 TB 1.690.000 ₫/năm · Canva Pro 1.390.000 ₫/năm · Gói cước Viettel 5G 150.000 ₫ · Duolingo Super 699.000 ₫/năm (đã
huỷ). Định dạng: `260.000 ₫` (VI) / `₫260,000` (EN) / `$17.99`.

---

## 7. Định hướng thiết kế

### 7.1 Cảm giác
Sạch, hiện đại, tin cậy như app tài chính nhẹ nhưng thân thiện. **Số tiền lớn, rõ**; mỗi số luôn có ngữ cảnh (chu kỳ,
khoảng thời gian, "≈"). Logo màu của dịch vụ là điểm nhấn trên nền trung tính. Thẻ bo tròn, thoáng; thông tin xếp theo
thứ bậc: số chính → so sánh → chi tiết.

### 7.2 Nền tảng
Light + Dark ngang hàng. Một thiết kế cho Android + iOS (Flutter, Material 3) nhưng tôn trọng thói quen nền tảng
(bottom sheet, tab bar dưới, vuốt quay lại iOS). Khung 390 × 844, kiểm 360 × 800.

### 7.3 Hệ thống
Giữ design system v13 (`design/system/tokens.json`: teal `#0e6b63` / dark `#46cdb9`, Be Vietnam Pro, số tabular, lưới
4/8, bo thẻ ~16, tile ~12, Lucide icons) — **được đề xuất thay đổi nếu tối ưu hơn, kèm lý do** và bảng token mới
(light/dark, hex). Màu ngữ nghĩa: thành công (đã trả, giảm giá, tiết kiệm) · cảnh báo (chờ xác nhận, dùng thử, tăng giá)
· nguy hiểm (xoá, vượt ngân sách). Màu dữ liệu biểu đồ: Đã thanh toán vs Còn phải thanh toán phân biệt rõ cả khi mù màu.
WCAG AA. Chuyển động 150–250 ms: số đếm khi đổi Tháng/Năm/tháng chọn, check khi xác nhận, confetti nhẹ khi huỷ.

### 7.4 Logo dịch vụ (thành phần quan trọng — đổi so với v13)
- **Logo thật** của dịch vụ có trong thư viện (đóng gói sẵn trong app, hiện ngay, không cần mạng). Đặt trên **tấm nền
  tròn hoặc vuông bo** màu nhạt theo màu thương hiệu (Claude Design chọn hình dạng thống nhất) để logo trong suốt/đen/
  trắng đều đọc được ở light và dark.
- Dịch vụ tự tạo: **monogram** (chữ cái/emoji trên màu) hoặc **ảnh người dùng chọn** (cắt vuông, cùng khung).
- Kích thước: 24 (lịch/widget) · 40 (hàng) · 56 (form/thẻ) · 80 (hero). Huy hiệu góc: đồng hồ cát (dùng thử), chấm
  cảnh báo (chờ xác nhận), tạm dừng.
- Nhìn đẹp và phân biệt được khi 10+ logo cạnh nhau.

### 7.5 Truy cập & ngôn ngữ
Vùng chạm ≥ 48 dp; chữ hệ thống 130–200% không vỡ (kiểm 320 dp × 200%); không truyền tin chỉ bằng màu (tăng/giảm
có ↑/↓ + dấu +/−); biểu đồ có nhãn chữ / đọc được bằng TalkBack/VoiceOver; VI dài hơn ~30%.

---

## 8. Bàn giao mong muốn từ Claude Design
1. Mockup Hi-Fi **mọi màn §4**, light + dark, đủ trạng thái; bản VI cho Tổng quan, Thống kê, Form, Tấm xác nhận.
2. Prototype các luồng §5 (ưu tiên 1, 5, 6, 7).
3. Trang hệ thống thiết kế: token (màu light/dark hex, chữ, spacing, radius, bóng), component: thẻ Chi phí, thanh
   Đã/Còn, cột tháng, bộ chọn tháng `‹ ›`, chip chu kỳ, chip chênh lệch, hàng gói, thẻ dùng thử 3 nút, thẻ Tăng giá,
   thẻ 12 tháng tới, dòng Lịch sử giá, logo/tấm nền logo + monogram + ảnh tự chọn, segmented control, bottom sheet, nút
   (chính/phụ/text/nguy hiểm), toggle, stepper, banner, snackbar, empty state, widget.
4. Giữ app icon + splash hiện có (trừ khi đề xuất tốt hơn).
5. Xuất **link claude.ai + file HTML tự chứa** (như v13) + PNG @2x đặt tên `NN-screen-state-mode.png`, ghi rõ màn nào
   mới/đổi so với v13.
