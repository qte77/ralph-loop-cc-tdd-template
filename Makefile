# This Makefile automates the build, test, and clean processes for the project.
# It provides a convenient way to run common tasks using the 'make' command.
# It is designed to work with the 'uv' tool for managing Python environments and dependencies.
# Run `make help` to see all available recipes.

.SILENT:
.ONESHELL:
.PHONY: setup_dev setup_claude_code setup_markdownlint setup_project run_markdownlint ruff test_all type_check validate quick_validate ralph_init ralph_run ralph_status ralph_clean ralph_reorganize help
.DEFAULT_GOAL := help


# MARK: setup


setup_dev:  ## Install uv and deps, Download and start Ollama 
	echo "Setting up dev environment ..."
	pip install uv -q
	uv sync --all-groups
	echo "npm version: $$(npm --version)"
	$(MAKE) -s setup_claude_code
	$(MAKE) -s setup_markdownlint

setup_claude_code:  ## Setup claude code CLI, node.js and npm have to be present
	echo "Setting up Claude Code CLI ..."
	npm install -gs @anthropic-ai/claude-code
	echo "Claude Code CLI version: $$(claude --version)"

setup_markdownlint:  ## Setup markdownlint CLI, node.js and npm have to be present
	echo "Setting up markdownlint CLI ..."
	npm install -gs markdownlint-cli
	echo "markdownlint version: $$(markdownlint --version)"

setup_project:  ## Customize template with your project details
	@echo "Project Setup"
	@echo "============="
	@# Check if already customized
	@if [ ! -d "src/your_project_name" ] && [ -z "$(GITHUB_REPO)" ]; then \
		echo "WARNING: Appears already customized (src/your_project_name/ not found)"; \
		read -p "Continue anyway? [y/N]: " confirm; \
		[ "$$confirm" != "y" ] && exit 0; \
	fi
	@# Get GITHUB_REPO (prompt if empty)
	@if [ -z "$(GITHUB_REPO)" ]; then \
		read -p "GitHub org/repo (e.g., acme/my-app): " GITHUB_REPO; \
	else \
		GITHUB_REPO="$(GITHUB_REPO)"; \
	fi; \
	# Derive PROJECT from GITHUB_REPO if not provided
	if [ -z "$(PROJECT)" ]; then \
		PROJECT=$${PROJECT:-$$(echo "$$GITHUB_REPO" | cut -d'/' -f2)}; \
		if [ -z "$$PROJECT" ]; then \
			read -p "Project name (kebab-case, e.g., my-app): " PROJECT; \
		fi; \
	else \
		PROJECT="$(PROJECT)"; \
	fi; \
	# Get DESCRIPTION (prompt if empty)
	if [ -z "$(DESCRIPTION)" ]; then \
		read -p "Project description: " DESCRIPTION; \
	else \
		DESCRIPTION="$(DESCRIPTION)"; \
	fi; \
	# Get AUTHOR (prompt if empty)
	if [ -z "$(AUTHOR)" ]; then \
		read -p "Author/Organization name: " AUTHOR; \
	else \
		AUTHOR="$(AUTHOR)"; \
	fi; \
	# Derive snake_case and year
	PROJECT_SNAKE=$$(echo "$$PROJECT" | tr '-' '_'); \
	YEAR=$$(date +%Y); \
	# Show summary
	echo ""; \
	echo "Applying:"; \
	echo "  GitHub repo: $$GITHUB_REPO"; \
	echo "  Project: $$PROJECT ($$PROJECT_SNAKE)"; \
	echo "  Description: $$DESCRIPTION"; \
	echo "  Author: $$AUTHOR"; \
	echo "  Year: $$YEAR"; \
	echo ""; \
	# Perform replacements
	sed -i "s|YOUR-ORG/YOUR-PROJECT-NAME|$$GITHUB_REPO|g" README.md; \
	sed -i "s|your-project-name|$$PROJECT|g" pyproject.toml; \
	sed -i "s|Python project using Ralph Loop autonomous development|$$DESCRIPTION|g" pyproject.toml; \
	sed -i "s|your_project_name|$$PROJECT_SNAKE|g" pyproject.toml; \
	sed -i "s|\[YEAR\]|$$YEAR|g" LICENSE.md; \
	sed -i "s|\[YOUR NAME OR ORGANIZATION\]|$$AUTHOR|g" LICENSE.md; \
	sed -i "s|your-project-name|$$PROJECT|g" scripts/ralph/init.sh; \
	sed -i "s|your-project-name|$$PROJECT|g" .claude/templates/ralph/progress.txt.template; \
	sed -i "s|your-project-name|$$PROJECT|g" .claude/templates/ralph/prd.json.template; \
	# Rename source directory
	if [ -d "src/your_project_name" ]; then \
		mv src/your_project_name "src/$$PROJECT_SNAKE"; \
	fi; \
	# Verify replacements
	REMAINING=$$(grep -r "YOUR-ORG\|your-project-name\|\[YEAR\]\|\[YOUR NAME" . --exclude-dir=.git --exclude="TEMPLATE_USAGE.md" 2>/dev/null | wc -l); \
	if [ $$REMAINING -gt 0 ]; then \
		echo ""; \
		echo "WARNING: Some placeholders may remain. Review with:"; \
		echo "  grep -r 'YOUR-ORG\|your-project-name' . --exclude-dir=.git"; \
	fi; \
	echo ""; \
	echo "Project setup complete!"


# MARK: run markdownlint


run_markdownlint:  ## Lint markdown files. Usage from root dir: make run_markdownlint INPUT_FILES="docs/**/*.md"
	if [ -z "$(INPUT_FILES)" ]; then
		echo "Error: No input files specified. Use INPUT_FILES=\"docs/**/*.md\""
		exit 1
	fi
	markdownlint $(INPUT_FILES) --fix


# MARK: Sanity


ruff:  ## Lint: Format and check with ruff
	uv run ruff format --exclude tests
	uv run ruff check --fix --exclude tests

test_all:  ## Run all tests
	uv run pytest

type_check:  ## Check for static typing errors
	uv run pyright src

validate:  ## Complete pre-commit validation sequence
	echo "Running complete validation sequence ..."
	$(MAKE) -s ruff
	-$(MAKE) -s type_check
	-$(MAKE) -s test_all
	echo "Validation sequence completed (check output for any failures)"

quick_validate:  ## Fast development cycle validation
	echo "Running quick validation ..."
	$(MAKE) -s ruff
	-$(MAKE) -s type_check
	echo "Quick validation completed (check output for any failures)"


# MARK: ralph


ralph_init:  ## Initialize Ralph loop environment
	echo "Initializing Ralph loop environment ..."
	bash scripts/ralph/init.sh

ralph_run:  ## Run Ralph autonomous development loop (use ITERATIONS=N to set max iterations)
	echo "Starting Ralph loop ..."
	ITERATIONS=$${ITERATIONS:-25}
	bash scripts/ralph/ralph.sh $$ITERATIONS

ralph_status:  ## Show Ralph loop progress and status
	echo "Ralph Loop Status"
	echo "================="
	if [ -f docs/ralph/prd.json ]; then \
		total=$$(jq '.stories | length' docs/ralph/prd.json); \
		passing=$$(jq '[.stories[] | select(.passes == true)] | length' docs/ralph/prd.json); \
		echo "Stories: $$passing/$$total completed"; \
		echo ""; \
		echo "Incomplete stories:"; \
		jq -r '.stories[] | select(.passes == false) | "  - [\(.id)] \(.title)"' docs/ralph/prd.json; \
	else \
		echo "prd.json not found. Run 'make ralph_init' first."; \
	fi

ralph_clean:  ## Reset Ralph state (WARNING: removes prd.json and progress.txt)
	echo "WARNING: This will reset Ralph loop state!"
	echo "Press Ctrl+C to cancel, Enter to continue..."
	read
	rm -f docs/ralph/prd.json docs/ralph/progress.txt
	echo "Ralph state cleaned. Run 'make ralph_init' to reinitialize."

ralph_reorganize:  ## Archive current PRD and start new iteration. Usage: make ralph_reorganize NEW_PRD=path/to/new.md [VERSION=2]
	@if [ -z "$(NEW_PRD)" ]; then \
		echo "Error: NEW_PRD parameter required"; \
		echo "Usage: make ralph_reorganize NEW_PRD=docs/PRD-New.md [VERSION=2]"; \
		exit 1; \
	fi
	@VERSION_ARG=""; \
	if [ -n "$(VERSION)" ]; then \
		VERSION_ARG="-v $(VERSION)"; \
	fi; \
	bash scripts/ralph/reorganize_prd.sh $$VERSION_ARG $(NEW_PRD)


# MARK: help


help:  ## Displays this message with available recipes
	# TODO add stackoverflow source
	echo "Usage: make [recipe]"
	echo "Recipes:"
	awk '/^[a-zA-Z0-9_-]+:.*?##/ {
		helpMessage = match($$0, /## (.*)/)
		if (helpMessage) {
			recipe = $$1
			sub(/:/, "", recipe)
			printf "  \033[36m%-20s\033[0m %s\n", recipe, substr($$0, RSTART + 3, RLENGTH)
		}
	}' $(MAKEFILE_LIST)