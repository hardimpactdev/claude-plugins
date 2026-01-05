#!/bin/bash
# Pre-bash hook script
# Called before bash commands are executed
# Can be used for validation, logging, or blocking dangerous commands

# Example: Log bash commands
# echo "$(date): Bash command requested" >> /tmp/claude-bash.log

# Example: Block certain commands (uncomment to activate)
# COMMAND="$CLAUDE_BASH_COMMAND"
# if [[ "$COMMAND" == *"rm -rf /"* ]]; then
#     echo "Blocked: Dangerous rm command"
#     exit 1
# fi

# Exit successfully to allow the command
exit 0
