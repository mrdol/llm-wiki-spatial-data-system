---
title: GAMBoost
type: estimator
created: 2026-04-23
updated: 2026-06-04
sources:
  - GAMboosting.pdf
  - raw/paper/GAMboosting.pdf
  - data/manifests/papers/GAMboosting_formulas_extracted.json
  - Buehlmann and Hothorn 2007, Boosting Algorithms: Regularization, Prediction and Model Fitting
  - mboost R package documentation, https://search.r-project.org/CRAN/refmans/mboost/html/00Index.html
tags: [estimator, boosting, gam, hyperparameters, formulas, paper-extracted, paper-supported]
---

GAMBoost is an allowed estimator in the project registry. This fiche records the paper-supported functional-gradient boosting formulation extracted from `GAMboosting.pdf`.

## Summary

GAMBoost fits additive predictors by iteratively fitting a base procedure to pseudo-residuals, then updating the current predictor by a shrinked base-learner step. The paper formulation is more general than a single generalized additive model equation: it is a functional-gradient descent framework driven by a task-specific loss function.

The project should treat `GAMBoost` as a model-based boosting family rather than
as one fixed estimator. The relevant implementation route is close to the
`mboost` logic: response family, base learners, shrinkage, stopping iteration
and validation determine the usable model.

## Estimator Family

- Family: boosting for generalized additive components
- Project status: allowed by [[restricted_estimator_policy_v1]]
- Current evidence status: paper_formula_extracted_partial
- Formula source: `raw/paper/GAMboosting.pdf`
- Formula manifest: `data/manifests/papers/GAMboosting_formulas_extracted.json`

## Model Equation

The project-facing additive predictor can be summarized as:

```math
g(E[Y_i]) = \eta_i = \beta_0 + \sum_{j=1}^{p} h_j(x_{ij})
```

This is only a compact interpretation. The paper-supported canonical formulation is the functional-gradient boosting process below.

### Risk Target

```math
f^*(\cdot) = \arg\min_f \mathbb{E}[\rho(Y, f(X))]
```

The empirical loss is:

```math
C(f) = n^{-1}\sum_{i=1}^{n} \rho(Y_i, f(X_i))
```

### Initialization

```math
\hat{f}^{[0]}(\cdot) \equiv \arg\min_c n^{-1}\sum_{i=1}^{n}\rho(Y_i, c)
```

The PDF also documents the zero-offset variant:

```math
\hat{f}^{[0]}(\cdot) := 0
```

### Pseudo-Residuals

At boosting step `m`, fit the base procedure to negative gradients:

```math
U_i = -\frac{\partial}{\partial f}\rho(Y_i, f)\bigg|_{f=\hat{f}^{[m-1]}(X_i)}, \quad i = 1,\ldots,n
```

For squared-error regression, this reduces to:

```math
U_i = Y_i - \tilde{f}^{[m-1]}(X_i)
```

### Iterative Update

```math
\hat{f}^{[m]}(\cdot) = \hat{f}^{[m-1]}(\cdot) + \nu \cdot \hat{g}^{[m]}(\cdot)
```

with shrinkage:

```math
0 < \nu \leq 1
```

For componentwise linear base learners, the selected covariate is:

```math
\hat{j} = \arg \min_{1 \leq j \leq p} \sum_{i=1}^{n} (U_i - \hat{\beta}^{(j)} x_i^{(j)})^2
```

and the coefficient update is:

```math
\hat{\beta}^{[m]} = \hat{\beta}^{[m-1]} + \nu \cdot \hat{\beta}^{(\hat{s}_m)}
```

### Final Aggregation

The paper also records an aggregation view:

```math
\hat{f}_A(\cdot) = \sum_{m=1}^{M} \alpha_m \hat{g}^{[m]}(\cdot)
```

For AdaBoost-style classification:

```math
\hat{f}_{AdaBoost}(x) = \arg\max_{y \in \{0,1\}} \sum_{m=1}^{m_{stop}} \alpha^{[m]} I(\hat{g}^{[m]}(x) = y)
```

Evidence status: `paper_formula_extracted_partial`.

## Loss Functions

The PDF treats the loss function `rho` as central. The estimator fiche must not collapse GAMBoost to one loss.

| Task | Loss / target | Role |
|---|---|---|
| Squared-error regression | `rho(y, f) = |y - f|^2` | Regression loss; target is conditional mean. |
| L2 regression variant | `rho_{L_2}(y, f) = (1/2)|y - f|^2` | Squared-error gradient boosting. |
| L1 regression | `rho_{L_1}(y, f) = |y - f|` | Robust median-oriented regression. |
| Huber regression | `rho_{Huber}(y, f)` piecewise quadratic/linear | Robust regression. |
| Logistic classification | `rho_{log-lik}(\tilde{y}, f) = log_2(1 + exp(-2\tilde{y}f))` | Binary classification loss. |
| SVM-like classification | `rho_{SVM}(y, f) = [1 - \tilde{y}f]_+` | Margin/hinge loss. |
| Exponential loss | `rho_{exp}(y, f) = exp(-\tilde{y}f)` | AdaBoost-style classification. |
| Poisson/count model | `rho(y, f) = -yf + exp(f)`, with `f = log(lambda)` | Count response loss. |
| Survival/censoring variant | weighted observed loss using censoring weights | Censored response extension. |

## Reweighting And Resampling

The PDF includes a reweighted-data view of boosting. Initial weights are:

```math
w^{[0]} = 1/n, \quad i = 1,\ldots,n
```

AdaBoost-style classification error and learner weight:

```math
err^{[m]} =
\frac{\sum_{i=1}^{n} w_i^{[m-1]} I(Y_i \neq \hat{g}^{[m]}(X_i))}
     {\sum_{i=1}^{n} w_i^{[m-1]}}
```

```math
\alpha^{[m]} = \log\left(\frac{1 - err^{[m]}}{err^{[m]}}\right)
```

Weight update:

```math
\tilde{w}_i = w_i^{[m-1]}\exp(\alpha^{[m]} I(Y_i \neq \hat{g}^{[m]}(X_i)))
```

```math
w_i^{[m]} = \tilde{w}_i / \sum_{j=1}^{n}\tilde{w}_j
```

## Base Learners

The base procedure fits candidate learners to pseudo-residuals. The paper includes at least these forms:

- componentwise linear least-squares learner;
- cubic smoothing spline base learner;
- penalized/smooth base learner with smoothness parameter `lambda`;
- stagewise linear updates;
- kernel or smoothing procedures in later examples.

Example spline base learner:

```math
\hat{f}^{(j)}(\cdot) =
\arg\min_{f(\cdot)} \sum_{i=1}^{n}(U_i - f(X_i^{(j)}))^2
+ \lambda \int (f''(x))^2 dx
```

## Stopping And Complexity

The stopping iteration is explicitly represented as:

```math
m = m_{stop}
```

Effective degrees of freedom are tracked by:

```math
df(m) = trace(\mathbf{B}_m)
```

The PDF includes model-complexity and stopping criteria such as:

```math
AIC_c(m) = \log(\hat{\sigma}^2) + \frac{1 + df(m)/n}{(1 - df(m) + 2)/n}
```

```math
gMDL(m) = \log(S) + \frac{df(m)}{n}\log(F)
```

and task-specific AIC variants for classification.

## Paper Evidence Status

| Source | Status | Notes |
|---|---|---|
| `GAMboosting.pdf` | formulas extracted | 222 formulas extracted into the manifest. |
| `data/manifests/papers/GAMboosting_formulas_extracted.json` | available | Used to enrich risk, pseudo-residual, update, loss, reweighting, and stopping sections. |

## Data Structures It May Fit

- Candidate use: nonlinear but partially interpretable tabular modeling
- Candidate structure: cross-section, panel-derived features, or engineered spatio-temporal tables
- Response types: continuous, binary, count, censored/survival variants depending on loss implementation
- Evidence status: paper_supported_general_boosting

## Main Use Cases

- Additive nonlinear effects
- Interpretable smooth components
- Componentwise variable selection
- High-dimensional tabular modeling when only a subset of components should enter early
- Alternative to black-box boosting when additive structure matters

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| `mstop` | Number of boosting iterations / stopping step | yes | paper_supported | Main complexity control. |
| `nu` | Step length / shrinkage | yes | paper_supported | Paper states `0 < nu <= 1`; tune jointly with `mstop`. |
| `loss_function` | Selects regression, classification, robust, count, or survival objective | yes | paper_supported | L2, L1, Huber, logistic, SVM/hinge, exponential, Poisson-like losses appear in the PDF. |
| `baselearner_type` | Component/base procedure family | yes | paper_supported | Linear, spline, penalized, kernel/smoothing, or implementation-specific base learners. |
| `df` | Effective degrees of freedom | yes | paper_supported | Used in stopping/complexity criteria. |
| `lambda` | Smoothness or penalty parameter | yes | paper_supported | Appears in spline and penalized formulations. |
| `family` | Response distribution or task family | yes | paper_supported | Must align with selected loss. |
| `link_function` | Maps response mean/probability/rate to predictor scale | task-dependent | paper_supported | Logistic and Poisson-like examples imply task-specific links. |

## Secondary Hyperparameters

- component selection rule;
- base-learner degrees of freedom;
- spline penalty;
- maximum candidate interactions, only when implementation supports them;
- robust-loss threshold such as Huber `delta`;
- censoring-weight model for survival settings.

## Hyperparameter Interactions

- `mstop` and `nu` jointly control effective model complexity.
- `loss_function` determines pseudo-residuals and valid response types.
- `baselearner_type`, `df`, and `lambda` jointly control smoothness and interpretability.
- Stopping criteria such as AIC, AICc, gMDL, or validation error must be aligned with the selected loss.
- Component type determines what can be tuned downstream.

## Cross-validation Policy

The cross-validation design will be fixed by the project owner.

For GAMBoost, validation should tune at least `mstop`, `nu`, `loss_function`, and base-learner complexity. For spatial or spatio-temporal datasets, folds must respect leakage rules defined by the dataset profile.

## Diagnostics To Inspect

- Validation error by boosting iteration
- Selected components by iteration
- Component-level effects
- Effective degrees of freedom `df(m)`
- Loss-specific residual or pseudo-residual structure
- Stability of selected components
- Overfitting after `mstop`

## Failure Modes

- Overfitting with too many boosting iterations
- Underfitting with too small `mstop` or too restrictive base learners
- Loss function not aligned with target variable type
- Instability when highly correlated base learners compete
- Misleading interpretability if smoothness and stopping are not tuned jointly
- Leakage when spatio-temporal folds do not respect spatial or temporal dependence

## Minimal Tuning Workflow

1. Define response type and select a compatible loss.
2. Define candidate base learners.
3. Tune `mstop` and `nu`.
4. Tune smoothness and complexity controls (`df`, `lambda`, base-learner type).
5. Select stopping criterion or validation metric.
6. Inspect selected effects and pseudo-residual structure before model acceptance.

For spatial or spatio-temporal datasets, use spatial or blocked space-time
validation. GAMBoost can use spatial features, smooths, lags or coordinates, but
it is not spatially valid merely because those variables are present.

## Dataset Compatibility Notes

- Useful when interpretability of nonlinear effects matters.
- Strong for tabular datasets with candidate predictors that can be expressed as additive components.
- Can use panel-derived or spatio-temporal features after feature engineering.
- Spatial usefulness depends on whether spatial coordinates, spatial lags, regional identifiers, or spatial smooth base learners are included.
- Not a spatial model by default; spatial structure must be encoded through features or supported base learners.

## Open Questions From Papers

- Which exact implementation package will be used for the project workflow?
- Which loss functions are implemented in the selected package?
- Which base learners support spatial or spatio-temporal features?
- Which stopping criterion should be standardized for project comparisons: validation error, AIC, AICc, gMDL, or another metric?

## Related Pages

- [[gam]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
- [[spboost]]
