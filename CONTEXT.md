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
| **Status** | Trạng thái | Của Subscription: `Trial` · `Active` · `Paused` · `Cancelled`. | |
| **Paused** | Tạm dừng | Người dùng tạm ngưng trả nhưng chưa huỷ. Có hiệu lực từ Due date kế tiếp (kỳ đã trả vẫn dùng hết); khi Paused không có Due date, Reminder, không tính vào tổng chi. Bật lại → người dùng chọn Due date kế tiếp (mặc định ngày bật lại). | "on hold", "suspended" |
| **Worth-it rating** | Đáng tiền? | Đánh giá của người dùng cho một Subscription: *Đáng* · *Phân vân* · *Không đáng* · (chưa đánh giá). Dùng để gợi ý tiết kiệm: "bỏ các gói Không đáng tiết kiệm X/năm". | "usage", "score" |
| **Label** | Nhãn | Thẻ tự đặt, gắn nhiều cái cho một Subscription (vd "Công việc", "Có quảng cáo"). Khác Category: một Subscription có đúng một Category nhưng nhiều Label. | "tag" (trong UI dùng "Nhãn") |
| **Category** | Danh mục | Nhóm chính của Subscription (Video, Nhạc, AI…). Người dùng thêm/sửa/xoá được; mỗi Subscription đúng một Category. | |
| **Payment method** | Phương thức thanh toán | Thẻ/ví/tài khoản người dùng dùng để trả (vd "Visa ••4821", "MoMo"), quản lý thành danh sách; một Subscription gắn tối đa một. | "card" |
| **Budget** | Ngân sách | Mức chi tối đa mỗi tháng cho một Category (và một mức tổng), so với Monthly cost của các Subscription `Active` trong Category đó. | "limit" |
| **Forecast** | Dự báo | Tổng tiền dự kiến phải trả trong một khoảng tới, tính từ các Due date sắp tới (không quy tháng). | "projection" |
| **Detection source** | Nguồn phát hiện | Nơi app tự lấy thông tin gói/lần trừ tiền, xử lý hoàn toàn trên máy: *Ảnh chụp* (màn hình gói của store, hoá đơn) · *Thông báo* (ngân hàng/ví do người dùng chọn) · *Gmail*. | "sync", "import" |
| **Detected charge** | Lần trừ tiền phát hiện | Một lần bị trừ tiền đọc được từ Detection source (dịch vụ, số tiền, ngày). Khớp chắc với Billing period đang chờ của một Subscription → **tự xác nhận** kỳ đó với số tiền thực trừ (Hoàn tác được); số tiền lệch chỉ ghi cho kỳ đó, giá Subscription giữ nguyên. | "transaction" |
| **Auto-detected** | Tự phát hiện | Nhãn của Subscription do app tự thêm từ Detection source (khi khớp dịch vụ trong Catalog, hoặc chỗ lạ có ≥ 2 Detected charge cùng số tiền cách ~1 chu kỳ). Người dùng gỡ được; gỡ thì không tự thêm lại. | |
| **Pro** | Bản Pro | Phần tự động (mọi Detection source) — thu phí; nhập tay luôn miễn phí. | "premium" |
| **Cancelled** | Đã huỷ | Người dùng báo đã huỷ. Subscription được giữ lại (khôi phục được), không còn Due date mới. | "deleted", "archived" |
| **Savings** | Tiết kiệm | Số tiền quy năm của các Subscription Cancelled — "bạn đã tiết kiệm X/năm". | |
| **Shared plan** | Gói chia sẻ | Subscription chia tiền với N người (Family/Duo). | |
| **My share** | Phần của tôi | Giá gói ÷ số người chia. Mọi tổng chi tính theo My share. | |
| **Primary currency** | Tiền tệ chính | Tiền tệ để cộng tổng chi; **USD** cho mọi máy mới (không suy từ ngôn ngữ/vùng máy — S-90). Mỗi Subscription có tiền tệ riêng. | "base currency" |
| **Exchange rate** | Tỷ giá | Tỷ giá quy đổi sang Primary currency, tự cập nhật hằng ngày khi có mạng, người dùng ghi đè được. | |
| **Monthly cost** | Chi phí quy tháng | Giá của một Subscription (My share) quy về 1 tháng theo Billing cycle và Exchange rate. Tổng chi tháng/năm = tổng Monthly cost của các Subscription `Active`; Trial hiển thị riêng là "sắp tính phí". | "average" |
| **Reminder** | Nhắc | Thông báo trên máy trước Due date (mặc định 3 ngày, 9:00) và trước khi Trial hết. | "alert", "push" (app không có server push) |
| **Catalog source** | Nguồn thư viện | Nơi app lấy Catalog: bản **đóng gói** trong app (luôn có, dùng khi offline) và bản **từ xa** của xưởng (cập nhật hằng tuần). App dùng bản mới nhất hợp lệ mà nó có. | "API của hãng" (không hãng nào có) |
| **Region** | Vùng giá | Giá gợi ý trong Catalog có hai vùng: **US** (giá chung cho mọi người, quy đổi sang Primary currency "≈") và **VN** (giá VND cho dịch vụ bán ở Việt Nam). Vùng không suy từ máy hay ngôn ngữ; tab Chung mở trước (S-90). | "currency" (tiền tệ khác vùng) |
| **Catalog section** | Mục thư viện | Thư viện chia *Chung* (dịch vụ toàn cầu) và *Việt Nam* (dịch vụ của VN). Cả hai tab luôn hiện; mở ra ở Chung. | |
| **Reference price** | Giá tham khảo | Giá gợi ý trong Catalog chưa được xác minh từ trang của hãng; vẫn điền sẵn nhưng ghi "giá tham khảo — kiểm lại". | "approx" |
| **Catalog link** | Liên kết thư viện | Mối nối giữa một Subscription và Service/Plan trong Catalog khi người dùng thêm từ thư viện. Subscription luôn là **bản sao riêng** của người dùng; Catalog đổi không tự sửa Subscription. | |
| **Price change notice** | Báo đổi giá | Khi giá Plan trong Catalog đổi và Subscription có Catalog link với giá còn bằng giá Catalog cũ: app **báo**, người dùng chọn *Cập nhật* (áp từ kỳ tới, Payment cũ giữ nguyên) hoặc *Giữ giá cũ*. Giá người dùng tự sửa thì không báo. | "auto-update" |
| **Discontinued plan** | Gói ngừng bán | Plan bị bỏ/đổi tên trong Catalog. Subscription đang dùng gói đó giữ nguyên, chi tiết hiện ghi chú nhẹ "gói đã ngừng bán cho khách mới". | "deleted plan" |
| **Service logo** | Logo dịch vụ | Logo thật của Service lấy từ dịch vụ logo bên thứ ba, lưu sẵn trên máy; không có/lỗi → tile monogram. | |
