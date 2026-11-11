// GENERATED from store/legal/*.md — do not edit by hand. Regenerate when the store texts change;
// test/features/settings/settings_content_test.dart fails while they differ (regenerate: see notes/2026-11-05-ui-settings.md).

/// In-app copies of the privacy policy and terms (shown while there is no public URL, and offline).
abstract final class LegalTexts {
  /// store/legal/privacy-policy.en.md
  static const String privacyEn = r'''# Subnest Privacy Policy

**Last updated:** 2026-11-06

This policy explains how the mobile app **Subnest: Subscription Tracker** ("Subnest", "the app") for Android
and iOS handles your information. Subnest is published by Phiotron ("we", "us").

## Summary

- **We do not collect any personal data.** Subnest has no account, no sign-in, no analytics, no advertising,
  no crash-reporting service and no tracking.
- **Everything you enter stays on your device.** We have no server that stores your data and we cannot see it.
- **The internet is used only to download public information:** currency exchange rates and the service
  library (suggested prices and plans). No information about you or your subscriptions is sent.
- **Service logos are built into the app.** Nothing is downloaded or sent to show them.
- **Reminders are local notifications** scheduled on your device.
- **Backup files are created only when you ask**, and you decide where to keep them.

## Information stored on your device

To work, the app stores what you enter in its private storage on your device, for example:

- subscriptions (service name, price, currency, billing cycle, renewal and trial dates, category, number of
  people you share a plan with, notes, the payment-method label you type, cancellation link);
- payment history you confirm (paid / skipped periods and amounts);
- settings (main currency, reminder time, theme, language), the last downloaded exchange rates and service
  library, and the pictures you choose yourself as the icon of a custom subscription.

This data never leaves your device through Subnest, except when you yourself export or share a backup file
(see below). You can delete individual items in the app at any time. Uninstalling the app, or clearing its
storage, deletes all of it.

**Device backups:** if you have turned on your phone's own backup (for example Google backup on Android or
iCloud Backup on iPhone), the operating system may include the app's data in that backup. This is managed by
Google or Apple under their own terms and your device settings; we have no access to it.

## Internet access

The app connects to the internet only to download three kinds of public information, described below. None of
these requests contains your subscriptions, amounts, notes, settings, or any identifier created by the app, and
none of them needs an account. As with any connection on the internet, each server necessarily receives
technical information such as your IP address and the time of the request; we do not receive it.

## Exchange rates

To convert prices into your main currency, the app downloads current exchange rates (about once a day, when
you are online) from a public exchange-rate service: **ExchangeRate-API (open.er-api.com)**.

- The request only asks for the latest rates.
- The service processes its technical logs under its own privacy policy.
- You can keep using the app offline. It then uses the last downloaded rates, or rates you set yourself.

## Service library

The service library (popular services with suggested prices and plans, and "how to cancel" links) is a public
file published by us on **GitHub Pages** (phamphuongphuongnd.github.io). The app downloads it at most once a
day, when you are online, and keeps the last copy on your device.

- The request is a plain download of a public file. It does **not** contain any of your data.
- GitHub, which hosts the file, sees your IP address and the time of the request, as any website does. It
  processes this under the [GitHub Privacy Statement](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement). We do not receive it and
  do not run any server of our own.
- Suggested prices are updated about once a week and may be out of date. If the download fails, the app uses
  the last downloaded copy, or the copy built into the app.

## Service logos and pictures

The logos of the services in the library are **bundled inside the app**. Showing them needs no internet and
sends nothing anywhere. If a service has no bundled logo, the app shows a tile with its initials instead.

- The service library (names, plans, suggested prices) is a static file that Subnest downloads from GitHub
  Pages (`phamphuongphuongnd.github.io`). The request carries no information about you or your subscriptions;
  like any website, the host sees your IP address and the time of the request.
- If you choose a picture as the icon of a custom subscription, you pick it with your system's photo picker.
  The app can read only the picture you choose. It is stored on your device and in the backup files you create,
  and is never uploaded.
- Service names and logos belong to their respective owners and are shown only to identify the service.

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
- **Internet** — only to download exchange rates and the service library.
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
lock). Exchange rates and the service library are downloaded over an encrypted connection (HTTPS).

## Changes to this policy

If we change how the app handles information, we will update this page and the "Last updated" date. Material
changes (for example adding any data collection) will also be announced in the app's release notes before
they take effect.

## Contact

Phiotron — email: phamphuongphuongnd@gmail.com
''';

  /// store/legal/privacy-policy.vi.md
  static const String privacyVi = r'''# Chính sách quyền riêng tư của Subnest

**Cập nhật lần cuối:** 2026-11-06

Chính sách này giải thích cách ứng dụng di động **Subnest: Subscription Tracker** ("Subnest", "ứng dụng") trên
Android và iOS xử lý thông tin của bạn. Subnest do Phiotron ("chúng tôi") phát hành.

## Tóm tắt

- **Chúng tôi không thu thập dữ liệu cá nhân nào.** Subnest không có tài khoản, không đăng nhập, không
  analytics, không quảng cáo, không dịch vụ báo lỗi (crash reporting) và không theo dõi.
- **Mọi thứ bạn nhập chỉ nằm trên thiết bị của bạn.** Chúng tôi không có máy chủ lưu dữ liệu của bạn và không
  thể xem được dữ liệu đó.
- **Ứng dụng chỉ dùng Internet để tải thông tin công khai:** tỷ giá ngoại tệ và thư viện dịch vụ (giá gợi ý và
  gói). Không thông tin nào về bạn hay các gói đăng ký của bạn được gửi đi.
- **Logo dịch vụ được đóng gói sẵn trong ứng dụng.** Hiển thị chúng không cần tải hay gửi gì.
- **Nhắc nhở là thông báo cục bộ** do thiết bị của bạn lên lịch.
- **File sao lưu chỉ được tạo khi bạn yêu cầu**, và bạn quyết định cất ở đâu.

## Thông tin lưu trên thiết bị của bạn

Để hoạt động, ứng dụng lưu những gì bạn nhập vào vùng lưu trữ riêng của ứng dụng trên thiết bị, ví dụ:

- các gói đăng ký (tên dịch vụ, giá, tiền tệ, chu kỳ, ngày gia hạn và ngày hết dùng thử, danh mục, số người chia
  gói, ghi chú, nhãn phương thức thanh toán do bạn gõ, link huỷ);
- lịch sử thanh toán bạn xác nhận (kỳ đã trả / bỏ qua và số tiền);
- cài đặt (tiền tệ chính, giờ nhắc, giao diện, ngôn ngữ), tỷ giá và thư viện dịch vụ tải về gần nhất, cùng các
  ảnh bạn tự chọn làm biểu tượng cho gói tự tạo.

Dữ liệu này không bao giờ rời khỏi thiết bị thông qua Subnest, trừ khi chính bạn xuất hoặc chia sẻ file sao lưu
(xem bên dưới). Bạn có thể xoá từng mục trong ứng dụng bất cứ lúc nào. Gỡ ứng dụng, hoặc xoá dữ liệu của ứng dụng,
sẽ xoá toàn bộ.

**Sao lưu của thiết bị:** nếu bạn đã bật tính năng sao lưu của điện thoại (ví dụ sao lưu Google trên Android hoặc
Sao lưu iCloud trên iPhone), hệ điều hành có thể đưa dữ liệu của ứng dụng vào bản sao lưu đó. Việc này do Google
hoặc Apple quản lý theo điều khoản của họ và cài đặt trên máy bạn; chúng tôi không truy cập được.

## Truy cập Internet

Ứng dụng chỉ kết nối Internet để tải ba loại thông tin công khai, mô tả bên dưới. Không yêu cầu nào trong số đó
chứa các gói đăng ký, số tiền, ghi chú, cài đặt của bạn hay bất kỳ mã định danh nào do ứng dụng tạo ra, và không
yêu cầu nào cần tài khoản. Như mọi kết nối Internet, máy chủ nhận yêu cầu tất yếu nhận được thông tin kỹ thuật như
địa chỉ IP và thời điểm yêu cầu; chúng tôi không nhận được thông tin đó.

## Tỷ giá

Để quy đổi giá sang tiền tệ chính của bạn, ứng dụng tải tỷ giá hiện hành (khoảng một lần mỗi ngày, khi có mạng)
từ một dịch vụ tỷ giá công khai: **ExchangeRate-API (open.er-api.com)**.

- Yêu cầu này chỉ hỏi tỷ giá mới nhất.
- Dịch vụ đó xử lý nhật ký kỹ thuật của họ theo chính sách quyền riêng tư của họ.
- Bạn vẫn dùng ứng dụng bình thường khi không có mạng. Khi đó ứng dụng dùng tỷ giá tải về gần nhất, hoặc tỷ giá
  bạn tự đặt.

## Thư viện dịch vụ

Thư viện dịch vụ (các dịch vụ phổ biến kèm giá gợi ý, gói và link "cách huỷ") là một file công khai do chúng tôi
đăng trên **GitHub Pages** (phamphuongphuongnd.github.io). Ứng dụng tải file này tối đa một lần mỗi ngày, khi có
mạng, và giữ bản gần nhất trên thiết bị của bạn.

- Yêu cầu chỉ là tải một file công khai. Nó **không** chứa bất kỳ dữ liệu nào của bạn.
- GitHub, nơi lưu file, thấy địa chỉ IP và thời điểm yêu cầu của bạn, như mọi trang web. Họ xử lý thông tin này
  theo [Tuyên bố quyền riêng tư của GitHub](https://docs.github.com/en/site-policy/privacy-policies/github-general-privacy-statement). Chúng tôi không nhận được và không vận hành máy chủ riêng nào.
- Giá gợi ý được cập nhật khoảng một lần mỗi tuần nên có thể đã cũ. Nếu tải không được, ứng dụng dùng bản đã tải
  gần nhất, hoặc bản đóng gói sẵn trong ứng dụng.

## Logo dịch vụ và ảnh

Logo của các dịch vụ trong thư viện được **đóng gói sẵn trong ứng dụng**. Hiển thị chúng không cần Internet và không
gửi gì đi đâu cả. Dịch vụ nào chưa có logo thì ứng dụng hiện ô chữ cái viết tắt thay thế.

- Thư viện dịch vụ (tên, gói, giá gợi ý) là một file tĩnh mà Subnest tải từ GitHub Pages
  (`phamphuongphuongnd.github.io`). Yêu cầu không mang thông tin nào về bạn hay các gói đăng ký của bạn; như mọi
  trang web, máy chủ thấy địa chỉ IP và thời điểm yêu cầu.
- Nếu bạn chọn một ảnh làm biểu tượng cho gói tự tạo, bạn chọn bằng bộ chọn ảnh của hệ thống. Ứng dụng chỉ đọc được
  ảnh bạn chọn. Ảnh được lưu trên thiết bị và trong các file sao lưu bạn tạo, không bao giờ được tải lên.
- Tên và logo dịch vụ thuộc về chủ sở hữu tương ứng và chỉ hiển thị để nhận diện dịch vụ.

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
- **Internet** — chỉ để tải tỷ giá và thư viện dịch vụ.
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
màn hình). Tỷ giá và thư viện dịch vụ được tải qua kết nối mã hoá (HTTPS).

## Thay đổi chính sách

Nếu chúng tôi thay đổi cách ứng dụng xử lý thông tin, chúng tôi sẽ cập nhật trang này và ngày "Cập nhật lần cuối".
Thay đổi quan trọng (ví dụ bắt đầu thu thập bất kỳ dữ liệu nào) cũng sẽ được thông báo trong ghi chú phát hành của
ứng dụng trước khi có hiệu lực.

## Liên hệ

Phiotron — email: phamphuongphuongnd@gmail.com
''';

  /// store/legal/terms.en.md
  static const String termsEn = r'''# Subnest Terms of Use

**Last updated:** 2026-11-06

By using **Subnest: Subscription Tracker** ("Subnest", "the app"), published by Phiotron ("we"), you
agree to these terms. If you got the app from the Apple App Store, Apple's Standard Licensed Application End
User License Agreement also applies.

1. **What Subnest is.** A free, personal tool to record your subscriptions, estimate what they cost and remind
   you of dates. It does not connect to your bank or to any service provider, and it cannot pay, cancel or
   change any subscription for you.
2. **Your responsibility.** Amounts, dates and totals are based on what you enter. Suggested prices in the
   service library are updated about once a week and may not yet reflect recent changes; they, the exchange
   rates and the reminders are provided for convenience and may be inaccurate, outdated or delayed (for example
   if notifications are turned off or the device is off). Always check the actual
   terms of each service. Subnest is not financial advice.
3. **Your data and backups.** Your data is stored only on your device. You are responsible for keeping backups;
   we cannot recover data that is lost, for example when the app is uninstalled or the device is reset.
4. **Trademarks.** Service names and logos shown in the app belong to their respective owners and are used
   only to identify those services. Subnest is not affiliated with, sponsored or endorsed by them.
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

**Cập nhật lần cuối:** 2026-11-06

Khi dùng **Subnest: Subscription Tracker** ("Subnest", "ứng dụng") do Phiotron ("chúng tôi") phát hành,
bạn đồng ý với các điều khoản này. Nếu bạn tải ứng dụng từ Apple App Store, Thoả thuận cấp phép người dùng cuối
tiêu chuẩn (Standard EULA) của Apple cũng được áp dụng.

1. **Subnest là gì.** Một công cụ cá nhân miễn phí để ghi lại các gói đăng ký, ước tính chi phí và nhắc bạn các
   mốc ngày. Ứng dụng không kết nối với ngân hàng hay nhà cung cấp dịch vụ nào, và không thể trả tiền, huỷ hay thay
   đổi gói đăng ký nào giúp bạn.
2. **Trách nhiệm của bạn.** Số tiền, ngày và tổng chi dựa trên những gì bạn nhập. Giá gợi ý trong thư viện dịch
   vụ được cập nhật khoảng một lần mỗi tuần nên có thể chưa kịp phản ánh thay đổi mới; giá gợi ý, tỷ giá và nhắc
   nhở chỉ để tiện tham khảo và có thể sai, cũ hoặc đến trễ (ví dụ khi thông báo bị tắt hoặc máy tắt nguồn). Hãy luôn kiểm tra điều khoản thật của từng dịch vụ. Subnest không phải lời khuyên tài chính.
3. **Dữ liệu và sao lưu.** Dữ liệu của bạn chỉ lưu trên thiết bị. Bạn tự chịu trách nhiệm sao lưu; chúng tôi không
   thể khôi phục dữ liệu bị mất, ví dụ khi gỡ ứng dụng hoặc đặt lại thiết bị.
4. **Nhãn hiệu.** Tên và logo các dịch vụ hiển thị trong ứng dụng thuộc về chủ sở hữu tương ứng, chỉ dùng để nhận
   diện dịch vụ. Subnest không liên kết với, không được bảo trợ hay xác nhận bởi các bên đó.
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
