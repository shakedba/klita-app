# Vercel Storage Expert Guidance

Expert guidance on Vercel's storage ecosystem: Blob, Edge Config, and Marketplace integrations (Neon, Upstash, Supabase, Prisma, MongoDB, Convex, Turso).

## Critical Migrations

| Deprecated | Replacement |
|-----------|-------------|
| `@vercel/postgres` | `@neondatabase/serverless` with drizzle-orm. Run: `vercel integration add neon` |
| `@vercel/kv` | `@upstash/redis` with `Redis.fromEnv()`. Run: `vercel integration add upstash` |

## Storage Decision Matrix

| Use Case | Solution |
|----------|---------|
| File uploads (images, docs) | Vercel Blob |
| Feature flags / A/B config | Edge Config (ultra-low latency) |
| Relational data | Neon (serverless Postgres) |
| Full-stack BaaS | Supabase |
| Type-safe ORM | Prisma + Neon/Supabase |
| Key-value / sessions / cache | Upstash Redis |
| Real-time sync | Convex |
| Edge SQLite | Turso |
| Vector embeddings | Neon pgvector or Supabase |

## Key Capabilities

**Blob Storage**
- Fast file uploads with public/private access
- `put()`, `get()`, `del()`, `list()` API

**Edge Config**
- Ultra-low latency (~1ms) reads at the edge
- Ideal for feature flags, redirects, A/B test config
- Use `@vercel/edge-config` SDK

**Neon (Postgres)**
- Serverless, autoscaling Postgres
- Use `@neondatabase/serverless` + `drizzle-orm`
- Supports connection pooling via Neon's proxy

**Upstash Redis**
- Serverless Redis, pay per request
- `Redis.fromEnv()` picks up env vars automatically

## Build-Time Safety

Use lazy initialization patterns — don't initialize DB clients at module level (causes build failures in serverless):

```ts
// ❌ Module-level init (breaks builds)
const db = drizzle(process.env.DATABASE_URL)

// ✅ Lazy init
function getDb() {
  return drizzle(process.env.DATABASE_URL!)
}
```

## Source

[vercel/vercel-plugin](https://github.com/vercel/vercel-plugin/tree/main/skills/vercel-storage)
