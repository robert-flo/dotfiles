#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly EXPECTED_OUTPUT="Hello, world!"
TEMP_DIR=""
TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR
readonly EXPECTED_FILE="$TEMP_DIR/expected"
readonly ACTUAL_FILE="$TEMP_DIR/actual"

cleanup() {
  rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

assert_expected_output() {
  local description=$1

  if ! cmp -s "$EXPECTED_FILE" "$ACTUAL_FILE"; then
    printf '%s did not match the expected bytes.\n' "$description" >&2
    exit 1
  fi
}

main() {
  cd "$REPO_ROOT"
  printf '%s\n' "$EXPECTED_OUTPUT" > "$EXPECTED_FILE"
  ./dockerfile.sh > "$ACTUAL_FILE"
  assert_expected_output 'Starter script output'

  if ! command -v docker > /dev/null 2>&1 || ! docker info > /dev/null 2>&1; then
    printf 'Docker is unavailable; container verification skipped.\n'
    exit 0
  fi

  make --no-print-directory docker-build > /dev/null
  make --no-print-directory docker-run > "$ACTUAL_FILE"
  assert_expected_output 'Container output'

  make --no-print-directory docker-test
  printf 'Docker Hello World tests passed.\n'
}

main "$@"
