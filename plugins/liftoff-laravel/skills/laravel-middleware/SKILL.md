---
name: laravel-middleware
description: Laravel 12 middleware patterns. Use when creating middleware for authentication, authorization, or request/response modification. Register middleware in bootstrap/app.php.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Laravel Middleware Patterns

## When to Apply

Apply when:
- Creating authentication/authorization middleware
- Adding request/response headers
- Logging requests
- Validating API keys

## Laravel 12 Structure

Middleware is registered in `bootstrap/app.php`, not in a Kernel class:

```php
// bootstrap/app.php
return Application::configure(basePath: dirname(__DIR__))
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->alias([
            'role' => \App\Http\Middleware\CheckRole::class,
            'active' => \App\Http\Middleware\EnsureUserIsActive::class,
        ]);

        $middleware->append(\App\Http\Middleware\AddSecurityHeaders::class);
    })
    ->create();
```

## Basic Middleware

```php
<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnsureUserIsActive
{
    public function handle(Request $request, Closure $next): Response
    {
        if ($request->user() && !$request->user()->is_active) {
            auth()->logout();

            return redirect()
                ->route('login')
                ->with('error', 'Your account has been deactivated.');
        }

        return $next($request);
    }
}
```

## Middleware with Parameters

```php
class CheckRole
{
    public function handle(Request $request, Closure $next, string ...$roles): Response
    {
        if (!$request->user() || !$request->user()->hasAnyRole($roles)) {
            abort(403, 'Unauthorized action.');
        }

        return $next($request);
    }
}

// Usage in Waymaker route
#[Get(middleware: ['role:admin,manager'])]
public function dashboard(): Response
```

## API Middleware

```php
class ValidateApiKey
{
    public function handle(Request $request, Closure $next): Response
    {
        $apiKey = $request->header('X-API-Key');

        if (!$apiKey || !$this->isValidApiKey($apiKey)) {
            return response()->json([
                'error' => 'Invalid or missing API key',
            ], 401);
        }

        return $next($request);
    }

    private function isValidApiKey(string $key): bool
    {
        return ApiKey::where('key', $key)
            ->where('is_active', true)
            ->exists();
    }
}
```

## Terminate Method (Post-Response)

```php
class LogRequestDuration
{
    private float $startTime;

    public function handle(Request $request, Closure $next): Response
    {
        $this->startTime = microtime(true);

        return $next($request);
    }

    public function terminate(Request $request, Response $response): void
    {
        $duration = microtime(true) - $this->startTime;

        Log::info('Request completed', [
            'uri' => $request->getRequestUri(),
            'method' => $request->method(),
            'duration' => round($duration * 1000, 2) . 'ms',
            'status' => $response->getStatusCode(),
        ]);
    }
}
```

## Modifying Response

```php
class AddSecurityHeaders
{
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        return $response
            ->header('X-Content-Type-Options', 'nosniff')
            ->header('X-Frame-Options', 'DENY')
            ->header('X-XSS-Protection', '1; mode=block');
    }
}
```

## Creating Middleware

```bash
php artisan make:middleware EnsureUserIsActive
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| Business logic in middleware | Keep in controllers/services |
| Missing return type | `public function handle(...): Response` |
| Forgetting `$next($request)` | Always call and return it |
| Heavy processing | Middleware runs on every request |
| Registering in Kernel.php | Use `bootstrap/app.php` (Laravel 12) |

## Don'ts

- Never put business logic in middleware
- Never forget to call `$next($request)`
- Never store state in middleware properties (except for terminate)
- Never do heavy database queries
- Never modify core Laravel middleware (extend instead)
