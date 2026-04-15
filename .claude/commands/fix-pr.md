# Fix PR Comments

Fetch all unresolved review comments on the current branch's pull request and fix them.

## Process

1. **Identify the PR** — find the open PR for the current branch:
   ```bash
   gh pr view --json number,title,url,reviewDecision
   ```

2. **Fetch unresolved comments** — get all review threads that are not resolved:
   ```bash
   gh pr view --json reviews,reviewThreads
   ```
   Or via the API:
   ```bash
   gh api repos/{owner}/{repo}/pulls/{pr_number}/comments
   ```

3. **Triage comments** — for each unresolved comment:
   - Read the comment and understand the reviewer's intent
   - Locate the file and line referenced
   - Assess: is the feedback valid? If not, explain why in a reply before skipping.

4. **Fix each valid comment** — make targeted changes; don't refactor surrounding code unless the comment explicitly asks for it.

5. **Verify** — run tests and linting after all fixes:
   ```bash
   # Run whatever CI checks apply to this project
   ```

6. **Commit** — group all PR feedback fixes in a single commit:
   ```
   fix: address PR review comments
   
   - [brief description of each change]
   ```

## Rules

- Fix comments in order (top of file to bottom) to avoid conflicts
- Do not resolve threads yourself — the reviewer resolves them
- If a comment is ambiguous, fix the most reasonable interpretation and note the assumption in the commit message
- Never rewrite large sections to "clean up" while fixing PR comments — scope creep causes review churn
