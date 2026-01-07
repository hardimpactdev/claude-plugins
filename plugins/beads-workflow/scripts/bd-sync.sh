#\!/bin/bash
# Only sync if beads is initialized in current directory
if [ -d ".beads" ]; then
    bd sync 2>/dev/null || true
fi
