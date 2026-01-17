# Python Ralph-Loop Template

> What at time to be alive

Out-of-the-box Python project template using Ralph Loop autonomous development with Claude Code.

![Version](https://img.shields.io/badge/version-0.0.0-58f4c2.svg)
[![License](https://img.shields.io/badge/license-BSD3Clause-58f4c2.svg)](LICENSE.md)
[![CodeQL](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/codeql.yaml/badge.svg)](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/codeql.yaml)
[![CodeFactor](https://www.codefactor.io/repository/github/YOUR-ORG/YOUR-PROJECT-NAME/badge)](https://www.codefactor.io/repository/github/YOUR-ORG/YOUR-PROJECT-NAME)
[![ruff](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/ruff.yaml/badge.svg)](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/ruff.yaml)
[![pytest](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/pytest.yaml/badge.svg)](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/pytest.yaml)
[![Link Checker](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/links-fail-fast.yaml/badge.svg)](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/links-fail-fast.yaml)
[![Deploy Docs](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/generate-deploy-mkdocs-ghpages.yaml/badge.svg)](https://github.com/YOUR-ORG/YOUR-PROJECT-NAME/actions/workflows/generate-deploy-mkdocs-ghpages.yaml)

## Quick Start

```bash
# Setup development environment
make setup_dev

# Initialize Ralph loop
make ralph_init

# Run autonomous development
make ralph ITERATIONS=5
```

## Ralph Loop Workflow

1. **Write requirements** in `docs/PRD.md`
2. **Generate tasks**: Use `generating-prd` skill to create `docs/ralph/prd.json`
3. **Run Ralph loop**: `make ralph` executes tasks autonomously
4. **Monitor progress**: `make ralph_status`

## Development

```bash
# Format and lint
make ruff

# Type check
make type_check

# Run tests
make test_all

# Complete validation
make validate
```

## Project Structure

```
.claude/
  commands/      # Slash commands (commit, phase-*, etc.)
  rules/         # Auto-applied coding principles (KISS, DRY, YAGNI)
  scripts/ralph/ # Ralph loop orchestration scripts
  skills/        # Specialized skills (designing-backend, implementing-python, etc.)
  templates/     # PRD and progress templates
docs/
  PRD.md         # Requirements document (input to Ralph loop)
  ralph/         # Ralph loop state (prd.json, progress.txt)
Makefile         # Build automation and Ralph orchestration
```

## Core Principles

- **KISS** (Keep It Simple, Stupid)
- **DRY** (Don't Repeat Yourself)
- **YAGNI** (You Aren't Gonna Need It)
- User Experience, Joy, and Success

See `.claude/rules/core-principles.md` for full guidelines.

## License

BSD 3-Clause License (see LICENSE.md)
