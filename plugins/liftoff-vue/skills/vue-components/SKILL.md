---
name: vue-components
description: liftoff-vue component library and composable patterns. Use when building UI with liftoff-vue components or extracting reusable logic.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Component Library & Composables

## When to Apply

Apply when:
- Using liftoff-vue components
- Creating composables
- Building page layouts
- Working with navigation

## liftoff-vue Imports

```typescript
import {
    AppLayout,
    Button,
    Card,
    CardContent,
    CardHeader,
    Tabs,
    TabsList,
    TabsTrigger,
    TabsContent,
    SidebarProvider,
    Sidebar,
    SidebarInset,
} from '@aspect/liftoff-vue';
```

## AppLayout Usage

```vue
<script setup lang="ts">
import { AppLayout } from '@aspect/liftoff-vue';

defineProps<{
    auth: { user: { id: number; name: string; email: string } };
    navigation: NavigationConfig;
}>();
</script>

<template>
    <AppLayout :auth="auth" :navigation="navigation">
        <!-- Page content -->
    </AppLayout>
</template>
```

## Backend-Driven Navigation

Navigation is configured in `HandleInertiaRequests` middleware:

```php
// app/Http/Middleware/HandleInertiaRequests.php
'navigation' => [
    'app' => [
        'main' => [
            'items' => [
                ['title' => 'Dashboard', 'href' => '/dashboard', 'icon' => 'Home', 'isActive' => true],
                ['title' => 'Projects', 'href' => '/projects', 'icon' => 'Folder'],
            ]
        ],
        'footer' => [
            'items' => [
                ['title' => 'Settings', 'href' => '/settings', 'icon' => 'Settings'],
            ]
        ]
    ]
]
```

## Component Composition

```vue
<template>
    <!-- Cards compose together -->
    <Card>
        <CardHeader>
            <CardTitle>Title</CardTitle>
            <CardDescription>Description</CardDescription>
        </CardHeader>
        <CardContent>
            Content here
        </CardContent>
    </Card>

    <!-- Tabs require all parts -->
    <Tabs default-value="tab1">
        <TabsList>
            <TabsTrigger value="tab1">Tab 1</TabsTrigger>
            <TabsTrigger value="tab2">Tab 2</TabsTrigger>
        </TabsList>
        <TabsContent value="tab1">Content 1</TabsContent>
        <TabsContent value="tab2">Content 2</TabsContent>
    </Tabs>
</template>
```

## Composables Pattern

```typescript
// composables/useCounter.ts
import { ref, readonly, onUnmounted } from 'vue';

export function useCounter(options?: { initial?: number }) {
    const count = ref(options?.initial ?? 0);

    const increment = () => count.value++;
    const decrement = () => count.value--;
    const reset = () => (count.value = options?.initial ?? 0);

    return {
        count: readonly(count),
        increment,
        decrement,
        reset,
    };
}
```

## Composable with Cleanup

```typescript
export function useInterval(callback: () => void, delay: number) {
    const intervalId = ref<number>();

    const start = () => {
        intervalId.value = window.setInterval(callback, delay);
    };

    const stop = () => {
        if (intervalId.value) {
            clearInterval(intervalId.value);
        }
    };

    onUnmounted(stop);

    return { start, stop };
}
```

## Async Composable

```typescript
export function useAsyncData<T>(fetcher: () => Promise<T>) {
    const data = ref<T>();
    const error = ref<Error>();
    const loading = ref(false);

    const execute = async () => {
        loading.value = true;
        error.value = undefined;
        try {
            data.value = await fetcher();
        } catch (e) {
            error.value = e as Error;
        } finally {
            loading.value = false;
        }
    };

    return { data, error, loading, execute };
}
```

## Conditional Classes

```vue
<script setup lang="ts">
import { cn } from '@aspect/liftoff-vue';
</script>

<template>
    <div :class="cn(
        'base-classes',
        isActive && 'active-classes',
        variant === 'primary' && 'primary-classes'
    )">
        Content
    </div>
</template>
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| Custom sidebar inside AppLayout | Use AppLayout's built-in sidebar |
| Navigation in Vue components | Configure in HandleInertiaRequests |
| `icon: 'home'` | `icon: 'Home'` (PascalCase) |
| TabsList without TabsTrigger | Always include required children |
| `function counterLogic()` | `function useCounter()` (use prefix) |
| Composable without cleanup | Use `onUnmounted` for intervals/listeners |

## Don'ts

- Never wrap AppLayout in another layout
- Never create custom sidebars when AppLayout exists
- Never configure navigation in Vue components
- Never break composable naming convention (`use` prefix)
- Never forget cleanup in composables (timers, listeners)
- Never override component styles unnecessarily
