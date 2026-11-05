# design/ — Subnest Hi-Fi mockups (v1.0)

| Path | What |
|---|---|
| `subnest-hifi.html` | **Open this.** Self-contained Hi-Fi viewer (fonts, tokens and renderer inlined, works offline). Tabs: Screens · Prototype · Components · Tokens. Toolbar: page light/dark, EN/VI, 390/360 frame, 100%/130% text. |
| `LINK.md`, `Subnest design system.url` | Link to the live design system on claude.ai (private until shared). |
| `png/` | 116 PNGs @2x (780 × 1688): all 58 screens/states of product.md §5, light and dark, English. File names are `NN-screen-state-mode.png`. |
| `system/tokens.json` | Design tokens (colour light/dark, type, spacing, radius, shadow, size) — source for Flutter `ThemeData` + `ThemeExtension`. |
| `system/tokens.css` | Same tokens as CSS custom properties. |
| `system/README.md` | Design-system rules: colour, type, space, motion, gestures, icons, VI and large-text rules, Flutter mapping. |
| `system/bundle.css`, `system/bundle.js` | Component styles and the renderer the mockups are drawn with (reference for exact paddings, sizes, states). |
| `system/icons/` | Lucide 0.460.0 SVGs used in the app (ISC licence). |
| `brand/` | App icon 1024 PNG + SVG, splash light/dark 1170 × 2532. |

Sample data: product.md §8, “today” = 4 Nov 2026. Font: Be Vietnam Pro (Google Fonts). Brand: teal `#0e6b63` / dark `#46cdb9`.
