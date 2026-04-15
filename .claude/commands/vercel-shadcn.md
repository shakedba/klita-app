# shadcn/ui Expert Guidance

Guidance for building deliberate, high-signal, consistent interfaces with shadcn/ui in the Vercel design ecosystem.

## Core Concept

shadcn/ui is not a traditional component library. The CLI copies component source code directly into your project — you own it, modify it, no import from a package.

## Essential CLI Commands

```bash
# Always use -d (defaults) for non-interactive init
npx shadcn@latest init -d

# Add components
npx shadcn@latest add button
npx shadcn@latest add card table badge

# Discover available components
npx shadcn@latest list
npx shadcn@latest search <term>

# Access inline docs
npx shadcn@latest docs <component>
```

## Key Technical Details

- **Theming:** CSS Variables using OKLch color space
- **Primitives:** Radix UI (February 2026: unified `@radix-ui` package, not individual `@radix-ui/react-*`)
- **Alternative primitives:** Base UI supported
- **Config:** `components.json` — registry, alias, theming options
- **Dark mode:** Class-based toggle (`dark` class on `<html>`)

## Composition Recipes

| UI Pattern | Components |
|-----------|-----------|
| Settings page | Tabs + Card |
| Data dashboard | Card + Badge + Table |
| CRUD table | Table + DropdownMenu + Sheet |
| Global search | Command + Dialog |
| Confirmation | AlertDialog |
| Notifications | Toast / Sonner |

## Known Gotchas

- **Geist font + Tailwind v4:** breaks with `@theme inline` — check compatibility
- **Avatar `size` prop:** doesn't exist — use Tailwind classes (`w-8 h-8`)
- **Radix unified package:** don't install individual `@radix-ui/react-*` packages (deprecated)

## Source

[vercel/vercel-plugin](https://github.com/vercel/vercel-plugin/tree/main/skills/shadcn)
