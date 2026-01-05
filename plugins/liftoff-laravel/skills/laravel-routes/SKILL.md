---
name: laravel-routes
description: Waymaker attribute-based routing system. Use when creating controllers, defining routes, or working with route parameters. Never define routes manually in web.php - use Waymaker attributes instead.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Waymaker Routing System

## When to Apply

Apply when:
- Creating new controllers
- Adding route methods to controllers
- Working with route parameters or middleware
- Debugging routing issues

## Core Principle

**Never define routes manually** - Waymaker auto-generates routes from controller attributes.

## HTTP Method Attributes

```php
use Hardimpact\Waymaker\Attributes\{Get, Post, Patch, Put, Delete};

class ProjectsController extends Controller
{
    #[Get]
    public function index(): Response

    #[Get(parameters: ['project'])]
    public function show(Project $project): Response

    #[Get(parameters: ['project:slug'])]  // Custom binding key
    public function showBySlug(Project $project): Response

    #[Post]
    public function store(StoreProjectRequest $request): RedirectResponse

    #[Patch(parameters: ['project'])]
    public function update(Project $project, UpdateProjectRequest $request): RedirectResponse

    #[Delete(parameters: ['project'])]
    public function destroy(Project $project): RedirectResponse
}
```

## Route Parameters

### Single Parameter
```php
#[Get(parameters: ['user'])]
public function show(User $user): Response
```

### Multiple Parameters (parent first)
```php
#[Get(parameters: ['project', 'task'])]
public function showTask(Project $project, Task $task): Response
```

### Optional Parameters
```php
#[Get(parameters: ['category?'])]
public function index(?Category $category = null): Response
```

### Custom Binding Key
```php
#[Get(parameters: ['project:slug'])]
public function show(Project $project): Response  // Resolves by slug
```

## Middleware

```php
// Authentication
#[Get(middleware: ['auth'])]
public function dashboard(): Response

// Multiple middleware
#[Post(middleware: ['auth', 'verified', 'throttle:6,1'])]
public function store(Request $request): RedirectResponse

// Authorization
#[Patch(parameters: ['project'], middleware: ['can:update,project'])]
public function update(Project $project): RedirectResponse

// API authentication
#[Get(uri: '/api/projects', middleware: ['auth:sanctum'])]
public function apiIndex(): JsonResponse
```

## Custom URIs

```php
// Action endpoints
#[Get(uri: '/projects/archived')]
public function archived(): Response

#[Post(uri: '/projects/{project}/archive', parameters: ['project'])]
public function archive(Project $project): RedirectResponse

// API versioning
#[Get(uri: '/api/v1/projects')]
public function index(): JsonResponse
```

## Route Prefix (Controller Property)

```php
class ProjectsController extends Controller
{
    protected static string $routePrefix = 'projects';

    #[Get]  // Generates /projects
    public function index(): Response
}

// Nested resources
class ProjectTasksController extends Controller
{
    protected static string $routePrefix = 'projects.tasks';

    #[Get(parameters: ['project'])]  // /projects/{project}/tasks
    public function index(Project $project): Response
}

// Admin area
class AdminUsersController extends Controller
{
    protected static string $routePrefix = 'admin/users';
}
```

## Route Generation

```bash
# Generate routes after controller changes
php artisan waymaker:generate

# View generated routes
php artisan route:list

# Cache in production only
php artisan route:cache
```

## Common Mistakes

| Wrong | Right |
|-------|-------|
| Defining routes in `web.php` | Use Waymaker attributes |
| `#[Get]` without parameters for `show()` | `#[Get(parameters: ['project'])]` |
| `public function show(Project $item)` | Parameter name must match: `$project` |
| `#[Get]` for creating resources | Use `#[Post]` |
| Forgetting to run `waymaker:generate` | Always regenerate after changes |

## Don'ts

- Never edit generated route files
- Never use `route()` helper in frontend - use Controllers object
- Never hardcode URIs in templates
- Never cache routes during development
- Never use underscores in URIs (use kebab-case)
