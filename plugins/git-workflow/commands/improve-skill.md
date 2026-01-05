# Improve Skill Command

Capture feedback for improving a plugin skill based on current session learnings.

## Usage

```
/git-workflow:improve-skill <plugin-name> <skill-name>
```

## Examples

```
/git-workflow:improve-skill liftoff-laravel laravel-routes
/git-workflow:improve-skill liftoff-vue vue-forms
```

## Instructions

When this command is invoked:

### 1. Validate Arguments

- Confirm plugin exists in marketplace
- Confirm skill exists in plugin
- Read current skill content for reference

### 2. Gather Context

Ask about:
- What was discovered or needs improvement?
- Type: improvement, addition, correction, or clarification?
- Priority: low, medium, or high?

### 3. Create Feedback File

Location: `.claude/plugin-feedback/pending/YYYY-MM-DD-<skill>.md`

Use this template:

```markdown
---
plugin: <plugin-name>
skill: <skill-name>
type: <improvement|addition|correction|clarification>
priority: <low|medium|high>
created: <YYYY-MM-DD>
session_context: "<brief context>"
---

# Feedback: <Title>

## Problem Encountered
<description>

## Current Skill Guidance
<quote from current skill>

## Proposed Change
<specific suggestion>

## Evidence/Example
<code examples>

## Impact
<who this affects>
```

### 4. Confirm Creation

Report:
- File created at path
- Summary of feedback
- Next step: use `/git-workflow:submit-feedback` when ready

### 5. Ensure Directory Exists

```bash
mkdir -p .claude/plugin-feedback/pending
mkdir -p .claude/plugin-feedback/submitted
```
