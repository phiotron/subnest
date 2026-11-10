# A001-subnest · Subnest: Subscription Tracker — APP.md

> Brief + trạng thái của app. **Chỉ phiên điều phối sửa file này**; phiên con ghi báo cáo vào `notes/`.
> Spec sản phẩm/giao diện: `product.md` (v2 2026-11-10, toàn app; v1 ở `docs/product-v1.md`) · Thuật ngữ: `CONTEXT.md` · Quyết định khó đảo: `docs/adr/`.

## Brief
- **Mã app / thư mục:** `A001-subnest` → `apps/A001-subnest/` — đã ghi trong `apps/REGISTRY.md`
- **Bundle ID** (không đổi sau khi phát hành): `com.phiotron.subnest`
- **Một câu mô tả:** Theo dõi mọi subscription, nhắc trước khi bị trừ tiền/hết dùng thử, tổng chi đa tiền tệ — offline, không thu thập dữ liệu.
- **Người dùng mục tiêu:** 18–40 tuổi, nhiều dịch vụ số, hay quên huỷ dùng thử, chia gói Family. Toàn cầu, EN + VI.
- **App gốc để cạnh tranh:** Bobby (chỉ iOS), Tilla (chỉ Android). Lợi thế: cross-platform, **English + Tiếng Việt, USD mặc định, hỗ trợ VND**, gói chia sẻ, xác nhận từng kỳ, Tiết kiệm.
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
8. F8 Widget màn hình chính nhỏ/vừa/lớn, Android + iOS — **vào 1.0** (grill 2026-11-06)
9. F9 *(mở rộng 2026-11-06)* Đủ chức năng SubFox: nhãn, danh mục sửa được, danh sách phương thức thanh toán, ngân sách theo danh mục,
   dự báo, chi theo ngày/tuần/tháng/năm, "sắp trừ tuần này", lọc + nhớ lọc/sắp xếp, thanh tiến độ kỳ, tab tự ẩn khi cuộn
10. F10 Tạm dừng · Đáng tiền? (3 mức) · Nhắc nhiều mốc
11. F11 Thư viện 500+ dịch vụ toàn cầu (giá US chung + mục/giá VN), logo thật, nhãn Giá tham khảo
12. F12 Tự phát hiện (Pro): quét ảnh trên máy ở 1.0 (ADR 0003) · thông báo ngân hàng/ví 1.1 · Gmail 1.2

> Vượt luật "MVP ≤ 5" — người dùng chấp nhận (2026-11-04, mở rộng lần nữa 2026-11-06 sau khi so đối thủ; spec ở `product.md` §10).
> **Kiếm tiền:** nhập tay miễn phí, phần tự động thu phí; giá + dùng thử người dùng chốt sau khi chức năng xong (chặn nộp store).

## Màn hình & luồng chính
Chi tiết ở `product.md` §4–§6: S1 Onboarding (5 bước: Ngôn ngữ → Chào mừng → Tiền tệ → Chọn dịch vụ → Nhắc, + thêm nhanh) ·
S2 Tổng quan · S3 Thư viện · S4 Form · S5 Chi tiết ·
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
- ~~Không dùng logo thương hiệu thật~~ → logo thật **đóng gói sẵn** trong app (quyết định 2026-11-10 (2), bỏ logo.dev); thiếu → monogram.

### Quyết định 2026-11-10 — Mặc định toàn cầu: English + USD (S-90)
Grill với người dùng, chốt bỏ mọi suy luận từ ngôn ngữ/vùng máy cho bản cài mới (A002 đã theo cùng hướng D-036):
- **Ngôn ngữ:** luôn **English** lần đầu; chỉ English + Tiếng Việt; bỏ lựa chọn "Theo hệ thống" trong Cài đặt.
- **Tiền tệ chính:** **USD** (danh sách xếp USD đầu); Form mới lấy theo Tiền tệ chính.
- **Catalog/Thư viện:** Region cố định mở ở **US**; hai tab Chung/Việt Nam luôn hiện, mở sẵn Chung. Đổi ngôn ngữ
  không đổi giá. Bỏ `deviceLocaleProvider`, `showVietnamSectionProvider`, `catalogRegionForLocale`.
- **Onboarding:** thêm **S1.0 Ngôn ngữ** trước Welcome (không có trong mockup v13 — dựng từ design system); chữ trên màn
  này chỉ tiếng Anh, tên ngôn ngữ giữ bản ngữ; bước tiền tệ chọn sẵn USD, có USD/VND + "Chọn tiền tệ khác…"; ví dụ nhắc luôn USD.
- **Máy đã cài:** giữ nguyên giá trị đã lưu; locale `null` (đang "Theo hệ thống") thành English; backup/restore giữ nguyên.
- **Không** viết ADR riêng cho A001 (người dùng chốt); luật xưởng ghi ở `playbook/STANDARDS.md` **S-90**.
- **Version:** `1.0.0` (không kèm số build — người dùng chốt dù Android dùng versionCode 1, không cài đè được bản +2).
- Ảnh store: EN = USD, VI = VND — **chưa chụp lại** trong phiên này.

### Quyết định 2026-11-10 — Sao lưu, Bảo mật, Widget, Làm tròn (grill, theo A002)
Kế hoạch: `C:\Users\Admin\.claude\plans\a001-subnes-sao-l-u-robust-kahan.md`. Thuật ngữ mới trong `CONTEXT.md`. Không ADR.
1. **Code sao lưu dở** (chưa commit trên `dev`, ~1.600 dòng chép từ A002): giữ, làm nốt, thêm test.
2. **Sao lưu tự động y A002** (F-24, AC-58..60, D-026, D-027): thư mục hệ thống + mật khẩu ≥ 6 ký tự, luôn mã hoá AES-256-GCM,
   mật khẩu trong Keystore/Keychain; **giờ sao lưu** mặc định 21:00; Android chạy nền cả khi đóng app, iOS khi mở app; bù khi lỡ;
   chỉ ghi khi dữ liệu đổi; giữ 2 file mới nhất; đuôi `.subnest`; tắt → quên mật khẩu + thư mục, không xoá file.
3. **Khôi phục chỉ Thay thế** (bỏ Gộp, khác mockup 56): kiểm file trước, file có mật khẩu thì hỏi, một xác nhận.
4. **Xoá toàn bộ dữ liệu = như mới cài**: 2 bước; xoá cả cài đặt; tắt PIN + sao lưu tự động, xoá dữ liệu widget; mở lại vào onboarding.
5. Cài đặt có nhóm mới **"Bảo mật"** sau nhóm Dữ liệu: Khoá mã PIN · Che nội dung khi chuyển app.
6. **PIN y A002** (AC-31..34): 4 số, khoá khi mở/quay lại sau > 1 phút, băm có muối trong Keystore/Keychain, Quên mã → Xoá toàn bộ.
   Chưa làm vân tay/Face ID (làm sau cho cả A001 + A002).
7. Thông báo nhắc **không đổi** khi bật PIN (vẫn tên + giá).
8. **Che nội dung** độc lập, mặc định tắt: Android `FLAG_SECURE`, iOS lớp phủ.
9. **Widget** (mockup v13 89/91/92): hiện số tiền; **PIN bật → chỉ "Đã khoá bằng PIN"**; chạm gói → Chi tiết, chỗ khác → Tổng quan, qua màn khoá.
10. **Làm tròn tiền** (theo A002 D-029): tỷ giá chéo phân số chính xác; mỗi dòng quy đổi làm tròn half-up tới đơn vị nhỏ nhất;
    mọi tổng = cộng dòng đã làm tròn.
11. Chia việc: đợt 1 **B** Sao lưu + **R** Làm tròn (song song), **W** Widget sau khi B commit phần native; đợt 2 **S** Bảo mật.
    Phiên con chung thư mục `dev` (Phương chọn); không commit file l10n sinh ra — điều phối gen khi gộp.
12. *(sau B, 2026-11-10)* Bỏ banner "Lâu rồi chưa sao lưu" và màn riêng `/settings/backup` — mọi thứ trong nhóm Dữ liệu +
    khối Sao lưu tự động ngay trong Cài đặt (như A002). Galaxy A13 không có dữ liệu thật → được thử Khôi phục/Xoá/Quên mã trên máy.

### Quyết định 2026-11-10 (2) — Thống kê theo tháng, logo đóng gói, giá tăng, dự đoán (grill popup, phiên #7)
Kế hoạch: `C:\Users\Admin\.claude\plans\pasted-content-id-7366-grill-with-docs-shimmying-jellyfish.md`. Thuật ngữ mới
trong `CONTEXT.md` (Month spend, Daily average, Month cash flow, Price history, Price increase, Custom logo). Không ADR.
1. **Thống kê:** segment Tháng | Năm + `‹ tháng ›`; chạm cột chọn tháng; mọi thẻ theo khoảng đang chọn.
2. **Month spend:** gói tháng = giá tháng; gói năm/khác quy tháng chỉ khi đã đăng ký trước/trong tháng; chỉ tháng đang trả
   (Trial = 0, sau tháng huỷ = 0, Paused cả tháng = 0); giá theo Lịch sử giá. Trung bình/ngày = ÷ số ngày tháng.
3. **Đã thanh toán / Còn phải thanh toán** = tiền trừ thật (gói năm đủ giá ở tháng gia hạn) + nút (i).
4. **Tổng quan:** header thành thẻ Chi phí (Tháng/Năm, chênh tháng trước, số gói, /ngày, thanh Đã/Còn, cột 6 tháng → Thống kê).
5. **Logo đóng gói** 500 dịch vụ, đẩy kèm repo catalog; **bỏ logo.dev** (code, key, chính sách, listing); tự tạo: chữ/emoji + **Chọn ảnh**.
6. **Thẻ dùng thử:** 3 nút Giữ lại · Xem gói đăng ký · Cách huỷ + "huỷ trước khi tính phí tiết kiệm X/năm".
7. **Chip chu kỳ** (Hàng tháng/Hàng năm/Mỗi 3 tháng…) dưới mọi giá.
8. **Lịch sử giá** (bảng mới, backfill từ Payment); Chi tiết cả tăng/giảm; Thống kê thẻ Tăng giá (so 12 tháng trước, chỉ tăng); ↑ ở hàng khi tăng ≤ 90 ngày.
9. **Dự đoán** 12 tháng tới vs 12 tháng qua, tách gói thêm/tăng giá/khác + Sắp tới 13 tuần/12 tháng.
10. Việc dở đợt này: U2b + U4 (+ lỗi Tạm dừng) · S Quét ảnh · P2 Catalog từ xa + Báo đổi giá · phát hành.
11. **Lõi trước, giao diện sau mockup v14.** 12. `product.md` v2 viết lại toàn app, **không nhắc app đối thủ**.

### Phiên điều phối #7 — kế hoạch
| Đợt | Phiên con | Việc | Khi nào |
|---|---|---|---|
| 0 | điều phối | product.md v2, CONTEXT, APP, TASKS; chip chu kỳ + thẻ dùng thử 3 nút | 2026-11-10 |
| 1 | **L** Logo · **M** Lõi số liệu · **R** CI iOS + push | xem kế hoạch; M làm migration (gồm cột ảnh tự chọn của L) | đề xuất 2026-11-10 |
| 1b | **P2** Catalog từ xa (data) | sau khi M commit migration | |
| 2 | U-Home · U-Insights · U2b · U4 · S UI · Lịch | sau mockup v14 (Phương gửi product.md v2 cho Claude Design) | |
| 3 | pháp lý (bỏ logo.dev, quyền ảnh) · QA A13 · ảnh store · AAB | | |

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

> **Thay thế bởi kế hoạch #3/#4 bên dưới (grill 2026-11-06 chiều).** P1 → gộp vào C1; P2, P3, P4 giữ (P2 dùng schema v4 rút gọn).

### Phiên điều phối #3 (tiếp) + #4 — Mở rộng 1.0 theo SubFox + tự phát hiện (grill 2026-11-06; ADR 0003; product.md §10)
Người dùng cho vượt luật ≤ 3 phiên điều phối (ghi ngoại lệ METRICS). Mọi phiên con: `flutter analyze` sạch, `flutter test` xanh,
`merge_arb --check`, commit WIP sớm, báo về phiên điều phối bằng SendMessage.

**Đợt 1 (song song):**
| Phiên con | Việc | Phạm vi |
|---|---|---|
| **C1** Catalog 500+ | Schema v4 rút gọn (giá `US` + `VN`, `verified`, `section: global/vn`, `logoDomain`, tên hiển thị trên trang gói Play/App Store); 99 → 500+; validator; hỏi link repo rồi đẩy repo `catalog` + Pages | `D:\Mobile App\catalog`, `assets/catalog/` |
| **M1** Lõi | Domain + migration: Paused, Worth-it, Label, Category tuỳ biến, PaymentMethod, Budget, nhắc nhiều mốc, nguồn phát hiện + Hoàn tác, DetectedCharge + luật khớp; backup/CSV; route + ARB placeholder màn mới; cổng Pro (mở hết); package ML Kit text recognition + home_widget | `lib/domain/`, `lib/data/`, `lib/core/router/`, `pubspec.yaml`, `drift_schemas/` |
| **P3** Logo (tiếp WIP `ab3ea85`) | Hoàn tất logo.dev + thanh tiến độ kỳ trong tile/row | `lib/core/widgets/service_tile*`, `subscription_row.dart`, `lib/data/logos/` |

> Đợt 1 xong 2026-11-06: C1 500 dịch vụ (354/765 giá xác minh), M1 DB v2 + domain (API đợt 2: `notes/2026-11-06-m1-core.md`), P3 logo + thanh tiến độ.
> Lưu ý đợt 2: gỡ shim API cũ (`category`, `reminderDays`) sau khi UI đổi xong; S hoặc W sửa `ios/Podfile` `platform :ios, '15.5'` (ML Kit);
> W sửa `app.dart` để gắn WidgetSync; hàng gói cần tone `paused` (P3 tạm dùng `off`).
> ~~Mockup v12~~ → **mockup v13** (`design/` `775901b`, 2026-11-06): số màn từ 21 trở đi đã dịch so với v12 — dùng bảng đợt 2 dưới.

**Đợt 2 — phiên điều phối #4 (mở 2026-11-06), số màn theo mockup v13** (`design/` `775901b`: 99 màn; token không đổi so v12
→ không cần phiên Design system). Tối đa ~3 phiên cùng lúc; brief bắt `get_usage` + commit WIP biên dịch được sau mỗi màn.
| Phiên con | Màn v13 | Phạm vi | Khi nào |
|---|---|---|---|
| **U1** Tổng quan | 08–20 (21 sau P2) | `features/home/`, `core/widgets/app_shell.dart`, `subscription_row.dart` (tone `paused`), `home_*.arb` | mở 2026-11-06 |
| **U2a** Thư viện + Form | 22–37 | `features/catalog/`, `features/subscription_form/`, ARB tương ứng | mở 2026-11-06 |
| **U2b** Chi tiết + Xác nhận | 38–54, 58–59 (55–57 sau P2) | `features/subscription_detail/`, `features/confirm/` | từ 10/11 |
| **U3** Lịch + Thống kê | 60–69 | `features/calendar/`, `features/insights/` | từ 10/11 |
| **U4** Cài đặt | 70–88 | `features/settings/` | từ 10/11 |
| **S** Quét ảnh | 93–99 | `features/scan/`, `domain/detection/`, `ios/Podfile` (iOS 15.5) | từ 10/11 |
| **W** Widget | 89, 91, 92 | `android/` widget, `ios/` extension, `features/widget_sync/`, `app.dart` | từ 10/11 |
| **P2** Catalog từ xa | dữ liệu cho 21, 55–57 | `lib/data/catalog/**`, domain/DB liên quan | từ 10/11 → rồi phiên nhỏ gắn UI 21 + 55–57 |
Luật đợt 2: component mới để trong thư mục feature (gom lên `core/widgets` sau); không sửa `domain`/`data`/router/`pubspec.yaml`
(thiếu API → SendMessage); UI mới dùng `categoryId`/`reminderOffsets`, không dùng shim; phiên con chung thư mục `dev` (người dùng chọn).

**Đợt 3 (#4):** P4b pháp lý (quét ảnh trên máy, quyền ảnh/camera, widget) · QA `smoke-android` + ảnh store → `1.0.0+3` → AAB.
**Chặn nộp store:** người dùng chốt giá/dùng thử Pro. 1.1 (thông báo) / 1.2 (Gmail) grill riêng; phải kiểm chính sách
NotificationListener của Play và thẩm định restricted scope Gmail (có miễn CASA khi chỉ xử lý trên máy không).

## Trạng thái
| Phiên điều phối | Ngày | Phiên con đã mở | Kết quả |
|---|---|---|---|
| #7 Thống kê theo tháng · logo đóng gói · giá tăng · dự đoán (grill popup) | 2026-11-10 | đề xuất L, M, R | 12 quyết định + 6 thuật ngữ; product.md v2 toàn app (gửi Claude Design → v14) |
| #6 Sao lưu · Bảo mật · Widget · Làm tròn (grill, theo A002) | 2026-11-10 | B Sao lưu ✅ · R Làm tròn ✅ · W Widget ✅ (đang sửa màu chữ widget trên One UI) · S Bảo mật ✅ | 12 quyết định + 9 thuật ngữ; `dev` `9171a92`…`b0f32fa` (chưa push); analyze sạch, **970 test xanh**; thử A13: S (PIN, che nội dung, Quên mã) đạt, W (3 widget, chạm, khoá) đạt, điều phối (làm tròn, sao lưu tự động + hẹn giờ khi app tắt, giữ 2 file, xoá toàn bộ, khôi phục mã hoá) đạt + sửa lỗi time picker cỡ chữ nhỏ — `notes/2026-11-10-*.md`. Còn: CI iOS tay, App Group, ảnh store |
| #5 Mặc định English + USD (S-90) | 2026-11-10 | không (làm trực tiếp) | English lần đầu + USD mặc định + Thư viện mở tab Chung (giá US) + Settings chỉ EN/VI; thêm S1.0 Language trước Welcome (chữ tiếng Anh, không dịch); version `1.0.0`; analyze sạch, **823 test xanh**; APK release `build/app/outputs/flutter-apk/app-release.apk` cài Galaxy A13 (máy `vi-VN`) mở English + USD |
| #4 Đợt 2 giao diện theo mockup v13 (đang mở) | 2026-11-06 | U1 Tổng quan ✅ · U2a Thư viện + Form ✅ (tuần 92% → chỉ mở 2; còn lại từ 10/11) | mockup v13 `775901b`; U1 `4075597`…`058cf34`, U2a `522df46` `ed06826` `09faefd`, U1 `3cb500c`; điều phối chạy lại ở `09faefd`: analyze sạch, merge_arb OK, **823 test xanh** (97 golden bỏ qua khi không bật cờ) |

**Việc dở đợt 2 (từ U1/U2a, 2026-11-06):**
- **Lỗi domain:** bấm Tạm dừng đặt `status = paused` ngay dù `pausedFrom` ở tương lai → gói rời tổng chi/ngân sách từ hôm nay; mockup 20
  ghi "vẫn tính tới ngày dừng" → giao một phiên lõi sửa tính tiền (theo mockup).
- `SubscriptionRow` có thêm `SubscriptionRowState.paused`, `nameBadge`, `metaExtras` (điều phối duyệt) — U2b dùng lại.
- Phiên **S** phải gọi `homeAutoUndoProvider.notifier.show(report)` để Tổng quan hiện Hoàn tác. Màn 21: chỗ gắn + API cần từ P2 ở `notes/2026-11-06-u1-home.md`.
- Router nên nhận `?region=` cho `/subscription/new` (U2a đang dùng tạm `libraryPickRegionProvider`). Gom lên `core/widgets`:
  chip nhãn, huy hiệu Auto, ReferencePriceChip, DotChip, WorthItPicker, sheet phương thức (thêm icon từng dòng).
- Form sửa đọc dịch vụ bằng `catalogRepositoryProvider.byId()` → khi cache trống parse lại cả asset catalog ~400 KB lúc hiện spinner
  (test S5 Edit dễ treo khi CPU bận). Sửa: dùng `catalogProvider` đã nạp sẵn (~3 dòng, U2a đề xuất) — giao U2b.
- Chưa sinh lại golden + chưa thử máy thật cho U1/U2a → QA. File l10n sinh ra bị commit kèm phần của phiên khác → cân nhắc luật: chỉ phiên cuối gen + commit.
| #3 Catalog từ xa + nộp store (đang mở) | 2026-11-06 | Sửa S9 ✅ code (chờ kiểm máy) · P4 pháp lý ✅ · P1 catalog API ⏸ WIP · P3 logo ⏸ WIP · P2, QA chưa mở · **chiều:** grill lấy giá/quản lý → mở rộng 1.0; đợt 1 **C1 ✅ M1 ✅ P3 ✅** (767 test xanh, `dev` `63a5ded`); repo `phamphuongphuongnd/catalog` public + Pages ✅ (data v12) · **dừng chờ hạn mức tuần (reset 2026-11-10)** → đợt 2 | ADR 0002 (sửa vùng giá), ADR 0003, product.md §10, CONTEXT +13 thuật ngữ — log `memory/sessions/2026-11-06-A001-subnest-phien2.md` |
| #2 Hoàn thiện | 2026-11-05 | QA máy thật ✅ · F Design system ✅ · B2 Giá catalog ✅ (approx 147→114) · I Lịch/Thống kê ✅ · J Cài đặt ✅ · G Home/Detail/Confirm ✅ · H Onboarding/Catalog/Form ✅ (G, H dừng 1 lần vì hết hạn mức → chạy lại) | Toàn bộ S1–S10 theo mockup; phiên điều phối chạy lại: analyze sạch, **603 test xanh**, merge_arb --check OK; build iOS (không ký) xanh với icon/splash mới; vùng chạm 48dp (S-50) |
| #1 Khởi động | 2026-11-04 | A Core ✅ · B Catalog ✅ · D Store & legal ✅ · E CI ✅ | Brief, product.md, CONTEXT, ADR 0001; lõi Flutter; catalog 99 dịch vụ; store/legal EN+VI; CI AAB ký + iOS không ký |

**Việc dở / bước tiếp:**
- **Phiên #5 (2026-11-10) — mặc định toàn cầu:** code + test + docs xong. Máy ảo/tests xác nhận; **máy thật Galaxy A13
  (`vi-VN`)**: cài mới mở **English**, onboarding 5 bước, màn Language chỉ chữ Anh; chưa chụp lại ảnh store (EN=USD,
  VI=VND) — để lượt sau. Release APK build lỗi R8 vì ML Kit tham chiếu recognizer không đóng gói → đã thêm
  `android/app/proguard-rules.pro` + `proguardFiles` (giữ cho lần build sau). Version `1.0.0` = versionCode 1:
  **không cài đè được** bản `1.0.0+2` đang có trên máy nào; máy test hiện chưa cài bản cũ.
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
