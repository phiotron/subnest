# Ảnh chụp store — Subnest (A001-subnest)

Chụp từ **app thật** (bản release, Galaxy A13 SM-A135F, Android 14) ngày 2026-11-05, dữ liệu mẫu theo `product.md` §8
(không có dữ liệu cá nhân). 1102 × 2203 PNG, tỷ lệ 1,999 : 1 — đạt quy cách Google Play (cạnh 320–3840 px, cạnh dài ≤ 2 × cạnh ngắn).
Tối đa 8 ảnh/loại thiết bị trên Play → mỗi ngôn ngữ đúng 8 ảnh, thứ tự = thứ tự đăng.

| # | `en/` | `vi/` | Màn |
|---|---|---|---|
| 1 | `01-overview.png` | `01-overview.png` | S2 Tổng quan: tổng tháng, chờ xác nhận, dùng thử sắp hết, sắp tới |
| 2 | `02-confirm.png` | `02-confirm.png` | S6 Tấm xác nhận kỳ (Netflix chia 4) |
| 3 | `03-calendar.png` | `03-calendar.png` | S8 Lịch tháng |
| 4 | `04-insights.png` | `04-insights.png` | S9 Thống kê 12 tháng |
| 5 | `05-detail.png` | `05-library.png` | EN: S5 Chi tiết · VI: S3 Thư viện (giá VN) |
| 6 | `06-savings.png` | `06-detail.png` | EN: ăn mừng huỷ / Tiết kiệm · VI: S5 Chi tiết |
| 7 | `07-subscriptions.png` | `07-savings.png` | EN: danh sách (Active, badge chờ, ÷ chia sẻ) · VI: ăn mừng huỷ |
| 8 | `08-insights-dark.png` | `08-insights-dark.png` | S9 tối: theo tháng + theo danh mục |

EN không có ảnh Thư viện: máy ở vùng VN nên thư viện hiện "Popular in Vietnam" + giá ₫ — chụp lại trên máy/vùng en-US nếu muốn.

## Chụp lại
1. Sinh backup mẫu: `python -I store/screenshots/tools/make_demo_backup.py assets/catalog/services.json <thư mục> <hôm nay>`
   → `adb push demo-vi.json /sdcard/Download/` → app: Cài đặt → Khôi phục từ file → **Thay thế**.
2. Cỡ chữ hệ thống 1.0, kích thước hiển thị mặc định, theme Theo hệ thống (tối: `adb shell cmd uimode night yes`).
3. `adb exec-out screencap -p > raw.png` → `python -I store/screenshots/tools/frame.py raw.png out.png`
   (cắt thanh trạng thái + điều hướng: Samsung bỏ qua chế độ demo của Android nên icon cá nhân sẽ lộ).
