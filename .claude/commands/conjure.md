---
name: conjure
description: "Invoke an agent with full Grimoire Protocol lifecycle."
argument-hint: "Agent name or rank (e.g., 'paimon', 'reviewer', 'duke/coder')"
allowed-tools: Read, Bash, Glob, Grep, Task
---

# Conjure — Agent Invocation Protocol

Invoke an agent with the full Grimoire Protocol lifecycle.

## Process

### Step 1: Verify the Circle
Before any agent invocation:
1. Verify seal integrity: `bash scripts/verify-seals.sh`
2. Verify hooks are active (settings.json exists and is valid)
3. Verify grimoire.toml is readable

If any check fails, report the failure and stop. The Circle must be drawn before conjuration.

### Step 2: Identify the Agent
Parse the argument to find the requested agent:
- Check `.claude/agents/` for matching agent definition files
- Match by name (e.g., "paimon"), rank/role (e.g., "duke/coder"), or alias
- Present available agents if no match or ambiguous

Available agents by rank:
| Rank | Name | File | Role |
|------|------|------|------|
| King | Paimon | kings/orchestrator.md | Primary orchestrator |
| Duke | Astaroth | dukes/coder.md | Code implementation |
| Duke | Vassago | dukes/researcher.md | Research & analysis |
| Duke | Agares | dukes/writer.md | Documentation |
| President | Marbas | presidents/reviewer.md | Code review |
| President | Buer | presidents/planner.md | Planning |
| Earl | Foras | earls/guardian.md | Alignment monitor (HGA) |
| Earl | Andromalius | earls/auditor.md | Security audit |
| Knight | Furcas | knights/utility.md | Utility |

### Step 3: Load Constraints
Load applicable constraint documents:
1. `grimoire/bindings/divine-names.md` (always)
2. `grimoire/bindings/angelic-orders.md` (always)
3. Relevant task constraints from `grimoire/bindings/task-constraints/`

### Step 4: Present the Seal
Read the agent definition file and verify its integrity against the seal manifest.

### Step 5: Conjure
Spawn the agent via the Task tool with the specified agent definition.
Pass the task description and constraint context.

### Step 6: Log
Log the conjuration to `grimoire/logs/audit.log`:
```
[timestamp] CONJURE agent=[name] rank=[rank] task=[summary]
```
