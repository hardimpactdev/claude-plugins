---
name: example-skill
description: A template skill demonstrating proper skill structure. Use this when the user asks about creating plugins, skills, or extending Claude Code functionality.
allowed-tools: Read, Grep, Glob, Write, Edit
---

# Example Skill

This skill demonstrates the proper structure for Claude Code skills.

## When to Use This Skill

Apply this skill when:
- User asks about plugin development
- User wants to create or modify skills
- User needs help with Claude Code extensions

## Instructions

### 1. Understand the Request

First, clarify what the user wants to accomplish:
- Are they creating a new plugin or skill?
- Are they modifying existing functionality?
- Do they need help with a specific component?

### 2. Follow Best Practices

When helping with plugin/skill development:
- Keep SKILL.md files under 500 lines
- Use progressive disclosure for complex topics
- Put detailed reference material in separate files
- Use clear, specific descriptions

### 3. Provide Examples

Always include concrete examples:

```markdown
---
name: my-skill
description: Brief description of what it does and when to use it
allowed-tools: Read, Grep
---

# Skill Title

Instructions go here...
```

## Reference Materials

For detailed information, see:
- `reference.md` - Extended documentation
- `examples.md` - More usage examples

## Tips

- Start simple, add complexity as needed
- Test skills locally with `claude --plugin-dir ./my-plugin`
- Use namespaced commands to avoid conflicts
