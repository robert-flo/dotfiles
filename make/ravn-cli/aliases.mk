# ═══════════════════════════════════════════════════════════════
# ravn-cli product Make aliases (prefixed; does not redefine monorepo aliases)
# ═══════════════════════════════════════════════════════════════

.PHONY: help-ravn-cli-aliases ravn-cli-dr

help-ravn-cli-aliases: ## Show ravn-cli product Make aliases
	@printf "\n"
	@printf "$(CYAN)ravn-cli aliases$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make ravn-cli-dr            Alias for ravn-cli-docker-run\n"
	@printf "\n"

ravn-cli-dr: ravn-cli-docker-run ## Alias for ravn-cli-docker-run
