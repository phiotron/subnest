# [A001-subnest] UI Settings — báo cáo phiên con J

> Phiên điều phối #2 · 2026-11-05 · Màn S10 Cài đặt + các màn con, kiểm chuỗi thông báo S12.
> Không dùng điện thoại thật: kiểm bằng widget test + ảnh chụp từ test (font Be Vietnam Pro + icon Lucide thật).

## Kết quả nhanh

- S10 + 9 màn/trạng thái con theo mockup png 48–56, sáng/tối, EN/VI; thêm Điều khoản, Giấy phép, bản privacy/terms trong app.
- `flutter analyze` sạch. Test Settings: **131 xanh** (`test/features/settings/`, gồm ma trận 12 màn × sáng/tối × EN/VI ×
  360/390 × chữ 100/130/200% không tràn). Toàn bộ `flutter test` lúc kiểm: 384 xanh, 3 đỏ — **cả 3 ở
  `test/features/insights/`** (phiên I đang sửa dở, chưa commit), không liên quan Settings.
- Không sửa `lib/core`, `lib/domain`, `lib/data`, `pubspec.yaml`, router, feature khác.

## Đã làm / file

| File (`lib/features/settings/`) | Nội dung |
|---|---|
| `settings_screen.dart` | **S10** (png 48, 49): Tiền (Tiền tệ chính, Tỷ giá "Auto · 2 h ago"/"Built-in"/"Set by you") · Nhắc nhở (Nhắc trước, Giờ nhắc → TimePicker `dialOnly`, Thông báo Bật/**Tắt màu cảnh báo**) · Giao diện & ngôn ngữ · Sao lưu (banner > 30 ngày + nút "Back up" → màn Sao lưu; Xuất JSON, Xuất CSV, Khôi phục ngay tại chỗ; "Last backup: …") · Giới thiệu (Phiên bản, Chính sách quyền riêng tư, Điều khoản, Giấy phép mã nguồn mở, Đánh giá Subnest, Gửi góp ý) · thẻ 🔒 cuối trang |
| `appearance_sheet.dart` | png 50: Theme segmented (Hệ thống/Sáng/Tối) + Ngôn ngữ (`RadioRowGroup` flat: Theo hệ thống "English (from your phone)" / English / Tiếng Việt), áp dụng ngay, nút "Done" |
| `rates_screen.dart`, `rates_status.dart` | png 51/52: intro, cặp "1 USD → **25,400 VND**" + "Auto · updated 2 hours ago"/"Set by you"/"Auto · from 3 days ago (offline)", banner offline, "Update now" (loading), ghi chú, ghi công Exchange Rate API (mở link). Mở màn → `refreshIfStale()`; lần fetch gần nhất lỗi ⇒ trạng thái offline |
| `rate_override_sheet.dart` | png 53: "USD → VND", toggle "Use automatic rate" (+ tỷ giá tự động, cập nhật bao lâu), ô "Your rate · 1 USD =" chữ `amount-lg`, xem trước "ChatGPT Plus becomes ≈ ₫500,000/month", kiểm > 0, "Save my rate", "Restore automatic" |
| `reminders_screen.dart` | png 54: banner "Notifications are off" + **Open settings** (mở trang thông báo của app trong cài đặt hệ thống — S-40: giải thích, không ép), segmented Tắt/Đúng ngày/1/3/7, giờ nhắc, ghi chú, **xem trước** bằng đúng chuỗi thông báo S12 + khoản gia hạn gần nhất thật. Bản debug có thêm "Gửi nhắc thử" |
| `backup_screen.dart`, `backup_actions.dart` | png 55/56: banner "It's been 42 days…", Xuất JSON/CSV (share sheet), Khôi phục (chọn file → kiểm → dialog: tên file, "It holds N subscriptions and M payments", Gộp (mặc định)/Thay thế, nút đổi sang **danger "Replace my data"** khi chọn Thay thế), "Last backup: 24 Sep 2026 · subnest-backup-2026-09-24.json", toast thành công/lỗi |
| `currency_screen.dart` | restyle theo png 04 (ô tìm, tile ký hiệu, mã + tên, dấu ✓), tìm **không dấu** ("dong" ra "Việt Nam đồng"), tên tiền tệ VI. Giữ constructor `CurrencyScreen({onPicked})` |
| `legal_screen.dart`, `legal_texts.dart` | Màn hiển thị privacy policy / điều khoản **trong app** (S-13) từ bản sao `store/legal/*.md` (EN/VI theo ngôn ngữ app), parser Markdown nhỏ (#, ##, đoạn, `- `, `1. `, **đậm**), chọn chép được |
| `licenses.dart` | `AppLicenses.register()` thêm vào `LicenseRegistry`: **Be Vietnam Pro (OFL 1.1)** và **Lucide (ISC + MIT Feather)** — gói `lucide_icons_flutter` chỉ có LICENSE MIT của wrapper. `showLicensePage` có icon app, phiên bản (S-70) |
| `settings_actions.dart` | giờ nhắc, mở cài đặt thông báo hệ thống, privacy/terms (URL nếu có, không thì bản trong app), licences, đánh giá (`market://` → https Play; iOS cần App Store id), góp ý `mailto:phamphuongphuongnd@gmail.com?subject=Subnest feedback (1.0.0 (1))`, không có app mail → toast hiện địa chỉ |
| `settings_platform.dart` | seam `SettingsPlatform` (mở URL, share, chọn file **kèm tên file**, mở cài đặt thông báo qua singleton `FlutterLocalNotificationsPlugin().openAppNotificationSettings()` — không thêm package) + `settingsPlatformProvider` để test giả lập |
| `settings_format.dart` | "2 h ago"/"2 hours ago"/"2 giờ trước", ngày giữa 2 mốc, luật > 30 ngày, tên file sao lưu, hiển thị/parse tỷ giá theo locale (`25,400` / `25.400`, `0.0000394`) |
| `app_info.dart` | **mọi hằng số "Giới thiệu" một chỗ**: `kAppVersion`/`kAppBuild`, `kPrivacyPolicyUrl` (TODO), `kTermsUrl` (TODO), `kSupportEmail`, `kAndroidPackage`, `kAppStoreId` (TODO) |
| `widgets/settings_bits.dart` | `ValueRow` (giá trị dạt phải — xem lỗi core bên dưới; ≥ 150% chữ thì giá trị xuống dòng dưới nhãn), `ListNote`, `PrivacyNote`, `NotificationPreview` |
| `widgets/app_mark.dart` | icon app vẽ bằng `CustomPainter` theo hình học `mark()` của mockup (dùng cho xem trước thông báo + trang giấy phép) |
| `lib/l10n/parts/settings_{en,vi}.arb` | viết lại theo chữ mockup (bỏ key cũ không ai dùng ngoài Settings) |
| `lib/l10n/parts/notifications_en.arb` | `don't` → `don’t` (khớp png 58). Phần còn lại đã khớp EN + VI (có test) |
| `lib/l10n/app_*.arb`, `generated/` | sinh lại từ part **đã commit** + part của mình (không gói key chưa commit của phiên Lịch/Thống kê) |
| `test/features/settings/` | `settings_harness.dart` (DB in-memory, fixture §8, fake platform, MockClient tỷ giá, font thật, `shot()`), `settings_screens_test.dart` (24 test hành vi + trợ năng), `settings_shots_test.dart` (96 tổ hợp không tràn + chụp ảnh), `settings_content_test.dart` (privacy/terms = store/legal, OFL = file font, phiên bản = pubspec, định dạng, chuỗi S12 EN/VI) |

## Ảnh (`notes/img/2026-11-05-ui-settings/`)

Chụp từ widget test (`flutter test test/features/settings/settings_shots_test.dart --dart-define=SHOTS=true`), khung
390×844 (360×800 cho chữ lớn), thanh trạng thái/home indicator để trống.

| Ảnh | Nội dung |
|---|---|
| `compare-{48…56}-*-light.png` | mockup sáng ↔ app sáng **EN** |
| `compare-{48…56}-*-dark.png` | mockup tối ↔ app tối **VI** |
| `*-light-vi-360-130.png`, `*-light-vi-360-200.png` | mọi màn ở 360, tiếng Việt, chữ 130% / 200% |
| `57-currency-*`, `58-privacy-*`, `59-terms-*` | màn không có mockup riêng (sáng EN, tối VI) |

## Chỗ lệch so với mockup (có chủ đích / do lõi)

1. **Tab bar vẫn hiện ở màn con** trên app thật: route `/settings/rates|backup|currency` nằm trong nhánh tab của router (core);
   Nhắc nhở + Privacy/Terms tôi `Navigator.push` trong nhánh cho đồng bộ. Mockup 51–56 không có tab bar → xem *Việc cho
   phiên điều phối* 1.
2. **Privacy policy / Terms**: icon `›` (mở trong app) thay vì `external-link` cho tới khi có URL thật. Thêm 2 hàng
   **Điều khoản sử dụng** và **Giấy phép mã nguồn mở** (brief yêu cầu, mockup không có).
3. **Đánh giá Subnest bị ẩn trên iOS** khi `kAppStoreId == null` (không nút chết). Android mở Play theo package id.
4. Phiên bản hiện `1.0.0 (1)` (mockup `1.0 (1)`); giờ nhắc EN `9:00 AM` theo đồng hồ 12/24h của máy (mockup `9:00`).
5. Tấm ghi đè tỷ giá: mở ra với toggle **bật** nếu cặp đang tự động (mockup vẽ trạng thái đang nhập tay); nút chính là
   "Done" khi toggle bật; "Restore automatic" chỉ hiện khi cặp đang đặt tay.
6. **"Update now" không bị vô hiệu khi offline** (mockup làm mờ): dùng làm nút thử lại — nút mờ không bấm được sẽ kẹt người
   dùng khi mạng có lại mà màn chưa biết. Chỉ mờ + loading khi đang tải.
7. Dialog khôi phục: chọn **Thay thế** → nút đổi `danger` "Replace my data" (xoá dữ liệu hiện tại); mockup chỉ có "Restore".
8. Tên file sao lưu gần nhất `subnest-backup-2026-09-24.json` (đúng tên `BackupService` đặt; mockup `subnest-2026-09-23.json`).
9. Xem trước nhắc dùng **khoản gia hạn gần nhất thật** (dữ liệu mẫu: "ChatGPT Plus renews in 3 days — $20.00"); khi
   chưa có subscription mới dùng mẫu Netflix như mockup. Bản **debug** có hàng "Gửi nhắc thử" (không có ở release).
10. Banner thông báo tắt ở 390: nút "Open settings" rơi xuống dòng và **rộng hết banner** (hành vi `AppBanner` của core khi
    hẹp); mockup là pill căn phải.
11. Mũi tên `→` vẽ bằng icon Lucide: **Be Vietnam Pro không có glyph U+2192** (cũng thiếu `₩` U+20A9, `฿` U+0E3F → trên máy
    dùng font dự phòng của hệ thống; trong ảnh test để trống).
12. Chữ ≥ 150%: giá trị hàng cài đặt xuống **dòng dưới nhãn** (mockup chỉ vẽ 130%, ở đó vẫn nằm bên phải).
13. S12: thông báo dùng thử trên Android hiện 2 dòng (tiêu đề "Your Spotify trial ends in 3 days." + nội dung "Cancel now…");
    mockup gộp 1 đoạn dưới tên app. Chữ đã khớp từng ký tự (test). Gia hạn/đến ngày chỉ có tiêu đề như mockup.
14. "Offline" = lần lấy tỷ giá gần nhất **thất bại** (app không có package kiểm kết nối); mở màn Tỷ giá tự thử lại nếu dữ liệu > 1 ngày.

## Chỗ cần URL privacy thật

- `lib/features/settings/app_info.dart`: đặt `kPrivacyPolicyUrl` (và `kTermsUrl`) = link https công khai của
  `store/legal/privacy-policy.*.html` khi đã host. Hàng sẽ tự đổi sang icon `external-link`, mở trình duyệt; mất mạng/không
  mở được → **vẫn rơi về bản trong app**. Có test chặn URL không phải https.
- Khi sửa `store/legal/*.md`: chạy lại đoạn sinh `legal_texts.dart` (dưới) — test `settings_content_test.dart` đỏ nếu lệch.
- `kAppStoreId` khi có app iOS (hiện ẩn hàng Đánh giá trên iOS).

```bash
python -I - <<'EOF'
import pathlib
docs=[('privacyEn','privacy-policy.en.md'),('privacyVi','privacy-policy.vi.md'),('termsEn','terms.en.md'),('termsVi','terms.vi.md')]
out=["// GENERATED from store/legal/*.md — do not edit by hand. Regenerate when the store texts change;",
     "// test/features/settings/settings_content_test.dart fails while they differ (regenerate: see notes/2026-11-05-ui-settings.md).",
     "","/// In-app copies of the privacy policy and terms (shown while there is no public URL, and offline).",
     "abstract final class LegalTexts {"]
for n,f in docs:
    t=pathlib.Path('store/legal',f).read_text(encoding='utf-8').replace('\r\n','\n')
    out+=[f"  /// store/legal/{f}",f"  static const String {n} = r'''{t}''';",""]
out[-1]="}"
pathlib.Path('lib/features/settings/legal_texts.dart').write_text('\n'.join(out)+'\n',encoding='utf-8',newline='\n')
EOF
```

## Việc cho phiên điều phối / lõi (tôi KHÔNG sửa vì ngoài phạm vi)

1. **Router (core)**: thêm route `/settings/reminders`, `/settings/legal/:doc` (privacy|terms) và cân nhắc đặt các route con
   của Cài đặt lên **root navigator** (`parentNavigatorKey`) để ẩn tab bar như mockup 51–56. Màn đã sẵn: `RemindersScreen()`,
   `LegalScreen(doc: LegalDoc.privacy|terms)`.
2. **`SettingRow(value:)` (core) lệch bố cục**: nhãn `Expanded` + giá trị `Flexible` chia đôi hàng ⇒ giá trị ngắn dừng giữa
   hàng thay vì dạt phải (thấy rõ ở ảnh chụp đầu tiên). Tôi tránh bằng `ValueRow` trong feature; nên sửa ở core rồi bỏ `ValueRow`.
   Phiên G/H/I dùng `SettingRow(value:)` sẽ gặp y như vậy.
3. **`AppSegmentedControl` cao 44dp < 48dp của S-50** (`androidTapTargetGuideline` báo ở Nhắc nhở; tấm Giao diện cũng vậy).
   Test trợ năng màn Nhắc nhở tạm dùng mức 44 (có comment). Nên nâng vùng chạm segment lên 48 ở core.
4. **Data**: `BackupService.exportJson()` ghi `lastBackupAt` ngay khi tạo file, **kể cả khi người dùng huỷ share sheet** → banner
   "42 ngày" biến mất dù chưa lưu bản nào. Đề xuất: trả file rồi để UI gọi `setLastBackupAt` khi share `success`.
   `BackupFiles.pickJson()` bỏ mất tên file → tôi đọc file qua `SettingsPlatform.pickBackup()` (feature).
5. `docs/dev.md` §1 "Cài đặt → **Gửi nhắc thử**" nay là **Cài đặt → Nhắc nhở → Gửi nhắc thử** (chỉ bản debug).
6. Phiên bản: đang là hằng số + test so với `pubspec.yaml`; nếu muốn đọc runtime thì thêm `package_info_plus` (phiên A/F).
7. Tên tiền tệ tiếng Việt (`currencyNamesVi`) đang nằm trong `currency_screen.dart`; onboarding (H) cần thì nên chuyển vào
   `core/utils/currencies.dart`.

## Việc dở / rủi ro

- **Chưa thử trên máy thật** (theo brief): share sheet, file picker, mở trang thông báo hệ thống (`openAppNotificationSettings`
  Android 8+/iOS 15.4+), `market://`, `mailto:` mới kiểm qua fake — cần một lượt thử trên Android + iPhone thật.
- **Chưa thử TalkBack/VoiceOver** (S-50 yêu cầu trước phát hành). Đã có: Semantics cho hàng tỷ giá ("1 USD equals 25,400 VND.
  Auto · …"), tiêu đề tấm, ô nhập tỷ giá có nhãn, test `labeledTapTargetGuideline` 4 màn.
- File l10n sinh ra trong commit này chỉ gồm part đã commit + part của tôi; working tree vẫn có bản đầy đủ (kèm key Lịch/Thống
  kê chưa commit) — phiên I/G… chạy lại merge + gen-l10n khi commit như `docs/dev.md` §4.

## Đề xuất cải tiến xưởng

1. **Harness test màn hình tái dùng được**: DB in-memory + fixture dữ liệu mẫu §8 + "seam" nền tảng (URL/share/file/quyền) qua
   một provider + `MockClient` cho mạng + nạp font thật & font icon từ `package_config.json` + ma trận kịch bản × theme × ngôn
   ngữ × khổ × cỡ chữ + `--dart-define=SHOTS=true` để ra ảnh + script PIL ghép mockup ↔ app. Một lần chạy ~20 s cho 96 tổ hợp —
   thay hẳn máy thật cho phần bố cục. Nên đưa vào `playbook/templates/flutter/test/`.
2. **Kiểm glyph font cho mọi chuỗi ARB** (fontTools, vài dòng) trong CI: phiên này phát hiện `→ ₩ ฿` không có trong Be Vietnam
   Pro chỉ nhờ nhìn ảnh.
3. **Văn bản pháp lý trong app sinh từ `store/legal` + test đồng bộ** — S-13 thoả ngay cả khi chưa host URL; mẫu dùng lại cho
   app sau.
4. **Drift + `testWidgets`**: đóng stream drift tạo timer 0 ms ⇒ "Timer still pending"; bọc `testWidgets` (unmount + pump 1 ms)
   như `settingsTest` — ghi vào hướng dẫn test của xưởng.
5. **Nhiều phiên chung 1 thư mục + file l10n sinh ra**: commit bản sinh từ `git show HEAD:<part>` + part của mình (thư mục tạm)
   để HEAD luôn build được; nên viết thành `tool/merge_arb.dart --committed-plus <parts>` cho mọi phiên.
