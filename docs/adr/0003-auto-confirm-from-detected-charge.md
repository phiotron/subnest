# 0003 — Tự phát hiện gói và tự xác nhận kỳ từ Detected charge (có Hoàn tác); sửa ADR 0001

- **Trạng thái:** Chấp nhận · 2026-11-06 · sửa một phần [0001](0001-confirm-each-billing-period.md)
- **Bối cảnh:** Người dùng muốn app vừa nhập tay vừa tự lấy thông tin gói đăng ký. Bốn đối thủ được tham chiếu
  (Trackly, Submos, SubFox, SubTrack) đều chỉ nhập tay; các app nối ngân hàng (Rocket Money, Monarch, Copilot) tự phát hiện
  và tự gắn lần trừ tiền vào khoản định kỳ. Subnest giữ cam kết "không thu thập dữ liệu" nên mọi nhận diện chạy trên máy,
  với các Detection source: ảnh chụp (1.0), thông báo ngân hàng/ví (1.1, Android), Gmail (1.2).

## Quyết định
1. **Gói mới phát hiện được tự thêm** với nhãn *Tự phát hiện*, kèm Hoàn tác/gỡ — chỉ khi tên khớp dịch vụ trong Catalog,
   hoặc chỗ lạ có ≥ 2 Detected charge cùng số tiền cách nhau khoảng một chu kỳ (mua lẻ không bị thêm nhầm).
   Gỡ một gói Tự phát hiện → app nhớ và không tự thêm lại.
2. **Detected charge khớp chắc với kỳ đang chờ** của một Subscription (cùng dịch vụ, số tiền gần đúng, gần Due date)
   → **tự xác nhận** kỳ đó (tạo Payment với số tiền thực trừ), báo kèm *Hoàn tác*. Khớp không chắc → để người dùng xác nhận như ADR 0001.
3. **Số tiền lệch** (vd hãng tăng giá) → chỉ ghi số thực trừ cho kỳ đó; giá của Subscription **không** tự đổi (như SubTrack).
4. Không có Detection source nào bật → hành vi y như ADR 0001 (mỗi kỳ người dùng tự xác nhận).

## Phương án đã cân nhắc
- *Danh sách chờ duyệt* (Monarch/Copilot) cho gói mới — an toàn hơn, người dùng chọn tự thêm cho nhanh.
- *Luôn hỏi* cho lần trừ tiền khớp — giữ nguyên tinh thần ADR 0001, nhưng mất phần lớn lợi ích của tự động.
- *Tự đổi giá gói theo số thực trừ* — người dùng chọn chỉ ghi cho kỳ đó.

## Hệ quả
- Payment cần biết nguồn (tay / tự động) để Hoàn tác và để hiển thị; Subscription cần nguồn + thời điểm phát hiện.
- Luật "khớp chắc" (ngưỡng số tiền, cửa sổ ngày) là luật domain có unit test; chỉnh ngưỡng không cần ADR mới.
- Nhận diện sai sẽ làm sai tổng chi tới khi người dùng Hoàn tác → nhãn Tự phát hiện phải nhìn thấy được ở danh sách và chi tiết.
