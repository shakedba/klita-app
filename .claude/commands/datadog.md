# Datadog Monitoring & Observability

Set up monitoring, dashboards, alerts, and APM tracing for production systems.

## Instrumentation

### Node.js / TypeScript
```ts
// Initialize at app entry point — before any imports
import tracer from 'dd-trace'
tracer.init({
  service: 'my-service',
  env: process.env.NODE_ENV,
  version: process.env.APP_VERSION,
  logInjection: true,   // correlate logs with traces
  runtimeMetrics: true,
})

// Custom spans
const span = tracer.startSpan('operation.name', {
  childOf: tracer.scope().active(),
})
span.setTag('user.id', userId)
try {
  // your code
} finally {
  span.finish()
}
```

### Custom Metrics (StatsD)
```ts
import { StatsD } from 'hot-shots'
const dogstatsd = new StatsD({ globalTags: { env: process.env.NODE_ENV } })

// Counter
dogstatsd.increment('api.request.count', 1, { endpoint: '/api/users' })

// Histogram (for latency)
dogstatsd.histogram('api.response.time', durationMs, { endpoint: '/api/users' })

// Gauge
dogstatsd.gauge('queue.depth', queueLength)
```

## Alert Templates

### High Error Rate
```yaml
Alert: API Error Rate > 1%
Query: sum:trace.web.request.errors{service:my-service}.as_rate() / 
       sum:trace.web.request.hits{service:my-service}.as_rate() > 0.01
Evaluation: last 5 minutes
Notify: #engineering-alerts @pagerduty
Message: |
  Error rate is {{value}}% on {{service}}.
  Runbook: https://notion.so/runbook/high-error-rate
```

### High Latency (p95)
```yaml
Alert: p95 Latency > 2s
Query: p95:trace.web.request.duration{service:my-service} > 2000
Notify: #engineering-alerts
```

### Low Disk Space
```yaml
Alert: Disk Usage > 85%
Query: avg:system.disk.in_use{*} by {host} > 0.85
```

## Dashboard Structure

A good service dashboard includes:

1. **Golden Signals** (top row)
   - Request rate (rpm)
   - Error rate (%)
   - p50 / p95 / p99 latency
   - Saturation (CPU, memory)

2. **Business Metrics** (second row)
   - Key product events (signups, orders, etc.)
   - Funnel drop-off rates

3. **Infrastructure** (third row)
   - Host CPU/memory
   - DB query time
   - Queue depth
   - Cache hit rate

4. **Logs** (bottom)
   - Error log stream
   - Slow query log stream

## Log Format (JSON structured)

```ts
// Use a structured logger — Datadog parses JSON automatically
import pino from 'pino'
const logger = pino({
  level: 'info',
  base: { service: 'my-service', env: process.env.NODE_ENV },
})

logger.info({ userId, action: 'login', duration: 120 }, 'User logged in')
logger.error({ err, requestId }, 'Payment failed')
```

## Source

[VoltAgent/awesome-agent-skills — Datadog](https://github.com/VoltAgent/awesome-agent-skills)
