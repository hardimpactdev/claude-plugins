# Template Plugin

A template plugin demonstrating all Claude Code plugin components.

## Installation

### From Marketplace

```bash
# Add the marketplace
/plugin marketplace add your-org/claude-plugins-marketplace

# Install the plugin
/plugin install template-plugin@claude-plugins-marketplace
```

### Direct Installation

```bash
# Clone and install locally
git clone https://github.com/your-org/template-plugin
claude plugin install ./template-plugin --scope user
```

## Components

### Commands

| Command | Description |
|---------|-------------|
| `/template-plugin:hello` | A greeting command |
| `/template-plugin:status` | Check project status |

### Skills

| Skill | Description |
|-------|-------------|
| `example-skill` | Demonstrates skill structure |

### Agents

| Agent | Description |
|-------|-------------|
| `reviewer` | Code review specialist |

### Hooks

- **PostToolUse**: Runs after file writes
- **PreToolUse**: Validates bash commands

## Development

### Testing Locally

```bash
# Test the plugin during development
claude --plugin-dir ./plugins/template-plugin
```

### Directory Structure

```
template-plugin/
├── .claude-plugin/
│   └── plugin.json      # Plugin manifest
├── commands/            # Slash commands
│   ├── hello.md
│   └── status.md
├── agents/              # Subagents
│   └── reviewer.md
├── skills/              # Auto-invoked skills
│   └── example-skill/
│       ├── SKILL.md
│       └── reference.md
├── hooks/               # Event handlers
│   └── hooks.json
├── scripts/             # Utility scripts
│   ├── post-write.sh
│   └── pre-bash.sh
├── .mcp.json           # MCP server config
└── README.md
```

## License

MIT
