---
name: consolidate-skills
description: Analyze all projects for common skills/agents and extract them into shared plugins. Cleans up abstracted skills while preserving project-specific ones.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

# Consolidate Skills

Scan projects in `~/projects` for common Claude configurations and extract reusable patterns into the plugin marketplace.

## Trigger

```
/consolidate-skills
```

Or reference this skill when asking Claude to consolidate/extract common skills.

## Process Overview

```
┌─────────────────────────────────────────────────────────────────────────┐
│  1. SCAN         Discover all .claude configs in ~/projects             │
├─────────────────────────────────────────────────────────────────────────┤
│  2. ANALYZE      Compare skills/agents/commands across projects         │
├─────────────────────────────────────────────────────────────────────────┤
│  3. CLASSIFY     Categorize as: abstractable vs project-specific        │
├─────────────────────────────────────────────────────────────────────────┤
│  4. EXTRACT      Create/improve plugins with common patterns            │
├─────────────────────────────────────────────────────────────────────────┤
│  5. CLEANUP      Remove abstracted skills from projects                 │
├─────────────────────────────────────────────────────────────────────────┤
│  6. REPORT       Summary of changes made                                │
└─────────────────────────────────────────────────────────────────────────┘
```

## Step 1: Scan Projects

Find all Claude configurations:

```bash
# List all projects
ls -d ~/projects/*/

# Find .claude directories
find ~/projects -maxdepth 2 -type d -name ".claude" 2>/dev/null

# For each project, catalog:
# - .claude/skills/*/SKILL.md
# - .claude/agents/*/AGENT.md
# - .claude/commands/*.md
# - .claude/settings.json
# - .claude/settings.local.json
```

Build inventory structure:

```yaml
projects:
  orchestrator:
    path: ~/projects/orchestrator
    skills:
      - name: custom-api-patterns
        file: .claude/skills/custom-api-patterns/SKILL.md
        content_hash: abc123
    agents:
      - name: pr-reviewer
        file: .claude/agents/pr-reviewer/AGENT.md
    commands:
      - deploy-staging.md

  liftoff-starterkit:
    skills:
      - name: api-patterns  # Similar to orchestrator!
        file: .claude/skills/api-patterns/SKILL.md
        content_hash: abc124
```

## Step 2: Analyze Similarities

For each skill/agent/command found:

### Content Similarity Check

```python
# Pseudocode for similarity detection
for skill_a in all_skills:
    for skill_b in all_skills:
        if skill_a.project != skill_b.project:
            similarity = compare(skill_a.content, skill_b.content)
            if similarity > 0.7:  # 70% similar
                mark_as_candidate(skill_a, skill_b)
```

### Pattern Categories to Look For

| Pattern | Indicators | Action |
|---------|------------|--------|
| **Identical** | Same content, different projects | Extract to plugin |
| **Near-identical** | Minor differences (project names) | Parameterize & extract |
| **Thematically similar** | Same domain, different impl | Merge best practices |
| **Project-specific** | References project internals | Leave untouched |

### Similarity Signals

Mark as **abstractable** if:
- Same technology focus (Laravel, Vue, PHP, etc.)
- Generic patterns (API design, testing, git workflows)
- No hardcoded project paths/names (or easily parameterizable)
- Used by 2+ projects

Mark as **project-specific** if:
- References specific business logic
- Contains project-specific file paths
- Mentions project-specific services/APIs
- Only makes sense in one context

## Step 3: Classify Each Item

Create classification report:

```markdown
## Consolidation Analysis Report

### Abstractable (candidates for extraction)

#### Skills
| Skill Name | Projects Using | Target Plugin | Action |
|------------|---------------|---------------|--------|
| api-patterns | orchestrator, liftoff-starterkit | liftoff-laravel | MERGE |
| vue-forms | liftoff-vue, platform11 | liftoff-vue | EXTRACT |
| pest-patterns | 3 projects | php-quality | IMPROVE |

#### Agents
| Agent Name | Projects Using | Target Plugin | Action |
|------------|---------------|---------------|--------|
| pr-reviewer | all projects | git-workflow | EXTRACT |

### Project-Specific (no action)

| Item | Project | Reason |
|------|---------|--------|
| orchestrator-deploy | orchestrator | References internal infra |
| platform11-billing | platform11 | Business logic specific |
```

## Step 4: Extract to Plugins

For each abstractable item:

### 4a. Determine Target Plugin

```
Technology mapping:
- Laravel/PHP patterns → liftoff-laravel
- Vue/TypeScript patterns → liftoff-vue
- PHP quality tools → php-quality
- Git/release workflows → git-workflow
- Dev environment → dev-environment
- Cross-cutting/meta → NEW plugin or git-workflow
```

### 4b. Create/Update Skill

If creating new skill in plugin:

```bash
mkdir -p ~/claude/plugins/<target-plugin>/skills/<skill-name>/
```

Write SKILL.md with:
- Merged best practices from all sources
- Parameterized project-specific values
- Clear usage documentation

### 4c. Update Plugin Version

```bash
# Bump patch version
cd ~/claude/plugins/<target-plugin>
# Update .claude-plugin/plugin.json version
# Update CHANGELOG.md
```

## Step 5: Cleanup Projects

For each project that had skills extracted:

### 5a. Remove Abstracted Skills

```bash
# Only after confirming extraction successful
rm -rf ~/projects/<project>/.claude/skills/<extracted-skill>/
```

### 5b. Update settings.json

Ensure project's `.claude/settings.json` includes the plugin:

```json
{
  "plugins": {
    "marketplace": "hardimpactdev/claude-plugins",
    "installed": [
      "liftoff-laravel",  // Add if not present
      "php-quality"
    ]
  }
}
```

### 5c. Leave Marker Comment (optional)

In project's `.claude/README.md` or settings:

```markdown
## Consolidated Skills

The following skills were moved to shared plugins:
- `api-patterns` → liftoff-laravel (2026-01-05)
- `pest-helpers` → php-quality (2026-01-05)
```

## Step 6: Generate Report

Output final summary:

```markdown
# Skill Consolidation Report
Date: 2026-01-05

## Projects Scanned
- orchestrator
- liftoff-starterkit
- liftoff-vue
- liftoff-laravel
- waymaker
- platform11-2026
- launchpad-cli

## Extractions Made

### New Skills Created
| Skill | Plugin | Source Projects |
|-------|--------|-----------------|
| api-design-patterns | liftoff-laravel | orchestrator, liftoff-starterkit |

### Existing Skills Improved
| Skill | Plugin | Merged From |
|-------|--------|-------------|
| pest-testing | php-quality | platform11, orchestrator |

## Project Cleanup

| Project | Skills Removed | Plugins Added |
|---------|---------------|---------------|
| orchestrator | api-patterns, pest-helpers | - |
| platform11 | pest-helpers | php-quality |

## Untouched (Project-Specific)

| Project | Item | Reason |
|---------|------|--------|
| orchestrator | deploy-staging | Infra-specific |
| platform11 | billing-rules | Business logic |

## Next Steps
1. Review changes in ~/claude (plugins repo)
2. Commit and push plugin updates
3. Verify projects work with consolidated skills
```

## Safety Rules

1. **Never delete without confirmation** - Always show what will be removed
2. **Backup first** - Create `.claude/backup/` before removing skills
3. **Test extraction** - Verify plugin skill works before cleanup
4. **Preserve project-specific** - When in doubt, leave it
5. **Atomic operations** - Complete one project before moving to next

## Dry Run Mode

Always start with analysis only:

```
/consolidate-skills --dry-run
```

This produces the report without making changes. Only proceed with extraction after reviewing the analysis.

## Rollback

If issues occur:

```bash
# Restore from backup
cp -r ~/projects/<project>/.claude/backup/* ~/projects/<project>/.claude/

# Or revert plugin changes
cd ~/claude
git checkout -- plugins/
```
