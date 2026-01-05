# Quality Check Command

Run all PHP quality tools on the project.

## Usage

```
/liftoff-laravel:quality-check
```

## Instructions

When this command is invoked, run the following quality checks in sequence:

### 1. Rector (Dry Run)

```bash
./vendor/bin/rector --dry-run
```

Report any suggested changes. If changes are needed, ask if user wants to apply them.

### 2. Pint (Code Style)

```bash
./vendor/bin/pint --dirty
```

Fix code style issues automatically.

### 3. PHPStan (Static Analysis)

```bash
./vendor/bin/phpstan analyse --memory-limit=512M
```

Report any static analysis errors. These must be fixed manually.

### 4. Pest (Tests)

```bash
./vendor/bin/pest
```

Run the test suite and report results.

### 5. Summary

Provide a summary:
- Number of files checked
- Issues found and fixed
- Remaining issues requiring attention
- Test results

## Requirements

These tools must be installed via Composer:
- `rector/rector`
- `laravel/pint`
- `larastan/larastan`
- `pestphp/pest`
