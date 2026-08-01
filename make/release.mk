# ═══════════════════════════════════════════════════════════════
# 🚀 RELEASE — Release Please readiness and diagnostics
# ═══════════════════════════════════════════════════════════════
# 🎯 Purpose: Inspect local Release Please readiness without mutating releases.
#
# 📎 Targets:
#    release-check   Validate checked-in release configuration.
#    release-status  Inspect pending release work and maintainer diagnostics.

RELEASE_CONFIG := release-please-config.json
RELEASE_MANIFEST := .release-please-manifest.json
RELEASE_VERSION_FILE := version.txt

.PHONY: help-release release-check release-status

# ═══════════════════════════════════════════════════════════════
# 🚀 HELP-RELEASE - Show the Release Please target catalog
# ═══════════════════════════════════════════════════════════════
# ──── Help: Lists non-mutating release readiness and status checks. ────
help-release: ## Show Release Please diagnostic targets
	@printf "\n"
	@printf "$(CYAN)🚀 Release Please targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make release-check         Validate local Release Please configuration\n"
	@printf "  make release-status        Show pending Release Please PRs and recent releases\n"
	@printf "\nRelease Please owns versions, CHANGELOG.md, vX.Y.Z tags, and GitHub Releases.\n"
	@printf "\n$(GREEN)  ✓ done$(NC)\n"
	@printf "\n$(YELLOW)📋 Quick Actions:$(NC)\n"
	@printf "$(DIM)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  • validate configuration: $(BLUE)make release-check$(NC)\n"
	@printf "  • inspect release status: $(BLUE)make release-status$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# 🚀 RELEASE-CHECK - Validate local Release Please configuration
# ═══════════════════════════════════════════════════════════════
# ──── Verify: Reads checked-in release state without changing it. ────
release-check: ## Validate local Release Please configuration without changing release state
	@printf "\n$(CYAN)🚀 release-check · validating local release configuration$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@set -euo pipefail; \
	if ! command -v jq > /dev/null 2>&1; then \
		printf "$(RED)jq is required for release-check$(NC)\n"; \
		exit 1; \
	fi; \
	for file in "$(RELEASE_CONFIG)" "$(RELEASE_MANIFEST)" "$(RELEASE_VERSION_FILE)" CHANGELOG.md; do \
		if [[ ! -f $$file ]]; then \
			printf "$(RED)Release file not found: %s$(NC)\n" "$$file"; \
			exit 1; \
		fi; \
	done; \
	version=$$(tr -d '\r\n' < "$(RELEASE_VERSION_FILE)"); \
	if [[ ! $$version =~ ^[0-9]+\.[0-9]+\.[0-9]+$$ ]]; then \
		printf "$(RED)version.txt must contain an X.Y.Z version$(NC)\n"; \
		exit 1; \
	fi; \
	if ! jq --exit-status \
		--arg version "$$version" \
		'.["."] == $$version' "$(RELEASE_MANIFEST)" > /dev/null; then \
		printf "$(RED)Manifest version does not match version.txt$(NC)\n"; \
		exit 1; \
	fi; \
	if ! jq --exit-status '.["release-type"] == "simple" and .["include-v-in-tag"] == true and .packages["."]["release-type"] == "simple" and .packages["."]["initial-version"] == "0.1.0" and .packages["."]["version-file"] == "version.txt" and .packages["."]["changelog-path"] == "CHANGELOG.md" and .packages["."]["include-v-in-tag"] == true' "$(RELEASE_CONFIG)" > /dev/null; then \
		printf "$(RED)Release Please configuration does not match the template contract$(NC)\n"; \
		exit 1; \
	fi; \
	printf "$(GREEN)  ✓ Release Please is ready at v%s$(NC)\n" "$$version"
	@printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make release-status$(NC) to inspect GitHub state\n\n"

# ═══════════════════════════════════════════════════════════════
# 🚀 RELEASE-STATUS - Inspect release workflow state
# ═══════════════════════════════════════════════════════════════
# ──── Inspect: Shows public lifecycle state and token availability only. ────
release-status: ## Show pending Release Please pull requests and recent GitHub releases
	@printf "\n$(CYAN)🚀 release-status · inspecting release workflow$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@set -euo pipefail; \
	if ! command -v gh > /dev/null 2>&1; then \
		printf "$(RED)GitHub CLI (gh) is required$(NC)\n"; \
		exit 1; \
	fi; \
	if ! gh auth status > /dev/null 2>&1; then \
		printf "$(RED)authenticate GitHub CLI first: gh auth login$(NC)\n"; \
		exit 1; \
	fi; \
	secret_names=""; \
	if ! secret_names=$$(gh secret list --json name --jq '.[].name'); then \
		printf "$(YELLOW)Unable to inspect RELEASE_PLEASE_TOKEN; verify maintainer configuration in GitHub.$(NC)\n"; \
	elif [[ $$secret_names == *"RELEASE_PLEASE_TOKEN"* ]]; then \
		printf "$(GREEN)RELEASE_PLEASE_TOKEN is configured for Release Please.$(NC)\n"; \
	else \
		printf "$(YELLOW)RELEASE_PLEASE_TOKEN is missing; Release Please cannot trigger normal PR CI.$(NC)\n"; \
	fi; \
	printf "$(CYAN)Pending Release Please pull requests$(NC)\n"; \
	gh pr list --base master --state open --label 'autorelease: pending'; \
	printf "\n$(CYAN)Recent GitHub releases$(NC)\n"; \
	gh release list --limit 5
	@printf "\n$(GREEN)  ✓ release workflow inspected$(NC)\n"
	@printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make release-check$(NC) to validate local configuration\n\n"
