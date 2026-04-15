# Code Quality Check

Comprehensive automated quality and security check. Run before every PR.

## Checks to Run

### 1. Type Safety
```bash
# TypeScript
npx tsc --noEmit

# Python
mypy . --strict
```
Flag: `any` types, missing return types, unsafe casts.

### 2. Linting
```bash
# JS/TS
npx eslint . --ext .ts,.tsx,.js,.jsx

# Python
ruff check .
```

### 3. Formatting
```bash
npx prettier --check .
# or
npx biome check .
```

### 4. Tests
```bash
npm test -- --coverage
# or
pytest --cov --cov-report=term-missing
```
Flag: coverage below 80% on new code.

### 5. Security
```bash
# JS/TS dependencies
npm audit --audit-level=high

# Python
pip-audit

# Secrets scan
git secrets --scan
# or
trufflehog git file://. --only-verified
```

### 6. Dead Code
- Unused imports, variables, functions
- Unreachable code paths
- Commented-out code blocks older than the current sprint

### 7. Common Anti-patterns
- `console.log` / `print` / `debugger` statements left in
- Hardcoded secrets, API keys, or environment-specific values
- TODOs blocking the feature (flag; non-blocking TODOs are okay)
- Error swallowing (`catch (e) {}`)

## Output Format

```
### ✅ Passing
- TypeScript: no errors
- Tests: 94% coverage
- No secrets found

### ❌ Failing
- ESLint: 3 errors in src/api/auth.ts
  - Line 42: no-explicit-any
  - Line 67: no-unused-vars (userId)
- npm audit: 1 HIGH severity (lodash < 4.17.21)
  - Fix: npm install lodash@latest

### ⚠️ Warnings
- Coverage dropped 4% on src/utils/format.ts (now 71%)
- 2 TODO comments in new code
```

Fix all ❌ before merging. ⚠️ require acknowledgment.
