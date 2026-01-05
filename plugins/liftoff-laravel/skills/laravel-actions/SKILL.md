---
name: laravel-actions
description: Action pattern for business logic encapsulation. Use when implementing features that involve business logic beyond simple CRUD - Actions are single-purpose, testable classes that keep controllers thin.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Action Pattern for Business Logic

## When to Apply

Apply when:
- Implementing business logic beyond simple CRUD
- Logic would make a controller method too complex
- Logic needs to be reused across controllers or commands
- Logic requires multiple service dependencies
- You need highly testable business operations

## Core Principle

**Controllers handle HTTP, Actions handle business logic.**

Actions are `final readonly` classes with a single `handle()` method that encapsulate one specific business operation.

## Action Structure

```php
<?php

declare(strict_types=1);

namespace App\Actions\Orders;

use App\Data\OrderData;
use App\Models\Order;
use App\Models\User;
use App\Services\PaymentGateway;
use App\Services\InventoryService;

final readonly class CreateOrder
{
    public function __construct(
        private PaymentGateway $payments,
        private InventoryService $inventory,
    ) {}

    public function handle(User $user, OrderData $data): Order
    {
        // Validate inventory
        $this->inventory->reserveItems($data->items);

        // Process payment
        $charge = $this->payments->charge($user, $data->total);

        // Create order
        return Order::create([
            'user_id' => $user->id,
            'charge_id' => $charge->id,
            'items' => $data->items,
            'total' => $data->total,
        ]);
    }
}
```

**Key characteristics:**
- `final` - Cannot be extended
- `readonly` - Immutable after construction
- `declare(strict_types=1)` - Type safety
- Single `handle()` method - One responsibility
- Constructor injection - Dependencies via DI container

## Directory Organization

```
app/Actions/
├── Orders/
│   ├── CreateOrder.php
│   ├── CancelOrder.php
│   └── RefundOrder.php
├── Users/
│   ├── CreateUser.php
│   └── DeactivateUser.php
└── Reports/
    └── GenerateMonthlyReport.php
```

Organize by **domain/feature**, not by type.

## Controller Usage

```php
class OrderController extends Controller
{
    #[Post]
    public function store(
        StoreOrderRequest $request,
        CreateOrder $createOrder,
    ): RedirectResponse {
        $order = $createOrder->handle(
            $request->user(),
            $request->getData(),
        );

        return redirect()->route('orders.show', $order);
    }
}
```

## When to Use Actions vs Services

| Use Actions | Use Services |
|-------------|--------------|
| Single business operation | Reusable utilities |
| One `handle()` method | Multiple related methods |
| Orchestrates a workflow | Wraps external systems |
| Feature-specific logic | Infrastructure concerns |

**Examples:**
- `CreateOrder` (Action) - orchestrates payment + inventory + order creation
- `PaymentGateway` (Service) - wraps Stripe API calls
- `SendWelcomeEmail` (Action) - handles user onboarding flow
- `EmailService` (Service) - wraps mail transport

## Testing Actions

```php
it('creates an order with valid payment', function () {
    $user = User::factory()->create();
    $data = OrderData::from([
        'items' => [['sku' => 'ABC', 'qty' => 2]],
        'total' => 100_00,
    ]);

    $payments = Mockery::mock(PaymentGateway::class);
    $payments->shouldReceive('charge')->andReturn(new Charge(id: 'ch_123'));

    $inventory = Mockery::mock(InventoryService::class);
    $inventory->shouldReceive('reserveItems')->once();

    $action = new CreateOrder($payments, $inventory);
    $order = $action->handle($user, $data);

    expect($order)
        ->user_id->toBe($user->id)
        ->charge_id->toBe('ch_123')
        ->total->toBe(100_00);
});
```

## Return Types

Actions should return:
- **Model** - When creating/updating entities
- **DTO** - When returning structured data
- **bool** - For success/failure operations
- **void** - For side-effect-only operations

```php
// Returns Model
final readonly class CreateUser
{
    public function handle(CreateUserData $data): User { }
}

// Returns DTO
final readonly class GetDashboardStats
{
    public function handle(): DashboardData { }
}

// Returns bool
final readonly class DeactivateUser
{
    public function handle(User $user): bool { }
}

// Returns void (sends email, logs, etc.)
final readonly class NotifyAdmins
{
    public function handle(string $message): void { }
}
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| Multiple public methods | Single `handle()` method |
| `class CreateOrder` | `final readonly class CreateOrder` |
| Business logic in controller | Extract to Action |
| Action calling another Action | Compose in controller or use Service |
| Missing `strict_types` | Always declare strict types |

## Don'ts

- Never put HTTP concerns in Actions (Request, Response)
- Never make Actions extend a base class
- Never inject Request into Actions - pass data explicitly
- Never have Actions call other Actions directly
- Never skip the `final readonly` modifiers
