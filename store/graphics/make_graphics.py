"""Store graphics for Google Play (A001-subnest).

    python -I store/graphics/make_graphics.py        (run from apps/A001-subnest/)

- icon-512.png            512×512, 32-bit PNG (Play: app icon) — downscaled design/brand/app-icon-1024.png
- feature-1024x500.png    1024×500, 24-bit PNG (Play: feature graphic, no alpha) — brand teal, mark, name, tagline (EN)
- feature-1024x500-vi.png same, Vietnamese tagline (for the vi listing)

Colours come from design/system/tokens.json (brand #0e6b63, brand-soft #d9f1ec); font Be Vietnam Pro (OFL).
"""
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

APP = Path(__file__).resolve().parents[2]
OUT = APP / 'store' / 'graphics'
ICON = APP / 'design' / 'brand' / 'app-icon-1024.png'
FONTS = APP / 'assets' / 'fonts' / 'BeVietnamPro'

BRAND = (0x0E, 0x6B, 0x63)
BRAND_SOFT = (0xD9, 0xF1, 0xEC)
WHITE = (0xFF, 0xFF, 0xFF)

TAGLINES = {
    '': 'Never miss a renewal or free trial again.',
    '-vi': 'Không bỏ lỡ ngày gia hạn hay hết dùng thử.',
}


def icon_512():
    im = Image.open(ICON).convert('RGBA').resize((512, 512), Image.LANCZOS)
    im.save(OUT / 'icon-512.png', optimize=True)


def feature(suffix, tagline):
    w, h = 1024, 500
    im = Image.new('RGB', (w, h), BRAND)
    # The icon's background is the brand teal, so the mark sits on the banner seamlessly.
    mark = Image.open(ICON).convert('RGB').resize((440, 440), Image.LANCZOS)
    im.paste(mark, (40, 30))
    d = ImageDraw.Draw(im)
    name = ImageFont.truetype(str(FONTS / 'BeVietnamPro-Bold.ttf'), 104)
    tag = ImageFont.truetype(str(FONTS / 'BeVietnamPro-Medium.ttf'), 34)
    x = 470
    max_w = w - x - 48
    # Tagline: wrap to at most two lines inside the right column.
    words, lines, cur = tagline.split(), [], ''
    for word in words:
        trial = f'{cur} {word}'.strip()
        if d.textlength(trial, font=tag) <= max_w:
            cur = trial
        else:
            lines.append(cur)
            cur = word
    lines.append(cur)
    name_h = 104
    block = name_h + 28 + len(lines) * 46
    y = (h - block) // 2 - 8
    d.text((x, y), 'Subnest', font=name, fill=WHITE)
    y += name_h + 36
    for line in lines:
        d.text((x, y), line, font=tag, fill=BRAND_SOFT)
        y += 46
    im.save(OUT / f'feature-1024x500{suffix}.png', optimize=True)


if __name__ == '__main__':
    OUT.mkdir(parents=True, exist_ok=True)
    icon_512()
    for suffix, text in TAGLINES.items():
        feature(suffix, text)
    print('ok')
