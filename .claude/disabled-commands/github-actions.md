# GitHub Actions CI/CD

Write, debug, and optimize GitHub Actions workflows for CI/CD pipelines.

## Standard CI Workflow Template

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  ci:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Type check
        run: npx tsc --noEmit

      - name: Lint
        run: npx eslint .

      - name: Test
        run: npm test -- --coverage

      - name: Build
        run: npm run build
```

## Key Patterns

### Caching
```yaml
- uses: actions/cache@v4
  with:
    path: ~/.npm
    key: ${{ runner.os }}-node-${{ hashFiles('**/package-lock.json') }}
    restore-keys: |
      ${{ runner.os }}-node-
```

### Matrix Builds
```yaml
strategy:
  matrix:
    node-version: [18, 20, 22]
    os: [ubuntu-latest, windows-latest]
```

### Secrets
```yaml
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
  # Never hardcode secrets — always use ${{ secrets.* }}
```

### Conditional Steps
```yaml
- name: Deploy to production
  if: github.ref == 'refs/heads/main' && github.event_name == 'push'
  run: npm run deploy
```

### Reusable Workflows
```yaml
# Caller
jobs:
  call-ci:
    uses: ./.github/workflows/ci-reusable.yml
    with:
      node-version: '20'
    secrets: inherit
```

## Debugging Workflows

```bash
# View recent workflow runs
gh run list --limit 10

# Watch a run in real-time
gh run watch

# View logs for a failed run
gh run view <run-id> --log-failed

# Re-run failed jobs only
gh run rerun <run-id> --failed-only
```

## Security Best Practices

- **Pin actions to commit SHA** (not just tag) for third-party actions:
  ```yaml
  uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683  # v4.2.2
  ```
- **Minimal permissions** — set `permissions:` at job level, not workflow level
- **No `pull_request_target`** with untrusted code access to secrets
- **Audit third-party actions** before use — treat as code execution

## Review Checklist

- [ ] `concurrency` set to cancel stale PR runs
- [ ] `actions/checkout@v4` (not v2/v3)
- [ ] Dependencies cached to reduce run time
- [ ] Secrets accessed via `${{ secrets.* }}` only
- [ ] No `continue-on-error: true` masking failures
- [ ] Timeout set on long-running jobs (`timeout-minutes: 30`)

## Source

[VoltAgent/awesome-agent-skills — GitHub Actions](https://github.com/VoltAgent/awesome-agent-skills)
