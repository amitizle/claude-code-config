---
allowed-tools: Bash, Write, Read, LS
---

# Start New Project

Initialize a new project with context storage.

## Usage
```
/project-start "project-name" "Project Description"
```
Project names with spaces must be quoted.

## Instructions

### 1. Create Project Directory
```bash
PROJECT_NAME="$1"
PROJECT_DESC="$2"

if [[ -z "$PROJECT_NAME" ]]; then
  echo "❌ Project name required"
  echo "Usage: /project-start \"project-name\" \"Project Description\""
  echo "Note: Use quotes around project names with spaces"
  exit 1
fi

PROJECT_DIR="$HOME/Documents/ClaudeProjects/$PROJECT_NAME"

if [[ -d "$PROJECT_DIR" ]]; then
  echo "❌ Project '$PROJECT_NAME' already exists"
  echo "Use /project-resume $PROJECT_NAME to continue working on it"
  exit 1
fi

mkdir -p "$PROJECT_DIR"
echo "✅ Created project directory: $PROJECT_DIR"
```

### 2. Initialize Context File
```bash
CONTEXT_FILE="$PROJECT_DIR/CONTEXT.md"
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat > "$CONTEXT_FILE" << EOF
# $PROJECT_NAME

**Created**: $CURRENT_DATE  
**Description**: ${PROJECT_DESC:-"New project"}  
**Status**: Active  

## Project Overview

${PROJECT_DESC:-"Add project description here"}

## Current Goals

- [ ] Define project requirements
- [ ] Set up initial structure

## Context & Notes

### Session $(date +"%Y-%m-%d")
- Project initialized
- Ready to begin development

## Files & Structure

\`\`\`
$PROJECT_NAME/
├── CONTEXT.md (this file)
└── ... (project files will go here)
\`\`\`

## Next Steps

1. Define project requirements
2. Create initial file structure
3. Begin implementation

---
*Last updated: $CURRENT_DATE*
EOF

echo "✅ Created context file: $CONTEXT_FILE"
```

### 3. Check for Existing Context Files
```bash
# Check if we're initializing in an existing directory with .md files
TARGET_PROJECT_DIR="."
if [[ -n "$3" ]]; then
  TARGET_PROJECT_DIR="$3"
fi

if [[ "$TARGET_PROJECT_DIR" != "." ]] && [[ -d "$TARGET_PROJECT_DIR" ]]; then
  cd "$TARGET_PROJECT_DIR" || true
fi

# Find existing .md files in current directory
EXISTING_MD_FILES=($(find . -maxdepth 1 -name "*.md" -type f 2>/dev/null | sed 's|^./||' | sort))

if [[ ${#EXISTING_MD_FILES[@]} -gt 0 ]]; then
  echo ""
  echo "📄 Found existing .md files:"
  for file in "${EXISTING_MD_FILES[@]}"; do
    echo "  - $file"
  done
  echo ""
  echo "These will be included in project context automatically."
  echo "You can use /project-resume \"$PROJECT_NAME\" to see all context files."
fi
```

### 4. Display Next Steps
```bash
echo ""
echo "🎯 Project '$PROJECT_NAME' ready!"
echo ""
echo "Next steps:"
echo "- cd \"$PROJECT_DIR\""
echo "- Edit CONTEXT.md to add project details"
echo "- Use /project-update to log progress"
if [[ ${#EXISTING_MD_FILES[@]} -gt 0 ]]; then
  echo "- /project-resume \"$PROJECT_NAME\" to see all context files"
fi
echo ""
echo "Resume from anywhere with: /project-resume \"$PROJECT_NAME\""
```