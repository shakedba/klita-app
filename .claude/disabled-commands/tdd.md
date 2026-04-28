# Test-Driven Development

Guide Claude through strict Red → Green → Refactor cycles. No implementation code before a failing test exists.

## The Cycle

```
RED    → Write a failing test that defines desired behavior
GREEN  → Write the minimum code to make it pass (no more)
REFACTOR → Clean up without changing behavior; all tests must still pass
```

## Rules

- **Never write implementation before a test.** If asked to implement something, write the test first.
- **Minimum viable implementation.** Only write enough code to make the failing test pass.
- **One cycle at a time.** Complete RED → GREEN → REFACTOR before starting the next feature.
- **Refactor only on green.** Never refactor on a failing test suite.
- **Tests are the spec.** If behavior isn't tested, it doesn't need to exist yet.

## Process

### Step 1 — RED
1. Identify the smallest next behavior to implement
2. Write a test that fails for the right reason (not a compile error)
3. Confirm the test fails before proceeding

### Step 2 — GREEN
1. Write the simplest code that makes the test pass
2. Hardcoding is acceptable here — clarity over cleverness
3. Confirm all tests pass

### Step 3 — REFACTOR
1. Remove duplication
2. Improve naming and structure
3. Apply patterns where appropriate
4. Run tests after every change — stay green

## When to Apply

- New features from scratch
- Bug fixes (write a failing test that reproduces the bug first)
- Replacing or refactoring existing code

## Anti-patterns to Flag

- Writing implementation before tests ("we'll add tests later")
- Tests that can't fail (`assert True`)
- Testing implementation details instead of behavior
- Skipping the refactor step
- Giant test cases covering multiple behaviors
