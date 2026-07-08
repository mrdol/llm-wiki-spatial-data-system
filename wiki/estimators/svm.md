---
title: SVM
type: estimator
created: 2026-04-29
updated: 2026-07-06
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

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| Cortes and Vapnik (1995) | paper_supported | canonical support-vector classifier |
| ISLR reference | paper_supported | pedagogical SVM/SVR framing |
| R implementation route | project_candidate | not currently wired in the spatial benchmark |

## Main Use Cases

- Non-spatial baseline for moderate-size feature matrices.
- Support vector regression when response is continuous.
- Classification baseline outside the current regression-only spatial benchmark.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `C` | Margin violation penalty | yes | Core regularization parameter. |
| `kernel` | Feature-space mapping | yes | Linear, RBF, polynomial, etc. |
| `gamma` | RBF/poly kernel scale | yes | Tune jointly with `C`. |
| `degree` | Polynomial degree | later | Polynomial kernel only. |
| `epsilon` | SVR insensitive tube | yes | Regression only. |
| `class_weight` | Imbalance correction | later | Classification only. |

## Secondary Hyperparameters

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| scaling parameters | feature normalization | no/later | implementation_supported | must be learned inside folds |
| probability calibration | calibrated probabilities | later | implementation_supported | classification only |
| cache / tolerance controls | solver runtime and convergence | no | implementation_supported | operational |

## Hyperparameter Interactions

- `C` and `gamma` jointly control margin flexibility for RBF kernels.
- Scaling interacts with every distance-based kernel.
- High-dimensional coordinate or lag features can make kernel tuning unstable.

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

## Minimal Tuning Workflow

1. Scale predictors inside each resampling split.
2. Start with linear or conservative RBF kernel.
3. Tune `C` and `gamma` jointly for RBF.
4. Use blocked validation for spatial datasets.
5. Inspect support-vector count and residual/spatial error patterns.

## Dataset Compatibility Notes

- Compatible `Y`: continuous for SVR, categorical for SVC.
- Compatible `X`: scaled numeric features.
- Spatial requirement: none; coordinates are just engineered features if used.
- Current benchmark note: SVM is allowed by policy but not currently wired into `benchmark_manual_test_2026-07.R`.

## Open Questions From Papers

- Whether SVM remains useful compared with tree baselines on the current spatial regression catalog.
- Which R backend should be standardized if SVM is added to the benchmark.

## Related Pages

- [[data_leakage]]
- [[rnn]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
