---
title: R_spaMM_blackcap_blackcap
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/R_spaMM_blackcap_blackcap.rds
tags: [dataset, r-package, spatial, point]
---

This data set is extracted from a study of genetic polymorphisms potentially associated to migration behaviour in the blackcap (Sylvia atricapilla). Across different populations in Europe and Africa, the average migration behaviour was found to correlate with average allele size (dependent on the number of repeats of a small DNA motif) at the locus...

## Description du jeu de donnees

- Topic: socio-demographie territoriale
- Observation unit: unite de recensement ou unite administrative
- Observed population: population territoriale documentee par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: This data set is extracted from a study of genetic polymorphisms potentially associated to migration behaviour in the blackcap (Sylvia atricapilla). Across different populations in Europe and Africa, the average migration behaviour was found to correlate with average allele size (dependent on the number of repeats of a small DNA motif) at the locus...
- Description source: package R `spaMM`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `migStatus`
- Candidate Y typology: continuous
- Candidate X variables: `means`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `latitude`, `longitude`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `migStatus` | `numeric` | continuous | [0, 2.5] | 0% |


> Selection Y/X (claude-sonnet-4-6) : migStatus (average migration behaviour score) is the biological response variable of interest, while means (average allele size at the genetic locus) is the genetic predictor hypothesized to correlate with migration behaviour. The column 'pos' appears to be a population index/identifier and is neither a meaningful target nor a useful covariate.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `means` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: migStatus ~ means + Matern(1|longitude+latitude)
- x_terms_pub: means
- y_term_pub: migStatus
- Reference publication: Mueller, J. C., Pulido, F., and Kempenaers, B. (2011) Identification of a gene associated with avian migratory behaviour. Proc. Roy. Soc. (Lond.) B 278, 2848-2856. Formule confirmee dans la doc officielle spaMM (fitme/corrHLfit/fixedLRT).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: migStatus ~ means + Matern(1|longitude+latitude)
- x_terms_used: means
- y_term_used: migStatus

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "migStatus ~ means + Matern(1|longitude+latitude)"
    response: "migStatus"
    predictors: ["means"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Mueller, J. C., Pulido, F., and Kempenaers, B. (2011) Identification of a gene associated with avian migratory behaviour. Proc. Roy. Soc. (Lond.) B 278, 2848-2856. Formule confirmee dans la doc officielle spaMM (fitme/corrHLfit/fixedLRT)."
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
    status: "confirmed"

  multivariate_constrained:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

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

- Dataset ID: `R_spaMM_blackcap_blackcap`
- Dataset name: spaMM::blackcap
- Source family: r-package
- Source: package R `spaMM` (version 4.6.65)
- Source URL: https://CRAN.R-project.org/package=spaMM
- Dataset DOI: none
- Publication DOI: 10.1098/rspb.2010.2567
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "migStatus ~ means + Matern(1|longitude+latitude)"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Mueller, J. C., Pulido, F., and Kempenaers, B. (2011) Identification of a gene associated with avian migratory behaviour. Proc. Roy. Soc. (Lond.) B 278, 2848-2856. Formule confirmee dans la doc officielle spaMM (fitme/corrHLfit/fixedLRT)."
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 14
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-23.601, 37.6197], y [-0.1671, 55.7559] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CeCILL-2
- License URL: https://CRAN.R-project.org/package=spaMM
- License open: yes
- Reproducibility status: available via package R `spaMM`
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
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CeCILL-2).

## Related Pages

- Source: package R `spaMM`
