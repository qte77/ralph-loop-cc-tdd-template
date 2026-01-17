# Template Usage

Python project template with Ralph Loop autonomous development.

## Setup Steps

### 1. Clone and Customize

```bash
# Clone this template
git clone <your-repo-url>
cd <your-repo>

# Customize the template
make setup_project
```

### 2. Write Requirements

Edit **`docs/PRD.md`** with your product requirements.

### 3. Setup Development Environment

```bash
# Install dependencies and tooling
make setup_dev

# Verify setup
make validate
```

### 4. Run Ralph Loop

```bash
make ralph_init              # Initialize (creates prd.json)
make ralph_run ITERATIONS=10 # Run autonomous development
make ralph_status            # Check progress
```

To generate prd.json: Run `claude -p` then use `generating-prd` skill.

### Starting New Product Iteration

When PRD.md changes significantly, reorganize and archive:

```bash
make ralph_reorganize NEW_PRD=docs/PRD-v2.md VERSION=2
```

Archives current PRD, prd.json, and progress to `docs/ralph/archive/`, then activates new PRD.

## Optional: MCP Servers

Template includes `context7` and `exa` MCP servers. Remove from `.claude/settings.json` if not needed.

## Directory Structure

```
your-project/
├── .claude/              # Claude Code configuration
├── docs/
│   ├── PRD.md           # Product requirements (edit this!)
│   ├── ralph/           # Ralph state (gitignored)
│   └── archive/         # Previous iterations
├── scripts/
│   └── ralph/           # Ralph automation scripts
├── src/                 # Your source code
├── tests/               # Your tests
├── Makefile             # Build automation
└── pyproject.toml       # Python project config
```

## Common Commands

```bash
make setup_project    # Customize template
make setup_dev        # Setup environment
make validate         # Run all checks
make ralph_init       # Initialize Ralph
make ralph_run        # Run autonomous dev
make ralph_status     # Check progress
make ralph_reorganize # Archive PRD and start new iteration
make help             # Show all commands
```

## Next Steps

1. Delete `TEMPLATE_USAGE.md`
2. Write requirements in `docs/PRD.md`
3. Run `make ralph_run` for autonomous implementation

See `docs/RalphUsage.md` for Ralph details, `.claude/skills/` for available skills.
