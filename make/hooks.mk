# ═══════════════════════════════════════════════════════════════
# 🔒 QUALITY GATE — Entrypoint bootstrap
# ═══════════════════════════════════════════════════════════════
# Gate Bootstrap: verify host tools, install the pre-commit framework
# as the sole Git Entrypoint. Does not install system packages.
#
# 🎯 Purpose: Activate the local Quality Gate Entrypoint safely.
# 📎 Target: hooks-install — verify prerequisites and install the Entrypoint.
#
#   make hooks-install          Install / refresh the Quality Gate Entrypoint
#   make hooks-install DRY_RUN=1  Preview without mutating hooks

.PHONY: help-hooks hooks-install

# ═══════════════════════════════════════════════════════════════
# 🔒 HELP-HOOKS - Show the local Quality Gate setup target
# ═══════════════════════════════════════════════════════════════
# ──── Help: Lists the local hook installation action. ────
help-hooks: ## Show Quality Gate bootstrap targets
	@printf "\n"
	@printf "$(CYAN)🔒 Quality Gate targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make hooks-install        Verify tools and install the pre-commit Entrypoint\n"
	@printf "\n  Required host tools: pre-commit, shfmt, shellcheck (must already be on PATH).\n"
	@printf "  Set DRY_RUN=1 to preview without installing hooks.\n"
	@printf "\n$(GREEN)  ✓ done$(NC)\n"
	@printf "\n$(YELLOW)📋 Quick Actions:$(NC)\n"
	@printf "$(DIM)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  • install the Entrypoint: $(BLUE)make hooks-install$(NC)\n"
	@printf "  • preview safely: $(BLUE)make hooks-install DRY_RUN=1$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# 🔒 HOOKS-INSTALL - Gate Bootstrap
# ═══════════════════════════════════════════════════════════════
# Verifies pre-commit, shfmt, and shellcheck are on PATH, then runs
# `pre-commit install` so the framework owns .git/hooks/pre-commit.
# Does not install OS packages; prints install hints on failure.
hooks-install: ## Gate Bootstrap: verify tools and install pre-commit Entrypoint
	@printf "\n"
	@printf "$(CYAN)🔒 hooks-install · Quality Gate bootstrap$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@set -eu; \
	missing=""; \
	for tool in pre-commit shfmt shellcheck; do \
	  if ! command -v "$$tool" > /dev/null 2>&1; then \
	    missing="$$missing $$tool"; \
	  fi; \
	done; \
	if [ -n "$$missing" ]; then \
	  printf "$(RED)  ✗ missing required tool(s):$(NC)%s\n\n" "$$missing"; \
	  printf "  Install on Arch Linux, for example:\n"; \
	  printf "    $(BLUE)sudo pacman -S pre-commit shfmt shellcheck$(NC)\n"; \
	  printf "  Or via pip (pre-commit only):\n"; \
	  printf "    $(BLUE)pip install pre-commit$(NC)\n\n"; \
	  printf "  Gate Bootstrap does not install packages for you.\n\n"; \
	  exit 1; \
	fi; \
	printf "  $(DIM)pre-commit$(NC)  $$(command -v pre-commit)\n"; \
	printf "  $(DIM)shfmt$(NC)       $$(command -v shfmt)\n"; \
	printf "  $(DIM)shellcheck$(NC)  $$(command -v shellcheck)\n"; \
	if [ "$(DRY_RUN)" = "1" ]; then \
	  printf "\n  ▶ [dry-run] would run: pre-commit install\n"; \
	  printf "$(GREEN)  ✓ preview complete$(NC)\n"; \
	  printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make hooks-install$(NC) to install the Entrypoint\n\n"; \
	  exit 0; \
	fi; \
	printf "\n  installing pre-commit Git Entrypoint...\n"; \
	pre-commit install; \
	printf "\n$(GREEN)  ✓ Quality Gate Entrypoint active (pre-commit framework)$(NC)\n"; \
	printf "  $(DIM)Run checks: pre-commit run --all-files$(NC)\n"
	@printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make verify$(NC) to run the local acceptance suite\n\n"
