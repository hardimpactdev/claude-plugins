---
name: laravel-general
description: PHP 8.4 and Laravel 12 general conventions. Use when working on any PHP file in a Laravel project - covers syntax, naming, project structure, and framework conventions.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# PHP & Laravel General Conventions

## When to Apply

Apply these conventions when:
- Working on any PHP file in a Laravel project
- Creating new classes, controllers, or models
- Reviewing or refactoring PHP code

## PHP Language Rules

### Version & Syntax
- **PHP 8.4** required
- Use **constructor property promotion** in `__construct()`
- Always use **explicit return type declarations**
- Use **appropriate type hints** for parameters
- Always use **curly braces** for control structures (even single line)
- Prefer `match()` over `switch()` for readability

### Naming Conventions
- **PascalCase** for class names
- **camelCase** for method names and variables
- **snake_case** for database columns
- **TitleCase** for Enum keys

### Type Declarations

```php
// Correct: explicit return types and parameter hints
protected function isAccessible(User $user, ?string $path = null): bool
{
    // implementation
}
```

### Comments & Documentation
- Prefer **PHPDoc blocks** over inline comments
- Never use comments within code unless very complex
- Add **array shape definitions** when appropriate

## Laravel Framework Conventions

### Project Structure (Laravel 12)
- Streamlined structure (no `app/Http/Middleware/`, no `app/Console/Kernel.php`)
- Commands **auto-register** from `app/Console/Commands/`
- Middleware/exceptions register in `bootstrap/app.php`
- Service providers in `bootstrap/providers.php`

### Artisan Commands
- Use `php artisan make:` commands for file generation
- Pass `--no-interaction` flag for automation
- Use `artisan make:class` for generic PHP classes
- Check available options with Laravel Boost `list-artisan-commands` tool

### Configuration & Environment
- Use `config()` helper, never `env()` outside config files
- Environment variables only in configuration files
- Example: `config('app.name')` not `env('APP_NAME')`

### Routing
- Use **named routes** and `route()` helper for URLs
- See `laravel-routes` skill for Waymaker routing

## Code Quality Requirements

### Static Analysis
- **Larastan level 9** required
- Run `composer analyse` after features
- Fix all static analysis issues

### Code Formatting
- Run `vendor/bin/pint --dirty` before committing
- Never run `vendor/bin/pint --test`

## Security Requirements
- Prevent **SQL injection** with FormRequest validation
- Never expose sensitive data in responses
- Never log or commit secrets/keys

## Common Pitfalls to Avoid
- Don't repeat string values - use Enums
- Don't create base folders without approval
- Don't skip FormRequest validation
- Don't use raw DB queries when Eloquent works
- Don't forget eager loading for relationships
