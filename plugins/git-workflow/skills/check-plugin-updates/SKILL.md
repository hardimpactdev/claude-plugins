---
name: check-plugin-updates
description: Check for updates to installed plugins from the marketplace. Use at session start or when user asks about plugin versions.
allowed-tools: Bash, Read, WebFetch, Grep, Glob
---

# Check Plugin Updates Skill

Monitor and report on available plugin updates.

## When to Use

- Starting a new development session
- User asks about plugin versions
- After plugin repository updates are announced
- Periodic maintenance checks

## How to Check Updates

### 1. Identify Installed Plugins

Read project's plugin configuration:

```bash
cat .claude/settings.json | jq '.plugins.installed // .plugins // []'
```

### 2. Get Latest Versions from Marketplace

```bash
# Fetch marketplace.json from GitHub
gh api repos/hardimpactdev/claude-plugins/contents/.claude-plugin/marketplace.json \
  -q '.content' | base64 -d | jq '.plugins[] | {name, version}'
```

### 3. Compare Versions

For each installed plugin:
- Check current installed version
- Compare to latest marketplace version
- Note any version differences

### 4. Check Changelogs

For plugins with updates:

```bash
gh api repos/hardimpactdev/claude-plugins/contents/plugins/<plugin>/CHANGELOG.md \
  -q '.content' | base64 -d | head -50
```

## Reporting Updates

### No Updates Available
```
All plugins are up to date.

Installed plugins:
- liftoff-laravel v1.0.0
- liftoff-vue v1.0.0
- php-quality v1.0.0
```

### Updates Available
```
Plugin updates available:

liftoff-laravel: v1.0.0 → v1.1.0
  - Added laravel-queues skill
  - Updated PHP 8.4 property hooks guidance

php-quality: v1.0.0 → v1.0.1
  - Fixed PHPStan level configuration

To update: Plugins auto-update from marketplace on next session.
```

## Breaking Changes Warning

If MAJOR version bump detected:

```
WARNING: Breaking changes detected!

liftoff-laravel: v1.0.0 → v2.0.0

Breaking changes:
- Removed deprecated laravel-herd skill
- Renamed laravel-routes to laravel-waymaker

Review CHANGELOG.md before updating.
```

## Manual Update

To force update of marketplace cache:

```bash
cd ~/.claude/plugins/marketplaces/hardimpact-plugins
git pull origin main
```
