/* Subnest — screen and component renderers for the design-system previews (no framework). */
(function () {
/* Subnest v2 — core: state, sample data (product.md v2 §6), business rules (§3), formatting, atoms */
var ICONS = {"archive": "<rect width=\"20\" height=\"5\" x=\"2\" y=\"3\" rx=\"1\" /> <path d=\"M4 8v11a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8\" /> <path d=\"M10 12h4\" />", "arrow-down": "<path d=\"M12 5v14\" /> <path d=\"m19 12-7 7-7-7\" />", "arrow-down-a-z": "<path d=\"m3 16 4 4 4-4\" /> <path d=\"M7 20V4\" /> <path d=\"M20 8h-5\" /> <path d=\"M15 10V6.5a2.5 2.5 0 0 1 5 0V10\" /> <path d=\"M15 14h5l-5 6h5\" />", "arrow-right": "<path d=\"M5 12h14\" /> <path d=\"m12 5 7 7-7 7\" />", "arrow-up": "<path d=\"m5 12 7-7 7 7\" /> <path d=\"M12 19V5\" />", "arrow-up-down": "<path d=\"m21 16-4 4-4-4\" /> <path d=\"M17 20V4\" /> <path d=\"m3 8 4-4 4 4\" /> <path d=\"M7 4v16\" />", "ban": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"m4.9 4.9 14.2 14.2\" />", "bell": "<path d=\"M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9\" /> <path d=\"M10.3 21a1.94 1.94 0 0 0 3.4 0\" />", "bell-off": "<path d=\"M8.7 3A6 6 0 0 1 18 8a21.3 21.3 0 0 0 .6 5\" /> <path d=\"M17 17H3s3-2 3-9a4.67 4.67 0 0 1 .3-1.7\" /> <path d=\"M10.3 21a1.94 1.94 0 0 0 3.4 0\" /> <path d=\"m2 2 20 20\" />", "bell-ring": "<path d=\"M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9\" /> <path d=\"M10.3 21a1.94 1.94 0 0 0 3.4 0\" /> <path d=\"M4 2C2.8 3.7 2 5.7 2 8\" /> <path d=\"M22 8c0-2.3-.8-4.3-2-6\" />", "book-open": "<path d=\"M12 7v14\" /> <path d=\"M3 18a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h5a4 4 0 0 1 4 4 4 4 0 0 1 4-4h5a1 1 0 0 1 1 1v13a1 1 0 0 1-1 1h-6a3 3 0 0 0-3 3 3 3 0 0 0-3-3z\" />", "bot": "<path d=\"M12 8V4H8\" /> <rect width=\"16\" height=\"12\" x=\"4\" y=\"8\" rx=\"2\" /> <path d=\"M2 14h2\" /> <path d=\"M20 14h2\" /> <path d=\"M15 13v2\" /> <path d=\"M9 13v2\" />", "calendar-check": "<path d=\"M8 2v4\" /> <path d=\"M16 2v4\" /> <rect width=\"18\" height=\"18\" x=\"3\" y=\"4\" rx=\"2\" /> <path d=\"M3 10h18\" /> <path d=\"m9 16 2 2 4-4\" />", "calendar-days": "<path d=\"M8 2v4\" /> <path d=\"M16 2v4\" /> <rect width=\"18\" height=\"18\" x=\"3\" y=\"4\" rx=\"2\" /> <path d=\"M3 10h18\" /> <path d=\"M8 14h.01\" /> <path d=\"M12 14h.01\" /> <path d=\"M16 14h.01\" /> <path d=\"M8 18h.01\" /> <path d=\"M12 18h.01\" /> <path d=\"M16 18h.01\" />", "calendar-range": "<rect width=\"18\" height=\"18\" x=\"3\" y=\"4\" rx=\"2\" /> <path d=\"M16 2v4\" /> <path d=\"M3 10h18\" /> <path d=\"M8 2v4\" /> <path d=\"M17 14h-6\" /> <path d=\"M13 18H7\" /> <path d=\"M7 14h.01\" /> <path d=\"M17 18h.01\" />", "camera": "<path d=\"M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z\" /> <circle cx=\"12\" cy=\"13\" r=\"3\" />", "chart-pie": "<path d=\"M21 12c.552 0 1.005-.449.95-.998a10 10 0 0 0-8.953-8.951c-.55-.055-.998.398-.998.95v8a1 1 0 0 0 1 1z\" /> <path d=\"M21.21 15.89A10 10 0 1 1 8 2.83\" />", "check": "<path d=\"M20 6 9 17l-5-5\" />", "check-check": "<path d=\"M18 6 7 17l-5-5\" /> <path d=\"m22 10-7.5 7.5L13 16\" />", "chevron-down": "<path d=\"m6 9 6 6 6-6\" />", "chevron-left": "<path d=\"m15 18-6-6 6-6\" />", "chevron-right": "<path d=\"m9 18 6-6-6-6\" />", "chevron-up": "<path d=\"m18 15-6-6-6 6\" />", "circle-alert": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <line x1=\"12\" x2=\"12\" y1=\"8\" y2=\"12\" /> <line x1=\"12\" x2=\"12.01\" y1=\"16\" y2=\"16\" />", "circle-check": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"m9 12 2 2 4-4\" />", "circle-dashed": "<path d=\"M10.1 2.182a10 10 0 0 1 3.8 0\" /> <path d=\"M13.9 21.818a10 10 0 0 1-3.8 0\" /> <path d=\"M17.609 3.721a10 10 0 0 1 2.69 2.7\" /> <path d=\"M2.182 13.9a10 10 0 0 1 0-3.8\" /> <path d=\"M20.279 17.609a10 10 0 0 1-2.7 2.69\" /> <path d=\"M21.818 10.1a10 10 0 0 1 0 3.8\" /> <path d=\"M3.721 6.391a10 10 0 0 1 2.7-2.69\" /> <path d=\"M6.391 20.279a10 10 0 0 1-2.69-2.7\" />", "circle-ellipsis": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"M17 12h.01\" /> <path d=\"M12 12h.01\" /> <path d=\"M7 12h.01\" />", "circle-help": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3\" /> <path d=\"M12 17h.01\" />", "circle-x": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"m15 9-6 6\" /> <path d=\"m9 9 6 6\" />", "clock": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <polyline points=\"12 6 12 12 16 14\" />", "cloud": "<path d=\"M17.5 19H9a7 7 0 1 1 6.71-9h1.79a4.5 4.5 0 1 1 0 9Z\" />", "coins": "<circle cx=\"8\" cy=\"8\" r=\"6\" /> <path d=\"M18.09 10.37A6 6 0 1 1 10.34 18\" /> <path d=\"M7 6h1v4\" /> <path d=\"m16.71 13.88.7.71-2.82 2.82\" />", "cpu": "<rect width=\"16\" height=\"16\" x=\"4\" y=\"4\" rx=\"2\" /> <rect width=\"6\" height=\"6\" x=\"9\" y=\"9\" rx=\"1\" /> <path d=\"M15 2v2\" /> <path d=\"M15 20v2\" /> <path d=\"M2 15h2\" /> <path d=\"M2 9h2\" /> <path d=\"M20 15h2\" /> <path d=\"M20 9h2\" /> <path d=\"M9 2v2\" /> <path d=\"M9 20v2\" />", "credit-card": "<rect width=\"20\" height=\"14\" x=\"2\" y=\"5\" rx=\"2\" /> <line x1=\"2\" x2=\"22\" y1=\"10\" y2=\"10\" />", "database": "<ellipse cx=\"12\" cy=\"5\" rx=\"9\" ry=\"3\" /> <path d=\"M3 5V19A9 3 0 0 0 21 19V5\" /> <path d=\"M3 12A9 3 0 0 0 21 12\" />", "delete": "<path d=\"M10 5a2 2 0 0 0-1.344.519l-6.328 5.74a1 1 0 0 0 0 1.481l6.328 5.741A2 2 0 0 0 10 19h10a2 2 0 0 0 2-2V7a2 2 0 0 0-2-2z\" /> <path d=\"m12 9 6 6\" /> <path d=\"m18 9-6 6\" />", "dumbbell": "<path d=\"M14.4 14.4 9.6 9.6\" /> <path d=\"M18.657 21.485a2 2 0 1 1-2.829-2.828l-1.767 1.768a2 2 0 1 1-2.829-2.829l6.364-6.364a2 2 0 1 1 2.829 2.829l-1.768 1.767a2 2 0 1 1 2.828 2.829z\" /> <path d=\"m21.5 21.5-1.4-1.4\" /> <path d=\"M3.9 3.9 2.5 2.5\" /> <path d=\"M6.404 12.768a2 2 0 1 1-2.829-2.829l1.768-1.767a2 2 0 1 1-2.828-2.829l2.828-2.828a2 2 0 1 1 2.829 2.828l1.767-1.768a2 2 0 1 1 2.829 2.829z\" />", "equal": "<line x1=\"5\" x2=\"19\" y1=\"9\" y2=\"9\" /> <line x1=\"5\" x2=\"19\" y1=\"15\" y2=\"15\" />", "equal-approximately": "<path d=\"M5 15a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0\" /> <path d=\"M5 9a6.5 6.5 0 0 1 7 0 6.5 6.5 0 0 0 7 0\" />", "external-link": "<path d=\"M15 3h6v6\" /> <path d=\"M10 14 21 3\" /> <path d=\"M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6\" />", "eye": "<path d=\"M2.062 12.348a1 1 0 0 1 0-.696 10.75 10.75 0 0 1 19.876 0 1 1 0 0 1 0 .696 10.75 10.75 0 0 1-19.876 0\" /> <circle cx=\"12\" cy=\"12\" r=\"3\" />", "eye-off": "<path d=\"M10.733 5.076a10.744 10.744 0 0 1 11.205 6.575 1 1 0 0 1 0 .696 10.747 10.747 0 0 1-1.444 2.49\" /> <path d=\"M14.084 14.158a3 3 0 0 1-4.242-4.242\" /> <path d=\"M17.479 17.499a10.75 10.75 0 0 1-15.417-5.151 1 1 0 0 1 0-.696 10.75 10.75 0 0 1 4.446-5.143\" /> <path d=\"m2 2 20 20\" />", "file-lock": "<path d=\"M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z\" /> <rect width=\"8\" height=\"6\" x=\"8\" y=\"12\" rx=\"1\" /> <path d=\"M10 12v-2a2 2 0 1 1 4 0v2\" />", "file-spreadsheet": "<path d=\"M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z\" /> <path d=\"M14 2v4a2 2 0 0 0 2 2h4\" /> <path d=\"M8 13h2\" /> <path d=\"M14 13h2\" /> <path d=\"M8 17h2\" /> <path d=\"M14 17h2\" />", "file-text": "<path d=\"M15 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7Z\" /> <path d=\"M14 2v4a2 2 0 0 0 2 2h4\" /> <path d=\"M10 9H8\" /> <path d=\"M16 13H8\" /> <path d=\"M16 17H8\" />", "film": "<rect width=\"18\" height=\"18\" x=\"3\" y=\"3\" rx=\"2\" /> <path d=\"M7 3v18\" /> <path d=\"M3 7.5h4\" /> <path d=\"M3 12h18\" /> <path d=\"M3 16.5h4\" /> <path d=\"M17 3v18\" /> <path d=\"M17 7.5h4\" /> <path d=\"M17 16.5h4\" />", "filter": "<polygon points=\"22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3\" />", "flag": "<path d=\"M4 15s1-1 4-1 5 2 8 2 4-1 4-1V3s-1 1-4 1-5-2-8-2-4 1-4 1z\" /> <line x1=\"4\" x2=\"4\" y1=\"22\" y2=\"15\" />", "folder": "<path d=\"M20 20a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.69-.9L9.6 3.9A2 2 0 0 0 7.93 3H4a2 2 0 0 0-2 2v13a2 2 0 0 0 2 2Z\" />", "folder-open": "<path d=\"m6 14 1.5-2.9A2 2 0 0 1 9.24 10H20a2 2 0 0 1 1.94 2.5l-1.54 6a2 2 0 0 1-1.95 1.5H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h3.9a2 2 0 0 1 1.69.9l.81 1.2a2 2 0 0 0 1.67.9H18a2 2 0 0 1 2 2v2\" />", "gamepad-2": "<line x1=\"6\" x2=\"10\" y1=\"11\" y2=\"11\" /> <line x1=\"8\" x2=\"8\" y1=\"9\" y2=\"13\" /> <line x1=\"15\" x2=\"15.01\" y1=\"12\" y2=\"12\" /> <line x1=\"18\" x2=\"18.01\" y1=\"10\" y2=\"10\" /> <path d=\"M17.32 5H6.68a4 4 0 0 0-3.978 3.59c-.006.052-.01.101-.017.152C2.604 9.416 2 14.456 2 16a3 3 0 0 0 3 3c1 0 1.5-.5 2-1l1.414-1.414A2 2 0 0 1 9.828 16h4.344a2 2 0 0 1 1.414.586L17 18c.5.5 1 1 2 1a3 3 0 0 0 3-3c0-1.545-.604-6.584-.685-7.258-.007-.05-.011-.1-.017-.151A4 4 0 0 0 17.32 5z\" />", "globe": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"M12 2a14.5 14.5 0 0 0 0 20 14.5 14.5 0 0 0 0-20\" /> <path d=\"M2 12h20\" />", "graduation-cap": "<path d=\"M21.42 10.922a1 1 0 0 0-.019-1.838L12.83 5.18a2 2 0 0 0-1.66 0L2.6 9.08a1 1 0 0 0 0 1.832l8.57 3.908a2 2 0 0 0 1.66 0z\" /> <path d=\"M22 10v6\" /> <path d=\"M6 12.5V16a6 3 0 0 0 12 0v-3.5\" />", "grip-vertical": "<circle cx=\"9\" cy=\"12\" r=\"1\" /> <circle cx=\"9\" cy=\"5\" r=\"1\" /> <circle cx=\"9\" cy=\"19\" r=\"1\" /> <circle cx=\"15\" cy=\"12\" r=\"1\" /> <circle cx=\"15\" cy=\"5\" r=\"1\" /> <circle cx=\"15\" cy=\"19\" r=\"1\" />", "hard-drive-download": "<path d=\"M12 2v8\" /> <path d=\"m16 6-4 4-4-4\" /> <rect width=\"20\" height=\"8\" x=\"2\" y=\"14\" rx=\"2\" /> <path d=\"M6 18h.01\" /> <path d=\"M10 18h.01\" />", "heart-pulse": "<path d=\"M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z\" /> <path d=\"M3.22 12H9.5l.5-1 2 4.5 2-7 1.5 3.5h5.27\" />", "history": "<path d=\"M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8\" /> <path d=\"M3 3v5h5\" /> <path d=\"M12 7v5l4 2\" />", "hourglass": "<path d=\"M5 22h14\" /> <path d=\"M5 2h14\" /> <path d=\"M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22\" /> <path d=\"M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2\" />", "house": "<path d=\"M15 21v-8a1 1 0 0 0-1-1h-4a1 1 0 0 0-1 1v8\" /> <path d=\"M3 10a2 2 0 0 1 .709-1.528l7-5.999a2 2 0 0 1 2.582 0l7 5.999A2 2 0 0 1 21 10v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z\" />", "image": "<rect width=\"18\" height=\"18\" x=\"3\" y=\"3\" rx=\"2\" ry=\"2\" /> <circle cx=\"9\" cy=\"9\" r=\"2\" /> <path d=\"m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21\" />", "image-plus": "<path d=\"M16 5h6\" /> <path d=\"M19 2v6\" /> <path d=\"M21 11.5V19a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h7.5\" /> <path d=\"m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21\" /> <circle cx=\"9\" cy=\"9\" r=\"2\" />", "images": "<path d=\"M18 22H4a2 2 0 0 1-2-2V6\" /> <path d=\"m22 13-1.296-1.296a2.41 2.41 0 0 0-3.408 0L11 18\" /> <circle cx=\"12\" cy=\"8\" r=\"2\" /> <rect width=\"16\" height=\"16\" x=\"6\" y=\"2\" rx=\"2\" />", "info": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <path d=\"M12 16v-4\" /> <path d=\"M12 8h.01\" />", "key-round": "<path d=\"M2.586 17.414A2 2 0 0 0 2 18.828V21a1 1 0 0 0 1 1h3a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h1a1 1 0 0 0 1-1v-1a1 1 0 0 1 1-1h.172a2 2 0 0 0 1.414-.586l.814-.814a6.5 6.5 0 1 0-4-4z\" /> <circle cx=\"16.5\" cy=\"7.5\" r=\".5\" fill=\"currentColor\" />", "languages": "<path d=\"m5 8 6 6\" /> <path d=\"m4 14 6-6 2-3\" /> <path d=\"M2 5h12\" /> <path d=\"M7 2h1\" /> <path d=\"m22 22-5-10-5 10\" /> <path d=\"M14 18h6\" />", "layers": "<path d=\"m12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83Z\" /> <path d=\"m22 17.65-9.17 4.16a2 2 0 0 1-1.66 0L2 17.65\" /> <path d=\"m22 12.65-9.17 4.16a2 2 0 0 1-1.66 0L2 12.65\" />", "layout-grid": "<rect width=\"7\" height=\"7\" x=\"3\" y=\"3\" rx=\"1\" /> <rect width=\"7\" height=\"7\" x=\"14\" y=\"3\" rx=\"1\" /> <rect width=\"7\" height=\"7\" x=\"14\" y=\"14\" rx=\"1\" /> <rect width=\"7\" height=\"7\" x=\"3\" y=\"14\" rx=\"1\" />", "lightbulb": "<path d=\"M15 14c.2-1 .7-1.7 1.5-2.5 1-.9 1.5-2.2 1.5-3.5A6 6 0 0 0 6 8c0 1 .2 2.2 1.5 3.5.7.7 1.3 1.5 1.5 2.5\" /> <path d=\"M9 18h6\" /> <path d=\"M10 22h4\" />", "link": "<path d=\"M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71\" /> <path d=\"M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71\" />", "loader-circle": "<path d=\"M21 12a9 9 0 1 1-6.219-8.56\" />", "lock": "<rect width=\"18\" height=\"11\" x=\"3\" y=\"11\" rx=\"2\" ry=\"2\" /> <path d=\"M7 11V7a5 5 0 0 1 10 0v4\" />", "lock-keyhole": "<circle cx=\"12\" cy=\"16\" r=\"1\" /> <rect x=\"3\" y=\"10\" width=\"18\" height=\"12\" rx=\"2\" /> <path d=\"M7 10V7a5 5 0 0 1 10 0v3\" />", "mail": "<rect width=\"20\" height=\"16\" x=\"2\" y=\"4\" rx=\"2\" /> <path d=\"m22 7-8.97 5.7a1.94 1.94 0 0 1-2.06 0L2 7\" />", "minus": "<path d=\"M5 12h14\" />", "music": "<path d=\"M9 18V5l12-2v13\" /> <circle cx=\"6\" cy=\"18\" r=\"3\" /> <circle cx=\"18\" cy=\"16\" r=\"3\" />", "panel-bottom": "<rect width=\"18\" height=\"18\" x=\"3\" y=\"3\" rx=\"2\" /> <path d=\"M3 15h18\" />", "pause": "<rect x=\"14\" y=\"4\" width=\"4\" height=\"16\" rx=\"1\" /> <rect x=\"6\" y=\"4\" width=\"4\" height=\"16\" rx=\"1\" />", "pencil": "<path d=\"M21.174 6.812a1 1 0 0 0-3.986-3.987L3.842 16.174a2 2 0 0 0-.5.83l-1.321 4.352a.5.5 0 0 0 .623.622l4.353-1.32a2 2 0 0 0 .83-.497z\" /> <path d=\"m15 5 4 4\" />", "piggy-bank": "<path d=\"M19 5c-1.5 0-2.8 1.4-3 2-3.5-1.5-11-.3-11 5 0 1.8 0 3 2 4.5V20h4v-2h3v2h4v-4c1-.5 1.7-1 2-2h2v-4h-2c0-1-.5-1.5-1-2V5z\" /> <path d=\"M2 9v1c0 1.1.9 2 2 2h1\" /> <path d=\"M16 11h.01\" />", "play": "<polygon points=\"6 3 20 12 6 21 6 3\" />", "plus": "<path d=\"M5 12h14\" /> <path d=\"M12 5v14\" />", "receipt": "<path d=\"M4 2v20l2-1 2 1 2-1 2 1 2-1 2 1 2-1 2 1V2l-2 1-2-1-2 1-2-1-2 1-2-1-2 1Z\" /> <path d=\"M16 8h-6a2 2 0 1 0 0 4h4a2 2 0 1 1 0 4H8\" /> <path d=\"M12 17.5v-11\" />", "refresh-cw": "<path d=\"M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8\" /> <path d=\"M21 3v5h-5\" /> <path d=\"M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16\" /> <path d=\"M8 16H3v5\" />", "rotate-ccw": "<path d=\"M3 12a9 9 0 1 0 9-9 9.75 9.75 0 0 0-6.74 2.74L3 8\" /> <path d=\"M3 3v5h5\" />", "rotate-cw": "<path d=\"M21 12a9 9 0 1 1-9-9c2.52 0 4.93 1 6.74 2.74L21 8\" /> <path d=\"M21 3v5h-5\" />", "scan": "<path d=\"M3 7V5a2 2 0 0 1 2-2h2\" /> <path d=\"M17 3h2a2 2 0 0 1 2 2v2\" /> <path d=\"M21 17v2a2 2 0 0 1-2 2h-2\" /> <path d=\"M7 21H5a2 2 0 0 1-2-2v-2\" />", "scan-line": "<path d=\"M3 7V5a2 2 0 0 1 2-2h2\" /> <path d=\"M17 3h2a2 2 0 0 1 2 2v2\" /> <path d=\"M21 17v2a2 2 0 0 1-2 2h-2\" /> <path d=\"M7 21H5a2 2 0 0 1-2-2v-2\" /> <path d=\"M7 12h10\" />", "scroll-text": "<path d=\"M15 12h-5\" /> <path d=\"M15 8h-5\" /> <path d=\"M19 17V5a2 2 0 0 0-2-2H4\" /> <path d=\"M8 21h12a2 2 0 0 0 2-2v-1a1 1 0 0 0-1-1H11a1 1 0 0 0-1 1v1a2 2 0 1 1-4 0V5a2 2 0 1 0-4 0v2a1 1 0 0 0 1 1h3\" />", "search": "<circle cx=\"11\" cy=\"11\" r=\"8\" /> <path d=\"m21 21-4.3-4.3\" />", "search-x": "<path d=\"m13.5 8.5-5 5\" /> <path d=\"m8.5 8.5 5 5\" /> <circle cx=\"11\" cy=\"11\" r=\"8\" /> <path d=\"m21 21-4.3-4.3\" />", "settings": "<path d=\"M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z\" /> <circle cx=\"12\" cy=\"12\" r=\"3\" />", "shapes": "<path d=\"M8.3 10a.7.7 0 0 1-.626-1.079L11.4 3a.7.7 0 0 1 1.198-.043L16.3 8.9a.7.7 0 0 1-.572 1.1Z\" /> <rect x=\"3\" y=\"14\" width=\"7\" height=\"7\" rx=\"1\" /> <circle cx=\"17.5\" cy=\"17.5\" r=\"3.5\" />", "share": "<path d=\"M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8\" /> <polyline points=\"16 6 12 2 8 6\" /> <line x1=\"12\" x2=\"12\" y1=\"2\" y2=\"15\" />", "shield": "<path d=\"M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z\" />", "shield-check": "<path d=\"M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z\" /> <path d=\"m9 12 2 2 4-4\" />", "signal": "<path d=\"M2 20h.01\" /> <path d=\"M7 20v-4\" /> <path d=\"M12 20v-8\" /> <path d=\"M17 20V8\" /> <path d=\"M22 4v16\" />", "sliders-horizontal": "<line x1=\"21\" x2=\"14\" y1=\"4\" y2=\"4\" /> <line x1=\"10\" x2=\"3\" y1=\"4\" y2=\"4\" /> <line x1=\"21\" x2=\"12\" y1=\"12\" y2=\"12\" /> <line x1=\"8\" x2=\"3\" y1=\"12\" y2=\"12\" /> <line x1=\"21\" x2=\"16\" y1=\"20\" y2=\"20\" /> <line x1=\"12\" x2=\"3\" y1=\"20\" y2=\"20\" /> <line x1=\"14\" x2=\"14\" y1=\"2\" y2=\"6\" /> <line x1=\"8\" x2=\"8\" y1=\"10\" y2=\"14\" /> <line x1=\"16\" x2=\"16\" y1=\"18\" y2=\"22\" />", "smartphone": "<rect width=\"14\" height=\"20\" x=\"5\" y=\"2\" rx=\"2\" ry=\"2\" /> <path d=\"M12 18h.01\" />", "sparkles": "<path d=\"M9.937 15.5A2 2 0 0 0 8.5 14.063l-6.135-1.582a.5.5 0 0 1 0-.962L8.5 9.936A2 2 0 0 0 9.937 8.5l1.582-6.135a.5.5 0 0 1 .963 0L14.063 8.5A2 2 0 0 0 15.5 9.937l6.135 1.581a.5.5 0 0 1 0 .964L15.5 14.063a2 2 0 0 0-1.437 1.437l-1.582 6.135a.5.5 0 0 1-.963 0z\" /> <path d=\"M20 3v4\" /> <path d=\"M22 5h-4\" /> <path d=\"M4 17v2\" /> <path d=\"M5 18H3\" />", "star": "<path d=\"M11.525 2.295a.53.53 0 0 1 .95 0l2.31 4.679a2.123 2.123 0 0 0 1.595 1.16l5.166.756a.53.53 0 0 1 .294.904l-3.736 3.638a2.123 2.123 0 0 0-.611 1.878l.882 5.14a.53.53 0 0 1-.771.56l-4.618-2.428a2.122 2.122 0 0 0-1.973 0L6.396 21.01a.53.53 0 0 1-.77-.56l.881-5.139a2.122 2.122 0 0 0-.611-1.879L2.16 9.795a.53.53 0 0 1 .294-.906l5.165-.755a2.122 2.122 0 0 0 1.597-1.16z\" />", "store": "<path d=\"m2 7 4.41-4.41A2 2 0 0 1 7.83 2h8.34a2 2 0 0 1 1.42.59L22 7\" /> <path d=\"M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8\" /> <path d=\"M15 22v-4a2 2 0 0 0-2-2h-2a2 2 0 0 0-2 2v4\" /> <path d=\"M2 7h20\" /> <path d=\"M22 7v3a2 2 0 0 1-2 2a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 16 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 12 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 8 12a2.7 2.7 0 0 1-1.59-.63.7.7 0 0 0-.82 0A2.7 2.7 0 0 1 4 12a2 2 0 0 1-2-2V7\" />", "sun-moon": "<path d=\"M12 8a2.83 2.83 0 0 0 4 4 4 4 0 1 1-4-4\" /> <path d=\"M12 2v2\" /> <path d=\"M12 20v2\" /> <path d=\"m4.9 4.9 1.4 1.4\" /> <path d=\"m17.7 17.7 1.4 1.4\" /> <path d=\"M2 12h2\" /> <path d=\"M20 12h2\" /> <path d=\"m6.3 17.7-1.4 1.4\" /> <path d=\"m19.1 4.9-1.4 1.4\" />", "tag": "<path d=\"M12.586 2.586A2 2 0 0 0 11.172 2H4a2 2 0 0 0-2 2v7.172a2 2 0 0 0 .586 1.414l8.704 8.704a2.426 2.426 0 0 0 3.42 0l6.58-6.58a2.426 2.426 0 0 0 0-3.42z\" /> <circle cx=\"7.5\" cy=\"7.5\" r=\".5\" fill=\"currentColor\" />", "target": "<circle cx=\"12\" cy=\"12\" r=\"10\" /> <circle cx=\"12\" cy=\"12\" r=\"6\" /> <circle cx=\"12\" cy=\"12\" r=\"2\" />", "thumbs-down": "<path d=\"M17 14V2\" /> <path d=\"M9 18.12 10 14H4.17a2 2 0 0 1-1.92-2.56l2.33-8A2 2 0 0 1 6.5 2H20a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2h-2.76a2 2 0 0 0-1.79 1.11L12 22a3.13 3.13 0 0 1-3-3.88Z\" />", "thumbs-up": "<path d=\"M7 10v12\" /> <path d=\"M15 5.88 14 10h5.83a2 2 0 0 1 1.92 2.56l-2.33 8A2 2 0 0 1 17.5 22H4a2 2 0 0 1-2-2v-8a2 2 0 0 1 2-2h2.76a2 2 0 0 0 1.79-1.11L12 2a3.13 3.13 0 0 1 3 3.88Z\" />", "trash-2": "<path d=\"M3 6h18\" /> <path d=\"M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6\" /> <path d=\"M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2\" /> <line x1=\"10\" x2=\"10\" y1=\"11\" y2=\"17\" /> <line x1=\"14\" x2=\"14\" y1=\"11\" y2=\"17\" />", "trending-down": "<polyline points=\"22 17 13.5 8.5 8.5 13.5 2 7\" /> <polyline points=\"16 17 22 17 22 11\" />", "trending-up": "<polyline points=\"22 7 13.5 15.5 8.5 10.5 2 17\" /> <polyline points=\"16 7 22 7 22 13\" />", "triangle-alert": "<path d=\"m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3\" /> <path d=\"M12 9v4\" /> <path d=\"M12 17h.01\" />", "users": "<path d=\"M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2\" /> <circle cx=\"9\" cy=\"7\" r=\"4\" /> <path d=\"M22 21v-2a4 4 0 0 0-3-3.87\" /> <path d=\"M16 3.13a4 4 0 0 1 0 7.75\" />", "users-round": "<path d=\"M18 21a8 8 0 0 0-16 0\" /> <circle cx=\"10\" cy=\"8\" r=\"5\" /> <path d=\"M22 20c0-3.37-2-6.5-4-8a5 5 0 0 0-.45-8.3\" />", "wallet": "<path d=\"M19 7V4a1 1 0 0 0-1-1H5a2 2 0 0 0 0 4h15a1 1 0 0 1 1 1v4h-3a2 2 0 0 0 0 4h3a1 1 0 0 0 1-1v-2a1 1 0 0 0-1-1\" /> <path d=\"M3 5v14a2 2 0 0 0 2 2h15a1 1 0 0 0 1-1v-4\" />", "wifi-off": "<path d=\"M12 20h.01\" /> <path d=\"M8.5 16.429a5 5 0 0 1 7 0\" /> <path d=\"M5 12.859a10 10 0 0 1 5.17-2.69\" /> <path d=\"M19 12.859a10 10 0 0 0-2.007-1.523\" /> <path d=\"M2 8.82a15 15 0 0 1 4.177-2.643\" /> <path d=\"M22 8.82a15 15 0 0 0-11.288-3.764\" /> <path d=\"m2 2 20 20\" />", "zap-off": "<path d=\"M10.513 4.856 13.12 2.17a.5.5 0 0 1 .86.46l-1.377 4.317\" /> <path d=\"M15.656 10H20a1 1 0 0 1 .78 1.63l-1.72 1.773\" /> <path d=\"M16.273 16.273 10.88 21.83a.5.5 0 0 1-.86-.46l1.92-6.02A1 1 0 0 0 11 14H4a1 1 0 0 1-.78-1.63l4.507-4.643\" /> <path d=\"m2 2 20 20\" />", "x": "<path d=\"M18 6 6 18\" /> <path d=\"m6 6 12 12\" />"};
var TODAY = new Date(2026, 10, 10);
var LANG = 'en', SIZE = 390, SCALE = 1;
var USD_VND = 26350;
function t(en, vi) { return LANG === 'vi' && vi != null ? vi : en; }
function P() { return LANG === 'vi' ? 'VND' : 'USD'; }

/* ---------- dates ---------- */
var MON = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
var MONTH_EN = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
var DOW = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'], DOW_VI = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
function D(s) { if (typeof s !== 'string') return new Date(s); var p = s.split('-'); return new Date(+p[0], +p[1] - 1, +p[2]); }
function iso(x) { return x.getFullYear() + '-' + ('0' + (x.getMonth() + 1)).slice(-2) + '-' + ('0' + x.getDate()).slice(-2); }
function days(s) { return Math.round((D(s) - TODAY) / 864e5); }
function addM(x, n) { var y = new Date(x), d = y.getDate(); y.setDate(1); y.setMonth(y.getMonth() + n); y.setDate(Math.min(d, new Date(y.getFullYear(), y.getMonth() + 1, 0).getDate())); return y; }
function dim(y, m) { return new Date(y, m + 1, 0).getDate(); }
/* 'dm' 15 Nov · 'dmy' 15 Nov 2026 · 'wdm' Sun, 15 Nov · 'my' Nov 2026 · 'mshort' Nov */
function fd(s, style) {
  var x = D(s), y = x.getFullYear(), dd = x.getDate(), m = x.getMonth();
  style = style || 'dm';
  if (LANG === 'vi') {
    if (style === 'my') return 'Tháng ' + (m + 1) + ', ' + y;
    if (style === 'mshort') return 'Thg ' + (m + 1);
    var b = dd + ' thg ' + (m + 1);
    if (style === 'num') return ('0' + dd).slice(-2) + '/' + ('0' + (m + 1)).slice(-2) + '/' + y;
    if (style === 'dm') return b + (y !== 2026 ? ', ' + y : '');
    if (style === 'dmy') return b + ', ' + y;
    if (style === 'wdm') return DOW_VI[x.getDay()] + ', ' + b;
    return b;
  }
  if (style === 'my') return MONTH_EN[m] + ' ' + y;
  if (style === 'mshort') return MON[m];
  if (style === 'num') return dd + ' ' + MON[m] + ' ' + y;
  var b2 = dd + ' ' + MON[m];
  if (style === 'dm') return b2 + (y !== 2026 ? ' ' + y : '');
  if (style === 'dmy') return b2 + ' ' + y;
  if (style === 'wdm') return DOW[x.getDay()] + ', ' + b2;
  return b2;
}
function monthName(m, short) { return LANG === 'vi' ? (short ? 'Thg ' : 'Tháng ') + (m + 1) : (short ? MON[m] : MONTH_EN[m]); }
function left(s) { var n = days(s); return n === 0 ? t('Today', 'Hôm nay') : n === 1 ? t('Tomorrow', 'Ngày mai') : n < 0 ? t(-n + ' days ago', -n + ' ngày trước') : t(n + ' days left', 'Còn ' + n + ' ngày'); }
function inN(s) { var n = days(s); return n === 0 ? t('today', 'hôm nay') : n === 1 ? t('tomorrow', 'ngày mai') : t('in ' + n + ' days', 'sau ' + n + ' ngày'); }

/* ---------- money ---------- */
function r2(v) { return P() === 'VND' ? Math.round(v) : Math.round(v * 100) / 100; }
function money(v, cur, o) {
  cur = cur || P(); o = o || {};
  var neg = v < 0, a = Math.abs(v), s;
  if (cur === 'USD') s = '$' + a.toLocaleString('en-US', { minimumFractionDigits: o.whole ? 0 : 2, maximumFractionDigits: o.whole ? 0 : 2 });
  else { var n = Math.round(a); s = LANG === 'vi' ? n.toLocaleString('vi-VN') + ' ₫' : '₫' + n.toLocaleString('en-US'); }
  return (neg ? '−' : o.sign ? '+' : '') + s;
}
function toP(v, cur) { var p = P(); if (cur === p) return v; return cur === 'USD' ? v * USD_VND : v / USD_VND; }
function approx(v, cur) { return (cur && cur !== P() ? '≈ ' : '') + money(v, cur); }

/* ---------- sample data ---------- */
/* cycle: [n, unit] unit d|w|m|y · kind: lib (library logo) | custom (monogram) | photo (user image) */
var EN_SUBS = [
  { id: 'netflix', name: 'Netflix', plan: 'Standard', color: '#e50914', mono: 'N', kind: 'lib', price: 17.99, cur: 'USD', cyc: [1, 'm'], cat: 'video', status: 'active', due: '2026-11-15', started: '2023-05-15', method: 'Visa ••4821', labels: ['family'], worth: 'yes', hist: [{ from: '2026-10-15', old: 15.49, nw: 17.99, src: 'lib' }], host: 'netflix.com' },
  { id: 'spotify', name: 'Spotify', plan: 'Premium', color: '#1db954', mono: 'S', kind: 'lib', price: 11.99, cur: 'USD', cyc: [1, 'm'], cat: 'music', status: 'trial', due: '2026-11-13', started: '2026-10-13', method: 'PayPal', labels: [], host: 'spotify.com' },
  { id: 'youtube', name: 'YouTube Premium', plan: 'Family', color: '#ff0033', mono: 'YT', kind: 'lib', price: 22.99, cur: 'USD', cyc: [1, 'm'], cat: 'video', status: 'active', share: 5, due: '2026-11-18', started: '2024-08-18', method: 'Visa ••4821', labels: ['family'], worth: 'unsure', host: 'youtube.com' },
  { id: 'chatgpt', name: 'ChatGPT', plan: 'Plus', color: '#10a37f', mono: 'C', kind: 'lib', price: 20, cur: 'USD', cyc: [1, 'm'], cat: 'ai', status: 'active', due: '2026-11-12', started: '2024-03-12', method: 'Visa ••4821', labels: ['work'], worth: 'yes', hist: [{ from: '2026-03-12', old: 19, nw: 20, src: 'you' }], host: 'chatgpt.com' },
  { id: 'claude', name: 'Claude', plan: 'Pro', color: '#d97757', mono: 'C', kind: 'lib', price: 20, cur: 'USD', cyc: [1, 'm'], cat: 'ai', status: 'active', due: '2026-11-08', awaiting: true, started: '2026-06-08', method: 'Visa ••4821', labels: ['work'], worth: 'yes', host: 'claude.ai' },
  { id: 'icloud', name: 'iCloud+', plan: '200 GB', color: '#3693f3', mono: 'iC', kind: 'lib', price: 2.99, cur: 'USD', cyc: [1, 'm'], cat: 'storage', status: 'active', due: '2026-12-05', started: '2024-12-05', method: 'Apple Pay', labels: [], worth: 'yes', host: 'apple.com' },
  { id: 'gym', name: 'Gym', plan: '', color: '#e8590c', mono: 'G', kind: 'photo', price: 39, cur: 'USD', cyc: [1, 'm'], cat: 'health', status: 'active', due: '2026-12-01', started: '2024-11-01', method: 'Visa ••4821', labels: ['health'], worth: 'unsure' },
  { id: 'disney', name: 'Disney+', plan: 'Standard', color: '#113ccf', mono: 'D+', kind: 'lib', price: 9.99, cur: 'USD', cyc: [1, 'm'], cat: 'video', status: 'active', due: '2026-11-21', pauseFrom: '2026-11-21', started: '2024-11-21', method: 'PayPal', labels: [], worth: 'no', host: 'disneyplus.com' },
  { id: 'gone', name: 'Google One', plan: '2 TB', color: '#1a73e8', mono: 'G1', kind: 'lib', price: 99.99, cur: 'USD', cyc: [1, 'y'], cat: 'storage', status: 'active', due: '2027-03-20', started: '2024-03-20', method: 'Google Play', labels: [], worth: 'yes', host: 'one.google.com' },
  { id: 'canva', name: 'Canva', plan: 'Pro', color: '#7d2ae8', mono: 'Ca', kind: 'lib', price: 120, cur: 'USD', cyc: [1, 'y'], cat: 'software', status: 'active', due: '2027-02-02', started: '2026-02-02', method: 'Visa ••4821', labels: ['work'], worth: 'no', host: 'canva.com' },
  { id: 'duolingo', name: 'Duolingo', plan: 'Super', color: '#58cc02', mono: 'D', kind: 'lib', price: 59.99, cur: 'USD', cyc: [1, 'y'], cat: 'education', status: 'cancelled', cancelled: '2026-10-12', due: '2026-10-12', started: '2024-10-12', method: 'Google Play', labels: [] },
  { id: 'applemusic', name: 'Apple Music', plan: 'Individual', color: '#fa2d48', mono: 'AM', kind: 'lib', price: 10.99, cur: 'USD', cyc: [1, 'm'], cat: 'music', status: 'cancelled', cancelled: '2026-10-20', due: '2026-10-20', started: '2024-04-20', method: 'Apple Pay', labels: [] }
];
var VI_SUBS = [
  { id: 'netflix', name: 'Netflix', plan: 'Premium', color: '#e50914', mono: 'N', kind: 'lib', price: 260000, cur: 'VND', cyc: [1, 'm'], cat: 'video', status: 'active', due: '2026-11-15', started: '2025-05-15', method: 'Visa ••4821', labels: ['family'], worth: 'yes', hist: [{ from: '2026-10-15', old: 220000, nw: 260000, src: 'lib' }], host: 'netflix.com' },
  { id: 'spotify', name: 'Spotify', plan: 'Premium', color: '#1db954', mono: 'S', kind: 'lib', price: 65000, cur: 'VND', cyc: [1, 'm'], cat: 'music', status: 'trial', due: '2026-11-13', started: '2026-10-13', method: 'MoMo', labels: [], host: 'spotify.com' },
  { id: 'youtube', name: 'YouTube Premium', plan: 'Gia đình', color: '#ff0033', mono: 'YT', kind: 'lib', price: 179000, cur: 'VND', cyc: [1, 'm'], cat: 'video', status: 'active', share: 5, due: '2026-11-18', started: '2024-08-18', method: 'Visa ••4821', labels: ['family'], worth: 'unsure', host: 'youtube.com' },
  { id: 'chatgpt', name: 'ChatGPT', plan: 'Plus', color: '#10a37f', mono: 'C', kind: 'lib', price: 20, cur: 'USD', cyc: [1, 'm'], cat: 'ai', status: 'active', due: '2026-11-12', started: '2024-03-12', method: 'Visa ••4821', labels: ['work'], worth: 'yes', hist: [{ from: '2026-03-12', old: 19, nw: 20, src: 'you' }], host: 'chatgpt.com' },
  { id: 'claude', name: 'Claude', plan: 'Pro', color: '#d97757', mono: 'C', kind: 'lib', price: 599000, cur: 'VND', cyc: [1, 'm'], cat: 'ai', status: 'active', due: '2026-11-08', awaiting: true, started: '2026-06-08', method: 'Visa ••4821', labels: ['work'], worth: 'yes', host: 'claude.ai' },
  { id: 'icloud', name: 'iCloud+', plan: '200 GB', color: '#3693f3', mono: 'iC', kind: 'lib', price: 89000, cur: 'VND', cyc: [1, 'm'], cat: 'storage', status: 'active', due: '2026-12-05', started: '2024-12-05', method: 'Apple Pay', labels: [], worth: 'yes', host: 'apple.com' },
  { id: 'gym', name: 'Gym', plan: '', color: '#e8590c', mono: 'G', kind: 'photo', price: 299000, cur: 'VND', cyc: [1, 'm'], cat: 'health', status: 'active', due: '2026-12-01', started: '2025-11-01', method: 'MoMo', labels: ['health'], worth: 'unsure' },
  { id: 'viettel', name: 'Viettel 5G', plan: 'V120', color: '#d6002e', mono: 'V', kind: 'lib', price: 150000, cur: 'VND', cyc: [1, 'm'], cat: 'telecom', status: 'active', due: '2026-11-20', started: '2025-05-20', method: 'MoMo', labels: [], worth: 'yes', host: 'viettel.vn' },
  { id: 'gone', name: 'Google One', plan: '2 TB', color: '#1a73e8', mono: 'G1', kind: 'lib', price: 1690000, cur: 'VND', cyc: [1, 'y'], cat: 'storage', status: 'active', due: '2027-03-20', started: '2024-03-20', method: 'Google Play', labels: [], worth: 'yes', host: 'one.google.com' },
  { id: 'canva', name: 'Canva', plan: 'Pro', color: '#7d2ae8', mono: 'Ca', kind: 'lib', price: 1390000, cur: 'VND', cyc: [1, 'y'], cat: 'software', status: 'active', due: '2027-02-02', started: '2026-02-02', method: 'Visa ••4821', labels: ['work'], worth: 'no', host: 'canva.com' },
  { id: 'duolingo', name: 'Duolingo', plan: 'Super', color: '#58cc02', mono: 'D', kind: 'lib', price: 699000, cur: 'VND', cyc: [1, 'y'], cat: 'education', status: 'cancelled', cancelled: '2026-10-12', due: '2026-10-12', started: '2025-10-12', method: 'Google Play', labels: [] }
];
var LABELS = { family: ['Family', 'Gia đình', '#d9468f'], work: ['Work', 'Công việc', '#2856d8'], health: ['Health', 'Sức khoẻ', '#1f9d55'], trip: ['Trip', 'Du lịch', '#e8590c'] };
var CATS = ['video', 'music', 'ai', 'storage', 'software', 'games', 'reading', 'health', 'education', 'telecom', 'other'];
var CAT_IC = { video: 'film', music: 'music', ai: 'bot', storage: 'cloud', software: 'cpu', games: 'gamepad-2', reading: 'book-open', health: 'heart-pulse', education: 'graduation-cap', telecom: 'signal', other: 'circle-ellipsis' };
var CAT_COL = { video: 'var(--chart-5)', music: 'var(--tile-violet)', ai: 'var(--chart-1)', storage: 'var(--chart-2)', software: 'var(--chart-4)', health: 'var(--chart-3)', telecom: 'var(--tile-sky)', education: 'var(--chart-other)', games: 'var(--chart-other)', reading: 'var(--chart-other)', other: 'var(--chart-other)' };
function catName(c) {
  return ({ all: t('All', 'Tất cả'), video: 'Video', music: t('Music', 'Nhạc'), ai: 'AI', storage: t('Storage', 'Lưu trữ'), software: t('Software', 'Phần mềm'), telecom: t('Telecom', 'Viễn thông'),
    education: t('Learning', 'Học tập'), games: t('Games', 'Game'), reading: t('Reading', 'Đọc'), health: t('Health', 'Sức khoẻ'), other: t('Other', 'Khác') })[c] || c;
}
function BUD() { return LANG === 'vi' ? { total: 3500000, cats: { ai: 1000000, video: 600000, storage: 300000, health: 300000, telecom: 200000, software: 150000 } } : { total: 160, cats: { ai: 35, video: 30, storage: 15, health: 40, music: 15, software: 10 } }; }

/* scenarios tweak a fresh copy */
function data(scn) {
  var d = JSON.parse(JSON.stringify(LANG === 'vi' ? VI_SUBS : EN_SUBS));
  var by = function (id) { return d.filter(function (s) { return s.id === id; })[0] || {}; };
  scn = scn || 'default';
  if (scn === 'empty') return [];
  if (scn === 'paidClaude' || scn === 'allConfirmed') { var c = by('claude'); c.awaiting = false; c.due = '2026-12-08'; c.paidNow = true; }
  if (scn === 'many') { var c2 = by('claude'); c2.due = '2026-10-08'; by('chatgpt').due = '2026-11-12'; }
  if (scn === 'trialKept') by('spotify').kept = true;
  if (scn === 'disneyPaused') { var ds = by('disney'); ds.status = 'paused'; ds.pausedFrom = '2026-10-21'; ds.pauseFrom = null; ds.due = '2026-10-21'; }
  if (scn === 'netflixAdded') { d = d.filter(function (s) { return s.id !== 'netflix'; }); }
  if (scn === 'gymNew') { by('gym').isNew = true; }
  if (scn === 'netflixNew') { var nf = by('netflix'); nf.isNew = true; nf.plan = 'Premium'; nf.price = LANG === 'vi' ? 260000 : 24.99; nf.share = 4; nf.hist = null; nf.started = '2026-11-10'; nf.due = '2026-12-10'; }
  if (scn === 'netflixRaised') { var n2 = by('netflix'); n2.hist = n2.hist.concat([{ from: '2026-12-15', old: n2.price, nw: LANG === 'vi' ? 280000 : 19.99, src: 'you', future: true }]); }
  if (scn === 'canvaCancelled') { var cv = by('canva'); cv.status = 'cancelled'; cv.cancelled = '2026-11-10'; }
  if (scn === 'firstMonth') { d = d.filter(function (s) { return ['netflix', 'spotify', 'chatgpt', 'icloud'].indexOf(s.id) >= 0; }); d.forEach(function (s) { s.started = s.id === 'spotify' ? s.started : '2026-11-0' + (s.id === 'icloud' ? 5 : 2); if (s.id === 'icloud') s.due = '2026-12-05'; s.hist = null; }); }
  if (scn === 'yearOnly') { d = d.filter(function (s) { return s.cyc[1] === 'y'; }); }
  return d;
}
function subOf(id, scn) { return data(scn).filter(function (s) { return s.id === id; })[0]; }

/* ---------- rules (§3) ---------- */
function cycMonths(s) { var n = s.cyc[0], u = s.cyc[1]; return u === 'y' ? 12 * n : u === 'm' ? n : u === 'w' ? n * 12 / 52 : n * 12 / 365; }
function step(x, s, k) { var n = s.cyc[0] * k, u = s.cyc[1]; if (u === 'm') return addM(x, n); if (u === 'y') return addM(x, 12 * n); var y = new Date(x); y.setDate(y.getDate() + (u === 'w' ? 7 * n : n)); return y; }
function priceAt(s, when) {
  var p = s.price, w = D(when);
  (s.hist || []).slice().reverse().forEach(function (h) { if (w < D(h.from)) p = h.old; });
  if (s.hist) { var last = s.hist[s.hist.length - 1]; if (last.future && w >= D(last.from)) p = last.nw; }
  return p;
}
function myShare(s, when) { return (when ? priceAt(s, when) : s.price) / (s.share || 1); }
function monthlyCost(s, when) { return r2(toP(myShare(s, when), s.cur) / cycMonths(s)); }
function yearlyCost(s) { return r2(toP(myShare(s), s.cur) * 12 / cycMonths(s)); }
function chargeStart(s) { return D(s.status === 'trial' ? s.due : s.started); }
/* every charge date of a subscription (paid, waiting or upcoming), clipped to [a, b) */
function events(s, a, b) {
  var out = [], due = D(s.due), x, k, stop = s.cancelled ? D(s.cancelled) : s.pausedFrom ? D(s.pausedFrom) : null, pf = s.pauseFrom ? D(s.pauseFrom) : null;
  for (k = 1; k < 400; k++) { x = step(due, s, -k); if (x < chargeStart(s) || x < a) break; if (x < b && (!stop || x < stop)) out.push({ s: s, d: x, st: 'paid', amt: r2(toP(myShare(s, x), s.cur)) }); }
  if (s.status !== 'cancelled' && s.status !== 'paused') {
    for (k = 0; k < 400; k++) {
      x = step(due, s, k); if (x >= b) break; if (pf && x >= pf) break;
      if (x >= a && x >= chargeStart(s)) out.push({ s: s, d: x, st: s.awaiting && x <= TODAY ? 'wait' : x < TODAY ? 'paid' : 'up', amt: r2(toP(myShare(s, x), s.cur)) });
    }
  }
  return out.sort(function (p, q) { return p.d - q.d; });
}
function allEvents(subs, a, b) { var o = []; subs.forEach(function (s) { o = o.concat(events(s, a, b)); }); return o.sort(function (p, q) { return p.d - q.d || p.s.name.localeCompare(q.s.name); }); }
/* Month spend (§3.11) */
function activeIn(s, y, m) {
  var a = new Date(y, m, 1), e = new Date(y, m + 1, 0);
  if (chargeStart(s) > e) return false;
  if (s.cancelled && D(s.cancelled) < a) return false;
  if (s.pausedFrom && D(s.pausedFrom) <= a) return false;
  if (s.pauseFrom && D(s.pauseFrom) <= a) return false;
  return true;
}
function monthLines(subs, y, m) {
  return subs.filter(function (s) { return activeIn(s, y, m); }).map(function (s) {
    var dd = Math.min(D(s.due).getDate(), dim(y, m));
    return { s: s, v: monthlyCost(s, new Date(y, m, dd)) };
  });
}
function monthSpend(subs, y, m) { return r2(monthLines(subs, y, m).reduce(function (a, l) { return a + l.v; }, 0)); }
function yearSpend(subs, y) { var v = 0; for (var m = 0; m < 12; m++) v += monthSpend(subs, y, m); return r2(v); }
/* Month cash flow (§3.12) */
function monthCash(subs, y, m) {
  var ev = allEvents(subs, new Date(y, m, 1), new Date(y, m + 1, 1)), paid = 0, due = 0;
  ev.forEach(function (e) { if (e.st === 'paid') paid += e.amt; else due += e.amt; });
  return { ev: ev, paid: r2(paid), due: r2(due) };
}
function savings(subs) { return r2(subs.filter(function (s) { return s.status === 'cancelled'; }).reduce(function (a, s) { return a + yearlyCost(s); }, 0)); }
function riseOf(s) { var then = addM(TODAY, -12), a = toP(myShare(s, then), s.cur) / cycMonths(s), b = toP(myShare(s), s.cur) / cycMonths(s); return r2(b - a); }
function rises(subs) { return subs.filter(function (s) { return s.status !== 'cancelled' && s.started <= iso(addM(TODAY, -12)) && riseOf(s) > 0; }).sort(function (a, b) { return riseOf(b) - riseOf(a); }); }
function recentRise(s) { return (s.hist || []).some(function (h) { return !h.future && h.nw > h.old && days(h.from) > -90 && days(h.from) <= 0; }); }
function forecast(subs) {
  var a = TODAY, b = addM(TODAY, 12), a0 = addM(TODAY, -12);
  var next = allEvents(subs, a, b).filter(function (e) { return e.st !== 'paid'; }), last = allEvents(subs, a0, a).filter(function (e) { return e.st === 'paid'; });
  var N = r2(next.reduce(function (x, e) { return x + e.amt; }, 0)), L = r2(last.reduce(function (x, e) { return x + e.amt; }, 0));
  var newSubs = subs.filter(function (s) { return s.status !== 'cancelled' && s.status !== 'paused' && !s.pauseFrom && chargeStart(s) > a0; });
  var nNew = r2(newSubs.reduce(function (x, s) { return x + next.filter(function (e) { return e.s === s; }).reduce(function (y, e) { return y + e.amt; }, 0) - last.filter(function (e) { return e.s === s; }).reduce(function (y, e) { return y + e.amt; }, 0); }, 0));
  var rs = rises(subs), nRise = r2(rs.reduce(function (x, s) { return x + riseOf(s) * 12; }, 0));
  var gone = subs.filter(function (s) { return s.status === 'cancelled' || s.status === 'paused' || s.pauseFrom; });
  var nGone = r2(gone.reduce(function (x, s) { return x + next.filter(function (e) { return e.s === s; }).reduce(function (y, e) { return y + e.amt; }, 0) - last.filter(function (e) { return e.s === s; }).reduce(function (y, e) { return y + e.amt; }, 0); }, 0));
  var other = r2(N - L - nNew - nRise - nGone);
  var top = newSubs.slice().sort(function (p, q) { return yearlyCost(q) - yearlyCost(p); })[0];
  return { next: N, last: L, diff: r2(N - L), nNew: nNew, cNew: newSubs.length, nRise: nRise, cRise: rs.length, nGone: nGone, cGone: gone.length, other: other, top: top, ev: next };
}

/* ---------- text helpers ---------- */
function cycText(s) {
  var n = s.cyc[0], u = s.cyc[1];
  if (n === 1) return ({ d: t('Daily', 'Hằng ngày'), w: t('Weekly', 'Hằng tuần'), m: t('Monthly', 'Hằng tháng'), y: t('Yearly', 'Hằng năm') })[u];
  if (u === 'm' && n === 3) return t('Quarterly', 'Hằng quý');
  return t('Every ' + n + ' ' + ({ d: 'days', w: 'weeks', m: 'months', y: 'years' })[u], 'Mỗi ' + n + ' ' + ({ d: 'ngày', w: 'tuần', m: 'tháng', y: 'năm' })[u]);
}
function perTxt(s) { return s.cyc[1] === 'y' ? t('/yr', '/năm') : s.cyc[1] === 'w' ? t('/wk', '/tuần') : t('/mo', '/tháng'); }
function fullName(s) { return s.name + (s.plan ? ' ' + s.plan : ''); }
function worthName(w) { return ({ yes: t('Worth it', 'Đáng'), unsure: t('Unsure', 'Phân vân'), no: t('Not worth it', 'Không đáng') })[w] || t('Not rated', 'Chưa đánh giá'); }
function worthIcon(w) { return ({ yes: 'thumbs-up', unsure: 'circle-help', no: 'thumbs-down' })[w] || 'circle-dashed'; }
function nsub(n) { return n + t(n === 1 ? ' subscription' : ' subscriptions', ' gói'); }

/* ---------- atoms ---------- */
function icon(name, size, cls) {
  return '<svg class="ic ' + (cls || '') + '" width="' + (size || 20) + '" height="' + (size || 20) + '" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">' + (ICONS[name] || '') + '</svg>';
}
/* Service logo: library services sit on a soft plate tinted by brand colour (the bundled logo goes here; mocks show a
   stand-in mark), custom services are a solid monogram, user photos fill the same squircle. badge: trial|wait|pause */
function logo(s, size, badge) {
  var k = s.kind || 'lib', cls = 'lg lg' + size + ' lg-' + k + (s.status === 'cancelled' ? ' off' : '');
  var inner = k === 'photo' ? '<span class="lg-photo"><i class="ph-a"></i><i class="ph-b"></i>' + icon('dumbbell', Math.round(size * .46)) + '</span>'
    : '<span class="lg-mark' + (s.mono.length > 1 ? ' two' : '') + '">' + s.mono + '</span>';
  var b = badge === 'trial' ? '<span class="lg-b b-trial">' + icon('hourglass', 10) + '</span>' : badge === 'wait' ? '<span class="lg-b b-wait">' + icon('clock', 10) + '</span>' : badge === 'pause' ? '<span class="lg-b b-pause">' + icon('pause', 10) + '</span>' : '';
  return '<span class="' + cls + '" style="--c:' + s.color + '" role="img" aria-label="' + s.name + '">' + inner + b + '</span>';
}
function autoBadge(s) { return s && s.status === 'trial' ? '' : ''; }
function badgeOf(s) { return s.status === 'trial' ? 'trial' : s.awaiting ? 'wait' : s.status === 'paused' ? 'pause' : ''; }
function cyc(s, o) { return '<span class="cyc' + (o === 'on' ? ' on' : '') + '">' + cycText(s) + '</span>'; }
function cycT(txt) { return '<span class="cyc">' + txt + '</span>'; }
function delta(v, o) { o = o || {}; if (Math.abs(v) < 0.005) return '<span class="delta same">' + icon('equal', 13) + t('Same as ', 'Bằng ') + (o.vs || '').replace(/^(vs|so với) /, '') + '</span>'; var up = v > 0; return '<span class="delta ' + (up ? 'isup' : 'isdown') + '">' + icon(up ? 'arrow-up' : 'arrow-down', 13) + money(Math.abs(v), o.cur, o) + (o.vs ? ' ' + o.vs : '') + '</span>'; }
function btn(label, o) {
  o = o || {};
  return '<button class="btn btn-' + (o.kind || 'primary') + (o.sm ? ' sm' : '') + (o.block ? ' block' : '') + (o.cls ? ' ' + o.cls : '') + '"' + (o.go ? ' data-go="' + o.go + '"' : '') + '>' +
    (o.icon ? icon(o.icon, o.sm ? 16 : 20) : '') + label + (o.trail ? icon(o.trail, 16) : '') + '</button>';
}
function chip(label, on, ic) { return '<span class="chip' + (on ? ' on' : '') + '">' + (on && ic !== false ? icon(ic || 'check', 16) : (ic && ic !== true ? icon(ic, 16) : '')) + label + '</span>'; }
function seg(items, on, cls, gos) { return '<div class="' + (cls || 'seg') + '" role="tablist">' + items.map(function (x, i) { return '<button role="tab" aria-selected="' + (i === on) + '" class="' + (i === on ? 'on' : '') + '"' + (gos && gos[i] ? ' data-go="' + gos[i] + '"' : '') + '>' + x + '</button>'; }).join('') + '</div>'; }
function toggle(on, lbl) { return '<span class="toggle' + (on ? ' on' : '') + '" role="switch" aria-checked="' + !!on + '"' + (lbl ? ' aria-label="' + lbl + '"' : '') + '><i></i></span>'; }
function stepper(n) { return '<span class="stepper"><button aria-label="' + t('Fewer', 'Bớt') + '">' + icon('minus', 18) + '</button><span class="v num">' + n + '</span><button aria-label="' + t('More', 'Thêm') + '">' + icon('plus', 18) + '</button></span>'; }
function badge(kind, ic, label) { return '<span class="badge badge-' + kind + '">' + (ic ? icon(ic, 13) : '') + label + '</span>'; }
function awaitBadge() { return badge('warn', 'clock', t('To confirm', 'Chờ xác nhận')); }
function banner(kind, ic, title, body, action) {
  return '<div class="banner banner-' + kind + '"><span class="banner-ic">' + icon(ic, 20) + '</span><span class="grow"><span class="label">' + title + '</span>' +
    (body ? '<span class="meta banner-body">' + body + '</span>' : '') + '</span>' + (action ? '<span class="banner-act"' + (action.go ? ' data-go="' + action.go + '"' : '') + '>' + action.label + '</span>' : '') + '</div>';
}
function empty(o) {
  return '<div class="empty">' + (o.art || art('nest', 160)) + '<h2 class="title">' + o.title + '</h2>' + (o.body ? '<p class="body muted">' + o.body + '</p>' : '') +
    (o.action ? btn(o.action, { icon: o.actionIcon || 'plus', go: o.go }) : '') + '</div>';
}
function setRow(o) {
  return '<div class="srow' + (o.danger ? ' danger' : '') + (o.cls ? ' ' + o.cls : '') + '"' + (o.go ? ' data-go="' + o.go + '"' : '') + '>' + (o.icon ? '<span class="srow-ic">' + icon(o.icon, 20) + '</span>' : (o.lead || '')) +
    '<span class="grow"><span class="srow-l">' + o.label + '</span>' + (o.sub ? '<span class="meta muted">' + o.sub + '</span>' : '') + '</span>' +
    (o.value ? '<span class="srow-v">' + o.value + '</span>' : '') + (o.right || '') + (o.chevron !== false && !o.right ? icon(o.ext ? 'external-link' : 'chevron-right', 18, 'muted') : '') + '</div>';
}
function group(rows, head, cls) { return (head ? '<div class="caption eyebrow grp-head">' + head + '</div>' : '') + '<div class="group' + (cls ? ' ' + cls : '') + '">' + rows.join('') + '</div>'; }
function dialog(title, body, actions) {
  return '<div class="dim"></div><div class="dialog" role="alertdialog"><h2 class="title">' + title + '</h2><div class="body muted dlg-body">' + body + '</div><div class="dlg-actions">' + actions.join('') + '</div></div>';
}
function sheet(inner, o) { o = o || {}; return (o.dim === false ? '' : '<div class="dim"></div>') + '<section class="sheet' + (o.cls ? ' ' + o.cls : '') + '" role="dialog"><div class="grabber"></div>' + inner + '</section>'; }
function toast(text, ic, action) { return '<div class="toast" role="status">' + icon(ic || 'circle-check', 18) + '<span class="grow">' + text + '</span>' + (action ? '<button class="toast-act">' + action + '</button>' : '') + '</div>'; }
function lbl(id) { var L = LABELS[id]; return '<span class="lbl"><i style="background:' + L[2] + '"></i>' + t(L[0], L[1]) + '</span>'; }
function info(go) { return '<button class="info-b" aria-label="' + t('How this is calculated', 'Cách tính') + '"' + (go ? ' data-go="' + go + '"' : '') + '>' + icon('info', 16) + '</button>'; }
function pbar(p, cls) { return '<span class="pbar' + (cls ? ' ' + cls : '') + '"><i style="width:' + Math.round(p * 100) + '%"></i></span>'; }
function keyboard(kind) {
  if (kind === 'num') return '<div class="kb num" aria-hidden="true">' + ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'].map(function (k) { return '<span class="kb-k' + (k ? '' : ' blank') + '">' + k + '</span>'; }).join('') + '</div>';
  var r = ['qwertyuiop', 'asdfghjkl', 'zxcvbnm'];
  return '<div class="kb" aria-hidden="true">' + r.map(function (row, i) {
    return '<div class="kb-row">' + (i === 2 ? '<span class="kb-k kb-w">⇧</span>' : '') + row.split('').map(function (c) { return '<span class="kb-k">' + c + '</span>'; }).join('') + (i === 2 ? '<span class="kb-k kb-w">⌫</span>' : '') + '</div>';
  }).join('') + '<div class="kb-row"><span class="kb-k kb-w">123</span><span class="kb-k kb-sp">' + t('space', 'dấu cách') + '</span><span class="kb-k kb-w kb-go">' + t('search', 'tìm') + '</span></div></div>';
}
function overlay(ph, extra) { var i = ph.lastIndexOf('<span class="home-ind'); return ph.slice(0, i) + extra + ph.slice(i); }
function unwrap(h) { var a = h.indexOf('</div>', h.indexOf('class="sb')) ; var start = h.indexOf('<', a + 6); var end = h.lastIndexOf('<span class="home-ind'); return h.slice(start, end); }

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
  return '<div class="phone' + (SIZE === 360 ? ' s360' : '') + (SIZE === 320 ? ' s320' : '') + (SCALE > 1 ? ' t130' : '') + (SCALE > 1.5 ? ' t200' : '') + (o.cls ? ' ' + o.cls : '') + '" lang="' + LANG + '">' + SB(o.sb) + inner + (o.tab === false || o.tab == null ? '' : tabbar(o.tab)) + '<span class="home-ind' + (o.sb && o.sb.light ? ' on-dark' : '') + '"></span></div>';
}
function nav(title, o) {
  o = o || {};
  return '<header class="nav' + (o.cls ? ' ' + o.cls : '') + '"><button class="icon-btn" data-go="' + (o.backGo || 'back') + '" aria-label="' + (o.close ? t('Close', 'Đóng') : t('Back', 'Quay lại')) + '">' + icon(o.close ? 'x' : 'chevron-left', 24) + '</button>' +
    '<h1 class="title-sm">' + title + '</h1>' + (o.right || '<span></span>') + '</header>';
}
function largeTop(title, eyebrow, right) {
  return '<header class="top"><div>' + (eyebrow ? '<div class="meta muted">' + eyebrow + '</div>' : '') + '<h1 class="headline">' + title + '</h1></div>' + (right || '') + '</header>';
}
function fab(go) { return '<button class="fab" data-go="' + (go || 'fab') + '" aria-label="' + t('Add subscription', 'Thêm gói đăng ký') + '">' + icon('plus', 26) + '</button>'; }

/* ---------------- Overview (tab 1) ---------------- */
var SCR = {};
function todayLine() { return LANG === 'vi' ? 'Thứ Ba, 10 tháng 11' : 'Tuesday, 10 November'; }

/* month columns: n months ending at (y, m); highlight the last; future months hatched */
function monthCols(subs, y, m, n, o) {
  o = o || {};
  var vals = [];
  for (var i = n - 1; i >= 0; i--) { var x = addM(new Date(y, m, 1), -i); vals.push([x.getFullYear(), x.getMonth(), monthSpend(subs, x.getFullYear(), x.getMonth())]); }
  if (o.forward) { vals = []; for (var j = 0; j < n; j++) { var z = addM(new Date(y, 0, 1), j); vals.push([z.getFullYear(), z.getMonth(), monthSpend(subs, z.getFullYear(), z.getMonth())]); } }
  var max = Math.max.apply(null, vals.map(function (v) { return v[2]; })) || 1;
  return '<div class="mcols' + (o.cls ? ' ' + o.cls : '') + '" role="img" aria-label="' + t('Monthly cost, last ' + n + ' months', 'Chi phí ' + n + ' tháng gần nhất') + '">' + vals.map(function (v) {
    var sel = o.sel ? (v[0] === o.sel[0] && v[1] === o.sel[1]) : (v[0] === y && v[1] === m), fut = new Date(v[0], v[1], 1) > TODAY;
    return '<span class="mc' + (sel ? ' on' : '') + (fut ? ' fut' : '') + '" data-go="col" data-tip="' + monthName(v[1], true) + ' · ' + money(v[2]) + '"><span class="mc-v num">' + (sel ? money(v[2], null, { whole: P() === 'USD' && v[2] >= 1000 }) : '&nbsp;') + '</span><span class="mc-b"><i style="height:' + Math.max(4, Math.round(v[2] / max * 100)) + '%"></i></span><span class="mc-l">' + monthName(v[1], true) + '</span></span>';
  }).join('') + '</div>';
}
function cashBar(paid, due, o) {
  o = o || {};
  var tot = paid + due || 1;
  return '<div class="cash"><div class="cash-rows"><span class="cash-r"><i class="dot paid"></i>' + t('Paid', 'Đã thanh toán') + '<b class="num">' + money(paid) + '</b></span>' +
    '<span class="cash-r"><i class="dot due"></i>' + (o.past ? t('Not paid', 'Không trả') : t('Still to pay', 'Còn phải thanh toán')) + '<b class="num">' + money(due) + '</b></span></div>' +
    '<span class="cbar" role="img" aria-label="' + t('Paid ', 'Đã thanh toán ') + money(paid) + ', ' + t('still to pay ', 'còn phải thanh toán ') + money(due) + '"><i class="paid" style="flex:' + paid + '"></i><i class="due" style="flex:' + due + '"></i></span>' +
    (o.range ? '<span class="meta muted cash-range">' + o.range + '</span>' : '') + '</div>';
}
/* §4.2.1 cost card */
function costCard(subs, o) {
  o = o || {};
  var y = 2026, m = 10, yr = o.year;
  var act = subs.filter(function (s) { return activeIn(s, y, m) && s.status !== 'cancelled'; }).length;
  var big, dlt, sub, cash, cols, range;
  if (!yr) {
    big = monthSpend(subs, y, m); var prev = monthSpend(subs, y, m - 1);
    dlt = o.first ? '' : delta(r2(big - prev), { vs: t('vs Oct', 'so với thg 10') });
    sub = t(act + ' active subscription' + (act === 1 ? '' : 's'), act + ' gói đang hoạt động') + ' · ≈ <b class="num">' + money(r2(big / 30)) + '</b> ' + t('a day', 'mỗi ngày');
    var c = monthCash(subs, y, m); cash = cashBar(c.paid, c.due, { range: t('1 Nov to 30 Nov', '1 thg 11 đến 30 thg 11') });
    cols = monthCols(subs, y, m, o.first ? 2 : 6);
  } else {
    big = yearSpend(subs, y); var py = yearSpend(subs, y - 1);
    dlt = delta(r2(big - py), { vs: t('vs 2025', 'so với 2025'), whole: false });
    sub = t('2026 · ≈ ', 'Năm 2026 · ≈ ') + '<b class="num">' + money(r2(big / 12)) + '</b> ' + t('a month', 'mỗi tháng');
    var ev = allEvents(subs, new Date(y, 0, 1), new Date(y + 1, 0, 1)), pd = 0, du = 0;
    ev.forEach(function (e) { if (e.st === 'paid') pd += e.amt; else du += e.amt; });
    cash = cashBar(r2(pd), r2(du), { range: t('1 Jan to 31 Dec 2026', '1 thg 1 đến 31 thg 12, 2026') });
    cols = monthCols(subs, y, 0, 12, { forward: true, sel: [2026, 10], cls: 'twelve' });
  }
  return '<section class="costcard" data-total="' + big + '">' +
    seg([t('Monthly cost', 'Chi phí hàng tháng'), t('Yearly cost', 'Chi phí hàng năm')], yr ? 1 : 0, 'seg cc-seg', ['month', 'year']) +
    '<div class="cc-top">' + (dlt || '<span class="meta muted">' + t('First month — no comparison yet', 'Tháng đầu — chưa có để so sánh') + '</span>') + '</div>' +
    '<div class="cc-big"><span class="display num"><span class="approx">≈</span>' + money(big) + '</span>' + info('info') + '</div>' +
    '<div class="meta muted cc-sub">' + sub + '</div>' + cash + cols + '</section>';
}
function pendingCard(subs) {
  var w = subs.filter(function (s) { return s.awaiting; }); if (!w.length) return '';
  var ev = allEvents(w, new Date(2025, 0, 1), addM(TODAY, 1)).filter(function (e) { return e.st === 'wait'; }), n = ev.length, sum = r2(ev.reduce(function (a, e) { return a + e.amt; }, 0));
  return '<a class="card card-warn" data-go="pending"><span class="warn-ic">' + icon('clock', 20) + '</span>' +
    '<span class="grow"><span class="title-sm">' + t(n + ' payment' + (n > 1 ? 's' : '') + ' to confirm', n + ' khoản cần xác nhận') + '</span><span class="avs">' + w.map(function (s) { return logo(s, 24); }).join('') + '<span class="meta warn-sub num">' + money(sum) + '</span></span></span>' +
    '<span class="chip-btn warn">' + t('Review', 'Xem') + '</span></a>';
}
function trialCard(s) {
  return '<div class="card trial3"><div class="tr-top"><span class="tr-ic">' + icon('hourglass', 20) + '</span><span class="grow"><span class="title-sm">' + t(s.name + ' trial ends in ' + days(s.due) + ' days', 'Dùng thử ' + s.name + ' kết thúc trong ' + days(s.due) + ' ngày') + '</span>' +
    '<span class="meta muted">' + t('Then ', 'Sẽ có giá ') + '<b class="num ink">' + money(s.price, s.cur) + '</b>' + t(' on ', ' vào ') + fd(s.due) + ' ' + cyc(s) + '</span></span>' + logo(s, 40) + '</div>' +
    '<div class="tr-save">' + icon('piggy-bank', 16) + '<span>' + t('Cancel before it charges to save ', 'Huỷ trước khi tính phí sẽ tiết kiệm ') + '<b class="num">' + money(yearlyCost(s)) + '</b>' + t(' a year', ' mỗi năm') + '</span></div>' +
    '<div class="tr-btns">' + btn(t('Keep it', 'Giữ lại'), { sm: true, go: 'keep' }) + btn(t('View', 'Xem gói'), { sm: true, kind: 'tonal', go: 'trial' }) + btn(t('How to cancel', 'Cách huỷ'), { sm: true, kind: 'text', trail: 'external-link', go: 'howcancel' }) + '</div></div>';
}
function noticeCard() {
  var yt = subOf('youtube'), nw = LANG === 'vi' ? 199000 : 25.99;
  return '<div class="card notice"><div class="tr-top">' + logo(yt, 40) + '<span class="grow"><span class="title-sm">' + t('YouTube Premium changed its price', 'YouTube Premium đổi giá') + '</span>' +
    '<span class="meta muted num">' + money(yt.price, yt.cur) + ' → <b class="ink">' + money(nw, yt.cur) + '</b> ' + cyc(yt) + '</span></span></div>' +
    '<div class="meta muted nt-note">' + t('Your share goes from ', 'Phần của bạn từ ') + money(yt.price / 5, yt.cur) + t(' to ', ' lên ') + money(nw / 5, yt.cur) + t(', from the 18 Nov renewal.', ', từ kỳ 18/11.') + '</div>' +
    '<div class="tr-btns">' + btn(t('Update', 'Cập nhật'), { sm: true, kind: 'tonal', go: 'priceupdate' }) + btn(t('Keep old price', 'Giữ giá cũ'), { sm: true, kind: 'text' }) + '</div></div>';
}
function upCard(e) {
  var s = e.s, w = e.st === 'wait', today = days(iso(e.d)) === 0;
  return '<div class="upc' + (w ? ' wait' : '') + (today ? ' today' : '') + '" data-go="detail-' + s.id + '">' + logo(s, 40, w ? 'wait' : s.status === 'trial' ? 'trial' : '') +
    '<span class="upc-n ell">' + s.name + '</span><span class="upc-p num">' + money(r2(myShare(s, e.d)), s.cur) + '</span>' + cyc(s) +
    '<span class="upc-t' + (w ? ' warn-t' : '') + '">' + (w ? t('To confirm', 'Chờ xác nhận') : s.status === 'trial' && iso(e.d) === s.due ? t('First charge · ', 'Lần trừ đầu · ') + left(iso(e.d)).toLowerCase() : left(iso(e.d))) + '</span>' +
    (w || today ? '<button class="upc-ok" data-go="confirm" aria-label="' + t('Mark paid', 'Đánh dấu đã trả') + '">' + icon('check', 18) + '</button>' : '') + '</div>';
}
function upcoming(subs) {
  var ev = allEvents(subs, TODAY, addM(TODAY, 1)).filter(function (e) { return e.st !== 'paid'; }), sum = r2(ev.reduce(function (a, e) { return a + e.amt; }, 0));
  var w = subs.filter(function (s) { return s.awaiting; }).map(function (s) { return { s: s, d: D(s.due), st: 'wait', amt: r2(toP(myShare(s), s.cur)) }; });
  return '<section class="sec"><div class="sec-h"><h2 class="title-sm">' + t('Upcoming payments', 'Thanh toán sắp tới') + '</h2><a class="link label" data-go="agenda">' + t('See all', 'Xem tất cả') + '</a></div>' +
    '<div class="meta muted sec-sub">' + t('Next 30 days: ≈ ', '30 ngày tới: ≈ ') + '<b class="num ink">' + money(sum) + '</b>' + t(' in ' + ev.length + ' charges', ' trong ' + ev.length + ' lần tính phí') + '</div>' +
    '<div class="hstrip">' + w.concat(ev).map(upCard).join('') + '</div></section>';
}
function budgetBar(subs) {
  var b = BUD(), v = monthSpend(subs, 2026, 10), p = v / b.total;
  return '<a class="card budget2" data-go="budgets"><div class="bd-top"><span class="label">' + t('Budget', 'Ngân sách') + '</span><span class="meta muted num">' + money(v) + t(' of ', ' / ') + money(b.total, null, { whole: true }) + '</span><span class="bd-pct' + (p > 1 ? ' over' : p > .85 ? ' near' : '') + '">' + Math.round(p * 100) + '%</span>' + icon('chevron-right', 18, 'muted') + '</div>' +
    pbar(Math.min(1, p), p > 1 ? 'over' : p > .85 ? 'near' : '') + '<span class="meta muted">' + t('1 category over budget: AI', '1 danh mục vượt ngân sách: AI') + '</span></a>';
}
/* §4.2.7 subscription row */
function row(s, o) {
  o = o || {};
  var cancelled = s.status === 'cancelled', paused = s.status === 'paused', trial = s.status === 'trial', w = s.awaiting;
  var today = !cancelled && !paused && days(s.due) === 0;
  var sub = [];
  if (cancelled) sub.push(t('Cancelled ', 'Đã huỷ ') + fd(s.cancelled, 'num'));
  else if (paused) sub.push(t('Paused since ', 'Tạm dừng từ ') + fd(s.pausedFrom));
  else if (s.pauseFrom) sub.push('<span class="pz">' + icon('pause', 12) + t('Pauses ', 'Tạm dừng từ ') + fd(s.pauseFrom) + '</span>');
  else if (w) sub.push('<span class="warn-t wt">' + icon('clock', 12) + t('To confirm · ', 'Chờ xác nhận · ') + fd(s.due) + '</span>');
  else sub.push((trial ? t('Trial · ', 'Dùng thử · ') : '') + left(s.due) + ' · ' + fd(s.due));
  if (!cancelled && s.method && !o.short) sub.push(s.method.split(' ')[0]);
  var nameB = (trial ? '<span class="tag tag-trial">' + t('TRIAL', 'DÙNG THỬ') + '</span>' : '') + (s.auto ? '<span class="tag tag-auto">' + icon('sparkles', 11) + t('Auto', 'Tự động') + '</span>' : '') ;
  var pct = cancelled || paused ? 0 : Math.max(0, Math.min(1, 1 - days(s.due) / (cycMonths(s) * 30.4)));
  var amt = '<span class="r-p num">' + (recentRise(s) ? '<span class="rise" title="' + t('Price went up', 'Giá vừa tăng') + '">' + icon('arrow-up', 13) + '</span>' : '') + money(s.share ? myShare(s) : s.price, s.cur) + '</span>' + cyc(s) +
    (s.cur !== P() ? '<span class="meta muted num">≈ ' + money(toP(myShare(s), s.cur)) + '</span>' : '') + (s.share ? '<span class="meta muted r-sh">' + icon('users', 12) + '÷' + s.share + '</span>' : '');
  return '<div class="row2' + (cancelled || paused ? ' is-off' : '') + (today ? ' today' : '') + (w ? ' wait' : '') + (s.isNew ? ' is-new' : '') + (o.swipe ? ' swiped' : '') + '" data-go="detail-' + s.id + '">' +
    (o.swipe ? '<span class="swa"><span class="swb ok">' + icon('check', 20) + t('Confirm', 'Xác nhận') + '</span><span class="swb no">' + icon('ban', 20) + t('Cancel', 'Huỷ') + '</span></span>' : '') +
    '<span class="row2-in">' + logo(s, 40, badgeOf(s)) + '<span class="r-main"><span class="r-name"><span class="title-sm ell">' + fullName(s) + '</span>' + nameB + '</span><span class="meta muted r-sub">' + sub.join(' · ') + '</span>' +
    ((s.labels || []).length && !cancelled ? '<span class="lbls">' + lbl(s.labels[0]) + (s.labels.length > 1 ? '<span class="lbl more">+' + (s.labels.length - 1) + '</span>' : '') + '</span>' : '') +
    (pct ? pbar(pct, w ? 'warn' : trial ? 'trial' : '') : '') + '</span><span class="r-amt">' + amt + '</span></span></div>';
}
function listTabs(subs, on) {
  var c = function (st) { return subs.filter(function (s) { return st === 'active' ? s.status === 'active' : s.status === st; }).length; };
  return seg([t('Active', 'Đang trả') + ' <em>' + c('active') + '</em>', t('Trial', 'Dùng thử') + ' <em>' + c('trial') + '</em>', t('Paused', 'Tạm dừng') + ' <em>' + c('paused') + '</em>', t('Cancelled', 'Đã huỷ') + ' <em>' + c('cancelled') + '</em>'], on, 'seg seg4');
}
function listSec(subs, o) {
  o = o || {};
  var tab = o.tab || 0, st = ['active', 'trial', 'paused', 'cancelled'][tab];
  var list = subs.filter(function (s) { return s.status === st; }).sort(function (a, b) { return D(a.due) - D(b.due); });
  if (o.filtered) list = list.filter(function (s) { return s.labels.indexOf('work') >= 0; });
  var h = '<section class="sec sec-subs"><div class="sec-h"><h2 class="title-sm">' + t('Subscriptions', 'Gói đăng ký') + '</h2><span class="sec-tools">' +
    '<button class="icon-btn sm" data-go="search" aria-label="' + t('Search', 'Tìm') + '">' + icon('search', 20) + '</button>' +
    '<button class="icon-btn sm' + (o.filtered ? ' on' : '') + '" data-go="filter" aria-label="' + t('Filter', 'Lọc') + '">' + icon('sliders-horizontal', 20) + (o.filtered ? '<span class="fcount">1</span>' : '') + '</button>' +
    '<button class="sort-b" data-go="sort" aria-label="' + t('Sort: next payment', 'Sắp xếp: thanh toán tiếp theo') + '">' + icon('arrow-up-down', 16) + t('Sort', 'Sắp xếp') + '</button></span></div>' + listTabs(subs, tab);
  if (o.filtered) h += '<div class="fchips">' + '<span class="chip on">' + icon('tag', 14) + t('Work', 'Công việc') + icon('x', 14) + '</span><button class="link label">' + t('Clear', 'Xoá lọc') + '</button></div>';
  if (st === 'cancelled') h += '<div class="save-head">' + icon('piggy-bank', 20) + '<span>' + t('You’re saving ', 'Bạn đang tiết kiệm ') + '<b class="num">' + money(savings(subs)) + '</b>' + t(' a year', '/năm') + '</span></div>';
  if (!list.length) h += '<div class="list-empty meta muted">' + (st === 'paused' ? t('Nothing paused. Pause a subscription from its detail page — it stops counting from its next due date.', 'Không có gói tạm dừng. Tạm dừng từ trang chi tiết — gói ngừng tính từ ngày thanh toán kế tiếp.') : t('Nothing here.', 'Không có gì ở đây.')) + '</div>';
  h += '<div class="group rows">' + list.map(function (s, i) { return row(s, { swipe: o.swipe && i === 0 }); }).join('') + '</div></section>';
  return h;
}
function notifBanner() { return '<div class="top-banner">' + banner('neutral', 'bell-off', t('Reminders are off', 'Nhắc nhở đang tắt'), t('You won’t hear about renewals or trials ending.', 'Bạn sẽ không được nhắc trước kỳ gia hạn hay khi hết dùng thử.'), { label: t('Turn on', 'Bật lại'), go: 'notif' }) + '</div>'; }

/* o: { year, notice, offline, notifOff, sheet: info|filter|sort, toast, tab, filtered, swipe, raw, tbHidden } */
SCR.overview = function (scn, o) {
  o = o || {};
  var subs = data(scn);
  var head = largeTop(t('Overview', 'Tổng quan'), todayLine(), '<button class="icon-btn" aria-label="' + t('Search', 'Tìm') + '" data-go="search">' + icon('search', 22) + '</button>');
  var h;
  if (!subs.length) {
    h = '<div class="scroll">' + head + (o.notifOff ? notifBanner() : '') +
      '<section class="costcard zero">' + seg([t('Monthly cost', 'Chi phí hàng tháng'), t('Yearly cost', 'Chi phí hàng năm')], 0, 'seg cc-seg') + '<div class="cc-big"><span class="display num">' + money(0) + '</span></div><div class="meta muted cc-sub">' + t('No subscriptions yet', 'Chưa có gói nào') + '</div></section>' +
      empty({ art: art('empty', 180), title: t('Add your first subscription', 'Thêm gói đầu tiên'), body: t('Pick from 500+ services with their logos and prices — most take three taps.', 'Chọn từ hơn 500 dịch vụ có sẵn logo và giá — thường chỉ 3 chạm.'), action: t('Browse services', 'Xem thư viện dịch vụ'), actionIcon: 'layout-grid', go: 'fab' }) + '</div>' + fab();
    return o.raw ? h : phone(h, { tab: 0 });
  }
  h = '<div class="scroll ov">' + head + (o.notifOff ? notifBanner() : '') + costCard(subs, { year: o.year, first: scn === 'firstMonth' }) +
    (o.offline ? '<div class="stale">' + icon('wifi-off', 14) + t('Offline · exchange rates from 3 days ago', 'Offline · tỷ giá cập nhật 3 ngày trước') + '</div>' : '') +
    '<section class="stack">' + pendingCard(subs) + (subs.filter(function (s) { return s.status === 'trial' && !s.kept && days(s.due) <= 7; }).map(trialCard).join('')) + (o.notice ? noticeCard() : '') + '</section>' +
    upcoming(subs) + budgetBar(subs) + listSec(subs, o) + '</div>' + fab();
  if (o.toast) h += toast(Array.isArray(o.toast) ? t(o.toast[0], o.toast[1]) : o.toast, o.toastIcon, o.undo ? t('Undo', 'Hoàn tác') : '');
  if (o.sheet === 'info') h += infoSheet();
  if (o.sheet === 'filter') h += filterSheet();
  if (o.sheet === 'sort') h += sortSheet();
  if (o.raw) return h;
  return phone(h, { tab: 0, sb: { offline: o.offline }, cls: o.tbHidden ? 'tb-hidden' : '' });
};
function infoSheet() {
  return sheet('<h2 class="title sh-title">' + t('How the numbers work', 'Cách tính các con số') + '</h2>' +
    '<div class="ex"><span class="ex-ic">' + icon('calendar-range', 20) + '</span><span class="grow"><span class="label">' + t('Monthly cost', 'Chi phí hàng tháng') + '</span><span class="meta muted">' + t('Every subscription active this month, spread evenly: a yearly plan counts as 1/12 each month. A trial counts from its first paid month; a pause stops it from the month after.', 'Mọi gói đang trả trong tháng, chia đều: gói năm tính 1/12 mỗi tháng. Dùng thử chỉ tính từ tháng trả phí đầu; tạm dừng thì ngừng tính từ tháng sau.') + '</span></span></div>' +
    '<div class="ex"><span class="ex-ic">' + icon('wallet', 20) + '</span><span class="grow"><span class="label">' + t('Paid · Still to pay', 'Đã thanh toán · Còn phải thanh toán') + '</span><span class="meta muted">' + t('The real money leaving this month: payments you confirmed, plus renewals still ahead and periods waiting for you. A yearly plan renewing this month counts in full.', 'Tiền thật bị trừ trong tháng: các khoản đã xác nhận, cộng kỳ sắp tới và kỳ đang chờ. Gói năm gia hạn trong tháng tính đủ giá năm.') + '</span></span></div>' +
    '<div class="ex"><span class="ex-ic">' + icon('equal-approximately', 20) + '</span><span class="grow"><span class="label">' + t('Why ≈', 'Vì sao có ≈') + '</span><span class="meta muted">' + t('Other currencies are converted at today’s rate and rounded per line, so the lines always add up to the total.', 'Tiền tệ khác được quy đổi theo tỷ giá hôm nay và làm tròn từng dòng, nên các dòng luôn cộng đúng bằng tổng.') + '</span></span></div>' +
    '<div class="info-note">' + icon('info', 16) + '<span>' + t('That’s why Paid + Still to pay can differ from the monthly cost.', 'Vì vậy Đã + Còn phải thanh toán có thể khác Chi phí hàng tháng.') + '</span></div>' +
    '<div class="sh-actions mt16">' + btn(t('Got it', 'Đã hiểu'), { block: true, kind: 'tonal' }) + '</div>');
}
function filterSheet() {
  var sec = function (h, items) { return '<div class="caption eyebrow grp-head">' + h + '</div><div class="chips">' + items.join('') + '</div>'; };
  return sheet('<div class="sh-row"><h2 class="title">' + t('Filter', 'Lọc') + '</h2><button class="link label">' + t('Reset', 'Đặt lại') + '</button></div>' +
    sec(t('Status', 'Trạng thái'), [chip(t('Active', 'Đang trả'), true), chip(t('Trial', 'Dùng thử')), chip(t('Paused', 'Tạm dừng')), chip(t('Cancelled', 'Đã huỷ'))]) +
    sec(t('Category', 'Danh mục'), ['video', 'music', 'ai', 'storage', 'software', 'health'].map(function (c) { return chip(catName(c), c === 'ai'); })) +
    sec(t('Labels', 'Nhãn'), Object.keys(LABELS).map(function (k) { return '<span class="chip' + (k === 'work' ? ' on' : '') + '">' + (k === 'work' ? icon('check', 16) : '<i class="ldot" style="background:' + LABELS[k][2] + '"></i>') + t(LABELS[k][0], LABELS[k][1]) + '</span>'; })) +
    sec(t('Payment method', 'Phương thức thanh toán'), ['Visa ••4821', 'PayPal', 'Apple Pay', 'Google Play'].map(function (m) { return chip(m); })) +
    '<p class="meta muted sh-note">' + icon('info', 14, 'inl') + ' ' + t('Subnest remembers your filter and sort.', 'Subnest nhớ bộ lọc và cách sắp xếp của bạn.') + '</p>' +
    '<div class="sh-actions">' + btn(t('Show 2 subscriptions', 'Hiện 2 gói'), { block: true }) + '</div>', { cls: 'tall' });
}
function sortSheet() {
  var it = [[t('Next payment', 'Thanh toán tiếp theo'), 'calendar-days'], [t('Price', 'Giá'), 'coins'], [t('Name', 'Tên'), 'arrow-down-a-z'], [t('Recently added', 'Mới thêm'), 'clock']];
  return sheet('<h2 class="title sh-title">' + t('Sort by', 'Sắp xếp theo') + '</h2><div class="group">' + it.map(function (x, i) { return '<div class="plan' + (i === 0 ? ' on' : '') + '"><span class="radio"></span><span class="srow-ic">' + icon(x[1], 20) + '</span><span class="grow"><span class="title-sm">' + x[0] + '</span></span></div>'; }).join('') + '</div>');
}
SCR.search = function () {
  var subs = data(), q = 'net', hits = subs.filter(function (s) { return /net|dis/i.test(s.name); });
  return phone('<header class="nav search-nav"><div class="input grow-in focus">' + icon('search', 18, 'muted') + '<span class="search-q">' + q + '</span><span class="caret sm"></span></div><button class="link label" data-go="back">' + t('Cancel', 'Huỷ') + '</button></header>' +
    '<div class="scroll"><div class="caption eyebrow grp-head">' + t('Your subscriptions', 'Gói của bạn') + '</div><div class="group rows">' + hits.slice(0, 1).map(function (s) { return row(s); }).join('') + '</div>' +
    '<div class="caption eyebrow grp-head">' + t('Add from the library', 'Thêm từ thư viện') + '</div><div class="group">' + LIBG().filter(function (l) { return /net/i.test(l[1]); }).slice(0, 2).map(function (l) { return libRow(l); }).join('') + '</div></div>' + keyboard());
};

/* ---------------- Launch, onboarding, library, form ---------------- */
SCR.splash = function () { return phone('<div class="splash">' + mark(120) + '<div class="splash-word">Subnest</div></div>', { sb: { light: true }, cls: 'is-splash' }); };
/* PIN lock (§4.0) — o: { n: digits typed, err, forgot } */
SCR.pin = function (o) {
  o = o || {};
  var n = o.n == null ? 2 : o.n;
  var h = '<div class="pinw">' + mark(56) + '<h1 class="title">' + (o.mode === 'set' ? t('Choose a 4-digit PIN', 'Đặt mã PIN 4 số') : o.mode === 'confirm' ? t('Enter it again', 'Nhập lại mã PIN') : t('Enter your PIN', 'Nhập mã PIN')) + '</h1>' +
    '<div class="pin-dots' + (o.err ? ' err' : '') + '">' + [0, 1, 2, 3].map(function (i) { return '<i class="' + (i < n ? 'on' : '') + '"></i>'; }).join('') + '</div>' +
    '<p class="meta ' + (o.err ? 'danger-t' : 'muted') + ' pin-msg">' + (o.err ? t('Wrong PIN. Try again.', 'Sai mã PIN. Thử lại.') : o.mode === 'set' ? t('You’ll enter it when Subnest opens, and after 1 minute away.', 'Bạn sẽ nhập khi mở Subnest và khi quay lại sau 1 phút.') : '&nbsp;') + '</p>' +
    '<div class="pinpad">' + ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'].map(function (k) { return k === 'del' ? '<button class="pk ic" aria-label="' + t('Delete', 'Xoá') + '">' + icon('delete', 26) + '</button>' : k === '' ? '<span></span>' : '<button class="pk num"' + (k === '7' ? ' data-go="pin"' : '') + '>' + k + '</button>'; }).join('') + '</div>' +
    (o.mode ? '' : '<button class="btn btn-text" data-go="forgot">' + t('Forgot PIN?', 'Quên mã?') + '</button>') + '</div>';
  if (o.forgot) h += dialog(t('Forgot your PIN?', 'Quên mã PIN?'), t('Subnest has no account and no server, so the PIN can’t be reset. The only way back in is to erase all data on this phone and start fresh. A backup file can be restored afterwards.', 'Subnest không có tài khoản hay máy chủ nên không thể đặt lại PIN. Cách duy nhất là xoá toàn bộ dữ liệu trên máy và bắt đầu lại. Sau đó bạn có thể khôi phục từ file sao lưu.'),
    [btn(t('Erase all data', 'Xoá toàn bộ dữ liệu'), { kind: 'danger', block: true }), btn(t('Try again', 'Thử lại'), { kind: 'text', block: true })]);
  return phone(h, { cls: o.mode ? '' : 'is-lock' });
};
function obProgress(step, skip) {
  return '<div class="ob-top"><div class="ob-prog" aria-label="Step ' + step + ' of 5">' + [1, 2, 3, 4, 5].map(function (i) { return '<span class="' + (i <= step ? 'on' : '') + '"></span>'; }).join('') + '</div>' +
    (skip ? '<button class="btn btn-text sm" data-go="skip">' + t('Skip', 'Bỏ qua') + '</button>' : '<span class="ob-sp"></span>') + '</div>';
}
SCR.language = function (o) {
  o = o || {};
  var it = [['English', 'English', 'EN'], ['Tiếng Việt', 'Vietnamese', 'VI']];
  return phone('<div class="ob">' + obProgress(1, false) + '<div class="lang-ic">' + icon('languages', 30) + '</div>' +
    '<h1 class="headline ob-h left">Choose your language</h1><p class="body muted ob-p">You can change it later in Settings. The whole app switches at once.</p>' +
    '<div class="group">' + it.map(function (x, i) { var on = (o.vi ? 1 : 0) === i; return '<div class="srow' + (on ? ' sel' : '') + '" data-go="' + (i ? 'vi' : 'en') + '"><span class="cur-badge">' + x[2] + '</span><span class="grow"><span class="srow-l">' + x[0] + '</span><span class="meta muted">' + x[1] + '</span></span>' + (on ? '<span class="check-c">' + icon('check', 18) + '</span>' : '<span class="radio"></span>') + '</div>'; }).join('') + '</div>' +
    '<div class="ob-foot">' + btn('Continue', { block: true, go: 'next' }) + '</div></div>');
};
SCR.welcome = function () {
  var ben = [['bell-ring', t('Reminders before you’re charged', 'Nhắc trước khi bị trừ tiền'), t('Before renewals and before trials end.', 'Trước kỳ gia hạn và trước khi hết dùng thử.')],
    ['wallet', t('Know what each month really costs', 'Biết mỗi tháng tốn bao nhiêu'), t('Every price shows its cycle — no more guessing.', 'Mọi giá đều ghi rõ chu kỳ — hết đoán.')],
    ['lock', t('Your data stays on this phone', 'Dữ liệu chỉ nằm trên máy'), t('No account, no bank link, no tracking.', 'Không tài khoản, không ngân hàng, không theo dõi.')]];
  return phone('<div class="ob">' + obProgress(2, true) + '<div class="ob-art">' + art('welcome', 300) + '</div>' +
    '<h1 class="headline ob-h">' + t('All your subscriptions, one nest', 'Mọi gói đăng ký, một tổ') + '</h1>' +
    '<div class="ben">' + ben.map(function (b) { return '<div class="ben-row"><span class="ben-ic">' + icon(b[0], 20) + '</span><span class="grow"><span class="title-sm">' + b[1] + '</span><span class="meta muted">' + b[2] + '</span></span></div>'; }).join('') + '</div>' +
    '<div class="ob-foot">' + btn(t('Get started', 'Bắt đầu'), { block: true, go: 'next' }) + '</div></div>');
};
var CURS = [['USD', 'US dollar', '$'], ['VND', 'Vietnamese đồng', '₫'], ['EUR', 'Euro', '€'], ['GBP', 'British pound', '£'], ['JPY', 'Japanese yen', '¥'], ['AUD', 'Australian dollar', 'A$'], ['CAD', 'Canadian dollar', 'C$'], ['INR', 'Indian rupee', '₹'], ['SGD', 'Singapore dollar', 'S$']];
SCR.currency = function (o) {
  o = o || {};
  var body = '<div class="ob">' + obProgress(3, true) +
    '<h1 class="headline ob-h left">' + t('Your main currency', 'Tiền tệ chính của bạn') + '</h1>' +
    '<p class="body muted ob-p">' + t('Totals are added up in it. Each subscription keeps its own currency.', 'Dùng để cộng tổng. Mỗi gói vẫn giữ tiền tệ riêng.') + '</p>' +
    '<div class="cur2">' + [['USD', 'US dollar', '$'], ['VND', t('Vietnamese đồng', 'Đồng Việt Nam'), '₫']].map(function (c, i) { var on = (LANG === 'vi' ? 1 : 0) === i; return '<button class="cur-big' + (on ? ' on' : '') + '" data-go="cur-' + c[0] + '"><span class="cb-s num">' + c[2] + '</span><span class="title-sm">' + c[0] + '</span><span class="meta muted">' + c[1] + '</span>' + (on ? '<span class="check-c">' + icon('check', 16) + '</span>' : '') + '</button>'; }).join('') + '</div>' +
    '<button class="btn btn-text change" data-go="change">' + icon('globe', 18) + t('Choose another currency…', 'Chọn tiền tệ khác…') + '</button>' +
    '<div class="ob-note meta muted">' + icon('refresh-cw', 16) + t('Exchange rates update once a day when you’re online. You can set your own in Settings.', 'Tỷ giá tự cập nhật mỗi ngày khi có mạng. Bạn có thể tự đặt trong Cài đặt.') + '</div>' +
    '<div class="ob-foot">' + btn(t('Continue', 'Tiếp tục'), { block: true, go: 'next' }) + '</div></div>';
  if (o.picker) body += sheet('<h2 class="title sh-title">' + t('Main currency', 'Tiền tệ chính') + '</h2>' +
    '<div class="search">' + icon('search', 20) + '<span class="search-ph">' + t('Search currency or country', 'Tìm tiền tệ hoặc quốc gia') + '</span></div>' +
    '<div class="cur-list">' + CURS.map(function (c, i) { return '<div class="srow" data-go="pickcur"><span class="cur-badge num">' + c[2] + '</span><span class="grow"><span class="srow-l">' + c[0] + '</span><span class="meta muted">' + c[1] + '</span></span>' + (i === 0 ? '<span class="check-c">' + icon('check', 18) + '</span>' : '') + '</div>'; }).join('') + '</div>', { cls: 'tall' });
  return phone(body);
};
/* library data: [id, name, colour, mark, from-price, currency, cycle unit, category, verified, plan count] */
function LIBG() {
  return [['netflix', 'Netflix', '#e50914', 'N', 7.99, 'USD', 'm', 'video', 1, 3], ['spotify', 'Spotify', '#1db954', 'S', 11.99, 'USD', 'm', 'music', 1, 4], ['youtube', 'YouTube Premium', '#ff0033', 'YT', 13.99, 'USD', 'm', 'video', 1, 3],
    ['chatgpt', 'ChatGPT', '#10a37f', 'C', 20, 'USD', 'm', 'ai', 1, 2], ['claude', 'Claude', '#d97757', 'C', 20, 'USD', 'm', 'ai', 1, 2], ['disney', 'Disney+', '#113ccf', 'D+', 9.99, 'USD', 'm', 'video', 1, 2],
    ['icloud', 'iCloud+', '#3693f3', 'iC', 0.99, 'USD', 'm', 'storage', 1, 4], ['gone', 'Google One', '#1a73e8', 'G1', 19.99, 'USD', 'y', 'storage', 1, 3], ['canva', 'Canva', '#7d2ae8', 'Ca', 120, 'USD', 'y', 'software', 1, 2],
    ['m365', 'Microsoft 365', '#d83b01', 'M', 99.99, 'USD', 'y', 'software', 1, 2], ['notion', 'Notion', '#2d3438', 'No', 10, 'USD', 'm', 'software', 0, 2], ['duolingo', 'Duolingo', '#58cc02', 'D', 59.99, 'USD', 'y', 'education', 1, 1],
    ['max', 'Max', '#002be7', 'Mx', 9.99, 'USD', 'm', 'video', 0, 3], ['applemusic', 'Apple Music', '#fa2d48', 'AM', 10.99, 'USD', 'm', 'music', 1, 3]];
}
function LIBV() {
  return [['netflix', 'Netflix', '#e50914', 'N', 74000, 'VND', 'm', 'video', 1, 4], ['spotify', 'Spotify', '#1db954', 'S', 65000, 'VND', 'm', 'music', 0, 3], ['fptplay', 'FPT Play', '#f37021', 'FP', 66000, 'VND', 'm', 'video', 0, 3],
    ['vieon', 'VieON', '#1a1f71', 'Vi', 49000, 'VND', 'm', 'video', 0, 3], ['zing', 'Zing MP3', '#7a3fe0', 'Z', 25000, 'VND', 'm', 'music', 0, 2], ['viettel', 'Viettel 5G', '#d6002e', 'V', 120000, 'VND', 'm', 'telecom', 0, 6],
    ['mobifone', 'MobiFone', '#005bab', 'Mo', 90000, 'VND', 'm', 'telecom', 0, 5], ['galaxy', 'Galaxy Play', '#2d3438', 'GP', 70000, 'VND', 'm', 'video', 0, 2], ['youtube', 'YouTube Premium', '#ff0033', 'YT', 79000, 'VND', 'm', 'video', 1, 3]];
}
function libSub(l) { return { id: l[0], name: l[1], color: l[2], mono: l[3], kind: 'lib', cyc: [1, l[6]] }; }
function libRow(l, go) {
  var s = libSub(l);
  return '<div class="lrow" data-go="' + (go || 'lib-' + l[0]) + '">' + logo(s, 40) + '<span class="grow"><span class="title-sm ell">' + l[1] + '</span><span class="lr-p"><span class="meta muted num">' + t('from ', 'từ ') + money(l[4], l[5]) + '</span>' + cyc(s) + (l[8] ? '' : '<span class="ref">' + t('Reference price', 'Giá tham khảo') + '</span>') + '</span>' +
    (l[5] !== P() ? '<span class="meta muted num">≈ ' + money(toP(l[4], l[5])) + '</span>' : '') + '</span><span class="add-c">' + icon('plus', 18) + '</span></div>';
}
SCR.pick = function (o) {
  o = o || {};
  var lib = LIBG(), picked = ['netflix', 'spotify', 'chatgpt', 'icloud', 'disney'];
  var prices = { netflix: 17.99, spotify: 11.99, chatgpt: 20, icloud: 2.99, disney: 9.99 }, sum = 0;
  picked.forEach(function (id) { sum += toP(prices[id], 'USD'); });
  var grid = lib.slice(0, 12).map(function (l) {
    var on = picked.indexOf(l[0]) >= 0;
    return '<button class="pick' + (on ? ' on' : '') + '" data-pick="' + l[0] + '">' + logo(libSub(l), 56) + (on ? '<span class="pick-check">' + icon('check', 14) + '</span>' : '') + '<span class="pick-n">' + l[1] + '</span></button>';
  }).join('');
  var nf = libSub(lib[0]);
  return phone('<div class="ob ob-pick">' + obProgress(4, false) +
    '<h1 class="headline ob-h left">' + t('What do you pay for?', 'Bạn đang dùng gì?') + '</h1>' +
    '<div class="search">' + icon('search', 20) + '<span class="search-ph">' + t('Search 500+ services', 'Tìm trong 500+ dịch vụ') + '</span></div>' +
    '<div class="pick-scroll"><div class="pick-grid">' + grid + '</div></div>' +
    '<div class="quick">' + logo(nf, 32) + '<span class="grow"><span class="label">Netflix Standard</span><span class="q-p"><span class="meta num">' + money(17.99, 'USD') + '</span>' + cyc(nf) + '</span></span><span class="quick-edit">' + icon('pencil', 16) + t('Price & cycle', 'Giá & chu kỳ') + '</span></div>' +
    '<div class="pick-bar"><div class="grow"><span class="label">' + t(picked.length + ' selected', 'Đã chọn ' + picked.length) + '</span><span class="meta muted num">≈ ' + money(r2(sum)) + t('/month', '/tháng') + '</span></div>' +
    '<button class="btn btn-text sm" data-go="later">' + t('Later', 'Để sau') + '</button>' + btn(t('Continue', 'Tiếp tục'), { sm: true, go: 'next', cls: 'pick-go' }) + '</div></div>');
};
SCR.remind = function (o) {
  o = o || {};
  var h = '<div class="ob">' + obProgress(5, false) +
    '<div class="notif-demo"><div class="lock-time">9:00</div><div class="notif">' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>' + t('now', 'bây giờ') + '</span></div>' +
    '<div class="notif-b">' + t('Netflix renews in 3 days — $17.99', 'Netflix gia hạn sau 3 ngày — 260.000 ₫') + '</div></div></div>' +
    '<div class="notif ghost">' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>' + t('2d ago', '2 ngày trước') + '</span></div><div class="notif-b">' + t('Your Spotify trial ends in 3 days.', 'Dùng thử Spotify hết sau 3 ngày.') + '</div></div></div></div>' +
    '<h1 class="headline ob-h">' + t('A heads-up before every charge', 'Báo trước mỗi lần trừ tiền') + '</h1>' +
    '<p class="body muted ob-p center">' + t('3 days before a renewal or a trial ending, at 9:00. You can change both later.', 'Trước 3 ngày khi sắp gia hạn hoặc hết dùng thử, lúc 9:00. Đổi được bất cứ lúc nào.') + '</p>' +
    '<div class="ob-foot col">' + btn(t('Turn on reminders', 'Bật nhắc nhở'), { block: true, icon: 'bell', go: 'next' }) + btn(t('No thanks', 'Không, cảm ơn'), { kind: 'text', block: true, go: 'next' }) + '</div></div>';
  if (o.os) h += '<div class="dim"></div><div class="os-alert" role="alertdialog"><div class="os-body"><b>' + t('Allow Subnest to send you notifications?', 'Cho phép Subnest gửi thông báo?') + '</b></div><div class="os-btns"><span>' + t('Don’t allow', 'Không cho phép') + '</span><span data-go="next"><b>' + t('Allow', 'Cho phép') + '</b></span></div></div>' +
    '<div class="os-note meta">' + icon('info', 14, 'inl') + ' ' + t('System dialog — drawn by Android/iOS, shown for flow context.', 'Hộp thoại hệ thống — do Android/iOS vẽ, chỉ để minh hoạ.') + '</div>';
  return phone(h);
};

/* ---------------- Library (+) ---------------- */
SCR.library = function (o) {
  o = o || {};
  var q = o.query || '', vn = o.tab === 'vn', list = vn ? LIBV() : LIBG();
  var h = nav(t('Add subscription', 'Thêm gói đăng ký'), { close: true }) + '<div class="lib">' +
    '<div class="search focus" data-go="search">' + icon('search', 20) + (q ? '<span class="search-q">' + q + '</span><span class="caret sm"></span><span class="search-x">' + icon('circle-x', 18) + '</span>' : '<span class="caret sm"></span><span class="search-ph">' + t('Search 500+ services', 'Tìm trong 500+ dịch vụ') + '</span>') + '</div>';
  var custom = function (label, sub) { return '<div class="lrow custom" data-go="custom"><span class="lg lg40 lg-ghost">' + icon('plus', 20) + '</span><span class="grow"><span class="title-sm">' + label + '</span><span class="meta muted">' + sub + '</span></span>' + icon('chevron-right', 18, 'muted') + '</div>'; };
  if (!q) {
    h += seg([t('General', 'Chung'), t('Vietnam', 'Việt Nam')], vn ? 1 : 0, 'seg lib-tabs', ['tab-gen', 'tab-vn']) +
      '<div class="chip-row">' + ['all'].concat(CATS).map(function (c, i) { return chip(catName(c), i === 0, false); }).join('') + '</div>' +
      '<div class="lib-list scrollable">' + custom(t('Create a custom service', 'Tạo dịch vụ tuỳ chỉnh'), t('Your own name, colour, letter or photo', 'Tên, màu, chữ hoặc ảnh của riêng bạn')) +
      '<div class="caption eyebrow lib-h">' + (vn ? t('Vietnam · prices in VND', 'Việt Nam · giá VND') : t('Popular · US prices', 'Phổ biến · giá US')) + '</div>' + list.slice(0, 10).map(function (l) { return libRow(l); }).join('') +
      '<div class="lib-foot meta muted">' + icon('refresh-cw', 14, 'inl') + ' ' + t('Library updated 3 days ago', 'Thư viện cập nhật 3 ngày trước') + '</div></div></div>';
    return phone(h + (o.plan ? planSheet() : ''));
  }
  var res = LIBG().concat(LIBV()).filter(function (l, i, a) { return l[1].toLowerCase().indexOf(q.toLowerCase()) === 0 && a.map(function (x) { return x[0]; }).indexOf(l[0]) === i; });
  h += '<div class="lib-list">' + (res.length ? '<div class="caption eyebrow lib-h">' + t(res.length + ' result' + (res.length > 1 ? 's' : ''), res.length + ' kết quả') + '</div>' + res.map(function (l) { return libRow(l, 'pick-' + l[0]); }).join('')
    : '<div class="no-res">' + icon('search-x', 28) + '<span class="title-sm">' + t('Nothing called “' + q + '”', 'Không thấy “' + q + '”') + '</span><span class="meta muted">' + t('Create it — pick a colour, a letter or a photo.', 'Tạo mới — chọn màu, chữ cái hoặc ảnh.') + '</span></div>') +
    custom((res.length ? t('Not it? ', 'Không phải? ') : '') + t('Create “' + q + '”', 'Tạo “' + q + '”'), t('Custom service', 'Dịch vụ tuỳ chỉnh')) + '</div></div>' + keyboard();
  return phone(h);
};
function planSheet() {
  var nf = libSub(LIBG()[0]), plans = [['Standard with ads', 7.99, t('1080p · 2 screens · ads', '1080p · 2 màn hình · có quảng cáo')], ['Standard', 17.99, t('1080p · 2 screens', '1080p · 2 màn hình')], ['Premium', 24.99, t('4K + HDR · 4 screens', '4K + HDR · 4 màn hình')]];
  return sheet('<div class="sh-head">' + logo(nf, 56) + '<div class="grow"><h2 class="title">Netflix</h2><span class="meta muted">' + t('Choose a plan · US prices', 'Chọn gói · giá US') + '</span></div></div>' +
    '<div class="plans">' + plans.map(function (p, i) { return '<div class="plan' + (i === 2 ? ' on' : '') + '" data-go="plan-' + i + '"><span class="radio"></span><span class="grow"><span class="title-sm">' + p[0] + '</span><span class="meta muted">' + p[2] + '</span></span><span class="pl-p"><span class="title-sm num">' + money(p[1], 'USD') + '</span>' + cyc(nf) + '</span></div>'; }).join('') + '</div>' +
    '<p class="meta muted sh-note">' + t('You can change the price on the next screen.', 'Bạn sửa được giá ở bước sau.') + '</p>' + btn(t('Continue with Premium', 'Tiếp tục với Premium'), { block: true, go: 'next' }));
}

/* ---------------- Form (§4.4) ---------------- */
/* o: { mode: add|custom|edit|invalid, more, iconSheet, priceDialog, picker } */
SCR.form = function (o) {
  o = o || {};
  var mode = o.mode || 'add', custom = mode === 'custom' || mode === 'invalid', edit = mode === 'edit', bad = mode === 'invalid';
  var vi = LANG === 'vi';
  var s = custom ? { id: 'gym', name: 'Gym', color: '#e8590c', mono: 'G', kind: o.photo ? 'photo' : 'custom', cyc: [1, 'm'] } : edit ? subOf('netflix') : { id: 'netflix', name: 'Netflix', plan: 'Premium', color: '#e50914', mono: 'N', kind: 'lib', price: vi ? 260000 : 24.99, cur: vi ? 'VND' : 'USD', cyc: [1, 'm'] };
  var price = edit ? (vi ? 280000 : 19.99) : custom ? (bad ? 0 : vi ? 299000 : 39) : s.price, cur = custom ? P() : s.cur, split = mode === 'add';
  var h = nav(edit ? t('Edit subscription', 'Sửa gói đăng ký') : t('New subscription', 'Gói đăng ký mới'), { close: true }) + '<div class="form">';
  h += '<div class="f-head"><span class="tile-wrap" data-go="icon">' + logo(s, 56) + '<span class="edit-dot">' + icon(custom ? 'image-plus' : 'pencil', 13) + '</span></span><div class="grow">' +
    (bad ? '<span class="name-in err">' + t('Service name', 'Tên dịch vụ') + '</span><span class="f-err">' + icon('circle-alert', 14) + t('Enter a name', 'Nhập tên dịch vụ') + '</span>'
      : '<span class="title">' + s.name + '</span>' + (custom ? '<span class="meta muted">' + t('Custom service · tap the icon for a photo', 'Dịch vụ tự tạo · chạm biểu tượng để chọn ảnh') + '</span>' : '<span><span class="plan-chip">' + s.plan + ' ' + icon('chevron-down', 16) + '</span></span>')) + '</div></div>';
  h += '<div class="group' + (bad ? ' err' : '') + '"><div class="field"><span class="f-label meta muted">' + t('Price', 'Giá') + '</span>' +
    '<div class="price-row"><span class="amount-lg num' + (bad ? ' ph' : '') + '">' + money(price, cur) + (mode === 'add' ? '<span class="caret"></span>' : '') + '</span><button class="cur-btn">' + cur + ' ' + icon('chevron-down', 16) + '</button></div>' +
    (cur !== P() ? '<span class="meta muted num">≈ ' + money(toP(price, cur)) + '</span>' : '') +
    (bad ? '<span class="f-err">' + icon('circle-alert', 14) + t('Price must be more than 0', 'Giá phải lớn hơn 0') + '</span>' : '') +
    (edit ? '<div class="info-note">' + icon('history', 16) + '<span>' + t('Was ', 'Giá cũ ') + money(s.price, s.cur) + t('. Saving asks when the new price starts and adds it to the price history.', '. Khi lưu, app hỏi giá mới áp dụng từ kỳ nào và ghi vào Lịch sử giá.') + '</span></div>' : '') + '</div></div>';
  h += '<div class="group"><div class="field"><div class="f-row"><span class="label">' + t('Billing cycle', 'Chu kỳ') + '</span><span class="every"><span class="meta muted">' + t('Every', 'Mỗi') + '</span><span class="mini-field num">1</span><span class="mini-field">' + t('month', 'tháng') + ' ' + icon('chevron-down', 16) + '</span></span></div>' +
    '<div class="chips fit" style="margin-top:12px">' + [t('Weekly', 'Hằng tuần'), t('Monthly', 'Hằng tháng'), t('Quarterly', 'Hằng quý'), t('Yearly', 'Hằng năm')].map(function (x, i) { return chip(x, i === 1, false); }).join('') + '</div></div>' +
    '<div class="field"><div class="f-row"><span class="label">' + t('Next payment', 'Thanh toán tiếp theo') + '</span><span class="mini-field' + (o.picker ? ' focus' : '') + '">' + fd(custom ? '2026-12-01' : '2026-12-10', 'dmy') + ' ' + icon('calendar-days', 16) + '</span></div>' +
    '<div class="meta muted" style="margin-top:6px">' + t('Then ', 'Sau đó: ') + (custom ? fd('2027-01-01') + ' · ' + fd('2027-02-01') : fd('2027-01-10') + ' · ' + fd('2027-02-10')) + '…</div></div></div>';
  h += '<div class="group"><div class="field"><div class="f-row"><span class="grow"><span class="label">' + t('Free trial', 'Đang dùng thử') + '</span><span class="meta muted">' + t('We’ll remind you before it ends', 'Nhắc bạn trước khi hết dùng thử') + '</span></span>' + toggle(false) + '</div></div>' +
    '<div class="field"><div class="f-row"><span class="grow"><span class="label">' + t('Split with others', 'Chia với người khác') + '</span><span class="meta muted">' + t('Totals use your share', 'Tổng chỉ tính phần của bạn') + '</span></span><span data-go="split" class="tg-hit">' + toggle(split) + '</span></div>' +
    (split ? '<div class="f-row" style="margin-top:12px"><span class="meta">' + t('People, including you', 'Số người, gồm cả bạn') + '</span>' + stepper(4) + '</div>' +
      '<div class="share-panel"><span class="grow"><span class="meta">' + t('Your share', 'Phần của bạn') + '</span><span class="big num">' + money(price / 4, cur) + '</span></span><span class="sp-r"><span class="meta num">' + money(price, cur) + ' ÷ 4</span>' + cyc(s) + '</span></div>' : '') + '</div></div>';
  h += '<div class="group"><div class="field"><span class="f-label label">' + t('Category', 'Danh mục') + '</span><div class="chips">' + ['video', 'music', 'ai', 'storage', 'software', 'health', 'other'].map(function (c) { return chip(catName(c), custom ? c === 'health' : c === 'video'); }).join('') + '</div></div>' +
    '<div class="field"><span class="f-label label">' + t('Labels', 'Nhãn') + '</span><div class="chips">' + Object.keys(LABELS).map(function (k) { var on = custom ? k === 'health' : k === 'family'; return '<span class="chip' + (on ? ' on' : '') + '">' + (on ? icon('check', 16) : '<i class="ldot" style="background:' + LABELS[k][2] + '"></i>') + t(LABELS[k][0], LABELS[k][1]) + '</span>'; }).join('') + '<span class="chip add">' + icon('plus', 16) + t('New', 'Thêm') + '</span></div></div></div>';
  h += '<div class="group"><div class="field"><div class="f-row"><span class="label">' + t('Remind me', 'Nhắc trước') + '</span><span class="meta muted">' + t('at 9:00', 'lúc 9:00') + '</span></div><div class="chips fit" style="margin-top:10px">' +
    [t('On the day', 'Đúng ngày'), t('1 day', '1 ngày'), t('3 days', '3 ngày'), t('7 days', '7 ngày')].map(function (x, i) { return chip(x, i === 0 || i === 2); }).join('') + '</div></div></div>';
  if (o.more) h += '<div class="group" id="more"><div class="field"><div class="f-row"><span class="label">' + t('More details', 'Thêm chi tiết') + '</span>' + icon('chevron-up', 20, 'muted') + '</div></div>' +
    '<div class="field"><span class="f-label meta muted">' + t('Payment method', 'Phương thức thanh toán') + '</span><div class="chips">' + ['Visa ••4821', 'PayPal', 'Apple Pay', 'Google Play'].map(function (m, i) { return chip(m, i === 0); }).join('') + '<span class="chip add">' + icon('plus', 16) + t('Add', 'Thêm') + '</span></div></div>' +
    '<div class="field"><span class="f-label meta muted">' + t('Cancel / manage link', 'Link huỷ / quản lý') + '</span><div class="input">' + icon('link', 18, 'muted') + '<span class="ell">netflix.com/account/membership</span></div><span class="meta muted f-hint">' + t('Filled in from the library. Opens from “How to cancel”.', 'Điền sẵn từ thư viện. Mở khi chạm “Cách huỷ”.') + '</span></div>' +
    '<div class="field"><span class="f-label meta muted">' + t('Worth it?', 'Đáng tiền?') + '</span><div class="worth">' + [['yes', 'thumbs-up'], ['unsure', 'circle-help'], ['no', 'thumbs-down']].map(function (w) { return '<span class="ws' + (w[0] === 'yes' ? ' on w-yes' : '') + '">' + icon(w[1], 18) + worthName(w[0]) + '</span>'; }).join('') + '</div></div>' +
    '<div class="field"><span class="f-label meta muted">' + t('Notes', 'Ghi chú') + '</span><div class="input tall"><span>' + t('Shared with Minh, Lan and Huy — they pay me on the 5th.', 'Chia với Minh, Lan và Huy — mọi người chuyển cho mình ngày 5.') + '</span></div></div></div>';
  else h += '<div class="group"><div class="field" data-go="more"><div class="f-row"><span class="grow"><span class="label">' + t('More details', 'Thêm chi tiết') + '</span><span class="meta muted">' + t('Payment method, cancel link, notes, worth it?', 'Thanh toán, link huỷ, ghi chú, đáng tiền?') + '</span></span>' + icon('chevron-down', 20, 'muted') + '</div></div></div>';
  if (edit) h += '<button class="btn btn-text block danger-t">' + icon('trash-2', 18) + t('Delete subscription', 'Xoá gói đăng ký') + '</button>';
  h += '</div><div class="bottom-bar">' + btn(edit ? t('Save changes', 'Lưu thay đổi') : t('Add subscription', 'Thêm gói đăng ký'), { block: true, go: edit ? 'saveprice' : 'save', cls: bad ? 'is-disabled' : '' }) + '</div>';
  if (o.iconSheet) h += iconSheet(s, o.iconSheet);
  if (o.priceDialog) h += dialog(t('Use ', 'Áp dụng giá ') + money(price, s.cur) + t(' from the next payment?', ' từ kỳ tới?'),
    t('The 15 Dec payment and later ones use the new price. Your past payments stay exactly as paid, and the change is saved to the price history.', 'Kỳ 15/12 và các kỳ sau dùng giá mới. Các khoản đã trả giữ nguyên, thay đổi được ghi vào Lịch sử giá.') +
    '<span class="dlg-list"><span>' + t('Now', 'Hiện tại') + '</span><b class="num">' + money(s.price, s.cur) + '</b><span>' + t('From 15 Dec', 'Từ 15/12') + '</span><b class="num rise-t">' + money(price, s.cur) + ' (+' + money(price - s.price, s.cur).replace('$', '$') + ')</b></span>',
    [btn(t('Apply from 15 Dec', 'Áp dụng từ 15/12'), { block: true, go: 'apply' }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true })]);
  return phone(h);
};
function iconSheet(s, which) {
  var sw = ['#d21f3c', '#e8590c', '#f2b705', '#1f9d55', '#0f8b8d', '#3a9be0', '#2856d8', '#7a3fe0', '#e0428f', '#8a5a3c', '#2d3438', '#79838a'];
  var photo = which === 'photo';
  return sheet('<h2 class="title sh-title">' + t('Change icon', 'Đổi biểu tượng') + '</h2><div class="ic-prev">' + logo(photo ? { name: 'Gym', color: '#e8590c', mono: 'G', kind: 'photo' } : s, 80) + '<span class="meta muted">' + (photo ? t('Your photo, cropped square', 'Ảnh của bạn, cắt vuông') : t('Letter on colour', 'Chữ trên nền màu')) + '</span></div>' +
    '<div class="two-btn">' + btn(t('Choose photo', 'Chọn ảnh'), { kind: photo ? 'outline' : 'tonal', icon: 'image-plus', go: 'photo' }) + (photo ? btn(t('Remove photo', 'Gỡ ảnh'), { kind: 'text', icon: 'trash-2', cls: 'danger-t' }) : btn(t('Take photo', 'Chụp ảnh'), { kind: 'outline', icon: 'camera' })) + '</div>' +
    '<div class="caption eyebrow grp-head">' + t('Colour', 'Màu') + '</div><div class="swatches">' + sw.map(function (c, i) { var on = !photo && i === 1; return '<span class="swatch' + (on ? ' on' : '') + '" style="--sw:' + c + '">' + (on ? icon('check', 16) : '') + '</span>'; }).join('') + '</div>' +
    '<div class="caption eyebrow grp-head">' + t('Letter or emoji', 'Chữ cái hoặc emoji') + '</div><div class="input">' + '<span class="search-q">G</span><span class="caret sm"></span></div>' +
    '<div class="sh-actions mt16">' + btn(t('Done', 'Xong'), { block: true, go: 'done' }) + '</div>', { cls: 'tall' });
}
SCR.crop = function () {
  return phone('<div class="crop"><div class="cam-top"><span class="cam-b" data-go="back">' + icon('x', 24) + '</span><span class="cam-t">' + t('Move and scale', 'Di chuyển và thu phóng') + '</span><span class="cam-b">' + icon('rotate-cw', 22) + '</span></div>' +
    '<div class="crop-view"><div class="crop-img"><i class="ph-a"></i><i class="ph-b"></i>' + icon('dumbbell', 120) + '</div><div class="crop-box"><span class="cg"></span></div></div>' +
    '<p class="cam-hint">' + t('The square is what shows as the icon', 'Phần trong khung vuông sẽ là biểu tượng') + '</p>' +
    '<div class="crop-bar">' + btn(t('Cancel', 'Huỷ'), { kind: 'text', cls: 'on-dark' }) + btn(t('Use photo', 'Dùng ảnh'), { go: 'next' }) + '</div></div>', { sb: { light: true }, cls: 'is-cam' });
};

/* ---------------- Detail (§4.5), confirm sheet (§4.6), pending (§4.7) ---------------- */
var SRC = { you: ['pencil', 'You changed it', 'Bạn sửa'], lib: ['book-open', 'Library update', 'Thư viện cập nhật'], pay: ['receipt', 'From past payments', 'Từ các kỳ đã trả'], scan: ['image', 'From screenshot', 'Từ ảnh chụp'] };
function priceHist(s) {
  var h = (s.hist || []).slice().reverse();
  if (!h.length) return '<div class="list-empty meta muted">' + t('The price has never changed.', 'Giá chưa từng đổi.') + '</div>';
  var rows = h.map(function (x) {
    var up = x.nw > x.old, d = x.nw - x.old;
    return '<div class="ph-row' + (x.future ? ' fut' : '') + '"><span class="ph-ic ' + (up ? 'isup' : 'isdown') + '">' + icon(up ? 'trending-up' : 'trending-down', 18) + '</span><span class="grow"><span class="label num">' + money(x.old, s.cur) + ' → ' + money(x.nw, s.cur) + '</span>' +
      '<span class="meta muted">' + (x.future ? t('From ', 'Từ ') : '') + fd(x.from, 'num') + ' · ' + icon(SRC[x.src][0], 12, 'inl') + ' ' + t(SRC[x.src][1], SRC[x.src][2]) + (x.future ? ' · ' + t('next payment', 'kỳ tới') : '') + '</span></span>' +
      '<span class="ph-d num ' + (up ? 'isup' : 'isdown') + '">' + (up ? '+' : '−') + money(Math.abs(d), s.cur) + '</span></div>';
  }).join('');
  var first = h[h.length - 1];
  return rows + '<div class="ph-row start"><span class="ph-ic">' + icon('flag', 16) + '</span><span class="grow"><span class="label num">' + t('Started at ', 'Bắt đầu với giá ') + money(first.old, s.cur) + '</span><span class="meta muted">' + fd(s.started, 'num') + ' · ' + icon('receipt', 12, 'inl') + ' ' + t('From past payments', 'Từ các kỳ đã trả') + '</span></span></div>';
}
function payHist(s) {
  var ev = events(s, addM(TODAY, -6), addM(TODAY, 1)).filter(function (e) { return e.st !== 'up'; }).reverse().slice(0, 5);
  if (!ev.length) return '<div class="list-empty meta muted">' + t('No payments yet — the first charge is on ', 'Chưa có thanh toán — lần trừ đầu vào ') + fd(s.due, 'dmy') + '.</div>';
  return ev.map(function (e, i) {
    var auto = s.id === 'netflix' && i === 0;
    var lab = e.st === 'wait' ? awaitBadge() : '<span class="hist-st ok">' + icon('circle-check', 16) + t('Paid', 'Đã trả') + '</span>' + (auto ? '<span class="src">' + icon('image', 13) + t('From screenshot', 'Từ ảnh chụp') + ' · <u>' + t('Undo', 'Hoàn tác') + '</u></span>' : '');
    return '<div class="srow hist"><span class="grow"><span class="srow-l">' + fd(e.d, 'num') + '</span>' + lab + '</span><span class="srow-v num">' + money(e.amt) + '</span>' + (e.st === 'paid' ? icon('pencil', 16, 'muted') : btn(t('Confirm', 'Xác nhận'), { sm: true, kind: 'tonal', go: 'confirm' })) + '</div>';
  }).join('');
}
/* o: { top: html banner, sheet: pause|resume, dialog: delete|cancel, notice, disc, auto, scn } */
SCR.detail = function (id, scn, o) {
  o = o || {};
  var subs = data(scn), s = subs.filter(function (x) { return x.id === id; })[0];
  if (o.auto) s.auto = true;
  var st = s.status === 'paused' ? badge('neutral', 'pause', t('Paused', 'Tạm dừng')) : s.status === 'cancelled' ? badge('neutral', 'ban', t('Cancelled', 'Đã huỷ')) : s.status === 'trial' ? badge('warn', 'hourglass', t('Trial · ' + days(s.due) + ' days left', 'Dùng thử · còn ' + days(s.due) + ' ngày')) : s.awaiting ? awaitBadge() : badge('success', 'circle-check', t('Active', 'Đang trả'));
  var h = nav('', { right: '<button class="btn btn-text sm" data-go="edit">' + t('Edit', 'Sửa') + '</button>', cls: 'nav-clear' }) + '<div class="scroll detail">' +
    '<section class="hero-d' + (s.status === 'cancelled' || s.status === 'paused' ? ' is-off' : '') + '" style="--tile:' + s.color + '">' + logo(s, 80) +
    '<h1 class="headline">' + fullName(s) + '</h1><div class="hero-d-st">' + st + (s.auto ? '<span class="tag tag-auto">' + icon('sparkles', 11) + t('Auto-detected', 'Tự phát hiện') + '</span>' : '') + '</div>' +
    '<div class="hero-d-amt"><span class="display-sm num">' + money(s.share ? myShare(s) : s.price, s.cur) + '</span>' + cyc(s) + '</div>' +
    (s.share ? '<div class="meta muted">' + icon('users', 14, 'inl') + ' ' + t('Your share · plan ', 'Phần của bạn · gói ') + money(s.price, s.cur) + ' ÷ ' + s.share + '</div>' : s.cur !== P() ? '<div class="meta muted num">≈ ' + money(toP(s.price, s.cur)) + '</div>' : '') + '</section>';
  var b = [];
  if (s.awaiting) b.push(banner('warn', 'clock', t('Payment on ' + fd(s.due) + ' needs confirming', 'Kỳ ' + fd(s.due) + ' đang chờ xác nhận'), t('The next date waits until you say whether it was paid.', 'Ngày thanh toán tiếp theo chỉ chạy khi bạn xác nhận.'), { label: t('Confirm', 'Xác nhận'), go: 'confirm' }));
  if (s.status === 'trial') b.push(banner('warn', 'hourglass', t('Trial ends ', 'Hết dùng thử ') + fd(s.due, 'wdm'), t('Then ' + money(s.price, s.cur) + ' a month. Cancel before to save ' + money(yearlyCost(s)) + ' a year.', 'Sau đó ' + money(s.price, s.cur) + '/tháng. Huỷ trước để tiết kiệm ' + money(yearlyCost(s)) + '/năm.')));
  if (s.status === 'paused') b.push(banner('neutral', 'pause', t('Paused since ', 'Tạm dừng từ ') + fd(s.pausedFrom, 'dmy'), t('No payments, no reminders, not counted.', 'Không trừ tiền, không nhắc, không tính vào tổng.'), { label: t('Resume', 'Bật lại'), go: 'resume' }));
  if (s.pauseFrom) b.push(banner('info', 'pause', t('Pauses from ', 'Tạm dừng từ ') + fd(s.pauseFrom, 'wdm'), t('Still counted this month — that payment is the first one skipped.', 'Tháng này vẫn tính — kỳ đó là kỳ đầu tiên được bỏ qua.'), { label: t('Undo', 'Hoàn tác') }));
  if (s.status === 'cancelled') b.push(banner('success', 'piggy-bank', t('Saving ', 'Tiết kiệm ') + money(yearlyCost(s)) + t(' a year', '/năm'), t('Cancelled ' + fd(s.cancelled, 'dmy') + '. No more reminders.', 'Đã huỷ ' + fd(s.cancelled, 'dmy') + '. Không còn nhắc nữa.'), { label: t('Restore', 'Khôi phục') }));
  if (o.notice) b.push(banner('info', 'tag', t('New library price: ', 'Giá mới trong thư viện: ') + money(LANG === 'vi' ? 199000 : 25.99, s.cur), t('You pay ' + money(s.price, s.cur) + '. Update from the next payment, or keep your price.', 'Bạn đang trả ' + money(s.price, s.cur) + '. Cập nhật từ kỳ tới, hoặc giữ giá của bạn.'), { label: t('Review', 'Xem'), go: 'priceupdate' }));
  if (o.disc) b.push(banner('neutral', 'archive', t('This plan is no longer sold', 'Gói này đã ngừng bán'), t('It left the library for new customers. Yours keeps its price and dates.', 'Gói không còn bán cho khách mới. Gói của bạn giữ nguyên giá và ngày.')));
  if (o.auto) b.push(banner('info', 'sparkles', t('Added automatically', 'Được thêm tự động'), t('Found in a screenshot today. Not yours? Remove it — it won’t be added again.', 'Tìm thấy trong ảnh chụp hôm nay. Không phải của bạn? Gỡ đi — app sẽ không thêm lại.'), { label: t('Remove', 'Gỡ'), go: 'removeauto' }));
  if (b.length) h += '<div class="pad bstack">' + b.join('') + '</div>';
  var paid = events(s, D('2000-01-01'), TODAY).filter(function (e) { return e.st === 'paid'; }).reduce(function (a, e) { return a + e.amt; }, 0);
  var rows = [];
  if (s.status !== 'cancelled' && s.status !== 'paused') rows.push(setRow({ icon: 'calendar-days', label: s.status === 'trial' ? t('First payment', 'Lần trả đầu') : t('Next payment', 'Thanh toán tiếp theo'), value: fd(s.due, 'wdm'), sub: s.awaiting ? t('Waiting for your confirmation', 'Chờ bạn xác nhận') : left(s.due), chevron: false }));
  rows.push(setRow({ icon: 'refresh-cw', label: t('Billing cycle', 'Chu kỳ'), right: cyc(s, 'on'), chevron: false }));
  if (s.status !== 'cancelled') rows.push(setRow({ icon: 'bell', label: t('Reminders', 'Nhắc'), value: t('On the day, 3 days before', 'Đúng ngày, trước 3 ngày'), chevron: false }));
  rows.push(setRow({ icon: CAT_IC[s.cat], label: t('Category', 'Danh mục'), value: catName(s.cat), chevron: false }));
  if ((s.labels || []).length) rows.push(setRow({ icon: 'tag', label: t('Labels', 'Nhãn'), right: '<span class="lbls">' + s.labels.map(lbl).join('') + '</span>', chevron: false }));
  if (s.method) rows.push(setRow({ icon: 'credit-card', label: t('Payment method', 'Phương thức'), value: s.method, chevron: false }));
  rows.push(setRow({ icon: 'calendar-check', label: t('Since', 'Bắt đầu từ'), value: fd(s.started, 'dmy'), chevron: false }));
  rows.push(setRow({ icon: 'coins', label: t('Total paid', 'Tổng đã trả'), value: '<b class="num">' + money(r2(paid)) + '</b>', chevron: false }));
  rows.push(setRow({ icon: worthIcon(s.worth), label: t('Worth it?', 'Đáng tiền?'), right: '<span class="worth-c' + (s.worth ? ' w-' + s.worth : '') + '">' + worthName(s.worth) + '</span>', chevron: false }));
  if (o.disc) rows.push(setRow({ icon: 'link', label: t('Service library', 'Thư viện dịch vụ'), value: t('No longer sold', 'Ngừng bán'), chevron: false }));
  h += '<div class="pad">' + group(rows) + '</div>';
  h += '<div class="pad">' + group([priceHist(s)], t('Price history', 'Lịch sử giá'), 'phist') + '</div>';
  h += '<div class="pad">' + group([payHist(s)], t('Payment history', 'Lịch sử thanh toán')) + '</div>';
  h += '<div class="pad actions">' + (s.status !== 'cancelled' ? (s.host ? setRow({ icon: 'external-link', label: t('How to cancel', 'Cách huỷ'), sub: t('Opens ' + s.host + ' account page', 'Mở trang tài khoản ' + s.host), chevron: false, right: icon('external-link', 18, 'muted'), go: 'howcancel' }) : '') +
    (s.status === 'paused' ? btn(t('Resume', 'Bật lại'), { kind: 'tonal', block: true, icon: 'play', go: 'resume' }) : !s.pauseFrom ? btn(t('Pause', 'Tạm dừng'), { kind: 'outline', block: true, icon: 'pause', go: 'pause' }) : '') +
    btn(t('Mark as cancelled', 'Đánh dấu đã huỷ'), { kind: 'outline', block: true, icon: 'ban', go: 'markcancel' }) : btn(t('Restore subscription', 'Khôi phục gói'), { kind: 'tonal', block: true, icon: 'rotate-ccw' })) +
    btn(t('Delete subscription', 'Xoá gói đăng ký'), { kind: 'text', block: true, icon: 'trash-2', cls: 'danger-t', go: 'delete' }) + '</div></div>';
  if (o.sheet === 'pause') h += sheet('<div class="sh-head">' + logo(s, 56) + '<div class="grow"><h2 class="title">' + t('Pause ', 'Tạm dừng ') + s.name + '?</h2><span class="meta muted">' + t('Nothing is cancelled with the service — this only stops tracking.', 'Không huỷ gì với nhà cung cấp — chỉ ngừng theo dõi.') + '</span></div></div>' +
    '<div class="pause-tl"><div class="pt on"><i></i><span class="label">' + t('Now → ', 'Bây giờ → ') + fd(s.due) + '</span><span class="meta muted">' + t('Still counted — you paid for this period', 'Vẫn tính — kỳ này bạn đã trả') + '</span></div><div class="pt"><i></i><span class="label">' + t('From ', 'Từ ') + fd(s.due, 'wdm') + '</span><span class="meta muted">' + t('No payments, no reminders, not in totals', 'Không trừ tiền, không nhắc, không tính tổng') + '</span></div></div>' +
    '<div class="sh-actions mt16">' + btn(t('Pause from ', 'Tạm dừng từ ') + fd(s.due), { block: true, icon: 'pause' }) + btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true }) + '</div>');
  if (o.sheet === 'resume') h += sheet('<h2 class="title sh-title">' + t('Resume ', 'Bật lại ') + s.name + '</h2><p class="meta muted">' + t('When is the next payment?', 'Kỳ thanh toán tiếp theo vào ngày nào?') + '</p>' + datePicker(2026, 10, 10) +
    '<div class="info-note">' + icon('info', 16) + '<span>' + t('Defaults to today. Then every month on the same day.', 'Mặc định là hôm nay. Sau đó hằng tháng vào cùng ngày.') + '</span></div><div class="sh-actions mt16">' + btn(t('Resume from today', 'Bật lại từ hôm nay'), { block: true, icon: 'play' }) + '</div>', { cls: 'tall' });
  if (o.dialog === 'delete') h += dialog(t('Delete ' + s.name + '?', 'Xoá ' + s.name + '?'), t('It and its payment and price history are removed for good. To stop reminders but keep the history, mark it as cancelled instead.', 'Gói này cùng lịch sử thanh toán và lịch sử giá sẽ bị xoá vĩnh viễn. Muốn tắt nhắc mà vẫn giữ lịch sử, hãy đánh dấu đã huỷ.'), [btn(t('Delete', 'Xoá'), { kind: 'danger', block: true }), btn(t('Keep it', 'Giữ lại'), { kind: 'text', block: true })]);
  if (o.dialog === 'cancel') h += dialog(t('Mark ' + s.name + ' as cancelled?', 'Đánh dấu ' + s.name + ' đã huỷ?'), t('Reminders stop and ' + money(yearlyCost(s)) + ' a year moves into your savings. You can restore it any time.', 'Subnest ngừng nhắc và cộng ' + money(yearlyCost(s)) + '/năm vào khoản tiết kiệm. Khôi phục được bất cứ lúc nào.'), [btn(t('Mark as cancelled', 'Đánh dấu đã huỷ'), { block: true, go: 'next' }), btn(t('Not yet', 'Chưa'), { kind: 'text', block: true })]);
  if (o.dialog === 'removeauto') h += dialog(t('Remove ' + s.name + '?', 'Gỡ ' + s.name + '?'), t('It was added from a screenshot. Subnest will remember and won’t add it again.', 'Gói này được thêm từ ảnh chụp. Subnest sẽ ghi nhớ và không tự thêm lại.'), [btn(t('Remove', 'Gỡ'), { kind: 'danger', block: true }), btn(t('Keep it', 'Giữ lại'), { kind: 'text', block: true })]);
  if (o.over) h += o.over;
  return phone(h);
};
function datePicker(y, m, sel) {
  var first = new Date(y, m, 1), off = (first.getDay() + 6) % 7, n = dim(y, m), cells = '';
  for (var i = 0; i < off; i++) cells += '<span></span>';
  for (var dd = 1; dd <= n; dd++) cells += '<span class="dp-d' + (dd === sel ? ' on' : '') + (y === 2026 && m === 10 && dd === 10 ? ' today' : '') + (y === 2026 && m === 10 && dd < 10 ? ' past' : '') + '">' + dd + '</span>';
  return '<div class="dp"><div class="dp-head"><button class="icon-btn" aria-label="Previous month">' + icon('chevron-left', 20) + '</button><span class="title-sm">' + fd(new Date(y, m, 1), 'my') + '</span><button class="icon-btn" aria-label="Next month">' + icon('chevron-right', 20) + '</button></div>' +
    '<div class="dp-grid dp-w">' + (LANG === 'vi' ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'] : ['M', 'T', 'W', 'T', 'F', 'S', 'S']).map(function (x) { return '<span>' + x + '</span>'; }).join('') + '</div><div class="dp-grid">' + cells + '</div></div>';
}
SCR.priceSheet = function () {
  var yt = subOf('youtube'), nw = LANG === 'vi' ? 199000 : 25.99;
  return phone(unwrap(SCR.detail('youtube', 'default', { notice: true })) + sheet('<div class="sh-head">' + logo(yt, 56) + '<div class="grow"><h2 class="title">' + t('Update the price?', 'Cập nhật giá?') + '</h2><span class="meta muted">' + t('YouTube Premium Family · library price', 'YouTube Premium Gia đình · giá thư viện') + '</span></div></div>' +
    '<div class="pc-cmp"><div class="pc-col"><span class="meta muted">' + t('You pay now', 'Bạn đang trả') + '</span><span class="title num">' + money(yt.price, yt.cur) + '</span><span class="meta muted num">' + t('your share ', 'phần bạn ') + money(yt.price / 5, yt.cur) + '</span></div><span class="pc-arrow">' + icon('arrow-right', 20) + '</span>' +
    '<div class="pc-col on"><span class="meta muted">' + t('New price', 'Giá mới') + '</span><span class="title num">' + money(nw, yt.cur) + '</span><span class="meta muted num">' + t('your share ', 'phần bạn ') + money(nw / 5, yt.cur) + '</span></div></div>' +
    '<div class="info-note">' + icon('history', 16) + '<span>' + t('Applies from the 18 Nov payment and is saved to the price history. Past payments stay as paid.', 'Áp dụng từ kỳ 18/11 và được ghi vào Lịch sử giá. Các khoản đã trả giữ nguyên.') + '</span></div>' +
    '<div class="sh-actions mt16">' + btn(t('Update from 18 Nov', 'Cập nhật từ 18/11'), { block: true, go: 'update' }) + btn(t('Keep ', 'Giữ ') + money(yt.price, yt.cur), { kind: 'text', block: true }) + '</div>'));
};
SCR.confirm = function (o) {
  o = o || {};
  var scn = o.chain ? 'many' : 'default', s = subOf('claude', scn), period = o.chain ? D(s.due) : D(s.due), amt = myShare(s);
  var next = step(period, s, 1);
  var ask = '<div class="ask"><div class="sh-head">' + logo(s, 56, 'wait') + '<div class="grow"><h2 class="title">' + fullName(s) + '</h2>' +
    '<span class="sh-meta">' + badge('warn', 'clock', o.chain ? t('1 more after this', 'Còn 1 kỳ sau') : t('Due ' + fd(period), 'Đến hạn ' + fd(period))) + '<span class="meta muted">' + t('Period of ', 'Kỳ ') + fd(period, 'num') + '</span></span></div></div>' +
    '<div class="amount-box"><span class="meta muted">' + t('Amount paid', 'Số tiền đã trả') + '</span><div class="f-row"><span class="amount-lg num">' + money(amt, s.cur) + '</span>' + cyc(s) + '<button class="icon-btn" aria-label="' + t('Edit amount', 'Sửa số tiền') + '">' + icon('pencil', 20) + '</button></div>' +
    '<div class="meta muted">' + t('Current price · change it if you paid a different amount', 'Giá hiện tại · sửa nếu số tiền thực trả khác') + '</div></div>' +
    '<div class="sh-actions">' + btn(t('Paid', 'Đã trả'), { block: true, icon: 'check', go: 'paid', cls: 'js-paid' }) + btn(t('Didn’t pay this period', 'Không trả kỳ này'), { kind: 'outline', block: true, go: 'skip' }) + btn(t('Later', 'Để sau'), { kind: 'text', block: true, go: 'later' }) + '</div></div>';
  var done = '<div class="done" aria-live="polite"><div class="check">' + icon('check', 36) + '</div><h2 class="title" style="margin:0">' + t('Payment saved', 'Đã lưu thanh toán') + '</h2>' +
    '<p class="body muted" style="margin:4px 0 12px">' + s.name + ' · ' + money(amt, s.cur) + ' · ' + fd(period, 'num') + '</p>' +
    '<span class="paid-pill">' + icon('calendar-days', 14) + t('Next period: ', 'Kỳ tới: ') + fd(next, 'num') + '</span>' +
    (o.chain ? '<div class="chain meta">' + icon('arrow-right', 14) + t('1 more period to confirm — opening it next', 'Còn 1 kỳ chưa xác nhận — mở tiếp') + '</div>' : '') +
    '<div class="sh-actions" style="margin-top:24px">' + btn(o.chain ? t('Next period', 'Kỳ tiếp theo') : t('Done', 'Xong'), { kind: 'tonal', block: true, go: 'done', cls: 'js-done' }) + '</div></div>';
  return phone(SCR.overview(scn, { raw: true }) + sheet(ask + done, { cls: o.done ? 'is-done' : '' }), { tab: 0 });
};
SCR.pending = function (o) {
  o = o || {};
  if (o.empty) return phone(nav(t('To confirm', 'Chờ xác nhận')) + '<div class="scroll">' + empty({ art: art('party', 200), title: t('You’re all caught up 🎉', 'Bạn đã xác nhận hết 🎉'), body: t('New periods show up here on their due date.', 'Kỳ mới sẽ hiện ở đây vào đúng ngày đến hạn.'), action: t('Back to Overview', 'Về Tổng quan'), actionIcon: 'house', go: 'back' }) + '</div>');
  var s = subOf('claude', 'many'), rows = [[D('2026-10-08'), ''], [D('2026-11-08'), 'queued']];
  var h = nav(t('To confirm', 'Chờ xác nhận')) + '<div class="scroll"><p class="meta muted pend-intro">' + t('Oldest first. Each one is confirmed in turn, so the next date only moves once the earlier one is settled.', 'Kỳ cũ nhất lên trước. Mỗi kỳ xác nhận lần lượt, nên ngày tiếp theo chỉ nhảy khi kỳ trước đã xong.') + '</p><div class="group">' +
    rows.map(function (r) {
      var q = r[1] === 'queued';
      return '<div class="row pend' + (q ? ' queued' : '') + '" data-go="confirm">' + logo(s, 40, q ? '' : 'wait') + '<div class="row-main"><span class="title-sm ell">' + fullName(s) + '</span><span class="meta muted">' + fd(r[0], 'dm') + ' · ' + t(-days(iso(r[0])) + ' days ago', -days(iso(r[0])) + ' ngày trước') + '</span>' +
        (q ? '<span class="meta queued-t">' + icon('lock-keyhole', 13, 'inl') + t(' After 8 Oct', ' Sau kỳ 8/10') + '</span>' : '') + '</div>' +
        '<div class="row-amt"><span class="title-sm num">' + money(myShare(s), s.cur) + '</span>' + cyc(s) + '</div>' + (q ? '<span class="qbtn off" aria-disabled="true">' + icon('check', 20) + '</span>' : '<button class="qbtn" aria-label="' + t('Mark paid', 'Đánh dấu đã trả') + '">' + icon('check', 20) + '</button>') + '</div>';
    }).join('') + '</div><p class="meta muted pend-intro">' + t('Tap a row to change the amount or mark it not paid.', 'Chạm một dòng để sửa số tiền hoặc chọn không trả.') + '</p></div>' +
    '<div class="bottom-bar">' + btn(t('Confirm all · ', 'Xác nhận tất cả · ') + money(myShare(s) * 2, s.cur), { block: true, icon: 'check-check', go: 'confirmall' }) + '</div>';
  if (o.dialog) h += dialog(t('Confirm 2 payments?', 'Xác nhận 2 khoản?'), t('Each period is saved as paid at its current price:', 'Mỗi kỳ được lưu là đã trả theo giá hiện tại:') + '<span class="dlg-list"><span>Claude Pro × 2</span><b class="num">' + money(myShare(s) * 2, s.cur) + '</b></span>' + t('You can edit any payment later.', 'Bạn vẫn sửa được từng khoản sau.'), [btn(t('Confirm all', 'Xác nhận tất cả'), { block: true, go: 'next' }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true })]);
  return phone(h);
};
SCR.celebrate = function () {
  var s = subOf('canva'), sv = r2(savings(data()) + yearlyCost(s));
  return phone(nav('', { close: true }) + '<div class="celebrate"><div class="confetti" aria-hidden="true">' + new Array(18).join('<i></i>') + '</div>' + art('party', 220) +
    '<h1 class="headline">' + t('Nice — that’s ', 'Tuyệt — thêm ') + money(yearlyCost(s)) + t(' a year saved', ' mỗi năm') + '</h1>' +
    '<p class="body muted">' + t('Canva Pro is marked as cancelled. Remember to cancel it on canva.com too — Subnest can’t do that for you.', 'Canva Pro đã được đánh dấu huỷ. Nhớ huỷ cả trên canva.com — Subnest không làm thay được.') + '</p>' +
    '<div class="save-total"><span class="meta muted">' + t('Total saving', 'Tổng tiết kiệm') + '</span><span class="title num">' + money(sv) + t(' a year', '/năm') + '</span><span class="meta muted">' + t('from 3 cancelled subscriptions', 'từ 3 gói đã huỷ') + '</span></div>' +
    '<div class="ob-foot col">' + btn(t('Done', 'Xong'), { block: true, go: 'next' }) + btn(t('Undo', 'Hoàn tác'), { kind: 'text', block: true }) + '</div></div>');
};
SCR.browser = function (host) {
  return phone('<div class="browser"><div class="br-bar">' + icon('x', 22) + '<span class="br-url">' + icon('lock', 13) + host + '</span>' + icon('external-link', 20) + '</div>' +
    '<div class="br-page"><div class="br-logo"></div><div class="br-h"></div><div class="br-l"></div><div class="br-l s"></div><div class="br-l"></div><div class="br-btn">' + t('Cancel membership', 'Huỷ gói thành viên') + '</div><div class="br-l s"></div></div>' +
    '<div class="br-back" data-go="back">' + icon('chevron-left', 18) + t('Back to Subnest', 'Quay lại Subnest') + '</div></div>', { sb: {} });
};

/* ---------------- Calendar (tab 2) ---------------- */
SCR.calendar = function (o) {
  o = o || {};
  var subs = data(o.scn), y = 2026, m = o.month == null ? 10 : o.month, sel = o.sel || (m === 10 ? 12 : 15);
  var c = monthCash(subs, y, m), past = new Date(y, m + 1, 1) <= TODAY;
  var h = '<div class="scroll cal">' + largeTop(t('Calendar', 'Lịch'), null, '') +
    '<div class="cal-bar"><div class="cal-nav"><button class="icon-btn" data-go="prev" aria-label="' + t('Previous month', 'Tháng trước') + '">' + icon('chevron-left', 22) + '</button><span class="title-sm nowrap">' + fd(new Date(y, m, 1), 'my') + '</span><button class="icon-btn" data-go="nextm" aria-label="' + t('Next month', 'Tháng sau') + '">' + icon('chevron-right', 22) + '</button></div>' +
    seg([t('Month', 'Tháng'), t('List', 'Danh sách')], o.view === 'agenda' ? 1 : 0, 'seg-mini', ['vmonth', 'agenda']) + '</div>' +
    '<div class="cal-total"><span class="meta muted">' + (LANG === 'vi' ? 'Tháng ' + (m + 1) + ':' : MONTH_EN[m] + ':') + '</span><span class="title num">≈ ' + money(r2(c.paid + c.due)) + '</span>' +
    '<span class="meta muted">' + (past ? t(c.ev.length + ' paid', c.ev.length + ' đã trả') : t(c.ev.filter(function (e) { return e.st === 'paid'; }).length + ' paid · ' + c.ev.filter(function (e) { return e.st !== 'paid'; }).length + ' to come', c.ev.filter(function (e) { return e.st === 'paid'; }).length + ' đã trả · ' + c.ev.filter(function (e) { return e.st !== 'paid'; }).length + ' sắp tới')) + '</span></div>';
  var evRow = function (e, withDate) {
    var s = e.s, w = e.st === 'wait';
    var st = w ? awaitBadge() : e.st === 'paid' ? '<span class="hist-st ok">' + icon('circle-check', 15) + t('Paid', 'Đã trả') + '</span>' : '<span class="meta muted">' + (s.status === 'trial' && iso(e.d) === s.due ? t('First charge after trial', 'Lần trừ đầu sau dùng thử') : left(iso(e.d))) + '</span>';
    return '<div class="row' + (w ? ' awaiting' : '') + '" data-go="detail-' + s.id + '">' + (withDate ? '<span class="ag-date"><b>' + e.d.getDate() + '</b><span>' + (LANG === 'vi' ? DOW_VI[e.d.getDay()] : DOW[e.d.getDay()]) + '</span></span>' : '') + logo(s, 40, w ? 'wait' : '') +
      '<div class="row-main"><span class="title-sm ell">' + fullName(s) + '</span><span class="row-sub">' + st + '</span></div>' +
      '<div class="row-amt"><span class="title-sm num">' + money(r2(myShare(s, e.d)), s.cur) + '</span>' + cyc(s) + '</div></div>';
  };
  if (o.view === 'agenda') {
    var ev = allEvents(subs, new Date(2026, 10, 1), new Date(2027, 0, 1)).filter(function (e) { return e.st !== 'paid'; });
    var grp = [[t('To confirm', 'Chờ xác nhận'), ev.filter(function (e) { return e.st === 'wait'; })], [t('This week', 'Tuần này'), ev.filter(function (e) { return e.st === 'up' && days(iso(e.d)) < 7; })],
      [t('Later in November', 'Cuối tháng 11'), ev.filter(function (e) { return e.st === 'up' && days(iso(e.d)) >= 7 && e.d.getMonth() === 10; })], [t('December', 'Tháng 12'), ev.filter(function (e) { return e.d.getMonth() === 11; })]];
    h += grp.filter(function (g) { return g[1].length; }).map(function (g) { return '<div class="caption eyebrow grp-head">' + g[0] + '</div><div class="group">' + g[1].map(function (e) { return evRow(e, true); }).join('') + '</div>'; }).join('') + '</div>' + fab();
    return phone(h, { tab: 1 });
  }
  var first = new Date(y, m, 1), off = (first.getDay() + 6) % 7, n = dim(y, m), cells = '';
  for (var i = 0; i < off; i++) cells += '<span class="cd out"></span>';
  for (var d = 1; d <= n; d++) {
    var es = c.ev.filter(function (e) { return e.d.getDate() === d; }), wait = es.some(function (e) { return e.st === 'wait'; }), isT = m === 10 && d === 10;
    cells += '<span class="cd' + (isT ? ' today' : '') + (d === sel ? ' sel' : '') + (wait ? ' wait' : '') + '"><span class="cd-n">' + d + '</span><span class="cd-lg">' +
      es.slice(0, 3).map(function (e) { return '<i class="ml m-' + e.st + '" style="--c:' + e.s.color + '">' + e.s.mono.slice(0, 1) + '</i>'; }).join('') + (es.length > 3 ? '<em>+' + (es.length - 3) + '</em>' : '') + '</span>' +
      (wait ? '<span class="cd-w">' + icon('clock', 10) + '</span>' : '') + '</span>';
  }
  var wd = LANG === 'vi' ? ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'] : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  h += '<div class="card cal-card"><div class="cal-grid cal-wd">' + wd.map(function (x) { return '<span>' + x + '</span>'; }).join('') + '</div><div class="cal-grid">' + cells + '</div>' +
    '<div class="cal-legend meta muted"><span><i class="ml m-paid" style="--c:var(--ink-muted)"></i>' + t('Paid', 'Đã trả') + '</span><span><i class="ml m-up" style="--c:var(--ink-muted)"></i>' + t('Expected', 'Dự kiến') + '</span><span class="lg-w">' + icon('clock', 12) + t('To confirm', 'Chờ xác nhận') + '</span></div></div>';
  var dayEv = c.ev.filter(function (e) { return e.d.getDate() === sel; }), dd = new Date(y, m, sel);
  h += '<div class="caption eyebrow grp-head">' + fd(dd, 'wdm') + (days(iso(dd)) === 0 ? t(' · Today', ' · Hôm nay') : '') + '</div><div class="group">' + (dayEv.length ? dayEv.map(function (e) { return evRow(e); }).join('') : '<div class="list-empty meta muted">' + t('Nothing due this day.', 'Không có khoản nào ngày này.') + '</div>') + '</div></div>' + fab();
  return phone(h, { tab: 1 });
};

/* ---------------- Insights (tab 3) ---------------- */
function picker(y, m, year) {
  var fut = !year && new Date(y, m, 1) > TODAY;
  return '<div class="mpick">' + seg([t('Month', 'Tháng'), t('Year', 'Năm')], year ? 1 : 0, 'seg-mini', ['mode-m', 'mode-y']) +
    '<div class="mp-nav"><button class="icon-btn" data-go="prevm" aria-label="' + t('Previous', 'Trước') + '">' + icon('chevron-left', 22) + '</button><span class="title-sm nowrap">' + (year ? y : fd(new Date(y, m, 1), 'my')) + '</span>' +
    '<button class="icon-btn" data-go="nextm" aria-label="' + t('Next', 'Sau') + '">' + icon('chevron-right', 22) + '</button></div>' + (fut ? '<span class="proj-tag">' + icon('sparkles', 12) + t('Projected', 'Dự kiến') + '</span>' : '') + '</div>';
}
function bars12(subs, y, m, year) {
  var cols = [], i, base = new Date(y, 0, 1);
  for (i = 0; i < 12; i++) { var x = addM(base, i); cols.push([x.getFullYear(), x.getMonth(), monthSpend(subs, x.getFullYear(), x.getMonth())]); }
  var max = Math.max.apply(null, cols.map(function (c) { return c[2]; })) || 1;
  return '<div class="card c-bars"><div class="ch-h"><span class="label">' + (year ? t('Each month of ' + y, 'Từng tháng năm ' + y) : t('12 months', '12 tháng')) + '</span><span class="meta muted">' + t('Tap a bar', 'Chạm một cột') + '</span></div>' +
    '<div class="bars">' + cols.map(function (c) {
      var on = !year && c[0] === y && c[1] === m, fut = new Date(c[0], c[1], 1) > TODAY;
      return '<span class="bc' + (on ? ' on' : '') + (fut ? ' fut' : '') + '" data-go="col-' + c[1] + '" title="' + monthName(c[1], true) + ' ' + money(c[2]) + '"><i style="height:' + Math.max(3, Math.round(c[2] / max * 100)) + '%"></i><span>' + monthName(c[1], true).replace('Thg ', '') + '</span></span>';
    }).join('') + '</div><div class="ch-legend meta muted"><span><i class="lsq"></i>' + t('Monthly cost', 'Chi phí tháng') + '</span><span><i class="lsq fut"></i>' + t('Projected', 'Dự kiến') + '</span></div></div>';
}
function donut(lines) {
  var by = {}; lines.forEach(function (l) { by[l.s.cat] = (by[l.s.cat] || 0) + l.v; });
  var cats = Object.keys(by).sort(function (a, b) { return by[b] - by[a]; }), tot = cats.reduce(function (a, c) { return a + by[c]; }, 0) || 1, off = 0, R = 52, C = 2 * Math.PI * R;
  var segs = cats.map(function (c) { var f = by[c] / tot, sgm = '<circle r="' + R + '" cx="70" cy="70" fill="none" stroke="' + CAT_COL[c] + '" stroke-width="22" stroke-dasharray="' + (f * C - 2).toFixed(1) + ' ' + C.toFixed(1) + '" stroke-dashoffset="' + (-off * C).toFixed(1) + '" transform="rotate(-90 70 70)"/>'; off += f; return sgm; }).join('');
  return '<div class="donut-w"><svg viewBox="0 0 140 140" width="132" height="132" role="img" aria-label="' + t('Spending by category', 'Chi tiêu theo danh mục') + '">' + segs + '</svg>' +
    '<div class="legend">' + cats.map(function (c) { return '<div class="lg-row" data-go="cat-' + c + '"><i style="background:' + CAT_COL[c] + '"></i><span class="grow">' + catName(c) + '</span><span class="meta muted">' + Math.round(by[c] / tot * 100) + '%</span><span class="num lg-v">' + money(r2(by[c])) + '</span></div>'; }).join('') + '</div></div>';
}
function riseCard(subs) {
  var rs = rises(subs), mo = r2(rs.reduce(function (a, s) { return a + riseOf(s); }, 0));
  if (!rs.length) return '<div class="card c-rise"><div class="ch-h"><span class="label">' + t('Price rises', 'Tăng giá') + '</span></div><div class="list-empty meta muted">' + t('No subscription got more expensive in the last 12 months.', 'Không gói nào tăng giá trong 12 tháng qua.') + '</div></div>';
  return '<div class="card c-rise"><div class="ch-h"><span class="label">' + icon('trending-up', 18, 'rise-ic') + t('Price rises', 'Tăng giá') + '</span></div>' +
    '<div class="rise-big"><span class="title num rise-t">+' + money(mo) + '</span><span class="meta">' + t(' more a month than a year ago', ' mỗi tháng so với một năm trước') + '</span></div>' +
    '<div class="meta muted">' + t('That’s ', 'Tức là ') + '<b class="num ink">' + money(r2(mo * 12)) + '</b>' + t(' a year · ', ' mỗi năm · ') + t(rs[0].name + ' changed the most', rs[0].name + ' thay đổi nhiều nhất') + '</div>' +
    '<div class="group flat">' + rs.map(function (s) { var h = s.hist[s.hist.length - 1]; return '<div class="srow" data-go="detail-' + s.id + '">' + logo(s, 32) + '<span class="grow"><span class="srow-l">' + fullName(s) + '</span><span class="meta muted num">' + money(h.old, s.cur) + ' → ' + money(h.nw, s.cur) + ' ' + cyc(s) + '</span></span><span class="ph-d isup num">+' + money(riseOf(s)) + '</span>' + icon('chevron-right', 18, 'muted') + '</div>'; }).join('') + '</div>' +
    btn(t('Review ', 'Xem xét ') + rs[0].name, { kind: 'tonal', block: true, sm: true, go: 'review', cls: 'mt12' }) + '</div>';
}
function next12Card(subs) {
  var f = forecast(subs), mx = Math.max(f.next, f.last) || 1;
  var line = function (lab, n, v) { return '<div class="fc-row"><span class="grow">' + lab + (n ? ' <span class="meta muted">· ' + n + '</span>' : '') + '</span><b class="num ' + (v > 0 ? 'rise-t' : v < 0 ? 'fall-t' : '') + '">' + (v > 0 ? '+' : '') + money(v) + '</b></div>'; };
  return '<div class="card c-next"><div class="ch-h"><span class="label">' + icon('calendar-range', 18) + t('Next 12 months', '12 tháng tới') + '</span></div>' +
    '<div class="fc-bars"><div class="fc-b"><span class="meta muted">' + t('Projected', 'Dự tính') + '</span><span class="fc-track"><i class="on" style="width:' + Math.round(f.next / mx * 100) + '%"></i></span><b class="num">≈ ' + money(f.next) + '</b></div>' +
    '<div class="fc-b"><span class="meta muted">' + t('Last 12 months', '12 tháng qua') + '</span><span class="fc-track"><i style="width:' + Math.round(f.last / mx * 100) + '%"></i></span><b class="num">≈ ' + money(f.last) + '</b></div></div>' +
    '<div class="fc-head">≈ <b class="num ' + (f.diff > 0 ? 'rise-t' : 'fall-t') + '">' + (f.diff > 0 ? '+' : '') + money(f.diff) + '</b>' + t(' a year compared with the last 12 months', ' mỗi năm so với 12 tháng qua') + '</div>' +
    '<div class="fc-tab">' + line(t('New this year', 'Gói đăng ký thêm năm nay'), nsub(f.cNew), f.nNew) + line(t('Price rises', 'Gói tăng giá'), nsub(f.cRise), f.nRise) +
    (f.nGone ? line(t('Cancelled or paused', 'Đã huỷ hoặc tạm dừng'), nsub(f.cGone), f.nGone) : '') + line(t('Other', 'Khác'), '', f.other) + '</div>' +
    '<div class="two-btn">' + btn(t('Review ', 'Xem xét ') + f.top.name, { kind: 'tonal', sm: true, go: 'review-top' }) + btn(t('View as list', 'Xem dạng danh sách'), { kind: 'text', sm: true, go: 'fc-list' }) + '</div></div>';
}
function upcomingCard(subs, weeks) {
  var cols = [], i, ev = allEvents(subs, TODAY, addM(TODAY, 12)).filter(function (e) { return e.st !== 'paid'; });
  if (weeks) { for (i = 0; i < 13; i++) { var a = new Date(TODAY); a.setDate(a.getDate() + 7 * i); var b = new Date(a); b.setDate(b.getDate() + 7); var wk = 46 + i; cols.push([t('W', 'T') + (wk > 52 ? wk - 52 : wk), r2(ev.filter(function (e) { return e.d >= a && e.d < b; }).reduce(function (x, e) { return x + e.amt; }, 0))]); } }
  else { for (i = 0; i < 12; i++) { var mm = addM(new Date(2026, 10, 1), i); cols.push([monthName(mm.getMonth(), true).replace('Thg ', 'T'), r2(ev.filter(function (e) { return e.d.getMonth() === mm.getMonth() && e.d.getFullYear() === mm.getFullYear(); }).reduce(function (x, e) { return x + e.amt; }, 0))]); } }
  var max = Math.max.apply(null, cols.map(function (c) { return c[1]; })) || 1, pk = cols.reduce(function (a, c) { return c[1] > a[1] ? c : a; }, cols[0]);
  return '<div class="card c-up"><div class="ch-h"><span class="label">' + t('Coming up', 'Sắp tới') + '</span>' + seg([t('13 weeks', '13 tuần'), t('12 months', '12 tháng')], weeks ? 0 : 1, 'seg-mini', ['w13', 'm12']) + '</div>' +
    '<div class="bars upb' + (weeks ? ' w13' : '') + '">' + cols.map(function (c) { return '<span class="bc fut2' + (c === pk ? ' pk' : '') + '"><i style="height:' + Math.max(c[1] ? 4 : 0, Math.round(c[1] / max * 100)) + '%"></i><span>' + c[0] + '</span></span>'; }).join('') + '</div>' +
    '<div class="meta muted">' + t('Biggest: ', 'Lớn nhất: ') + '<b class="ink">' + pk[0] + '</b> · ≈ <b class="num ink">' + money(pk[1]) + '</b>' + (weeks ? '' : t(' (Google One renews)', ' (Google One gia hạn)')) + '</div>' +
    '<button class="link label mt12" data-go="up-list">' + t('View as list', 'Xem dưới dạng danh sách') + '</button></div>';
}
function budgetCard(subs) {
  var b = BUD(), lines = monthLines(subs, 2026, 10), by = {}; lines.forEach(function (l) { by[l.s.cat] = (by[l.s.cat] || 0) + l.v; });
  return '<div class="card c-bud"><div class="ch-h"><span class="label">' + t('Budgets', 'Ngân sách') + '</span><a class="link label" data-go="budget-edit">' + t('Edit', 'Sửa') + '</a></div>' +
    Object.keys(b.cats).map(function (c) { var v = r2(by[c] || 0), p = v / b.cats[c], over = p > 1; return '<div class="bud-r"><div class="bud-t"><span class="ci" style="--c:' + CAT_COL[c] + '">' + icon(CAT_IC[c], 14) + '</span><span class="grow label">' + catName(c) + '</span><span class="meta num ' + (over ? 'danger-t' : 'muted') + '">' + (over ? icon('circle-alert', 13, 'inl') + ' ' : '') + money(v) + ' / ' + money(b.cats[c], null, { whole: true }) + '</span></div>' + pbar(Math.min(1, p), over ? 'over' : p > .85 ? 'near' : '') + '</div>'; }).join('') + '</div>';
}
function saveCard(subs) {
  var no = subs.filter(function (s) { return s.worth === 'no' && s.status === 'active'; }), nv = r2(no.reduce(function (a, s) { return a + yearlyCost(s); }, 0));
  return '<div class="card c-save"><span class="sv-ic">' + icon('piggy-bank', 22) + '</span><div class="grow"><span class="label">' + t('You’re saving ', 'Bạn đang tiết kiệm ') + '<b class="num">' + money(savings(subs)) + '</b>' + t(' a year', '/năm') + '</span><span class="meta muted">' + t('by cancelling 2 subscriptions', 'nhờ huỷ 2 gói') + '</span>' +
    '<div class="sv-hint"><span class="meta">' + t('Dropping the ' + no.length + ' you marked “Not worth it” would save ', 'Bỏ ' + no.length + ' gói bạn đánh giá “Không đáng” sẽ tiết kiệm thêm ') + '<b class="num">' + money(nv) + '</b>' + t(' more a year.', '/năm.') + '</span><span class="avs">' + no.map(function (s) { return logo(s, 24); }).join('') + '</span></div></div></div>' +
    '<div class="card c-hint">' + icon('lightbulb', 20) + '<span class="meta">' + t('You pay for 3 video services — do you need all of them?', 'Bạn trả 3 dịch vụ video — cần cả ba không?') + '</span></div>';
}
/* o: { y, m, year, scroll, weeks, scn } */
SCR.insights = function (o) {
  o = o || {};
  var subs = data(o.scn), y = o.y || 2026, m = o.m == null ? 10 : o.m, yr = !!o.year;
  var head = largeTop(t('Insights', 'Thống kê'), null, '');
  if (!subs.length) return phone('<div class="scroll">' + head + picker(y, m, yr) + empty({ art: art('chart', 180), title: t('Add subscriptions to see insights', 'Thêm gói để xem thống kê'), body: t('Monthly cost, categories, price rises and the next 12 months show up here.', 'Chi phí tháng, danh mục, tăng giá và 12 tháng tới sẽ hiện ở đây.'), action: t('Browse services', 'Xem thư viện dịch vụ'), actionIcon: 'layout-grid', go: 'fab' }) + '</div>', { tab: 2 });
  var past = !yr && new Date(y, m + 1, 1) <= TODAY, fut = !yr && new Date(y, m, 1) > TODAY;
  var big, prev, lines = [], cash, perLbl;
  if (yr) { big = yearSpend(subs, y); prev = yearSpend(subs, y - 1); for (var k = 0; k < 12; k++) lines = lines.concat(monthLines(subs, y, k)); }
  else { big = monthSpend(subs, y, m); prev = monthSpend(subs, y, m - 1); lines = monthLines(subs, y, m); }
  var agg = {}; lines.forEach(function (l) { agg[l.s.id] = agg[l.s.id] || { s: l.s, v: 0 }; agg[l.s.id].v = r2(agg[l.s.id].v + l.v); });
  var top = Object.keys(agg).map(function (k) { return agg[k]; }).sort(function (a, b) { return b.v - a.v; });
  if (yr) { var ev = allEvents(subs, new Date(y, 0, 1), new Date(y + 1, 0, 1)), pd = 0, du = 0; ev.forEach(function (e) { if (e.st === 'paid') pd += e.amt; else du += e.amt; }); cash = cashBar(r2(pd), r2(du)); }
  else { var c = monthCash(subs, y, m); cash = past ? cashBar(c.paid, 0, { past: true }) : cashBar(c.paid, c.due); }
  perLbl = yr ? '≈ <b class="num">' + money(r2(big / 12)) + '</b> ' + t('a month', 'mỗi tháng') : '≈ <b class="num">' + money(r2(big / dim(y, m))) + '</b> ' + t('a day', 'mỗi ngày');
  var nAct = Object.keys(agg).length;
  var h = '<div class="scroll ins">' + head + picker(y, m, yr) +
    '<section class="costcard ins-c">' + '<div class="cc-top"><span class="label">' + (yr ? t('Cost in ' + y, 'Chi phí năm ' + y) : t('Cost of ' + MONTH_EN[m], 'Chi phí tháng ' + (m + 1))) + '</span>' + (prev ? delta(r2(big - prev), { vs: yr ? t('vs ' + (y - 1), 'so với ' + (y - 1)) : t('vs ' + MON[(m + 11) % 12], 'so với thg ' + ((m + 11) % 12 + 1)) }) : '') + '</div>' +
    '<div class="cc-big"><span class="display num"><span class="approx">≈</span>' + money(big) + '</span>' + info('info') + '</div>' +
    '<div class="meta muted cc-sub">' + t(nAct + ' subscriptions', nAct + ' gói') + ' · ' + perLbl + '</div>' + cash + '</section>' +
    bars12(subs, y, m, yr) +
    '<div class="card c-cat"><div class="ch-h"><span class="label">' + t('By category', 'Theo danh mục') + '</span><span class="meta muted">' + (yr ? y : fd(new Date(y, m, 1), 'my')) + '</span></div>' + donut(lines) + '</div>' +
    '<div class="card c-top"><div class="ch-h"><span class="label">' + t('Most expensive', 'Đắt nhất') + '</span><span class="meta muted">' + (yr ? t('share of the year', 'phần trong năm') : t('share of the month', 'phần trong tháng')) + '</span></div><div class="group flat">' +
    top.slice(0, 5).map(function (a, i) { return '<div class="srow" data-go="detail-' + a.s.id + '"><span class="rank num">' + (i + 1) + '</span>' + logo(a.s, 32) + '<span class="grow"><span class="srow-l">' + fullName(a.s) + '</span><span class="meta muted num">' + money(a.s.share ? myShare(a.s) : a.s.price, a.s.cur) + ' ' + cyc(a.s) + '</span></span><span class="num label">' + money(a.v) + '</span></div>'; }).join('') + '</div></div>' +
    riseCard(subs) + next12Card(subs) + upcomingCard(subs, o.weeks !== false) + budgetCard(subs) + saveCard(subs) + '</div>';
  if (o.sheet === 'info') h += infoSheet();
  return phone(h, { tab: 2 });
};
SCR.category = function () {
  var subs = data(), lines = monthLines(subs, 2026, 10).filter(function (l) { return l.s.cat === 'video'; }), tot = r2(lines.reduce(function (a, l) { return a + l.v; }, 0));
  return phone(nav(t('Video · November', 'Video · Tháng 11')) + '<div class="scroll"><div class="cat-head"><span class="ci big" style="--c:' + CAT_COL.video + '">' + icon('film', 22) + '</span><span class="title num">≈ ' + money(tot) + '</span><span class="meta muted">' + t(lines.length + ' subscriptions · ' + Math.round(tot / monthSpend(subs, 2026, 10) * 100) + '% of November', lines.length + ' gói · ' + Math.round(tot / monthSpend(subs, 2026, 10) * 100) + '% của tháng 11') + '</span></div>' +
    '<div class="group rows">' + lines.map(function (l) { return row(l.s, { short: true }); }).join('') + '</div><p class="meta muted pend-intro">' + t('Disney+ still counts in November — its pause starts on 21 Nov.', 'Disney+ vẫn tính trong tháng 11 — tạm dừng từ 21/11.') + '</p></div>');
};
SCR.forecastList = function () {
  var f = forecast(data()), byM = {};
  f.ev.forEach(function (e) { var k = e.d.getFullYear() * 12 + e.d.getMonth(); (byM[k] = byM[k] || []).push(e); });
  return phone(nav(t('Next 12 months', '12 tháng tới')) + '<div class="scroll"><div class="cat-head"><span class="title num">≈ ' + money(f.next) + '</span><span class="meta muted">' + t(f.ev.length + ' expected charges from real due dates', f.ev.length + ' lần trừ dự kiến theo ngày thanh toán thật') + '</span></div>' +
    Object.keys(byM).slice(0, 4).map(function (k) { var es = byM[k], mm = es[0].d; return '<div class="caption eyebrow grp-head fc-gh"><span>' + fd(mm, 'my') + '</span><b class="num">' + money(r2(es.reduce(function (a, e) { return a + e.amt; }, 0))) + '</b></div><div class="group">' + es.map(function (e) { return '<div class="row"><span class="ag-date"><b>' + e.d.getDate() + '</b><span>' + (LANG === 'vi' ? DOW_VI[e.d.getDay()] : DOW[e.d.getDay()]) + '</span></span>' + logo(e.s, 32, e.st === 'wait' ? 'wait' : '') + '<div class="row-main"><span class="title-sm ell">' + fullName(e.s) + '</span></div><div class="row-amt"><span class="title-sm num">' + money(e.amt) + '</span>' + cyc(e.s) + '</div></div>'; }).join('') + '</div>'; }).join('') + '</div>');
};

/* ---------------- Settings (tab 4, §4.10) ---------------- */
function aboutGroup() {
  return '<div class="caption eyebrow grp-head">' + t('About', 'Giới thiệu') + '</div><div class="card about-in"><div class="ab-top">' + mark(44) + '<span class="grow"><span class="title-sm">Subnest</span><span class="meta muted">' + t('Version 1.0.0 (3)', 'Phiên bản 1.0.0 (3)') + '</span></span></div>' +
    '<div class="ab-kv"><span class="meta muted">' + t('Service library', 'Thư viện dịch vụ') + '</span><span class="meta">' + t('Updated 3 days ago · 512 services', 'Cập nhật 3 ngày trước · 512 dịch vụ') + '</span><span class="meta muted">' + t('Price lists', 'Bảng giá') + '</span><span class="meta">US + ' + t('Vietnam', 'Việt Nam') + '</span></div>' +
    '<div class="ab-links">' + [[t('Privacy policy', 'Chính sách quyền riêng tư'), 'shield-check'], [t('Terms', 'Điều khoản'), 'file-text'], [t('Licences', 'Giấy phép'), 'scroll-text'], [t('Rate the app', 'Đánh giá app'), 'star'], [t('Send feedback', 'Gửi góp ý'), 'mail']].map(function (l) { return '<span class="ab-l">' + icon(l[1], 16) + l[0] + '</span>'; }).join('') + '</div>' +
    '<p class="meta muted ab-tm">' + t('Service names and logos belong to their respective owners.', 'Tên và logo dịch vụ thuộc chủ sở hữu tương ứng.') + '</p></div>';
}
SCR.settings = function (o) {
  o = o || {};
  var pin = !!o.pin;
  var h = '<div class="scroll set">' + largeTop(t('Settings', 'Cài đặt')) +
    group([setRow({ icon: 'coins', label: t('Main currency', 'Tiền tệ chính'), value: P() }), setRow({ icon: 'refresh-cw', label: t('Exchange rates', 'Tỷ giá'), value: t('Auto · 2 h ago', 'Tự động · 2 giờ trước'), go: 'rates' })], t('Money', 'Tiền')) +
    group([setRow({ icon: 'bell', label: t('Remind me', 'Nhắc trước'), value: t('On the day, 3 days', 'Đúng ngày, 3 ngày'), go: 'reminders' }), setRow({ icon: 'clock', label: t('Reminder time', 'Giờ nhắc'), value: '9:00' }),
      setRow({ icon: 'bell-ring', label: t('Notifications', 'Thông báo'), value: o.notifOff ? '<span class="warn-t">' + t('Off', 'Tắt') + '</span>' : t('Allowed', 'Đã cho phép') })], t('Reminders', 'Nhắc nhở')) +
    group([setRow({ icon: 'sun-moon', label: t('Theme', 'Giao diện'), value: t('System', 'Theo hệ thống'), go: 'appearance' }), setRow({ icon: 'languages', label: t('Language', 'Ngôn ngữ'), value: t('English', 'Tiếng Việt'), go: 'language' }),
      setRow({ icon: 'panel-bottom', label: t('Hide tab bar when scrolling', 'Ẩn thanh tab khi cuộn'), right: toggle(false), chevron: false })], t('Appearance & language', 'Giao diện & ngôn ngữ')) +
    group([setRow({ icon: 'shapes', label: t('Categories', 'Danh mục'), value: '11', go: 'cats' }), setRow({ icon: 'tag', label: t('Labels', 'Nhãn'), value: '4', go: 'labels' }),
      setRow({ icon: 'credit-card', label: t('Payment methods', 'Phương thức thanh toán'), value: '5', go: 'methods' }), setRow({ icon: 'target', label: t('Budget', 'Ngân sách'), value: money(BUD().total, null, { whole: true }) + t('/mo', '/tháng'), go: 'budget' })], t('Organize', 'Sắp xếp gói')) +
    '<div class="caption eyebrow grp-head">' + t('Automation', 'Tự động') + ' <span class="pro">PRO</span></div><div class="group">' +
      setRow({ icon: 'scan-line', label: t('Screenshot scan', 'Quét ảnh chụp'), sub: t('Add from store pages and receipts', 'Thêm từ trang cửa hàng và hoá đơn'), go: 'scan' }) +
      setRow({ icon: 'bell-ring', label: t('Bank & wallet notifications', 'Thông báo ngân hàng/ví'), value: '<span class="soon">' + t('Soon', 'Sắp có') + '</span>', chevron: false }) +
      setRow({ icon: 'mail', label: 'Gmail', value: '<span class="soon">' + t('Soon', 'Sắp có') + '</span>', chevron: false }) + '</div>' +
    '<div class="caption eyebrow grp-head data-h">' + t('Data', 'Dữ liệu') + '</div>' + autoBackupCard(o) +
    '<div class="group mt8">' + setRow({ icon: 'hard-drive-download', label: t('Back up now', 'Sao lưu ngay'), sub: t('A .subnest file, with or without a password', 'File .subnest, có hoặc không mật khẩu'), go: 'backupnow' }) +
      setRow({ icon: 'folder-open', label: t('Restore', 'Khôi phục'), sub: t('Replaces everything on this phone', 'Thay thế toàn bộ dữ liệu trên máy'), go: 'restore' }) +
      setRow({ icon: 'file-spreadsheet', label: t('Export CSV', 'Xuất CSV'), sub: t('Subscriptions and payments, for spreadsheets', 'Gói và thanh toán, mở bằng bảng tính'), chevron: false, right: icon('share', 18, 'muted') }) +
      setRow({ icon: 'trash-2', label: t('Erase all data', 'Xoá toàn bộ dữ liệu'), danger: true, go: 'erase' }) + '</div>' +
    group([setRow({ icon: 'lock-keyhole', label: t('PIN lock', 'Khoá mã PIN'), sub: pin ? t('On · asks after 1 minute away', 'Bật · hỏi khi quay lại sau 1 phút') : t('4 digits, asked when Subnest opens', '4 số, hỏi khi mở Subnest'), right: '<span data-go="pin" class="tg-hit">' + toggle(pin) + '</span>', chevron: false }),
      pin ? setRow({ icon: 'key-round', label: t('Change PIN', 'Đổi mã PIN') }) : '',
      setRow({ icon: 'eye-off', label: t('Hide content in app switcher', 'Che nội dung khi chuyển app'), sub: t('Also blocks screenshots', 'Đồng thời chặn chụp màn hình'), right: toggle(true), chevron: false })], t('Security', 'Bảo mật')) +
    aboutGroup() +
    '<div class="privacy">' + icon('lock', 18) + '<span>' + t('Your data stays on this phone. Subnest collects nothing.', 'Dữ liệu của bạn chỉ nằm trên máy này. Subnest không thu thập gì.') + '</span></div></div>';
  if (o.sheet === 'appearance') h += sheet('<h2 class="title sh-title">' + t('Theme', 'Giao diện') + '</h2>' + seg([t('System', 'Hệ thống'), t('Light', 'Sáng'), t('Dark', 'Tối')], 0) +
    '<p class="meta muted sh-note">' + t('System follows your phone’s light or dark mode.', 'Hệ thống: theo chế độ sáng/tối của máy.') + '</p>');
  if (o.sheet === 'language') h += sheet('<h2 class="title sh-title">' + t('Language', 'Ngôn ngữ') + '</h2><div class="group">' + [['English', 'English'], ['Tiếng Việt', 'Vietnamese']].map(function (x, i) { var on = (LANG === 'vi' ? 1 : 0) === i; return '<div class="plan' + (on ? ' on' : '') + '"><span class="radio"></span><span class="grow"><span class="title-sm">' + x[0] + '</span><span class="meta muted">' + x[1] + '</span></span></div>'; }).join('') + '</div>' +
    '<p class="meta muted sh-note">' + t('The whole app switches right away. Dates and amounts follow the language.', 'Cả app đổi ngay. Ngày và số tiền định dạng theo ngôn ngữ.') + '</p>');
  if (o.dialog === 'erase') h += dialog(t('Erase all data?', 'Xoá toàn bộ dữ liệu?'), t('Every subscription, payment, price history, label and setting on this phone is deleted. Subnest goes back to the first-run screens. Automatic backup files in your folder are kept.', 'Mọi gói, thanh toán, lịch sử giá, nhãn và cài đặt trên máy bị xoá. Subnest quay về màn hình lần đầu. File sao lưu tự động trong thư mục vẫn được giữ.'),
    [btn(t('Continue', 'Tiếp tục'), { kind: 'danger', block: true, go: 'erase2' }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true })]);
  if (o.dialog === 'erase2') h += dialog(t('Type ERASE to confirm', 'Gõ XOA để xác nhận'), '<div class="input focus mt8"><span class="search-q">' + t('ERASE', 'XOA') + '</span><span class="caret sm"></span></div><span class="meta muted">' + t('This can’t be undone.', 'Không thể hoàn tác.') + '</span>',
    [btn(t('Erase everything', 'Xoá tất cả'), { kind: 'danger', block: true }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true })]);
  return phone(h, { tab: 3 });
};
function autoBackupCard(o) {
  if (o.backupOff) return '<div class="card ab-card off"><div class="ab-h">' + icon('database', 20) + '<span class="grow"><span class="label">' + t('Automatic backup', 'Sao lưu tự động') + '</span><span class="meta muted">' + t('Off — your data lives only on this phone', 'Tắt — dữ liệu chỉ nằm trên máy') + '</span></span><span data-go="autobackup" class="tg-hit">' + toggle(false) + '</span></div></div>';
  return '<div class="card ab-card"><div class="ab-h">' + icon('database', 20) + '<span class="grow"><span class="label">' + t('Automatic backup', 'Sao lưu tự động') + '</span><span class="meta ok-t">' + icon('circle-check', 13, 'inl') + ' ' + t('Last: yesterday, 21:00', 'Gần nhất: hôm qua, 21:00') + '</span></span>' + toggle(true) + '</div>' +
    '<div class="ab-grid"><span class="meta muted">' + t('Folder', 'Thư mục') + '</span><span class="meta ell">Download/Subnest</span><span class="meta muted">' + t('Time', 'Giờ') + '</span><span class="meta">21:00 ' + t('every day', 'mỗi ngày') + '</span>' +
    '<span class="meta muted">' + t('Password', 'Mật khẩu') + '</span><span class="meta">•••••••• ' + icon('lock', 12, 'inl') + '</span><span class="meta muted">' + t('Keeps', 'Giữ') + '</span><span class="meta">' + t('2 newest files', '2 file mới nhất') + '</span></div></div>';
}
SCR.autoBackup = function () {
  return phone(nav(t('Automatic backup', 'Sao lưu tự động')) + '<div class="scroll"><div class="ab-hero">' + icon('database', 28) + '<p class="body muted">' + t('Once a day Subnest saves an encrypted .subnest file to a folder you choose — on this phone, an SD card or a synced folder like Google Drive.', 'Mỗi ngày Subnest lưu một file .subnest đã mã hoá vào thư mục bạn chọn — trên máy, thẻ nhớ hoặc thư mục đồng bộ như Google Drive.') + '</p></div>' +
    group([setRow({ icon: 'folder', label: t('Folder', 'Thư mục'), value: 'Download/Subnest' }), setRow({ icon: 'clock', label: t('Time', 'Giờ sao lưu'), value: '21:00' }), setRow({ icon: 'layers', label: t('Keep', 'Giữ lại'), value: t('2 newest', '2 file mới nhất'), chevron: false })]) +
    '<div class="caption eyebrow grp-head">' + t('Password', 'Mật khẩu') + '</div><div class="group"><div class="field"><div class="input focus">' + icon('lock', 18, 'muted') + '<span class="search-q">••••••</span><span class="caret sm"></span>' + icon('eye', 18, 'muted') + '</div>' +
    '<span class="meta ok-t f-hint">' + icon('check', 13, 'inl') + ' ' + t('At least 6 characters', 'Ít nhất 6 ký tự') + '</span></div><div class="field"><div class="input">' + icon('lock', 18, 'muted') + '<span class="search-ph">' + t('Repeat password', 'Nhập lại mật khẩu') + '</span></div></div></div>' +
    '<div class="mt16">' + banner('warn', 'key-round', t('Write the password down', 'Ghi lại mật khẩu'), t('Without it the backup can’t be opened — there’s no reset.', 'Không có mật khẩu thì không mở được file — không thể đặt lại.')) + '</div></div>' +
    '<div class="bottom-bar">' + btn(t('Turn on automatic backup', 'Bật sao lưu tự động'), { block: true }) + '</div>');
};
SCR.backupNow = function () {
  return overlay(SCR.settings({ raw: true }), sheet('<h2 class="title sh-title">' + t('Back up now', 'Sao lưu ngay') + '</h2><div class="file-chip">' + icon('file-lock', 22) + '<span class="grow"><span class="label">subnest-2026-11-10.subnest</span><span class="meta muted">' + t('12 subscriptions · 148 payments · 41 KB', '12 gói · 148 thanh toán · 41 KB') + '</span></span></div>' +
    '<div class="field"><div class="f-row"><span class="grow"><span class="label">' + t('Protect with a password', 'Đặt mật khẩu') + '</span><span class="meta muted">' + t('Recommended if you save it to the cloud', 'Nên bật nếu lưu lên đám mây') + '</span></span>' + toggle(true) + '</div><div class="input mt8">' + icon('lock', 18, 'muted') + '<span class="search-q">••••••••</span></div></div>' +
    '<div class="sh-actions mt16">' + btn(t('Save file…', 'Lưu file…'), { block: true, icon: 'hard-drive-download' }) + btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true }) + '</div>'));
};
SCR.restore = function (o) {
  o = o || {};
  var h = nav(t('Restore', 'Khôi phục')) + '<div class="scroll"><div class="file-chip big">' + icon('file-lock', 26) + '<span class="grow"><span class="label">subnest-2026-11-09.subnest</span><span class="meta muted">Download/Subnest · ' + t('yesterday, 21:00', 'hôm qua, 21:00') + '</span></span><span class="badge badge-success">' + icon('check', 13) + t('Valid', 'Hợp lệ') + '</span></div>' +
    (o.step === 'pw' ? '<div class="caption eyebrow grp-head">' + t('This backup has a password', 'File có mật khẩu') + '</div><div class="group"><div class="field"><div class="input focus' + (o.err ? ' err' : '') + '">' + icon('lock', 18, 'muted') + '<span class="search-q">•••••••</span><span class="caret sm"></span></div>' + (o.err ? '<span class="f-err">' + icon('circle-alert', 14) + t('Wrong password', 'Sai mật khẩu') + '</span>' : '') + '</div></div>'
      : '<div class="caption eyebrow grp-head">' + t('In this file', 'Trong file') + '</div>' + group([setRow({ icon: 'layers', label: t('Subscriptions', 'Gói đăng ký'), value: '12', chevron: false }), setRow({ icon: 'receipt', label: t('Payments', 'Thanh toán'), value: '148', chevron: false }), setRow({ icon: 'history', label: t('Price changes', 'Lần đổi giá'), value: '3', chevron: false }), setRow({ icon: 'settings', label: t('Settings and labels', 'Cài đặt và nhãn'), value: t('Included', 'Có'), chevron: false })])) +
    '<div class="mt16">' + banner('warn', 'triangle-alert', t('Restoring replaces everything', 'Khôi phục sẽ thay thế toàn bộ'), t('What’s on this phone now is removed and the file’s data takes its place.', 'Dữ liệu hiện có trên máy bị xoá và thay bằng dữ liệu trong file.')) + '</div></div>' +
    '<div class="bottom-bar">' + btn(o.step === 'pw' ? t('Unlock and restore', 'Mở khoá và khôi phục') : t('Continue', 'Tiếp tục'), { block: true, go: 'next' }) + '</div>';
  if (o.dialog) h += dialog(t('Replace all data?', 'Thay thế toàn bộ dữ liệu?'), t('Your 12 current subscriptions are replaced by the 12 in this backup from yesterday, 21:00.', '12 gói hiện tại sẽ được thay bằng 12 gói trong bản sao lưu hôm qua, 21:00.'), [btn(t('Replace and restore', 'Thay thế và khôi phục'), { kind: 'danger', block: true }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true })]);
  return phone(h);
};
SCR.rates = function (o) {
  o = o || {};
  var vi = LANG === 'vi';
  var h = nav(t('Exchange rates', 'Tỷ giá')) + '<div class="scroll"><p class="meta muted pend-intro">' + t('Totals convert to USD. Rates update once a day when you’re online; set your own to override.', 'Tổng quy về VND. Tỷ giá tự cập nhật mỗi ngày khi có mạng; tự đặt để ghi đè.') + '</p>' +
    '<div class="group">' + (vi ? setRow({ label: '1 USD → <b class="num">26.350 VND</b>', sub: t('Auto · updated 2 hours ago', 'Tự động · cập nhật 2 giờ trước'), go: 'rate' }) : setRow({ label: '1 EUR → <b class="num">1.0842 USD</b>', sub: 'Auto · updated 2 hours ago', go: 'rate' }) + setRow({ label: '1 VND → <b class="num">0.000038 USD</b>', sub: '<span class="ok-t">' + icon('pencil', 12, 'inl') + ' Set by you</span>', go: 'rate' })) + '</div>' +
    btn(t('Update now', 'Cập nhật ngay'), { kind: 'tonal', block: true, icon: 'refresh-cw', cls: 'mt16' }) + '<p class="meta muted list-note">' + t('Only currencies your subscriptions use are listed.', 'Chỉ hiện các loại tiền mà gói của bạn đang dùng.') + '</p></div>';
  return phone(h);
};
SCR.reminders = function (o) {
  o = o || {};
  var h = nav(t('Reminders', 'Nhắc nhở')) + '<div class="scroll">' + (o.off ? banner('warn', 'bell-off', t('Notifications are off for Subnest', 'Thông báo của Subnest đang tắt'), t('Reminders can’t reach you until you allow them in system settings.', 'Bạn sẽ không nhận được nhắc cho tới khi cho phép trong cài đặt hệ thống.'), { label: t('Open settings', 'Mở cài đặt') }) : '') +
    '<div class="group mt8"><div class="field"><span class="f-label label">' + t('Remind me before a payment', 'Nhắc trước kỳ thanh toán') + '</span><div class="chips fit">' + [t('On the day', 'Đúng ngày'), t('1 day', '1 ngày'), t('3 days', '3 ngày'), t('7 days', '7 ngày')].map(function (x, i) { return chip(x, i === 0 || i === 2); }).join('') + '</div>' +
    '<div class="meta muted" style="margin-top:8px">' + t('Pick any combination. Trials get the same reminders before they end.', 'Chọn bao nhiêu mốc tuỳ ý. Dùng thử cũng được nhắc như vậy trước khi hết.') + '</div></div>' + setRow({ icon: 'clock', label: t('Time', 'Giờ nhắc'), value: '9:00' }) + '</div>' +
    '<p class="meta muted list-note">' + t('Each subscription can override these on its edit screen. PIN lock doesn’t change what notifications say.', 'Từng gói có thể chỉnh riêng trong màn sửa. Bật PIN không đổi nội dung thông báo.') + '</p>' +
    '<div class="caption eyebrow grp-head">' + t('Preview', 'Xem trước') + '</div><div class="notif solo">' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>9:00</span></div><div class="notif-b">' + t('Netflix renews in 3 days — $17.99', 'Netflix gia hạn sau 3 ngày — 260.000 ₫') + '</div></div></div></div>';
  return phone(h);
};
/* organize: cats | catEdit | labels | methods | budget */
SCR.organize = function (what) {
  var h, title;
  var catTile = function (c, z) { return '<span class="ci" style="--c:' + CAT_COL[c] + ';width:' + z + 'px;height:' + z + 'px">' + icon(CAT_IC[c], Math.round(z * .5)) + '</span>'; };
  var cnt = { video: 3, music: 2, ai: 2, storage: 2, software: 1, health: 1, education: 1 };
  if (what === 'cats' || what === 'catEdit' || what === 'catDelete') {
    title = t('Categories', 'Danh mục');
    h = '<p class="meta muted pend-intro">' + t('Drag to reorder. Colours are used in charts and filters.', 'Kéo để sắp xếp. Màu dùng trong biểu đồ và bộ lọc.') + '</p><div class="group">' +
      CATS.map(function (c) { return '<div class="srow">' + catTile(c, 32) + '<span class="grow"><span class="srow-l">' + catName(c) + '</span><span class="meta muted">' + nsub(cnt[c] || 0) + '</span></span>' + icon('grip-vertical', 18, 'muted') + '</div>'; }).join('') + '</div>' + btn(t('New category', 'Thêm danh mục'), { kind: 'tonal', block: true, icon: 'plus', cls: 'mt16' });
    var ph = phone(nav(title) + '<div class="scroll">' + h + '</div>');
    if (what === 'catEdit') ph = overlay(ph, sheet('<h2 class="title sh-title">' + t('Edit category', 'Sửa danh mục') + '</h2><div class="cat-prev">' + catTile('video', 56) + '<div class="input grow-in"><span class="search-q">Video</span><span class="caret sm"></span></div></div>' +
      '<div class="caption eyebrow grp-head">' + t('Colour', 'Màu') + '</div><div class="swatches">' + ['#e87ba4', '#d21f3c', '#e8590c', '#c26a00', '#1f9d55', '#0f8b8d', '#3a9be0', '#2856d8', '#7a3fe0', '#8a5a3c', '#2d3438', '#79838a'].map(function (c, i) { return '<span class="swatch' + (i === 0 ? ' on' : '') + '" style="--sw:' + c + '">' + (i === 0 ? icon('check', 16) : '') + '</span>'; }).join('') + '</div>' +
      '<div class="caption eyebrow grp-head">' + t('Icon', 'Biểu tượng') + '</div><div class="emojis">' + ['film', 'music', 'bot', 'cloud', 'cpu', 'signal', 'graduation-cap', 'gamepad-2', 'book-open', 'heart-pulse', 'dumbbell', 'receipt', 'shield', 'store', 'users-round', 'circle-ellipsis'].map(function (n, i) { return '<span class="emo' + (i === 0 ? ' on' : '') + '">' + icon(n, 20) + '</span>'; }).join('') + '</div>' +
      '<div class="sh-actions mt16">' + btn(t('Save', 'Lưu'), { block: true }) + btn(t('Delete category', 'Xoá danh mục'), { kind: 'text', block: true, icon: 'trash-2', cls: 'danger-t', go: 'catdel' }) + '</div>', { cls: 'tall' }));
    if (what === 'catDelete') ph = overlay(ph, dialog(t('Delete “Video”?', 'Xoá “Video”?'), t('3 subscriptions use it. Move them to:', '3 gói đang dùng danh mục này. Chuyển sang:') + '<div class="dlg-opts">' + ['other', 'music', 'software'].map(function (c, i) { return '<div class="plan' + (i === 0 ? ' on' : '') + '"><span class="radio"></span>' + catTile(c, 28) + '<span class="grow"><span class="title-sm">' + catName(c) + '</span></span></div>'; }).join('') + '</div>',
      [btn(t('Move and delete', 'Chuyển và xoá'), { kind: 'danger', block: true }), btn(t('Cancel', 'Huỷ'), { kind: 'text', block: true })]));
    return ph;
  }
  if (what === 'labels') {
    title = t('Labels', 'Nhãn'); var lc = { family: 2, work: 3, health: 1, trip: 0 };
    h = '<p class="meta muted pend-intro">' + t('Labels cut across categories — a subscription can have several.', 'Nhãn dùng chéo danh mục — một gói có thể có nhiều nhãn.') + '</p><div class="group">' +
      Object.keys(LABELS).map(function (k) { return '<div class="srow"><span class="lbl-big" style="--c:' + LABELS[k][2] + '">' + icon('tag', 16) + '</span><span class="grow"><span class="srow-l">' + t(LABELS[k][0], LABELS[k][1]) + '</span><span class="meta muted">' + nsub(lc[k]) + '</span></span>' + icon('pencil', 16, 'muted') + '</div>'; }).join('') + '</div>' + btn(t('New label', 'Thêm nhãn'), { kind: 'tonal', block: true, icon: 'plus', cls: 'mt16' });
  } else if (what === 'methods') {
    title = t('Payment methods', 'Phương thức thanh toán');
    h = '<p class="meta muted pend-intro">' + t('Names only — Subnest never connects to a bank or card.', 'Chỉ là tên gọi — Subnest không kết nối ngân hàng hay thẻ.') + '</p><div class="group">' +
      [['Visa ••4821', 'credit-card', 7], ['PayPal', 'wallet', 2], ['Apple Pay', 'smartphone', 2], ['Google Play', 'store', 2], ['MoMo', 'wallet', 0]].map(function (m) { return '<div class="srow"><span class="srow-ic">' + icon(m[1], 20) + '</span><span class="grow"><span class="srow-l">' + m[0] + '</span><span class="meta muted">' + nsub(m[2]) + '</span></span>' + icon('grip-vertical', 18, 'muted') + '</div>'; }).join('') + '</div>' + btn(t('Add payment method', 'Thêm phương thức'), { kind: 'tonal', block: true, icon: 'plus', cls: 'mt16' });
  } else {
    title = t('Budget', 'Ngân sách'); var b = BUD(), lines = monthLines(data(), 2026, 10), by = {}; lines.forEach(function (l) { by[l.s.cat] = (by[l.s.cat] || 0) + l.v; });
    var tot = monthSpend(data(), 2026, 10);
    h = '<div class="group"><div class="field"><span class="f-label meta muted">' + t('Monthly budget, all subscriptions', 'Ngân sách tháng, tất cả gói') + '</span><div class="price-row"><span class="amount-lg num">' + money(b.total, null, { whole: true }) + '<span class="caret"></span></span><span class="cur-btn static">' + P() + '</span></div>' +
      pbar(tot / b.total, tot / b.total > .85 ? 'near' : '') + '<span class="meta muted">' + Math.round(tot / b.total * 100) + t('% used this month · ', '% đã dùng tháng này · ') + money(tot) + '</span></div></div>' +
      '<div class="caption eyebrow grp-head">' + t('Per category · optional', 'Theo danh mục · tuỳ chọn') + '</div><div class="group">' +
      Object.keys(b.cats).map(function (c) { var over = (by[c] || 0) > b.cats[c]; return '<div class="srow">' + catTile(c, 32) + '<span class="grow"><span class="srow-l">' + catName(c) + '</span><span class="meta ' + (over ? 'danger-t' : 'muted') + ' num">' + (over ? icon('circle-alert', 12, 'inl') + ' ' : '') + money(r2(by[c] || 0)) + t(' this month', ' tháng này') + '</span></span><span class="mini-field num">' + money(b.cats[c], null, { whole: true }) + '</span></div>'; }).join('') +
      '<div class="srow">' + catTile('education', 32) + '<span class="grow"><span class="srow-l">' + catName('education') + '</span></span><span class="link label">' + t('Set', 'Đặt') + '</span></div></div>' +
      '<p class="meta muted list-note">' + t('Budgets compare against the monthly cost. Going over turns the bar red — no notifications.', 'Ngân sách so với chi phí tháng. Vượt thì thanh chuyển đỏ — không gửi thông báo.') + '</p>';
  }
  return phone(nav(title) + '<div class="scroll">' + h + '</div>');
};
SCR.automation = function (o) {
  o = o || {};
  var h = '<div class="pro-card"><span class="pro">PRO</span><h2 class="title">' + t('Let Subnest find your subscriptions', 'Để Subnest tự tìm gói đăng ký') + '</h2><p class="meta">' + t('Everything is read on this phone. Nothing is uploaded.', 'Mọi thứ được đọc ngay trên máy. Không tải gì lên.') + '</p></div>' +
    '<div class="group mt16">' + setRow({ icon: 'scan-line', label: t('Screenshot scan', 'Quét ảnh chụp'), sub: t('Google Play / App Store pages, receipts', 'Trang gói Google Play / App Store, hoá đơn'), right: btn(t('Open', 'Mở'), { sm: true, kind: 'tonal', go: 'scan' }), chevron: false }) +
    setRow({ icon: 'bell-ring', label: t('Bank & wallet notifications', 'Thông báo ngân hàng/ví'), sub: 'Android', value: '<span class="soon">' + t('Soon', 'Sắp có') + '</span>', chevron: false }) + setRow({ icon: 'mail', label: 'Gmail', sub: t('Receipts and renewal emails', 'Email hoá đơn và gia hạn'), value: '<span class="soon">' + t('Soon', 'Sắp có') + '</span>', chevron: false }) + '</div>' +
    group([setRow({ icon: 'plus', label: t('Add new ones automatically', 'Tự thêm gói mới'), right: toggle(true), chevron: false }), setRow({ icon: 'check', label: t('Confirm periods automatically', 'Tự xác nhận kỳ'), right: toggle(true), chevron: false })], t('When something is found', 'Khi tìm thấy')) +
    '<p class="meta muted list-note">' + t('Every automatic change is tagged Auto and has Undo.', 'Mọi thay đổi tự động đều gắn nhãn Tự động và có Hoàn tác.') + '</p>' +
    btn(t('Get early access', 'Đăng ký dùng sớm'), { kind: 'outline', block: true, icon: 'sparkles', go: 'pro' });
  var ph = phone(nav(t('Automation', 'Tự động')) + '<div class="scroll">' + h + '</div>');
  if (o.pro) ph = overlay(ph, sheet('<div class="pro-hero"><span class="pro">PRO</span><h2 class="title">Subnest Pro</h2><p class="meta muted">' + t('Finds and confirms subscriptions for you. Adding them by hand stays free, always.', 'Tự tìm và tự xác nhận gói cho bạn. Nhập tay luôn miễn phí.') + '</p></div>' +
    '<div class="group">' + [['scan-line', t('Screenshot scan', 'Quét ảnh chụp'), badge('success', 'check', t('Now', 'Có ngay'))], ['bell-ring', t('Bank & wallet notifications', 'Thông báo ngân hàng/ví'), '<span class="soon">' + t('Soon', 'Sắp có') + '</span>'], ['mail', 'Gmail', '<span class="soon">' + t('Soon', 'Sắp có') + '</span>'], ['rotate-ccw', t('Undo on every change', 'Hoàn tác mọi thay đổi'), '']].map(function (f) { return setRow({ icon: f[0], label: f[1], right: f[2] || '<span></span>', chevron: false }); }).join('') + '</div>' +
    '<div class="mt16">' + banner('info', 'sparkles', t('Early access', 'Đăng ký sớm'), t('Join now and we’ll tell you the price before Pro starts charging. Nothing is billed without asking you.', 'Đăng ký ngay, app sẽ báo giá trước khi Pro bắt đầu tính phí. Không trừ tiền khi chưa hỏi bạn.')) + '</div>' +
    '<div class="sh-actions mt16">' + btn(t('Join early access', 'Đăng ký dùng sớm'), { block: true }) + btn(t('Not now', 'Để sau'), { kind: 'text', block: true }) + '</div>', { cls: 'tall' }));
  return ph;
};

/* ---------------- Scan (Pro, §4.11) ---------------- */
function shot(rows) { return '<span class="shot"><i class="sh-bar"></i>' + rows.map(function (c) { return '<span class="sh-row"><i style="background:' + c + '"></i><em></em></span>'; }).join('') + '</span>'; }
var SCAN = function () {
  return [{ s: { id: 'max', name: 'Max', color: '#002be7', mono: 'Mx', kind: 'lib', cyc: [1, 'm'] }, price: 9.99, cur: 'USD', next: '2026-11-24' }, { s: { id: 'notion', name: 'Notion', plan: 'Plus', color: '#2d3438', mono: 'No', kind: 'lib', cyc: [1, 'm'] }, price: 10, cur: 'USD', next: '2026-11-25' },
    { s: { id: 'm365', name: 'Microsoft 365', plan: 'Personal', color: '#d83b01', mono: 'M', kind: 'lib', cyc: [1, 'y'] }, price: 99.99, cur: 'USD', next: '2027-01-14' }, { s: { id: 'duo', name: 'Duolingo', plan: 'Super', color: '#58cc02', mono: 'D', kind: 'lib', cyc: [1, 'y'] }, price: 59.99, cur: 'USD', next: '2027-10-12' }];
};
SCR.scan = function (step) {
  var undo = '<button class="link label">' + t('Undo', 'Hoàn tác') + '</button>';
  if (step === 'intro') {
    var st = [[t('Open your subscriptions page', 'Mở trang gói của bạn'), t('Google Play → Payments & subscriptions, or App Store → Subscriptions', 'Google Play → Thanh toán & gói thuê bao, hoặc App Store → Gói đăng ký')], [t('Take screenshots', 'Chụp màn hình'), t('Scroll and capture every subscription. Receipts work too.', 'Cuộn và chụp hết các gói. Hoá đơn cũng được.')], [t('Pick them here', 'Chọn ảnh ở đây'), t('Subnest reads them on this phone and fills everything in.', 'Subnest đọc ngay trên máy và điền sẵn mọi thứ.')]];
    return phone(nav(t('Scan screenshots', 'Quét ảnh chụp'), { close: true }) + '<div class="scroll scan"><div class="scan-art">' + shot(['#e50914', '#1db954', '#10a37f', '#3693f3']) + shot(['#002be7', '#2d3438', '#d83b01']) + '<span class="scan-badge">' + icon('scan-line', 22) + '</span></div>' +
      '<ol class="steps">' + st.map(function (s, i) { return '<li><span class="st-n num">' + (i + 1) + '</span><span class="grow"><span class="title-sm">' + s[0] + '</span><span class="meta muted">' + s[1] + '</span></span></li>'; }).join('') + '</ol>' +
      '<div class="two-btn">' + btn(t('Open Google Play', 'Mở Google Play'), { kind: 'outline', icon: 'store', sm: true }) + btn(t('Open App Store', 'Mở App Store'), { kind: 'outline', icon: 'smartphone', sm: true }) + '</div>' +
      '<div class="privacy mt16">' + icon('lock', 18) + '<span>' + t('Text is read on this phone. Your screenshots never leave it.', 'Chữ được đọc ngay trên máy. Ảnh không bao giờ rời khỏi máy.') + '</span></div></div>' +
      '<div class="bottom-bar col">' + btn(t('Choose screenshots', 'Chọn ảnh chụp'), { block: true, icon: 'images', go: 'next' }) + btn(t('Photograph a receipt', 'Chụp hoá đơn'), { kind: 'text', block: true, icon: 'camera', go: 'camera' }) + '</div>');
  }
  if (step === 'photos') {
    var li = function (ic, a, b) { return '<li><span class="st-n ic">' + icon(ic, 18) + '</span><span class="grow"><span class="title-sm">' + a + '</span><span class="meta muted">' + b + '</span></span></li>'; };
    return phone(nav(t('Scan screenshots', 'Quét ảnh chụp'), { close: true }) + '<div class="scroll scan"><div class="perm-art">' + icon('images', 40) + '</div><h2 class="title center">' + t('Subnest only sees the photos you pick', 'Subnest chỉ thấy những ảnh bạn chọn') + '</h2>' +
      '<ol class="steps">' + li('images', t('You choose the screenshots', 'Bạn tự chọn ảnh'), t('Nothing else in your gallery is opened.', 'Các ảnh khác không bị mở.')) + li('cpu', t('Read on this phone', 'Đọc ngay trên máy'), t('Text recognition works offline.', 'Nhận chữ chạy offline.')) + li('shield', t('Nothing is uploaded or kept', 'Không tải lên, không lưu ảnh'), t('Only the subscriptions found are saved.', 'Chỉ lưu các gói tìm thấy.')) + '</ol>' +
      '<p class="meta muted center">' + t('Next, your phone asks which photos Subnest may see.', 'Tiếp theo, máy hỏi bạn cho Subnest xem ảnh nào.') + '</p></div>' +
      '<div class="bottom-bar col">' + btn(t('Continue', 'Tiếp tục'), { block: true, go: 'next' }) + btn(t('Not now', 'Để sau'), { kind: 'text', block: true }) + '</div>');
  }
  if (step === 'reading') return phone(nav(t('Reading 2 screenshots', 'Đang đọc 2 ảnh'), { close: true }) + '<div class="scroll scan"><div class="scan-art reading">' + shot(['#002be7', '#2d3438', '#d83b01', '#e50914']) + shot(['#58cc02', '#10a37f']) + '<i class="scan-line"></i></div>' +
    '<div class="scan-prog" data-go="next"><span class="label">' + t('Found 3 so far…', 'Đã thấy 3 gói…') + '</span>' + pbar(.62) + '<span class="meta muted">' + t('On this phone · about 5 seconds', 'Trên máy · khoảng 5 giây') + '</span></div>' +
    '<div class="group">' + SCAN().slice(0, 3).map(function (f) { return '<div class="srow">' + logo(f.s, 32) + '<span class="grow"><span class="srow-l">' + fullName(f.s) + '</span><span class="meta muted num">' + money(f.price, f.cur) + ' ' + cyc(f.s) + '</span></span>' + icon('loader-circle', 18, 'muted spin') + '</div>'; }).join('') + '</div></div>');
  if (step === 'camera') return phone('<div class="cam"><div class="cam-top"><span class="cam-b" data-go="back">' + icon('x', 24) + '</span><span class="cam-t">' + t('Photograph a receipt', 'Chụp hoá đơn') + '</span><span class="cam-b">' + icon('zap-off', 22) + '</span></div>' +
    '<div class="cam-view"><div class="cam-frame"><div class="rcpt"><b>' + t('Order receipt', 'Hoá đơn') + '</b><i></i><span>Max · ' + t('Monthly', 'Hằng tháng') + '</span><span class="num">$9.99</span><i></i><span>' + t('Renews 24 Nov 2026', 'Gia hạn 24/11/2026') + '</span><i class="short"></i></div><span class="cn tl"></span><span class="cn tr"></span><span class="cn bl"></span><span class="cn br"></span></div></div>' +
    '<p class="cam-hint">' + icon('scan-line', 16, 'inl') + ' ' + t('Fit the receipt inside the frame', 'Đặt hoá đơn vừa trong khung') + '</p><div class="cam-bar"><span class="cam-thumb">' + icon('images', 20) + '</span><button class="shutter" aria-label="' + t('Take photo', 'Chụp') + '"></button><span class="cam-thumb ghost"></span></div></div>', { sb: { light: true }, cls: 'is-cam' });
  if (step === 'nothing') {
    var tips = [[t('Open the subscriptions list', 'Mở danh sách gói'), t('Google Play → Payments & subscriptions → Subscriptions', 'Google Play → Thanh toán & gói thuê bao → Gói thuê bao')], [t('Keep price and date in view', 'Để thấy giá và ngày'), t('Each price and renewal date should be on screen.', 'Giá và ngày gia hạn phải nằm trong ảnh.')], [t('Avoid cropped or blurry shots', 'Tránh ảnh bị cắt hoặc mờ'), t('Full-screen screenshots read best.', 'Ảnh chụp toàn màn hình đọc tốt nhất.')]];
    return phone(nav(t('Scan results', 'Kết quả quét'), { close: true }) + '<div class="scroll scan"><div class="res-head"><span class="check none">' + icon('search-x', 30) + '</span><h2 class="title">' + t('No subscriptions found', 'Không tìm thấy gói nào') + '</h2><span class="meta muted">' + t('In 2 screenshots · nothing was added', 'Trong 2 ảnh · chưa thêm gì') + '</span></div>' +
      '<div class="caption eyebrow grp-head">' + t('Try this', 'Thử cách này') + '</div><ol class="steps card-steps">' + tips.map(function (s, i) { return '<li><span class="st-n num">' + (i + 1) + '</span><span class="grow"><span class="title-sm">' + s[0] + '</span><span class="meta muted">' + s[1] + '</span></span></li>'; }).join('') + '</ol></div>' +
      '<div class="bottom-bar col">' + btn(t('Choose other screenshots', 'Chọn ảnh khác'), { block: true, icon: 'images' }) + btn(t('Add by hand', 'Thêm tay'), { kind: 'text', block: true, icon: 'plus' }) + '</div>');
  }
  var sc = SCAN(), cg = subOf('chatgpt'), cl = subOf('claude'), yt = subOf('youtube');
  var add = sc.map(function (f, i) { return '<div class="srow' + (step === 'undone' && i === 1 ? ' undone' : '') + '">' + logo(f.s, 40) + '<span class="grow"><span class="srow-l">' + fullName(f.s) + ' <span class="tag tag-auto">' + icon('sparkles', 11) + t('Auto', 'Tự động') + '</span></span><span class="meta muted num">' + money(f.price, f.cur) + ' ' + cyc(f.s) + ' · ' + t('next ', 'kỳ tới ') + fd(f.next) + '</span></span>' + (step === 'undone' && i === 1 ? '<span class="meta muted">' + t('Removed', 'Đã gỡ') + '</span>' : i === 1 ? undo.replace('<button', '<button data-go="undo1"') : undo) + '</div>'; }).join('');
  var h = nav(t('Scan results', 'Kết quả quét'), { close: true }) + '<div class="scroll scan"><div class="res-head"><span class="check">' + icon('check', 32) + '</span><h2 class="title">' + (step === 'undone' ? t('Added 3, confirmed 1', 'Đã thêm 3 gói, xác nhận 1 kỳ') : t('Added 4, confirmed 1', 'Đã thêm 4 gói, xác nhận 1 kỳ')) + '</h2><span class="meta muted">' + t('From 2 screenshots and a receipt', 'Từ 2 ảnh chụp và 1 hoá đơn') + '</span></div>' +
    '<div class="caption eyebrow grp-head">' + t('Added', 'Đã thêm') + '</div><div class="group">' + add + '</div>' +
    '<div class="caption eyebrow grp-head">' + t('Confirmed', 'Đã xác nhận') + '</div><div class="group"><div class="srow">' + logo(cl, 40) + '<span class="grow"><span class="srow-l">Claude Pro</span><span class="meta muted num">' + t('8 Nov period · paid ', 'Kỳ 8/11 · đã trả ') + money(myShare(cl), cl.cur) + '</span></span>' + undo + '</div></div>' +
    '<div class="caption eyebrow grp-head warn-t">' + t('Needs your check', 'Cần bạn kiểm') + '</div><div class="group review"><div class="srow">' + logo(yt, 40) + '<span class="grow"><span class="srow-l">YouTube Premium</span><span class="meta muted num">' + money(myShare(yt) * 5, yt.cur) + t(' on 9 Nov — 9 days before the 18 Nov payment', ' ngày 9/11 — sớm 9 ngày so với kỳ 18/11') + '</span><span class="rv-btns">' + btn(t('It’s this period', 'Đúng kỳ này'), { kind: 'tonal', sm: true }) + btn(t('Not this', 'Không phải'), { kind: 'text', sm: true }) + '</span></span></div></div>' +
    '<div class="caption eyebrow grp-head">' + t('Different amount', 'Số tiền khác') + '</div><div class="group"><div class="srow">' + logo(cg, 40) + '<span class="grow"><span class="srow-l">ChatGPT Plus</span><span class="meta muted num">' + t('12 Nov · charged $22.00', '12/11 · bị trừ $22.00') + '</span><span class="meta warn-t diff">' + icon('info', 13, 'inl') + ' ' + t('Usual $20.00 — recorded for this period only; the price isn’t changed.', 'Giá thường $20.00 — chỉ ghi cho kỳ này; giá gói không đổi.') + '</span></span>' + undo + '</div></div>' +
    '<div class="caption eyebrow grp-head">' + t('Not added', 'Không thêm') + '</div><div class="group"><div class="srow"><span class="srow-ic">' + icon('receipt', 20) + '</span><span class="grow"><span class="srow-l">“GOOGLE *TV” · $4.99</span><span class="meta muted">' + t('Seen once. Added if a second charge about a month later matches.', 'Mới thấy 1 lần. Sẽ thêm nếu tháng sau có lần trừ khớp.') + '</span></span><button class="link label">' + t('Add', 'Thêm') + '</button></div></div></div>' +
    '<div class="bottom-bar col">' + btn(t('Done', 'Xong'), { block: true, go: 'next' }) + btn(t('Undo all', 'Hoàn tác tất cả'), { kind: 'text', block: true }) + '</div>';
  if (step === 'undone') h += toast(t('Notion Plus removed · won’t be added again', 'Đã gỡ Notion Plus · sẽ không tự thêm lại'), 'rotate-ccw', t('Redo', 'Làm lại'));
  return phone(h);
};

/* ---------------- Widgets (§4.12) ---------------- */
function wItem(s, d, amt) { return '<div class="wg-it">' + logo(s, 24) + '<span class="grow"><span class="wg-in ell">' + s.name + '</span><span class="wg-m">' + fd(d, 'wdm') + '</span></span><span class="wg-ia"><b class="num">' + money(amt, s.cur) + '</b>' + cycT(s.cyc[1] === 'y' ? t('Yearly', 'Năm') : t('Monthly', 'Tháng')) + '</span></div>'; }
SCR.widgets = function (os) {
  var subs = data(), ev = allEvents(subs, TODAY, addM(TODAY, 2)).filter(function (e) { return e.st === 'up'; }), cg = subOf('chatgpt'), tot = monthSpend(subs, 2026, 10);
  var list = function (n) { return ev.slice(0, n).map(function (e) { return wItem(e.s, e.d, r2(myShare(e.s, e.d))); }).join(''); };
  var A = os === 'android';
  var small = '<div class="wg wg-s2' + (A ? ' wg-a' : '') + '"><div class="wg-top">' + logo(cg, 32) + '<span class="wg-when">' + t('2 days', '2 ngày') + '</span></div><div class="wg-n">ChatGPT Plus</div><div class="wg-p"><b class="num">$20.00</b>' + cycT(t('Monthly', 'Tháng')) + '</div><div class="wg-m">' + t('12 Nov · 2 days left', '12/11 · còn 2 ngày') + '</div></div>';
  var sp = subOf('spotify'), small2 = '<div class="wg wg-s2' + (A ? ' wg-a' : '') + '"><div class="wg-top">' + logo(sp, 32, 'trial') + '<span class="wg-when">' + t('3 days', '3 ngày') + '</span></div><div class="wg-n">Spotify</div><div class="wg-p"><b class="num">' + money(sp.price, sp.cur) + '</b>' + cycT(t('Monthly', 'Tháng')) + '</div><div class="wg-m">' + t('Trial ends 13 Nov', 'Hết dùng thử 13/11') + '</div></div>';
  var med = '<div class="wg wg-m2' + (A ? ' wg-a' : '') + '"><div class="wg-l">' + mark(16) + t('November', 'Tháng 11') + '</div><div class="wg-big num">≈ ' + money(tot) + '<span class="wg-per">' + t('/mo', '/tháng') + '</span></div><div class="wg-list">' + list(3) + '</div></div>';
  var large = '<div class="wg wg-l2' + (A ? ' wg-a' : '') + '"><div class="wg-lh"><div><div class="wg-l">' + mark(16) + t('November', 'Tháng 11') + '</div><div class="wg-big num">≈ ' + money(tot) + '<span class="wg-per">' + t('/mo', '/tháng') + '</span></div></div><span class="wg-chip">' + icon('clock', 13) + t('1 to confirm', '1 chờ xác nhận') + '</span></div>' +
    cashBar(monthCash(subs, 2026, 10).paid, monthCash(subs, 2026, 10).due) + '<div class="wg-list big">' + list(6) + '</div></div>';
  if (os === 'large') {
    var lg2 = large.replace('wg wg-l2', 'wg wg-l2 wg-a');
    return phone('<div class="home"><div class="wg-cap">iOS · ' + t('large', 'lớn') + '</div>' + large + '<div class="wg-cap">Android · ' + t('large', 'lớn') + '</div>' + lg2 + '</div>', { sb: { light: true }, cls: 'is-home' });
  }
  return phone('<div class="home' + (A ? ' and' : '') + '"><div class="wg-cap">' + (A ? 'Android' : 'iOS') + ' · ' + t('small', 'nhỏ') + '</div><div class="wg-row">' + small + small2 + '</div><div class="wg-cap">' + (A ? 'Android' : 'iOS') + ' · ' + t('medium', 'vừa') + '</div>' + med + '</div>', { sb: { light: true }, cls: 'is-home' });
};
SCR.widgetStates = function () {
  var cl = subOf('claude');
  var wait = '<div class="wg wg-s2 warnw"><div class="wg-top">' + logo(cl, 32, 'wait') + '<span class="wg-when">' + icon('clock', 12) + '</span></div><div class="wg-n">Claude Pro</div><div class="wg-p"><b class="num">$20.00</b>' + cycT(t('Monthly', 'Tháng')) + '</div><div class="wg-m"><b>' + t('Tap to confirm', 'Chạm để xác nhận') + '</b></div></div>';
  var none = '<div class="wg wg-s2 emptyw"><div class="wg-top">' + mark(28) + '</div><div class="wg-n">' + t('Nothing due', 'Chưa có gói') + '</div><div class="wg-m">' + t('Tap to add your first subscription', 'Chạm để thêm gói đầu tiên') + '</div></div>';
  var lockS = '<div class="wg wg-s2 lockw"><div class="wg-top">' + mark(28) + '</div><span class="lk">' + icon('lock-keyhole', 26) + '</span><div class="wg-m">' + t('Locked with PIN', 'Đã khoá bằng PIN') + '</div></div>';
  var lockM = '<div class="wg wg-m2 lockw"><div class="wg-l">' + mark(16) + 'Subnest</div><span class="lk">' + icon('lock-keyhole', 26) + '</span><div class="wg-m">' + t('Locked with PIN — open Subnest to see your payments', 'Đã khoá bằng PIN — mở Subnest để xem các khoản') + '</div></div>';
  return phone('<div class="home"><div class="wg-cap">' + t('To confirm · empty', 'Chờ xác nhận · trống') + '</div><div class="wg-row">' + wait + none + '</div><div class="wg-cap">' + t('PIN lock on', 'Đang bật khoá PIN') + '</div><div class="wg-row">' + lockS + '</div>' + lockM + '</div>', { sb: { light: true }, cls: 'is-home' });
};

/* ---------------- Notifications (§4.13) ---------------- */
SCR.lock = function () {
  var n = [[t('Netflix renews in 3 days — $17.99', 'Netflix gia hạn sau 3 ngày — 260.000 ₫'), t('now', 'bây giờ')], [t('Your Spotify trial ends in 3 days. Cancel now if you don’t want to be charged.', 'Dùng thử Spotify hết sau 3 ngày. Huỷ ngay nếu không muốn bị tính phí.'), '9:00'],
    [t('Claude renews today — tap to confirm', 'Hôm nay gia hạn Claude — chạm để xác nhận'), t('2d ago', '2 ngày trước')], [t('Backup failed — open Subnest to check', 'Sao lưu lỗi — mở Subnest để kiểm tra'), t('yesterday', 'hôm qua')]];
  return phone('<div class="lockscreen"><div class="ls-date">' + t('Tuesday, 10 November', 'Thứ Ba, 10 tháng 11') + '</div><div class="ls-time">9:41</div><div class="ls-list">' + n.map(function (x, i) {
    return '<div class="notif' + (i === 3 ? ' err' : '') + '"' + (i === 2 ? ' data-go="notif"' : '') + '>' + mark(38) + '<div class="grow"><div class="notif-h"><b>Subnest</b><span>' + x[1] + '</span></div><div class="notif-b">' + x[0] + '</div></div></div>';
  }).join('') + '</div><p class="ls-note">' + t('Plain text only — no action buttons. A backup notice appears only when it fails.', 'Chỉ chữ — không có nút hành động. Thông báo sao lưu chỉ hiện khi lỗi.') + '</p></div>', { sb: { light: true }, cls: 'is-lock' });
};

/* ---------------- behaviour, stage, prototypes ---------------- */
function wire(root, inProto) {
  root.querySelectorAll('.scroll.detail').forEach(function (sc) {
    var nv = sc.parentNode.querySelector('.nav-clear');
    if (nv) sc.addEventListener('scroll', function () { nv.classList.toggle('solid', sc.scrollTop > 120); });
  });
  root.querySelectorAll('.stepper').forEach(function (st) {
    var v = st.querySelector('.v'), field = st.closest('.field'), panel = field && field.querySelector('.share-panel');
    st.querySelectorAll('button').forEach(function (b, i) {
      b.addEventListener('click', function (e) {
        e.stopPropagation();
        var old = +v.textContent, n = Math.max(2, Math.min(10, old + (i ? 1 : -1)));
        v.textContent = n;
        if (panel) { var big = panel.querySelector('.big'), tot = panel.querySelector('.sp-r .meta'); var cur = (tot.textContent.match(/^[^\d]*/) || [''])[0], val = parseFloat(tot.textContent.replace(/[^\d.,]/g, '').replace(/,/g, '')); if (val) { big.textContent = tot.textContent.replace(/÷.*$/, '').replace(/[\d.,]+/, (val / n).toFixed(cur.indexOf('$') >= 0 ? 2 : 0)); tot.textContent = tot.textContent.replace(/÷ \d+/, '÷ ' + n); } }
      });
    });
  });
  if (!inProto) {
    root.querySelectorAll('.js-paid').forEach(function (b) { b.addEventListener('click', function () { b.closest('.sheet').classList.add('is-done'); }); });
    root.querySelectorAll('.js-done').forEach(function (b) { b.addEventListener('click', function () { b.closest('.sheet').classList.remove('is-done'); }); });
    root.querySelectorAll('.toggle').forEach(function (tg) { tg.addEventListener('click', function () { tg.classList.toggle('on'); tg.setAttribute('aria-checked', tg.classList.contains('on')); }); });
    root.querySelectorAll('.seg, .seg-mini').forEach(function (sg) { sg.querySelectorAll('button').forEach(function (b) { b.addEventListener('click', function () { sg.querySelectorAll('button').forEach(function (x) { x.classList.toggle('on', x === b); x.setAttribute('aria-selected', x === b); }); }); }); });
    root.querySelectorAll('.chip').forEach(function (c) { if (!c.closest('.fchips')) c.addEventListener('click', function () { c.classList.toggle('on'); }); });
  }
}
function scrollTo(root, what) {
  if (!what) return;
  root.querySelectorAll('.scroll, .form').forEach(function (sc) {
    var target = typeof what === 'number' ? null : sc.querySelector(what);
    sc.scrollTop = target ? target.offsetTop - 8 : (typeof what === 'number' ? what : 0);
    var nv = sc.parentNode.querySelector('.nav-clear'); if (nv) nv.classList.toggle('solid', sc.scrollTop > 120);
  });
}
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

var OV = function (scn, o) { return function () { return SCR.overview(scn, o); }; };
var FLOWS = {
  first: { title: '1 · First run', desc: 'Language → welcome → currency → pick 5 services → reminders → Overview with the cost card.', steps: [
    { id: 'l', label: 'Language', r: function () { return SCR.language(); }, go: { next: 'w' } },
    { id: 'w', label: 'Welcome', r: function () { return SCR.welcome(); }, go: { next: 'c', skip: 'c' } },
    { id: 'c', label: 'Main currency', r: function () { return SCR.currency(); }, go: { next: 'p', skip: 'p' } },
    { id: 'p', label: 'Pick services', r: function () { return SCR.pick(); }, go: { next: 'r', later: 'r' } },
    { id: 'r', label: 'Reminders', r: function () { return SCR.remind(); }, go: { next: 'os' } },
    { id: 'os', label: 'System prompt', r: function () { return SCR.remind({ os: true }); }, go: { next: 'o' } },
    { id: 'o', label: 'Overview — the wow', r: OV('default'), go: {} }] },
  add: { title: '2 · Add a subscription', desc: '+ → search “netf” → Netflix → choose plan → form, split with 4 → saved, the new row glows.', steps: [
    { id: 'o', label: 'Overview', r: OV('default'), go: { fab: 'l' } },
    { id: 'l', label: 'Library', r: function () { return SCR.library(); }, go: { search: 's' } },
    { id: 's', label: 'Search “netf”', r: function () { return SCR.library({ query: 'netf' }); }, go: { 'pick-netflix': 'p' } },
    { id: 'p', label: 'Choose plan', r: function () { return SCR.library({ plan: true }); }, go: { next: 'f' } },
    { id: 'f', label: 'Form · split 4', r: function () { return SCR.form({ mode: 'add' }); }, go: { save: 'd' } },
    { id: 'd', label: 'Saved', r: OV('netflixNew', { toast: ['Netflix Premium added · your share $6.25', 'Đã thêm Netflix Premium · phần của bạn 65.000 ₫'] }), scroll: '.sec-subs', go: {} }] },
  custom: { title: '3 · Custom service with a photo', desc: 'Create “Gym” → change icon → choose photo → crop → save → the row shows the photo.', steps: [
    { id: 'l', label: 'Library', r: function () { return SCR.library(); }, go: { custom: 'f' } },
    { id: 'f', label: 'Form · Gym', r: function () { return SCR.form({ mode: 'custom' }); }, go: { icon: 'i' } },
    { id: 'i', label: 'Change icon', r: function () { return SCR.form({ mode: 'custom', iconSheet: 'mono' }); }, go: { photo: 'c' } },
    { id: 'c', label: 'Crop', r: function () { return SCR.crop(); }, go: { next: 'p' } },
    { id: 'p', label: 'Photo set', r: function () { return SCR.form({ mode: 'custom', photo: true, iconSheet: 'photo' }); }, go: { done: 'g' } },
    { id: 'g', label: 'Form with photo', r: function () { return SCR.form({ mode: 'custom', photo: true }); }, go: { save: 'o' } },
    { id: 'o', label: 'Saved', r: OV('gymNew', { toast: ['Gym added', 'Đã thêm Gym'] }), scroll: '.sec-subs', go: {} }] },
  confirm: { title: '4 · Confirm a payment', desc: 'Notification → confirm sheet → Paid → the cost card moves money from “still to pay” to “paid”.', steps: [
    { id: 'n', label: 'Notification', r: function () { return SCR.lock(); }, go: { notif: 's' } },
    { id: 's', label: 'Confirm sheet', r: function () { return SCR.confirm(); }, go: { paid: 'd', later: 'o0' } },
    { id: 'd', label: 'Paid ✓', r: function () { return SCR.confirm({ done: true }); }, go: { done: 'o' } },
    { id: 'o', label: 'Cost card updated', r: OV('paidClaude'), go: {} },
    { id: 'o0', label: 'Later', r: OV('default'), go: {}, branch: true }] },
  trial: { title: '5 · Trial ending', desc: 'Trial card with 3 buttons: Keep it (card goes), View subscription, How to cancel.', steps: [
    { id: 'o', label: 'Overview · trial card', r: OV('default'), go: { keep: 'k', trial: 'd', howcancel: 'w' } },
    { id: 'k', label: 'Keep it', r: OV('trialKept', { toast: ['We’ll still remind you before 13 Nov', 'Vẫn nhắc bạn trước ngày 13/11'] }), go: {} },
    { id: 'd', label: 'Spotify detail', r: function () { return SCR.detail('spotify'); }, go: { howcancel: 'w', back: 'o' }, branch: true },
    { id: 'w', label: 'spotify.com', r: function () { return SCR.browser('spotify.com/account'); }, go: { back: 'o' }, branch: true }] },
  month: { title: '6 · Insights by month', desc: 'Insights → back to August → every card changes → tap the December bar → Projected.', steps: [
    { id: 'n', label: 'November', r: function () { return SCR.insights(); }, go: { prevm: 'a' } },
    { id: 'a', label: 'August (‹ ×3)', r: function () { return SCR.insights({ m: 7 }); }, go: { 'col-11': 'd', prevm: 'a', nextm: 'n' } },
    { id: 'd', label: 'December · projected', r: function () { return SCR.insights({ m: 11 }); }, go: { prevm: 'n' } }] },
  rise: { title: '7 · A price goes up', desc: 'Edit Netflix’s price → applies from the next payment → price history → Insights “Price rises” → Review.', steps: [
    { id: 'd', label: 'Netflix detail', r: function () { return SCR.detail('netflix'); }, go: { edit: 'f' } },
    { id: 'f', label: 'Edit price', r: function () { return SCR.form({ mode: 'edit' }); }, go: { saveprice: 'q' } },
    { id: 'q', label: 'From next payment?', r: function () { return SCR.form({ mode: 'edit', priceDialog: true }); }, go: { apply: 'h' } },
    { id: 'h', label: 'Price history', r: function () { return SCR.detail('netflix', 'netflixRaised'); }, scroll: '.phist', go: { back: 'i' } },
    { id: 'i', label: 'Insights · Price rises', r: function () { return SCR.insights(); }, scroll: '.c-rise', go: { review: 'r' } },
    { id: 'r', label: 'Review Netflix', r: function () { return SCR.detail('netflix', 'netflixRaised'); }, scroll: '.phist', go: {} }] },
  price: { title: '8 · Library price notice', desc: 'The library price of a linked plan changes → card on Overview → compare → update from the next payment.', steps: [
    { id: 'o', label: 'Overview · notice', r: OV('default', { notice: true }), scroll: '.stack', go: { priceupdate: 's' } },
    { id: 's', label: 'Update the price?', r: function () { return SCR.priceSheet(); }, go: { update: 'd' } },
    { id: 'd', label: 'Updated', r: OV('default', { toast: ['YouTube Premium: $25.99 from 18 Nov', 'YouTube Premium: 199.000 ₫ từ 18/11'] }), go: {} }] },
  cancel: { title: '9 · Cancel and celebrate', desc: 'Detail → how to cancel → mark as cancelled → the saving is celebrated.', steps: [
    { id: 'd', label: 'Canva detail', r: function () { return SCR.detail('canva'); }, scroll: '.actions', go: { howcancel: 'w', markcancel: 'q' } },
    { id: 'w', label: 'canva.com', r: function () { return SCR.browser('canva.com/settings/billing'); }, go: { back: 'd' } },
    { id: 'q', label: 'Mark as cancelled?', r: function () { return SCR.detail('canva', 'default', { dialog: 'cancel' }); }, scroll: '.actions', go: { next: 'c' } },
    { id: 'c', label: 'Saving +$120/yr', r: function () { return SCR.celebrate(); }, go: { next: 'o' } },
    { id: 'o', label: 'Cancelled tab', r: OV('canvaCancelled', { tab: 3 }), scroll: '.sec-subs', go: {} }] },
  scan: { title: '10 · Screenshot scan (Pro)', desc: 'Automation → scan → photo access → reading on device → results → undo one row.', steps: [
    { id: 'a', label: 'Automation', r: function () { return SCR.automation(); }, go: { scan: 'i' } },
    { id: 'i', label: 'How it works', r: function () { return SCR.scan('intro'); }, go: { next: 'p' } },
    { id: 'p', label: 'Photo access', r: function () { return SCR.scan('photos'); }, go: { next: 'r' } },
    { id: 'r', label: 'Reading', r: function () { return SCR.scan('reading'); }, go: { next: 'x' }, auto: [2600, 'x'] },
    { id: 'x', label: 'Results', r: function () { return SCR.scan('results'); }, go: { undo1: 'u' } },
    { id: 'u', label: 'One row undone', r: function () { return SCR.scan('undone'); }, go: {} }] },
  pin: { title: '11 · PIN lock', desc: 'Turn on PIN → choose and repeat it → leave for 2 minutes → enter the PIN to get back in.', steps: [
    { id: 's', label: 'Settings · Security', r: function () { return SCR.settings(); }, scroll: '.data-h', go: { pin: 'a' } },
    { id: 'a', label: 'Choose PIN', r: function () { return SCR.pin({ mode: 'set', n: 2 }); }, go: { pin: 'b' } },
    { id: 'b', label: 'Repeat PIN', r: function () { return SCR.pin({ mode: 'confirm', n: 3 }); }, go: { pin: 'c' } },
    { id: 'c', label: 'PIN on', r: function () { return SCR.settings({ pin: true }); }, scroll: '.data-h', go: {}, auto: [2600, 'l'] },
    { id: 'l', label: '2 min later · locked', r: function () { return SCR.pin({ n: 3 }); }, go: { pin: 'o' } },
    { id: 'o', label: 'Back in', r: OV('default'), go: {} }] }
};
var protoSeq = 0;
function proto(flowId, host) {
  var f = FLOWS[flowId], cur = 0, hist = [], hot = true, lang = 'en';
  host.innerHTML = '<div class="proto"><div class="proto-phone" data-theme="' + (document.documentElement.getAttribute('data-theme') || 'light') + '"></div>' +
    '<aside class="proto-side"><h2>' + f.title + '</h2><p>' + f.desc + '</p><ol class="proto-steps">' + f.steps.map(function (s, i) { return '<li><button data-i="' + i + '" class="' + (s.branch ? 'br' : '') + '">' + s.label + '</button></li>'; }).join('') + '</ol>' +
    '<div class="proto-ctl"><button class="pb js-back">' + icon('chevron-left', 16) + 'Back</button><button class="pb js-restart">' + icon('rotate-ccw', 16) + 'Restart</button></div>' +
    '<label class="proto-opt"><input type="checkbox" class="js-hot" checked> Show tap targets</label>' +
    '<div class="proto-theme"><span class="js-theme">' + seg(['Light', 'Dark'], (document.documentElement.getAttribute('data-theme') || 'light') === 'dark' ? 1 : 0, 'seg-mini') + '</span><span class="js-lang">' + seg(['English', 'Tiếng Việt'], 0, 'seg-mini') + '</span></div>' +
    '<p class="proto-hint js-hint"></p></aside></div>';
  var ph = host.querySelector('.proto-phone');
  var idx = function (id) { return f.steps.map(function (x) { return x.id; }).indexOf(id); };
  function show(i, push) {
    if (push) hist.push(cur);
    cur = i;
    var s = f.steps[i];
    LANG = lang; ph.innerHTML = s.r(); wire(ph, true); scrollTo(ph, s.scroll); LANG = 'en';
    var p = ph.querySelector('.phone'); if (p) p.classList.add('enter');
    var keys = Object.keys(s.go);
    ph.querySelectorAll('[data-go]').forEach(function (el) {
      var k = el.getAttribute('data-go');
      if (keys.indexOf(k) >= 0) {
        el.classList.add('live'); if (hot) el.classList.add('hot');
        el.addEventListener('click', function (e) { e.preventDefault(); e.stopPropagation(); var to = idx(s.go[k]); if (to >= 0) show(to, true); });
      }
    });
    var tok = ++protoSeq;
    if (s.auto) setTimeout(function () { if (tok === protoSeq) show(idx(s.auto[1]), true); }, s.auto[0]);
    host.querySelectorAll('.proto-steps button').forEach(function (b, j) { b.classList.toggle('on', j === i); b.classList.toggle('seen', j < i); });
    host.querySelector('.js-hint').textContent = s.auto ? 'Moves on by itself in a moment…' : keys.length ? 'Tap a highlighted control on the phone to continue.' : 'End of flow — Restart or pick a step.';
  }
  host.querySelectorAll('.proto-steps button').forEach(function (b) { b.addEventListener('click', function () { show(+b.getAttribute('data-i'), true); }); });
  host.querySelector('.js-back').addEventListener('click', function () { if (hist.length) show(hist.pop(), false); });
  host.querySelector('.js-restart').addEventListener('click', function () { hist = []; show(0, false); });
  host.querySelector('.js-hot').addEventListener('change', function (e) { hot = e.target.checked; ph.querySelectorAll('.live').forEach(function (x) { x.classList.toggle('hot', hot); }); });
  host.querySelectorAll('.js-theme button').forEach(function (b, i) { b.addEventListener('click', function () { host.querySelectorAll('.js-theme button').forEach(function (x, j) { x.classList.toggle('on', j === i); }); ph.setAttribute('data-theme', i ? 'dark' : 'light'); }); });
  host.querySelectorAll('.js-lang button').forEach(function (b, i) { b.addEventListener('click', function () { host.querySelectorAll('.js-lang button').forEach(function (x, j) { x.classList.toggle('on', j === i); }); lang = i ? 'vi' : 'en'; show(cur, false); }); });
  show(0, false);
}

window.Subnest = { SCR: SCR, stage: stage, wire: wire, proto: proto, flows: FLOWS, icon: icon, logo: logo, mark: mark, art: art, money: money, data: data, subOf: subOf,
  btn: btn, chip: chip, seg: seg, toggle: toggle, stepper: stepper, badge: badge, banner: banner, empty: empty, row: row, sheet: sheet, dialog: dialog, toast: toast, setRow: setRow, group: group,
  phone: phone, tabbar: tabbar, cyc: cyc, cycT: cycT, delta: delta, cashBar: cashBar, monthCols: monthCols, costCard: costCard, trialCard: trialCard, upCard: upCard, noticeCard: noticeCard, pendingCard: pendingCard,
  riseCard: riseCard, next12Card: next12Card, upcomingCard: upcomingCard, budgetCard: budgetCard, priceHist: priceHist, picker: picker, bars12: bars12, donut: donut, allEvents: allEvents, info: info, pbar: pbar, datePicker: datePicker,
  setLang: function (l) { LANG = l; }, setSize: function (z) { SIZE = z; }, setScale: function (k) { SCALE = k; }, scrollTo: scrollTo, TODAY: TODAY };

})();
