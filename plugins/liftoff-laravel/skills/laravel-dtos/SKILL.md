---
name: laravel-dtos
description: Laravel Data DTO patterns for data transfer, model casting, and transformations. Use when creating DTOs, passing data to views, or casting model attributes. See laravel-validation for FormRequest integration.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Laravel Data DTO Patterns

## When to Apply

Apply when:
- Creating data transfer objects
- Passing data to Inertia views
- Casting model JSON columns
- Transforming data between layers

## Basic DTO Structure

```php
<?php

namespace App\Data;

use Spatie\LaravelData\Data;
use Spatie\LaravelData\Attributes\Computed;
use Illuminate\Support\Collection;
use Carbon\Carbon;

class UserData extends Data
{
    public function __construct(
        public ?int $id,
        public string $name,
        public string $email,
        public ?string $phone,
        public bool $is_active = true,
        public ?Carbon $email_verified_at = null,
        /** @var Collection<int, string> */
        public ?Collection $tags = null,
        public ?AddressData $address = null,
        #[Computed]
        public ?string $display_name = null,
    ) {
        $this->tags ??= collect();
        $this->display_name = "{$this->name} ({$this->email})";
    }

    public static function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email'],
            'phone' => ['nullable', 'string'],
            'tags' => ['nullable', 'array'],
            'tags.*' => ['string', 'max:50'],
        ];
    }

    public static function empty(): self
    {
        return new self(
            id: null,
            name: '',
            email: '',
            phone: null,
        );
    }
}
```

## Creating DTOs

```php
// From array
$user = UserData::from([
    'name' => 'John',
    'email' => 'john@example.com',
]);

// From model
$user = UserData::from($userModel);

// From request (via FormRequest)
$user = $request->getData();

// Collection of DTOs
$users = UserData::collect(User::all());
```

## Nested DTOs

```php
class OrderData extends Data
{
    public function __construct(
        public int $id,
        public CustomerData $customer,           // Nested DTO
        public DataCollection $items,            // Collection of DTOs
        public ?AddressData $shipping = null,    // Optional nested
    ) {}
}

// Usage
$order = OrderData::from([
    'id' => 1,
    'customer' => ['name' => 'John', 'email' => 'john@test.com'],
    'items' => [
        ['product_id' => 1, 'quantity' => 2],
        ['product_id' => 2, 'quantity' => 1],
    ],
]);
```

## Model Casting

```php
// In Model
final class Project extends Model
{
    protected function casts(): array
    {
        return [
            'settings' => SettingsData::class,      // Single DTO
            'metadata' => MetadataData::class,
            'tags' => AsCollection::class,           // Simple collection
        ];
    }
}

// Usage
$project = Project::find(1);
$project->settings->theme;  // Type-safe access
$project->settings = SettingsData::from(['theme' => 'dark']);
$project->save();
```

## Computed Properties

```php
class InvoiceData extends Data
{
    public function __construct(
        public DataCollection $items,
        public float $tax_rate,
        #[Computed]
        public ?float $subtotal = null,
        #[Computed]
        public ?float $tax = null,
        #[Computed]
        public ?float $total = null,
    ) {
        $this->subtotal = $this->items->sum('amount');
        $this->tax = $this->subtotal * $this->tax_rate;
        $this->total = $this->subtotal + $this->tax;
    }
}
```

## Lazy Properties

```php
use Spatie\LaravelData\Lazy;

class ProductData extends Data
{
    public function __construct(
        public int $id,
        public string $name,
        public Lazy|CategoryData $category,    // Loaded on demand
        public Lazy|DataCollection $reviews,
    ) {}

    public static function fromModel(Product $product): self
    {
        return new self(
            id: $product->id,
            name: $product->name,
            category: Lazy::create(fn() => CategoryData::from($product->category)),
            reviews: Lazy::create(fn() => ReviewData::collect($product->reviews)),
        );
    }
}

// Include lazy properties when needed
$product = ProductData::from($model)->include('category', 'reviews');
```

## Transformations

```php
class UserData extends Data
{
    // Transform when creating from model
    public static function fromModel(User $user): self
    {
        return new self(
            id: $user->id,
            name: $user->name,
            email: $user->email,
            role: RoleData::from($user->role),
            created_at: $user->created_at,
        );
    }

    // Transform to array (for API responses)
    public function toArray(): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'role' => $this->role->name,
            'member_since' => $this->created_at->diffForHumans(),
        ];
    }
}
```

## Property Mapping

```php
use Spatie\LaravelData\Attributes\MapName;
use Spatie\LaravelData\Attributes\MapInputName;
use Spatie\LaravelData\Attributes\MapOutputName;

class ApiData extends Data
{
    public function __construct(
        #[MapName('user_name')]           // Both input and output
        public string $name,

        #[MapInputName('created_at')]     // Only when receiving
        #[MapOutputName('createdAt')]     // Only when outputting
        public Carbon $createdAt,
    ) {}
}
```

## Controller Usage

```php
class ProjectsController extends Controller
{
    public function index(): Response
    {
        return Inertia::render('Projects/Index', [
            'projects' => ProjectData::collect(
                Project::with('owner')->paginate()
            ),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('Projects/Create', [
            'form' => CreateProjectData::empty(),
            'categories' => CategoryData::collect(Category::all()),
        ]);
    }

    public function edit(Project $project): Response
    {
        return Inertia::render('Projects/Edit', [
            'form' => UpdateProjectData::from($project),
        ]);
    }
}
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| Passing arrays to views | Use `DTO::collect()` or `DTO::from()` |
| Using validation attributes | Use `rules()` method |
| Untyped properties | Always declare types |
| Forgetting `empty()` method | Add for form DTOs |
| Uninitialized collections | Add `$this->items ??= collect()` |

## Don'ts

- Never pass raw arrays to Inertia views
- Never use validation attributes (`#[Required]`)
- Never add persistence logic to DTOs
- Never forget to initialize nullable collections
- Never expose Eloquent models directly to frontend
