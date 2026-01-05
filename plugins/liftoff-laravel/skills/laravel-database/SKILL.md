---
name: laravel-database
description: Database migrations, indexes, and query patterns. Use when creating migrations, designing schemas, or optimizing queries. Always use migrations - never modify database directly.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Database Development Patterns

## When to Apply

Apply when:
- Creating migrations
- Designing database schemas
- Adding indexes
- Writing complex queries
- Setting up foreign keys

## Migration Structure

```php
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('projects', function (Blueprint $table) {
            // Primary key
            $table->id();

            // String columns with lengths
            $table->string('name', 255);
            $table->string('slug', 255)->unique();
            $table->text('description')->nullable();
            $table->string('status', 50)->default('draft');

            // Numeric with precision
            $table->decimal('budget', 12, 2)->nullable();
            $table->unsignedInteger('max_members')->default(10);

            // Dates
            $table->date('start_date')->nullable();
            $table->timestamp('published_at')->nullable();

            // Foreign keys with constraints
            $table->foreignId('owner_id')
                  ->constrained('users')
                  ->onDelete('cascade');

            $table->foreignId('category_id')
                  ->nullable()
                  ->constrained()
                  ->onDelete('set null');

            // JSON for flexible data
            $table->json('settings')->nullable();

            // Booleans
            $table->boolean('is_featured')->default(false);

            // Timestamps and soft deletes
            $table->timestamps();
            $table->softDeletes();

            // Indexes
            $table->index(['status', 'published_at']);
            $table->index('owner_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('projects');
    }
};
```

## Column Types

```php
// Strings
$table->string('name', 255);        // VARCHAR
$table->text('description');         // TEXT (< 65K)
$table->longText('content');         // LONGTEXT (> 65K)

// Numbers
$table->decimal('price', 10, 2);     // Precise decimals
$table->integer('quantity')->unsigned();
$table->tinyInteger('rating');       // 1-255

// Dates
$table->date('birth_date');
$table->dateTime('expires_at');
$table->timestamp('verified_at')->nullable();

// Others
$table->boolean('is_active')->default(true);
$table->json('metadata')->nullable();
$table->uuid('public_id')->unique();

// Use string instead of enum (database-agnostic)
$table->string('status', 50);  // Not: $table->enum()
```

## Foreign Keys

```php
// Cascade delete (parent deleted = children deleted)
$table->foreignId('user_id')
      ->constrained()
      ->onDelete('cascade');

// Set null (parent deleted = children remain, FK becomes null)
$table->foreignId('category_id')
      ->nullable()  // Required for set null!
      ->constrained()
      ->onDelete('set null');

// Restrict (prevent parent deletion if children exist)
$table->foreignId('author_id')
      ->constrained('users')
      ->onDelete('restrict');
```

## Indexing Strategy

```php
// Always index foreign keys
$table->foreignId('user_id')->constrained();  // Auto-indexed
$table->index('user_id');  // Manual if using unsignedBigInteger

// Index frequently queried columns
$table->index('status');
$table->index('published_at');

// Composite indexes (column order matters!)
$table->index(['status', 'published_at']);  // For: WHERE status = ? ORDER BY published_at
$table->index(['user_id', 'created_at']);   // For: WHERE user_id = ? ORDER BY created_at

// Unique constraints
$table->unique('email');
$table->unique(['project_id', 'user_id']);  // Composite unique
```

## Query Optimization

```php
// Select only needed columns
$users = User::query()
    ->select(['id', 'name', 'email'])
    ->where('status', 'active')
    ->get();

// Use chunking for large datasets
User::query()
    ->where('created_at', '<', now()->subYear())
    ->chunk(1000, function ($users) {
        foreach ($users as $user) {
            $this->archive($user);
        }
    });

// Transactions for related operations
DB::transaction(function () {
    $order = Order::create([...]);
    $order->items()->createMany([...]);
    Product::whereIn('id', $productIds)->decrement('stock');
});
```

## Modifying Tables

```php
// Laravel 12: Include ALL attributes when modifying
Schema::table('users', function (Blueprint $table) {
    $table->string('timezone', 50)
          ->default('UTC')
          ->after('email');

    $table->index('email_verified_at');
});

// Down method must reverse changes
public function down(): void
{
    Schema::table('users', function (Blueprint $table) {
        $table->dropIndex(['email_verified_at']);
        $table->dropColumn('timezone');
    });
}
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `$table->enum('status', [...])` | `$table->string('status', 50)` |
| `$table->unsignedBigInteger('user_id')` without index | Use `foreignId()->constrained()` |
| Empty `down()` method | Always implement rollback |
| `onDelete('set null')` without `nullable()` | Add `->nullable()` first |
| Mixing concerns in one migration | One table/concern per migration |

## Don'ts

- Never modify database directly - use migrations
- Never use database-specific features (enum, set)
- Never skip foreign key constraints
- Never write raw SQL without parameter bindings
- Never load all records - use pagination/chunking
- Never create long-running transactions
