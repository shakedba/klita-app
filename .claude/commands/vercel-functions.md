# Vercel Functions Expert Guidance

Expert guidance for Serverless Functions, Edge Functions, Fluid Compute, streaming, Cron Jobs, and runtime configuration on Vercel.

## Function Types

| Type | Cold Start | Duration | Best For |
|------|-----------|----------|---------|
| Serverless (Node.js) | 800ms–2.5s | up to 800s | General APIs, DB access |
| Edge (V8) | <1ms globally | 25s | Low-latency, simple logic |
| Bun (Beta) | Fast | — | CPU-bound work (~28% latency reduction) |
| Rust (Beta) | Native | — | Maximum performance |

## Fluid Compute

Unified execution model with:
- Optimized concurrency
- Extended durations (300s default, 800s max)
- Active CPU pricing
- Background processing (`waitUntil` / `after`)
- Bytecode caching

## Validation Rules

- Use named HTTP methods (`GET`, `POST`) not default exports
- Use Web API `Request`/`Response` not Pages Router types
- Use Vercel AI SDK not direct AI provider SDKs
- Long-running/polling → use Workflow instead
- No local filesystem writes → use Vercel Storage
- No in-process memory caches → use Runtime Cache
- No manual retry logic → use Workflow DevKit
- No Express.js → use Next.js route handlers or Web API handlers

## Streaming

Zero-config streaming for both Serverless and Edge runtimes. Essential for AI applications.

## Cron Jobs

Schedule via `vercel.json`:

```json
{
  "crons": [{
    "path": "/api/cron/cleanup",
    "schedule": "0 0 * * *"
  }]
}
```

Verify cron requests using `CRON_SECRET` authorization header.

## Configuration

All settings via `vercel.json` (Note: `now.json` deprecated, remove by March 31, 2026).

## Instance Sizes

- Standard: 1 vCPU, 2 GB RAM
- Performance: 2 vCPU, 4 GB RAM

## Common Pitfalls

- DB connection cold starts — use connection pooling
- Edge runtime limitations — no Node.js APIs
- Bundle size — tree-shake heavy dependencies
- Environment variables — always `process.env.VAR` not hardcoded

## Timeout Limits

- Default (all plans): 300s
- Pro/Enterprise extended: 800s

## Source

[vercel/vercel-plugin](https://github.com/vercel/vercel-plugin/tree/main/skills/vercel-functions)
