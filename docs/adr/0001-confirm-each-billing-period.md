# 0001 — Mỗi kỳ phải được xác nhận; Due date đứng yên cho tới khi xác nhận

- **Trạng thái:** Chấp nhận · 2026-11-04
- **Bối cảnh:** App cạnh tranh (Bobby, Tilla) tự cuộn ngày gia hạn và coi như đã trả. Người dùng chọn cách
  ghi sổ từng kỳ để chi tiêu thực tế chính xác (giá đổi, kỳ được miễn, gói bị huỷ ngầm…).

## Quyết định
1. Khi tới Due date, Billing period chuyển sang **Awaiting confirmation**. Người dùng xác nhận **trong app**
   (không có nút trên thông báo): *Đã trả* (tạo Payment, số tiền sửa được) · *Không trả kỳ này* (Skipped) · *Để sau*.
2. **Due date của Subscription đứng yên** cho tới khi kỳ hiện tại được xác nhận; Reminder của kỳ sau chỉ được
   lên lịch sau khi xác nhận. Kỳ đã qua mà chưa xác nhận được bắt kịp lần lượt, có "Xác nhận tất cả".
3. Chi tiêu *thực tế* chỉ tính từ Payment; Monthly cost/tổng chi tháng vẫn tính từ Subscription `Active`.
4. Hết Trial → Subscription tự thành `Active`; ngày hết Trial là Due date của kỳ trả phí đầu tiên (cũng phải xác nhận).

## Phương án đã cân nhắc
- *Tự cuộn ngày, coi như đã trả* (đề xuất ban đầu) — ít thao tác nhất, nhưng không có chi tiêu thực tế.
- *Tự tạo Payment, cho sửa* — ít phiền, nhưng người dùng muốn chủ động xác nhận.
- *Ngày vẫn nhảy, kỳ cũ vào hàng chờ* — nhắc kỳ sau không bị trễ; người dùng chọn đứng yên để danh sách chờ
  không dồn nhiều kỳ.

## Hệ quả
- Người dùng bỏ app lâu sẽ thấy Subscription "kẹt" ở kỳ cũ và không nhận nhắc kỳ mới → UI phải làm nổi bật kỳ
  chờ ở mọi nơi + có luồng bắt kịp nhanh. Thông báo "đến ngày" là cú hích duy nhất để quay lại app.
- Data model cần thực thể Payment/Skipped riêng; đổi sang tự cuộn sau này cần migration dữ liệu.
