# [A001-subnest] Catalog US prices — báo cáo phiên con (2026-11-05)

Phiên điều phối #2 · phiên con "[A001-subnest] Catalog US prices". Phạm vi sửa: `assets/catalog/**` + file này.

## Kết quả

| | Trước | Sau |
|---|---|---|
| Phiên bản | v2 | **v3** (updatedAt/priceSurveyDate 2026-11-05) |
| Dịch vụ · gói · mức giá | 99 · 242 · 281 | 99 · 245 · 284 (thêm 3 gói đã xác minh: Zing Premium 12 tháng, Evernote Advanced tháng/năm) |
| Mức giá `approx` | 114 | **37** (mục tiêu ≤ 40 ✔) |

Validator `python -I -X utf8 assets/catalog/tool/validate_catalog.py` → **OK** (exit 0). `flutter test` xanh (642 pass, 96 skip).

### Số approx trước → sau theo nhóm

| Nhóm | Trước | Sau | Còn lại |
|---|---|---|---|
| video | 23 | 2 | Prime Video Ultra (US, giá tổng suy ra), VieON VIP |
| music | 9 | 2 | SoundCloud Go+ (US), Zing MP3 Plus 12 tháng |
| ai | 5 | 1 | Copilot Pro (ngừng bán mới) |
| storage | 5 | 3 | zCloud ×3 (VN) |
| software | 16 | 7 | Adobe Photoshop & Acrobat Pro lẻ, Surfshark tháng, CapCut VN, Zoom ×2, Bkav Pro |
| gaming | 8 | **0** | — |
| reading | 5 | 3 | NYTimes, Voiz FM, Blinkist |
| health | 10 | 3 | Headspace tháng, Calm tháng, Peloton App One |
| education | 15 | 9 | Duolingo ×6 (VN+US), ELSA US ×2 + Premium VN |
| telecom | 9 | 1 | FPT Internet "Gia đình 500 Mbps" |
| other | 9 | 6 | X Premium ×3, Telegram Premium ×2, Snapchat+ năm |
| **Tổng** | **114** | **37** | |

Mọi dịch vụ nhóm video/nhạc/AI/lưu trữ đã có giá US xác minh **hoặc lý do** (bảng "Còn approx" bên dưới).

## Phát hiện: giá cũ SAI (nhiều mức lệch lớn so với giá hiện hành)

| Dịch vụ | Cũ (catalog v2) | Hiện hành 2026-11 |
|---|---|---|
| Peacock | 10.99 / 16.99 | **12.99 / 19.99** (từ 18/08/2026) |
| Hulu | 11.99 / 18.99 | **12.49 / 21.49** (từ 23/09/2026) |
| Crunchyroll | 7.99 / 11.99 / 15.99 | **9.99 / 13.99 / 17.99** (02/2026) |
| Prime Video ad-free | add-on 2.99 | **Prime Video Ultra add-on 4.99** (từ 10/04/2026) |
| Tidal | 10.99 / 16.99 | **11.99 / 19.99** |
| Amazon Music | 11.99 (thường) / 10.99 (Prime) | **12.99 / 11.99** |
| YouTube Music US | 10.99 | **11.99** (04/2026) |
| LinkedIn Premium | Career 29.99 / Business 59.99 | **39.99 / 69.99** |
| Todoist Pro (tháng) | 5 | **7** (từ 10/12/2025) |
| NordVPN Basic (tháng) | 12.99 | **14.99** |
| ElevenLabs Starter | 5 | **6** |
| Evernote | Personal 14.99 / 129.99 | **Starter 14.99 / 99; Advanced 24.99 / 249.99** (Personal đã ngừng) |
| FPT Play | MAX 99k / VIP 139k / V.VIP1 155k | **88k / 120k / 130k** |
| TV360 Standard | 25.000đ / 30 ngày | **60.000đ/tháng** (từ 15/05/2026) |
| ELSA Pro 1 năm (VN) | 1.095.000 (giá gốc) | 985.000 (giá ưu đãi niêm yết) |

Khớp (chỉ gỡ `approx`): HBO Max (10.99/18.49/22.99), Paramount+ (8.99/13.99), YouTube Premium Student/Lite US (8.99/8.99), YouTube TV 82.99, ChatGPT Go 8, Backblaze 9/99, Adobe CC Pro 69.99 + Photography 14.99, ExpressVPN 12.95, Grammarly 30, CapCut US 19.99, EA Play, Ubisoft+, GeForce NOW, Twitch Turbo, Audible 8.99, Everand 11.99, MyFitnessPal, Fitbit Premium, Headspace/Calm gói năm, Peloton App+ 28.99, Quizlet, Snapchat+ tháng, Deezer, Galaxy Play, Monkey, Viettel MXH100, VinaPhone BIG90/120, MobiFone KC90/TK135, Internet Viettel/FPT/VNPT (giá sàn).

## Còn approx (37 mức) — lý do

| Dịch vụ | Lý do |
|---|---|
| Prime Video Ultra US (13.98) | Add-on 4.99 có ≥ 2 nguồn; 8.99 giá Prime Video lẻ lấy từ trang trợ giúp Amazon không ghi ngày → tổng suy ra |
| SoundCloud Go+ | Trang chính thức không ghi ngày; mâu thuẫn 10.99 / 11.99; có thông báo tăng giá sau 28/02/2026 nhưng không nêu số |
| Copilot Pro | Ngừng bán mới (thay bằng Microsoft 365 Premium $19.99) — giữ, không xoá |
| Surfshark tháng | Hai trang chính thức mâu thuẫn (15.45 vs 16.45) — đã chọn số mới hơn |
| Zoom Pro (tháng/năm) | Trang zoom.us ghi 16.99 / 14.16; trang sản phẩm ghi 15.99 / 159.90 |
| Adobe Photoshop, Acrobat Pro | Trang Adobe nạp giá động, công cụ tra không đọc được |
| NYTimes | nytimes.com bị chặn với công cụ tra; chỉ có tổng hợp ~25 |
| Blinkist | Trang giá tự mâu thuẫn (79.99/99.99/174.99 gia hạn) |
| Headspace/Calm tháng, Peloton App One | Không tìm thấy giá tháng/giá hiện hành trên trang hãng |
| Telegram Premium | Giá theo mã vùng số điện thoại + kênh mua; chỉ nguồn 2022–2024 |
| Snapchat+ năm | Chỉ xác nhận gói tháng (TechCrunch 02/2026) |
| X Premium ×3 | X đang chuyển sang "The X Subscription" (10/2026), cơ cấu gói đổi |
| Duolingo ×6, ELSA US ×2 | Giá chỉ hiện sau đăng nhập/trong app; nguồn tổng hợp mâu thuẫn |
| ELSA Premium VN | 1.716.000 (catalog) vs 799k–999k (nguồn khác) |
| VieON, Voiz FM, zCloud ×3, Zing Plus 12 tháng | Giá gói không công khai khi chưa đăng nhập / chỉ có "từ X" |
| CapCut VN | Nguồn VN mâu thuẫn 199.000–290.000 |
| Bkav Pro | Đã đổi sang giá hãng 299.000 (trang không ghi ngày) — đại lý từng 189.000 |
| FPT Internet "Gia đình 500 Mbps" | Không tìm được số khớp (GIGA/SKY 195k, META 295k) |

Không gói nào bị ngừng bán hoàn toàn trong đợt này (Copilot Pro chỉ ngừng bán mới; Evernote Personal đã thành Starter; gói Photography 20GB của Adobe không còn bán mới) → **không xoá dịch vụ nào**, ghi trong `note`.

## Nguồn dùng (chi tiết URL trong `note` từng dịch vụ)

- **Chính thức/trợ giúp của hãng** (qua WebSearch giới hạn `allowed_domains` — kết quả trích từ chính trang đó): help.hbomax.com, hulu.com, disneyplus.com, tv.youtube.com, support.google.com/youtube, amazon.com (FAQ + Music), backblaze.com, helpx.adobe.com, nordvpn.com/pricing, expressvpn.com/order-pricing, support.grammarly.com, capcut.com/pricing, todoist.com, ea.com, store.ubisoft.com, NVIDIA newsroom, audible.com, everand.com, help.headspace.com, calm.com, myfitnesspal.com, fitbit.com, support.onepeloton.com, premium.linkedin.com, twitch.tv/turbo, tidal.com, deezer.com/us, elevenlabs.io/pricing, x.ai/pricing, help.evernote.com, openai.com/index/introducing-chatgpt-go.
- **≥ 2 nguồn báo chí 2026 khớp:** Peacock (tvline, droid-life, cordcuttersnews, AP), Paramount+ (AP, techradar), Crunchyroll (thewrap, alternativeto, finalweapon, superherohype), Hulu No Ads (variety, deadline, cordcuttersnews), YouTube Lite/Music (9to5google, androidcentral, tomsguide), Prime Video Ultra (9to5google, pulse2, ppc.land).
- **VN (trang chính thức tìm qua WebSearch):** fpt.vn, galaxyplay.vn, viettel.vn, vnpt.vn, mobifone.vn, monkey.edu.vn, elsaspeak.vn, zingmp3.vn.

## Cách làm & độ tin cậy

- WebSearch trả **bản tóm tắt** từ trang, không phải HTML thô → mọi số đều qua tay công cụ; vì vậy chỉ nhận khi trang chính thức hoặc ≥ 2 nguồn khớp, số mâu thuẫn giữ approx. Không đăng nhập, không điền form, không dùng built-in browser trong đợt này.
- Một số trang chính thức hiện bản cache cũ (tuổi trang ghi trong kết quả); số lấy từ đó (HBO Max help, Deezer US, Galaxy Play) khớp thêm ≥ 1 nguồn 2026 hoặc catalog cũ nên chấp nhận, nhưng nên kiểm lại khi có IP Mỹ.
- Giá VN vẫn chưa gồm VAT/thuế theo trang của YouTube/Crunchyroll (xem README).

## Đề xuất cải tiến xưởng (tra giá theo vùng cho app sau)

1. **Bộ đôi công cụ cố định:** WebSearch (vùng Mỹ) cho giá US + built-in browser (IP VN) cho giá VN. Dùng `allowed_domains` = tên miền hãng khiến kết quả trích thẳng từ trang chính thức — hiệu quả hơn nhiều so với tìm tự do (tự do ra toàn trang spam/cũ). Ghi vào PLAYBOOK mục "dữ liệu giá".
2. **Truy vấn mẫu theo vùng:** US = WebSearch + `allowed_domains`; VN = trang tiếng Việt của hãng (`vn.`/`.vn`) cũng tra được bằng WebSearch (nhà mạng, FPT, Viettel, Monkey, ELSA đều có). Thử WebSearch trước, trình duyệt chỉ khi cần.
3. **Schema:** thêm `Price.verifiedAt` + `Price.source` (URL) thay cho `approx` boolean — hiện nguồn nằm trong `note` dạng văn bản nên không máy đọc được; validator nên cảnh báo giá > 90 ngày. Thêm trường `pricingUrl` ở cấp dịch vụ (trang giá chính thức) để lần sau khỏi mò.
4. **Gỡ `approx` có tiêu chí:** (a) trang chính thức/trợ giúp hãng, hoặc (b) ≥ 2 nguồn 2026 khớp; còn lại giữ cờ + ghi lý do. Đừng gỡ cờ vì "ổn định lâu năm" — đợt này 25 mức đã sai giá.
5. **Lưu ý cơ cấu gói đổi:** Copilot Pro, X Premium, SuperGrok, Evernote Personal, Prime Video ad-free đều đổi tên/ngừng trong 2026 → chuẩn hoá trường `status` (`active` / `closed-to-new` / `renamed`) trong schema để app ẩn gói cũ nhưng giữ id.
6. **Script áp dụng thay đổi:** viết script Python `setp/note/addplan` (như phiên này) và lưu vào `playbook/templates/` — diff JSON gọn, chạy lại được, in bảng thay đổi giá.
7. **Tra theo quý** (TASKS lặp lại); nhóm ưu tiên: streaming, AI, VPN, nhà mạng. Cân nhắc catalog tải từ xa để sửa giá không cần phát hành app.
8. **Giới hạn đã biết của WebSearch:** một số tên miền bị chặn (nytimes.com, theverge.com, cnet.com) và gây lỗi cả lệnh nếu để trong `allowed_domains`; trang nạp giá bằng JS (Adobe, một phần Zoom) không đọc được → dùng trình duyệt hoặc IP Mỹ.

## Kiểm thử

`flutter test` (toàn bộ dự án, sau khi sửa catalog): **+642 ~96 (skip) — All tests passed**, exit 0. Validator: OK.
