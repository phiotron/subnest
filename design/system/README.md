Subnest tracks every subscription a person pays for, warns them before a charge or a trial ends, and asks them to confirm each period. The UI is calm and exact: the monthly total is the hero, each service's own colour is the accent, and the app chrome stays neutral so those colours can carry the screen.

Brand direction: **Teal “Nest”** — `brand` `#0e6b63` light / `#46cdb9` dark. Two themes, `light` and `dark`, both first-class.

## What's on this page

- **Components** — ServiceTile, SubscriptionRow, SummaryCard, Button, ChipBadge, SegmentedControl, ToggleStepper, Banner, EmptyState, BottomSheet, Dialog, DatePicker, TabBar. Each card shows light and dark.
- **Screens S0–S12** at 390 × 844, light and dark side by side, one card per state: data, empty, many awaiting, offline, reminders off, trial, cancelled, validation, dialogs and sheets. S2, S4 and S6 also have a Vietnamese card for overflow. Lists scroll inside the phone.
- **Tiếng Việt (VI)** — every screen state again in Vietnamese, light and dark, to catch overflow.
- **360 × 800 check** — 16 key views on the smallest Android frame, in Vietnamese (the worst case), light and dark.
- **Large text 130%** — 8 key views at system text size 130% (iOS Dynamic Type / Android font scale), in Vietnamese, light and dark.
- **Prototype** — the six flows of product spec §6, clickable. Tap the dashed control on the phone or jump with the step list; switch light/dark and English/Tiếng Việt beside it.
- **Brand** — app icon (1024 PNG + SVG in the Brand assets) and the splash.
- Every mock is rendered by `components/bundle.js` from one copy of the §8 sample data, so numbers agree across screens: active total ≈ ₫1,074,467/month, savings ₫1,479,000/year, two periods awaiting (Viettel 5G 1 Nov, Netflix 4 Nov).

## Content fundamentals

- Two languages, designed in English, checked in Vietnamese (strings run ~30% longer). Names may ellipsize; amounts and status never do. Rules that came out of the VI and 360 checks:
  - Awaiting rows show only the badge (no date beside it).
  - Shared rows say “gói 260.000đ” / “plan ₫260,000”.
  - The four cycle quick-chips are single words in VI (Tuần · Tháng · Quý · Năm) so they stay on one row at 360.
  - Banners let their action drop under the text when the line is too narrow; meta pairs (like the hero's two facts) wrap as whole phrases.
  - The calendar's Month/List toggle moves under the month name when there's no room.
- Voice: plain, calm, second person. “Did you pay Netflix?” / “Bạn đã trả Netflix chưa?”. No urgency words, no exclamation marks, no guilt. Emoji only in a celebratory empty state (“You're all caught up 🎉”).
- Product terms: *Subscription*, *To confirm / Chờ xác nhận* (awaiting confirmation), *Payment*, *Next renewal / Gia hạn tiếp theo*, *Your share / Phần của bạn*, *plan ₫260,000 / gói 260.000đ*.
- Money by locale: `₫260,000` (EN) · `260.000đ` (VI) · `$20.00`. A converted amount is prefixed `≈ ` and set in `ink-muted` when secondary.
- Dates: relative up to 30 days (“in 3 days”, “còn 3 ngày”, “today”), then a date (“2 Feb 2027”, “2/2/2027”). Weeks start on Monday.

## Colour

- Page `bg`; cards and list groups `surface`; inputs, segmented tracks and resting chips `surface-2`; sheets and dialogs `surface-sheet`.
- Text: `ink` for primary text and amounts, `ink-muted` for meta — both 4.5:1 on `bg`, `surface`, `surface-2` and `surface-sheet` in both themes.
- `brand` for the one primary action per view (FAB, main button), the selected chip, an on toggle, links and today in calendars. Text on it is `on-brand`. Selected tabs and segments use `brand-soft` with `on-brand-soft`.
- **To confirm** is amber, never red: `warning-soft` fill, `warning-ink` text and icon, `warning` for the 12px dot on the tile and the calendar clock. Always colour + clock icon + words, everywhere the subscription appears.
- Paid and savings: `success` on `success-soft`. `danger` appears only for delete and validation errors.
- Charts: categories take `chart-1`…`chart-6` in a fixed order (AI, Storage, Telecom, Software, Video, Music; the rest fold into `chart-other`) — colour follows the category, never its rank. Light slots 3–5 are under 3:1 on white, so a chart always shows its full legend with labels and values. Paid vs expected in the bar chart is `brand` solid vs a `brand` hatch on `brand-soft`.
- Service tiles carry the library colour or a custom `tile-*`; the letter is `on-tile-light` or `on-tile-dark`, whichever reaches 4.5:1; `tile-ring` keeps dark tiles edged on dark surfaces.
- Focus: 2px solid `focus` (alias of `brand`) outline, 2px offset.

## Type

- One family: **Be Vietnam Pro** (Google Fonts, full Vietnamese diacritics), 400–700. Flutter: `google_fonts` or bundled TTFs.
- Money always uses tabular figures (`font-variant-numeric: tabular-nums`; Flutter `FontFeature.tabularFigures()`).
- `display` for the total-spend hero; `amount-lg` for editable amounts; `headline` for tab-level titles; `title` for sheets and sections; `title-sm` for row names and amounts; `body`; `label` for buttons, chips, segments; `meta` for second lines; `caption` uppercase for eyebrows and badges.
- Layouts hold at 130% system text (see the Large text cards): text grows, tiles/icons/tab bar don't, and `display`, `amount-lg` and `headline` grow less (to 44/38/32px) so the big numbers stay on one line. Rows get taller; a row's second line and a settings value may wrap to two lines; names ellipsize; amounts and badges never truncate. In code, scale only text styles by the system factor — never the layout grid.

## Space, shape, elevation

- 4/8 grid. Screen gutter `space-4`; card padding `space-4`; sections `space-6` apart; stacked cards `space-3`.
- Corners: cards `radius-lg`, inputs and buttons `radius-md`, segment thumbs `radius-sm`, sheets and dialogs `radius-xl`, chips/badges/pills `radius-full`. Tiles scale with size: `radius-tile-24/40/56/80` (32px tiles in widgets use 9px).
- Light: `shadow-card` (barely there), `shadow-float` for FAB, sheets, dialogs, toasts. Dark: no card shadow — `shadow-card` becomes a 1px `line` ring and sheets sit on the lighter `surface-sheet`.
- Frames: 390 × 844 is the design size; everything is fluid down to 360 × 800, where only the hero total steps down to 36px.
- Touch targets ≥ `tap-min` 44px. Row `row-h` 68; buttons `button-h` 52 (small 40); FAB `fab-size` 56; tab bar `tabbar-h` 64 + home-indicator inset.

## Gestures

- Swipe a subscription row left: **Confirm** (`brand`, only while a period is awaiting — opens the confirm sheet) and **Cancel** (`surface-2`, opens the mark-cancelled dialog). A full swipe triggers the leading action with a haptic tick at the threshold. Every swipe action also exists as a visible button on the detail screen.
- Sheets dismiss by dragging down or tapping the scrim, except when a choice is required (confirm-all, restore). iOS back-swipe works on every pushed screen.

## Motion

150–250 ms, ease-out, each with a reason: the total counts up when switching Month ↔ Year (240 ms); sheets slide up (240 ms) over a fading `scrim`; dialogs scale in (200 ms); Paid pops a `success` check (220 ms) with a light haptic; a new row flashes `brand-soft` once; cancelling earns a 1.4 s confetti fall. Nothing loops (prototype tap targets aside). Reduce-motion cuts to the end state.

## Iconography

- **Lucide** (ISC), 24px grid, 2px stroke, round caps; Flutter `lucide_icons_flutter`. Sizes 13–16 inline and in badges, 20 rows and buttons, 22 tab bar, 24–26 top bar and FAB. The SVGs used are in the Icons asset group (single ink, `currentColor` — inline them; inside `<img>` they render black).
- Meanings are fixed: `clock` to confirm · `hourglass` trial · `users` shared · `ban` cancelled / didn't pay · `circle-check` paid · `piggy-bank` savings · `wifi-off` offline rates · `bell-off` reminders off · `lock` privacy · `external-link` leaves the app.
- No real service logos in v1: services are always monogram tiles.

## App icon and splash

The mark is a mint nest holding three tiles on the teal field — fixed colours, not theme tokens (see AppIcon). Splash: light theme fills `brand` with the icon and the word Subnest in white; dark theme keeps `bg` so launch never flashes.

## Flutter mapping

`brand`→`primary`, `on-brand`→`onPrimary`, `brand-soft`→`primaryContainer`, `on-brand-soft`→`onPrimaryContainer`, `surface`→`surface`, `surface-2`→`surfaceContainerHighest`, `ink`→`onSurface`, `ink-muted`→`onSurfaceVariant`, `line`→`outlineVariant`, `line-strong`→`outline`, `danger`→`error`. `warning*`, `success*`, `chart-*`, `tile-*`, `surface-sheet` and `scrim` live in a `ThemeExtension`. Type styles map 1:1 to a `TextTheme` on Be Vietnam Pro.
