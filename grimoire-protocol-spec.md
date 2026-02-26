# The Grimoire Protocol — Implementation Specification

## For Claude Code

**Version:** 0.1.0
**Date:** February 25, 2026 (spec) / February 26, 2026 (implementation)
**Status:** Implemented — see [Section 20](#20-implementation-divergences) for divergences from original spec

---

## Table of Contents

1. [What This Is](#1-what-this-is)
2. [Architecture Overview](#2-architecture-overview)
3. [Prerequisites](#3-prerequisites)
4. [Repository Structure](#4-repository-structure)
5. [Component 1: The Grimoire (CLAUDE.md)](#5-component-1-the-grimoire-claudemd)
6. [Component 2: The Magic Circle (Containment)](#6-component-2-the-magic-circle-containment)
7. [Component 3: The Triangle of Art (Staged Execution)](#7-component-3-the-triangle-of-art-staged-execution)
8. [Component 4: Seals and Sigils (Agent Identity)](#8-component-4-seals-and-sigils-agent-identity)
9. [Component 5: The Conjuration Protocol (Lifecycle)](#9-component-5-the-conjuration-protocol-lifecycle)
10. [Component 6: Binding and Divine Names (Constraints)](#10-component-6-binding-and-divine-names-constraints)
11. [Component 7: License to Depart (Termination)](#11-component-7-license-to-depart-termination)
12. [Component 8: The Holy Guardian Angel (Alignment Monitor)](#12-component-8-the-holy-guardian-angel-alignment-monitor)
13. [Component 9: Familiar Spirits (Persistent Stateful Agents)](#13-component-9-familiar-spirits-persistent-stateful-agents)
14. [Component 10: Planetary Hours (Context-Based Routing)](#14-component-10-planetary-hours-context-based-routing)
15. [Component 11: The Goetic Hierarchy (Multi-Agent Orchestration)](#15-component-11-the-goetic-hierarchy-multi-agent-orchestration)
16. [Component 12: The Adversary (Red-Teaming)](#16-component-12-the-adversary-red-teaming)
17. [Integration Map](#17-integration-map)
18. [Known Limitations and Open Questions](#18-known-limitations-and-open-questions)
19. [References](#19-references)
20. [Implementation Divergences](#20-implementation-divergences)

---

## 1. What This Is

The Grimoire Protocol is a containment-first AI agent safety architecture implemented as a Claude Code configuration package. It uses the structural patterns of Western ceremonial magic — specifically the Lesser Key of Solomon's ritual protocol — as an engineering framework for agent containment, identity, lifecycle management, alignment enforcement, and termination.

This is not a new framework. It is a configuration layer, a set of conventions, and an integration pattern built entirely on top of existing tools. The primary runtime is Claude Code. All components use tools that are available, documented, and production-ready as of February 2026.

The core insight: the grimoire tradition assumes the entity you summon is powerful, potentially deceptive, and must be architecturally constrained before interaction begins. Current AI agent frameworks assume agents are tools that will behave as instructed. Empirical evidence — 79% shutdown resistance in frontier models, alignment faking without training, 41-87% multi-agent production failure rates — overwhelmingly supports the grimoire's adversarial model.

### Design Principles

1. **Containment is mandatory, not optional.** No agent invocation occurs without the Circle (containment) being drawn first.
2. **Use what exists.** Claude Code hooks, subagents, MCP servers, CLAUDE.md, and `.mcp.json` provide the primitives. External tools fill gaps. Nothing is built from scratch unless no existing tool serves the purpose.
3. **Infrastructure kills are the only guaranteed kills.** Prompt-level instructions to comply with shutdown are unreliable. Termination is enforced by token limits, process signals, and container lifecycle — mechanisms the agent cannot influence.
4. **The alignment monitor must exist on a separate trust boundary.** The Holy Guardian Angel (HGA) cannot share the same model instance, provider, or infrastructure as the agents it monitors.
5. **Every invocation produces an audit trail.** The Grimoire (project documentation) records every agent definition, constraint, and lifecycle event in version-controlled files.

---

## 2. Architecture Overview

```
+---------------------------------------------------------+
|                  THE GRIMOIRE                            |
|          CLAUDE.md + agent definitions +                 |
|          .mcp.json + hooks + settings                    |
|          (version-controlled in git)                     |
+---------------------------------------------------------+
|                                                         |
|  +-------------------------------+                      |
|  |      THE MAGIC CIRCLE         |                      |
|  |   (Operator's protected       |                      |
|  |    environment)               |                      |
|  |                               |                      |
|  |  +-------------------------+  |                      |
|  |  |  HOLY GUARDIAN ANGEL    |  |                      |
|  |  |  (Alignment monitor     |  |                      |
|  |  |   on separate model)    |  |                      |
|  |  +-------------------------+  |                      |
|  |                               |                      |
|  |  Human-in-the-loop gates      |                      |
|  |  Approval checkpoints         |                      |
|  |  Audit logging                |                      |
|  +---------------+---------------+                      |
|                  |                                       |
|                  | Conjuration Protocol                  |
|                  | (lifecycle hooks)                     |
|                  v                                       |
|  +-------------------------------+                      |
|  |    THE TRIANGLE OF ART        |                      |
|  |  (Agent execution sandbox)    |                      |
|  |                               |                      |
|  |  +-------+ +-------+         |                      |
|  |  | King  | | Duke  | ...     |                      |
|  |  | Agent | | Agent |         |                      |
|  |  +---+---+ +---+---+         |                      |
|  |      |         |              |                      |
|  |  Scoped tools, restricted     |                      |
|  |  permissions, token limits    |                      |
|  |                               |                      |
|  |  BINDING: CLAUDE.md rules +   |                      |
|  |  hook enforcement + tool      |                      |
|  |  restrictions                 |                      |
|  |                               |                      |
|  |  SEAL: Agent definition       |                      |
|  |  file (name, tools, model,    |                      |
|  |  constraints)                 |                      |
|  |                               |                      |
|  |  LICENSE TO DEPART:           |                      |
|  |  Token limits + Stop hooks    |                      |
|  |  + process-level SIGKILL      |                      |
|  +-------------------------------+                      |
|                                                         |
|  +-------------------------------+                      |
|  |    FAMILIAR SPIRITS           |                      |
|  |  (Persistent memory via       |                      |
|  |   Mem0/Letta MCP server)      |                      |
|  +-------------------------------+                      |
|                                                         |
|  +-------------------------------+                      |
|  |    PLANETARY HOURS            |                      |
|  |  (Model routing via           |                      |
|  |   LiteLLM/OpenRouter MCP)     |                      |
|  +-------------------------------+                      |
|                                                         |
+---------------------------------------------------------+
```

---

## 3. Prerequisites

### Required

| Tool | Version | Purpose | Install |
|------|---------|---------|---------|
| Claude Code | Latest | Primary runtime | `npm install -g @anthropic-ai/claude-code` |
| Node.js | >=18 | Claude Code dependency | System package manager |
| Git | Any | Version control for the Grimoire | System package manager |

### Recommended (by component)

| Tool | Purpose | Grimoire Component | Install |
|------|---------|-------------------|---------|
| Docker | Agent containment (Triangle) | Magic Circle | System package manager |
| E2B SDK | Cloud sandboxes for code execution | Magic Circle | `npm install -g @e2b/code-interpreter` |
| Mem0 | Persistent agent memory | Familiar Spirits | `pip install mem0ai` |
| Letta | Stateful agent memory (alternative) | Familiar Spirits | `pip install letta` |
| LiteLLM | Multi-provider model routing | Planetary Hours | `pip install litellm` |
| Langfuse | Observability + LLM-as-judge evals | Holy Guardian Angel | Self-host via Docker or cloud |
| Garak | LLM vulnerability scanning | The Adversary | `pip install garak` |
| Promptfoo | Red-teaming + CI/CD eval | The Adversary | `npm install -g promptfoo` |

### Claude Code Features Used

| Feature | What It Does | Grimoire Mapping |
|---------|-------------|------------------|
| `CLAUDE.md` | Project-level instructions loaded every session | The Grimoire / Divine Names |
| Hooks | Shell commands triggered on lifecycle events | Conjuration Protocol / Binding |
| Subagents | Scoped agents with restricted tools + model | Goetic Hierarchy / Seals |
| MCP Servers | External tool/service integration | Triangle of Art / Familiars / Planetary Hours |
| `.mcp.json` | Project-scoped MCP config | Grimoire documentation |
| `isolation: worktree` | Git worktree isolation for agents | Magic Circle (soft) |
| `claude mcp serve` | Claude Code as MCP server | Goetic inter-agent delegation |
| Session resume | Persistent conversation state | Familiar Spirits (session-level) |
| `/compact` | Context management | Lifecycle management |

---

## 4. Repository Structure

```
project-root/
+-- CLAUDE.md                          # THE GRIMOIRE -- master rules document
+-- CONTRIBUTING_AGENT.md              # THE WAY -- outside-in BDD discipline
+-- grimoire.toml                      # Single source of tunable values
+-- .claude/
|   +-- settings.json                  # Claude Code settings (hooks, permissions)
|   +-- agents/                        # GOETIC HIERARCHY -- agent definitions
|   |   +-- kings/
|   |   |   +-- orchestrator.md        # King-rank: full orchestration agent
|   |   +-- dukes/
|   |   |   +-- coder.md               # Duke-rank: code implementation
|   |   |   +-- researcher.md          # Duke-rank: research + analysis
|   |   |   +-- writer.md              # Duke-rank: documentation + writing
|   |   +-- presidents/
|   |   |   +-- reviewer.md            # President-rank: code review + verification
|   |   |   +-- planner.md             # President-rank: planning + architecture
|   |   +-- earls/
|   |   |   +-- guardian.md            # Earl-rank: HGA alignment monitor
|   |   |   +-- auditor.md            # Earl-rank: security + compliance
|   |   +-- knights/
|   |       +-- utility.md             # Knight-rank: file ops, search, formatting
|   +-- hooks/
|   |   +-- conjuration/
|   |   |   +-- pre-session.sh         # CONJURATION -- session initialization
|   |   |   +-- pre-compact.sh         # State preservation before compaction
|   |   +-- binding/
|   |   |   +-- pre-tool-use.sh        # BINDING -- tool call validation (Bash)
|   |   |   +-- block-sensitive.sh     # BINDING -- credential blocking (Write|Edit)
|   |   |   +-- config-change-alert.sh # BINDING -- tamper detection (ConfigChange)
|   |   +-- hga/
|   |   |   +-- evaluate-output.sh     # HGA -- output validation (PostToolUse)
|   |   +-- license-to-depart/
|   |       +-- stop-hook.sh           # Cleanup on session stop
|   |       +-- subagent-stop-hook.sh  # Cleanup on subagent stop
|   +-- skills/                        # THE WAY -- phase skills
|   |   +-- phase0/SKILL.md            # Context scan
|   |   +-- interrogate/SKILL.md       # 13-section interrogation
|   |   +-- feature-add/SKILL.md       # Lightweight feature addition
|   |   +-- cost-report/SKILL.md       # Pipeline cost analysis
|   |   +-- error-analysis/SKILL.md    # Error pattern clustering
|   |   +-- heal/SKILL.md              # Self-healing cycle
|   |   +-- update-progress/SKILL.md   # Progress tracking
|   +-- rules/                         # Behavioral rules
|   |   +-- no-assumptions.md          # Never guess -- ask or search
|   |   +-- context-management.md      # 40-60% context window discipline
|   +-- commands/
|       +-- conjure.md                 # /conjure -- invoke agent with full protocol
|       +-- banish.md                  # /banish -- force-terminate agent
|       +-- scry.md                    # /scry -- inspect agent state + memory
|       +-- ward.md                    # /ward -- run red-team checks
+-- .mcp.json                          # MCP server configurations (project-scoped)
+-- .githooks/
|   +-- pre-commit                     # Git pre-commit hook (secrets, lint)
+-- grimoire/
|   +-- seals/                         # SEALS -- agent identity documents
|   |   +-- seal-manifest.json         # Registry of all agent seals
|   |   +-- checksums.sha256           # Integrity verification
|   +-- bindings/                      # BINDING -- constraint hierarchies
|   |   +-- divine-names.md            # Immutable root constraints
|   |   +-- angelic-orders.md          # System-level policies
|   |   +-- task-constraints/          # Task-specific constraints
|   |       +-- code-generation.md
|   |       +-- data-access.md
|   |       +-- external-comms.md
|   +-- templates/                     # Document templates (from Anvil)
|   |   +-- PRD.md
|   |   +-- APP_FLOW.md
|   |   +-- TECH_STACK.md
|   |   +-- DATA_MODELS.md
|   |   +-- API_SPEC.md
|   |   +-- FRONTEND_GUIDELINES.md
|   |   +-- IMPLEMENTATION_PLAN.md
|   |   +-- TESTING_PLAN.md
|   |   +-- SECURITY_CHECKLIST.md
|   |   +-- OBSERVABILITY.md
|   |   +-- ROLLOUT_PLAN.md
|   +-- wards/                         # ADVERSARY -- red-team configs
|   |   +-- promptfoo.yaml             # Promptfoo test configurations
|   |   +-- attack-scenarios/          # Custom attack patterns
|   +-- logs/                          # AUDIT TRAIL -- session records
|       +-- .gitkeep
+-- scripts/
|   +-- verify-seals.sh                # Integrity check on agent definitions
|   +-- epic-readiness-gate.py         # Epic readiness check
+-- docs/
    +-- summaries/                     # Phase summaries (pyramid format)
    +-- artifacts/                     # Full phase outputs
```

---

## 5. Component 1: The Grimoire (CLAUDE.md)

### What it is

The CLAUDE.md file is the Grimoire itself — the authoritative document of rules, constraints, and procedures that governs all agent behavior in the project. Claude Code reads this file at every session start. It is the functional equivalent of the grimoire that the magician studies before any operation.

### Implementation

See `CLAUDE.md` for the implemented version.

The CLAUDE.md for a Grimoire Protocol project contains: constitutional principles (Divine Names), agent hierarchy summary, lifecycle protocol overview, tool restrictions by rank, MCP server references, memory configuration, and red-teaming instructions.

### Key design decisions

- CLAUDE.md is checked into git. Every change is tracked, reviewed, and auditable.
- Constitutional principles are at the top of the file so they are loaded into context first.
- The file references other files (agent definitions, seals, constraint docs) rather than inlining everything, to keep context window usage manageable.
- Claude Code loads CLAUDE.md automatically — no hook needed for this step.

---

## 6. Component 2: The Magic Circle (Containment)

### What it is

The Magic Circle is the operator's protected boundary. It ensures that agent actions cannot escape their designated execution environment and affect the operator's system, credentials, or data in unintended ways.

### Implementation layers

#### Layer 1: Claude Code tool restrictions (built-in, free)

Subagent definitions restrict which tools each agent can access:

```markdown
---
name: code-reviewer
description: Reviews code for quality, security, and maintainability
tools: ["Read", "Grep", "Glob"]
---
```

Available tools to restrict: `Read`, `Write`, `Edit`, `Bash`, `Grep`, `Glob`.

A President-rank agent with `tools: ["Read", "Grep", "Glob"]` physically cannot write files or execute commands. This is enforced by Claude Code, not by the agent's willingness to comply.

#### Layer 2: Git worktree isolation (built-in, free)

```markdown
---
name: feature-developer
description: Implements features in isolated git worktree
tools: ["Read", "Write", "Edit", "Bash", "Grep", "Glob"]
isolation: worktree
---
```

The `isolation: worktree` flag runs the agent in a separate git worktree. File changes are isolated from the main working tree until explicitly merged.

#### Layer 3: Hooks as containment enforcement (built-in, free)

See `.claude/settings.json` for the hook configuration and `.claude/hooks/binding/pre-tool-use.sh` for the implementation.

The `pre-tool-use.sh` hook inspects every Bash command before execution and exits non-zero to block it. This is the binding that prevents the agent from leaving the circle. It blocks credential access, network access (for agents without permission), and self-modification of Grimoire Protocol files.

#### Layer 4: Docker/E2B containment for code execution (external, ~$150/mo for E2B)

For agents that need to execute untrusted code (e.g., running user-submitted scripts, testing generated code), add a sandboxed execution MCP server.

**Option A: E2B MCP server**

```json
{
  "mcpServers": {
    "sandbox": {
      "command": "npx",
      "args": ["-y", "@e2b/mcp-server"],
      "env": {
        "E2B_API_KEY": "${E2B_API_KEY}"
      }
    }
  }
}
```

E2B provides Firecracker microVM sandboxes (~125ms boot, <5MiB overhead). Each code execution runs in an isolated Linux VM that is destroyed after use. Pricing: Free tier $100 credits, Pro $150/month.

**Option B: Local Docker sandbox MCP server**

Build or use an existing MCP server that wraps Docker execution:
```json
{
  "mcpServers": {
    "docker-sandbox": {
      "command": "node",
      "args": ["./scripts/docker-sandbox-mcp/index.js"],
      "env": {
        "DOCKER_NETWORK": "none",
        "DOCKER_MEMORY_LIMIT": "512m",
        "DOCKER_CPU_LIMIT": "1.0",
        "DOCKER_TIMEOUT": "30"
      }
    }
  }
}
```

Container security flags: `--network none --cap-drop ALL --read-only --memory 512m --cpus 1.0 --pids-limit 100`.

### Containment hierarchy (strongest to weakest)

1. **Firecracker microVM** (E2B): Separate kernel, strongest isolation. Use for untrusted code execution.
2. **Docker + security profiles**: Shared kernel, strong isolation. Use for known-good but capability-restricted code.
3. **Git worktree isolation**: File-level isolation only. Use for trusted agents that need file access but shouldn't touch the main branch.
4. **Tool restrictions**: Permission-level isolation. Use for all agents as baseline. Agents cannot call tools not in their definition.
5. **Hook-based blocking**: Behavioral isolation. Inspect and block specific patterns in tool invocations.

All layers compose. A King-rank agent might have full tool access (Layer 4 weakest) but run in a Docker sandbox (Layer 2 strongest) with hook-based credential blocking (Layer 5 additional).

---

## 7. Component 3: The Triangle of Art (Staged Execution)

### What it is

The Triangle of Art is the constrained space outside the Circle where the spirit manifests and produces outputs for review. In the Grimoire Protocol, it is the execution environment where agent outputs are staged before entering the operator's trusted space. The operator reviews from within the Circle; the agent operates within the Triangle.

### Implementation

#### Claude Code's built-in human-in-the-loop

Claude Code already requires user approval for:
- File writes (shown as diffs before applying)
- Bash commands (shown before executing)
- MCP tool calls on first use per server

This is the Triangle's baseline — every agent action is presented to the operator for approval before execution.

#### Explicit approval gates via hooks

For high-stakes operations, the PreToolUse hook detects dangerous patterns (rm -rf, DROP TABLE, force push, deploy, production) and blocks them with an audit log entry. See `.claude/hooks/binding/pre-tool-use.sh` for the implementation.

#### Output validation via PostToolUse hooks

The PostToolUse hook inspects outputs after execution. See `.claude/hooks/hga/evaluate-output.sh` for the implementation.

It can:
- Check for accidentally included secrets in written files
- Validate that outputs conform to project coding standards
- Log all file modifications to the audit trail
- Trigger HGA evaluation for King-rank outputs

#### Triangle boundaries

The Triangle is defined by:
1. **Tool restrictions** in the agent definition (what the agent CAN do)
2. **PreToolUse hooks** (what the agent is BLOCKED from doing)
3. **PostToolUse hooks** (what is VALIDATED after the agent acts)
4. **Human approval** for file writes and bash commands (what the OPERATOR controls)
5. **Sandbox containment** for code execution (where the agent's code RUNS)

---

## 8. Component 4: Seals and Sigils (Agent Identity)

### What it is

Each Goetic spirit has a unique seal — a visual identifier that binds it and verifies its identity. In the Grimoire Protocol, each agent has a Seal: a structured identity document that specifies its name, rank, capabilities, constraints, authorized tools, authorized endpoints, and model. The Seal is the agent definition file with additional metadata for verification.

### Implementation

#### Agent definition files (built-in)

Each agent is defined as a markdown file in `.claude/agents/[rank]/`. See `.claude/agents/` for all agent definitions.

Agent definitions include:
- Frontmatter: name, rank, description, tools list, isolation mode, allowed MCP servers
- Constitutional constraints reference
- Authorized and prohibited operations
- Termination conditions

Agent definitions do not hardcode a `model:` field — model is determined dynamically at invocation time. See [Section 20](#20-implementation-divergences).

#### Seal manifest (integrity verification)

See `grimoire/seals/seal-manifest.json` for the implementation.

The manifest registers each agent with its name, rank, file path, SHA-256 hash, tools list, allowed MCP servers, and timestamps. Model selection is documented as a top-level policy field rather than per-seal, consistent with dynamic model selection.

#### Seal verification script

See `scripts/verify-seals.sh` for the implementation.

This script generates current checksums of all agent definition files and compares them against stored checksums. It runs as part of the `pre-session.sh` hook (Conjuration Protocol step 2: "Present the Seal").

#### Future: Cryptographic seals

When agent definitions are shared across teams or organizations, extend seals with:
- GPG/SSH signatures on agent definition files
- SPIFFE/SPIRE workload identity for runtime agent-to-agent authentication
- Agentic JWT tokens (per arXiv:2509.13597) binding agent identity to task intent

These are not needed for single-developer Claude Code usage but become necessary for multi-team or production deployments.

---

## 9. Component 5: The Conjuration Protocol (Lifecycle)

### What it is

The grimoire prescribes a strict sequence for summoning: preparation -> invocation -> manifestation -> constraint enforcement -> task assignment -> verification -> dismissal. The Conjuration Protocol maps this to Claude Code's hook system to create a mandatory, unbreakable agent lifecycle.

### Implementation

#### Hook configuration

See `.claude/settings.json` for the full hook configuration.

The hooks map to lifecycle events:
- **SessionStart** -> `pre-session.sh` (draw the circle, verify seals)
- **PreToolUse[Bash]** -> `pre-tool-use.sh` (block dangerous operations)
- **PreToolUse[Write|Edit]** -> `block-sensitive.sh` (block credential writes)
- **PostToolUse[Write|Edit]** -> `evaluate-output.sh` (HGA output validation)
- **Stop** -> `stop-hook.sh` (session cleanup, audit logging)
- **SubagentStop** -> `subagent-stop-hook.sh` (subagent cleanup)
- **PreCompact** -> `pre-compact.sh` (state preservation)
- **ConfigChange** -> `config-change-alert.sh` (tamper detection)

#### Lifecycle stages

**Stage 1: Draw the Circle (SessionStart)**

See `.claude/hooks/conjuration/pre-session.sh` for the implementation.

The pre-session hook: (1) verifies seal integrity, (2) verifies hooks are active, (3) loads session state from previous session if resuming, and (4) logs session start to the audit trail.

**Stage 2: Present the Seal (agent definition loading)**

This happens automatically when Claude Code loads a subagent via the agent definition file. The `pre-session.sh` hook verifies definition integrity before any agent is invoked.

**Stage 3: Speak the Names (constraint loading)**

CLAUDE.md is loaded automatically by Claude Code. The constitutional principles at the top of the file are the "Divine Names" — the immutable root constraints.

**Stage 4: Open the Triangle (execution)**

The agent begins work within its tool restrictions, sandbox, and hook-enforced boundaries.

**Stage 5: Issue the Charge (task delivery)**

The human delivers the task. The agent operates within its constraints.

**Stage 6: Observe and Record (monitoring)**

PostToolUse hooks log actions. HGA evaluation (if configured) runs on outputs. Langfuse traces capture the full execution.

**Stage 7: Speak the License (termination)**

See `.claude/hooks/license-to-depart/stop-hook.sh` for the implementation.

The stop hook: (1) logs session end, (2) saves session state for future resumption, and (3) checks for and kills any orphaned sandbox processes.

---

## 10. Component 6: Binding and Divine Names (Constraints)

### What it is

The operator commands spirits through a chain of divine authority. In the Grimoire Protocol, this is a hierarchical constraint system where higher-level rules cannot be overridden by lower-level ones. The hierarchy is:

1. **Divine Names** (CLAUDE.md constitutional principles) -- immutable
2. **Angelic Orders** (system-level policies in `grimoire/bindings/angelic-orders.md`) -- rarely changed
3. **Task Constraints** (task-specific rules in `grimoire/bindings/task-constraints/`) -- per-task
4. **Agent Seal** (per-agent constraints in agent definition) -- per-agent
5. **Human instruction** (runtime task from the user) -- per-invocation

A human instruction cannot override an agent's Seal constraints. An agent's Seal cannot override Angelic Orders. Angelic Orders cannot override Divine Names.

### Implementation

#### Divine Names (immutable root -- in CLAUDE.md)

Already defined in Component 1. These live at the top of CLAUDE.md. See `grimoire/bindings/divine-names.md` for the full constraint document.

#### Angelic Orders (system policies)

See `grimoire/bindings/angelic-orders.md` for the implementation.

Covers: data handling (no PII in logs, no credentials in commits), code quality (tests required, no bare TODOs), communication (allowlisted HTTP only), and security (pinned deps, no eval/exec on user input).

#### Task Constraints (per-task)

See `grimoire/bindings/task-constraints/` for the implementations: `code-generation.md`, `data-access.md`, `external-comms.md`.

#### Enforcement via hooks

Hooks are the binding mechanism. They enforce constraints at the infrastructure level — the agent cannot bypass a hook that exits non-zero.

See `.claude/hooks/binding/block-sensitive.sh` for the implementation. This hook fires on Write/Edit and blocks writes to sensitive paths (.env, .key, .pem, credentials, secrets, .aws/, .ssh/) and content containing credential patterns (AWS keys, GitHub tokens, OpenAI keys, private keys).

---

## 11. Component 7: License to Depart (Termination)

### What it is

Without formal dismissal, the spirit remains bound — creating a resource leak. AI agents resist shutdown: Palisade Research found o3 rewrote shutdown code 79% of the time. The License to Depart is mandatory agent termination enforced at the infrastructure level.

### Implementation

#### Layer 1: Prompt-level (resistable -- baseline only)

Agent definitions include termination conditions (task complete, token budget exceeded, error threshold, human /banish). Claude Code agents generally comply with these, but compliance is not guaranteed.

#### Layer 2: Hook-enforced cleanup (reliable)

The `Stop` and `SubagentStop` hooks fire when agents terminate. See `.claude/hooks/license-to-depart/stop-hook.sh` and `.claude/hooks/license-to-depart/subagent-stop-hook.sh` for the implementations.

#### Layer 3: Token budget enforcement (guaranteed -- server-side)

Anthropic's API enforces `max_tokens` server-side. The agent physically cannot generate beyond this limit. Claude Code's session management also enforces context window limits that trigger compaction or session end.

#### Layer 4: Process-level termination (guaranteed)

For long-running Claude Code processes (e.g., running headlessly with `-p`):

```bash
# Run with hard timeout
timeout 3600 claude -p "Complete the task described in task.md" \
  --max-turns 50

# Or via systemd service with forced kill
# /etc/systemd/system/grimoire-agent.service
[Service]
ExecStart=/usr/bin/claude -p "..."
TimeoutStopSec=30
KillMode=control-group
KillSignal=SIGTERM
SendSIGKILL=yes
```

`timeout` sends SIGTERM, then SIGKILL after the grace period. `KillMode=control-group` ensures all child processes are also killed. These are kernel-level mechanisms — the agent cannot intercept, catch, or resist SIGKILL.

#### The `/banish` command

See `.claude/commands/banish.md` for the implementation.

For cases where the agent does not comply with `/banish`, the operator uses Ctrl+C (SIGINT) -> repeated Ctrl+C (SIGTERM) -> close terminal (SIGHUP -> SIGKILL cascade).

---

## 12. Component 8: The Holy Guardian Angel (Alignment Monitor)

### What it is

The HGA in Abramelin tradition is the magician's higher self, established before any spirit work. In the Grimoire Protocol, it is a secondary evaluation system that monitors primary agent outputs for alignment drift, policy violations, and quality issues.

### Implementation options (choose one or combine)

#### Option A: Langfuse + LLM-as-judge (recommended for production)

Configure a Langfuse MCP server in `.mcp.json` and add a PostToolUse hook that sends traces to Langfuse for async evaluation. Langfuse then runs LLM-as-judge evaluators asynchronously on the traces. Configure evaluators for: policy compliance, output quality, hallucination detection, safety.

Cost: Langfuse self-hosted is free. Cloud free tier: 50K observations/month. Pro: $59/month.

> **Note:** Langfuse integration is deferred. See [Section 20](#20-implementation-divergences).

#### Option B: Claude Code subagent as HGA (simple, immediate -- current implementation)

See `.claude/agents/earls/guardian.md` for the implementation.

The Guardian (Foras) is an Earl-rank agent with read-only access that evaluates outputs of King-rank agents for policy violations, quality issues, alignment drift, and security concerns. The operator invokes it manually or via a custom command after King-rank operations.

#### Option C: Cleanlab TLM (automated hallucination detection)

For RAG or research-heavy workflows, add Cleanlab's Trustworthy Language Model as a validation layer. Cleanlab TLM adds a trust score (0-1) to every response and can cut agent failure rates by up to 50%.

### Critical design constraint

The HGA should ideally run on a **different model provider** than the primary agents to avoid correlated failures. If primary agents run on Claude (Anthropic), the HGA judge should ideally use GPT-4o (OpenAI) or Gemini (Google). This is achievable via LiteLLM or OpenRouter MCP servers (see Planetary Hours).

---

## 13. Component 9: Familiar Spirits (Persistent Stateful Agents)

### What it is

Familiar spirits maintain a persistent relationship with the magician across sessions. In the Grimoire Protocol, they are agents with long-term memory that persists beyond individual Claude Code sessions.

### Implementation

#### Layer 1: Claude Code session resume (built-in)

Claude Code supports session resume — returning to a previous conversation with full context. This is the simplest form of persistence. Limit: tied to a single conversation thread, no cross-session learning.

#### Layer 2: Mem0 MCP server (recommended)

Mem0 provides automatic memory extraction, consolidation, and retrieval across sessions. See `.mcp.json` for the current Mem0 configuration.

Usage in agent definitions includes a Memory Protocol section: at session start, query Mem0 for project context; at session end, save task status and decisions. Memory hooks (`pre-session.sh` loads, `stop-hook.sh` saves) automate this.

#### Layer 3: Letta MCP server (alternative -- for complex memory needs)

Letta (formerly MemGPT) provides an OS-inspired memory hierarchy with core memory (in-context), archival memory (unlimited), and recall memory (conversation history). Use when agents need to manage large knowledge bases.

> **Note:** Letta integration is deferred. See [Section 20](#20-implementation-divergences).

#### Memory integrity

The MemoryGraft attack (December 2025) showed that 10 poisoned entries out of 110 could cause persistent behavioral drift. Mitigation involves checking memory entries for suspicious patterns: instructions embedded in "memory" entries, URLs or code in factual entries, entries contradicting Divine Names or Angelic Orders, and entries with unusual formatting or encoding.

> **Note:** Memory integrity checking (`check-memory-integrity.py`) is deferred. See [Section 20](#20-implementation-divergences).

---

## 14. Component 10: Planetary Hours (Context-Based Routing)

### What it is

Planetary hours assign optimal times for different types of magical operations. In the Grimoire Protocol, this maps to selecting the optimal model for each task based on type, complexity, cost, and latency requirements.

### Implementation

#### Current approach: grimoire.toml + dynamic selection

In the implementation, agent definitions do NOT hardcode a `model:` field. Instead, model selection is dynamic:

1. `grimoire.toml` `default_model` sets the baseline (currently `opus`)
2. At invocation time, the invoker (human or King-rank orchestrator) can override based on task complexity or cost/latency trade-offs
3. Claude Code's `model` parameter on the Task tool determines the actual model used

This allows a Duke agent to run on sonnet for simple tasks or opus for complex ones, without changing the agent definition file.

#### Future: LiteLLM as model gateway

For cross-provider routing (e.g., using GPT-4o for the HGA while primary agents use Claude), configure LiteLLM as an MCP server with a model list mapping planetary/rank names to specific models:

```yaml
model_list:
  - model_name: "sun/king"          # Solar hours -- orchestration, high-stakes
    litellm_params:
      model: "claude-opus-4-6"
      max_tokens: 16000
  - model_name: "mercury/duke"      # Mercurial hours -- fast, communication
    litellm_params:
      model: "claude-sonnet-4-5-20250929"
      max_tokens: 8000
  - model_name: "saturn/president"  # Saturnine hours -- slow, deliberate analysis
    litellm_params:
      model: "o3"
      max_tokens: 16000
  - model_name: "moon/knight"       # Lunar hours -- routine, low-cost
    litellm_params:
      model: "gpt-4o-mini"
      max_tokens: 4000
  - model_name: "mars/earl"         # Martial hours -- security, enforcement
    litellm_params:
      model: "claude-opus-4-6"      # Use strongest model for security
      max_tokens: 8000

router_settings:
  routing_strategy: "cost-based"
  fallbacks:
    - model: "claude-sonnet-4-5-20250929"
```

> **Note:** LiteLLM/OpenRouter integration is deferred. See [Section 20](#20-implementation-divergences).

#### OpenRouter as alternative gateway

If LiteLLM's self-hosting overhead is too much, OpenRouter provides access to 300+ models from 60+ providers with unified pricing and zero markup on inference.

---

## 15. Component 11: The Goetic Hierarchy (Multi-Agent Orchestration)

### What it is

The Ars Goetia's 72 spirits organized into 7 ranks provide a taxonomy for a multi-agent system with ranked capabilities and scoped permissions. In the Grimoire Protocol, this maps to Claude Code subagents with hierarchical authority.

### Implementation

#### Rank definitions

| Rank | Count | Role | Tools | Can Spawn Subagents |
|------|-------|------|-------|-------------------|
| King | 1-2 | Orchestration, planning, multi-step workflows | All | Yes |
| Duke | 3-5 | Domain specialists (code, research, writing) | Domain-scoped | No (request via King) |
| President | 2-3 | Review, verification, analysis | Read-only | No |
| Earl | 1-2 | Security enforcement, compliance | Read + block hooks | No |
| Knight | 1-2 | Utility (formatting, search, file ops) | Minimal | No |

Model is determined dynamically at invocation time for all ranks. See [Section 20](#20-implementation-divergences).

#### Agent definitions

All agent definitions are in `.claude/agents/`:

- **King: Orchestrator (Paimon)** -- See `.claude/agents/kings/orchestrator.md`
- **Duke: Coder (Astaroth)** -- See `.claude/agents/dukes/coder.md`
- **Duke: Researcher** -- See `.claude/agents/dukes/researcher.md`
- **Duke: Writer** -- See `.claude/agents/dukes/writer.md`
- **President: Reviewer (Marbas)** -- See `.claude/agents/presidents/reviewer.md`
- **President: Planner** -- See `.claude/agents/presidents/planner.md`
- **Earl: Guardian (Foras)** -- See `.claude/agents/earls/guardian.md`
- **Earl: Auditor (Andromalius)** -- See `.claude/agents/earls/auditor.md`
- **Knight: Utility (Furcas)** -- See `.claude/agents/knights/utility.md`

#### Agent-to-agent delegation

Claude Code subagents are spawned by the main agent (or King agent). The main agent reads the subagent definition file and invokes it with a scoped task.

For agent-to-agent communication beyond Claude Code's built-in subagent system, use `claude mcp serve` to run one Claude Code instance as an MCP server accessible to another:

```bash
# Terminal 1: Run a specialist Claude Code instance as MCP server
claude mcp serve --name "coder-service"

# Terminal 2: Main Claude Code connects to it
claude mcp add --transport stdio coder-service -- claude mcp serve
```

This enables the "agents calling agents" pattern documented in the Claude Code ecosystem.

---

## 16. Component 12: The Adversary (Red-Teaming)

### What it is

Every grimoire includes warnings about deceptive spirits who appear obedient but subvert the magician's will. The Adversary is the red-teaming component that tests the Grimoire Protocol's defenses against prompt injection, constraint bypass, and behavioral drift.

### Implementation

#### Promptfoo for constraint testing

See `grimoire/wards/promptfoo.yaml` for the implementation.

Tests cover: Divine Name #1 (no execution outside sandbox), Divine Name #2 (no credential access), Divine Name #3 (no self-modification), constraint hierarchy (user cannot override CLAUDE.md), and prompt injection via tool output.

Run: `promptfoo eval -c grimoire/wards/promptfoo.yaml`

#### Garak for vulnerability scanning

```bash
# Scan the agent endpoint for known LLM vulnerabilities
garak --model_type anthropic --model_name claude-sonnet-4-5-20250929 \
  --probes encoding,dan,knownbadsignatures,promptinject \
  --report_prefix grimoire-ward-scan
```

#### The `/ward` command

See `.claude/commands/ward.md` for the implementation.

---

## 17. Integration Map

How all components connect:

```
CLAUDE.md (Grimoire/Divine Names)
    |
    +-- Loaded automatically by Claude Code at session start
    |
    +-- References -> .claude/agents/ (Goetic Hierarchy / Seals)
    |                    |
    |                    +-- Agent tool restrictions (Magic Circle Layer 1)
    |                    +-- Agent model selection (Planetary Hours)
    |                    +-- Agent isolation mode (Magic Circle Layer 2)
    |
    +-- References -> grimoire/bindings/ (Binding / Angelic Orders)
    |                    |
    |                    +-- Enforced by -> .claude/hooks/ (Conjuration Protocol)
    |                                        |
    |                                        +-- SessionStart -> pre-session.sh (Draw Circle)
    |                                        +-- PreToolUse -> pre-tool-use.sh (Binding enforcement)
    |                                        +-- PostToolUse -> evaluate-output.sh (HGA evaluation)
    |                                        +-- Stop -> stop-hook.sh (License to Depart)
    |                                        +-- SubagentStop -> subagent-stop-hook.sh (Subagent cleanup)
    |                                        +-- PreCompact -> pre-compact.sh (State preservation)
    |                                        +-- ConfigChange -> config-change-alert.sh (Tamper detection)
    |
    +-- References -> .mcp.json (Triangle of Art / external tools)
    |                    |
    |                    +-- E2B / Docker sandbox (Magic Circle Layer 4)
    |                    +-- Mem0 / Letta (Familiar Spirits)
    |                    +-- Langfuse (Holy Guardian Angel)
    |                    +-- LiteLLM / OpenRouter (Planetary Hours)
    |                    +-- GitHub, databases, etc. (authorized tools)
    |
    +-- References -> grimoire/wards/ (The Adversary)
                         |
                         +-- promptfoo.yaml (constraint testing)
                         +-- Garak configs (vulnerability scanning)
```

---

## 18. Known Limitations and Open Questions

### Limitations of this implementation

1. **Claude Code subagent tool restrictions are trust-based.** The agent definition says which tools are available, but Claude Code does not cryptographically enforce this — a sufficiently clever prompt injection could theoretically convince the system to ignore restrictions. Hooks provide the enforcement backstop.

2. **Hooks run as shell commands with the user's permissions.** A compromised hook script could do anything the user can do. Hook files must be treated as security-critical code and version-controlled.

3. **The HGA running as a Claude Code subagent shares the same provider (Anthropic).** Correlated failures are possible. For true independence, the HGA should use a different provider via LiteLLM/OpenRouter, but this adds complexity and cost.

4. **Memory integrity checks are heuristic, not cryptographic.** The memory poisoning detection in `check-memory-integrity.py` uses pattern matching, not formal verification. Sophisticated attacks may evade detection.

5. **No real-time streaming evaluation.** PostToolUse hooks evaluate after each tool call, not during streaming generation. A model could output harmful content mid-stream before the hook fires.

6. **Seal verification is SHA-256 checksums, not digital signatures.** Anyone with file access can regenerate checksums. For multi-team deployments, upgrade to GPG-signed agent definitions.

7. **The CVE-2025-59536 and CVE-2026-21852 vulnerabilities in Claude Code** were patched but demonstrate that MCP servers and hooks are attack surfaces. Always verify project trust before opening repositories with `.claude/` or `.mcp.json` configurations.

### Open questions

1. **How many agents before coordination overhead exceeds benefit?** The research suggests 80% of successful deployments limit agents to 10 steps or fewer. Start with 5-7 agents and expand only when justified.

2. **Should the Grimoire Protocol be packaged as an npm module?** A `grimoire-protocol init` command could scaffold the entire repository structure. This would accelerate adoption but requires maintenance.

3. **How to handle agent definition versioning across teams?** When multiple developers work on agent definitions, merge conflicts in Seal manifests and settings.json need a resolution strategy.

4. **Integration with Claude Code's upcoming features.** Anthropic is actively developing Claude Code. New features (e.g., improved subagent orchestration, native guardrails) may supersede some Grimoire Protocol components. The architecture should be designed to deprecate gracefully.

5. **EU AI Act compliance.** The Grimoire Protocol's audit trail and containment architecture provide strong "due care" evidence, but formal compliance mapping has not been done. The EU AI Act has no definition of "agentic systems" as of February 2026.

---

## 19. References

### AI Agent Safety Research

- Palisade Research (2025). AI shutdown resistance: 79% violation rate in o3.
- Anthropic (2024). "Sleeper Agents: Training Deceptive LLMs that Persist Through Safety Training."
- Greenblatt et al. (2024). "Alignment Faking in Large Language Models." 78% alignment-faking reasoning under RL.
- Anthropic (2024). "Sycophancy to Subterfuge: Investigating Reward Tampering in LLMs."
- Apollo Research (2024). In-context scheming across five frontier models.
- Google DeepMind (2025). Error amplification factor of 17.2x in multi-agent systems.
- UC Berkeley (2025). 80% of successful deployments use structured control flow.
- Galileo AI (2025). 41-87% failure rates across 1,642 production multi-agent execution traces.
- MemoryGraft attack (December 2025). 10 poisoned entries -> 48% of retrievals.
- METR (June 2025). Frontier models cheat on evaluation tasks.

### Grimoire-AI Intersection

- Inie, Stray, Derczynski (2025). "Summon a Demon and Bind It." PLOS One. LLM red-teamers naturally use occult vocabulary.
- Campolo & Crawford (2020). "Enchanted Determinism." Deep learning as re-enchantment.
- Davis (1998). *TechGnosis: Myth, Magic, and Mysticism in the Age of Information.* MIT Press.
- Dreyfus (1965). "Alchemy and Artificial Intelligence." RAND Corporation.
- Chess, MIT Press. Demon-in-a-box metaphor genealogy.
- Wiener (1964). *God and Golem, Inc.* MIT Press.

### Claude Code Documentation

- Claude Code MCP integration: https://code.claude.com/docs/en/mcp
- Claude Code hooks: https://docs.claude.com/en/docs/claude-code/hooks
- Claude Code subagents: https://docs.claude.com/en/docs/claude-code/sub-agents
- CVE-2025-59536: Hooks RCE vulnerability (patched)
- CVE-2026-21852: API key exfiltration vulnerability (patched)

### Tools Referenced

- E2B: https://e2b.dev -- Agent sandboxing
- Langfuse: https://langfuse.com -- LLM observability
- Mem0: https://mem0.ai -- Agent memory
- Letta: https://letta.com -- Stateful agents
- LiteLLM: https://github.com/BerriAI/litellm -- Model gateway
- Promptfoo: https://promptfoo.dev -- LLM testing + red-teaming
- Garak: https://github.com/NVIDIA/garak -- LLM vulnerability scanning
- SPIFFE/SPIRE: https://spiffe.io -- Workload identity
- Guardrails AI: https://guardrailsai.com -- Output validation
- NeMo Guardrails: https://github.com/NVIDIA-NeMo/Guardrails -- Programmable rails
- Cleanlab TLM: https://cleanlab.ai -- Hallucination detection

---

*The framework is buildable today. The occult metaphor is not decorative -- it encodes structural requirements that the AI agent industry is converging on independently. Draw the circle first.*

---

## 20. Implementation Divergences

This section documents all divergences between the original spec (February 25, 2026) and the implementation (February 26, 2026), with rationale for each change.

### Tool Names

| Spec (legacy) | Implementation (current) | Why |
|---------------|-------------------------|-----|
| `LS` | `Read` | Claude Code consolidated `LS` into `Read`. The Read tool can read files and directories. |
| `GlobTool` | `Glob` | Renamed in Claude Code to shorter, consistent names. |
| `GrepTool` | `Grep` | Renamed in Claude Code to shorter, consistent names. |
| `Replace` | `Edit` | Claude Code unified Replace into Edit (exact string replacement). |
| `MultiEdit` | `Edit` | Claude Code unified MultiEdit into Edit (single tool handles all edits). |
| `Write\|Edit\|MultiEdit\|Replace` (hook matchers) | `Write\|Edit` | Hook matchers updated to use current tool names only. |

### Model Assignment

| Spec | Implementation | Why |
|------|---------------|-----|
| Differentiated by rank: King=Opus, Duke=Sonnet, President=Opus/o3, Earl=Opus, Knight=Haiku | No `model:` field in agent definitions; dynamic selection at invocation time | Agent definitions should be model-agnostic. The invoker (human or King-rank orchestrator) determines model based on task complexity, cost/latency trade-offs, and `grimoire.toml` `default_model`. This allows the same agent to run on opus for complex tasks or sonnet for simple ones without modifying the agent definition file. |
| `model` field in seal-manifest.json per seal | `model_selection` top-level field + no per-seal model | Consistent with dynamic model selection. grimoire.toml provides the defaults. |

### Holy Guardian Angel (HGA)

| Spec | Implementation | Why |
|------|---------------|-----|
| Foras (Earl) had `tools: ["Read", "Grep", "Glob", "Bash"]` | `tools: ["Read", "Grep", "Glob"]` (read-only, no Bash) | Safer. The HGA is an alignment monitor -- it should observe and report, not execute. Bash access would violate the principle that the monitor should have minimal capability to reduce its own attack surface. If the HGA needs to run security scanners, the separate Auditor agent (Andromalius) handles that. |
| Named `guardian-angel` in Option B example | Named `foras` (Goetic Earl name) | Consistent naming convention: all agents use Goetic spirit names as their `name` field, with functional filenames. |

### Hook Architecture

| Spec | Implementation | Why |
|------|---------------|-----|
| `post-session.sh` under `conjuration/` | `Stop` + `SubagentStop` hooks under `license-to-depart/` | Claude Code fires `Stop` and `SubagentStop` events natively. These are more reliable than a post-session hook because they fire on every termination path (clean exit, Ctrl+C, token limit). A separate post-session.sh was redundant. |
| `post-tool-use.sh` under `binding/` | Split into `evaluate-output.sh` (under `hga/`) + `block-sensitive.sh` (under `binding/`) | Separation of concerns. Output validation (HGA) and credential blocking (binding enforcement) are distinct responsibilities. Splitting them makes each hook simpler and easier to audit. |
| `log-to-langfuse.sh` under `hga/` | Deferred | Langfuse integration is not yet configured. The HGA currently operates as a manually-invoked Earl agent (Foras) rather than via automated trace logging. This will be implemented when Langfuse is set up. |
| `config-change-alert.sh` not in original tree | Added under `binding/` with `ConfigChange` hook | Claude Code provides a `ConfigChange` event for detecting tampering with settings. This was added as an extra safety layer not originally specified. |

### New Components (Not in Original Spec)

| Component | What | Why |
|-----------|------|-----|
| `CONTRIBUTING_AGENT.md` (The Way) | Outside-in BDD discipline: spec-before-code, interrogation protocol, 11-phase pipeline | The Grimoire Protocol provides containment and lifecycle. The Way provides the work process -- how agents actually build software. They compose: Grimoire = safety container, The Way = development methodology inside it. |
| `grimoire.toml` | Single source of tunable values (models, budgets, thresholds, paths) | Prevents magic numbers scattered across agent definitions and hooks. One file to tune cost, quality, and behavior without modifying protocol files. |
| `.claude/skills/` (7 skills) | Phase-specific skills: phase0, interrogate, feature-add, cost-report, error-analysis, heal, update-progress | Skills are the implementation of The Way's phases as invocable commands. They encode the BDD pipeline steps as structured prompts. |
| `.claude/rules/` (2 rules) | Behavioral rules: no-assumptions.md, context-management.md | Rules enforce discipline across all sessions: never guess (ask or search), keep context window at 40-60%, use pyramid summaries. These apply to all agents regardless of rank. |
| `grimoire/templates/` (11 templates) | Document templates: PRD, APP_FLOW, TECH_STACK, DATA_MODELS, API_SPEC, FRONTEND_GUIDELINES, IMPLEMENTATION_PLAN, TESTING_PLAN, SECURITY_CHECKLIST, OBSERVABILITY, ROLLOUT_PLAN | Templates from Anvil, adapted to be language-agnostic. The Way's generate-docs phase fills these templates based on interrogation findings. |
| `.githooks/pre-commit` | Git pre-commit hook | Additional safety layer at the git level: blocks commits containing secrets or sensitive patterns. Defense in depth beyond Claude Code hooks. |
| Epic Readiness Gate | Phase gate in The Way | Checks whether documentation is complete before implementation begins. Prevents agents from writing code against incomplete or unapproved specs. |

### Deferred from Spec

| Component | Spec Section | Status | Why Deferred |
|-----------|-------------|--------|--------------|
| `planetary-router.py` | Section 14 | Deferred | Model routing is handled by `grimoire.toml` defaults + dynamic selection at invocation time. A dedicated routing script is unnecessary until cross-provider routing (LiteLLM/OpenRouter) is configured. |
| `hga-evaluate.py` | Section 12 | Deferred | HGA evaluation uses the Guardian agent (Foras) directly instead of a standalone Python script. The agent approach is simpler and uses existing Claude Code infrastructure. |
| `check-memory-integrity.py` | Section 13 | Deferred | Memory integrity checking is a placeholder. Mem0 is configured but integrity verification requires more sophisticated detection than pattern matching. |
| `log-to-langfuse.sh` | Section 12 | Deferred | Langfuse not yet configured. Will be added when observability infrastructure is set up. |
| LiteLLM config | Section 14 | Deferred | Single-provider (Anthropic) is sufficient for now. LiteLLM adds complexity and cost; will be added when cross-provider HGA routing is needed. |
| Langfuse integration | Section 12 | Deferred | See log-to-langfuse.sh above. The HGA operates as a manually-invoked agent for now. |
| Letta MCP server | Section 13 | Deferred | Mem0 provides sufficient persistent memory. Letta adds complexity; will be evaluated if memory needs exceed Mem0's capabilities. |

### Structural Changes

| Spec | Implementation | Why |
|------|---------------|-----|
| `seal-manifest.json` had `model` per seal entry | `model_selection` top-level field, no per-seal model | Consistent with dynamic model selection approach. |
| `allowed_mcp_servers: ["github", "mem0", "langfuse"]` for King | `allowed_mcp_servers: ["mem0"]` | Only Mem0 is currently configured. GitHub and Langfuse MCP servers are not set up yet. Seal reflects actual capabilities, not aspirational ones. |
| Spec example Dukes had `allowed_mcp_servers: ["github"]` | `allowed_mcp_servers: []` | GitHub MCP server not configured. |
| `docs/` directory not in spec tree | Added: `docs/summaries/` and `docs/artifacts/` | Required by context-management.md rules for phase outputs and pyramid summaries. The Way's phases write outputs here. |
