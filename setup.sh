#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE="claude-code"
TARGET_DIR="${HOME}/.claude"

# Sub-agents URLs to download
SUB_AGENTS_URLS=(
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/ansible-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/auth0-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/bullmq-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/bun-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/celery-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/circleci-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/cypress-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/deno-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/docker-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/elasticsearch-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/express-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/github-actions-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/go-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/grafana-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/graphql-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/grpc-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/html-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/javascript-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/jest-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/jwt-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/python-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/rabbitmq-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/redis-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/nodejs-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/knex-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/kubernetes-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/lua-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/mariadb-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/mongodb-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/mqtt-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/mysql-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/oauth-oidc-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/openai-api-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/owasp-top10-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/postgres-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/prisma-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/prometheus-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/python-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/rabbitmq-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/redis-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/rollup-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/ruby-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/sns-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/sidekiq-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/sql-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/sqlite-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/sqs-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/stripe-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/terraform-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/typescript-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/webpack-expert.md"
  "https://raw.githubusercontent.com/0xfurai/claude-code-subagents/refs/heads/main/agents/websocket-expert.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/architect-review.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/backend-architect.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/business-analyst.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/cloud-architect.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/code-reviewer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/content-marketer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/customer-support.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/data-engineer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/database-admin.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/database-optimizer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/debugger.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/devops-troubleshooter.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/deployment-engineer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/incident-responder.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/legacy-modernizer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/network-engineer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/payment-integration.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/performance-engineer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/prompt-engineer.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/risk-manager.md"
  "https://raw.githubusercontent.com/wshobson/agents/refs/heads/main/security-auditor.md"
  "https://raw.githubusercontent.com/VoltAgent/awesome-claude-code-subagents/refs/heads/main/categories/08-business-product/legal-advisor.md"
  "https://raw.githubusercontent.com/VoltAgent/awesome-claude-code-subagents/refs/heads/main/categories/08-business-product/customer-success-manager.md"
  "https://raw.githubusercontent.com/VoltAgent/awesome-claude-code-subagents/refs/heads/main/categories/06-developer-experience/build-engineer.md"
  "https://raw.githubusercontent.com/VoltAgent/awesome-claude-code-subagents/refs/heads/main/categories/06-developer-experience/mcp-developer.md"
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
  local source_dir="${SCRIPT_DIR}/${PACKAGE}"

  if [[ ! -d "${source_dir}" ]]; then
    log_error "Source directory '${source_dir}' does not exist"
    return 1
  fi

  # Check if target directory exists
  if [[ ! -d "${TARGET_DIR}" ]]; then
    log_info "Creating target directory: ${TARGET_DIR}"
    mkdir -p "${TARGET_DIR}"
  fi

  log_info "Stowing ${PACKAGE} from '${source_dir}' to '${TARGET_DIR}'..."

  # Check for existing files that would conflict
  local conflicts=()
  if [[ -f "${TARGET_DIR}/CLAUDE.md" ]] && [[ ! -L "${TARGET_DIR}/CLAUDE.md" ]]; then
    conflicts+=("CLAUDE.md")
  fi
  if [[ -f "${TARGET_DIR}/settings.json" ]] && [[ ! -L "${TARGET_DIR}/settings.json" ]]; then
    conflicts+=("settings.json")
  fi

  if [[ ${#conflicts[@]} -gt 0 ]]; then
    log_warn "Found conflicting files: ${conflicts[*]}"
    log_warn "These will be backed up and replaced with symlinks"

    # Backup existing files
    for file in "${conflicts[@]}"; do
      log_info "Backing up ${TARGET_DIR}/${file} to ${TARGET_DIR}/${file}.backup"
      cp "${TARGET_DIR}/${file}" "${TARGET_DIR}/${file}.backup"
    done

    # Use stow with --adopt to resolve conflicts
    log_info "Using --adopt flag to resolve conflicts..."
    if stow --dir="${SCRIPT_DIR}" --target="${TARGET_DIR}" --adopt "${PACKAGE}"; then
      log_info "Successfully stowed ${PACKAGE} to ${TARGET_DIR}"

      if [[ ${#conflicts[@]} -gt 0 ]]; then
        log_info "Backed up original files:"
        for file in "${conflicts[@]}"; do
          echo "  - ${TARGET_DIR}/${file}.backup"
        done
      fi
    else
      log_error "Failed to stow ${PACKAGE} with --adopt"
      return 1
    fi
  else
    # No conflicts, use regular stow
    if stow --dir="${SCRIPT_DIR}" --target="${TARGET_DIR}" "${PACKAGE}"; then
      log_info "Successfully stowed ${PACKAGE} to ${TARGET_DIR}"
    else
      log_error "Failed to stow ${PACKAGE}"
      return 1
    fi
  fi
}

unstow_package() {
  log_info "Unstowing ${PACKAGE} from '${TARGET_DIR}'..."

  if stow --dir="${SCRIPT_DIR}" --target="${TARGET_DIR}" --delete "${PACKAGE}"; then
    log_info "Successfully unstowed ${PACKAGE}"
  else
    log_error "Failed to unstow ${PACKAGE}"
    return 1
  fi
}

show_usage() {
  echo "Usage: ${0} [COMMAND]"
  echo ""
  echo "Commands:"
  echo "  stow              - Stow claude-code to ~/.claude (auto-handles conflicts)"
  echo "  unstow            - Unstow claude-code from ~/.claude"
  echo "  setup-sub-agents  - Download sub-agent files from configured URLs"
  echo "  info              - Show package information"
  echo "  help              - Show this help message"
  echo "  all               - Stow claude-code and setup sub-agents"
  echo ""
  echo "Examples:"
  echo "  ${0} stow              - Stow claude-code directory to ~/.claude"
  echo "  ${0} unstow            - Remove claude-code symlinks from ~/.claude"
  echo "  ${0} setup-sub-agents  - Download all configured sub-agent files"
  echo "  ${0} all               - Complete setup (stow + sub-agents)"
  echo ""
  echo "Note: The 'stow' command will automatically handle conflicts by backing up"
  echo "      existing files with a .backup suffix and replacing them with symlinks."
}

show_info() {
  local source_dir="${SCRIPT_DIR}/${PACKAGE}"
  local exists=""
  if [[ ! -d "${source_dir}" ]]; then
    exists=" (source missing)"
  fi
  log_info "Package: ${PACKAGE} -> ${TARGET_DIR}${exists}"
}

setup_sub_agents() {
  local sub_agents_dir="${TARGET_DIR}/agents"

  if [[ ${#SUB_AGENTS_URLS[@]} -eq 0 ]]; then
    log_warn "No sub-agent URLs configured. Please add URLs to the SUB_AGENTS_URLS array."
    return 0
  fi

  # Create sub-agents directory if it doesn't exist
  if [[ ! -d "${sub_agents_dir}" ]]; then
    log_info "Creating sub-agents directory: ${sub_agents_dir}"
    mkdir -p "${sub_agents_dir}"
  fi

  log_info "Setting up sub-agents in ${sub_agents_dir}..."

  # Download URLs one by one
  pushd "${sub_agents_dir}"
  for url in "${SUB_AGENTS_URLS[@]}"; do
    if [[ -n "${url}" && ! "${url}" =~ ^[[:space:]]*# ]]; then
      log_info "Downloading: ${url}"
      if curl -sLO "${url}"; then
        log_info "Successfully downloaded: $(basename "${url}")"
      else
        log_error "Failed to download: ${url}"
      fi
    fi
  done

  popd
  # Copy sub agents from agents/*.md to target directory
  echo "Copying sub agents from agents/*.md to $sub_agents_dir..."
  cp agents/*.md "$sub_agents_dir/"
  log_info "Sub-agents setup completed"
}

main() {
  check_stow

  local command="${1:-info}"

  case "${command}" in
  "stow")
    stow_package
    ;;
  "unstow")
    unstow_package
    ;;
  "setup-sub-agents")
    setup_sub_agents
    ;;
  "info")
    show_info
    ;;
  "help" | "--help" | "-h")
    show_usage
    ;;
  "all")
    stow_package
    setup_sub_agents
    ;;
  *)
    log_error "Unknown command: ${command}"
    show_usage
    exit 1
    ;;
  esac
}

main "$@"
