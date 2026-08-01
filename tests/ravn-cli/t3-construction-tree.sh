#!/usr/bin/env bash
# Phase 1 / T3: construction tree present; stubs still side-effect free.

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
RAVN_CLI="$ROOT_DIR/ravn-cli"
TEST_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/ravn-cli-t3.XXXXXX")"

trap 'rm -rf "$TEST_ROOT"' EXIT

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_file() {
  [[ -f $1 ]] || fail "missing file: $1"
}

require_dir() {
  [[ -d $1 ]] || fail "missing directory: $1"
}

require_file "$ROOT_DIR/runtime/lib/configuration.sh"
require_file "$ROOT_DIR/runtime/lib/keys.sh"
require_file "$ROOT_DIR/runtime/completion/ravn-cli.bash"
require_file "$ROOT_DIR/runtime/completion/_ravn-cli"
require_file "$ROOT_DIR/runtime/templates/git/config"
require_dir "$ROOT_DIR/make/ravn-cli/workflow"
require_file "$ROOT_DIR/make/ravn-cli/workflow/s"
require_file "$ROOT_DIR/make/ravn-cli/workflow/.git-workflow"

# Completion sources against the catalog without executing ravn-cli.
bash -c "source '$ROOT_DIR/runtime/completion/ravn-cli.bash'" || fail "bash completion source failed"

# Stubs still do not install workflow companions into HOME bin.
HOME_DIR="$TEST_ROOT/home"
mkdir -p "$HOME_DIR"
env -C "$TEST_ROOT" HOME="$HOME_DIR" XDG_CONFIG_HOME="$HOME_DIR/.config" \
  TERM=dumb NO_COLOR=1 "$RAVN_CLI" config > "$TEST_ROOT/config.out" 2>&1
grep -Fq 'hola desde config' "$TEST_ROOT/config.out" || fail "config stub did not run"
if [[ -e $HOME_DIR/.local/bin/s || -e $HOME_DIR/.config/git/config ]]; then
  fail "construction tree stubs mutated HOME"
fi

# Identity strings in completion/user-facing payload
grep -Fq 'ravn-cli' "$ROOT_DIR/runtime/completion/ravn-cli.bash" || fail "completion missing ravn-cli"
if grep -Fq 'git-setup' "$ROOT_DIR/runtime/completion/ravn-cli.bash"; then
  fail "completion still mentions git-setup"
fi

printf 'OK: tests/ravn-cli/t3-construction-tree.sh\n'
