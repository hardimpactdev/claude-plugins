# Submit Feedback Command

Review pending feedback and create pull requests to the plugin marketplace repository.

## Usage

```
/git-workflow:submit-feedback [--all | --file <path>]
```

## Examples

```
/git-workflow:submit-feedback
/git-workflow:submit-feedback --all
/git-workflow:submit-feedback --file .claude/plugin-feedback/pending/2026-01-05-laravel-routes.md
```

## Instructions

When this command is invoked:

### 1. Find Pending Feedback

```bash
ls -la .claude/plugin-feedback/pending/
```

If no files found, report "No pending feedback to submit."

### 2. Review Each Feedback File

For each file (or specified file):
1. Read and parse the feedback
2. Validate required fields present
3. Show summary to user for confirmation

### 3. Create Branch in Plugins Repo

```bash
cd /home/launchpad/claude  # Local clone of hardimpactdev/claude-plugins
git checkout main && git pull
git checkout -b feedback/<project>-<skill>-<date>
```

### 4. Apply Changes to Skill

1. Locate target: `plugins/<plugin>/skills/<skill>/SKILL.md`
2. Read current content
3. Apply proposed changes from feedback
4. Validate YAML frontmatter still valid

### 5. Commit Changes

```bash
git add plugins/<plugin>/skills/<skill>/
git commit -m "$(cat <<'EOF'
skill(<plugin>): <summary from feedback>

Source: <project-name>
Type: <improvement|addition|correction|clarification>
Priority: <priority>

<detailed description from feedback>

Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
EOF
)"
```

### 6. Push and Create PR

```bash
git push -u origin feedback/<project>-<skill>-<date>

gh pr create \
  --title "skill(<plugin>): <summary>" \
  --body "$(cat <<'EOF'
## Skill Improvement Proposal

**Plugin**: `<plugin>`
**Skill**: `<skill>`
**Source Project**: `<project>`
**Type**: <type>
**Priority**: <priority>

### Context
<session_context from feedback>

### Problem/Gap
<problem description>

### Changes Made
<summary of changes>

### Evidence
<code examples>

---
Generated via plugin auto-improvement workflow
EOF
)"
```

### 7. Update Feedback Status

```bash
mv .claude/plugin-feedback/pending/<file> .claude/plugin-feedback/submitted/
```

Add PR URL to the file's frontmatter:
```yaml
pr_url: https://github.com/hardimpactdev/claude-plugins/pull/XX
submitted: YYYY-MM-DD
```

### 8. Report Results

```
Feedback submitted successfully!

PR Created: https://github.com/hardimpactdev/claude-plugins/pull/XX
Plugin: liftoff-laravel
Skill: laravel-routes

Feedback moved to: .claude/plugin-feedback/submitted/

Next steps:
1. Review the PR on GitHub
2. Address any review comments
3. Merge when approved
```
