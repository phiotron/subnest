#!/usr/bin/env python3
"""Fetch the real logo of every Catalog service and bundle it in the app (no network at runtime).

Run from the app folder, isolated (downloads are untrusted data):

    python -I tool/fetch_logos.py                 # services without a logo yet
    python -I tool/fetch_logos.py --only a,b,c    # (re)fetch these ids (after editing OVERRIDES)
    python -I tool/fetch_logos.py --all           # refetch everything
    python -I tool/fetch_logos.py --sheet DIR     # only write contact sheets (PNG) to DIR
    python -I tool/fetch_logos.py --index         # only rewrite SOURCES.md + the Dart index

Sources, first hit wins (none needs a key):
  1. OVERRIDES below (a fixed URL, an App Store id, a different domain, or "none" = monogram);
  2. App Store icon of the service's own app (iTunes Search API, strict name/publisher match);
  3. the service's website: <link rel=apple-touch-icon|icon>, web manifest icons, /apple-touch-icon.png;
  4. Google's favicon service at 256 px (the site's own icon, crawled by Google).
Only icons >= 128 px are kept. Each is normalised to a square PNG of SIZE px (transparency kept,
transparent margins trimmed), quantised to 256 colours to keep the bundle small.

Outputs:
  assets/logos/png/<serviceId>.png      bundled (pubspec registers assets/logos/png/ only)
  assets/logos/sources.json             machine state: source kind + URL per id (not bundled)
  assets/logos/SOURCES.md               human list of sources + services without a logo
  lib/data/logos/bundled_logos.g.dart   const set of ids that have a bundled logo
"""
from __future__ import annotations

import argparse
import concurrent.futures as cf
import html.parser
import io
import json
import re
import sys
import threading
import time
import unicodedata
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

from PIL import Image, ImageDraw, ImageOps

ROOT = Path(__file__).resolve().parent.parent
CATALOG = ROOT / 'assets/catalog/services.json'
LOGO_DIR = ROOT / 'assets/logos'
PNG_DIR = LOGO_DIR / 'png'
STATE = LOGO_DIR / 'sources.json'
SOURCES_MD = LOGO_DIR / 'SOURCES.md'
DART_INDEX = ROOT / 'lib/data/logos/bundled_logos.g.dart'

SIZE = 192
MIN_SOURCE = 128
MAX_DOWNLOAD = 3 * 1024 * 1024
TIMEOUT = 12
UA = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/130.0 Safari/537.36'

# Manual fixes after reviewing the contact sheets. Values:
#   'none'              -> no bundled logo (monogram)            e.g. a parent-company logo only
#   'https://...'       -> this exact image URL
#   {'itunes': 123}     -> App Store app id (icon of that app)
#   {'domain': 'x.com'} -> look at this website instead of the Catalog logoDomain
#   {'term': 'name'}    -> App Store search with this name (still strict match)
OVERRIDES: dict[str, object] = {}

# Words dropped from a service name before matching an App Store app name.
_SUFFIXES = {
    'premium', 'plus', 'pro', 'pass', 'gold', 'subscription', 'membership', 'turbo', 'lite', 'unlimited',
    'basic', 'standard', 'family', 'personal', 'business', 'essentials', 'express', 'blessing', 'monthly',
    'vip', 'max', 'one', 'sub', '+',
}

_itunes_lock = threading.Lock()
_itunes_last = [0.0]
ITUNES_GAP = 3.1  # Apple allows ~20 calls / minute


# ---- HTTP ------------------------------------------------------------------------------------

def get(url: str, accept: str = '*/*') -> tuple[bytes, str, str]:
    """(body, final url, content type). Raises on HTTP errors / oversize bodies."""
    req = urllib.request.Request(url, headers={'User-Agent': UA, 'Accept': accept, 'Accept-Language': 'en'})
    with urllib.request.urlopen(req, timeout=TIMEOUT) as res:
        body = res.read(MAX_DOWNLOAD + 1)
        if len(body) > MAX_DOWNLOAD:
            raise ValueError('too large')
        return body, res.geturl(), res.headers.get('Content-Type', '')


def itunes(params: dict[str, str]) -> list[dict]:
    with _itunes_lock:
        wait = _itunes_last[0] + ITUNES_GAP - time.time()
        if wait > 0:
            time.sleep(wait)
        _itunes_last[0] = time.time()
        url = 'https://itunes.apple.com/' + params.pop('_path', 'search') + '?' + urllib.parse.urlencode(params)
        for attempt in range(3):
            try:
                body, _, _ = get(url, 'application/json')
                return json.loads(body.decode('utf-8')).get('results', [])
            except urllib.error.HTTPError as e:
                if e.code in (403, 429) and attempt < 2:
                    time.sleep(20)
                    continue
                return []
            except Exception:
                return []
    return []


# ---- Image handling --------------------------------------------------------------------------

def open_image(data: bytes) -> Image.Image | None:
    try:
        img = Image.open(io.BytesIO(data))
        if img.format == 'ICO':
            sizes = img.info.get('sizes') or []
            if sizes:
                img.size = max(sizes)  # pick the largest frame
        img.load()
        return img.convert('RGBA')
    except Exception:
        return None


def normalise(img: Image.Image) -> Image.Image | None:
    """Square SIZE px RGBA. Transparent margins trimmed (logo then gets a small margin); opaque
    full-bleed icons are centre-cropped to a square. None = blank/unusable."""
    alpha = img.getchannel('A')
    bbox = alpha.point(lambda a: 255 if a > 16 else 0).getbbox()
    if bbox is None:
        return None
    w, h = img.size
    corners_opaque = all(alpha.getpixel(p) > 240 for p in [(0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1)])
    if corners_opaque:
        side = min(w, h)
        img = ImageOps.fit(img, (side, side), Image.Resampling.LANCZOS)
    else:
        img = img.crop(bbox)
        cw, ch = img.size
        side = int(max(cw, ch) * 1.16)  # 8% margin each side
        canvas = Image.new('RGBA', (side, side), (0, 0, 0, 0))
        canvas.paste(img, ((side - cw) // 2, (side - ch) // 2))
        img = canvas
    img = img.resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    lo, hi = img.convert('L').getextrema()
    if hi - lo < 8 and img.getchannel('A').getextrema()[0] > 240:
        return None  # one flat colour
    return img


def encode(img: Image.Image) -> bytes:
    q = img.quantize(colors=256, method=Image.Quantize.FASTOCTREE, dither=Image.Dither.NONE)
    out = io.BytesIO()
    q.save(out, 'PNG', optimize=True)
    return out.getvalue()


def try_image(url: str, min_side: int = MIN_SOURCE) -> tuple[Image.Image, int] | None:
    if url.lower().split('?')[0].endswith('.svg'):
        return None
    try:
        data, _, ctype = get(url, 'image/*')
    except Exception:
        return None
    if 'svg' in ctype:
        return None
    img = open_image(data)
    if img is None or min(img.size) < min_side:
        return None
    return img, min(img.size)


# ---- Source: App Store -----------------------------------------------------------------------

def _plain(s: str) -> str:
    s = unicodedata.normalize('NFKD', s).encode('ascii', 'ignore').decode().lower()
    return re.sub(r'[^a-z0-9+ ]+', ' ', s).strip()


def _core(name: str) -> str:
    words = [w for w in _plain(name).replace('+', ' + ').split() if w]
    while len(words) > 1 and words[-1] in _SUFFIXES:
        words.pop()
    return ' '.join(w for w in words if w != '+')


def _app_core(track: str) -> str:
    return _core(re.split(r'\s[-–—|:]\s|:\s', track)[0])


def from_app_store(service: dict, term: str | None = None, app_id: int | None = None) -> tuple[Image.Image, str] | None:
    if app_id is not None:
        results = itunes({'_path': 'lookup', 'id': str(app_id)})
        picked = results[0] if results else None
    else:
        country = 'vn' if service.get('market') == 'vn' else 'us'
        core = _core(term or service['name'])
        stem = service.get('logoDomain', '').split('.')[0].replace('-', '')
        results = itunes({'term': term or service['name'], 'entity': 'software', 'limit': '10', 'country': country})
        picked = None
        for r in results:
            app = _app_core(r.get('trackName', ''))
            seller = _plain(r.get('sellerName', '') + ' ' + r.get('artistName', '')).replace(' ', '')
            seller_url = (r.get('sellerUrl') or '').lower()
            publisher_ok = bool(stem) and (stem in seller or stem in seller_url)
            if app == core or (publisher_ok and len(app) >= 4 and (core.startswith(app) or app.startswith(core))):
                picked = r
                break
    if not picked:
        return None
    url = picked.get('artworkUrl512') or picked.get('artworkUrl100')
    if not url:
        return None
    url = re.sub(r'/\d+x\d+bb\.(jpg|png)$', r'/256x256bb.png', url)
    got = try_image(url)
    if got is None:
        return None
    return got[0], url + f'  (App Store: {picked.get("trackName")}, id {picked.get("trackId")})'


# ---- Source: website -------------------------------------------------------------------------

class _Links(html.parser.HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.icons: list[tuple[str, str, str]] = []  # (rel, href, sizes)
        self.manifest: str | None = None

    def handle_starttag(self, tag, attrs):
        if tag != 'link':
            return
        a = {k.lower(): (v or '') for k, v in attrs}
        rel = a.get('rel', '').lower()
        href = a.get('href', '')
        if not href:
            return
        if 'manifest' in rel:
            self.manifest = href
        elif 'icon' in rel and 'mask-icon' not in rel:
            self.icons.append((rel, href, a.get('sizes', '')))


def _declared(sizes: str) -> int:
    best = 0
    for m in re.finditer(r'(\d+)x(\d+)', sizes or ''):
        best = max(best, min(int(m.group(1)), int(m.group(2))))
    return best


def from_website(domain: str) -> tuple[Image.Image, str] | None:
    page = None
    for base in (f'https://{domain}/', f'https://www.{domain}/'):
        try:
            body, final, ctype = get(base, 'text/html')
            if 'html' in ctype or body[:200].lstrip().startswith(b'<'):
                page = (body.decode('utf-8', 'ignore'), final)
                break
        except Exception:
            continue
    cands: list[tuple[int, str]] = []
    if page:
        text, final = page
        p = _Links()
        try:
            p.feed(text[:600_000])
        except Exception:
            pass
        for rel, href, sizes in p.icons:
            size = _declared(sizes) or (180 if 'apple-touch' in rel else 0)
            cands.append((size, urllib.parse.urljoin(final, href)))
        if p.manifest:
            try:
                murl = urllib.parse.urljoin(final, p.manifest)
                mbody, mfinal, _ = get(murl, 'application/json')
                for icon in json.loads(mbody.decode('utf-8', 'ignore')).get('icons', []):
                    if 'monochrome' in icon.get('purpose', ''):
                        continue
                    size = _declared(icon.get('sizes', ''))
                    if 'maskable' in icon.get('purpose', '') and 'any' not in icon.get('purpose', ''):
                        size //= 2  # lots of padding → prefer a normal icon
                    cands.append((size, urllib.parse.urljoin(mfinal, icon.get('src', ''))))
            except Exception:
                pass
        cands.append((179, urllib.parse.urljoin(final, '/apple-touch-icon.png')))
    seen: set[str] = set()
    best: tuple[Image.Image, str, int] | None = None
    tried = 0
    for size, url in sorted(cands, key=lambda c: -c[0]):
        if url in seen or (0 < size < MIN_SOURCE):
            continue
        seen.add(url)
        tried += 1
        got = try_image(url)
        if got and (best is None or got[1] > best[2]):
            best = (got[0], url, got[1])
            if got[1] >= 256:
                break
        if tried >= 5:
            break
    return (best[0], best[1]) if best else None


def from_google(domain: str) -> tuple[Image.Image, str] | None:
    url = f'https://www.google.com/s2/favicons?domain={domain}&sz=256'
    got = try_image(url)
    return (got[0], url) if got else None


# ---- Pipeline --------------------------------------------------------------------------------

def fetch_one(service: dict) -> tuple[str, dict]:
    sid = service['id']
    domain = service.get('logoDomain') or ''
    o = OVERRIDES.get(sid)
    result: tuple[Image.Image, str] | None = None
    kind = ''
    if o == 'none':
        return sid, {'kind': 'none', 'url': '', 'note': 'manual: no suitable logo'}
    if isinstance(o, str):
        got = try_image(o, 96)
        result, kind = ((got[0], o), 'manual') if got else (None, '')
    elif isinstance(o, dict) and 'itunes' in o:
        result, kind = from_app_store(service, app_id=int(o['itunes'])), 'appstore'
    elif isinstance(o, dict) and 'term' in o:
        result, kind = from_app_store(service, term=str(o['term'])), 'appstore'
    elif isinstance(o, dict) and 'domain' in o:
        domain = str(o['domain'])
    if result is None and not isinstance(o, (str,)) and not (isinstance(o, dict) and ('itunes' in o or 'term' in o)):
        steps = [('appstore', lambda: from_app_store(service)), ('website', lambda: from_website(domain)),
                 ('google-favicon', lambda: from_google(domain))]
        for k, fn in steps:
            if k != 'appstore' and not domain:
                continue
            try:
                result = fn()
            except Exception:
                result = None
            if result:
                kind = k
                break
    if not result:
        return sid, {'kind': 'missing', 'url': '', 'note': ''}
    img = normalise(result[0])
    if img is None:
        return sid, {'kind': 'missing', 'url': result[1], 'note': 'blank image'}
    (PNG_DIR / f'{sid}.png').write_bytes(encode(img))
    return sid, {'kind': kind, 'url': result[1], 'note': ''}


def load_state() -> dict[str, dict]:
    return json.loads(STATE.read_text(encoding='utf-8')) if STATE.exists() else {}


def save_state(state: dict[str, dict]) -> None:
    STATE.write_text(json.dumps(dict(sorted(state.items())), ensure_ascii=False, indent=1) + '\n', encoding='utf-8')


def write_index(services: list[dict], state: dict[str, dict]) -> None:
    ids = sorted(s['id'] for s in services if (PNG_DIR / f"{s['id']}.png").exists())
    lines = [
        '// GENERATED by tool/fetch_logos.py — do not edit. Ids of Catalog services with a bundled logo',
        '// (assets/logos/png/<id>.png). Sources: assets/logos/SOURCES.md.',
        '',
        'const Set<String> bundledLogoIds = {',
        *[f"  '{i}'," for i in ids],
        '};',
        '',
    ]
    DART_INDEX.write_text('\n'.join(lines), encoding='utf-8', newline='\n')
    total = sum((PNG_DIR / f'{i}.png').stat().st_size for i in ids)
    by_kind: dict[str, int] = {}
    for s in services:
        k = state.get(s['id'], {}).get('kind', 'missing')
        by_kind[k] = by_kind.get(k, 0) + 1
    names = {s['id']: s['name'] for s in services}
    md = [
        '# Logo dịch vụ đóng gói — nguồn',
        '',
        'Sinh bởi `python -I tool/fetch_logos.py` (đừng sửa tay — sửa `OVERRIDES` trong script rồi chạy lại).',
        'Logo là nhãn hiệu của chủ sở hữu tương ứng; app chỉ dùng để nhận diện dịch vụ người dùng đang trả tiền.',
        '',
        f'- Có logo: **{len(ids)}/{len(services)}** ({len(ids) * 100 // max(1, len(services))}%) · tổng {total / 1024:.0f} KB · '
        f'PNG {SIZE}px, 256 màu',
        '- Theo nguồn: ' + ', '.join(f'{k} {v}' for k, v in sorted(by_kind.items())),
        '',
        '## Không có logo (hiện monogram)',
        '',
    ]
    missing = [s for s in services if s['id'] not in ids]
    md += [f"- `{s['id']}` — {s['name']} ({s.get('logoDomain', '')})"
           + (f" — {state.get(s['id'], {}).get('note')}" if state.get(s['id'], {}).get('note') else '')
           for s in missing] or ['- (không có)']
    md += ['', '## Nguồn từng logo', '', '| id | dịch vụ | nguồn | URL |', '|---|---|---|---|']
    for i in ids:
        st = state.get(i, {})
        md.append(f"| `{i}` | {names[i]} | {st.get('kind', '?')} | {st.get('url', '').replace('|', '/')} |")
    SOURCES_MD.write_text('\n'.join(md) + '\n', encoding='utf-8', newline='\n')
    print(f'logos: {len(ids)}/{len(services)}  total {total / 1024:.0f} KB  {by_kind}')


def contact_sheets(services: list[dict], out_dir: Path, per_sheet: int = 100, cell: int = 64) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)
    cols = 10
    for n in range(0, len(services), per_sheet):
        chunk = services[n:n + per_sheet]
        rows = (len(chunk) + cols - 1) // cols
        sheet = Image.new('RGB', (cols * cell, rows * (cell + 12)), (236, 236, 236))
        draw = ImageDraw.Draw(sheet)
        for i, s in enumerate(chunk):
            x, y = (i % cols) * cell, (i // cols) * (cell + 12)
            f = PNG_DIR / f"{s['id']}.png"
            if f.exists():
                img = Image.open(f).convert('RGBA').resize((cell - 8, cell - 8), Image.Resampling.LANCZOS)
                plate = Image.new('RGBA', img.size, (255, 255, 255, 255))
                sheet.paste(Image.alpha_composite(plate, img).convert('RGB'), (x + 4, y + 4))
            else:
                draw.rectangle([x + 4, y + 4, x + cell - 4, y + cell - 4], outline=(200, 0, 0))
            draw.text((x + 2, y + cell - 2), f"{n + i}:{s['id'][:9]}", fill=(0, 0, 0))
        sheet.save(out_dir / f'sheet-{n // per_sheet + 1}.png')
    print(f'sheets → {out_dir}')


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument('--only', help='comma-separated service ids to (re)fetch')
    ap.add_argument('--all', action='store_true', help='refetch every service')
    ap.add_argument('--sheet', help='write contact sheets to this folder and exit')
    ap.add_argument('--index', action='store_true', help='rewrite SOURCES.md + Dart index and exit')
    ap.add_argument('--workers', type=int, default=8)
    args = ap.parse_args()

    services = json.loads(CATALOG.read_text(encoding='utf-8'))['services']
    PNG_DIR.mkdir(parents=True, exist_ok=True)
    state = load_state()
    if args.sheet:
        contact_sheets(services, Path(args.sheet))
        return
    if not args.index:
        if args.only:
            wanted = set(args.only.split(','))
            todo = [s for s in services if s['id'] in wanted]
        elif args.all:
            todo = services
        else:
            todo = [s for s in services if s['id'] not in state]
        for s in todo:
            (PNG_DIR / f"{s['id']}.png").unlink(missing_ok=True)
        done = 0
        with cf.ThreadPoolExecutor(args.workers) as pool:
            for sid, info in pool.map(fetch_one, todo):
                state[sid] = info
                done += 1
                if done % 20 == 0:
                    save_state(state)
                    print(f'{done}/{len(todo)}', flush=True)
        save_state(state)
    # Drop files of services no longer in the Catalog.
    known = {s['id'] for s in services}
    for f in PNG_DIR.glob('*.png'):
        if f.stem not in known:
            f.unlink()
    write_index(services, state)


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8')
    main()
