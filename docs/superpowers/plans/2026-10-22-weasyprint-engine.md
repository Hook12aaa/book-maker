# WeasyPrint Engine Switch — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Puppeteer with WeasyPrint for PDF rendering, enabling running headers, TOC page numbers, and PDF bookmarks.

**Architecture:** Update print.css with CSS Paged Media Level 3 features (string-set, target-counter, bookmark-level). Update render-protocol.md to document WeasyPrint usage and math pre-rendering. Test against an existing book HTML to verify all features render correctly.

**Tech Stack:** WeasyPrint (Python, already installed at `/Users/hook/miniforge3/bin/weasyprint`), KaTeX Node.js API for math pre-rendering, EB Garamond font.

**Spec:** `docs/superpowers/specs/2026-10-22-weasyprint-engine-design.md`

## Global Constraints

- WeasyPrint is the only permitted PDF producer. Puppeteer references are removed.
- No JavaScript in the HTML delivered to WeasyPrint. Math is pre-rendered.
- `<html lang="en">` is required on every document for hyphenation.
- EB Garamond must be available as a system font or via `@font-face`.
- Do NOT reset the page counter (`counter-reset: page`) — this breaks `target-counter`.
- The ePub pipeline is unchanged. Only print.css and render-protocol.md are affected.

## Review Focus

1. **Math-heavy chapter with `<` and `>` in LaTeX** — pre-rendering must handle comparison operators inside `$...$` without HTML-escaping them. Test with a chapter from the mod_neuro book.
2. **TOC target-counter shows page 0** — the known WeasyPrint bug when page counter is reset. Verify no `counter-reset: page` exists anywhere.
3. **EB Garamond missing** — WeasyPrint must fall back gracefully to Palatino/Georgia, not produce garbled output.
4. **Chapter opener running headers suppressed** — named page `chapter-opener` must NOT show running headers in top margin. Verify blank margin on chapter-start pages.
5. **Blank verso pages before recto chapter openers** — `page-break-before: right` generates blank pages. These must have no running headers and no page numbers.

---

### Task 1: Update print.css — Running headers and TOC

**Files:**
- Modify: `skills/book-maker/assets/print.css`

**Interfaces:**
- Consumes: existing print.css (582 lines)
- Produces: print.css with `string-set`, `target-counter`, `bookmark-level`, webkit prefixes removed

- [ ] **Step 1: Add string-set for running headers**

Add after the `h1.chapter` rule (around line 304):

```css
h1.chapter {
  /* existing properties stay */
  string-set: chapter-title content();
}
```

Add a hidden element rule for the book title:

```css
.book-title-string {
  display: none;
  string-set: book-title content();
}
```

- [ ] **Step 2: Update @page :left and :right with running headers**

Replace the existing `@page :left` block (lines 21-30) with:

```css
@page :left {
  margin-left: 0.75in;
  margin-right: 0.875in;
  @top-left {
    content: counter(page);
    font-family: "Source Sans Pro", "Helvetica", sans-serif;
    font-size: 8pt;
    color: #999;
  }
  @top-center {
    content: string(book-title);
    font-variant: small-caps;
    font-size: 8pt;
    color: #999;
  }
  @top-right { content: none; }
}
```

Replace the existing `@page :right` block (lines 32-36) with:

```css
@page :right {
  margin-left: 0.875in;
  margin-right: 0.75in;
  @top-right {
    content: counter(page);
    font-family: "Source Sans Pro", "Helvetica", sans-serif;
    font-size: 8pt;
    color: #999;
  }
  @top-center {
    content: string(chapter-title);
    font-style: italic;
    font-size: 8pt;
    color: #999;
  }
  @top-left { content: none; }
}
```

- [ ] **Step 3: Replace TOC styling with target-counter approach**

Remove the `.toc-dots` and `.toc-page` rules (lines 255-268). Replace with:

```css
.toc-entry a {
  color: #111;
  text-decoration: none;
}

.toc-entry a::after {
  content: leader('.') target-counter(attr(href), page);
  font-size: 10pt;
  color: #666;
}
```

- [ ] **Step 4: Add PDF bookmark levels**

Add after the heading rules:

```css
h1 { bookmark-level: 1; }
h2 { bookmark-level: 2; }
h3 { bookmark-level: 3; }
```

- [ ] **Step 5: Remove webkit prefixes**

Remove these lines:
- Line 82: `-webkit-hyphens: auto;`
- Line 84: `-webkit-print-color-adjust: exact;`
- Line 399: `-webkit-print-color-adjust: exact;`

- [ ] **Step 6: Remove the old @page default margin box**

The default `@page` block (lines 1-11) has a `@bottom-center` page counter. Remove it — page numbers now live in `@top-left` (verso) and `@top-right` (recto) via the `:left/:right` rules. The `@page :first` block already suppresses all margin content.

Replace lines 1-11:

```css
@page {
  size: 6in 9in;
  margin: 0.75in 0.75in 0.75in 0.875in;
}
```

- [ ] **Step 7: Verify named pages suppress headers correctly**

Confirm these named page rules have NO `@top-*` content (they already should from the current CSS):
- `@page frontmatter` — no headers, no page numbers
- `@page chapter-opener` — no headers, page number at `@bottom-center` only
- `@page part-page` — no headers, no page numbers

---

### Task 2: Update render-protocol.md — WeasyPrint and math pre-rendering

**Files:**
- Modify: `skills/book-maker/references/render-protocol.md`

**Interfaces:**
- Consumes: existing render-protocol.md (247 lines)
- Produces: render-protocol.md with WeasyPrint references, math pre-rendering step, TOC restructure, prerequisites

- [ ] **Step 1: Replace the opening description**

Change line 3 from:
```
The renderer takes the drafted chapters, endnotes, and figure specs, emits styled HTML with book structure, and prints the HTML to PDF via a headless browser. Non-browser PDF generators are out of scope.
```
To:
```
The renderer takes the drafted chapters, endnotes, and figure specs, emits styled HTML with book structure, and prints the HTML to PDF via WeasyPrint. WeasyPrint renders CSS Paged Media Level 3 — running headers, page numbers, TOC counters, and PDF bookmarks — without JavaScript.
```

- [ ] **Step 2: Add prerequisites section**

Add after the Outputs section:

```markdown
## Prerequisites

WeasyPrint must be installed:
  pip install weasyprint

macOS system dependencies (if not already present):
  brew install pango cairo libffi gdk-pixbuf harfbuzz

EB Garamond font must be available as a system font:
  brew install --cask font-eb-garamond

Verify installation: weasyprint --version
```

- [ ] **Step 3: Replace the running headers section**

Replace the current section 11 (Running headers, around line 97-100) which says headers need Puppeteer `headerTemplate`. Replace with:

```markdown
### 11. Running headers

WeasyPrint renders running headers via CSS `string-set` and margin boxes. No build script configuration needed — the CSS handles everything:
- Verso (left pages): book title in small caps (centre), page number (outer margin)
- Recto (right pages): chapter title in italic (centre), page number (outer margin)
- Suppressed on: front matter pages, chapter opener pages, part divider pages, blank pages

The HTML must include a hidden book-title element:
`<span class="book-title-string">Book Title</span>`
with CSS `string-set: book-title content()`. Each `h1.chapter` sets `string-set: chapter-title content()` automatically.
```

- [ ] **Step 4: Replace the KaTeX step with math pre-rendering**

Replace the current step 10 (KaTeX JavaScript loading, line 112) with:

```markdown
10. Pre-render LaTeX math. Scan the assembled HTML for `$...$` (inline) and `$$...$$` (display) delimiters. Replace each with server-side rendered HTML using one of:
    - `katex.renderToString(latex, {displayMode: true/false})` via Node.js
    - `latex2mathml.converter.convert(latex)` via Python
    WeasyPrint does not execute JavaScript. All math must be rendered to HTML/MathML/SVG before the PDF engine sees the document. If no LaTeX delimiters are found, this step is a no-op.
```

- [ ] **Step 5: Replace the PDF printing step**

Replace the current step 11 (headless browser printing, line 113) with:

```markdown
11. Render PDF via WeasyPrint: `weasyprint book.html book.pdf`. No JavaScript dependency. No wait-for-render timing. Ensure the HTML document has `<html lang="en">` for hyphenation support.
```

Replace "The headless browser is the only permitted PDF producer." with:

```
WeasyPrint is the only permitted PDF producer.
```

- [ ] **Step 6: Replace the TOC page number section**

Replace the current "TOC page numbers" section (around line 117-119) with:

```markdown
### TOC page numbers

WeasyPrint computes TOC page numbers via CSS `target-counter`. Each TOC entry is an anchor link (`<a href="#chNN">Chapter Title</a>`) and the CSS rule `.toc-entry a::after { content: leader('.') target-counter(attr(href), page); }` fills the page number automatically. Do NOT use `counter-reset: page` anywhere in the document — this causes all target-counter values to resolve to 0.
```

- [ ] **Step 7: Update the HTML assembly step for TOC**

Update step 7 (TOC generation) to specify that TOC entries are anchor links:

```markdown
7. Generate the table of contents from `book/architecture.json`. Emit entries as anchor links: `<div class="toc-entry"><a href="#chNN">Chapter N: Title</a></div>`. WeasyPrint's `target-counter` CSS fills page numbers automatically. Do NOT use empty `<span class="toc-page">` elements.
```

- [ ] **Step 8: Add book-title element to HTML assembly**

Add a new step between part dividers and the final wrap:

```markdown
9. Add a hidden book-title element for running headers: `<span class="book-title-string">BOOK TITLE</span>` immediately after `<main>` opens. This element is invisible but WeasyPrint reads its `string-set` property to populate verso running headers.
```

---

### Task 3: Test against existing book HTML

**Files:**
- No files created or modified in the plugin
- Uses: `/Users/hook/Documents/coding/python/dossays/career_mentoring/book/output/ai-career-mentoring.html` as test input

**Interfaces:**
- Consumes: updated print.css, existing book HTML
- Produces: test PDF verifying all features

- [ ] **Step 1: Create a test HTML from the existing book**

Copy the career mentoring book HTML to a test location:

```bash
cp /Users/hook/Documents/coding/python/dossays/career_mentoring/book/output/ai-career-mentoring.html /tmp/weasyprint-test.html
```

- [ ] **Step 2: Patch the test HTML for WeasyPrint**

The existing HTML was built for Puppeteer. Apply these patches to the copy:

1. Replace inline CSS with the updated print.css content
2. Add `lang="en"` to `<html>` if missing
3. Add `<span class="book-title-string">The Mentor Gap</span>` after `<main>`
4. Remove `<script>` tags (KaTeX JS) — not needed
5. Convert TOC entries from `<span class="toc-page"></span>` to `<a href="#chNN">` links
6. Add `string-set: chapter-title content()` to each `h1.chapter` if not already in CSS

- [ ] **Step 3: Render with WeasyPrint**

```bash
weasyprint /tmp/weasyprint-test.html /tmp/weasyprint-test.pdf
```

- [ ] **Step 4: Verify all features in the output PDF**

Open the PDF and check:

| Feature | Expected | Check |
|---|---|---|
| Trim size | 6×9 inches | Measure page dimensions |
| Running header (verso) | "The Mentor Gap" in small caps, page number left | Open a left-hand page mid-chapter |
| Running header (recto) | Chapter title in italic, page number right | Open a right-hand page mid-chapter |
| Chapter opener | No running header, page number at bottom centre, title sunk 1/3 down | Open any chapter start |
| Front matter | No running headers, no page numbers | Check title page, copyright page, TOC |
| TOC page numbers | Actual page numbers matching chapter starts | Compare TOC numbers to chapter pages |
| Drop cap | First letter of first paragraph oversized (3.2em) | Check any chapter opening |
| First-line indent | Paragraphs indented 1.5em, no spacing between | Check body text |
| Justified text | Text justified with hyphenation | Check body text |
| PDF bookmarks | H1/H2/H3 appear in PDF reader sidebar | Check bookmark panel |
| Blank verso pages | Truly blank (no headers, no numbers) | Find a blank page before a recto chapter start |
| Asymmetric margins | Gutter wider on binding side | Compare inner vs outer margins |
| Endnotes | Superscript numbers linking to chapter-end notes | Check any endnote reference |

- [ ] **Step 5: Fix any issues found in step 4**

If any feature doesn't render correctly, adjust print.css and re-run `weasyprint`. Common fixes:
- `100vh` not working for title page centering → replace with `position: absolute; top: 33%`
- Font not found → verify `brew install --cask font-eb-garamond` or add `@font-face` rule
- target-counter showing 0 → check for `counter-reset: page` anywhere in CSS

- [ ] **Step 6: Clean up test files**

```bash
rm /tmp/weasyprint-test.html /tmp/weasyprint-test.pdf
```
