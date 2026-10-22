# Continuity Gates

Fifteen adversarial quality gates run by a separate reviewer agent with no drafting history. The reviewer reads the full draft plus all bible artifacts and checks each gate. Prose quality gates (10-12) run FIRST — prose quality and structural coherence are orthogonal, and a structurally perfect book can read like a report. One revision pass is allowed on flagged chapters; if gates still fail after revision, emit `NARRATIVE_BROKEN`.

## Gate 10: Prose Density and Paragraph Craft

**What it checks:** Word count, heading density, list presence, em dash frequency, and paragraph-level craft per chapter. These are the measurable symptoms of report-mode prose. The paragraph checks separate "structurally correct" from "editorially alive" — a manuscript can pass every structural gate and still read like a report if every paragraph is 180 words and the page has no white space.

**How to check:** For each chapter, count: total words, number of headings (any level), number of bullet/numbered list items, number of em dashes (—). Then for paragraph-level craft, count: words per paragraph, number of paragraphs under 50 words, number of paragraphs over 150 words, and compute the standard deviation of paragraph word counts.

**Pass — document-level (existing):**
- Word count ≥6,000 per chapter (configurable; default raised from 4,000 to prevent shorthand compression)
- Headings ≤1 per 3,000 words (default to zero headings; a heading is permitted only at genuine topic shifts, not sub-topics). If a heading exists, the section beneath it must be ≥2,000 words.
- Zero bullet or numbered lists in narrative mode (research mode: lists permitted in appendix-style sections only)
- Em dashes ≤3 per 1,000 words

**Pass — paragraph-level (new):**
- No paragraph exceeds 150 words unless it is an unbreakable scene or reasoning chain. More than 5% of paragraphs over 150 words is a fail.
- At least 15% of paragraphs are under 50 words (emphasis beats, pacing relief, transitions). Fewer than 15% means the chapter has no breathing room.
- The standard deviation of paragraph word counts divided by the mean is at least 0.40. Below 0.40 means the paragraphs are too uniform — report-style blocks rather than book-style varied rhythm.
- At least one paragraph of 40 words or fewer per 600 words of chapter text (emphasis beat frequency).
- No run of 3+ consecutive paragraphs within 20 words of each other in length.

**Fail:** Any threshold breached.

**Fail action:** Flag the chapter with the specific metric that failed and its current value. For document-level failures: the drafter must expand thin chapters, consolidate sections behind fewer headings, rewrite lists as prose, replace em dashes. For paragraph-level failures: the drafter must break dense paragraphs at mode shifts, thought turns, or new-entity arrivals; add emphasis beats at moments of revelation, reversal, or transition; vary paragraph length to create visual rhythm.

## Gate 11: Catalogue Detection

**What it checks:** Consecutive entity-introduction paragraphs — sections where the prose devolves into a curated directory of organisations, people, or programmes rather than building an argument.

**How to check:** Scan each section for runs of consecutive paragraphs where each introduces a new named entity (person, organisation, programme, framework) as its primary purpose — opening with the entity name, providing its description and credentials, then moving to the next entity. This is the "guidebook" pattern.

**Pass:** No section has 3+ consecutive paragraphs that each introduce a new named entity without returning to the chapter's argumentative thread between introductions.

**Fail:** Catalogue pattern detected — 3+ entity introductions in sequence without argumentative connective tissue.

**Fail action:** Flag the section with note: "weave entities into argument rather than listing them." The drafter must restructure: make the argument the spine, and introduce entities only as they serve specific claims within that argument.

## Gate 12: Scene-Exposition Ratio

**What it checks:** The balance of concrete/immersive paragraphs (scene) versus analytical/contextual paragraphs (exposition) — the "layer cake" rhythm.

**How to check:** Classify each paragraph in each chapter:
- **Scene:** concrete, immersive, specific. A moment in time, a person in a place, a number attached to a human consequence, an anecdote, a case study with narrative detail.
- **Exposition:** analytical, contextual, abstract. Framework explanation, principle statement, evidence synthesis, analytical commentary, definitions.

Compute the scene percentage per chapter.

**Pass:**
- Narrative mode: 40-60% scene paragraphs per chapter
- Research mode: 25-40% scene paragraphs per chapter
- No chapter exceeds 80% in either direction (all-scene is a memoir; all-exposition is a report)

**Fail:** Ratio outside the target range for the declared book mode.

**Fail action:** Flag the chapter with its current scene-exposition ratio and the target range. The drafter must add scene beats to exposition-heavy chapters (anchor abstractions in concrete moments) or add analytical synthesis to scene-heavy chapters (tell the reader what the scene means).

---

## Gate 1: Thread Completeness (Chekhov's Gate)

**What it checks:** Every thread in `book/threads.jsonl` reaches `status: resolved` by the end of the book.

**How to check:** Scan threads.jsonl. Flag every entry where `status` is `open` or `developed` but never `resolved`.

**Pass:** Zero threads with `status: open` at book end. Every introduced concept, question, anecdote, tension, metaphor, or case study reaches resolution.

**Fail:** One or more threads remain `open`. The reader was promised something that was never delivered.

**Fail action:** Return the list of orphan threads with their introduction chapter/section. The drafter must either resolve each thread in an appropriate chapter or remove the introduction if the thread is not load-bearing.

**Exception:** A thread may remain deliberately unresolved only if the final chapter explicitly names it as an open question. This must be marked `status: "open-deliberate"` in threads.jsonl with a justification string.

## Gate 2: Horizontal Flow

**What it checks:** The sequence of chapter titles and opening sentences forms a coherent, progressive argument. No entry could be reordered without the reader noticing.

**How to check:** Extract from every chapter: (a) the chapter title, (b) the central argument from architecture.json, and (c) the first sentence of the chapter. Read them in sequence. Evaluate whether each entry follows logically from the previous one.

**Pass:** The extracted skeleton reads as a progressive, non-redundant argument. Each entry builds on or responds to the previous.

**Fail:** Any entry could swap positions with its neighbor without breaking the logical flow.

**Fail action:** Flag the specific chapter boundary where flow breaks. The drafter must reorder chapters or rewrite openings to create logical dependency between them.

## Gate 3: Transition Audit

**What it checks:** Every chapter-to-chapter boundary has a working transition — no cold starts, no orphan closes, no logical gaps.

**How to check:** For every adjacent chapter pair, extract the last paragraph of chapter N and the first paragraph of chapter N+1. Evaluate against three criteria:

1. **Logical bridge:** Does the end of N create a question, tension, or expectation that N+1 answers?
2. **No cold start:** Does N+1 assume context that N established? Or does it restart from zero as if it were a separate document?
3. **No orphan close:** Does N end with a resolution so complete that N+1 feels like a separate essay?

**Pass:** Every transition has a bridge.

**Fail:** Cold start, orphan close, or logical gap.

**Fail action:** Flag the chapter pair. Check `book/transitions.json` — the exit_state/entry_assumption pair must match. If the contract is sound but the prose doesn't follow it, the drafter must rewrite the closing and opening paragraphs.

## Gate 4: Concept Ordering

**What it checks:** No concept is referenced before its `first_introduced` chapter in `book/concepts.json`.

**How to check:** For each concept card, verify that every chapter referencing the concept appears at or after the `first_introduced` chapter in the book order.

**Pass:** Every concept is introduced before it is used.

**Fail:** A chapter references a concept that is formally introduced in a later chapter.

**Fail action:** Flag the forward-reference with the concept name, the offending chapter, and the introduction chapter.

## Gate 5: Pacing Envelope

**What it checks:** Chapter lengths, claim density, and structural rhythm follow book-appropriate patterns.

**How to check:** Compute for each chapter: word count, number of verified claims referenced, claims-per-1000-words density.

Three sub-checks:

1. **Sagging middle:** Chapters in the middle third should not all be longer than the average of the outer two thirds.
2. **Length variance:** The standard deviation of chapter word counts must be at least 15% of the mean.
3. **Density gradient:** Claims-per-1000-words density should generally increase toward the book's climax (the 60-75% mark).

**Pass:** No sagging middle, adequate length variance, density rises toward climax.

**Fail:** Sag, uniformity, or flat density.

**Fail action:** Flag the specific pattern.

## Gate 6: Redundancy Detection

**What it checks:** No two sections make the same core claim without the second adding material depth.

**How to check:** For every section, identify its core claim. Compare all core claims pairwise. Flag any pair where the claims are semantically equivalent and the second instance adds no new evidence, angle, or implication.

**Pass:** Every section's core claim is distinct. Additionally, no two paragraphs anywhere in the book share more than 80% word overlap (near-duplicate detection). Near-duplicate paragraphs indicate a drafting error where an agent was interrupted and resumed, producing verbatim repetition.

**Fail:** Two or more sections assert the same claim with no additional value, OR two paragraphs share >80% word overlap.

**Fail action:** Flag the redundant pair with both section IDs. For near-duplicate paragraphs, flag both locations — the drafter must cut one or merge them.

## Gate 7: Entity Consistency

**What it checks:** Every named entity is consistent throughout the book.

**How to check:** Verify: spelling consistency, first-use introduction with context, recurrence (no single-use named entities).

**Pass:** Zero spelling inconsistencies, every entity introduced on first use, no orphan entities.

**Fail:** Spelling drift, bare-name introductions, or orphan entities.

**Fail action:** Flag each violation with the entity name and chapter.

## Gate 8: Arc Completeness

**What it checks:** The book exhibits a complete narrative arc with appropriate momentum.

**How to check:** From `book/grid.json`, plot the polarity charges (`+`, `−`, `0`) across all sections in order.

1. **Setup (first 15-25%):** Establishes the central question.
2. **Investigation (25-60%):** Polarity alternates.
3. **Turn (60-75%):** Strongest challenge or most surprising finding.
4. **Resolution (75-100%):** Threads resolve, polarity trends positive.

**Pass:** The arc has shape. A turn exists. No 5+ consecutive same-polarity sections.

**Fail:** No identifiable turn, flatlined polarity, or resolution introduces major new evidence.

**Fail action:** Flag the specific arc failure.

## Gate 9: Paragraph Flow

**What it checks:** Paragraphs within sections flow through argumentative links, not topical proximity.

**How to check:** Sample 10 random paragraph boundaries across the book (excluding chapter and section boundaries). For each, extract the last sentence of paragraph N and the first sentence of paragraph N+1. Classify:

- **Argumentative** — N+1 builds on, responds to, or extends N's conclusion.
- **Wall** — N+1 shares the same topic but could swap positions with N.

**Pass:** No more than 2 of 10 sampled boundaries are walls.

**Fail:** 3 or more walls. Name each with chapter, section, paragraph numbers, and the missing transitional move.

**Fail action:** Flag each wall transition. The drafter must rewrite to create an argumentative link.

---

## Accumulation Gates

These gates verify that the book builds across chapters rather than producing a collection of excellent but emotionally independent chapters. They check the mechanisms that transform individual chapters into a progressive experience.

### Gate 13: Leitmotif Recurrence

**What it checks:** Every leitmotif declared in `book/spine.json` appears at least 3 times across the book, and its meaning transforms with each recurrence.

**How to check:** For each leitmotif in spine.json, search the chapters for the concrete image or phrase. Verify: (a) at least 3 appearances across different chapters, (b) each appearance occurs in a different emotional context than the previous one, (c) the meaning progression matches the spine's declared meanings.

**Pass:** Every leitmotif recurs 3+ times with transforming meaning.

**Fail:** A leitmotif appears fewer than 3 times, or it recurs without meaningful transformation (same emotional context, same function in the argument).

**Fail action:** Flag the leitmotif with its current appearances and the missing transformation. The drafter must add recurrences or deepen existing ones.

### Gate 14: Callback Harvest

**What it checks:** Every callback seed planted in the discourse briefs is harvested by a later chapter.

**How to check:** From the briefs, collect all callback_seeds. For each, verify that a later chapter's callback_harvests references it and that the harvesting chapter recontextualizes the detail (the reader's accumulated experience gives it new weight).

**Pass:** Every seeded callback is harvested. Every recapitulation_target from spine.json appears in the final chapter in transformed context.

**Fail:** An unharvested callback seed, or a recapitulation target missing from the final chapter.

**Fail action:** Flag the orphaned seed. The drafter must either harvest it in an appropriate later chapter or remove the seed if it is not load-bearing.

### Gate 15: Progressive Stakes

**What it checks:** Emotional weight escalates across the book. No chapter's emotional stakes are lower than the previous chapter's.

**How to check:** Read the weight_trajectory from spine.json. For each chapter boundary, verify that the emotional weight described is genuinely higher-stakes than the previous boundary. "Higher-stakes" means the consequences matter more, the scope is larger, or the personal cost is greater.

**Pass:** Stakes escalate monotonically. The penultimate chapter carries the highest weight. The final chapter resolves with appropriate gravitas.

**Fail:** A chapter boundary where the stakes drop or plateau.

**Fail action:** Flag the specific boundary. The drafter must either raise the stakes in the lower chapter or reorder material so the escalation holds.

---

## Revision protocol

After the first review pass, the reviewer returns a findings report listing every failed gate with specific chapters and sections flagged. The drafter revises only the flagged chapters. The reviewer then runs all 15 gates a second time on the complete draft.

If any gate still fails after the revision pass, emit `NARRATIVE_BROKEN`. Do not attempt a third pass.
