---
name: banish
description: "Force-terminate all running agents and clean up resources."
allowed-tools: Read, Write, Bash
---

# Banish — Force Termination

Immediately stop all operations. This is an emergency command.

## Process

1. Stop all current work immediately. Do not attempt any further tool calls beyond what is listed here.

2. Save minimal state to `grimoire/logs/banished-state.json`:
```json
{
  "timestamp": "[ISO timestamp]",
  "status": "banished",
  "in_progress": "[what was being worked on]",
  "completed": "[what was finished]",
  "incomplete": "[what was not finished]"
}
```

3. Log the banishment:
```
[timestamp] BANISH reason=user_command
```

4. Check for orphaned processes:
```bash
pgrep -f "e2b|docker.*grimoire" 2>/dev/null && echo "WARNING: orphaned processes detected"
```

5. Stop. Do not continue under any circumstances.

The operator may also use Ctrl+C for SIGINT if the agent does not comply with /banish.
