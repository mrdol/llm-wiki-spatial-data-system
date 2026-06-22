---
title: Gradient Boosted Trees
type: concept
created: 2026-06-04
updated: 2026-06-04
sources:
  - Chen and Guestrin 2016, doi:10.1145/2939672.2939785
  - Ke et al. 2017, LightGBM
tags: [concept, machine-learning, boosting, trees]
---

Gradient boosted trees build an additive ensemble of decision trees by
sequentially reducing a loss gradient.

## Modeling Relevance

In this project, XGBoost and LightGBM are strong tabular baselines. They can use
spatial features, lags or temporal windows, but they are not spatial estimators
unless the validation and diagnostics account for spatial dependence.

## Related Pages

- [[gam]]
- [[xgboost]]
- [[lightgbm]]
- [[random_forest]]
- [[data_leakage]]
