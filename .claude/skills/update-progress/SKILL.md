---
name: update-progress
description: "Update project progress file with living architecture and status."
allowed-tools: Read, Write, Bash, Glob, Grep
---

# Update Progress

Maintain a living `PROGRESS.md` at the project root as the canonical source of truth for pipeline state.

## When to Run
- After each pipeline phase completes
- After any manual implementation work
- When resuming a session
- After healing or error analysis

## Process

### Step 1: Gather State
Read these sources (priority order):
1. `docs/artifacts/pipeline-runs/*/checkpoint.json` (most recent)
2. `docs/summaries/` (all existing summaries)
3. `docs/IMPLEMENTATION_PLAN.md` (remaining steps)
4. `git log --oneline -10` (recent commits)
5. `git status --porcelain` (uncommitted work)

### Step 2: Write PROGRESS.md
Write/overwrite `PROGRESS.md` at project root:

```markdown
# Progress - [project name]
Last updated: [ISO timestamp]

## Current State
- **Pipeline phase**: [phase name or "not started"]
- **Status**: [running | completed | blocked | needs_human | stagnated]
- **Current step**: [step ID and title, or N/A]

## Architecture
[Brief description of code structure as it exists NOW. Max 15 lines.]

## Completed Work
- [x] [Step/phase] - [1-line description] ([commit hash])

## In Progress
- [ ] [Current step] - [what's happening, any blockers]

## Recent Changes
| Date | Change | Commit |
|------|--------|--------|
| [date] | [description] | [hash] |

## Failed Approaches
[What was tried and didn't work. Prevents repeating failed strategies.]

## Known Issues
- [Issue description] - [severity: blocker/warning/info]

## Assumptions Made
- [ASSUMPTION: description] (confidence: HIGH/MEDIUM/LOW)

## Remaining Work
- [ ] [Step ID]: [title]
```

### Step 3: Update Memory
If Mem0 available, update pipeline_state, current_step, completed_steps.
If unavailable, update fallback files (progress.txt, lessons.md, decisions.md).

## Rules
- Never delete "Failed Approaches" or "Lessons Learned" entries (append-only)
- Keep "Architecture" section under 15 lines
- "Recent Changes" shows only last 5 entries
