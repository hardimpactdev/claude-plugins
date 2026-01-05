#!/bin/bash
# Post-write hook script
# Called after any file is written by Claude
# $1 contains the paths of files that were written

FILE_PATHS="$1"

# Example: Log file writes
# echo "Files written: $FILE_PATHS" >> /tmp/claude-writes.log

# Example: Run linting on written files
# if command -v eslint &> /dev/null; then
#     eslint --fix $FILE_PATHS 2>/dev/null || true
# fi

# Exit successfully (non-zero exit could block the operation)
exit 0
