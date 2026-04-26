# Performance Optimization

Identify bottlenecks and propose targeted improvements. No premature optimization — measure first.

## Process

### 1. Measure First
Before changing anything, establish a baseline:
- What is slow? (page load, API response, query time, bundle size, render time)
- What metric matters? (p50, p95, p99 latency / LCP / TTI / bundle kb)
- Run profiling tools appropriate to the stack:
  ```bash
  # Browser: Chrome DevTools Performance tab, Lighthouse
  # Node.js: clinic.js, --prof flag, 0x
  # Bundle: next build --analyze, vite-bundle-visualizer, source-map-explorer
  # DB: EXPLAIN ANALYZE on slow queries
  ```

### 2. Find the Bottleneck
- Profile hot paths — don't guess
- Look for: N+1 queries, waterfall fetches, blocking I/O, large bundle imports, layout thrashing, missing indexes

### 3. Prioritize by Impact
Use the Decision Matrix before touching code:

| Issue | User Impact | Effort | Priority |
|-------|------------|--------|----------|
| N+1 query (100ms per req) | HIGH | LOW | Ship now |
| Missing DB index | HIGH | LOW | Ship now |
| Barrel file imports | MEDIUM | LOW | Ship now |
| Unvirtualized 500-row list | HIGH | MEDIUM | Plan next |
| Component re-renders | LOW | MEDIUM | Defer |

### 4. Apply Fixes (in order of impact)

**Database:**
- Add missing indexes on filtered/sorted columns
- Batch N+1 queries with joins or `dataloader`
- Add query result caching (Redis, React Query)

**Bundle:**
- Replace barrel imports with direct imports
- Dynamic import heavy components (`next/dynamic`, `React.lazy`)
- Tree-shake unused exports

**Frontend:**
- Memoize expensive computations (`useMemo`, `useCallback`)
- Virtualize long lists (`virtua`, `react-window`)
- Move data fetching to server (RSC, SSR)

**API:**
- Parallelize independent I/O with `Promise.all()`
- Add response caching with proper cache-control headers
- Stream large responses

### 5. Measure Again
Confirm the improvement matches expectations. Document before/after numbers in the PR.

## Rules

- Never optimize without a measurement baseline
- One optimization at a time — isolate the variable
- Leave a comment explaining *why* an optimization exists (it will look like unnecessary complexity without context)
