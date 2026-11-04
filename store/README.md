# store/ — nội dung store & pháp lý của Subnest (A001-subnest)

> Mọi chữ dùng khi đăng app lên Google Play và App Store, EN + VI. Phiên con D tạo 2026-11-04.
> Placeholder dạng `<VIẾT_HOA>` phải thay trước khi dùng (danh sách ở cuối).

## Mục lục
| File | Nội dung | Dùng ở đâu |
|---|---|---|
| `listing/en.md` | Play: title, short, full description · App Store: name, subtitle, promo, keywords, description, What's New — **có đếm ký tự** | Play Console → Main store listing (en-US) · App Store Connect → English (U.S.) |
| `listing/vi.md` | Bản tiếng Việt tương ứng | Play → Thêm bản dịch *vi* · App Store → Vietnamese |
| `legal/privacy-policy.{en,vi}.md` | Chính sách quyền riêng tư (nguồn) | Sửa ở đây |
| `legal/terms.{en,vi}.md` | Điều khoản sử dụng ngắn (không bắt buộc với store, nên có) | |
| `legal/*.html`, `legal/index.html` | Bản HTML tĩnh **sinh ra từ .md** — upload nguyên thư mục `legal/` lên nơi host | Privacy policy URL, Support URL |
| `forms/google-play.md` | Câu trả lời App content: Data safety, IARC, target audience, ads, financial features, exact alarm… | Play Console → Policy → App content |
| `forms/app-store.md` | App Privacy ("Data Not Collected"), privacy manifest, export compliance, age rating, review notes | App Store Connect |
| `testers/invite.md` | Thư mời closed testing (VI/EN, ngắn + email) + tin nhắc ngày 7 + tin cảm ơn | Zalo/Messenger/email |
| `testers/guide.md` | Hướng dẫn: người tổ chức (Google Group, Play Console) + tester từng bước (VI/EN) | Gửi kèm thư mời |
| `testers/tracker.csv` | Bảng theo dõi tester (mở bằng Excel/Google Sheets) | Đếm đủ 12 người × 14 ngày |
| `icon-brief.md` | Brief icon + feature graphic + danh sách kích thước bàn giao | Đối chiếu icon của Claude Design |
| `tools/check_lengths.py` | Đếm ký tự/byte mọi trường listing, kiểm giới hạn + luật keywords | Chạy sau mỗi lần sửa listing |
| `tools/md_to_html.py` | Sinh `legal/*.html` từ `.md` (không cần thư viện) | Chạy sau mỗi lần sửa legal |

```bash
python store/tools/check_lengths.py          # thêm --fix để cập nhật số đếm trong tiêu đề
python store/tools/md_to_html.py
```
(Trên Windows nếu lỗi in tiếng Việt: đặt `PYTHONIOENCODING=utf-8`.)

## Việc còn thiếu / người dùng cần quyết
1. **Email hỗ trợ** `<SUPPORT_EMAIL>` — hiển thị công khai trên cả 2 store, trong privacy policy và nút "Gửi góp ý".
   Đề xuất một hộp thư riêng cho xưởng (vd một Gmail mới chỉ dùng cho app, hoặc `support@<domain>`), không dùng email cá nhân hay email công việc.
2. **Tên nhà phát triển** `<DEVELOPER_NAME>` — phải khớp tên developer trên Play Console / Apple (tài khoản cá nhân
   thì Apple hiện **tên thật**). Bundle là `com.phiotron.*` → nếu Play hiện "Phiotron" thì privacy ghi
   "Phiotron (<họ tên>)".
3. **Nơi host privacy policy** → điền `<PRIVACY_POLICY_URL>`, `<SUPPORT_URL>`, `<WEBSITE_URL>` (phương án bên dưới).
4. **API tỷ giá:** privacy policy đang ghi **ExchangeRate-API (open.er-api.com)** theo gợi ý APP.md — phiên A chưa
   chốt (2026-11-04 chưa có code gọi API). Đổi nhà cung cấp → sửa 2 file privacy + chạy `md_to_html.py`.
5. **Exact alarm:** nếu phiên A/E xin `SCHEDULE_EXACT_ALARM` → xem `forms/google-play.md` §8.
6. **Dòng "Có trên Android và iPhone"** trong listing Play: xoá nếu bản iOS chưa live lúc đăng.
7. **Ảnh chụp màn hình + feature graphic** — chưa có (phiên M ở điều phối #3; feature graphic theo `icon-brief.md`).
8. **Google Group + opt-in link** cho tester — tạo khi phiên E upload được AAB lên closed testing (`testers/guide.md` §A).

## Nơi host privacy policy — phương án
Yêu cầu chung: URL công khai, ổn định lâu dài (đổi URL phải sửa trên cả 2 store), không cần đăng nhập, HTML (không PDF),
không bị chặn ở VN.

| Phương án | Ưu | Nhược | Chi phí |
|---|---|---|---|
| **A. GitHub Pages — repo public riêng** (vd `phiotron/apps` → `phiotron.github.io/apps/subnest/privacy-policy.en.html`) | Miễn phí; dùng luôn file HTML ở `legal/`; có lịch sử sửa đổi; **một repo cho mọi app của xưởng** (mỗi app một thư mục); sau gắn domain riêng được | Repo phải public (chỉ chứa trang pháp lý — repo app vẫn private); URL gắn tên tài khoản GitHub; cần push mỗi lần sửa | 0 |
| **B. Google Sites** | Dễ nhất, sửa trên web, không cần git | Phải dán tay nội dung (không dùng file HTML); 2 ngôn ngữ = 2 trang tay; URL dài `sites.google.com/view/...`; khó tái dùng cho app sau | 0 |
| **C. Domain riêng** (vd `phiotron.app` / `subnest.app`) + host tĩnh (GitHub Pages / Cloudflare Pages) | Chuyên nghiệp, URL không phụ thuộc nền tảng, email `support@domain`, làm trang giới thiệu/landing sau này; dùng cho cả xưởng | Tốn phí hằng năm, phải gia hạn (hết hạn = link chết = vi phạm store); cấu hình DNS | ~10–40 USD/năm |

**Đề xuất:** làm **A ngay** (repo public `phiotron/apps` hoặc `<github-user>.github.io`, một thư mục mỗi app, copy
`store/legal/` vào), và khi xưởng có 2–3 app thì mua **domain cấp xưởng** (C) trỏ vào chính repo đó — URL cũ vẫn
redirect được, không phải làm lại nội dung. Tránh B vì không tái dùng được.

## Placeholder cần thay
| Placeholder | Ở đâu |
|---|---|
| `<SUPPORT_EMAIL>` | legal/*.md, forms/*.md, testers/guide.md §A |
| `<DEVELOPER_NAME>` | legal/*.md, forms/app-store.md |
| `<PRIVACY_POLICY_URL>`, `<SUPPORT_URL>`, `<WEBSITE_URL>` | forms/*.md (điền trên console) |
| `<GROUP_LINK>`, `<OPT_IN_LINK>`, `<DEADLINE>`, `<YOUR_NAME>`, `<FEEDBACK_CONTACT>` | testers/*.md |

Sau khi thay trong `legal/*.md` → chạy lại `tools/md_to_html.py` rồi mới upload.
