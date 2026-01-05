---
name: vue-autoimports
description: Auto-import configuration for Vue, Inertia, and VueUse. Check auto-imports.d.ts and components.d.ts before manually importing.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Auto-Imports Configuration

## When to Apply

Apply when:
- Adding imports to Vue files
- Using Vue methods or composables
- Using Inertia components
- Checking available utilities

## Auto-Imported (Do Not Import)

### Vue Methods

```typescript
// These are auto-imported - don't add imports
ref
reactive
computed
watch
watchEffect
onMounted
onUnmounted
toRef
toRefs
```

### Inertia Components & Methods

```typescript
// These are auto-imported - don't add imports
Head
Link
useForm
usePage
router
```

### VueUse Composables

```typescript
// These are auto-imported - don't add imports
useLocalStorage
useSessionStorage
useDark
useToggle
// ... and many more
```

### Controllers Object

```typescript
// Globally available for Waymaker routing
Controllers.UserController.show({ user: id })
Controllers.ProjectController.index()
```

## Check Before Importing

```bash
# Check for auto-imported methods
resources/js/types/auto-imports.d.ts

# Check for auto-imported components
resources/js/types/components.d.ts

# Check configuration
vite.config.ts
```

## Component Usage Rules

```vue
<script setup lang="ts">
// No need to import Head, Link, ref, computed, etc.

const form = useForm(props.resource);
const page = usePage();
const count = ref(0);
const doubled = computed(() => count.value * 2);
</script>

<template>
    <Head title="Page Title" />
    <Link :href="Controllers.HomeController.index()">Home</Link>
</template>
```

## When to Import

Only import when:
- The item is NOT in auto-imports.d.ts
- The item is NOT in components.d.ts
- You need a specific type

```typescript
// Types still need importing
import type { User, Project } from '@/types';

// Custom composables need importing
import { useCustomHook } from '@/composables/useCustomHook';

// Utility functions need importing
import { formatDate } from '@/utils/date';
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `import { ref } from 'vue'` | `ref` is auto-imported |
| `import { Link } from '@inertiajs/vue3'` | `Link` is auto-imported |
| `import { useForm } from '@inertiajs/vue3'` | `useForm` is auto-imported |
| Adding new UI libraries | Use existing components |

## Don'ts

- Never import Vue reactivity methods (ref, computed, etc.)
- Never import Inertia components (Head, Link, etc.)
- Never import VueUse composables
- Never introduce new UI component libraries
- Never assume - check auto-imports.d.ts first
