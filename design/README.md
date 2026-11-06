# design/ — Subnest Hi-Fi mockups (v1.0 extended)

| Path | What |
|---|---|
| `subnest-hifi.html` | **Open this.** Self-contained Hi-Fi viewer (fonts, tokens and renderer inlined, works offline). Tabs: Screens · Prototype · Components · Tokens. Toolbar: page light/dark, EN/VI, 390/360 frame, 100%/130% text. |
| `LINK.md`, `Subnest design system.url` | Link to the live design system on claude.ai (private until shared). |
| `png/` | 170 PNGs @2x (780 × 1688): all 85 screens/states of product.md §5 and §10, light and dark, English. File names are `NN-screen-state-mode.png`. |
| `system/tokens.json` | Design tokens (colour light/dark, type, spacing, radius, shadow, size) — source for Flutter `ThemeData` + `ThemeExtension`. |
| `system/tokens.css` | Same tokens as CSS custom properties. |
| `system/README.md` | Design-system rules: colour, type, space, motion, gestures, icons, VI and large-text rules, Flutter mapping, and the §10 additions. |
| `system/bundle.css`, `system/bundle.js` | Component styles and the renderer the mockups are drawn with (reference for exact paddings, sizes, states). |
| `system/icons/` | Lucide 0.460.0 SVGs used in the app (ISC licence). |
| `brand/` | App icon 1024 PNG + SVG, splash light/dark 1170 × 2532. |
| `_archive/` | The previous PNG set (before §10) and the zip used to copy the new one. Safe to delete. |

## What changed on 6 Nov 2026 (product.md §10)

- S2 Overview: progress bar per row, label chips, Auto badge, filter sheet + filtered list, “Due this week” strip, budget bar, Undo snackbar, tab bar hidden on scroll, Paused rows.
- S3 Library: General / Vietnam tabs, US prices with ≈ VND, “Reference price” chip.
- S4 Form / S5 Detail: labels, payment-method sheet, several reminders, Worth it?, Pause / Resume sheets, Paused state, history source + Undo.
- S9 Insights: Forecast 30 days / 12 months, cost per day/week/month/year, Budgets per category.
- S10 Settings: Categories (list, edit, delete-and-move), Labels, Payment methods, Budget, Automation (Pro).
- S13 Screenshot scan: intro, reading, results. Prototype flow 7.
- S11 widgets v2: iOS large, Android small + medium.
- Logos: the app loads them from Logo.dev; mockups show the monogram fallback. Pro price is not shown (decided later).

Sample data: product.md §8, “today” = 4 Nov 2026. Font: Be Vietnam Pro (Google Fonts). Brand: teal `#0e6b63` / dark `#46cdb9`.
