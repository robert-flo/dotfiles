#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
readonly SELF_TEST="tests/fresh-template-acceptance.sh"
TEMP_DIR=""
TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR
readonly FIXTURE_DIR="$TEMP_DIR/template-copy"
readonly RELEASE_WORKFLOW="$FIXTURE_DIR/.github/workflows/release-please.yml"
readonly RELEASE_CONFIG="$FIXTURE_DIR/release-please-config.json"
readonly RELEASE_MANIFEST="$FIXTURE_DIR/.release-please-manifest.json"
readonly VERSION_FILE="$FIXTURE_DIR/version.txt"
readonly GIT_MAKEFILE="$FIXTURE_DIR/make/git.mk"

cleanup() {
  rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

assert_contains() {
  local expected=$1
  local file=$2

  if ! grep --fixed-strings --quiet -- "$expected" "$file"; then
    printf 'Expected %s to contain: %s\n' "$file" "$expected" >&2
    exit 1
  fi
}

assert_clean() {
  local description=$1
  local status=""

  status=$(git -C "$FIXTURE_DIR" status --porcelain)
  if [[ -n $status ]]; then
    printf 'Fresh template fixture is dirty after %s.\n' "$description" >&2
    git -C "$FIXTURE_DIR" diff --exit-code >&2 || true
    exit 1
  fi
}

materialize_fixture() {
  git -C "$REPO_ROOT" archive --format=tar HEAD | tar -xf - -C "$FIXTURE_DIR"
  git -C "$FIXTURE_DIR" init --initial-branch=master --quiet
  git -C "$FIXTURE_DIR" config user.email 'template@example.invalid'
  git -C "$FIXTURE_DIR" config user.name 'Template Acceptance'
  git -C "$FIXTURE_DIR" add --all
  git -C "$FIXTURE_DIR" commit --quiet --message 'Initial template commit'
}

verify_fresh_history() {
  local commit_count=""

  commit_count=$(git -C "$FIXTURE_DIR" rev-list --count HEAD)
  if [[ $commit_count != "1" ]]; then
    printf 'Fresh template fixture must start with exactly one commit.\n' >&2
    exit 1
  fi
}

verify_release_contract() {
  local version=""

  version=$(< "$VERSION_FILE")
  if [[ ! $version =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    printf 'Fresh template fixture must contain an X.Y.Z version.\n' >&2
    exit 1
  fi

  assert_contains '"release-type": "simple"' "$RELEASE_CONFIG"
  assert_contains '"initial-version": "0.1.0"' "$RELEASE_CONFIG"
  assert_contains '"include-v-in-tag": true' "$RELEASE_CONFIG"
  assert_contains '"label": "autorelease: pending"' "$RELEASE_CONFIG"
  assert_contains '"release-label": "autorelease: tagged"' "$RELEASE_CONFIG"
  assert_contains 'contents: write' "$RELEASE_WORKFLOW"
  assert_contains 'issues: write' "$RELEASE_WORKFLOW"
  assert_contains 'pull-requests: write' "$RELEASE_WORKFLOW"
  assert_contains '".": "0.1.0"' "$RELEASE_MANIFEST"
}

verify_bootstrap_contract() {
  local bootstrap_output=""

  bootstrap_output=$(make -C "$FIXTURE_DIR" repository-bootstrap DRY_RUN=1)
  if [[ $bootstrap_output != *'remote repository setup skipped'* ]]; then
    printf 'Local bootstrap must skip remote configuration by default.\n' >&2
    exit 1
  fi
  assert_clean 'dry-run local bootstrap'

  assert_contains '"required_status_checks":{"strict":true,"contexts":["Run Pre-Commit Hooks","Validate changed shell scripts"]}' "$GIT_MAKEFILE"
  assert_contains '"enforce_admins":true' "$GIT_MAKEFILE"
  assert_contains '"required_conversation_resolution":true' "$GIT_MAKEFILE"
  assert_contains '"allow_force_pushes":false' "$GIT_MAKEFILE"
  assert_contains '"allow_deletions":false' "$GIT_MAKEFILE"
}

verify_public_template_contract() {
  bash "$FIXTURE_DIR/tests/public-template-docs.sh"
  assert_clean 'public template validation'
}

run_aggregate_verification() {
  make -C "$FIXTURE_DIR" verify TEST_EXCLUDE="$SELF_TEST"
  assert_clean 'aggregate verification'
  pushd "$FIXTURE_DIR" > /dev/null
  pre-commit run --all-files
  popd > /dev/null
  assert_clean 'pre-commit all-files audit'
}

main() {
  mkdir -- "$FIXTURE_DIR"
  materialize_fixture
  verify_fresh_history
  assert_clean 'initialization'
  verify_release_contract
  assert_clean 'release configuration validation'
  verify_bootstrap_contract
  verify_public_template_contract
  run_aggregate_verification
  printf 'Fresh template acceptance tests passed.\n'
}

main "$@"
