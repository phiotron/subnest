# [A001-subnest] Điều phối thử máy — sao lưu, khôi phục, làm tròn (2026-11-10)

Máy: Galaxy A13 (`R58TC12SRZW`), Android, cỡ chữ hệ thống 0.8. APK debug từ `dev` `ac4d5b3` rồi `b0f32fa`. Lái bằng adb + uiautomator.
Dữ liệu: 5 gói thử bằng USD (YouTube Premium, Spotify, ChatGPT Go, iCloud+ 50 GB, Netflix Standard with ads), Tiền tệ chính VND.

## Kết quả
| Việc | Kết quả |
|---|---|
| Làm tròn: tổng = cộng dòng | ĐẠT — 408,188 + 331,605 + 204,222 + 25,272 + 229,494 = **₫1,198,781** = Tổng quan |
| Làm tròn: VND → USD → VND | ĐẠT — USD $46.96; về VND đúng lại **₫1,198,781** |
| Bật sao lưu tự động: bộ chọn thư mục → quyền → mật khẩu 2 lần → giờ (mặc định **21:00**) | ĐẠT (thư mục thử `Download/SubnestTest`, không ghi vào Drive của Phương) |
| Giờ sao lưu: chuyển sang nhập bằng bàn phím | **LỖI → đã sửa** `b0f32fa`: màn đỏ "BoxConstraints has non-normalized height constraints" (máy cỡ chữ 0.8: chiều cao hộp 252×0.8 = 201,6 < tối thiểu 216 của Flutter). Sửa: `dialOnly` như giờ nhắc (`settings_actions.dart`). Kiểm lại: không còn nút bàn phím |
| Bù khi lỡ: chưa sao lưu lần nào → rời app | ĐẠT — ghi `subnest-auto-…-1557` |
| File luôn mã hoá | ĐẠT — envelope `subnest-backup-encrypted` (PBKDF2 100k + AES-GCM), không có chữ rõ |
| Sao lưu ngay + giữ 2 file | ĐẠT — 3 lần ghi → chỉ còn 2 file mới nhất |
| Hẹn giờ khi app đã tắt (`am kill`) | ĐẠT — đặt 16:10, alarm nổ 16:11:43 (inexact), Android khởi động app nền, log `SubnestBackup: scheduled backup result=ok`, ghi `…-1611`, còn 2 file |
| Xoá toàn bộ | ĐẠT — 2 bước → onboarding bước 1 Language; file sao lưu vẫn còn |
| Khôi phục file mã hoá: sai mật khẩu | ĐẠT — "Wrong password, or the file was changed" |
| Khôi phục: đúng mật khẩu | ĐẠT — một hộp "Restore this backup?" (5 gói, 0 thanh toán), chỉ **Replace my data**; về đủ 5 gói, Tiền tệ chính VND, tổng **₫1,198,781** |
| Tắt sao lưu tự động | ĐẠT — tắt ngay, file không bị xoá |

Dọn máy: tắt sao lưu tự động, xoá `Download/SubnestTest`. Subnest còn 5 gói thử, Tiền tệ chính USD, PIN tắt.

## Ghi chú
- "Sao lưu ngay" luôn ghi file dù dữ liệu không đổi; luật "chỉ ghi khi dữ liệu đổi" chỉ áp cho lần chạy theo giờ (như A002 D-027).
- **A002 có cùng lỗi time picker** (`auto_backup_section.dart` dòng ~301, ~333; `reminder_section.dart` ~89; `onboarding_screen.dart` ~92;
  `entry_time.dart` ~58 — đều `showTimePicker` mặc định) trên máy cỡ chữ < ~0.86 → đã ghi việc cho A002 trong `TASKS.md`.
- Chưa thử: chạy nền sau khởi động lại máy / đổi múi giờ; iOS (chưa có máy, Swift chưa biên dịch).
