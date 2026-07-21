# ═══════════════════════════════════════════════════════════════
# 🚀 RELEASE — Release Please readiness and diagnostics
# ═══════════════════════════════════════════════════════════════

RELEASE_CONFIG := release-please-config.json
RELEASE_MANIFEST := .release-please-manifest.json
RELEASE_VERSION_FILE := version.txt

.PHONY: help-release release-check release-status

help-release: ## Show Release Please diagnostic targets
	@printf "\n"
	@printf "$(CYAN)Release Please targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make release-check         Validate local Release Please configuration\n"
	@printf "  make release-status        Show pending Release Please PRs and recent releases\n"
	@printf "\nRelease Please owns versions, CHANGELOG.md, vX.Y.Z tags, and GitHub Releases.\n"

release-check: ## Validate local Release Please configuration without changing release state
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
	printf "$(GREEN)Release Please is ready at v%s$(NC)\n" "$$version"

release-status: ## Show pending Release Please pull requests and recent GitHub releases
	@set -euo pipefail; \
	if ! command -v gh > /dev/null 2>&1; then \
		printf "$(RED)GitHub CLI (gh) is required$(NC)\n"; \
		exit 1; \
	fi; \
	if ! gh auth status > /dev/null 2>&1; then \
		printf "$(RED)authenticate GitHub CLI first: gh auth login$(NC)\n"; \
		exit 1; \
	fi; \
	printf "$(CYAN)Pending Release Please pull requests$(NC)\n"; \
	gh pr list --base master --state open --label 'autorelease: pending'; \
	printf "\n$(CYAN)Recent GitHub releases$(NC)\n"; \
	gh release list --limit 5
