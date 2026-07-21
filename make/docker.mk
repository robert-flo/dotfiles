# ═══════════════════════════════════════════════════════════════
# 🐳 DOCKER — Executable container baseline
# ═══════════════════════════════════════════════════════════════

DOCKER_IMAGE ?= dotfiles:local
DOCKERFILE ?= Dockerfile
DOCKER_EXPECTED_OUTPUT ?= Hello, world!
DOCKER_TEST_IMAGE := dotfiles:local

.PHONY: help-docker docker-build docker-run docker-test docker-clean

help-docker: ## Show Docker targets
	@printf "\n"
	@printf "$(CYAN)Docker targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make docker-build          Build the local Hello World image\n"
	@printf "  make docker-run            Run the image and print its output\n"
	@printf "  make docker-test           Verify Hello, world!; skips when Docker is unavailable\n"
	@printf "  make docker-clean          Remove the managed local image\n"
	@printf "\n"

docker-build: ## Build the local Hello World image
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@test -f "$(DOCKERFILE)" || { printf "$(RED)Dockerfile not found: $(DOCKERFILE)$(NC)\n"; exit 1; }
	@docker build --file "$(DOCKERFILE)" --tag "$(DOCKER_IMAGE)" .

docker-run: ## Run the local image and print its output
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@if ! docker image inspect "$(DOCKER_IMAGE)" > /dev/null 2>&1; then \
		$(MAKE) --no-print-directory docker-build; \
	fi
	@docker run --rm "$(DOCKER_IMAGE)"

docker-test: ## Verify the container output; skips when Docker is unavailable
	@if ! command -v docker > /dev/null 2>&1 || ! docker info > /dev/null 2>&1; then \
		printf "$(YELLOW)Docker is unavailable; container verification skipped.$(NC)\n"; \
		exit 0; \
	fi
	@if ! docker image inspect "$(DOCKER_IMAGE)" > /dev/null 2>&1; then \
		$(MAKE) --no-print-directory docker-build > /dev/null; \
	fi
	@actual_file=$$(mktemp); \
	expected_file=$$(mktemp); \
	trap 'rm -f "$$actual_file" "$$expected_file"' EXIT; \
	if ! docker run --rm "$(DOCKER_IMAGE)" > "$$actual_file"; then \
		printf "$(RED)Container exited with a failure status.$(NC)\n"; \
		exit 1; \
	fi; \
	printf '%s\n' "$(DOCKER_EXPECTED_OUTPUT)" > "$$expected_file"; \
	if ! cmp -s "$$expected_file" "$$actual_file"; then \
		printf "$(RED)Container output did not match the expected bytes.$(NC)\n"; \
		exit 1; \
	fi; \
	printf "$(GREEN)Container output verified: %s$(NC)\n" "$(DOCKER_EXPECTED_OUTPUT)"

docker-clean: ## Remove the managed local Docker image
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@if [[ "$(DOCKER_IMAGE)" != "$(DOCKER_TEST_IMAGE)" ]]; then \
		printf "$(RED)Refusing to remove unmanaged Docker image: $(DOCKER_IMAGE)$(NC)\n"; \
		exit 1; \
	fi
	@if docker image inspect "$(DOCKER_IMAGE)" > /dev/null 2>&1; then \
		docker image rm "$(DOCKER_IMAGE)"; \
	else \
		printf "$(GREEN)No local Docker image to remove$(NC)\n"; \
	fi
