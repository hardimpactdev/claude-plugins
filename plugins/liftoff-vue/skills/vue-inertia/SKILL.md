---
name: vue-inertia
description: Inertia.js v2 and Waymaker routing patterns. Use when navigating between pages or accessing shared data. Always use Controllers object for routes.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Inertia.js & Waymaker Routing

## When to Apply

Apply when:
- Navigating between pages
- Using Link component
- Accessing shared/auth data
- Working with route parameters

## Route Generation (Waymaker)

```typescript
// Controllers object is globally available (auto-imported)

// Simple routes
Controllers.HomeController.index()
Controllers.UserController.show({ user: userId })

// Multiple parameters
Controllers.CommentController.show({
    post: postId,
    comment: commentId,
})

// Query parameters
Controllers.ProductController.index({
    page: 2,
    sort: 'price',
})
```

## Link Component

```vue
<script setup lang="ts">
import { Link } from '@inertiajs/vue3';
</script>

<template>
    <!-- Simple navigation -->
    <Link :href="Controllers.DashboardController.index()">
        Dashboard
    </Link>

    <!-- With parameters -->
    <Link :href="Controllers.UserController.show({ user: userId })">
        View Profile
    </Link>

    <!-- Non-GET methods -->
    <Link
        :href="Controllers.ProjectController.destroy({ project: id })"
        method="delete"
        as="button"
    >
        Delete
    </Link>

    <!-- Preserve scroll/state -->
    <Link
        :href="Controllers.ProductController.index({ page: 2 })"
        preserve-scroll
        preserve-state
    >
        Next Page
    </Link>

    <!-- Prefetching -->
    <Link :href="Controllers.UserController.index()" prefetch>
        Users
    </Link>
</template>
```

## Programmatic Navigation

```typescript
import { router } from '@inertiajs/vue3';

// Simple navigation
router.visit(Controllers.ProjectController.show({ project: projectId }));

// With options
router.visit(Controllers.UserController.index(), {
    preserveState: true,
    preserveScroll: true,
    only: ['users'],
    onSuccess: () => console.log('Success'),
    onError: (errors) => console.error(errors),
});

// Partial reloads
router.reload({ only: ['notifications'] });
```

## Shared Data Access

```typescript
import { usePage } from '@inertiajs/vue3';

const page = usePage();

// Auth data
const user = computed(() => page.props.auth.user);

// Flash messages
const flash = computed(() => page.props.flash);

// In template
<template>
    <div v-if="user">Welcome, {{ user.name }}!</div>

    <div v-if="flash.success" class="alert-success">
        {{ flash.success }}
    </div>
</template>
```

## Deferred Props (v2)

```php
// Backend
Inertia::render('Dashboard', [
    'stats' => Inertia::defer(fn () => $this->getExpensiveStats()),
]);
```

```vue
<script setup lang="ts">
const page = usePage();
const stats = computed(() => page.props.stats);
</script>

<template>
    <!-- Skeleton while loading -->
    <div v-if="!stats" class="animate-pulse">
        <div class="h-4 bg-gray-200 rounded"></div>
    </div>
    <div v-else>{{ stats }}</div>
</template>
```

## Polling (v2)

```typescript
import { router } from '@inertiajs/vue3';

// Poll every 5 seconds
setInterval(() => {
    router.reload({ only: ['notifications'] });
}, 5000);
```

## Active Link Styling

```vue
<Link
    :href="Controllers.DashboardController.index()"
    :class="{
        'font-bold text-blue-600': $page.component === 'Dashboard/Index'
    }"
>
    Dashboard
</Link>
```

## Error Handling

```typescript
import { router } from '@inertiajs/vue3';

// Global error handling
router.on('error', (event) => {
    if (event.detail.errors.status === 404) {
        console.error('Page not found');
    }
});

// Loading states
router.on('start', () => showLoading());
router.on('finish', () => hideLoading());
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `href="/users"` | `:href="Controllers.UserController.index()"` |
| `<a href="...">` | `<Link :href="...">` |
| `window.location.href = ...` | `router.visit(...)` |
| `Controllers.UserController.show(123)` | `Controllers.UserController.show({ user: 123 })` |
| `$page.props` in script | `usePage().props` |
| Missing null check on auth | `page.props.auth.user?.name` |

## Don'ts

- Never hardcode URLs - use Controllers object
- Never use `<a>` tags for internal navigation
- Never use `window.location` - use Inertia navigation
- Never use positional parameters - use object syntax
- Never mutate shared props - they're readonly
- Never forget loading states for deferred props
- Never skip error handling on navigation
