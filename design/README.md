# design/ — Subnest Hi-Fi mockups v2 (product.md v2, 10 Nov 2026)

| Path | What |
|---|---|
| `subnest-hifi.html` | **Open this.** Self-contained viewer (fonts, tokens, renderer inlined, works offline). Tabs: Screens · Prototype (11 flows) · Components · Tokens. Toolbar: page light/dark, EN/VI, 390/360 frame, 100%/130% text. |
| `LINK.md`, `Subnest design system.url` | The live design system on claude.ai (private until shared). |
| `png/` | 252 PNGs @2x: 126 screens/states, light and dark, English. Names `NNN-screen-state-mode.png`. |
| `system/` | tokens.json / tokens.css (unchanged from v13), README.md (design rules incl. v2 additions), bundle.css / bundle.js (the renderer — exact sizes, paddings, states), icons/ (Lucide). |
| `brand/` | App icon 1024 + SVG, splash light/dark (unchanged). |
| `_archive/` | v13 export and older PNG sets. Safe to delete. |

## Read this first

- **Service logos:** the app shows the real logos bundled with it, on a tinted plate. The mockups put a stand-in mark (initials in the brand colour) on that plate, because Claude doesn't reproduce real trademarks. Keep the plate spec in `system/README.md` → Service logos.
- **Numbers:** every screen is computed from product.md §6 with the §3 rules, so they agree everywhere (Nov ≈ $144.89, Paid $41.99, Still to pay $74.58, next 30 days ≈ $116.57 in 7 charges). The “next 12 months” card uses computed figures (≈ $1,618.83 vs ≈ $1,544.22, +$74.61) instead of the spec's example numbers so it stays consistent with the other screens.
- **Pro price** is never shown (early access only).

## Screens and what changed since v13

65 new · 58 changed · 3 kept. Also in the live design system (not as PNG): Vietnamese versions, the 360 × 800 check and the 320 dp × 200% text check.

| PNG | vs v13 | Screen |
|---|---|---|
| 001 | KEPT | Splash — icon on brand |
| 002 | NEW | PIN lock — 4 dots + number pad |
| 003 | NEW | PIN lock — wrong PIN |
| 004 | NEW | PIN lock — Forgot PIN? → erase |
| 005 | NEW | Onboarding 1/5 · Language — English preselected |
| 006 | CHANGED | Onboarding 2/5 · Welcome |
| 007 | NEW | Onboarding 3/5 · Main currency — USD / VND one tap |
| 008 | CHANGED | Onboarding 3/5 · Other currency list |
| 009 | CHANGED | Onboarding 4/5 · What do you pay for? — logos, quick edit |
| 010 | CHANGED | Onboarding 5/5 · Reminders — USD sample |
| 011 | CHANGED | Onboarding 5/5 · System prompt |
| 012 | NEW | Overview — cost card, to-confirm, trial card (3 buttons) |
| 013 | NEW | Overview — upcoming payments strip + budget |
| 014 | NEW | Overview — subscription list (Active) |
| 015 | NEW | Overview — Yearly cost mode |
| 016 | NEW | Overview — (i) how the numbers work |
| 017 | NEW | Overview — library price notice card |
| 018 | NEW | Overview — 2 periods waiting |
| 019 | CHANGED | Overview — offline + reminders off |
| 020 | NEW | Overview — first month (no comparison) |
| 021 | CHANGED | Overview — empty |
| 022 | CHANGED | Overview — filter sheet |
| 023 | NEW | Overview — sort sheet |
| 024 | CHANGED | Overview — filtered by label Work |
| 025 | CHANGED | Overview — swipe a row |
| 026 | CHANGED | Overview — Cancelled tab with savings |
| 027 | NEW | Overview — Paused tab |
| 028 | CHANGED | Overview — Undo snackbar after an automatic add |
| 029 | NEW | Overview — search |
| 030 | NEW | Library — General tab, logos, US prices |
| 031 | NEW | Library — Vietnam tab, VND |
| 032 | CHANGED | Library — search ‘netf’ |
| 033 | CHANGED | Library — no results → create |
| 034 | CHANGED | Library — choose a Netflix plan |
| 035 | CHANGED | Form — Netflix Premium, split with 4 |
| 036 | CHANGED | Form — category, labels, reminders, more details |
| 037 | NEW | Form — custom service Gym |
| 038 | NEW | Form — Change icon sheet |
| 039 | NEW | Form — crop the photo square |
| 040 | NEW | Form — photo set, Remove photo |
| 041 | CHANGED | Form — validation |
| 042 | CHANGED | Form — edit price |
| 043 | CHANGED | Form — apply new price from next payment? |
| 044 | CHANGED | Detail — Netflix Standard, cycle chip, info |
| 045 | NEW | Detail — price history + payment history |
| 046 | NEW | Detail — upcoming price change in history |
| 047 | CHANGED | Detail — trial |
| 048 | CHANGED | Detail — waiting for confirmation |
| 049 | CHANGED | Detail — shared plan ÷5 |
| 050 | CHANGED | Detail — pauses from 21 Nov |
| 051 | CHANGED | Detail — paused |
| 052 | CHANGED | Detail — cancelled, saving |
| 053 | NEW | Detail — custom service with photo |
| 054 | NEW | Detail — library price notice |
| 055 | NEW | Detail — Update the price? sheet |
| 056 | NEW | Detail — plan no longer sold |
| 057 | NEW | Detail — auto-detected, Remove |
| 058 | NEW | Detail — remove auto-detected |
| 059 | CHANGED | Detail — pause sheet |
| 060 | CHANGED | Detail — resume, pick next payment |
| 061 | CHANGED | Detail — mark as cancelled? |
| 062 | CHANGED | Detail — delete |
| 063 | CHANGED | Cancelled — celebrate the saving |
| 064 | KEPT | How to cancel — provider page |
| 065 | CHANGED | Confirm sheet — Claude Pro, 8 Nov |
| 066 | CHANGED | Confirm sheet — paid ✓ |
| 067 | CHANGED | Confirm sheet — 1 more period |
| 068 | CHANGED | To confirm — oldest first |
| 069 | CHANGED | To confirm — confirm all? |
| 070 | KEPT | To confirm — all caught up |
| 071 | NEW | Calendar — November, mini logos, day list |
| 072 | NEW | Calendar — list (agenda) |
| 073 | NEW | Calendar — October (past) |
| 074 | NEW | Insights — November: cost, 12 bars |
| 075 | NEW | Insights — by category + most expensive |
| 076 | NEW | Insights — price rises + next 12 months |
| 077 | NEW | Insights — coming up (13 weeks), budgets |
| 078 | NEW | Insights — savings, worth it, hint |
| 079 | NEW | Insights — August (past month) |
| 080 | NEW | Insights — December (projected) |
| 081 | NEW | Insights — Year 2026 |
| 082 | NEW | Insights — coming up by month |
| 083 | NEW | Insights — tap a slice: Video |
| 084 | NEW | Insights — next 12 months as a list |
| 085 | NEW | Insights — empty |
| 086 | NEW | Insights — only yearly plans |
| 087 | CHANGED | Settings — money, reminders, appearance, organize |
| 088 | NEW | Settings — automation, data (auto backup), security |
| 089 | NEW | Settings — about (inline) + privacy |
| 090 | NEW | Settings — PIN on |
| 091 | NEW | Settings — automatic backup off |
| 092 | NEW | Settings — language sheet |
| 093 | CHANGED | Settings — theme sheet |
| 094 | CHANGED | Exchange rates |
| 095 | CHANGED | Reminders — several offsets, time |
| 096 | CHANGED | Reminders — permission off |
| 097 | NEW | Automatic backup — set up |
| 098 | NEW | Back up now — .subnest file |
| 099 | NEW | Restore — check file |
| 100 | NEW | Restore — password |
| 101 | NEW | Restore — replace all data? |
| 102 | NEW | Erase all data — step 1 |
| 103 | NEW | Erase all data — step 2 |
| 104 | NEW | PIN — choose |
| 105 | NEW | PIN — repeat |
| 106 | CHANGED | Categories |
| 107 | CHANGED | Category — edit |
| 108 | CHANGED | Category — delete, move subscriptions |
| 109 | CHANGED | Labels |
| 110 | CHANGED | Payment methods |
| 111 | CHANGED | Budget — total and per category |
| 112 | CHANGED | Automation (Pro) |
| 113 | CHANGED | Pro — early access, no price |
| 114 | CHANGED | Scan — how it works |
| 115 | CHANGED | Scan — before the photo picker |
| 116 | CHANGED | Scan — reading on device |
| 117 | CHANGED | Scan — photograph a receipt |
| 118 | CHANGED | Scan — results: added 4, confirmed 1 |
| 119 | CHANGED | Scan — needs your check / different amount / not added |
| 120 | NEW | Scan — one row undone |
| 121 | CHANGED | Scan — nothing found |
| 122 | NEW | Widgets — iOS small and medium |
| 123 | NEW | Widgets — large, iOS and Android |
| 124 | NEW | Widgets — Android small and medium |
| 125 | NEW | Widgets — to confirm, empty, PIN locked |
| 126 | CHANGED | Notifications — reminder, trial, due today, backup error |
