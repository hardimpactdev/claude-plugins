---
name: beads-init
description: Initialize beads issue tracking in the current project
allowed-tools: Bash(bd:*), Bash(git:*), Read
---

# Initialize Beads

Set up beads issue tracking for this project.

## Steps

1. Check if already initialized:
   ```bash
   ls -la .beads 2>/dev/null && echo "Already initialized" || echo "Not initialized"
   ```

2. If not initialized, run:
   ```bash
   bd init --stealth
   ```

3. Verify setup:
   ```bash
   bd list --json
   ```

4. Inform the user that beads is ready and explain:
   - Tasks are stored in `.beads/issues.jsonl`
   - Use `bd create "Task"` to add tasks
   - Use `bd ready` to see available work
   - Stealth mode keeps beads invisible to collaborators
