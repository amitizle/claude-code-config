---
allowed-tools: Bash, Read, Edit, Write
---

# Update Project Context

Log progress and updates to the current project's context.

## Usage
```
/project-update "project-name" "Progress description"
```
Project names with spaces must be quoted.

## Instructions

### 1. Validate Project
```bash
PROJECT_NAME="$1"
UPDATE_TEXT="$2"

if [[ -z "$PROJECT_NAME" ]]; then
  echo "❌ Project name required"
  echo "Usage: /project-update \"project-name\" \"Progress description\""
  echo "Note: Use quotes around project names with spaces"
  echo ""
  echo "Available projects:"
  ls "$HOME/Documents/ClaudeProjects" 2>/dev/null | head -5 || echo "No projects found"
  exit 1
fi

PROJECT_DIR="$HOME/Documents/ClaudeProjects/$PROJECT_NAME"
CONTEXT_FILE="$PROJECT_DIR/CONTEXT.md"

if [[ ! -f "$CONTEXT_FILE" ]]; then
  echo "❌ Project '$PROJECT_NAME' not found or has no context file"
  echo "Available projects:"
  ls "$HOME/Documents/ClaudeProjects" 2>/dev/null | head -5 || echo "No projects found"
  exit 1
fi
```

### 2. Prepare Update Entry
```bash
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SESSION_DATE=$(date +"%Y-%m-%d")

if [[ -z "$UPDATE_TEXT" ]]; then
  echo "📝 Enter progress update (or press Ctrl+C to cancel):"
  echo "What did you accomplish?"
  read -r UPDATE_TEXT
fi

if [[ -z "$UPDATE_TEXT" ]]; then
  echo "❌ No update provided"
  exit 1
fi
```

### 3. Update Context File
Read the current context file and add the new entry:

```bash
# Read current content
TEMP_FILE=$(mktemp)
cp "$CONTEXT_FILE" "$TEMP_FILE"

# Check if session already exists for today
if grep -q "### Session $SESSION_DATE" "$CONTEXT_FILE"; then
  # Append to existing session
  sed -i "/### Session $SESSION_DATE/a\\
- $(date +"%H:%M"): $UPDATE_TEXT" "$CONTEXT_FILE"
else
  # Create new session entry
  # Insert before the "---" line at the end
  sed -i "/^---$/i\\
\\
### Session $SESSION_DATE\\
- $(date +"%H:%M"): $UPDATE_TEXT" "$CONTEXT_FILE"
fi

# Update the "Last updated" timestamp
sed -i "s/^\*Last updated:.*/*Last updated: $CURRENT_DATE*/" "$CONTEXT_FILE"
```

### 4. Display Confirmation
```bash
echo "✅ Updated project context: $PROJECT_NAME"
echo "Added: $UPDATE_TEXT"
echo ""
echo "Context file: $CONTEXT_FILE"
echo ""
echo "Recent updates:"
echo "==============="
tail -10 "$CONTEXT_FILE" | head -8
```

### 5. Show Next Steps
```bash
echo ""
echo "Continue working on: $PROJECT_NAME"
echo "Project directory: $PROJECT_DIR"
```