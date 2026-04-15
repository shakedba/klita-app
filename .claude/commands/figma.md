# Figma Design-to-Code

Translate Figma designs into production-quality code. Bridge the gap between design and implementation.

## Reading a Figma Design

When given a Figma link or screenshot:

1. **Identify the component type** — is this a new component, a variant of an existing one, or a page layout?
2. **Extract design tokens** — spacing, colors, typography, border-radius, shadows
3. **Map to the design system** — which existing components can be reused? What needs to be built new?
4. **Check all states** — default, hover, active, focus, disabled, loading, empty, error

## Design Token Extraction

Read design values and map to code:

| Design Value | Tailwind | CSS Variable |
|-------------|---------|-------------|
| 8px gap | `gap-2` | `var(--spacing-2)` |
| #3B82F6 | `text-blue-500` | `var(--color-primary)` |
| 16/24 type | `text-base leading-6` | — |
| 4px radius | `rounded` | `var(--radius-sm)` |

## Component Implementation Checklist

- [ ] Matches design at 1x and 2x pixel density
- [ ] All interactive states implemented (hover, focus, active, disabled)
- [ ] All data states implemented (loading, empty, error, success)
- [ ] Responsive: works at mobile (375px), tablet (768px), desktop (1280px)
- [ ] Accessible: ARIA labels, keyboard navigation, focus visible
- [ ] Uses design system tokens — no hardcoded values
- [ ] Matches spacing grid (4px or 8px base)

## Figma Code Connect

When setting up Figma Code Connect for a component library:

```ts
// Button.figma.ts
import figma from "@figma/code-connect"
import { Button } from "./Button"

figma.connect(Button, "https://www.figma.com/file/.../Button", {
  props: {
    label: figma.string("Label"),
    variant: figma.enum("Variant", {
      Primary: "primary",
      Secondary: "secondary",
      Destructive: "destructive",
    }),
    disabled: figma.boolean("Disabled"),
  },
  example: ({ label, variant, disabled }) => (
    <Button variant={variant} disabled={disabled}>
      {label}
    </Button>
  ),
})
```

```bash
# Publish Code Connect
npx @figma/code-connect publish --token $FIGMA_ACCESS_TOKEN
```

## Handoff Workflow

1. Designer shares Figma link with "Dev mode" access
2. Check "Inspect" panel for exact values (don't eyeball)
3. Export assets (SVGs, images) at 1x and 2x
4. Implement component in isolation (Storybook or standalone page)
5. QA against Figma design side-by-side
6. Flag any design issues before finalizing

## Common Pitfalls

- Implementing from a screenshot instead of the actual Figma file — missing specs
- Ignoring the design system and hardcoding values
- Not implementing error/empty/loading states — they're in the design, find them
- Using px instead of rem for typography — breaks user font preferences

## Source

[VoltAgent/awesome-agent-skills — Figma](https://github.com/VoltAgent/awesome-agent-skills)
