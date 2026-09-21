---
title: INLA
type: estimator
created: 2026-04-23
updated: 2026-09-18
sources:
  - OpitzINLA.pdf
  - Rue, Martino and Chopin 2009, Approximate Bayesian inference for latent Gaussian models by using integrated nested Laplace approximations
  - Lindgren, Rue and Lindstrom 2011, An explicit link between Gaussian fields and Gaussian Markov random fields: the stochastic partial differential equation approach
  - https://www.r-inla.org/
tags: [estimator, bayesian, spatial, latent-gaussian, spde, hyperparameters, paper-supported]
---

INLA is a deterministic approximate Bayesian inference framework for latent
Gaussian models. In this project it is relevant for spatial, areal,
geostatistical, hierarchical and spatio-temporal models where uncertainty and
latent structure matter.

## Summary

INLA approximates posterior marginals for latent Gaussian models without running
MCMC. The R-INLA ecosystem is especially important for spatial models because
SPDE formulations can represent continuous spatial fields through sparse
Gaussian Markov random fields.

## Estimator Family

- Family: approximate Bayesian inference for latent Gaussian models.
- Project status: allowed by [[restricted_estimator_policy_v1]].
- Evidence status: reference methodology and R-INLA project documentation.
- Related concepts: latent Gaussian model, GMRF, SPDE, areal random effects.

## Model Equation

Generic latent Gaussian model:

```math
y_i \mid \eta_i,\theta \sim p(y_i \mid \eta_i,\theta)
```

```math
\eta_i = \alpha + x_i^\top\beta + \sum_k u_k(i)
```

where the latent field is Gaussian conditional on hyperparameters:

```math
x \mid \theta \sim N(0, Q(\theta)^{-1})
```

INLA approximates posterior marginals for latent components and
hyperparameters.

## Spatial Formulations

| Formulation | Dataset type | Notes |
|---|---|---|
| ICAR/BYM/BYM2 | areal data | Requires spatial adjacency or neighborhood graph. |
| SPDE Matern field | point or areal with coordinates/mesh | Requires mesh, CRS and prior choices. |
| Spatial econometric latent effects | areal/panel | Possible when latent model is implemented. |
| Space-time latent effects | spatial panels or gridded time series | Requires careful temporal structure and validation. |

## Data Structures It May Fit

- Areal disease mapping or regional indicators.
- Point-referenced spatial observations.
- Spatial panels with repeated units.
- Count, binary, Gaussian and other likelihood families supported by R-INLA.

## Paper Evidence Status

| Source | Status | Use in fiche |
|---|---|---|
| Rue, Martino and Chopin (2009) | paper_supported | INLA approximation for latent Gaussian models |
| Lindgren, Rue and Lindstrom (2011) | paper_supported | SPDE/GMRF spatial field construction |
| R-INLA documentation | implementation_supported | software API and families/effects |

## Main Use Cases

- Bayesian spatial regression with explicit uncertainty.
- Areal random effects such as ICAR/BYM/BYM2.
- Point-referenced spatial fields via SPDE meshes.
- Spatio-temporal latent Gaussian models when temporal structure is real.

## Hyperparameters To Optimize

| Hyperparameter | Role | Tune? | Notes |
|---|---|---|---|
| `family` | Likelihood family | yes | Determined by response type. |
| `link` | Mean-response link | yes | Must match likelihood and interpretation. |
| spatial effect type | ICAR/BYM/SPDE/etc. | yes | Model-structure choice. |
| prior precision | Latent-effect shrinkage | yes | Must be recorded. |
| SPDE range prior | Spatial correlation scale | yes | Central for SPDE models. |
| SPDE variance prior | Field amplitude | yes | Record prior assumptions. |
| mesh resolution | Spatial discretization | yes | Accuracy-cost tradeoff. |
| temporal effect type | AR, RW, iid, interaction | yes if temporal | Only when time structure is real. |

## Secondary Hyperparameters

| Hyperparameter | Role | Tune? | Evidence status | Notes |
|---|---|---|---|---|
| integration strategy | INLA approximation settings | later | implementation_supported | usually keep defaults first |
| control predictor settings | fitted value / linear predictor controls | no/later | implementation_supported | output control |
| posterior sampling settings | simulation from posterior | no/later | implementation_supported | diagnostic/reporting |

## Hyperparameter Interactions

- Mesh resolution and SPDE priors jointly determine the effective spatial field.
- Priors and likelihood family must be documented together; priors are not neutral defaults.
- Areal adjacency quality directly affects ICAR/BYM-style effects.

## Cross-validation Policy

Use spatial or spatio-temporal validation, not only posterior fit criteria. WAIC,
DIC, CPO and posterior predictive checks are useful, but they do not replace
out-of-sample validation when the goal is prediction.

## Diagnostics To Inspect

- Posterior marginals and credible intervals.
- Prior sensitivity.
- WAIC/DIC/CPO where appropriate.
- Posterior predictive checks.
- Residual spatial autocorrelation.
- Mesh sensitivity for SPDE models.

## Failure Modes

- Treating prior choices as neutral.
- Mesh too coarse or too fine.
- Using areal adjacency without checking geometry/topology.
- Comparing models by information criteria only when prediction transfer is the goal.
- Applying spatial effects to data without reliable spatial support.

## Minimal Tuning Workflow

1. Identify response type and likelihood.
2. Define spatial support: coordinates, mesh or adjacency.
3. Fit a non-spatial baseline.
4. Add spatial latent structure.
5. Record priors, mesh/adjacency, diagnostics and validation design.

## Dataset Compatibility Notes

- Compatible `Y`: Gaussian, count, binary and other R-INLA-supported likelihoods.
- Compatible `X`: fixed effects plus spatial/temporal indexing fields.
- Spatial requirement: adjacency for areal models or coordinates/mesh for SPDE models.
- Current benchmark note: wired in as `inla_spde` in the modern
  `packages/spatialtidymodels/` package (`R/51-parsnip-inlaspde.R`,
  `inla_spde_reg()`/`inlabru::bru()`), not in the older, parallel
  `code/R/estimators/benchmark_manual_test_2026-07.R` harness (out of scope).
  First validated on a small synthetic SPDE dataset and on
  `paper_banff_stream_temperature` (N=110, point-referenced, `test_datasets`
  entry in `inst/metadata/estimators.json`).
- Validation: posterior criteria do not replace external spatial or space-time validation.

## Statut d'implementation actuel (2026-09-18)

- **Construit (Phase 1, 2026-09-14)** : champ spatial SPDE (Matérn continu,
  PC-priors via `INLA::inla.spde2.pcmatern()`), réponse gaussienne (continue),
  via `inlabru::bru()` (interface à base de composants, pas
  `INLA::inla()` + `inla.stack()` manuel). Wrapper `parsnip` complet
  (`inla_spde_reg()`, `inlaspde_fit_impl()`, `inlaspde_pred_impl()`,
  `register_inlaspde_reg()`), estimateur `inla_spde` dans
  `fit_one_benchmark_estimator()` et `inst/metadata/estimators.json`.
- **Construit (Phase 2, 2026-09-15)** : familles non-gaussiennes ajoutées à
  `inla_spde_reg()`/`inlaspde_fit_impl()` via un argument `family`
  (`"gaussian"`/`"binomial"`/`"poisson"`) et un argument `link` optionnel
  (seul `"cloglog"` est accepté pour `"binomial"`, vérifié empiriquement
  contre `inlabru::bru(..., control.family = list(link = ...))`). Dérivées
  automatiquement de `response_typology`/`glm_link` dans
  `fit_one_benchmark_estimator()`, exactement comme `ols`/`gam_spatial`.
  Motivé par la lecture directe de 3 papiers du corpus déjà validés qui
  utilisent réellement INLA en binomial/poisson :
  `paper_flapper_skate_presence` (Loca et al. 2025, binomial+cloglog),
  `paper_mistletoe_bird_abundance` (INLA négative-binomiale/Poisson) et
  `paper_goa_trawl_demersal` (Shelton et al. 2017, script R original des
  auteurs sur Dryad : binomial+gamma, delta-GLMM). `inla_spde_reg()` reste
  volontairement en `mode = "regression"` même pour le binaire — la
  prédiction retournée est une probabilité continue, pas une classe, même
  convention que `ols`/`gam_spatial` (pas de mode `"classification"` séparé
  comme pour `ProbitSpatial`). Validé de bout en bout sur les vraies fiches
  curées `paper_flapper_skate_presence` et `paper_mistletoe_bird_abundance`.
- **Construit (Phase 3, 2026-09-18)** : deux variantes, suivant le même
  patron que `mgwrsar`/`spboost` (un seul modèle `parsnip` enregistré,
  argument natif qui change le comportement au fit — pas de
  `set_new_model()` séparé) :
  - `inla_spde_st` : champ spatio-temporel séparable espace × AR1, via un
    nouvel argument `time` sur `inla_spde_reg()`/`inlaspde_fit_impl()` —
    `group=`/`control.group=list(model="ar1")` sur le terme `field()`
    (arguments confirmés dans `args(INLA::f)` avant d'écrire le code, pas
    supposés). Motivé par `paper_crane`, `paper_mistletoe_bird_abundance`
    et `paper_goa_trawl_demersal`, qui utilisent tous les trois un champ
    M(s,t) structuré par le temps. Une période absente de l'entraînement
    fait échouer la prédiction explicitement (pas d'extrapolation
    temporelle). Validé sur données réelles (`paper_crane`, échantillon de
    400 lignes sur les 12 630 — le fit complet serait lent mais
    fonctionnellement identique) : le fit confirme un hyperparamètre
    `GroupRho for field` réellement estimé, pas un pooling silencieux des
    périodes. Dans le harnais de CV (2026-09-21), la colonne temporelle se
    déclare par jeu : `spatial_dataset_spec(..., inla_time = "<colonne>")`
    (ou `benchmark_spatial(..., inla_time =)` en direct) ; elle est
    transmise aux folds et à l'ajustement final. Sans `inla_time`, seul
    `inla_spde_st` échoue (message explicite, fold par fold), les autres
    estimateurs du même appel tournent. Les jeux issus du registre
    (`benchmark_spatial_suite("nom")`) n'ont pas encore de champ « colonne
    temporelle » dans leurs métadonnées : ils ne peuvent pas lancer
    `inla_spde_st` sans passer par une `spatial_dataset_spec` explicite.
    La colonne de temps est retirée des effets fixes : si elle figure aussi
    dans la formule (ex. `Season` de mistletoe), elle n'y est plus
    covariable, seulement index AR1.
  - `inla_spde_group` : détection automatique d'un terme `(1 | groupe)`
    dans la formule (même détection que `gam_spatial`,
    `extract_group_re_terms()`), traduit en composant iid `inlabru`
    supplémentaire. Motivé par `paper_banff_stream_temperature` (HUC10) et
    `paper_mistletoe_bird_abundance` (observateur/région). Contourne
    `workflows::fit()` — `stats::model.frame()` ne comprend pas la syntaxe
    `(1 | groupe)`, même raison que `gam_spatial` ; erreur explicite si la
    formule ne contient aucun terme de groupe. Validé sur données réelles
    (`paper_banff_stream_temperature`, N=110, 5 niveaux HUC10) : hyperparamètre
    `Precision for HUC10` réellement estimé. Un niveau de groupe absent de
    l'entraînement à la prédiction n'est PAS traité comme une erreur —
    vérifié empiriquement, `predict.bru()` marginalise correctement sur le
    prior bayésien de l'effet iid.
  - Bug de fond trouvé et corrigé en chemin (pas spécifique à ces deux
    variantes, bénéficie à tout appelant futur) : `drop_formula_terms()`/
    `add_coords_to_formula()` reconstruisaient une formule via
    `term.labels` → `paste()` → `as.formula()`, ce qui perdait silencieusement
    les parenthèses protectrices d'un terme `(1 | groupe)` et le corrompait
    au reparse. Corrigé par un nouveau helper générique
    `protect_group_re_terms()`.
  - Bug de dispatch trouvé et corrigé (spécifique à `inla_spde_group`,
    qui contourne `workflows`) : charger `INLA` promeut `predict` en
    générique S4 (confirmé empiriquement, `isGeneric("predict")` devient
    `TRUE`), ce qui fait ignorer notre méthode S3 `predict.inla_spde_group_fit()`
    au profit de `predict.bru()` natif d'`inlabru` — `predict_vector_for_benchmark()`
    contourne ce dispatch explicitement plutôt que de le corriger
    globalement.
- **Différé** : BYM2/ICAR (aucune matrice d'adjacence précalculée dans le
  corpus de jeux curés — un seul jeu polygone `ready`+`package_include`, sans
  W), le modèle barrière `INLAspacetime` (aucune géométrie non convexe/côte/
  réseau hydrographique stockée), les vraisemblances binomiale négative et
  gamma (aucun routage `response_typology` existant pour ces deux familles —
  seuls continuous/binary/count existent dans le projet). Ces trois éléments
  restent bloqués par l'absence de données/infrastructure adaptées dans le
  corpus, pas par un choix de scope arbitraire — voir le plan
  "Étendre inla_spde : variante spatio-temporelle + effets aléatoires de
  groupe" pour le détail de cette analyse.

## Open Questions From Papers

- ~~Which INLA formulation should be the first benchmark route: BYM2, SPDE,
  or another latent spatial effect.~~ **Résolu** : SPDE d'abord — recensement
  du corpus (`wiki/datasets/fiches_datasets/`) : 376/380 fiches en géométrie
  POINT, 2 seulement en POLYGON (aucune avec W précalculé), 0 en LINE/réseau ;
  SPDE sur coordonnées ponctuelles est la seule formulation qui dessert
  immédiatement un nombre substantiel de jeux déjà curés.
- ~~How to standardize priors so results are comparable across datasets.~~
  **Résolu** : règle déterministe calculée depuis les données
  (`inla_spde_default_priors()`) — `prior.range = c(diagonale_bbox / 5, 0.5)`,
  `prior.sigma = c(ecart_type(y), 0.5)` (forme PC-prior standard, "weak
  default"), surchargeable par jeu via `prior_range`/`prior_sigma`.
- ~~How to expose INLA in the project without forcing a full `parsnip`
  wrapper immediately.~~ **Résolu** : un wrapper complet est nécessaire (INLA/
  inlabru n'ont pas de moteur `parsnip` natif, contrairement à MARS/XGBoost
  qui réutilisent le moteur natif de `earth`/`xgboost`), mais `inlabru::bru()`
  + `predict.bru(newdata=...)` (prédiction hors échantillon native) rendent ce
  wrapper nettement plus léger que celui de `ProbitSpatial`, qui doit
  reconstruire la prédiction à la main.

## Related Pages

- [[gam]]
- [[svc]]
- [[spatial_autocorrelation]]
- [[spatiotemporal_data]]
- [[restricted_estimator_policy_v1]]
- [[estimator_fiche_schema_v1]]
