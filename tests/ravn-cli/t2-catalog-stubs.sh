#!/usr/bin/env bash
# Phase 1 / T2: full catalog construction stubs and menu recovery.

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RAVN_CLI="$ROOT_DIR/ravn-cli"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/ravn-cli-t2.XXXXXX")"

trap 'rm -rf "$TEST_ROOT"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_output() {
  grep -Fq "$2" "$1" || fail "missing output in $1: $2"
}

HOME_DIR="$TEST_ROOT/home"
mkdir -p "$HOME_DIR"

run_with_test_env() {
  local cmd="$1"
  shift
  env -C "$TEST_ROOT" HOME="$HOME_DIR" XDG_CONFIG_HOME="$HOME_DIR/.config" \
    TERM=dumb NO_COLOR=1 "$cmd" "$@"
}

run_cli() {
  run_with_test_env "$RAVN_CLI" "$@"
}

# Canonical commands and representative aliases.
for pair in \
  'config:hola desde config' \
  'f:hola desde config' \
  'verify:hola desde verify' \
  'v:hola desde verify' \
  'setup:hola desde setup' \
  's:hola desde setup' \
  'test:hola desde test' \
  't:hola desde test' \
  'demo:hola desde demo' \
  'help:BASIC USE'; do
  cmd="${pair%%:*}"
  needle="${pair#*:}"
  out="$TEST_ROOT/out-$cmd.txt"
  status=0
  run_cli "$cmd" > "$out" 2>&1 || status=$?
  if [[ $cmd == "clean" || $cmd == "c" ]]; then
    fail "clean should not appear in zero-exit batch"
  fi
  ((status == 0)) || fail "command $cmd exited $status"
  require_output "$out" "$needle"
done

# clean: non-zero on direct CLI, no config mutation.
clean_status=0
run_cli clean > "$TEST_ROOT/clean.out" 2>&1 || clean_status=$?
((clean_status != 0)) || fail "clean stub exited 0"
require_output "$TEST_ROOT/clean.out" "hola desde clean"
run_cli c > "$TEST_ROOT/clean-alias.out" 2>&1 || true
require_output "$TEST_ROOT/clean-alias.out" "hola desde clean"

# Per-module --help (construction stubs describe ravn-cli; no domain work)
for cmd in config verify setup test clean demo help; do
  run_cli "$cmd" --help > "$TEST_ROOT/help-$cmd.out" 2>&1
  require_output "$TEST_ROOT/help-$cmd.out" "ravn-cli"
done

# Direct module executable for verify
run_with_test_env "$ROOT_DIR/runtime/scripts/verify" > "$TEST_ROOT/verify-module.out" 2>&1
require_output "$TEST_ROOT/verify-module.out" "hola desde verify"

# Menu: numbered verify (1), clean failure (4), then quit — menu must survive clean.
# Order: verify, setup, test, clean, demo, help(h), q
printf '4\n\nq\n' | run_cli > "$TEST_ROOT/menu-recover.out" 2>&1 || true
require_output "$TEST_ROOT/menu-recover.out" "hola desde clean"
require_output "$TEST_ROOT/menu-recover.out" "Goodbye"
require_output "$TEST_ROOT/menu-recover.out" "Choose an action"

# No managed git config from stubs
if [[ -e $HOME_DIR/.config/git/config ]]; then
  fail "stubs wrote managed git config"
fi

# config is not a numbered menu row (menu=0)
printf 'q\n' | run_cli > "$TEST_ROOT/menu-labels.out" 2>&1 || true
require_output "$TEST_ROOT/menu-labels.out" "Verify current configuration"
require_output "$TEST_ROOT/menu-labels.out" "Run full setup"
if grep -E '^[ ]+[0-9]+  .*Config$' "$TEST_ROOT/menu-labels.out"; then
  fail "config appeared as a numbered menu row"
fi

printf 'OK: tests/ravn-cli/t2-catalog-stubs.sh\n'
