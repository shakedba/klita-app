# Design Review

Automated UI/UX design review using specialized checks across visual consistency, accessibility, interaction quality, and brand alignment.

## Review Dimensions

### 1. Visual Consistency
- **Spacing:** Uses design system tokens? No magic numbers (`p-[17px]` instead of `p-4`)?
- **Typography:** Consistent font scale? Heading hierarchy correct?
- **Color:** Only palette colors used? Hardcoded hex values?
- **Iconography:** Single icon library? Consistent size/weight?
- **Border radius / shadows:** Consistent with design system?

### 2. Accessibility (WCAG 2.1 AA)
- **Color contrast:** Text meets 4.5:1 (normal) / 3:1 (large) ratio
- **Focus states:** Every interactive element has visible focus ring
- **Screen reader:** Semantic HTML, ARIA labels on icon buttons, alt text on images
- **Keyboard navigation:** Tab order logical? No keyboard traps?
- **Motion:** `prefers-reduced-motion` respected?

### 3. Responsive Behavior
- Works at: 375px (mobile), 768px (tablet), 1280px (desktop), 1920px (wide)
- Text doesn't overflow or truncate unexpectedly
- Touch targets ≥ 44×44px
- No horizontal scrollbar on mobile

### 4. Interaction Quality
- **Loading states:** Every async action has a loading indicator
- **Empty states:** Lists/tables have meaningful empty state copy + CTA
- **Error states:** Form errors inline, toast errors actionable
- **Success states:** Confirmation after destructive or important actions
- **Hover/active states:** All interactive elements have distinct hover

### 5. Copy & Content
- Active voice: "Save changes" not "Changes will be saved"
- Button labels specific: "Delete account" not "Confirm"
- Error messages include fix: "Email already in use — try logging in"
- No lorem ipsum, placeholder copy, or `[TODO]` in UI

### 6. Brand Alignment
- Tone matches product voice?
- Marketing claims on the page still accurate?
- New feature consistent with existing product narrative?

## Output Format

```
## Design Review: [Feature/Screen Name]

### ✅ Passing (X checks)
- Spacing uses design tokens throughout
- Focus states present on all interactive elements

### ❌ Issues (X found)
- [HIGH] src/components/Modal.tsx:34 — hardcoded color #3B82F6, use text-blue-500
- [MEDIUM] Empty state missing on user list (shows blank screen)
- [LOW] "Click here" link text — use descriptive label

### 📋 Summary
Total issues: X (Y high, Z medium, W low)
```
