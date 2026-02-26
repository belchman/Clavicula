#!/bin/bash
# Grimoire Protocol — Conjuration: Draw the Circle
# Fires on SessionStart. Verifies containment before any agent work begins.

set -euo pipefail

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
AUDIT_LOG="$GRIMOIRE_ROOT/grimoire/logs/audit.log"

echo "═══ GRIMOIRE PROTOCOL: DRAWING THE CIRCLE ═══"

# 1. Verify seal integrity
if [ -f "$GRIMOIRE_ROOT/scripts/verify-seals.sh" ]; then
  bash "$GRIMOIRE_ROOT/scripts/verify-seals.sh" || {
    echo "WARNING: Seal integrity check failed — agent definitions may have been modified"
  }
fi

# 2. Verify hooks are active (self-check)
if [ ! -f "$GRIMOIRE_ROOT/.claude/settings.json" ]; then
  echo "WARNING: settings.json missing — hooks not configured"
fi

# 3. Configure git hooks path (idempotent)
if [ -d "$GRIMOIRE_ROOT/.githooks" ]; then
  CURRENT_HOOKS_PATH=$(git -C "$GRIMOIRE_ROOT" config core.hooksPath 2>/dev/null || true)
  if [ "$CURRENT_HOOKS_PATH" != ".githooks" ]; then
    git -C "$GRIMOIRE_ROOT" config core.hooksPath .githooks
    echo "Configured git hooks path: .githooks"
  fi
fi

# 4. Verify grimoire.toml exists
if [ ! -f "$GRIMOIRE_ROOT/grimoire.toml" ]; then
  echo "WARNING: grimoire.toml missing — no configuration loaded"
fi

# 5. Load session state from previous session (if resuming)
if [ -f "$GRIMOIRE_ROOT/grimoire/logs/last-session-state.json" ]; then
  echo "Previous session state found. Agent will restore context."
fi

# 6. Auto-detect project type
PROJECT_TYPE="unknown"
if [ -f "$GRIMOIRE_ROOT/package.json" ]; then
  PROJECT_TYPE="node"
elif [ -f "$GRIMOIRE_ROOT/pyproject.toml" ] || [ -f "$GRIMOIRE_ROOT/requirements.txt" ]; then
  PROJECT_TYPE="python"
elif [ -f "$GRIMOIRE_ROOT/go.mod" ]; then
  PROJECT_TYPE="go"
elif [ -f "$GRIMOIRE_ROOT/Cargo.toml" ]; then
  PROJECT_TYPE="rust"
elif [ -f "$GRIMOIRE_ROOT/pom.xml" ] || [ -f "$GRIMOIRE_ROOT/build.gradle" ]; then
  PROJECT_TYPE="java"
fi

# 7. Auto-detect PM tool
PM_TOOL="none"
if [ -d "$GRIMOIRE_ROOT/.beads" ]; then
  PM_TOOL="beads"
elif [ -d "$GRIMOIRE_ROOT/project/issues" ]; then
  PM_TOOL="kanbus"
elif [ -d "$GRIMOIRE_ROOT/.git" ]; then
  PM_TOOL="github-issues"
fi

# 8. Log session start
mkdir -p "$(dirname "$AUDIT_LOG")"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) SESSION_START user=$(whoami) pwd=$(pwd) project_type=$PROJECT_TYPE pm_tool=$PM_TOOL" >> "$AUDIT_LOG"

echo "Project type: $PROJECT_TYPE"
echo "PM tool: $PM_TOOL"
echo "═══ CIRCLE DRAWN. PROCEED WITH CONJURATION. ═══"
