---
title: SVM
type: estimator
created: 2026-04-29
updated: 2026-06-04
sources:
  - ISLRv2_corrected_June_2023.pdf
  - Cortes and Vapnik 1995, Support-vector networks, doi:10.1007/BF00994018
tags: [estimator, svm, kernel, classification, regression, hyperparameters, paper-supported]
---

Support vector machines are margin-based estimators for classification and
regression. In this project they are non-spatial baselines unless spatial or
temporal information is encoded as features.

## Summary

SVMs learn a decision or regression function using support vectors and a kernel.
They can work well on moderate-size feature matrices, but they are sensitive to
feature scaling and can be expensive on large dense datasets.

## Estimator Family

- Family: kernel methods / margin-based learning.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: ISLR background plus Cortes and Vapnik reference.

## Model Equation

Classification decision function:

```math
f(x) = sign\left(\sum_i \alpha_i y_i K(x_i, x) + b\right)
```

Support vector regression uses an epsilon-insensitive loss around a regression
function.

## Data Structures It May Fit

- Binary or multiclass classification through wrappers.
- Continuous response with support vector regression.
- Spatial datasets after feature engineering.
- Spatio-temporal datasets after lag/window construction.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `C` | Margin violation penalty | yes | Core regularization parameter. |
| `kernel` | Feature-space mapping | yes | Linear, RBF, polynomial, etc. |
| `gamma` | RBF/poly kernel scale | yes | Tune jointly with `C`. |
| `degree` | Polynomial degree | later | Polynomial kernel only. |
| `epsilon` | SVR insensitive tube | yes | Regression only. |
| `class_weight` | Imbalance correction | later | Classification only. |

## Cross-validation Policy

Scaling must be fitted inside each training fold. For spatial/ST datasets, use
blocked validation and avoid preprocessing leakage.

## Diagnostics To Inspect

- Number and proportion of support vectors.
- Sensitivity to scaling.
- Margin behavior.
- Calibration if probabilities are needed.
- Spatial or temporal residual patterns.

## Failure Modes

- Leakage from scaling before splitting.
- Kernel overfitting with high `C` and high `gamma`.
- Poor scalability on large datasets.
- Weak spatial transfer if coordinates are used without blocked validation.

## Related Pages

- [[data_leakage]]
- [[rnn]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
