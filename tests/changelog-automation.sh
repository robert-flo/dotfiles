#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly UPDATE_SCRIPT="$REPO_ROOT/.github/scripts/update-pr-changelog.sh"
readonly VALIDATE_SCRIPT="$REPO_ROOT/.github/scripts/validate-pr-changelog.sh"

temp_dir=$(mktemp -d)
trap 'rm -rf "$temp_dir"' EXIT

assert_contains() {
  local expected=$1
  local file=$2

  if ! grep --fixed-strings --quiet -- "$expected" "$file"; then
    printf 'Expected %s to contain: %s\n' "$file" "$expected" >&2
    exit 1
  fi
}

run_update() {
  local changelog_file=$1
  local labels=$2

  CHANGELOG_FILE="$changelog_file" \
    PR_NUMBER=42 \
    PR_URL='https://github.com/robert-flo/dotfiles/pull/42' \
    PR_TITLE='Add changelog automation' \
    PR_LABELS="$labels" \
    "$UPDATE_SCRIPT"
}

main() {
  local changelog_file='source/CHANGELOG.md'
  local skip_file='source/SKIP.md'
  local before_second_run=""
  local after_second_run=""

  mkdir "$temp_dir/source"
  cp "$REPO_ROOT/CHANGELOG.md" "$temp_dir/$changelog_file"
  cp "$REPO_ROOT/CHANGELOG.md" "$temp_dir/$skip_file"

  pushd "$temp_dir" > /dev/null
  run_update "$changelog_file" 'changelog:added'

  assert_contains '### Added' "$changelog_file"
  assert_contains '- Add changelog automation ([#42](https://github.com/robert-flo/dotfiles/pull/42)). <!-- changelog-pr:42 -->' "$changelog_file"

  before_second_run=$(sha256sum "$changelog_file")
  run_update "$changelog_file" 'changelog:added'
  after_second_run=$(sha256sum "$changelog_file")

  if [[ $before_second_run != "$after_second_run" ]]; then
    printf 'Changelog generation is not idempotent.\n' >&2
    exit 1
  fi

  CHANGELOG_FILE="$changelog_file" \
    PR_NUMBER=42 \
    PR_URL='https://github.com/robert-flo/dotfiles/pull/42' \
    PR_TITLE='Add changelog automation' \
    PR_LABELS='changelog:added' \
    "$VALIDATE_SCRIPT"

  run_update "$skip_file" 'changelog:skip'
  if ! cmp -s "$REPO_ROOT/CHANGELOG.md" "$skip_file"; then
    printf 'changelog:skip must leave the changelog unchanged.\n' >&2
    exit 1
  fi

  if CHANGELOG_FILE="$skip_file" \
    PR_NUMBER=42 \
    PR_URL='https://github.com/robert-flo/dotfiles/pull/42' \
    PR_TITLE='Add changelog automation' \
    PR_LABELS='' \
    "$UPDATE_SCRIPT"; then
    printf 'Generation without a changelog label must fail.\n' >&2
    exit 1
  fi

  if CHANGELOG_FILE="$skip_file" \
    PR_NUMBER=42 \
    PR_URL='https://github.com/robert-flo/dotfiles/pull/42' \
    PR_TITLE='Add changelog automation' \
    PR_LABELS=$'changelog:skip\nchangelog:added' \
    "$UPDATE_SCRIPT"; then
    printf 'changelog:skip cannot be combined with a category label.\n' >&2
    exit 1
  fi

  if CHANGELOG_FILE="$skip_file" \
    PR_NUMBER=42 \
    PR_URL='https://github.com/robert-flo/dotfiles/pull/42' \
    PR_TITLE='Add changelog automation' \
    PR_LABELS='changelog:added' \
    "$VALIDATE_SCRIPT"; then
    printf 'Validation must fail when the generated entry is absent.\n' >&2
    exit 1
  fi

  popd > /dev/null

  printf 'Changelog automation tests passed.\n'
}

main "$@"
