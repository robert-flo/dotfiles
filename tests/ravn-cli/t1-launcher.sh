#!/usr/bin/env bash
# Phase 1 / T1: process-seam smoke for ravn-cli launcher and help module.

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RAVN_CLI="$ROOT_DIR/ravn-cli"
HELP_MODULE="$ROOT_DIR/runtime/scripts/help"
DEMO_MODULE="$ROOT_DIR/runtime/scripts/demo"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/ravn-cli-t1.XXXXXX")"

trap 'rm -rf "$TEST_ROOT"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [[ -f $1 ]] || fail "missing file: $1"
}

require_exec() {
  [[ -x $1 ]] || fail "not executable: $1"
}

require_output() {
  grep -Fq "$2" "$1" || fail "missing output in $1: $2"
}

require_file "$RAVN_CLI"
require_exec "$RAVN_CLI"
require_file "$HELP_MODULE"
require_exec "$HELP_MODULE"
require_file "$DEMO_MODULE"
require_exec "$DEMO_MODULE"

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

run_module() {
  run_with_test_env "$HELP_MODULE" "$@"
}

# Help via launcher does not require git/gh/gpg/delta.
run_cli help > "$TEST_ROOT/help-launcher.out" 2>&1
require_output "$TEST_ROOT/help-launcher.out" "ravn-cli"
require_output "$TEST_ROOT/help-launcher.out" "BASIC USE"

# Help aliases
run_cli --help > "$TEST_ROOT/help-long.out" 2>&1
require_output "$TEST_ROOT/help-long.out" "ravn-cli"
run_cli -h > "$TEST_ROOT/help-short.out" 2>&1
require_output "$TEST_ROOT/help-short.out" "ravn-cli"

# Direct command module path matches launcher for help.
run_module --help > "$TEST_ROOT/help-module.out" 2>&1
require_output "$TEST_ROOT/help-module.out" "ravn-cli"

# Unknown command fails clearly and does not open the interactive menu.
unknown_status=0
run_cli not-a-real-command > "$TEST_ROOT/unknown.out" 2>&1 || unknown_status=$?
((unknown_status != 0)) || fail "unknown command exited 0"
require_output "$TEST_ROOT/unknown.out" "Unknown command"
if grep -Fq "Selection:" "$TEST_ROOT/unknown.out"; then
  fail "unknown command entered the interactive menu"
fi

# Direct construction stub via launcher and module path.
run_cli demo > "$TEST_ROOT/demo-launcher.out" 2>&1
require_output "$TEST_ROOT/demo-launcher.out" "hola desde demo"
run_with_test_env "$DEMO_MODULE" > "$TEST_ROOT/demo-module.out" 2>&1
require_output "$TEST_ROOT/demo-module.out" "hola desde demo"

# Interactive menu: design language, numbered demo, h help, q exit.
printf '1\n\nh\n\nq\n' | run_cli > "$TEST_ROOT/menu.out" 2>&1 || true
require_output "$TEST_ROOT/menu.out" "Choose an action"
require_output "$TEST_ROOT/menu.out" "Demo construction stub"
require_output "$TEST_ROOT/menu.out" "Help and usage"
require_output "$TEST_ROOT/menu.out" "hola desde demo"
require_output "$TEST_ROOT/menu.out" "Exit"
require_output "$TEST_ROOT/menu.out" "Goodbye"
require_output "$TEST_ROOT/menu.out" "ravn-cli"

# No managed git config written by T1 help/menu paths.
if [[ -e $HOME_DIR/.config/git/config ]]; then
  fail "T1 paths wrote managed git config"
fi

printf 'OK: tests/ravn-cli/t1-launcher.sh\n'
