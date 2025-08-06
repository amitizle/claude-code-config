#!/bin/bash

# ~/.claude/scripts/smart_notify.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGO_PATH="$SCRIPT_DIR/claude.png"

MESSAGE=$(jq -r '.message // "No message"')

REQUIRED_TOOLS=("jq" "terminal-notifier")

for tool in "${REQUIRED_TOOLS[@]}"; do
  if ! command -v "$tool" &> /dev/null; then
    echo "Error: $tool is not installed." >&2
    case $tool in
      "jq")
        echo "Install with: brew install jq" >&2
        ;;
      "terminal-notifier")
        echo "Install with: brew install terminal-notifier" >&2
        ;;
    esac
    exit 1
  fi
done

notify() {
  local message="$1"
  local title="${2:-🤖 Claude Code}"
  local sound="${3:-Glass}"
  local timeout="${4:-10}"

  terminal-notifier \
    -title "$title" \
    -message "$message" \
    -sound "$sound" \
    -contentImage "$LOGO_PATH" \
    -timeout "$timeout" \
    -activate com.apple.Terminal
}

if [[ "$MESSAGE" == *"permission"* ]]; then
  notify "Permission needed: $MESSAGE" "🚨 Claude Code" "Sosumi"
elif [[ "$MESSAGE" == *"waiting for your input"* ]]; then
  notify "Waiting for your input: $MESSAGE" "💭 Claude Code" "Glass"
else
  notify "$MESSAGE" "🤖 Claude Code" "Ping"
fi
