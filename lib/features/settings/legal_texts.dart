// GENERATED from store/legal/*.md — do not edit by hand. Regenerate when the store texts change;
// test/features/settings/settings_content_test.dart fails while they differ (regenerate: see notes/2026-11-05-ui-settings.md).

/// In-app copies of the privacy policy and terms (shown while there is no public URL, and offline).
abstract final class LegalTexts {
  /// store/legal/privacy-policy.en.md
  static const String privacyEn = r'''# Subnest Privacy Policy

**Last updated:** 2026-11-04

This policy explains how the mobile app **Subnest: Subscription Tracker** ("Subnest", "the app") for Android
and iOS handles your information. Subnest is published by Phiotron ("we", "us").

## Summary

- **We do not collect any personal data.** Subnest has no account, no sign-in, no analytics, no advertising,
  no crash-reporting service and no tracking.
- **Everything you enter stays on your device.** We have no server that stores your data and we cannot see it.
- **The internet is used only to download currency exchange rates.** No information about you or your
  subscriptions is sent.
- **Reminders are local notifications** scheduled on your device.
- **Backup files are created only when you ask**, and you decide where to keep them.

## Information stored on your device

To work, the app stores what you enter in its private storage on your device, for example:

- subscriptions (service name, price, currency, billing cycle, renewal and trial dates, category, number of
  people you share a plan with, notes, the payment-method label you type, cancellation link);
- payment history you confirm (paid / skipped periods and amounts);
- settings (main currency, reminder time, theme, language) and the last downloaded exchange rates.

This data never leaves your device through Subnest, except when you yourself export or share a backup file
(see below). You can delete individual items in the app at any time. Uninstalling the app, or clearing its
storage, deletes all of it.

**Device backups:** if you have turned on your phone's own backup (for example Google backup on Android or
iCloud Backup on iPhone), the operating system may include the app's data in that backup. This is managed by
Google or Apple under their own terms and your device settings; we have no access to it.

## Internet access: exchange rates

To convert prices into your main currency, the app downloads current exchange rates (about once a day, when
you are online) from a public exchange-rate service: **ExchangeRate-API (open.er-api.com)**.

- The request only asks for the latest rates. It does **not** contain your subscriptions, amounts, notes,
  settings, or any identifier created by the app.
- As with any connection on the internet, the service necessarily receives technical information such as
  your IP address and the time of the request. It processes this under its own privacy policy; we do not
  receive it.
- You can keep using the app offline. It then uses the last downloaded rates, or rates you set yourself.

## Notifications

Renewal and free-trial reminders are **local notifications**: they are scheduled and shown by your device's
operating system. We do not use a push-notification server, and no notification content is sent anywhere.
You can turn reminders off in the app or in your system settings.

## Backup and export files

When you choose "Export backup (JSON)" or "Export spreadsheet (CSV)", the app creates a file with your data and
opens your system's share/save sheet. **You choose where it goes** (for example your files, a cloud drive or an
email). We never receive these files. They are not encrypted, so store them somewhere you trust. When you
restore, the app reads only the file you pick.

## Links to websites

The app may open web pages in your browser, such as a service's "how to cancel" page or this policy. Those
websites have their own privacy practices, which we do not control.

## Contacting us

If you send us feedback by email, we receive your email address and whatever you write. We use it only to
reply to you, do not share it, and will delete it on request.

## Permissions

- **Notifications** — to show renewal and trial reminders.
- **Alarms & reminders / exact alarms** (Android, if requested) — so reminders arrive at the time you chose.
- **Internet** — only to download exchange rates.
- **Files** — the app only accesses a file you pick in the system file picker when restoring a backup.

The app does not request access to your contacts, location, camera, microphone, photos or bank accounts.

## Children

Subnest is a general-audience tool and is not directed at children under 13. Because we collect no personal
data, we do not knowingly collect data from children.

## Your rights

Data-protection laws (such as the GDPR in Europe, the CCPA in California and Vietnam's Personal Data
Protection Decree 13/2023/NĐ-CP) give you rights to access, correct and delete your personal data. Because we
do not collect or store your data, we hold nothing about you to access, correct or delete; you control
everything directly in the app. If you have emailed us, you can ask us to delete that correspondence.

We do not sell or share personal data, and we do not use it for advertising.

## Security

Your data stays in the app's private storage, protected by your device's security (for example your screen
lock). Exchange rates are downloaded over an encrypted connection (HTTPS).

## Changes to this policy

If we change how the app handles information, we will update this page and the "Last updated" date. Material
changes (for example adding any data collection) will also be announced in the app's release notes before
they take effect.

## Contact

Phiotron — email: phamphuongphuongnd@gmail.com
''';

  /// store/legal/privacy-policy.vi.md
  static const String privacyVi = r'''# Chính sách quyền riêng tư của Subnest

**Cập nhật lần cuối:** 2026-11-04

Chính sách này giải thích cách ứng dụng di động **Subnest: Subscription Tracker** ("Subnest", "ứng dụng") trên
Android và iOS xử lý thông tin của bạn. Subnest do Phiotron ("chúng tôi") phát hành.

## Tóm tắt

- **Chúng tôi không thu thập dữ liệu cá nhân nào.** Subnest không có tài khoản, không đăng nhập, không
  analytics, không quảng cáo, không dịch vụ báo lỗi (crash reporting) và không theo dõi.
- **Mọi thứ bạn nhập chỉ nằm trên thiết bị của bạn.** Chúng tôi không có máy chủ lưu dữ liệu của bạn và không
  thể xem được dữ liệu đó.
- **Ứng dụng chỉ dùng Internet để tải tỷ giá ngoại tệ.** Không thông tin nào về bạn hay các gói đăng ký của bạn
  được gửi đi.
- **Nhắc nhở là thông báo cục bộ** do thiết bị của bạn lên lịch.
- **File sao lưu chỉ được tạo khi bạn yêu cầu**, và bạn quyết định cất ở đâu.

## Thông tin lưu trên thiết bị của bạn

Để hoạt động, ứng dụng lưu những gì bạn nhập vào vùng lưu trữ riêng của ứng dụng trên thiết bị, ví dụ:

- các gói đăng ký (tên dịch vụ, giá, tiền tệ, chu kỳ, ngày gia hạn và ngày hết dùng thử, danh mục, số người chia
  gói, ghi chú, nhãn phương thức thanh toán do bạn gõ, link huỷ);
- lịch sử thanh toán bạn xác nhận (kỳ đã trả / bỏ qua và số tiền);
- cài đặt (tiền tệ chính, giờ nhắc, giao diện, ngôn ngữ) và tỷ giá tải về gần nhất.

Dữ liệu này không bao giờ rời khỏi thiết bị thông qua Subnest, trừ khi chính bạn xuất hoặc chia sẻ file sao lưu
(xem bên dưới). Bạn có thể xoá từng mục trong ứng dụng bất cứ lúc nào. Gỡ ứng dụng, hoặc xoá dữ liệu của ứng dụng,
sẽ xoá toàn bộ.

**Sao lưu của thiết bị:** nếu bạn đã bật tính năng sao lưu của điện thoại (ví dụ sao lưu Google trên Android hoặc
Sao lưu iCloud trên iPhone), hệ điều hành có thể đưa dữ liệu của ứng dụng vào bản sao lưu đó. Việc này do Google
hoặc Apple quản lý theo điều khoản của họ và cài đặt trên máy bạn; chúng tôi không truy cập được.

## Truy cập Internet: tỷ giá

Để quy đổi giá sang tiền tệ chính của bạn, ứng dụng tải tỷ giá hiện hành (khoảng một lần mỗi ngày, khi có mạng)
từ một dịch vụ tỷ giá công khai: **ExchangeRate-API (open.er-api.com)**.

- Yêu cầu này chỉ hỏi tỷ giá mới nhất. Nó **không** chứa các gói đăng ký, số tiền, ghi chú, cài đặt hay bất kỳ
  mã định danh nào do ứng dụng tạo ra.
- Như mọi kết nối Internet, dịch vụ đó tất yếu nhận được thông tin kỹ thuật như địa chỉ IP và thời điểm yêu cầu.
  Họ xử lý thông tin này theo chính sách quyền riêng tư của họ; chúng tôi không nhận được.
- Bạn vẫn dùng ứng dụng bình thường khi không có mạng. Khi đó ứng dụng dùng tỷ giá tải về gần nhất, hoặc tỷ giá
  bạn tự đặt.

## Thông báo

Nhắc gia hạn và nhắc hết dùng thử là **thông báo cục bộ**: do hệ điều hành trên thiết bị của bạn lên lịch và hiển
thị. Chúng tôi không dùng máy chủ gửi thông báo đẩy (push), và nội dung thông báo không được gửi đi đâu cả. Bạn có
thể tắt nhắc nhở trong ứng dụng hoặc trong cài đặt hệ thống.

## File sao lưu và file xuất

Khi bạn chọn "Xuất bản sao lưu (JSON)" hoặc "Xuất bảng tính (CSV)", ứng dụng tạo một file chứa dữ liệu của bạn và
mở bảng chia sẻ/lưu của hệ thống. **Bạn chọn nơi file được gửi tới** (ví dụ thư mục trên máy, ổ đám mây hay email).
Chúng tôi không bao giờ nhận được các file này. File không được mã hoá, nên hãy cất ở nơi bạn tin cậy. Khi khôi
phục, ứng dụng chỉ đọc đúng file bạn chọn.

## Liên kết tới trang web

Ứng dụng có thể mở trang web trong trình duyệt, chẳng hạn trang "cách huỷ" của một dịch vụ hoặc chính sách này.
Các trang web đó có cách xử lý quyền riêng tư riêng mà chúng tôi không kiểm soát.

## Khi bạn liên hệ với chúng tôi

Nếu bạn gửi góp ý qua email, chúng tôi nhận được địa chỉ email và nội dung bạn viết. Chúng tôi chỉ dùng để trả lời
bạn, không chia sẻ cho ai, và sẽ xoá khi bạn yêu cầu.

## Quyền truy cập (permissions)

- **Thông báo** — để hiện nhắc gia hạn và nhắc hết dùng thử.
- **Báo thức & lời nhắc / báo thức chính xác** (Android, nếu ứng dụng yêu cầu) — để nhắc đến đúng giờ bạn chọn.
- **Internet** — chỉ để tải tỷ giá.
- **File** — ứng dụng chỉ truy cập file bạn chọn trong trình chọn file của hệ thống khi khôi phục sao lưu.

Ứng dụng không xin quyền truy cập danh bạ, vị trí, camera, micro, ảnh hay tài khoản ngân hàng.

## Trẻ em

Subnest là công cụ dành cho mọi người và không hướng tới trẻ em dưới 13 tuổi. Vì chúng tôi không thu thập dữ liệu
cá nhân, chúng tôi không cố ý thu thập dữ liệu của trẻ em.

## Quyền của bạn

Các luật bảo vệ dữ liệu (như GDPR ở châu Âu, CCPA ở California và Nghị định 13/2023/NĐ-CP về bảo vệ dữ liệu cá
nhân của Việt Nam) cho bạn quyền truy cập, chỉnh sửa và xoá dữ liệu cá nhân của mình. Vì chúng tôi không thu thập
hay lưu dữ liệu của bạn, chúng tôi không giữ gì về bạn để truy cập, chỉnh sửa hay xoá; bạn kiểm soát mọi thứ trực
tiếp trong ứng dụng. Nếu bạn đã gửi email cho chúng tôi, bạn có thể yêu cầu xoá thư từ đó.

Chúng tôi không bán hay chia sẻ dữ liệu cá nhân và không dùng dữ liệu cho quảng cáo.

## Bảo mật

Dữ liệu của bạn nằm trong vùng lưu trữ riêng của ứng dụng, được bảo vệ bởi cơ chế bảo mật của thiết bị (ví dụ khoá
màn hình). Tỷ giá được tải qua kết nối mã hoá (HTTPS).

## Thay đổi chính sách

Nếu chúng tôi thay đổi cách ứng dụng xử lý thông tin, chúng tôi sẽ cập nhật trang này và ngày "Cập nhật lần cuối".
Thay đổi quan trọng (ví dụ bắt đầu thu thập bất kỳ dữ liệu nào) cũng sẽ được thông báo trong ghi chú phát hành của
ứng dụng trước khi có hiệu lực.

## Liên hệ

Phiotron — email: phamphuongphuongnd@gmail.com
''';

  /// store/legal/terms.en.md
  static const String termsEn = r'''# Subnest Terms of Use

**Last updated:** 2026-11-04

By using **Subnest: Subscription Tracker** ("Subnest", "the app"), published by Phiotron ("we"), you
agree to these terms. If you got the app from the Apple App Store, Apple's Standard Licensed Application End
User License Agreement also applies.

1. **What Subnest is.** A free, personal tool to record your subscriptions, estimate what they cost and remind
   you of dates. It does not connect to your bank or to any service provider, and it cannot pay, cancel or
   change any subscription for you.
2. **Your responsibility.** Amounts, dates and totals are based on what you enter. Suggested prices in the
   service library, exchange rates and reminders are provided for convenience and may be inaccurate, outdated
   or delayed (for example if notifications are turned off or the device is off). Always check the actual
   terms of each service. Subnest is not financial advice.
3. **Your data and backups.** Your data is stored only on your device. You are responsible for keeping backups;
   we cannot recover data that is lost, for example when the app is uninstalled or the device is reset.
4. **Trademarks.** Service names shown in the app belong to their respective owners and are used only to
   identify those services. Subnest is not affiliated with or endorsed by them.
5. **No warranty.** The app is provided "as is", without warranties of any kind, to the extent permitted by law.
6. **Limitation of liability.** To the extent permitted by law, we are not liable for any charges, fees,
   missed cancellations or other losses arising from your use of the app.
7. **Changes.** We may update the app and these terms. Continued use after an update means you accept the new
   terms. The "Last updated" date shows the current version.
8. **Contact.** phamphuongphuongnd@gmail.com

Our [Privacy Policy](privacy-policy.en.html) explains how the app handles information.
''';

  /// store/legal/terms.vi.md
  static const String termsVi = r'''# Điều khoản sử dụng Subnest

**Cập nhật lần cuối:** 2026-11-04

Khi dùng **Subnest: Subscription Tracker** ("Subnest", "ứng dụng") do Phiotron ("chúng tôi") phát hành,
bạn đồng ý với các điều khoản này. Nếu bạn tải ứng dụng từ Apple App Store, Thoả thuận cấp phép người dùng cuối
tiêu chuẩn (Standard EULA) của Apple cũng được áp dụng.

1. **Subnest là gì.** Một công cụ cá nhân miễn phí để ghi lại các gói đăng ký, ước tính chi phí và nhắc bạn các
   mốc ngày. Ứng dụng không kết nối với ngân hàng hay nhà cung cấp dịch vụ nào, và không thể trả tiền, huỷ hay thay
   đổi gói đăng ký nào giúp bạn.
2. **Trách nhiệm của bạn.** Số tiền, ngày và tổng chi dựa trên những gì bạn nhập. Giá gợi ý trong thư viện dịch
   vụ, tỷ giá và nhắc nhở chỉ để tiện tham khảo và có thể sai, cũ hoặc đến trễ (ví dụ khi thông báo bị tắt hoặc
   máy tắt nguồn). Hãy luôn kiểm tra điều khoản thật của từng dịch vụ. Subnest không phải lời khuyên tài chính.
3. **Dữ liệu và sao lưu.** Dữ liệu của bạn chỉ lưu trên thiết bị. Bạn tự chịu trách nhiệm sao lưu; chúng tôi không
   thể khôi phục dữ liệu bị mất, ví dụ khi gỡ ứng dụng hoặc đặt lại thiết bị.
4. **Nhãn hiệu.** Tên các dịch vụ hiển thị trong ứng dụng thuộc về chủ sở hữu tương ứng, chỉ dùng để nhận diện dịch
   vụ. Subnest không liên kết với và không được các bên đó bảo trợ.
5. **Không bảo đảm.** Ứng dụng được cung cấp "nguyên trạng", không kèm bảo đảm dưới bất kỳ hình thức nào, trong phạm
   vi pháp luật cho phép.
6. **Giới hạn trách nhiệm.** Trong phạm vi pháp luật cho phép, chúng tôi không chịu trách nhiệm về các khoản phí,
   khoản bị trừ tiền, việc lỡ huỷ gói hay thiệt hại khác phát sinh từ việc bạn dùng ứng dụng.
7. **Thay đổi.** Chúng tôi có thể cập nhật ứng dụng và các điều khoản này. Tiếp tục dùng sau khi cập nhật nghĩa là
   bạn chấp nhận điều khoản mới. Ngày "Cập nhật lần cuối" cho biết phiên bản hiện hành.
8. **Liên hệ.** phamphuongphuongnd@gmail.com

[Chính sách quyền riêng tư](privacy-policy.vi.html) giải thích cách ứng dụng xử lý thông tin.
''';
}
