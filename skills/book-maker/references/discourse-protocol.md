# Discourse Protocol

Read this before producing any discourse plan. These fourteen principles are the mechanical rules behind narrative flow and storytelling craft. They are not suggestions — they are load-bearing structures. A chapter that violates them reads like a report no matter how good the content.

## The Central Rule: Earn Before You Name

Every concept, claim, and conclusion in the book must be EARNED through the reader's experience before it is stated as a fact. The reader should arrive at the insight a half-step before the text names it. This is what separates storytelling from reporting: reporting delivers conclusions; storytelling creates the conditions for the reader to reach them.

**Why it matters:** When the text names a concept before the reader has the intuition to receive it, the concept arrives as a deposit — information placed in the reader's account. When the text builds the intuition first and names the concept at the moment of recognition, the concept arrives as a discovery — something the reader feels they figured out. Deposits are forgotten. Discoveries are remembered.

**The test:** For every concept introduction, ask: "Has the reader encountered enough concrete material to almost name this themselves?" If yes, name it now. If no, defer the naming and add more concrete material.

This rule governs all fourteen principles below. The known-new contract is how you earn at the sentence level. The Feynman move is how you earn at the concept level. The payoff principle is how you earn across the arc of the book.

## 1. The Known-New Contract

**Definition:** Every paragraph opens with what the reader already knows and ends with what is new. The new thing becomes the known thing for the next paragraph. This creates a chain that pulls the reader forward without effort.

**Why it works:** The reader's brain anchors on familiar ground before processing new information. When a paragraph opens with something unfamiliar, the reader stalls — even if the content is correct, the experience is jarring. Flow is not a vibe. It is the known-new chain operating at every scale: sentences, paragraphs, sections, chapters.

**Before (broken chain):**
> Organic certification operates through a tripartite system. The Codex Alimentarius was adopted in 1999. IFOAM published its first Basic Standards in 1980.

Each sentence introduces a new entity cold. The reader cannot connect them.

**After (continuous chain):**
> Organic certification operates through a tripartite system of standard-setter, certification body, and accreditation body. The standard-setters themselves sit in a hierarchy. At the top, the Codex Alimentarius — adopted in 1999 — provides the intergovernmental baseline. Below it, IFOAM's Basic Standards, first published in 1980, supply the movement's own benchmark.

Each sentence opens with what the previous sentence established and closes with something new.

**How the briefer encodes it:** Every beat has a `known` field (what the reader carries in) and a `new` field (what the reader takes out). The chain must be continuous — each beat's `known` connects to the previous beat's `new`.

## 2. Value Shift Per Chapter

**Definition:** The reader enters the chapter believing A and exits believing B. Name the value at stake: ignorance to understanding, confidence to doubt, simplicity to complexity, complacency to urgency. A chapter where the reader enters and exits with the same belief is dead weight.

**Why it works:** The value shift is the chapter's reason to exist. Without it, the chapter is a container for information rather than a vehicle for transformation. The reader remembers the shift, not the facts.

**Before (no shift):**
> Chapter 3 covers the agricultural workforce, including statistics on employment, regional variation, and the distinction between farmers and workers.

The reader enters knowing nothing about agricultural workers and exits knowing facts about them. But their belief has not changed.

**After (genuine shift):**
> Chapter 3: The reader enters believing "agricultural workers" are a small, definable group. They exit understanding that one billion people work in agriculture, that the distinction between farmer and worker is the fault line of the entire debate, and that the organic sector is expanding into a workforce already under demographic and economic pressure.

The reader's mental model is reorganised.

**How the briefer encodes it:** The `value_shift` object names `before` and `after` as beliefs, not topics. If `before` and `after` could describe the same mental state, the shift is not genuine — rewrite.

## 3. The Layer Cake

**Definition:** Alternate between scene (concrete, immersive, sensory, specific) and exposition (abstract, analytical, contextual, general). Scenes slow down time and immerse the reader. Exposition accelerates and contextualises. The alternation creates rhythm.

**Why it works:** Three consecutive paragraphs of exposition and the reader's attention drifts — the prose becomes a textbook. Three consecutive paragraphs of scene and the reader loses the analytical thread — the prose becomes anecdote. The layer cake gives the reader both: the concrete moment that makes them care and the analysis that makes them understand.

**Before (all exposition):**
> The organic sector grew 12% in 2024. Global retail sales reached 145 billion euros. The EU committed to converting 25% of agricultural land by 2030. Switzerland holds the world's highest per-capita expenditure.

Four facts in a row. The reader processes none of them.

**After (layer cake):**
> Picture a consumer in Zurich reaching for a carton of strawberries. She pauses at the organic label and pays thirty per cent more — 468 Swiss francs per person per year, the highest organic spending on earth. [SCENE] That premium funds a sector that grew 12% in 2024 and now spans 183 countries. The EU has committed to converting a quarter of its farmland to organic management by 2030. [EXPOSITION] But stand in the strawberry field and the growth looks different. The person picking that carton earns no premium. [SCENE]

Scene grounds the data. Exposition gives it scale. Scene returns to the human.

**How the briefer encodes it:** Every beat is tagged `scene` or `exposition`. No two adjacent beats can both be `exposition`. Target ratios: 40-60% scene in narrative mode, 25-40% in research mode.

## 4. The Nut Graf

**Definition:** Within paragraphs 2-6, one paragraph names the chapter's question and its urgency. The scene hook comes first (paragraph 1), then the stake. Without the nut graf, the reader has a vivid opening but no reason to keep reading.

**Why it works:** The nut graf is the contract between writer and reader. It says: "Here is what this chapter is about, and here is why you should care." A chapter without it is a mystery without a detective — atmospheric but directionless. The nut graf converts curiosity (from the hook) into commitment (to the chapter's question).

**Before (no nut graf):**
> [Scene opening about a farm inspection] ... The inspector reviewed the records. She checked the buffer zones. She examined the chemical shed. She interviewed the farm manager. Then she left.

The scene is vivid but the reader does not know what question it raises or why it matters.

**After (nut graf in paragraph 3):**
> [Same scene opening] ... Then she left. At no point did the inspector speak to a worker, ask about wages, or verify the existence of a contract. This chapter asks a single question: when a certification system designed to verify soil, inputs, and traceability encounters the people who do the work, what does it see? The answer, documented across every major jurisdiction, is: nothing.

Paragraph 3 names the question (what does the system see?) and the urgency (the answer is nothing — everywhere).

**How the briefer encodes it:** The `nut_graf` object specifies `paragraph_position` (2-6), `question` (the chapter's driving question), and `urgency` (why it matters now).

## 5. Scene-Sequel

**Definition:** Every beat either drives toward a complication (scene: claim, counter-evidence, provisional conclusion raising a harder question) or reacts to one (sequel: reaction, dilemma, decision propelling the argument forward).

**Why it works:** The scene-sequel pattern prevents the "list of facts" failure mode. A scene without a sequel is a cliffhanger with no resolution. A sequel without a scene is analysis without grounding. Together, they create the push-pull rhythm that makes arguments feel inevitable rather than asserted.

**Before (list of facts):**
> Regulation A contains no labour clause. Regulation B contains no labour clause. Regulation C mentions workers once, in a footnote.

Three facts. No scene, no sequel.

**After (scene-sequel):**
> [SCENE] Search the complete text of the EU's organic regulation — 2018/848, the instrument governing organic production across 27 member states — for the word "labour." It appears zero times. Search for "worker." Three results, each referring to animal welfare. [COMPLICATION] This is not one country's oversight. [SEQUEL] The question this forces is uncomfortable: did the drafters not think of workers, or did they think of them and decide they were out of scope?

The scene presents the evidence. The complication raises the stakes. The sequel forces a dilemma.

**How the briefer encodes it:** Each beat's `purpose` field names whether it drives toward complication or reacts to one. The beats alternate between forward-driving (scene) and reflective (sequel) energy.

## 6. Show, Then Tell, Then So What

**Definition:** Concrete example first (show). Then the analytical point it illustrates (tell). Then why it matters to the reader or the book's thesis (so what). This is the micro-rhythm of good non-fiction.

**Why it works:** Show alone is anecdote. Tell alone is lecture. So-what alone is assertion. The three-beat sequence earns the reader's trust: the show makes them see, the tell makes them understand, the so-what makes them care. Every section of three or more paragraphs should contain at least one such sequence.

**Before (tell only):**
> The certification system is structurally incapable of observing labour conditions. Audits are announced, last hours, and are conducted in the company of management.

Correct, but asserted. The reader has no reason to believe it beyond the writer's authority.

**After (show → tell → so what):**
> [SHOW] Imagine you are a field worker on a certified organic farm on the day of the annual inspection. You are weeding a strawberry row by hand. In the farm office, an inspector is reviewing input purchase receipts. She will walk the fields. She will check the chemical shed. She will interview the farm manager. At no point will she ask you what you are paid. [TELL] The regulation mandates one interview — with "an authorized representative of the inspected operation." The designated representative is management. [SO WHAT] You are standing in the field that the inspector came to verify, and you are not part of the verification.

The reader sees it (show), understands the mechanism (tell), and feels the consequence (so what).

**How the briefer encodes it:** Beats that carry a `show_tell_sowhat` object have all three fields filled. At least one per chapter.

## 7. Negative Constraints Over Positive Aspirations

**Definition:** "No em dashes" works. "Write flowing prose" does not. Ban the bad patterns; the good ones emerge. Specify what NOT to do, not what to do.

**Why it works:** Positive instructions ("write with narrative flow", "use vivid language", "create momentum") are interpreted at the lowest-energy level — the agent produces technically compliant text that satisfies the instruction without embodying the spirit. Negative constraints ("no em dashes", "no bullet lists", "no throat-clearing") close off the low-energy paths and force the agent toward the harder, better alternatives.

**Before (positive instruction):**
> "Write flowing narrative prose with vivid descriptions and strong transitions."

Result: em dashes connecting clauses, bullet points reformatted as numbered lists, "Consider this:" before every reflection.

**After (negative constraint):**
> "No em dashes. No bullet lists. No blockquote callouts. No sentences beginning with 'Consider this:', 'It's worth noting', or 'Interestingly.'"

Result: the agent must use periods, semicolons, and sentence restructuring. The removal of crutches forces genuine prose.

**How the briefer encodes it:** The `chapter_bans` array lists chapter-specific negative constraints. Global bans live in `references/style-rules.md`. The drafter reads both before writing.

## 8. The Payoff Principle

**Definition:** Every concept, analogy, or question introduced early in the book must pay off later — not by being mentioned again, but by being TRANSFORMED by what the reader has learned since it was introduced. A payoff is not a callback; it is a callback that has changed meaning.

**Why it works:** The reader carries introduced concepts as open questions. When a concept returns unchanged ("remember the thermometer"), the reader thinks "yes, I remember" — and nothing happens. When a concept returns transformed ("the thermometer is now measuring something you did not know existed when you first encountered it"), the reader's understanding shifts. The distance between introduction and payoff creates weight: a concept introduced in chapter 2 and resolved in chapter 12 carries more emotional and intellectual force than one introduced and resolved within the same chapter, because the reader has accumulated new knowledge that changes the concept's meaning.

**Before (callback without transformation):**
> Chapter 2 introduces "the thermometer problem" — measuring the wrong thing. Chapter 9 says: "Recall the thermometer problem from Chapter 2. The same issue appears here."

The reader recognises the reference but gains nothing. The concept is unchanged.

**After (callback with transformation):**
> Chapter 2 introduces the thermometer problem: you build a thermometer to know if it is light outside. It measures temperature perfectly. It tells you nothing about light. Chapter 9 returns to the thermometer — but now the reader has spent seven chapters learning that the research pipeline's own instruments (loss curves, benchmark accuracy, convergence metrics) are thermometers. The payoff is not "remember the thermometer." The payoff is: "You have been reading about thermometers for 200 pages. Every metric you trusted was measuring temperature."

The concept has not been referenced. It has been revealed.

**How the briefer encodes it:** Every thread in `threads.jsonl` with status `resolved` must include a `transformation` field naming how the resolution changes the original introduction's meaning, not merely revisits it. Plan at least 3 long-arc payoffs (5+ chapters between introduction and resolution). The final chapter should contain the deepest payoff — the concept from chapter 1 reframed by everything the reader has learned.

## 9. Framing as Argument

**Definition:** The frame through which a concept is introduced determines how the reader processes everything that follows. A frame is not a metaphor — it is a lens that makes some conclusions feel inevitable and others feel absurd. The frame IS the argument.

**Why it works:** Facts do not speak for themselves. They speak through the frame placed around them. Introducing neural architecture search as "a search problem" invites efficiency thinking: how to search faster, how to reduce compute, how to optimise the process. Introducing it as "a map problem" invites structural thinking: what if the map is wrong? What if faster searching through a flawed map produces faster wrong answers? The same body of evidence, framed differently, produces different conclusions. The writer who controls the frame controls the argument.

**Before (neutral framing):**
> Neural Architecture Search (NAS) automates the design of neural network architectures. Research has focused on reducing the computational cost of the search process.

The frame is "efficiency." The reader now evaluates everything that follows through the lens of "is this faster?"

**After (argumentative framing):**
> Every architecture search begins with a space — a set of allowable components, wiring patterns, and constraints that define what the search can find. A decade of research has made the search faster. Nobody asked whether the space contains the right answer.

The frame is "the map, not the compass." The reader now evaluates everything through the lens of "is this looking in the right place?" The same evidence, different conclusion.

**How the briefer encodes it:** The discourse brief names the chapter's `frame` explicitly: what lens does this chapter give the reader? What does that lens make visible? What does it hide — and which later chapter will reveal what this frame concealed? When a later chapter challenges an earlier chapter's frame, that challenge IS the value shift. The reader does not just learn new information; they learn to see differently.

## 10. Tension Architecture

**Definition:** A book maintains the reader's attention through unresolved tension at multiple timescales simultaneously. Four levels operate in parallel:

- **Paragraph tension:** each paragraph ends with something unresolved that the next paragraph addresses (the known-new contract's forward pull).
- **Section tension:** each section opens a complication and reaches only a provisional resolution that raises a deeper question (the scene-sequel pattern).
- **Chapter tension:** each chapter's closing creates pull toward the next chapter (the transition contract's bridge paragraph).
- **Book tension:** the central question posed in chapter 1 remains genuinely unresolved until the final chapters.

**Why it works:** Most AI-generated prose resolves tension too quickly. Every paragraph answers its own question. Every section wraps up neatly. Every chapter reaches a satisfying conclusion. The result is a book where the reader can stop anywhere and feel finished — which means they stop. The Rigorous Storyteller holds tension: lets the reader sit with uncertainty, delays the resolution until the reader has earned the understanding to appreciate it.

**Before (tension resolved too quickly):**
> The organic standard contains no labour clause. This means workers are unprotected. The system should be reformed.

Three sentences: question, answer, recommendation. The reader has no reason to turn the page.

**After (tension held across scales):**
> The organic standard contains no labour clause. [PARAGRAPH TENSION: why not?] The absence is not an oversight — it is an architectural feature, documented across every major jurisdiction. [SECTION TENSION: if it is deliberate, who decided?] That question leads to three transfer points where the movement's social chapter was written, submitted, and rejected. [CHAPTER TENSION: even if we know who decided, do workers notice?] The next chapter walks into a field on inspection day. [BOOK TENSION: and behind all of this sits a deeper question the certification system was never designed to answer.]

Four levels of unresolved tension operating simultaneously.

**How the briefer encodes it:** No chapter's driving question should be fully resolved within the chapter. The `closing_pull` must defer a piece of the resolution. The narrative briefer tracks open thread count: at least 2 threads should be open at any point in the book. A book with all threads resolved except the current chapter's reads like a curriculum, not a journey.

## 11. The Feynman Move: Intuition Before Formalism

**Definition:** Always build the reader's intuition BEFORE introducing the formal concept. The reader should feel like they almost understand it before you name it. The sequence is:

1. Present a concrete situation the reader can picture.
2. Point out the pattern the reader can see.
3. Name the pattern (the formal concept).
4. Show how the formal concept predicts something the intuition alone would miss.

This is the opposite of the lecture pattern (define, explain, example). The Feynman move earns the concept; the lecture pattern deposits it.

**Why it works:** When a formal concept arrives as a label ("This is called the convolution theorem"), the reader files it away. When the same concept arrives as a recognition ("Oh — that is why the frequencies multiply instead of add"), the reader owns it. The Feynman move exploits the brain's pattern-recognition machinery: present the instances, let the pattern emerge, then name it at the moment of recognition. The name sticks because it labels something the reader already feels.

**Before (lecture pattern — define, then illustrate):**
> The convolution theorem states that convolution in the spatial domain is equivalent to pointwise multiplication in the frequency domain. For example, consider modular addition. Adding two numbers modulo p can be computed by taking the Discrete Fourier Transform of both, multiplying pointwise, and inverting.

Correct. Forgettable. The definition arrives before the reader has any reason to care.

**After (Feynman move — intuition, then naming):**
> Take two numbers and add them modulo 7. Now take the same two numbers, convert each to a pattern of seven frequencies — a kind of fingerprint — and multiply the fingerprints together, frequency by frequency. Convert back. You get the same answer. [SITUATION + PATTERN] This is not a coincidence. It is the convolution theorem: any operation that looks like combination in one domain looks like element-wise scaling in the dual domain. [NAME] And the 160-parameter network did not learn this theorem from a textbook. It learned it from data — then enacted it as its own architecture. [SURPRISE]

The concept arrives at the moment the reader is ready to name it themselves.

**How the briefer encodes it:** The known-new chain should build toward each concept's naming moment. The `known` entries represent the intuition being built; the `new` entry at the naming moment should feel like recognition, not introduction. If a concept is named before the reader has encountered enough concrete material to almost name it themselves, the naming is premature. Defer it.

## 12. Scene Design for Non-Fiction

**Definition:** A "scene" in non-fiction is not a vivid description — it is a moment designed to make the reader FEEL something that the analytical exposition which follows will make sense of. The scene creates the emotional receptivity for the argument.

**Why it works:** Exposition lands differently after a scene. "The certification system does not interview workers" is an assertion. "You are standing in a strawberry field while an inspector walks past you without a word" is an experience. The reader who has stood in that field processes the exposition differently — not as information, but as explanation for something they felt. The scene makes the reader a witness; the exposition tells the witness what they saw.

**Components of an effective non-fiction scene:**
- **Specificity:** real place, real time, real stakes. "A data center floor at Google Brain in 2016. Eight hundred GPUs. Twenty-eight days." Not "a research lab somewhere."
- **Sensory anchor:** one detail the reader can see, hear, or feel. The hum of the fans. The cursor blinking on a terminal. The weight of the strawberry carton.
- **Tension:** something is about to go wrong, or something surprising is about to be revealed. The reader should feel that the scene is headed somewhere before knowing where.
- **Incompleteness:** the scene raises a question it does not answer. The exposition that follows provides the answer. A scene that resolves its own question is an anecdote, not a setup.

**Scenes are NOT:**
- Generic illustrations ("Imagine a researcher working on a problem...") — these are thought experiments, not scenes. They have no specificity, no sensory anchor, no stakes.
- Decorated exposition ("The lab was quiet. The data was troubling.") — adjectives do not make a scene. A scene is a moment with a trajectory, not a description with atmosphere.
- Historical summaries ("In 2019, researchers at DeepMind published a paper...") — this is narrated history, not scene. A scene puts the reader in the room; a summary reports what happened in the room.

**Before (generic illustration):**
> Imagine a researcher who has trained a model and achieved high accuracy. They might feel confident. But what if the accuracy was misleading?

The reader imagines nothing specific. The "researcher" is a placeholder. The scene does no work.

**After (specific scene):**
> The terminal shows 99.2% validation accuracy. Three runs, three confirmations. The architecture is small — 160 parameters, less than a logistic regression on a decent feature set — and it is solving modular arithmetic with nine different primes simultaneously. You close the laptop and walk to the kitchen to make coffee. The result looks clean. It will take four more days and a different experiment to discover that the accuracy is real but the architecture is doing something nobody intended.

Specific. Sensory (the terminal, the laptop, the kitchen). Tense (something is wrong that the protagonist does not yet know). Incomplete (what did nobody intend?). The reader is pulled forward.

**How the briefer encodes it:** Every scene beat in the discourse brief specifies WHERE (specific location or moment), WHAT (specific event or observation), and WHY (what question it raises for the reader). The layer-cake rhythm requires scene beats to do WORK — a scene that does not raise a question or change the reader's understanding is decoration, not structure.

## 13. Paragraph as Unit of Thought

**Definition:** Every paragraph makes one argumentative move — and only one. The break between paragraphs is not a formatting decision. It is punctuation. It signals a shift in thought, mode, or register, and it gives the reader a moment of comprehension before the next move begins.

**Why it works:** When a publisher sends a non-fiction manuscript back for revision, "break up" is among the most common notes. It means the paragraph is doing too much: two claims where one should live, a scene bleeding into its analysis, evidence stacked without synthesis between entries. The white space between paragraphs is where the reader absorbs what they just read. Without it, ideas arrive faster than the reader can process them. A manuscript whose every paragraph is 180 words may be structurally sound but editorially dead — the reader sees a wall of text and skims rather than reads.

**The line editor's test:** Can you state what this paragraph's ONE move is in a single clause? "It introduces X." "It shows what goes wrong." "It names the consequence." If the answer is a compound sentence — "It introduces X and then shows its consequence" — break at the "and then."

**The craft distinction this principle encodes:**

A competent paragraph covers a topic adequately. A publishable paragraph makes one move and lands it. The difference:
- Competent: each paragraph advances the argument. Transitions exist. Grammar is correct.
- Publishable: each paragraph earns its length. The break carries meaning. Short paragraphs create emphasis through isolation. The reader feels pulled forward by the white space itself.

**Five break triggers:**

1. **Mode shift.** The prose crosses from scene to exposition or vice versa. Break at the boundary.
2. **Turn of thought.** The argument pivots — from evidence to implication, claim to consequence, problem to solution. Each side of the turn gets its own paragraph.
3. **New entity.** A new named concept, person, or data point enters as the main subject. Give the reader a fresh paragraph to register the arrival.
4. **Cognitive checkpoint.** After a chain of 3+ linked logical steps, break and let the reader absorb before continuing.
5. **Visual monotony.** Three consecutive paragraphs of similar length create scanning fatigue. Break the pattern with a short paragraph.

**Emphasis paragraphs:** A single-sentence paragraph marks a moment of revelation, reversal, or transition. It is the non-fiction writer's boldface. Deploy 3-5 per chapter. Never use one because you ran out of things to say.

**Before (one paragraph, two moves):**
> Error correction follows the same pattern, and its deployment is even older. The Voyager 2 spacecraft, launched in 1977, transmitted images of Jupiter, Saturn, Uranus, and Neptune back to Earth using Reed-Solomon error-correcting codes. The signals traveled billions of kilometers, degraded by noise, and the ground stations reconstructed the original data by solving systems of equations over a finite field. Reed-Solomon codes entered consumer products with the compact disc in 1982, and they have since been adopted in DVDs, Blu-ray discs, QR codes, satellite broadcasting, digital television, and RAID 6 storage systems.

**After (two paragraphs, one move each):**
> Error correction follows the same pattern, and its deployment is even older.
>
> The Voyager 2 spacecraft, launched in 1977, transmitted images of Jupiter, Saturn, Uranus, and Neptune back to Earth using Reed-Solomon error-correcting codes. The signals traveled billions of kilometers, degraded by noise, and the ground stations reconstructed the original data by solving systems of equations over a finite field. Reed-Solomon codes entered consumer products with the compact disc in 1982, and they have since been adopted in DVDs, Blu-ray discs, QR codes, satellite broadcasting, and RAID 6 storage systems.

The first paragraph makes one move: it names the pattern and asserts its age. The second paragraph develops the claim with evidence. The break is the reader's moment to register the setup before the evidence arrives.

**How the briefer encodes it:** The briefer does not specify paragraph breaks — the drafter decides structure. But when a beat contains inherently dense content (multi-step reasoning, technical mechanisms, evidence surveys), the briefer flags it with `paragraph_density: "high"` to signal the drafter that extra break triggers apply. The drafter then applies the five break triggers with particular discipline in those beats.

## 14. Structural Asymmetry

**Definition:** Not every section follows the same internal pattern. A machine distributes attention evenly: three points get equal development, each section follows claim-evidence-implication, each chapter has the same shape. A human dwells unevenly: the point that surprised them gets more space, the point that resolves cleanly gets compressed, the point that remains open gets lingered upon. The distribution of attention IS the narrator's voice.

**Why it works:** Structural symmetry is among the strongest AI detection signals in long-form writing. When every section follows the same template, the reader feels the template before they feel the argument. When the sections vary — one is all evidence with no conclusion, one is a single provocative question, one is a digression that earns its place, one compresses three points into a paragraph and then spends two pages on the one that matters — the reader feels a mind at work, deciding what deserves attention.

**The five asymmetry moves:**

1. **Dwell.** One section gets significantly more development than its neighbors because the narrator found it genuinely interesting or difficult. The extra length is not padding — it is the narrator's attention, which the reader reads as care.
2. **Compress.** A point that resolves cleanly gets one paragraph, not three. The brevity signals confidence. The reader trusts that the narrator knows which parts are settled.
3. **Digress.** One section per chapter departs from the main argument into a related observation, a historical parallel, or a personal aside. The digression earns its place by returning to the argument with something the straight path could not have reached.
4. **Leave open.** Not every section closes. One section per chapter ends with a question rather than a resolution. The open question creates pull into the next section.
5. **Vary the template.** If sections 1-3 follow show-tell-so-what, section 4 follows a different internal structure: pure evidence, a single extended scene, or a question answered by another question.

**How the briefer encodes it:** The briefer assigns different `chapter_form` values and ensures that no two adjacent sections in a chapter's beat plan follow the same internal pattern. Synthesis chapters (final-part chapters) are flagged to spend more words on open questions and less on resolved points.
