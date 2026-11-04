# A001-subnest · Subnest — CONTEXT (glossary)

> Chỉ là bảng thuật ngữ nghiệp vụ. Không ghi chi tiết kỹ thuật ở đây.
> Thuật ngữ chuẩn dùng tiếng Anh trong code; cột VI là chữ hiển thị/tài liệu.

## Thuật ngữ

| Term (code) | VI | Định nghĩa | Tránh dùng |
|---|---|---|---|
| **Subscription** | Gói đăng ký | Một khoản người dùng trả định kỳ cho một dịch vụ (vd "Netflix Premium, 260.000đ/tháng"). Đơn vị chính của app. | "plan", "bill" |
| **Service** | Dịch vụ | Nhà cung cấp mà Subscription thuộc về (Netflix, Spotify…), có tên, logo/màu, link huỷ. | "app", "brand" |
| **Catalog** | Thư viện dịch vụ | Danh sách Service có sẵn kèm giá gợi ý, để thêm Subscription bằng một chạm. Người dùng vẫn có thể tạo Service tự do. | "preset list" |
| **Billing cycle** | Chu kỳ | Khoảng lặp lại của một Subscription: mỗi N ngày / tuần / tháng / năm. | "period" (để dành cho Billing period) |
| **Billing period** | Kỳ | Một lần lặp cụ thể của chu kỳ, có **Due date**. | |
| **Due date** | Ngày gia hạn | Ngày của Billing period kế tiếp cần trả. **Không tự nhảy**: chỉ sang kỳ sau khi kỳ hiện tại được xác nhận. | "renewal date", "next payment" |
| **Awaiting confirmation** | Chờ xác nhận | Trạng thái của một Billing period đã tới Due date nhưng người dùng chưa xác nhận đã trả hay không. Due date của Subscription đứng yên cho tới khi xác nhận. | "overdue", "unpaid" |
| **Payment** | Thanh toán | Bản ghi một Billing period **đã được người dùng xác nhận** là đã trả, với số tiền thực trả (sửa được). Chi tiêu thực tế chỉ tính từ Payment. | "transaction" |
| **Skipped period** | Kỳ bỏ qua | Billing period người dùng xác nhận là *không* trả (được miễn, tạm dừng…). Không tạo Payment. | |
| **Trial** | Dùng thử | Giai đoạn miễn phí có ngày kết thúc. Hết Trial thì Subscription **tự thành Active**, ngày hết Trial là Due date của kỳ trả phí đầu tiên. | "free plan" |
| **Status** | Trạng thái | Của Subscription: `Trial` · `Active` · `Cancelled`. | |
| **Cancelled** | Đã huỷ | Người dùng báo đã huỷ. Subscription được giữ lại (khôi phục được), không còn Due date mới. | "deleted", "archived" |
| **Savings** | Tiết kiệm | Số tiền quy năm của các Subscription Cancelled — "bạn đã tiết kiệm X/năm". | |
| **Shared plan** | Gói chia sẻ | Subscription chia tiền với N người (Family/Duo). | |
| **My share** | Phần của tôi | Giá gói ÷ số người chia. Mọi tổng chi tính theo My share. | |
| **Primary currency** | Tiền tệ chính | Tiền tệ để cộng tổng chi; mặc định theo vùng của máy. Mỗi Subscription có tiền tệ riêng. | "base currency" |
| **Exchange rate** | Tỷ giá | Tỷ giá quy đổi sang Primary currency, tự cập nhật hằng ngày khi có mạng, người dùng ghi đè được. | |
| **Monthly cost** | Chi phí quy tháng | Giá của một Subscription (My share) quy về 1 tháng theo Billing cycle và Exchange rate. Tổng chi tháng/năm = tổng Monthly cost của các Subscription `Active`; Trial hiển thị riêng là "sắp tính phí". | "average" |
| **Reminder** | Nhắc | Thông báo trên máy trước Due date (mặc định 3 ngày, 9:00) và trước khi Trial hết. | "alert", "push" (app không có server push) |
