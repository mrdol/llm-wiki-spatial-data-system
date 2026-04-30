---
title: Grubel-Lloyd Intra-Industry Trade Index
type: estimator
created: 2026-04-21
updated: 2026-04-21
sources: [pagoulatos1975.pdf]
tags: [estimator, index, intra-industry-trade]
---

Bounded estimator of intra-industry trade intensity computed from exports and imports for the same commodity category.

## Definition

For commodity or industry `i`:

`Bi = ((Xi + Mi) - |Xi - Mi|) / (Xi + Mi) * 100`

where:
- `Xi`: exports of `i`
- `Mi`: imports of `i`

## Interpretation

- `Bi = 0`: one-way trade only (net specialization).
- `Bi = 100`: perfectly balanced two-way trade.
- Intermediate values: partial overlap of exports and imports.

## Data Requirements

- Harmonized product classification (e.g., SITC code and revision).
- Consistent period and valuation basis for `Xi`, `Mi`.
- Industry-level mapping for aggregate analyses.

## Assumptions and Caveats

- Sensitive to aggregation level (possible aggregation bias).
- Does not separately identify product quality ladders or firm-level differentiation.
- Should be accompanied by metadata about code granularity and partner coverage.

## Metadata Fields Recommended

- `formula`
- `unit` (percentage points)
- `value_range` ([0, 100])
- `classification_level` (e.g., SITC 3-digit)
- `partner_scope`
- `aggregation_risk_flag`

## Related Pages

- [[pagoulatos1975_two_way_trade]]
- [[pagoulatos1975_methodology_to_metadata]]
