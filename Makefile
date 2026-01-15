# This Makefile automates the build, test, and clean processes for the project.
# It provides a convenient way to run common tasks using the 'make' command.
# It is designed to work with the 'uv' tool for managing Python environments and dependencies.
# Run `make help` to see all available recipes.

.SILENT:
.ONESHELL:
.PHONY: setup_dev setup_dev_full setup_claude_code setup_markdownlint run_markdownlint run_cli run_agent build_agent test_agent
.DEFAULT_GOAL := help


# MARK: setup


setup_dev:  ## Install uv and deps, Download and start Ollama 
	echo "Setting up dev environment ..."
	pip install uv -q
	uv sync --all-groups
	echo "npm version: $$(npm --version)"
	$(MAKE) -s setup_claude_code
	$(MAKE) -s setup_markdownlint
	
setup_dev_full: ## Complete dev setup including Opik tracing stack
	$(MAKE) -s setup_dev
	$(MAKE) -s setup_opik

setup_claude_code:  ## Setup claude code CLI, node.js and npm have to be present
	echo "Setting up Claude Code CLI ..."
	npm install -gs @anthropic-ai/claude-code
	echo "Claude Code CLI version: $$(claude --version)"

setup_markdownlint:  ## Setup markdownlint CLI, node.js and npm have to be present
	echo "Setting up markdownlint CLI ..."
	npm install -gs markdownlint-cli
	echo "markdownlint version: $$(markdownlint --version)"


# MARK: run markdownlint


run_markdownlint:  ## Lint markdown files. Usage from root dir: make run_markdownlint INPUT_FILES="docs/**/*.md"
	if [ -z "$(INPUT_FILES)" ]; then
		echo "Error: No input files specified. Use INPUT_FILES=\"docs/**/*.md\""
		exit 1
	fi
	markdownlint $(INPUT_FILES) --fix


# MARK: run app


run_cli:  ## Run app on CLI only. Usage: make run_cli ARGS="--help" or make run_cli ARGS="--download-peerread-samples-only"
	echo PYTHONPATH=$(SRC_PATH) uv run python $(CLI_PATH) $(ARGS)


# MARK: Sanity


ruff:  ## Lint: Format and check with ruff
	uv run ruff format --exclude tests
	uv run ruff check --fix --exclude tests

test_all:  ## Run all tests
	uv run pytest

coverage_all:  ## Get test coverage
	uv run coverage run -m pytest || true
	uv run coverage report -m

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

# MARK: opik

setup_opik:  ## Complete Opik setup (start services + configure environment)
	echo "Setting up Opik tracing stack..."
	$(MAKE) start_opik
	echo "Waiting for services to be healthy..."
	sleep 20
	$(MAKE) setup_opik_env
	echo "Opik setup complete!"

setup_opik_env:  ## Setup Opik environment variables for local development
	echo "Setting up Opik environment variables ..."
	echo "export OPIK_URL_OVERRIDE=http://localhost:8080" >> ~/.bashrc  # do not send to comet.com/api
	echo "export OPIK_WORKSPACE=peerread-evaluation" >> ~/.bashrc
	echo "export OPIK_PROJECT_NAME=peerread-evaluation" >> ~/.bashrc
	echo "Environment variables added to ~/.bashrc"
	echo "Run: source ~/.bashrc"

start_opik:  ## Start local Opik tracing with ClickHouse database
	# https://github.com/comet-ml/opik/blob/main/deployment/docker-compose/docker-compose.yaml
	# https://www.comet.com/docs/opik/self-host/local_deployment/
	echo "Starting Opik stack with ClickHouse ..."
	docker-compose -f docker-compose.opik.yaml up -d
	echo "Frontend: http://localhost:5173"
	echo "Backend API: http://localhost:8080"
	echo "ClickHouse: http://localhost:8123"

stop_opik:  ## Stop local Opik tracing stack
	echo "Stopping Opik stack ..."
	docker-compose -f docker-compose.opik.yaml down

clean_opik:  ## Stop Opik and remove all trace data (WARNING: destructive)
	echo "WARNING: This will remove all Opik trace data!"
	echo "Press Ctrl+C to cancel, Enter to continue..."
	read
	docker-compose -f docker-compose.opik.yaml down -v

status_opik:  ## Check Opik services health status
	echo "Checking Opik services status ..."
	docker-compose -f docker-compose.opik.yaml ps
	echo "API Health:"
	curl -f http://localhost:8080/health-check 2>/dev/null && \
		echo "Opik API healthy" || echo "Opik API not responding"
	echo "ClickHouse:"
	curl -s http://localhost:8123/ping 2>/dev/null && \
		echo "ClickHouse healthy" || echo "ClickHouse not responding"


# MARK: ralph


ralph_init:  ## Initialize Ralph loop environment
	echo "Initializing Ralph loop environment ..."
	bash .claude/scripts/ralph/init.sh

ralph:  ## Run Ralph autonomous development loop (use ITERATIONS=N to set max iterations)
	echo "Starting Ralph loop ..."
	ITERATIONS=$${ITERATIONS:-25}
	bash .claude/scripts/ralph/ralph.sh $$ITERATIONS

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


# MARK: agentbeats


run_agent:  ## Start AgentBeats server. Usage: make run_agent or make run_agent ARGS="--port 8080"
	PYTHONPATH=src uv run python -m agentbeats.server $(ARGS)

build_agent:  ## Build AgentBeats Docker image
	docker build -t green-agent .

test_agent:  ## Run agentbeats tests
	uv run pytest tests/


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