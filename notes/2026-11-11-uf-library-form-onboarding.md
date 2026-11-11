# [A001-subnest] UF Onboarding 005–011 · Thư viện 030–034 · Form 035–043 — 2026-11-11 (phiên con, điều phối #7)

Dựng lại theo mockup v14 (`design/system/bundle.js` `SCR.language/welcome/currency/pick/remind/library/form/crop` + `bundle.css`).
Commit trên `dev`: `de917e8` (Onboarding), `8c7be44` (Thư viện), `8f71f94` (Form), commit cuối (notes).

## Màn ↔ PNG ↔ code
| PNG | Nội dung | Code |
|---|---|---|
| 005 | Ngôn ngữ: ô 64px `brand-soft` + hai hàng EN/VI (badge, tên bản ngữ, tên Anh, ✓/radio) — chữ chỉ tiếng Anh | `onboarding/widgets/simple_steps.dart` `LanguageStep`; `onboarding_parts.dart` `OnboardingChoiceRow`, `OnboardingBadge`, `CheckCircle` |
| 006 | Chào mừng (chữ v14) | `WelcomeStep` (chỉ đổi chữ ARB) |
| 007–008 | Tiền tệ: hai thẻ lớn USD/VND (ký hiệu `brand`, ✓ góc, vòng 2px), "Chọn tiền tệ khác…", ghi chú tỷ giá; tiền tệ chọn từ danh sách hiện thành hàng ✓ thứ ba; danh sách = `showCurrencySheet` cũ | `CurrencyStep`, `_CurrencyCard` |
| 009 | Chọn dịch vụ: lưới logo thật, ✓ viền `bg`, thẻ nhanh (logo 32 + tên gói + giá + `CycleChip` + nút "Giá & chu kỳ"), thanh "Đã chọn N · ≈ …/tháng" | `pick_step.dart` `_QuickCard` (+ chỉnh nhẹ `_PickCell`) |
| 010–011 | Nhắc nhở (chữ v14, "No thanks"); hộp thoại hệ thống do OS vẽ | `RemindersStep` (chỉ ARB) |
| 030–031 | Thư viện: tìm kiếm focus, tab Chung/Việt Nam, chip danh mục, "Tạo dịch vụ tuỳ chỉnh", hàng = logo + tên + "từ $8.99" + `CycleChip` + tag **Giá tham khảo** + dòng "≈ …" + nút +; chân trang "Thư viện cập nhật N ngày trước" = `catalogUpdatedOnProvider` (hôm nay / hôm qua / N ngày) | `catalog/catalog_screen.dart`, `widgets/library_rows.dart` (`LibraryRow` đổi API: `price`, `cycle`, `approx`, `fallback`, `reference`), `catalog_helpers.dart` `CatalogView.rowOffer` |
| 032–033 | Tìm "netf": ẩn tab + chip, tìm **cả hai vùng** (tab đang mở xếp trước, mỗi dòng theo giá vùng của nó), "Không phải? Tạo “netf”"; không thấy → "Không thấy “abc”" + "Tạo “abc”" | `_searchResults` |
| 034 | Chọn gói: giá + `CycleChip` bên phải, phụ đề "Tối đa N người"/Giá tham khảo, "Chọn gói · giá US" | `widgets/plan_sheet.dart` |
| 035–036 | Form: thẻ **Danh mục + Nhãn** chung; "Nhắc trước … lúc 9:00" (chip Đúng ngày/1/3/7); **Thêm chi tiết** gồm chip Phương thức thanh toán (chạm = chọn/bỏ, "+ Thêm" mở sheet cũ), link huỷ, Đáng tiền?, ghi chú; khung chia có `CycleChip` | `subscription_form_screen.dart` (`_categoryCard` + `_labelsField`, `_moreCard` + `_methodField` + `_worthField`, `_SharePanel`) |
| 037 | Gói tự tạo (Gym): dòng "Dịch vụ tự tạo · chạm biểu tượng để chọn ảnh", nút sửa ở logo là icon ảnh | `_header` |
| 038, 040 | Sheet **Đổi biểu tượng**: xem trước 80px + "Chữ trên nền màu"/"Ảnh của bạn, cắt vuông"; Chọn ảnh + **Chụp ảnh** (hoặc Chọn ảnh + Gỡ ảnh khi đã có ảnh); màu; một ô "Chữ cái hoặc emoji"; Xong. Ảnh vẫn chỉ cho dịch vụ không có logo đóng gói (logic phiên L giữ nguyên) | `widgets/tile_sheet.dart` (bỏ tab Chữ/Emoji, hàng emoji, xem trước dạng danh sách) |
| 039 | Cắt ảnh: màn tối, ✕ · "Di chuyển và thu phóng" · xoay (90°), khung vuông bo 28% trắng, "Huỷ" / "Dùng ảnh" | `widgets/custom_logo_picker.dart` (+ `customLogoCameraProvider`) |
| 041 | Kiểm hợp lệ (chữ không đổi) | như cũ |
| 042–043 | Sửa giá: ghi chú `history` "Giá cũ …"; hộp thoại "Áp dụng giá X từ kỳ tới?" + bảng Hiện tại / Từ 4/12 (+chênh, `warning-ink` khi tăng) + **Áp dụng từ 4/12** / **Huỷ** (Huỷ = không lưu gì, ở lại form — bỏ nút "Giữ giá cũ" v13). `save()` tự ghi Lịch sử giá, test kiểm hàng `PriceChange` | `_confirmPrice` |

Việc dở giao kèm: Form sửa/thêm đọc dịch vụ từ `catalogProvider` đã nạp (`await ref.read(catalogProvider.future)`), không còn `catalogRepositoryProvider.byId()`.

## Chuỗi ARB (chỉ trong ARB feature mình)
- onboarding: viết lại theo chữ v14 (+`onboardingLanguageEnglishSub/VietnameseSub`; bỏ `CurrencyDefault`, `CurrencyChosen`, `PickMeta`). Màn Ngôn ngữ vẫn chỉ chữ Anh ở cả hai file.
- catalog: +`catalogUpdated`; đổi `catalogCustomSub/CustomNamed/Popular/PopularVietnam/NoResult*/PlanSub*`; VI `catalogTitle` "Thêm gói đăng ký".
- subscription_form: +`PriceNow/PriceFrom/RemindAt/CustomSub/AddMethod/TileLetterPreview/TilePhotoPreview/TileTakePhoto/TileLetterOrEmoji/CropRotate`; `PriceApply` nhận `{date}`; đổi `PriceWas/MoreSub/RemindOnDay/PriceDialog*/TileTitle/Crop*`; bỏ các chuỗi không còn dùng.
- Đã chạy `merge_arb` + `gen-l10n`; **không commit** `lib/l10n/app_*.arb`, `lib/l10n/generated/` (điều phối gen khi gộp).

## Kiểm tra
- `flutter analyze` (cả dự án lúc kiểm): sạch.
- `flutter test test/features/onboarding test/features/catalog test/features/subscription_form test/a11y`: **136 qua, 1 đỏ** — `test/a11y/semantics_tap_action_test.dart` báo `lib/features/settings/manage/manage_sheets.dart:221` (Semantics ẩn onTap) = code của phiên **US Cài đặt**, ngoài phạm vi, không do UF.
- `merge_arb --check` OK (sau khi merge lại; trước đó "out of date" vì phiên khác vừa sửa ARB của họ).
- Ma trận bố cục 360/390 × EN/VI × sáng/tối × 100/130/200% (+ 320 × 200% cho Form) chạy cho cả ba nhóm, không tràn.
- So ảnh render tạm (390 EN sáng) với mockup: tiền tệ (007), chọn dịch vụ (009), thư viện (030), hộp thoại giá (043), chi tiết thêm (036) khớp bố cục. Chưa nhìn từng ảnh dark/VI (test ma trận không báo tràn). Ảnh render thử đã hoàn nguyên, không commit.

## Lệch có chủ ý / giới hạn
- 011 (hộp thoại quyền thông báo) và hộp thoại cắt ảnh/camera là của hệ điều hành — không dựng.
- Màn cắt ảnh: xoay 90° làm bằng `RotatedBox`; không có "thu phóng bằng nút", chỉ chụm/kéo như cũ.
- "Chụp ảnh" dùng `ImagePicker.camera` (intent camera hệ thống, không cần quyền CAMERA; iOS đã có `NSCameraUsageDescription`). **Chưa thử trên máy thật.**
- Danh sách tiền tệ 008 dùng lại `showCurrencySheet` (v13) — chưa đối chiếu từng pixel với 008.
- Nút "Lưu" bị khoá khi có lỗi (như v13), mockup 041 vẽ tương tự.
- `?region=` cho `/subscription/new`: **chưa cần** — vẫn dùng `libraryPickRegionProvider`, hoạt động đúng; chỉ khi muốn bỏ provider tạm thì cần router nhận tham số (không thuộc phạm vi tôi).
- `LibraryRow`/`planSubtitle`/`rowMeta` cũ: `rowMeta` còn dùng ở Tổng quan (`home_screen.dart:918`) nên giữ.

## Nên gom lên core
- `OnboardingChoiceRow` / `CheckCircle` (hàng chọn có badge + ✓) — Cài đặt (sheet ngôn ngữ/tiền tệ) có thể dùng.
- `LibraryRow` kiểu "logo + giá + chip chu kỳ" đã na ná `_LibraryRow` của Tổng quan (`home_screen.dart:930`) → dùng chung được.
