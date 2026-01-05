---
name: vue-forms
description: Inertia form handling with DTOs. Use when creating forms that submit to Laravel. Always initialize from props and use form.submit().
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Inertia Form Handling

## When to Apply

Apply when:
- Creating forms with Inertia
- Handling form validation
- Submitting data to Laravel
- Managing form state

## Form Initialization

```typescript
// Always initialize from props (never empty forms)
const props = defineProps<{
    resource: App.Data.UserData;
}>();

const form = useForm(props.resource);

// With defaults for optional fields
const form = useForm({
    ...props.resource,
    tags: props.resource.tags ?? [],
});
```

## Form Submission

```typescript
// Always use form.submit() - Wayfinder includes HTTP method
const createUser = () => {
    form.submit(Controllers.UserController.store(), {
        onSuccess: () => {
            form.reset();
            toast.success('User created');
        },
        onError: () => {
            toast.error('Please check the form errors');
        },
    });
};

// Update with route parameters
const updateProject = () => {
    form.submit(Controllers.ProjectController.update({
        project: props.project.id
    }), {
        preserveScroll: true,
        onSuccess: () => toast.success('Project updated'),
    });
};

// Delete with confirmation
const deleteResource = () => {
    if (!confirm('Are you sure?')) return;

    form.submit(Controllers.ResourceController.destroy({
        resource: props.resource.id
    }));
};
```

## Validation Errors

```vue
<template>
    <div>
        <label for="email">Email</label>
        <input
            id="email"
            v-model="form.email"
            type="email"
            :class="{ 'border-red-500': form.errors.email }"
            @input="form.clearErrors('email')"
        >
        <p v-if="form.errors.email" class="text-sm text-red-600">
            {{ form.errors.email }}
        </p>
    </div>
</template>
```

## Form State

```vue
<template>
    <!-- Disable during processing -->
    <button
        type="submit"
        :disabled="form.processing || !form.isDirty"
    >
        <span v-if="form.processing">Saving...</span>
        <span v-else>Save Changes</span>
    </button>

    <!-- Error summary -->
    <div v-if="form.hasErrors" class="bg-red-50 p-4 rounded">
        <p v-for="(error, field) in form.errors" :key="field">
            {{ field }}: {{ error }}
        </p>
    </div>
</template>
```

## Dynamic Fields

```typescript
// Array fields
const form = useForm({
    ...props.resource,
    contacts: props.resource.contacts || [{ name: '', email: '' }],
});

const addContact = () => {
    form.contacts.push({ name: '', email: '' });
};

const removeContact = (index: number) => {
    form.contacts.splice(index, 1);
};
```

## File Uploads

```typescript
const form = useForm({
    ...props.resource,
    avatar: null as File | null,
});

const handleFileChange = (event: Event) => {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
        form.avatar = file;
    }
};
```

## Unsaved Changes Warning

```typescript
import { onBeforeRouteLeave } from 'vue-router';

onBeforeRouteLeave((to, from, next) => {
    if (form.isDirty && !confirm('You have unsaved changes. Leave anyway?')) {
        next(false);
    } else {
        next();
    }
});
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `useForm({ name: '', email: '' })` | `useForm(props.resource)` |
| `form.post(url)` | `form.submit(Controllers.X.store())` |
| `form.patch(url)` | `form.submit(Controllers.X.update())` |
| Manual interface definition | Use `App.Data.XData` types |
| Ignoring `form.errors` | Display errors for each field |
| No loading state | Check `form.processing` |

## Don'ts

- Never create empty forms - initialize from props
- Never use `form.post()`, `form.patch()`, `form.delete()` - use `form.submit()`
- Never manually construct URLs - use Wayfinder Controllers
- Never define TypeScript interfaces manually - use generated types
- Never ignore validation errors
- Never forget to disable submit button during processing
- Never modify the DTO structure (field names must match backend)
