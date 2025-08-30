---
allowed-tools: Bash, Read, LS
---

# List Projects

Show all available projects with their status.

## Usage
```
/project-list
```

## Instructions

### 1. Check Projects Directory
```bash
PROJECTS_DIR="$HOME/Documents/ClaudeProjects"

if [[ ! -d "$PROJECTS_DIR" ]]; then
  echo "📁 No projects directory found"
  echo "Create your first project with: /project-start project-name \"Description\""
  exit 0
fi

cd "$PROJECTS_DIR" || exit 1
PROJECT_COUNT=$(ls -1 | wc -l)

if [[ $PROJECT_COUNT -eq 0 ]]; then
  echo "📁 No projects found"
  echo "Create your first project with: /project-start project-name \"Description\""
  exit 0
fi
```

### 2. List All Projects
```bash
echo "📋 Projects ($PROJECT_COUNT found):"
echo "=============================="

for project in */; do
  project_name=${project%/}
  context_file="$project/CONTEXT.md"
  
  if [[ -f "$context_file" ]]; then
    # Extract description and last updated
    description=$(grep "^**Description**:" "$context_file" 2>/dev/null | sed 's/^**Description**: *//' | head -1)
    last_updated=$(grep "^*Last updated:" "$context_file" 2>/dev/null | tail -1 | sed 's/^*Last updated: *//' | sed 's/\*$//')
    
    if [[ -z "$description" ]]; then
      description="No description"
    fi
    
    if [[ -n "$last_updated" ]]; then
      echo "- $project_name"
      echo "  └─ $description"
      echo "  └─ Updated: $last_updated"
    else
      echo "- $project_name"
      echo "  └─ $description"
    fi
  else
    echo "- $project_name (no context file)"
  fi
  echo ""
done
```

### 3. Show Usage Help
```bash
echo "Commands:"
echo "- /project-resume \"PROJECT_NAME\"         (view project context)"
echo "- /project-start \"NAME\" \"DESC\"           (create new project)"
echo "- /project-update \"PROJECT_NAME\" \"msg\"   (log progress)"
echo "- /project-status \"PROJECT_NAME\"         (show project details)"
```