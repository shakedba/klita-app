# Reproduce Issue

Create a minimal, isolated reproduction case from a bug report.

## Process

### 1. Understand the Bug
```bash
gh issue view <number>
# or paste the error / description
```
Identify:
- What triggers it (user action, API call, data shape)
- What the error message or wrong behavior is
- What environment it occurs in (browser, Node version, OS)

### 2. Build the Minimal Reproduction

Goal: the smallest possible code that demonstrates the bug.

Rules for a good repro:
- **No external dependencies** beyond what's necessary to show the bug
- **No authentication** — use hardcoded test data
- **Single file** if possible
- **Runnable immediately** — no complex setup

Start with the reported code path and strip everything unrelated until the bug still occurs.

### 3. Write an Automated Test

Convert the repro into a failing test:

```ts
// Bug: <short description>
// Reported in: #<issue-number>
test('should <expected behavior>', () => {
  // Arrange: minimal setup that triggers the bug
  // Act: the operation that fails
  // Assert: what SHOULD happen (this assertion will fail until fixed)
})
```

The test should:
- Fail with the current code
- Have a clear failure message that points to the bug
- Pass once the bug is fixed

### 4. Document the Environment

```markdown
## Reproduction

**Steps to reproduce:**
1. ...
2. ...

**Expected:** ...
**Actual:** ...

**Environment:**
- Node: x.x.x
- Browser: Chrome 12x / Safari 17
- OS: macOS / Linux / Windows
```

### 5. Commit the Failing Test

```
test: add failing reproduction for #<issue-number>

<Short description of the bug>
```

The failing test becomes the acceptance criterion for the fix.
