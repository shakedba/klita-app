# Implementation Playbook

Detailed implementation steps for Phase 4 of the Token Optimizer. The orchestrator dispatches to these based on user choice.

---

## 4A: CLAUDE.md Consolidation

```bash
# Backup first
cp ~/.claude/CLAUDE.md ~/.claude/_backups/CLAUDE.md.pre-optimization-$(date +%Y%m%d)
```

**Steps**:
1. Read current CLAUDE.md
2. Apply tiered architecture pattern:
   - **Tier 1 (always loaded, ~300 lines / ~4,500 tokens)**: Identity, critical rules, key paths
   - **Tier 2 (skill/command, loaded on-demand)**: Workflows, domain docs, tool configs
   - **Tier 3 (file reference, explicit only)**: Full guides, templates, detailed standards
3. Move Tier 2/3 content to skills or reference files
4. Output optimized version to `{COORD_PATH}/plan/CLAUDE.md.optimized`
5. Present diff to user for approval before overwriting

**Targets**:
- Remove content that belongs in skills/commands (workflows, detailed configs)
- Remove content that duplicates MEMORY.md
- Move reference content to on-demand files
- Condense personality/voice specs to 1-2 lines

---

## 4B: MEMORY.md Deduplication

```bash
# Backup first
for memfile in ~/.claude/projects/*/memory/MEMORY.md; do
  [ -f "$memfile" ] || continue
  projname=$(basename "$(dirname "$(dirname "$memfile")")"
  cp "$memfile" "$HOME/.claude/_backups/MEMORY-${projname}.pre-optimization-$(date +%Y%m%d).md"
done
```

**Steps**:
1. Read current MEMORY.md
2. Remove content that duplicates CLAUDE.md (choose ONE source of truth)
3. Condense verbose operational history to current rule only
4. Keep only: learnings, corrections, habit tracking
5. Output to `{COORD_PATH}/plan/MEMORY.md.optimized`
6. Present diff for approval

---

## 4C: Skill Archival

```bash
mkdir -p ~/.claude/_backups/skills-archived-$(date +%Y%m%d)
mv ~/.claude/skills/[skill-name] ~/.claude/_backups/skills-archived-$(date +%Y%m%d)/
```

**CRITICAL**: A subfolder `_archived/` INSIDE `skills/` still loads as a namespace. Must move OUTSIDE `skills/` entirely.

List what will be archived, ask for confirmation before moving.

**DEPENDENCY CHECK (mandatory before archival)**:
Before archiving any skill, search for references to it:
1. `grep -r "[skill-name]" ~/.claude/CLAUDE.md ~/.claude/rules/ ~/.claude/skills/`
2. Check if any MCP server tools depend on the skill
3. Warn the user: "Archiving [skill] may break [dependent] which references it. Archive anyway?"

---

## 4D: File Exclusion Rules

If missing, add `permissions.deny` rules to `.claude/settings.json` (project-level) or `~/.claude/settings.json` (global). See `examples/permissions-deny-template.json` for a starter template.

**SIDE EFFECT WARNING (mandatory before applying)**:
1. **Database deny rules**: Will break any skill or MCP server that reads SQLite databases. Only add at project level.
2. **Credential deny rules**: Will prevent Claude from reading `.env`, `*.key`, `*.pem`. Usually desired for security.
3. **Global vs project-level**: Recommend project-level first.

Always tell the user: "These deny rules will prevent Claude from reading matching files in ALL sessions."

---

## 4E: MCP Server Guidance

Don't auto-disable MCP servers. Instead, provide:

```
To disable these MCP servers:
1. Edit config file (~/.claude/settings.json or Desktop config)
2. Remove or comment out these entries: [server list]
3. Restart Claude
Estimated savings: ~X tokens
```

**CONSEQUENCE CHECK (mandatory)**:
1. Search CLAUDE.md, skills, and rules for references to the server's tool names
2. If ANY skill references the server's tools, warn before recommending removal

---

## 4F: Hooks Configuration

### SessionEnd (measure.py collect)
Handled in Phase 0 setup. Offer `examples/hooks-starter.json` template.

### PreCompact
Guides what Claude preserves during context compaction.

### PostToolUse
Triggers auto-formatters on file writes, saving output tokens on style explanations.

---

## 4G: CLAUDE.md Cache Structure

If CLAUDE.md has volatile content mixed with stable content, restructure for prompt caching. See `examples/claude-md-optimized.md` for the pattern.

**Why**: Prompt caching caches prefixes. Static content first = stays cached (90% cheaper).

---

## 4H: Rules Cleanup

**Steps**:
1. List all files in `~/.claude/rules/`
2. For each rule file: measure token cost, check for `paths:` frontmatter, compare for duplication
3. Present findings and generate merge plan
4. Execute after user approval (backup to `~/.claude/_backups/rules-$(date +%Y%m%d)/`)

---

## 4I: Settings Tuning

Audit settings.json env block for token-relevant variables. Present current vs default values with tradeoff explanations. Apply user-chosen changes.

---

## 4J: Skill Description Tightening

**Steps**:
1. Scan all skill SKILL.md files, extract `description:` field
2. Flag descriptions >200 characters
3. Generate tighter alternatives
4. Apply approved changes to frontmatter (backup first)

**Note**: Only modify the `description:` field. Never touch skill body content.

---

## 4K: Compact Instructions Setup

**Steps**:
1. Read current CLAUDE.md
2. Identify what should survive compaction: task context, file paths, decisions, errors
3. Generate compact instructions section:
   ```markdown
   ## Compact Instructions
   When compacting this conversation, always preserve:
   - Current task context and progress
   - File paths being modified and their state
   - Test results and error messages
   - Active constraints and decisions made
   ```
4. Present to user for customization
5. Add to CLAUDE.md after approval (place near end, volatile section)

---

## 4L: Model Routing Setup

**Steps**:
1. Check if CLAUDE.md has model routing instructions
2. If not, present the recommended snippet:
   ```markdown
   ## Agent Model Selection
   Default subagents to haiku. Upgrade only when task requires judgment:
   - haiku: file reading, data gathering, counting, scanning, formatting
   - sonnet: analysis, code review, writing, moderate reasoning
   - opus: architecture decisions, novel debugging, cross-cutting synthesis
   ```
3. If routing exists, compare against actual model_mix usage from trends DB
4. Add to CLAUDE.md under `## Agent Model Selection` in the stable section

---

## 4M: Smart Compaction Setup

```bash
# Preview what will change
python3 $MEASURE_PY setup-smart-compact --dry-run

# Install all hooks
python3 $MEASURE_PY setup-smart-compact

# Check current status
python3 $MEASURE_PY setup-smart-compact --status
```

Components: **PreCompact** (capture before), **SessionStart** (restore after), **Stop** (checkpoint on end), **SessionEnd** (checkpoint on /clear).

Configurable via environment variables:
- `TOKEN_OPTIMIZER_CHECKPOINT_FILES`: Max checkpoint files kept (default: 10)
- `TOKEN_OPTIMIZER_CHECKPOINT_TTL`: Seconds before checkpoint expires (default: 300)
- `TOKEN_OPTIMIZER_CHECKPOINT_RETENTION_DAYS`: Days to keep old checkpoints (default: 7)

---

## 4N: Context Quality Check

```bash
python3 $MEASURE_PY quality current
```

Score ranges: 85-100 excellent, 70-84 good, 50-69 degraded, <50 critical.

---

## 4O: Version-Aware Optimizations (v2.1.83-86)

- **v2.1.86+**: Native read deduplication — disable `read_cache.py` hook if redundant
- **v2.1.86+**: @ file mentions no longer JSON-escaped — ~5-15% savings on file-heavy sessions
- **v2.1.84+**: Idle-return /clear conflicts with Smart Compaction — use /compact instead
- **v2.1.83+**: Auto-compact circuit breaker — stops after 3 failures, manual /compact resets it
- **v2.1.85+**: Conditional hooks with `if` field — add `"if": "tool_uses"` to PostToolUse hook

---

## Quality Checklist

- [ ] Coordination folder created
- [ ] All 6 audit agents dispatched in parallel
- [ ] Synthesis completed with tiered plan
- [ ] Findings presented clearly
- [ ] User consent before any file changes
- [ ] Backups created before modifications
- [ ] Verification run after changes
- [ ] Results quantified (tokens + cost)
- [ ] Model routing instructions checked/added (4L)
- [ ] Version-aware optimizations checked (4O)

---

## Error Handling

| Issue | Response |
|-------|----------|
| CLAUDE.md not found | Skip to skills audit |
| MEMORY.md not found | Skip this optimization |
| No skills directory | Setup is minimal. Focus on CLAUDE.md + MCP |
| User says 'skip verification' | Skip. Recommend running /cost before and after |
| Backup is empty/missing | Warn, do not modify files without explicit confirmation |
| File write fails mid-implementation | Restore from backup. Present restore command |
| Synthesis output missing | Show raw audit findings instead |
