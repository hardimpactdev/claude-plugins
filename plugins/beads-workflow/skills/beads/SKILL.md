---
name: beads
description: Git-backed issue tracking with beads (bd). Apply when working in a repo with .beads/ directory to track tasks, dependencies, and discoveries.
allowed-tools: Bash(bd:*), Read, Grep, Glob
---

# Beads Issue Tracking

Use `bd` to track your work persistently across sessions.

## When to Apply

- Project has `.beads/` directory
- Working on multi-step tasks
- Need to track discoveries or sub-tasks
- Handing off work to another session

## Core Commands

```bash
bd ready --json                              # Tasks with no blockers
bd create "Title" -p 1 --json                # Create task (priority 0-4)
bd update <id> --status in_progress --json   # Claim task
bd close <id> --reason "Done" --json         # Complete task
bd list --status open --json                 # All open tasks
bd show <id> --json                          # Task details
```

## Workflow

1. **Check available work**: `bd ready --json`
2. **Claim before starting**: `bd update <id> --status in_progress`
3. **Create sub-tasks** when you discover work:
   ```bash
   bd create "Sub-task" -p 1 --deps discovered-from:<parent-id> --json
   ```
4. **Complete**: `bd close <id> --reason "what was done"`
5. **File remaining work**: Create tasks for anything unfinished
6. **Sync**: `bd sync` before ending session

## Priority Levels

| Priority | Use For |
|----------|---------|
| 0 | Critical/blocking |
| 1 | High priority |
| 2 | Normal (default) |
| 3 | Low priority |
| 4 | Backlog |

## Tips

- Always use `--json` for programmatic output
- Update status in real-time, don't batch
- File issues for TODOs you discover in code
- Check `bd ready` periodically for unblocked work
