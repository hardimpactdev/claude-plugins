---
name: laravel-validation
description: FormRequest and Laravel Data DTO patterns. Use when creating validation, form requests, or data transfer objects. Never use inline validation - always use FormRequest with DTOs.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# FormRequest & DTO Patterns

## When to Apply

Apply when:
- Creating form validation
- Building data transfer objects
- Working with form submissions
- Passing data to Inertia views

## Core Principle

**Never use inline validation** - Always use FormRequest classes with Laravel Data DTOs.

## FormRequest Structure

```php
<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Spatie\LaravelData\WithData;
use App\Data\CreateUserData;

class StoreUserRequest extends FormRequest
{
    use WithData;

    public function authorize(): bool
    {
        return $this->user()->can('create-users');
    }

    protected function dataClass(): string
    {
        return CreateUserData::class;
    }
}
```

**Key points:**
- Use `WithData` trait
- Only implement `authorize()` and `dataClass()`
- **Never** implement `rules()` - that goes in the DTO

## DTO Structure

```php
<?php

namespace App\Data;

use Spatie\LaravelData\Data;
use Spatie\LaravelData\Attributes\Computed;
use Illuminate\Support\Collection;

class UserData extends Data
{
    public function __construct(
        public ?int $id,
        public string $name,
        public string $email,
        public ?string $phone,
        public UserRole $role,
        public bool $is_active = true,
        public ?Collection $permissions = null,
    ) {
        $this->permissions ??= collect();
    }

    public static function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users,email'],
            'phone' => ['nullable', 'string'],
            'role' => ['required', 'string', 'in:admin,user,guest'],
            'is_active' => ['boolean'],
            'permissions' => ['nullable', 'array'],
            'permissions.*' => ['string', 'exists:permissions,name'],
        ];
    }

    public static function messages(): array
    {
        return [
            'email.unique' => 'This email is already registered.',
        ];
    }

    public static function empty(): self
    {
        return new self(
            id: null,
            name: '',
            email: '',
            phone: null,
            role: UserRole::USER,
        );
    }
}
```

## Controller Usage

```php
class UsersController extends Controller
{
    public function create(): Response
    {
        return Inertia::render('Users/Create', [
            'form' => CreateUserData::empty(),
            'roles' => RoleData::collection(Role::all()),
        ]);
    }

    public function edit(User $user): Response
    {
        return Inertia::render('Users/Edit', [
            'form' => UpdateUserData::from($user),
        ]);
    }

    public function store(StoreUserRequest $request): RedirectResponse
    {
        $data = $request->getData(); // Returns DTO
        $user = User::create($data->toArray());

        return redirect()->route('users.show', $user);
    }
}
```

## Separate Create/Update DTOs

```php
// CreateUserData - requires password
class CreateUserData extends Data
{
    public function __construct(
        public string $name,
        public string $email,
        public string $password,
    ) {}

    public static function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email', 'unique:users'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
        ];
    }
}

// UpdateUserData - password optional
class UpdateUserData extends Data
{
    public function __construct(
        public string $name,
        public string $email,
        public ?string $password = null,
    ) {}

    public static function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'email' => ['required', 'email'],
            'password' => ['nullable', 'string', 'min:8', 'confirmed'],
        ];
    }
}
```

## Collections

Use `Collection` instead of arrays:

```php
class ProjectData extends Data
{
    public function __construct(
        public string $name,
        public Collection $tags,           // Simple collection
        public DataCollection $tasks,      // Collection of DTOs
    ) {
        $this->tags ??= collect();
    }

    public static function rules(): array
    {
        return [
            'tags' => ['required', 'array', 'min:1'],
            'tags.*' => ['string', 'max:50'],
            'tasks' => ['required', 'array'],
            'tasks.*.title' => ['required', 'string'],
        ];
    }
}
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `$request->validate([...])` | Use FormRequest class |
| `rules()` in FormRequest | Put `rules()` in DTO |
| `public array $items` | `public Collection $items` |
| Missing `WithData` trait | Always include trait |
| Using validation attributes | Use `rules()` method |
| Passing arrays to views | Pass DTOs with `empty()` or `from()` |

## Don'ts

- Never implement `rules()` in FormRequest
- Never use inline validation in controllers
- Never use plain arrays - use Collection or DataCollection
- Never forget the `empty()` method for form DTOs
- Never mix validation attributes with `rules()` method
