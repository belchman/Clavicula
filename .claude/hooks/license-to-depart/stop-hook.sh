#!/bin/bash
# Grimoire Protocol — License to Depart: Session cleanup
# Fires on Stop. Ensures clean termination and state preservation.

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"
LOGS_DIR="$GRIMOIRE_ROOT/grimoire/logs"

mkdir -p "$LOGS_DIR"

echo "═══ GRIMOIRE PROTOCOL: LICENSE TO DEPART ═══"

# 1. Log session end
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) SESSION_STOP" >> "$AUDIT_LOG"

# 2. Save session state for future resumption
cat > "$LOGS_DIR/last-session-state.json" << STATEEOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "status": "clean_exit"
}
STATEEOF

# 3. Check for orphaned processes
if pgrep -f "e2b|docker.*grimoire-sandbox" > /dev/null 2>&1; then
  echo "WARNING: Orphaned sandbox processes detected."
fi

echo "═══ SPIRIT DEPARTED. CIRCLE CLOSED. ═══"
