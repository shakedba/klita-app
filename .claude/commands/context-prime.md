# Context Prime

Load comprehensive project understanding before starting a new task. Use at the start of a session or when switching between features.

## What to Load

### 1. Project Overview
```bash
cat README.md
cat CLAUDE.md 2>/dev/null
```

### 2. Tech Stack & Dependencies
```bash
cat package.json | jq '{dependencies, devDependencies}'
# or
cat pyproject.toml
cat go.mod
```

### 3. Project Structure
```bash
find . -type f -name "*.ts" -not -path "*/node_modules/*" | head -50
# Understand the top-level directory organization
```

### 4. Recent Activity
```bash
git log --oneline -20
git diff main...HEAD --stat
```

### 5. Open Issues & PRs (if relevant)
```bash
gh issue list --limit 10 --state open
gh pr list --limit 5
```

### 6. Current Task Context
If there's a relevant issue or PR:
```bash
gh issue view <number>
# or
gh pr view <number>
```

## Output After Loading

Produce a brief context summary:

```
## Session Context

**Project:** [name] — [one-line description]
**Stack:** [frontend] + [backend] + [DB] + [infra]
**Branch:** [current branch] (X commits ahead of main)

**Current task:** [what we're working on]
**Relevant files:** [top 3-5 files for this task]
**Recent changes:** [last 3 commits in plain English]
**Open blockers:** [any known issues or dependencies]

Ready.
```

## When to Use

- First message of a new session
- After a long break mid-task
- When switching from one feature to another
- When handing off between team members
