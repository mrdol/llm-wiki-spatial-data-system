---
title: Data Leakage
type: concept
created: 2026-04-29
updated: 2026-04-29
sources: []
tags: [concept, validation, leakage, cross-validation]
---

Validation failure where information from validation or test data influences training.

## Definition

Data leakage occurs when preprocessing, feature construction, spatial proximity, temporal ordering, or duplicated units allow the model to indirectly see validation or test information during training.

## Spatial And Temporal Cases

- nearby spatial neighbors split across train and test
- future observations used to predict past observations
- scaling or imputation fitted before splitting
- lag features constructed using validation periods
- duplicated entities across folds

## Related Pages

- [[spatial_panel]]
- [[spatiotemporal_data]]
- [[variable_typology]]
