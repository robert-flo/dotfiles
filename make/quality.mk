# ═══════════════════════════════════════════════════════════════
# ✅ QUALITY — Local formatting, linting, testing, and verification
# ═══════════════════════════════════════════════════════════════
# 🎯 Purpose: Format deliberately, then run non-mutating quality contracts.
#
# 📎 Targets:
#    format  Apply formatting changes.
#    lint    Audit hygiene, documentation, and shell quality.
#    test    Run repository behavior contracts.
#    verify  Run the full non-mutating local acceptance contract.

SHELL := bash

TEST_EXCLUDE ?=

.PHONY: help-quality format lint test verify

# ═══════════════════════════════════════════════════════════════
# ✅ HELP-QUALITY - Show the local quality target catalog
# ═══════════════════════════════════════════════════════════════
# ──── Help: Distinguishes formatting from non-mutating verification. ────
help-quality: ## Show local quality targets
	@printf "\n"
	@printf "$(CYAN)✅ Local quality targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make format               Apply repository formatting rules; may modify files\n"
	@printf "  make lint                 Check File Hygiene, documentation, and shell quality; does not modify files\n"
	@printf "  make test                 Run repository behavior tests; does not modify files\n"
	@printf "  make verify               Run lint and test; does not modify files\n"
	@printf "\n$(GREEN)  ✓ done$(NC)\n"
	@printf "\n$(YELLOW)📋 Quick Actions:$(NC)\n"
	@printf "$(DIM)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  • apply formatting: $(BLUE)make format$(NC)\n"
	@printf "  • run full verification: $(BLUE)make verify$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# ✅ FORMAT - Apply repository formatting rules
# ═══════════════════════════════════════════════════════════════
# ──── Format: The only quality target allowed to rewrite files. ────
format: ## Apply repository formatting rules; may modify files
	@printf "\n$(CYAN)✅ format · applying repository formatting$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@set -euo pipefail; \
	for hook in end-of-file-fixer trailing-whitespace; do \
	  pre-commit run "$$hook" --all-files || pre-commit run "$$hook" --all-files; \
	done; \
	shell_files=(); \
	while IFS= read -r -d '' file; do \
	  if [[ $$file == *.sh ]]; then \
	    shell_files+=("$$file"); \
	    continue; \
	  fi; \
	  first_line=""; \
	  first_line=$$(head -n 1 -- "$$file" 2> /dev/null || true); \
	  if [[ $$first_line =~ ^\#\!.*(bash|sh) ]]; then \
	    shell_files+=("$$file"); \
	  fi; \
	done < <(git ls-files --cached --others --exclude-standard -z); \
	if (($${#shell_files[@]} > 0)); then \
	  shfmt -i 2 -sr -kp -ci -w -- "$${shell_files[@]}"; \
	fi
	@printf "\n$(GREEN)  ✓ formatting complete$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# ✅ LINT - Audit quality without changing the worktree
# ═══════════════════════════════════════════════════════════════
# ──── Lint: Runs File Hygiene, Doc, and Shell Quality Gates. ────
lint: ## Check repository quality without modifying files
	@printf "\n$(CYAN)✅ lint · auditing repository quality$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@set -euo pipefail; \
	temp_dir=$$(mktemp -d); \
	trap 'rm -rf "$$temp_dir"' EXIT; \
	tar --exclude=.git -cf - . | tar -xf - -C "$$temp_dir"; \
	git -C "$$temp_dir" init --quiet; \
	git -C "$$temp_dir" add --all; \
	( \
	  cd "$$temp_dir"; \
	  pre-commit run end-of-file-fixer --all-files; \
	  pre-commit run trailing-whitespace --all-files; \
	); \
	for hook in check-added-large-files check-merge-conflict check-symlinks check-json check-yaml check-toml check-xml markdownlint-cli2; do \
	  pre-commit run "$$hook" --all-files; \
	done; \
	RAVN_SHELL_QUALITY_SCOPE=all .git-hooks/ravn-shell-quality
	@printf "\n$(GREEN)  ✓ quality audit passed$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# ✅ TEST - Run repository behavior contracts
# ═══════════════════════════════════════════════════════════════
# ──── Test: Executes behavior checks without rewriting the worktree. ────
test: ## Run repository behavior tests without modifying files
	@printf "\n$(CYAN)✅ test · running repository behavior contracts$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@set -euo pipefail; \
	for test_file in tests/*.sh; do \
	  [[ -e $$test_file ]] || continue; \
	  skip_test=0; \
	  for excluded_test in $(TEST_EXCLUDE); do \
	    if [[ $$test_file == $$excluded_test ]]; then \
	      skip_test=1; \
	      break; \
	    fi; \
	  done; \
	  if ((skip_test)); then \
	    continue; \
	  fi; \
	  bash "$$test_file"; \
	done
	@printf "\n$(GREEN)  ✓ behavior contracts passed$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# ✅ VERIFY - Run the aggregate non-mutating acceptance contract
# ═══════════════════════════════════════════════════════════════
# ──── Verify: Combines lint and test under one memorable command. ────
verify: ## Run all non-mutating local quality checks
	@printf "\n$(CYAN)✅ verify · running full local acceptance$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@$(MAKE) --no-print-directory lint
	@$(MAKE) --no-print-directory test
	@printf "\n$(GREEN)  ✓ full local acceptance passed$(NC)\n"
	@printf "$(YELLOW)📋 Quick Actions:$(NC) $(BLUE)make format$(NC) to apply formatting when needed\n\n"
