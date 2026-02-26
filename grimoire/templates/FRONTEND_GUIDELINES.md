# Frontend Guidelines

## Overview

## Design System
### Colors
### Typography
### Spacing

## Component Architecture

### Component Categories
- **Layout Components:**
- **UI Components:**
- **Feature Components:**
- **Page Components:**

## State Management

| Category | Scope | Examples | Tool |
|----------|-------|----------|------|
| UI State | Component | open/closed | Local state |
| Server State | Global | API responses | Data fetching library |
| URL State | Global | route params | Router |

## Routing

| Route Type | Pattern | Guard |
|-----------|---------|-------|
| Public | /login | Redirect if authed |
| Protected | /dashboard | Redirect if not authed |

## Accessibility
- Minimum WCAG level:
- Keyboard navigation:
- ARIA patterns:

## Performance
- Bundle size budget:
- Code splitting strategy:

## Error Handling

| Category | Example | Recovery |
|----------|---------|----------|
| Network | Timeout | Retry with backoff |
| Auth | 401 | Redirect to login |
| Server | 500 | Show fallback UI |

## Related Documents
- **Feeds into:** [IMPLEMENTATION_PLAN.md](IMPLEMENTATION_PLAN.md)
- **Informed by:** [APP_FLOW.md](APP_FLOW.md)
