#!/usr/bin/env python3
"""Build static HTML pages from the legal Markdown files (no dependencies).

Supports the small Markdown subset used in store/legal/*.md:
  # / ## headings, paragraphs, "- " bullet lists, "1. " numbered lists
  (continuation lines indented), **bold**, `code`, [text](url).

Usage:  python store/tools/md_to_html.py
Writes store/legal/<name>.html next to every store/legal/<name>.<lang>.md,
plus store/legal/index.html linking all pages. Pages are self-contained
(inline CSS, light/dark), ready to upload to any static host.
Re-run after editing the .md files; never edit the .html by hand.
"""
import html
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parent.parent
LEGAL = ROOT / "legal"
APP_NAME = "Subnest"
OTHER_LANG = {"en": ("vi", "Tiếng Việt"), "vi": ("en", "English")}

CSS = """
:root{--bg:#ffffff;--fg:#1d2330;--muted:#5b6474;--accent:#0f766e;--line:#e3e7ee}
@media (prefers-color-scheme:dark){:root{--bg:#11151c;--fg:#e8ecf2;--muted:#9aa4b4;--accent:#5eead4;--line:#2a313d}}
*{box-sizing:border-box}
body{margin:0;background:var(--bg);color:var(--fg);font:16px/1.6 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif}
main{max-width:720px;margin:0 auto;padding:32px 16px 64px}
h1{font-size:1.75rem;line-height:1.25;margin:0 0 8px}
h2{font-size:1.2rem;margin:32px 0 8px;padding-top:16px;border-top:1px solid var(--line)}
a{color:var(--accent)}
code{font-family:ui-monospace,Consolas,monospace;font-size:.9em}
ul,ol{padding-left:1.4em}
li{margin:4px 0}
nav{font-size:.9rem;color:var(--muted);margin-bottom:24px}
footer{margin-top:48px;font-size:.85rem;color:var(--muted)}
"""


def inline(text):
    text = html.escape(text, quote=False)
    text = re.sub(r"\*\*(.+?)\*\*", r"<strong>\1</strong>", text)
    text = re.sub(r"`(.+?)`", r"<code>\1</code>", text)
    text = re.sub(r"\[(.+?)\]\((.+?)\)", r'<a href="\2">\1</a>', text)
    return text


def convert(md):
    out, para, items, kind = [], [], [], None
    title = ""

    def flush_para():
        if para:
            out.append("<p>" + inline(" ".join(para)) + "</p>")
            para.clear()

    def flush_list():
        nonlocal kind
        if items:
            out.append(f"<{kind}>" + "".join(f"<li>{inline(i)}</li>" for i in items) + f"</{kind}>")
            items.clear()
        kind = None

    for raw in md.split("\n"):
        line = raw.rstrip()
        bullet = re.match(r"^- (.*)", line)
        number = re.match(r"^\d+\. (.*)", line)
        if line.startswith("# "):
            flush_para(); flush_list()
            title = line[2:].strip()
            out.append(f"<h1>{inline(title)}</h1>")
        elif line.startswith("## "):
            flush_para(); flush_list()
            out.append(f"<h2>{inline(line[3:].strip())}</h2>")
        elif bullet or number:
            flush_para()
            new_kind = "ul" if bullet else "ol"
            if kind and kind != new_kind:
                flush_list()
            kind = new_kind
            items.append((bullet or number).group(1))
        elif line.startswith("  ") and items and line.strip():
            items[-1] += " " + line.strip()
        elif not line.strip():
            flush_para(); flush_list()
        else:
            flush_list()
            para.append(line.strip())
    flush_para(); flush_list()
    return title, "\n".join(out)


def page(lang, title, body, other_href, other_label):
    return f"""<!doctype html>
<html lang="{lang}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{html.escape(title)}</title>
<style>{CSS}</style>
</head>
<body>
<main>
<nav><a href="{other_href}">{other_label}</a></nav>
{body}
<footer>{APP_NAME}</footer>
</main>
</body>
</html>
"""


def main():
    links = []
    for md_path in sorted(LEGAL.glob("*.*.md")):
        stem, lang = md_path.stem.rsplit(".", 1)
        title, body = convert(md_path.read_text(encoding="utf-8"))
        other_lang, other_label = OTHER_LANG[lang]
        other = f"{stem}.{other_lang}.html"
        out = md_path.with_suffix(".html")
        out.write_text(page(lang, title, body, other, other_label), encoding="utf-8", newline="\n")
        links.append((title, out.name))
        print("wrote", out.relative_to(ROOT.parent))
    items = "".join(f'<li><a href="{n}">{html.escape(t)}</a></li>' for t, n in links)
    index = page("en", f"{APP_NAME} — Legal", f"<h1>{APP_NAME}</h1><ul>{items}</ul>", "#", "")
    index = index.replace('<nav><a href="#"></a></nav>\n', "")
    (LEGAL / "index.html").write_text(index, encoding="utf-8", newline="\n")
    print("wrote", (LEGAL / "index.html").relative_to(ROOT.parent))


if __name__ == "__main__":
    main()
