# ═══════════════════════════════════════════════════════════════
# ✅ QUALITY — Local formatting, linting, testing, and verification
# ═══════════════════════════════════════════════════════════════

SHELL := bash

TEST_EXCLUDE ?=

.PHONY: help-quality format lint test verify

help-quality: ## Show local quality targets
	@printf "\n"
	@printf "$(CYAN)Local quality targets$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  make format               Apply repository formatting rules; may modify files\n"
	@printf "  make lint                 Check File Hygiene, documentation, and shell quality; does not modify files\n"
	@printf "  make test                 Run repository behavior tests; does not modify files\n"
	@printf "  make verify               Run lint and test; does not modify files\n"
	@printf "\n"

format: ## Apply repository formatting rules; may modify files
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

lint: ## Check repository quality without modifying files
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

test: ## Run repository behavior tests without modifying files
	@set -euo pipefail; \
	for test_file in tests/*.sh; do \
	  [[ -e $$test_file ]] || continue; \
	  if [[ -n "$(TEST_EXCLUDE)" && $$test_file == "$(TEST_EXCLUDE)" ]]; then \
	    continue; \
	  fi; \
	  bash "$$test_file"; \
	done

verify: lint test ## Run all non-mutating local quality checks
