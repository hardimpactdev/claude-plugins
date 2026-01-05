# Contributing to Claude Plugins Marketplace

Thank you for your interest in contributing!

## Ways to Contribute

### 1. Create a New Plugin

1. Fork this repository
2. Create your plugin:
   ```bash
   ./scripts/new-plugin.sh my-plugin
   ```
3. Develop and test your plugin
4. Add it to `marketplace.json`
5. Submit a pull request

### 2. Improve Existing Plugins

1. Fork this repository
2. Make your improvements
3. Test thoroughly
4. Submit a pull request with clear description

### 3. Report Issues

Open an issue with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior

## Plugin Guidelines

### Required Files

- `.claude-plugin/plugin.json` - Valid manifest with name, version, description
- `README.md` - Documentation for your plugin

### Quality Standards

- **Tested**: Verify with `claude --plugin-dir ./plugins/your-plugin`
- **Documented**: Clear README with installation and usage
- **Focused**: Do one thing well
- **Safe**: No malicious or dangerous operations

### Code Style

- Use clear, descriptive names
- Keep skill files under 500 lines
- Include examples in documentation
- Follow semantic versioning

## Pull Request Process

1. Ensure CI passes (validate workflow)
2. Update documentation as needed
3. Bump version if updating existing plugin
4. Request review from maintainers

## Marketplace Entry

When adding to `marketplace.json`:

```json
{
  "name": "your-plugin",
  "source": "./plugins/your-plugin",
  "description": "Clear, concise description",
  "version": "1.0.0",
  "author": { "name": "Your Name" },
  "keywords": ["relevant", "keywords"],
  "license": "MIT"
}
```

## Questions?

Open a discussion or issue if you need help!
