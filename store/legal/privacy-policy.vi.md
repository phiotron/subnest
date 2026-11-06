# Chính sách quyền riêng tư của Subnest

**Cập nhật lần cuối:** 2026-11-06

Chính sách này giải thích cách ứng dụng di động **Subnest: Subscription Tracker** ("Subnest", "ứng dụng") trên
Android và iOS xử lý thông tin của bạn. Subnest do Phiotron ("chúng tôi") phát hành.

## Tóm tắt

- **Chúng tôi không thu thập dữ liệu cá nhân nào.** Subnest không có tài khoản, không đăng nhập, không
  analytics, không quảng cáo, không dịch vụ báo lỗi (crash reporting) và không theo dõi.
- **Mọi thứ bạn nhập chỉ nằm trên thiết bị của bạn.** Chúng tôi không có máy chủ lưu dữ liệu của bạn và không
  thể xem được dữ liệu đó.
- **Ứng dụng chỉ dùng Internet để tải thông tin công khai:** tỷ giá ngoại tệ, thư viện dịch vụ (giá gợi ý và
  gói) và logo dịch vụ. Không thông tin nào về bạn hay các gói đăng ký của bạn được gửi đi.
- **Nhắc nhở là thông báo cục bộ** do thiết bị của bạn lên lịch.
- **File sao lưu chỉ được tạo khi bạn yêu cầu**, và bạn quyết định cất ở đâu.

## Thông tin lưu trên thiết bị của bạn

Để hoạt động, ứng dụng lưu những gì bạn nhập vào vùng lưu trữ riêng của ứng dụng trên thiết bị, ví dụ:

- các gói đăng ký (tên dịch vụ, giá, tiền tệ, chu kỳ, ngày gia hạn và ngày hết dùng thử, danh mục, số người chia
  gói, ghi chú, nhãn phương thức thanh toán do bạn gõ, link huỷ);
- lịch sử thanh toán bạn xác nhận (kỳ đã trả / bỏ qua và số tiền);
- cài đặt (tiền tệ chính, giờ nhắc, giao diện, ngôn ngữ), tỷ giá và thư viện dịch vụ tải về gần nhất, cùng các
  logo dịch vụ ứng dụng đã tải.

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

## Logo dịch vụ

Để hiện logo của một dịch vụ, ứng dụng tải hình từ **Logo.dev** (img.logo.dev) và lưu trên thiết bị của bạn để
không phải tải lại nhiều lần. Logo được yêu cầu cho các dịch vụ hiện trong ứng dụng (ví dụ trong thư viện dịch
vụ hoặc danh sách của bạn) mà có website đã biết.

- Yêu cầu chỉ chứa tên miền website của dịch vụ (ví dụ `netflix.com`) và khoá công khai của ứng dụng dành cho
  dịch vụ Logo.dev. Nó **không** chứa tên của bạn, giá, ngày hay ghi chú của các gói đăng ký, hay bất kỳ mã định
  danh nào do ứng dụng tạo ra.
- Logo.dev thấy địa chỉ IP và thời điểm yêu cầu của bạn, như mọi trang web, và có thể thấy những tên miền dịch vụ
  nào được yêu cầu từ địa chỉ đó. Họ xử lý thông tin này theo [Chính sách quyền riêng tư của Logo.dev](https://www.logo.dev/legal/privacy).
  Chúng tôi không nhận được.
- Nếu không tải được logo (ví dụ khi không có mạng) hoặc dịch vụ không có logo, ứng dụng hiện ô chữ cái thay thế.
- Tên và logo dịch vụ thuộc về chủ sở hữu của chúng và chỉ hiển thị để nhận diện dịch vụ. Logos provided by
  [Logo.dev](https://logo.dev).

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
- **Internet** — chỉ để tải tỷ giá, thư viện dịch vụ và logo dịch vụ.
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
màn hình). Tỷ giá, thư viện dịch vụ và logo được tải qua kết nối mã hoá (HTTPS).

## Thay đổi chính sách

Nếu chúng tôi thay đổi cách ứng dụng xử lý thông tin, chúng tôi sẽ cập nhật trang này và ngày "Cập nhật lần cuối".
Thay đổi quan trọng (ví dụ bắt đầu thu thập bất kỳ dữ liệu nào) cũng sẽ được thông báo trong ghi chú phát hành của
ứng dụng trước khi có hiệu lực.

## Liên hệ

Phiotron — email: phamphuongphuongnd@gmail.com
