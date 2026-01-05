# dev-environment Plugin

Local development environment patterns with Launchpad CLI.

## Skills

| Skill | Description |
|-------|-------------|
| `launchpad-cli` | Launchpad CLI commands for Docker-based PHP development |

## Commands

| Command | Description |
|---------|-------------|
| `/dev-environment:status` | Check development environment status |

## Launchpad CLI

Launchpad provides a Docker-based local PHP development environment with:
- Multiple PHP versions (8.3, 8.4)
- Automatic HTTPS via Caddy
- PostgreSQL, Redis, Mailpit
- Automatic `.test` domain resolution

## Quick Reference

```bash
launchpad start      # Start services
launchpad stop       # Stop services
launchpad status     # Check status
launchpad sites      # List sites
launchpad php <site> <version>  # Set PHP version
```

## Installation

```bash
claude /plugin install dev-environment
```
