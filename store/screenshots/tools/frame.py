"""Turn a raw `adb exec-out screencap -p` (1080×2408, Galaxy A13, density 450) into a Play screenshot.

    python -I store/screenshots/tools/frame.py raw.png out.png

Crops the status bar (top 70px) and the navigation bar (from y=2273) — Samsung ignores Android's
SystemUI demo mode, so personal status icons would show — then repeats the edge columns to reach
exactly 2:1 (Play: sides 320–3840px, longer side ≤ 2× the shorter). Result: 1102×2203.
Other phones: read the insets with `adb shell dumpsys window | grep -E "type=(statusBars|navigationBars) frame"`.
"""
import sys

from PIL import Image

TOP, BOTTOM = 70, 2273

im = Image.open(sys.argv[1]).convert('RGB')
c = im.crop((0, TOP, im.width, BOTTOM))
h = c.height
w = (h + 1) // 2
pad = (w - c.width) // 2
out = Image.new('RGB', (c.width + 2 * pad, h))
out.paste(c, (pad, 0))
out.paste(c.crop((0, 0, 1, h)).resize((pad, h)), (0, 0))
out.paste(c.crop((c.width - 1, 0, c.width, h)).resize((pad, h)), (c.width + pad, 0))
assert max(out.size) / min(out.size) <= 2.0, out.size
out.save(sys.argv[2], optimize=True)
print(out.size)
