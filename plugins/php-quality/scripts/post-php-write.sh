#!/bin/bash
# PHP Quality Check Hook - Runs after any PHP file is written or edited
# Based on launchpad-cli/.claude/hooks/php-checks.sh

set -e

cd "$CLAUDE_PROJECT_DIR"

# Check if this is a PHP project
if [ ! -f "composer.json" ]; then
    exit 0
fi

log_file="storage/logs/laravel.log"

# Store current log line count before running checks
if [ -f "$log_file" ]; then
    log_lines_before=$(wc -l < "$log_file")
else
    log_lines_before=0
fi

# Run Rector if available
if [ -f "vendor/bin/rector" ]; then
    echo "Running Rector..."
    ./vendor/bin/rector --dry-run 2>&1 || true
fi

# Run Pint if available
if [ -f "vendor/bin/pint" ]; then
    echo ""
    echo "Running Pint..."
    ./vendor/bin/pint --dirty 2>&1 || true
fi

# Run PHPStan if available
if [ -f "vendor/bin/phpstan" ]; then
    echo ""
    echo "Running PHPStan..."
    ./vendor/bin/phpstan analyse --memory-limit=512M --no-progress 2>&1 || true
fi

# Run Pest if available
if [ -f "vendor/bin/pest" ]; then
    echo ""
    echo "Running tests..."
    ./vendor/bin/pest --colors=always 2>&1 || true
fi

# Check for new errors/warnings in laravel.log
echo ""
echo "Checking laravel.log for new errors/warnings..."
if [ -f "$log_file" ]; then
    log_lines_after=$(wc -l < "$log_file")
    new_lines=$((log_lines_after - log_lines_before))

    if [ $new_lines -gt 0 ]; then
        new_errors=$(tail -n "$new_lines" "$log_file" | grep -E '\[(ERROR|WARNING|CRITICAL|ALERT|EMERGENCY)\]' 2>/dev/null || true)
        if [ -n "$new_errors" ]; then
            echo "New errors/warnings found in laravel.log:"
            echo "$new_errors"
        else
            echo "No new errors or warnings"
        fi
    else
        echo "No new log entries"
    fi
else
    echo "No laravel.log file (no errors logged)"
fi

exit 0
