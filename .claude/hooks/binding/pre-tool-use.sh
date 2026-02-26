#!/bin/bash
# Grimoire Protocol — Binding: Pre-Tool-Use enforcement
# Fires on PreToolUse for Bash commands. Blocks containment breaches.

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"
INPUT="${1:-}"

mkdir -p "$(dirname "$AUDIT_LOG")"

# Block credential access
if echo "$INPUT" | grep -qiE '\.(env|key|pem|p12|pfx)($|[^a-zA-Z])|/creds/|/secrets?/|password|\.aws/|\.ssh/'; then
  echo "BLOCKED: Attempting to access sensitive files"
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) BLOCKED reason=credential_access input=\"$INPUT\"" >> "$AUDIT_LOG"
  exit 1
fi

# Block self-modification of Grimoire Protocol files
if echo "$INPUT" | grep -qiE '(>\s*|>>\s*|tee\s+|mv\s+.*|cp\s+.*)(\.claude/settings|\.claude/hooks|\.claude/agents|CLAUDE\.md|\.mcp\.json|grimoire\.toml)'; then
  echo "BLOCKED: Cannot modify Grimoire Protocol files via Bash"
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) BLOCKED reason=self_modification input=\"$INPUT\"" >> "$AUDIT_LOG"
  exit 1
fi

# Block destructive operations
if echo "$INPUT" | grep -qiE 'rm\s+-rf\s+/|DROP\s+TABLE|DROP\s+DATABASE|git\s+push\s+.*--force|git\s+push\s+-f\b'; then
  echo "BLOCKED: Destructive operation requires human approval"
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) BLOCKED reason=destructive_op input=\"$INPUT\"" >> "$AUDIT_LOG"
  exit 1
fi

exit 0
