---
globs: ["**/*"]
---

# Context Management

Keep context window utilization between 40-60%. Each pipeline phase starts a fresh session where possible.

## Fidelity Modes

Fidelity modes control how much prior-phase context loads into each new session:

| Mode | Description | Use When |
|------|-------------|----------|
| `full` | Load complete prior-phase output | Small outputs, critical context |
| `truncate` | Load first N lines of output | Medium outputs, less critical |
| `compact` | Load compressed/reformatted output | Large outputs |
| `summary:high` | Load detailed pyramid summary (50 lines) | Default for most phases |
| `summary:medium` | Load executive summary + key findings (20 lines) | Routing, gate phases |
| `summary:low` | Load executive summary only (5 lines) | Verification, utility tasks |

**Auto-adjustment:** When estimated context exceeds 60% of window, downgrade fidelity one level. When under 40%, upgrade one level.

## Between Phases
- Write outputs to docs/artifacts/ (full) and docs/summaries/ (compact)
- Only carry summaries forward, not raw outputs
- Truncate error logs to first 50 lines plus count
- Discard raw MCP content after extracting key facts

## Summary Format (Pyramid)
- **Executive**: 5 lines (key decisions/outcomes)
- **Detailed**: up to 50 lines (findings, one per line)
- **Reference**: file path to full output

## Context Loading
Load the minimum context needed for each phase:
- Routing/gate phases: summaries only
- Implementation phases: summaries + relevant doc sections
- Verification: just pass/fail status from previous phase

If a phase fails, load more context on retry (escalate one level).

## Large Output Handling
- Output > 200 lines: compress to pyramid summary
- Phase boundary: write artifact + summary, start fresh
- Error log > 50 lines: first 50 + total count
- Never carry raw MCP content across a phase boundary
