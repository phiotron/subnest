# Subnest — Hướng dẫn dev (A001-subnest)

> Dành cho mọi phiên làm code của app. Đọc cùng `APP.md` (brief), `CONTEXT.md` (thuật ngữ — **dùng đúng tên trong
> code**), `product.md` (spec màn hình), `docs/adr/` (quyết định khó đảo).

## 1. Chạy app

Máy dev: Windows 10, Flutter 3.47 ở `C:\src\flutter` (Dart 3.13), Android SDK + JDK 17. iOS build trên macOS runner
(GitHub Actions — phiên E).

```bash
export PATH="/c/src/flutter/bin:$PATH"     # Git Bash; PowerShell: $env:Path = "C:\src\flutter\bin;" + $env:Path
flutter pub get
flutter run                                  # máy Android cắm USB (bật USB debugging) hoặc emulator
```

| Việc | Lệnh |
|---|---|
| Phân tích tĩnh (phải sạch) | `flutter analyze` |
| Test (phải xanh) | `flutter test` |
| APK debug | `flutter build apk --debug` → `build/app/outputs/flutter-apk/app-debug.apk` |
| Gộp ARB + sinh l10n | `dart run tool/merge_arb.dart && flutter gen-l10n` |
| Kiểm ARB đã gộp chưa (CI) | `dart run tool/merge_arb.dart --check` |
| Sinh code drift (sau khi sửa bảng) | `dart run build_runner build` |
| Lưu schema DB mới + test migration | `dart run drift_dev make-migrations` |
| Kiểm catalog (phiên B) | `python assets/catalog/tool/validate_catalog.py` |

File sinh ra **được commit** (`lib/data/db/*.g.dart`, `lib/l10n/app_*.arb`, `lib/l10n/generated/`) để clone về là
build được ngay; CI nên chạy `merge_arb --check` + `build_runner` rồi `git diff --exit-code` để bắt quên sinh lại.

### Kiểm nhanh thông báo
Cài đặt → **Gửi nhắc thử**: 1 thông báo ngay + 1 thông báo hẹn giờ sau 10 giây (đi qua `zonedSchedule` giống nhắc
thật). Chạm thông báo → mở màn *Chờ xác nhận*. Nhắc thật: thêm subscription có Ngày gia hạn = hôm nay và giờ nhắc
(Cài đặt → Giờ nhắc) vài phút sau → nhận "… gia hạn hôm nay — chạm để xác nhận" → chạm mở tấm xác nhận.
Xem thông báo đang chờ trên Android: `adb shell dumpsys alarm | grep -A2 com.phiotron.subnest` (dòng `origWhen=`); thông báo
đang hiện: `adb shell dumpsys notification --noredact | grep com.phiotron.subnest`. Alarm là **inexact** nên có thể trễ ~5 phút.
Lên lịch lại chỉ huỷ thông báo *đang chờ* (`cancelAllPendingNotifications`), không xoá thông báo người dùng chưa đọc.

## 2. Cấu trúc thư mục

```
lib/
  main.dart                 khởi tạo: date symbols, NotificationService, ProviderContainer, router
  app.dart                  MaterialApp.router, theme/locale theo Settings, vòng đời (Trial→Active, tỷ giá, deep link)
  core/                     dùng chung, KHÔNG chứa luật nghiệp vụ
    router/                 routes.dart (mọi đường dẫn) · app_router.dart (bảng route) · app_shell.dart (tab bar) · sheet_page.dart
    l10n/l10n.dart          context.l10n + nhãn cho giá trị domain (chu kỳ, trạng thái, danh mục, nhắc, tiền, ngày)
    theme/app_theme.dart    THEME TẠM — phiên F thay bằng token từ Claude Design
    widgets/                ServiceTile (tile monogram), AsyncValueView — phiên F restyle
    utils/                  format.dart (tiền/ngày/parse số), currencies.dart, streams.dart
  domain/                   Dart thuần, không Flutter/DB — MỌI luật kỳ/tiền ở đây, có unit test
    local_date.dart · billing_cycle.dart · money.dart · subscription.dart · confirmed_period.dart
    billing_rules.dart      xác nhận kỳ, bắt kịp, Trial→Active, huỷ/khôi phục, rebase (ADR 0001)
    spending.dart           Monthly cost, tổng chi, Savings, theo danh mục, thực trả vs dự kiến 12 tháng
    reminder_planner.dart   quyết định thông báo nào cần chờ (≤ 60 do giới hạn iOS 64)
    calendar.dart           mục Lịch / Sắp tới · catalog.dart (model Catalog + tìm không dấu)
    subscription_draft.dart trạng thái form S4 + validate + áp dụng sửa
  data/                     lưu trữ & nền tảng
    db/                     drift: app_database.dart (bảng, migration), mappers.dart
    subscription_repository.dart · settings_repository.dart · catalog_repository.dart
    rates/                  exchange_rate_repository.dart (open.er-api.com), fallback_rates.dart
    backup/                 backup_service.dart (JSON/CSV), backup_codec.dart, backup_files.dart (share/pick)
    notifications/          notification_service.dart
    providers.dart          MỌI provider Riverpod dùng chung (repo, stream dữ liệu, tổng chi, today…)
  features/<feature>/       UI từng nhóm màn (đang là PLACEHOLDER chạy được)
  l10n/parts/<part>_{en,vi}.arb   chuỗi theo feature (sửa ở đây)
  l10n/app_{en,vi}.arb            SINH RA bởi merge_arb — đừng sửa
  l10n/generated/                 SINH RA bởi gen-l10n — đừng sửa
tool/merge_arb.dart         gộp + kiểm ARB
drift_schemas/              schema DB đã phát hành (để test migration)
test/                       domain/ (luật) · data/ (DB in-memory, backup, tỷ giá) · core/ (định dạng)
```

### Màn ↔ route ↔ thư mục ↔ phiên UI (đợt #2)

| Màn | Route (`AppRoutes`) | Widget (giữ tên + constructor) | Thư mục | Phiên |
|---|---|---|---|---|
| S1 Onboarding | `/onboarding` | `OnboardingScreen` | `features/onboarding/` | H |
| S2 Tổng quan | `/home` (tab) | `HomeScreen` | `features/home/` | G |
| S3 Thư viện | `/catalog` | `CatalogScreen` | `features/catalog/` | H |
| S4 Form thêm/sửa | `/subscription/new?service=&plan=&name=` · `/subscription/:id/edit` | `SubscriptionFormScreen` | `features/subscription_form/` | H |
| S5 Chi tiết | `/subscription/:id` | `SubscriptionDetailScreen` | `features/subscription_detail/` | G |
| S6 Tấm xác nhận | `/confirm/:id` (bottom sheet, deep link từ thông báo) | `ConfirmSheet` | `features/confirm/` | G |
| S7 Chờ xác nhận | `/awaiting` | `AwaitingScreen` | `features/confirm/` | G |
| S8 Lịch | `/calendar` (tab) | `CalendarScreen` | `features/calendar/` | I |
| S9 Thống kê | `/insights` (tab) | `InsightsScreen` | `features/insights/` | I |
| S10 Cài đặt | `/settings` (tab), `/settings/currency`, `/settings/rates`, `/settings/backup` | `SettingsScreen`, `CurrencyScreen`, `RatesScreen`, `BackupScreen` | `features/settings/` | J |

## 3. Quy ước cho các phiên UI (G, H, I, J…)

1. **Chỉ sửa thư mục feature của mình + ARB part của mình** (`lib/l10n/parts/<feature>_{en,vi}.arb`).
   Widget con riêng của feature đặt trong `features/<feature>/widgets/`.
2. **Giữ tên lớp + constructor** của màn trong bảng trên (router dùng chúng). Cần route mới/đổi tham số → ghi vào
   notes để phiên điều phối giao (file `core/router/` thuộc phiên Core).
3. **Không đụng `lib/domain`, `lib/data`, `core/router`, `pubspec.yaml`.** Thấy lỗi/thiếu ở lõi → ghi notes.
   Thiếu package → ghi notes (chỉ phiên A/F sửa pubspec).
4. **Không viết luật nghiệp vụ trong UI.** Dùng: `BillingRules` (chờ xác nhận, số kỳ chờ, ngày còn lại),
   `SpendingCalculator` qua `spendingCalculatorProvider`/`spendingSummaryProvider`, `CalendarBuilder`,
   `SubscriptionDraft` (form), repository qua provider trong `data/providers.dart`. "Hôm nay" = `todayProvider`.
5. **Tiền**: lưu số nguyên đơn vị nhỏ (`priceMinor`); hiển thị bằng `l10n.money(...)` / `l10n.amount(...)`;
   số đã quy đổi luôn `approx: true` (dấu "≈"). Nhập số: `Fmt.parseAmount`.
6. **Điều hướng**: `context.push(AppRoutes.xxx(...))`; sau khi thêm mới → `context.go(AppRoutes.home)`.
7. **Màu/khoảng cách**: dùng `Theme.of(context)` và token của phiên F, không hard-code hex trong feature.

## 4. Chuỗi (l10n) tách theo feature

- Mỗi feature một cặp file `lib/l10n/parts/<part>_en.arb` + `<part>_vi.arb`. Part `common` (core) và
  `notifications` (thông báo) thuộc phiên Core.
- **Key phải bắt đầu bằng tên part dạng camelCase**: part `subscription_form` → `subscriptionFormSaveChanges`.
  Script báo lỗi nếu sai, trùng key giữa các part, hoặc VI thiếu/thừa key so với EN.
- Metadata (`"@key": {"placeholders": …}`) chỉ đặt trong file `_en`. Plural/select theo ICU
  (chỉ dùng `=0`, `=1`, `=2`, `other`… — không có `=3`).
- Sau khi sửa: `dart run tool/merge_arb.dart && flutter gen-l10n`, dùng `context.l10n.<key>`.
- Hai phiên song song chỉ đụng nhau ở 2 file sinh ra (`app_en.arb`, `app_vi.arb`, `generated/`): nếu git báo
  xung đột ở đó, **đừng sửa tay** — chạy lại merge + gen-l10n rồi commit kết quả.
- Chữ trong thông báo hệ thống lấy qua `lookupAppLocalizations` (không cần `BuildContext`).

## 5. Luật nghiệp vụ đã cài (tóm tắt — chi tiết + test trong `lib/domain`, `test/domain`)

- Due date = `cycle.occurrence(anchorDate, periodIndex)` — luôn tính từ mốc nên ngày 31 / 29-2 quay lại đúng
  ngày (31/1 → 28/2 → 31/3). Sửa ngày gia hạn hoặc chu kỳ ⇒ đặt lại mốc (`rebase`).
- Tới Due date ⇒ *Chờ xác nhận*; Due date đứng yên tới khi xác nhận (Đã trả → `Payment`, số tiền mặc định =
  My share, sửa được · Không trả → Skipped period · Để sau → không làm gì). Bỏ lâu ⇒ các kỳ đã qua lần lượt chờ;
  "Xác nhận tất cả" = trả hết theo giá hiện tại.
- Trial: ngày hết Trial = Due date kỳ trả phí đầu; tới ngày đó tự thành Active (hiển thị ngay, lưu khi mở app).
- Huỷ: giữ lịch sử, bỏ kỳ đang chờ, không nhắc; Savings = chi phí quy năm. Khôi phục: Due date nhảy tới lần lặp
  đầu tiên ≥ hôm nay (không đòi xác nhận thời gian đã huỷ).
- Monthly cost = My share × số kỳ/tháng (năm ÷12, tuần ×52÷12, ngày ×365÷12) quy về Primary currency. Tổng tháng chỉ
  tính Active; Trial hiện riêng "sắp tính phí".
- Nhắc: mặc định 3 ngày trước lúc 9:00 + thông báo "đến ngày" (chạm → `/confirm/:id`). Từng subscription:
  Tắt / Đúng ngày / 1 / 3 / 7. Kỳ đang chờ ⇒ không lên lịch kỳ sau. Lên lịch lại toàn bộ sau mỗi thay đổi dữ liệu,
  khi mở app, khi quay lại app, qua nửa đêm; Android tự khôi phục sau khởi động lại (boot receiver).

## 6. Database migrations (drift)

1. Sửa bảng trong `lib/data/db/app_database.dart`, tăng `schemaVersion`.
2. `dart run build_runner build` rồi `dart run drift_dev make-migrations` → lưu `drift_schemas/app/drift_schema_vN.json`,
   sinh `app_database.steps.dart` và test migration trong `test/drift/`.
3. Viết bước trong `onUpgrade` bằng `m.runMigrationSteps(...)`, chạy `flutter test test/drift`.
4. Đổi định dạng backup JSON ⇒ tăng `BackupCodec.version`, giữ đọc được bản cũ.

## 7. Bí mật & phát hành

Không commit keystore/`key.properties`/`.p12`/`.env` (đã có trong `.gitignore`). Ký release + CI: phiên E (`docs/ci.md`).
Nguồn tỷ giá yêu cầu ghi công "Rates by Exchange Rate API" (đã có ở Cài đặt → Tỷ giá).
