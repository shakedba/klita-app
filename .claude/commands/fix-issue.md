# Fix GitHub Issue

Analyze a GitHub issue and implement a fix end-to-end.

## Process

### 1. Fetch Issue Details
```bash
gh issue view <issue-number> --json title,body,labels,comments,assignees
```

### 2. Understand the Problem
- Read the full issue body and all comments
- Identify: what is broken or missing? What is the expected behavior?
- Note any reproduction steps, error messages, or screenshots mentioned

### 3. Locate Relevant Code
- Search the codebase for files, functions, and components related to the issue
- Trace the execution path from entry point to the failing behavior
- Identify the root cause — don't fix symptoms

### 4. Implement the Fix
- Make the minimal change that resolves the issue
- Do not refactor unrelated code in the same PR
- Follow existing patterns and conventions in the affected files

### 5. Write or Update Tests
- Add a test that would have caught this bug (regression test)
- If the issue is a missing feature, add tests covering the new behavior
- Run the full test suite to verify nothing is broken

### 6. Verify Quality
- Run linting and type checks
- Test the fix manually if the issue involves UI or user-facing behavior

### 7. Commit with Clear Message
```
fix: <short description of what was broken>

Fixes #<issue-number>

- Root cause: <what was wrong>
- Fix: <what was changed and why>
```

## Rules

- Always link the issue number in the commit message
- If the fix requires a design decision, comment on the issue before implementing
- If the issue is a duplicate or won't-fix, say so with reasoning instead of implementing
