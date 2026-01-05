---
name: laravel-testing
description: Pest PHP v2 testing patterns. Use when writing tests for Laravel features, APIs, or units. Always use Pest expectations over PHPUnit assertions.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Pest PHP Testing Patterns

## When to Apply

Apply when:
- Writing feature or unit tests
- Testing API endpoints
- Testing form validation
- Adding architecture tests

## Test Structure

```php
<?php

use App\Models\User;
use function Pest\Laravel\{actingAs, get, post, assertDatabaseHas};

uses(RefreshDatabase::class);

describe('UserController', function () {
    beforeEach(function () {
        $this->user = User::factory()->create();
    });

    it('shows user profile', function () {
        actingAs($this->user)
            ->get('/profile')
            ->assertOk()
            ->assertSee($this->user->name);
    });

    it('updates user settings', function () {
        actingAs($this->user)
            ->put('/profile', ['name' => 'New Name'])
            ->assertRedirect();

        expect($this->user->fresh()->name)->toBe('New Name');
    });
});
```

## Expectations (Not Assertions)

```php
// Use Pest expectations
expect($value)->toBe(5);
expect($user)->toBeInstanceOf(User::class);
expect($array)->toContain('item');

// Chain related expectations
expect($response)
    ->toBeArray()
    ->toHaveCount(3)
    ->each->toBeString();

// Negation
expect($value)->not->toBeNull();
expect($array)->not->toBeEmpty();

// Avoid PHPUnit assertions
// $this->assertEquals(5, $value);  // Don't use
```

## Laravel Helpers

```php
use function Pest\Laravel\{actingAs, get, post, delete, assertDatabaseHas};

// Use helpers directly (not $this->)
actingAs($user)->get('/profile')->assertOk();
assertDatabaseHas('posts', ['title' => 'Test']);

// API testing
postJson('/api/users', ['name' => 'John'])
    ->assertCreated()
    ->assertJsonStructure(['data' => ['id', 'name']]);

// Form validation
postJson('/register', ['email' => 'invalid'])
    ->assertUnprocessable()
    ->assertJsonValidationErrors(['email']);
```

## Datasets

```php
// Named datasets for clarity
it('handles user roles', function (string $role, bool $canPublish) {
    $user = User::factory()->create(['role' => $role]);

    expect($user->canPublish())->toBe($canPublish);
})->with([
    'admin can publish' => ['admin', true],
    'editor can publish' => ['editor', true],
    'viewer cannot publish' => ['viewer', false],
]);

// Validation datasets
test('validates registration', function (string $field, mixed $value, string $error) {
    $data = validUserData();
    $data[$field] = $value;

    postJson('/register', $data)
        ->assertUnprocessable()
        ->assertJsonValidationErrors([$field => $error]);
})->with([
    'missing name' => ['name', '', 'required'],
    'invalid email' => ['email', 'not-an-email', 'valid email'],
]);

// Shared datasets in tests/Datasets/
dataset('user_roles', ['admin', 'editor', 'viewer']);
```

## Architecture Tests

```php
// tests/Architecture/ArchitectureTest.php

arch()->preset()->laravel();
arch()->preset()->security();

arch('models extend eloquent')
    ->expect('App\Models')
    ->toExtend('Illuminate\Database\Eloquent\Model')
    ->toBeFinal();

arch('controllers are invokable or resourceful')
    ->expect('App\Http\Controllers')
    ->toHaveSuffix('Controller');

arch('no env calls outside config')
    ->expect('env')
    ->not->toBeUsedIn('App');
```

## API Testing

```php
test('api returns user data', function () {
    $user = User::factory()->create();

    actingAs($user)
        ->getJson('/api/user')
        ->assertOk()
        ->assertJsonStructure([
            'data' => ['id', 'name', 'email', 'created_at']
        ])
        ->assertJson([
            'data' => ['id' => $user->id]
        ]);
});

test('unauthenticated users get 401', function () {
    getJson('/api/profile')->assertUnauthorized();
});
```

## Mocking

```php
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Mail;

// Fake facades
Mail::fake();
$this->performAction();
Mail::assertSent(WelcomeEmail::class);

// Spy for verification
Cache::spy();
$this->performAction();
Cache::shouldHaveReceived('put')->once();

// Mockery for services
$mailer = Mockery::mock(Mailer::class);
$mailer->shouldReceive('send')->once()->andReturn(true);
app()->instance(Mailer::class, $mailer);
```

## Pest.php Configuration

```php
// tests/Pest.php
<?php

use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class)->in('Feature');

expect()->extend('toBeValidUuid', function () {
    return $this->toMatch('/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i');
});
```

## Running Tests

```bash
# Run all tests
pest

# Parallel execution
pest --parallel

# With coverage
pest --coverage --min=80

# Mutation testing
pest --mutate --parallel --min=80

# Specific test file
pest tests/Feature/UserTest.php

# Filter by name
pest --filter="creates user"
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| `$this->assertEquals()` | `expect()->toBe()` |
| `$this->actingAs()` | `actingAs()` helper |
| Unnamed datasets | Named datasets with descriptions |
| `sleep()` in tests | Use `travel()` or proper mocks |
| Testing implementation | Test behavior/outcomes |

## Don'ts

- Never use PHPUnit assertions when Pest expectations exist
- Never use `$this->` when Laravel helpers are available
- Never hardcode IDs or timestamps (use factories)
- Never share state between tests
- Never commit commented-out or skipped tests without explanation
- Never use `sleep()` in tests
