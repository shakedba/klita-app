# Run CI

Run the full CI check suite locally and fix all errors before pushing.

## Process

### 1. Detect the CI Stack
Check for CI configuration:
```bash
ls .github/workflows/ 2>/dev/null
cat package.json | grep -A5 '"scripts"'
cat Makefile 2>/dev/null | grep -E "^(test|lint|check|ci):"
```

### 2. Run in Standard Order

**Formatting** (fastest — fix first):
```bash
npx prettier --check . || npx biome check .
```

**Linting:**
```bash
npx eslint . --ext .ts,.tsx    # JS/TS
ruff check .                    # Python
golangci-lint run               # Go
```

**Type checking:**
```bash
npx tsc --noEmit               # TypeScript
mypy .                          # Python
```

**Tests:**
```bash
npm test                        # Jest / Vitest
pytest -x                       # Python (stop on first failure)
go test ./...                   # Go
```

**Build:**
```bash
npm run build
```

### 3. Fix All Failures

Fix in dependency order: formatting → linting → types → tests → build.  
Do not suppress errors with `// eslint-disable` or `# type: ignore` unless there is a documented reason.

### 4. Confirm Clean Pass
```bash
# Run the full suite one final time to confirm
npm run ci   # or whatever the project's combined CI command is
```

### 5. Report Results

```
CI Results:
✅ Formatting — clean
✅ Linting — clean  
✅ Types — clean
✅ Tests — 142 passed, 0 failed (coverage: 87%)
✅ Build — successful

Ready to push.
```

## Rules

- Fix, don't suppress
- Run the full suite even if one step fails — collect all errors before fixing
- If a test was already failing before your changes, flag it separately
