---
name: vue-tailwind
description: Tailwind CSS v4 patterns. Use when styling components with Tailwind. Use gap for spacing, opacity modifiers, and v4 utility names.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Tailwind CSS v4 Patterns

## When to Apply

Apply when:
- Styling Vue components
- Working with layout/spacing
- Using colors with opacity
- Responsive design

## v4 Breaking Changes

```html
<!-- Opacity modifiers (not separate classes) -->
<div class="bg-red-500/60">60% opacity</div>
<div class="text-black/50">50% opacity text</div>

<!-- Renamed utilities -->
<div class="bg-linear-to-r from-blue-500 to-purple-500">Gradient</div>
<div class="shadow-xs">Extra small shadow</div>
<div class="rounded-xs">Extra small radius</div>
<div class="outline-hidden">Hidden outline</div>
<div class="ring-3">3px ring</div>

<!-- Renamed flex utilities -->
<div class="shrink-0">No shrink</div>
<div class="grow">Grow</div>
```

## Spacing with Gap

```html
<!-- Always use gap in flex/grid (not margins or space-*) -->
<div class="flex gap-4">
    <div>Item 1</div>
    <div>Item 2</div>
    <div>Item 3</div>
</div>

<!-- Works with flex-wrap -->
<div class="flex flex-wrap gap-4">
    <!-- Gap handles wrapped items correctly -->
</div>

<!-- Grid gap -->
<div class="grid grid-cols-3 gap-6">
    <!-- Consistent spacing -->
</div>
```

## Typography

```html
<!-- Line height modifiers (not leading-*) -->
<p class="text-base/7">Text with line height 7</p>
<p class="text-lg/8">Large text with line height 8</p>

<!-- Sizes reference -->
<!-- text-xs = 12px, text-sm = 14px, text-base = 16px -->
<!-- text-lg = 18px, text-xl = 20px -->
```

## Responsive Design

```html
<!-- Only add breakpoint when value changes -->
<div class="px-4 lg:px-8">
    <!-- Efficient: changes at lg only -->
</div>

<!-- Mobile viewport height (not min-h-screen) -->
<div class="min-h-dvh">
    <!-- Works correctly on mobile Safari -->
</div>
```

## Container Queries (v4)

```html
<!-- Container query setup -->
<article class="@container">
    <div class="flex flex-col @md:flex-row @lg:gap-8">
        <img class="w-full @md:w-48" />
        <div class="mt-4 @md:mt-0">
            Content adapts to container
        </div>
    </div>
</article>
```

## Dark Mode

```html
<!-- Light first, then dark variant -->
<div class="bg-white text-black dark:bg-gray-900 dark:text-white">
    <button class="hover:bg-gray-100 dark:hover:bg-gray-800">
        Click me
    </button>
</div>
```

## Size Utilities

```html
<!-- Use size-* for equal width/height -->
<div class="size-12">48px square</div>
<div class="size-16">64px square</div>

<!-- Instead of separate w-* h-* -->
```

## CSS Variables

```css
/* Extend theme with CSS */
@import "tailwindcss";

@theme {
    --color-brand-500: oklch(0.72 0.11 178);
}

/* Access theme values */
.custom {
    background: var(--color-red-500);
    margin-top: calc(100vh - --spacing(16));
}
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `bg-opacity-60` | `bg-red-500/60` |
| `space-x-4` in flex | `gap-4` |
| `leading-7` | `text-base/7` |
| `bg-gradient-to-r` | `bg-linear-to-r` |
| `min-h-screen` | `min-h-dvh` |
| `w-12 h-12` | `size-12` |
| `shadow-sm` (v3) | `shadow-xs` (v4) |
| `rounded-sm` (v3) | `rounded-xs` (v4) |

## Don'ts

- Never use `@apply` - use CSS variables or components
- Never use `space-x-*` or `space-y-*` in flex/grid - use gap
- Never use deprecated opacity utilities
- Never use arbitrary values when scale exists (`ml-4` not `ml-[16px]`)
- Never add redundant breakpoint classes
- Never use `leading-*` classes - use line-height modifiers
- Never use `min-h-screen` - use `min-h-dvh`
