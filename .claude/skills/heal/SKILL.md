---
name: heal
description: "Run the Healer cycle to diagnose and fix systemic pipeline failures."
allowed-tools: Read, Write, Bash, Glob, Grep, Task
---

# Run Healer

Diagnose and fix systemic failures by analyzing error patterns across runs.

## When to Run
- After any pipeline run that ended in `blocked` or `stagnated` status
- After 3+ consecutive verify failures
- When cost per run exceeds 2x historical average
- Manually, when systemic issues suspected

## Process

### Step 1: Pre-Flight Check
1. Verify pipeline run logs exist at `docs/artifacts/pipeline-runs/`
2. Count total runs and failure counts
3. If fewer than 2 runs, report "Insufficient data for healing" and exit

### Step 2: Collect Error Evidence
- Read `checkpoint.json` from each run for failed/blocked/stagnated runs
- Read verify JSON outputs for FAIL verdicts
- Read `blocked-*.txt` files for block reports

### Step 3: Run the 7-Step Healing Cycle
1. **OBSERVE**: Read all recent pipeline logs
2. **CLUSTER**: Group similar failures by error type, file, root cause
3. **DIAGNOSE**: For each cluster, identify the systemic issue
4. **INVESTIGATE**: Read relevant source code, configs, rules
5. **PRESCRIBE**: Write the fix (code, rule, or config change)
6. **APPLY**: Make changes and commit: `fix(healer): [description]`
7. **VERIFY**: Run relevant tests to confirm fix

### Step 4: Post-Healing Validation
1. Run project test suite to check for regressions
2. If tests fail, revert the healer's commits and report
3. If tests pass, log lessons learned

### Step 5: Generate Report
Write `docs/artifacts/heal-report-[date].md`

## Safety Rules
- Fix the PIPELINE, not the TARGET PROJECT's business logic
- Only modify: `.claude/rules/`, `.claude/skills/`, `grimoire.toml`, `scripts/`
- Never modify: `grimoire/templates/`, target project source code
- Never increase budget ceilings without flagging it
- If prescription requires architectural changes, flag as [NEEDS_HUMAN]
- Maximum 5 prescriptions per heal cycle
