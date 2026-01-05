# Liftoff Laravel Plugin

Comprehensive Laravel development support for the Liftoff ecosystem.

## Overview

This plugin provides Claude with deep knowledge of Laravel 12, PHP 8.4, and the Liftoff development patterns. It consolidates the development rules from orchestrator and liftoff-starterkit into reusable skills.

## Installation

```bash
# Add marketplace
/plugin marketplace add hardimpactdev/claude-plugins-marketplace

# Install plugin
/plugin install liftoff-laravel@liftoff-plugins-marketplace
```

## Skills (Auto-Invoked)

Claude automatically applies these skills when working on relevant files:

| Skill | Trigger | Description |
|-------|---------|-------------|
| `laravel-general` | `*.php` | PHP 8.4 conventions, Laravel 12 structure |
| `laravel-controllers` | `*Controller.php` | Controller patterns, resourceful methods |
| `laravel-routes` | Route files | Waymaker attribute-based routing |
| `laravel-validation` | `*Request.php` | FormRequest patterns, validation rules |
| `laravel-models` | `*.php` (models) | Eloquent best practices, relationships |
| `laravel-database` | Migrations | Migration patterns, factories, seeders |
| `laravel-dtos` | `*Data.php` | Laravel Data DTO patterns |
| `laravel-enums` | `*.php` (enums) | PHP 8.4 enum patterns |
| `laravel-middleware` | Middleware files | Middleware patterns |
| `laravel-testing` | `*Test.php` | Pest testing patterns |

## Commands

| Command | Description |
|---------|-------------|
| `/liftoff-laravel:scaffold` | Generate Laravel components |
| `/liftoff-laravel:quality-check` | Run all quality tools |

## MCP Servers

This plugin integrates with:
- **laravel-boost** - Laravel artisan commands and documentation

## Source

Rules migrated from:
- `~/projects/orchestrator/.ai/rules/backend/`
- `~/projects/liftoff-starterkit/.ai/rules/backend/`

## Configuration

The plugin uses the project's `composer.json` to detect Laravel projects and applies skills accordingly.

## Development Status

- [x] Plugin manifest
- [ ] Skills migration from .ai/rules/backend/
- [ ] Commands implementation
- [ ] Hooks integration
- [ ] MCP server configuration
