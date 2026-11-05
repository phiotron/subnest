# [A001-subnest] Catalog prices — báo cáo phiên con (2026-11-05)

Phiên điều phối #2 · phiên con "[A001-subnest] Catalog prices". Phạm vi sửa: `assets/catalog/**` + file này.

## Kết quả

| | Trước | Sau |
|---|---|---|
| Phiên bản / ngày | v1 · 2026-11-04 | **v2 · 2026-11-05** |
| Dịch vụ · gói · mức giá | 99 · 229 · 255 | 99 · 242 · 281 |
| Mức giá `approx` | 147 | **114** |

- Giảm 33 mức `approx` (bỏ cờ sau khi đối chiếu), thêm 26 mức giá/13 gói mới đã xác minh (VN có Apple One, Apple TV,
  Crunchyroll, YouTube Student, Gemini Plus US, …).
- Validator `python -I -X utf8 assets/catalog/tool/validate_catalog.py` → **OK** (exit 0). Cảnh báo "ChatGPT Plus VN dùng USD" đã hết vì VN nay bán bằng VND.
- Cách đối chiếu: built-in browser, không đăng nhập, từ IP Việt Nam. Nguồn + ngày nằm trong `note` của từng dịch vụ (schema
  không có trường nguồn riêng cho từng giá). README đã cập nhật bảng nguồn.

## Phát hiện quan trọng (giá cũ SAI dù không bị đánh `approx`)

| Dịch vụ | Cũ | Chính thức 2026-11-05 |
|---|---|---|
| Apple Music US | 10.99 / 16.99 / SV 5.99 | **11.99 / 19.99 / 6.99** |
| Apple One US | 19.95 / 25.95 / 37.95 | **21.95 / 27.95 / 39.95**; VN **có** bán: 239.000 / 279.000đ (không có Premier) |
| Apple TV | US 12.99, VN chưa có | **US 14.99, VN 179.000đ** |
| PlayStation Plus Premium (1 tháng) US | 17.99 | **19.99** |
| Gemini Plus VN | 122.000đ | **132.000đ**; US Plus 4.99; Ultra nay có 5x (VN 2.250.000 / US 99.99) và 20x (VN 5.500.000 / US 199.99) |
| ChatGPT VN | Plus tính USD 20 | **Plus 522.500đ**, Go 132.000đ, Pro 100 = 2.849.000đ, Pro 200 = 5.225.000đ |
| Cursor | Pro 20 / Pro+ 60 / Ultra 200 | **Plus 8 / Premium 30 / Super 100 / Ultra 200** (gói cũ không còn) |
| Claude | Max 5x 100 / Max 20x 200 | **Max 100 / Ultra 200** (giữ id cũ, đổi tên hiển thị) |
| Bitwarden | Premium $10/tháng, Families $40/tháng | **chỉ bán theo năm: $19.80 và $47.88** |
| Canva VN | không có giá VND | **150.000đ/tháng, 1.300.000đ/năm** |
| Google One VN | 100 GB 45.000đ (ước) | 45.000đ ✔; thêm Lite 30 GB 19.000đ; **không có gói 2 TB**, AI Pro nay 5 TB 489.000đ |

Khớp: Netflix (VN 4 gói + US 3 gói), Spotify (VN 65.000 / SV 33.000, **VN không có Duo/Family**; US 4 gói), iCloud+ (VN 5 gói gồm 2 TB 299.000đ; US 5 gói),
Apple Music VN, Xbox Game Pass US (22.99 Ultimate), Microsoft 365 US + VN Family (260.000đ/tháng, 2.599.000đ/năm),
Notion, Proton, Figma, GitHub Copilot (+ Max $100), YouTube Premium VN (Individual 79.000, Family 149.000, Student 49.000, Lite 49.000; trang ghi **chưa gồm VAT**).

## Theo nhóm ưu tiên

**(a) Dịch vụ trong `product.md` §8 + video/nhạc/AI/lưu trữ lớn — đã xác minh hoặc có lý do:**

| Dịch vụ | Trạng thái |
|---|---|
| Netflix, Spotify, Apple Music, iCloud+, Google One (VN), Gemini, Claude, ChatGPT (VN), YouTube Premium (VN), YouTube Music (VN), Canva (VN), Xbox, PS Plus, Microsoft 365, Cursor | ✔ xác minh (vùng ghi trong note) |
| YouTube Premium/Music US, ChatGPT US, Canva US, Google One US | giữ giá cũ: trang chọn vùng theo IP, không xem được US |
| Duolingo | ✘ giữ approx — trang `/super` không hiện giá khi chưa đăng nhập |
| HBO Max | chỉ VN gói năm (699.000 / 949.000đ); gói tháng + US chưa — cookie modal chặn nút chuyển, trang theo IP |
| Hulu, Disney+, Peacock, Paramount+ | ✘ chặn IP ngoài Mỹ ("not available in your region", 406) |
| Prime Video, Tidal, Deezer, Amazon Music, SoundCloud, Copilot, Grok, ElevenLabs | ✘ chưa tra (hết thời gian / trang không hiện giá rõ) |
| Viettel SD90, 5G150 | không đổi (không mở được trang chính thức) |

**(b) Dịch vụ Việt Nam:**

| Dịch vụ | Kết quả |
|---|---|
| Apple/Google/Spotify/Netflix... bán tại VN | ✔ xem ở trên |
| Zing MP3 | trang chỉ ghi "Plus từ 13.000đ/tháng", "Premium từ 41.000đ/tháng" (đã gồm thuế); không có giá từng chu kỳ → giữ 250.000đ/12 tháng **approx** và ghi nghi vấn (156.000đ nếu 13k×12) |
| FPT Play, VieON, TV360, Galaxy Play | ✘ danh sách gói cần đăng nhập/app; URL gói chuyển về trang chủ |
| Viettel/VinaPhone/MobiFone, Internet | ✘ `shop.viettel.vn` không tải được, URL đoán sai → chưa tra |
| Monkey, ELSA, zCloud, Bkav, Voiz | ✘ chưa tra |

**(c)** phần còn lại (VPN, Adobe, Zoom, Evernote, sức khoẻ, game phụ, X/Telegram/LinkedIn/Snapchat…): chỉ tra Bitwarden, Todoist (gói năm), Proton, Figma, Grammarly (gói năm). NordVPN/Surfshark chỉ có giá khuyến mãi 27 tháng nên giữ approx.

## Lệch giữa `product.md` §8 (dữ liệu mockup) và giá chính thức — phiên điều phối cân nhắc

| Dòng mockup | Giá mockup | Chính thức |
|---|---|---|
| Netflix Premium | 260.000đ | 273.000đ |
| Spotify Premium | 59.000đ | 65.000đ |
| YouTube Premium Family | 179.000đ | 149.000đ (chưa VAT) |
| ChatGPT Plus | $20 ≈ 508.000đ | VN: 522.500đ (VND) |
| iCloud+ 200GB | 59.000đ | 89.000đ |
| Google One 2TB | 1.690.000đ/năm | VN không bán 2 TB (100 GB 45.000đ/tháng) |
| Canva Pro | 1.390.000đ/năm | 1.300.000đ/năm |
| Apple Music | 65.000đ | 65.000đ ✔ |
| Viettel 5G150 | 150.000đ | chưa xác minh |
| Duolingo Super | 699.000đ/năm | chưa xác minh |

Chỉ là dữ liệu mẫu mockup nên không bắt buộc sửa, nhưng nếu demo/ảnh store dùng các số này thì nên dùng giá catalog.

## Việc dở / rủi ro

- **`cancelUrl`: chưa sửa link nào** (chưa thử từng link huỷ trực tiếp vì thời gian). Việc tiếp theo: kiểm từng URL, ưu tiên Netflix/Spotify/Apple/YouTube/ChatGPT.
- **Giá US còn thiếu kiểm** cho dịch vụ bị khoá theo IP (YouTube, ChatGPT, Canva, Google One, HBO Max…). Cần IP Mỹ hoặc máy có VPN (xem đề xuất).
- Giá VN của YouTube/Crunchyroll… trên trang **chưa gồm VAT**; catalog đang để giá niêm yết. App nên ghi chú "chưa gồm thuế" hoặc người dùng tự sửa (đã là gợi ý điền sẵn).
- Cursor/Claude/ChatGPT đổi cơ cấu gói mạnh trong 2026 → nên tra lại mỗi quý.
- `YouTube Music`: thứ tự Individual/Family/Student suy từ thứ tự trên trang (65k/99k/35k), chưa nhìn nhãn từng thẻ.
- Cờ `approx` chưa có trường "ngày tra" riêng; nguồn/ngày chỉ nằm trong `note` (dạng văn bản) — khó máy đọc.

## Đề xuất cải tiến xưởng

1. **Tra giá = quy trình riêng, 2 lượt:** (1) lượt VN (IP Việt Nam, trình duyệt), (2) lượt US cần IP Mỹ (VPN/máy khác/Chrome của người dùng). Ghi vào PLAYBOOK mục "dữ liệu giá".
2. **Ưu tiên URL có mã vùng** (`/us/`, `/vn/`, `en-US`): xem được cả hai vùng không cần VPN. Giữ danh sách "URL giá chính thức" trong catalog (trường mới `pricingUrl` hoặc file `sources.json`) để lần sau không phải mò lại — lần này mất nhiều lượt đoán URL.
3. **Thêm vào schema** `Price.verifiedAt` (YYYY-MM-DD) + `source` (URL) thay cho `approx` boolean: máy đọc được, app/CI có thể tự cảnh báo giá quá 90 ngày. Validator thêm cảnh báo "giá chưa tra > 1 quý".
4. **Dò bằng JS, không đọc cả trang:** `document.body.innerText.match(/\$\d/)` + cắt 1 đoạn rồi mới đọc kỹ — nhanh hơn `get_page_text` nhiều lần; trang giá có nút Monthly/Yearly cần bấm toggle (sau khi từ chối cookie).
5. **Cookie modal** chặn toggle ở HBO Max: nên xử lý bằng "Manage Cookies → Reject" trước, hoặc chấp nhận bỏ qua ngay (đừng đoán nút).
6. **Đừng tin giá "ổn định" chưa kiểm**: nhiều mức không gắn `approx` hoá ra lỗi thời (Apple Music/Apple One/Apple TV US, PS Premium, Gemini Plus VN, Cursor, Bitwarden) — nên coi mọi giá chưa có nguồn chính thức + ngày là chưa xác minh.
7. **Cập nhật catalog theo quý** như một mục TASKS lặp lại; sau này cân nhắc catalog tải từ xa (S3 đã gợi ý `version`) để sửa giá không cần phát hành app.
8. Đưa script áp dụng thay đổi (đọc JSON → sửa theo hàm `setp/addplan` → ghi lại + validator) vào `playbook/templates/` — chạy lại được, diff gọn, tránh gõ tay JSON.
