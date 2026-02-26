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
3. **Review the interrogation.** LLM-as-Judge with position bias mitigation (dual-pass). Score each section. Must pass to proceed.
4. **Generate documentation.** Fill all applicable templates from `grimoire/templates/`. One at a time. Write output, release from context. Every feature in the PRD must have acceptance criteria in Given/When/Then form.
5. **Review the documentation.** LLM-as-Judge again. Must pass to proceed.
6. **Write executable specifications.** Translate acceptance criteria into the project's test framework (Gherkin features, test cases, or equivalent). Run them and confirm they fail. This is the red phase.
7. **Generate holdout scenarios.** Adversarial tests written in complete isolation from the implementation agent. Written to holdout directory. These are the hidden specifications.
8. **Implement.** Step by step from `IMPLEMENTATION_PLAN.md`. Write only the code required to make the specifications pass. This is the green phase. Verify each step. Retry up to 3 times. Commit after each verified step.
9. **Refactor.** Only while all specifications remain green.
10. **Holdout validation.** Run implementation against the hidden scenarios. Gate: must pass with zero anti-pattern flags.
11. **Security audit.** Scan for OWASP top 10, hardcoded secrets, insecure defaults. Gate: zero BLOCKERs.
12. **Ship.** Final test suite, PR creation, recording.

Skipping steps is corruption of the process.

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
| Interrogation review | LLM-as-Judge pass | ITERATE or BLOCK |
| Doc review | LLM-as-Judge pass | ITERATE |
| Verify | PASS/FAIL | Retry up to 3 times, then BLOCK |
| Holdout validation | Pass + zero anti-patterns | Route back to implement |
| Security audit | Zero BLOCKERs | Auto-fix, then re-audit |
| Ship | All green | Create PR |

All review gates use LLM-as-Judge with position bias mitigation:
- Dual-pass evaluation (normal order + reversed order)
- Stricter verdict wins when passes disagree

## Circuit Breakers

The pipeline protects itself from runaway cost and infinite loops.

- **Kill switch:** Create `.pipeline-kill` to halt immediately.
- **Per-phase turn limits:** `[turns]` section in grimoire.toml.
- **Stagnation detection:** similar errors across retries triggers reroute.

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

This is The Way.
