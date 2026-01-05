---
name: plugin-feedback
description: Capture lessons learned and skill improvements during development sessions. Use when discovering patterns, workarounds, or improvements to existing plugin guidance.
allowed-tools: Read, Write, Glob, Grep, Bash
---

# Plugin Feedback Skill

Capture feedback about plugin skills to enable continuous improvement.

## When to Use

- Discovered a pattern not covered by existing skills
- Found incorrect or outdated guidance in a skill
- Identified a common workflow that should be documented
- Want to suggest an enhancement to skill documentation

## Feedback Directory Structure

Each project maintains a feedback directory:

```
.claude/plugin-feedback/
├── pending/              # Awaiting submission
│   └── YYYY-MM-DD-<skill>.md
└── submitted/            # PRs created
    └── YYYY-MM-DD-<skill>.md
```

## Feedback File Template

Create files in `.claude/plugin-feedback/pending/`:

```markdown
---
plugin: <plugin-name>
skill: <skill-name>
type: improvement|addition|correction|clarification
priority: low|medium|high
created: YYYY-MM-DD
session_context: "<brief description of what you were working on>"
---

# Feedback: <Title>

## Problem Encountered
<What issue or gap was discovered>

## Current Skill Guidance
<Quote from existing SKILL.md if applicable>

## Proposed Change
<Specific wording or addition to suggest>

## Evidence/Example
<Code example that demonstrates the issue>

## Impact
<Who this affects and how often it occurs>
```

## Creating Feedback

1. **Identify the Gap**
   - Which plugin/skill needs improvement?
   - What category: improvement, addition, correction, clarification?

2. **Document Context**
   - What were you working on when you discovered this?
   - What did you expect vs what happened?

3. **Propose Solution**
   - What should the skill say instead?
   - Provide concrete examples

4. **Save Feedback**
   - Create file: `.claude/plugin-feedback/pending/YYYY-MM-DD-<skill>.md`
   - Use the template above

## Next Steps

After creating feedback:
1. Review with `/git-workflow:submit-feedback` command
2. This creates a PR to the plugin marketplace
3. Team reviews and merges improvements
4. Plugin version is bumped
