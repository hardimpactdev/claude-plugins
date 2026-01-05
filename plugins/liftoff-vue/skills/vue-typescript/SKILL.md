---
name: vue-typescript
description: TypeScript patterns for Vue. Use when typing props, emits, refs, or working with types. Prefer type over interface, const objects over enums.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# TypeScript Patterns

## When to Apply

Apply when:
- Typing Vue components
- Creating type definitions
- Working with generics
- Handling errors with types

## Type Definitions

```typescript
// Prefer type over interface
type User = {
    id: string;
    name: string;
    email: string;
    role: 'admin' | 'user';
};

// Union types
type ApiResponse<T> =
    | { success: true; data: T }
    | { success: false; error: string };

// Utility types
type PartialUser = Partial<User>;
type ReadonlyUser = Readonly<User>;
type UserKeys = keyof User;
```

## Const Objects (Not Enums)

```typescript
// Use const objects instead of enums
export const UserRole = {
    ADMIN: 'admin',
    USER: 'user',
    GUEST: 'guest',
} as const;

export type UserRole = typeof UserRole[keyof typeof UserRole];

// Const assertions for tuples
const RGB = [255, 128, 0] as const;

// Configuration objects
export const API_ENDPOINTS = {
    USERS: '/api/users',
    POSTS: '/api/posts',
} as const;
```

## Function Typing

```typescript
// Always type parameters and returns
const calculateTotal = (items: CartItem[]): number => {
    return items.reduce((sum, item) => sum + item.price * item.quantity, 0);
};

// Async functions
const fetchUser = async (id: string): Promise<User | null> => {
    try {
        const response = await api.get(`/users/${id}`);
        return response.data;
    } catch {
        return null;
    }
};

// Function types
type EventHandler<T = void> = (event: Event) => T;
type AsyncOperation<T> = () => Promise<T>;

// Generics
const mapArray = <T, U>(items: T[], transform: (item: T) => U): U[] => {
    return items.map(transform);
};
```

## Vue Component Types

```typescript
// Props interface
type Props = {
    title: string;
    count?: number;
    variant?: 'primary' | 'secondary';
};

const props = withDefaults(defineProps<Props>(), {
    count: 0,
    variant: 'primary',
});

// Typed emits
const emit = defineEmits<{
    'update:count': [value: number];
    'close': [];
}>();

// Template refs
const inputRef = ref<HTMLInputElement>();
const componentRef = ref<InstanceType<typeof ChildComponent>>();
```

## Type Guards

```typescript
// Custom type guard
const isUser = (value: unknown): value is User => {
    return (
        typeof value === 'object' &&
        value !== null &&
        'id' in value &&
        'email' in value
    );
};

// Error type guard
const isApiError = (error: unknown): error is ApiError => {
    return (
        typeof error === 'object' &&
        error !== null &&
        'code' in error &&
        'message' in error
    );
};

// Usage
if (isUser(data)) {
    console.log(data.email); // TypeScript knows it's a User
}
```

## Result Pattern

```typescript
type Result<T, E = Error> =
    | { ok: true; value: T }
    | { ok: false; error: E };

const parseJson = <T>(json: string): Result<T, SyntaxError> => {
    try {
        return { ok: true, value: JSON.parse(json) };
    } catch (error) {
        return { ok: false, error: error as SyntaxError };
    }
};

// Usage
const result = parseJson<User>(jsonString);
if (result.ok) {
    console.log(result.value.name);
} else {
    console.error(result.error.message);
}
```

## Naming Conventions

```typescript
// Types/Interfaces: PascalCase
type UserProfile = { ... };

// Type parameters: T prefix
type ApiResponse<TData, TError = string> = { ... };

// Constants: UPPER_SNAKE_CASE
const MAX_RETRY_COUNT = 3;
const API_BASE_URL = 'https://api.example.com';

// Booleans: is/has/should prefix
const isLoading = ref(false);
const hasError = ref(false);
const shouldRetry = computed(() => ...);

// Functions: verb prefix
const fetchUserData = async () => { ... };
const validateEmail = (email: string) => { ... };
```

## Import Patterns

```typescript
// Group by type
import { ref, computed } from 'vue';
import { z } from 'zod';

import { useAuth } from '@/composables/useAuth';
import { api } from '@/services/api';

// Type imports
import type { User, Post } from '@/types';

// Named exports
export const useUser = () => { ... };
export type { UserProfile, UserSettings };
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `type Data = any` | `type Data = unknown` |
| `enum UserRole { ... }` | `const UserRole = { ... } as const` |
| `interface User { ... }` | `type User = { ... }` |
| Missing return type | `(): ReturnType => { ... }` |
| `const handler: Function` | `const handler: () => void` |
| `error.message` in catch | Type guard first |

## Don'ts

- Never use `any` - use `unknown` and type guards
- Never use `@ts-ignore` - fix the type issue
- Never use enums - use const objects with `as const`
- Never use `interface` for object types - use `type`
- Never forget return types on functions
- Never use unsafe type assertions without validation
- Never use `Function` type - define specific signatures
- Never use default exports - use named exports
