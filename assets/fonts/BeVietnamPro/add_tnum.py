"""Adds a `tnum` (tabular figures) OpenType feature to the Be Vietnam Pro static TTFs.

Be Vietnam Pro (google/fonts, ofl/bevietnampro) ships proportional digits only and no `tnum`
feature, so `FontFeature.tabularFigures()` would be a no-op. This script appends one glyph per
digit (`<digit>.tf`) whose advance is the widest digit of that weight, centred, and a GSUB
`tnum` single-substitution lookup registered for every script/language. Existing features
(ccmp, locl, … — needed for Vietnamese diacritics) are left untouched.

OFL 1.1 allows modified versions; the font declares no Reserved Font Name.

Usage (re-run after replacing the TTFs from upstream):
    python -I add_tnum.py BeVietnamPro-Regular.ttf BeVietnamPro-Medium.ttf ...
Idempotent: a font that already has `tnum` is skipped.
"""
import copy
import sys

from fontTools.ttLib import TTFont
from fontTools.ttLib.tables import otTables as ot

DIGITS = "0123456789"


def add_tnum(path: str) -> None:
    font = TTFont(path)
    gsub = font["GSUB"].table
    if any(fr.FeatureTag == "tnum" for fr in gsub.FeatureList.FeatureRecord):
        print(f"{path}: already has tnum, skipped")
        return

    cmap = font.getBestCmap()
    glyf, hmtx = font["glyf"], font["hmtx"]
    names = [cmap[ord(d)] for d in DIGITS]
    width = max(hmtx[n][0] for n in names)
    order = list(font.getGlyphOrder())
    mapping = {}
    for n in names:
        new = f"{n}.tf"
        adv, lsb = hmtx[n]
        dx = (width - adv) // 2
        g = copy.deepcopy(glyf[n])
        if g.isComposite():
            for c in g.components:
                c.x += dx
        elif g.numberOfContours > 0:
            g.coordinates.translate((dx, 0))
        order.append(new)
        font.setGlyphOrder(order)
        glyf.glyphOrder = order
        glyf.glyphs[new] = g
        hmtx[new] = (width, lsb + dx)
        mapping[n] = new
    if "hdmx" in font:
        del font["hdmx"]
    if "post" in font and hasattr(font["post"], "extraNames"):
        font["post"].formatType = 2.0

    # Lookup: single substitution digit -> digit.tf
    sub = ot.SingleSubst()
    sub.mapping = mapping
    lookup = ot.Lookup()
    lookup.LookupType = 1
    lookup.LookupFlag = 0
    lookup.SubTable = [sub]
    lookup.SubTableCount = 1
    gsub.LookupList.Lookup.append(lookup)
    gsub.LookupList.LookupCount = len(gsub.LookupList.Lookup)
    lookup_index = gsub.LookupList.LookupCount - 1

    # Feature record, then re-sort FeatureList by tag (spec) and remap LangSys indices.
    feat = ot.Feature()
    feat.FeatureParams = None
    feat.LookupListIndex = [lookup_index]
    feat.LookupCount = 1
    rec = ot.FeatureRecord()
    rec.FeatureTag = "tnum"
    rec.Feature = feat
    records = gsub.FeatureList.FeatureRecord
    records.append(rec)
    new_index = len(records) - 1
    order_idx = sorted(range(len(records)), key=lambda i: records[i].FeatureTag)
    remap = {old: new for new, old in enumerate(order_idx)}
    gsub.FeatureList.FeatureRecord = [records[i] for i in order_idx]
    gsub.FeatureList.FeatureCount = len(records)

    def fix(langsys):
        if langsys is None:
            return
        idx = [remap[i] for i in langsys.FeatureIndex] + [remap[new_index]]
        langsys.FeatureIndex = sorted(idx)
        langsys.FeatureCount = len(langsys.FeatureIndex)
        if langsys.ReqFeatureIndex != 0xFFFF:
            langsys.ReqFeatureIndex = remap[langsys.ReqFeatureIndex]

    for srec in gsub.ScriptList.ScriptRecord:
        fix(srec.Script.DefaultLangSys)
        for lrec in srec.Script.LangSysRecord:
            fix(lrec.LangSys)

    font.save(path)
    print(f"{path}: tnum added, figure width {width}")


if __name__ == "__main__":
    for p in sys.argv[1:]:
        add_tnum(p)
