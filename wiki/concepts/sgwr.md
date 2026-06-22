---
title: Similarity and Geographically Weighted Regression
type: concept
created: 2026-06-04
updated: 2026-06-04
sources:
  - wiki/papers/lessani_li_2024_sgwr.md
tags: [concept, sgwr, gwr, similarity]
---

# Similarity and Geographically Weighted Regression

Similarity and geographically weighted regression (SGWR) extends GWR by
combining geographic proximity with attribute similarity. It is useful when
nearby observations are not necessarily the most similar observations in the
feature space relevant to the process being modeled.

## KG Use

The concept should connect papers and formulas where:

- a geographic weight matrix is combined with a similarity weight matrix;
- a mixing parameter controls the balance between geography and similarity;
- AICc, CV or prediction metrics are used to select the balance.

## Related Pages

- [[lessani_li_2024_sgwr]]
- [[gwr]]
- [[mgwr]]
- [[spatial_heterogeneity]]
