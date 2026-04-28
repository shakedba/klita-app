# AI-Native Startup Patterns

## Overview
This skill activates when building AI-first products, implementing prompt engineering, creating AI-native workflows, and scaling AI products efficiently.

## Core Frameworks

**Dan Shipper's 5-Product Playbook** emphasizes building rapidly with AI, testing immediately with actual users, iterating based on real-world usage, and prioritizing distribution alongside product development.

**2025 Prompt Engineering Best Practices** include structured outputs in JSON format, streaming implementation, retry logic design, flexibility for model switching, and aggressive caching strategies.

**Cost Optimization Strategies:**
- Caching handles approximately 80% of queries
- Route simple requests to smaller models, complex ones to larger models
- Group similar requests through batching
- Minimize tokens in prompts

## Implementation Patterns

Modern AI products should feature streaming for responsiveness, intelligent model selection based on query complexity, retry logic with exponential backoff, and structured JSON outputs. Cost optimization combines caching, smart model routing, batch processing, and prompt efficiency.

## Key Principles

"AI doesn't replace PMs. It makes small PM teams as powerful as large ones."

Build for the AI you'll have in 6 months, not the AI you have today.

## Startup Checklist

- [ ] Streaming implemented
- [ ] Retry logic with exponential backoff
- [ ] Model switching support
- [ ] Structured outputs (JSON)
- [ ] Caching implementation
- [ ] Prompt optimization
- [ ] Cost per user sustainable
- [ ] Latency acceptable
- [ ] Error rates monitored
