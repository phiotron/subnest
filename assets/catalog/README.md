# Catalog (Thư viện dịch vụ) — dữ liệu & schema

`services.json` là danh sách **Service** dựng sẵn kèm **giá gợi ý** để người dùng thêm Subscription bằng một chạm
(xem `CONTEXT.md`: Service, Catalog, Billing cycle; `product.md` §5 S3, §7.4).

- **Ngày khảo sát giá:** 2026-11-05 (`priceSurveyDate`; đợt tra đầu 2026-11-04, đối chiếu trang chính thức bằng trình duyệt
  2026-11-05, đợt tra giá US bằng WebSearch 2026-11-05).
  **Phiên bản dữ liệu:** `version` = 3.
- **Số lượng:** 99 dịch vụ · 245 gói · 284 mức giá (37 mức gắn `approx: true`).
- **Không có logo:** app vẽ tile monogram từ `color` + `monogram`. Tên dịch vụ chỉ dùng để nhận diện;
  `color` là màu gần đúng với màu đặc trưng, không phải tài sản thương hiệu.
- **Kiểm tra:** `python assets/catalog/tool/validate_catalog.py` (chỉ dùng thư viện chuẩn, exit 0 = hợp lệ).

## Schema

### Gốc

| Trường | Kiểu | Bắt buộc | Ý nghĩa |
|---|---|---|---|
| `version` | int ≥ 1 | ✔ | Tăng khi đổi dữ liệu, để app biết catalog mới (sau này có thể tải qua mạng). |
| `updatedAt` | `YYYY-MM-DD` | ✔ | Ngày sửa file lần cuối. |
| `priceSurveyDate` | `YYYY-MM-DD` | | Ngày tra giá lần cuối. App có thể ghi "giá tham khảo tháng 11/2026". |
| `regions` | object `{REGION: CURRENCY}` | | Tiền tệ mặc định của mỗi vùng có giá (`VN → VND`, `US → USD`). |
| `services` | Service[] | ✔ | Danh sách dịch vụ, đã xếp theo danh mục. |

### Service

| Trường | Kiểu | Bắt buộc | Ý nghĩa |
|---|---|---|---|
| `id` | slug `^[a-z0-9]+(-[a-z0-9]+)*$` | ✔ | Khoá ổn định, **duy nhất**, không bao giờ đổi/tái sử dụng (Subscription lưu id này). |
| `name` | string | ✔ | Tên hiển thị (giống nhau EN/VI). |
| `category` | enum | ✔ | Một trong `video, music, ai, storage, software, gaming, reading, health, education, telecom, other` — khớp hàng chip ở S3. |
| `color` | `#RRGGBB` | ✔ | Nền tile. App tự chọn chữ đen/trắng theo độ tương phản. |
| `monogram` | 1–2 ký tự | ✔ | Chữ trên tile. Cặp (`color`, `monogram`) không trùng giữa các dịch vụ. |
| `market` | `global` \| `vn` | | `vn` = dịch vụ của Việt Nam (gợi ý xếp lên đầu khi máy ở VN). Thiếu = `global`. |
| `aliases` | string[] (chữ thường) | ✔ | Từ khoá tìm kiếm thêm, gồm tiếng Việt **không dấu** ("nghe nhac", "luu tru"). App nên so khớp sau khi bỏ dấu cả câu tìm. |
| `cancelUrl` | https URL \| null | ✔ | Trang huỷ (hoặc hướng dẫn huỷ chính thức). |
| `manageUrl` | https URL \| null | ✔ | Trang quản lý gói/tài khoản. |
| `plans` | Plan[] (≥ 1) | ✔ | Các gói; gói đầu tiên là gói mặc định khi chỉ chọn nhanh. |
| `note` | string (tiếng Việt) | | Ghi chú cho người bảo trì dữ liệu (nguồn, độ chắc chắn). **Không hiển thị** trong app. |

### Plan

| Trường | Kiểu | Bắt buộc | Ý nghĩa |
|---|---|---|---|
| `id` | slug | ✔ | Duy nhất trong service. |
| `name` | string | ✔ | Tên gói (giữ tên gốc của nhà cung cấp, vd "Premium", "SD90"). |
| `cycle` | `{unit, count}` | ✔ | Billing cycle: `unit` ∈ `day, week, month, year`; `count` int ≥ 1. Vd gói nhà mạng = `{day, 30}`, NYT = `{week, 4}`, Nintendo 3 tháng = `{month, 3}`. |
| `prices` | `{REGION: Price}` | ✔ | Giá theo vùng (mã ISO 3166-1: `VN`, `US`). **Thiếu vùng = không có số liệu đáng tin**, không phải miễn phí. |
| `members` | int ≥ 2 | | Số người tối đa của gói chia sẻ (Family/Duo) → gợi ý sẵn "Chia với N người" (Shared plan). |

### Price

| Trường | Kiểu | Bắt buộc | Ý nghĩa |
|---|---|---|---|
| `currency` | ISO 4217 | ✔ | `VND`, `USD`… Thường bằng tiền tệ mặc định của vùng, nhưng có thể khác (vd ChatGPT Plus ở VN tính USD). |
| `amount` | number > 0 | ✔ | Đơn vị tiền **chính** (không phải xu): `74000` = 74.000đ, `12.99` = $12.99. VND luôn số nguyên. Tối đa 2 chữ số thập phân. |
| `approx` | bool | | `true` = giá chưa chắc (nguồn thứ ba, không ghi ngày, mâu thuẫn hoặc có thể đã đổi). Thiếu = có ≥ 1 nguồn 2026 nhất quán. |

### Gợi ý dùng trong app

- Giá chỉ là **gợi ý điền sẵn** — người dùng luôn sửa được (product.md S4).
- Chọn vùng theo locale máy. **Không có giá vùng của máy → dùng giá `US` (USD)**: phần lớn dịch vụ quốc tế bán
  cho người Việt bằng USD trên web. Mua qua App Store/Google Play thường ra giá VND khác.
- Không hiển thị cờ `approx` cho người dùng ở bản 1; nó dành cho việc cập nhật dữ liệu.
- "từ X/tháng" ở S3 = gói rẻ nhất quy tháng (theo `cycle`) trong vùng đang chọn.

## Nguồn & độ tin cậy

### Đã đối chiếu trên trang chính thức (2026-11-05)

Dùng trình duyệt không đăng nhập, từ IP Việt Nam. Trang nào có đường dẫn theo vùng (`/us/`, `/vn/`, `/en-US/`…)
thì xem được cả VN và US; trang chọn vùng theo IP chỉ xem được giá VN. Nguồn cụ thể của từng dịch vụ nằm trong
`note` của dịch vụ đó. Giá mức này **không** còn `approx`.

| Dịch vụ | Vùng đã xác minh |
|---|---|
| Netflix, Spotify, Apple Music/TV/One, iCloud+, Gemini/Google AI, Microsoft 365 | VN + US |
| Xbox Game Pass, PlayStation Plus, Cursor, Claude, GitHub Copilot, Notion, Proton, Figma, Bitwarden | US |
| YouTube Premium/Music, ChatGPT, Google One, Canva, Crunchyroll, HBO Max (gói năm) | VN |

### Đợt 2026-11-05 (b): giá US & VN tra bằng WebSearch (vùng Mỹ)

Công cụ WebSearch trả kết quả theo vùng Mỹ nên đọc được giá US của các hãng chọn vùng theo IP. Chỉ nhận số khi có trang
chính thức/trang trợ giúp của hãng hoặc ≥ 2 nguồn uy tín 2026 khớp nhau; URL nguồn nằm trong `note` của từng dịch vụ.
Đã bỏ `approx` (và sửa số nếu lệch) cho: YouTube Premium/Music/TV, HBO Max, Hulu, Peacock, Paramount+, Crunchyroll, Tidal,
Deezer, Amazon Music, ChatGPT Go, Grok, ElevenLabs, Backblaze, Adobe (CC Pro, Photography), NordVPN, ExpressVPN, Grammarly,
CapCut US, Todoist, Evernote (đã đổi sang Starter/Advanced), EA Play, Ubisoft+, GeForce NOW, Twitch Turbo, Audible, Everand,
Headspace/Calm (gói năm), MyFitnessPal, Fitbit Premium, Peloton App+, LinkedIn Premium, Quizlet, Snapchat+ (tháng);
VN: FPT Play, Galaxy Play, TV360, Monkey, ELSA (6 tháng/1 năm), Viettel MXH100, VinaPhone BIG90/120, MobiFone KC90/TK135,
Internet Viettel/FPT/VNPT (giá sàn), Zing MP3 Premium 12 tháng (gói mới).

### Chưa đối chiếu được (giữ `approx`, lý do ở `note`)

- **Giá khuyến mãi/mâu thuẫn giữa các trang:** Surfshark (hai trang chính thức khác nhau), SoundCloud Go+, Zoom, Blinkist,
  Prime Video Ultra (giá tổng suy ra), Bkav Pro (giá hãng cũ), Elsa Premium.
- **Giá chỉ hiện sau đăng nhập/trong app:** Duolingo (VN+US), VieON, Voiz, zCloud, Telegram Premium, Snapchat+ (năm),
  Headspace/Calm (gói tháng), Peloton App One.
- **Cơ cấu gói đang đổi:** Copilot Pro (ngừng bán mới), X Premium (chuyển sang "The X Subscription").
- **Trang không truy cập được qua công cụ tra:** NYTimes, Adobe Photoshop/Acrobat lẻ (giá nạp động), CapCut VN, ELSA US.
- Giá VN của YouTube/Crunchyroll… trên trang ghi **chưa gồm VAT/thuế**; số trong catalog là giá niêm yết.

### Nguồn đợt khảo sát đầu (2026-11-04, nguồn thứ ba)

Giá lấy từ: thông báo/tin tức về đợt đổi giá 2025–2026, trang tổng hợp của nhà bán lẻ VN, mục mua trong ứng dụng
trên App Store VN, và hiểu biết sẵn có cho các giá ổn định lâu năm. Những mức không chắc đều gắn `approx: true`,
lý do ghi trong `note`. Các dòng dưới đây có thể đã được thay bằng giá chính thức ở bảng trên.

| Nhóm | Nguồn chính |
|---|---|
| Netflix VN/US | finhay.com.vn/cac-goi-netflix (VN, gồm VAT 10% từ 07/2025); mekongasean.vn (tăng giá 1/7); tin CNBC/Tom's Guide về đợt tăng US 03/2026 |
| YouTube Premium/Music | fptshop.com.vn (VN 79.000/149.000đ, Lite 49.000đ từ 08/2026); phonearena.com, techadvisor.com (US tăng 04/2026) |
| Disney+, HBO Max, Hulu, Peacock, Paramount+, Prime Video | wdwmagic.com, droid-life.com (Disney+ 09/2026); tomsguide.com "What streaming costs in 2026"; dealnews.com (HBO Max 10/2025) |
| Spotify | spotify.com/vn/premium (VN 65.000đ, Student 33.000đ); vietnamnet.vn (tăng 10,2% tại VN); macrumors.com 2026-01-15 (US) |
| Apple Music, iCloud+ | finhay.com.vn/cac-goi-apple-music; fptshop.com.vn/tin-tuc/danh-gia/gia-icloud-cac-goi-211852, news.tuoitre.vn (iCloud VN tăng ~06/2026); support.apple.com/108047 (US) |
| Google One / Gemini | one.google.com/about/plans (US); e.vnexpress.net 09/2025 (Google AI Plus/Pro/Ultra VN) |
| ChatGPT | e.vnexpress.net (Go tại VN 10/2025); cellphones.com.vn, fptshop.com.vn (Plus qua App Store ~499.000đ) |
| Xbox, PlayStation | tech-insider.org, pushsquare.com (đổi giá 2025–2026, nguồn thứ ba) |
| FPT Play, VieON, Galaxy Play, TV360, Zing MP3, Monkey, Bkav, zCloud, CapCut | App Store VN; fptshop.com.vn; didongviet.vn; hacom.vn; vnreview.vn; viettelstore.vn |
| Duolingo, ELSA | cellphones.com.vn/sforum/super-duolingo; vn.elsaspeak.com, cellphones.com.vn/sforum/elsa-speak |
| Viettel, VinaPhone, MobiFone | viettelstore.vn, cellphones.com.vn (SD90, 5G150, MXH); homecredit.vn, xtmobile.vn (BIG90/120, KC90, TK135) |
| Internet FPT/VNPT/Viettel | phongvu.vn, news.laodong.vn (giá sàn 190.000–195.000đ); chogia.vn 2026-08-07 |
| AI/phần mềm/sức khoẻ/học tập quốc tế còn lại | trang giá chính thức của từng hãng theo hiểu biết đến giữa 2026 — phần lớn gắn `approx` |

### Cố ý KHÔNG đưa vào (thiếu giá đáng tin hoặc dịch vụ không còn)

- **K+** — ngừng phát sóng từ 2026-01-01 (znews.vn, doanhnhan.baophapluat.vn).
- **NhacCuaTui, Waka, Fonos, iQIYI, WeTV, MyTV** — không tìm được giá VND hiện hành đáng tin (chỉ có giá đại lý
  cũ, giá storefront nước khác hoặc gói combo). Thêm lại khi tra được trên app/web chính thức.

## Cập nhật dữ liệu

1. Sửa trực tiếp `services.json` (giữ thứ tự theo danh mục; **không đổi `id`** đã phát hành).
2. Tăng `version`, cập nhật `updatedAt` (và `priceSurveyDate` nếu tra lại giá); bỏ `approx` khi đã xác minh.
3. Chạy `python assets/catalog/tool/validate_catalog.py` → phải in `OK`.
4. Nên tra lại giá **mỗi quý** — streaming/AI đổi giá 1–2 lần/năm (xem danh sách ưu tiên trong
   `notes/2026-11-04-catalog.md`).
