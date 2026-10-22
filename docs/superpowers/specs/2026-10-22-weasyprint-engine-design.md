# Design Spec: PDF Engine Switch (Puppeteer → WeasyPrint)

**Date:** 2026-10-22
**Status:** Approved
**Scope:** Replace the PDF rendering engine from Puppeteer (headless Chrome) to WeasyPrint (CSS Paged Media Level 3). Update print.css with running headers, TOC page numbers, and PDF bookmarks. Add math pre-rendering step.

---

## Problem

The print.css has professional book typography (6×9 trim, first-line indent, Garamond, drop caps, chapter openers, asymmetric margins) but Puppeteer cannot render most of it. Specifically:

- No `@page :left/:right` (verso/recto page styling)
- No named pages (`@page chapter-opener`, `@page frontmatter`)
- No margin boxes (`@top-left`, `@top-right`, `@bottom-center`)
- No running headers that vary by chapter
- No `target-counter` for TOC page numbers
- No PDF bookmarks

The CSS is ready. The engine is not.

## Solution

Switch to WeasyPrint. All 15 critical CSS features are supported (verified by spike).

## Changes

### 1. print.css — Add running headers, TOC counters, bookmarks

Add after the existing `@page` rules:

```css
/* Running headers via named strings */
h1.chapter {
  string-set: chapter-title content();
}

@page :left {
  @top-center {
    content: string(book-title);
    font-variant: small-caps;
    font-size: 8pt;
    color: #999;
  }
  @top-left {
    content: counter(page);
    font-size: 8pt;
    font-family: "Source Sans Pro", "Helvetica", sans-serif;
    color: #999;
  }
  @top-right { content: none; }
}

@page :right {
  @top-center {
    content: string(chapter-title);
    font-style: italic;
    font-size: 8pt;
    color: #999;
  }
  @top-right {
    content: counter(page);
    font-size: 8pt;
    font-family: "Source Sans Pro", "Helvetica", sans-serif;
    color: #999;
  }
  @top-left { content: none; }
}

/* PDF bookmarks */
h1 { bookmark-level: 1; }
h2 { bookmark-level: 2; }
h3 { bookmark-level: 3; }
```

Remove:
- `-webkit-hyphens: auto` (WeasyPrint uses `hyphens: auto` directly with Pyphen)
- `-webkit-print-color-adjust: exact` (WeasyPrint renders colours faithfully by default)

### 2. print.css — TOC restructure

Replace the current `.toc-page` empty-span approach. The HTML assembly step emits TOC entries as anchor links:

```html
<div class="toc-entry">
  <a href="#ch01">Chapter 1: The Invisible Hand</a>
</div>
```

The CSS fills page numbers automatically:

```css
.toc-entry a::after {
  content: leader('.') target-counter(attr(href), page);
  font-size: 10pt;
  color: #666;
}
```

Remove the `.toc-dots` and `.toc-page` CSS classes — no longer needed.

### 3. render-protocol.md — Engine swap

Replace all references to "headless browser" and "Puppeteer" with "WeasyPrint".

Update the stage order:

1. Assemble chapters from `book/chapters/`
2. Convert markdown to HTML paragraphs with HTML escaping
3. Inject endnote references AFTER escaping (existing fix from v0.3)
4. Preserve LaTeX delimiters (existing fix from v0.3)
5. **NEW: Pre-render LaTeX math.** Scan for `$...$` and `$$...$$`. Replace each with server-side rendered HTML using `katex.renderToString()` (Node.js) or `latex2mathml` (Python). WeasyPrint does not execute JavaScript, so math must be rendered before the PDF engine sees it.
6. Inline figure specs
7. Generate TOC from `book/architecture.json` — emit entries as `<a href="#chNN">` links (NOT empty spans)
8. Generate front matter (half-title, title, copyright, dedication)
9. Add a hidden book-title element for running headers: `<span class="book-title-string" style="display:none">Book Title</span>` with `string-set: book-title content()`
10. Generate part divider pages
11. Wrap in `<!doctype html>` with inlined `assets/print.css`. Ensure `<html lang="en">` for hyphenation.
12. **Render PDF via WeasyPrint** — `weasyprint input.html output.pdf`. No JavaScript dependency. No wait-for-render timing.

### 4. render-protocol.md — Installation prerequisite

Add to the protocol:

```
## Prerequisites

WeasyPrint must be installed:
  pip install weasyprint

macOS system dependencies (if not already present):
  brew install pango cairo libffi gdk-pixbuf harfbuzz

EB Garamond font must be available. Install via:
  brew install --cask font-eb-garamond
  (or download from Google Fonts and install system-wide)

Verify: weasyprint --version
```

### 5. HTML assembly — Book title string-set element

Add to the HTML body, before the first chapter:

```html
<span class="book-title-string">The Mentor Gap</span>
```

With CSS:
```css
.book-title-string {
  display: none;
  string-set: book-title content();
}
```

WeasyPrint reads the `string-set` property and uses it in `@page :left` running headers. The element is hidden but the string persists.

## What does NOT change

- SKILL.md pipeline (no new steps exposed to the user)
- Agent prompts (chapter-drafter, narrative-briefer, etc.)
- Schema files
- ePub pipeline (uses epub.css, not paged media)
- The "MD over JS" philosophy — WeasyPrint is a CLI tool invoked the same way Puppeteer was

## Risks

1. **EB Garamond not installed** — WeasyPrint falls back to system serif. The render protocol documents the font requirement.
2. **Math-heavy books** — KaTeX pre-rendering adds a step. If no math is present, the step is a no-op.
3. **`100vh` on title/part pages** — May not map to page height in paged media. Test and potentially replace with absolute positioning.
4. **`target-counter` page-0 bug** — Known WeasyPrint issue if `counter-reset: page` is used. Solution: do not reset the page counter.

## Success criteria

A test PDF rendered from an existing book's HTML output:
- Has running headers (book title verso, chapter title recto)
- Has page numbers in outer top margins
- Has automatic TOC page numbers matching actual chapter start pages
- Has no running headers on front matter, chapter openers, or part dividers
- Has PDF bookmarks navigable in any PDF reader
- Has rendered math (if the book contains LaTeX)
- Has correct 6×9 trim, asymmetric margins, first-line indent, drop caps
