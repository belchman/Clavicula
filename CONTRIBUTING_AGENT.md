# THE WAY

This repository is governed by The Way.
The Way is not a suggestion. It is the prescribed order of creation.
All work must pass through its forms.
This is The Way.

Deviation from The Way offends the discipline that makes autonomous pipelines reliable. Shortcuts produce hallucinations, wasted cost, and broken gates. Every sin against The Way is a pipeline that ships bugs.

## The Sacrament of Specification

The pipeline is the instrument of record. Nothing exists until it is interrogated, documented, and gated.

Work begins in interrogation, not in code.
Code without documentation is disorder.

Every change must be:
- Interrogated.
- Documented.
- Holdout-tested.
- Verified.
- Shipped through gates.

If it did not pass the gates, it did not happen.

## The Single Source of Truth

`grimoire.toml` is the one configuration. All thresholds, timeouts, models, budgets, and paths live there. Consumers read from it. Nothing is hardcoded in skills or prompts when a config variable exists.

Direct manipulation of magic numbers is strictly forbidden:
- Do not hardcode thresholds in hook scripts
- Do not embed directory paths in prompt strings when config variables exist
- Do not duplicate defaults across files
- All tunable values must pass through `grimoire.toml`

## Running The Way

Interactive mode:

```bash
claude
# then: /phase0 -> follow prompts
```

Feature shortcut:

```bash
claude
# then: /feature-add "description"
```

Conjure a specific agent:

```bash
claude
# then: /conjure paimon "Complete the task described in task.md"
```

## The Order of Phases

All work is structured.

The pipeline flows through phases in strict order:
`phase0` → `interrogate` → `interrogation-review` → `generate-docs` → `doc-review` → `write-specs` → `holdout-generate` → `implement` → `holdout-validate` → `security-audit` → `ship`

Phase ordering is sacred. It is not to be altered without updating all consumers.

Structure is not bureaucracy. Structure is memory.

## The Cognitive Framework

There is one discipline.

Outside-in Behavior-Driven Development.

The specification is the product.
Documentation defines the behavior contract.
Implementation code exists only to make failing specifications pass.
Holdout scenarios exist to catch what the spec forgot.

This is the first principle.

Non-negotiable laws:
- Begin with intent, not internals.
- Describe behavior in English first.
- Translate behavior into executable specifications (Gherkin, test cases, or holdout scenarios).
- Run the specifications and watch them fail.
- Write only the code required to make them pass.
- Refactor only while all specifications remain green.
- Every behavior must be specified, implemented, and verified.
- No gate may be skipped.
- Specifications describe observable behavior only. They must not describe internal structure.
- Assumptions must be tagged: `[ASSUMPTION: rationale]` with confidence level.

If behavior cannot be observed, it is not behavior.
If a requirement cannot be verified, it is not a requirement.

## The Rite of Specification

Every feature must have executable specifications before implementation begins.

When the target project supports a test framework, specifications take the form of Gherkin features:

```gherkin
Feature: Session logout
  Scenario: User logs out successfully
    Given an authenticated user session
    When the user clicks the logout button
    Then the session token is invalidated
    And the user is redirected to the login page
```

When the target project does not use Gherkin, specifications take the form of test cases written in the project's test framework, following the Given/When/Then structure as comments or assertions.

When neither is applicable (e.g., infrastructure or pipeline work), holdout scenarios serve as the specification mechanism.

The form may vary. The discipline does not.

100% specification coverage is mandatory. Every behavior must be specified. Every specification must pass.

Green is peace. Red is unfinished.

## The Epic Readiness Gate

Epics represent new features. Before an Epic may advance to "Ready" status, it must satisfy the following gate:

Given that there is an Epic representing a new feature,
When we want to advance that feature to the "Ready" status,
Then the Epic must include a PR-FAQ document explaining the feature from the outside-in,
And the Epic must include at least one Story,
And all Story issues in the Epic must include at least some valid Gherkin specification code.

### PR-FAQ Requirement

Every Epic must have a PR-FAQ (Press Release / Frequently Asked Questions) document. The PR-FAQ describes the feature as if announcing it to the world:

1. **Press Release**: A concise statement of what the feature does, who it benefits, and why it matters. Written in the voice of the end user, not the developer.
2. **FAQ — Customer**: Questions a user would ask about the feature. Answers clarify scope, behavior, and limitations.
3. **FAQ — Internal**: Questions the team would ask. Answers address technical approach, risks, dependencies, and trade-offs.

The PR-FAQ is written before any specification or implementation work begins. It is the outside-in anchor that prevents scope drift and ensures the feature serves a real need.

PR-FAQ documents are stored in `docs/artifacts/pr-faq-[epic-slug].md`.

### Story Gherkin Requirement

Every Story within an Epic must include valid Gherkin specification code. This is not optional. Stories without Gherkin are not Ready.

Gherkin in a Story defines the acceptance criteria in executable form:
- Each Story has at least one `Feature:` block
- Each Feature has at least one `Scenario:` with `Given/When/Then` steps
- Scenarios cover the happy path and at least one error/edge case

When auto-detecting the PM tool:
- **Beads** (`bd`): PR-FAQ and Gherkin are stored in the Epic and Story issue bodies
- **Kanbus** (`kbs`): PR-FAQ and Gherkin are stored in issue content files
- **GitHub Issues** (`gh`): PR-FAQ and Gherkin are stored in issue descriptions

## The Interrogation Ritual

When asked to build or change behavior, follow this sequence. It is not optional.

1. **Phase 0: Context Scan.** Scan git state, project type, PM tool, TODOs, test status, blockers, Grimoire integrity. Write summary to `docs/summaries/`.
2. **Interrogate.** Execute all 13 sections of the interrogation protocol. Search MCP sources first, infer second, assume last. Tag every assumption. Capture intent as user stories: _As a \<role\>, I want \<capability\>, so that \<benefit\>._
3. **Review the interrogation.** LLM-as-Judge with position bias mitigation (dual-pass). Score each section. Gate: `>= threshold_pass` (from grimoire.toml) to proceed.
4. **Generate documentation.** Fill all applicable templates from `grimoire/templates/`. One at a time. Write output, release from context. Every feature in the PRD must have acceptance criteria in Given/When/Then form.
5. **Review the documentation.** LLM-as-Judge again. Gate: `>= threshold_pass` to proceed.
6. **Write executable specifications.** Translate acceptance criteria into the project's test framework (Gherkin features, test cases, or equivalent). Run them and confirm they fail. This is the red phase.
7. **Generate holdout scenarios.** Adversarial tests written in complete isolation from the implementation agent. Written to holdout directory. These are the hidden specifications.
8. **Implement.** Step by step from `IMPLEMENTATION_PLAN.md`. Write only the code required to make the specifications pass. This is the green phase. Verify each step. Retry up to `max_verify_retries` (from grimoire.toml). Commit after each verified step.
9. **Refactor.** Only while all specifications remain green.
10. **Holdout validation.** Run implementation against the hidden scenarios. Gate: `>= threshold_holdout` and zero anti-pattern flags.
11. **Security audit.** Scan for OWASP top 10, hardcoded secrets, insecure defaults. Gate: zero BLOCKERs.
12. **Ship.** Final test suite, PR creation, recording.

Skipping steps is corruption of the process.

## Roles in the Order

**Phase 0** establishes ground truth about the project.

**Interrogation** captures intent. It produces user stories and requirements. Every section must be addressed.

**Documentation** translates interrogation into the behavior contract. Acceptance criteria define what must happen, in Given/When/Then form.

**Specifications** are the executable form of the contract. They must fail before implementation begins (red). They must pass after implementation (green). They describe observable behavior only.

**Holdout scenarios** are adversarial specifications. They test what the contract forgot. They are written in isolation and never shown to the implementing agent.

**Implementation** serves the specifications. It may not invent behavior beyond what is specified. It writes only the code required to turn red to green.

**Verification** proves the implementation satisfies its step. It is mechanical and impartial.

**Security audit** restores trust boundaries that implementation may have violated.

**Ship** records the outcome and publishes it for review.

## The Rite of Holdout

Every pipeline must generate holdout scenarios before implementation begins.

Holdout scenarios must:
- Test behavior IMPLIED but not explicitly stated
- Cover cross-feature interactions
- Test boundary conditions
- Validate security assumptions
- Check for reward-hacking anti-patterns (hardcoded returns, missing validation)

The implementing agent never sees the holdouts.
The holdout validator never sees the implementation prompts.
This separation is required.

Without holdouts, there is no alignment between intent and implementation.

## Gate Discipline

Gates are the checkpoints of The Way. They are not optional.

| Gate | Threshold | Failure Action |
|------|-----------|----------------|
| Epic Readiness | PR-FAQ + Stories + Gherkin | BLOCK until satisfied |
| Interrogation review | `threshold_pass` | ITERATE or BLOCK |
| Doc review | `threshold_pass` | ITERATE |
| Verify | PASS/FAIL | Retry up to `max_verify_retries`, then BLOCK |
| Holdout validation | `threshold_holdout` + zero anti-patterns | Route back to implement |
| Security audit | Zero BLOCKERs | Auto-fix, then re-audit |
| Ship | All green | Create PR |

All review gates use LLM-as-Judge with position bias mitigation:
- Dual-pass evaluation (normal order + reversed order)
- Stricter verdict wins when passes disagree

Satisfaction scoring uses grimoire.toml thresholds, not magic numbers.

## Circuit Breakers

The pipeline protects itself from runaway cost and infinite loops.

- **Kill switch:** Create `.pipeline-kill` to halt immediately.
- **Cost ceiling:** `max_session_cost` (grimoire.toml) stops the pipeline if exceeded.
- **Per-phase limits:** `[turns]` and `[budget]` sections in grimoire.toml.
- **Stagnation detection:** `>= stagnation_similarity` similar errors across retries triggers reroute.

Circuit breakers are not paranoia. They are discipline.

## Context Discipline

Context is finite. Treat it as a budget.

**Fidelity modes** control how much prior-phase context loads into each new session:
- `full` | `truncate` | `compact` | `summary:high` | `summary:medium` | `summary:low`

**Compaction rules:**
- Output > 200 lines: compress to pyramid summary
- Phase boundary: write artifact + summary, start fresh
- Error log > 50 lines: first 50 + count
- Never carry raw MCP content across a phase boundary

Large outputs go to `docs/artifacts/` (Tier 3), not conversation.

## Assumptions Policy

**Interactive mode:** Never guess. ASK.

**Autonomous mode:**
1. SEARCH first: query all MCP sources and codebase
2. INFER second: use codebase patterns and conventions
3. ASSUME last: mark with `[ASSUMPTION: rationale]` and confidence (HIGH/MEDIUM/LOW)

LOW confidence assumptions on critical topics (auth, compliance, data retention) must be flagged as `[NEEDS_HUMAN]` rather than assumed.

"I think" and "probably" are red flags. Replace with "I need to confirm."

## Auto-Detection

The Grimoire Protocol is language-agnostic. At phase 0, auto-detect:

**Project language/framework:**
- `package.json` → Node.js (check dependencies for framework)
- `pyproject.toml` / `requirements.txt` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust
- `pom.xml` / `build.gradle` → Java/Kotlin

**Project management tool:**
- `.beads/` → Beads (use `bd` commands)
- `project/issues/` → Kanbus (use `kbs` commands)
- `.git/` with remote → GitHub Issues (use `gh` commands)

**Test framework:**
- Auto-detect from project config and use for specification format
- Gherkin if supported, test cases otherwise, holdouts as fallback

**Spec format:**
- Gherkin features when test framework supports them
- Test cases in project's native test framework otherwise
- Holdout scenarios for infrastructure/pipeline work

## Portability

Non-negotiable portability rules:
- No `grep -oP` (PCRE is not portable to macOS/BSD). Use `grep -E` or shell builtins.
- No hardcoded paths when config variables exist in grimoire.toml.
- TTY-aware colors: wrap ANSI codes in `if [ -t 1 ]` checks.
- All config in `grimoire.toml`, not scattered across files.

## Commit Discipline

- Commit after each verified implementation step.
- Commit messages follow conventional format: `feat(step-id): title`, `fix(security): description`.
- Never commit secrets, credentials, or `.env` files.
- The human user is the sole author. Claude is never listed as co-author.

## The Grimoire Protocol

The Way operates within the Grimoire Protocol. The Grimoire provides containment and lifecycle management. The Way provides the work process.

- Agents are conjured per the Conjuration Protocol (CLAUDE.md)
- Agent permissions are defined in `.claude/agents/` (Seals)
- Constraints are layered: Divine Names > Angelic Orders > Task Constraints > Agent Seal
- All actions are logged to `grimoire/logs/audit.log`
- Seal integrity is verified on session start

The Way governs HOW work is done.
The Grimoire governs WHO does it and WHAT they are permitted to do.

## Example: Adding a Feature

Even the smallest feature must pass through The Way.

No code precedes specification.
No specification precedes documentation.
No documentation precedes interrogation.
No implementation precedes failure.

User request: "Add a logout button."

1. `/phase0` — Scan project state. Detect language, framework, PM tool.
2. `/interrogate` — Capture the intent: _As an authenticated user, I want to log out, so that my session is terminated and credentials are cleared._ Where does the button go? What happens on click? What API endpoint? Session cleanup? Token invalidation?
3. Review the interrogation output. Gate it.
4. Generate docs: update PRD, APP_FLOW, API_SPEC, IMPLEMENTATION_PLAN. The PRD includes acceptance criteria:
   ```gherkin
   Feature: User logout
     Scenario: Successful logout
       Given an authenticated user on any page
       When the user clicks the logout button
       Then the session token is invalidated
       And the user is redirected to the login page

     Scenario: Logout with expired session
       Given a user whose session has already expired
       When the user clicks the logout button
       Then the user is redirected to the login page
       And no error is displayed
   ```
5. Review the docs. Gate them.
6. Write executable specs from the acceptance criteria. Run them. Watch them fail. This is correct.
7. Generate holdout scenarios: What if the user clicks logout twice rapidly? What if there's no network? What if a background request carries the old token after logout?
8. Implement step by step. Write only the code that makes the failing specs pass. Verify each step.
9. Refactor while all specs remain green.
10. Validate against holdouts.
11. Security audit: Does logout actually clear tokens? Are there dangling sessions?
12. Ship.

This is The Way.
