# Style Rules

Mandatory constraints derived from a 14-chapter developmental edit. Organized into three categories: voice bans (patterns that break the Rigorous Storyteller voice), structure bans (patterns that create report-like document architecture), and rhythm rules (positive requirements for prose cadence). Every ban is absolute. Violations are revisions, not judgement calls.

## Voice Bans

**1. No em dashes.** Use periods, semicolons, or restructure the sentence. Em dashes are the single strongest signal of AI-generated text: LLMs use them at 3.3 times the human baseline rate. Every em dash is a missed opportunity to write a cleaner sentence.

**2. No throat-clearing.** Never open a sentence or paragraph with: "It is important to note that", "It should be mentioned that", "Interestingly,", "It is worth noting", "As previously discussed", "In this chapter, we will", "Let us now turn to", "Consider this:", "Think about it this way:", "To understand X, we must first", "It is important to understand", "Before we proceed". Cut straight to the claim.

**3. No self-narration.** Never comment on your own material's quality, elegance, or importance: "The elegance is worth noting", "It is worth pausing to appreciate how insidious this is", "The pattern is striking", "This is a crucial point", "This result is remarkable". Show the material. The reader will feel its weight without being told to feel it.

**4. No narrating the reader's reaction.** Never prescribe what the reader should feel: "You might be surprised to learn", "This should be concerning", "The implications are profound", "This is counterintuitive". Trust the evidence to create the reaction. If the evidence does not create it, narrating it will not either. **Scope:** this bans prescribing the READER's reaction. It does NOT ban the narrator's own reaction. "That number stopped me" is narrator reaction — permitted and encouraged. "You might be surprised by that number" is reader-reaction narration — banned. The narrator has a relationship to the material. Show it.

**5. No label-before-reveal.** Never name a concept abstractly before showing it concretely. The concrete example comes FIRST. The principle it illustrates comes SECOND. "This is called X" arrives AFTER the reader has experienced X, never before. Wrong: "Representational change theory proposes that insight occurs when... For example, consider the matchstick puzzle." Right: "Picture a table in a psychology lab. On it, a row of matchsticks forms an equation: VI = VII + I. [scene plays out]... Ohlsson called this representational change."

**6. No academic citation ceremony.** Never structure a sentence around a citation: "Smith et al. (2024) demonstrated that...", "According to a 2023 study by...", "Research by Johnson and colleagues found...". Enter through the idea, not the citation. The author and year belong in the endnote, not the sentence. Wrong: "Pham et al. (2018) introduced parameter sharing between candidate architectures." Right: "Within two years, the cost dropped by a thousand-fold. The trick was parameter sharing."

**7. No documentation voice.** Never describe a technical mechanism as a specification of what it does. Always show what goes wrong without it FIRST, then introduce the mechanism as the solution to that failure. Wrong: "The null-baseline gate runs three null comparisons on pre-registered metrics. Each comparison is designed to catch a specific form of spurious success." Right: "The simplest way to build a model that looks impressive and learns nothing is to memorise the training distribution. Feed it shuffled labels and watch what happens. If the accuracy barely changes, your model was never learning the relationship you thought it was."

## Structure Bans

**8. No bullet lists in prose chapters.** If information needs a list, it needs a table in an appendix or it needs to be woven into narrative sentences. Bullets break the reading flow and signal "I could not find the argument connecting these points."

**9. No blockquote callouts.** They interrupt the page and announce "this does not fit the flow." If the content matters, integrate it. If it does not, cut it.

**10. Headings are earned, not automatic.** Default to ZERO headings per chapter. The prose should flow as continuous narrative without structural interruption. A heading is permitted only when the chapter genuinely shifts topic (not sub-topic) AND the shift cannot be achieved through a transitional paragraph. Maximum 1 heading per 3,000 words. If a chapter has 3 headings, it is three sections stitched together, not a chapter. If a heading exists, the section beneath it must be at least 2,000 words — a heading over 800 words of prose is a report section, not a book chapter.

**11. No numbered action items mid-chapter.** Actionable takeaways belong in a dedicated final chapter or appendix. Mid-chapter numbered lists break the narrative register.

**12. No dissertation roadmap paragraphs.** Never preview the chapter's argument structure: "This chapter establishes...", "The argument rests on three rounds of evidence...", "This section will discuss three mechanisms...". Let the argument announce itself through its progression. If the reader needs a roadmap, the argument is not clear enough to follow on its own.

**13. No catalogue mode.** Never introduce more than two named systems, frameworks, or entities consecutively using the same paragraph template (name, date, metric, contribution). Pick one to embody the principle as a scene. Reference the others in a single sentence that names the pattern they share. Wrong: "ENAS introduced parameter sharing... AmoebaNet used evolutionary methods... DARTS employed differentiable relaxation..." Right: "Within two years, three lines of work dropped the cost by a thousand-fold. Each attacked the expense. None touched the space." Then zoom into one as the scene.

**14. No parallel enumeration.** Never describe three mechanisms, conditions, or components with the same grammatical structure: "The first is... The second is... The third is..." or "The X comparison asks whether... The Y comparison asks whether... The Z comparison asks whether...". Vary the framing: present one as a scene, one as a question, one as a consequence.

**15. No thesis restating.** State the chapter's key insight once in the closing section with force. Never restate it with slight variation across multiple paragraphs. If the conclusion needs three paragraphs to summarize, the chapter is unfocused. One paragraph. One statement. Move to the implication.

**16. No summary-after-section.** Never follow an evidence block with a paragraph that restates what the evidence just showed. Move to the next implication. Trust the reader to track the argument. Wrong: "As the examples above demonstrate, the search space constrains what can be found." Right: [cut the summary paragraph; begin the next section's opening scene].

**17. No near-verbatim repetition.** Never restate the same list of items, key phrase, or argument in consecutive paragraphs, even for emphasis. If a phrase appeared in paragraph N, it does not appear in paragraph N+1. Emphasis through repetition is the AI winding-down pattern. Emphasis through precision is the author's tool.

## Rhythm Rules

**18. Sentence length must vary.** No 3+ consecutive sentences within 5 words of each other in length. A short sentence after three long ones creates emphasis. Rhythm is not decoration. It is the reader's trust signal.

**19. One punch per 500 words.** Every 500 words must contain at least one sentence under 8 words. Short declarative sentences after long analytical ones create authority. "It could not." "The map is the territory." "These failures were not wasted compute. They were evidence." These are the moments the reader remembers.

**20. Minimum 6,000 words per chapter.** Target 200-250 pages across the book. A chapter at 4,000 words is compressed shorthand, not developed narrative. Every concept deserves a scene, every argument deserves development, every transition deserves breathing room. If a chapter feels finished at 4,000 words, it is missing scenes, examples, or the slow-build development that separates a book from a report. Configurable per book, but the default is 6,000 to prevent the drafter from treating the floor as a target.

**21. One extended metaphor per chapter.** Once introduced, call it back at least once before the chapter ends. Abandoned metaphors are broken promises. Two extended metaphors in one chapter compete for attention and dilute both.

**22. Concrete before abstract.** Every section's first substantive content should be a scene, example, number, or specific observation. The analytical statement follows the evidence, not the other way around. Wrong: "Structural distrust is a design principle where no agent both produces and approves its own work. For example..." Right: "It was also rigged. The rigging was not deliberate. [scene unfolds]... The principle has a name: structural distrust."

**23. One immersive passage per chapter.** Every chapter must contain at least one passage where the reader could forget they are reading non-fiction. A moment of scene-mode so vivid it reads like a novel: a specific place, a specific time, sensory detail, present tense or close third person. "Picture a data center floor at Google Brain in 2016. Eight hundred GPUs running simultaneously, their fans producing a low industrial hum that would continue without pause for twenty-eight days."

## Line Editing

Rules 26-30 address the gap between developmental structure and copy-level mechanics. A manuscript can pass every structural gate and every voice ban and still read like a report. The difference between competent and publishable lives at the paragraph level: how the eye moves down the page, where the white space falls, and whether each paragraph earns its length. These rules encode the line editor's craft.

**26. Every paragraph makes one move.** A paragraph that advances two claims, shifts from evidence to implication, or crosses from scene to exposition is two paragraphs that forgot to separate. Break at the turn of thought. The known-new chain connects the two halves across the break; the break itself signals the shift. Wrong: a 200-word paragraph that opens with a concrete example and closes with its analytical implication. Right: the example in one paragraph, the implication in the next, with the second opening from where the first landed.

**27. No paragraph exceeds 150 words.** The only exceptions: (a) an immersive scene whose sensory continuity ruptures if broken, or (b) a chain of reasoning where every sentence depends on both its predecessor and its successor and no internal sentence could open a new paragraph without orphaning the ones before it. If the paragraph contains an internal turn — from evidence to analysis, from one claim to its consequence, from problem to solution — the turn is the break point. The 150-word ceiling is not a target. Target 80-100 words. A paragraph that reaches 150 has the burden of proof.

**28. One emphasis paragraph per 600 words.** Every 600 words must contain at least one paragraph of 40 words or fewer. This paragraph is a deliberate pacing beat: a standalone assertion, a one-sentence revelation, a short bridge, or a question left to breathe. Single-sentence paragraphs are the non-fiction writer's boldface — isolation creates emphasis. Deploy 3-5 per chapter at moments of revelation, reversal, or transition. Never use one because you ran out of things to say.

**29. Break at the scene-analysis boundary.** When prose shifts from scene (concrete, immersive, specific) to exposition (analytical, abstract, generalising), break. The break marks the mode shift for the reader. The opening sentence of the exposition paragraph references the scene it analyses. Never run the last sentence of a scene and the first sentence of its analysis in the same paragraph. The scene lands. The analysis begins.

**30. Paragraph length must vary.** No 3+ consecutive paragraphs within 20 words of each other in length. The standard deviation of paragraph word counts within a chapter must be at least 40% of the mean. Uniform paragraph blocks create scanning fatigue — the visual monotone of a report. A page of trade non-fiction has 4-6 paragraphs of varied length. A page of report prose has 2-3 blocks of identical height. The difference is the white space that enables comprehension.

## Voice Texture Rules

Rules 31-32 address the gap between consistent prose and human prose. A manuscript can pass every structural gate, every voice ban, and every paragraph craft rule and still read as machine-generated. The difference between polished and human is voice texture: the register breaks, the narrator's presence, and the dual perspective that non-fiction's best writers use to make analytical prose feel alive. These rules encode the non-fiction voice craft researched from Feynman, Ng, Gladwell, Gawande, Yong, McPhee, and Roach.

**31. No uniform register.** A chapter that maintains one analytical register for 6,000 words reads as machine-generated regardless of prose quality. Every chapter must contain at least 3 register breaks from at least 2 of these five categories: (a) conversational aside — a sentence that sounds spoken, not written, (b) direct address — the teacher speaking to the reader at a difficulty spike, (c) vulnerability moment — the narrator admitting difficulty, uncertainty, or a wrong turn, (d) wonder moment — the narrator's fascination visible through pacing and attention, not announcement, (e) anecdotal open — a specific person in a specific moment. Uniform analytical polish is itself an AI tell. The breaks must be genuine — not inserted as decoration but placed where the material warrants a shift in how the narrator relates to it.

**32. No invisible narrator.** The narrator's reaction to the material must surface at least twice per chapter. Not narrating the reader's reaction (banned by Rule 4: "you might be surprised"). Narrating the narrator's own encounter with the material: difficulty ("the honest admission is that nobody fully understands why"), recognition ("the lint engine found it in eleven milliseconds — what a careful human reader had approved twice"), wonder expressed through attention rather than adjective. A narrator with zero emotional relationship to the material is a documentary voice. The Rigorous Storyteller is a teacher's voice, and a teacher who never reacts to their own subject is a lecturer, not a teacher.

**33. Not every sentence earns its polish.** Zero grammatical imperfection across 6,000 words is the strongest remaining AI tell. At least 2-3 sentences per chapter prioritise voice over grammar: a fragment used for rhythm ("Not yet."), a colloquial phrase in analytical context ("Here is the thing about hedge words."), a contraction where formality is expected ("it is not" becomes "it's not" once per chapter), a sentence that starts with "And" or "But." The reader's ear expects occasional roughness from a human author. Uniform polish is the sound of a machine that optimises for correctness. Personality is the fix.

## Formatting Rules

**24. Mathematical notation uses LaTeX.** All mathematical expressions, equations, and formal notation must be written in LaTeX syntax: inline as `$expression$` and display as `$$expression$$`. Never write mathematical notation in plain text ("x^2 + y^2 = z^2") or Unicode approximations. The render pipeline converts LaTeX to properly typeset mathematics via KaTeX or MathJax. If a concept can be explained without notation, prefer prose. If notation is necessary, it must be LaTeX.

**25. Titles and chapter headings follow book convention.** Chapter titles are evocative, not descriptive. Wrong: "Chapter 5: The Evolutionary Search Process and Convergence Model". Right: "Chapter 5: The Evolutionary Search". Subtitles are optional and short — a phrase, not a sentence. Part titles name the arc movement, not the topic list. The table of contents should read like a story's chapter names, not a report's section headers.

---

These rules are bans, not aspirations. A violation is a revision, not a judgement call. The seven strongest passages across the book's 14 chapters share three traits: concrete before abstract, short sentence after long, and load-bearing analogy. The seven weakest share three: abstract before concrete, specification prose, and enumeration as structure. The line-editing rules (26-30) address the gap between structural quality and page-level readability: a manuscript that passes every structural gate can still read like a report if every paragraph is 180 words and the eye has nowhere to rest. The voice texture rules (31-32) address the gap between polished prose and human prose: a manuscript with perfect grammar, perfect structure, and perfect paragraph density reads as machine-generated if the narrator has no personality, no reactions, and no register variation.
