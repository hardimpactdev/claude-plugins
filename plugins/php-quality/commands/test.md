# Test Command

Run the Pest test suite.

## Usage

```
/php-quality:test [filter]
```

## Instructions

Run Pest with optional filter:

```bash
# Run all tests
./vendor/bin/pest

# Run specific test (if filter provided)
./vendor/bin/pest --filter="<filter>"
```

## Options

- No arguments: Run full test suite
- With filter: Run matching tests only

## Report

Provide test results summary:
- Tests passed/failed
- Coverage percentage (if available)
- Failed test details
