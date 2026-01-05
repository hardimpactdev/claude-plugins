# Claude Code Plugin Plan

## Executive Summary

After analyzing the 7 projects in `~/projects`, I identified significant overlap in AI configurations, rules, skills, and workflows that can be consolidated into reusable Claude Code plugins. This document outlines a strategic plan for creating plugins that eliminate duplication and provide a consistent development experience across the Liftoff ecosystem.

---

## Analysis of Current State

### Projects Analyzed

| Project | Purpose | AI Config |
|---------|---------|-----------|
| **orchestrator** | Claude agent management & task pipeline | Full .ai/rules/, MCP, commands |
| **liftoff-starterkit** | Full-stack starter template | Full .ai/rules/, MCP, commands |
| **liftoff-laravel** | Laravel scaffolding package | CLAUDE.md only |
| **liftoff-vue** | Vue component library | CLAUDE.md, custom MCP server |
| **waymaker** | Route generation package | CLAUDE.md only |
| **launchpad-cli** | Docker-based dev environment | Skills, hooks |
| **platform11-2026** | Application using Liftoff | Minimal |

### Identified Overlaps

#### 1. Duplicated Rules (18 files, ~200KB total)

**Backend Rules** (orchestrator = liftoff-starterkit):
- `General.mdc` - PHP 8.4/Laravel 12 conventions
- `Controllers.mdc` - Controller patterns
- `Routes.mdc` - Waymaker routing
- `FormRequests.mdc` - Validation patterns
- `Models.mdc` - Eloquent conventions
- `Database.mdc` - Migrations, factories
- `DTOs.mdc` - Laravel Data patterns
- `Enums.mdc` - Enum usage
- `Middleware.mdc` - Middleware patterns
- `Testing.mdc` - Pest testing

**Frontend Rules** (orchestrator = liftoff-starterkit):
- `Vue.mdc` - Vue 3 Composition API
- `Inertia.mdc` - Inertia.js patterns
- `TypeScript.mdc` - TypeScript conventions
- `LiftoffUI.mdc` - Component library usage
- `Tailwind.mdc` - Tailwind CSS v4
- `AutoImports.mdc` - Unplugin patterns
- `Routing.mdc` - Frontend routing
- `Forms.mdc` - VeeValidate + Zod

**Development Rules**:
- `laravel-boost.mdc` - MCP tool usage
- `herd.mdc` - Local development
- `pint.mdc` - Code formatting

#### 2. Duplicated Commands

| Command | Projects | Purpose |
|---------|----------|---------|
| `wrap-up.md` | orchestrator, liftoff-starterkit | Update CLAUDE.md/README.md after sessions |

**The wrap-up command is 100% identical in both projects.**

#### 3. Skills (Currently Isolated)

| Skill | Project | Purpose |
|-------|---------|---------|
| `release-version` | launchpad-cli | Semantic versioning, GitHub releases |

This skill is broadly applicable but only exists in one project.

#### 4. Hooks

| Hook Type | Project | Commands |
|-----------|---------|----------|
| PostToolUse (Write) | launchpad-cli | Rector, Pint, PHPStan, Pest, log check |
| Pre-commit (whisky) | orchestrator | lint, rector, format |
| Pre-push (whisky) | orchestrator | test, analyse, oxlint |

#### 5. MCP Servers

| Server | Projects | Purpose |
|--------|----------|---------|
| `laravel-boost` | orchestrator, liftoff-starterkit | Laravel artisan, docs |
| `herd` | orchestrator, liftoff-starterkit | Local PHP development |
| `liftoff-vue` | liftoff-vue | Component discovery |

---

## Proposed Plugin Architecture

### Plugin 1: `liftoff-laravel` (Highest Priority)

**Purpose**: Comprehensive Laravel development support for the Liftoff ecosystem.

**Components**:
```
liftoff-laravel/
├── .claude-plugin/plugin.json
├── skills/
│   ├── laravel-general/SKILL.md      # From General.mdc
│   ├── laravel-controllers/SKILL.md  # From Controllers.mdc
│   ├── laravel-routes/SKILL.md       # From Routes.mdc (Waymaker)
│   ├── laravel-validation/SKILL.md   # From FormRequests.mdc
│   ├── laravel-models/SKILL.md       # From Models.mdc
│   ├── laravel-database/SKILL.md     # From Database.mdc
│   ├── laravel-dtos/SKILL.md         # From DTOs.mdc
│   ├── laravel-enums/SKILL.md        # From Enums.mdc
│   ├── laravel-middleware/SKILL.md   # From Middleware.mdc
│   └── laravel-testing/SKILL.md      # From Testing.mdc
├── commands/
│   ├── scaffold.md        # Generate Laravel components
│   └── quality-check.md   # Run all quality tools
├── hooks/
│   └── hooks.json         # PHP file write hooks
├── .mcp.json              # laravel-boost server
└── README.md
```

**Why This Plugin**:
- Consolidates 10 duplicated backend rules
- Provides consistent Laravel patterns across all projects
- Integrates with laravel-boost MCP server
- Skills are auto-invoked when working on PHP/Laravel code

---

### Plugin 2: `liftoff-vue` (High Priority)

**Purpose**: Vue 3 + TypeScript + Tailwind development support.

**Components**:
```
liftoff-vue/
├── .claude-plugin/plugin.json
├── skills/
│   ├── vue-components/SKILL.md     # From Vue.mdc
│   ├── vue-inertia/SKILL.md        # From Inertia.mdc
│   ├── vue-typescript/SKILL.md     # From TypeScript.mdc
│   ├── vue-tailwind/SKILL.md       # From Tailwind.mdc
│   ├── vue-forms/SKILL.md          # From Forms.mdc
│   ├── vue-routing/SKILL.md        # From Routing.mdc
│   └── liftoff-ui/SKILL.md         # From LiftoffUI.mdc
├── commands/
│   ├── component.md       # Generate Vue components
│   └── composable.md      # Generate composables
├── .mcp.json              # liftoff-vue component discovery server
└── README.md
```

**Why This Plugin**:
- Consolidates 8 duplicated frontend rules
- Integrates liftoff-vue MCP server for component discovery
- Auto-imports guidance included
- Consistent patterns for forms, routing, TypeScript

---

### Plugin 3: `php-quality` (High Priority)

**Purpose**: Automated PHP code quality enforcement.

**Components**:
```
php-quality/
├── .claude-plugin/plugin.json
├── skills/
│   ├── php-formatting/SKILL.md    # Pint rules
│   └── php-analysis/SKILL.md      # PHPStan/Larastan
├── commands/
│   ├── lint.md           # Run all linters
│   ├── fix.md            # Auto-fix issues
│   └── test.md           # Run Pest tests
├── hooks/
│   └── hooks.json        # Post-write: Rector, Pint, PHPStan, Pest
├── scripts/
│   ├── post-php-write.sh
│   └── pre-commit.sh
└── README.md
```

**Why This Plugin**:
- Extracted from launchpad-cli hooks
- Runs quality checks on every PHP file write
- Integrates Rector, Pint, PHPStan, Pest
- Log monitoring for errors

---

### Plugin 4: `git-workflow` (Medium Priority)

**Purpose**: Git workflow automation and documentation maintenance.

**Components**:
```
git-workflow/
├── .claude-plugin/plugin.json
├── skills/
│   └── release-version/         # From launchpad-cli
│       ├── SKILL.md
│       └── reference.md
├── commands/
│   ├── wrap-up.md               # From orchestrator
│   ├── release.md               # Trigger release skill
│   └── changelog.md             # Generate changelog
├── agents/
│   └── documentation-reviewer.md
└── README.md
```

**Why This Plugin**:
- Consolidates wrap-up command (currently duplicated)
- Generalizes release-version skill
- Works with any git repository
- Documentation maintenance automation

---

### Plugin 5: `dev-environment` (Medium Priority)

**Purpose**: Local development environment management.

**Components**:
```
dev-environment/
├── .claude-plugin/plugin.json
├── skills/
│   └── local-dev/SKILL.md       # From herd.mdc
├── commands/
│   ├── serve.md          # Start local server
│   ├── status.md         # Check dev environment
│   └── logs.md           # View Laravel logs
├── .mcp.json             # herd server
└── README.md
```

**Why This Plugin**:
- Herd integration
- Development workflow commands
- Log monitoring

---

### Plugin 6: `liftoff-scaffold` (Lower Priority)

**Purpose**: Project scaffolding and initialization.

**Components**:
```
liftoff-scaffold/
├── .claude-plugin/plugin.json
├── commands/
│   ├── init.md           # Initialize new project
│   ├── setup.md          # Run setup.php equivalent
│   └── configure.md      # Configure project settings
├── agents/
│   └── project-setup.md  # Full project setup agent
└── README.md
```

**Why This Plugin**:
- Automates liftoff-starterkit setup
- Replaces setup.php with Claude-driven setup
- Handles dependency installation

---

## Implementation Priority

### Phase 1: Foundation (Recommended First)

1. **`liftoff-laravel`** - Most duplicated content, highest value
2. **`php-quality`** - Critical for development workflow

### Phase 2: Frontend

3. **`liftoff-vue`** - Frontend consistency

### Phase 3: Workflow

4. **`git-workflow`** - Consolidate duplicated commands
5. **`dev-environment`** - Development tooling

### Phase 4: Convenience

6. **`liftoff-scaffold`** - Project initialization

---

## Migration Strategy

### For Existing Projects

1. Install plugins at user scope: `claude plugin install <plugin>@marketplace --scope user`
2. Remove duplicated `.ai/rules/` directories
3. Keep project-specific customizations in `.claude/settings.json`

### For New Projects

1. Start with plugins pre-installed
2. No need for `.ai/rules/` directory
3. Customize via plugin configuration or local overrides

---

## Marketplace Structure

```
claude-plugins-marketplace/
├── .claude-plugin/
│   └── marketplace.json
├── plugins/
│   ├── liftoff-laravel/
│   ├── liftoff-vue/
│   ├── php-quality/
│   ├── git-workflow/
│   ├── dev-environment/
│   └── liftoff-scaffold/
└── README.md
```

---

## Key Benefits

1. **Eliminate Duplication**: 18 rule files consolidated into 2-3 plugins
2. **Consistency**: Same development experience across all projects
3. **Maintainability**: Update once, apply everywhere
4. **Discoverability**: Skills auto-invoke based on context
5. **Extensibility**: Easy to add new capabilities
6. **Versioning**: Semantic versioning for controlled updates

---

## Recommended First Plugin: `liftoff-laravel`

Start with this plugin because:
- Highest duplication (10 rule files, ~100KB)
- Used by most projects in the ecosystem
- Integrates with existing laravel-boost MCP server
- Provides immediate value for Laravel development
- Foundation for php-quality plugin hooks

---

## Questions to Resolve

1. Should laravel-boost MCP server be bundled or referenced externally?
2. Should rules be split into multiple skills or consolidated?
3. What's the preferred skill granularity (fine vs coarse)?
4. Should hooks run automatically or require opt-in?
5. How to handle project-specific rule overrides?

---

## Next Steps

1. Approve plugin plan
2. Create `liftoff-laravel` plugin structure
3. Migrate rules from orchestrator/.ai/rules/backend/
4. Add hooks for PHP quality checks
5. Test with existing projects
6. Proceed to next plugin
