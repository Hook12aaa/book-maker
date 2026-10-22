# Book-Maker Plugin Design Spec

**Date:** 2026-08-19
**Author:** Anton Chepaldin
**Status:** Draft
**Base reference:** deep-report v0.2.0 (`../report`)

## 1. Purpose

A Claude Code plugin that produces **claim-verified, narratively coherent non-fiction books** as PDF. It inherits deep-report's verified research pipeline and adds a narrative architecture system that ensures the book reads as a continuous, flowing argument — not a collection of isolated report sections.

The core problem: deep-report produces excellent verified content but each paragraph feels like its own section. Paragraphs don't flow into each other, chapters don't connect, and there is no story arc. Book-maker solves this by introducing a **book bible** — a living continuity ledger tracked and adversarially verified throughout the pipeline, analogous to deep-report's claims ledger but for narrative structure.

## 2. Constraints

- **200-300 pages** target output
- **PDF only** — no artifact generation. HARD-GATE: the Artifact tool must never be invoked.
- **Endnotes per chapter** — numbered superscripts in text, full citation with clickable source URLs at end of each chapter
- **Headless browser PDF** — same Puppeteer approach as deep-report
- **Node >= 20**, Puppeteer, Graphviz `dot` as dependencies (same as deep-report)

## 3. Book Modes

User must pick one before the pipeline starts.

### 3.1 Narrative Mode

Argument-driven, story arc, personal voice, light citations. Modelled on *The Consultant's Forge*.

- Second-person or engaging narrative voice
- Stories, analogies, extended metaphors
- Chapters build progressive argument through scenes and examples
- Endnotes present but unobtrusive (research supports the argument, doesn't dominate it)
- 8-15 chapters across 3-5 parts

### 3.2 Research Mode

Evidence-driven, systematic, dense citations, academic register. Modelled on *The Certification Paradox* but with proper narrative flow.

- Third-person analytical voice
- Heavy citation density, every claim traced to verified evidence
- Chapters build through documented evidence toward synthesis
- Endnotes dense and comprehensive
- 10-20 chapters across 3-6 parts

## 4. Pipeline (14 Stages)

### Stage 1: Confirm

Inputs required before proceeding (HARD-GATE):
- **Topic** — the book's subject
- **Book mode** — narrative or research
- **Voice anchor** — same protocol as deep-report (calm technical lecturer default, named anchors available). Applied uniformly throughout.
- **Narrative direction** (optional) — user can suggest the story arc, thesis, or chapter structure. If not provided, the system generates one from research findings.

### Stage 2: Decompose

Split the topic into 6-12 non-overlapping, independently researchable themes. More themes than deep-report (4-8) because books are longer and need more granular research coverage. Written to `book/themes.md`.

### Stage 3: Parallel Research

One subagent per theme. Each writes to `book/research/<slug>.md`. Every claim carries an inline `[source: <url>]` citation. No speculation in research drafts. Same protocol as deep-report.

### Stage 4: Extract Claims

Every load-bearing fact goes into `book/claims.jsonl` with `verdict: "pending"`. Same structure as deep-report.

### Stage 5: Verify Claims

Same verification sidecar as deep-report:
- Source trust hierarchy: primary record > official aggregator > reputable secondary > tertiary
- Refuses search-engine pages, social media, AI summaries, undated pages
- Close-paraphrase rule for numbers, names, dates
- One corrective re-research pass allowed
- Halts with `CLAIMS_UNVERIFIED` if any claim fails after retry

### Stage 6: Build Spine

Produce `book/spine.json`:

```json
{
  "thesis": "One-sentence thesis statement",
  "thesis_expanded": "One-paragraph expansion: setup, three complications, resolution",
  "arc": [
    {
      "beat": "setup",
      "chapters": ["ch01", "ch02", "ch03"],
      "movement": "What the reader learns in this beat"
    },
    {
      "beat": "investigation",
      "chapters": ["ch04", "ch05", "ch06", "ch07"],
      "movement": "..."
    },
    {
      "beat": "evidence",
      "chapters": ["ch08", "ch09"],
      "movement": "..."
    },
    {
      "beat": "synthesis",
      "chapters": ["ch10", "ch11"],
      "movement": "..."
    },
    {
      "beat": "resolution",
      "chapters": ["ch12"],
      "movement": "..."
    }
  ]
}
```

If the user provided a narrative direction in Stage 1, the spine is built from that. Otherwise, a subagent generates it from the verified research.

### Stage 7: Build Architecture

Produce `book/architecture.json` — the chapter skeleton. Each chapter entry:

```json
{
  "chapter_id": "ch03",
  "title": "Chapter Title",
  "part": "part_1",
  "part_title": "Part Title",
  "beat": "setup",
  "central_argument": "What this chapter proves or establishes",
  "evidence_keys": ["claim_042", "claim_043"],
  "reader_enters_believing": "What the reader thinks coming in",
  "reader_exits_believing": "What the reader thinks going out",
  "connects_forward": ["ch04_topic_slug"],
  "connects_backward": ["ch02_topic_slug"],
  "sections": [
    {
      "section_id": "ch03_s01",
      "title": "Section Title",
      "function": "establish",
      "purpose": "What this section does for the reader",
      "claims_used": ["claim_042"],
      "threads_advanced": ["thread_worker_invisibility"]
    }
  ]
}
```

Section function vocabulary: `orient`, `establish`, `complicate`, `evidence`, `synthesize`, `pivot`, `resolve`, `bridge`.

Simultaneously produce:

**`book/concepts.json`** — concept cards:
```json
{
  "concept_id": "concept_pyramid_principle",
  "label": "The Pyramid Principle",
  "first_introduced": {"chapter": "ch02", "context": "Minto's framework for structured communication"},
  "reinforced": [{"chapter": "ch05", "context": "Applied to proposal architecture"}],
  "challenged": [{"chapter": "ch09", "context": "Limits in ambiguous domains"}],
  "assumed_known_after": "ch02"
}
```

**`book/arguments.json`** — argument dependency DAG:
```json
{
  "node_id": "arg_certification_excludes_labour",
  "depends_on": ["arg_movement_aristocratic_origins", "arg_codex_transfer_failure"],
  "supports": ["arg_paradox_thesis"],
  "chapter": "ch02",
  "section": "ch02_s03"
}
```

### Stage 8: Build Thread Registry

Produce `book/threads.jsonl` — every narrative promise:

```json
{
  "thread_id": "thread_worker_invisibility",
  "type": "tension",
  "introduced": {
    "chapter": "ch01",
    "section": "ch01_s02",
    "how": "The seal says nothing about the person who picked the strawberry"
  },
  "developed": [
    {"chapter": "ch02", "section": "ch02_s05", "how": "Worker's perspective during inspection"}
  ],
  "resolved": null,
  "status": "open"
}
```

Thread types: `question`, `concept`, `anecdote`, `tension`, `metaphor`, `case_study`.

### Stage 9: Build Transition Contracts

Produce `book/transitions.json`:

```json
{
  "from_chapter": "ch02",
  "exit_state": "Reader understands certification architecture excludes labour by design",
  "bridge_sentence": "The architecture is clear. The question now is: who works within it?",
  "to_chapter": "ch03",
  "entry_assumption": "Reader accepts the exclusion is structural, now needs to understand WHO is excluded"
}
```

### Stage 10: Validate Skeleton

Before any chapter is drafted, run pre-draft gates on the architecture:

| Gate | Check | Fail condition |
|---|---|---|
| **Concept ordering** | Concepts.json vs chapter sequence | Any concept referenced before `first_introduced` chapter |
| **Argument DAG** | Topological sort of arguments.json | Circular dependency, or dependency on a later chapter |
| **Horizontal flow** | Chapter titles + central arguments read in sequence | Sequence doesn't form progressive argument |
| **Transition coverage** | Transitions.json completeness | Any chapter pair missing a transition contract |
| **Thread seeding** | Threads.jsonl coverage | Fewer than 3 threads introduced in first 25% of chapters |
| **Claim coverage** | Claims vs architecture evidence_keys | Any verified claim not assigned to any chapter |

If any gate fails, the architecture is revised before drafting begins.

### Stage 11: Chapter Drafting

**Sequential, not parallel.** Each chapter is drafted in order so the drafting agent can:
- Reference what was established in prior chapters
- Register new threads as they're introduced (bible grows during drafting)
- Write transitions that build on actual drafted content, not planned content

Each drafted chapter is written to `book/chapters/<chapter_id>.md`.

During drafting, the agent:
- Tags each section with its Story Grid values (polarity shift, turning point)
- Updates `book/threads.jsonl` — new threads get `status: "open"`, developed threads get new `developed` entries, resolved threads get `status: "resolved"`
- Updates `book/grid.json` with per-section value charges

**Drafting constraints by mode:**

*Narrative mode:*
- Paragraphs must use transitional bridges (the last sentence of paragraph N sets up paragraph N+1)
- At least one scene/anecdote per chapter
- Metaphors introduced must be extended or called back
- Direct reader address permitted

*Research mode:*
- Every factual claim must reference a verified claim from claims.jsonl
- Evidence density: minimum 3 cited claims per section
- Analytical voice maintained throughout
- No unsupported assertions

### Stage 12: Continuity Review

A **separate agent** (fresh context, no drafting history) reads the full draft plus all bible artifacts and runs 8 quality gates:

| # | Gate | Method | Fail action |
|---|---|---|---|
| 1 | **Thread completeness** | Scan threads.jsonl for `status: "open"` | Flag orphan threads; send owning chapters back for revision |
| 2 | **Horizontal flow** | Extract chapter titles + opening sentences; read in sequence | Flag broken sequence points |
| 3 | **Transition audit** | Extract last para of ch N + first para of ch N+1; evaluate bridge quality | Flag cold starts, orphan closes, logical gaps |
| 4 | **Concept ordering** | Verify no concept used before introduction | Flag forward-reference errors |
| 5 | **Pacing envelope** | Plot chapter word counts + claim density | Flag sagging middle, uniform lengths, flat density |
| 6 | **Redundancy detection** | Extract core claim per section; pairwise similarity | Flag sections making same claim without adding depth |
| 7 | **Entity consistency** | Check spelling consistency, first-use introduction, recurrence | Flag inconsistencies |
| 8 | **Arc completeness** | Plot section polarity charges across book | Flag flatlined sequences, missing turning point |

One revision pass allowed. If gates still fail after revision, the pipeline halts with `NARRATIVE_BROKEN`.

### Stage 13: Endnote Assembly

For each chapter:
1. Collect all `[source: <url>]` citations in order of appearance
2. Assign sequential numbers starting from 1 per chapter
3. Replace inline citations with superscript numbers
4. Generate endnote section at end of chapter with full citation and clickable URL
5. Validate: every superscript has a matching endnote, every endnote has a matching superscript

Output: `book/endnotes/<chapter_id>.json`

```json
{
  "chapter_id": "ch03",
  "endnotes": [
    {
      "number": 1,
      "text": "Author, Title, Publication, Date",
      "url": "https://example.com/source",
      "in_text_location": "ch03_s02_p04"
    }
  ]
}
```

### Stage 14: Spec Figures

Same four families as deep-report: `hierarchy`, `sequence`, `matrix`, `table`. Same render + measure pipeline. Same quality gates. Refused layouts: mind-map, radial, scatter, free-form.

### Stage 15: Render HTML → PDF

Markdown + endnotes + figure HTML → styled HTML → PDF via Puppeteer.

**Book-specific rendering (differs from deep-report):**

- **Title page** — title, subtitle, author, date. Full-page, centred.
- **Table of contents** — auto-generated from part/chapter hierarchy with page numbers
- **Part divider pages** — part title on its own page with `page-break-before`
- **Chapter pages** — chapter title starts on a new page
- **Endnotes section** — appears at end of each chapter, before the next chapter's page break
- **Bibliography** — consolidated back matter with all sources alphabetised
- **Page numbers** — bottom centre, starting after TOC

**Typography (extends deep-report's print.css):**
- A4, 22mm/24mm margins
- 11pt serif body (Source Serif Pro), 1.45 line-height
- Chapter titles: 24pt bold
- Part titles: 30pt bold
- Section headings: 14pt bold
- Endnote text: 9pt
- Running headers: chapter title, 8pt

### Stage 16: Post-Render Verification

Same checks as deep-report's verify-pdf.js:
- Figure fit within content width
- WCAG AA contrast (4.5:1 body, 3:1 large)
- Orphan headings
- Blank page detection (>= 10% text density)

Plus book-specific checks:
- TOC page numbers match actual pages
- Every chapter starts on a new page
- No endnote section is empty
- Part dividers appear on their own pages

### Stage 17: Emit Verdict

| Verdict | Condition |
|---|---|
| `BOOK_SHIPPED` | PDF rendered, all claims verified, all narrative gates passed |
| `CLAIMS_UNVERIFIED` | Any claim failed verification after corrective pass |
| `NARRATIVE_BROKEN` | Continuity review failed after revision pass |
| `SCOPE_TOO_VAGUE` | Topic rejected at Stage 1 |

## 5. HARD-GATEs

1. Must have explicit topic + voice anchor + book mode before proceeding.
2. Must not begin drafting until skeleton validation (Stage 10) passes.
3. Must not enter render until every claim has a verifier verdict.
4. Must not emit `BOOK_SHIPPED` unless all 8 continuity gates pass.
5. Must not invoke the Artifact tool. Output is PDF to filesystem only.
6. Must not emit scattered/free-form figure layouts.
7. Must produce PDF exclusively from rendered HTML via headless browser.
8. Must not draft chapters in parallel — sequential only.

## 6. File Structure

```
book/
├── spine.json              # Thesis + 5-beat arc
├── architecture.json       # Chapter skeleton with sections
├── threads.jsonl           # Thread registry (grows during drafting)
├── transitions.json        # Chapter-to-chapter contracts
├── concepts.json           # Concept cards
├── arguments.json          # Argument dependency DAG
├── grid.json               # Story Grid (value charges per section)
├── claims.jsonl            # Verified claims (from research pipeline)
├── themes.md               # Research decomposition
├── research/
│   ├── theme-1.md
│   └── theme-2.md
├── chapters/
│   ├── ch01.md
│   └── ch02.md
├── endnotes/
│   ├── ch01.json
│   └── ch02.json
├── figures/
│   ├── fig-01.spec.json
│   └── fig-01.html
├── output/
│   ├── book.html
│   └── book.pdf
└── bibliography.json       # Consolidated back matter
```

## 7. What Carries Over from deep-report

| Component | Status |
|---|---|
| Research pipeline (parallel subagents) | Unchanged |
| Claims extraction | Unchanged |
| Verification sidecar + source trust hierarchy | Unchanged |
| Figure spec system (4 families) | Unchanged |
| Figure render + measure pipeline | Unchanged |
| Prose quality metrics (Coleman-Liau, hedge density, etc.) | Unchanged |
| Puppeteer PDF rendering | Extended (book CSS) |
| Voice anchor protocol | Unchanged |

## 8. What's New

| Component | Purpose |
|---|---|
| Book modes (narrative/research) | Different voice, citation density, structure |
| Spine document | Through-line + 5-beat arc |
| Architecture with entry/exit beliefs | Chapter skeleton with reader journey |
| Thread registry | Promise-payoff tracking (narrative claims ledger) |
| Transition contracts | Chapter-to-chapter bridge specifications |
| Concept cards | Term/framework lifecycle tracking |
| Argument DAG | Logical dependency validation |
| Story Grid | Per-section value charges + polarity tracking |
| Skeleton validation (pre-draft) | 6 gates before drafting begins |
| Sequential chapter drafting | Ordered drafting with growing bible |
| 8-gate continuity review | Adversarial narrative coherence checking |
| Endnote assembly | Per-chapter numbered endnotes with clickable URLs |
| Book-specific CSS | Title page, TOC, part dividers, running headers |
| 4 verdicts (vs deep-report's 3) | Added `NARRATIVE_BROKEN` |

## 9. Artifact Prevention

The skill must include:
- A HARD-GATE: "Do NOT invoke the Artifact tool. All output goes to the filesystem as PDF."
- The rendering stage writes to `book/output/book.pdf`, never to an artifact URL.
- If the LLM attempts to invoke the Artifact tool, the pipeline halts.

## 10. Plugin Structure (Target)

```
book-maker/
├── .claude-plugin/
│   ├── plugin.json
│   └── marketplace.json
├── config.sh
├── hooks/
│   ├── hooks.json
│   └── session-start
├── commands/
│   └── book-maker.md
├── skills/
│   ├── using-book-maker/
│   │   └── SKILL.md
│   └── book-maker/
│       ├── SKILL.md
│       ├── package.json
│       ├── agents/
│       │   ├── narrative-architect.md
│       │   ├── chapter-drafter.md
│       │   ├── continuity-reviewer.md
│       │   ├── prose-spec-author.md
│       │   └── figure-spec-author.md
│       ├── schemas/
│       │   ├── spine.schema.json
│       │   ├── architecture.schema.json
│       │   ├── thread.schema.json
│       │   ├── transition.schema.json
│       │   ├── concept.schema.json
│       │   ├── argument.schema.json
│       │   ├── grid.schema.json
│       │   ├── endnote.schema.json
│       │   ├── prose-section-spec.schema.json
│       │   └── figure-spec.schema.json
│       ├── scripts/
│       │   ├── build-pdf.js
│       │   ├── render-prose.js
│       │   ├── render-figure.js
│       │   ├── measure-prose.js
│       │   ├── measure-figure.js
│       │   ├── verify-pdf.js
│       │   ├── validate-skeleton.js
│       │   ├── validate-continuity.js
│       │   └── assemble-endnotes.js
│       ├── references/
│       │   ├── verifier-protocol.md
│       │   ├── depth-modes.md
│       │   ├── render-protocol.md
│       │   ├── prose-metrics.md
│       │   ├── figure-layouts.md
│       │   ├── voice-anchors.md
│       │   ├── narrative-functions.md
│       │   └── continuity-gates.md
│       └── assets/
│           ├── print.css
│           └── hedge-words.txt
└── tests/
    ├── run-tests.sh
    ├── drift-check.sh
    ├── integration-gates.sh
    └── fixtures/
```
