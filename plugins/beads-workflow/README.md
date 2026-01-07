# Beads Workflow Plugin

Git-backed issue tracking for AI agents using [beads](https://github.com/steveyegge/beads).

## Features

- **Skill**: Instructions for agents to use beads for task tracking
- **Hooks**: Auto-sync on session stop and before context compaction
- **Command**: `/beads-init` to initialize beads in a project

## Installation

Requires `bd` CLI to be installed:

```bash
npm install -g @beads/bd
```

## Usage

### Initialize in a project

```
/beads-init
```

### Agent workflow

The skill activates when a `.beads/` directory exists. Agents will:

1. Check `bd ready` for available tasks
2. Claim tasks with `bd update <id> --status in_progress`
3. Create sub-tasks for discoveries
4. Close completed tasks
5. Auto-sync on session end (via hooks)

## Commands

| Command | Description |
|---------|-------------|
| `/beads-init` | Initialize beads in current project |

## Hooks

| Event | Action |
|-------|--------|
| Stop | Run `bd sync` to persist changes |
| PreCompact | Run `bd sync` before context compaction |
