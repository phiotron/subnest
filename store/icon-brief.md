# Subnest — App icon brief

> Chỉ chữ. Dùng để đối chiếu với icon Claude Design làm (phiên F đưa vào app). Màu cụ thể lấy theo token
> thương hiệu của Claude Design (product.md §7.3 gợi ý chàm/teal) — brief này không ép mã màu.

## Ý tưởng
**"Tổ" (nest) gom các subscription.** Một hình tổ tối giản ôm 2–3 "thẻ"/"đồng xu" xếp chồng — mỗi thẻ là một
subscription — hoặc một vòng tròn tổ có mũi tên tuần hoàn (chu kỳ gia hạn) ẩn trong nét đan.
Thông điệp: *mọi khoản định kỳ ở một chỗ, gọn, an toàn.*

Hướng phương án (Claude Design chọn/đề xuất 2–3, chọn 1):
1. **Tổ + thẻ:** đường cong hình chiếc bát/tổ ở nửa dưới, 2–3 thẻ bo góc màu khác nhau nhô lên (gợi tile dịch vụ của app).
2. **Tổ + vòng lặp:** vòng tròn dày gồm 2–3 nét đan, một đầu nét thành mũi tên → "gia hạn định kỳ".
3. **Chữ "S" tổ:** chữ S được tạo bởi 2 nét cong như cành đan, có một chấm/trứng ở giữa.

## Bắt buộc
- Nhận ra được ở **48 px** (launcher Android) và **29 pt** (Settings iOS): tối đa 2–3 khối hình, nét dày, không chi tiết nhỏ.
- **Không chữ**, không tên app, không ký hiệu tiền tệ cụ thể ($, ₫) — app toàn cầu, đa tiền tệ.
- **Không logo thương hiệu** của dịch vụ nào, không giống logo Netflix/Spotify… (rủi ro bị từ chối).
- Không hoạt hình/nhân vật dễ thương quá mức → tránh "appeal to children" (Play target audience 18+).
- Nền đặc (không trong suốt) cho iOS; tương phản tốt trên cả nền launcher sáng và tối.
- Không bắt chước icon của app đối thủ (tránh xanh lá + chữ B, tránh icon lịch/chuông chung chung).

## File cần bàn giao
| Dùng cho | Kích thước / dạng |
|---|---|
| App Store | 1024 × 1024 PNG, **không** trong suốt, **không** tự bo góc (iOS tự bo) |
| Google Play listing | 512 × 512 PNG 32-bit, ≤ 1 MB (Play tự bo góc + đổ bóng — không vẽ sẵn) |
| Android adaptive icon | **Foreground** 432 × 432 (108 dp), hình chính nằm trong **vùng an toàn 264 × 264 (66 dp) ở giữa** · **Background** 432 × 432 màu đặc hoặc gradient nhẹ · **Monochrome** (Android 13 themed icon): 1 màu, cùng hình foreground |
| iOS 18+ | Biến thể **Dark** và **Tinted** (nếu Claude Design cung cấp) |
| Notification icon (Android) | 1 màu trắng trên nền trong suốt, 24 dp — hình tổ đơn giản hoá |
| Splash (S0) | Logo dạng vector (SVG) trên nền màu thương hiệu |
| Nguồn | SVG/Figma để chỉnh sau |

## Feature graphic (Google Play, 1024 × 500)
Nền màu thương hiệu, icon bên trái, slogan bên phải:
- EN: **"All your subscriptions, one nest"**
- VI: **"Mọi subscription, một tổ"**
Giữ phần quan trọng ở giữa (Play có thể cắt mép), không chèn nút "Download"/huy hiệu store.

## Cách kiểm
- Đặt icon cạnh 20 icon phổ biến trên màn hình điện thoại thật (sáng + tối) → còn nhận ra không?
- Thu nhỏ 48 px, nheo mắt → còn thấy hình tổ/thẻ không?
- Android themed icon (monochrome) → hình vẫn đọc được.
