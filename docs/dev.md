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
| Sinh token từ design (sau khi `design/system/tokens.json` đổi) | `dart run tool/gen_tokens.dart` · CI: `--check` |
| Sinh lại app icon + splash (sau khi `design/brand/` đổi) | `python -I assets/icons/brand/make_brand_assets.py && dart run flutter_launcher_icons && dart run flutter_native_splash:create` → **hoàn tác** `ios/Runner.xcodeproj/project.pbxproj` + `ios/Runner/Info.plist` (tool ghi sai/định dạng lại) |
| Gallery component (debug) | giữ lâu tab **Cài đặt**, hoặc `adb shell am start -n com.phiotron.subnest/.MainActivity --es route "'/dev/gallery?page=3&dark=1&vi=1&large=1'"` (Git Bash: đặt `MSYS_NO_PATHCONV=1`; debug khởi động ~10 s) |

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
    theme/                  tokens.g.dart (SINH từ design/system/tokens.json) · app_theme.dart (ThemeData M3) · motion.dart · chart_colors.dart
    widgets/                design system — import 'core/widgets/widgets.dart' (xem §8 UI conventions)
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
7. **Màu/chữ/khoảng cách/component**: theo §8 — không hard-code hex, cỡ chữ, padding trong feature.

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

## 8. UI conventions (design system — phiên F, 2026-11-05)

Nguồn: `design/system/README.md` (luật), `design/png/` (58 màn × sáng/tối), `design/subnest-hifi.html` (mở bằng trình duyệt:
Components · 360 · 130% · VI). Trong code: **một import** `import '../../core/widgets/widgets.dart';` (kèm theme, icon, formatter).
Xem trực tiếp mọi component × trạng thái: gallery `/dev/gallery` (debug; giữ lâu tab Cài đặt) — có nút Sáng/Tối, EN/VI,
100/130%, khung 360. Báo cáo + ảnh so sánh: `notes/2026-11-05-design-system.md`.

### 8.1 Token → code
| Cần | Dùng | Ví dụ |
|---|---|---|
| Màu | `context.colors.<token>` (`AppColors`, ThemeExtension, đủ mọi token) — hoặc `Theme.of(context).colorScheme` cho widget Material | `context.colors.warningSoft`, `.inkMuted`, `.surface2`, `.chart3`, `.tileBlue` |
| Màu biểu đồ theo danh mục | `context.colors.chartFor(category)` (slot cố định AI, Storage, Telecom, Software, Video, Music; còn lại `chartOther`) | |
| Chữ | `AppType.display / amountLg / headline / title / titleSm / body / label / meta / caption` (chưa có màu → kế thừa `ink`) | `Text(x, style: AppType.meta.copyWith(color: c.inkMuted))` |
| Tiền | luôn `.tabular` (font đã thêm `tnum`) | `AppType.titleSm.tabular` |
| Khoảng cách | `AppSpace.s1…s10` (4·8·12·16·20·24·32·40) — lề màn `s4`, padding card `s4`, giữa section `s6`, giữa card `s3`, padding sheet `s5` | |
| Bo góc | `AppRadius.sm/md/lg/xl/full`, tile `tile24/40/56/80` | card `lg`, input/nút `md`, sheet/dialog `xl` |
| Kích thước | `AppSize.tapMin 44 · rowH 68 · buttonH 52 · fabSize 56 · tabbarH 64` | |
| Bóng | `context.elevation.card` / `.float` (tối: card = viền 1px `line`) | |
| Chuyển động | `AppMotion.countUp/sheet/dialog/paidPop/newRowFlash/confetti`; `AppMotion.of(context, d)` = 0 khi người dùng bật giảm chuyển động | |
| Icon | `AppIcons.<tên>` (Lucide). Nghĩa cố định: `awaiting` clock · `trial` hourglass · `shared` users · `cancelled` ban · `paid` circle-check · `savings` piggy-bank · `offline` wifi-off · `remindersOff` bell-off · `privacy` lock · `external` external-link. Cỡ 13–16 inline/badge, 20 hàng/nút, 22 tab, 24–26 top bar/FAB | `Icon(AppIcons.awaiting, size: 16)` |

### 8.2 Component nào cho việc gì
| Việc | Component |
|---|---|
| Tile dịch vụ | `ServiceTile(name, colorValue, iconText, size: 24/32/40/56/80, awaiting:, trial:, off:, faded:)` · ô "thêm tuỳ chỉnh" `GhostTile` |
| Hàng subscription (S2, S7, list S8) | `SubscriptionRow(state: normal/awaiting/trial/cancelled, meta:, awaitingCount:, sharedCount:, amount:, amountMeta:, onTap:, onConfirm:, onCancel:, highlight:, queued:)` trong `AppGroup(dividerIndent: 68)`; vuốt trái = Xác nhận/Huỷ (haptic + action trợ năng có sẵn) |
| Hero tổng chi (S2, tổng tháng S8) | `SpendHero(label, amount, format, approx, yearly, onPeriodChanged, segments, leadingMeta, trailingMeta, footer)` — tự đếm số 240 ms; `SpendStrip`, `CountUpText` dùng riêng được |
| Nút | `AppButton.primary/tonal/outline/text/danger` (+ `AppButtonKind.dangerText`), `small:` (40, pill), `expand:` (full width), `icon:`, `loading:`; FAB `AppFab`; icon 44px `AppIconButton` |
| Chip / badge | `AppChip(selected, fit:)` (đặt trong `Wrap(spacing: 8, runSpacing: 0)`; `fit` = 4 chip chu kỳ 1 hàng) · `StatusBadge.awaiting/trial/paid` hoặc `StatusBadge(kind:, icon:, large:)` · `ShareMark(count)` |
| Segmented | `AppSegmentedControl<T>(segments: [AppSegment(value, label, count)], selected, onChanged, mini:)` (mini = Tháng/Năm) |
| Bật/tắt, tăng/giảm | `AppToggle(value, onChanged)` · `AppStepper(value, min, max, onChanged)` |
| Banner | `AppBanner(kind: warning/info/success/danger/neutral, icon, title, body, actionLabel, onAction)` — nút tự rơi xuống dòng khi hẹp |
| Trạng thái rỗng | `EmptyState(title, body, art: NestArt(kind: nest/empty/party/chart/welcome), actionLabel, onAction)` |
| Card / nhóm / hàng cài đặt | `AppCard(color:, onTap:)` · `AppGroup(children, dividerIndent)` · `SettingRow(icon, label, subtitle, value, trailing, onTap, external:, danger:)` · `SectionHeader(label, actionLabel)` (eyebrow viết hoa) |
| Tiêu đề | tab: `LargeTitle(title, eyebrow, trailing)` · màn đẩy: `Scaffold(appBar: AppTopBar(title, close:, trailing:))` |
| Sheet / dialog / toast | `showAppSheet(context, builder:, required:)` + `AppSheet(title, child, actions)` · `showAppDialog(context, title, body, content, actions)` · `showAppToast(context, msg)` · route `/confirm/:id` tự lấy style sheet từ theme |
| Chọn ngày | `showAppDatePicker(context, initial, today, doneLabel, footer:)` → `LocalDate?` (tuần bắt đầu thứ Hai) · inline `AppDatePicker` |
| Tab bar | `AppTabBar` (đã gắn trong `AppShell`) |
| Ngày | `AppDates.relative(l10n, date, today:)` ("in 3 days"/"còn 3 ngày"; > 30 ngày → "2 Feb 2027"/"2/2/2027") · `.short` · `.full` · `.weekdayShort` ("Fri, 6 Nov"/"T6, 6/11") · `.weekdayLong` (eyebrow S2) · `.monthTitle` · `.weekdayHeaders` |
| Tiền | `l10n.money(m)` / `l10n.amount(v, cur, approx:)` (lõi): `₫260,000` · `260.000đ` · `$20.00`; số quy đổi phụ: `≈ ` + `inkMuted` · hậu tố chu kỳ `perCycle(l10n, cycle)` ("/month") · gói chia sẻ `l10n.corePlanPrice(price)` |

### 8.3 Luật VI / 360 / 130% (rút từ design README)
- Thiết kế bằng EN, **kiểm bằng VI** (dài hơn ~30%). Tên được ellipsize; **số tiền, badge, trạng thái không bao giờ cắt**.
- Hàng chờ xác nhận chỉ hiện badge (không kèm ngày). Gói chia sẻ ghi "gói 260.000đ". 4 chip chu kỳ VI một từ (Tuần · Tháng · Quý · Năm).
- Mọi thứ co giãn tới **360 × 800**; chỉ hero tổng chi tự xuống 36px (`SpendHero` lo). Lề màn 16.
- **130% chữ**: chữ to lên, **tile/icon/tab bar giữ nguyên**; `display`/`amountLg`/`headline` lớn tối đa 44/38/32 — dùng
  `TextScaleCap(max: AppTextScale.display, …)` hoặc `textScaler: AppTextScale.capped(context, AppTextScale.headline)`.
  Hàng cao lên; dòng 2 của hàng và giá trị cài đặt được xuống 2 dòng. Không scale lưới layout.
- Vùng chạm ≥ 44 cho mọi control (component đã đảm bảo; có test `iOSTapTargetGuideline`).
- "Chờ xác nhận" luôn **hổ phách + icon clock + chữ**, không bao giờ đỏ. `danger` chỉ cho xoá và lỗi nhập.
- Một hành động chính (`brand`) mỗi màn. Giọng văn bình tĩnh, ngôi thứ hai, không dấu chấm than; emoji chỉ ở empty state ăn mừng.
- Không hard-code hex / cỡ chữ / padding trong feature; thiếu component → ghi notes cho phiên điều phối (đừng chép rồi sửa trong feature).
- Test overflow cho màn của bạn: dùng lại `pumpUi` + `loadAppFonts` trong `test/core/design_system_test.dart` (nạp Be Vietnam Pro
  thật — font test mặc định rộng gấp đôi nên báo tràn sai), chạy 360×800, `locale: 'vi'`, `textScale: 1.3`, sáng + tối.
