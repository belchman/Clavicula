---
name: cost-report
description: "Show cost report for pipeline runs."
allowed-tools: Read, Bash, Glob
---

# Cost Report

Analyze historical pipeline run costs and provide actionable insights.

## Process

### Step 1: Discover Runs
Find all pipeline run directories:
```
docs/artifacts/pipeline-runs/*/costs.json
```
If no runs exist, report "No pipeline runs found" and exit.

### Step 2: Parse Each Run
For each `costs.json`, extract:
- **Date**: from directory name
- **Status**: from `checkpoint.json`
- **Phases**: array of {name, cost, turns}
- **Total cost**: sum of phase costs
- **Total turns**: sum of phase turns

### Step 3: Per-Run Report
Output a table for each run:
```
## Run: [date] | Status: [status]
| Phase              | Cost    | Turns | $/Turn |
|--------------------|---------|-------|--------|
| phase0             | $0.42   | 8     | $0.05  |
| ...                |         |       |        |
| **Total**          | $12.50  | 142   | $0.09  |
```

### Step 4: Cross-Run Summary
If multiple runs exist, aggregate metrics.

### Step 5: Cost Optimization Insights
Flag:
- Phases using > 30% of budget
- High turn counts with low output (stagnation)
- Runs that hit cost ceiling

## Output Format
Print full report to terminal. Read-only analysis — no files written.
