# Claude Code Config

My personal preference for using Claude Code.
Using `stow` because it's easy to manage and keep track of changes.

Sub-agents are downloaded directly to ~/.claude/agents and are not managed by this repository.

> ⚠️ NOTE: when using `stow`, the `~/.claude` directory will be overwritten with symlinks to the files in this repository.
> If you want to keep your existing `~/.claude` directory, make sure to back it up before running the setup script.
> `mv ~/.claude ~/.claude.bak` is a good way to do this.

## Prerequisites

- **GNU Stow** - Package manager for symlink management
- **curl** - For downloading sub-agent files
- **jq** - JSON processor (for notification handling)
- **terminal-notifier** - macOS notification system (for notification handling)

Install prerequisites on macOS:
```bash
brew install stow jq terminal-notifier
```

## Scripts

### setup.sh

Main setup script for managing Claude Code configuration using GNU Stow.

**Usage:**
```bash
./setup.sh [COMMAND]
```

**Commands:**
- `stow` - Stow claude-code to ~/.claude
- `unstow` - Unstow claude-code from ~/.claude  
- `setup-sub-agents` - Download sub-agent files from configured URLs
- `all` - Stow claude-code and setup sub-agents
- `info` - Show package information
- `help` - Show help message

**Examples:**
```bash
# Setup everything (stow + download sub-agents)
./setup.sh all

# Just stow the claude-code configuration
./setup.sh stow

# Download all sub-agent files
./setup.sh setup-sub-agents

# Remove claude-code symlinks
./setup.sh unstow
```

**Features:**
- Uses GNU Stow to create symlinks from `claude-code/` to `~/.claude/`
- Downloads 80+ expert sub-agents from curated repositories
- Colored logging output (INFO, WARN, ERROR)
- Error handling and validation

### claude-code/scripts/handle_notification.sh

Smart notification handler for Claude Code that provides contextual macOS notifications.

**Usage:**
This script is typically called by Claude Code hooks and expects JSON input via stdin:
```bash
echo '{"message": "Your message here"}' | ./handle_notification.sh
```

**Features:**
- **Smart notification categorization:**
  - Permission requests: Red alert with "Sosumi" sound
  - Input waiting: Thinking icon with "Glass" sound  
  - General messages: Robot icon with "Ping" sound
- **Custom notification display:**
  - Claude logo icon
  - 10-second timeout
  - Activates Terminal app on click
- **Dependency validation:**
  - Checks for `jq` and `terminal-notifier`
  - Provides installation instructions if missing

**Message Types:**
- Messages containing "permission" → 🚨 Permission alert
- Messages containing "waiting for your input" → 💭 Input prompt
- All other messages → 🤖 General notification

## Installation

1. Clone this repository
2. Install prerequisites
3. Run the setup script:

```bash
git clone <repository-url> ai-tools
cd ai-tools
./setup.sh all
```

This will:
- Create symlinks from `claude-code/` to `~/.claude/`
- Download all sub-agent files to `~/.claude/agents/`

## Directory Structure

```
ai-tools/
├── README.md
├── setup.sh                                    # Main setup script
└── claude-code/                               # Claude Code configuration
    ├── scripts/
    │   ├── claude.png                         # Notification icon
    │   └── handle_notification.sh             # Notification handler
    └── [other claude config files...]
```

After setup, your `~/.claude/` directory will contain symlinks to the configuration files and a populated `agents/` directory with expert sub-agents.
