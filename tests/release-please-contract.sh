#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly RELEASE_CONFIG="$REPO_ROOT/release-please-config.json"
readonly RELEASE_MANIFEST="$REPO_ROOT/.release-please-manifest.json"
readonly RELEASE_WORKFLOW="$REPO_ROOT/.github/workflows/release-please.yml"
readonly VERSION_FILE="$REPO_ROOT/version.txt"
readonly GIT_MAKEFILE="$REPO_ROOT/make/git.mk"
readonly MARKDOWNLINT_CONFIG="$REPO_ROOT/.markdownlint.yaml"
readonly CHANGELOG_FILE="$REPO_ROOT/CHANGELOG.md"

assert_file_exists() {
  local file=$1

  if [[ ! -f $file ]]; then
    printf 'Expected file to exist: %s\n' "$file" >&2
    exit 1
  fi
}

assert_file_missing() {
  local file=$1

  if [[ -e $file ]]; then
    printf 'Expected legacy file to be removed: %s\n' "$file" >&2
    exit 1
  fi
}

assert_contains() {
  local expected=$1
  local file=$2

  if ! grep --fixed-strings --quiet -- "$expected" "$file"; then
    printf 'Expected %s to contain: %s\n' "$file" "$expected" >&2
    exit 1
  fi
}

main() {
  local changelog_first_line=""
  local help_output=""
  local version=""
  local dollar='$'

  assert_file_exists "$RELEASE_CONFIG"
  assert_file_exists "$RELEASE_MANIFEST"
  assert_file_exists "$RELEASE_WORKFLOW"
  assert_file_exists "$VERSION_FILE"
  assert_file_exists "$MARKDOWNLINT_CONFIG"
  assert_file_exists "$CHANGELOG_FILE"

  version=$(< "$VERSION_FILE")
  if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf 'version.txt must contain an X.Y.Z version.\n' >&2
    exit 1
  fi

  jq --exit-status --arg version "$version" '.["."] == $version' "$RELEASE_MANIFEST" > /dev/null
  jq --exit-status '
    .["release-type"] == "simple" and
    .["include-v-in-tag"] == true and
    .packages["."]["release-type"] == "simple" and
    .packages["."]["initial-version"] == "0.1.0" and
    .packages["."]["version-file"] == "version.txt" and
    .packages["."]["changelog-path"] == "CHANGELOG.md" and
    .packages["."]["include-v-in-tag"] == true
  ' "$RELEASE_CONFIG" > /dev/null

  assert_contains 'googleapis/release-please-action@v4' "$RELEASE_WORKFLOW"
  assert_contains 'RELEASE_PLEASE_TOKEN' "$RELEASE_WORKFLOW"
  assert_contains 'autorelease: pending' "$RELEASE_CONFIG"
  assert_contains 'autorelease: tagged' "$RELEASE_CONFIG"
  assert_contains 'MD012: false' "$MARKDOWNLINT_CONFIG"
  assert_contains 'RELEASE_PLEASE_TOKEN' "$REPO_ROOT/make/release.mk"
  assert_contains 'gh secret list' "$REPO_ROOT/make/release.mk"
  assert_contains 'git-configure-release-labels' "$GIT_MAKEFILE"
  assert_contains '"required_conversation_resolution":true' "$GIT_MAKEFILE"
  assert_contains "\"required_approving_review_count\":${dollar}(GIT_PROTECTION_REQUIRED_APPROVALS)" "$GIT_MAKEFILE"

  if grep --fixed-strings --quiet 'Validate committed changelog' "$GIT_MAKEFILE"; then
    printf 'Branch protection must not require the retired changelog check.\n' >&2
    exit 1
  fi

  changelog_first_line=$(head -n 1 "$CHANGELOG_FILE")
  if [[ $changelog_first_line != '<!-- Release Please maintains this file. -->' ]]; then
    printf 'CHANGELOG.md must not seed a heading that Release Please duplicates.\n' >&2
    exit 1
  fi

  assert_file_missing "$REPO_ROOT/.github/workflows/update-pr-changelog.yml"
  assert_file_missing "$REPO_ROOT/.github/scripts/update-pr-changelog.sh"
  assert_file_missing "$REPO_ROOT/.github/scripts/validate-pr-changelog.sh"
  assert_file_missing "$REPO_ROOT/tests/changelog-automation.sh"

  help_output=$(make -C "$REPO_ROOT" help)
  if [[ $help_output != *'make release-check'* ]] || [[ $help_output != *'make release-status'* ]]; then
    printf 'Make help must advertise the release diagnostics.\n' >&2
    exit 1
  fi

  make -C "$REPO_ROOT" release-check

  if rg --fixed-strings --quiet 'changelog-update' "$REPO_ROOT/Makefile" "$REPO_ROOT/make"; then
    printf 'The Make interface must not retain the manual changelog generator.\n' >&2
    exit 1
  fi

  printf 'Release Please contract tests passed.\n'
}

main "$@"
