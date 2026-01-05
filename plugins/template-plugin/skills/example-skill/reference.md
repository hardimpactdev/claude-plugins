# Example Skill Reference

Extended documentation for the example skill.

## Skill Frontmatter Options

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique identifier for the skill |
| `description` | Yes | What the skill does and when Claude should use it |
| `allowed-tools` | No | Restrict which tools can be used |
| `model` | No | Override the model for this skill |

## File Structure

A skill can be a single file or a directory:

### Single File
```
skills/
└── my-skill.md
```

### Directory (Recommended for Complex Skills)
```
skills/
└── my-skill/
    ├── SKILL.md        # Main skill file (required)
    ├── reference.md    # Detailed documentation
    ├── examples.md     # Usage examples
    └── scripts/        # Utility scripts
        └── helper.sh
```

## Tool Restrictions

Use `allowed-tools` to limit what Claude can do:

```yaml
allowed-tools: Read, Grep, Glob  # Read-only skill
```

Common tool combinations:
- **Read-only**: `Read, Grep, Glob`
- **File editing**: `Read, Grep, Glob, Write, Edit`
- **Full access**: Omit `allowed-tools` entirely

## Best Practices

1. **Progressive Disclosure**: Keep main SKILL.md focused and concise
2. **Specific Descriptions**: Include trigger keywords users would naturally say
3. **Clear Structure**: Use headers to organize instructions
4. **Concrete Examples**: Show expected inputs and outputs
