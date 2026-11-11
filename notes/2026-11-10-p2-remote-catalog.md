# [A001-subnest] P2 Catalog từ xa — 2026-11-10 (phiên con, điều phối #7)

Tầng DATA cho *Catalog source* (bản đóng gói + bản từ xa), *Service logo* cho dịch vụ chỉ có ở bản từ xa,
*Price change notice*, *Discontinued plan*, thời điểm cập nhật thư viện. Theo ADR 0002 + CONTEXT.md. **Chưa có UI**
(màn 21, 55–57 làm sau mockup v14) và **chưa gắn vào `app.dart`** (ngoài phạm vi — xem "Việc dở" 1).

## File
- `lib/data/catalog/` (mới, của P2)
  - `catalog_data.dart` — `CatalogData` {services, origin `bundled|remote`, schemaVersion, `version`, `updatedOn`, `downloadedAt`}, `CatalogFormatException`.
  - `catalog_validator.dart` — `CatalogValidator.validate(text, {previous})`: schema ∈ {4}; version ≥ 1; `updatedAt`;
    ≥ 1 service; parse **strict** (một service hỏng ⇒ bỏ cả file); id slug + không trùng; ≥ 1 plan, plan id slug + không trùng;
    `cancelUrl`/`manageUrl` https hoặc null; giá > 0, tiền 3 chữ hoa; với `previous`: không được mất service/plan id nào.
  - `catalog_cache.dart` — `<app support>/catalog/`: `services.json` (bản tải cuối hợp lệ), `state.json`
    (`CatalogSyncState`: lastCheckAt, downloadedAt, version, sha256, logosVersion, logos), `notices.json`, `logos/<id>-<sha8>.png`.
    Ghi `.part` rồi rename; đọc lỗi ⇒ coi như không có.
  - `catalog_sync.dart` — `CatalogSync.refreshIfDue({force})` → `CatalogRefreshResult {updated, upToDate, notDue, offline, failed}`. Không bao giờ throw.
  - `remote_logos.dart` — `RemoteLogoStore` (ids/`pathOf`/`logoFor`, `load`, `attachTo(AppLogoSource)` ⇒ `AppLogoSource.remote`).
  - `price_notices.dart` — thuần: `PriceLedger`, `CatalogPlanMatcher`, `PriceChangeNotice` + `findPriceChangeNotices`, `CatalogPlanNote` + `findPlanNotes`.
  - `catalog_notice_store.dart` — lưu ledger + quyết định "Giữ giá cũ" (`notices.json`).
  - `catalog_providers.dart` — mọi provider cho UI (bên dưới).
- `lib/data/catalog_repository.dart` — `CatalogRepository({bundle, cache})`, `CatalogRepository.device()` (dùng cache trên máy),
  `loadData()` = bản **mới nhất hợp lệ** giữa đóng gói và cache (cache hỏng/cũ hơn ⇒ đóng gói), `loadBundled()`, `reset()`,
  `parseData(text, {strict})`. `load()`/`byId()`/`parse()` giữ nguyên API cũ.
- `lib/data/providers.dart` — **1 dòng**: `catalogRepositoryProvider` ⇒ `CatalogRepository.device()` (lọt vào commit `cf2fa31` của M
  vì M commit cả file; code tương ứng ở `40d055a` — giữa hai commit này `dev` không biên dịch).
- `test/data/catalog/` — `catalog_sync_test.dart`, `price_notices_test.dart`, `catalog_providers_test.dart`, `catalog_fixtures.dart`.

## Tải catalog từ xa (S-42)
`https://phamphuongphuongnd.github.io/catalog/subnest/v1/` — chỉ **GET** file tĩnh, không query, không header riêng, không dữ liệu người dùng.
1. Tối đa **1 lần/ngày theo lịch máy** (`lastCheckAt` khác ngày; đồng hồ lùi ⇒ cho kiểm). Offline/timeout 15 s ⇒ `offline`, không ghi gì ⇒ lần mở app sau thử lại.
   Server trả lời (kể cả 404/500/rác) ⇒ tính là đã kiểm hôm nay.
2. `meta.json` (≤ 64 KB): schemaVersion ∈ {4}, `version` int, `files["services.min.json"].sha256`. `version` ≤ bản đang dùng ⇒ `upToDate`.
3. `services.min.json` (≤ 8 MB): đúng `bytes`, đúng **sha256**, `CatalogValidator` với `previous` = bản đang dùng, `version` trong file = meta ⇒ ghi cache ⇒ `updated`.
   Không dùng URL trong meta (luôn ghép từ base cố định).
4. Lỗi bất kỳ ⇒ giữ bản cũ, không báo gì.

## Logo cho dịch vụ chỉ có ở bản từ xa — ĐỀ XUẤT cấu trúc repo `catalog` (chưa có)
- `subnest/v1/logos/index.json` = `{"files": {"<serviceId>": "<sha256 hex của PNG>"}}`
- `subnest/v1/logos/<serviceId>.png` (PNG vuông 256 px như `assets/logos/png`, ≤ 256 KB).
- Thêm/đổi logo ⇒ tăng `version` dữ liệu (app chỉ đọc lại index khi `version` đổi hoặc lần trước chưa xong).
- App: chỉ tải logo của service **có trong catalog đang dùng mà không bundled** (`AppLogoSource.bundled`), sha khác bản đã có;
  kiểm PNG + sha + ≤ 256 KB; ≤ 60 logo/lần; `index.json` 404 ⇒ coi như không có logo cho version này (không hỏi lại).
  Service về sau được đóng gói (bản app mới) ⇒ xoá file cache. Tên file có `sha8` ⇒ không dính cache ảnh cũ.
- `export_app_asset.py` cũng nên chép `logos/*.png` của repo vào `assets/logos/png` khi đóng gói bản mới (việc của L/catalog).

## Price change notice — cách nhận biết (không cần cột DB)
Subscription **chỉ lưu `serviceId`**, không lưu plan ⇒
- **PriceLedger**: mọi giá Catalog máy từng thấy theo `service/plan/REGION/CUR` (≤ 12 giá/khoá), ghi mỗi lần nạp catalog
  (đóng gói/tải về) và ngay trước khi bản mới thay bản cũ.
- **Plan của Subscription** (`CatalogPlanMatcher`): (1) theo tên như form lưu — "<service> <plan>", hoặc "<service>" khi 1 plan;
  tên cũ `renamedFrom` cũng khớp; (2) không thì theo giá: plan **duy nhất** cùng chu kỳ có giá hiện tại/đã từng = giá Subscription
  (cùng tiền tệ). Mơ hồ ⇒ không báo gì.
- **Có notice khi**: có `serviceId`; không cancelled; khớp plan **cùng chu kỳ**; plan có giá cùng tiền tệ với Subscription và
  **khác** giá Subscription; giá Subscription **có trong ledger** của plan đó (= giá Catalog cũ; giá người dùng tự gõ ⇒ không báo);
  chưa "Giữ giá cũ" cho **đúng giá mới này**.
- **Cập nhật** ⇒ `changePrice(id, newMinor, currency, source: PriceChangeSource.catalog)` — áp từ Due date kế tiếp (mặc định repo),
  Payment cũ giữ nguyên. Kiểm lại trước: Subscription đã đổi giá/xoá ⇒ không ghi, trả `false`.
- **Giữ giá cũ** ⇒ nhớ khoá `subId|service/plan/REGION/CUR|giáMới` ⇒ không hỏi lại giá đó; Catalog đổi sang giá khác ⇒ hỏi lại.
- Giới hạn: Subscription thêm trước khi tính năng này có, mà giá Catalog đã đổi trước lần đầu ledger ghi ⇒ không nhận ra (thà không báo).

## API cho UI (import `package:subnest/data/catalog/catalog_providers.dart`)
| Provider | Kiểu | Dùng cho |
|---|---|---|
| `catalogProvider` (providers.dart, như cũ) | `FutureProvider<List<CatalogService>>` | Thư viện — giờ là bản mới nhất hợp lệ |
| `catalogDataProvider` | `FutureProvider<CatalogData>` | origin, `version`, `updatedOn`, `downloadedAt` |
| `catalogUpdatedOnProvider` | `Provider<LocalDate?>` | **Màn 21 Giới thiệu**: "Thư viện cập nhật N ngày trước" = `updatedOn.daysUntil(today)` (ngày dữ liệu đổi, không phải ngày tải) |
| `catalogUpdaterProvider` | `CatalogUpdater` | `refreshIfDue({force})` — gọi lúc mở app/resume; `force: true` cho nút "Kiểm tra cập nhật" nếu mockup có |
| `priceChangeNoticesProvider` | `Provider<List<PriceChangeNotice>>` | **Màn 55** danh sách báo đổi giá (rỗng khi đang tải) |
| `subscriptionPriceNoticeProvider(id)` | `PriceChangeNotice?` | **Màn 56** banner trên chi tiết gói |
| `priceNoticeActionsProvider` | `PriceNoticeActions` | `update(n)` → `Future<bool>`, `updateAll(list)` → số gói đã cập nhật, `keepOldPrice(n)` |
| `catalogPlanNotesProvider` | `Map<subId, CatalogPlanNote>` | **Màn 57**/chi tiết: ghi chú gói ngừng bán |
| `subscriptionPlanNoteProvider(id)` | `CatalogPlanNote?` | `kind` = `closedToNew` · `discontinued` · `renamed` (`previousName` → `plan.name`) |
| `remoteLogoStoreProvider` | `RemoteLogoStore` | (không cần cho UI — tile đọc qua `AppLogoSource`) |

`PriceChangeNotice`: `subscription`, `service`, `plan`, `region`, `oldPriceMinor`, `newPriceMinor`, `currency`, `isIncrease`,
`isReference` (giá mới là *Giá tham khảo* ⇒ nên hiện chip), `newPrice` (`CatalogPrice`).

## Việc dở / cần điều phối
1. **Gắn vào `app.dart`** (ngoài phạm vi P2): trong `_housekeeping()` thêm
   `await ref.read(catalogUpdaterProvider).refreshIfDue();` (sau `exchangeRateRepositoryProvider.refreshIfStale()`).
   Lần gọi đầu cũng gắn logo từ xa vào `AppLogoSource.instance`. Chưa gắn ⇒ app vẫn chạy như cũ (bản đóng gói/cache).
2. **Repo `catalog`**: tạo `subnest/v1/logos/` + `index.json` theo đề xuất trên (khi có dịch vụ mới không đóng gói logo).
3. **Delete all data**: nên gọi `ref.read(catalogNoticeStoreProvider).clearDecisions()` (quyết định "Giữ giá cũ"); cache catalog
   không phải dữ liệu người dùng ⇒ giữ. Backup **không** chứa các quyết định này (khôi phục ⇒ có thể hỏi lại một lần) — chấp nhận
   được; muốn chính xác hơn thì cần khoá trong bảng `settings` (việc của M/B).
4. Tuỳ chọn (cần DB, chưa làm): cột `catalogPlanId` trên Subscription cho khớp plan chắc chắn thay vì đoán theo tên/giá.
5. Chính sách quyền riêng tư/Data safety: app gọi `phamphuongphuongnd.github.io` (đã nêu trong ADR 0002 — kiểm lại câu chữ P4).
