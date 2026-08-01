#!/usr/bin/env bash

# Shared repository, runtime, template, and generated-configuration paths.
helper_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly RAVN_CLI_RUNTIME_DIR="${RAVN_CLI_RUNTIME_DIR:-$(cd "$helper_dir/.." && pwd)}"
readonly RAVN_CLI_ROOT="${RAVN_CLI_ROOT:-$(cd "$RAVN_CLI_RUNTIME_DIR/.." && pwd)}"
readonly WORKFLOW_SOURCE_DIR="$RAVN_CLI_ROOT/make/ravn-cli/workflow"
TEMPLATE_DIR="${TEMPLATE_DIR:-$RAVN_CLI_RUNTIME_DIR/templates/git}"
GIT_CONFIG_DIR="${GIT_CONFIG_DIR:-$HOME/.config/git}"
GIT_CONFIG_FILE="${GIT_CONFIG_FILE:-$GIT_CONFIG_DIR/config}"
WORKFLOW_COMMAND_DIR="${WORKFLOW_COMMAND_DIR:-$HOME/.local/bin}"
USER_NAME="${USER_NAME:-${NAME:-Roberto Flores}}"
USER_EMAIL="${USER_EMAIL:-${EMAIL:-25asab015@ujmd.edu.sv}}"

export RAVN_CLI_ROOT
export RAVN_CLI_RUNTIME_DIR
export WORKFLOW_SOURCE_DIR
export TEMPLATE_DIR
export GIT_CONFIG_DIR
export GIT_CONFIG_FILE
export WORKFLOW_COMMAND_DIR
export USER_NAME
export USER_EMAIL
