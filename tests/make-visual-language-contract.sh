#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT

assert_contains() {
  local output=$1
  local expected=$2

  if [[ $output != *"$expected"* ]]; then
    printf 'Expected output to contain: %s\n' "$expected" >&2
    exit 1
  fi
}

assert_file_contains() {
  local file=$1
  local expected=$2
  local contents=""

  contents=$(< "$file")
  assert_contains "$contents" "$expected"
}

assert_help_language() {
  local target=$1
  local title=$2
  local output=""

  output=$(make -C "$REPO_ROOT" --no-print-directory "$target")
  assert_contains "$output" "$title"
  assert_contains "$output" '────────────────────────────────────────────────────────────────────────────────'
  assert_contains "$output" '📋 Quick Actions:'
  assert_contains "$output" '✓ done'
}

main() {
  assert_help_language help-git '🔀 Git targets'
  assert_help_language help-docker '🐳 Docker targets'
  assert_help_language help-aliases '📎 Compatibility aliases'
  assert_help_language help-hooks '🔒 Quality Gate targets'
  assert_help_language help-quality '✅ Local quality targets'
  assert_help_language help-release '🚀 Release Please targets'

  assert_file_contains "$REPO_ROOT/make/docker.mk" '# 🐳 DOCKER-BUILD -'
  assert_file_contains "$REPO_ROOT/make/docker.mk" '# 🐳 DOCKER-RUN -'
  assert_file_contains "$REPO_ROOT/make/docker.mk" '# 🐳 DOCKER-TEST -'
  assert_file_contains "$REPO_ROOT/make/docker.mk" '# 🐳 DOCKER-CLEAN -'
  assert_file_contains "$REPO_ROOT/make/hooks.mk" '# 🔒 HOOKS-INSTALL -'
  assert_file_contains "$REPO_ROOT/make/quality.mk" '# ✅ FORMAT -'
  assert_file_contains "$REPO_ROOT/make/quality.mk" '# ✅ LINT -'
  assert_file_contains "$REPO_ROOT/make/quality.mk" '# ✅ TEST -'
  assert_file_contains "$REPO_ROOT/make/quality.mk" '# ✅ VERIFY -'
  assert_file_contains "$REPO_ROOT/make/release.mk" '# 🚀 RELEASE-CHECK -'
  assert_file_contains "$REPO_ROOT/make/release.mk" '# 🚀 RELEASE-STATUS -'
  assert_file_contains "$REPO_ROOT/make/git.mk" '# ──── Configure:'
  assert_file_contains "$REPO_ROOT/make/git.mk" '# ──── Bootstrap:'
  assert_file_contains "$REPO_ROOT/make/git.mk" '# 🧹 GIT-PRUNE-BRANCHES -'
  assert_file_contains "$REPO_ROOT/make/aliases.mk" 'language stay centralized'

  printf 'Make visual language contract tests passed.\n'
}

main "$@"
