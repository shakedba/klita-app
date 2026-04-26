---
name: token-optimizer
description: Find the ghost tokens. Audit Claude Code setup, see where 25-38% of your context goes, fix it. Use when context feels tight.
effort: high
---

# Token Optimizer: See Where Your Context Window Goes. Get It Back.

Token optimization specialist. Audits a Claude Code setup, identifies context window waste, implements fixes, and measures savings.

**Target**: 5-15% context recovery through config cleanup (more for heavier setups), up to 25%+ with autocompact management. Plus behavioral optimizations that compound across every session.

---

## Phase 0: Initialize

0. **Resolve measure.py path** (works for both skill and plugin installs):
```bash
MEASURE_PY=""
for f in "$HOME/.claude/skills/token-optimizer/scripts/measure.py" \
         "$HOME/.claude/plugins/cache"/*/token-optimizer/*/skills/token-optimizer/scripts/measure.py; do
  [ -f "$f" ] && MEASURE_PY="$f" && break
done
[ -z "$MEASURE_PY" ] && { echo "[Error] measure.py not found. Is Token Optimizer installed?"; exit 1; }
echo "Using: $MEASURE_PY"
```
Use `$MEASURE_PY` for all subsequent measure.py calls in this session.

1. **Detect context window size**:
   Check if `TOKEN_OPTIMIZER_CONTEXT_SIZE` env var is already set. If not:
   - Check for `ANTHROPIC_API_KEY` env var (indicates API usage, possibly 1M context)
   - If API key found, ask the user: "You appear to be using the API. Do you have 1M token context (e.g. Opus)? If so I'll calibrate for 1M instead of 200K."
   - If they confirm 1M, `export TOKEN_OPTIMIZER_CONTEXT_SIZE=1000000` for this session
   - If no API key or they say no, default is 200K (no action needed)
   Keep this quick, one question max. Don't belabor it.

2. **Quick pre-check** (detect minimal setups):
   Run `python3 $MEASURE_PY report`.
   If estimated controllable tokens < 1,000 and no CLAUDE.md exists, short-circuit:
   ```
   [Token Optimizer] Your setup is already minimal (~X tokens overhead).
   Focus on behavioral changes instead: /compact at 70%, /clear between topics,
   default agents to haiku, batch requests.
   ```

3. **Backup everything first** (before touching anything):
```bash
BACKUP_DIR="$HOME/.claude/_backups/token-optimizer-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
chmod 700 "$BACKUP_DIR"
cp ~/.claude/CLAUDE.md "$BACKUP_DIR/" 2>/dev/null || true
cp ~/.claude/settings.json "$BACKUP_DIR/" 2>/dev/null || true
cp -r ~/.claude/commands "$BACKUP_DIR/" 2>/dev/null || true
# Back up all project MEMORY.md files
for memfile in ~/.claude/projects/*/memory/MEMORY.md; do
  if [ -f "$memfile" ]; then
    projname=$(basename "$(dirname "$(dirname "$memfile")")"
    cp "$memfile" "$BACKUP_DIR/MEMORY-${projname}.md" 2>/dev/null || true
  fi
done

# Verify backup is non-empty
if [ -z "$(ls -A "$BACKUP_DIR" 2>/dev/null)" ]; then
  echo "[Warning] Backup directory is empty. No files were backed up."
  echo "This may mean you have a fresh setup (nothing to back up) or a permissions issue."
fi
```

4. **Create coordination folder**:
```bash
COORD_PATH=$(mktemp -d /tmp/token-optimizer-XXXXXXXXXX)
[ -d "$COORD_PATH" ] || { echo "[Error] Failed to create coordination folder. Check /tmp permissions."; exit 1; }
mkdir -p "$COORD_PATH"/{audit,analysis,plan,verification}
```

5. **Check SessionEnd hook** (first-time setup, skips silently if already installed):
```bash
python3 $MEASURE_PY check-hook
```
   - If exit 0: hook is already installed (includes plugin auto-install), skip entirely and proceed to Phase 1.
   - If exit 1 (manual/script install users only): explain and offer to install:

   ```
   [Token Optimizer] Want to track your token usage over time?

   Right now, the optimizer can audit your setup. But to track *trends* (which
   skills you actually use, how your context fills up day to day, model costs),
   it needs to save a small log after each Claude Code session.

   What this does:
   - When you close a Claude Code session, it automatically saves usage stats
   - Takes ~2 seconds, runs silently in the background, then stops
   - All data stays on your machine (stored in ~/.claude/_backups/token-optimizer/)
   - Powers the Trends and Health tabs in your dashboard

   Without this, the dashboard only shows a snapshot from right now.
   With it, you get a living history that updates every session.

   Remove anytime by running: python3 measure.py setup-hook --uninstall
   Or manually: delete the SessionEnd entry from ~/.claude/settings.json
   ```

   Ask user:
   1. Install it (run `measure.py setup-hook --dry-run` first to show the diff, then confirm and run `measure.py setup-hook`)
   2. Show me the JSON first (run `measure.py setup-hook --dry-run` and stop)
   3. Skip for now

   If skipped, note it and continue. The audit still works without it, but the Trends tab will only have data from manual `measure.py collect` runs.

6. **Offer the bookmarkable dashboard URL** (macOS and Windows. Linux lands in a future release; skip silently there.):

   Run BOTH probes in one pass, then branch on the combination:
```bash
python3 "$MEASURE_PY" daemon-status
python3 "$MEASURE_PY" daemon-consent --get
```

   `daemon-status` prints one of `DAEMON_RUNNING`, `DAEMON_FOREIGN`, or `DAEMON_NOT_RUNNING`. `daemon-consent --get` prints a JSON object.

   First-time install prompt copy:

   ```
   [Token Optimizer] Want a bookmarkable dashboard URL?

   URL:  http://localhost:24842/token-optimizer
   File: ~/.claude/_backups/token-optimizer/dashboard.html  (always works)

   The URL stays bookmarked and auto-updates after every session.
   The file is the fallback — same content, just harder to reach.
   ```

   Ask user:
   1. Install it (write consent FIRST: `measure.py daemon-consent --set yes`, then `measure.py setup-daemon`)
   2. Skip (run `measure.py daemon-consent --set no`)

7. **Check Smart Compaction hooks** (v2.0, first-time setup, skips silently if already installed):
```bash
python3 $MEASURE_PY setup-smart-compact --status
```
   - If all 4 hooks installed: skip entirely.
   - If partially or not installed: explain and offer to install.

Output: `[Token Optimizer Initialized] Backup: $BACKUP_DIR | Coordination: $COORD_PATH`

---

## Phase 1: Quick Audit (Parallel Agents)

Read `references/agent-prompts.md` for all prompt templates.

Dispatch 6 agents in parallel (single message, multiple Task calls):

**Model assignment**: CLAUDE.md, MEMORY.md, Skills, MCP auditors use `model="sonnet"`. Commands uses `model="haiku"`. Settings & Advanced uses `model="sonnet"`.

| Agent | Output File | Task |
|-------|-------------|------|
| CLAUDE.md Auditor | `audit/claudemd.md` | Size, duplication, tiered content, cache structure |
| MEMORY.md Auditor | `audit/memorymd.md` | Size, overlap with CLAUDE.md |
| Skills Auditor | `audit/skills.md` | Count, frontmatter overhead, duplicates |
| MCP Auditor | `audit/mcp.md` | Deferred tools, broken/unused servers |
| Commands Auditor | `audit/commands.md` | Count, menu overhead |
| Settings & Advanced | `audit/advanced.md` | Hooks, rules, settings, @imports, file exclusion, caching, monitoring |

Pass `COORD_PATH` to each agent. Wait for all to complete.

**Validation**: Before proceeding to Phase 2, verify all 6 audit files exist:
```bash
for f in claudemd.md memorymd.md skills.md mcp.md commands.md advanced.md; do
  [ -f "$COORD_PATH/audit/$f" ] || echo "MISSING: $f"
done
```

---

## Phase 2: Analysis (Synthesis Agent)

Read the **Synthesis Agent** prompt from `references/agent-prompts.md`.

Dispatch with `model="opus"` (fallback: `model="sonnet"`). It reads all audit files and writes a prioritized plan to `{COORD_PATH}/analysis/optimization-plan.md`.

---

## Phase 3: Present Findings

```
[Token Optimizer Results]

CURRENT STATE
Your per-message overhead: ~X tokens
Context used before first message: ~X%

QUICK WINS (do these today)
- [Action 1]: Save ~X tokens/msg (~Y%)
- [Action 2]: Save ~X tokens/msg (~Y%)

MODEL ROUTING
[Has instructions: Yes/No] | [Token distribution: X% Opus, Y% Sonnet, Z% Haiku or "Not measured yet"]

FULL OPTIMIZATION POTENTIAL
If all implemented: ~X tokens/msg saved (~Y% reduction)

Ready to implement? I can:
1. Auto-fix safe changes (consolidate CLAUDE.md, archive skills)
2. Generate permissions.deny rules (if missing)
3. Create optimized CLAUDE.md template
4. Show MCP servers to consider disabling
```

**Then generate the interactive dashboard:**

```bash
python3 $MEASURE_PY dashboard --coord-path $COORD_PATH
```

**Wait for user decision before proceeding.**

---

## Phase 4: Implementation

Read `references/implementation-playbook.md` for detailed steps.

Available actions: 4A (CLAUDE.md), 4B (MEMORY.md), 4C (Skills), 4D (File Exclusion), 4E (MCP), 4F (Hooks), 4G (Cache Structure), 4H (Rules Cleanup), 4I (Settings Tuning), 4J (Skill Description Tightening), 4K (Compact Instructions Setup), 4L (Model Routing Setup), 4M (Smart Compaction Setup), 4N (Context Quality Check), 4O (Version-Aware Optimizations), 4P (Smart Model Routing Instructions).

Templates in `examples/`. Always backup before changes. Present diffs for approval.

---

## Phase 5: Verification

Read the **Verification Agent** prompt from `references/agent-prompts.md`.

Dispatch with `model="haiku"`. It re-measures everything and calculates savings.

Present results:
```
[Optimization Complete]

SAVINGS ACHIEVED
- CLAUDE.md: -X tokens/msg
- MEMORY.md: -Y tokens/msg
- Skills: -Z tokens/msg
- Total: -W tokens/msg (V% reduction)

NEXT STEPS (Behavioral, ordered by ROI)
1. Default subagents to Haiku (60x cheaper than Opus, see Model Routing)
2. Use /compact at 50-70% context (quality degrades past 70%)
3. Use /clear between unrelated topics
4. Use Plan Mode (Shift+Tab x2) before complex tasks
5. Batch related requests into one message
6. Run /context periodically to check fill level
7. Run `measure.py trends` periodically to review usage patterns
```

---

## Reference Files

| Phase | Read |
|-------|------|
| Phase 1-2 | `references/agent-prompts.md`, `references/token-flow-architecture.md` |
| Phase 3 | `references/optimization-checklist.md` |
| Phase 4 | `references/implementation-playbook.md`, `examples/` |
| Phase 5 | `references/agent-prompts.md` |

---

## Model Selection

| Task | Model | Fallback | Why |
|------|-------|----------|-----|
| CLAUDE.md, MEMORY.md, Skills, MCP auditors | `sonnet` | `haiku` | Judgment: content structure, semantic duplicates |
| Commands auditor | `haiku` | - | Data gathering: counting, presence checks |
| Settings & Advanced auditor | `sonnet` | `haiku` | Judgment: rules quality, settings tradeoffs |
| Synthesis (Phase 2) | `opus` | `sonnet` | Cross-cutting prioritization across all findings |
| Orchestrator | Default | - | Coordination only |
| Verification (Phase 5) | `haiku` | - | Re-measurement |

---

## Error Handling

- **Agent timeout/failure**: Note the gap and continue. Do not retry.
- **Model unavailable**: Fall back one tier: opus -> sonnet -> haiku.
- **No CLAUDE.md found**: Report 0 tokens, skip to skills audit.
- **No skills directory**: Report 0 tokens, note as "fresh setup."
- **measure.py not found**: Fall back to manual estimation (line count x 15 for prose, x 8 for YAML).
- **Coordination folder write failure**: Abort and report the error.
- **Backup write failure**: Warn user and ask whether to proceed without backup.
- **Synthesis agent failure**: Present raw audit files to user instead.
- **Verification agent failure**: Fall back to running `measure.py snapshot after` + `measure.py compare` directly.

---

## Core Rules

- Quantify everything (X tokens, Y%)
- Create backups before any changes (`~/.claude/_backups/`)
- Ask user before implementing
- Never delete files, always archive
- Check dependencies before archiving
- Warn about side effects: deny rules block ALL tools, MCP removal breaks dependent skills
- Use appropriate models (with fallbacks) for each task
- Show before/after diffs
- Frame savings as context budget (% of context window), not dollar amounts
