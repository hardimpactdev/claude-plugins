# Git Workflow Plugin

Git workflow automation for releases, documentation, and changelogs.

## Overview

This plugin provides commands and skills for managing git workflows, including semantic versioning releases and documentation maintenance.

## Installation

```bash
/plugin install git-workflow@liftoff-plugins-marketplace
```

## Skills

| Skill | Trigger | Description |
|-------|---------|-------------|
| `release-version` | "release", "version", "tag" | Semantic versioning releases |

## Commands

| Command | Description |
|---------|-------------|
| `/git-workflow:wrap-up` | Update CLAUDE.md and README.md |
| `/git-workflow:release` | Create a new release |
| `/git-workflow:changelog` | Generate changelog |

## Agents

| Agent | Description |
|-------|-------------|
| `documentation-reviewer` | Reviews and updates project documentation |

## Release Workflow

The `release-version` skill guides through:
1. Check current state (uncommitted changes, tags)
2. Determine version number (semver)
3. Review and update documentation
4. Commit changes
5. Create and push tag
6. Create GitHub release via `gh`
7. Verify release

## Source

Migrated from:
- `~/projects/launchpad-cli/.claude/skills/release-version/`
- `~/projects/orchestrator/.claude/commands/wrap-up.md`

## Development Status

- [x] Plugin manifest
- [ ] Release skill migration
- [ ] Wrap-up command migration
- [ ] Changelog command
- [ ] Documentation reviewer agent
