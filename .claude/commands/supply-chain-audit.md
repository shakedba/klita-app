# Supply Chain Risk Audit

Assess third-party dependency risk before adding packages or as part of security reviews.

## When to Run

- Before adding a new npm/pip/cargo dependency
- During security review of a PR
- Quarterly audit of existing dependencies

## Checklist for a New Dependency

### 1. Reputation & Maintenance
```bash
# npm
npm info <package> | grep -E "(maintainers|downloads|version|homepage)"
# Check: last publish date, weekly downloads, number of maintainers

# Check GitHub
gh repo view <owner/repo> --json stargazerCount,updatedAt,openIssues,watchers
```

Questions:
- [ ] Is the package actively maintained? (last commit < 6 months)
- [ ] Does it have a real maintainer team, or a single person?
- [ ] Are there many open security issues?
- [ ] Does it have a security policy (`SECURITY.md`)?

### 2. Vulnerability Scan
```bash
# Check known CVEs
npm audit
pip-audit
cargo audit

# Check OSV database
osv-scanner --lockfile package-lock.json
```

### 3. Scope & Permissions
- Does this package need network access, filesystem access, or exec?
- Is the permission scope justified by the package's purpose?
- Does it phone home (telemetry)?

### 4. Transitive Dependencies
```bash
npm ls --all | wc -l   # How many transitive deps does it pull in?
```

A small utility that brings in 200 transitive dependencies is a red flag.

### 5. License Compatibility
```bash
npx license-checker --summary
```

- MIT, Apache 2.0, BSD: ✅ generally safe for commercial use
- GPL, AGPL: ⚠️ may require open-sourcing your code — verify with legal
- UNLICENSED or no license: ❌ do not use in production

### 6. Code Inspection (for high-risk packages)
```bash
# Download and inspect before installing
npm pack <package>
tar -xf <package>.tgz
cat package/index.js | grep -E "(exec|child_process|fetch|http|fs\.)"
```

Look for: obfuscated code, unexpected network calls, eval(), excessive permissions.

## Risk Scoring

| Factor | Low Risk | High Risk |
|--------|---------|---------|
| Downloads/week | >100K | <1K |
| Last publish | <3 months | >2 years |
| Maintainers | Team (3+) | Single person |
| Known CVEs | 0 | Any HIGH/CRITICAL |
| Transitive deps | <10 | >100 |

## Output Format

```
## Supply Chain Audit: <package-name>@<version>

Risk Level: LOW / MEDIUM / HIGH / CRITICAL

Findings:
- ✅ Actively maintained (last publish: 2 weeks ago)
- ✅ 2.3M weekly downloads — widely used
- ⚠️ Single maintainer — bus factor risk
- ❌ CVE-2024-XXXXX: HIGH severity in v<x.y.z> — fix available in v<a.b.c>

Recommendation: [APPROVE / APPROVE WITH CONDITIONS / REJECT]
Conditions: [upgrade to vX, pin to specific version, etc.]
```
