#!/usr/bin/env bash
# Phase 1 / T4: product test surface aggregates process-seam contracts.

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SUITE_DIR="$ROOT_DIR/tests/ravn-cli"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

[[ -d $SUITE_DIR ]] || fail "missing product test surface: $SUITE_DIR"

# Run every product test except this suite runner.
while IFS= read -r test_file; do
  [[ -n $test_file ]] || continue
  [[ $test_file == "$SUITE_DIR/t4-process-suite.sh" ]] && continue
  bash "$test_file" || fail "product test failed: $test_file"
done < <(find "$SUITE_DIR" -type f -name '*.sh' | LC_ALL=C sort)

printf 'OK: tests/ravn-cli/t4-process-suite.sh\n'
