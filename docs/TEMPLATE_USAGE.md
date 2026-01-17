# Using This Template

This is a Python project template for autonomous development using the Ralph Loop plugin with Claude Code.

## Setup Steps

### 1. Clone and Customize

```bash
# Clone this template
git clone <your-repo-url>
cd <your-repo>

# Search and replace placeholders
find . -type f -name "*.md" -o -name "*.toml" -o -name "*.json" | xargs sed -i 's/your-project-name/my-actual-project/g'
```

### 2. Update Project Metadata

Edit these files with your project details:

- **`pyproject.toml`**: Update `name`, `description`, `version`
- **`LICENSE.md`**: Update copyright holder (line 3)
- **`README.md`**: Update project name and description
- **`docs/PRD.md`**: Write your product requirements

### 3. Setup Development Environment

```bash
# Install dependencies and tooling
make setup_dev

# Verify setup
make validate
```

### 4. Create Project Structure

```bash
# Create source and test directories
mkdir -p src tests
touch src/__init__.py tests/__init__.py
```

### 5. Use Ralph Loop

```bash
# Initialize Ralph loop environment
make ralph_init

# Generate prd.json from your PRD.md
# Run: claude -p
# Then ask: "Use generating-prd skill to create prd.json from docs/PRD.md"

# Run autonomous development
make ralph ITERATIONS=10

# Check progress
make ralph_status
```

## Optional: MCP Servers

The template includes MCP servers in `.claude/settings.json`:
- `context7` - Code context management
- `exa` - Search capabilities

If you don't need these, remove them from `.claude/settings.json` under `enabledMcpjsonServers`.

## Directory Structure

```
your-project/
├── .claude/              # Claude Code configuration (don't modify)
├── docs/                 # Documentation
│   ├── PRD.md           # Product requirements (edit this!)
│   └── ralph/           # Ralph state (auto-generated, gitignored)
├── src/                 # Your source code goes here
├── tests/               # Your tests go here
├── Makefile             # Build automation
└── pyproject.toml       # Python project config
```

## Common Commands

```bash
make setup_dev        # Setup environment
make validate         # Run all checks (ruff, pyright, pytest)
make ralph_init       # Initialize Ralph loop
make ralph            # Run Ralph autonomous dev
make ralph_status     # Check Ralph progress
make help             # Show all available commands
```

## After Setup

1. Delete this file (`TEMPLATE_USAGE.md`)
2. Write your actual requirements in `docs/PRD.md`
3. Generate `prd.json` using the `generating-prd` skill
4. Run `make ralph` and let Claude Code autonomously implement your project

## Need Help?

- Read `docs/RalphUsage.md` for Ralph Loop details
- Check `.claude/skills/` for available skills
- See `.claude/rules/core-principles.md` for coding principles
