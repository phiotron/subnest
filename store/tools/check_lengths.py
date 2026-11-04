#!/usr/bin/env python3
"""Check store listing field lengths.

Reads store/listing/*.md. A field is a heading of the form

    ### <Field name> (≤ <limit>) — <declared length>

followed by a ```text fenced block. The block content (without the final
newline) is the field value. The script reports the real length (Unicode
code points after NFC normalisation, which is how the stores count), checks
it against the limit, and checks that the declared length is up to date.

Extra checks:
- "Keywords" fields: also ≤ 100 UTF-8 bytes (App Store Connect is safest
  treated as a byte limit for non-ASCII text), no space after commas, and no
  keyword that repeats a word from the Name / Subtitle of the same file.
- Text must already be NFC (decomposed Vietnamese diacritics count double).

Usage:  python store/tools/check_lengths.py [--fix]
  --fix  rewrite the declared lengths in the headings with the real values.
Exit code 1 if any limit is exceeded or a declared length is wrong (without --fix).
"""
import pathlib
import re
import sys
import unicodedata

ROOT = pathlib.Path(__file__).resolve().parent.parent
HEAD = re.compile(r"^### (?P<name>.+?) \(≤ (?P<limit>\d+)\) — (?P<decl>\d+)\s*$")


def fields(text):
    lines = text.split("\n")
    i = 0
    while i < len(lines):
        m = HEAD.match(lines[i])
        if m and i + 1 < len(lines) and lines[i + 1].strip() == "```text":
            j = i + 2
            body = []
            while lines[j].strip() != "```":
                body.append(lines[j])
                j += 1
            yield i, m, "\n".join(body)
            i = j
        i += 1


def words(s):
    return {w for w in re.split(r"[^\w]+", s.lower()) if w}


def main():
    fix = "--fix" in sys.argv
    ok = True
    for path in sorted((ROOT / "listing").glob("*.md")):
        text = path.read_text(encoding="utf-8")
        lines = text.split("\n")
        print(f"\n== {path.relative_to(ROOT.parent)}")
        section = ""
        title_words = {}
        found = list(fields(text))
        # collect name/subtitle words per store section for the keyword rule
        for idx, m, body in found:
            if m["name"] in ("Name", "Subtitle"):
                title_words.setdefault("app", set()).update(words(body))
        for idx, m, body in found:
            for k in range(idx, -1, -1):
                if lines[k].startswith("## "):
                    section = lines[k][3:].strip()
                    break
            if body != unicodedata.normalize("NFC", body):
                print(f"  !! {section} / {m['name']}: text is not NFC")
                ok = False
            n = len(unicodedata.normalize("NFC", body))
            limit, decl = int(m["limit"]), int(m["decl"])
            flag = "OK " if n <= limit else "OVER"
            extra = ""
            if m["name"].startswith("Keywords"):
                b = len(body.encode("utf-8"))
                extra = f" · {b} bytes"
                if b > limit:
                    flag = "OVER"
                if ", " in body:
                    print(f"  !! {section} / Keywords: remove spaces after commas")
                    ok = False
                kw = [k.strip().lower() for k in body.split(",")]
                if len(kw) != len(set(kw)):
                    print(f"  !! {section} / Keywords: duplicate keyword")
                    ok = False
                rep = set().union(*(words(k) for k in kw)) & title_words.get("app", set())
                if rep:
                    print(f"  !! {section} / Keywords repeat Name/Subtitle words: {sorted(rep)}")
                    ok = False
            if flag == "OVER":
                ok = False
            stale = "" if n == decl else f"  (declared {decl} → fix)"
            print(f"  {flag} {section} / {m['name']}: {n}/{limit}{extra}{stale}")
            if n != decl:
                if fix:
                    lines[idx] = HEAD.sub(
                        lambda mm: f"### {mm['name']} (≤ {mm['limit']}) — {n}", lines[idx]
                    )
                else:
                    ok = False
        if fix:
            path.write_text("\n".join(lines), encoding="utf-8", newline="\n")
    print("\nALL OK" if ok else "\nPROBLEMS FOUND")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
