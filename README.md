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
# 1. Customize template with your project details
make setup_project

# 2. Setup development environment, if not done by devcontainer.json
make setup_dev

# 3. Write requirements in docs/PRD.md, then run Ralph
make ralph_init                 # Initialize (creates prd.json)
make ralph_run [ITERATIONS=25]  # Run autonomous development
make ralph_status               # Check progress

# 4. Post-run options
make ralph_clean                # Reset state (removes prd.json, progress.txt)
make ralph_reorganize NEW_PRD=docs/PRD-v2.md [VERSION=2]  # Archive and start new iteration
```

For detailed setup and usage, see [docs/TEMPLATE_USAGE.md](docs/TEMPLATE_USAGE.md).

## Project Structure

```
.claude/
  commands/      # Slash commands (commit, phase-*, etc.)
  rules/         # Auto-applied coding principles (KISS, DRY, YAGNI)
  skills/        # Specialized skills (designing-backend, implementing-python, etc.)
  templates/     # PRD and progress templates
docs/
  PRD.md         # Requirements document (input to Ralph loop)
  ralph/         # Ralph loop state (prd.json, progress.txt)
scripts/
  ralph/         # Ralph loop orchestration
Makefile         # Build automation and Ralph orchestration
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development workflow, core principles, and contribution guidelines.
