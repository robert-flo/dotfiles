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

assert_not_contains() {
  local forbidden=$1
  local file=$2

  if grep --fixed-strings --quiet -- "$forbidden" "$file"; then
    printf 'Expected %s not to contain: %s\n' "$file" "$forbidden" >&2
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
  local target=""

  assert_contains 'RaVN Dotfiles' "$README_FILE"
  assert_contains 'Quality Gate' "$README_FILE"
  assert_contains 'Release Please' "$README_FILE"
  assert_contains 'docs/ravn-cli/README.md' "$README_FILE"
  assert_contains 'ravn-cli' "$README_FILE"

  assert_not_contains 'Bash project template' "$README_FILE"
  assert_not_contains 'Use this template' "$README_FILE"
  assert_not_contains 'Customize before publishing' "$README_FILE"

  for target in repository-bootstrap help format lint test verify docker-build docker-run docker-test release-check release-status; do
    assert_contains "make $target" "$README_FILE"
    assert_make_target "$target"
  done

  printf 'Public product documentation tests passed.\n'
}

main "$@"
