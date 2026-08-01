#!/usr/bin/env bash
# Phase 1 / T5: product Make surface is prefixed and monorepo targets remain.

set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

fail() {
  printf 'FAIL: %s\n' "$1" >&2
  exit 1
}

require_output() {
  grep -Fq "$2" "$1" || fail "missing output in $1: $2"
}

cd "$ROOT_DIR"

make -n ravn-cli-help > /tmp/ravn-cli-make-help.out 2>&1
require_output /tmp/ravn-cli-make-help.out './ravn-cli help'

make help-ravn-cli-docker > /tmp/ravn-cli-help-docker.out 2>&1
require_output /tmp/ravn-cli-help-docker.out 'ravn-cli-docker-build'
require_output /tmp/ravn-cli-help-docker.out 'ravn-cli-docker-run'

# Monorepo docker surface still documents unprefixed targets.
make help-docker > /tmp/mono-help-docker.out 2>&1
require_output /tmp/mono-help-docker.out 'docker-build'
require_output /tmp/mono-help-docker.out 'docker-run'

# Product targets must not redefine bare docker-run as the product recipe only.
if grep -n '^docker-run:' make/ravn-cli/docker.mk; then
  fail "product docker.mk defines unprefixed docker-run"
fi

# Dockerfiles exist on the product surface
[[ -f docker/ravn-cli/Dockerfile ]] || fail "missing docker/ravn-cli/Dockerfile"
[[ -f docker/ravn-cli/ubuntu.Dockerfile ]] || fail "missing ubuntu Dockerfile"
[[ -f docker/ravn-cli/fedora.Dockerfile ]] || fail "missing fedora Dockerfile"

# Optional smoke: non-interactive help inside a built image when docker is available.
if command -v docker > /dev/null 2>&1; then
  docker build --file docker/ravn-cli/Dockerfile --tag ravn-cli:local-test "$ROOT_DIR" > /tmp/ravn-cli-docker-build.out 2>&1 ||
    fail "docker build failed (see /tmp/ravn-cli-docker-build.out)"
  docker run --rm --env RAVN_CLI_DOCKER_TRIAL=1 ravn-cli:local-test help > /tmp/ravn-cli-docker-help.out 2>&1 ||
    fail "docker run help failed"
  require_output /tmp/ravn-cli-docker-help.out 'ravn-cli'
  docker image rm ravn-cli:local-test > /dev/null 2>&1 || true
else
  printf 'SKIP: docker not installed; Dockerfile presence only\n'
fi

printf 'OK: tests/ravn-cli/t5-make-docker-surface.sh\n'
