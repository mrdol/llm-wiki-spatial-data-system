---
title: SVM
type: estimator
created: 2026-04-29
updated: 2026-04-29
sources: [ISLRv2_corrected_June_2023.pdf]
tags: [estimator, svm, kernel, classification, regression, hyperparameters]
---

Support vector machine estimator family for margin-based classification and support vector regression.

## Summary

SVM is a standalone candidate estimator for classification or regression on feature matrices. It can use spatial or temporal variables as engineered predictors, but it is not inherently a spatial or spatio-temporal estimator.

## Estimator Family

- Family: support vector machines
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Evidence status: background support from [[islr2_statistical_learning]]

## Model Equation

Canonical classification decision function:

`f(x) = sign(sum_i alpha_i y_i K(x_i, x) + b)`

Support vector regression uses an epsilon-insensitive loss around a regression function.

Where:

- `K(x_i, x)` is a kernel function
- `alpha_i` are support-vector weights
- `C` controls margin violation penalty
- `epsilon` controls the insensitive tube for regression

Evidence status: `background_supported`.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| [[islr2_statistical_learning]] | background | General SVM reference for classification, kernels, margin, and tuning |

## Data Structures It May Fit

- Tabular cross-sections
- Engineered panel features
- Spatial datasets with coordinates, distances, neighborhood summaries, or eigenvectors as predictors
- Spatio-temporal datasets after lag/window feature engineering

## Compatible Variable Typologies

- Candidate `Y`: binary, categorical, continuous
- Candidate `X`: continuous, categorical after encoding, spatial features, temporal features, lagged features
- Not ideal for: raw geometry, raw timestamps, very large dense datasets without approximation

## Main Use Cases

- Binary classification
- Multiclass classification through wrapper strategies
- Support vector regression
- Baseline comparison against tree-based, boosting, and spatial estimators

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `C` | Margin penalty | yes | background_supported | Core regularization parameter |
| `kernel` | Feature-space transformation | yes | background_supported | Linear, polynomial, RBF, etc. |
| `gamma` | RBF/poly kernel scale | yes | background_supported | Tune with `C` |
| `degree` | Polynomial kernel degree | later | background_supported | Only for polynomial kernels |
| `epsilon` | SVR insensitive tube | yes | background_supported | Regression only |
| `class_weight` | Imbalance correction | later | implementation_supported | Classification only |

## Cross-validation Policy

The cross-validation design is external to this fiche.

SVM requires feature scaling inside each training fold to avoid leakage from validation/test data.

## Diagnostics To Inspect

- Support-vector count
- Margin behavior
- Sensitivity to feature scaling
- Calibration if probabilistic outputs are needed
- Performance under spatial or temporal blocked validation

## Failure Modes

- Leakage from scaling before splitting
- Poor scalability on very large dense datasets
- Kernel overfitting
- Weak performance if spatial or temporal structure is not represented in features

## Dataset Compatibility Notes

SVM is plausible for tabular datasets after preprocessing. It becomes spatial or spatio-temporal only through engineered predictors and validation design.

## Related Pages

- [[rnn]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[variable_typology]]
- [[data_leakage]]
