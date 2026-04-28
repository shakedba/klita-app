# Experimentation-Driven Development

## Overview

This skill guides building features with A/B testing methodologies, emphasizing frameworks from Ronny Kohavi and practices from Netflix/Airbnb. It covers experiment design, metric selection, statistical significance, and feature flag architecture for data-driven development.

## Core Components

**HITS Framework** structures experiments through:
- **Hypothesis**: Clear belief statement about expected outcomes
- **Implementation**: Feature flags and sample sizing
- **Test**: Running with guardrail monitoring
- **Ship or Stop**: Decision based on results

**Metric Strategy** requires:
- One primary metric tied directly to business value
- Guardrail metrics preventing unintended consequences
- Statistical rigor (95% confidence, 80% power)

**Feature Flags** enable:
- Gradual rollouts from small percentages to full deployment
- Instant rollback capability
- Safe production testing

## Practical Guidance

The decision tree advises experimenting when changes affect core metrics, involve risk, or carry uncertain impact. Common pitfalls include stopping tests early, lacking guardrails, running too many variants simultaneously, and ignoring external factors.

Real-world applications span Netflix's 250+ concurrent experiments, Airbnb's booking algorithm testing with multi-metric validation, and Stripe's flag-behind-every-feature approach.

## Key Principle

Trust intuition to form hypotheses, but rely on data for final decisions. This balances creative thinking with empirical validation in product development.
