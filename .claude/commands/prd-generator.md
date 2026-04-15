# PRD Generator

Generate a complete Product Requirements Document from a feature idea or brief.

## Output Structure

Produce a full PRD in this format:

---

# PRD: [Feature Name]

**Status:** Draft  
**Author:** [PM]  
**Last updated:** [date]  
**Target release:** [quarter]

---

## 1. Problem Statement

*What user problem are we solving? Why does it matter now?*

- **User pain:** [specific frustration or unmet need]
- **Business impact:** [revenue, retention, acquisition angle]
- **Why now:** [market timing, data trigger, strategic reason]

## 2. Goals & Success Metrics

| Goal | Metric | Target | Timeframe |
|------|--------|--------|-----------|
| [e.g. Reduce support tickets] | [e.g. Ticket volume] | [e.g. -30%] | [e.g. 90 days post-launch] |

**Non-goals:** [explicitly list what this feature will NOT do]

## 3. User Stories

```
As a [user type],
I want to [action],
So that [outcome].

Acceptance criteria:
- [ ] Given [context], when [action], then [result]
- [ ] ...
```

## 4. Proposed Solution

*High-level description. No implementation details yet.*

[2-3 paragraphs describing the UX and behavior]

### User Flow
1. User lands on [screen]
2. User [action]
3. System [response]
4. ...

### Edge Cases
- [What happens if X]
- [What happens if Y]

## 5. Scope

### In Scope (MVP)
- [ ] [Feature component 1]
- [ ] [Feature component 2]

### Out of Scope (Future)
- [Nice-to-have deferred]

## 6. Dependencies & Risks

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|-----------|
| [e.g. API rate limits] | Medium | High | [Cache + queue] |

**Dependencies:** [APIs, teams, infra, legal/compliance]

## 7. Open Questions

- [ ] [Decision needed from stakeholder X]
- [ ] [Technical feasibility question for eng]

---

## How to Use

Provide the feature idea or brief, and I will fill in all sections. I will ask clarifying questions for any section I cannot confidently complete without more information.
