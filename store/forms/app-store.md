# App Store Connect — câu trả lời soạn sẵn

> Câu trả lời giữ nguyên tiếng Anh như giao diện App Store Connect; "Vì sao" bằng tiếng Việt.
> Cùng điều kiện như `google-play.md`: không SDK analytics/crash/quảng cáo, mạng chỉ để lấy tỷ giá.
> Kiểm lại câu chữ form khi điền — Apple đổi bảng câu hỏi định kỳ (age rating đổi năm 2025).

## 1. App Privacy (nhãn "Privacy Nutrition Label")
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Privacy Policy URL | `<PRIVACY_POLICY_URL>` | Bắt buộc. Có thể đặt URL bản VI cho localization Vietnamese. |
| Privacy Choices URL | (để trống) | Không có gì để người dùng chọn. |
| Do you or your third-party partners collect data from this app? | **No, we do not collect data from this app** | Dữ liệu chỉ ở trên máy; định nghĩa "collect" của Apple = truyền khỏi thiết bị và lưu lâu hơn thời gian cần để phục vụ yêu cầu. Request tỷ giá không chứa dữ liệu người dùng. |
| **Kết quả trên store** | **Data Not Collected** | |

## 2. Privacy manifest (`ios/Runner/PrivacyInfo.xcprivacy`) — ghi chú cho phiên E / A
Không phải form trên web nhưng Apple đối chiếu với nhãn ở trên khi review:
| Khoá | Giá trị |
|---|---|
| `NSPrivacyTracking` | `false` |
| `NSPrivacyTrackingDomains` | (rỗng) |
| `NSPrivacyCollectedDataTypes` | (rỗng) |
| `NSPrivacyAccessedAPITypes` | Khai theo package thật dùng. Thường gặp với Flutter: **UserDefaults** `CA92.1` (nếu dùng `shared_preferences` hoặc plugin dùng UserDefaults) · **File timestamp** `C617.1` (đọc metadata file trong container app — drift/path_provider) · **Disk space** `E174.1` chỉ nếu có kiểm dung lượng trước khi ghi. Các plugin đã có manifest riêng thì Xcode gộp; chỉ khai thêm cho code của app. |
Kiểm: sau khi build archive, Xcode → *Generate Privacy Report* phải không có mục "collected data".

## 3. Export compliance (Encryption)
| Câu hỏi | Trả lời | Vì sao |
|---|---|---|
| Info.plist | Thêm `ITSAppUsesNonExemptEncryption` = **NO** (`<false/>`) | Để App Store Connect không hỏi lại mỗi build. |
| Does your app use encryption? (nếu được hỏi) | **Yes** → *"Only uses or accesses standard encryption…"* / chọn lựa chọn **miễn trừ (exempt)** | App chỉ dùng HTTPS (TLS chuẩn) để tải tỷ giá; không có thuật toán mã hoá riêng, không mã hoá dữ liệu người dùng. Dùng mã hoá chỉ để bảo vệ kết nối HTTPS thuộc diện miễn trừ của US EAR (Category 5 Part 2) → không cần tài liệu, không cần nộp báo cáo năm. |
| Is your app going to be available in France? | Có — không cần nộp tờ khai Pháp với trường hợp chỉ dùng HTTPS chuẩn | |
| ⚠ Ghi chú kỹ thuật | Package `http` của Dart trên iOS dùng TLS của Dart (BoringSSL đóng gói trong Flutter), không phải TLS của iOS. Vẫn là "thuật toán chuẩn, chỉ cho HTTPS" → vẫn miễn trừ. Nếu App Store Connect hỏi kiểu *"standard encryption algorithms instead of, or in addition to, Apple's OS"* thì chọn mục đó và trả lời **Yes, qualifies for exemption**. Muốn tránh hẳn: dùng `cupertino_http` (NSURLSession) trên iOS. | Không phải tư vấn pháp lý — tự kiểm lại khi nộp. |

## 4. Age rating (bảng câu hỏi mới 2025: 4+ / 9+ / 13+ / 16+ / 18+)
| Nhóm câu hỏi | Trả lời |
|---|---|
| In-app controls: Parental controls / Age assurance | No / No |
| Capabilities: Unrestricted web access | **No** (chỉ mở link cố định ra trình duyệt ngoài) |
| Capabilities: User-generated content | No |
| Capabilities: Messaging and chat | No |
| Capabilities: Advertising | No |
| Mature themes (profanity/crude humour, horror/fear, alcohol/tobacco/drugs, mature/suggestive themes) | None |
| Medical or wellness topics | None |
| Sexuality or nudity | None |
| Violence (cartoon, realistic, prolonged/graphic, guns) | None |
| Chance-based activities: simulated gambling / contests / loot boxes | None / No |
| Gambling (real money) | No |
| Made for Kids | **No** |
| **Kết quả dự kiến** | **4+** |

## 5. App Information / Pricing
| Mục | Trả lời |
|---|---|
| Primary category | **Finance** · Secondary: **Productivity** |
| Content rights: contains, shows or accesses third-party content? | **No** — app chỉ hiện *tên* dịch vụ (văn bản) với tile chữ cái do app tự vẽ, không logo/nội dung của bên thứ ba. (Nếu sau này dùng logo thật → đổi thành Yes và phải có quyền.) |
| Price | Free (Tier 0), mọi quốc gia |
| Support URL (bắt buộc) | `<SUPPORT_URL>` — có thể là trang index đã host cùng privacy policy, có ghi email `phamphuongphuongnd@gmail.com` |
| Marketing URL | (tuỳ chọn) `<WEBSITE_URL>` |
| Copyright | `2026 Phiotron` |
| License agreement | Apple Standard EULA (terms.*.md đã nhắc) |
| Localizations | English (U.S.) — bản chính · Vietnamese — từ `store/listing/vi.md` |

## 6. App Review Information
| Mục | Trả lời |
|---|---|
| Sign-in required | **No** (bỏ trống tài khoản demo) |
| Contact | Tên, SĐT, email người phát hành (điền lúc nộp — không ghi vào repo) |
| Notes (dán nguyên văn) | xem khối dưới |

```text
Subnest is a fully offline subscription tracker. There is no account or sign-in.
All data is stored on the device only; the app makes a single network request type to download public currency exchange rates (no user data is sent).
Reminders are local notifications. To see one quickly: add any subscription, set the next renewal date to today or tomorrow and "Remind me: on the day".
Service names in the catalog are shown as plain text with generated letter tiles; no third-party logos are used.
The app is free with no in-app purchases or ads.
```
