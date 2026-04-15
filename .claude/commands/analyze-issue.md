# Analyze GitHub Issue

Fetch a GitHub issue and produce a structured implementation spec ready to hand off to engineering.

## Process

### 1. Fetch Issue
```bash
gh issue view <number> --json title,body,labels,comments,assignees,milestone
```

### 2. Produce Implementation Spec

Output the following:

---

## Issue #[N]: [Title]

**Labels:** [bug | feature | improvement]  
**Priority:** [critical | high | medium | low]  
**Effort estimate:** [XS | S | M | L | XL]

### Problem Summary
[1-2 sentences: what is broken or missing, and why it matters]

### Root Cause / Context
[What part of the system is involved. Reference specific files/components/APIs if identifiable from the issue.]

### Acceptance Criteria
- [ ] Given [context], when [action], then [result]
- [ ] [Edge case handled]
- [ ] [Error state handled]

### Relevant Files
- `[path/to/file.ts]` — [why it's relevant]
- `[path/to/component.tsx]` — [why it's relevant]

### Implementation Approach
[Brief description of the recommended fix or approach. Flag if multiple approaches exist and which is preferred.]

### Risks & Notes
- [Regression risk: does this touch shared code?]
- [Dependency: does this require another issue first?]
- [Testing: what test coverage is needed?]

### Out of Scope
[What the fix should NOT change — prevents scope creep]

---

## Rules

- Search the codebase to find relevant files before producing the spec
- Do not propose a solution if the root cause is unclear — flag it as "needs investigation" instead
- If the issue lacks reproduction steps, note that as a blocker
