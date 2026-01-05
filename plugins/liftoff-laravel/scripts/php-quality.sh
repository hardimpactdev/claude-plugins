#!/bin/bash
# PHP Quality Check Hook
# Runs after any PHP file is written or edited

set -e

cd "$CLAUDE_PROJECT_DIR"

# Check if this is a Laravel/PHP project
if [ ! -f "composer.json" ]; then
    exit 0
fi

# Check for required tools
HAS_PINT=false
HAS_PHPSTAN=false

if [ -f "vendor/bin/pint" ]; then
    HAS_PINT=true
fi

if [ -f "vendor/bin/phpstan" ]; then
    HAS_PHPSTAN=true
fi

# Run Pint if available
if [ "$HAS_PINT" = true ]; then
    echo "Running Pint..."
    ./vendor/bin/pint --dirty 2>&1 || true
fi

# Run PHPStan if available (just report, don't fail)
if [ "$HAS_PHPSTAN" = true ]; then
    echo ""
    echo "Running PHPStan..."
    ./vendor/bin/phpstan analyse --memory-limit=512M --no-progress 2>&1 || true
fi

exit 0
