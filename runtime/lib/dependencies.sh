#!/usr/bin/env bash

# Operational dependency checks. Phase 1 keeps the structure for future package
# probes but does not require the Git/GitHub/GPG stack to open the menu or help.
if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
  module_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  # shellcheck disable=SC1091
  source "$module_dir/presentation.sh"
fi

# Future phase: populate with product-required host commands.
readonly -a RAVN_CLI_REQUIRED_COMMANDS=()
readonly -a RAVN_CLI_PACKAGE_MANAGERS=(pacman apt dnf)
declare -Ar RAVN_CLI_PACKAGE_MANAGER_LABEL=([pacman]="Arch Linux" [apt]="Ubuntu/Debian" [dnf]="Fedora")
declare -Ar RAVN_CLI_PACKAGE_MANAGER_COMMAND=([pacman]="sudo pacman -S --needed <packages>" [apt]="sudo apt install <packages>" [dnf]="sudo dnf install <packages>")

command_exists() {
  command -v "$1" > /dev/null 2>&1
}

verify_dependencies() {
  print_section "${ICON_PACKAGE} Checking Dependencies"

  if ((${#RAVN_CLI_REQUIRED_COMMANDS[@]} == 0)); then
    print_success "No operational package checks required (phase 1)"
    print_info "Dependency probes stay available for future command modules."
    return 0
  fi

  local -a missing_commands=()
  local required_command=""

  for required_command in "${RAVN_CLI_REQUIRED_COMMANDS[@]}"; do
    if command_exists "$required_command"; then
      print_success "$required_command installed"
    else
      print_error "$required_command not found"
      missing_commands+=("$required_command")
    fi
  done

  if ((${#missing_commands[@]} == 0)); then
    return 0
  fi

  echo ""
  print_info "Missing commands: ${missing_commands[*]}"
  print_info "ravn-cli did not install packages or change your configuration."
  print_dependency_guidance
  return 1
}

print_dependency_guidance() {
  local detected_manager=""
  local manager=""
  local label=""
  local -a ordered_managers=()

  for manager in "${RAVN_CLI_PACKAGE_MANAGERS[@]}"; do
    if command_exists "$manager"; then
      detected_manager="$manager"
      ordered_managers+=("$manager")
      break
    fi
  done

  echo ""
  if [[ -n $detected_manager ]]; then
    print_info "Install the required packages with the detected package manager:"
  else
    print_warn "No supported package manager detected (pacman, apt, or dnf)."
    print_info "Install packages that provide: ${RAVN_CLI_REQUIRED_COMMANDS[*]}."
    print_info "Equivalent commands for supported Linux families:"
  fi

  for manager in "${RAVN_CLI_PACKAGE_MANAGERS[@]}"; do
    [[ $manager == "$detected_manager" ]] || ordered_managers+=("$manager")
  done

  for manager in "${ordered_managers[@]}"; do
    label="${RAVN_CLI_PACKAGE_MANAGER_LABEL[$manager]}"
    if [[ $manager == "$detected_manager" ]]; then
      label="$label (detected)"
    fi

    echo -e "  ${WHITE}$label:${NC}"
    echo -e "    ${GRAY}${RAVN_CLI_PACKAGE_MANAGER_COMMAND[$manager]}${NC}"
  done

  echo ""
  print_info "After installing the missing packages, run ravn-cli again."
}
