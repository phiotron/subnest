# Hướng dẫn tester · Tester guide

> Gửi kèm thư mời. Thay `<GROUP_LINK>`, `<OPT_IN_LINK>`, `<FEEDBACK_CONTACT>`.
> Phần A cho người tổ chức (làm 1 lần trên Play Console), phần B/C cho tester.

---

## A. Người tổ chức — chuẩn bị (1 lần)

1. **Tạo Google Group** (groups.google.com) tên vd `subnest-testers`: quyền *Who can join* = "Anyone on the web can
   ask" hoặc "Invited users only"; *Who can view members* = Group managers. → lấy `<GROUP_LINK>`.
   (Nhóm giúp thêm/bớt tester mà không phải sửa Play Console; tester rời nhóm = rời test.)
2. Play Console → **Testing → Closed testing** → tạo track (vd "Alpha") → **Testers** → *Google Groups* → nhập email
   nhóm `subnest-testers@googlegroups.com`. Có thể kèm *Email list* cho người không muốn vào nhóm.
3. Ghi **feedback URL or email** = `phamphuongphuongnd@gmail.com`.
4. Upload AAB (phiên E), *Countries/regions* = tất cả nước có tester, gửi review. Khi track được duyệt, copy
   **opt-in link** ("Join on the web") → `<OPT_IN_LINK>`.
5. Gửi thư mời (`invite.md`), theo dõi bằng `tracker.csv`. **14 ngày tính từ khi có đủ 12 tester đã opt-in**,
   phải liên tục — ai rời nhóm/opt-out giữa chừng thì cần người bù.
6. Hết 14 ngày → Play Console → *Dashboard* → **Apply for production** (trả lời vài câu về quá trình test:
   số tester, cách thu góp ý, đã sửa gì → ghi sẵn trong `notes/`).

---

## B. Hướng dẫn cho tester — Tiếng Việt

**Bạn cần:** điện thoại Android, tài khoản Gmail đang đăng nhập trên Play Store của máy đó.

1. **Vào nhóm thử nghiệm** — mở `<GROUP_LINK>` trên trình duyệt, đăng nhập **đúng Gmail dùng trên điện thoại**, bấm
   **"Tham gia nhóm" / "Join group"**.
   *Máy có nhiều tài khoản Google?* Dùng cùng một tài khoản cho cả bước 1, 2, 3.
2. **Đồng ý tham gia thử nghiệm** — mở `<OPT_IN_LINK>` (nên mở trên điện thoại), bấm **"Become a tester" / "Trở thành
   người thử nghiệm"**. Nếu báo "App not available" → đợi vài phút sau bước 1 rồi tải lại trang.
3. **Cài app** — trên cùng trang, bấm **"Download it on Google Play"** → **Cài đặt**. Tên trên Play Store:
   *Subnest: Quản lý gói đăng ký* (có nhãn "Thử nghiệm" / "Early access").
4. **Dùng thử vài phút** — thêm 2–3 gói bạn đang dùng, cho phép thông báo khi được hỏi.
5. **Giữ app ít nhất 14 ngày** ⚠ — đây là phần quan trọng nhất:
   - **không gỡ app**, **không rời nhóm**, **không bấm "Leave the program"**;
   - để Play Store tự cập nhật bản mới (mình có thể gửi vài bản sửa lỗi);
   - mở app 2–3 lần/tuần là tuyệt nhất.
6. **Góp ý** — thấy lỗi/khó hiểu/ý tưởng: nhắn `<FEEDBACK_CONTACT>`, hoặc trên Play Store vào trang app → *Gửi ý kiến
   riêng cho nhà phát triển*. Ảnh chụp màn hình càng tốt.

**Riêng tư:** app không cần tài khoản, không quảng cáo, không thu thập dữ liệu; mọi thứ bạn nhập chỉ nằm trên máy bạn.
Mình (người phát triển) chỉ thấy *số lượng* tester và Gmail bạn dùng để vào nhóm, không thấy dữ liệu trong app.

**Dùng iPhone?** Bản iOS sẽ thử qua TestFlight sau — báo mình nếu muốn nhận link.

---

## C. Tester guide — English

**You need:** an Android phone and the Gmail account signed in to the Play Store on that phone.

1. **Join the test group** — open `<GROUP_LINK>` in a browser, sign in with **the same Gmail as on your phone**, tap
   **"Join group"**.
   *Several Google accounts on the phone?* Use the same one for steps 1, 2 and 3.
2. **Opt in to the test** — open `<OPT_IN_LINK>` (ideally on the phone) and tap **"Become a tester"**. If it says
   "App not available", wait a few minutes after step 1 and reload.
3. **Install** — on the same page tap **"Download it on Google Play"** → **Install**. Store name:
   *Subnest: Subscription Tracker* (marked "Early access" / testing).
4. **Try it for a few minutes** — add 2–3 subscriptions you have, allow notifications when asked.
5. **Keep the app for at least 14 days** ⚠ — the most important part:
   - **don't uninstall**, **don't leave the group**, **don't tap "Leave the program"**;
   - let the Play Store update the app (there may be a few bug-fix versions);
   - opening it 2–3 times a week is ideal.
6. **Feedback** — bugs, confusing parts, ideas: message `<FEEDBACK_CONTACT>`, or on the app's Play Store page use
   *Send private feedback to the developer*. Screenshots help a lot.

**Privacy:** no account, no ads, no data collection; everything you enter stays on your phone. As the developer I
only see the *number* of testers and the Gmail you used to join the group — never your data in the app.

**On iPhone?** The iOS version will be tested via TestFlight later — tell me if you'd like the link.
