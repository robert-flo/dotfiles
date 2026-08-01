# ═══════════════════════════════════════════════════════════════
# 🐳 DOCKER — Executable container baseline
# ═══════════════════════════════════════════════════════════════
# 🎯 Purpose: Build, run, verify, and remove the baseline container image.
#
# 📎 Targets:
#    docker-build  Build the local image.
#    docker-run    Run the image and print its output.
#    docker-test   Verify the exact container output.
#    docker-clean  Remove only the managed local image.

DOCKER_IMAGE ?= dotfiles:local
DOCKERFILE ?= Dockerfile
DOCKER_EXPECTED_OUTPUT ?= Hello, world!
DOCKER_TEST_IMAGE := dotfiles:local

.PHONY: help-docker docker-build docker-run docker-test docker-clean

# ═══════════════════════════════════════════════════════════════
# 🐳 HELP-DOCKER - Show the Docker target catalog
# ═══════════════════════════════════════════════════════════════
# ──── Help: Lists the safe build, run, verify, and cleanup actions. ────
help-docker: ## Show Docker targets
	@printf "\n"
	@printf "$(CYAN)🐳 Docker targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make docker-build          Build the local Hello World image\n"
	@printf "  make docker-run            Run the image and print its output\n"
	@printf "  make docker-test           Verify Hello, world!; skips when Docker is unavailable\n"
	@printf "  make docker-clean          Remove the managed local image\n"
	@printf "\n$(GREEN)  ✓ done$(NC)\n"
	@printf "\n$(YELLOW)📋 Quick Actions:$(NC)\n"
	@printf "$(DIM)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  • build the image: $(BLUE)make docker-build$(NC)\n"
	@printf "  • verify its output: $(BLUE)make docker-test$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# 🐳 DOCKER-BUILD - Build the managed local image
# ═══════════════════════════════════════════════════════════════
# ──── Build: Creates the executable Hello World container image. ────
docker-build: ## Build the local Hello World image
	@printf "\n$(CYAN)🐳 docker-build · building local image$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n"; exit 1; }
	@test -f "$(DOCKERFILE)" || { printf "$(RED)Dockerfile not found: $(DOCKERFILE)$(NC)\n"; exit 1; }
	@docker build --file "$(DOCKERFILE)" --tag "$(DOCKER_IMAGE)" .
	@printf "\n$(GREEN)  ✓ image ready: %s$(NC)\n\n" "$(DOCKER_IMAGE)"

# ═══════════════════════════════════════════════════════════════
# 🐳 DOCKER-RUN - Run the managed local image
# ═══════════════════════════════════════════════════════════════
# ──── Run: Builds the image when needed, then streams its output. ────
docker-run: ## Run the local image and print its output
	@printf "\n$(CYAN)🐳 docker-run · running local image$(NC)\n" >&2
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n" >&2
	@command -v docker > /dev/null || { printf "$(RED)Docker is not installed$(NC)\n" >&2; exit 1; }
	@if ! docker image inspect "$(DOCKER_IMAGE)" > /dev/null 2>&1; then \
		$(MAKE) --no-print-directory docker-build >&2; \
	fi
	@docker run --rm "$(DOCKER_IMAGE)"
	@printf "\n$(GREEN)  ✓ container completed$(NC)\n" >&2
	@printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make docker-test$(NC) to verify its output\n\n" >&2

# ═══════════════════════════════════════════════════════════════
# 🐳 DOCKER-TEST - Verify the managed image output
# ═══════════════════════════════════════════════════════════════
# ──── Verify: Confirms the container exits successfully with exact output. ────
docker-test: ## Verify the container output; skips when Docker is unavailable
	@printf "\n$(CYAN)🐳 docker-test · verifying container output$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@if ! command -v docker > /dev/null 2>&1 || ! docker info > /dev/null 2>&1; then \
		printf "$(YELLOW)Docker is unavailable; container verification skipped.$(NC)\n"; \
		printf "$(GREEN)  ✓ skipped$(NC)\n"; \
		printf "$(YELLOW)📋 Quick Actions:$(NC) install Docker, then run $(BLUE)make docker-test$(NC)\n\n"; \
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
	printf "$(GREEN)  ✓ container output verified: %s$(NC)\n" "$(DOCKER_EXPECTED_OUTPUT)"
	@printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make docker-run$(NC) to run it directly\n\n"

# ═══════════════════════════════════════════════════════════════
# 🐳 DOCKER-CLEAN - Remove the managed local image
# ═══════════════════════════════════════════════════════════════
# ──── Clean: Refuses to remove images outside the managed name. ────
docker-clean: ## Remove the managed local Docker image
	@printf "\n$(CYAN)🐳 docker-clean · removing managed local image$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
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
	@printf "$(GREEN)  ✓ cleanup complete$(NC)\n"
	@printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make docker-build$(NC) to rebuild it\n\n"
