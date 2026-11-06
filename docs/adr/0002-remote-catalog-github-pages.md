# 0002 — Catalog từ xa: JSON tĩnh trên GitHub Pages, cập nhật hằng tuần bằng GitHub Actions; logo từ logo.dev

- **Trạng thái:** Chấp nhận · 2026-11-06
- **Bối cảnh:** Người dùng muốn "lưu đúng chính xác các dịch vụ": giá đúng theo nước, đủ dịch vụ/gói, link huỷ đúng, logo thật —
  không phải chờ phát hành app mới, không dùng máy tính của xưởng, không dùng Claude cho việc lặp lại.
  Không hãng nào (Netflix, Spotify…) có API giá công khai; App Store Connect API chỉ đọc giá app của mình.

## Quyết định
1. **"API" là của xưởng:** repo public `phamphuongphuongnd/catalog`, GitHub Pages phục vụ `subnest/v1/services.json`
   (schema có phiên bản). App tải tối đa 1 lần/ngày, cache; offline/lỗi → bản đã tải hoặc bản đóng gói trong app.
2. **Cập nhật hằng tuần bằng GitHub Actions** (repo public → miễn phí): giá US/UK/AU/CA/IN từ API Aristocles (key do người dùng
   tạo, GitHub secret) + bộ đọc cố định trang giá VN ổn định → validator → **tự đăng**. Validator là chốt kỹ thuật bắt buộc
   (JSON sai không được đăng). Dịch vụ không đọc được giữ giá cũ.
3. **Vùng giá:** VN, US, UK, AU, CA, IN theo vùng máy; vùng khác dùng giá US quy đổi ("≈").
4. **Catalog không tự sửa dữ liệu người dùng:** Subscription là bản sao; đổi giá → *Price change notice* (người dùng chọn);
   gói ngừng bán → ghi chú nhẹ (CONTEXT.md).
5. **Logo thật từ logo.dev** (key `pk_` do người dùng tạo; free tier dùng thương mại phải ghi nguồn), lưu sẵn trên máy,
   lỗi → tile monogram. Bật từ bản nộp store đầu tiên, kèm ghi rõ logo/tên thuộc chủ sở hữu.

## Phương án đã cân nhắc
- App gọi thẳng API giá bên thứ ba — 100 lượt/ngày cho mọi người dùng, key lộ trong app, không có VN.
- Điện thoại tự đọc trang hãng — dễ vỡ, có thể trái điều khoản của hãng, lộ IP cho ~100 trang, rủi ro bị store từ chối.
- Routine Claude (cloud/máy này) hằng tuần — tốn hạn mức; Actions + Anthropic API — tốn tiền.
- Thu giá từ người dùng (server) — chính xác nhất nhưng phá cam kết "không thu thập dữ liệu".
- Giá mua trong app trên App Store/Play — khác giá web; không chọn ở đợt này.
- Brandfetch cho logo — cấm cache (mỗi lần hiện là một lần gọi mạng).

## Hệ quả
- Phụ thuộc Aristocles (sản phẩm cá nhân, chưa rõ điều khoản đăng lại dữ liệu) → phải kiểm điều khoản trước; không được thì bỏ nguồn đó.
- Bộ đọc trang VN sẽ vỡ khi hãng đổi giao diện → Actions giữ giá cũ + đánh dấu cần xem; không tự sửa được thì nhờ cập nhật tay.
- App giờ gọi mạng tới GitHub Pages và logo.dev → sửa privacy policy, Data safety, App Privacy (vẫn không thu thập dữ liệu người dùng).
- Rủi ro duyệt store vì logo thương hiệu → có sẵn đường lùi: tắt logo, nộp lại.

## Sửa đổi 2026-11-06 (grill lấy giá/quản lý)
- **Vùng giá rút còn US + VN** (thay 6 vùng ở mục 3): giá US dùng chung cho mọi người (quy đổi "≈"); máy ở VN thấy thêm
  *mục Việt Nam* và giá VND cho dịch vụ bán ở VN. Người dùng chủ yếu ở nước ngoài → ưu tiên độ phủ dịch vụ hơn giá theo nước.
- **Quy mô 500+ dịch vụ** hướng toàn cầu; giá chưa xác minh vẫn điền sẵn nhưng hiện nhãn *Giá tham khảo*.
