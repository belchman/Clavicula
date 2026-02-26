#!/bin/bash
# Grimoire Protocol — Binding: Configuration Change Alert
# Fires on ConfigChange. Detects modifications to protocol configuration files.

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"

mkdir -p "$(dirname "$AUDIT_LOG")"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) CONFIG_CHANGE detected" >> "$AUDIT_LOG"
echo "WARNING: Grimoire Protocol configuration has been modified."
echo "Verify that changes to settings.json, grimoire.toml, or .mcp.json are intentional."

# Do not block — just alert. Config changes require human action per Divine Name #3.
exit 0
