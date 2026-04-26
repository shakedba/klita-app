# React View Transitions

Guide for implementing smooth animations using React's View Transition API without third-party libraries.

## Core Component

The `<ViewTransition>` wrapper automatically assigns unique names and triggers `document.startViewTransition` behind the scenes — you never call it directly.

**Animation Triggers:** Only `startTransition`, `useDeferredValue`, or `Suspense` activate animations. Regular state updates don't animate.

## Five Priority Patterns (implement in order)

1. **Shared elements** — communicate "going deeper" (hierarchical navigation)
2. **Suspense reveals** — communicate "data loaded"
3. **List identity** — communicate "same items, new arrangement"
4. **State changes** — appearing/disappearing elements
5. **Route changes** — full page transitions

## Animation Styles by Context

| Context | Approach |
|---------|----------|
| Hierarchical navigation | Type-keyed directional slides (`nav-forward`/`nav-back`) |
| Lateral navigation | Bare transitions or `default="none"` (no depth implied) |
| Suspense reveals | Enter/exit string props for content arrival |
| Background refresh | `default="none"` (silent animation) |

## Transition Types

Use `addTransitionType()` to tag transitions so different `<ViewTransition>` components react contextually. Map types to CSS classes for directional animations that respond to navigation direction.

## Browser Support

- Chromium 111+
- Firefox 144+
- Safari 18.2+
- Graceful degradation on unsupported browsers

## Critical Rule

`<ViewTransition>` must wrap content directly — placing it inside another element suppresses animations.

## Next.js Note

React canary ships built-in — don't install it separately.

## Source

[vercel-labs/agent-skills](https://github.com/vercel-labs/agent-skills/tree/main/skills/react-view-transitions)
