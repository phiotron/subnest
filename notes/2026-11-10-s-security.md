# [A001-subnest] S Bảo mật — 2026-11-10 (phiên con S)

Theo APP.md "Quyết định 2026-11-10 — Sao lưu, Bảo mật, Widget, Làm tròn" ý 5–8 + CONTEXT.md (App lock, Privacy
screen). Bản tham chiếu: A002 `features/lock/{app_lock,lock_screen,pin_pad}.dart`, `data/pin_service.dart`,
`settings/secure_window.dart`, `VigonNative.swift` (F-11 AC-31..34, F-22 AC-56, D-017, D-022).
Commit trên `dev` (chưa push): `335971f` (WIP lõi) + commit cuối (test, iOS, sửa nhỏ) — xem `git log`.

## Đã làm
1. **PIN** (`lib/features/lock/pin_service.dart`, chép A002 + chỉnh): 4 số; muối ngẫu nhiên 16 byte + SHA-256 lặp
   20.000 vòng; chỉ lưu `pin_hash`, `pin_salt`, `pin_install_id` trong `SecretStore` (Keystore/Keychain,
   `secretStoreProvider` có sẵn của B — **không sửa `secret_store.dart`**). So sánh thời gian hằng.
   - **D-017 cài lại iOS**: mã cài đặt ngẫu nhiên ghi cả Keychain lẫn bảng `settings` (khoá `pinInstallId`, KHÔNG
     thuộc `backupKeys` → không vào file sao lưu, khôi phục giữ mã của máy). Khác A002: `isEnabled()` **đọc DB trước**
     — DB không có mã ⇒ chưa từng đặt PIN với DB này ⇒ tắt, không chạm Keychain (mở app nhanh; PIN Keychain cũ
     không bao giờ khoá bản cài mới; dọn PIN cũ chạy nền).
2. **Trạng thái khoá** (`app_lock.dart`): `checking → locked/unlocked`; khoá khi khởi động nguội và khi quay lại sau
   **> 1 phút** ở nền (tính từ lần `onHide` đầu, dùng `clockProvider`); Keystore lỗi ⇒ khoá (thấy "Quên mã" thay vì màn
   trắng); không có plugin (test/desktop) ⇒ mở. `pinEnabledProvider` (FutureProvider) cho Cài đặt + widget.
3. **Màn khoá** (`lock_screen.dart`): `LockGate` đặt ở `MaterialApp.router(builder:)` trong `lib/app.dart` — **ngoài
   router, không redirect**: các route vẫn mount nhưng `Offstage` (không vẽ, không chạm, ngoài cây semantics) +
   `TickerMode` tắt; bàn phím của ô nhập bên dưới bị bỏ focus khi khoá. Deep link (thông báo `launchRoute`/`taps`, widget
   `initialLink`/`taps`) vẫn push vào router như cũ ⇒ nằm sau màn khoá, nhập đúng PIN là thấy đúng màn. **Không sửa
   `lib/core/router/**`.**
   - Nút Back hệ thống khi đang khoá: đóng hộp thoại của màn khoá, không thì `SystemNavigator.pop()` (rời app) —
     không bao giờ pop route ẩn bên dưới (A002 không chặn chỗ này).
   - **Quên mã**: hộp "Quên mã PIN?" (Subnest không có máy chủ…) → `BackupActions.deleteAll(context, ref)` (2 bước
     của B) → true thì `router.go('/onboarding')` + mở khoá. Màn khoá không có `GoRouter` phía trên (nằm ngoài
     router) nên `deleteAll` tự `GoRouter.maybeOf` = null; `LockGate` nhận `router` để tự `go`. Huỷ bước nào cũng về màn khoá.
4. **Cài đặt › Bảo mật** (`settings/security_section.dart`, chèn sau nhóm Dữ liệu trong `settings_screen.dart`):
   `SettingRow` + `AppToggle` — "Khoá mã PIN" (dòng phụ = cảnh báo quên mã), "Che nội dung khi chuyển app" (ghi chú
   Android/iOS khác nhau). Bật PIN: màn toàn khung `PinSetupScreen` (nhập 2 lần; cảnh báo ở lần đầu; lệch → về lần
   đầu + rung nhẹ); tắt: `PinCheckScreen` phải đúng mã. Back = huỷ. (`lib/features/lock/pin_screens.dart`,
   bàn phím `pin_pad.dart` theo design system A001: `surface2`, `AppType.headline`, chấm 16px, dòng lỗi cao cố định.)
5. **Che nội dung** (`privacy_screen.dart`): công tắc độc lập, mặc định tắt, lưu dòng `settings` `privacyScreen`
   (không thuộc `backupKeys`; Xoá toàn bộ xoá mọi dòng ⇒ tự tắt). `privacyScreenSyncProvider` (watch ở `app.dart`) đẩy
   giá trị qua kênh `subnest/secure` khi mở app và mỗi lần đổi (theo stream DB ⇒ cả khi khôi phục/xoá toàn bộ).
   - Android `MainActivity.kt`: `FLAG_SECURE` trong `configureFlutterEngine` (giữ nguyên dòng của B, W).
   - iOS `AppDelegate.swift`: `SecureSceneHandler` (`FlutterSceneLifeCycleDelegate`, đăng ký `addSceneDelegate` trong
     `SubnestNative.register`) phủ `PrivacyCoverView` (màu `bg` sáng/tối + ảnh `LaunchImage`) khi
     `sceneWillResignActive`/`DidEnterBackground`, gỡ khi `DidBecomeActive`. Chép A002 `VigonSceneHandler`.
6. **Nối widget**: `appLockEnabledProvider` (W) = `ref.watch(pinEnabledProvider)` ⇒ PIN bật/đang tải/lỗi → widget chỉ
   "Đã khoá bằng PIN". **Thông báo nhắc không đổi.**
7. **Xoá toàn bộ** (`backup_actions.dart` chỗ [S · App lock]): thêm bước `pinService.disable()` + invalidate
   `pinEnabledProvider`. Câu xác nhận `settingsDeleteAllConfirm` EN/VI thêm "…và khoá mã PIN".
8. Chuỗi EN+VI: `lib/l10n/parts/security_{en,vi}.arb` (17 khoá `security*`). Đã merge_arb + gen-l10n để biên dịch;
   **không commit** `lib/l10n/app_*.arb`, `lib/l10n/generated/**`.

## Kiểm tra
- `flutter analyze` sạch.
- `test/features/lock/` **39 xanh**:
  - `pin_service_test` — khớp/sai, chỉ 4 số, chỉ băm + muối trong SecretStore (không có PIN, DB chỉ có mã cài đặt),
    muối mới mỗi lần, tắt xoá hết, đổi PIN giữ mã cài đặt, **D-017** (DB mới → tắt + dọn; DB cùng → giữ; mã khác →
    dọn), mã cài đặt không vào file sao lưu và khôi phục giữ nguyên.
  - `lock_state_test` — cold start khoá/mở, Keychain cũ sau cài lại, Keystore hỏng → khoá, không plugin → mở;
    **timeout bằng đồng hồ giả**: đúng 1 phút vẫn mở, 1:01 khoá, tính từ lần ẩn đầu, resume không ẩn (kéo thông báo)
    không khoá, PIN tắt giữa chừng; cờ widget theo PIN (đang tải = khoá).
  - `lock_app_test` — qua **`SubnestApp` + router thật**: không PIN mở thẳng + widget có dữ liệu; có PIN → màn khoá,
    route ẩn, widget `locked` và **không lần ghi nào có tên gói**; sai → "Wrong PIN"; đúng → Tổng quan; **chạm widget
    lúc mở nguội** và **chạm thông báo lúc mở nguội** → màn khoá rồi đúng Chi tiết; vòng đời: 30 s không khoá, 2 phút
    khoá, chạm widget khi đang khoá → sau PIN vào Chi tiết; **Back** khi khoá gọi `SystemNavigator.pop` và không pop
    route ẩn; **Quên mã** huỷ ở bước giải thích/bước 2 không mất gì, đi hết → Onboarding, PIN + mã cài đặt xoá, dữ liệu xoá.
  - `privacy_screen_test` — **kênh giả**: mở app gửi `setSecure(false)`, đã lưu bật → `true`, đổi áp dụng ngay + lưu
    DB, Xoá toàn bộ → `false`, không thuộc backupKeys, kênh lỗi/không có không ném.
- `test/features/settings/security_settings_test.dart` **7 xanh**: nhóm nằm sau Dữ liệu, trước Giới thiệu; nhãn VI +
  ghi chú iOS; bật PIN 2 lần (lệch → làm lại); Back khi đặt → vẫn tắt; tắt cần đúng mã; công tắc che nội dung lưu DB;
  Xoá toàn bộ tắt PIN + che nội dung.
- Test cũ dựng `SubnestApp` (`app_flow_test`, `home/flows_test`, `onboarding/add_flows_test`) vẫn xanh — đây là lý do
  `isEnabled()` đọc DB trước: trong widget test, gọi `flutter_secure_storage` thật không bao giờ trả lời (fake async)
  ⇒ màn khoá kẹt ở `checking`.
- `flutter test` toàn bộ (2026-11-10): **967 xanh, 2 đỏ** — `settings_screens_test` "S10 list" (nhóm Bảo mật đẩy
  ghi chú Dữ liệu ra khỏi màn khi cuộn tới ghi chú quyền riêng tư → test cuộn tới từng ghi chú, đã sửa, xanh) và
  `subscription_detail_screen_test` "S5 Edit" (pumpAndSettle hết giờ khi CPU bận — lỗi treo đã biết trong APP.md; chạy
  lại xanh). Chạy lại 2 file đó: 75 xanh.
- `flutter build apk --debug` OK (`build/app/outputs/flutter-apk/app-debug.apk`).

## Thử máy thật — Galaxy A13 (`R58TC12SRZW`, APK debug `a5f5724`, 2026-11-10 15:05–15:21)
Phương xác nhận máy không có dữ liệu thật (qua điều phối). Lái bằng `adb -s R58TC12SRZW` + `uiautomator dump`; ảnh ở
`notes/img/2026-11-10-s-security/`. **Tất cả ĐẠT:**
| Ca | Kết quả | Ảnh |
|---|---|---|
| Cài đặt › nhóm "BẢO MẬT" ngay sau Dữ liệu, 2 công tắc tắt | ĐẠT | `01-settings-security.png` |
| Bật PIN: "Đặt mã PIN 4 số" + cảnh báo; nhập lệch → "Hai lần nhập không khớp. Thử lại." về bước 1; nhập đúng 2 lần → công tắc bật | ĐẠT | `02-pin-setup.png`, `03-pin-mismatch.png`, `04-pin-on.png` |
| Về nền ~1,5 phút → mở lại thấy màn khoá | ĐẠT | `05-locked-after-1min.png` |
| Sai mã → "Sai mã PIN"; đúng → về đúng màn Cài đặt đang mở | ĐẠT | `06-wrong-pin.png` |
| Về nền 20 giây → không khoá; `force-stop` rồi mở → khoá | ĐẠT | — |
| Back trên màn khoá → rời app (launcher lên trên) | ĐẠT | — |
| Chạm widget (intent `es.antonborri.home_widget.action.LAUNCH`, `subnest://widget/subscription/<LANDR>`) khi app tắt → màn khoá → PIN → Chi tiết LANDR | ĐẠT | `07-widget-link-after-pin.png` |
| Dữ liệu widget (`run-as … HomeWidgetPreferences.xml`): PIN bật → chỉ `{"state":"locked","locked":"Đã khoá bằng PIN"}`, không tên/số tiền; tắt PIN → `list`; sau Xoá toàn bộ → `empty`. Máy chưa đặt widget Subnest nên không chụp widget (W thử) | ĐẠT | — |
| Tắt PIN: sai mã → "Sai mã PIN", đúng → tắt | ĐẠT | — |
| Che nội dung bật: `screencap` ra **0 byte** (FLAG_SECURE); thẻ app gần đây **trắng**, cả khi mở nguội (áp dụng khi mở app) | ĐẠT | `08-recents-card-privacy-on.png` (chỉ cắt thẻ) |
| Quên mã → "Quên mã PIN?" → Xóa toàn bộ dữ liệu → Xóa → Xóa hết → onboarding **English**, bước tiền tệ chọn sẵn **USD**; câu xác nhận có "…và khoá mã PIN" | ĐẠT | `09-after-forgot-onboarding.png`, `10-onboarding-usd.png` |
| Sau Quên mã: `FlutterSecureStorage.xml` rỗng (`<map />`), DB 0 gói, bảng `settings` chỉ còn `ratesFetchedAt` (không `pinInstallId`, không `privacyScreen`), chụp màn hình lại được | ĐẠT | — |

- **Lỗi thấy trên máy, đã sửa:** màn đặt/tắt PIN mở từ Cài đặt vẫn hiện thanh tab dưới bàn phím (push vào navigator của
  nhánh Cài đặt) → `PinActions` đẩy lên **root navigator**; thêm test trong `lock_app_test.dart` (app thật: không có
  `AppTabBar` trên màn đặt PIN, bật xong widget `locked` ngay). APK trên A13 là bản trước khi sửa.
- Thẻ cũ trong danh sách gần đây: task mở từ trước khi bật Che nội dung giữ ảnh chụp cũ cho tới khi task đó bị đóng (hành
  vi Android). Nhiều task Subnest (#159–#161) là do tôi mở bằng `am start`/`force-stop`, không phải người dùng thường.
- **Không lưu** ảnh nguyên màn hình chính/app gần đây: hình nền là ảnh cá nhân của Phương → chỉ giữ ảnh cắt riêng thẻ app.
- Máy trả cho W lúc 15:21: Subnest đang ở onboarding bước 3, PIN + Che nội dung tắt.

## Lệch so với A002 (và lý do)
- `isEnabled()` kiểm mã cài đặt trong DB trước Keychain (xem trên). A002 đọc Keychain trước.
- Chặn nút Back khi khoá (A002 để lọt xuống router ẩn).
- Không có cài đặt "Hiện số tiền trên widget" như A002: A001 chốt PIN bật → widget chỉ "Đã khoá bằng PIN" (ý 9).
- Lớp phủ iOS dùng ảnh `LaunchImage` có sẵn (A002 có asset riêng `PrivacyLogo`).

## Việc dở / rủi ro
- Đã thử máy thật (mục trên). **Chưa thử trên máy thật:** chạm thông báo nhắc khi đang khoá (có test widget qua app thật),
  widget thật trên màn hình chính khi bật PIN (W thử).
- **Swift chưa biên dịch** (máy Windows) — `SecureSceneHandler` chép A002 (A002 đã qua CI macOS), cần CI/Mac kiểm.
- Khi khoá do > 1 phút, ảnh trong Recents vẫn là màn trước khi ra nền nếu Che nội dung tắt (như A002, đúng thiết kế).
- Đang ở hệ thống chọn file/thư mục (khôi phục, chọn thư mục sao lưu) > 1 phút thì quay lại bị khoá (như A002).
- Commit `5a9f2b9` của W đã gom luôn mấy dòng nối của S trong `lib/app.dart`, `widget_sync.dart`, `MainActivity.kt`
  (cùng chạy trên `dev`) ⇒ riêng commit đó không biên dịch (thiếu `lib/features/lock/`), từ `335971f` trở đi OK.

## Đề xuất cải tiến xưởng
- Khi chép tính năng giữa app, ghi rõ trong brief "file dùng chung với phiên khác" + ai commit; lần này W commit cả
  hunk của S. Hoặc: phiên nối (S) chỉ sửa file dùng chung SAU khi phiên kia commit.
- `features/lock/` (PIN service, lock gate, pin pad) + kênh `secure` là ứng viên package dùng chung A001/A002 (cùng
  giao thức, chỉ khác tên kênh + design system) — gom khi có app thứ 3 hoặc khi làm vân tay cho cả hai.
- Mẫu test "mở nguội có PIN qua root widget thật" (`lock_app_test.dart`) dùng lại được cho A002.
