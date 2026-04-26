# Static Analysis

Run static analysis tools to find bugs, security issues, and code quality problems without executing code.

## Tool Selection by Language

| Language | Tools |
|----------|-------|
| JavaScript/TypeScript | ESLint, Semgrep, CodeQL |
| Python | Bandit, Semgrep, mypy, ruff |
| Go | staticcheck, gosec, golangci-lint |
| Rust | clippy, cargo-audit |
| Any | Semgrep (cross-language rules) |

## Running Semgrep (Cross-language)

```bash
# Install
pip install semgrep

# Run with security ruleset
semgrep --config=p/security-audit .

# Run with OWASP Top 10
semgrep --config=p/owasp-top-ten .

# Run with default ruleset for your language
semgrep --config=p/typescript .
semgrep --config=p/python .

# Custom rules
semgrep --config=./semgrep-rules/ .
```

## Running CodeQL (GitHub-native)

```bash
# Via GitHub CLI — triggers existing workflow
gh workflow run codeql-analysis.yml

# Or locally
codeql database create codeqldb --language=javascript
codeql database analyze codeqldb javascript-security-and-quality.qls \
  --format=sarif-latest --output=results.sarif
```

## Interpreting Results

For each finding:
1. **Understand the pattern** — what class of bug is it detecting?
2. **Verify it's real** — static analysis has false positives; check the actual code path
3. **Assess severity** — can this be exploited? What's the blast radius?
4. **Fix or suppress with justification:**
   ```ts
   // semgrep: disable next-line
   // Reason: this value is validated at the API boundary before reaching here
   ```

## Writing a Semgrep Rule

When you find a recurring pattern that should be caught:

```yaml
rules:
  - id: no-raw-sql-concat
    patterns:
      - pattern: |
          $DB.query("..." + $USER_INPUT)
    message: "SQL injection risk: use parameterized queries"
    languages: [javascript, typescript]
    severity: ERROR
    metadata:
      category: security
      cwe: CWE-89
```

## Output Format

```
Static Analysis Results — [date]

Tool: Semgrep (p/security-audit)
Files scanned: 142
Time: 8.3s

ERRORS (must fix):
  src/api/users.ts:67 — sql-injection: raw string concatenation in query
  src/auth/reset.ts:23 — hardcoded-secret: literal API key detected

WARNINGS (review):
  src/utils/fetch.ts:12 — ssrf: outbound URL not validated

INFO:
  3 rules matched 0 findings (clean)
```

## Source

Methodology from [Trail of Bits Security Skills](https://github.com/trailofbits/skills)
