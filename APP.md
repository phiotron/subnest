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

### Phiên điều phối #3 — Phát hành & retro (sau ≥ 14 ngày closed testing)
1. **L** QA trên máy Android thật + TestFlight (mượn iPhone nếu có) → bug vào `notes/`; sửa lỗi theo phiên của feature.
2. **M** Ảnh chụp store (EN + VI, light/dark) vào `store/screenshots/`.
3. Nộp Google Play production + App Store review; tag `v1.0.0`.
4. Retro bắt buộc → METRICS, PLAYBOOK v1.

## Trạng thái
| Phiên điều phối | Ngày | Phiên con đã mở | Kết quả |
|---|---|---|---|
| #1 Khởi động | 2026-11-04 | (đang mở A, B, D) | Đã chốt brief, product.md, CONTEXT, ADR 0001 |

**Việc dở / bước tiếp:**
- Chờ A, B, D báo cáo → kiểm tra thật (test, build) → mở E.
- Người dùng: Claude Design, Apple Developer, gom tester.

## Retro (điền khi phát hành)
- Tổng phiên điều phối / phiên con:
- Chậm nhất ở đâu, vì sao:
- Thứ tái dùng được cho app sau:
- Cải tiến đề xuất cho Playbook:
