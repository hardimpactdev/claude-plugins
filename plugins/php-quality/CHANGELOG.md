# Changelog

All notable changes to the php-quality plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-05

### Added
- Initial release with 2 skills
- `php-formatting` - Laravel Pint code style rules
- `php-analysis` - PHPStan and Larastan configuration
- `/php-quality:lint` command - Run all linters
- `/php-quality:fix` command - Auto-fix issues
- `/php-quality:test` command - Run Pest tests
- Post-write hook for automatic PHP quality checks
