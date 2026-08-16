---
title: R_surveillance_hagelloch_hagelloch
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_surveillance_hagelloch_hagelloch.rds
tags: [dataset, r-package, spatial, point]
---

Data on the 188 cases in the measles outbreak among children in the German city of Hagelloch (near Tübingen) 1861. The data were originally collected by Dr. Albert Pfeilsticker (1863) and augmented and re-analysed by Dr. Heike Oesterle (1992). This dataset is used to illustrate the ‘twinSIR’ model class in ‘vignette("twinSIR")’.

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Data on the 188 cases in the measles outbreak among children in the German city of Hagelloch (near Tübingen) 1861. The data were originally collected by Dr. Albert Pfeilsticker (1863) and augmented and re-analysed by Dr. Heike Oesterle (1992). This dataset is used to illustrate the ‘twinSIR’ model class in ‘vignette("twinSIR")’.
- Description source: package R `surveillance`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `event`, `Revent`
- Candidate Y typology: binary
- Candidate X variables: `start`, `stop`, `atRiskY`, `AGE`, `SEX`, `CL`, `household`, `nothousehold`, `c1`, `c2`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `id`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `event` | `numeric` | binary | {0, 1} | 0% |
| `Revent` | `numeric` | binary | {0, 1} | 0% |


> Note doc : number of cases in family

> **Note** - Fiche canonique fusionnee : l'objet `hagelloch.df` est une variante tabulaire integree dans cette fiche, pas une fiche dataset separee.

> Selection Y/X (claude-sonnet-4-6) : Dans un modèle twinSIR d'épidémie, 'event' (nouvelle infection) et 'Revent' (rétablissement) sont les variables réponse naturelles de l'analyse de survie/point process ; les covariables explicatives incluent l'âge, le sexe, la classe scolaire (CL), le nombre de contacts intra- et extra-ménage (household, nothousehold), les compteurs spatiaux de voisinage (c1, c2), ainsi que les variables de fenêtre temporelle (start, stop) et l'indicateur de risque (atRiskY) typiques du format counting-process. BLOCK, x.loc et y.loc sont des identifiants/coordonnées déjà exclus en amont ou redondants.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `start` | `numeric` | continuous | 0% |
| `stop` | `numeric` | continuous | 0% |
| `atRiskY` | `numeric` | binary | 0% |
| `AGE` | `numeric` | continuous | 0% |
| `SEX` | `factor` | categorical | 5.9% |
| `CL` | `factor` | categorical | 0% |
| `household` | `numeric` | continuous | 0% |
| `nothousehold` | `numeric` | continuous | 0% |
| `c1` | `numeric` | continuous | 0% |
| `c2` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: not_applicable - twinSIR (Neal & Roberts 2004, Biostatistics 5(2):249-261, DOI 10.1093/biostatistics/5.2.249) est un modele de hasard/intensite pour processus ponctuel epidemique (classe 'epidata'/twinSIR du package surveillance, cf. https://surveillance.r-forge.r-project.org/pkgdown/reference/twinSIR.html), pas une regression Y~X classique : la 'reponse' est la structure d'historique d'evenements SIR elle-meme (start/stop/atRiskY/event, construite par as.epidata() depuis hagelloch.df), pas une colonne scalaire. household + cox(AGE) sont les covariables du terme de hasard, pas des predicteurs d'un Y observable. N reel : 188 enfants (hagelloch.df), 56 foyers distincts (x.loc/y.loc) -- les 70500 lignes de l'objet 'epidata' hagelloch sont 188 enfants x 375 pas de temps de la fenetre a risque, pas 70500 observations spatiales independantes.
- x_terms_pub: household, cox(AGE)
- y_term_pub: pending
- Reference publication: Neal PJ, Roberts GO (2004) Statistical inference and model selection for the 1861 Hagelloch measles epidemic

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: event ~ start + stop + atRiskY + AGE + SEX + CL + household + nothousehold
- x_terms_used: start + stop + atRiskY + AGE + SEX + CL + household + nothousehold
- y_term_used: event

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "event ~ start + stop + atRiskY + AGE + SEX + CL + household + nothousehold"
    response: "event"
    predictors: ["start", "stop", "atRiskY", "AGE", "SEX", "CL", "household", "nothousehold"]
    role: "paper_main_specification"
    source_type: "published_or_manual_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_surveillance_hagelloch_hagelloch`
- Dataset name: surveillance::hagelloch
- Source family: r-package
- Source: package R `surveillance` (version 1.25.0)
- Source URL: https://CRAN.R-project.org/package=surveillance
- Dataset DOI: none
- Publication DOI: 10.1093/biostatistics/5.2.249
- Year: 2005

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "event ~ start + stop + atRiskY + AGE + SEX + CL + household + nothousehold"
  equation_family: regression
  model_family: "n/a"
  source_type: published_or_manual_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 70500
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [7.5, 280], y [5, 240] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=surveillance
- License open: yes
- Reproducibility status: available via package R `surveillance`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_non_continuous_response"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "route classification/binomiale/survie ou transformation continue explicite requise"
  reason: "La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel."
```

- Decision: not_ready_non_continuous_response
- Manque principal: route classification/binomiale/survie ou transformation continue explicite requise
- Raison: La variable reponse ou la formule n est pas une regression continue scalaire compatible avec le benchmark actuel.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: WARN - groupe de versions suspectes `hagelloch`; autres versions: R_surveillance_hagelloch_hagelloch.df
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `surveillance`
- Duplicate/version candidate: [[R_surveillance_hagelloch_hagelloch.df]]
