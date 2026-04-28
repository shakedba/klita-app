# Security Audit

Comprehensive security review of code changes. Based on Trail of Bits methodology.

## Audit Checklist

### Authentication & Authorization
- [ ] All routes/endpoints require authentication where expected
- [ ] Authorization checks happen server-side, not just client-side
- [ ] JWT/session tokens validated on every request (not just on login)
- [ ] Password reset flows use time-limited, single-use tokens
- [ ] Admin endpoints restricted to admin roles
- [ ] Row-level security (RLS) policies correct for multi-tenant data

### Injection Vulnerabilities
- [ ] SQL: parameterized queries everywhere — no string concatenation into queries
- [ ] Command injection: no `exec()`/`shell_exec()` with user input
- [ ] XSS: user content sanitized before rendering (`dangerouslySetInnerHTML` flagged)
- [ ] Path traversal: file paths validated and sandboxed
- [ ] SSRF: outbound URLs validated against allowlist

### Data Handling
- [ ] Secrets not logged (passwords, tokens, PII in logs)
- [ ] Sensitive data encrypted at rest (PII, payment data, credentials)
- [ ] API responses don't leak internal fields (use DTOs/serializers)
- [ ] Error messages don't expose stack traces or internal paths to end users
- [ ] PII only retained as long as required; deletion honored

### Cryptography
- [ ] No MD5/SHA1 for security-sensitive hashing — use SHA-256+ or bcrypt/argon2 for passwords
- [ ] No hardcoded secrets or keys in source code
- [ ] Secrets loaded from environment variables or secrets manager
- [ ] Constant-time comparison for token/MAC verification (no timing attacks)

### Dependencies
- [ ] `npm audit` / `pip-audit` / `cargo audit` run and HIGH+ addressed
- [ ] No packages with known critical CVEs
- [ ] Pinned or locked dependency versions (lockfile committed)

### API Security
- [ ] Rate limiting on auth endpoints (login, register, reset)
- [ ] CORS policy restrictive (not `Access-Control-Allow-Origin: *` in production)
- [ ] HTTPS enforced; HSTS header set
- [ ] Sensitive operations require re-authentication (e.g., change email/password)
- [ ] Webhook signatures verified before processing

### Infrastructure
- [ ] Environment variables not exposed to client-side bundles
- [ ] Debug/dev endpoints disabled in production
- [ ] File upload: type validation, size limits, stored outside web root

## Output Format

```
## Security Audit Results

### 🔴 Critical (fix before merge)
- [File:line] — Unparameterized SQL query: user input concatenated into query
  Fix: use prepared statements

### 🟠 High
- [File:line] — JWT not validated on /api/admin/* routes

### 🟡 Medium
- [File:line] — npm audit: 1 HIGH severity in lodash@4.17.20

### 🟢 Low / Informational
- Console.log outputs userId on line 45 — remove before prod

### ✅ Passing
- No hardcoded secrets found
- RLS policies reviewed — correct
- All SQL uses parameterized queries
```

## Source

Methodology from [Trail of Bits Security Skills](https://github.com/trailofbits/skills)
