#!/bin/bash
# PostToolUse hook: Auto-lint and format files after Claude writes/edits them.
# Triggered on: Write, Edit, MultiEdit
# Reads tool input JSON from stdin to extract the file path.

set -euo pipefail

INPUT=$(cat)

# Extract file path from tool input JSON
FILE_PATH=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    tool_input = data.get('tool_input', {})
    # Write tool uses 'file_path', Edit uses 'file_path' too
    print(tool_input.get('file_path', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

# Skip if no file path or file doesn't exist
if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

CHANGED=0

# --- ESLint (JS/TS files) ---
if [[ "$FILE_PATH" =~ \.(js|jsx|ts|tsx|mjs|cjs)$ ]]; then
    if command -v npx &>/dev/null; then
        # Only run if ESLint config exists in project
        if ls eslint.config* .eslintrc* 2>/dev/null | head -1 | grep -q .; then
            if npx eslint --fix "$FILE_PATH" 2>/dev/null; then
                CHANGED=1
            fi
        fi
    fi
fi

# --- Prettier (JS/TS/JSON/CSS/MD files) ---
if [[ "$FILE_PATH" =~ \.(js|jsx|ts|tsx|mjs|cjs|json|css|scss|md|mdx|html|yaml|yml)$ ]]; then
    if command -v npx &>/dev/null; then
        # Only run if Prettier config exists or prettier is in package.json
        HAS_PRETTIER=0
        ls .prettierrc* prettier.config* 2>/dev/null | head -1 | grep -q . && HAS_PRETTIER=1
        [ $HAS_PRETTIER -eq 0 ] && grep -q '"prettier"' package.json 2>/dev/null && HAS_PRETTIER=1

        if [ $HAS_PRETTIER -eq 1 ]; then
            if npx prettier --write "$FILE_PATH" 2>/dev/null; then
                CHANGED=1
            fi
        fi
    fi
fi

# --- Ruff (Python files) ---
if [[ "$FILE_PATH" =~ \.py$ ]]; then
    if command -v ruff &>/dev/null; then
        ruff check --fix "$FILE_PATH" 2>/dev/null && CHANGED=1
        ruff format "$FILE_PATH" 2>/dev/null && CHANGED=1
    fi
fi

# --- gofmt (Go files) ---
if [[ "$FILE_PATH" =~ \.go$ ]]; then
    if command -v gofmt &>/dev/null; then
        gofmt -w "$FILE_PATH" 2>/dev/null && CHANGED=1
    fi
fi

if [ $CHANGED -eq 1 ]; then
    echo "✓ Auto-formatted: $FILE_PATH"
fi

exit 0
