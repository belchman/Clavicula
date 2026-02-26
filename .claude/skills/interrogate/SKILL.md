---
name: interrogate
description: "13-section interrogation protocol. Supports INTERACTIVE (ask human) and AUTONOMOUS (search/infer/assume) modes."
allowed-tools: Read, Write, Bash, Glob, Grep, WebSearch, WebFetch
---

# Interrogation Protocol

Comprehensive requirements gathering across 13 sections. This is the CORE of The Way.

## Mode Detection
- **INTERACTIVE** (default): Ask the human each question. Wait for answers. Confirm MCP-sourced data.
- **AUTONOMOUS** (when explicitly requested or running headlessly): No human available. For each question: SEARCH MCP/codebase → INFER from patterns → ASSUME with [ASSUMPTION] tags.

## Pre-Interrogation
1. Read `docs/summaries/phase0-summary.md` for project context
2. Read any existing docs in `docs/` that may already answer questions
3. If resuming, read `docs/artifacts/interrogation-*.md` for prior transcript

## The 13 Sections

### Section 1: Problem Statement & User Stories
- What problem does this solve? Who has this problem?
- Current workaround (if any)?
- 3-5 user stories: "As a [persona], I want [action], so that [benefit]"
- MVP scope? Explicitly OUT of scope?

### Section 2: Target Users / Personas
- Primary and secondary users?
- Technical skill level?
- Devices/platforms?
- Usage frequency?

### Section 3: Functional Requirements
- Every feature (numbered), with: input, processing, output, error states
- Critical user flows (happy path)
- Edge cases per flow

### Section 4: Non-Functional Requirements
- Performance targets (p50/p95/p99 latency)
- Scale (users, data volume, growth)
- Availability (uptime SLA, RTO/RPO)
- Accessibility (WCAG, i18n)

### Section 5: Technical Stack & Constraints
- Languages, frameworks, versions
- Databases and rationale
- External services/APIs
- Deployment target
- Mandated tools or libraries

### Section 6: Data Model & Storage
- Core entities and relationships
- Storage engine choice
- Data lifecycle (create, update, delete, archive)
- Migration strategy
- Volume estimates

### Section 7: API Design / Integration Points
- API style (REST, GraphQL, gRPC, WebSocket)
- Auth method for consumers
- Rate limiting and quotas
- Key endpoints with request/response shapes

### Section 8: Authentication & Authorization
- Auth provider
- Session management
- Role model (RBAC, ABAC, ACL)
- Multi-tenancy

### Section 9: Error Handling & Edge Cases
- Error taxonomy
- Retry strategy
- Graceful degradation
- User-facing error messages

### Section 10: Testing Strategy
- Coverage targets
- Integration test scope
- E2E scenarios
- Test data strategy

### Section 11: Deployment & Infrastructure
- Pipeline stages and gates
- Environment tiers
- IaC approach
- Secrets management
- Rollback procedure

### Section 12: Security & Compliance
- Compliance requirements
- Data classification
- Encryption strategy
- Audit logging
- Incident response

### Section 13: Success Metrics & Acceptance Criteria
- Quantitative success metrics
- Acceptance criteria per user story (Given/When/Then)
- Monitoring/dashboards needed
- Definition of "done"

## Post-Interrogation

### Write Transcript
Write to: `docs/artifacts/interrogation-[date].md`

Format each section as:
```
## Section N: [Title]
### Q: [question]
**A:** [answer]
**Source:** [human | codebase:path/to/file | ASSUMPTION:rationale]
**Confidence:** [HIGH | MEDIUM | LOW] (autonomous mode only)
```

### Generate Pyramid Summary
Write to: `docs/summaries/interrogation-summary.md`

**Executive (5 lines):**
1. Core problem
2. Primary user persona
3. Tech stack
4. Key constraint or risk
5. MVP scope

**Detailed (50 lines):**
- All requirements, one per line, numbered, grouped by section

**Assumptions:**
- All [ASSUMPTION] items with confidence level
- All [NEEDS_HUMAN] items
- All [DRAFT_SPEC] items
