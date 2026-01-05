---
name: laravel-enums
description: PHP 8 enum patterns for Laravel. Use when creating enums for statuses, types, or fixed value sets. Prefer string-backed enums over class constants.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# PHP Enum Patterns

## When to Apply

Apply when:
- Creating status or type enums
- Replacing class constants
- Defining fixed value sets
- Adding enum methods for labels/colors

## Basic String-Backed Enum

```php
<?php

namespace App\Enums;

enum UserRole: string
{
    case SUPER_ADMIN = 'super_admin';
    case ADMIN = 'admin';
    case MANAGER = 'manager';
    case USER = 'user';
    case GUEST = 'guest';

    public function label(): string
    {
        return match($this) {
            self::SUPER_ADMIN => 'Super Administrator',
            self::ADMIN => 'Administrator',
            self::MANAGER => 'Manager',
            self::USER => 'User',
            self::GUEST => 'Guest',
        };
    }

    public function color(): string
    {
        return match($this) {
            self::SUPER_ADMIN => 'red',
            self::ADMIN => 'orange',
            self::MANAGER => 'yellow',
            self::USER => 'blue',
            self::GUEST => 'gray',
        };
    }
}
```

## Status Enum with Transitions

```php
enum OrderStatus: string
{
    case PENDING = 'pending';
    case PROCESSING = 'processing';
    case SHIPPED = 'shipped';
    case DELIVERED = 'delivered';
    case CANCELLED = 'cancelled';

    public function canTransitionTo(self $newStatus): bool
    {
        return match($this) {
            self::PENDING => in_array($newStatus, [self::PROCESSING, self::CANCELLED]),
            self::PROCESSING => in_array($newStatus, [self::SHIPPED, self::CANCELLED]),
            self::SHIPPED => in_array($newStatus, [self::DELIVERED]),
            self::DELIVERED, self::CANCELLED => false,
        };
    }

    public function isFinal(): bool
    {
        return in_array($this, [self::DELIVERED, self::CANCELLED]);
    }
}
```

## Model Casting

```php
// In Model
final class Order extends Model
{
    protected function casts(): array
    {
        return [
            'status' => OrderStatus::class,
        ];
    }
}

// Usage
$order = Order::find(1);
$order->status; // OrderStatus enum instance
$order->status->label(); // "Pending"
$order->status = OrderStatus::PROCESSING;
$order->save();
```

## Validation

```php
// In DTO or FormRequest rules
public static function rules(): array
{
    return [
        'status' => ['required', 'string', Rule::enum(OrderStatus::class)],
        'role' => ['required', 'string', Rule::in(array_column(UserRole::cases(), 'value'))],
    ];
}
```

## Helper Methods

```php
enum Priority: string
{
    case LOW = 'low';
    case MEDIUM = 'medium';
    case HIGH = 'high';
    case URGENT = 'urgent';

    // Get all values as array
    public static function values(): array
    {
        return array_column(self::cases(), 'value');
    }

    // Get options for select dropdown
    public static function options(): array
    {
        return collect(self::cases())->map(fn($case) => [
            'value' => $case->value,
            'label' => $case->label(),
        ])->all();
    }

    // Try to create from value (returns null if invalid)
    public static function tryFromValue(string $value): ?self
    {
        return self::tryFrom($value);
    }
}
```

## Naming Conventions

```php
// Correct
enum ProjectStatus: string  // PascalCase enum name
{
    case DRAFT = 'draft';           // UPPER_SNAKE_CASE cases
    case IN_PROGRESS = 'in_progress';
    case COMPLETED = 'completed';
}

// Wrong
enum project_status: string  // Should be PascalCase
{
    case draft = 'draft';           // Should be DRAFT
    case InProgress = 'in_progress'; // Should be IN_PROGRESS
}
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| Class constants for fixed values | Use PHP enums |
| Integer-backed enums | Prefer string-backed (more readable in DB) |
| Dynamic values in enums | Enums are for fixed sets only |
| Inconsistent case naming | Use UPPER_SNAKE_CASE for all cases |
| Missing `label()` method | Add for UI display |

## Don'ts

- Never use class constants when enums fit
- Never use integer backing unless required by external API
- Never create enums for dynamic/changing values
- Never try to extend enums (they're final)
- Never forget to cast enums in models
