---
name: release-version
description: Release a new version of the project. Use when the user wants to release, tag, or publish a new version with semantic versioning.
allowed-tools: Bash(git:*), Bash(gh:*), Read, Edit, Glob, Grep
---

# Release New Version

## When to Apply

Use this skill when the user mentions:
- "release", "new release", "create release"
- "version", "new version", "bump version"
- "tag", "create tag", "push tag"
- "publish", "deploy"

## Instructions

### 1. Check Current State

```bash
# Check for uncommitted changes
git status

# Get current version tags
git tag --sort=-version:refname | head -5

# View recent commits since last tag
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

### 2. Determine Version Number

Follow semantic versioning (MAJOR.MINOR.PATCH):
- **MAJOR**: Breaking changes
- **MINOR**: New features, backwards compatible
- **PATCH**: Bug fixes, backwards compatible

### 3. Review and Update Documentation

**IMPORTANT**: Before releasing, ensure documentation is up to date.

#### 3.1 Check for Changes

1. Read `README.md` and verify it reflects current state
2. Read `CLAUDE.md` and verify:
   - Architecture section is current
   - Commands/features are documented
   - Test coverage section is accurate

#### 3.2 Update Documentation if Needed

If any documentation is missing or outdated:
1. Update README.md with new/changed features
2. Update CLAUDE.md with current structure
3. Commit documentation updates

### 4. Commit Changes (if needed)

If there are uncommitted changes (including documentation updates):

```bash
git add -A
git commit -m "Your commit message"
```

### 5. Create and Push Tag

```bash
# Create annotated tag
git tag -a vX.Y.Z -m "vX.Y.Z - Brief description"

# Push commits and tags
git push && git push --tags
```

### 6. Create GitHub Release

Always use the gh CLI to create the release:

```bash
gh release create vX.Y.Z --title "vX.Y.Z" --notes "$(cat <<'EOF'
## What's New

- Feature 1
- Feature 2

## Bug Fixes

- Fix 1
EOF
)"
```

### 7. Verify Release

```bash
# Confirm release was created
gh release view vX.Y.Z
```

## Documentation Checklist

Before tagging, confirm:

- [ ] README.md is up to date
- [ ] CLAUDE.md reflects current state
- [ ] New features from recent commits are documented
- [ ] Breaking changes are clearly noted

## Notes

- Always use `gh release create` for GitHub releases
- Include meaningful release notes summarizing changes
- Link to related issues/PRs when applicable
- Documentation must be updated BEFORE creating the tag
