# book-maker

Plugin that emits a `/book-maker` slash command. Produces claim-verified, narratively coherent non-fiction books as PDF from a user-supplied topic.

## Pipeline shape

1. Confirm topic, voice anchor, and book mode with the user.
2. Decompose the topic into research themes.
3. Spawn one research subagent per theme.
4. Extract every load-bearing claim into a claims ledger.
5. Run the claim verification sidecar against each claim.
6. Build the narrative spine (thesis + 5-beat arc).
7. Build the architecture (chapter skeleton, concept cards, argument DAG).
8. Build the thread registry and transition contracts.
9. Validate the skeleton against 6 pre-draft gates.
10. Draft chapters sequentially, growing the bible during drafting.
11. Run 8 adversarial continuity gates with a separate reviewer agent.
12. Assemble per-chapter endnotes with clickable source URLs.
13. Spec every figure as a structured layout (hierarchy, sequence, matrix, or table).
14. Render the document as styled HTML, then print to PDF via a headless browser.
15. Emit the verdict token.

## Verdict tokens

- `BOOK_SHIPPED` — PDF rendered, every claim verified, all 8 continuity gates passed.
- `CLAIMS_UNVERIFIED` — one or more load-bearing claims failed the verifier.
- `NARRATIVE_BROKEN` — continuity review failed after revision pass.
- `SCOPE_TOO_VAGUE` — topic was rejected at the confirmation step.

## Invocation

Type `/book-maker` to trigger the skill. The bootstrap is loaded on session start.
