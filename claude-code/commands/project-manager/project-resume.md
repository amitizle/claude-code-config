---
allowed-tools: Bash, Read, LS
---

# Resume Project

Resume working on an existing project.

## Usage
```
/project-resume "project-name"
```
Project names with spaces must be quoted.

## Instructions

### 1. Validate Project
```bash
PROJECT_NAME="$1"

if [[ -z "$PROJECT_NAME" ]]; then
  echo "❌ Project name required"
  echo "Usage: /project-resume \"project-name\""
  echo "Note: Use quotes around project names with spaces"
  echo ""
  echo "Available projects:"
  ls "$HOME/Documents/ClaudeProjects" 2>/dev/null | head -10 || echo "No projects found"
  exit 1
fi

PROJECT_DIR="$HOME/Documents/ClaudeProjects/$PROJECT_NAME"

if [[ ! -d "$PROJECT_DIR" ]]; then
  echo "❌ Project '$PROJECT_NAME' not found"
  echo ""
  echo "Available projects:"
  ls "$HOME/Documents/ClaudeProjects" 2>/dev/null | head -10 || echo "No projects found"
  exit 1
fi
```

### 2. Display Project Context
```bash
CONTEXT_FILE="$PROJECT_DIR/CONTEXT.md"

echo "📋 Resuming: $PROJECT_NAME"
echo "=====================================\\"
echo ""

# Always show CONTEXT.md first (create if missing)
if [[ ! -f "$CONTEXT_FILE" ]]; then
  echo "⚠️  No CONTEXT.md found for $PROJECT_NAME"
  echo "Creating basic context file..."
  
  CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  cat > "$CONTEXT_FILE" << EOF
# $PROJECT_NAME

**Created**: Unknown  
**Resumed**: $CURRENT_DATE  
**Status**: Active  

## Project Overview

Add project description here.

## Current Goals

- [ ] Add project goals

## Context & Notes

### Session $(date +"%Y-%m-%d")
- Project resumed
- Added basic context structure

---
*Last updated: $CURRENT_DATE*
EOF
  echo "✅ Created CONTEXT.md"
  echo ""
fi

# Display CONTEXT.md first
echo "📄 CONTEXT.md (Primary Context)"
echo "---"
cat "$CONTEXT_FILE"
echo ""
echo "---"
echo ""

# Find other .md files (excluding CONTEXT.md)
OTHER_MD_FILES=($(find "$PROJECT_DIR" -maxdepth 1 -name "*.md" -type f -not -name "CONTEXT.md" | sort))

if [[ ${#OTHER_MD_FILES[@]} -gt 0 ]]; then
  echo "📄 Additional Context Files:"
  echo ""
  for md_file in "${OTHER_MD_FILES[@]}"; do
    filename=$(basename "$md_file")
    echo "📄 $filename"
    echo "---"
    cat "$md_file"
    echo ""
    echo "---"
    echo ""
  done
fi

echo "=====================================\\"
```

### 3. Display Navigation
```bash
echo ""
echo "🎯 Ready to work on: $PROJECT_NAME"
echo ""
echo "Project location: $PROJECT_DIR"
echo "Context file: $CONTEXT_FILE"
echo ""
echo "Useful commands:"
echo "- cd \"$PROJECT_DIR\""
echo "- /project-update \"$PROJECT_NAME\" \"message\" (to log progress)"
echo "- /project-status \"$PROJECT_NAME\" (show status)"
echo "- /project-list (see all projects)"
```