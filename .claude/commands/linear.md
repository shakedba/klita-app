# Linear Project Management

Create, update, and manage Linear issues and projects directly from Claude Code.

## Prerequisites

```bash
# Linear CLI or MCP server must be configured
# Set your Linear API key:
export LINEAR_API_KEY=lin_api_xxxxx
```

## Common Operations

### Create an Issue
```
Create a Linear issue:
- Title: [clear, actionable title]
- Team: [Engineering / Design / Product]
- Priority: [Urgent / High / Medium / Low]
- Labels: [bug / feature / improvement / tech-debt]
- Description: [full context, steps to reproduce, acceptance criteria]
- Assignee: [team member]
- Cycle: [current sprint if applicable]
```

### Triage a Bug Report
When given a bug description, produce:
1. **Title** — concise, in format: `[Component] Brief description of bug`
2. **Priority** — based on user impact and frequency
3. **Labels** — `bug` + affected area
4. **Description** using this template:
   ```
   ## Problem
   [What's broken and who it affects]
   
   ## Steps to Reproduce
   1. 
   2.
   
   ## Expected Behavior
   
   ## Actual Behavior
   
   ## Environment
   - Browser/OS/Version:
   
   ## Possible Fix
   [If known]
   ```

### Create a Feature Issue
```
## Overview
[1-2 sentences: what we're building and why]

## User Story
As a [user type], I want [action] so that [outcome].

## Acceptance Criteria
- [ ] 
- [ ] 

## Design
[Link to Figma or description]

## Technical Notes
[Implementation guidance, affected files, dependencies]

## Out of Scope
[What this issue does NOT include]
```

### Update Issue Status
When completing work, update the issue:
- Move to **In Review** when opening a PR
- Link the PR to the issue
- Move to **Done** after merge and verification

### Write a Project Update
For weekly project status:
```
## Week of [date]

**Status:** 🟢 On track / 🟡 At risk / 🔴 Off track

**Progress:**
- Completed: [list]
- In progress: [list]

**Blockers:**
- [blocker] — Owner: [name] — ETA: [date]

**Next week:**
- [planned items]
```

## Source

[VoltAgent/awesome-agent-skills — Linear](https://github.com/VoltAgent/awesome-agent-skills)
