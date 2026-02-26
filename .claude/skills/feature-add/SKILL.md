---
name: feature-add
description: "Add a new feature: lightweight interrogation, doc updates, implementation, and verification."
allowed-tools: Read, Write, Bash, Glob, Grep
argument-hint: "Feature description (e.g., 'add user profile page with avatar upload')"
---

# Feature Addition Workflow

Orchestrates adding a new feature to an existing project. Lighter than a full pipeline run — skips project-level interrogation and focuses on the delta.

## Prerequisites
- Project must already have base documentation (docs/PRD.md at minimum)
- Run `/phase0` first if not already done this session

## Process

### Step 1: Context Gathering
1. Read `docs/summaries/phase0-summary.md` for current project state
2. Read existing docs (PRD, IMPLEMENTATION_PLAN, TECH_STACK)
3. Scan codebase for related features

### Step 2: Feature Interrogation (Lightweight)
Focused interrogation covering only relevant sections:

1. **Problem & User Story**: What does this feature do? Who benefits? 1-3 user stories.
2. **Functional Requirements**: Inputs, outputs, edge cases.
3. **Data Model Changes**: New entities or modifications?
4. **API Changes**: New endpoints or modifications?
5. **Testing**: What tests are needed?
6. **Security**: Any new attack surface?

In INTERACTIVE mode: ask the human each question.
In AUTONOMOUS mode: search codebase, infer, assume with [ASSUMPTION] tags.

Write to: `docs/artifacts/feature-[slug]-interrogation.md`

### Step 3: Documentation Updates
Update relevant docs with the new feature (append, don't rewrite).

### Step 4: Implementation Plan
Ordered list of implementation steps. Each step:
- Small enough to implement and verify in one pass
- Ordered by dependency

### Step 5: Implementation Loop
For each step:
1. Implement following existing codebase patterns
2. Run type checker / linter after each edit
3. Run relevant tests
4. Commit: `feat([feature-slug]): [step description]`

If a step fails verification:
- Retry up to 3 times with error context
- If stagnated (same error 2x), try different approach
- If blocked after 3 retries, stop and report

### Step 6: Verification
1. Run full test suite
2. Run type checker on entire project
3. Verify no regressions

### Step 7: Update Progress
1. Update `PROGRESS.md`
2. Generate summary of what was added
