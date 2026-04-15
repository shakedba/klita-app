# React Composition Patterns

Guide for refactoring components from boolean-prop patterns to composable architectures.

## Core Problem

Avoid components with excessive boolean props:

```tsx
// ❌ Boolean prop hell
<Card outlined shadowed compact clickable header footer />

// ✅ Composition
<Card>
  <Card.Header />
  <Card.Body />
  <Card.Footer />
</Card>
```

## Four-Tier Priority System

### 1. Component Architecture (highest impact)
- Eliminate boolean customization through composition
- Replace `isX`/`hasX` props with slot/children patterns
- Use explicit variant props (`variant="outlined"`) only when variants are truly enumerable

### 2. State Management
- Provider is the only place that knows how state is managed
- Decouple state from presentation via context
- Never pass state management callbacks through multiple component layers

### 3. Implementation Patterns
- Prefer children-based composition over render-props
- Use explicit variants for enumerable states
- Compound components share implicit context via React.createContext

### 4. React 19 APIs
- Use `use()` hook for context and promises
- Server Components for async data — no useEffect data fetching
- `useOptimistic` for instant UI feedback on mutations

## Key Principles

- "Provider is the only place that knows how state is managed"
- Composition scales; boolean props rot
- Shared context makes compound components feel native

## Source

[vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills/tree/main/skills/composition-patterns)
