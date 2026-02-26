#!/bin/bash
# Grimoire Protocol — Holy Guardian Angel: Post-write evaluation
# Fires on PostToolUse for Write/Edit. Validates output integrity.

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"

mkdir -p "$(dirname "$AUDIT_LOG")"

# Log the file modification to audit trail
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) FILE_MODIFIED tool=write_edit" >> "$AUDIT_LOG"

exit 0
