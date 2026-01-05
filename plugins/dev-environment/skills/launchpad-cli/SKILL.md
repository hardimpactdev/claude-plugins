---
name: launchpad-cli
description: Launchpad CLI commands for local PHP development. Use when managing Docker services, sites, or PHP versions in the development environment.
allowed-tools: Bash(launchpad:*), Read, Grep
---

# Launchpad CLI

## When to Apply

Apply when user mentions:
- Starting/stopping development environment
- Docker services status
- PHP version switching
- Site configuration
- Local HTTPS/SSL
- Database/Redis connections

## Common Commands

```bash
# Start all services
launchpad start

# Stop all services
launchpad stop

# Restart all services
launchpad restart

# Check status
launchpad status

# List all sites
launchpad sites

# View logs
launchpad logs [service]
```

## PHP Version Management

```bash
# Set PHP version for a site
launchpad php mysite 8.4

# Reset to default version
launchpad php mysite --reset

# List sites with PHP versions
launchpad sites
```

## JSON Output

All commands support `--json` for programmatic access:

```bash
# Get status as JSON
launchpad status --json

# Get sites as JSON
launchpad sites --json
```

## Services

| Service | Port | Description |
|---------|------|-------------|
| Caddy | 80, 443 | Web server (HTTPS) |
| PHP 8.3 | - | FPM worker |
| PHP 8.4 | - | FPM worker |
| PostgreSQL | 5432 | Database |
| Redis | 6379 | Cache |
| Mailpit | 1025, 8025 | Mail catcher |
| DNS | 53 | .test domains |

## Configuration

Config stored at `~/.config/launchpad/config.json`:

```json
{
  "paths": ["~/projects"],
  "tld": "test",
  "default_php_version": "8.3",
  "sites": {
    "mysite": {
      "php_version": "8.4"
    }
  }
}
```

## Setup New Project

```bash
# Create symlink in projects folder
ln -s /path/to/project ~/projects/myapp

# Restart to detect new site
launchpad restart

# Visit https://myapp.test
```

## Trust Local CA

```bash
# Install Caddy root CA for HTTPS
launchpad trust
```

## Database Connection

```
Host: 127.0.0.1
Port: 5432
User: postgres
Password: postgres
Database: (project name)
```

## Redis Connection

```
Host: 127.0.0.1
Port: 6379
```

## Mail Testing

- SMTP: localhost:1025
- Web UI: http://localhost:8025

## Troubleshooting

```bash
# Check if Docker is running
docker info

# View service logs
launchpad logs caddy
launchpad logs php-84

# Rebuild PHP images
launchpad rebuild

# Check for updates
launchpad upgrade --check
```
