#!/bin/bash
# PostToolUse hook: Run type checker after Claude writes/edits files.
# Triggered on: Write, Edit, MultiEdit
# Outputs errors back to Claude so it can self-correct immediately.

set -uo pipefail

INPUT=$(cat)

# Extract file path
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

# Skip non-TypeScript files
if [[ ! "$FILE_PATH" =~ \.(ts|tsx)$ ]]; then
    exit 0
fi

# Skip if no tsconfig
if ! ls tsconfig*.json 2>/dev/null | head -1 | grep -q .; then
    exit 0
fi

# Skip if tsc not available
if ! command -v npx &>/dev/null; then
    exit 0
fi

# Run type check (project-wide, since TS needs full context)
ERRORS=$(npx tsc --noEmit 2>&1) || true

if [ -n "$ERRORS" ]; then
    echo "TypeScript errors detected:"
    echo "$ERRORS"
    # Exit 1 returns output to Claude as feedback — it will self-correct
    exit 1
fi

exit 0
