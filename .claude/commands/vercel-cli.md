# Vercel CLI Expert Guidance

Expert guidance for deploying and managing projects on Vercel via the command-line (`vercel` or `vc`).

## Key Files

- `vercel.json` — project configuration
- `.vercel/project.json` — single project link
- `.vercel/repo.json` — monorepo link

## Project Linking

**When something goes wrong, check how things are linked first.**

| Command | Creates | Use For |
|---------|---------|---------|
| `vercel link` | `.vercel/project.json` | Single projects |
| `vercel link --repo` | `.vercel/repo.json` | Monorepos |

Commands must run from directories containing `.vercel` folders.

## Common Commands

```bash
vercel                    # Deploy
vercel dev                # Local development
vercel logs               # View deployment logs
vercel env pull           # Pull environment variables
vercel env add            # Add environment variable
vercel domains            # Manage custom domains
vercel inspect <url>      # Inspect deployment
```

## CI/CD

- Always use `--yes` flag in CI environments to avoid interactive prompts
- Use `VERCEL_TOKEN` environment variable, not hardcoded tokens
- Use `vercel link --yes` for non-interactive linking

## Common Anti-Patterns

- Using wrong link type in monorepos (project vs repo link)
- Auto-linking without explicit configuration
- Linking on incorrect team
- Forgetting `--yes` flag in CI
- Hardcoding tokens instead of using environment variables

## Source

[vercel/vercel-plugin](https://github.com/vercel/vercel-plugin/tree/main/skills/vercel-cli)
