---
allowed-tools: Bash, Read
---

# Project Status

Show current project and recent activity.

## Usage
```
/project-status "project-name"
```
Project names with spaces must be quoted.

## Instructions

### 1. Validate Project
```bash
PROJECT_NAME="$1"

if [[ -z "$PROJECT_NAME" ]]; then
  echo "❌ Project name required"
  echo "Usage: /project-status \"project-name\""
  echo "Note: Use quotes around project names with spaces"
  echo ""
  echo "Available projects:"
  ls "$HOME/Documents/ClaudeProjects" 2>/dev/null | head -5 || echo "No projects found"
  exit 1
fi

PROJECT_DIR="$HOME/Documents/ClaudeProjects/$PROJECT_NAME"
CONTEXT_FILE="$PROJECT_DIR/CONTEXT.md"
```

### 2. Display Current Status
```bash
echo "🎯 Project: $PROJECT_NAME"
echo "📁 Location: $PROJECT_DIR"
echo ""

if [[ ! -f "$CONTEXT_FILE" ]]; then
  echo "❌ Project '$PROJECT_NAME' not found or has no context file"
  echo "Available projects:"
  ls "$HOME/Documents/ClaudeProjects" 2>/dev/null | head -5 || echo "No projects found"
  exit 1
fi
```

### 3. Show Project Overview
```bash
echo "📋 Project Overview:"
echo "==================="

# Extract key information
DESCRIPTION=$(grep "^**Description**:" "$CONTEXT_FILE" 2>/dev/null | sed 's/^**Description**: *//' | head -1)
STATUS=$(grep "^**Status**:" "$CONTEXT_FILE" 2>/dev/null | sed 's/^**Status**: *//' | head -1)
CREATED=$(grep "^**Created**:" "$CONTEXT_FILE" 2>/dev/null | sed 's/^**Created**: *//' | head -1)

echo "Description: ${DESCRIPTION:-"Not set"}"
echo "Status: ${STATUS:-"Unknown"}"
echo "Created: ${CREATED:-"Unknown"}"
echo ""
```

### 4. Show Available Context Files
```bash
echo "📄 Context Files:"
echo "================="

# Show CONTEXT.md first (primary context file)
if [[ -f "$CONTEXT_FILE" ]]; then
  size=$(ls -lh "$CONTEXT_FILE" | awk '{print $5}')
  modified=$(ls -l "$CONTEXT_FILE" | awk '{print $6, $7, $8}')
  echo "✅ CONTEXT.md (Primary) - $size, modified: $modified"
else
  echo "❌ CONTEXT.md (Primary) - Missing! Use /project-update to create it."
fi

# Find other .md files (excluding CONTEXT.md)
OTHER_MD_FILES=($(find "$PROJECT_DIR" -maxdepth 1 -name "*.md" -type f -not -name "CONTEXT.md" | sort))

if [[ ${#OTHER_MD_FILES[@]} -gt 0 ]]; then
  echo ""
  echo "Additional context files:"
  for md_file in "${OTHER_MD_FILES[@]}"; do
    filename=$(basename "$md_file")
    size=$(ls -lh "$md_file" | awk '{print $5}')
    modified=$(ls -l "$md_file" | awk '{print $6, $7, $8}')
    echo "- $filename ($size, modified: $modified)"
  done
fi
echo ""
```

### 5. Show Recent Activity
```bash
echo "📊 Recent Activity:"
echo "==================="

# Look for sessions in CONTEXT.md specifically
if [[ -f "$CONTEXT_FILE" ]]; then
  # Get last 3 sessions
  grep -n "### Session" "$CONTEXT_FILE" | tail -3 | while IFS=':' read -r line_num session; do
    session_date=$(echo "$session" | sed 's/### Session //')
    echo ""
    echo "$session"
    
    # Get activities for this session (lines after the session header until next session or end)
    next_session_line=$(grep -n "### Session" "$CONTEXT_FILE" | awk -F: -v current="$line_num" '$1 > current {print $1; exit}')
    
    if [[ -n "$next_session_line" ]]; then
      sed -n "${line_num},${next_session_line}p" "$CONTEXT_FILE" | grep "^- " | head -5
    else
      sed -n "${line_num},\$p" "$CONTEXT_FILE" | grep "^- " | head -5
    fi
  done

  if ! grep -q "### Session" "$CONTEXT_FILE"; then
    echo "No activity logged yet"
    echo "Use /project-update \"$PROJECT_NAME\" \"message\" to log progress"
  fi
else
  echo "No CONTEXT.md file found - no activity logged yet"
  echo "Use /project-update \"$PROJECT_NAME\" \"message\" to log progress"
fi
```

### 6. Show Quick Actions
```bash
echo ""
echo "Quick Actions:"
echo "=============="
echo "- /project-update \"$PROJECT_NAME\" \"message\"  (log progress)"
echo "- cd \"$PROJECT_DIR\"                        (go to project)"
echo "- /project-list                             (see all projects)"
echo "- /project-resume NAME                      (view other project)"
```