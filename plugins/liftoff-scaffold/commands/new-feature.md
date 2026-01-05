# New Feature Command

Scaffold a new feature with all required components.

## Usage

```
/liftoff-scaffold:new-feature <FeatureName>
```

## Example

```
/liftoff-scaffold:new-feature Project
```

## Instructions

When invoked, create all components for a new feature:

### 1. Database

- Create migration with proper columns
- Add indexes for frequently queried fields
- Include foreign keys with constraints

### 2. Model

- Create final model class
- Add fillable, casts, relationships
- Create factory with realistic data
- Create seeder

### 3. Enum (if needed)

- Create status/type enum
- Add `label()` and `color()` methods

### 4. DTOs

- Create main DTO with validation rules
- Create form-specific DTOs if needed
- Add `empty()` method for create forms

### 5. FormRequest

- Create with `WithData` trait
- Reference the DTO class

### 6. Controller

- Use Waymaker attributes
- Only resourceful methods
- Pass DTOs to views

### 7. Vue Pages

- Create Index, Create, Edit, Show pages
- Use AppLayout
- Initialize forms from props

### 8. Tests

- Feature tests for controller
- Unit tests for model/service logic

### 9. Final Steps

```bash
php artisan migrate
php artisan waymaker:generate
npm run build
php artisan test
```

Report what was created and any next steps.
