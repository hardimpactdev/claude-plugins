# PHP Quality Plugin

Automated PHP code quality enforcement.

## Overview

This plugin runs quality checks automatically when PHP files are written, ensuring consistent code quality across all Laravel projects.

## Installation

```bash
/plugin install php-quality@liftoff-plugins-marketplace
```

## Hooks

### PostToolUse (Write)

When a PHP file is written, automatically runs:
1. **Rector** - Automated refactoring
2. **Pint** - Code formatting (PSR-12)
3. **PHPStan** - Static analysis (level 9)
4. **Pest** - Test suite
5. **Log Check** - Monitor laravel.log for new errors

## Commands

| Command | Description |
|---------|-------------|
| `/php-quality:lint` | Run all linters |
| `/php-quality:fix` | Auto-fix issues |
| `/php-quality:test` | Run Pest tests |

## Skills

| Skill | Description |
|-------|-------------|
| `php-formatting` | Pint code style rules |
| `php-analysis` | PHPStan/Larastan patterns |

## Source

Hooks migrated from:
- `~/projects/launchpad-cli/.claude/hooks/php-checks.sh`
- `~/projects/orchestrator/whisky.json`

## Configuration

Requires these tools in the project:
- `vendor/bin/rector`
- `vendor/bin/pint`
- `vendor/bin/phpstan`
- `vendor/bin/pest`

## Development Status

- [x] Plugin manifest
- [ ] Hooks implementation
- [ ] Commands implementation
- [ ] Skills migration
