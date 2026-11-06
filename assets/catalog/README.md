# Catalog (Thư viện dịch vụ) đóng gói trong app — schema v4

`services.json` là **bản đóng gói** của thư viện dịch vụ (Catalog), sinh từ repo public `catalog`
(`subnest/v1/services.json`, ADR 0002). App dùng bản này khi chưa tải được bản từ xa hoặc bản từ xa lỗi; bản nào có
`version` lớn hơn và hợp lệ thì dùng bản đó.

- **Không có `note`** (ghi chú nguồn cho người bảo trì — chỉ có ở bản đầy đủ trong repo `catalog`), thụt lề 1 để diff
  dễ đọc. Nội dung còn lại giống hệt `services.json` của repo `catalog` cùng `version`.
- **Số liệu, schema đầy đủ, nguồn giá:** `catalog/README.md` (repo `catalog`). Ghi chú bàn giao:
  `notes/2026-11-06-c1-catalog.md`.
- **Kiểm tra:** `python assets/catalog/tool/validate_catalog.py` (exit 0 = hợp lệ). File này **sinh tự động** từ
  `catalog/tools/validate.py` + `common.py` — sửa ở repo `catalog` rồi sinh lại, không sửa tay ở đây.
- **Cập nhật bản đóng gói** (trước mỗi bản phát hành): trong repo `catalog` chạy
  `python tools/export_app_asset.py ../apps/A001-subnest/assets/catalog` (ghi `services.json` không `note` + sinh lại
  validator), rồi chạy validator ở trên.

## Schema v4 tóm tắt (cho bộ đọc trong `lib/`)

Gốc: `schemaVersion` = 4 · `version` (int, tăng mỗi lần dữ liệu đổi) · `updatedAt` · `staleAfterDays` = 90 ·
`regions` = `{"US":"USD","VN":"VND"}` · `services[]` (theo thứ tự danh mục).

| Service | | Plan | | Price | |
|---|---|---|---|---|---|
| `id` slug, không bao giờ đổi | ✔ | `id` slug | ✔ | `currency` = tiền của vùng | ✔ |
| `name` | ✔ | `name` | ✔ | `amount` đơn vị chính (VND nguyên) | ✔ |
| `category` (11 giá trị) | ✔ | `status` `active`/`closed_to_new`/`discontinued` (lạ → `active`) | ✔ | `method` `aristocles`/`vn-parser`/`manual` | ✔ |
| `color`, `monogram` (tile dự phòng) | ✔ | `cycle` `{unit: day/week/month/year, count}` | ✔ | `verifiedAt` + `source` (đi cùng nhau) | |
| `market` `global`/`vn` = **Catalog section** | ✔ | `prices` `{US?, VN?}` | ✔ | | |
| `logoDomain` (logo.dev) | ✔ | `members` (gói chia sẻ) | | | |
| `aliases` (chữ thường, có không dấu) | ✔ | `renamedFrom` | | | |
| `cancelUrl`, `manageUrl` (https hoặc null) | ✔ | | | | |
| `storeNames` (tên như trên trang gói Google Play/App Store) | | | | | |

- **Region:** giá `US` dùng cho mọi người (quy đổi "≈" sang tiền tệ chính); giá `VN` chỉ dùng khi máy ở VN. Mục
  *Việt Nam* (`market: "vn"`) chỉ hiện khi máy ở VN; dịch vụ `vn` có thể chỉ có giá VN.
- **Reference price (Giá tham khảo):** giá không có `verifiedAt`, hoặc `verifiedAt` cũ hơn `staleAfterDays` ngày →
  vẫn điền sẵn nhưng hiện chip "Giá tham khảo". Phần lớn dịch vụ thêm đợt C1 (2026-11-06) là giá tham khảo.
- **`storeNames`** (tuỳ chọn): bộ quét ảnh (product.md §10.6) so khớp tên đọc được với `storeNames`, rồi `name`,
  rồi `aliases`. Là tên ước lượng theo hiểu biết chung, **chưa** đối chiếu ảnh chụp thật.
- Không xoá service/plan: id cũ luôn còn (Catalog link của Subscription trỏ vào id).
