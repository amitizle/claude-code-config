#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

declare -A STOW_MAP=(
  ["claude-code"]="$HOME/.claude"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

check_stow() {
  if ! command -v stow &>/dev/null; then
    log_error "GNU Stow is not installed. Please install it first"
    exit 1
  fi
}

stow_package() {
  local package="$1"
  local source_dir="$SCRIPT_DIR/$package"
  local target_dir="${STOW_MAP[$package]}"

  if [[ -z "$target_dir" ]]; then
    log_error "No target directory configured for package '$package'"
    log_info "Please add '$package' to the STOW_MAP in this script"
    return 1
  fi

  if [[ ! -d "$source_dir" ]]; then
    log_error "Source directory '$source_dir' does not exist"
    return 1
  fi

  log_info "Stowing $package from '$source_dir' to '$target_dir'..."

  # Use stow to create symlinks
  if stow --dir="$SCRIPT_DIR" --target="$target_dir" "$package"; then
    log_info "Successfully stowed $package to $target_dir"
  else
    log_error "Failed to stow $package"
    return 1
  fi
}

unstow_package() {
  local package="$1"
  local target_dir="${STOW_MAP[$package]}"

  if [[ -z "$target_dir" ]]; then
    log_error "No target directory configured for package '$package'"
    log_info "Please add '$package' to the STOW_MAP in this script"
    return 1
  fi

  log_info "Unstowing $package from '$target_dir'..."

  if stow --dir="$SCRIPT_DIR" --target="$target_dir" --delete "$package"; then
    log_info "Successfully unstowed $package"
  else
    log_error "Failed to unstow $package"
    return 1
  fi
}

show_usage() {
  echo "Usage: $0 [COMMAND] [PACKAGE]"
  echo ""
  echo "Commands:"
  echo "  stow [PACKAGE]    - Stow a package"
  echo "  unstow [PACKAGE]  - Unstow a package"
  echo "  list              - List configured packages"
  echo "  help              - Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 stow claude-code   - Stow claude-code directory to \$HOME/.claude"
  echo "  $0 unstow claude-code"
  echo "  $0 list               - Show all configured mappings"
}

list_packages() {
  log_info "Configured packages:"
  for package in "${!STOW_MAP[@]}"; do
    local target="${STOW_MAP[$package]}"
    local source_dir="$SCRIPT_DIR/$package"
    local exists=""
    if [[ ! -d "$source_dir" ]]; then
      exists=" (source missing)"
    fi
    echo "  $package -> $target$exists"
  done
}

main() {
  check_stow

  local command="${1:-list}"
  local package="${2:-}"

  case "$command" in
  "stow")
    if [[ -z "$package" ]]; then
      log_error "Please specify a package to stow"
      show_usage
      exit 1
    fi
    stow_package "$package"
    ;;
  "unstow")
    if [[ -z "$package" ]]; then
      log_error "Please specify a package to unstow"
      show_usage
      exit 1
    fi
    unstow_package "$package"
    ;;
  "list")
    list_packages
    ;;
  "help" | "--help" | "-h")
    show_usage
    ;;
  *)
    log_error "Unknown command: $command"
    show_usage
    exit 1
    ;;
  esac
}

main "$@"
