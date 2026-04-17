# /pricing — Pricing Strategy Design

Design a pricing strategy grounded in value delivery, competitive positioning, and customer willingness to pay.

## Invocation

```
/pricing [describe your product and current pricing situation]
/pricing [upload competitive analysis or pricing data]
/pricing                   # asks you about your product
```

## Key Insight

Pricing is the most powerful lever for revenue growth — a 1% improvement in pricing typically has 3–4x the impact of a 1% improvement in customer acquisition. Value-based approaches outperform cost-plus methods.

## Workflow

### Step 1: Context Understanding

Gather:
- Product details and core value proposition
- Current pricing (if any) and why it was set
- Market trigger (launch, reposition, competitive pressure, growth)
- Customer profiles and segments
- Constraints (contracts, competitive parity, margin floor)

### Step 2: Model Analysis

Evaluate models for fit using **pricing-strategy** skill:

| Model | Best For | Example |
|-------|---------|--------|
| Flat-rate | Simple, predictable | Basecamp $99/mo |
| Per-seat | Team collaboration | Slack |
| Usage-based | Infrastructure, APIs | AWS |
| Tiered (Free/Pro/Enterprise) | Broad market | Most SaaS |
| Freemium | Network effects | Dropbox |
| Freemium + usage | Platform products | Twilio |
| Value-based | High-impact enterprise | Consulting tools |

### Step 3: Competitive Benchmarking

- Research 3–5 competitors
- Map tier structures and price points
- Identify category pricing patterns
- Spot gaps and differentiation opportunities

### Step 4: Willingness-to-Pay Assessment

- Van Westendorp price sensitivity analysis
- Value-based anchoring (what outcome does the product deliver?)
- Quantify customer value: time saved, revenue generated, risk reduced

### Step 5: Strategy Recommendation

```
## Pricing Strategy: [Product]

### Recommended Model
[Model name and rationale]

### Value Metric
[What you charge for — seats, usage, outcomes]

### Tier Structure
| Tier | Price | Target | Key Features |
|------|-------|--------|-------------|
| Free | $0 | [segment] | [features] |
| Pro | $X/mo | [segment] | [features] |
| Enterprise | Custom | [segment] | [features] |

### Competitive Positioning
[How pricing compares to 3-5 competitors]

### Willingness-to-Pay Estimate
[Range with validation method]

### Key Assumptions to Validate
1. [Assumption]
2. [Assumption]

### Migration Plan
[If repricing existing customers]

### Revenue Projections
[CAC, LTV, break-even at key price points]
```

### Step 6: Next Steps

- "Should I **design A/B tests** for these price points?"
- "Want me to **build a monetization strategy** with multiple revenue streams?"
- "Should I **create a pricing page** outline?"

## Notes

- Most products use hybrid models (e.g., freemium + upgrade, subscription + marketplace fees)
- Validate pricing assumptions early through customer conversations before full implementation
- Apply **pricing-strategy** skill for detailed model analysis
