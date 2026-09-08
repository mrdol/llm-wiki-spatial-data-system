---
title: Probit spatial (SAR/SEM)
type: estimator
created: 2026-09-07
updated: 2026-09-07
sources:
  - Martinetti, D. & Geniaux, G. (2017). Approximate likelihood estimation of
    spatial probit models. Regional Science and Urban Economics, 64, 30-45.
  - CRAN ProbitSpatial package (v1.1) documentation and vignette
tags: [estimator, spatial, probit, sar, sem, classification, binary, r-package]
---

Probit spatial is the project fiche for the binary spatial autoregressive and
spatial error probit models implemented by the R package `ProbitSpatial`
(Martinetti & Geniaux, 2017). It is the co-supervisor's own published method
for spatial probit estimation.

## Summary

`ProbitSpatial::ProbitSpatialFit()` fits a probit model with a spatial
component on the latent linear predictor:

- a binary response `Y in {0,1}`;
- spatial units or points with coordinates;
- a row-standardized spatial weights matrix `W` (class `dgCMatrix`);
- candidate explanatory variables `X`.

Two dependence structures (`DGP` argument) are supported and exposed in this
project: `"SAR"` (spatial lag in the latent index) and `"SEM"` (spatial error).
`"SARAR"` is documented by the package but not exposed here, consistent with
the SAR/SEM/SDM trio already handled elsewhere for continuous spatial
regression.

## Estimator Family

- Family: spatial probit (binary response, autoregressive or error spatial
  dependence in the latent variable).
- Project status: allowed, added 2026-09 alongside the binary/count response
  routing work.
- Implementation route: R-first through package `ProbitSpatial`.
- Related estimators: [[mgwrsar]] (continuous local/SAR analogue),
  spatialreg SAR/SEM (`sar_lag`/`sem_error`, continuous-response equivalent).

## Model Equation

Latent-variable formulation, SAR case:

`y*_i = rho * sum_j W_ij y*_j + x_i'beta + eps_i`, `y_i = 1[y*_i > 0]`, `eps ~ N(0,1)`

SEM case:

`y*_i = x_i'beta + u_i`, `u_i = lambda * sum_j W_ij u_j + eps_i`, `y_i = 1[y*_i > 0]`

`ProbitSpatialFit()` estimates `(beta, rho)` (SAR) or `(beta, lambda)` (SEM) by
conditional or full-likelihood approximation (`method = "conditional"` or
`"full-lik"`), chosen to keep estimation tractable at the sample sizes
typical of this project's benchmark datasets.

## Variantes Exposees Dans spatialtidymodels

Le package `spatialtidymodels` expose une specification generique
`probit_spatial_reg()` et deux noms d'estimateurs pour le benchmark
automatique, l'un par structure de dependance spatiale.

| Nom dans `spatialtidymodels` | Backend `ProbitSpatial` | Role dans le benchmark | Arguments spatiaux principaux | Tuning actuel |
|---|---|---|---|---|
| `sar_probit` | `ProbitSpatialFit(DGP="SAR")` via `sar_probit_reg()` | Probit spatial SAR, reponse binaire uniquement | `coords`, `W`, `k_neighbors`, `style`, `zero_policy` | `k_neighbors` |
| `sem_probit` | `ProbitSpatialFit(DGP="SEM")` via `sem_probit_reg()` | Probit spatial SEM, reponse binaire uniquement | `coords`, `W`, `k_neighbors`, `style`, `zero_policy` | `k_neighbors` |

Mode `parsnip` : `mode = "classification"` uniquement -- ces deux routes ne
sont jamais proposees pour un Y continu ou de comptage. `response_typology`
doit valoir `"binary"` pour que `benchmark_spatial()`/`fit_one_benchmark_estimator()`
les acceptent.

## Implementation Notes

- `ProbitSpatial` n'expose pas de methode `predict()` documentee dans son
  API publique pour l'usage hors-echantillon direct utilise ici ; la
  prediction est ecrite dans `probitspatial_pred_impl()`
  (`R/50-parsnip-probitspatial.R`), qui appelle `stats::predict()` (dispatch
  S3 vers `predict.ProbitSpatial`) avec `type = "response"`, `oos = TRUE` et
  la matrice `W` combinee train+test (`WSO`), suivant la formule BLUP de
  Goulard et al. (2017).
- Bug amont reel : `ProbitSpatialFit()`/`predict.ProbitSpatial()` echouent si
  le package `Matrix` n'est pas attache via `library()` (namespace seul ne
  suffit pas) -- contourne par `probitspatial_ensure_matrix_attached()`,
  appele au debut de `probitspatial_fit_impl()` et `probitspatial_pred_impl()`.
  Une correction pour `spatial_probit` de l'`spdep` (qui possède la fonction predict) pourrait être plus interessante.
- `W` doit etre de classe `dgCMatrix`, differemment du `listw` utilise par
  `spatialreg` -- construit par `probitspatial_build_W()`.

## Data Structures It May Fit

| Requirement | Expected form | Why it matters |
|---|---|---|
| Response `Y` | binary, coercible to `{0,1}` without loss | Probit link; a non-binary Y is rejected before fitting |
| Explanatory variables `X` | numeric or encoded variables | Linear index inside the probit link |
| Coordinates | two columns | Used to construct `W` via k-NN when no original weights are available |
| Spatial weights `W` | row-standardized `dgCMatrix` | Required for both SAR and SEM variants |
| Spatial support | points or areal units | Needed for distance/neighbor structure |

Not the first choice for continuous or count responses -- see [[gam]],
`sar_lag`/`sem_error`, or [[spboost]] for those.

## Hyperparameters To Optimize

| Hyperparameter | Package argument | Tune? | Notes |
|---|---|---|---|
| Dependance spatiale | `DGP` (`"SAR"` / `"SEM"`) | yes, choix de modele plutot que grille | Determine si la propagation spatiale est dans la moyenne latente (SAR) ou dans l'erreur (SEM) |
| Voisinage spatial | `k_neighbors` (construit `W` via `probitspatial_build_W()`) | yes | Seul hyperparametre expose au benchmark automatique actuellement |
| Standardisation de `W` | `style` (`"W"` habituellement) | rarement | Doit rester coherente avec `zero_policy` |
| Isolats | `zero_policy` | selon les donnees | Necessaire si des observations n'ont aucun voisin dans le k choisi |
| Methode d'estimation | `method` (`"conditional"` / `"full-lik"`) | non expose au benchmark, fixe cote implementation | `"full-lik"` plus couteux ; `"conditional"` privilegie pour les tailles typiques du catalogue |

## Diagnostics To Inspect

- Convergence de `ProbitSpatialFit()` (rho/lambda a l'interieur du domaine de stabilite, pas de message d'echec de l'optimiseur).
- Accuracy, AUC et deviance (log-vraisemblance binomiale) sur le pli de validation -- voir `make_metric_values()` dans `12-diagnose-spatial.R`.
- Sensibilite de rho/lambda a `k_neighbors` : une forte instabilite suggere un `W` mal specifie plutot qu'une vraie absence de dependance spatiale.
- Comparaison a un probit non spatial (`glm(family = binomial())`) comme baseline pour verifier que la composante spatiale apporte reellement de l'information.

## Failure Modes

- `spboost` was evaluated as an alternative binary-capable spatial boosting
  route and confirmed **not** extensible to binary/count: its internal
  `BSPA_SAR_ML` profiles rho via a Gaussian-specific log-likelihood and
  pre-filters the response as `(I-rho*W) %*% Y`, a continuous linear
  operation -- architecturally incompatible with a probit link, not a simple
  `family=` gap. Documented as a known limitation rather than worked around.
- Non-binary Y (more than 2 levels, or numeric values outside `{0,1}`) must
  raise before fitting rather than being silently coerced.
- Convergence/likelihood approximation quality depends on `k_neighbors` and
  sample size; not validated here at the very large end of the benchmark
  catalog.

## Cross-validation Policy

Same spatial cross-validation policy as the rest of the benchmark harness:
no naive random row-splits when observations are spatially dependent; `W`
must be reconstructed consistently for each train/test split (`build_knn_W()`
on train, then combined train+test for out-of-sample prediction).

## Related Pages

- [[mgwrsar]]
- variable typology
- modeling evidence
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
