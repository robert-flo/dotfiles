#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly MAP_FILE="$REPO_ROOT/docs/repository-map.md"
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
  local file=""
  local map=""
  local readme=""

  if [[ ! -f $MAP_FILE ]]; then
    printf 'Repository map is missing: %s\n' "$MAP_FILE" >&2
    exit 1
  fi

  map=$(< "$MAP_FILE")
  readme=$(< "$README_FILE")
  assert_contains "$readme" '[Repository map](docs/repository-map.md)'
  assert_contains "$map" "\`docs/repository-map.md\`"

  while IFS= read -r file; do
    [[ -z $file ]] && continue
    assert_contains "$map" "\`$file\`"
  done < <(git -C "$REPO_ROOT" ls-files ':!tests/**')

  printf 'Repository map tests passed.\n'
}

main "$@"
