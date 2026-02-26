#!/bin/bash
# Grimoire Protocol — Draw the Circle (Container Setup)
# Optional: Sets up Docker-based containment for agent code execution.
# Use this when agents need to execute untrusted code in a sandbox.

set -euo pipefail

GRIMOIRE_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

echo "═══ GRIMOIRE PROTOCOL: DRAWING THE CIRCLE (CONTAINER) ═══"

# Check for Docker
if ! command -v docker &> /dev/null; then
  echo "Docker not found. Container-level containment unavailable."
  echo "Falling back to tool restrictions + hook-based containment."
  exit 0
fi

# Build sandbox container if Dockerfile exists
SANDBOX_DOCKERFILE="$GRIMOIRE_ROOT/scripts/Dockerfile.sandbox"
if [ -f "$SANDBOX_DOCKERFILE" ]; then
  echo "Building sandbox container..."
  docker build -t grimoire-sandbox -f "$SANDBOX_DOCKERFILE" "$GRIMOIRE_ROOT"
else
  echo "No sandbox Dockerfile found at $SANDBOX_DOCKERFILE"
  echo "To enable container containment, create a Dockerfile.sandbox in scripts/"
fi

# Verify container security settings
echo ""
echo "Container security flags for agent execution:"
echo "  --network none        (no network access)"
echo "  --cap-drop ALL        (drop all capabilities)"
echo "  --read-only           (read-only filesystem)"
echo "  --memory 512m         (memory limit)"
echo "  --cpus 1.0            (CPU limit)"
echo "  --pids-limit 100      (process limit)"
echo ""
echo "Usage:"
echo "  docker run --rm --network none --cap-drop ALL --read-only \\"
echo "    --memory 512m --cpus 1.0 --pids-limit 100 \\"
echo "    -v \$(pwd):/workspace:ro \\"
echo "    grimoire-sandbox [command]"

echo ""
echo "═══ CIRCLE DRAWN. CONTAINER READY. ═══"
