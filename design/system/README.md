Subnest tracks every subscription a person pays for, warns them before a charge or a trial ends, shows **price rises** and the **next 12 months**, and asks them to confirm each period. The money is the hero, every price carries its cycle, and the app chrome stays neutral so the services' own colours carry the screen.

**Version 2 — 10 Nov 2026**, redrawn end to end from product.md v2. Brand stays **Teal “Nest”** (`brand` `#0e6b63` light / `#46cdb9` dark), Be Vietnam Pro, Lucide, 4/8 grid — the v13 tokens hold up, so nothing in `tokens.json` changed; v2 adds components and usage rules. Light and dark are both first-class.

## What's on this page

- **Components** (top) — Service logo plate, cycle chip + change chip + tags, Cost card, Paid / Still to pay bar + month picker + 12-month bars, Subscription row, Trial card (3 buttons) + price notice, Upcoming strip, Price rises + Next 12 months, Price history row, controls, banners + snackbar, sheet + dialog, empty state + tab bar. Each in light and dark.
- **Screens by section of the spec** — 4.0–4.1 Launch & onboarding · 4.2 Overview · 4.3–4.4 Library & form · 4.5–4.7 Detail & confirm · 4.8 Calendar · 4.9 Insights · 4.10 Settings · 4.11 Scan (Pro) · 4.12–4.13 Widgets & notifications. 390 × 844, light and dark side by side, one card per state. Every card's notes start with **NEW**, **CHANGED** or **KEPT** compared with v13.
- **Tiếng Việt (VI)** — Overview, Insights, Form and Confirm sheet in Vietnamese with the VND sample set.
- **360 × 800 check** — Overview, Insights and Form at 360, in Vietnamese (the worst case).
- **320 dp × 200% text** — Overview, list, Form and Insights at the spec's hardest accessibility check.
- **Prototype** — all 11 flows of §5, clickable, with light/dark and English/Tiếng Việt switches.
- **Brand** — app icon and splash (unchanged).
- Every mock is drawn by `components/bundle.js` from the §6 sample data with the §3 rules implemented in code (month spend, month cash flow, price history, forecast), so numbers agree everywhere: November ≈ $144.89 (10 active, ≈ $4.83 a day), Paid $41.99, Still to pay $74.58, 7 charges ≈ $116.57 in the next 30 days, price rises +$3.50/month, savings $191.87/year.

## What's new in v2

- **Cost card** replaces the big header: Monthly | Yearly, change chip, ≈ total with (i), per-day line, Paid / Still to pay, month range and 6 columns that open Insights on that month.
- **Insights by selected month or year** — every card follows `‹ November 2026 ›`; future months are tagged Projected.
- **Price history + price rises** — timeline on Detail; Insights card “+$3.50 more a month than a year ago”; ↑ on rows that rose in the last 90 days; the edit-price dialog writes to history.
- **Next 12 months** — projected vs last 12 months with a breakdown that always adds up (new, price rises, cancelled or paused, other). The spec's example figures were replaced by figures computed from the §6 data so every screen agrees.
- **Cycle chip next to every price.**
- **Trial card with 3 buttons** (Keep it · View · How to cancel) and the yearly saving.
- **Upcoming payments strip** (merges “Due this week”).
- **Service logos** on a plate; custom monogram or the user's own photo (choose, crop square).
- Gathered in from after v13: language step, automatic backup (`.subnest`, password, 21:00, keep 2), restore = replace all, erase all data (2 steps), PIN lock + hide content, widgets small/medium/large incl. PIN-locked, scan states.

## Service logos

- Library services show their **real logo, bundled with the app** (no network), centred at 64% of a squircle plate (radius 28%) tinted from the brand colour. The plate makes black, white and transparent logos readable in both themes and keeps 10+ logos even.
- **These mockups use a stand-in mark (initials in the brand colour) where the bundled logo goes** — Claude doesn't reproduce real trademarks. Build with the logo files from the catalog; keep the plate exactly as specified.
- Custom services: monogram (1–2 letters or an emoji) in white on a palette colour, or the user's photo filling the same squircle. Sizes 24 · 32 · 40 · 56 · 80. Badges bottom-right: hourglass (trial), clock (waiting), pause.
- About carries the line “Service names and logos belong to their respective owners.”

## Content fundamentals

- English first (new phones open in English + USD); Vietnamese checked with the VND set (strings ~30% longer). Names may ellipsize; amounts, cycle chips and status never do.
- Every price has its cycle: chip text Weekly · Monthly · Quarterly · Yearly · Every N days/weeks/months (VI Hằng tuần · Hằng tháng · Hằng quý · Hằng năm · Mỗi N …).
- Converted amounts start with `≈`; each line is rounded and totals add the rounded lines.
- Increases are `warning-ink` with ↑ and +, decreases `success` with ↓ and − — never colour alone.
- Voice: plain, calm, second person; no urgency, no guilt. Money: `$17.99`, `₫260,000` (EN), `260.000 ₫` (VI). Dates: “6 days left · 15 Nov”, then dates; weeks start Monday.
- Pro is explained without a price (“Early access — we'll tell you the price before Pro starts charging”).

## Colour

- Page `bg`; cards and list groups `surface`; inputs, segmented tracks and resting chips `surface-2`; sheets and dialogs `surface-sheet`.
- Text: `ink` for primary text and amounts, `ink-muted` for meta — both 4.5:1 on `bg`, `surface`, `surface-2` and `surface-sheet` in both themes.
- `brand` for the one primary action per view (FAB, main button), the selected chip, an on toggle, links and today in calendars. Text on it is `on-brand`. Selected tabs and segments use `brand-soft` with `on-brand-soft`.
- **To confirm** is amber, never red: `warning-soft` fill, `warning-ink` text and icon, `warning` for the 12px dot on the tile and the calendar clock. Always colour + clock icon + words, everywhere the subscription appears.
- Paid and savings: `success` on `success-soft`. `danger` appears only for delete and validation errors.
- Charts: categories take `chart-1`…`chart-6` in a fixed order (AI, Storage, Telecom, Software, Video, Music; the rest fold into `chart-other`) — colour follows the category, never its rank. Light slots 3–5 are under 3:1 on white, so a chart always shows its full legend with labels and values. **Paid vs Still to pay** and actual vs projected are always `brand` solid vs a 135° `brand` hatch — readable in greyscale and for colour-blind users. Category colours in v2: AI `chart-1`, Storage `chart-2`, Health `chart-3`, Software `chart-4`, Video `chart-5`, Music `tile-violet`, Telecom `tile-sky`, the rest `chart-other`.
- Logo plates are tinted from the service's brand colour (13% over `surface` in light, 26% in dark, 1px ring at 22%). Custom monograms use the `tile-*` palette with white letters.
- Focus: 2px solid `focus` (alias of `brand`) outline, 2px offset.

## Type

- One family: **Be Vietnam Pro** (Google Fonts, full Vietnamese diacritics), 400–700. Flutter: `google_fonts` or bundled TTFs.
- Money always uses tabular figures (`font-variant-numeric: tabular-nums`; Flutter `FontFeature.tabularFigures()`).
- `display` for the total-spend hero; `amount-lg` for editable amounts; `headline` for tab-level titles; `title` for sheets and sections; `title-sm` for row names and amounts; `body`; `label` for buttons, chips, segments; `meta` for second lines; `caption` uppercase for eyebrows and badges.
- Layouts hold at 130–200% system text (see the 320 dp × 200% cards): text grows, tiles/icons/tab bar don't, and `display`, `amount-lg` and `headline` grow less (to 44/38/32px) so the big numbers stay on one line. Rows get taller; a row's second line and a settings value may wrap to two lines; names ellipsize; amounts and badges never truncate. In code, scale only text styles by the system factor — never the layout grid.

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

150–250 ms, ease-out, each with a reason: the cost number counts up when switching Monthly ↔ Yearly or the selected month (200 ms); sheets slide up (240 ms) over a fading `scrim`; dialogs scale in (200 ms); Paid pops a `success` check (220 ms) with a light haptic; a new row flashes `brand-soft` once; cancelling earns a 1.4 s confetti fall. Nothing loops (prototype tap targets aside). Reduce-motion cuts to the end state.

## Iconography

- **Lucide** (ISC), 24px grid, 2px stroke, round caps; Flutter `lucide_icons_flutter`. Sizes 13–16 inline and in badges, 20 rows and buttons, 22 tab bar, 24–26 top bar and FAB. The SVGs used are in the Icons asset group (single ink, `currentColor` — inline them; inside `<img>` they render black).
- Meanings are fixed: `clock` to confirm · `hourglass` trial · `users` shared · `ban` cancelled / didn't pay · `circle-check` paid · `piggy-bank` savings · `wifi-off` offline rates · `bell-off` reminders off · `lock` privacy · `external-link` leaves the app.
- Service logos: see **Service logos** above. Icons never stand in for a service.

## App icon and splash

The mark is a mint nest holding three tiles on the teal field — fixed colours, not theme tokens (see AppIcon). Splash: light theme fills `brand` with the icon and the word Subnest in white; dark theme keeps `bg` so launch never flashes.

## Flutter mapping

`brand`→`primary`, `on-brand`→`onPrimary`, `brand-soft`→`primaryContainer`, `on-brand-soft`→`onPrimaryContainer`, `surface`→`surface`, `surface-2`→`surfaceContainerHighest`, `ink`→`onSurface`, `ink-muted`→`onSurfaceVariant`, `line`→`outlineVariant`, `line-strong`→`outline`, `danger`→`error`. `warning*`, `success*`, `chart-*`, `tile-*`, `surface-sheet` and `scrim` live in a `ThemeExtension`. Type styles map 1:1 to a `TextTheme` on Be Vietnam Pro.
