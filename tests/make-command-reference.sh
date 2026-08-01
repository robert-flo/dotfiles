#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly REFERENCE_FILE="$REPO_ROOT/docs/make/README.md"
readonly README_FILE="$REPO_ROOT/README.md"

assert_contains() {
  local output=$1
  local expected=$2

  if [[ $output != *"$expected"* ]]; then
    printf 'Expected output to contain: %s\n' "$expected" >&2
    exit 1
  fi
}

main() {
  local help_output=""
  local readme=""
  local reference=""
  local target=""
  local targets=""

  if [[ ! -f $REFERENCE_FILE ]]; then
    printf 'Make command reference is missing: %s\n' "$REFERENCE_FILE" >&2
    exit 1
  fi

  help_output=$(env -i PATH="$PATH" HOME="$HOME" make -C "$REPO_ROOT" --no-print-directory help)
  reference=$(< "$REFERENCE_FILE")
  readme=$(< "$README_FILE")
  targets=$(printf '%s\n' "$help_output" | sed -E 's/\x1B\[[0-9;]*[[:alpha:]]//g' | sed -nE 's/^[[:space:]]*make[[:space:]]+([a-z0-9-]+).*/\1/p' | sort -u)

  while IFS= read -r target; do
    [[ -z $target ]] && continue
    assert_contains "$reference" "\`make $target"
  done <<< "$targets"

  assert_contains "$help_output" 'make git-configure-release-labels'
  assert_contains "$help_output" 'make git-diff-dev'
  assert_contains "$help_output" 'make git-diff-rc'
  assert_contains "$reference" '## Examples'
  assert_contains "$reference" 'make repository-bootstrap CONFIGURE_REMOTE=1'
  assert_contains "$reference" 'make git-cm MSG="docs: 📝 describe the command surface"'
  assert_contains "$reference" 'make verify'
  assert_contains "$reference" 'make docker-test'
  assert_contains "$reference" 'make release-status'
  assert_contains "$readme" '[Make command reference](docs/make/)'

  printf 'Make command reference tests passed.\n'
}

main "$@"
