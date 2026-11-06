# design/ — Subnest Hi-Fi mockups (v1.0 extended)

| Path | What |
|---|---|
| `subnest-hifi.html` | **Open this.** Self-contained Hi-Fi viewer (fonts, tokens and renderer inlined, works offline). Tabs: Screens · Prototype · Components · Tokens. Toolbar: page light/dark, EN/VI, 390/360 frame, 100%/130% text. |
| `LINK.md`, `Subnest design system.url` | Link to the live design system on claude.ai (private until shared). |
| `png/` | 198 PNGs @2x (780 × 1688): all 99 screens/states of product.md §5, §10 and the CONTEXT.md / ADR 0003 additions, light and dark, English. File names are `NN-screen-state-mode.png`. |
| `system/tokens.json` | Design tokens (colour light/dark, type, spacing, radius, shadow, size) — source for Flutter `ThemeData` + `ThemeExtension`. |
| `system/tokens.css` | Same tokens as CSS custom properties. |
| `system/README.md` | Design-system rules: colour, type, space, motion, gestures, icons, VI and large-text rules, Flutter mapping, and the §10 additions. |
| `system/bundle.css`, `system/bundle.js` | Component styles and the renderer the mockups are drawn with (reference for exact paddings, sizes, states). |
| `system/icons/` | Lucide 0.460.0 SVGs used in the app (ISC licence). |
| `brand/` | App icon 1024 PNG + SVG, splash light/dark 1170 × 2532. |
| `_archive/` | Earlier PNG sets and the zips used to copy new ones. Safe to delete. |

## What changed on 6 Nov 2026 (product.md §10)

- S2 Overview: progress bar per row, label chips, Auto badge, filter sheet + filtered list, “Due this week” strip, budget bar, Undo snackbar, tab bar hidden on scroll, Paused rows.
- S3 Library: General / Vietnam tabs, US prices with ≈ VND, “Reference price” chip.
- S4 Form / S5 Detail: labels, payment-method sheet, several reminders, Worth it?, Pause / Resume sheets, Paused state, history source + Undo.
- S9 Insights: Forecast 30 days / 12 months, cost per day/week/month/year, Budgets per category.
- S10 Settings: Categories (list, edit, delete-and-move), Labels, Payment methods, Budget, Automation (Pro).
- S13 Screenshot scan: intro, reading, results. Prototype flow 7.
- S11 widgets v2: iOS large, Android small + medium.
- Logos: the app loads them from Logo.dev; mockups show the monogram fallback. Pro price is not shown (decided later).

## Added later on 6 Nov 2026 (gaps from CONTEXT.md, ADR 0003, §10.7)

- Price change notice: Overview card, detail banner + Service library row, “Update the price?” sheet. Prototype flow 8.
- Discontinued plan note; auto-detected subscription detail with Remove (remembered, not re-added).
- S10 About: library freshness, price lists (US + Vietnam), privacy, terms, licences, rate, feedback, Logo.dev credit and trademark line.
- S10 Edit label sheet; Pro early-access sheet (no price yet).
- S13: before the photo picker, receipt camera, results with “needs your check” / amount differs / not added, nothing found.
- S11: Android large widget; small widget for an awaiting period and for no data.

Sample data: product.md §8, “today” = 4 Nov 2026. Font: Be Vietnam Pro (Google Fonts). Brand: teal `#0e6b63` / dark `#46cdb9`.
