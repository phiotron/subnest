# Google Play Console — câu trả lời soạn sẵn (App content / Policy)

> Dán theo thứ tự trong Play Console → **Policy and programs → App content**. Câu trả lời giữ nguyên tiếng Anh
> (Console hiển thị tiếng Anh), cột "Vì sao" bằng tiếng Việt để người điền hiểu và kiểm lại.
> **Điều kiện để các câu trả lời này đúng** (phải khớp hành vi thật của build — kiểm lại trước khi nộp):
> 1. Không có SDK analytics / crash / quảng cáo / Firebase nào trong `pubspec.yaml` (tính đến 2026-11-04: đúng).
> 2. Mạng chỉ dùng để tải 3 thứ công khai — tỷ giá (open.er-api.com), thư viện dịch vụ (JSON tĩnh trên GitHub Pages
>    `phamphuongphuongnd.github.io/catalog/subnest/v1/…`, tối đa 1 lần/ngày) và logo dịch vụ (`img.logo.dev`, theo tên miền
>    dịch vụ, key `pk_` công khai, lưu cache trên máy; ADR 0002) — request không kèm dữ liệu người dùng, ID thiết bị hay
>    ID do app tạo. Không có server của xưởng nào nhận request từ app.
> 3. Sao lưu/xuất chỉ qua share sheet/trình chọn file của hệ thống, do người dùng bấm.
> 4. Logo dịch vụ chỉ được yêu cầu theo **tên miền của dịch vụ** (không kèm tên/ghi chú/giá người dùng); không gọi `img.logo.dev`
>    kèm bất kỳ tham số nào khác ngoài tên miền, key công khai và kích thước/định dạng ảnh.
> Nếu sau này thêm bất kỳ SDK nào ở trên → phải làm lại Data safety + privacy policy.

## 1. Privacy policy
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Privacy policy URL | `https://phamphuongphuongnd.github.io/legal/subnest/privacy-policy.en.html` | Bắt buộc với mọi app. Trang phải công khai, không cần đăng nhập, không phải PDF. Xem `store/README.md` để chọn nơi host. |

## 2. App access
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Is all functionality available without special access? | **All functionality is available without special access** | Không có đăng nhập, không mã mời. |

## 3. Ads
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Does your app contain ads? | **No, my app does not contain ads** | Không SDK quảng cáo, không quảng cáo tự làm. |

## 4. Content rating (IARC questionnaire)
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Email address (IARC liên hệ) | `phamphuongphuongnd@gmail.com` | IARC gửi chứng nhận về email này. |
| Category | **All Other App Types** (utility, productivity, communication, other) | Không phải game, không phải mạng xã hội / tham chiếu. |
| Violence (any) | No | |
| Fear / horror | No | |
| Sexuality / nudity | No | |
| Language (profanity, crude humour) | No | |
| Controlled substances (drugs, alcohol, tobacco) | No | Thư viện dịch vụ không có dịch vụ rượu/thuốc lá — phiên B kiểm. |
| Gambling / simulated gambling | No | |
| Does the app allow users to interact or exchange content with other users (chat, sharing)? | **No** | Xuất file qua share sheet là người dùng tự gửi file của mình, không phải tương tác người dùng–người dùng trong app. |
| Does the app share the user's current physical location with other users? | No | Không dùng vị trí. |
| Does the app allow users to purchase digital goods? | **No** | Không IAP. |
| Does the app contain any swastikas or other hateful symbols? | No | |
| Does the app provide unrestricted access to the internet (e.g. a browser)? | **No** | Chỉ mở vài link cố định (trang "cách huỷ" của dịch vụ, privacy policy) bằng trình duyệt ngoài; app không có trình duyệt/ô nhập URL. |
| Is the app a web browser or search engine? | No | |
| **Kết quả dự kiến** | Everyone / PEGI 3 / USK 0 / ClassInd L / ESRB Everyone / GRAC All | Nếu ra khác → đọc lại câu hỏi bị đánh "Yes". |

## 5. Target audience and content
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Target age groups | **18 and over** (chỉ chọn nhóm này) | Đối tượng 18–40, nội dung về chi tiêu. Chọn bất kỳ nhóm dưới 13 sẽ kéo app vào chính sách **Families** (yêu cầu thêm, không cần). Có thể cân nhắc thêm 16–17 sau, không đổi gì về chính sách. |
| Could your store listing unintentionally appeal to children? | **No** | Không nhân vật hoạt hình, không ngôn ngữ trẻ em. Icon "tổ" phải giữ phong cách tối giản (xem `icon-brief.md`). |

## 6. Data safety
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Does your app collect or share any of the required user data types? | **No** | Không dữ liệu người dùng nào được truyền khỏi máy tới nhà phát triển hay bên thứ ba. Toàn bộ dữ liệu lưu cục bộ (theo Google, xử lý trên máy không tính là "collect"). Ba loại request mạng (tỷ giá, thư viện dịch vụ, logo) là **tải dữ liệu công khai về máy**; chúng chỉ mang tên miền dịch vụ/đường dẫn file công khai, không mang dữ liệu người dùng, tài khoản hay ID → không thuộc loại dữ liệu nào trong danh sách của Data safety (Personal info, Financial info, App activity, Device or other IDs…). Địa chỉ IP bên nhận thấy là phần tất yếu của mọi kết nối, không phải dữ liệu app thu. |
| (chỉ hiện nếu trả lời Yes ở trên) Encrypted in transit / deletion request | — bỏ qua — | |
| Account creation | App không tạo tài khoản → không cần URL xoá tài khoản | Checklist Android: mục "có tài khoản → cách xoá" = không áp dụng. |
| Independent security review (MASA) | Không (tuỳ chọn) | |
| **Kết quả hiển thị trên store** | "No data collected" · "No data shared with third parties" | |

Các điểm dễ hỏi khi review Data safety:
- **Gọi API tỷ giá:** request chỉ là `GET` tỷ giá, không chứa dữ liệu người dùng. Địa chỉ IP tất yếu đi kèm mọi kết nối
  Internet không phải dữ liệu app "collect" → vẫn "No". Nếu đổi sang API **cần API key gắn theo người dùng** hoặc gửi
  kèm ID thiết bị/tiền tệ của người dùng lên server của mình → phải xem lại.
- **Tải thư viện dịch vụ (GitHub Pages):** `GET` một file JSON tĩnh công khai, không tham số, không cookie/ID. GitHub
  là host, không phải "bên nhận dữ liệu người dùng" → vẫn "No".
- **Tải logo (logo.dev):** `GET img.logo.dev/<tên-miền-dịch-vụ>?token=pk_…`. `pk_` là **khoá công khai của xưởng, cùng
  một giá trị cho mọi người dùng** (không phải ID người dùng/thiết bị) → không định danh được ai. Điểm cần nói rõ nếu
  Google hỏi: Logo.dev thấy IP + tên miền dịch vụ nào được yêu cầu từ IP đó; tên miền là của dịch vụ trong thư viện
  chung, không phải nội dung người dùng gõ. Lập luận này hợp lý nhưng **không chắc 100%** — trước hết giữ "No data collected"; nếu Google
  phản hồi buộc khai, quay lại mục này (dự phòng: khai App activity "Other actions" là *shared* với Logo.dev, mục đích
  *App functionality*, không bắt buộc, không dùng cho quảng cáo) và sửa privacy policy cho khớp.
  Giảm rủi ro: chỉ yêu cầu logo cho dịch vụ **có trong thư viện** (không đoán tên miền từ tên người dùng tự gõ), và
  tuyệt đối không thêm tham số nào chứa dữ liệu người dùng vào URL logo.
- **Quyền mạng:** chỉ `INTERNET` (và `ACCESS_NETWORK_STATE` nếu có) — không thêm quyền nào cho logo/thư viện; phần
  Permissions trong privacy policy đã cập nhật (§ Permissions: "tỷ giá, thư viện dịch vụ và logo").
- **Xuất JSON/CSV qua share sheet:** người dùng chủ động gửi file của mình đi đâu thì đó là hành động của người dùng,
  không phải app "share" → không khai.
- **Sao lưu tự động của Android (Auto Backup):** do Google/hệ điều hành làm, nằm ngoài phạm vi Data safety. Ghi chú cho
  phiên E: cân nhắc giữ hoặc tắt `android:allowBackup` — privacy policy đã viết đúng cho cả hai trường hợp.

## 7. Advertising ID
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Does your app use advertising ID? | **No** | Không SDK quảng cáo/analytics. Kiểm build release: manifest gộp không có quyền `com.google.android.gms.permission.AD_ID` (nếu một package kéo vào → thêm `tools:node="remove"`). |

## 8. Các khai báo khác
| Mục | Trả lời | Vì sao |
|---|---|---|
| Government apps | No | |
| Financial features | **"My app doesn't provide any financial features"** — nếu form có lựa chọn kiểu *personal finance / budgeting / expense tracking* thì chọn đúng mục đó (không cần giấy phép) | App không chuyển tiền, không cho vay, không kết nối ngân hàng; chỉ ghi chép. ⚠ Danh sách lựa chọn của form này đổi theo thời gian — đọc kỹ khi điền. |
| Health apps | My app does not have any health features | |
| News apps | No | |
| COVID-19 contact tracing & status | Not applicable | |
| Data deletion (account) | Không áp dụng (không có tài khoản) | |
| **Exact alarm** (`SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`) | Chỉ khai nếu build có xin quyền này | Phiên A/E quyết. `USE_EXACT_ALARM` chỉ dành cho app báo thức/lịch → **không dùng**. Nếu dùng `SCHEDULE_EXACT_ALARM` (Android 14+ mặc định bị từ chối) thì app phải chạy được khi không có quyền (rơi về inexact alarm); Console có thể hỏi lý do: *"Reminders the user schedules for subscription renewal dates and free-trial end dates."* |
| Foreground service / background location / SMS / call log / all-files access | Không xin → không khai | |

## 9. Store settings
| Mục | Trả lời |
|---|---|
| App category | **Finance** (phương án thay thế: Productivity — Finance cạnh tranh hơn nhưng đúng ý định tìm kiếm "subscription tracker") |
| Tags | Budget, Bill reminder, Personal finance, Expense tracker (chọn tối đa 5 trong danh sách Google gợi ý) |
| Contact email | `phamphuongphuongnd@gmail.com` (bắt buộc, hiển thị công khai) |
| Website | `https://phamphuongphuongnd.github.io/legal/subnest/` |
| Price | Free (⚠ app Free không bao giờ chuyển sang Paid được; IAP sau này vẫn thêm được) |
| Countries | All countries/regions |
