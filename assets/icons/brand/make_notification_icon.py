"""Monochrome Android icons from the brand mark (design/brand/app-icon.svg geometry).

    python -I assets/icons/brand/make_notification_icon.py      (run from apps/A001-subnest/)

- drawable-*/ic_stat_subnest.png       status-bar / notification small icon: white on transparent,
  24dp (mdpi 24 … xxxhdpi 96 px). Android tints it; a full-colour icon becomes a white blob.
- drawable-*/ic_launcher_monochrome.png  Android 13+ themed app icon layer (108dp, mark in the 66dp safe zone).

Shapes (1024 canvas, like the SVG): three tiles above the nest. A 2-colour icon can't use the
darker rim to separate them, so the tiles are cut by transparent gaps instead.
"""
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw

APP = Path(__file__).resolve().parents[3]
RES = APP / 'android' / 'app' / 'src' / 'main' / 'res'
DENSITIES = {'mdpi': 1, 'hdpi': 1.5, 'xhdpi': 2, 'xxhdpi': 3, 'xxxhdpi': 4}
S = 4  # supersampling of the 1024 canvas
GAP = 26


def tile(x, y, size, radius, angle, grow=0):
    """Rounded square rotated about its centre, as an L mask on the big canvas."""
    m = Image.new('L', (1024 * S, 1024 * S), 0)
    d = ImageDraw.Draw(m)
    d.rounded_rectangle(
        [(x - grow) * S, (y - grow) * S, (x + size + grow) * S, (y + size + grow) * S],
        radius=(radius + grow) * S,
        fill=255,
    )
    if angle:
        cx, cy = (x + size / 2) * S, (y + size / 2) * S
        m = m.rotate(-angle, resample=Image.BICUBIC, center=(cx, cy))
    return m


def ellipse(cx, cy, rx, ry):
    m = Image.new('L', (1024 * S, 1024 * S), 0)
    ImageDraw.Draw(m).ellipse([(cx - rx) * S, (cy - ry) * S, (cx + rx) * S, (cy + ry) * S], fill=255)
    return m


def nest():
    """Rim ellipse + the bowl body (lower half-ellipse widening into the rounded bottom)."""
    m = ellipse(512, 566, 300, 64)
    d = ImageDraw.Draw(m)
    pts = []
    # Body: from (212,566) down the curve to (512,800) and back up to (812,566) — the SVG's cubic.
    def cubic(p0, p1, p2, p3, n=40):
        for i in range(n + 1):
            t = i / n
            a = (1 - t) ** 3
            b = 3 * (1 - t) ** 2 * t
            c = 3 * (1 - t) * t ** 2
            e = t ** 3
            pts.append(((a * p0[0] + b * p1[0] + c * p2[0] + e * p3[0]) * S, (a * p0[1] + b * p1[1] + c * p2[1] + e * p3[1]) * S))
    cubic((812, 566), (812, 712), (676, 800), (512, 800))
    cubic((512, 800), (348, 800), (212, 712), (212, 566))
    d.polygon(pts, fill=255)
    return m


def mark():
    left = tile(252, 332, 210, 58, -12)
    right = tile(562, 332, 210, 58, 12)
    centre = tile(397, 262, 230, 64, 0)
    out = ImageChops.lighter(left, right)
    out = ImageChops.subtract(out, tile(397, 262, 230, 64, 0, grow=GAP))  # gap around the front tile
    out = ImageChops.lighter(out, centre)
    rim = nest()
    out = ImageChops.subtract(out, ellipse(512, 566, 300 + GAP, 64 + GAP))  # tiles sit in the nest
    out = ImageChops.lighter(out, rim)
    # One weave line across the bowl (the SVG has two; at 24dp one reads better).
    stripe = Image.new('L', out.size, 0)
    ImageDraw.Draw(stripe).line(
        [(p[0] * S, p[1] * S) for p in [(282, 668), (400, 716), (512, 726), (624, 716), (742, 668)]],
        fill=255,
        width=GAP * S,
        joint='curve',
    )
    out = ImageChops.subtract(out, stripe)
    return out


def render(mask, canvas_dp, content_dp, name):
    box = mask.getbbox()
    crop = mask.crop(box)
    for folder, k in DENSITIES.items():
        px = round(canvas_dp * k)
        inner = content_dp * k
        scale = inner / max(crop.size)
        w, h = max(1, round(crop.width * scale)), max(1, round(crop.height * scale))
        alpha = crop.resize((w, h), Image.LANCZOS)
        img = Image.new('RGBA', (px, px), (255, 255, 255, 0))
        layer = Image.new('RGBA', (w, h), (255, 255, 255, 255))
        layer.putalpha(alpha)
        img.alpha_composite(layer, ((px - w) // 2, (px - h) // 2))
        out = RES / f'drawable-{folder}' / f'{name}.png'
        out.parent.mkdir(parents=True, exist_ok=True)
        img.save(out, optimize=True)


if __name__ == '__main__':
    m = mark()
    render(m, 24, 21, 'ic_stat_subnest')  # Material: 24dp icon, ~1dp padding
    render(m, 108, 52, 'ic_launcher_monochrome')  # inside the 66dp safe zone with room to spare
    print('ok')
