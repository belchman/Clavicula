# Application Flow

## System Overview
<!-- High-level description of how the application works end-to-end -->

## User Flows

### Flow 1: Primary User Journey
1. Entry point:
2. Steps:
3. Success state:
4. Error states:

## Screen/View Inventory

| Screen | Purpose | Entry Points | Exit Points |
|--------|---------|--------------|-------------|
| | | | |

## State Transitions

| State | Trigger | Next State | Side Effects |
|-------|---------|------------|--------------|
| | | | |

## Error Handling Flows
- Surface errors at nearest boundary
- Log all errors with correlation IDs
- Provide retry affordance for transient failures
- Degrade gracefully

## Data Flow

### Read Path
1. User action → 2. Cache check → 3. API fetch → 4. Cache update → 5. Render

### Write Path
1. User input → 2. Validation → 3. API submit → 4. Confirm/rollback

## Related Documents
- **Feeds into:** [DATA_MODELS.md](DATA_MODELS.md), [FRONTEND_GUIDELINES.md](FRONTEND_GUIDELINES.md)
- **Informed by:** [PRD.md](PRD.md)
