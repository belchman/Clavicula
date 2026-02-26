#!/bin/bash
# Grimoire Protocol — State preservation before context compaction
# Fires on PreCompact. Saves current state so context can be restored.

set -euo pipefail

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"
SUMMARIES_DIR="$GRIMOIRE_ROOT/docs/summaries"
LOGS_DIR="$GRIMOIRE_ROOT/grimoire/logs"

mkdir -p "$SUMMARIES_DIR" "$LOGS_DIR"

# Log compaction event
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) PRE_COMPACT" >> "$AUDIT_LOG"

# Save session state for resumption after compaction
cat > "$LOGS_DIR/last-session-state.json" << STATEEOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "compacting",
  "note": "Context compaction in progress. Agent should read docs/summaries/ and PROGRESS.md to restore context."
}
STATEEOF

echo "State preserved for post-compaction recovery."
