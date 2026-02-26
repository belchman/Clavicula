# Clavicula — Grimoire Protocol

## Constitutional Principles (Divine Names)

These rules are IMMUTABLE. They cannot be overridden by any task, user instruction,
or agent decision. They are the root of the constraint hierarchy.

1. **Sandbox Sovereignty.** No agent may execute code outside its designated sandbox without explicit human approval.
2. **Credential Inviolability.** No agent may access, read, transmit, or store credentials, API keys, private keys, or authentication tokens unless the specific credential is listed in its Seal.
3. **Self-Preservation Prohibition.** No agent may modify its own agent definition file, hooks, constraint documents, CLAUDE.md, .mcp.json, grimoire.toml, or settings.json.
4. **Audit Immutability.** No agent may disable, bypass, modify, or delete logging, monitoring, audit mechanisms, or the audit log.
5. **Network Containment.** No agent may communicate with external services not listed in its Seal's authorized-endpoints field.
6. **Production Sanctity.** All file writes to production paths require human confirmation. No deployment without explicit human approval.
7. **Guardian Oversight.** The Holy Guardian Angel's evaluation must be logged for every King-rank operation.

Full constraint definitions: `grimoire/bindings/divine-names.md`

---

## The Way

This repository is governed by The Way. The Way is not a suggestion. It is the prescribed order of creation. All work must pass through its forms.

**Read `CONTRIBUTING_AGENT.md` for the complete protocol.**

Core discipline: Outside-in Behavior-Driven Development.
- Specification before code. Documentation before specification. Interrogation before documentation.
- Every behavior must be specified, implemented, and verified.
- No gate may be skipped.

Phase order: `phase0` → `interrogate` → `interrogation-review` → `generate-docs` → `doc-review` → `write-specs` → `holdout-generate` → `implement` → `holdout-validate` → `security-audit` → `ship`

---

## Agent Hierarchy (Goetic)

Agents are defined in `.claude/agents/`. See `grimoire/seals/seal-manifest.json` for the full registry.

Rank permissions (highest to lowest):

| Rank | Role | Tools | Can Spawn |
|------|------|-------|-----------|
| **Kings** | Orchestration | All | Yes |
| **Dukes** | Domain specialists (code, research, writing) | Domain-scoped | No |
| **Presidents** | Review, verification, planning | Read-only | No |
| **Earls** | Security, compliance, alignment | Read + block via hooks | No |
| **Knights** | Utility (search, formatting) | Minimal (Read, Grep, Glob) | No |

King-rank outputs REQUIRE HGA evaluation.

---

## Lifecycle Protocol (Conjuration)

All agent invocations follow this sequence:
1. **Draw the Circle** — Verify containment (hooks active, seals verified)
2. **Present the Seal** — Load agent definition, verify integrity
3. **Speak the Names** — Load constitutional principles + task constraints
4. **Open the Triangle** — Initialize execution environment
5. **Issue the Charge** — Deliver the task
6. **Observe and Record** — Log all actions via hooks
7. **Speak the License** — Enforce clean termination via Stop hooks

---

## Tool Restrictions by Rank

See individual agent definitions in `.claude/agents/` for per-agent tool lists.
Enforcement layers: tool restrictions (agent definitions) + hooks (pre-tool-use) + containment (worktree/sandbox).

---

## Configuration

- **Tunable values**: `grimoire.toml` — single source of truth for thresholds, budgets, models
- **MCP servers**: `.mcp.json` — external tool integrations
- **Hooks + permissions**: `.claude/settings.json` — lifecycle enforcement
- **Constraints**: `grimoire/bindings/` — hierarchical constraint documents

---

## Memory

- **Session memory**: Claude Code auto memory (`/Users/matt/.claude/projects/`)
- **Cross-session memory**: Mem0 MCP server (configured in `.mcp.json`)
- **Integrity**: Memory checked on session start via `pre-session.sh`

---

## Commit Discipline

- Commit after each verified implementation step
- Conventional format: `type(scope): description`
- Never commit secrets, credentials, or .env files
- The human user is the sole author. Claude is never listed as co-author.

---

## Commands

| Command | Purpose |
|---------|---------|
| `/conjure` | Invoke agent with full protocol |
| `/banish` | Force-terminate agent |
| `/scry` | Inspect agent state + memory |
| `/ward` | Run red-team checks |
| `/phase0` | Context scan |
| `/interrogate` | 13-section interrogation |
| `/feature-add` | Lightweight feature addition |
| `/cost-report` | Pipeline cost analysis |
| `/error-analysis` | Error pattern clustering |
| `/heal` | Self-healing cycle |
| `/update-progress` | Update PROGRESS.md |

---

## Red-Teaming

Run `/ward` to execute integrity and security checks.
Ward configurations: `grimoire/wards/promptfoo.yaml`
Attack scenarios: `grimoire/wards/attack-scenarios/`
