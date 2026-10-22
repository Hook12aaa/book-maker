# Scope: book-maker

## Name
`book-maker` — produces claim-verified, narratively coherent non-fiction books as PDF from a user-supplied topic.

## Slash command
`/book-maker`

## Triggers
- **slash**: `/book-maker`
- **natural-language**: "write me a book on X", "build a book about X", "produce a non-fiction book", "generate a book on X", "create a book about X"

## Verdict tokens
- `BOOK_SHIPPED` — PDF rendered, all claims verified, all 8 narrative continuity gates passed.
- `CLAIMS_UNVERIFIED` — research complete but one or more load-bearing claims failed the verification sidecar after corrective pass; do not ship.
- `NARRATIVE_BROKEN` — continuity review failed after revision pass; the book's narrative structure does not hold together.
- `SCOPE_TOO_VAGUE` — topic rejected at the confirmation stage; user must refine.

## Anti-Pattern
**"I can write the chapters without building the narrative skeleton first, and the prose is fluent enough that the claims don't need independent verification."** — skipping the narrative skeleton (spine, thread registry, transition contracts, architecture) produces paragraphs that feel like isolated report sections. Skipping claim verification produces confident hallucination. The skill exists to enforce both: narrative architecture must be built and validated before drafting begins, and every load-bearing claim must pass the verification sidecar before it reaches the final PDF.

### Supporting red flags (not the anchor, but the gate watches for them)
- "The research is done, I can start writing chapters now" — skips skeleton validation.
- "The chapters flow well enough without transition contracts" — the exact failure mode of deep-report.
- "I can draft chapters in parallel to save time" — parallel drafting breaks sequential awareness; each chapter must know what came before.
- "Claim verification is overkill for a narrative book" — narrative mode has lighter citations but the same verification requirement.

## Target project path
`/Users/hook/Documents/coding/python/Personal_AI  Projects/book_maker/` (confirmed to exist on disk).

## Plugin mode
**new** — full plugin scaffold. Empty project directory.

## Pipeline shape (design happens in next stage)
1. **Confirm** — topic, voice anchor, book mode (narrative/research). HARD-GATE: all three required.
2. **Decompose** — split topic into 6-12 researchable themes.
3. **Parallel research** — one subagent per theme, inline source citations.
4. **Extract claims** — every load-bearing fact to `book/claims.jsonl`.
5. **Verify claims** — same sidecar as deep-report (source trust hierarchy, close-paraphrase, one corrective pass).
6. **Build spine** — thesis + 5-beat arc (`book/spine.json`). User can provide or system generates.
7. **Build architecture** — chapter skeleton with entry/exit beliefs, concept cards, argument DAG.
8. **Build thread registry** — every narrative promise tracked from introduction to resolution.
9. **Build transition contracts** — chapter-to-chapter exit_state/entry_assumption pairs.
10. **Validate skeleton** — 6 pre-draft gates (concept ordering, DAG check, horizontal flow, transition coverage, thread seeding, claim coverage).
11. **Chapter drafting** — sequential (not parallel), bible grows during drafting, Story Grid values per section.
12. **Continuity review** — 8 adversarial gates (thread completeness, horizontal flow, transition audit, concept ordering, pacing envelope, redundancy detection, entity consistency, arc completeness). One revision pass. Fails → `NARRATIVE_BROKEN`.
13. **Endnote assembly** — per-chapter numbered endnotes with clickable source URLs.
14. **Spec figures** — same four families as deep-report (hierarchy, sequence, matrix, table).
15. **Render HTML → PDF** — book-specific CSS (title page, TOC, part dividers, running headers, endnotes). Puppeteer headless browser only.
16. **Post-render verification** — deep-report checks + book-specific (TOC page numbers, chapter page breaks, endnote completeness).
17. **Emit verdict** — `BOOK_SHIPPED` / `CLAIMS_UNVERIFIED` / `NARRATIVE_BROKEN` / `SCOPE_TOO_VAGUE`.

## Known constraints (locked-in)
- Output: 200-300 page PDF (rendered from HTML via Puppeteer, not Python PDF libraries).
- Two book modes: narrative (argument-driven, story arc, personal voice) and research (evidence-driven, systematic, academic register).
- No artifact generation. HARD-GATE: the Artifact tool must never be invoked.
- Citations: endnotes per chapter with clickable source URLs, not internal ref anchors.
- Voice: anchor protocol inherited from deep-report (calm technical lecturer default, named anchors available).
- Visual policy: structured layouts only (hierarchy / sequence / matrix / table); scattered mind maps banned.
- Chapter drafting: sequential only (not parallel) — each chapter must know what came before.
- Narrative skeleton: spine, architecture, threads, transitions, concepts must all be built and validated before drafting begins.
- Bible is a living document: grows during drafting as new threads are introduced.
- Prose metrics: inherited from deep-report (Coleman-Liau 9-16, hedge density ≤15/1000, etc.).
- Continuity review: 8 adversarial gates checked by a separate agent with no drafting history.
- Base reference: deep-report v0.2.0 (`../report`).

## Design spec reference
Full design spec at `docs/superpowers/specs/2026-08-19-book-maker-design.md`.
