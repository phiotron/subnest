"""Builds the launcher-icon / splash source images from design/brand/ (Claude Design export).

Run from the app root:  python -I assets/icons/brand/make_brand_assets.py
Then:                    dart run flutter_launcher_icons && dart run flutter_native_splash:create
Outputs (inputs for those two tools, configured in pubspec.yaml — not bundled as Flutter assets):
  app_icon.png            1024² full-bleed icon (iOS, Android legacy + adaptive foreground)
  splash_light.png        mark + "Subnest" word cut from splash-light.png, at 4x (tool treats source as xxxhdpi)
  splash_dark.png         same from splash-dark.png
  splash_android12.png    1152² teal canvas, icon scaled into the 768px circle Android 12+ shows
"""
from pathlib import Path

from PIL import Image

SRC = Path("design/brand")
OUT = Path("assets/icons/brand")
TEAL = (14, 107, 99)

icon = Image.open(SRC / "app-icon-1024.png").convert("RGB")
icon.save(OUT / "app_icon.png")

# Splash mockups are 1170x2532 @3x; content bbox x 402..766, y 1024..1500 (centred).
for mode in ("light", "dark"):
    im = Image.open(SRC / f"splash-{mode}.png").convert("RGB")
    crop = im.crop((385, 1012, 785, 1512))  # 400x500 @3x around the mark + word
    crop = crop.resize((round(400 * 4 / 3), round(500 * 4 / 3)), Image.LANCZOS)
    crop.save(OUT / f"splash_{mode}.png")

canvas = Image.new("RGB", (1152, 1152), TEAL)
small = icon.resize((800, 800), Image.LANCZOS)
canvas.paste(small, ((1152 - 800) // 2, (1152 - 800) // 2))
canvas.save(OUT / "splash_android12.png")
print("ok")
