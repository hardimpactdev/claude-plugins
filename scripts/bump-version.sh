#!/bin/bash
# Bump version for a plugin
# Usage: ./scripts/bump-version.sh <plugin-name> <major|minor|patch>

set -e

PLUGIN=$1
BUMP_TYPE=$2

if [ -z "$PLUGIN" ] || [ -z "$BUMP_TYPE" ]; then
    echo "Usage: ./scripts/bump-version.sh <plugin-name> <major|minor|patch>"
    echo "Example: ./scripts/bump-version.sh liftoff-laravel minor"
    exit 1
fi

PLUGIN_DIR="plugins/$PLUGIN"
PLUGIN_JSON="$PLUGIN_DIR/.claude-plugin/plugin.json"
MARKETPLACE_JSON=".claude-plugin/marketplace.json"

if [ ! -f "$PLUGIN_JSON" ]; then
    echo "Error: Plugin not found at $PLUGIN_DIR"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(jq -r '.version' "$PLUGIN_JSON")
echo "Current version: $CURRENT_VERSION"

# Parse version components
IFS='.' read -r MAJOR MINOR PATCH <<< "$CURRENT_VERSION"

# Bump appropriate component
case $BUMP_TYPE in
    major)
        MAJOR=$((MAJOR + 1))
        MINOR=0
        PATCH=0
        ;;
    minor)
        MINOR=$((MINOR + 1))
        PATCH=0
        ;;
    patch)
        PATCH=$((PATCH + 1))
        ;;
    *)
        echo "Error: Invalid bump type. Use major, minor, or patch"
        exit 1
        ;;
esac

NEW_VERSION="$MAJOR.$MINOR.$PATCH"
echo "New version: $NEW_VERSION"

# Update plugin.json
jq --arg v "$NEW_VERSION" '.version = $v' "$PLUGIN_JSON" > "$PLUGIN_JSON.tmp"
mv "$PLUGIN_JSON.tmp" "$PLUGIN_JSON"

# Update marketplace.json
jq --arg name "$PLUGIN" --arg v "$NEW_VERSION" \
    '(.plugins[] | select(.name == $name) | .version) = $v' \
    "$MARKETPLACE_JSON" > "$MARKETPLACE_JSON.tmp"
mv "$MARKETPLACE_JSON.tmp" "$MARKETPLACE_JSON"

echo ""
echo "Updated versions:"
echo "  - $PLUGIN_JSON"
echo "  - $MARKETPLACE_JSON"
echo ""
echo "Next steps:"
echo "  1. Update $PLUGIN_DIR/CHANGELOG.md with release notes"
echo "  2. git add . && git commit -m 'release($PLUGIN): v$NEW_VERSION'"
echo "  3. git tag $PLUGIN-v$NEW_VERSION"
echo "  4. git push && git push --tags"
echo "  5. gh release create $PLUGIN-v$NEW_VERSION --title '$PLUGIN v$NEW_VERSION'"
