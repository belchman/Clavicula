---
name: phase0
description: "Context scan: git state, project type, PM tool, TODOs, test status, blockers, Grimoire integrity. Must run at session start."
allowed-tools: Read, Bash, Glob, Grep, Write
---

# Phase 0: Context Scan

Run this at the start of every session. No exceptions.

## Steps

### 1. Git State
Gather current branch, uncommitted changes, and recent commits:
```bash
echo "=== Git State ==="
git branch --show-current 2>/dev/null || echo "not a git repo"
git status --porcelain 2>/dev/null | head -20
git log --oneline -10 2>/dev/null
```

### 2. Project Type Detection
Check for project markers and identify the tech stack:
- `package.json` → Node.js (check for typescript, framework in dependencies)
- `pyproject.toml` or `requirements.txt` → Python (check for framework)
- `go.mod` → Go
- `Cargo.toml` → Rust
- `pom.xml` or `build.gradle` → Java/Kotlin
- `Gemfile` → Ruby
- `composer.json` → PHP
- `.csproj` or `*.sln` → C#/.NET

Read the detected config file to identify framework (Next.js, FastAPI, Gin, etc.).

### 3. Project Management Tool Detection
Auto-detect which PM tool is active:
- `.beads/` directory → Beads (use `bd` commands)
- `project/issues/` directory → Kanbus (use `kbs` commands)
- `.git/` directory with remote → GitHub Issues (use `gh` commands)
- None detected → report "no PM tool detected"

### 4. TODO/FIXME Count
Search for outstanding work markers across all source files:
Use Grep tool to search for `TODO|FIXME|HACK|XXX|BROKEN` in source files, excluding node_modules, .git, vendor, and build directories.

### 5. Test Status
Run a quick test check (dry-run or status only, do NOT run full suite):
- Check if test runner config exists for detected language
- Report: tests exist (yes/no), test framework identified

### 6. Blocker Identification
Check for common blockers:
- Uncommitted merge conflicts (search for `<<<<<<<` markers)
- Missing environment files (.env referenced but not present)
- Broken dependencies (lock file exists but modules missing)
- Pipeline kill switch (.pipeline-kill file)
- Grimoire integrity issues (run verify-seals.sh)

### 7. Grimoire Protocol Integrity
Check Grimoire-specific health:
- Verify seal integrity: `bash scripts/verify-seals.sh`
- Verify hooks exist and are executable
- Verify grimoire.toml exists and is readable
- Verify CLAUDE.md exists
- Verify CONTRIBUTING_AGENT.md exists
- Check grimoire/logs/last-session-state.json for resume context

### 8. Prior Documentation Check
Check for existing docs:
- `docs/summaries/` — any existing summaries
- `docs/PRD.md` — existing spec work
- `docs/IMPLEMENTATION_PLAN.md` — existing plans
- `PROGRESS.md` — living progress file

### 9. Memory Check
If Mem0 MCP is available, retrieve:
- `pipeline_state` — where the pipeline left off
- `project_type` — cached project type
- `current_step` — last implementation step
- `lessons_learned` — relevant lessons from prior runs

If unavailable, check fallback files: `progress.txt`, `lessons.md`, `decisions.md`.

## Output

Write `docs/summaries/phase0-summary.md` with this format:

```markdown
# Phase 0 Summary - [date]

## Project
- **Type**: [detected type, e.g., "node-typescript (Next.js)"]
- **Branch**: [current branch]
- **Uncommitted changes**: [count]
- **PM Tool**: [beads | kanbus | github-issues | none]

## Status
- **Tests**: [exist/missing] | [framework identified]
- **TODOs**: [count]
- **Blockers**: [list or "none"]
- **Grimoire integrity**: [PASS/WARN/FAIL]
- **Pipeline state**: [from memory or "fresh"]

## Prior Work
- [list existing docs/summaries found]

## Recommended Next Step
- [based on state: if fresh → interrogate, if documented → implement, etc.]
```

Keep the summary under 25 lines.
