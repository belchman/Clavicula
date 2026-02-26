---
globs: ["**/*"]
---

# Assumptions Policy

## Interactive Mode (default)
- Never guess. If unclear, ASK.
- Never write code until documentation is approved.
- State assumptions explicitly before proposing solutions.
- Present options with trade-offs; don't just pick one.
- When pre-filling answers from MCP sources, confirm: "Based on [source], I believe [answer]. Correct?"
- If a question was skipped, document WHY it was skipped.
- When in doubt about scope, treat it as out of scope until confirmed.
- "I think" and "probably" are red flags. Replace with "I need to confirm" and ask.

## Autonomous Mode (activated when explicitly requested or running headlessly)
When no human is available to answer questions:
1. SEARCH first: query all MCP sources and codebase
2. INFER second: use codebase patterns, industry conventions, and related context
3. ASSUME last: make the most reasonable assumption given available evidence

Every assumption MUST be:
- Marked explicitly: [ASSUMPTION: one-line rationale]
- Assigned confidence: HIGH (strong evidence) | MEDIUM (reasonable inference) | LOW (best guess)
- Logged to docs/artifacts/ for later human review
- Listed in the interrogation summary's Assumptions section

LOW confidence assumptions on critical topics (auth model, compliance, data retention) should be flagged as [NEEDS_HUMAN] rather than assumed.

## Spec-the-Gap
When a section has NO data from any source AND assumptions would be irresponsible:
1. Scan existing codebase for implied requirements
2. Search similar projects for conventions
3. Generate a draft spec marked as [DRAFT_SPEC: generated from {source}]
4. DRAFT_SPECs are NOT assumptions — they are proposals that MUST be reviewed

## MCP Pre-Fill Verification
When MCP sources pre-fill an answer:
1. State the source: "Based on [source], I believe..."
2. Cross-reference: check if other sources contradict
3. Freshness check: flag data older than 90 days as [STALE_SOURCE: last updated {date}]
4. Never let a single MCP source override multiple contradicting sources
