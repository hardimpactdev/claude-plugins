---
name: laravel-controllers
description: Laravel controller patterns and conventions. Use when creating or modifying controller files - covers resourceful methods, naming, and structure.
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
---

# Laravel Controller Conventions

## When to Apply

Apply when:
- Creating new controllers
- Modifying existing controllers
- Reviewing controller code

## Naming Conventions

- **Plural** names for resource controllers: `UsersController`, `ArticlesController`
- **Singular** for single functionality: `DashboardController`, `ProfileController`

## Resourceful Methods Only

Controllers should only contain these methods:

| Method | Route | Purpose |
|--------|-------|---------|
| `index` | GET /resources | List all resources |
| `show` | GET /resources/{id} | Display single resource |
| `create` | GET /resources/create | Show creation form |
| `store` | POST /resources | Create new resource |
| `edit` | GET /resources/{id}/edit | Show edit form |
| `update` | PUT /resources/{id} | Update resource |
| `destroy` | DELETE /resources/{id} | Delete resource |

## Controller Structure

```php
<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Data\ArticleData;
use App\Http\Requests\StoreArticleRequest;
use App\Models\Article;
use Hardimpact\Waymaker\Attributes\Get;
use Hardimpact\Waymaker\Attributes\Post;
use Inertia\Inertia;
use Inertia\Response;

final class ArticlesController extends Controller
{
    #[Get]
    public function index(): Response
    {
        return Inertia::render('Articles/Index', [
            'articles' => ArticleData::collect(Article::query()->paginate()),
        ]);
    }

    #[Get(parameters: ['article:slug'])]
    public function show(Article $article): Response
    {
        return Inertia::render('Articles/Show', [
            'article' => ArticleData::from($article),
        ]);
    }

    #[Post]
    public function store(StoreArticleRequest $request): RedirectResponse
    {
        $article = Article::create($request->validated());

        return redirect()->route('articles.show', $article);
    }
}
```

## Key Requirements

1. **Always use FormRequest** - Never inline validation
2. **Use DTOs for responses** - Via Laravel Data
3. **Use Waymaker attributes** - For route definitions
4. **Return type hints** - Always declare return types
5. **Final classes** - Controllers should be `final`

## See Also

- `laravel-routes` - Waymaker routing patterns
- `laravel-validation` - FormRequest patterns
- `laravel-dtos` - Laravel Data patterns
