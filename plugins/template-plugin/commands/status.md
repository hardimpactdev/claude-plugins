# Status Command

Check the status of the current project or environment.

## Usage

Invoked as `/template-plugin:status`

## Instructions

When this command is invoked:

1. Check the current working directory
2. Look for common project indicators:
   - package.json (Node.js)
   - requirements.txt or pyproject.toml (Python)
   - Cargo.toml (Rust)
   - go.mod (Go)
3. Report what type of project is detected
4. List any running processes or services if relevant
5. Summarize the project health

## Output Format

Provide a concise status report with:
- Project type detected
- Key configuration files found
- Any notable findings or warnings
