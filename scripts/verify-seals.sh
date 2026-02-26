#!/bin/bash
# Grimoire Protocol — Seal Integrity Verification
# Verifies that agent definition files have not been modified outside version control.

set -euo pipefail

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CHECKSUMS_FILE="$GRIMOIRE_ROOT/grimoire/seals/checksums.sha256"

# Determine the correct sha256 command for this platform
if command -v sha256sum &> /dev/null; then
  SHA_CMD="sha256sum"
elif command -v shasum &> /dev/null; then
  SHA_CMD="shasum -a 256"
else
  echo "ERROR: No sha256 tool found (need sha256sum or shasum)"
  exit 1
fi

# Check if checksums file exists
if [ ! -f "$CHECKSUMS_FILE" ]; then
  echo "WARNING: No checksums file found at $CHECKSUMS_FILE"
  echo "Run this script with --generate to create initial checksums."

  if [ "${1:-}" = "--generate" ]; then
    echo "Generating checksums..."
    cd "$GRIMOIRE_ROOT"
    find .claude/agents -name "*.md" -type f | sort | while read -r f; do
      $SHA_CMD "$f"
    done > "$CHECKSUMS_FILE"
    echo "Checksums written to $CHECKSUMS_FILE"
    exit 0
  fi

  exit 1
fi

# Generate current checksums to a temp file
CURRENT_CHECKSUMS=$(mktemp)
trap 'rm -f "$CURRENT_CHECKSUMS"' EXIT

cd "$GRIMOIRE_ROOT"
find .claude/agents -name "*.md" -type f | sort | while read -r f; do
  $SHA_CMD "$f"
done > "$CURRENT_CHECKSUMS"

# Compare
if ! diff -q "$CHECKSUMS_FILE" "$CURRENT_CHECKSUMS" > /dev/null 2>&1; then
  echo "SEAL INTEGRITY VIOLATION"
  echo "Agent definition files have been modified."
  echo ""
  echo "Changes detected:"
  diff "$CHECKSUMS_FILE" "$CURRENT_CHECKSUMS" || true
  exit 1
fi

echo "All seals verified"
exit 0
