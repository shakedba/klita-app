# The Shipping Decision Matrix

## When This Skill Activates

Use this skill when:
- Asking "is this ready to ship?"
- Deciding between shipping now vs iterating more
- Evaluating if "good enough" is good enough
- Balancing technical debt vs shipping speed
- Preventing perfectionism paralysis

## Core Frameworks

### 1. Reversible vs Irreversible Decisions (Jeff Bezos / Shreyas Doshi)

**Two-Way Doors (Reversible)**
- Can be undone or changed easily
- Low cost to reverse
- Learning > being right
- **Decision speed:** FAST (hours/days)
- **Process:** Ship and iterate

**One-Way Doors (Irreversible)**
- Hard or impossible to reverse
- High cost to undo
- Need to get it right
- **Decision speed:** SLOW (weeks/months)
- **Process:** Research, debate, decide carefully

```
Before shipping, ask:
1. "Can we reverse this decision?"
   - YES → Two-way door → Ship fast, iterate
   - NO → One-way door → Go slow, get it right

2. "What's the cost of being wrong?"
   - LOW → Ship and learn
   - HIGH → Research more
```

**Two-Way Doors (Ship Fast):** Button color, copy/messaging, UI layout, feature flag experiments
**One-Way Doors (Go Slow):** Database schema, API contracts, brand decisions, enterprise pricing, architecture

---

### 2. The Shipping Scorecard (Shreyas Doshi)

**The 5-Check System:**

- ✅ **Core Functionality Works** - Happy path functions end-to-end
- ✅ **Edge Cases Acceptable** - Errors handled gracefully, user can recover
- ✅ **Reversible Decision** - Can we undo or iterate?
- ✅ **Learning Value > Polish Value** - Will shipping teach us more than building more?
- ✅ **Risk Mitigated** - Monitoring in place, gradual rollout plan

**Scoring:**
- 5/5 → SHIP NOW
- 4/5 → SHIP TO SMALL GROUP
- 3/5 → ITERATE ONE MORE CYCLE
- <3/5 → NOT READY

---

### 3. Technical Debt vs Shipping Speed (Marty Cagan, Tobi Lutke)

**Ship with Tech Debt when:**
- Need user feedback to validate approach
- Debt is temporary and isolated
- User value >> debt cost

**Pay Down Debt First when:**
- Debt compounds and slows future changes
- Security/Privacy risk
- Breaking changes to platform/API

---

### 4. Gradual Rollout Strategy

**The Rollout Ladder:**
1. **Internal (1-10 users)** - 1-3 days
2. **Early Adopters (1-5%)** - 3-7 days
3. **Broader Beta (10-25%)** - 1-2 weeks
4. **General Availability (100%)** - Ongoing

## Key Quotes

> "Some decisions are consequential and irreversible—one-way doors. Make those slowly." — Jeff Bezos

> "The best PMs know when 'good enough' is good enough. Ship to learn, not to be perfect." — Shreyas Doshi

> "Technical debt isn't the enemy. The enemy is debt that compounds and slows you down." — Marty Cagan
