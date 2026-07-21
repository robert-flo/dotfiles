#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly SELF_TEST="tests/make-quality-contract.sh"
readonly CI_WORKFLOW="$REPO_ROOT/.github/workflows/ci.yml"
TEMP_DIR=""
TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR
readonly FIXTURE_DIR="$TEMP_DIR/repository"

cleanup() {
  git -C "$REPO_ROOT" worktree remove --force "$FIXTURE_DIR" > /dev/null 2>&1 || true
  rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

assert_contains() {
  local output=$1
  local expected=$2

  if [[ $output != *"$expected"* ]]; then
    printf 'Expected output to contain: %s\n' "$expected" >&2
    exit 1
  fi
}

run_non_mutating_target() {
  local worktree=$1
  local target=$2
  local before=""
  local after=""

  before=$(git -C "$worktree" status --porcelain)
  if [[ -n $before ]]; then
    printf 'Quality fixture must start clean before make %s.\n' "$target" >&2
    exit 1
  fi

  make -C "$worktree" "$target" TEST_EXCLUDE="$SELF_TEST"
  after=$(git -C "$worktree" status --porcelain)

  if [[ -n $after ]]; then
    printf 'make %s changed the clean quality fixture unexpectedly.\n' "$target" >&2
    git -C "$worktree" diff --exit-code >&2 || true
    exit 1
  fi
}

main() {
  local help_output=""
  local ci_workflow=""

  cd "$REPO_ROOT"
  git worktree add --detach "$FIXTURE_DIR" HEAD > /dev/null
  help_output=$(make -C "$FIXTURE_DIR" help)
  ci_workflow=$(< "$CI_WORKFLOW")

  assert_contains "$help_output" 'make format'
  assert_contains "$help_output" 'make lint'
  assert_contains "$help_output" 'make test'
  assert_contains "$help_output" 'make verify'
  assert_contains "$ci_workflow" 'run: make verify'

  run_non_mutating_target "$FIXTURE_DIR" lint
  run_non_mutating_target "$FIXTURE_DIR" test
  run_non_mutating_target "$FIXTURE_DIR" verify

  printf 'Make quality contract tests passed.\n'
}

main "$@"
