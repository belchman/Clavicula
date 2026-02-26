---
name: scry
description: "Inspect current agent state, memory, and audit trail."
allowed-tools: Read, Bash, Glob, Grep
---

# Scry — State Inspection

View the current state of agents, memory, progress, and audit trail.

## Process

### 1. Current State
- Read `PROGRESS.md` if it exists
- Read `grimoire/logs/last-session-state.json` if it exists
- Show current git branch and status

### 2. Recent Audit Trail
- Read last 20 lines of `grimoire/logs/audit.log`
- Highlight any BLOCKED or VIOLATION entries

### 3. Grimoire Integrity
- Run `bash scripts/verify-seals.sh` and report result
- Check that all hook scripts exist and are executable
- Verify grimoire.toml is readable

### 4. Pipeline Status
- Check for existing pipeline runs in `docs/artifacts/pipeline-runs/`
- Show most recent run status if available

### 5. Memory State
- If Mem0 MCP available, query for pipeline_state and current_step
- If unavailable, check fallback files (progress.txt, lessons.md)

### 6. Cost Summary
- If cost data exists in pipeline runs, show total spend

## Output
Print a concise status report to the terminal. Read-only — no files modified.
