# liftoff-vue Plugin

Vue 3 + TypeScript patterns for Liftoff projects.

## Skills

| Skill | Description |
|-------|-------------|
| `vue-general` | Vue 3 Composition API patterns |
| `vue-components` | liftoff-vue component library & composables |
| `vue-forms` | Inertia form handling with DTOs |
| `vue-inertia` | Inertia.js v2 & Waymaker routing |
| `vue-typescript` | TypeScript patterns for Vue |
| `vue-tailwind` | Tailwind CSS v4 patterns |
| `vue-autoimports` | Auto-import configuration |

## Key Patterns

- **Composition API only** - No Options API
- **TypeScript required** - Always use `lang="ts"`
- **Script first, template second** - No `<style>` blocks
- **Tailwind only** - No scoped styles
- **DTOs from backend** - Never create empty forms
- **Controllers object** - Never hardcode URLs
- **Auto-imports** - Don't import Vue/Inertia methods

## Installation

```bash
claude /plugin install liftoff-vue
```
