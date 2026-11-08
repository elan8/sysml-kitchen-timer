# SPDX-FileCopyrightText: 2026 Elan8
# SPDX-License-Identifier: MIT
"""Write index.html for the published engineering documents.

Reads the manifest `doc42 build --all --json` prints, so the page shows the
metadata the model declares and links each entry to the PDF Doc42 wrote.
"""
import argparse
import html
import json
from datetime import datetime, timezone
from pathlib import Path

PAGE = """<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{title} engineering documents</title>
<style>
:root {{ --text: #1f2933; --muted: #52606d; --line: #d9e2ec; --accent: #0b6e99; --surface: #ffffff; }}
@media (prefers-color-scheme: dark) {{
  :root {{ --text: #e4e7eb; --muted: #9aa5b1; --line: #3e4c59; --accent: #5ab4d6; --surface: #1f2933; }}
}}
body {{ margin: 0; background: var(--surface); color: var(--text);
  font: 16px/1.5 system-ui, -apple-system, "Segoe UI", sans-serif; }}
main {{ max-width: 46rem; margin: 0 auto; padding: 2.5rem 1rem; }}
h1 {{ font-size: 1.6rem; margin: 0 0 .25rem; }}
p {{ color: var(--muted); margin: 0 0 1.5rem; }}
a {{ color: var(--accent); }}
ul {{ list-style: none; padding: 0; margin: 0 0 2rem; }}
li {{ border-top: 1px solid var(--line); padding: .9rem 0; }}
li:last-child {{ border-bottom: 1px solid var(--line); }}
.name {{ font-weight: 600; }}
.meta {{ color: var(--muted); font-size: .9rem; }}
footer {{ color: var(--muted); font-size: .85rem; }}
</style>
</head>
<body>
<main>
<h1>{title}</h1>
<p>Engineering documents generated from the
<a href="{repository}">SysML v2 model</a> with Doc42. Tables, values and diagrams
are read from the model, so these documents always match it.</p>
<ul>
{items}
</ul>
<footer>Built from <a href="{repository}/commit/{commit}">{short}</a> with {doc42} on {date}.</footer>
</main>
</body>
</html>
"""

ITEM = """<li><a class="name" href="{file}">{name}</a><br>
<span class="meta">{number} rev. {revision} · {status}</span></li>"""


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("manifest", type=Path, help="JSON from `doc42 build --all --json`")
    parser.add_argument("--out", type=Path, required=True, help="Directory with the PDFs")
    parser.add_argument("--repository", required=True, help="URL of the model repository")
    parser.add_argument("--commit", required=True, help="Model commit the documents were built from")
    parser.add_argument("--doc42", required=True, help="Doc42 version, e.g. `doc42 0.6.0`")
    args = parser.parse_args()

    manifest = json.loads(args.manifest.read_text(encoding="utf-8"))
    items, titles = [], set()
    for document in manifest["documents"]:
        pdf = args.out / Path(document["file"]).name
        if not pdf.is_file():
            raise SystemExit(f"{document['qualified_name']}: no PDF {pdf}")
        titles.add(document["title"])
        items.append(ITEM.format(
            file=html.escape(pdf.name, quote=True),
            name=html.escape(document.get("subtitle") or document["title"]),
            number=html.escape(document.get("number") or pdf.stem),
            revision=html.escape(document.get("revision") or "-"),
            status=html.escape(document.get("status") or "Released"),
        ))
    title = titles.pop() if len(titles) == 1 else "Engineering documents"
    page = PAGE.format(
        title=html.escape(title),
        repository=html.escape(args.repository, quote=True),
        items="\n".join(items),
        commit=html.escape(args.commit, quote=True),
        short=html.escape(args.commit[:7]),
        doc42=html.escape(args.doc42),
        date=datetime.now(timezone.utc).strftime("%Y-%m-%d"),
    )
    (args.out / "index.html").write_text(page, encoding="utf-8")
    print(f"Wrote {args.out / 'index.html'} for {len(items)} documents.")


if __name__ == "__main__":
    main()
