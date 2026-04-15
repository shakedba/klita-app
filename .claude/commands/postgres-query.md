# PostgreSQL Query Assistant

Write, optimize, and debug PostgreSQL queries safely. Read-only by default — no destructive operations without explicit confirmation.

## Query Safety Rules

- **Never run `DROP`, `TRUNCATE`, `DELETE`, or `UPDATE` without explicit user confirmation**
- Always use parameterized queries — no string interpolation with user input
- Include `LIMIT` on exploratory queries
- Use transactions for multi-step operations
- Test on dev/staging before production

## Common Query Patterns

### Explore Schema
```sql
-- List tables
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- Describe a table
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'users'
ORDER BY ordinal_position;

-- Show indexes
SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'users';
```

### Performance Analysis
```sql
-- Find slow queries (requires pg_stat_statements)
SELECT query, calls, mean_exec_time, total_exec_time
FROM pg_stat_statements
ORDER BY mean_exec_time DESC
LIMIT 20;

-- Explain a query
EXPLAIN (ANALYZE, BUFFERS, FORMAT TEXT)
SELECT * FROM orders WHERE user_id = $1 AND created_at > NOW() - INTERVAL '30 days';

-- Find missing indexes
SELECT relname, seq_scan, idx_scan,
       seq_scan - idx_scan AS seq_minus_idx
FROM pg_stat_user_tables
WHERE seq_scan > idx_scan
ORDER BY seq_minus_idx DESC;
```

### Common Data Patterns
```sql
-- Pagination (cursor-based, more efficient than OFFSET)
SELECT id, created_at, title
FROM posts
WHERE created_at < $cursor_timestamp
ORDER BY created_at DESC
LIMIT 20;

-- Aggregation with window functions
SELECT 
  user_id,
  date_trunc('week', created_at) AS week,
  COUNT(*) AS events,
  SUM(COUNT(*)) OVER (PARTITION BY user_id ORDER BY date_trunc('week', created_at)) AS cumulative
FROM events
GROUP BY user_id, week
ORDER BY user_id, week;

-- Upsert
INSERT INTO user_settings (user_id, key, value)
VALUES ($1, $2, $3)
ON CONFLICT (user_id, key) 
DO UPDATE SET value = EXCLUDED.value, updated_at = NOW();
```

### Index Creation
```sql
-- Standard index
CREATE INDEX CONCURRENTLY idx_orders_user_id 
ON orders(user_id);

-- Partial index (only index rows matching condition)
CREATE INDEX CONCURRENTLY idx_orders_pending 
ON orders(user_id, created_at) 
WHERE status = 'pending';

-- Composite index (column order matters — most selective first)
CREATE INDEX CONCURRENTLY idx_orders_user_created 
ON orders(user_id, created_at DESC);
```

## Query Review Checklist

- [ ] Uses parameterized queries (`$1`, `$2` — not string concatenation)
- [ ] Has `LIMIT` on unbounded queries
- [ ] Appropriate index exists for WHERE/ORDER BY columns
- [ ] No `SELECT *` in production code — select only needed columns
- [ ] Long-running queries use `statement_timeout`
- [ ] Transactions committed or rolled back in all code paths
- [ ] `CONCURRENTLY` used for index creation (avoids table lock)

## Source

[hesreallyhim/awesome-claude-code — read-only-postgres](https://github.com/hesreallyhim/awesome-claude-code)
