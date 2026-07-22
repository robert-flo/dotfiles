# ═══════════════════════════════════════════════════════════════
# 📎 COMPATIBILITY ALIASES
# ═══════════════════════════════════════════════════════════════
# 🎯 Purpose: Short redirects for the Git and Docker targets
#
# 📎 Aliases intentionally do not print their own target banners: they only
#    delegate to canonical targets, which own the behavior and terminal
#    language in make/git.mk and make/docker.mk.

.PHONY: help-aliases \
        git-a git-c git-ac git-p git-st git-s git-d git-l git-lg \
        git-af git-fuck git-bye git-df git-fc git-fm \
        a c ac p l st s d lg af fuck bye clean df fc fm cm db dr dt dc

# ═══════════════════════════════════════════════════════════════
# 📎 HELP-ALIASES - Show compatibility aliases for Git targets
# ═══════════════════════════════════════════════════════════════
# ──── Help: Maps historical shorthand names to their canonical targets. ────
help-aliases: ## Show Git compatibility aliases
	@printf "\n"
	@printf "$(CYAN)📎 Compatibility aliases$(NC)\n"
	@printf "$(CYAN)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "\n"
	@printf "$(BLUE)%-20s %-25s %s$(NC)\n" "ALIAS" "TARGET" "DESCRIPTION"
	@printf "$(CYAN)%-20s %-25s %s$(NC)\n" "-----" "------" "-----------"
	@printf "%-20s %-25s %s\n" "a / git-a" "git-add" "Stage all changes"
	@printf "%-20s %-25s %s\n" "c / git-c" "git-commit" "Create a timestamped commit"
	@printf "%-20s %-25s %s\n" "cm" "git-cm MSG=..." "Commit with a custom message"
	@printf "%-20s %-25s %s\n" "ac / git-ac" "git-add-commit" "Stage and commit"
	@printf "%-20s %-25s %s\n" "p / git-p" "git-push" "Push the current branch"
	@printf "%-20s %-25s %s\n" "l / git-l" "git-pull" "Pull the current branch"
	@printf "%-20s %-25s %s\n" "st, s / git-st, git-s" "git-status" "Show repository state"
	@printf "%-20s %-25s %s\n" "d / git-d" "git-diff" "Show uncommitted changes"
	@printf "%-20s %-25s %s\n" "lg / git-lg" "git-log" "Show recent history"
	@printf "%-20s %-25s %s\n" "af / git-af" "git-add-fuzzy" "Interactively stage changes"
	@printf "%-20s %-25s %s\n" "fuck / git-fuck" "git-amend" "Amend the last commit"
	@printf "%-20s %-25s %s\n" "bye, clean / git-bye" "git-clean" "Remove merged worktrees"
	@printf "%-20s %-25s %s\n" "df / git-df" "git-diff-fuzzy" "Select a commit to inspect"
	@printf "%-20s %-25s %s\n" "fc / git-fc" "git-search CODE=..." "Search history by code"
	@printf "%-20s %-25s %s\n" "fm / git-fm" "git-search MSG=..." "Search history by message"
	@printf "%-20s %-25s %s\n" "db" "docker-build" "Build the local Docker image"
	@printf "%-20s %-25s %s\n" "dr" "docker-run" "Run the local Docker image"
	@printf "%-20s %-25s %s\n" "dt" "docker-test" "Verify the local Docker image output"
	@printf "%-20s %-25s %s\n" "dc" "docker-clean" "Remove the local Docker image"
	@printf "\n$(GREEN)  ✓ done$(NC)\n"
	@printf "\n$(YELLOW)📋 Quick Actions:$(NC)\n"
	@printf "$(DIM)────────────────────────────────────────────────────────────────────────────────$(NC)\n"
	@printf "  • inspect canonical commands: $(BLUE)make help-git$(NC)\n"
	@printf "  • inspect Docker commands: $(BLUE)make help-docker$(NC)\n\n"

# ═══════════════════════════════════════════════════════════════
# 📎 GIT COMPATIBILITY ALIASES - Delegate to canonical Git targets
# ═══════════════════════════════════════════════════════════════
# ──── Aliases: Preserve short commands without duplicating behavior. ────
git-a: git-add
git-c: git-commit
git-ac: git-add-commit
git-p: git-push
git-st: git-status
git-s: git-status
git-d: git-diff
git-l: git-pull
git-lg: git-log
git-af: git-add-fuzzy
git-fuck: git-amend
git-bye: git-clean
git-df: git-diff-fuzzy
git-fc: git-search
git-fm: git-search

# ═══════════════════════════════════════════════════════════════
# 📎 SHORT GIT ALIASES - Delegate to canonical Git targets
# ═══════════════════════════════════════════════════════════════
# ──── Aliases: Provide concise interactive shortcuts. ────
a: git-add
c: git-commit
cm: git-cm
ac: git-add-commit
p: git-push
l: git-pull
st: git-status
s: git-status
d: git-diff
lg: git-log
af: git-add-fuzzy
fuck: git-amend
bye: git-clean
clean: git-clean
df: git-diff-fuzzy
fc: git-search
fm: git-search

# ═══════════════════════════════════════════════════════════════
# 📎 DOCKER ALIASES - Delegate to canonical Docker targets
# ═══════════════════════════════════════════════════════════════
# ──── Aliases: Keep Docker shortcuts aligned with their canonical output. ────
db: docker-build
dr: docker-run
dt: docker-test
dc: docker-clean
