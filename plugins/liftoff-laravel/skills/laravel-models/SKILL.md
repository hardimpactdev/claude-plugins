---
name: laravel-models
description: Eloquent model patterns and best practices. Use when creating models, defining relationships, or working with database queries. Prefer Eloquent over raw queries.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Eloquent Model Patterns

## When to Apply

Apply when:
- Creating new models
- Defining relationships
- Writing database queries
- Adding model methods or scopes

## Model Structure

```php
<?php

declare(strict_types=1);

namespace App\Models;

use App\Enums\ProjectStatus;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

final class Project extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'name',
        'description',
        'status',
        'user_id',
        'started_at',
    ];

    protected function casts(): array
    {
        return [
            'status' => ProjectStatus::class,
            'started_at' => 'datetime',
            'is_active' => 'boolean',
            'metadata' => 'array',
        ];
    }

    // Relationships with return types
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function tasks(): HasMany
    {
        return $this->hasMany(Task::class);
    }

    // Scopes
    public function scopeActive(Builder $query): Builder
    {
        return $query->where('status', ProjectStatus::Active);
    }
}
```

## Key Requirements

1. **Use `final` class** - Models should be final
2. **Use `casts()` method** - Not `$casts` property (Laravel 12)
3. **Return types on relationships** - Always declare return types
4. **Create factories and seeders** - With every new model

## Relationships

```php
// BelongsTo
public function user(): BelongsTo
{
    return $this->belongsTo(User::class);
}

// HasMany
public function tasks(): HasMany
{
    return $this->hasMany(Task::class);
}

// HasOne
public function profile(): HasOne
{
    return $this->hasOne(Profile::class);
}

// BelongsToMany
public function tags(): BelongsToMany
{
    return $this->belongsToMany(Tag::class)
        ->withTimestamps()
        ->withPivot('order');
}

// HasManyThrough
public function comments(): HasManyThrough
{
    return $this->hasManyThrough(Comment::class, Task::class);
}

// MorphMany
public function attachments(): MorphMany
{
    return $this->morphMany(Attachment::class, 'attachable');
}
```

## Querying

### Prefer Eloquent

```php
// Good - Eloquent
$projects = Project::query()
    ->where('status', ProjectStatus::Active)
    ->with('tasks')
    ->orderByDesc('created_at')
    ->paginate(15);

// Avoid - Raw DB
$projects = DB::table('projects')
    ->where('status', 'active')
    ->get();
```

### Prevent N+1 Queries

```php
// Bad - N+1 problem
$projects = Project::all();
foreach ($projects as $project) {
    echo $project->user->name; // Query per iteration
}

// Good - Eager loading
$projects = Project::with('user')->get();
foreach ($projects as $project) {
    echo $project->user->name; // No additional queries
}

// Nested eager loading
$projects = Project::with(['user', 'tasks.comments'])->get();

// Conditional eager loading
$projects = Project::with(['tasks' => function ($query) {
    $query->where('completed', false);
}])->get();
```

## Scopes

```php
// Local scope
public function scopeActive(Builder $query): Builder
{
    return $query->where('status', ProjectStatus::Active);
}

public function scopeOwnedBy(Builder $query, User $user): Builder
{
    return $query->where('user_id', $user->id);
}

// Usage
$projects = Project::active()->ownedBy($user)->get();
```

## Accessors & Mutators

```php
// Accessor (Laravel 12 style)
protected function fullName(): Attribute
{
    return Attribute::make(
        get: fn () => "{$this->first_name} {$this->last_name}",
    );
}

// Mutator
protected function email(): Attribute
{
    return Attribute::make(
        set: fn (string $value) => strtolower($value),
    );
}
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `protected $casts = [...]` | `protected function casts(): array` |
| Missing relationship return types | `public function user(): BelongsTo` |
| `DB::table('users')` | `User::query()` |
| Querying in loops | Use eager loading with `with()` |
| Non-final model class | `final class User extends Model` |

## Don'ts

- Never use raw DB queries when Eloquent works
- Never query relationships in loops (N+1)
- Never forget to create factories with models
- Never use `$casts` property (use `casts()` method)
- Never forget return types on relationships
