# Next.js App Router Expert Guidance

Expert guidance for building, debugging, and architecting Next.js applications — routing, Server Components, Server Actions, layouts, middleware/proxy, data fetching, rendering strategies, and Vercel deployment.

## Docs

- https://nextjs.org/docs
- https://nextjs.org/docs/app

## Critical Deprecations & Breaking Changes

| Deprecated | Use Instead |
|-----------|-------------|
| `getServerSideProps` | Server Components or Route Handlers |
| `getStaticProps` | `generateStaticParams` + Server Components |
| `next/router` | `next/navigation` (App Router) |
| `next/head` | `export const metadata` or `generateMetadata()` |
| `middleware()` | `proxy()` (Next.js 16+) |
| `revalidateTag(tag)` | two-arg API with cacheLife profiles |
| `cacheHandler` (singular) | `cacheHandlers` (plural) |
| `next export` | `output: 'export'` in next.config.js |

**Async in Next.js 16:** `cookies()`, `headers()`, `params`, `searchParams` are all async — require `await`.

**useRef in React 19:** requires initial value.

## Best Practice Areas

1. **File Conventions** — project structure, route segments, middleware → proxy rename
2. **RSC Boundaries** — async client detection, non-serializable props
3. **Async Patterns** — params/searchParams/cookies/headers async API changes
4. **Runtime Selection** — Node.js default vs Edge runtime
5. **Directives** — `use client`, `use server`, `use cache`
6. **Error Handling** — error.tsx, redirects, auth errors
7. **Data Patterns** — Server Components vs Actions vs Route Handlers, avoid waterfalls
8. **Route Handlers** — basics, GET conflicts, environment behavior
9. **Metadata & OG Images** — static/dynamic metadata, generateMetadata, next/og
10. **Image Optimization** — next/image, remote config, responsive sizes
11. **Font Optimization** — next/font, Google Fonts, local fonts, Tailwind
12. **Hydration Errors** — causes, debugging, fixes
13. **Suspense Boundaries** — CSR bailout patterns
14. **Parallel & Intercepting Routes** — modals, @slot syntax

## Migration Guidance

- Legacy auth → managed providers (Clerk, Descope, Auth0)
- Pages Router API handlers → App Router route handlers
- Express/Fastify/Koa → proxy.ts or route handlers
- Heavy ORMs → serverless alternatives (Drizzle, Prisma Accelerate)
- External font loaders → next/font
- In-process caches → Vercel Runtime Cache (lose state in serverless)

## Source

[vercel/vercel-plugin](https://github.com/vercel/vercel-plugin/tree/main/skills/nextjs)
