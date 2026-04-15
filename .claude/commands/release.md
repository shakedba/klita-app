# Release

Prepare a versioned release: changelog, version bump, tag, and release notes.

## Process

### 1. Review Changes Since Last Release
```bash
git log $(git describe --tags --abbrev=0)..HEAD --oneline
```

### 2. Determine Version Bump (Semantic Versioning)

| Change Type | Bump |
|------------|------|
| Breaking API change | MAJOR (x.0.0) |
| New feature, backward-compatible | MINOR (0.x.0) |
| Bug fix, patch, docs | PATCH (0.0.x) |

### 3. Update CHANGELOG.md

Add a new section at the top (keep "Unreleased" section):

```markdown
## [x.y.z] — YYYY-MM-DD

### Added
- [New feature description] (#issue)

### Changed
- [Changed behavior] (#issue)

### Fixed
- [Bug fix description] (#issue)

### Removed
- [Removed feature] (#issue)
```

Rules for changelog entries:
- User-facing language, not implementation details
- Link issue/PR numbers
- Group by type (Added / Changed / Fixed / Removed / Security)
- No "misc", "various fixes", or vague entries

### 4. Bump Version

```bash
# Node.js
npm version patch|minor|major --no-git-tag-version

# Python (pyproject.toml)
# update version field manually or use: bump2version patch

# Other: update version in the relevant config file
```

### 5. Commit and Tag
```bash
git add CHANGELOG.md <version-file>
git commit -m "chore: release v<x.y.z>"
git tag -a v<x.y.z> -m "Release v<x.y.z>"
```

### 6. Generate Release Notes for GitHub
```bash
gh release create v<x.y.z> \
  --title "v<x.y.z>" \
  --notes "$(cat <<'EOF'
[paste the CHANGELOG section for this version]
EOF
)"
```

## Rules

- Never release directly from a feature branch — release from `main`/`master`
- Confirm all CI checks pass before tagging
- If breaking changes exist, update migration guide / README before releasing
