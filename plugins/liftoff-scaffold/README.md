# liftoff-scaffold Plugin

Project scaffolding patterns for the Liftoff stack.

## Skills

| Skill | Description |
|-------|-------------|
| `project-setup` | Liftoff stack project setup patterns |

## Commands

| Command | Description |
|---------|-------------|
| `/liftoff-scaffold:new-feature <Name>` | Scaffold a new feature with all components |

## What Gets Created

When scaffolding a new feature:

1. **Migration** - Database table with indexes
2. **Model** - Final class with factory
3. **Enum** - Status/type enum (if needed)
4. **DTOs** - Data transfer objects
5. **FormRequest** - With WithData trait
6. **Controller** - Waymaker-attributed
7. **Vue Pages** - Index, Create, Edit, Show
8. **Tests** - Feature and unit tests

## Technology Stack

- PHP 8.4 + Laravel 12
- Vue 3 + TypeScript
- Inertia.js v2
- Tailwind CSS v4
- Pest v3

## Installation

```bash
claude /plugin install liftoff-scaffold
```

## Dependencies

- liftoff-laravel
- liftoff-vue
