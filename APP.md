# A001-subnest · Subnest: Subscription Tracker — APP.md

> Brief + trạng thái của app. **Chỉ phiên điều phối sửa file này**; phiên con ghi báo cáo vào `notes/`.
> Spec sản phẩm/giao diện: `product.md` · Thuật ngữ: `CONTEXT.md` · Quyết định khó đảo: `docs/adr/`.

## Brief
- **Mã app / thư mục:** `A001-subnest` → `apps/A001-subnest/` — đã ghi trong `apps/REGISTRY.md`
- **Bundle ID** (không đổi sau khi phát hành): `com.phiotron.subnest`
- **Một câu mô tả:** Theo dõi mọi subscription, nhắc trước khi bị trừ tiền/hết dùng thử, tổng chi đa tiền tệ — offline, không thu thập dữ liệu.
- **Người dùng mục tiêu:** 18–40 tuổi, nhiều dịch vụ số, hay quên huỷ dùng thử, chia gói Family. Toàn cầu, EN + VI.
- **App gốc để cạnh tranh:** Bobby (chỉ iOS), Tilla (chỉ Android). Lợi thế: cross-platform, VI/VND, gói chia sẻ, xác nhận từng kỳ, Tiết kiệm.
- **Kiếm tiền:** miễn phí hoàn toàn ở bản 1 (không ads, không IAP). Pro/IAP xét ở bản sau.
- **Nền tảng:** Android + iOS · **Stack:** Flutter (3.47 có sẵn trên máy) · iOS build trên macOS runner của GitHub Actions.
- **Quyền riêng tư:** không tài khoản, không analytics/crash SDK → store khai "No data collected". Mạng chỉ dùng để lấy tỷ giá.

## MVP (bản 1.0)
1. F1 Thêm/sửa/xoá Subscription (chu kỳ N ngày/tuần/tháng/năm, Trial, Gói chia sẻ, danh mục)
2. F2 Tổng chi tháng/năm đa tiền tệ, tỷ giá tự cập nhật hằng ngày + ghi đè
3. F3 Nhắc trước Due date (mặc định 3 ngày, 9:00) và trước khi hết Trial
4. F4 Xác nhận từng kỳ (Due date đứng yên tới khi xác nhận — ADR 0001) + Lịch
5. F5 Thư viện ~100 dịch vụ
6. F6 Thống kê & biểu đồ
7. F7 Sao lưu/khôi phục JSON + xuất CSV
8. F8 *(stretch)* Widget màn hình chính — chỉ làm nếu kịp ở cuối phiên #2, không thì bản 1.1

> Vượt luật "MVP ≤ 5" của Playbook v0 — người dùng chấp nhận vì F5–F7 nhỏ và chia song song được; widget là phần cắt đầu tiên.

## Màn hình & luồng chính
Chi tiết ở `product.md` §4–§6: S1 Onboarding (3 bước + thêm nhanh) · S2 Tổng quan · S3 Thư viện · S4 Form · S5 Chi tiết ·
S6 Tấm xác nhận · S7 Chờ xác nhận · S8 Lịch · S9 Thống kê · S10 Cài đặt · S11 Widget.

## Quyết định kỹ thuật riêng của app
- Kiến trúc feature-first: `lib/core/` (theme, widgets dùng chung, router, l10n, utils) · `lib/domain/` (model + luật kỳ/tiền) ·
  `lib/data/` (DB, repository, tỷ giá, backup, notifications) · `lib/features/<feature>/` (UI từng nhóm màn).
- Gợi ý thư viện (phiên A chốt, ghi lý do vào notes): Riverpod · go_router · drift (SQLite) · flutter_local_notifications + timezone ·
  gen-l10n (ARB) · fl_chart · share_plus + file_picker · http. Tỷ giá: API miễn phí không cần key có VND (vd open.er-api.com) — A kiểm tra.
- **Chống đụng độ khi song song (bắt buộc, A dựng sẵn):**
  - Router khai báo sẵn **mọi route** trỏ tới màn placeholder trong đúng thư mục feature → phiên UI chỉ thay file trong feature của mình.
  - **ARB tách theo feature**: `lib/l10n/parts/<feature>_{en,vi}.arb` + script gộp `tool/merge_arb.dart` chạy trước `flutter gen-l10n`
    → mỗi phiên chỉ sửa ARB của feature mình.
  - Chỉ phiên A (và F ở #2) được sửa `pubspec.yaml`; phiên khác cần package thì ghi vào notes để phiên điều phối giao.
- Không dùng logo thương hiệu thật: tile monogram màu (product.md §7.4).

## Kế hoạch 3 phiên điều phối

### Phiên điều phối #1 — Khởi động (2026-11-04) ← **đang ở đây**
**Phiên điều phối đã làm:** nghiên cứu thị trường, grill, cấp mã, `product.md`, `CONTEXT.md`, ADR 0001, repo GitHub.

**Đợt 1 — 3 phiên con song song, chạy ngay (tập file không chồng lấn):**
| Phiên con | Việc | Phạm vi file | Xong khi |
|---|---|---|---|
| **A** `[A001-subnest] Core` | Khởi tạo Flutter, kiến trúc, dependency, domain + luật kỳ (có unit test), DB, tỷ giá, thông báo, backup, router + placeholder mọi màn, l10n tách feature | toàn bộ project **trừ** `assets/catalog/`, `store/` | `flutter test` xanh; `flutter build apk --debug` OK; chạy trên Android thấy luồng thêm → nhắc → xác nhận bằng UI thô |
| **B** `[A001-subnest] Catalog` | Dữ liệu ~100 dịch vụ (tên, danh mục, màu, monogram, gói + giá VN/US, link huỷ) + schema | `assets/catalog/` | `services.json` hợp lệ theo `assets/catalog/README.md` |
| **D** `[A001-subnest] Store & legal` | Store listing EN/VI, chính sách quyền riêng tư, câu trả lời Data safety / App Privacy / content rating, thư mời tester | `store/` | Đủ file, độ dài trường đúng giới hạn store |

**Đợt 2 — sau khi A xong (vẫn trong #1 nếu kịp, không thì đầu #2):**
| **E** `[A001-subnest] CI & signing` | GitHub Actions: build AAB ký (keystore qua secrets), build iOS trên macOS runner (chưa ký → ký khi có Apple Developer); upload bản đầu lên **closed testing** để bắt đầu đếm 14 ngày | `.github/`, `android/` (chỉ cấu hình ký), `ios/` (chỉ cấu hình build), `docs/ci.md` | Workflow chạy xanh, AAB có trên Play Console closed testing |

**Việc của người dùng (song song, ngoài phiên):**
1. Gửi `product.md` cho Claude Design → nhận mockup → lưu link + export HTML vào `apps/A001-subnest/design/`.
2. **Đăng ký Apple Developer Program ($99/năm)** ngay — xác minh có thể mất vài ngày.
3. Gom **12–15 tester** (Gmail + Android) cho closed testing 14 ngày.
4. *(Tuỳ chọn)* mua domain `subnest.*` để host chính sách quyền riêng tư; không thì dùng GitHub Pages của một repo public riêng.

### Phiên điều phối #2 — Hoàn thiện (khi có mockup trong `design/`)
1. **F** `[A001-subnest] Design system` (chạy trước, một mình, ngắn): token màu/chữ/spacing từ export → `lib/core/theme/`,
   component dùng chung → `lib/core/widgets/`, font + icon set (được sửa `pubspec.yaml`), app icon + splash.
2. Sau F — **4 phiên con song song**:
   | Phiên con | Màn | Phạm vi |
   |---|---|---|
   | **G** Home & confirm | S2, S5, S6, S7 | `lib/features/home/`, `subscription_detail/`, `confirm/` |
   | **H** Add & onboarding | S1, S3, S4 | `lib/features/onboarding/`, `catalog/`, `subscription_form/` |
   | **I** Calendar & insights | S8, S9 | `lib/features/calendar/`, `insights/` |
   | **J** Settings & backup UI | S10 | `lib/features/settings/` |
   Mỗi phiên sửa ARB của feature mình; không đụng `lib/domain`, `lib/data` (lỗi lõi → ghi notes, phiên điều phối giao).
3. **E** (nếu chưa xong) / build release mới → closed testing + TestFlight.
4. **K** *(stretch)* Widget (S11): `android/` widget + `ios/` WidgetKit extension + package home_widget — chỉ khi G–J xong sớm.
5. Kết thúc #2: chạy `playbook/checklists/release-android.md` + `release-ios.md`.

### Phiên điều phối #3 — Catalog từ xa + logo, rồi nộp store (mở 2026-11-06; ADR 0002)
Người dùng chốt (grill 2026-11-06): làm đủ tính năng rồi mới upload/nộp. Thuật ngữ mới trong `CONTEXT.md`
(Catalog source, Region, Catalog link, Price change notice, Discontinued plan, Service logo).
| Phiên con | Việc | Phạm vi | Phụ thuộc |
|---|---|---|---|
| **P1** Catalog repo | Repo public `phamphuongphuongnd/catalog` + Pages; schema v4 (6 vùng VN/US/UK/AU/CA/IN, `logoDomain`, nguồn + ngày xác minh, trạng thái gói); chuyển dữ liệu v3; validator; Actions hằng tuần (Aristocles + bộ đọc trang VN → validate → tự đăng). Kiểm điều khoản Aristocles; dừng ở bước key → hướng dẫn người dùng | repo catalog (ngoài app) | — |
| **P4** Pháp lý & khai báo | Privacy/terms EN+VI (tải catalog từ GitHub Pages, logo từ logo.dev), forms Data safety/App Privacy, listing ghi "Logos provided by Logo.dev" + câu nhãn hiệu; đẩy sang repo legal | `store/`, `D:\Mobile App\legal` | — |
| **P2** Catalog từ xa trong app | Tải + cache + fallback bản đóng gói; chọn Region; Catalog link trên Subscription (migration); Price change notice; Discontinued plan; gắn `logoDomain` vào tile | `lib/data/catalog/**`, domain, DB, features liên quan | sau phiên sửa Thống kê |
| **P3** Logo | logo.dev (key `pk_` người dùng tạo, qua `--dart-define`/file ngoài repo), cache trên máy, fallback monogram, ghi nguồn ở Giới thiệu | `lib/core/widgets/service_tile*`, `lib/data/logos/**`, settings About | song song P2 (giao diện qua `logoDomain`) |
| **QA** | `smoke-android.md` + ảnh store mới (có logo) → version `1.0.0+3` → AAB | toàn app | sau P2, P3 |
Sau đó: người dùng upload closed testing → ≥ 14 ngày → production + App Store (khi có Apple Developer) → tag `v1.0.0` → retro cuối.

## Trạng thái
| Phiên điều phối | Ngày | Phiên con đã mở | Kết quả |
|---|---|---|---|
| #3 Catalog từ xa + nộp store | 2026-11-06 | Sửa Thống kê (đang chạy) · P1 · P4 · P2 · P3 · QA | ADR 0002 |
| #2 Hoàn thiện | 2026-11-05 | QA máy thật ✅ · F Design system ✅ · B2 Giá catalog ✅ (approx 147→114) · I Lịch/Thống kê ✅ · J Cài đặt ✅ · G Home/Detail/Confirm ✅ · H Onboarding/Catalog/Form ✅ (G, H dừng 1 lần vì hết hạn mức → chạy lại) | Toàn bộ S1–S10 theo mockup; phiên điều phối chạy lại: analyze sạch, **603 test xanh**, merge_arb --check OK; build iOS (không ký) xanh với icon/splash mới; vùng chạm 48dp (S-50) |
| #1 Khởi động | 2026-11-04 | A Core ✅ · B Catalog ✅ · D Store & legal ✅ · E CI ✅ | Brief, product.md, CONTEXT, ADR 0001; lõi Flutter; catalog 99 dịch vụ; store/legal EN+VI; CI AAB ký + iOS không ký |

**Việc dở / bước tiếp:**
- **QA máy thật ✅ (2026-11-05, Galaxy A13)**: 6 luồng §6 chạy trọn; 16 lỗi tìm thấy, 11 đã sửa (S6 số tiền cũ, 12 vùng chạm thiếu
  hành động TalkBack, nút "Bật lại" chết, bàn phím che nút sau date picker, sao lưu huỷ vẫn ghi, gãy chữ ở 320dp×200%, thông báo xấu →
  icon đơn sắc + teal + body). Khởi động nguội release ~0,9–1,1 s. Phiên điều phối chạy lại: analyze sạch, **622 test xanh**, merge_arb OK.
  Báo cáo: `notes/2026-11-05-qa-device.md`.
- **Ảnh store ✅**: `store/screenshots/{en,vi}/` (8 + 8), `store/graphics/icon-512.png`, `feature-1024x500(-vi).png`.
- **Người dùng còn phải làm:** (1) kiểm TalkBack bằng tay ~5 phút (các bước trong notes QA); (2) gửi link repo privacy policy;
  (3) tạo app Play Console + upload AAB closed testing (docs/ci.md §4); (4) gom 12–15 tester; (5) Apple Developer.
- Lỗi thấp #12–#16 ✅ đã sửa. **`1.0.0+2` đã vào `main`** (`91e7d5a`) sau khi phiên điều phối chạy lại: analyze sạch, **641 test xanh**,
  merge_arb OK. AAB ký bằng khoá người dùng, build **trên máy** (không tốn phút Actions):
  `C:\Users\Admin\keystores\A001-subnest\out\subnest-1.0.0+2.aab` (SHA-256 upload key `85:BC:…:08:6B`) → dùng file này cho closed testing.
- **Nhánh (từ 2026-11-05):** thư mục app luôn ở `dev`; CI không chạy `dev`; `main` chỉ kiểm; build chỉ khi tag/chạy tay (WORKFLOW §7).
  Sự cố 17:01: thư mục bị một phiên khác `checkout main` → phiên điều phối đã chuyển lại `dev` (không mất gì).
- Widget S11 → bản 1.1. Ký iOS/TestFlight chờ Apple Developer.
- **Catalog v3 ✅** (2026-11-05, `7a0b78e`): giá `approx` 114 → **37/284** (WebSearch vùng Mỹ + `allowed_domains` trang hãng); sửa 25 giá cũ sai;
  37 còn lại có lý do trong `notes/2026-11-05-catalog-us-prices.md`. Đã vào `main`; AAB `1.0.0+2` build lại 17:26 (có catalog v3 + link privacy).
- Lệch nhỏ catalog: ChatGPT monogram "GP" xanh (mockup "C" đen); ảnh store EN thiếu màn Thư viện (máy vùng VN).
- Khoá upload do người dùng tự tạo 2026-11-05. CI chưa chạy `gen_tokens --check`. Nhắc dùng alarm inexact (trễ ~1–5 phút).
- Bài học song song: `git commit -- <đường dẫn>`; commit chưa push của một phiên chặn push phiên khác; 2 phiên hết hạn mức giữa chừng →
  brief nên chia nhỏ hơn / commit WIP sớm.

## Retro

### Giữa kỳ — 2026-11-05 (code xong, trước khi nộp store; retro cuối bổ sung sau phiên #3)
- **Tổng:** 2 phiên điều phối (#1 2026-11-04, #2 2026-11-05) · 13 phiên con: #1 A Core, B Catalog, D Store & legal, E CI ·
  #2 F Design system, B2 Giá catalog, I Lịch/Thống kê, J Cài đặt, G Home/Detail/Confirm, H Onboarding/Catalog/Form, QA máy thật,
  Giá US catalog (đang chạy). Kết quả: 7/7 tính năng MVP, 58 màn mockup → S1–S10, 642 test, AAB `1.0.0+2` ký.
- **Chậm nhất / vấp:**
  1. *Phiên con dừng giữa chừng* (E dừng qua đêm; G, H hết hạn mức) → phải nhắn chạy lại; G giữ commit WIP chưa push chặn H push.
  2. *Luật thay đổi giữa chừng* (repo, khoá, nhánh, phút Actions) → sửa lại tài liệu + làm lại khoá upload + đổi CI.
  3. *CI build mỗi lần push* → đốt quota (phiotron hết 2.000 phút; A004 ~110 phút/push vì iOS macOS ×10).
  4. *Chỉ 1 điện thoại dùng chung* → phiên UI kiểm bằng ảnh render; QA máy thật dồn cuối và tìm 16 lỗi (7 ở 320dp × 200%).
  5. *Giá catalog theo vùng* → tra từ VN không ra giá US; 3 lượt tra.
  6. Một phiên khác `checkout main` trong thư mục dùng chung (17:01) — không mất gì nhưng nguy hiểm.
- **Tốt / giữ lại:** Core chạy song song trong lúc chờ Claude Design; route khai sẵn + ARB tách feature → 4 phiên UI không đụng nhau;
  design system + gallery trước rồi mới UI; ảnh golden ma trận (EN/VI × sáng/tối × 360/390 × 100–200%) thay máy thật cho bố cục;
  build AAB trên máy (không tốn phút).
- **Tái dùng được cho app sau:** `tool/merge_arb.dart`, `tool/gen_tokens.dart`, gallery + harness test UI (DB in-memory, font thật,
  router thật, chụp PNG), khung `ci.yml`/`ios.yml` + khối ký Android + `set-android-secrets.sh`, catalog + validator, mẫu store
  (privacy "no data", forms, tester kit, check_lengths), mẫu thông báo "planner + resync", repo legal chung `phamphuongphuongnd/legal`.
- **Cải tiến đã áp vào Playbook:** v0.3 repo theo link · v0.4 không tự tạo khoá · v0.9 nhánh dev + CI tiết kiệm phút ·
  v0.10 checklist `smoke-android.md`. **Đề xuất tiếp:** phiên con "nâng cấp xưởng" rút bộ template Flutter (`playbook/templates/flutter/`);
  brief phiên con: commit WIP sớm, kiểm `get_usage` trước khi mở nhiều phiên; ma trận bố cục có 320dp × 200%; tra trùng tên app trước grill.
