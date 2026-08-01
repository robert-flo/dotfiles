#!/usr/bin/env bash

if [[ ${_RAVN_CLI_BASH_COMPLETION_LOADED:-0} == 1 ]]; then
  return 0
fi
readonly _RAVN_CLI_BASH_COMPLETION_LOADED=1

RAVN_CLI_COMPLETION_DIR=""
RAVN_CLI_COMPLETION_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly RAVN_CLI_COMPLETION_DIR
# shellcheck disable=SC1091
source "$RAVN_CLI_COMPLETION_DIR/../lib/command_catalog.sh"

_ravn_cli_completion() {
  local current="${COMP_WORDS[COMP_CWORD]}"
  local previous="${COMP_WORDS[COMP_CWORD - 1]:-}"
  local commands=""
  local options=""

  if ((COMP_CWORD == 1)); then
    commands=$(command_catalog_completion_words)
    # shellcheck disable=SC2207 # Bash completion requires word splitting here.
    COMPREPLY=($( compgen -W "$commands" -- "$current"))
    return 0
  fi

  if command_catalog_get "$previous" options; then
    options="$RAVN_CLI_COMMAND_CATALOG_VALUE"
    # shellcheck disable=SC2207 # Bash completion requires word splitting here.
    COMPREPLY=($( compgen -W "$options" -- "$current"))
  fi
}

complete -F _ravn_cli_completion ravn-cli
