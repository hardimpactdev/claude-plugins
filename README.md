# Claude Code Plugins Marketplace

A GitHub-powered marketplace for Claude Code plugins.

## Overview

This repository serves as both:
1. **A marketplace** - A registry of curated Claude Code plugins
2. **A development environment** - Templates and tools for creating new plugins

## Quick Start

### For Users: Installing Plugins

```bash
# Add this marketplace to Claude Code
/plugin marketplace add your-org/claude-plugins-marketplace

# Browse and install plugins
/plugin install

# Or install directly
/plugin install template-plugin@claude-plugins-marketplace
```

### For Developers: Creating Plugins

1. **Copy the template**
   ```bash
   cp -r plugins/template-plugin plugins/my-plugin
   ```

2. **Edit the plugin manifest**
   ```bash
   # Edit plugins/my-plugin/.claude-plugin/plugin.json
   ```

3. **Add your components**
   - Commands in `commands/`
   - Skills in `skills/`
   - Agents in `agents/`
   - Hooks in `hooks/`

4. **Test locally**
   ```bash
   claude --plugin-dir ./plugins/my-plugin
   ```

5. **Register in marketplace**
   ```bash
   # Add entry to .claude-plugin/marketplace.json
   ```

## Repository Structure

```
.
├── .claude-plugin/
│   └── marketplace.json     # Marketplace manifest
├── plugins/
│   └── template-plugin/     # Example plugin with all components
├── .github/
│   └── workflows/
│       └── validate.yml     # CI validation for plugins
└── README.md
```

## Plugin Components

| Component | Location | Description |
|-----------|----------|-------------|
| **Commands** | `commands/*.md` | Slash commands (`/plugin:command`) |
| **Skills** | `skills/*/SKILL.md` | Auto-invoked capabilities |
| **Agents** | `agents/*.md` | Specialized subagents |
| **Hooks** | `hooks/hooks.json` | Event handlers |
| **MCP Servers** | `.mcp.json` | External tool integrations |

## Creating a New Plugin

### 1. Plugin Manifest

Every plugin needs `.claude-plugin/plugin.json`:

```json
{
  "name": "my-plugin",
  "version": "1.0.0",
  "description": "What your plugin does",
  "author": { "name": "Your Name" },
  "commands": "./commands/",
  "skills": "./skills/",
  "agents": "./agents/"
}
```

### 2. Commands

Create markdown files in `commands/`:

```markdown
# My Command

Instructions for what Claude should do when this command is invoked.
```

### 3. Skills

Create skill directories in `skills/`:

```markdown
---
name: my-skill
description: When Claude should use this skill
allowed-tools: Read, Grep, Glob
---

# Skill Instructions

Step-by-step guidance for Claude...
```

### 4. Agents

Create agent definitions in `agents/`:

```markdown
# Agent Name

## Capabilities
What this agent specializes in...

## Instructions
How the agent should operate...
```

## Adding to Marketplace

1. Create your plugin in `plugins/your-plugin/`
2. Add an entry to `.claude-plugin/marketplace.json`:

```json
{
  "plugins": [
    {
      "name": "your-plugin",
      "source": "./plugins/your-plugin",
      "description": "What it does",
      "version": "1.0.0"
    }
  ]
}
```

3. Submit a pull request

## External Plugin Sources

The marketplace can reference plugins from other repositories:

```json
{
  "name": "external-plugin",
  "source": {
    "source": "github",
    "repo": "owner/plugin-repo"
  }
}
```

## Best Practices

- **Semantic versioning**: Use MAJOR.MINOR.PATCH
- **Clear descriptions**: Help users find your plugin
- **Progressive disclosure**: Keep main files concise, details in reference docs
- **Test thoroughly**: Use `claude --plugin-dir` during development
- **Document dependencies**: List required external tools

## Contributing

1. Fork this repository
2. Create your plugin in `plugins/`
3. Update `marketplace.json`
4. Submit a pull request

## License

MIT
