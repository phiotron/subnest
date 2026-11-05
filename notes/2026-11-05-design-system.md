# [A001-subnest] Design system — báo cáo phiên con F

> Phiên điều phối #2 · 2026-11-05 · Hướng dẫn dùng cho phiên G–J: **`docs/dev.md` §8 UI conventions** (đọc cái đó trước).

## Kết quả nhanh

- Theme Material 3 sáng/tối **sinh từ `design/system/tokens.json`** bằng `tool/gen_tokens.dart` (chạy lại được, có `--check`).
- Font **Be Vietnam Pro** 400/500/600/700 đóng gói (không tải runtime) — **đã thêm feature `tnum`** vì font gốc không có số tabular.
- Icon **Lucide** qua `lucide_icons_flutter` (font icon, tree-shake khi release); 54/54 icon của `design/system/icons/` có đủ.
- 15 nhóm component trong `lib/core/widgets/` + gallery debug `/dev/gallery` (6 trang × sáng/tối/EN/VI/100–130%/360).
- AppShell dùng tab bar theo design (không đổi danh sách route). App icon + splash (Android ≤ 11, Android 12+, iOS) từ `design/brand/`.
- `flutter analyze` sạch · `flutter test` **130 xanh** (94 cũ + 36 mới) · chạy trên **Samsung SM-A135F (Android 14)**, ảnh trong `notes/img/2026-11-05-design-system/`.

## Đã làm / file

| File | Nội dung |
|---|---|
| `tool/gen_tokens.dart` | đọc tokens.json → `lib/core/theme/tokens.g.dart`: `AppColors` (ThemeExtension, 45 token, alias `{brand}` giải sẵn, `tilePalette`, `byName`), `AppElevation` (CSS box-shadow → `BoxShadow`), `AppType`, `AppSpace`, `AppRadius`, `AppSize`. Tự `dart format`. `--check` cho CI |
| `lib/core/theme/app_theme.dart` | `AppTheme.light()/dark()` (giữ API cũ, `app.dart` không đổi — chọn Sáng/Tối/Hệ thống đã nối sẵn qua `settings.themeMode`), ColorScheme theo mục *Flutter mapping*, TextTheme, theme cho mọi widget Material hay dùng (button, input, switch, chip, list tile, sheet, dialog, snackbar=toast, date/time picker…). `context.colors`, `context.elevation`, `context.isDark`, `TextStyle.tabular`, `AppTextScale` + `TextScaleCap` (luật 130%). `AppTheme.warning/success` cũ giữ lại dạng `@Deprecated` để màn placeholder còn biên dịch |
| `lib/core/theme/motion.dart` · `chart_colors.dart` | `AppMotion` (thời lượng/curve + tôn trọng giảm chuyển động) · `colors.chartFor(category)` (slot cố định) |
| `lib/core/widgets/*.dart` + `widgets.dart` (barrel) | component — bảng API bên dưới |
| `lib/core/router/app_shell.dart` | `AppTabBar` theo design; debug: giữ lâu tab Cài đặt → gallery |
| `lib/core/router/app_router.dart`, `routes.dart` | thêm **chỉ** route `/dev/gallery` (đăng ký khi `kDebugMode`, nhận `?page&dark&vi&large&narrow`) |
| `lib/features/dev/gallery_screen.dart` | gallery |
| `lib/l10n/parts/core_{en,vi}.arb` | 18 chuỗi của component (ngày tương đối, "/month", "plan …", nhãn vuốt, Month/Year, nhãn tab "Overview"…) + `app_*.arb`/`generated/` sinh lại |
| `assets/fonts/BeVietnamPro/` | 4 TTF + `OFL.txt` + `add_tnum.py` (thêm `tnum`, idempotent) |
| `assets/icons/brand/` | `make_brand_assets.py` + ảnh nguồn cho 2 tool icon/splash (không đóng gói vào app) |
| `pubspec.yaml` | font, `lucide_icons_flutter: 4.0.1` (ghim), dev: `flutter_launcher_icons ^0.14.4`, `flutter_native_splash ^2.4.8` + cấu hình |
| `android/app/src/main/res/**` | mipmap + adaptive icon (`mipmap-anydpi-v26`, nền `#0e6b63`, inset 8%), splash `drawable*`, `values*/styles.xml`, `values-v31`/`values-night-v31` (Android 12 splash), `values/colors.xml` |
| `ios/Runner/Assets.xcassets/**`, `ios/Runner/Base.lproj/LaunchScreen.storyboard` | AppIcon (đủ cỡ), LaunchImage sáng/tối, LaunchBackground |
| `test/core/design_system_test.dart` | 36 test (bên dưới) |
| `docs/dev.md` | §1 lệnh mới, §2 cấu trúc, §3.7, **§8 UI conventions** mới |

**Không** sửa: `lib/domain`, `lib/data`, màn feature, `assets/catalog`, `store/`, `.github/`, `design/`, `APP.md`.
`ios/Runner.xcodeproj/project.pbxproj` và `ios/Runner/Info.plist` bị tool icon/splash sửa → **đã hoàn tác** (xem rủi ro).

## Bảng token → Flutter

| Token (tokens.json) | Flutter |
|---|---|
| `brand` / `on-brand` / `brand-soft` / `on-brand-soft` | `colorScheme.primary/onPrimary/primaryContainer/onPrimaryContainer` (+ `secondary*` cùng giá trị) · `context.colors.brand…` |
| `surface` · `surface-2` · `surface-sheet` · `bg` | `colorScheme.surface` · `surfaceContainerHighest` · `surfaceContainerHigh` (+ theme sheet/dialog) · `scaffoldBackgroundColor` |
| `ink` · `ink-muted` | `onSurface` · `onSurfaceVariant` |
| `line` · `line-strong` | `outlineVariant` (+ divider) · `outline` |
| `danger` / `on-danger` / `danger-soft` | `error` / `onError` / `errorContainer` |
| `warning` / `warning-ink` / `warning-soft` | `tertiary` / `onTertiaryContainer` / `tertiaryContainer` — dùng `context.colors.warning*` cho rõ nghĩa |
| `success*`, `chart-1…6`, `chart-other`, `tile-*`, `on-tile-light/dark`, `tile-ring`, `scrim`, `focus` | chỉ trong `AppColors` (`context.colors.success`, `.chartFor(cat)`, `AppColors.tilePalette`, …); `scrim` cũng là `colorScheme.scrim` + barrier của sheet/dialog |
| type `display … caption` | `AppType.display/amountLg/headline/title/titleSm/body/label/meta/caption`; TextTheme: display→displayLarge, amount-lg→displayMedium, headline→headlineLarge/Medium + displaySmall, title→titleLarge, title-sm→titleMedium, body→bodyLarge/Medium, meta→bodySmall(muted)/labelMedium, label→labelLarge/titleSmall, caption→labelSmall |
| `space-1…10` · `radius-*` · `tap-min`, `row-h`, `button-h`, `fab-size`, `tabbar-h` | `AppSpace.s1…s10` · `AppRadius.sm…full`, `tile24…80` · `AppSize.*` |
| `shadow-card` / `shadow-float` | `context.elevation.card` / `.float` (tối: card = viền 1px `line`) |
| Motion (README) | `AppMotion.fast 150 · countUp 240 · sheet 240 · dialog 200 · paidPop 220 · newRowFlash 1600 · confetti 1400` |

## Component + API ngắn (cho G–J)

Tất cả trong `import '../../core/widgets/widgets.dart';` — chi tiết + "dùng cho việc gì" ở `docs/dev.md` §8.2.

| Component | API |
|---|---|
| `ServiceTile` | `(name, colorValue, iconText, size 24/32/40/56/80, awaiting, trial, off, faded, badgeRingColor)` — **constructor cũ giữ nguyên**; `ServiceTile.onTileColor(c)` chọn chữ sáng/tối theo tương phản WCAG; không lớn theo cỡ chữ. `GhostTile` |
| `SubscriptionRow` | `(name, colorValue, iconText, state: normal/awaiting/trial/cancelled, meta, awaitingCount, badgeLabel, sharedCount, amount, amountMeta, onTap, onConfirm, onCancel, highlight, queued)` — trình bày thuần, caller tự dựng chuỗi meta. Vuốt: `SwipeActions` dùng lại được |
| `SpendHero` · `SpendStrip` · `CountUpText` | hero tổng chi: `(label, amount, format, approx, yearly, onPeriodChanged, segments: [SpendSegment(color, value)], leadingMeta, trailingMeta, footer)` |
| `AppButton` | `.primary/.tonal/.outline/.text/.danger` hoặc `kind:` (+ `dangerText`); `small`, `expand`, `icon`, `trailingIcon`, `loading`; `AppFab(onPressed, tooltip)`; `AppIconButton(icon, tooltip, onPressed)` |
| `AppChip` · `StatusBadge` · `ShareMark` | `AppChip(label, selected, onTap, icon, showCheck, fit)` · `StatusBadge.awaiting/.trial/.paid(label)` hoặc `(label, kind: BadgeKind.*, icon, large)` · `ShareMark(count)` |
| `AppSegmentedControl<T>` | `(segments: [AppSegment(value, label, count)], selected, onChanged, mini)` |
| `AppToggle` · `AppStepper` | `(value, onChanged)` · `(value, min, max, onChanged, decreaseLabel, increaseLabel)` |
| `AppBanner` | `(kind: BannerKind.warning/info/success/danger/neutral, icon, title, body, actionLabel, onAction)` |
| `EmptyState` · `NestArt` | `(title, body, art, actionLabel, actionIcon, onAction)` · `NestArt(kind: nest/empty/party/chart/welcome, width)` — minh hoạ tổ chim vẽ bằng CustomPainter theo token |
| `AppCard` · `AppGroup` · `SettingRow` · `SectionHeader` · `LargeTitle` · `AppTopBar` | card/nhóm có hairline thụt `dividerIndent` · hàng cài đặt (icon, label, subtitle, value, trailing, external, danger) · eyebrow + link · tiêu đề tab · top bar 52px |
| `showAppSheet` + `AppSheet` · `showAppDialog` + `AppDialog` · `showAppToast` | sheet (`required:` = không kéo/chạm nền để đóng) · dialog scale-in 200 ms · toast |
| `RadioRow` · `RadioRowGroup` · `RadioMark` *(bổ sung 05/11, theo yêu cầu phiên điều phối)* | `RadioRowGroup<T>(options: [RadioOption(value, title, subtitle, trailing)], value, onChanged, style: card/flat)`; `RadioRow.price(context, amount, suffix:)`; ≥ 48dp; chữ ≥ 150% → giá xuống dưới |
| `AmountField` · `AmountFormat` · `AmountInputFormatter` *(bổ sung 05/11)* | `(value (major units, null = trống), currency, onChanged, label, onCurrencyTap, showEditButton, conversion, helper, helperIcon, errorText, boxed, autofocus, focusNode, enabled, maxIntegerDigits)`; nhóm số theo locale khi gõ, giữ con trỏ, `.`/`,` = thập phân, tự thu nhỏ chữ cho vừa, `amount-lg` ≤ 38px ở chữ lớn, mọi nút ≥ 48dp |
| `AppDatePicker` · `showAppDatePicker` | tuần bắt đầu thứ Hai, today viền, chọn tô `brand`, ngày quá khứ mờ; sheet trả `LocalDate?` + dòng footer tuỳ ý |
| `AppTabBar` | đã dùng trong `AppShell` |
| `AppDates` · `perCycle` | `relative` (≤ 30 ngày → "in 3 days"/"còn 3 ngày", rồi "2 Feb 2027"/"2/2/2027"), `short`, `full`, `weekdayShort`, `weekdayLong`, `monthTitle`, `weekdayHeaders`; tiền dùng `l10n.money/amount` của lõi (đã đúng ₫260,000 / 260.000đ / $20.00) |

## Kiểm tra

- `flutter analyze` → *No issues found*. `flutter test` → **130 passed** (đợt bổ sung RadioRow/AmountField: **141 passed**, chạy trên bản checkout sạch tại HEAD vì thư mục chung đang có thay đổi dở của I/J). `dart run tool/gen_tokens.dart --check` và
  `dart run tool/merge_arb.dart --check` → OK.
- Test mới (`test/core/design_system_test.dart`): token khớp tokens.json + mapping ColorScheme; chữ trên 12 màu tile chọn đúng
  như ghi chú design và ≥ 4.5:1; tile không lớn ở 130%; ngày tương đối/ngày/hậu tố chu kỳ EN+VI; date picker bắt đầu thứ Hai;
  vuốt hàng (lộ Xác nhận + Huỷ, vuốt hết = xác nhận, hàng đã huỷ không vuốt); count-up đi qua giá trị trung gian; dải màu
  đủ cao + tỷ lệ; banner rơi nút xuống khi hẹp; segmented/toggle/stepper; tab bar 64px; dialog + sheet mở được;
  **gallery 6 trang × sáng/tối ở 360×800, VI, 130% không tràn** (nạp font Be Vietnam Pro thật trong test);
  **vùng chạm ≥ 44** (`iOSTapTargetGuideline`) trên 5 trang control.
- Test đã bắt 4 lỗi thật trước khi lên máy: `Semantics(scopesRoute)` thiếu `explicitChildNodes` (dialog sẽ crash),
  segment chỉ nhận chạm 36px, chip "AI" rộng 42px, tab bar cao 65px. Trên máy bắt thêm 1: dải màu hero cao 0 (đã thêm test).
- Máy thật: build APK debug, mở `--es route "/dev/gallery?page=N&dark=D"`, chụp `adb screencap`. **Vùng bong bóng chat Zalo
  (overlay cá nhân trên máy) đã được làm mờ** trong mọi ảnh; thanh trạng thái/điều hướng đã cắt.

### Ảnh (`notes/img/2026-11-05-design-system/`)
| Ảnh | Nội dung |
|---|---|
| `compare-overview-light.png` | mockup S2 ↔ hero + hàng trên máy |
| `compare-rows-swipe-light.png`, `compare-rows-dark.png` | mockup danh sách ↔ `SubscriptionRow` mọi trạng thái |
| `compare-datepicker-dark.png` | mockup S4 date picker ↔ `AppDatePicker` |
| `compare-dialog-light.png` | mockup S5 xoá ↔ `AppDialog` |
| `compare-splash-light.png`, `splash-android12-device.png` | splash mockup ↔ splash Android 12 thật |
| `gallery-{1..6}-*-{light,dark}.png` | 6 trang gallery, mỗi ảnh 2 màn (đầu + cuộn) |
| `compare-plan-sheet-light.png`, `compare-amount-light.png` *(bổ sung)* | mockup S3 plan sheet ↔ `RadioRowGroup`; mockup S4 giá ↔ `AmountField` |
| `gallery-7-form-inputs-{light,dark}.png` *(bổ sung)* | trang 7 gallery: `AmountField` (VND, USD + quy đổi, lỗi, boxed S6) + `RadioRow` card/flat |

## Chỗ lệch so với mockup

1. **Chữ số tabular**: mockup (CSS `tabular-nums` trên font không có `tnum`) thực ra vẽ số *tỷ lệ*; app vẽ số *tabular thật* →
   "₫1,074,467" hơi rộng hơn, chữ "1" thưa hơn. Có chủ đích (brief yêu cầu, và count-up không nhảy chiều rộng).
2. **Splash Android 12+** chỉ có mark trên nền (API hệ thống không cho chữ "Subnest"); Android ≤ 11 và iOS có cả mark + chữ.
   Mark trên Android 12 hiện không có khung bo góc (nền teal liền).
3. **Monogram**: tile lấy `iconText` của catalog; khi trống thì tự lấy 2 chữ đầu ("Netflix Premium" → "NP"), mockup dùng "N".
   Phiên H/B nên luôn có monogram trong catalog/form.
4. **Ngày**: `Fmt.date` của lõi vẫn ra "Nov 4, 2026" / "04/11/2026"; design dùng "4 Nov 2026". Tôi không sửa `core/utils`
   (ngoài phạm vi) mà thêm `AppDates.full/short/...` đúng design — **phiên UI nên dùng `AppDates`**, không dùng `l10n.date()`.
5. **Nhãn tab**: `commonTabHome` EN là "Home", design là "Overview" → tab bar dùng chuỗi mới `coreTabOverview`. `commonTabHome`
   giờ không ai dùng (phiên Core có thể xoá).
6. Badge dùng thử: mockup ghi "Trial", chuỗi lõi `commonStatusTrial` = "Free trial" → `SubscriptionRow(badgeLabel:)` cho ghi đè.
7. Icon Lucide của gói là bản Lucide mới hơn 0.460 → vài nét có thể khác chút; 54 tên khớp đủ.
8. ~~Sort sheet trong gallery dùng `RadioListTile`~~ → đã đổi sang `RadioRowGroup` (bổ sung 05/11).
9. `AmountField` khi chưa sửa hiện giá trị không có số 0 thừa ("$20" chứ không "$20.00"); placeholder "0.00" mờ. Con trỏ
   khi chèn giữa đứng sau dấu phân cách nhóm ("15,|234"), tương đương về logic.

## Dependency đã thêm

| Package | Loại | Lý do |
|---|---|---|
| `lucide_icons_flutter` **4.0.1** (ghim; 4.0.2 ra 04/11 chưa đủ 2 tuần) | runtime | Icon Lucide dạng font: dùng `Icon`/`IconTheme` như icon Material, tự tree-shake khi build release (chỉ giữ glyph dùng). Phương án SVG + `flutter_svg` cần thêm package render SVG, không ăn `IconTheme`, phải tự quản 54 file — nặng hơn khi dùng mà không nhẹ hơn khi chạy |
| `flutter_launcher_icons` ^0.14.4 | dev | sinh icon Android (cả adaptive) + iOS |
| `flutter_native_splash` ^2.4.8 | dev | splash sáng/tối Android ≤ 11, Android 12 API, iOS LaunchScreen |
| Font Be Vietnam Pro (OFL 1.1, google/fonts) | asset | không dùng `google_fonts` (không gọi mạng ngoài tỷ giá) |

## Việc dở / rủi ro

- **Màn placeholder vẫn dùng `AppTheme.warning/success` (deprecated)** — G sửa `home`, `subscription_detail` khi thay màn.
- ~~Thiếu radio row + ô nhập tiền~~ → **đã thêm `RadioRow`/`RadioRowGroup` và `AmountField`** (bổ sung 05/11, gallery trang 7
  "Form inputs", 11 test mới). Còn chưa có component riêng cho: thanh tìm kiếm (S3), lưới chọn dịch vụ onboarding, ô lịch tháng
  S8 (`cd`), confetti/check "Đã trả" — widget riêng của 1 feature, phiên G/H/I tự làm trong `features/<feature>/widgets/`.
- ~~S-50 (48dp) chưa đạt ở chip/segmented/toggle/stepper~~ → **đã nâng mọi component core lên ≥ 48dp** (đợt 3, theo yêu cầu
  phiên điều phối): `AppChip` (layout 48, pill 36, chip hẹp có 2 bên trong suốt tới 48), `AppSegmentedControl` (thường: track
  44 nhìn thấy; mini: 36), `AppToggle` 52 × 48, `AppStepper` (nút 48, track 44 vẽ lùi 2px), nút action của `AppBanner`, link
  `SectionHeader`, `AppIconButton`, ô ngày date picker (cả ô 48 cao, vòng tròn 44; sheet dùng lề 12 cho lưới → 7 cột ≥ 48dp
  ở màn 360). Thêm hằng `AppTouch.min` (`touch.dart`). Kích thước nhìn thấy có test giữ đúng mockup. Hệ quả: các control này
  cao thêm 4dp trong layout; hàng chip nên dùng `Wrap(runSpacing: -4)` để giữ khe 8. Test 48dp (`androidTapTargetGuideline`)
  chạy trên **cả 7 trang** gallery ở màn 390.
- **Sửa lỗi trợ năng**: tab bar, ô ngày date picker và nút tiền tệ dùng `Semantics(excludeSemantics: true)` nên **mất hành
  động chạm** với TalkBack/VoiceOver — đã truyền `onTap` vào Semantics, có test bấm qua semantics.
- **Chữ 200%**: cả 7 trang gallery không tràn ở 360 × 800 VI (đã đo).
- **`flutter_launcher_icons` làm hỏng `project.pbxproj`** (đổi `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES`
  thành `AppIcon`) và `flutter_native_splash` viết lại toàn bộ `Info.plist` → tôi đã hoàn tác cả hai; ghi trong `docs/dev.md` §1.
  Chưa build iOS kiểm icon/LaunchScreen (cần chạy workflow `ios.yml` của E — chạy tay trên GitHub).
- Android 13 *themed icon* (monochrome) chưa làm — cần một bản mark 1 màu; không bắt buộc.
- CI chưa chạy `dart run tool/gen_tokens.dart --check` (`.github/` ngoài phạm vi) — đề nghị phiên điều phối/E thêm 1 dòng.
- `docs/dev.md` §4 vẫn ghi part `common`/`notifications` thuộc Core; part mới `core` (chuỗi component) thuộc design system.
- App debug khởi động ~8–15 s trên A135F (JIT) — bình thường với debug, chưa đo release.

## Đề xuất cải tiến xưởng

1. **`tool/gen_tokens.dart` tái dùng được nguyên** cho app sau có export Claude Design (chỉ đổi đường dẫn + tên font) → đưa vào
   `playbook/templates/flutter/` (kèm `motion.dart`, `app_theme.dart` làm mẫu mapping). Tiết kiệm ~1/3 thời gian phiên design system.
2. **Gallery + bộ test "mọi trang × sáng/tối × VI × 130% × 360 + touch target"** là lưới an toàn rất rẻ: đã bắt 5 lỗi thật trước
   khi các phiên UI dùng component. Đưa `pumpUi`/`loadAppFonts` + vòng lặp gallery vào template test của xưởng; khuyến nghị mỗi
   phiên UI viết 1 test overflow tương tự cho màn của mình.
3. **Luôn nạp font thật trong widget test** khi kiểm tràn chữ — font test mặc định rộng ~2× nên báo tràn sai hàng loạt.
4. **Checklist font**: kiểm font có `tnum` chưa (`add_tnum.py` dùng lại được cho font OFL khác).
5. **Icon/splash generator**: sau khi chạy luôn `git diff ios/Runner.xcodeproj ios/Runner/Info.plist` và hoàn tác — đưa vào
   `playbook/checklists/release-ios.md`.
6. Route debug nhận query (`?page&dark&vi&large`) + `adb am start --es route` giúp chụp ảnh tự động không cần chạm — nên thành
   mẫu cho mọi app (ảnh store, so sánh với mockup).
