---
name: project-setup
description: Liftoff stack project setup patterns. Use when setting up a new Laravel + Vue + Inertia project or adding features.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Liftoff Project Setup

## When to Apply

Apply when:
- Setting up a new project
- Adding new features/modules
- Creating CRUD functionality
- Understanding project structure

## Technology Stack

- **PHP 8.4** with Laravel 12
- **Vue 3** with Composition API
- **Inertia.js v2** for SPA
- **TypeScript** for type safety
- **Tailwind CSS v4** for styling
- **Pest v3** for testing
- **Waymaker** for routing
- **liftoff-vue** for UI components

## Project Structure

```
app/
├── Data/              # DTOs (Laravel Data)
├── Enums/             # PHP Enums
├── Http/
│   ├── Controllers/   # Waymaker-attributed controllers
│   ├── Middleware/
│   └── Requests/      # FormRequests
├── Models/            # Final Eloquent models
└── Services/          # Business logic

resources/js/
├── Components/        # Reusable Vue components
├── Layouts/           # Page layouts
├── Pages/             # Inertia pages
├── composables/       # Vue composables
└── types/             # TypeScript types

database/
├── factories/         # Model factories
├── migrations/        # Database migrations
└── seeders/           # Database seeders

tests/
├── Feature/           # Feature tests
└── Unit/              # Unit tests
```

## Adding a New Feature

### 1. Create Migration

```bash
php artisan make:migration create_projects_table
```

### 2. Create Model with Factory

```php
// app/Models/Project.php
final class Project extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = ['name', 'status', 'user_id'];

    protected function casts(): array
    {
        return [
            'status' => ProjectStatus::class,
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
```

### 3. Create Enum

```php
// app/Enums/ProjectStatus.php
enum ProjectStatus: string
{
    case DRAFT = 'draft';
    case ACTIVE = 'active';
    case COMPLETED = 'completed';

    public function label(): string
    {
        return match($this) {
            self::DRAFT => 'Draft',
            self::ACTIVE => 'Active',
            self::COMPLETED => 'Completed',
        };
    }
}
```

### 4. Create DTOs

```php
// app/Data/ProjectData.php
class ProjectData extends Data
{
    public function __construct(
        public ?int $id,
        public string $name,
        public ProjectStatus $status,
        public ?UserData $user = null,
    ) {}

    public static function rules(): array
    {
        return [
            'name' => ['required', 'string', 'max:255'],
            'status' => ['required', Rule::enum(ProjectStatus::class)],
        ];
    }

    public static function empty(): self
    {
        return new self(
            id: null,
            name: '',
            status: ProjectStatus::DRAFT,
        );
    }
}
```

### 5. Create FormRequest

```php
// app/Http/Requests/StoreProjectRequest.php
class StoreProjectRequest extends FormRequest
{
    use WithData;

    protected string $dataClass = ProjectData::class;

    public function authorize(): bool
    {
        return true;
    }
}
```

### 6. Create Controller

```php
// app/Http/Controllers/ProjectController.php
#[Prefix('projects')]
final class ProjectController extends Controller
{
    #[Get]
    public function index(): Response
    {
        return Inertia::render('Projects/Index', [
            'projects' => ProjectData::collect(
                Project::with('user')->paginate()
            ),
        ]);
    }

    #[Get('create')]
    public function create(): Response
    {
        return Inertia::render('Projects/Create', [
            'form' => ProjectData::empty(),
        ]);
    }

    #[Post]
    public function store(StoreProjectRequest $request): RedirectResponse
    {
        $data = $request->getData();
        Project::create($data->toArray());

        return redirect()
            ->route('projects.index')
            ->with('success', 'Project created.');
    }
}
```

### 7. Create Vue Pages

```vue
<!-- resources/js/Pages/Projects/Index.vue -->
<script setup lang="ts">
const props = defineProps<{
    projects: App.Data.ProjectData[];
}>();
</script>

<template>
    <AppLayout>
        <Head title="Projects" />
        <!-- Content -->
    </AppLayout>
</template>
```

### 8. Generate Routes

```bash
php artisan waymaker:generate
```

### 9. Create Tests

```php
// tests/Feature/ProjectControllerTest.php
describe('ProjectController', function () {
    it('displays projects index', function () {
        $projects = Project::factory()->count(3)->create();

        actingAs(User::factory()->create())
            ->get('/projects')
            ->assertOk()
            ->assertInertia(fn ($page) =>
                $page->component('Projects/Index')
                    ->has('projects', 3)
            );
    });
});
```

## Quick Commands

```bash
# Generate Waymaker routes
php artisan waymaker:generate

# Run static analysis
composer analyse

# Run tests
php artisan test

# Format code
vendor/bin/pint --dirty

# Build frontend
npm run build
```

## Key Principles

1. **Models are final** with factories and seeders
2. **DTOs from backend** - never empty forms
3. **Waymaker routing** - never edit web.php
4. **FormRequest with DTOs** - never inline validation
5. **Resourceful controllers** - only 7 methods
6. **Every feature needs tests** - minimum coverage
