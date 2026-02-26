#!/bin/bash
# Grimoire Protocol — License to Depart: Subagent cleanup
# Fires on SubagentStop. Logs subagent termination.

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"

mkdir -p "$(dirname "$AUDIT_LOG")"

AGENT_NAME="${AGENT_NAME:-unknown}"

# Log subagent stop
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) SUBAGENT_STOP agent=$AGENT_NAME" >> "$AUDIT_LOG"

# Kill any sandbox containers this agent may have spawned
if command -v docker &> /dev/null; then
  docker ps -q --filter "label=grimoire-agent=$AGENT_NAME" 2>/dev/null | xargs -r docker kill 2>/dev/null || true
fi
