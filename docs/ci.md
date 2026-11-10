# Subnest — CI, ký app & phát hành (A001-subnest)

> Viết bởi phiên E `[A001-subnest] CI & signing` (2026-11-05). Đọc cùng `docs/dev.md` §7.

## 1. Workflow

| File | Chạy khi | Làm gì | Runner |
|---|---|---|---|
| `.github/workflows/ci.yml` | **Không chạy trên `dev`.** Push `main` (bỏ qua `*.md`, `docs/`, `store/`, `design/`, `notes/`) → chỉ **kiểm**. Tag `v*` hoặc chạy tay → kiểm **+ build** | Kiểm: `flutter pub get` → `merge_arb --check` → `build_runner` + `gen-l10n` + `git diff --exit-code` → `flutter analyze` → `flutter test`. Build (chỉ tag/chạy tay): `flutter build appbundle --release` (ký bằng upload key từ secrets) → in chứng chỉ ký → artifact `subnest-aab-<số lần chạy>` (giữ 30 ngày) | ubuntu (phút ×1) |

**Nhánh (WORKFLOW §7, từ 2026-11-05):** làm + push trên `dev` (tự chạy analyze/test trên máy trước khi push); phiên điều phối
kiểm xong mới `git push origin dev:main`. Cần file AAB để upload → chạy tay *Actions → CI → Run workflow* trên `main`, hoặc gắn tag
`vX.Y.Z` trên `main` (tag còn kích hoạt build iOS). Build local (§2) không tốn phút Actions.
| `.github/workflows/ios.yml` | **chỉ** chạy tay (*Actions → iOS → Run workflow*) hoặc push tag `v*` | kiểm `Info.plist` (`ITSAppUsesNonExemptEncryption=false`) + `PrivacyInfo.xcprivacy` (hợp lệ, có trong Copy Bundle Resources) → `flutter build ios --release --no-codesign` → kiểm bundle id/version trong `Runner.app` | macos (repo private: **phút ×10**) |

- Flutter cố định ở `FLUTTER_VERSION` (đầu mỗi workflow) = bản trên máy dev (`flutter --version`). Nâng Flutter ở máy dev
  ⇒ sửa số này cùng commit.
- Cache: Flutter SDK + pub (`subosito/flutter-action` `cache: true`), Gradle (`gradle/actions/setup-gradle`).
- Trên `main`/chạy tay, CI đặt `REQUIRE_RELEASE_SIGNING=true` ⇒ thiếu secrets thì **fail**, không lặng lẽ ra AAB ký debug.
  PR (không có secrets nếu từ fork) ⇒ cảnh báo + ký debug, vẫn chạy đủ kiểm tra.
- Không tự upload lên Play/App Store. Tải AAB: trang lần chạy → *Artifacts* → `subnest-aab-N` (file zip chứa
  `app-release.aab`), hoặc `gh run download <run-id> -n subnest-aab-N -D <thư mục>`.

## 2. Ký Android

**Upload key** (Play App Signing giữ app signing key thật; mình chỉ giữ upload key):

| Thứ | Ở đâu |
|---|---|
| Keystore | `C:\Users\Admin\keystores\A001-subnest\upload-keystore.jks` (PKCS12, RSA 4096, alias `upload`, ~27 năm) — **người dùng tự tạo 2026-11-05** (khoá cũ do Claude tạo đã bỏ, chưa từng upload), **ngoài mọi repo** |
| Mật khẩu + alias | `C:\Users\Admin\keystores\A001-subnest\key.properties` (store password = key password) |
| SHA-256 chứng chỉ upload | `85:BC:15:82:80:BC:54:F9:73:4D:DF:A5:AB:29:C5:76:A3:A7:C8:50:26:41:C1:B3:84:00:83:84:38:C8:08:6B` (đối chiếu với *Play Console → Test and release → App integrity → Upload key certificate*) |

`android/app/build.gradle.kts` tìm `key.properties` theo thứ tự: biến môi trường `ANDROID_KEY_PROPERTIES` (đường dẫn
file) → `android/key.properties` (đã git-ignore). Không thấy ⇒ bản release ký bằng **debug key** (chạy thử được, **không
upload được**); có `REQUIRE_RELEASE_SIGNING=true` thì báo lỗi thay vì rơi về debug.

### Build AAB ký ở máy local (Git Bash)
```bash
export PATH="/c/src/flutter/bin:$PATH"
export ANDROID_KEY_PROPERTIES="C:/Users/Admin/keystores/A001-subnest/key.properties" REQUIRE_RELEASE_SIGNING=true
flutter build appbundle --release
# → build/app/outputs/bundle/release/app-release.aab ; kiểm chữ ký:
keytool -printcert -jarfile build/app/outputs/bundle/release/app-release.aab | grep SHA256:
```
PowerShell: `$env:ANDROID_KEY_PROPERTIES="C:/Users/Admin/keystores/A001-subnest/key.properties"; $env:REQUIRE_RELEASE_SIGNING="true"; flutter build appbundle --release`.
Logo dịch vụ đã đóng gói sẵn trong app (`docs/dev.md` §7) — không cần khoá nào lúc build.

### GitHub secrets (repo `phamphuongphuongnd/A001-subnest`)

| Secret | Giá trị |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | base64 một dòng của `upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | `storePassword` trong `key.properties` |
| `ANDROID_KEY_PASSWORD` | `keyPassword` |
| `ANDROID_KEY_ALIAS` | `upload` |

Đặt/đặt lại (giá trị đi qua stdin, không lộ ra dòng lệnh/log) — chạy trong Git Bash ở thư mục repo app:
```bash
bash .github/scripts/set-android-secrets.sh C:/Users/Admin/keystores/A001-subnest
```
CI giải mã keystore vào `$RUNNER_TEMP`, ghi `key.properties` tạm, xoá ở bước cuối (`if: always()`).

### ~~Khoá Logo.dev~~ (bỏ 2026-11-10)

Logo dịch vụ giờ **đóng gói sẵn** (`assets/logos/png/`, `docs/dev.md` §7) — không còn `--dart-define=LOGO_DEV_KEY`, CI
không đọc secret đó nữa. Nếu đã tạo: có thể xoá secret `LOGO_DEV_KEY` trên GitHub và file
`C:/Users/Admin/keystores/A001-subnest/logo-dev.key` (không còn dùng).

### Phiên bản
`versionName`/`versionCode` lấy từ `pubspec.yaml` (`version: 1.0.0+1` ⇒ name `1.0.0`, code `1`). **Mỗi lần upload lên
Play phải tăng số sau `+`** (Play từ chối versionCode đã dùng, kể cả ở track test). Tag phát hành `vX.Y.Z` (WORKFLOW §7)
— push tag cũng kích hoạt build iOS.

### Manifest release (đã kiểm 2026-11-05)
- `targetSdk` = `compileSdk` = **36**, `minSdk` 24 (mặc định Flutter 3.47.8). Yêu cầu Play hiện hành: app mới/cập nhật
  phải target ≥ API 35 (từ 31/8/2025) — đạt; khi Google nâng mốc (thường tháng 8 hằng năm) ⇒ nâng Flutter hoặc đặt
  `targetSdk` trong `android/app/build.gradle.kts`.
- Quyền trong manifest gộp của AAB: xem `notes/2026-11-04-ci.md` (không có `AD_ID`, không exact alarm).

## 3. Sao lưu keystore — BẮT BUỘC

Mất upload key **không** mất app (Play App Signing giữ app signing key), nhưng phải xin Google reset upload key — mất
vài ngày, không phát hành được trong lúc chờ. Mất cả keystore lẫn mật khẩu khi chưa bật Play App Signing = không bao
giờ cập nhật được app.

1. Chép **cả thư mục** `C:\Users\Admin\keystores\A001-subnest\` (`upload-keystore.jks` + `key.properties`) vào **2 nơi
   khác máy này**: vd USB cất riêng + kho mật (Bitwarden/1Password: đính kèm file `.jks`, dán mật khẩu vào mục ghi chú).
2. Không gửi qua chat/email không mã hoá, không để trong Google Drive/OneDrive dạng thường, không bao giờ commit.
3. Thử khôi phục 1 lần: chép bản sao lưu về thư mục tạm, chạy
   `keytool -list -keystore <bản sao>/upload-keystore.jks` + nhập mật khẩu ⇒ thấy alias `upload` và SHA-256 như bảng trên.
4. Nếu lộ keystore/mật khẩu: Play Console → *App integrity* → *Request upload key reset*, tạo keystore mới, chạy lại
   script secrets.

## 4. Lần upload đầu lên Google Play (người dùng làm tay — lần đầu bắt buộc qua web)

Tài khoản cá nhân tạo sau 11/2023 ⇒ phải **closed testing ≥ 12 tester đã opt-in, liên tục ≥ 14 ngày** rồi mới xin
được production. Đếm ngày bắt đầu khi bản closed testing được duyệt và tester tham gia ⇒ làm sớm.

**Bước 0 — lấy AAB:** `C:\Users\Admin\keystores\A001-subnest\out\subnest-1.0.0+1.aab` (đã ký upload key), hoặc artifact
của lần chạy CI mới nhất (§1).

1. **Tạo app** — [play.google.com/console](https://play.google.com/console) → *Create app*:
   App name `Subnest: Subscription Tracker` · Default language `English (United States) – en-US` · *App* · *Free*
   (⚠ Free không đổi sang Paid được) · tick 2 ô cam kết (Developer Program Policies, US export laws) → *Create app*.
2. **Khai App content** (*Policy and programs → App content* / mục *Set up your app* trên Dashboard): dán theo
   `store/forms/google-play.md` (privacy policy URL, app access, ads, content rating, target audience 18+, data safety
   "No data collected", advertising ID **No**, government/financial/health…). Store listing: theo `store/listing/`
   (cần icon 512, feature graphic 1024×500, ≥ 2 ảnh chụp — có thể dùng tạm ảnh placeholder cho closed testing nhưng
   vẫn phải qua review).
3. **Tạo track closed testing** — *Test and release → Testing → Closed testing* → dùng track mặc định *Closed testing -
   Alpha* (hoặc *Create track*) → *Manage track*:
   - *Countries/regions*: chọn tất cả (hoặc ít nhất VN + nơi tester ở).
   - *Testers*: tạo email list (hoặc Google Group) với **≥ 12 Gmail** (tốt nhất 15–20 để dự phòng người bỏ) — danh sách
     + thư mời ở `store/testers/`. Đặt *Feedback URL or email*. *Save*.
4. **Tạo release** — trong track đó → *Create new release*:
   - Lần đầu Play hỏi **app signing key**: chọn *Use Google-generated key* (= bật **Play App Signing**, mặc định — đừng
     chọn "export and upload your own key"). Từ đây key mình giữ chỉ là upload key.
   - *App bundles → Upload* → chọn file `.aab` ở Bước 0. Chờ xử lý xong (thấy `1 (1.0.0)`).
   - *Release name*: `1.0.0 (1)` · *Release notes* (en-US, vi): "First test build." → *Next*.
   - Đọc cảnh báo ở trang *Review* (cảnh báo vàng không chặn; lỗi đỏ phải sửa — thường là App content chưa điền đủ) →
     *Save* → *Go to overview* → **Send changes for review** (trang *Publishing overview*). Review lần đầu: vài giờ –
     vài ngày.
5. **Mời tester** — sau khi duyệt, track hiện *How testers join your test* → copy **link opt-in** (web) gửi tester
   (mẫu thư ở `store/testers/`). Tester phải bấm *Become a tester* bằng đúng Gmail trong danh sách rồi cài từ Play.
   Đếm 14 ngày tính theo tester **đã opt-in**; nhắc họ giữ app, không rời chương trình.
6. **Kiểm** — *Test and release → App integrity → App signing*: thấy *Upload key certificate* SHA-256 khớp bảng §2.
   *Pre-launch report* (tự chạy trên máy ảo) — đọc crash/cảnh báo nếu có.
7. **Sau ≥ 14 ngày & ≥ 12 tester**: Dashboard → *Apply for production* (trả lời câu hỏi về quá trình test) → được duyệt
   thì tạo release Production bằng AAB mới (tăng `+N`).

Các lần upload sau: tăng `version` trong `pubspec.yaml` → push → lấy AAB từ artifact CI → *Create new release* trên track
tương ứng. (Tự động upload qua Play Developer API/`r0adkll/upload-google-play` có thể thêm sau — cần service account.)

## 5. iOS — trạng thái & việc khi có Apple Developer

**Hiện tại:** `ios.yml` build `--no-codesign` để chắc dự án iOS biên dịch được trên macOS (bundle `com.phiotron.subnest`,
iOS ≥ 15.5; widget extension ≥ 16.0). Không tạo `.ipa`, không TestFlight. Đã có: `ITSAppUsesNonExemptEncryption=false` trong `Info.plist`;
`ios/Runner/PrivacyInfo.xcprivacy` (không tracking, không thu thập dữ liệu; API *File timestamp* lý do `C617.1` cho
SQLite/drift đọc metadata file trong container app) — plugin có manifest riêng thì Xcode tự gộp.

**Khi có Apple Developer Program ($99/năm) — CHƯA làm:**
1. *Certificates, IDs & Profiles → Identifiers*: đăng ký App ID `com.phiotron.subnest` (capability: Push Notifications
   **không** cần — app chỉ dùng thông báo cục bộ).
2. *App Store Connect → Apps → +*: tạo app (name, primary language en-US, bundle ID trên, SKU `A001-subnest`).
3. *App Store Connect → Users and Access → Integrations → App Store Connect API → Team Keys*: tạo key quyền
   **App Manager** → tải `AuthKey_XXXX.p8` (chỉ tải được 1 lần — cất cùng chỗ keystore, **không commit**), ghi *Key ID*,
   *Issuer ID*.
4. GitHub secrets: `ASC_KEY_ID`, `ASC_ISSUER_ID`, `ASC_KEY_P8_BASE64` (base64 của `.p8`), `APPLE_TEAM_ID`.
5. Sửa `ios.yml`: thay bước build bằng `flutter build ipa --release --export-options-plist=ios/ExportOptions.plist`
   với ký tự động qua API key (`xcodebuild -allowProvisioningUpdates -authenticationKeyPath … -authenticationKeyID …
   -authenticationKeyIssuerID …`; đặt `DEVELOPMENT_TEAM` = Team ID) — Xcode tự tạo certificate *Apple Distribution*
   + provisioning profile *App Store*, không cần `.p12` thủ công. `ExportOptions.plist`: `method = app-store-connect`,
   `signingStyle = automatic`, `teamID`.
6. Upload TestFlight: `xcrun altool --upload-app -f build/ios/ipa/*.ipa -t ios --apiKey $ASC_KEY_ID --apiIssuer
   $ASC_ISSUER_ID` (đặt `.p8` vào `~/private_keys/`) hoặc action `apple-actions/upload-testflight-build`.
7. Build number = số sau `+` trong pubspec — tăng mỗi lần upload. Kiểm *Generate Privacy Report* trên archive (không có
   "collected data") — nếu không có Mac, tải `.xcarchive` làm artifact rồi nhờ máy Mac/bỏ qua (App Store Connect cũng
   cảnh báo khi thiếu khai báo API).
8. Tester nội bộ TestFlight (≤ 100, không cần review) → thêm external testers (cần Beta App Review).

## 6. Tiết kiệm phút macOS
- iOS **không** chạy theo push. Chỉ chạy tay khi đổi `ios/`, plugin native, hoặc trước khi gắn tag phát hành.
- Phút macOS đo được mỗi lần build: xem `notes/2026-11-04-ci.md`. Repo private: 1 phút macOS = 10 phút quota
  (gói Free: 2.000 phút/tháng ⇒ ~200 phút macOS).

### Kết quả build iOS không ký trên `dev` (2026-11-10, phiên R)
- Lần 1 [42794154802](https://github.com/phamphuongphuongnd/A001-subnest/actions/runs/42794154802) đỏ 2m14s: `pod install` báo `google_mlkit_commons` cần iOS ≥ 15.5.
- Nâng `IPHONEOS_DEPLOYMENT_TARGET` Runner 15.0 → 15.5 ⇒ lần 2 [42794545752](https://github.com/phamphuongphuongnd/A001-subnest/actions/runs/42794545752) xanh 2m37s (`Runner.app` 81.7MB, bundle `com.phiotron.subnest` 1.0.0). Chưa có `ios/Podfile` trong repo (Flutter tự sinh khi build).
- Bước *Check bundle* chưa kiểm `PlugIns/SubnestWidgetExtension.appex` — có thể thêm lần sau nếu muốn chắc extension được nhúng.
