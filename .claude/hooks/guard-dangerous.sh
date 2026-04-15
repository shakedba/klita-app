#!/bin/bash
# PreToolUse hook: Block or warn on dangerous Bash commands before execution.
# Triggered on: Bash
# Outputs JSON decision to stdout. Exit 0 = allow, exit 2 = hard block.

set -uo pipefail

INPUT=$(cat)

# Extract command from tool input JSON
COMMAND=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    print(data.get('tool_input', {}).get('command', ''))
except Exception:
    print('')
" 2>/dev/null || echo "")

if [ -z "$COMMAND" ]; then
    exit 0
fi

# --- Hard blocks: destructive and unrecoverable ---
HARD_BLOCK_PATTERNS=(
    "rm -rf /"
    "rm -rf ~"
    "rm -rf \$HOME"
    ":(){:|:&};:"           # fork bomb
    "dd if=.*of=/dev/"      # disk overwrite
    "mkfs\."                # format filesystem
    "> /dev/sd"             # write to disk device
    "chmod -R 777 /"        # world-writable root
    "chown -R.*/"           # recursive chown on root
)

for pattern in "${HARD_BLOCK_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qE "$pattern"; then
        echo "{\"decision\": \"block\", \"reason\": \"Hard-blocked: matches destructive pattern '$pattern'. This command cannot be run.\"}"
        exit 2
    fi
done

# --- Soft warnings: risky but sometimes legitimate ---
WARN_PATTERNS=(
    "git push --force"
    "git push -f "
    "git reset --hard"
    "git clean -fd"
    "git clean -fxd"
    "DROP TABLE"
    "DROP DATABASE"
    "TRUNCATE "
    "DELETE FROM.*WHERE.*1=1"
    "rm -rf"
    "npm publish"
    "yarn publish"
    "pnpm publish"
    "curl.*\| bash"
    "wget.*\| bash"
    "curl.*\| sh"
)

for pattern in "${WARN_PATTERNS[@]}"; do
    if echo "$COMMAND" | grep -qiE "$pattern"; then
        # Exit 1 sends warning back to Claude — it must re-confirm before proceeding
        echo "⚠️  Potentially dangerous command detected:"
        echo "    Command: $COMMAND"
        echo "    Pattern matched: $pattern"
        echo ""
        echo "Please confirm this is intentional before proceeding."
        echo "If confirmed, re-run the command explicitly."
        exit 1
    fi
done

exit 0
