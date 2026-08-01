#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly README_FILE="$REPO_ROOT/README.md"

assert_contains() {
  local expected=$1
  local file=$2

  if ! grep --fixed-strings --quiet -- "$expected" "$file"; then
    printf 'Expected %s to contain: %s\n' "$file" "$expected" >&2
    exit 1
  fi
}

assert_make_target() {
  local target=$1

  if ! make -C "$REPO_ROOT" --dry-run "$target" > /dev/null; then
    printf 'README advertises a missing Make target: %s\n' "$target" >&2
    exit 1
  fi
}

main() {
  local public_files=()
  local file=""
  local target=""

  assert_contains 'Bash project template' "$README_FILE"
  assert_contains 'Use this template' "$README_FILE"
  assert_contains 'one-commit history' "$README_FILE"
  assert_contains 'Quality Gate' "$README_FILE"
  assert_contains 'Release Please' "$README_FILE"
  assert_contains 'separate AUR packaging' "$README_FILE"

  for target in repository-bootstrap help format lint test verify docker-build docker-run docker-test release-check release-status; do
    assert_contains "make $target" "$README_FILE"
    assert_make_target "$target"
  done

  public_files=(
    "$README_FILE"
    "$REPO_ROOT/CONTRIBUTING.md"
    "$REPO_ROOT/.github/PULL_REQUEST_TEMPLATE.md"
    "$REPO_ROOT/.github/ISSUE_TEMPLATE/bug_report.yml"
    "$REPO_ROOT/.github/ISSUE_TEMPLATE/feature_request.yml"
    "$REPO_ROOT/.github/ISSUE_TEMPLATE/documentation_update.yml"
    "$REPO_ROOT/.github/ISSUE_TEMPLATE/custom.yml"
  )
  for file in "${public_files[@]}"; do
    if grep --ignore-case --quiet --extended-regexp 'ravn|hyprland|hyprctl' "$file"; then
      printf 'Public template file retains project-specific identity: %s\n' "$file" >&2
      exit 1
    fi
  done

  printf 'Public template documentation tests passed.\n'
}

main "$@"
