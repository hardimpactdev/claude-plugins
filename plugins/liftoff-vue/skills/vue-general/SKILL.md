---
name: vue-general
description: Vue 3 Composition API patterns. Use when creating Vue components or working with reactive state. Always use script setup with TypeScript.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Vue 3 Development Patterns

## When to Apply

Apply when:
- Creating Vue components
- Managing reactive state
- Defining props and events
- Writing component logic

## Component Structure

```vue
<script setup lang="ts">
import { reactive, computed, ref } from 'vue';

interface Props {
    title: string;
    count?: number;
}

const props = withDefaults(defineProps<Props>(), {
    count: 0,
});

const emit = defineEmits<{
    'update:modelValue': [value: string];
    'item-selected': [item: Item];
}>();

const state = reactive({
    isOpen: false,
    items: [] as Item[],
});

const itemCount = computed(() => state.items.length);
</script>

<template>
    <div class="p-4">
        <h2 class="text-xl font-bold">{{ props.title }}</h2>
        <!-- Content -->
    </div>
</template>
```

## Key Rules

1. **Script first, template second** - No `<style>` blocks
2. **Always TypeScript** - Use `lang="ts"` on script
3. **Composition API only** - Never use Options API
4. **Tailwind only** - No scoped styles or inline styles

## State Management

```typescript
// Group related state with reactive
const state = reactive({
    isOpen: false,
    items: [] as Item[],
    selectedId: null as number | null,
});

// Use computed for derived state
const selectedItem = computed(() =>
    state.items.find(item => item.id === state.selectedId)
);

// Reserve ref for DOM elements
const inputRef = ref<HTMLInputElement>();
```

## Props and Emits

```typescript
// Typed props with defaults
interface Props {
    title: string;
    count?: number;
    variant?: 'primary' | 'secondary';
}

const props = withDefaults(defineProps<Props>(), {
    count: 0,
    variant: 'primary',
});

// Typed emits
const emit = defineEmits<{
    'update:modelValue': [value: string];
    'item-selected': [item: Item];
    'close': [];
}>();

// Usage
emit('update:modelValue', newValue);
```

## Template Patterns

```vue
<template>
    <article class="p-4">
        <h2 class="text-xl font-bold">{{ props.title }}</h2>

        <!-- Conditional rendering -->
        <ul v-if="state.items.length > 0" class="mt-4">
            <li v-for="item in state.items" :key="item.id" class="py-2">
                {{ item.name }}
            </li>
        </ul>
        <p v-else class="text-gray-500">No items available</p>

        <!-- Frequent toggles use v-show -->
        <dialog v-show="state.isOpen" class="fixed inset-0">
            <!-- Content -->
        </dialog>
    </article>
</template>
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `<template>` before `<script>` | `<script setup>` first |
| Missing `lang="ts"` | Always include TypeScript |
| `<style scoped>` | Use Tailwind classes only |
| `defineProps<Props>()` unbound | `const props = defineProps<Props>()` |
| `ref({...})` for state | `reactive({...})` for objects |
| Options API | Composition API with `<script setup>` |

## Don'ts

- Never use Options API (`data()`, `methods()`, etc.)
- Never use `<style>` blocks - Tailwind only
- Never use inline styles (`:style="..."`)
- Never mutate props directly
- Never use arbitrary Tailwind values (`w-[397px]`)
- Never put `v-if` and `v-for` on the same element
- Never forget `:key` in v-for loops
