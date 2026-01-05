# Release Command

Create a new semantic version release.

## Usage

```
/git-workflow:release [version]
```

## Instructions

This command triggers the `release-version` skill to:

1. Check current git state
2. Determine appropriate version number
3. Update documentation
4. Create git tag
5. Push to remote
6. Create GitHub release

If a version is provided (e.g., `/git-workflow:release 1.2.0`), use that version.
Otherwise, analyze commits since last tag to suggest appropriate version bump.

## See Also

- `release-version` skill for detailed release process
