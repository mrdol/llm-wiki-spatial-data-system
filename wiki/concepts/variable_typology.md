---
title: Variable Typology
type: concept
created: 2026-04-29
updated: 2026-04-29
sources: []
tags: [concept, variables, metadata, modeling]
---

Classification of candidate `Y` and `X` variables by modeling role and value type.

## Definition

Variable typology describes whether a variable is a response candidate, predictor, spatial feature, temporal feature, lagged feature, imputed feature, identifier, geometry, or timestamp.

For candidate `Y`, the main value types are:

- continuous
- binary
- count
- rate
- proportion
- presence_absence
- categorical
- ordinal
- duration
- unknown

## Why It Matters

Estimator eligibility depends on the target variable type. A continuous `Y` suggests regression; a binary `Y` suggests classification or binary-response models; a count `Y` may require count models; a presence/absence `Y` may require classification or spatial occurrence modeling.

## Related Pages

- [[catalog_registry_schema_v3]]
- [[estimator_fiche_schema_v1]]
- [[modeling_evidence]]
