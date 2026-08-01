#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT=""
REPO_ROOT=$(git rev-parse --show-toplevel)
readonly REPO_ROOT
TEMP_DIR=""
TEMP_DIR=$(mktemp -d)
readonly TEMP_DIR
readonly FAKE_GH="$TEMP_DIR/gh"
readonly COMPLIANT_PROTECTION='{"required_status_checks":{"strict":true,"contexts":["Run Pre-Commit Hooks","Validate changed shell scripts"]},"enforce_admins":{"enabled":true},"required_pull_request_reviews":{"dismiss_stale_reviews":false,"require_code_owner_reviews":false,"required_approving_review_count":0,"require_last_push_approval":false},"restrictions":null,"required_linear_history":{"enabled":false},"allow_force_pushes":{"enabled":false},"allow_deletions":{"enabled":false},"block_creations":{"enabled":false},"required_conversation_resolution":{"enabled":true},"lock_branch":{"enabled":false},"allow_fork_syncing":{"enabled":false}}'
readonly MISMATCHED_PROTECTION='{"required_status_checks":{"strict":false,"contexts":[]},"enforce_admins":{"enabled":false},"required_pull_request_reviews":null,"required_conversation_resolution":{"enabled":false},"allow_force_pushes":{"enabled":true},"allow_deletions":{"enabled":true}}'

cleanup() {
  rm -rf "$TEMP_DIR"
}

trap cleanup EXIT

assert_contains() {
  local output=$1
  local expected=$2

  if [[ $output != *"$expected"* ]]; then
    printf 'Expected output to contain: %s\n' "$expected" >&2
    exit 1
  fi
}

create_fake_gh() {
  # shellcheck disable=SC2016 # The mock must preserve literal shell variables.
  printf '%s\n' '#!/usr/bin/env bash' 'set -euo pipefail' 'if [[ $1 == "auth" && $2 == "status" ]]; then exit 0; fi' 'if [[ $1 == "repo" && $2 == "view" ]]; then case "$*" in *nameWithOwner*) printf "%s\\n" "example/template" ;; *defaultBranchRef*) printf "%s\\n" "master" ;; esac; exit 0; fi' 'if [[ $1 == "api" ]]; then if [[ ${PROTECTION_FIXTURE:-} == "denied" ]]; then printf "%s\\n" "HTTP 403: Resource not accessible" >&2; exit 1; fi; printf "%s\\n" "$PROTECTION_FIXTURE"; exit 0; fi' 'printf "%s\\n" "unexpected gh invocation: $*" >&2' 'exit 1' > "$FAKE_GH"
  chmod +x "$FAKE_GH"
}

run_target() {
  local fixture=$1
  local expected_status=$2
  local expected_output=$3
  local output=""
  local status=0

  output=$(PROTECTION_FIXTURE="$fixture" make -C "$REPO_ROOT" --no-print-directory repository-protection-status GH="$FAKE_GH" 2>&1) || status=$?
  if ((expected_status == 0 && status != 0)) || ((expected_status != 0 && status == 0)); then
    printf 'Expected success state %s, got exit status %s.\n%s\n' "$expected_status" "$status" "$output" >&2
    exit 1
  fi
  assert_contains "$output" "$expected_output"
}

main() {
  local subtle_mismatch=""

  create_fake_gh

  run_target "$COMPLIANT_PROTECTION" 0 '✓ branch protection matches the template policy'
  run_target "$MISMATCHED_PROTECTION" 1 '✗ branch protection differs from the template policy'
  subtle_mismatch=$(printf '%s' "$COMPLIANT_PROTECTION" | jq '.required_linear_history.enabled = true')
  run_target "$subtle_mismatch" 1 '✗ branch protection differs from the template policy'
  run_target denied 1 'unable to read branch protection; repository administration access may be required'

  printf 'Repository protection status tests passed.\n'
}

main "$@"
