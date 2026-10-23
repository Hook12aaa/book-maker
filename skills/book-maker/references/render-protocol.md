# Render Protocol

The renderer takes the drafted chapters, endnotes, and figure specs, emits styled HTML with book structure, and prints the HTML to PDF via WeasyPrint. WeasyPrint renders CSS Paged Media Level 3 — running headers, page numbers, TOC counters, and PDF bookmarks — without JavaScript.

## Inputs

- `book/chapters/<chapter_id>.md` — one markdown file per chapter, in order.
- `book/endnotes/<chapter_id>.json` — one endnote file per chapter.
- `book/figures/<figure-id>.spec.json` — one file per figure, conforming to the families in `figure-layouts.md`.
- `book/architecture.json` — chapter skeleton with part/chapter hierarchy (used for TOC generation).
- `book/spine.json` — thesis and arc metadata (used for title page).
- `book/claims.jsonl` — the claims ledger. Every load-bearing claim in the draft must appear here with `verdict=verified`.

## Outputs

- `book/output/<topic-slug>.html` — the styled HTML.
- `book/output/<topic-slug>.pdf` — the printed PDF.

## Prerequisites

WeasyPrint must be installed: `pip install weasyprint`

macOS system dependencies (if not already present): `brew install pango cairo libffi gdk-pixbuf harfbuzz`

EB Garamond font must be available as a system font: `brew install --cask font-eb-garamond` (or download from Google Fonts and install system-wide)

Verify installation: `weasyprint --version`

## Book structure (emitted in this order)

### 1. Half-title page

Recto page, centred vertically. Contains only the book title (24 pt, regular weight, no subtitle, no author). This is the first page the reader sees. Force page break after.

### 2. Title page

Recto page, centred vertically:
- Title (28 pt, regular weight, letter-spaced)
- Subtitle (14 pt, italic) — a short phrase (5-10 words) that complements the title. Not the thesis.
- Book type (9 pt, uppercase, letter-spaced) — e.g. "A Narrative Investigation"
- Author name (13 pt, letter-spaced)
- Date

Force a page break after.

### 3. Copyright page

Verso page (back of title page). Flush to bottom of page. Contains:
- "© [year] [author name]. All rights reserved."
- "No part of this book may be reproduced without written permission."
- Optional ISBN placeholder: "ISBN: [pending]"
- Optional edition line: "First edition, [month] [year]"

Font size: 9 pt, colour #666. Force page break after.

### 4. Dedication page (optional)

Recto page if the user provides a dedication. Centred vertically, italic, 12 pt. Force page break after. If no dedication provided, omit this page.

### 5. Table of contents

Auto-generated from `book/architecture.json`:
- Part titles (bold, with part number)
- Chapter titles (indented under their part, with page number)

Force a page break after the TOC.

### 6. Part divider pages

Before each part's first chapter, emit a full-page part divider:
- Part number and title, centred
- Page break before and after

### 7. Chapters

Each chapter starts on a new page (`page-break-before`).
- Chapter title: H1 (24 pt, bold)
- Section headings: H2 (18 pt), H3 (14 pt)
- Body prose from the chapter markdown
- Superscript endnote numbers inline
- Figures inlined at `{{fig:<id>}}` placeholder positions

### 8. Chapter endnotes

At the end of each chapter, before the next chapter's page break:
- Heading: "Notes" (H3, 14 pt)
- Numbered list matching the superscript numbers in the chapter text
- Each entry: citation text followed by clickable source URL as a hyperlink
- Font size: 9 pt

### 9. Bibliography

After the last chapter:
- Page break before
- Heading: "Bibliography" (H1, 24 pt)
- All sources consolidated alphabetically
- Each entry: author, title, publication, date, URL as clickable hyperlink

### 10. Page numbers

Bottom centre on every page, starting after the TOC. Title page and TOC are unnumbered.

### 11. Running headers

WeasyPrint renders running headers via CSS `string-set` and margin boxes. No build script configuration needed — the CSS handles everything:
- Verso (left pages): book title in small caps (centre), page number (outer margin)
- Recto (right pages): chapter title in italic (centre), page number (outer margin)
- Suppressed on: front matter pages, chapter opener pages, part divider pages, blank pages

The HTML must include a hidden book-title element immediately after `<main>` opens: `<span class="book-title-string">BOOK TITLE</span>`. This element is invisible but WeasyPrint reads its `string-set` property to populate verso running headers. Each `h1.chapter` sets `string-set: chapter-title content()` automatically.

## Stage order

1. Assemble chapters in order from `book/chapters/`.
2. Convert each chapter's markdown prose to HTML paragraphs. Apply HTML escaping to all prose text content at this step.
3. Strip residual markdown headers: scan all `<p>` elements. Any paragraph whose text content begins with one or more `#` characters followed by a space is a markdown header that survived conversion. Remove these elements — the chapter's `<h1>`, `<h2>`, `<h3>` elements are generated separately from the architecture, not from inline markdown headers. This is a validation step: if any `<p>#` elements remain after stripping, log a warning.
4. For each chapter, inject endnote references from `book/endnotes/<chapter_id>.json` as raw `<sup class="endnote-ref">` tags AFTER the HTML escaping in step 2. Endnote injection must happen after escaping so the `<sup>` tags are emitted as live HTML, not as escaped entities. This is the critical ordering constraint — reversing steps 2 and 3 produces double-escaped endnote text.
5. Preserve LaTeX delimiters: `<` and `>` inside `$...$` or `$$...$$` blocks must not be HTML-escaped. Scan for LaTeX delimiters before escaping and protect their contents, or process LaTeX blocks separately.
6. For each figure reference (`{{fig:<id>}}`), render the figure spec into inline SVG or HTML and inline it.
7. Generate the table of contents from `book/architecture.json`. Emit entries as anchor links: `<div class="toc-entry"><a href="#chNN">Chapter N: Title</a></div>`. WeasyPrint's CSS `target-counter` fills page numbers automatically. Do NOT use empty `<span class="toc-page">` elements. Use consistent chapter numbering (no zero-padding: "Chapter 1", not "Chapter 01").
8. Generate the title page from `book/spine.json`. The subtitle on the title page is a short phrase (5-10 words), not the full thesis. If spine.json contains only the thesis, extract or compose a short subtitle from it. The full thesis belongs in a preface or back cover blurb, not the title page.
9. Generate part divider pages.
10. Wrap in `<!doctype html>` with inlined `assets/print.css`. Do NOT include `<link>` tags to external font services (Google Fonts, etc.) in the PDF HTML. WeasyPrint uses system fonts exclusively. External font links are ignored and add unnecessary network dependencies. Extend print.css with screen-reading styles (max-width body for browser viewing) but do not duplicate it — read the file and extend.
11. Pre-render LaTeX math. Scan the assembled HTML for `$...$` (inline) and `$$...$$` (display) delimiters. Replace each with server-side rendered HTML using `katex.renderToString(latex, {displayMode: true/false})` via Node.js or `latex2mathml.converter.convert(latex)` via Python. WeasyPrint does not execute JavaScript. All math must be rendered to HTML/MathML/SVG before the PDF engine sees the document. If no LaTeX delimiters are found, this step is a no-op.
12. Add a hidden book-title element for running headers: `<span class="book-title-string">BOOK TITLE</span>` immediately after `<main>` opens. WeasyPrint reads its `string-set` property to populate verso running headers.
13. Render PDF via WeasyPrint: `weasyprint book.html book.pdf`. No JavaScript dependency. No wait-for-render timing. Ensure `<html lang="en">` for hyphenation.

WeasyPrint is the only permitted PDF producer.

### TOC page numbers

WeasyPrint computes TOC page numbers via CSS `target-counter`. Each TOC entry is an anchor link (`<a href="#chNN">Chapter Title</a>`) and the CSS rule `.toc-entry a::after { content: leader('.') target-counter(attr(href), page); }` fills the page number automatically. Do NOT use `counter-reset: page` anywhere in the document — this causes all target-counter values to resolve to 0.

## Page sizing defaults

- Trim: 6 x 9 inches (152.4 x 228.6 mm) — standard US trade non-fiction.
- Margins: 0.75 inches outside/top/bottom, 0.875 inches gutter (binding side). Asymmetric: verso pages have gutter on right, recto pages have gutter on left.
- Default font: EB Garamond (or Garamond, Palatino fallback), 11 pt body, 8.5 pt endnotes, 8 pt running headers.
- Line height: 1.35.
- Paragraph style: first-line indent (1.5 em) with ZERO spacing between paragraphs. First paragraph after a heading: no indent (flush left). This is the single most important book-vs-web signal.
- Text alignment: justified with `hyphens: auto`.
- Chapter title: 20 pt regular weight, centred, sunk 33% from page top.
- Chapter number: 9 pt uppercase, letter-spaced, above the title.
- Part title: 22 pt regular weight, centred.
- Section headings: H2 13 pt italic, H3 11 pt bold, H4 11 pt italic.
- Chapter openers start on recto (right-hand) pages. If the previous chapter ends on a recto page, the verso before the next chapter opener is blank (no headers, no page numbers).
- Drop cap: first letter of first paragraph of each chapter floats at 3.2 em.
- Scene breaks: centred `* * *` with 1.5 em vertical spacing above and below.

## Style defaults

- Body: serif typeface (EB Garamond or Garamond) for prose, monospace (JetBrains Mono) for code, sans-serif (Source Sans Pro) for tables, figure captions, chapter numbers, and running headers.
- Colour palette: monochrome with one accent colour (#1a5c8a). Accent reserved for endnote numbers and hyperlinks only.
- Blockquotes: left-indented 2 em, italic, no border or background. Book blockquotes are not web callouts.
- Tables: full width, header row bolded, clean borders.
- Figures: captioned below in italic, numbered per chapter.
- Endnote numbers: superscript, accent-coloured, clickable within the HTML.
- Hyperlinks in endnotes and bibliography: accent-coloured, no underline (underline on hover for screen).
- Page breaks: avoid mid-paragraph and mid-figure. Chapters start recto. Part dividers start recto. Front matter pages suppress running headers and page numbers.
- Widows/orphans: minimum 3 lines at both top and bottom of page.

## ePub assembly

When ePub output is requested, assemble the book as ePub3 from the same source materials used for PDF.

### ePub3 structure

An ePub is a ZIP file with this layout:

```
mimetype                          (first entry, uncompressed, "application/epub+zip")
META-INF/
  container.xml                   (points to content.opf)
OEBPS/
  content.opf                     (manifest + spine + metadata)
  nav.xhtml                       (ePub3 HTML5 nav TOC)
  styles/
    epub.css                      (from assets/epub.css — NOT print.css)
  chapters/
    ch01.xhtml ... chNN.xhtml     (one per chapter)
    ch01-notes.xhtml ...          (one per chapter endnotes)
  parts/
    part01.xhtml ...              (one per part divider)
  images/
    cover.jpg                     (cover image)
    fig-01.svg ...                (rendered figures)
  title.xhtml                    (title page)
  bibliography.xhtml             (back matter)
```

### XHTML conversion

Convert each chapter markdown to XHTML:
- Add `xmlns="http://www.w3.org/1999/xhtml"` to the `<html>` root element
- Self-close all void tags: `<br/>`, `<img/>`, `<hr/>`
- Ensure all tags are properly closed (XHTML is strict XML)
- Strip residual markdown headers: apply the same stripping as PDF stage 3. Any `<p>` whose text begins with `# ` is a markdown header that survived conversion — remove it. The chapter's heading elements are generated from the architecture, not from inline markdown.
- `dc:date` in `content.opf` must be ISO 8601 format (e.g. `2026-10`), not prose (e.g. "October 2026")
- `bibliography.xhtml` must be included in both the OPF manifest and the spine. The bibliography is back matter that appears after the last chapter.

### OPF manifest and spine

Generate `content.opf` from `book/architecture.json`:
- `<metadata>`: `dc:title` from spine.json, `dc:creator` from user, `dc:language` (default `en`), `dc:identifier` (generated UUID), `dcterms:modified` (ISO 8601 timestamp)
- `<manifest>`: list every XHTML file, the CSS, all images, the nav, and the cover
- `<spine>`: list items in reading order — title, TOC, part1, ch01, ch01-notes, ch02, ..., bibliography. The bibliography MUST be included as `bibliography.xhtml` in both the manifest and spine, after the last chapter's endnotes. Omitting it from the ePub when the PDF has one is a bug.
- `<dc:date>` MUST use ISO 8601 format (`YYYY-MM` or `YYYY-MM-DD`), not natural language dates like "October 2026"
- Cover image declared with `properties="cover-image"` in manifest

### nav.xhtml TOC

Generate from the part/chapter hierarchy in `architecture.json`:
- HTML5 `<nav epub:type="toc">` with nested `<ol>/<li>/<a>` elements
- Parts as top-level items, chapters as nested items

### Endnote linking

In chapter XHTML: `<a epub:type="noteref" href="chNN-notes.xhtml#n1"><sup>1</sup></a>`

In endnote XHTML, each note MUST use `<aside epub:type="footnote">`, NOT `<ol><li>`:

```html
<aside epub:type="footnote" id="n1">
  <p>1. Citation text. <a href="https://source.url">Source</a></p>
</aside>
```

Do NOT use `<ol><li>` for ePub endnotes. The `<aside epub:type="footnote">` wrapper is required for popup footnotes on iBooks, Kobo, and Kindle. Without it, readers see flat endnote lists instead of interactive popups.

Each chapter's endnotes MUST be in a separate file (`chNN-notes.xhtml`), not inlined in the chapter XHTML. This separation is what enables cross-file `noteref` linking.

iBooks and Kobo render these as popup footnotes. Kindle converts them to popup endnotes automatically.

### Cover image

- Required format: JPEG
- Recommended size: 1600 x 2560 pixels (1:1.6 ratio)
- Minimum: 625 x 1000 pixels
- Declared in OPF with `properties="cover-image"`
- The pipeline accepts a user-provided cover or generates a text-only cover from spine.json metadata

### CSS

Use `assets/epub.css`, NOT `assets/print.css`. The ePub stylesheet uses relative units (em, %) instead of fixed units (pt, mm), strips `@page` rules, and replaces `page-break` with `break-before`/`break-after`.

### Validation

Run `epubcheck` on the generated `.epub` file if the tool is available. Common failures:
- `mimetype` not the first ZIP entry or compressed (must be store-only)
- Unclosed XHTML tags
- Missing manifest entries for referenced files
- Broken internal links between chapters and endnotes

### Distribution

The resulting ePub3 is directly uploadable to:
- **Amazon KDP** — KDP converts ePub3 to KFX internally
- **Apple Books** — via Apple Books for Authors or iTunes Connect
- **Kobo** — via Kobo Writing Life
- **Google Play Books** — via Google Play Books Partner Center

### Output

Write the assembled ePub to `book/output/<topic-slug>.epub`.

## Failure handling

If WeasyPrint returns non-zero, the renderer:

1. Logs the WeasyPrint stderr.
2. Does not emit a PDF.
3. Exits with a non-zero code.

The renderer never emits a partial or fallback PDF.
