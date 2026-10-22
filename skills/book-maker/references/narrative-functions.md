# Narrative Functions

Every section in the book architecture is tagged with exactly one narrative function. The function describes what the section does to the reader — not what it contains, but what it accomplishes. The Story Grid tracks polarity shifts per section; the narrative function determines the kind of shift.

## The eight functions

### 1. orient

**Definition:** Introduce the reader to a new context, setting, or framework they have not encountered in the book before.

**When to use:** Opening of a new part, first section of a chapter that shifts domain, or any point where the reader needs grounding before the argument can proceed.

**What it does to the reader:** Establishes where they are. Reduces confusion. Creates a stable platform for the sections that follow.

**Non-fiction example:** In *The Undoing Project*, Michael Lewis opens the Kahneman-Tversky collaboration by orienting the reader to 1960s Jerusalem — the physical campus, the intellectual culture, the shared cafeteria where they met.

**Differs from establish:** Orient sets the scene; establish lays down a specific fact or concept. Orient says "here is where we are." Establish says "here is what you need to know."

### 2. establish

**Definition:** Lay down a foundational fact, concept, or definition the reader needs for later argument.

**When to use:** When a term, framework, or factual baseline must be in the reader's working memory before a complication or evidence section can land.

**What it does to the reader:** Gives them a piece to hold. Creates the expectation that this piece will be used.

**Non-fiction example:** In *Thinking, Fast and Slow*, Kahneman establishes the distinction between System 1 and System 2 early — a definition the entire book then builds on.

**Differs from orient:** Establish is specific and named — it puts a concept on the table. Orient is spatial — it puts the reader in a context. A chapter might orient first ("We are now in the world of organic certification auditing") then establish ("An organic audit inspects five items, none of which concern people").

### 3. complicate

**Definition:** Introduce a tension, contradiction, counterargument, or unexpected finding that disrupts what the reader currently believes.

**When to use:** After an establish or evidence section has set a baseline. The complication creates the energy that drives the reader forward.

**What it does to the reader:** Creates cognitive dissonance. Raises stakes. Makes the reader want the resolution that a later section will provide.

**Non-fiction example:** In *Bad Blood*, John Carreyrou establishes that Theranos claimed to run hundreds of tests from a single drop of blood — then complicates with the revelation that the machines could not reliably run even one.

**Differs from evidence:** Evidence supports or challenges a claim with data. Complicate introduces a structural tension — a paradox, a contradiction, a gap between promise and reality. Evidence is a fact; complicate is a problem.

### 4. evidence

**Definition:** Present specific data, case studies, citations, or documented findings that support or challenge a claim made elsewhere in the chapter.

**When to use:** After establishing a claim or introducing a complication, when the reader needs proof.

**What it does to the reader:** Builds credibility. Converts assertion into demonstrated fact. The reader's confidence in the argument rises or falls based on the quality of evidence presented.

**Non-fiction example:** In *The Certification Paradox*, after establishing that organic regulations omit labour provisions, the evidence section walks through the exact text of regulations in the EU, US, Japan, India, and China — quoting word counts and specific clause numbers.

**Differs from establish:** Establish introduces a concept; evidence proves a claim about that concept. Establish says "here is the framework." Evidence says "here is why the framework is true (or false)."

### 5. synthesize

**Definition:** Draw together threads from multiple earlier sections into a unified insight that is greater than the sum of its parts.

**When to use:** At the end of a chapter or part, or at any point where the argument needs to consolidate before advancing. Never before the threads being synthesized have been individually established.

**What it does to the reader:** Crystallizes understanding. Transforms a collection of facts into a coherent picture. The reader's mental model clicks into place.

**Non-fiction example:** In *Sapiens*, Harari synthesizes the cognitive revolution, agricultural revolution, and scientific revolution into a single argument about the power of shared fictions — drawing together threads developed across separate chapters.

**Differs from resolve:** Synthesize merges; resolve closes. A synthesis can leave the door open for further complication. A resolution is final within its scope.

### 6. pivot

**Definition:** Shift the reader's attention from one dimension of the topic to another without resolving the current thread.

**When to use:** When the argument needs to change angle — from historical to quantitative, from macro to micro, from one case study to another. The pivot acknowledges the shift explicitly.

**What it does to the reader:** Reorients without disorienting. The reader understands they are looking at the same subject from a new angle.

**Non-fiction example:** In *The Consultant's Forge*, the chapter on slides pivots from the structural anatomy of a single slide (vertical flow) to the narrative structure of a full deck (horizontal flow) — same subject, different altitude.

**Differs from bridge:** Pivot stays within a chapter, shifting angle. Bridge moves between chapters, closing one arc and opening the next.

### 7. resolve

**Definition:** Close an open question, thread, or tension with a conclusion. The reader should feel that a promise made earlier has been fulfilled.

**When to use:** When a thread introduced in an earlier section (or chapter) has accumulated enough evidence and complication to support a definitive statement.

**What it does to the reader:** Satisfies the narrative debt created by the complication or question. The reader exhales.

**Non-fiction example:** In *The Certification Paradox*, after chapters documenting the gap between organic certification and worker welfare, the synthesis chapter resolves: "The effect is real but paradoxical — running simultaneously in opposite directions through mechanisms the certification system neither intended nor, in its current design, is capable of measuring."

**Differs from synthesize:** Resolve delivers a verdict. Synthesize delivers a picture. A resolve says "the answer is X." A synthesis says "when you put A, B, and C together, you see this."

### 8. bridge

**Definition:** Transition between chapters — close the current arc and open the next. The closing sentence of the current chapter and the opening sentence of the next chapter form a matched pair.

**When to use:** The final section of every chapter (except the last). The bridge is structural — it ensures the reader never hits a wall between chapters.

**What it does to the reader:** Creates pull. The reader finishes one chapter already curious about the next. Without bridges, chapters feel like separate essays bound together.

**Non-fiction example:** In *The Consultant's Forge*, Chapter 1 ends with "This is the first insight of the hidden craft: that consulting is, at its core, an engineering discipline applied to human communication." Chapter 2 opens with "In the autumn of 1963, a twenty-four-year-old woman walked into McKinsey..." — the bridge is the implicit question: "Who engineered that discipline?"

**Differs from pivot:** Bridge crosses chapters; pivot stays within one. Bridge closes and opens; pivot only shifts.

## Polarity shifts

Every section produces a polarity shift in the reader's understanding:

- `+` → the reader's confidence in the thesis rises (establish, evidence supporting, resolve confirming)
- `−` → the reader's confidence is challenged (complicate, evidence contradicting)
- `0` → neutral movement (orient, bridge)

The Story Grid (`book/grid.json`) tracks these per section. A healthy chapter alternates polarities. Three consecutive same-polarity sections signal monotone.

## Distribution rules

- Every chapter must contain at least one `complicate` or `pivot` section. A chapter with only `establish` and `evidence` is a report section, not a book chapter.
- No chapter opens with `resolve` — the reader needs setup before closure.
- No chapter ends without a `bridge` (except the final chapter, which ends with `resolve`).
- `synthesize` never appears before the threads it synthesizes have been individually developed.
