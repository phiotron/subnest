/* Subnest — screen and component renderers for the design-system previews (no framework). */
(function () {
/* ---------------- core: data, formatting, atoms ---------------- */
var ICONS = {"arrow-up-down": "<path d=\"m21 16-4 4-4-4\" /> <path d=\"M17 20V4\" /> <path d=\"m3 8 4-4 4 4\" /> <path d=\"M7 4v16\" />", "ban": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"m4.9 4.9 14.2 14.2\" />", "bell": "<path d=\"M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9\" /> <path d=\"M10.3 21a1.94 1.94 0 0 0 3.4 0\" />", "bell-off": "<path d=\"M8.7 3A6 6 0 0 1 18 8a21.3 21.3 0 0 0 .6 5\" /> <path d=\"M17 17H3s3-2 3-9a4.67 4.67 0 0 1 .3-1.7\" /> <path d=\"M10.3 21a1.94 1.94 0 0 0 3.4 0\" /> <path d=\"m2 2 20 20\" />", "bell-ring": "<path d=\"M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9\" /> <path d=\"M10.3 21a1.94 1.94 0 0 0 3.4 0\" /> <path d=\"M4 2C2.8 3.7 2 5.7 2 8\" /> <path d=\"M22 8c0-2.3-.8-4.3-2-6\" />", "calendar-check": "<path d=\"M8 2v4\" /> <path d=\"M16 2v4\" /> <rect width=\"18\" height=\"18\" x=\"3\" y=\"4\" rx=\"2\" /> <path d=\"M3 10h18\" /> <path d=\"m9 16 2 2 4-4\" />", "calendar-clock": "<path d=\"M21 7.5V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h3.5\" /> <path d=\"M16 2v4\" /> <path d=\"M8 2v4\" /> <path d=\"M3 10h5\" /> <path d=\"M17.5 17.5 16 16.3V14\" /> <circle cx=\"16\" cy=\"16\" r=\"6\" />", "calendar-days": "<path d=\"M8 2v4\" /> <path d=\"M16 2v4\" /> <rect width=\"18\" height=\"18\" x=\"3\" y=\"4\" rx=\"2\" /> <path d=\"M3 10h18\" /> <path d=\"M8 14h.01\" /> <path d=\"M12 14h.01\" /> <path d=\"M16 14h.01\" /> <path d=\"M8 18h.01\" /> <path d=\"M12 18h.01\" /> <path d=\"M16 18h.01\" />", "chart-pie": "<path d=\"M21 12c.552 0 1.005-.449.95-.998a10 10 0 0 0-8.953-8.951c-.55-.055-.998.398-.998.95v8a1 1 0 0 0 1 1z\" /> <path d=\"M21.21 15.89A10 10 0 1 1 8 2.83\" />", "check": "<path d=\"M20 6 9 17l-5-5\" />", "chevron-down": "<path d=\"m6 9 6 6 6-6\" />", "chevron-left": "<path d=\"m15 18-6-6 6-6\" />", "chevron-right": "<path d=\"m9 18 6-6-6-6\" />", "circle-alert": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <line x1=\"12\" x2=\"12\" y1=\"8\" y2=\"12\" /> <line x1=\"12\" x2=\"12.01\" y1=\"16\" y2=\"16\" />", "circle-check": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"m9 12 2 2 4-4\" />", "circle-x": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"m15 9-6 6\" /> <path d=\"m9 9 6 6\" />", "clock": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <polyline points=\"12 6 12 12 16 14\" />", "coins": "<circle cx=\"8\" cy=\"8\" r=\"6\" /> <path d=\"M18.09 10.37A6 6 0 1 1 10.34 18\" /> <path d=\"M7 6h1v4\" /> <path d=\"m16.71 13.88.7.71-2.82 2.82\" />", "credit-card": "<rect width=\"20\" height=\"14\" x=\"2\" y=\"5\" rx=\"2\" /> <line x1=\"2\" x2=\"22\" y1=\"10\" y2=\"10\" />", "download": "<path d=\"M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4\" /> <polyline points=\"7 10 12 15 17 10\" /> <line x1=\"12\" x2=\"12\" y1=\"15\" y2=\"3\" />", "external-link": "<path d=\"M15 3h6v6\" /> <path d=\"M10 14 21 3\" /> <path d=\"M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6\" />", "file-json": "<path d=\"M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z\" /> <path d=\"M14 2v4a2 2 0 0 0 2 2h4\" /> <path d=\"M10 12a1 1 0 0 0-1 1v1a1 1 0 0 1-1 1 1 1 0 0 1 1 1v1a1 1 0 0 0 1 1\" /> <path d=\"M14 18a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1 1 1 0 0 1-1-1v-1a1 1 0 0 0-1-1\" />", "file-spreadsheet": "<path d=\"M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z\" /> <path d=\"M14 2v4a2 2 0 0 0 2 2h4\" /> <path d=\"M8 13h2\" /> <path d=\"M14 13h2\" /> <path d=\"M8 17h2\" /> <path d=\"M14 17h2\" />", "globe": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20\" /> <path d=\"M2 12h20\" />", "hourglass": "<path d=\"M5 22h14\" /> <path d=\"M5 2h14\" /> <path d=\"M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22\" /> <path d=\"M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2\" />", "house": "<path d=\"M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8\" /> <path d=\"M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z\" />", "info": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"M12 16v-4\" /> <path d=\"M12 8h.01\" />", "languages": "<path d=\"m5 8 6 6\" /> <path d=\"m4 14 6-6 2-3\" /> <path d=\"M2 5h12\" /> <path d=\"M7 2h1\" /> <path d=\"m22 22-5-10-5 10\" /> <path d=\"M14 18h6\" />", "layout-grid": "<rect width=\"7\" height=\"7\" x=\"3\" y=\"3\" rx=\"1\" /> <rect width=\"7\" height=\"7\" x=\"14\" y=\"3\" rx=\"1\" /> <rect width=\"7\" height=\"7\" x=\"14\" y=\"14\" rx=\"1\" /> <rect width=\"7\" height=\"7\" x=\"3\" y=\"14\" rx=\"1\" />", "lightbulb": "<path d=\"M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5\" /> <path d=\"M9 18h6\" /> <path d=\"M10 22h4\" />", "link": "<path d=\"M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71\" /> <path d=\"M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71\" />", "lock": "<rect width=\"18\" height=\"11\" x=\"3\" y=\"11\" rx=\"2\" ry=\"2\" /> <path d=\"M7 11V7a5 5 0 0 1 10 0v4\" />", "lock-keyhole": "<circle cx=\"12\" cy=\"16\" r=\"1\" /> <rect x=\"3\" y=\"10\" width=\"18\" height=\"12\" rx=\"2\" /> <path d=\"M7 10V7a5 5 0 0 1 10 0v3\" />", "mail": "<rect width=\"20\" height=\"16\" x=\"2\" y=\"4\" rx=\"2\" /> <path d=\"m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7\" />", "minus": "<path d=\"M5 12h14\" />", "pencil": "<path d=\"M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z\" /> <path d=\"m15 5 4 4\" />", "piggy-bank": "<path d=\"M19 5c-1.5 0-2.8 1.4-3 2-3.5-1.5-11-.3-11 5 0 1.8 0 3 2 4.5V20h4v-2h3v2h4v-4c1-.5 1.7-1 2-2h2v-4h-2c0-1-.5-1.5-1-2V5z\" /> <path d=\"M2 9v1c0 1.1.9 2 2 2h1\" /> <path d=\"M16 11h.01\" />", "plus": "<path d=\"M5 12h14\" /> <path d=\"M12 5v14\" />", "refresh-cw": "<path d=\"M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8\" /> <path d=\"M21 3v5h-5\" /> <path d=\"M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16\" /> <path d=\"M8 16H3v5\" />", "rotate-ccw": "<path d=\"M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8\" /> <path d=\"M3 3v5h5\" />", "search": "<circle cx=\"11\" cy=\"11\" r=\"8\" /> <path d=\"m21 21-4.3-4.3\" />", "settings": "<path d=\"M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z\" /> <circle cx=\"12\" cy=\"12\" r=\"3\" />", "shield-check": "<path d=\"M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z\" /> <path d=\"m9 12 2 2 4-4\" />", "star": "<path d=\"M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z\" />", "sticky-note": "<path d=\"M16 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V8Z\" /> <path d=\"M15 3v4a2 2 0 0 0 2 2h4\" />", "sun-moon": "<path d=\"M12 8a2.83 2.83 0 0 0 4 4 4 4 0 1 1-4-4\" /> <path d=\"M12 2v2\" /> <path d=\"M12 20v2\" /> <path d=\"m4.9 4.9 1.4 1.4\" /> <path d=\"m17.7 17.7 1.4 1.4\" /> <path d=\"M2 12h2\" /> <path d=\"M20 12h2\" /> <path d=\"m6.3 17.7-1.4 1.4\" /> <path d=\"m19.1 4.9-1.4 1.4\" />", "tag": "<path d=\"M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z\" /> <circle cx=\"7.5\" cy=\"7.5\" r=\".5\" fill=\"currentColor\" />", "trash-2": "<path d=\"M3 6h18\" /> <path d=\"M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6\" /> <path d=\"M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2\" /> <line x1=\"10\" x2=\"10\" y1=\"11\" y2=\"17\" /> <line x1=\"14\" x2=\"14\" y1=\"11\" y2=\"17\" />", "trending-up": "<polyline points=\"22 7 13.5 15.5 8.5 10.5 2 17\" /> <polyline points=\"16 7 22 7 22 13\" />", "upload": "<path d=\"M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4\" /> <polyline points=\"17 8 12 3 7 8\" /> <line x1=\"12\" x2=\"12\" y1=\"3\" y2=\"15\" />", "users": "<path d=\"M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2\" /> <circle cx=\"9\" cy=\"7\" r=\"4\" /> <path d=\"M22 21v-2a4 4 0 0 0-3-3.87\" /> <path d=\"M16 3.13a4 4 0 0 1 0 7.75\" />", "wallet": "<path d=\"M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1\" /> <path d=\"M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4\" />", "wifi-off": "<path d=\"M12 20h.01\" /> <path d=\"M8.5 16.429a5 5 0 0 1 7 0\" /> <path d=\"M5 12.859a10 10 0 0 1 5.17-2.69\" /> <path d=\"M19 12.859a10 10 0 0 0-2.007-1.523\" /> <path d=\"M2 8.82a15 15 0 0 1 4.177-2.643\" /> <path d=\"M22 8.82a15 15 0 0 0-11.288-3.764\" /> <path d=\"m2 2 20 20\" />", "x": "<path d=\"M18 6 6 18\" /> <path d=\"m6 6 12 12\" />"};
var TODAY = new Date(2026, 10, 4);
var USD_VND = 25400;
var LANG = 'en';
var SIZE = 390;
var SCALE = 1;
function t(en, vi) { return LANG === 'vi' && vi != null ? vi : en; }

var BASE = [
  { id: 'viettel', name: 'Viettel 5G', color: '#d6002e', mono: 'V', price: 150000, cur: 'VND', cycle: 'month', cat: 'telecom', status: 'active', due: '2026-11-01', awaiting: true, started: '2025-05-01', method: 'MoMo', remind: 3 },
  { id: 'netflix', name: 'Netflix Premium', color: '#e50914', mono: 'N', price: 260000, cur: 'VND', cycle: 'month', cat: 'video', status: 'active', share: 4, due: '2026-11-04', awaiting: true, started: '2026-06-04', method: 'Visa ••4242', remind: 3, notes: 'Shared with Minh, Lan and Huy' },
  { id: 'chatgpt', name: 'ChatGPT Plus', color: '#202123', mono: 'C', price: 20, cur: 'USD', cycle: 'month', cat: 'ai', status: 'active', due: '2026-11-07', started: '2026-03-07', method: 'Visa ••4242', remind: 3 },
  { id: 'icloud', name: 'iCloud+ 200GB', color: '#2a72d4', mono: 'iC', price: 59000, cur: 'VND', cycle: 'month', cat: 'storage', status: 'active', due: '2026-11-15', started: '2024-11-15', method: 'App Store', remind: 3 },
  { id: 'youtube', name: 'YouTube Premium Family', color: '#e6002e', mono: 'YT', price: 179000, cur: 'VND', cycle: 'month', cat: 'video', status: 'active', share: 5, due: '2026-11-22', started: '2025-08-22', method: 'Google Play', remind: 3 },
  { id: 'canva', name: 'Canva Pro', color: '#7d2ae8', mono: 'C', price: 1390000, cur: 'VND', cycle: 'year', cat: 'software', status: 'active', due: '2027-02-02', started: '2025-02-02', method: 'Visa ••4242', remind: 7 },
  { id: 'gone', name: 'Google One 2TB', color: '#1a73e8', mono: 'G1', price: 1690000, cur: 'VND', cycle: 'year', cat: 'storage', status: 'active', due: '2027-03-20', started: '2025-03-20', method: 'Google Play', remind: 7 },
  { id: 'spotify', name: 'Spotify Premium', color: '#1db954', mono: 'S', dark: 1, price: 59000, cur: 'VND', cycle: 'month', cat: 'music', status: 'trial', due: '2026-11-06', started: '2026-10-06', remind: 3 },
  { id: 'duolingo', name: 'Duolingo Super', color: '#58cc02', mono: 'D', dark: 1, price: 699000, cur: 'VND', cycle: 'year', cat: 'education', status: 'cancelled', cancelled: '2026-10-12', started: '2025-10-12', method: 'Google Play' },
  { id: 'applemusic', name: 'Apple Music', color: '#e0243f', mono: 'AM', price: 65000, cur: 'VND', cycle: 'month', cat: 'music', status: 'cancelled', cancelled: '2026-09-28', started: '2025-04-28', method: 'App Store' }
];
var HIST = {
  netflix: [['2026-11-04', 'wait'], ['2026-10-04', 'paid', 65000], ['2026-09-04', 'paid', 65000], ['2026-08-04', 'skip'], ['2026-07-04', 'paid', 65000], ['2026-06-04', 'paid', 65000]],
  spotify: [],
  canva: [['2026-02-02', 'paid', 1390000], ['2025-02-02', 'paid', 1290000]],
  duolingo: [['2025-10-12', 'paid', 699000]],
  viettel: [['2026-11-01', 'wait'], ['2026-10-01', 'paid', 150000], ['2026-09-01', 'paid', 150000], ['2026-08-01', 'paid', 150000]]
};
var LIB = [
  { id: 'netflix', name: 'Netflix', color: '#e50914', mono: 'N', from: 74000, cat: 'video', plans: 4 },
  { id: 'spotify', name: 'Spotify', color: '#1db954', mono: 'S', dark: 1, from: 59000, cat: 'music' },
  { id: 'youtube', name: 'YouTube Premium', color: '#e6002e', mono: 'YT', from: 79000, cat: 'video', plans: 2 },
  { id: 'chatgpt', name: 'ChatGPT', color: '#202123', mono: 'C', fromUsd: 20, cat: 'ai', plans: 2 },
  { id: 'icloud', name: 'iCloud+', color: '#2a72d4', mono: 'iC', from: 19000, cat: 'storage', plans: 4 },
  { id: 'gone', name: 'Google One', color: '#1a73e8', mono: 'G1', from: 45000, cat: 'storage', plans: 3 },
  { id: 'canva', name: 'Canva Pro', color: '#7d2ae8', mono: 'C', from: 130000, cat: 'software' },
  { id: 'disney', name: 'Disney+', color: '#113ccf', mono: 'D+', from: 79000, cat: 'video' },
  { id: 'applemusic', name: 'Apple Music', color: '#e0243f', mono: 'AM', from: 65000, cat: 'music' },
  { id: 'duolingo', name: 'Duolingo', color: '#58cc02', mono: 'D', dark: 1, from: 699000, yearly: 1, cat: 'education' },
  { id: 'viettel', name: 'Viettel', color: '#d6002e', mono: 'V', from: 70000, cat: 'telecom', plans: 6 },
  { id: 'm365', name: 'Microsoft 365', color: '#d83b01', mono: 'M', from: 1199000, yearly: 1, cat: 'software', plans: 2 },
  { id: 'notion', name: 'Notion', color: '#2d3438', mono: 'No', fromUsd: 10, cat: 'software' },
  { id: 'adobe', name: 'Adobe CC', color: '#c4161c', mono: 'Ad', fromUsd: 23, cat: 'software', plans: 3 },
  { id: 'prime', name: 'Prime Video', color: '#1a98ff', mono: 'P', dark: 1, from: 59000, cat: 'video' },
  { id: 'zing', name: 'Zing MP3', color: '#7a3fe0', mono: 'Z', from: 25000, cat: 'music' }
];

function clone(o) { return JSON.parse(JSON.stringify(o)); }
/* scenarios — the same §8 data bent for one state or one prototype step */
function data(scn) {
  var d = clone(BASE), by = function (id) { return d.filter(function (s) { return s.id === id; })[0]; };
  scn = scn || 'default';
  if (scn === 'empty') return [];
  if (scn === 'many') { by('viettel').due = '2026-10-01'; }
  if (scn === 'noNetflix') d = d.filter(function (s) { return s.id !== 'netflix'; });
  if (scn === 'netflixAdded') { var n = by('netflix'); n.awaiting = false; n.due = '2026-12-04'; n.isNew = true; }
  if (scn === 'netflixPaid') { var p = by('netflix'); p.awaiting = false; p.due = '2026-12-04'; }
  if (scn === 'allConfirmed') { by('netflix').awaiting = false; by('netflix').due = '2026-12-04'; by('viettel').awaiting = false; by('viettel').due = '2026-12-01'; }
  if (scn === 'trialKept') by('spotify').kept = true;
  if (scn === 'canvaCancelled') { var c = by('canva'); c.status = 'cancelled'; c.cancelled = '2026-11-04'; }
  return d;
}

/* ---------- formatting ---------- */
var MON = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
var DOW = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'], DOW_VI = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
function money(v, cur) {
  if (cur === 'USD') return '$' + (LANG === 'vi' ? String(v) : Number(v).toFixed(2));
  var n = Math.round(v);
  return LANG === 'vi' ? n.toLocaleString('vi-VN') + 'đ' : '₫' + n.toLocaleString('en-US');
}
function D(s) { var p = s.split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }
function iso(x) { return x.getFullYear() + '-' + ('0' + (x.getMonth() + 1)).slice(-2) + '-' + ('0' + x.getDate()).slice(-2); }
function days(s) { return Math.round((D(s) - TODAY) / 864e5); }
/* style: 'dm' 4 Nov · 'dmy' 4 Nov 2026 · 'wdm' Wed, 4 Nov · 'wdmy' Wed, 4 Nov 2026 */
function fd(s, style) {
  var x = typeof s === 'string' ? D(s) : s, y = x.getFullYear(), dd = x.getDate(), m = x.getMonth();
  style = style || 'dm';
  if (LANG === 'vi') {
    var w = DOW_VI[x.getDay()] + ', ', base = dd + '/' + (m + 1);
    if (style === 'dm') return base + (y !== 2026 ? '/' + y : '');
    if (style === 'dmy') return ('0' + dd).slice(-2) + '/' + ('0' + (m + 1)).slice(-2) + '/' + y;
    if (style === 'wdm') return w + base;
    return w + ('0' + dd).slice(-2) + '/' + ('0' + (m + 1)).slice(-2) + '/' + y;
  }
  var w2 = DOW[x.getDay()] + ', ', b = dd + ' ' + MON[m];
  if (style === 'dm') return b + (y !== 2026 ? ' ' + y : '');
  if (style === 'dmy') return b + ' ' + y;
  if (style === 'wdm') return w2 + b;
  return w2 + b + ' ' + y;
}
function rel(s) {
  var n = days(s);
  if (n === 0) return t('today', 'hôm nay');
  if (n === 1) return t('tomorrow', 'ngày mai');
  if (n < 0) return t(-n + ' days ago', (-n) + ' ngày trước');
  if (n <= 30) return t('in ' + n + ' days', 'còn ' + n + ' ngày');
  return fd(s, 'dm');
}
function share(s) { return s.price / (s.share || 1); }
function inVnd(v, cur) { return cur === 'USD' ? v * USD_VND : v; }
function monthly(s) { var v = inVnd(share(s), s.cur); return s.cycle === 'year' ? v / 12 : s.cycle === 'week' ? v * 52 / 12 : v; }
function yearly(s) { return monthly(s) * 12; }
function addCycle(x, s) { var y = new Date(x); if (s.cycle === 'year') y.setFullYear(y.getFullYear() + 1); else y.setMonth(y.getMonth() + 1); return y; }
function behind(s) { var n = 0, x = D(s.due); while (x <= TODAY) { n++; x = addCycle(x, s); } return n; }
function catName(c) {
  return ({ video: t('Video'), music: t('Music', 'Nhạc'), ai: 'AI', storage: t('Storage', 'Lưu trữ'), software: t('Software', 'Phần mềm'), telecom: t('Telecom', 'Viễn thông'),
    education: t('Learning', 'Học tập'), games: t('Games', 'Game'), reading: t('Reading', 'Đọc'), health: t('Health', 'Sức khoẻ'), other: t('Other', 'Khác') })[c] || c;
}
function cycleName(s) { return s.cycle === 'year' ? t('Yearly', 'Hằng năm') : t('Monthly', 'Hằng tháng'); }
function per(s) { return s.cycle === 'year' ? t('/year', '/năm') : t('/month', '/tháng'); }

/* ---------- atoms ---------- */
function icon(name, size, cls) {
  return '<svg class="ic ' + (cls || '') + '" width="' + (size || 20) + '" height="' + (size || 20) + '" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + (ICONS[name] || '') + '</svg>';
}
function tile(s, size, extra) {
  return '<span class="tile t' + size + (extra ? ' ' + extra : '') + '" style="--tile:' + s.color + ';--tile-on:var(' + (s.dark ? '--on-tile-dark' : '--on-tile-light') + ')" role="img" aria-label="' + s.name + '">' +
    '<span class="tile-mono' + (s.mono.length > 1 ? ' two' : '') + '">' + s.mono + '</span></span>';
}
function btn(label, o) {
  o = o || {};
  return '<button class="btn btn-' + (o.kind || 'primary') + (o.sm ? ' sm' : '') + (o.block ? ' block' : '') + (o.cls ? ' ' + o.cls : '') + '"' + (o.go ? ' data-go="' + o.go + '"' : '') + (o.disabled ? ' disabled' : '') + '>' +
    (o.icon ? icon(o.icon, o.sm ? 16 : 20) : '') + label + (o.trail ? icon(o.trail, 16) : '') + '</button>';
}
function chip(label, on, ic) { return '<span class="chip' + (on ? ' on' : '') + '">' + (on && ic !== false ? icon(ic || 'check', 16) : (ic && ic !== true ? icon(ic, 16) : '')) + label + '</span>'; }
function seg(items, on, cls) { return '<div class="' + (cls || 'seg') + '" role="tablist">' + items.map(function (x, i) { return '<button role="tab" aria-selected="' + (i === on) + '" class="' + (i === on ? 'on' : '') + '">' + x + '</button>'; }).join('') + '</div>'; }
function toggle(on, lbl) { return '<span class="toggle' + (on ? ' on' : '') + '" role="switch" aria-checked="' + !!on + '"' + (lbl ? ' aria-label="' + lbl + '"' : '') + '></span>'; }
function stepper(n) { return '<span class="stepper"><button aria-label="' + t('Fewer', 'Bớt') + '">' + icon('minus', 18) + '</button><span class="v num">' + n + '</span><button aria-label="' + t('More', 'Thêm') + '">' + icon('plus', 18) + '</button></span>'; }
function badge(kind, ic, label) { return '<span class="badge badge-' + kind + '">' + (ic ? icon(ic, 13) : '') + label + '</span>'; }
function awaitBadge() { return badge('warn', 'clock', t('To confirm', 'Chờ xác nhận')); }
/* banner: kind warn | info | success | danger | neutral */
function banner(kind, ic, title, body, action) {
  return '<div class="banner banner-' + kind + '"><span class="banner-ic">' + icon(ic, 20) + '</span><span class="grow"><span class="label">' + title + '</span>' +
    (body ? '<span class="meta banner-body">' + body + '</span>' : '') + '</span>' + (action ? '<span class="banner-act"' + (action.go ? ' data-go="' + action.go + '"' : '') + '>' + action.label + '</span>' : '') + '</div>';
}
function empty(o) {
  return '<div class="empty">' + (o.art || art('nest', 160)) + '<h2 class="title">' + o.title + '</h2>' + (o.body ? '<p class="body muted">' + o.body + '</p>' : '') +
    (o.action ? btn(o.action, { icon: o.actionIcon || 'plus', go: o.go }) : '') + '</div>';
}
function setRow(o) {
  return '<div class="srow' + (o.danger ? ' danger' : '') + '"' + (o.go ? ' data-go="' + o.go + '"' : '') + '>' + (o.icon ? '<span class="srow-ic">' + icon(o.icon, 20) + '</span>' : '') +
    '<span class="grow"><span class="srow-l">' + o.label + '</span>' + (o.sub ? '<span class="meta muted">' + o.sub + '</span>' : '') + '</span>' +
    (o.value ? '<span class="srow-v">' + o.value + '</span>' : '') + (o.right || '') + (o.chevron !== false && !o.right ? icon(o.ext ? 'external-link' : 'chevron-right', 18, 'muted') : '') + '</div>';
}
function group(rows, head) { return (head ? '<div class="caption eyebrow grp-head">' + head + '</div>' : '') + '<div class="group">' + rows.join('') + '</div>'; }
function dialog(title, body, actions) {
  return '<div class="dim"></div><div class="dialog" role="alertdialog"><h2 class="title">' + title + '</h2><div class="body muted dlg-body">' + body + '</div><div class="dlg-actions">' + actions.join('') + '</div></div>';
}
function sheet(inner, o) { o = o || {}; return (o.dim === false ? '' : '<div class="dim"></div>') + '<section class="sheet' + (o.cls ? ' ' + o.cls : '') + '" role="dialog"><div class="grabber"></div>' + inner + '</section>'; }
function toast(text, ic) { return '<div class="toast" role="status">' + icon(ic || 'circle-check', 18) + '<span>' + text + '</span></div>'; }
function keyboard() {
  var r = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
  return '<div class="kb" aria-hidden="true">' + r.map(function (row, i) {
    return '<div class="kb-row">' + (i === 2 ? '<span class="kb-k kb-w">⇧</span>' : '') + row.split('').map(function (c) { return '<span class="kb-k">' + c + '</span>'; }).join('') + (i === 2 ? '<span class="kb-k kb-w">⌫</span>' : '') + '</div>';
  }).join('') + '<div class="kb-row"><span class="kb-k kb-w">123</span><span class="kb-k kb-sp">' + t('space', 'dấu cách') + '</span><span class="kb-k kb-w kb-go">' + t('search', 'tìm') + '</span></div></div>';
}

/* ---------------- illustrations, device chrome ---------------- */
var NEST_TILES = [['#e50914', 'N', 0, -14, 30, -10], ['#1db954', 'S', 0, 46, 22, 8, 1], ['#202123', 'C', 0, 92, 30, -4], ['#2a72d4', 'iC', 0, 128, 18, 12]];
/* kind: nest | empty | party | chart | welcome */
function art(kind, w) {
  var tiles = '';
  var T5 = kind === 'welcome'
    ? [['#e50914', 'N', 44, 34, 34, -12], ['#1db954', 'S', 82, 20, 38, 6, 1], ['#202123', 'C', 124, 36, 32, 14], ['#2a72d4', 'iC', 62, 62, 28, -4], ['#7d2ae8', 'C', 104, 64, 26, 10], ['#58cc02', 'D', 140, 4, 22, 18, 1], ['#e6002e', 'YT', 30, 0, 22, -16]]
    : kind === 'empty' ? [] : [['#e50914', 'N', 52, 46, 30, -12], ['#1db954', 'S', 85, 36, 32, 6, 1], ['#202123', 'C', 118, 48, 28, 12]];
  T5.forEach(function (x) {
    var cx = x[2] + x[4] / 2, cy = x[3] + x[4] / 2;
    tiles += '<g transform="rotate(' + x[5] + ' ' + cx + ' ' + cy + ')"><rect x="' + x[2] + '" y="' + x[3] + '" width="' + x[4] + '" height="' + x[4] + '" rx="' + (x[4] * .27).toFixed(1) + '" fill="' + x[0] + '"/>' +
      '<text x="' + cx + '" y="' + (cy + x[4] * .17) + '" text-anchor="middle" font-family="Be Vietnam Pro, system-ui" font-weight="700" font-size="' + (x[4] * (x[1].length > 1 ? .38 : .48)).toFixed(1) + '" fill="' + (x[6] ? '#0d1113' : '#fff') + '">' + x[1] + '</text></g>';
  });
  var extra = '';
  if (kind === 'empty') extra = '<rect class="a-dash" x="84" y="44" width="32" height="32" rx="9"/><path class="a-plus" d="M100 53v14M93 60h14"/>';
  if (kind === 'party') extra = '<path class="a-spark w" d="M34 22l3 8 8 3-8 3-3 8-3-8-8-3 8-3z"/><path class="a-spark b" d="M166 14l2 6 6 2-6 2-2 6-2-6-6-2 6-2z"/><path class="a-spark b" d="M150 54l1.5 4 4 1.5-4 1.5-1.5 4-1.5-4-4-1.5 4-1.5z"/><circle class="a-dot w" cx="58" cy="12" r="3"/><circle class="a-dot b" cx="132" cy="8" r="2.5"/>';
  if (kind === 'chart') { extra = '<rect class="a-bar" x="64" y="40" width="16" height="44" rx="4"/><rect class="a-bar" x="92" y="18" width="16" height="66" rx="4"/><rect class="a-bar soft" x="120" y="52" width="16" height="32" rx="4"/>'; tiles = ''; }
  var y0 = kind === 'welcome' ? 96 : 84;
  return '<svg class="art" viewBox="0 0 200 ' + (y0 + 52) + '" width="' + w + '" aria-hidden="true">' +
    '<ellipse class="a-rim" cx="100" cy="' + y0 + '" rx="76" ry="14"/>' + extra + tiles +
    '<path class="a-bowl" d="M24 ' + y0 + 'A76 14 0 0 0 176 ' + y0 + 'C176 ' + (y0 + 34) + ' 142 ' + (y0 + 48) + ' 100 ' + (y0 + 48) + 'C58 ' + (y0 + 48) + ' 24 ' + (y0 + 34) + ' 24 ' + y0 + 'Z"/>' +
    '<path class="a-weave" d="M36 ' + (y0 + 20) + 'C70 ' + (y0 + 34) + ' 130 ' + (y0 + 34) + ' 164 ' + (y0 + 20) + 'M54 ' + (y0 + 36) + 'C84 ' + (y0 + 44) + ' 116 ' + (y0 + 44) + ' 146 ' + (y0 + 36) + '"/></svg>';
}
/* the app mark (icon artwork) — fixed brand colours, used for the icon, splash, notifications, widgets */
function mark(size, o) {
  o = o || {};
  var bg = o.bare ? '' : '<rect width="1024" height="1024" rx="' + (o.square ? 0 : 230) + '" fill="#0e6b63"/>';
  return '<svg class="mark" viewBox="0 0 1024 1024" width="' + size + '" height="' + size + '" aria-label="Subnest">' + bg +
    '<ellipse cx="512" cy="566" rx="300" ry="64" fill="#0a4f49"/>' +
    '<rect x="252" y="332" width="210" height="210" rx="58" fill="#8fe8d9" transform="rotate(-12 357 437)"/>' +
    '<rect x="562" y="332" width="210" height="210" rx="58" fill="#f5a524" transform="rotate(12 667 437)"/>' +
    '<rect x="397" y="262" width="230" height="230" rx="64" fill="#ffffff"/>' +
    '<path d="M212 566A300 64 0 0 0 812 566C812 712 676 800 512 800C348 800 212 712 212 566Z" fill="#46cdb9"/>' +
    '<path d="M262 650C380 712 644 712 762 650M322 734C420 770 604 770 702 734" fill="none" stroke="#2fae9c" stroke-width="22" stroke-linecap="round"/></svg>';
}

var SB = function (o) {
  return '<div class="sb' + (o && o.light ? ' on-dark' : '') + '"><span class="sb-time">9:41</span><span class="sb-island"></span><span class="sb-icons">' +
    '<svg width="18" height="12" viewBox="0 0 18 12" fill="currentColor"><rect x="0" y="8" width="3" height="4" rx="1"/><rect x="5" y="5.5" width="3" height="6.5" rx="1"/><rect x="10" y="3" width="3" height="9" rx="1"/><rect x="15" y="0" width="3" height="12" rx="1"/></svg>' +
    (o && o.offline ? '' : '<svg width="16" height="12" viewBox="0 0 16 12" fill="currentColor"><path d="M8 2.2c2.3 0 4.4.9 6 2.4l1.1-1.2A10.2 10.2 0 0 0 8 .6 10.2 10.2 0 0 0 .9 3.4L2 4.6a8.6 8.6 0 0 1 6-2.4Zm0 3.3c1.4 0 2.7.5 3.7 1.4l1.1-1.2A7 7 0 0 0 8 3.9a7 7 0 0 0-4.8 1.8l1.1 1.2c1-.9 2.3-1.4 3.7-1.4Zm0 3.3c-.6 0-1.2.2-1.6.6L8 11.2l1.6-1.8c-.4-.4-1-.6-1.6-.6Z"/></svg>') +
    '<svg width="27" height="13" viewBox="0 0 27 13" fill="none"><rect x=".5" y=".5" width="23" height="12" rx="3.5" stroke="currentColor" opacity=".4"/><rect x="2" y="2" width="20" height="9" rx="2" fill="currentColor"/><path d="M25 4.5v4c.8-.3 1.3-1.1 1.3-2s-.5-1.7-1.3-2Z" fill="currentColor" opacity=".45"/></svg>' +
    '</span></div>';
};
function tabbar(active) {
  var ic = ['house', 'calendar-days', 'chart-pie', 'settings'], go = ['tab-home', 'tab-cal', 'tab-ins', 'tab-set'];
  var l = [t('Overview', 'Tổng quan'), t('Calendar', 'Lịch'), t('Insights', 'Thống kê'), t('Settings', 'Cài đặt')];
  return '<nav class="tabbar">' + l.map(function (x, i) {
    return '<a class="tab' + (i === active ? ' on' : '') + '" data-go="' + go[i] + '"' + (i === active ? ' aria-current="page"' : '') + '><span class="tab-pill">' + icon(ic[i], 22) + '</span><span class="tab-l">' + x + '</span></a>';
  }).join('') + '</nav>';
}
/* o: { tab: index|false, sb: {light, offline}, cls } */
function phone(inner, o) {
  o = o || {};
  return '<div class="phone' + (SIZE === 360 ? ' s360' : '') + (SCALE > 1 ? ' t130' : '') + (o.cls ? ' ' + o.cls : '') + '" lang="' + LANG + '">' + SB(o.sb) + inner + (o.tab === false || o.tab == null ? '' : tabbar(o.tab)) + '<span class="home-ind' + (o.sb && o.sb.light ? ' on-dark' : '') + '"></span></div>';
}
function nav(title, o) {
  o = o || {};
  return '<header class="nav' + (o.cls ? ' ' + o.cls : '') + '"><button class="icon-btn" data-go="' + (o.backGo || 'back') + '" aria-label="' + (o.close ? t('Close', 'Đóng') : t('Back', 'Quay lại')) + '">' + icon(o.close ? 'x' : 'chevron-left', 24) + '</button>' +
    '<h1 class="title-sm">' + title + '</h1>' + (o.right || '<span></span>') + '</header>';
}
function largeTop(title, eyebrow, right) {
  return '<header class="top"><div>' + (eyebrow ? '<div class="meta muted">' + eyebrow + '</div>' : '') + '<h1 class="headline">' + title + '</h1></div>' + (right || '') + '</header>';
}
function fab(go) { return '<button class="fab" data-go="' + (go || 'fab') + '" aria-label="' + t('Add subscription', 'Thêm subscription') + '">' + icon('plus', 26) + '</button>'; }

/* ---------------- S0 Splash, S1 Onboarding ---------------- */
var SCR = {};
SCR.splash = function () {
  return phone('<div class="splash">' + mark(120) + '<div class="splash-word">Subnest</div></div>', { sb: { light: true }, cls: 'is-splash' });
};
function obProgress(step, skip) {
  return '<div class="ob-top"><div class="ob-prog" aria-label="Step ' + step + ' of 4">' + [1, 2, 3, 4].map(function (i) { return '<span class="' + (i <= step ? 'on' : '') + '"></span>'; }).join('') + '</div>' +
    (skip ? '<button class="btn btn-text sm" data-go="skip">' + t('Skip', 'Bỏ qua') + '</button>' : '<span class="ob-sp"></span>') + '</div>';
}
SCR.welcome = function () {
  var ben = [['bell-ring', t('Reminders before you’re charged', 'Nhắc trước khi bị trừ tiền'), t('3 days ahead, and before trials end.', 'Trước 3 ngày, và trước khi hết dùng thử.')],
    ['wallet', t('Know exactly what each month costs', 'Biết chính xác mỗi tháng tốn bao nhiêu'), t('In your currency, shared plans split fairly.', 'Theo tiền tệ của bạn, gói chia sẻ tính đúng phần.')],
    ['lock', t('Private — data stays on your phone', 'Riêng tư — dữ liệu chỉ trên máy bạn'), t('No account, no bank link, no tracking.', 'Không tài khoản, không ngân hàng, không theo dõi.')]];
  return phone('<div class="ob">' + obProgress(1, true) + '<div class="ob-art">' + art('welcome', 300) + '</div>' +
    '<h1 class="headline ob-h">' + t('All your subscriptions, one nest', 'Mọi subscription, một tổ') + '</h1>' +
    '<div class="ben">' + ben.map(function (b) { return '<div class="ben-row"><span class="ben-ic">' + icon(b[0], 20) + '</span><span class="grow"><span class="title-sm">' + b[1] + '</span><span class="meta muted">' + b[2] + '</span></span></div>'; }).join('') + '</div>' +
    '<div class="ob-foot">' + btn(t('Get started', 'Bắt đầu'), { block: true, go: 'next' }) + '</div></div>');
};
var CURS = [['VND', 'Vietnamese đồng', '₫'], ['USD', 'US dollar', '$'], ['EUR', 'Euro', '€'], ['JPY', 'Japanese yen', '¥'], ['SGD', 'Singapore dollar', 'S$'], ['THB', 'Thai baht', '฿'], ['KRW', 'South Korean won', '₩'], ['GBP', 'British pound', '£'], ['AUD', 'Australian dollar', 'A$']];
function curBadge(c) { return '<span class="cur-badge num">' + c[2] + '</span>'; }
SCR.currency = function (o) {
  o = o || {};
  var body = '<div class="ob">' + obProgress(2, true) +
    '<h1 class="headline ob-h left">' + t('Your main currency', 'Tiền tệ chính của bạn') + '</h1>' +
    '<p class="body muted ob-p">' + t('Used to add up your totals. Each subscription still keeps its own currency.', 'Dùng để cộng tổng chi. Mỗi subscription vẫn có tiền tệ riêng.') + '</p>' +
    '<div class="group"><div class="srow sel">' + curBadge(CURS[0]) + '<span class="grow"><span class="srow-l">VND — ' + t('Vietnamese đồng', 'Đồng Việt Nam') + '</span><span class="meta muted">' + t('Suggested for Vietnam', 'Gợi ý theo vùng: Việt Nam') + '</span></span><span class="check-c">' + icon('check', 18) + '</span></div></div>' +
    '<button class="btn btn-text change" data-go="change">' + icon('globe', 18) + t('Choose another currency', 'Chọn tiền tệ khác') + '</button>' +
    '<div class="ob-note meta muted">' + icon('refresh-cw', 16) + t('Exchange rates update once a day when you’re online. You can set your own in Settings.', 'Tỷ giá tự cập nhật mỗi ngày khi có mạng. Bạn có thể tự đặt trong Cài đặt.') + '</div>' +
    '<div class="ob-foot">' + btn(t('Continue', 'Tiếp tục'), { block: true, go: 'next' }) + '</div></div>';
  if (o.picker) body += sheet('<h2 class="title sh-title">' + t('Main currency', 'Tiền tệ chính') + '</h2>' +
    '<div class="search">' + icon('search', 20) + '<span class="search-ph">' + t('Search currency or country', 'Tìm tiền tệ hoặc quốc gia') + '</span></div>' +
    '<div class="cur-list">' + CURS.map(function (c, i) { return '<div class="srow" data-go="pickcur">' + curBadge(c) + '<span class="grow"><span class="srow-l">' + c[0] + '</span><span class="meta muted">' + c[1] + '</span></span>' + (i === 0 ? '<span class="check-c">' + icon('check', 18) + '</span>' : '') + '</div>'; }).join('') + '</div>', { cls: 'tall' });
  return phone(body);
};
SCR.pick = function (o) {
  o = o || {};
  var picked = o.picked || ['netflix', 'spotify', 'youtube', 'chatgpt', 'icloud'];
  var price = { netflix: 260000, spotify: 59000, youtube: 79000, chatgpt: 20 * USD_VND, icloud: 59000 };
  var sum = picked.reduce(function (a, id) { return a + (price[id] || 0); }, 0);
  var grid = LIB.map(function (s) {
    var on = picked.indexOf(s.id) >= 0;
    return '<button class="pick' + (on ? ' on' : '') + '" data-pick="' + s.id + '">' + tile(s, 56) + (on ? '<span class="pick-check">' + icon('check', 14) + '</span>' : '') + '<span class="pick-n">' + s.name + '</span></button>';
  }).join('');
  return phone('<div class="ob ob-pick">' + obProgress(3, false) +
    '<h1 class="headline ob-h left">' + t('What do you pay for?', 'Bạn đang dùng gì?') + '</h1>' +
    '<div class="search">' + icon('search', 20) + '<span class="search-ph">' + t('Search 100+ services', 'Tìm trong 100+ dịch vụ') + '</span></div>' +
    '<div class="pick-scroll"><div class="pick-grid">' + grid + '</div></div>' +
    (o.edit === false ? '' : '<div class="quick">' + tile(LIB[4], 24) + '<span class="grow"><span class="label">iCloud+ 200GB</span><span class="meta muted num">' + money(59000) + t('/month · renews monthly', '/tháng · hằng tháng') + '</span></span><span class="quick-edit">' + icon('pencil', 16) + t('Edit', 'Sửa') + '</span></div>') +
    '<div class="pick-bar"><div class="grow"><span class="label">' + t(picked.length + ' selected', 'Đã chọn ' + picked.length) + '</span><span class="meta muted num">≈ ' + money(sum) + t('/month', '/tháng') + '</span></div>' +
    '<button class="btn btn-text sm" data-go="later">' + t('Later', 'Để sau') + '</button>' + btn(t('Continue', 'Tiếp tục'), { sm: true, go: 'next', cls: 'pick-go' }) + '</div></div>');
};
SCR.remind = function () {
  return phone('<div class="ob">' + obProgress(4, false) +
    '<div class="notif-demo"><div class="lock-time">9:00</div><div class="notif">' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>' + t('now', 'bây giờ') + '</span></div>' +
    '<div class="notif-b">' + t('Netflix renews in 3 days — ₫260,000', 'Netflix gia hạn sau 3 ngày — 260.000đ') + '</div></div></div>' +
    '<div class="notif ghost">' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>' + t('2d ago', '2 ngày trước') + '</span></div><div class="notif-b">' + t('Your Spotify trial ends in 3 days.', 'Dùng thử Spotify hết sau 3 ngày.') + '</div></div></div></div>' +
    '<h1 class="headline ob-h">' + t('A heads-up before every charge', 'Báo trước mỗi lần trừ tiền') + '</h1>' +
    '<p class="body muted ob-p center">' + t('We’ll remind you 3 days before a renewal or a trial ending, at 9:00. Change it any time.', 'Subnest nhắc trước 3 ngày khi sắp gia hạn hoặc hết dùng thử, lúc 9:00. Đổi bất cứ lúc nào.') + '</p>' +
    '<div class="ob-foot col">' + btn(t('Turn on reminders', 'Bật nhắc nhở'), { block: true, icon: 'bell', go: 'next' }) + btn(t('Not now', 'Không, cảm ơn'), { kind: 'text', block: true, go: 'next' }) + '</div></div>');
};

/* ---------------- S2 Overview ---------------- */
/* o: { offline, notifOff, seg: 0|1|2, highlight, toast, scroll } */
SCR.overview = function (scn, o) {
  o = o || {};
  var all = data(scn);
  var head = largeTop(t('Overview', 'Tổng quan'), t('Wednesday, 4 November', 'Thứ Tư, 4 tháng 11'), '<button class="icon-btn" aria-label="Search">' + icon('search', 22) + '</button>');
  if (!all.length) {
    return phone('<div class="scroll">' + head + (o.notifOff ? notifBanner() : '') +
      '<section class="hero"><div class="hero-row"><span class="meta muted">' + t('Monthly spend', 'Chi mỗi tháng') + '</span></div><div class="display hero-num zero">' + money(0) + '</div></section>' +
      empty({ art: art('empty', 180), title: t('Add your first subscription', 'Thêm subscription đầu tiên'), body: t('Pick from 100+ popular services — most take three taps.', 'Chọn từ 100+ dịch vụ phổ biến — thường chỉ 3 chạm.'), action: t('Browse services', 'Xem thư viện dịch vụ'), actionIcon: 'layout-grid', go: 'fab' }) +
      '</div>' + fab(), { tab: 0 });
  }
  var active = all.filter(function (s) { return s.status === 'active'; }), trials = all.filter(function (s) { return s.status === 'trial'; }), canc = all.filter(function (s) { return s.status === 'cancelled'; });
  var total = active.reduce(function (a, s) { return a + monthly(s); }, 0);
  var sorted = active.slice().sort(function (a, b) { return monthly(b) - monthly(a); }), top = sorted[0];
  var waiting = active.filter(function (s) { return s.awaiting; });
  var periods = waiting.reduce(function (a, s) { return a + behind(s); }, 0);
  var waitSum = waiting.reduce(function (a, s) { return a + share(s) * behind(s); }, 0);
  var strip = sorted.map(function (s) { return '<span style="flex:' + monthly(s).toFixed(0) + ';background:' + s.color + '"></span>'; }).join('');
  var h = '<div class="scroll">' + head + (o.notifOff ? notifBanner() : '') +
    '<section class="hero" data-total="' + total.toFixed(0) + '">' +
    '<div class="hero-row"><span class="meta muted js-label">' + t('Monthly spend', 'Chi mỗi tháng') + '</span>' +
    '<div class="seg-mini" role="tablist"><button class="on" data-p="m">' + t('Month', 'Tháng') + '</button><button data-p="y">' + t('Year', 'Năm') + '</button></div></div>' +
    '<div class="display hero-num"><span class="approx">≈</span><span class="js-total">' + money(total) + '</span></div>' +
    '<div class="strip" aria-hidden="true">' + strip + '</div>' +
    '<div class="meta muted hero-sub"><span>' + t(active.length + ' active · ' + trials.length + ' trial', active.length + ' đang trả · ' + trials.length + ' dùng thử') + '</span><span>' + t('Biggest: ', 'Lớn nhất: ') + top.name + ' · ' + Math.round(monthly(top) / total * 100) + '%</span></div>' +
    (o.offline ? '<div class="stale">' + icon('wifi-off', 14) + t('Offline · rates from 3 days ago', 'Offline · tỷ giá cập nhật 3 ngày trước') + '</div>' : '') +
    '</section><section class="stack">';
  if (periods) h += '<a class="card card-warn" data-go="pending"><span class="warn-ic">' + icon('clock', 20) + '</span>' +
    '<span class="grow"><span class="title-sm">' + t(periods + ' payment' + (periods > 1 ? 's' : '') + ' to confirm', periods + ' khoản cần xác nhận') + '</span>' +
    '<span class="meta warn-sub">' + money(waitSum) + ' · ' + waiting.map(function (s) { return s.name.split(' ')[0]; }).join(', ') + '</span></span>' +
    '<span class="chip-btn warn">' + t('Review', 'Xem') + '</span></a>';
  var sp = trials[0];
  if (sp && !sp.kept && days(sp.due) <= 7) h += '<div class="card card-trial" data-go="trial"><div class="trial-top"><span class="tile-wrap">' + tile(sp, 40) + '<span class="trial-badge">' + icon('hourglass', 12) + '</span></span>' +
    '<span class="grow"><span class="title-sm">' + t('Spotify trial ends in ' + days(sp.due) + ' days', 'Dùng thử Spotify hết sau ' + days(sp.due) + ' ngày') + '</span>' +
    '<span class="meta muted">' + t('Then ', 'Sau đó ') + money(sp.price) + t('/month from ', '/tháng từ ') + fd(sp.due, 'wdm') + '</span></span></div>' +
    '<div class="trial-actions">' + btn(t('How to cancel', 'Cách huỷ'), { kind: 'tonal', sm: true, icon: 'external-link', go: 'howcancel' }) + btn(t('Keep it', 'Giữ lại'), { kind: 'text', sm: true, go: 'keep' }) + '</div></div>';
  h += '</section>';
  /* upcoming: next 7 days */
  var up = all.filter(function (s) { return s.status !== 'cancelled' && !s.awaiting && days(s.due) > 0 && days(s.due) <= 7; }).sort(function (a, b) { return D(a.due) - D(b.due); });
  if (up.length) h += '<section class="sec"><div class="sec-head"><span class="caption eyebrow">' + t('Upcoming · 7 days', 'Sắp tới · 7 ngày') + '</span><a class="link label" data-go="tab-cal">' + t('Calendar', 'Lịch') + '</a></div>' +
    '<div class="up-grid">' + up.slice(0, 2).map(function (s) {
      return '<div class="card up">' + tile(s, 40) + '<div class="up-name title-sm ell">' + s.name.replace(' Premium', '') + '</div><div class="meta muted">' + fd(s.due, 'wdm') + ' · ' + rel(s.due) + '</div>' +
        '<div class="up-amt title-sm num">' + money(share(s), s.cur) + '</div><div class="meta muted">' + (s.status === 'trial' ? t('First charge', 'Lần trừ đầu') : s.cur === 'USD' ? '≈ ' + money(inVnd(s.price, 'USD')) : per(s)) + '</div></div>';
    }).join('') + '</div></section>';
  var segI = o.seg || 0, list = [active, trials, canc][segI].slice().sort(function (a, b) { return segI === 2 ? D(b.cancelled) - D(a.cancelled) : D(a.due) - D(b.due); });
  h += '<section class="sec sec-subs"><div class="sec-head"><h2 class="title">' + t('Subscriptions', 'Subscription của bạn') + '</h2><button class="sort label">' + icon('arrow-up-down', 16) + t('Due date', 'Ngày gia hạn') + '</button></div>' +
    seg([t('Active', 'Đang trả') + ' <b>' + active.length + '</b>', t('Trials', 'Dùng thử') + ' <b>' + trials.length + '</b>', t('Cancelled', 'Đã huỷ') + ' <b>' + canc.length + '</b>'], segI);
  if (segI === 2) {
    var save = canc.reduce(function (a, s) { return a + yearly(s); }, 0);
    h += '<div class="card save-card"><span class="save-ic">' + icon('piggy-bank', 22) + '</span><span class="grow"><span class="meta">' + t('You’re saving', 'Bạn đang tiết kiệm') + '</span><span class="title num">' + money(save) + t('/year', '/năm') + '</span></span></div>';
  }
  h += '<div class="list card">' + (list.length ? list.map(function (s) { return row(s, { highlight: o.highlight === s.id, swipe: o.swipe === s.id }); }).join('') : '<div class="list-empty meta muted">' + t('No trials right now.', 'Không có dùng thử nào.') + '</div>') + '</div>';
  if (segI === 1) h += '<p class="meta muted list-note">' + t('Trials aren’t in your monthly total until they turn into paid subscriptions.', 'Dùng thử chưa tính vào tổng chi cho tới khi chuyển sang trả phí.') + '</p>';
  h += '</section></div>' + fab() + (o.toast ? toast(Array.isArray(o.toast) ? t(o.toast[0], o.toast[1]) : o.toast) : '');
  if (o.sheet === 'sort') h += sheet('<h2 class="title sh-title">' + t('Sort subscriptions', 'Sắp xếp subscription') + '</h2><div class="group">' +
    [[t('Due date', 'Ngày gia hạn'), t('Soonest first · awaiting always on top', 'Gần nhất trước · khoản chờ xác nhận luôn ở trên')], [t('Price', 'Giá'), t('Highest monthly cost first', 'Chi phí quy tháng cao nhất trước')], [t('Name', 'Tên'), 'A → Z']]
      .map(function (x, i) { return '<div class="plan' + (i === 0 ? ' on' : '') + '"><span class="radio"></span><span class="grow"><span class="title-sm">' + x[0] + '</span><span class="meta muted">' + x[1] + '</span></span></div>'; }).join('') + '</div>' +
    '<div class="sh-gap"></div>' + btn(t('Done', 'Xong'), { block: true, kind: 'tonal' }));
  if (o.raw) return h + tabbar(0);
  return phone(h, { tab: 0, sb: { offline: o.offline } });
};
function notifBanner() { return '<div class="top-banner">' + banner('neutral', 'bell-off', t('Reminders are off', 'Nhắc nhở đang tắt'), t('You won’t hear about renewals or trials ending.', 'Bạn sẽ không được báo trước khi gia hạn hay hết dùng thử.'), { label: t('Turn on', 'Bật lại') }) + '</div>'; }
function row(s, o) {
  o = o || {};
  var r1, r2, l2;
  if (s.cur === 'USD') { r1 = money(s.price, 'USD'); r2 = '≈ ' + money(inVnd(s.price, 'USD')); }
  else if (s.share) { r1 = money(share(s)); r2 = t('plan ', 'gói ') + money(s.price); }
  else { r1 = money(s.price); r2 = per(s); }
  if (s.status === 'cancelled') l2 = '<span class="meta muted">' + t('Cancelled ', 'Đã huỷ ') + fd(s.cancelled, 'dmy') + '</span>';
  else if (s.status === 'trial') l2 = badge('neutral', 'hourglass', t('Trial', 'Dùng thử')) + '<span class="meta muted">' + t('ends ', 'hết ') + rel(s.due) + '</span>';
  else if (s.awaiting) l2 = awaitBadge() + (behind(s) > 1 ? '<span class="meta warn-t">×' + behind(s) + '</span>' : '');
  else l2 = '<span class="meta muted">' + (days(s.due) <= 30 ? rel(s.due) : fd(s.due, 'dm')) + ' · ' + catName(s.cat) + '</span>';
  var pre = '', post = '';
  if (o.swipe) {
    pre = '<div class="swipe"><div class="swipe-acts">' + (s.awaiting ? '<span class="sw-act ok">' + icon('check', 20) + t('Confirm', 'Xác nhận') + '</span>' : '') +
      '<span class="sw-act no">' + icon('ban', 20) + t('Cancel', 'Huỷ') + '</span></div>';
    post = '</div>';
  }
  return pre + '<div class="row' + (s.awaiting ? ' awaiting' : '') + (s.status === 'cancelled' ? ' is-off' : '') + (o.highlight ? ' is-new' : '') + (o.swipe ? ' swiped' + (s.awaiting ? ' two' : '') : '') + '" data-go="sub-' + s.id + '">' +
    tile(s, 40, s.awaiting ? 'dot' : s.status === 'cancelled' ? 'off' : '') +
    '<div class="row-main"><div class="row-name"><span class="title-sm ell">' + s.name + '</span>' + (s.share ? '<span class="share">' + icon('users', 14) + '÷' + s.share + '</span>' : '') + '</div>' +
    '<div class="row-sub">' + l2 + '</div></div>' +
    '<div class="row-amt"><div class="title-sm num">' + r1 + '</div><div class="meta muted num">' + r2 + '</div></div></div>' + post;
}

/* ---------------- S3 Library ---------------- */
var CATS = ['all', 'video', 'music', 'ai', 'storage', 'software', 'games', 'reading', 'health', 'education', 'telecom', 'other'];
function libRow(s, go) {
  var from = s.fromUsd ? '$' + s.fromUsd + t('/month', '/tháng') : t('from ', 'từ ') + money(s.from) + (s.yearly ? t('/year', '/năm') : t('/month', '/tháng'));
  return '<div class="lrow" data-go="' + (go || 'lib-' + s.id) + '">' + tile(s, 40) + '<span class="grow"><span class="title-sm">' + s.name + '</span><span class="meta muted num">' + from + (s.plans ? ' · ' + s.plans + t(' plans', ' gói') : '') + '</span></span><span class="add-c">' + icon('plus', 18) + '</span></div>';
}
/* o: { query, plan } */
SCR.library = function (o) {
  o = o || {};
  var q = o.query || '', h = nav(t('Add subscription', 'Thêm subscription'), { close: true }) + '<div class="lib">' +
    '<div class="search focus" data-go="search">' + icon('search', 20) + (q ? '<span class="search-q">' + q + '</span><span class="caret sm"></span>' : '<span class="caret sm"></span><span class="search-ph">' + t('Search 100+ services', 'Tìm trong 100+ dịch vụ') + '</span>') + (q ? '<span class="search-x">' + icon('circle-x', 18) + '</span>' : '') + '</div>';
  var custom = function (label, sub) { return '<div class="lrow custom" data-go="custom"><span class="tile t40 ghost">' + icon('plus', 20) + '</span><span class="grow"><span class="title-sm">' + label + '</span><span class="meta muted">' + sub + '</span></span>' + icon('chevron-right', 18, 'muted') + '</div>'; };
  if (!q) {
    h += '<div class="chip-row">' + CATS.map(function (c, i) { return chip(c === 'all' ? t('All', 'Tất cả') : catName(c), i === 0, false); }).join('') + '</div>' +
      '<div class="lib-list">' + custom(t('Create a custom service', 'Tạo dịch vụ tuỳ chỉnh'), t('Anything not in the library', 'Cho dịch vụ không có trong thư viện')) +
      '<div class="caption eyebrow lib-h">' + t('Popular in Vietnam', 'Phổ biến ở Việt Nam') + '</div>' + LIB.slice(0, 9).map(function (s) { return libRow(s); }).join('') + '</div>';
  } else {
    var res = LIB.filter(function (s) { return s.name.toLowerCase().indexOf(q.toLowerCase()) === 0; });
    h += '<div class="lib-list">' + (res.length ? '<div class="caption eyebrow lib-h">' + t(res.length + ' result' + (res.length > 1 ? 's' : ''), res.length + ' kết quả') + '</div>' + res.map(function (s) { return libRow(s, 'pick-' + s.id); }).join('')
      : '<div class="no-res">' + icon('search', 28) + '<span class="title-sm">' + t('No service called “' + q + '”', 'Không thấy “' + q + '”') + '</span><span class="meta muted">' + t('Create it — you can pick the colour and letters.', 'Tạo mới — bạn tự chọn màu và chữ cái.') + '</span></div>') +
      custom((res.length ? t('Not seeing it? ', 'Không thấy? ') : '') + t('Create “' + q + '”', 'Tạo “' + q + '”'), t('Custom service', 'Dịch vụ tuỳ chỉnh')) + '</div>';
  }
  h += '</div>' + keyboard();
  if (o.plan) {
    var plans = [['Mobile', 74000, t('480p · 1 phone or tablet', '480p · 1 điện thoại/máy tính bảng')], ['Basic', 114000, t('720p · 1 screen', '720p · 1 màn hình')], ['Standard', 230000, t('1080p · 2 screens', '1080p · 2 màn hình')], ['Premium', 260000, t('4K + HDR · 4 screens', '4K + HDR · 4 màn hình')]];
    h += sheet('<div class="sh-head">' + tile(LIB[0], 56) + '<div class="grow"><h2 class="title">Netflix</h2><span class="meta muted">' + t('Choose a plan · suggested prices for Vietnam', 'Chọn gói · giá gợi ý tại Việt Nam') + '</span></div></div>' +
      '<div class="plans">' + plans.map(function (p, i) { return '<div class="plan' + (i === 3 ? ' on' : '') + '" data-go="plan-' + p[0].toLowerCase() + '"><span class="radio"></span><span class="grow"><span class="title-sm">' + p[0] + '</span><span class="meta muted">' + p[2] + '</span></span><span class="title-sm num">' + money(p[1]) + '<span class="meta muted">' + t('/mo', '/th') + '</span></span></div>'; }).join('') + '</div>' +
      '<p class="meta muted sh-note">' + t('You can change the price on the next screen.', 'Bạn có thể sửa giá ở bước sau.') + '</p>' + btn(t('Continue with Premium', 'Tiếp tục với Premium'), { block: true, go: 'next' }));
  }
  return phone(h);
};

/* ---------------- S4 Form ---------------- */
/* o.mode: 'add' (Netflix Premium, split 4) | 'addNoSplit' | 'custom' (trial on + validation) | 'edit' (price change) ; o.picker: date picker sheet */
SCR.form = function (o) {
  o = o || {};
  var mode = o.mode || 'add', nf = LIB[0], split = mode === 'add' || mode === 'edit', custom = mode === 'custom';
  var price = mode === 'edit' ? 280000 : custom ? 0 : 260000;
  var title = mode === 'edit' ? t('Edit subscription', 'Sửa subscription') : t('New subscription', 'Subscription mới');
  var h = nav(title, { close: true }) + '<div class="form">';
  h += '<div class="f-head"><span class="tile-wrap">' + (custom ? '<span class="tile t56" style="--tile:var(--tile-teal);--tile-on:var(--on-tile-dark)"><span class="tile-mono">?</span></span>' : tile(nf, 56)) + '<span class="edit-dot">' + icon('pencil', 13) + '</span></span>' +
    '<div class="grow">' + (custom ? '<span class="name-in err">' + t('Service name', 'Tên dịch vụ') + '</span><span class="f-err">' + icon('circle-alert', 14) + t('Enter a name', 'Nhập tên dịch vụ') + '</span>'
      : '<span class="title">Netflix</span><span><span class="plan-chip">Premium ' + icon('chevron-down', 16) + '</span></span>') + '</div></div>';
  h += '<div class="group' + (custom ? ' err' : '') + '"><div class="field"><span class="f-label meta muted">' + (custom ? t('Price after trial', 'Giá sau dùng thử') : t('Price', 'Giá')) + '</span>' +
    '<div class="price-row"><span class="amount-lg num' + (custom ? ' ph' : '') + '">' + money(price) + (mode === 'add' ? '<span class="caret"></span>' : '') + '</span><button class="cur-btn">VND ' + icon('chevron-down', 16) + '</button></div>' +
    (custom ? '<span class="f-err">' + icon('circle-alert', 14) + t('Price must be more than 0', 'Giá phải lớn hơn 0') + '</span>' : '') +
    (mode === 'edit' ? '<div class="info-note">' + icon('info', 16) + '<span>' + t('Was ₫260,000. The new price applies from the next period (4 Dec). Past payments stay as they were.', 'Giá cũ 260.000đ. Giá mới áp dụng từ kỳ tới (4/12). Các khoản đã trả giữ nguyên.') + '</span></div>' : '') + '</div></div>';
  h += '<div class="group"><div class="field"><div class="f-row"><span class="label">' + t('Billing cycle', 'Chu kỳ') + '</span><span class="every"><span class="meta muted">' + t('Every', 'Mỗi') + '</span><span class="mini-field num">1</span><span class="mini-field">' + t('month', 'tháng') + ' ' + icon('chevron-down', 16) + '</span></span></div>' +
    '<div class="chips fit" style="margin-top:12px">' + [t('Weekly', 'Tuần'), t('Monthly', 'Tháng'), t('Quarterly', 'Quý'), t('Yearly', 'Năm')].map(function (x, i) { return chip(x, i === 1, false); }).join('') + '</div></div>' +
    '<div class="field"><div class="f-row"><span class="label">' + (custom ? t('First charge', 'Lần trừ đầu') : t('Next renewal', 'Gia hạn tiếp theo')) + '</span><span class="mini-field' + (o.picker ? ' focus' : '') + '">' + fd(custom ? '2026-11-02' : '2026-12-04', 'wdmy') + ' ' + icon('calendar-days', 16) + '</span></div>' +
    '<div class="meta muted" style="margin-top:6px">' + t('Then ', 'Sau đó: ') + (custom ? fd('2026-12-02') + ' · ' + fd('2027-01-02') + ' · ' + fd('2027-02-02') + '…' : fd('2027-01-04') + ' · ' + fd('2027-02-04') + ' · ' + fd('2027-03-04') + '…') + '</div></div></div>';
  h += '<div class="group"><div class="field"><div class="f-row"><span class="grow"><span class="label">' + t('Free trial', 'Đang dùng thử') + '</span><span class="meta muted">' + t('Remind me before it ends', 'Nhắc trước khi hết dùng thử') + '</span></span>' + toggle(custom) + '</div>' +
    (custom ? '<div class="f-row" style="margin-top:12px"><span class="meta">' + t('Trial ends', 'Hết dùng thử ngày') + '</span><span class="mini-field err">' + fd('2026-11-02', 'wdmy') + ' ' + icon('calendar-days', 16) + '</span></div><span class="f-err right">' + icon('circle-alert', 14) + t('Trial end can’t be in the past', 'Ngày hết dùng thử không được ở quá khứ') + '</span>' : '') + '</div>' +
    '<div class="field"><div class="f-row"><span class="grow"><span class="label">' + t('Split with others', 'Chia với người khác') + '</span><span class="meta muted">' + t('Totals use your share', 'Tổng chi chỉ tính phần của bạn') + '</span></span><span data-go="split" class="tg-hit">' + toggle(split) + '</span></div>' +
    (split ? '<div class="f-row" style="margin-top:12px"><span class="meta">' + t('People, including you', 'Số người, gồm cả bạn') + '</span>' + stepper(4) + '</div>' +
      '<div class="share-panel"><span class="grow"><span class="meta">' + t('Your share', 'Phần của bạn') + '</span><span class="big num">' + money(price / 4) + '<span class="meta"> ' + t('/month', '/tháng') + '</span></span></span><span class="meta num" style="text-align:right">' + money(price) + ' ÷ 4</span></div>' : '') + '</div></div>';
  h += '<div class="group"><div class="field"><span class="f-label label">' + t('Category', 'Danh mục') + '</span><div class="chips">' + ['video', 'music', 'ai', 'storage', 'software', 'games', 'other'].map(function (c, i) { return chip(catName(c), custom ? i === 6 : i === 0); }).join('') + '</div></div></div>';
  h += '<div class="group"><div class="field"><span class="f-label label">' + t('Remind me', 'Nhắc trước') + '</span>' + seg([t('Off', 'Tắt'), t('On day', 'Đúng ngày'), t('1 day', '1 ngày'), t('3 days', '3 ngày'), t('7 days', '7 ngày')], 3, 'seg5') +
    '<div class="meta muted" style="margin-top:8px">' + t('At 9:00 · ', 'Lúc 9:00 · ') + fd('2026-12-01', 'wdm') + '</div></div></div>';
  if (o.more) h += '<div class="group" id="more"><div class="field"><div class="f-row"><span class="label">' + t('More details', 'Thêm chi tiết') + '</span>' + icon('chevron-down', 20, 'muted rot') + '</div></div>' +
    '<div class="field"><span class="f-label meta muted">' + t('Payment method', 'Phương thức thanh toán') + '</span><div class="input">' + icon('credit-card', 18, 'muted') + '<span>Visa ••4242</span></div>' +
    '<div class="chips mt8">' + ['Visa ••4242', 'MoMo', 'ZaloPay', 'App Store', 'Google Play'].map(function (x, i) { return chip(x, i === 0, false); }).join('') + '</div></div>' +
    '<div class="field"><span class="f-label meta muted">' + t('Cancel / manage link', 'Link huỷ / quản lý') + '</span><div class="input">' + icon('link', 18, 'muted') + '<span class="ell">netflix.com/account/membership</span></div><span class="meta muted f-hint">' + t('Filled in from the library. Opens from “How to cancel”.', 'Điền sẵn từ thư viện. Mở khi chạm “Cách huỷ”.') + '</span></div>' +
    '<div class="field"><span class="f-label meta muted">' + t('Notes', 'Ghi chú') + '</span><div class="input tall"><span>' + t('Shared with Minh, Lan and Huy — they pay me on the 5th.', 'Chia với Minh, Lan và Huy — mọi người chuyển cho mình ngày 5.') + '</span></div><span class="meta muted f-hint right">58/200</span></div></div>';
  else h += '<div class="group"><div class="field"><div class="f-row"><span class="grow"><span class="label">' + t('More details', 'Thêm chi tiết') + '</span><span class="meta muted">' + t('Payment method, cancel link, notes', 'Phương thức thanh toán, link huỷ, ghi chú') + '</span></span>' + icon('chevron-down', 20, 'muted') + '</div></div></div>';
  if (mode === 'edit') h += '<button class="btn btn-text block danger-t">' + icon('trash-2', 18) + t('Delete subscription', 'Xoá subscription') + '</button>';
  h += '</div><div class="bottom-bar">' + btn(mode === 'edit' ? t('Save changes', 'Lưu thay đổi') : t('Add subscription', 'Thêm subscription'), { block: true, go: 'save', cls: custom ? 'is-disabled' : '' }) + '</div>';
  if (o.tileSheet) h += tileSheet(nf);
  if (o.curSheet) h += curSheet();
  if (o.priceDialog) h += dialog(t('Use ₫280,000 from the next period?', 'Áp dụng giá 280.000đ từ kỳ tới?'),
    t('The 4 Dec renewal and later ones use the new price. Your 5 past payments stay at what you actually paid.', 'Kỳ 4/12 và các kỳ sau dùng giá mới. 5 khoản đã trả vẫn giữ đúng số tiền bạn đã trả.'),
    [btn(t('Apply from next period', 'Áp dụng từ kỳ tới'), { block: true }), btn(t('Keep ₫260,000', 'Giữ 260.000đ'), { kind: 'text', block: true })]);
  if (o.picker) h += sheet(datePicker(2026, 11, 4) + '<div class="dp-foot"><span class="meta muted">' + t('Then 4 Jan · 4 Feb · 4 Mar', 'Sau đó 4/1 · 4/2 · 4/3') + '</span>' + btn(t('Done', 'Xong'), { sm: true }) + '</div>');
  return phone(h);
};
function datePicker(y, m, sel) {
  var first = new Date(y, m, 1), off = (first.getDay() + 6) % 7, n = new Date(y, m + 1, 0).getDate(), cells = '';
  for (var i = 0; i < off; i++) cells += '<span></span>';
  for (var dd = 1; dd <= n; dd++) {
    var past = y === 2026 && m === 10 && dd < 4;
    cells += '<span class="dp-d' + (dd === sel ? ' on' : '') + (y === 2026 && m === 10 && dd === 4 ? ' today' : '') + (past ? ' past' : '') + '">' + dd + '</span>';
  }
  var mn = LANG === 'vi' ? 'Tháng ' + (m + 1) + ' ' + y : ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'][m] + ' ' + y;
  return '<div class="dp"><div class="dp-head"><button class="icon-btn" aria-label="Previous month">' + icon('chevron-left', 20) + '</button><span class="title-sm">' + mn + '</span><button class="icon-btn" aria-label="Next month">' + icon('chevron-right', 20) + '</button></div>' +
    '<div class="dp-grid dp-w">' + (LANG === 'vi' ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'] : ['M', 'T', 'W', 'T', 'F', 'S', 'S']).map(function (x) { return '<span>' + x + '</span>'; }).join('') + '</div><div class="dp-grid">' + cells + '</div></div>';
}

/* ---------------- S5 Detail ---------------- */
/* o: { dialog: 'delete' | 'cancel', scroll } */
SCR.detail = function (id, scn, o) {
  o = o || {};
  var s = data(scn).filter(function (x) { return x.id === id; })[0];
  var st = s.status === 'cancelled' ? badge('neutral', 'ban', t('Cancelled', 'Đã huỷ')) : s.status === 'trial' ? badge('warn', 'hourglass', t('Trial · ' + days(s.due) + ' days left', 'Dùng thử · còn ' + days(s.due) + ' ngày')) : s.awaiting ? awaitBadge() : badge('success', 'circle-check', t('Active', 'Đang trả'));
  var hist = HIST[id] || [], paid = hist.filter(function (x) { return x[1] === 'paid'; }).reduce(function (a, x) { return a + x[2]; }, 0);
  var host = s.id === 'canva' ? 'canva.com' : s.id === 'spotify' ? 'spotify.com' : 'netflix.com';
  var h = nav('', { right: '<button class="btn btn-text sm" data-go="edit">' + t('Edit', 'Sửa') + '</button>', cls: 'nav-clear' }) + '<div class="scroll detail">' +
    '<section class="hero-d' + (s.status === 'cancelled' ? ' is-off' : '') + '" style="--tile:' + s.color + '">' + tile(s, 80, s.status === 'cancelled' ? 'off' : '') +
    '<h1 class="headline">' + s.name + '</h1><div class="hero-d-st">' + st + '</div>' +
    '<div class="hero-d-amt"><span class="display-sm num">' + money(s.share ? share(s) : s.price, s.cur) + '</span><span class="meta muted"> ' + per(s) + '</span></div>' +
    (s.share ? '<div class="meta muted">' + icon('users', 14, 'inl') + ' ' + t('Your share · plan ', 'Phần của bạn · gói ') + money(s.price) + ' ÷ ' + s.share + '</div>' : s.cur === 'USD' ? '<div class="meta muted">≈ ' + money(inVnd(s.price, 'USD')) + '</div>' : '') + '</section>';
  if (s.awaiting) h += '<div class="pad">' + banner('warn', 'clock', t('Renewal on ' + fd(s.due, 'dm') + ' needs confirming', 'Kỳ ' + fd(s.due, 'dm') + ' đang chờ xác nhận'), t('Did ' + money(share(s)) + ' go out? The next date waits until you say.', 'Ngày gia hạn tiếp chỉ chạy khi bạn xác nhận.'), { label: t('Confirm', 'Xác nhận'), go: 'confirm' }) + '</div>';
  if (s.status === 'trial') h += '<div class="pad">' + banner('warn', 'hourglass', t('Trial ends ', 'Hết dùng thử ') + fd(s.due, 'wdm'), t('After that it renews at ' + money(s.price) + '/month. Cancel before then if you don’t want it.', 'Sau đó gia hạn ' + money(s.price) + '/tháng. Huỷ trước ngày này nếu bạn không muốn dùng tiếp.')) +
    '<div class="two-btn">' + btn(t('How to cancel', 'Cách huỷ'), { kind: 'primary', icon: 'external-link', go: 'howcancel' }) + btn(t('Keep it', 'Giữ lại'), { kind: 'outline', go: 'keep' }) + '</div></div>';
  if (s.status === 'cancelled') h += '<div class="pad">' + banner('success', 'piggy-bank', t('Saving ', 'Tiết kiệm ') + money(yearly(s)) + t('/year', '/năm'), t('Cancelled ' + fd(s.cancelled, 'dmy') + '. No more reminders.', 'Đã huỷ ' + fd(s.cancelled, 'dmy') + '. Không còn nhắc nữa.')) + '<div class="two-btn one">' + btn(t('Restore subscription', 'Khôi phục subscription'), { kind: 'tonal', icon: 'rotate-ccw', block: true }) + '</div></div>';
  var info = [];
  if (s.status !== 'cancelled') info.push(setRow({ icon: 'calendar-days', label: s.status === 'trial' ? t('First charge', 'Lần trừ đầu') : t('Next renewal', 'Gia hạn tiếp theo'), value: fd(s.due, 'wdm'), sub: s.awaiting ? t('Waits for your confirmation', 'Chờ bạn xác nhận') : rel(s.due), chevron: false }));
  info.push(setRow({ icon: 'refresh-cw', label: t('Billing cycle', 'Chu kỳ'), value: s.cycle === 'year' ? t('Every year', 'Mỗi năm') : t('Every month', 'Mỗi tháng'), chevron: false }));
  if (s.status !== 'cancelled') info.push(setRow({ icon: 'bell', label: t('Remind me', 'Nhắc trước'), value: t((s.remind || 3) + ' days before, 9:00', (s.remind || 3) + ' ngày, lúc 9:00'), chevron: false }));
  info.push(setRow({ icon: 'tag', label: t('Category', 'Danh mục'), value: catName(s.cat), chevron: false }));
  if (s.method) info.push(setRow({ icon: 'credit-card', label: t('Payment method', 'Thanh toán bằng'), value: s.method, chevron: false }));
  info.push(setRow({ icon: 'calendar-check', label: t('Since', 'Bắt đầu từ'), value: fd(s.started, 'dmy'), chevron: false }));
  info.push(setRow({ icon: 'coins', label: t('Total paid', 'Tổng đã trả'), value: '<b class="num">' + money(paid) + '</b>', chevron: false }));
  if (s.notes) info.push(setRow({ icon: 'sticky-note', label: t('Notes', 'Ghi chú'), sub: t(s.notes, 'Chia với Minh, Lan và Huy'), chevron: false }));
  h += '<div class="pad">' + group(info) + '</div>';
  h += '<div class="pad"><div class="caption eyebrow grp-head">' + t('Payment history', 'Lịch sử thanh toán') + '</div><div class="group">' + (hist.length ? hist.map(function (x) {
    var lab = x[1] === 'paid' ? '<span class="hist-st ok">' + icon('circle-check', 16) + t('Paid', 'Đã trả') + '</span>' : x[1] === 'skip' ? '<span class="hist-st">' + icon('ban', 16) + t('Didn’t pay', 'Không trả') + '</span>' : awaitBadge();
    return '<div class="srow hist"><span class="grow"><span class="srow-l">' + fd(x[0], 'dmy') + '</span>' + lab + '</span><span class="srow-v num' + (x[1] === 'skip' ? ' muted' : '') + '">' + (x[2] ? money(x[2]) : x[1] === 'wait' ? money(share(s)) : '—') + '</span>' + (x[1] === 'paid' ? icon('pencil', 16, 'muted') : '') + '</div>';
  }).join('') : '<div class="list-empty meta muted">' + t('No payments yet — the first charge is on ', 'Chưa có thanh toán — lần trừ đầu vào ') + fd(s.due, 'wdm') + '.</div>') + '</div></div>';
  h += '<div class="pad actions">' + (s.status !== 'cancelled' ? setRow({ icon: 'external-link', label: t('How to cancel this service', 'Cách huỷ dịch vụ này'), sub: t('Opens ' + host + ' account settings', 'Mở trang tài khoản ' + host), chevron: false, right: icon('external-link', 18, 'muted'), go: 'howcancel' }) +
    btn(t('Mark as cancelled', 'Đánh dấu đã huỷ'), { kind: 'outline', block: true, icon: 'ban', go: 'markcancel' }) : '') +
    btn(t('Delete subscription', 'Xoá subscription'), { kind: 'text', block: true, icon: 'trash-2', cls: 'danger-t', go: 'delete' }) + '</div></div>';
  if (o.dialog === 'delete') h += dialog(t('Delete ' + s.name + '?', 'Xoá ' + s.name + '?'), t('This removes it and its ' + hist.length + ' payment records for good. To stop reminders but keep the history, mark it as cancelled instead.', 'Subscription này và ' + hist.length + ' khoản thanh toán sẽ bị xoá vĩnh viễn. Muốn tắt nhắc mà vẫn giữ lịch sử, hãy đánh dấu đã huỷ.'), [btn(t('Delete', 'Xoá'), { kind: 'danger', block: true }), btn(t('Keep it', 'Giữ lại'), { kind: 'text', block: true })]);
  if (o.dialog === 'cancel') h += dialog(t('Mark ' + s.name + ' as cancelled?', 'Đánh dấu ' + s.name + ' đã huỷ?'), t('Reminders stop and ' + money(yearly(s)) + '/year moves into your savings. You can restore it any time.', 'Subnest ngừng nhắc và cộng ' + money(yearly(s)) + '/năm vào khoản tiết kiệm. Bạn có thể khôi phục bất cứ lúc nào.'), [btn(t('Mark as cancelled', 'Đánh dấu đã huỷ'), { kind: 'primary', block: true, go: 'next' }), btn(t('Not yet', 'Chưa'), { kind: 'text', block: true, go: 'back' })]);
  return phone(h);
};
SCR.celebrate = function () {
  var conf = '';
  for (var i = 0; i < 26; i++) conf += '<i style="left:' + ((i * 37) % 100) + '%;animation-delay:' + (i % 7) * 60 + 'ms;--r:' + (i * 47 % 180) + 'deg" class="cf c' + (i % 4) + '"></i>';
  return phone('<div class="celebrate"><div class="confetti" aria-hidden="true">' + conf + '</div>' + art('party', 200) +
    '<div class="meta muted">' + t('Canva Pro cancelled', 'Đã huỷ Canva Pro') + '</div><div class="display num cele-num">+' + money(1390000) + '</div><div class="title-sm muted">' + t('a year saved', 'tiết kiệm mỗi năm') + '</div>' +
    '<div class="card save-card wide"><span class="save-ic">' + icon('piggy-bank', 22) + '</span><span class="grow"><span class="meta">' + t('You’re now saving', 'Giờ bạn đang tiết kiệm') + '</span><span class="title num">' + money(2869000) + t('/year', '/năm') + '</span></span></div>' +
    '<div class="cele-foot">' + btn(t('See cancelled', 'Xem mục đã huỷ'), { block: true, go: 'next' }) + '</div></div>');
};
/* a stand-in for the service's own site, opened by "How to cancel" */
SCR.browser = function (host) {
  return phone('<div class="web"><div class="web-bar"><button class="btn btn-text sm" data-go="back">' + t('Done', 'Xong') + '</button><span class="web-url">' + icon('lock', 12) + host + '</span>' + icon('refresh-cw', 18, 'muted') + '</div>' +
    '<div class="web-body"><div class="web-blk w40"></div><div class="web-blk w80"></div><div class="web-blk w60"></div><div class="web-card"><div class="web-blk w50"></div><div class="web-blk w90"></div><div class="web-btn">Cancel plan</div></div><div class="web-blk w70"></div><div class="web-blk w40"></div></div>' +
    '<div class="web-hint">' + icon('info', 16) + '<span>' + t('The service’s own account page opens in the in-app browser. Tap <b>Done</b> to return to Subnest.', 'Trang tài khoản của dịch vụ mở trong trình duyệt của app. Chạm <b>Xong</b> để quay lại Subnest.') + '</span></div></div>');
};

/* ---------------- S6 Confirm sheet ---------------- */
/* o: { state: 'ask'|'done', sub: 'netflix'|'viettel', catchup } */
SCR.confirm = function (scn, o) {
  o = o || {};
  var all = data(scn), s = all.filter(function (x) { return x.id === (o.sub || 'netflix'); })[0];
  var period = o.catchup ? '2026-10-01' : s.due, amt = share(s);
  var next = o.catchup ? '2026-11-01' : iso(addCycle(D(period), s));
  var ask = '<div class="ask"><div class="sh-head">' + tile(s, 56) + '<div class="grow"><h2 class="title">' + t('Did you pay ' + s.name.split(' ')[0] + '?', 'Bạn đã trả ' + s.name.split(' ')[0] + ' chưa?') + '</h2>' +
    '<span class="sh-meta">' + (o.catchup ? badge('warn', 'clock', t('1 more after this', 'Còn 1 kỳ sau')) : badge('warn', 'clock', days(period) === 0 ? t('Due today', 'Đến hạn hôm nay') : t('Overdue', 'Quá hạn'))) +
    '<span class="meta muted">' + t('Period of ', 'Kỳ ') + fd(period, 'dmy') + '</span></span></div></div>' +
    '<div class="amount-box"><span class="meta muted">' + t('Amount paid', 'Số tiền đã trả') + '</span><div class="f-row"><span class="amount-lg num">' + money(amt) + '</span><button class="icon-btn" aria-label="Edit amount">' + icon('pencil', 20) + '</button></div>' +
    (s.share ? '<div class="meta muted">' + icon('users', 14, 'inl') + ' ' + t('Your share · plan ', 'Phần của bạn · gói ') + money(s.price) + ' ÷ ' + s.share + '</div>' : '<div class="meta muted">' + t('Current price · edit if it changed', 'Giá hiện tại · sửa nếu đã đổi') + '</div>') + '</div>' +
    '<div class="next-note meta">' + icon('calendar-clock', 16) + (o.catchup ? t('Next up: the ' + fd(next, 'dm') + ' period, also waiting.', 'Tiếp theo: kỳ ' + fd(next, 'dm') + ', cũng đang chờ.') : t('Confirming moves the next renewal to ' + fd(next, 'wdm') + '.', 'Xác nhận xong, ngày gia hạn tiếp theo là ' + fd(next, 'wdm') + '.')) + '</div>' +
    '<div class="sh-actions">' + btn(t('Paid', 'Đã trả'), { block: true, icon: 'check', go: 'paid', cls: 'js-paid' }) + btn(t('Didn’t pay this period', 'Không trả kỳ này'), { kind: 'outline', block: true, go: 'skip' }) + btn(t('Later', 'Để sau'), { kind: 'text', block: true, go: 'later' }) + '</div></div>';
  var done = '<div class="done" aria-live="polite"><div class="check">' + icon('check', 36) + '</div><h2 class="title" style="margin:0">' + t('Payment saved', 'Đã lưu thanh toán') + '</h2>' +
    '<p class="body muted" style="margin:4px 0 12px">' + s.name.split(' ')[0] + ' · ' + money(amt) + ' · ' + fd(period, 'dmy') + '</p>' +
    '<span class="paid-pill">' + icon('calendar-days', 14) + t('Next period: ', 'Kỳ tới: ') + fd(next, 'wdmy') + '</span>' +
    '<div class="sh-actions" style="margin-top:24px">' + btn(t('Done', 'Xong'), { kind: 'tonal', block: true, go: 'done', cls: 'js-done' }) + '</div></div>';
  return phone(SCR.overview(scn, { raw: true }) + sheet(ask + done, { cls: o.state === 'done' ? 'is-done' : '' }));
};

/* ---------------- S7 Pending list ---------------- */
SCR.pending = function (o) {
  o = o || {};
  if (o.empty) return phone(nav(t('To confirm', 'Chờ xác nhận')) + '<div class="scroll">' + empty({ art: art('party', 200), title: t('You’re all caught up 🎉', 'Bạn đã xác nhận hết 🎉'), body: t('New periods show up here on their due date.', 'Kỳ mới sẽ hiện ở đây vào đúng ngày đến hạn.'), action: t('Back to Overview', 'Về Tổng quan'), actionIcon: 'house', go: 'back' }) + '</div>');
  var rows = [['viettel', '2026-10-01', 150000, 'oldest'], ['viettel', '2026-11-01', 150000, 'queued'], ['netflix', '2026-11-04', 65000, '']];
  var all = data('many');
  var h = nav(t('To confirm', 'Chờ xác nhận')) + '<div class="scroll"><p class="meta muted pend-intro">' + t('Oldest first. Each period is confirmed one at a time, so the next date only moves once the earlier one is settled.', 'Kỳ cũ nhất lên trước. Mỗi kỳ được xác nhận lần lượt, nên ngày gia hạn chỉ nhảy khi kỳ trước đã xong.') + '</p><div class="group">' +
    rows.map(function (r) {
      var s = all.filter(function (x) { return x.id === r[0]; })[0], q = r[3] === 'queued';
      return '<div class="row pend' + (q ? ' queued' : '') + '" data-go="confirm-' + r[0] + '">' + tile(s, 40, q ? '' : 'dot') + '<div class="row-main"><span class="title-sm ell">' + s.name + '</span><span class="meta muted">' + fd(r[1], 'dm') + ' · ' + (days(r[1]) === 0 ? t('today', 'hôm nay') : t(-days(r[1]) + 'd ago', -days(r[1]) + ' ngày trước')) + '</span>' +
        (q ? '<span class="meta queued-t">' + icon('lock-keyhole', 13, 'inl') + t(' After 1 Oct', ' Sau kỳ 1/10') + '</span>' : '') + '</div>' +
        '<div class="row-amt"><span class="title-sm num">' + money(r[2]) + '</span></div>' + (q ? '<span class="qbtn off" aria-disabled="true">' + icon('check', 20) + '</span>' : '<button class="qbtn" aria-label="' + t('Mark paid', 'Đánh dấu đã trả') + '">' + icon('check', 20) + '</button>') + '</div>';
    }).join('') + '</div>' +
    '<p class="meta muted pend-intro">' + t('Tap a row to change the amount or mark it unpaid.', 'Chạm vào một dòng để sửa số tiền hoặc chọn không trả.') + '</p></div>' +
    '<div class="bottom-bar">' + btn(t('Confirm all · ', 'Xác nhận tất cả · ') + money(365000), { block: true, icon: 'check', go: 'confirmall' }) + '</div>';
  if (o.dialog) h += dialog(t('Confirm 3 payments?', 'Xác nhận 3 khoản?'), t('Each period is saved as paid at its current price:', 'Mỗi kỳ được lưu là đã trả theo giá hiện tại:') + '<br><span class="dlg-list"><span>Viettel 5G × 2</span><b class="num">' + money(300000) + '</b><span>Netflix Premium</span><b class="num">' + money(65000) + '</b></span>' + t('You can edit any payment later.', 'Bạn vẫn sửa được từng khoản sau này.'), [btn(t('Confirm all', 'Xác nhận tất cả'), { block: true, go: 'next' }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true, go: 'back' })]);
  return phone(h);
};

/* ---------------- S8 Calendar ---------------- */
var EV = {
  10: [[1, 'viettel', 'wait'], [4, 'netflix', 'wait'], [6, 'spotify', 'up', 59000], [7, 'chatgpt', 'up'], [15, 'icloud', 'up'], [22, 'youtube', 'up']],
  9: [[1, 'viettel', 'paid', 150000], [4, 'netflix', 'paid', 65000], [7, 'chatgpt', 'paid', 508000], [15, 'icloud', 'paid', 59000], [22, 'youtube', 'skip']]
};
var MONTH_EN = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
function monthName(m) { return t(MONTH_EN[m], 'Tháng ' + (m + 1)); }
function subById(id) { return BASE.filter(function (s) { return s.id === id; })[0]; }
function evAmt(e) { var s = subById(e[1]); return e[3] || inVnd(share(s), s.cur); }
/* o: { month: 10 (Nov) | 9 (Oct), sel: day, view: 'month'|'agenda' } */
SCR.calendar = function (o) {
  o = o || {};
  var m = o.month == null ? 10 : o.month, ev = EV[m], sel = o.sel || (m === 10 ? 4 : 22);
  var past = m < 10, sum = ev.filter(function (e) { return past ? e[2] === 'paid' : true; }).reduce(function (a, e) { return a + evAmt(e); }, 0);
  var h = '<div class="scroll cal">' + largeTop(t('Calendar', 'Lịch'), null, '') +
    '<div class="cal-bar"><div class="cal-nav"><button class="icon-btn" data-go="prev" aria-label="' + t('Previous month', 'Tháng trước') + '">' + icon('chevron-left', 22) + '</button><span class="title-sm nowrap">' + t(MONTH_EN[m] + ' 2026', 'Tháng ' + (m + 1) + '/2026') + '</span><button class="icon-btn" data-go="next" aria-label="' + t('Next month', 'Tháng sau') + '">' + icon('chevron-right', 22) + '</button></div>' +
    seg([t('Month', 'Tháng'), t('Agenda', 'Danh sách')], o.view === 'agenda' ? 1 : 0, 'seg-mini') + '</div>' +
    '<div class="cal-total"><span class="meta muted">' + (past ? t('Paid in ' + MONTH_EN[m], 'Đã trả trong tháng ' + (m + 1)) : t(MONTH_EN[m] + ' total', 'Tổng tháng ' + (m + 1))) + '</span><span class="title num">' + (past ? '' : '≈ ') + money(sum) + '</span>' +
    '<span class="meta muted">' + (past ? t('4 paid · 1 skipped', '4 đã trả · 1 bỏ qua') : t('6 payments · 2 to confirm', '6 khoản · 2 chờ xác nhận')) + '</span></div>';
  if (o.view === 'agenda') {
    var groups = [[t('To confirm', 'Chờ xác nhận'), [['2026-11-01', 'viettel', 'wait'], ['2026-11-04', 'netflix', 'wait']]], [t('This week', 'Tuần này'), [['2026-11-06', 'spotify', 'up'], ['2026-11-07', 'chatgpt', 'up']]],
      [t('Later in November', 'Cuối tháng 11'), [['2026-11-15', 'icloud', 'up'], ['2026-11-22', 'youtube', 'up']]], [t('December', 'Tháng 12'), [['2026-12-01', 'viettel', 'up'], ['2026-12-04', 'netflix', 'up'], ['2026-12-06', 'spotify', 'up']]]];
    h += groups.map(function (g) {
      return '<div class="caption eyebrow grp-head">' + g[0] + '</div><div class="group">' + g[1].map(function (e) {
        var s = subById(e[1]), dw = D(e[0]).getDay();
        return '<div class="row' + (e[2] === 'wait' ? ' awaiting' : '') + '">' + '<span class="ag-date"><b>' + D(e[0]).getDate() + '</b><span>' + (LANG === 'vi' ? DOW_VI[dw] : DOW[dw]) + '</span></span>' + tile(s, 40, e[2] === 'wait' ? 'dot' : '') +
          '<div class="row-main"><span class="title-sm ell">' + s.name + '</span>' + (e[2] === 'wait' ? '<span class="row-sub">' + awaitBadge() + '</span>' : '<span class="meta muted">' + (s.status === 'trial' && e[0] === '2026-11-06' ? t('First charge after trial', 'Lần trừ đầu') : rel(e[0])) + '</span>') + '</div>' +
          '<div class="row-amt"><span class="title-sm num">' + money(share(s), s.cur) + '</span></div></div>';
      }).join('') + '</div>';
    }).join('') + '</div>' + fab();
    return phone(h, { tab: 1 });
  }
  var first = new Date(2026, m, 1), off = (first.getDay() + 6) % 7, n = new Date(2026, m + 1, 0).getDate(), cells = '';
  for (var i = 0; i < off; i++) cells += '<span class="cd out"></span>';
  for (var d = 1; d <= n; d++) {
    var es = ev.filter(function (e) { return e[0] === d; }), wait = es.some(function (e) { return e[2] === 'wait'; });
    cells += '<span class="cd' + (m === 10 && d === 4 ? ' today' : '') + (d === sel ? ' sel' : '') + (wait ? ' wait' : '') + '"><span class="cd-n">' + d + '</span><span class="cd-ev">' +
      es.slice(0, 3).map(function (e) { var s = subById(e[1]); return '<i class="ev ev-' + e[2] + '" style="--c:' + s.color + '"></i>'; }).join('') + (es.length > 3 ? '<em>+' + (es.length - 3) + '</em>' : '') + '</span>' +
      (wait ? '<span class="cd-w">' + icon('clock', 10) + '</span>' : '') + '</span>';
  }
  var wd = LANG === 'vi' ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'] : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  h += '<div class="card cal-card"><div class="cal-grid cal-wd">' + wd.map(function (x) { return '<span>' + x + '</span>'; }).join('') + '</div><div class="cal-grid">' + cells + '</div>' +
    '<div class="cal-legend meta muted"><span><i class="ev ev-paid" style="--c:var(--ink-muted)"></i>' + t('Paid', 'Đã trả') + '</span><span><i class="ev ev-up" style="--c:var(--ink-muted)"></i>' + t('Upcoming', 'Sắp tới') + '</span><span><i class="ev ev-skip" style="--c:var(--ink-muted)"></i>' + t('Skipped', 'Bỏ qua') + '</span><span class="lg-w">' + icon('clock', 12) + t('To confirm', 'Chờ xác nhận') + '</span></div></div>';
  var dayEv = ev.filter(function (e) { return e[0] === sel; }), dd = new Date(2026, m, sel);
  h += '<div class="caption eyebrow grp-head">' + (m === 10 && sel === 4 ? t('Today · ', 'Hôm nay · ') : '') + fd(dd, 'wdm') + '</div><div class="group">' + (dayEv.length ? dayEv.map(function (e) {
    var s = subById(e[1]);
    var st = e[2] === 'wait' ? awaitBadge() : e[2] === 'paid' ? '<span class="hist-st ok">' + icon('circle-check', 16) + t('Paid', 'Đã trả') + '</span>' : e[2] === 'skip' ? '<span class="hist-st">' + icon('ban', 16) + t('Didn’t pay this period', 'Không trả kỳ này') + '</span>' : '<span class="meta muted">' + rel(iso(dd)) + '</span>';
    return '<div class="row' + (e[2] === 'wait' ? ' awaiting' : '') + '">' + tile(s, 40, e[2] === 'wait' ? 'dot' : '') + '<div class="row-main"><span class="title-sm ell">' + s.name + '</span><span class="row-sub">' + st + '</span></div>' +
      '<div class="row-amt"><span class="title-sm num' + (e[2] === 'skip' ? ' muted strike' : '') + '">' + money(e[3] || share(s), e[3] ? 'VND' : s.cur) + '</span>' + (e[2] === 'wait' ? btn(t('Confirm', 'Xác nhận'), { sm: true, kind: 'tonal', go: 'confirm' }) : '') + '</div></div>';
  }).join('') : '<div class="list-empty meta muted">' + t('Nothing due this day.', 'Không có khoản nào ngày này.') + '</div>') + '</div></div>' + fab();
  return phone(h, { tab: 1 });
};

/* ---------------- S9 Insights ---------------- */
var MONTHS12 = [[11, 374800], [0, 374800], [1, 1764800], [2, 2572800], [3, 882800], [4, 882800], [5, 882800], [6, 882800], [7, 882800], [8, 882800], [9, 782000], [10, 0, 876800]];
var CATSPLIT = [['ai', 'chart-1', 508000], ['storage', 'chart-2', 199833], ['telecom', 'chart-3', 150000], ['software', 'chart-4', 115833], ['video', 'chart-5', 100800]];
function barChart() {
  var W = 326, H = 150, max = 3000000, bw = 18, gap = (W - 12 * bw) / 11, g = '';
  [1000000, 2000000, 3000000].forEach(function (v) { var y = H - v / max * H; g += '<line class="ch-grid" x1="0" x2="' + W + '" y1="' + y + '" y2="' + y + '"/><text class="ch-ax" x="' + W + '" y="' + (y - 4) + '" text-anchor="end">' + (v / 1e6) + (LANG === 'vi' ? 'tr' : 'M') + '</text>'; });
  MONTHS12.forEach(function (mm, i) {
    var x = i * (bw + gap), a = mm[1] / max * H, p = (mm[2] || 0) / max * H;
    var mlab = LANG === 'vi' ? 'T' + (mm[0] + 1) : MON[mm[0]];
    var tip = mlab + (i === 0 ? ' 2025' : ' 2026') + ' · ' + (mm[2] ? money(mm[2]) + t(' expected', ' dự kiến') : money(mm[1]) + t(' paid', ' đã trả'));
    g += '<g class="ch-col" data-tip="' + tip + '"><rect class="ch-hit" x="' + (x - gap / 2) + '" y="0" width="' + (bw + gap) + '" height="' + (H + 20) + '"/>' +
      (a ? '<path class="ch-bar" d="M' + x + ' ' + H + 'V' + (H - a + 4) + 'q0 -4 4 -4h' + (bw - 8) + 'q4 0 4 4V' + H + 'Z"/>' : '') +
      (p ? '<path class="ch-proj" d="M' + x + ' ' + H + 'V' + (H - p + 4) + 'q0 -4 4 -4h' + (bw - 8) + 'q4 0 4 4V' + H + 'Z"/>' : '') +
      '<text class="ch-ax' + (i === 11 ? ' cur' : '') + '" x="' + (x + bw / 2) + '" y="' + (H + 16) + '" text-anchor="middle">' + (LANG === 'vi' ? mm[0] + 1 : MON[mm[0]][0]) + '</text></g>';
  });
  return '<div class="chart"><svg viewBox="-2 -16 ' + (W + 4) + ' ' + (H + 36) + '" width="100%" role="img" aria-label="' + t('Paid per month, last 12 months; peaks in February and March from yearly plans.', 'Số đã trả mỗi tháng trong 12 tháng; cao nhất tháng 2 và 3 do gói năm.') + '">' +
    '<defs><pattern id="hatch" width="6" height="6" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><rect width="6" height="6" class="hatch-bg"/><line x1="0" y1="0" x2="0" y2="6" class="hatch-ln"/></pattern></defs>' + g +
    '<line class="ch-base" x1="0" x2="' + W + '" y1="' + H + '" y2="' + H + '"/></svg><div class="ch-tip" hidden></div></div>';
}
function donut() {
  var tot = CATSPLIT.reduce(function (a, c) { return a + c[2]; }, 0), r = 52, C = 2 * Math.PI * r, acc = 0, segs = '';
  CATSPLIT.forEach(function (c) {
    var len = c[2] / tot * C;
    segs += '<circle class="dn-seg" cx="70" cy="70" r="' + r + '" stroke="var(--' + c[1] + ')" stroke-dasharray="' + Math.max(0, len - 2.5).toFixed(2) + ' ' + C.toFixed(2) + '" stroke-dashoffset="' + (-acc).toFixed(2) + '"/>';
    acc += len;
  });
  return '<div class="donut"><svg viewBox="0 0 140 140" width="140" height="140" role="img" aria-label="' + t('Monthly spend by category', 'Chi mỗi tháng theo danh mục') + '">' + '<g transform="rotate(-90 70 70)">' + segs + '</g>' +
    '<text class="dn-c1" x="70" y="68" text-anchor="middle">' + t('≈ ₫1.07M', '≈ 1,07tr') + '</text><text class="dn-c2" x="70" y="85" text-anchor="middle">' + t('per month', 'mỗi tháng') + '</text></svg>' +
    '<div class="dn-leg">' + CATSPLIT.map(function (c) { return '<div class="dn-row"><i style="background:var(--' + c[1] + ')"></i><span class="grow"><span class="label">' + catName(c[0]) + '</span><span class="meta muted num">' + money(c[2]) + '</span></span><span class="label num">' + Math.round(c[2] / tot * 100) + '%</span></div>'; }).join('') + '</div></div>';
}
SCR.insights = function (o) {
  o = o || {};
  var h = '<div class="scroll ins">' + largeTop(t('Insights', 'Thống kê')) + seg([t('This month', 'Tháng này'), t('12 months', '12 tháng'), t('This year', 'Năm nay')], 1);
  if (o.empty) return phone(h + empty({ art: art('chart', 180), title: t('Add subscriptions to see insights', 'Thêm subscription để xem thống kê'), body: t('Your spending by month and category shows up here once you’ve added a few.', 'Chi tiêu theo tháng và danh mục sẽ hiện ở đây khi bạn đã thêm vài subscription.'), action: t('Add a subscription', 'Thêm subscription'), go: 'fab' }) + '</div>', { tab: 2 });
  var act = 11166000, proj = 12042800;
  h += '<div class="card ins-sum"><div class="ins-sum-a"><span class="meta muted">' + t('Paid · last 12 months', 'Đã trả · 12 tháng qua') + '</span><span class="display-sm num">' + money(act) + '</span>' +
    '<span class="meta trend">' + icon('trending-up', 16) + t('14% more than the 12 months before', 'Nhiều hơn 14% so với 12 tháng trước đó') + '</span></div>' +
    '<div class="ins-sum-b"><span class="lg"><i class="sw solid"></i>' + t('Paid', 'Đã trả') + '</span><span class="num label">' + money(act) + '</span><span class="lg"><i class="sw hatch"></i>' + t('Expected, not yet confirmed', 'Dự kiến, chưa xác nhận') + '</span><span class="num label">' + money(proj - act) + '</span></div></div>';
  h += '<div class="card ins-card"><div class="ins-h"><span class="title-sm">' + t('By month', 'Theo tháng') + '</span><span class="meta muted">' + t('Tap a bar', 'Chạm vào cột') + '</span></div>' + barChart() +
    '<p class="meta muted ch-note">' + t('February and March jump with the yearly Canva and Google One renewals.', 'Tháng 2 và 3 tăng vọt vì gia hạn gói năm Canva và Google One.') + '</p></div>';
  h += '<div class="card ins-card"><div class="ins-h"><span class="title-sm">' + t('By category', 'Theo danh mục') + '</span><span class="meta muted">' + t('monthly, active', 'mỗi tháng, đang trả') + '</span></div>' + donut() + '</div>';
  var top = BASE.filter(function (s) { return s.status === 'active'; }).sort(function (a, b) { return monthly(b) - monthly(a); }).slice(0, 5), mx = monthly(top[0]);
  h += '<div class="card ins-card"><div class="ins-h"><span class="title-sm">' + t('Most expensive', 'Đắt nhất') + '</span><span class="meta muted">' + t('per month', 'mỗi tháng') + '</span></div>' + top.map(function (s, i) {
    return '<div class="top-row"><span class="top-n num">' + (i + 1) + '</span>' + tile(s, 24) + '<span class="grow"><span class="label ell">' + s.name + '</span><span class="top-bar"><i style="width:' + (monthly(s) / mx * 100).toFixed(0) + '%"></i></span></span><span class="label num">' + money(monthly(s)) + '</span></div>';
  }).join('') + '</div>';
  h += '<div class="card save-card big"><span class="save-ic">' + icon('piggy-bank', 24) + '</span><span class="grow"><span class="meta">' + t('You’re saving', 'Bạn đang tiết kiệm') + '</span><span class="title num">' + money(1479000) + t('/year', '/năm') + '</span><span class="meta">' + t('by cancelling Duolingo Super and Apple Music', 'nhờ huỷ Duolingo Super và Apple Music') + '</span></span></div>';
  h += '<div class="card hint-card"><span class="hint-ic">' + icon('lightbulb', 20) + '</span><span class="grow"><span class="label">' + t('You pay for 2 video services', 'Bạn trả 2 dịch vụ video') + '</span><span class="meta muted">' + t('Netflix and YouTube Premium together are ' + money(100800) + '/month. Need both?', 'Netflix và YouTube Premium tổng cộng ' + money(100800) + '/tháng. Cần cả hai?') + '</span></span><span class="avs">' + tile(subById('netflix'), 24) + tile(subById('youtube'), 24) + '</span></div>';
  return phone(h + '</div>', { tab: 2 });
};

/* ---------------- S10 Settings ---------------- */
SCR.settings = function (o) {
  o = o || {};
  var h = '<div class="scroll set">' + largeTop(t('Settings', 'Cài đặt')) +
    group([setRow({ icon: 'coins', label: t('Main currency', 'Tiền tệ chính'), value: 'VND' }), setRow({ icon: 'refresh-cw', label: t('Exchange rates', 'Tỷ giá'), value: t('Auto · 2 h ago', 'Tự động · 2 giờ trước'), go: 'rates' })], t('Money', 'Tiền')) +
    group([setRow({ icon: 'bell', label: t('Remind me', 'Nhắc trước'), value: t('3 days before', '3 ngày'), go: 'reminders' }), setRow({ icon: 'clock', label: t('Reminder time', 'Giờ nhắc'), value: '9:00' }), setRow({ icon: 'bell-ring', label: t('Notifications', 'Thông báo'), value: o.notifOff ? '<span class="warn-t">' + t('Off', 'Tắt') + '</span>' : t('On', 'Bật') })], t('Reminders', 'Nhắc nhở')) +
    group([setRow({ icon: 'sun-moon', label: t('Theme', 'Giao diện'), value: t('System', 'Theo hệ thống'), go: 'appearance' }), setRow({ icon: 'languages', label: t('Language', 'Ngôn ngữ'), value: t('System', 'Theo hệ thống') })], t('Appearance', 'Giao diện & ngôn ngữ')) +
    '<div class="caption eyebrow grp-head">' + t('Backup', 'Sao lưu') + '</div>' + banner('warn', 'download', t('Last backup was 42 days ago', 'Lần sao lưu gần nhất cách đây 42 ngày'), t('Your data lives only on this phone. Export a copy now.', 'Dữ liệu chỉ nằm trên máy này. Hãy xuất một bản ngay.'), { label: t('Back up', 'Sao lưu'), go: 'backup' }) +
    '<div class="group mt8">' + setRow({ icon: 'file-json', label: t('Export backup', 'Xuất bản sao lưu'), sub: t('JSON · everything, to restore later', 'JSON · đầy đủ, để khôi phục sau'), chevron: false, right: icon('upload', 18, 'muted') }) + setRow({ icon: 'file-spreadsheet', label: t('Export spreadsheet', 'Xuất bảng tính'), sub: t('CSV · opens in Excel or Sheets', 'CSV · mở bằng Excel hoặc Sheets'), chevron: false, right: icon('upload', 18, 'muted') }) +
    setRow({ icon: 'download', label: t('Restore from file', 'Khôi phục từ file'), go: 'restore' }) + '</div><p class="meta muted list-note">' + t('Last backup: ', 'Sao lưu gần nhất: ') + fd('2026-09-23', 'dmy') + '</p>' +
    group([setRow({ icon: 'info', label: t('Version', 'Phiên bản'), value: '1.0 (1)', chevron: false }), setRow({ icon: 'shield-check', label: t('Privacy policy', 'Chính sách quyền riêng tư'), ext: true }), setRow({ icon: 'star', label: t('Rate Subnest', 'Đánh giá Subnest'), ext: true }), setRow({ icon: 'mail', label: t('Send feedback', 'Gửi góp ý'), ext: true })], t('About', 'Giới thiệu')) +
    '<div class="privacy">' + icon('lock', 18) + '<span>' + t('Your data stays on this phone. Subnest collects nothing.', 'Dữ liệu của bạn chỉ nằm trên máy này. Subnest không thu thập gì.') + '</span></div></div>';
  if (o.sheet === 'appearance') h += sheet('<h2 class="title sh-title">' + t('Appearance', 'Giao diện & ngôn ngữ') + '</h2><div class="caption eyebrow grp-head">' + t('Theme', 'Giao diện') + '</div>' + seg([t('System', 'Hệ thống'), t('Light', 'Sáng'), t('Dark', 'Tối')], 0) +
    '<div class="caption eyebrow grp-head">' + t('Language', 'Ngôn ngữ') + '</div><div class="group">' + [[t('System', 'Theo hệ thống'), t('English (from your phone)', 'Tiếng Việt (theo máy)')], ['English', ''], ['Tiếng Việt', '']].map(function (x, i) { return '<div class="plan' + (i === 0 ? ' on' : '') + '"><span class="radio"></span><span class="grow"><span class="title-sm">' + x[0] + '</span>' + (x[1] ? '<span class="meta muted">' + x[1] + '</span>' : '') + '</span></div>'; }).join('') + '</div>' + btn(t('Done', 'Xong'), { block: true, kind: 'tonal' }));
  return phone(h, { tab: 3 });
};
SCR.rates = function (o) {
  o = o || {};
  var h = nav(t('Exchange rates', 'Tỷ giá')) + '<div class="scroll">' + '<p class="meta muted pend-intro">' + t('Totals convert to VND. Rates update once a day when you’re online; set your own to override.', 'Tổng chi quy về VND. Tỷ giá tự cập nhật mỗi ngày khi có mạng; bạn có thể tự đặt để ghi đè.') + '</p>' +
    '<div class="group">' + setRow({ label: '1 USD → <b class="num">' + (LANG === 'vi' ? '25.400' : '25,400') + ' VND</b>', sub: o.offline ? t('Auto · from 3 days ago (offline)', 'Tự động · từ 3 ngày trước (offline)') : t('Auto · updated 2 hours ago', 'Tự động · cập nhật 2 giờ trước'), go: 'rate-usd' }) + '</div>' +
    (o.offline ? '<div class="mt16">' + banner('neutral', 'wifi-off', t('You’re offline', 'Bạn đang offline'), t('Using the last rates we fetched. They update when you’re back online.', 'Đang dùng tỷ giá gần nhất. Sẽ cập nhật khi có mạng trở lại.')) + '</div>' : '') +
    btn(t('Update now', 'Cập nhật ngay'), { kind: 'tonal', block: true, icon: 'refresh-cw', cls: 'mt16' + (o.offline ? ' is-disabled' : '') }) + '<p class="meta muted list-note">' + t('Only currencies your subscriptions use are listed.', 'Chỉ hiện các loại tiền mà subscription của bạn đang dùng.') + '</p></div>';
  if (o.sheet) h += sheet('<h2 class="title sh-title">USD → VND</h2><div class="f-row rate-row"><span class="grow"><span class="label">' + t('Use automatic rate', 'Dùng tỷ giá tự động') + '</span><span class="meta muted">' + t('25,400 · updated 2 h ago', '25.400 · cập nhật 2 giờ trước') + '</span></span>' + toggle(false) + '</div>' +
    '<div class="amount-box"><span class="meta muted">' + t('Your rate · 1 USD =', 'Tỷ giá của bạn · 1 USD =') + '</span><div class="f-row"><span class="amount-lg num">' + (LANG === 'vi' ? '25.000' : '25,000') + '<span class="caret"></span></span><span class="cur-btn static">VND</span></div><div class="meta muted">' + t('ChatGPT Plus becomes ≈ ', 'ChatGPT Plus thành ≈ ') + money(500000) + t('/month', '/tháng') + '</div></div>' +
    btn(t('Save my rate', 'Lưu tỷ giá này'), { block: true }) + btn(t('Restore automatic', 'Khôi phục tự động'), { kind: 'text', block: true }));
  return phone(h);
};
SCR.reminders = function (o) {
  o = o || {};
  var h = nav(t('Reminders', 'Nhắc nhở')) + '<div class="scroll">' + (o.off ? banner('warn', 'bell-off', t('Notifications are off for Subnest', 'Thông báo của Subnest đang tắt'), t('Reminders can’t reach you until you allow them in system settings.', 'Bạn sẽ không nhận được nhắc cho tới khi cho phép trong cài đặt hệ thống.'), { label: t('Open settings', 'Mở cài đặt') }) : '') +
    '<div class="group mt8"><div class="field"><span class="f-label label">' + t('Remind me before a renewal', 'Nhắc trước khi gia hạn') + '</span>' + seg([t('Off', 'Tắt'), t('On day', 'Đúng ngày'), t('1 day', '1 ngày'), t('3 days', '3 ngày'), t('7 days', '7 ngày')], 3, 'seg5') + '<div class="meta muted" style="margin-top:8px">' + t('Trials get the same reminder before they end.', 'Dùng thử cũng được nhắc như vậy trước khi hết.') + '</div></div>' +
    setRow({ icon: 'clock', label: t('Time', 'Giờ nhắc'), value: '9:00' }) + '</div>' +
    '<p class="meta muted list-note">' + t('You can change this for a single subscription from its edit screen. Applies to new reminders; existing ones move to the new time.', 'Có thể chỉnh riêng từng subscription trong màn sửa. Áp dụng cho nhắc mới; nhắc đã lên lịch sẽ chuyển sang giờ mới.') + '</p>' +
    '<div class="caption eyebrow grp-head">' + t('Preview', 'Xem trước') + '</div><div class="notif solo">' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>9:00</span></div><div class="notif-b">' + t('Netflix renews in 3 days — ₫260,000', 'Netflix gia hạn sau 3 ngày — 260.000đ') + '</div></div></div></div>';
  return phone(h);
};
SCR.backup = function (o) {
  o = o || {};
  var file = 'subnest-2026-09-23.json';
  var h = nav(t('Backup & restore', 'Sao lưu & khôi phục')) + '<div class="scroll">' + banner('warn', 'clock', t('It’s been 42 days since your last backup', 'Đã 42 ngày kể từ lần sao lưu gần nhất'), t('Subnest keeps nothing online, so a backup is the only way to move to a new phone.', 'Subnest không lưu gì trên mạng, nên sao lưu là cách duy nhất để chuyển sang máy mới.')) +
    '<div class="group mt16">' + setRow({ icon: 'file-json', label: t('Export backup', 'Xuất bản sao lưu'), sub: t('Everything, as a .json file to restore later', 'Toàn bộ dữ liệu, file .json để khôi phục sau'), chevron: false, right: icon('upload', 18, 'muted') }) +
    setRow({ icon: 'file-spreadsheet', label: t('Export spreadsheet', 'Xuất bảng tính'), sub: t('Subscriptions and payments as .csv', 'Subscription và thanh toán dạng .csv'), chevron: false, right: icon('upload', 18, 'muted') }) + '</div>' +
    '<div class="group mt16">' + setRow({ icon: 'download', label: t('Restore from file', 'Khôi phục từ file'), sub: t('Pick a Subnest .json backup', 'Chọn file sao lưu .json của Subnest'), go: 'restore' }) + '</div><p class="meta muted list-note">' + t('Last backup: ', 'Sao lưu gần nhất: ') + fd('2026-09-23', 'dmy') + ' · ' + file + '</p></div>';
  if (o.dialog) h += dialog(t('Restore this backup?', 'Khôi phục bản sao lưu này?'), '<span class="meta muted file-n">' + file + '</span><br>' + t('It holds 9 subscriptions and 61 payments.', 'Gồm 9 subscription và 61 khoản thanh toán.') +
    '<div class="dlg-opts"><div class="plan on"><span class="radio"></span><span class="grow"><span class="title-sm">' + t('Merge', 'Gộp') + '</span><span class="meta muted">' + t('Add what’s missing, keep your current data', 'Thêm phần còn thiếu, giữ dữ liệu hiện tại') + '</span></span></div><div class="plan"><span class="radio"></span><span class="grow"><span class="title-sm">' + t('Replace', 'Thay thế') + '</span><span class="meta muted">' + t('Delete current data and use the backup', 'Xoá dữ liệu hiện tại và dùng bản sao lưu') + '</span></span></div></div>',
    [btn(t('Restore', 'Khôi phục'), { block: true }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true })]);
  return phone(h);
};

/* ---------------- S11 Widgets, S12 Notifications ---------------- */
SCR.widgets = function () {
  var sp = subById('spotify'), up = [['spotify', '2026-11-06', 59000], ['chatgpt', '2026-11-07', 508000], ['icloud', '2026-11-15', 59000]];
  var apps = ''; for (var i = 0; i < 8; i++) apps += '<span class="app"><i></i><em></em></span>';
  return phone('<div class="home"><div class="wg-row"><div class="wg wg-s"><div class="wg-top">' + tile(sp, 32) + mark(18) + '</div><div class="wg-l">' + t('Next', 'Sắp tới') + '</div><div class="wg-n">Spotify</div><div class="wg-m">' + t('in 2 days · first charge', 'còn 2 ngày') + '</div><div class="wg-a num">' + money(59000) + '</div></div>' +
    '<div class="app-grid sm">' + apps.slice(0, apps.length / 2) + '</div></div>' +
    '<div class="wg wg-m4"><div class="wg-left"><div class="wg-l">' + mark(16) + t('This month', 'Tháng này') + '</div><div class="wg-big num">≈ ' + money(1074467) + '</div><div class="wg-m">' + t('7 active · 2 to confirm', '2 chờ xác nhận') + '</div></div><div class="wg-list">' +
    up.map(function (u) { var s = subById(u[0]); return '<div class="wg-it">' + tile(s, 24) + '<span class="grow"><span class="wg-in">' + s.name.split(' ')[0] + '</span><span class="wg-m">' + fd(u[1], 'wdm') + '</span></span><span class="wg-ia num">' + money(u[2]) + '</span></div>'; }).join('') + '</div></div>' +
    '<div class="app-grid">' + apps + '</div><div class="dock"><span class="app"><i></i></span><span class="app"><i></i></span><span class="app"><i></i></span><span class="app"><i></i></span></div></div>', { sb: { light: true }, cls: 'is-home' });
};
SCR.lock = function (o) {
  o = o || {};
  var n = o.only ? [o.only] : [[t('Netflix renews in 3 days — ₫260,000', 'Netflix gia hạn sau 3 ngày — 260.000đ'), t('2d ago', '2 ngày trước')],
    [t('Your Spotify trial ends in 3 days. Cancel now if you don’t want to be charged.', 'Dùng thử Spotify hết sau 3 ngày. Huỷ ngay nếu không muốn bị tính phí.'), t('Tue', 'T3')],
    [t('Netflix renews today — tap to confirm', 'Hôm nay gia hạn Netflix — chạm để xác nhận'), t('now', 'bây giờ')]].reverse();
  return phone('<div class="lock"><div class="lock-d">' + t('Wednesday, 4 November', 'Thứ Tư, 4 tháng 11') + '</div><div class="lock-t">9:00</div><div class="lock-list">' +
    n.map(function (x, i) { return '<div class="notif glass' + (i === 0 ? ' first' : '') + '"' + (i === 0 ? ' data-go="notif"' : '') + '>' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>' + x[1] + '</span></div><div class="notif-b">' + x[0] + '</div></div></div>'; }).join('') + '</div></div>', { sb: { light: true }, cls: 'is-lock' });
};

/* ---------------- behaviour: small interactions on every mock ---------------- */
function wire(root, inProto) {
  root.querySelectorAll('.hero').forEach(function (hero) {
    var total = +hero.getAttribute('data-total'), out = hero.querySelector('.js-total'), lab = hero.querySelector('.js-label'), lang = (hero.closest('[lang]') || {}).lang || 'en';
    if (!out) return;
    hero.querySelectorAll('.seg-mini button').forEach(function (b) {
      b.addEventListener('click', function (e) {
        e.stopPropagation();
        hero.querySelectorAll('.seg-mini button').forEach(function (x) { x.classList.toggle('on', x === b); });
        var yr = b.getAttribute('data-p') === 'y', from = yr ? total : total * 12, to = yr ? total * 12 : total, t0 = performance.now();
        var L = LANG; LANG = lang;
        lab.textContent = yr ? t('Yearly spend', 'Chi mỗi năm') : t('Monthly spend', 'Chi mỗi tháng');
        LANG = L;
        (function step(now) {
          var k = Math.min(1, (now - t0) / 240), ez = 1 - Math.pow(1 - k, 3), L2 = LANG; LANG = lang;
          out.textContent = money(from + (to - from) * ez);
          LANG = L2;
          if (k < 1) requestAnimationFrame(step);
        })(t0);
      });
    });
  });
  root.querySelectorAll('.scroll.detail').forEach(function (sc) {
    var nv = sc.parentNode.querySelector('.nav-clear');
    if (nv) sc.addEventListener('scroll', function () { nv.classList.toggle('solid', sc.scrollTop > 120); });
  });
  root.querySelectorAll('.stepper').forEach(function (st) {
    var v = st.querySelector('.v'), field = st.closest('.field'), panel = field && field.querySelector('.share-panel');
    st.querySelectorAll('button').forEach(function (b, i) {
      b.addEventListener('click', function (e) {
        e.stopPropagation();
        var n = Math.max(2, Math.min(10, +v.textContent + (i ? 1 : -1))), lang = (st.closest('[lang]') || {}).lang || 'en', L = LANG;
        v.textContent = n;
        if (panel) { LANG = lang; panel.querySelector('.big').innerHTML = money(260000 / n) + '<span class="meta"> ' + t('/month', '/tháng') + '</span>'; panel.querySelector('.grow + .meta').textContent = money(260000) + ' ÷ ' + n; LANG = L; }
      });
    });
  });
  if (!inProto) {
    root.querySelectorAll('.js-paid').forEach(function (b) { b.addEventListener('click', function () { b.closest('.sheet').classList.add('is-done'); }); });
    root.querySelectorAll('.js-done').forEach(function (b) { b.addEventListener('click', function () { b.closest('.sheet').classList.remove('is-done'); }); });
    root.querySelectorAll('.toggle').forEach(function (tg) { tg.addEventListener('click', function () { tg.classList.toggle('on'); tg.setAttribute('aria-checked', tg.classList.contains('on')); }); });
  }
  root.querySelectorAll('.chart').forEach(function (ch) {
    var tip = ch.querySelector('.ch-tip');
    ch.querySelectorAll('.ch-col').forEach(function (c) {
      function show() {
        ch.querySelectorAll('.ch-col').forEach(function (x) { x.classList.toggle('dim-col', x !== c); });
        tip.hidden = false; tip.textContent = c.getAttribute('data-tip');
        var r = c.getBoundingClientRect(), R = ch.getBoundingClientRect(), z = R.width / ch.offsetWidth || 1;
        tip.style.left = Math.max(0, Math.min(ch.offsetWidth - tip.offsetWidth, (r.left - R.left) / z + r.width / z / 2 - tip.offsetWidth / 2)) + 'px';
      }
      c.addEventListener('mouseenter', show); c.addEventListener('click', show);
    });
    ch.addEventListener('mouseleave', function () { tip.hidden = true; ch.querySelectorAll('.ch-col').forEach(function (x) { x.classList.remove('dim-col'); }); });
  });
}
function scrollTo(root, what) {
  if (!what) return;
  root.querySelectorAll('.scroll, .form').forEach(function (sc) {
    var target = typeof what === 'number' ? null : sc.querySelector(what);
    sc.scrollTop = target ? target.offsetTop - 8 : (typeof what === 'number' ? what : 0);
    var nv = sc.parentNode.querySelector('.nav-clear'); if (nv) nv.classList.toggle('solid', sc.scrollTop > 120);
  });
}

/* ---------------- static stage: light + dark of one screen ---------------- */
function stage(render, o) {
  o = o || {};
  document.querySelectorAll('.slot').forEach(function (el) {
    LANG = o.lang || 'en'; SIZE = o.size || 390; SCALE = o.scale || 1;
    el.innerHTML = render(el.getAttribute('data-mode'));
    el.setAttribute('data-theme', el.getAttribute('data-mode'));
    wire(el);
    scrollTo(el, o.scroll);
    LANG = 'en'; SIZE = 390; SCALE = 1;
  });
}

/* ---------------- prototypes (§6) ---------------- */
var OV = function (scn, o) { return function () { return SCR.overview(scn, o); }; };
var FLOWS = {
  onboarding: { title: '1 · First launch', desc: 'Welcome → currency → pick 5 services → reminders → Overview with the total already there.', steps: [
    { id: 'w', label: 'Welcome', r: SCR.welcome, go: { next: 'c', skip: 'c' } },
    { id: 'c', label: 'Main currency', r: function () { return SCR.currency(); }, go: { next: 'p', skip: 'p', change: 'cp' } },
    { id: 'cp', label: '…currency list', r: function () { return SCR.currency({ picker: true }); }, go: { pickcur: 'c' }, branch: 1 },
    { id: 'p', label: 'What do you pay for?', r: function () { return SCR.pick(); }, go: { next: 'r', later: 'r' } },
    { id: 'r', label: 'Turn on reminders', r: SCR.remind, go: { next: 'o' } },
    { id: 'o', label: 'Overview — first total', r: OV('default'), go: {} }] },
  add: { title: '2 · Add a subscription', desc: '+ → search “netf” → Netflix → Premium → split with 4 → saved, new row highlighted.', steps: [
    { id: 'o', label: 'Overview', r: OV('noNetflix'), go: { fab: 'l' } },
    { id: 'l', label: 'Library', r: function () { return SCR.library(); }, go: { search: 's', back: 'o' } },
    { id: 's', label: 'Search “netf”', r: function () { return SCR.library({ query: 'netf' }); }, go: { 'pick-netflix': 'pl', back: 'o' } },
    { id: 'pl', label: 'Choose plan', r: function () { return SCR.library({ query: 'netf', plan: true }); }, go: { next: 'f', 'plan-premium': 'f' } },
    { id: 'f', label: 'Form, prefilled', r: function () { return SCR.form({ mode: 'addNoSplit' }); }, go: { split: 'f2', back: 's' } },
    { id: 'f2', label: 'Split with 4', r: function () { return SCR.form({ mode: 'add' }); }, go: { save: 'done', split: 'f', back: 's' } },
    { id: 'done', label: 'Saved', r: OV('netflixAdded', { highlight: 'netflix', toast: ['Netflix Premium added · your share ₫65,000', 'Đã thêm Netflix Premium · phần của bạn 65.000đ'] }), scroll: '.sec-subs', go: {} }] },
  confirm: { title: '3 · Confirm a period', desc: 'Tap the “renews today” notification → sheet → Paid → Overview updated.', steps: [
    { id: 'n', label: 'Notification', r: function () { return SCR.lock({ only: ['Netflix renews today — tap to confirm', 'now'] }); }, go: { notif: 's' } },
    { id: 's', label: 'Confirm sheet', r: function () { return SCR.confirm('default'); }, go: { paid: 'd', later: 'n' } },
    { id: 'd', label: 'Paid ✓', r: function () { return SCR.confirm('default', { state: 'done' }); }, go: { done: 'o' } },
    { id: 'o', label: 'Overview updated', r: OV('netflixPaid', { toast: ['Netflix · ₫65,000 saved · next 4 Dec', 'Netflix · đã lưu 65.000đ · kỳ tới 4/12'] }), go: {} }] },
  catchup: { title: '4 · Catch up on many periods', desc: '“3 payments to confirm” → list → Confirm all → all caught up.', steps: [
    { id: 'o', label: 'Overview · 3 waiting', r: OV('many'), go: { pending: 'l' } },
    { id: 'l', label: 'To-confirm list', r: function () { return SCR.pending(); }, go: { confirmall: 'dl', back: 'o' } },
    { id: 'dl', label: 'Confirm all?', r: function () { return SCR.pending({ dialog: true }); }, go: { next: 'e', back: 'l' } },
    { id: 'e', label: 'All caught up', r: function () { return SCR.pending({ empty: true }); }, go: { back: 'o2' } },
    { id: 'o2', label: 'Overview, clear', r: OV('allConfirmed', { toast: ['3 payments saved', 'Đã lưu 3 khoản'] }), go: {} }] },
  cancel: { title: '5 · Cancel a service', desc: 'Canva Pro → how to cancel (their site) → back → mark as cancelled → savings moment → Cancelled tab.', steps: [
    { id: 'd', label: 'Canva Pro detail', r: function () { return SCR.detail('canva', 'default'); }, go: { howcancel: 'w', markcancel: 'q' }, scroll: '.actions' },
    { id: 'w', label: 'canva.com', r: function () { return SCR.browser('canva.com/settings/billing'); }, go: { back: 'd' }, branch: 1 },
    { id: 'q', label: 'Mark as cancelled?', r: function () { return SCR.detail('canva', 'default', { dialog: 'cancel' }); }, go: { next: 'c', back: 'd' }, scroll: '.actions' },
    { id: 'c', label: 'Saving +₫1.39M/yr', r: SCR.celebrate, go: { next: 'o' } },
    { id: 'o', label: 'Cancelled tab', r: OV('canvaCancelled', { seg: 2 }), scroll: '.sec-subs', go: {} }] },
  trial: { title: '6 · Trial ending', desc: 'Trial card → Spotify detail → how to cancel, or keep it.', steps: [
    { id: 'o', label: 'Overview · trial card', r: OV('default'), go: { trial: 'd', howcancel: 'w' } },
    { id: 'd', label: 'Spotify detail', r: function () { return SCR.detail('spotify', 'default'); }, go: { howcancel: 'w', keep: 'k', back: 'o' } },
    { id: 'w', label: 'spotify.com', r: function () { return SCR.browser('spotify.com/account'); }, go: { back: 'd' } },
    { id: 'k', label: 'Kept', r: OV('trialKept', { toast: ['Spotify turns Active on 6 Nov', 'Spotify chuyển sang Đang trả từ 6/11'] }), go: {} }] }
};
function proto(flowId, host) {
  var f = FLOWS[flowId], cur = 0, hist = [], hot = true, lang = 'en';
  host.innerHTML = '<div class="proto"><div class="proto-phone" data-theme="' + (document.documentElement.getAttribute('data-theme') || 'light') + '"></div>' +
    '<aside class="proto-side"><h2>' + f.title + '</h2><p>' + f.desc + '</p><ol class="proto-steps">' + f.steps.map(function (s, i) { return '<li><button data-i="' + i + '" class="' + (s.branch ? 'br' : '') + '">' + s.label + '</button></li>'; }).join('') + '</ol>' +
    '<div class="proto-ctl"><button class="pb js-back">' + icon('chevron-left', 16) + 'Back</button><button class="pb js-restart">' + icon('rotate-ccw', 16) + 'Restart</button></div>' +
    '<label class="proto-opt"><input type="checkbox" class="js-hot" checked> Show tap targets</label>' +
    '<div class="proto-theme"><span class="js-theme">' + seg(['Light', 'Dark'], (document.documentElement.getAttribute('data-theme') || 'light') === 'dark' ? 1 : 0, 'seg-mini') + '</span><span class="js-lang">' + seg(['English', 'Tiếng Việt'], 0, 'seg-mini') + '</span></div>' +
    '<p class="proto-hint js-hint"></p></aside></div>';
  var ph = host.querySelector('.proto-phone');
  function show(i, push) {
    if (push) hist.push(cur);
    cur = i;
    var s = f.steps[i];
    LANG = lang; ph.innerHTML = s.r(); wire(ph, true); scrollTo(ph, s.scroll); LANG = 'en';
    ph.querySelector('.phone').classList.add('enter');
    var keys = Object.keys(s.go);
    ph.querySelectorAll('[data-go]').forEach(function (el) {
      var k = el.getAttribute('data-go');
      if (keys.indexOf(k) >= 0) {
        el.classList.add('live'); if (hot) el.classList.add('hot');
        el.addEventListener('click', function (e) { e.preventDefault(); e.stopPropagation(); var to = f.steps.map(function (x) { return x.id; }).indexOf(s.go[k]); if (to >= 0) show(to, true); });
      }
    });
    host.querySelectorAll('.proto-steps button').forEach(function (b, j) { b.classList.toggle('on', j === i); b.classList.toggle('seen', j < i); });
    host.querySelector('.js-hint').textContent = keys.length ? 'Tap a highlighted control on the phone to continue.' : 'End of flow — Restart or pick a step.';
  }
  host.querySelectorAll('.proto-steps button').forEach(function (b) { b.addEventListener('click', function () { show(+b.getAttribute('data-i'), true); }); });
  host.querySelector('.js-back').addEventListener('click', function () { if (hist.length) show(hist.pop(), false); });
  host.querySelector('.js-restart').addEventListener('click', function () { hist = []; show(0, false); });
  host.querySelector('.js-hot').addEventListener('change', function (e) { hot = e.target.checked; ph.querySelectorAll('.live').forEach(function (x) { x.classList.toggle('hot', hot); }); });
  host.querySelectorAll('.js-theme button').forEach(function (b, i) { b.addEventListener('click', function () { host.querySelectorAll('.js-theme button').forEach(function (x, j) { x.classList.toggle('on', j === i); }); ph.setAttribute('data-theme', i ? 'dark' : 'light'); }); });
  host.querySelectorAll('.js-lang button').forEach(function (b, i) { b.addEventListener('click', function () { host.querySelectorAll('.js-lang button').forEach(function (x, j) { x.classList.toggle('on', j === i); }); lang = i ? 'vi' : 'en'; show(cur, false); }); });
  show(0, false);
}

window.Subnest = { SCR: SCR, stage: stage, wire: wire, proto: proto, flows: FLOWS, icon: icon, tile: tile, mark: mark, art: art, money: money, data: data, subs: BASE, lib: LIB,
  btn: btn, chip: chip, seg: seg, toggle: toggle, stepper: stepper, badge: badge, banner: banner, empty: empty, row: row, sheet: sheet, dialog: dialog, toast: toast, datePicker: datePicker,
  setRow: setRow, group: group, phone: phone, tabbar: tabbar, monthly: monthly, setLang: function (l) { LANG = l; },
  setSize: function (z) { SIZE = z; }, setScale: function (k) { SCALE = k; }, scrollTo: scrollTo };

/* ---------------- extra sheets and states ---------------- */
function unwrap(h) { return h.replace(/^<div class="phone[^>]*>/, '').replace(/^<div class="sb[\s\S]*?<\/svg><\/span><\/div>/, '').replace(/<span class="home-ind[^>]*><\/span><\/div>$/, ''); }
/* S4 · customise the service tile: colour, letters or emoji */
function tileSheet(s) {
  var pal = ['crimson', 'orange', 'amber', 'lime', 'green', 'teal', 'sky', 'blue', 'violet', 'pink', 'brown', 'graphite'];
  var dk = { orange: 1, amber: 1, lime: 1, green: 1, teal: 1, sky: 1, pink: 1 };
  var emo = ['🎬', '🎵', '🎮', '📚', '☁️', '💪', '📱', '🤖'];
  return sheet('<h2 class="title sh-title">' + t('Tile', 'Biểu tượng') + '</h2>' +
    '<div class="tile-prev">' + tile(s, 80) + '<div class="grow"><span class="meta muted">' + t('Preview in a list', 'Xem trong danh sách') + '</span>' +
    '<div class="tile-row">' + tile(s, 40) + '<span class="grow"><span class="title-sm">Netflix Premium</span><span class="meta muted">' + money(65000) + t('/month', '/tháng') + '</span></span></div></div></div>' +
    seg([t('Letters', 'Chữ cái'), 'Emoji'], 0) +
    '<div class="f-row mt8"><span class="label">' + t('Letters', 'Chữ cái') + '</span><span class="letters"><span class="mini-field focus">N<span class="caret sm"></span></span><span class="meta muted">' + t('1–2 characters', '1–2 ký tự') + '</span></span></div>' +
    '<div class="caption eyebrow grp-head">' + t('Colour', 'Màu') + '</div>' +
    '<div class="swatches"><span class="swatch on" style="--sw:' + s.color + '" aria-label="' + t('Brand colour', 'Màu thương hiệu') + '">' + icon('check', 16) + '</span>' +
    pal.map(function (c) { return '<span class="swatch" style="--sw:var(--tile-' + c + ')"></span>'; }).join('') + '</div>' +
    '<p class="meta muted">' + t('The first swatch is Netflix’s own colour from the library. Letter colour is picked for contrast automatically.', 'Ô đầu là màu riêng của Netflix trong thư viện. Màu chữ tự chọn để đủ tương phản.') + '</p>' +
    '<div class="caption eyebrow grp-head">' + t('Or an emoji', 'Hoặc emoji') + '</div><div class="emojis">' + emo.map(function (e) { return '<span class="emo">' + e + '</span>'; }).join('') + '</div>' +
    '<div class="sh-gap"></div>' + btn(t('Done', 'Xong'), { block: true }), { cls: 'tall' });
}
/* S4 · currency for one subscription */
function curSheet() {
  var rows = [['VND', t('Vietnamese đồng', 'Đồng Việt Nam'), '₫', t('Main currency', 'Tiền tệ chính')], ['USD', t('US dollar', 'Đô la Mỹ'), '$', '1 USD ≈ ' + money(25400)], ['EUR', 'Euro', '€', '1 EUR ≈ ' + money(27300)], ['SGD', t('Singapore dollar', 'Đô la Singapore'), 'S$', '1 SGD ≈ ' + money(19500)], ['JPY', t('Japanese yen', 'Yên Nhật'), '¥', '1 JPY ≈ ' + money(166)]];
  return sheet('<h2 class="title sh-title">' + t('Currency for this subscription', 'Tiền tệ của subscription này') + '</h2>' +
    '<div class="search">' + icon('search', 20) + '<span class="search-ph">' + t('Search currency', 'Tìm tiền tệ') + '</span></div>' +
    '<div class="caption eyebrow grp-head">' + t('Used by your subscriptions', 'Bạn đang dùng') + '</div>' +
    '<div class="cur-list">' + rows.map(function (c, i) {
      return '<div class="srow">' + '<span class="cur-badge num">' + c[2] + '</span><span class="grow"><span class="srow-l">' + c[0] + ' · ' + c[1] + '</span><span class="meta muted num">' + c[3] + '</span></span>' + (i === 0 ? '<span class="check-c">' + icon('check', 18) + '</span>' : '') + '</div>';
    }).join('') + '</div>' +
    '<p class="meta muted">' + t('Totals still add up in VND, shown with ≈ when converted.', 'Tổng chi vẫn cộng theo VND, có dấu ≈ khi quy đổi.') + '</p>', { cls: 'tall' });
}

/* S5 · edit one past payment (tap a history row) */
SCR.payEdit = function () {
  var base = unwrap(SCR.detail('netflix', 'default'));
  var nf = BASE[1];
  var sh = sheet('<div class="sh-head">' + tile(nf, 56) + '<div class="grow"><h2 class="title">' + t('Payment · 4 Oct 2026', 'Thanh toán · 04/10/2026') + '</h2><span class="sh-meta">' + badge('success', 'circle-check', t('Paid', 'Đã trả')) + '<span class="meta muted">Netflix Premium</span></span></div></div>' +
    '<div class="amount-box"><span class="meta muted">' + t('Amount paid', 'Số tiền đã trả') + '</span><div class="f-row"><span class="amount-lg num">' + money(70000) + '<span class="caret"></span></span><span class="cur-btn static">VND</span></div>' +
    '<div class="meta warn-t">' + icon('info', 14, 'inl') + ' ' + t('Was ₫65,000 — saving updates Total paid to ₫265,000.', 'Trước là 65.000đ — lưu xong Tổng đã trả thành 265.000đ.') + '</div></div>' +
    '<div class="group">' + setRow({ icon: 'calendar-days', label: t('Paid on', 'Ngày trả'), value: fd('2026-10-04', 'wdmy') }) + setRow({ icon: 'credit-card', label: t('Paid with', 'Trả bằng'), value: 'Visa ••4242' }) + '</div>' +
    '<div class="sh-actions mt16">' + btn(t('Save', 'Lưu'), { block: true }) + btn(t('Mark as not paid', 'Chuyển thành không trả'), { kind: 'outline', block: true }) + btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true }) + '</div>');
  return phone(base + sh);
};

/* S9 · tap a donut slice → that category's subscriptions */
SCR.catSheet = function () {
  var base = unwrap(SCR.insights());
  var subs = BASE.filter(function (s) { return s.cat === 'storage' && s.status === 'active'; });
  var tot = subs.reduce(function (a, s) { return a + monthly(s); }, 0);
  var sh = sheet('<div class="cat-head"><i class="cat-sw" style="background:var(--chart-2)"></i><div class="grow"><h2 class="title">' + catName('storage') + '</h2><span class="meta muted">' + t('19% of your monthly spend', '19% chi tiêu mỗi tháng') + '</span></div><span class="title num">' + money(tot) + '<span class="meta muted">' + t('/mo', '/th') + '</span></span></div>' +
    '<div class="list card flat">' + subs.map(function (s) { return row(s); }).join('') + '</div>' +
    '<p class="meta muted">' + t('Google One renews yearly (₫1,690,000) — shown here as its monthly share.', 'Google One gia hạn theo năm (1.690.000đ) — ở đây tính theo tháng.') + '</p>' +
    btn(t('Close', 'Đóng'), { block: true, kind: 'tonal' }));
  return phone(base + sh);
};

/* S1.4 · the system permission prompt after “Turn on reminders” */
SCR.permission = function () {
  var base = unwrap(SCR.remind());
  return phone(base + '<div class="dim"></div><div class="os-alert" role="alertdialog"><div class="os-body"><b>' + t('“Subnest” Would Like to Send You Notifications', '“Subnest” muốn gửi thông báo cho bạn') + '</b><span>' +
    t('Notifications may include alerts, sounds and icon badges. These can be configured in Settings.', 'Thông báo có thể gồm cảnh báo, âm thanh và biểu tượng. Bạn có thể cấu hình trong Cài đặt.') + '</span></div>' +
    '<div class="os-btns"><span>' + t('Don’t Allow', 'Không cho phép') + '</span><span><b>' + t('Allow', 'Cho phép') + '</b></span></div></div>' +
    '<div class="os-note meta">' + icon('info', 14, 'inl') + ' ' + t('System dialog — drawn by iOS/Android, shown for flow context only.', 'Hộp thoại hệ thống — do iOS/Android vẽ, chỉ để minh hoạ luồng.') + '</div>');
};

})();
