#!/bin/bash
# Create a new plugin from the template

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

if [ -z "$1" ]; then
    echo "Usage: $0 <plugin-name>"
    echo "Example: $0 my-awesome-plugin"
    exit 1
fi

PLUGIN_NAME="$1"
PLUGIN_DIR="$ROOT_DIR/plugins/$PLUGIN_NAME"

if [ -d "$PLUGIN_DIR" ]; then
    echo "Error: Plugin '$PLUGIN_NAME' already exists"
    exit 1
fi

echo "Creating new plugin: $PLUGIN_NAME"

# Copy template
cp -r "$ROOT_DIR/plugins/template-plugin" "$PLUGIN_DIR"

# Update plugin.json
sed -i "s/template-plugin/$PLUGIN_NAME/g" "$PLUGIN_DIR/.claude-plugin/plugin.json"
sed -i "s/A template plugin/$PLUGIN_NAME plugin/g" "$PLUGIN_DIR/.claude-plugin/plugin.json"

# Update README
sed -i "s/Template Plugin/$PLUGIN_NAME/g" "$PLUGIN_DIR/README.md"
sed -i "s/template-plugin/$PLUGIN_NAME/g" "$PLUGIN_DIR/README.md"

echo ""
echo "Plugin created at: $PLUGIN_DIR"
echo ""
echo "Next steps:"
echo "  1. Edit $PLUGIN_DIR/.claude-plugin/plugin.json"
echo "  2. Add your commands, skills, and agents"
echo "  3. Test with: claude --plugin-dir $PLUGIN_DIR"
echo "  4. Add to marketplace.json when ready"
