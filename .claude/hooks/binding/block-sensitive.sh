#!/bin/bash
# Grimoire Protocol — Binding: Block sensitive file writes
# Fires on PreToolUse for Write/Edit. Prevents credential exposure.

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"
INPUT="${1:-}"

mkdir -p "$(dirname "$AUDIT_LOG")"

# Check if target file is in a sensitive path
if echo "$INPUT" | grep -qiE '\.env($|\.)|\.key$|\.pem$|credentials|secrets\.ya?ml|\.aws/|\.ssh/'; then
  echo "BINDING VIOLATION: Divine Name #2 — No credential access"
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) VIOLATION divine_name=2 reason=sensitive_path input=\"$INPUT\"" >> "$AUDIT_LOG"
  exit 1
fi

# Check if written content contains potential secrets
if echo "$INPUT" | grep -qiE 'AKIA[A-Z0-9]{16}|ghp_[a-zA-Z0-9]{36}|sk-[a-zA-Z0-9]{48}|-----BEGIN.*PRIVATE KEY'; then
  echo "BINDING VIOLATION: Output contains potential credentials"
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) VIOLATION reason=credential_in_content" >> "$AUDIT_LOG"
  exit 1
fi

exit 0
