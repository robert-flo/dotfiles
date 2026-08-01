# ═══════════════════════════════════════════════════════════════
# ravn-cli product Git/workflow Make surface (prefixed targets only)
# ═══════════════════════════════════════════════════════════════

RAVN_CLI_WORKFLOW_DIR := make/ravn-cli/workflow

.PHONY: help-ravn-cli-git ravn-cli-help

help-ravn-cli-git: ## Show ravn-cli product Git/workflow Make targets
	@printf "\n"
	@printf "$(CYAN)ravn-cli workflow Make targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make ravn-cli-help          Show ravn-cli CLI help via the product launcher\n"
	@printf "  Portable companions live in $(RAVN_CLI_WORKFLOW_DIR)/ (construction examples).\n"
	@printf "  Prefixed Make workflow parity lands with later product evolution.\n"
	@printf "\n"

ravn-cli-help: ## Run ravn-cli help without entering the interactive menu
	@./ravn-cli help
