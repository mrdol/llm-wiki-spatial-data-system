---
title: SHAP Spatial Effects
type: concept
created: 2026-06-04
updated: 2026-06-04
sources:
  - wiki/papers/li_2022_shap_xgboost_spatial_effects.md
tags: [concept, shap, xgboost, spatial-effects, interpretability]
---

# SHAP Spatial Effects

SHAP spatial effects refers to using local feature-attribution methods to
interpret spatial patterns learned by machine-learning models. In the current
project, the concept is mainly useful for comparing XGBoost-style models with
spatial statistical models such as SLM and MGWR.

## KG Use

The concept should connect papers and methods where:

- SHAP or another local interpretation method is used on a spatial dataset;
- the interpretation is compared with spatial autocorrelation or spatial
  heterogeneity models;
- code/data repositories expose reproducible spatial machine-learning
  workflows.

## Related Pages

- [[li_2022_shap_xgboost_spatial_effects]]
- [[gradient_boosted_trees]]
- [[mgwr]]
- [[spatial_regression]]
