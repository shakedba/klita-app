#!/bin/bash
# Stop hook: Send desktop notification when Claude finishes a task.
# Triggered on: Stop (task completion)
# Cross-platform: macOS, Linux (notify-send), Windows WSL.

INPUT=$(cat)

# Extract final message summary if available
SUMMARY=$(echo "$INPUT" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    # Try to get a useful summary from the stop reason
    print(data.get('stop_reason', 'Task complete'))
except Exception:
    print('Task complete')
" 2>/dev/null || echo "Task complete")

TITLE="Claude Code ✓"
MESSAGE="$SUMMARY"
TIMESTAMP=$(date '+%H:%M:%S')
FULL_MESSAGE="[$TIMESTAMP] $MESSAGE"

# --- macOS ---
if command -v osascript &>/dev/null; then
    osascript -e "display notification \"$FULL_MESSAGE\" with title \"$TITLE\" sound name \"Glass\"" 2>/dev/null &
    exit 0
fi

# --- Linux (notify-send) ---
if command -v notify-send &>/dev/null; then
    notify-send "$TITLE" "$FULL_MESSAGE" --icon=terminal --urgency=low 2>/dev/null &
    exit 0
fi

# --- Linux (zenity fallback) ---
if command -v zenity &>/dev/null; then
    zenity --notification --text="$TITLE: $FULL_MESSAGE" 2>/dev/null &
    exit 0
fi

# --- WSL / Windows (PowerShell toast) ---
if command -v powershell.exe &>/dev/null; then
    powershell.exe -Command "
        Add-Type -AssemblyName System.Windows.Forms
        \$notify = New-Object System.Windows.Forms.NotifyIcon
        \$notify.Icon = [System.Drawing.SystemIcons]::Information
        \$notify.Visible = \$true
        \$notify.ShowBalloonTip(3000, '$TITLE', '$FULL_MESSAGE', [System.Windows.Forms.ToolTipIcon]::Info)
        Start-Sleep -Seconds 3
        \$notify.Dispose()
    " 2>/dev/null &
    exit 0
fi

# --- Terminal bell fallback (always works) ---
echo -e "\a"
echo "$TITLE: $FULL_MESSAGE"

exit 0
