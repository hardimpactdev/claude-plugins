# Consolidate Skills Command

Scan all projects in `~/projects` and extract common skills/agents into shared plugins.

## Usage

```
/consolidate-skills [--dry-run] [--project <name>] [--verbose]
```

## Options

| Option | Description |
|--------|-------------|
| `--dry-run` | Analyze only, don't make changes (default first run) |
| `--project <name>` | Only analyze specific project |
| `--verbose` | Show detailed similarity analysis |

## Examples

```bash
# Analyze all projects (dry run)
/consolidate-skills

# Full consolidation with changes
/consolidate-skills --apply

# Check single project
/consolidate-skills --project orchestrator --dry-run
```

## Instructions

When this command is invoked:

### Phase 1: Discovery

1. **Scan ~/projects for .claude directories**

```bash
find ~/projects -maxdepth 2 -type d -name ".claude" 2>/dev/null
```

2. **For each project, inventory:**
   - Skills: `.claude/skills/*/SKILL.md`
   - Agents: `.claude/agents/*/AGENT.md`
   - Commands: `.claude/commands/*.md`
   - Settings: `.claude/settings.json`

3. **Build inventory table** showing all items across projects

### Phase 2: Analysis

4. **Compare items across projects:**
   - Read content of each skill/agent
   - Identify naming similarities
   - Check content overlap (similar headings, patterns, tools)
   - Note technology focus (Laravel, Vue, PHP, etc.)

5. **Classify each item:**

   **Abstractable criteria:**
   - Same/similar name across 2+ projects
   - Generic technology patterns
   - No hardcoded project paths
   - Reusable guidance

   **Project-specific criteria:**
   - References specific business logic
   - Contains project-only file paths
   - Unique to project's domain
   - Mentions internal services

### Phase 3: Report (Dry Run stops here)

6. **Present classification report:**

```markdown
## Consolidation Analysis

### Candidates for Extraction
| Item | Type | Projects | Target Plugin | Similarity |
|------|------|----------|---------------|------------|
| ... | skill | proj1, proj2 | liftoff-laravel | 85% |

### Project-Specific (No Action)
| Item | Project | Reason |
|------|---------|--------|
| ... | proj1 | Contains business logic |

Proceed with extraction? [y/N]
```

### Phase 4: Extraction (if --apply or confirmed)

7. **For each abstractable item:**
   - Determine target plugin based on technology
   - Merge content from all source projects
   - Create/update skill in plugin
   - Update plugin's CHANGELOG.md

8. **Map to plugins:**
   ```
   Laravel/PHP → liftoff-laravel
   Vue/TS → liftoff-vue
   PHP tools → php-quality
   Git/releases → git-workflow
   Dev env → dev-environment
   ```

### Phase 5: Cleanup

9. **For each project with extracted skills:**
   - Create backup: `.claude/backup/YYYY-MM-DD/`
   - Remove abstracted skill directories
   - Update `.claude/settings.json` with required plugins
   - Add consolidation note

### Phase 6: Summary

10. **Output final report:**
    - Skills extracted
    - Plugins updated
    - Projects cleaned
    - Items preserved (project-specific)

11. **Remind to commit changes:**
```
Changes made to:
- ~/claude/plugins/... (commit & push)
- ~/projects/*/... (commit per project)
```

## Safety

- Always runs in dry-run mode first
- Creates backups before removing anything
- Requires confirmation for destructive actions
- Preserves anything ambiguous as project-specific
