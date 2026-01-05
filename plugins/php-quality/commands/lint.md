# Lint Command

Run all PHP linters on the project.

## Usage

```
/php-quality:lint
```

## Instructions

Run the following tools in sequence:

### 1. Rector (Dry Run)

```bash
./vendor/bin/rector --dry-run
```

Show suggested changes without applying them.

### 2. Pint

```bash
./vendor/bin/pint --test
```

Check code style without making changes.

### 3. PHPStan

```bash
./vendor/bin/phpstan analyse --memory-limit=512M
```

Run static analysis.

### 4. Report Summary

Provide a summary of all issues found across all tools.
