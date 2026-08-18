---
title: paper_nyc_tract_income_ssig
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_nyc_tract_income_ssig.rds
  - DataCite_2023_WhatDictatesIncomeIn_10_1057_s41599_023_0
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "What dictates income in New York City? SHAP analysis of income estimation based on Socio-economic and Spatial Information Gaussian Processes (SSIG)" (DOI 10.1057/s41599-023-01548-7).

## Description du jeu de donnees

- Topic: socio-economic
- Observation unit: observation spatiale du dataset "Tract-level and ZIP-level income (per-capita and median household), ACS 2015-2019 5-year via Census Reporter"
- Observed population: Modele Gaussian Process (noyau Matern-3/2) + SHAP pour estimer le revenu par tract/ZIP a partir de 10 variables socio-economiques ACS et des coordonnees du centroide
- Geographic context: Coordonnees reelles (centroides de tract, TIGER/Line 2023), CRS EPSG:4326.
- Temporal context: none (cross-sectional)
- Source description: What dictates income in New York City? SHAP analysis of income estimation based on Socio-economic and Spatial Information Gaussian Processes (SSIG)
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1057/s41599-023-01548-7
- Dataset DOI: none
- Source URL: https://api.censusreporter.org
- Local raw dir: `data/raw/papers/DataCite_2023_WhatDictatesIncomeIn_10_1057_s41599_023_0/`
- Local sf output: `data/final_datasets/sf/paper_nyc_tract_income_ssig.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `per_capita_income`, `median_household_income`
- Candidate Y typology: count, continuous
- Candidate X variables in local artifact: `ALAND`, `AWATER`, `UDG25`, `PGD25`, `Unemploy`, `Age65p`, `AgeU18`, `PopDensity`, `MaleShare`, `BlackShare`, `AsianShare`, `WhiteShare`
- Candidate X count in local artifact: 12
- Candidate X typology: continuous
- Published X variables from paper: proportion bachelor >=25 ans (UDG25), proportion diplome superieur >=25 ans (PGD25), taux de chomage (Unemploy), proportion >=65 ans (Age65p), proportion <18 ans (AgeU18), densite de population (PopDensity), proportion hommes (MaleShare), proportion Black/African American (BlackShare), proportion Asian (AsianShare), proportion White (WhiteShare), latitude/longitude du centroide (spatial info)
- Published X count: 11
- Coordinates (x, y - excluded from X candidates): `INTPTLON`, `INTPTLAT`
- Identifier columns (excluded from X candidates): `GEOID`, `COUNTYFP`, `TRACTCE`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `per_capita_income` | `integer` | count | [2343, 276384] | 0% |
| `median_household_income` | `numeric` | continuous | [11094, 250001] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `nyc_tract_income_ssig`, la ou les reponses `per_capita_income`, `median_household_income` viennent du loader papier et/ou des preuves de l article `What dictates income in New York City? SHAP analysis of income estimation based on Socio-economic and Spatial Information Gaussian Processes (SSIG)`. Les covariables X retenues sont `UDG25`, `PGD25`, `Unemploy`, `Age65p`, `AgeU18`, `PopDensity`, `MaleShare`, `BlackShare`, `AsianShare`, `WhiteShare` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`INTPTLON`, `INTPTLAT`), identifiants (`GEOID`, `COUNTYFP`, `TRACTCE`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ALAND` | `integer` | count | 0% |
| `AWATER` | `integer` | count | 0% |
| `UDG25` | `numeric` | continuous | 0% |
| `PGD25` | `numeric` | continuous | 0% |
| `Unemploy` | `numeric` | continuous | 0% |
| `Age65p` | `numeric` | continuous | 0% |
| `AgeU18` | `numeric` | continuous | 0% |
| `PopDensity` | `numeric` | continuous | 0% |
| `MaleShare` | `numeric` | continuous | 0% |
| `BlackShare` | `numeric` | continuous | 0% |
| `AsianShare` | `numeric` | continuous | 0% |
| `WhiteShare` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: per_capita_income, median_household_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare + latitude + longitude [Gaussian Process, noyau Matern-3/2, pas d'equation lineaire fermee -- SHAP utilise pour l'importance des variables]
- x_terms_pub: proportion bachelor >=25 ans (UDG25), proportion diplome superieur >=25 ans (PGD25), taux de chomage (Unemploy), proportion >=65 ans (Age65p), proportion <18 ans (AgeU18), densite de population (PopDensity), proportion hommes (MaleShare), proportion Black/African American (BlackShare), proportion Asian (AsianShare), proportion White (WhiteShare), latitude/longitude du centroide (spatial info)
- y_term_pub: per_capita_income (ou median_household_income), District income at Tract-level
- Reference publication: Bai, Lam & Li (2023), Humanities and Social Sciences Communications 10:60, DOI 10.1057/s41599-023-01548-7 (SSIG model). Table 2 documente exactement les 10 variables socio-economiques utilisees ; le depot du papier n'est pas public (donnees sur demande), reconstruit depuis les sources publiques citees (ACS via Census Reporter, geometrie TIGER/Line), millesime ACS 2020-2024 5-year au lieu de 2015-2019 (cle API Census Bureau indisponible, decision utilisateur 2026-08-15, cf. README_nyc_tract_income.txt). Modele publie = Gaussian Process (noyau Matern-3/2) + SHAP, pas une regression lineaire ; formula_used est une variante continue executable sur les memes 10 predicteurs.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: per_capita_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare
- x_terms_used: UDG25, PGD25, Unemploy, Age65p, AgeU18, PopDensity, MaleShare, BlackShare, AsianShare, WhiteShare
- y_term_used: per_capita_income
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "per_capita_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare"
    response: "per_capita_income (ou median_household_income), District income at Tract-level"
    predictors: ["proportion bachelor >=25 ans (UDG25)", "proportion diplome superieur >=25 ans (PGD25)", "taux de chomage (Unemploy)", "proportion >=65 ans (Age65p)", "proportion <18 ans (AgeU18)", "densite de population (PopDensity)", "proportion hommes (MaleShare)", "proportion Black/African American (BlackShare)", "proportion Asian (AsianShare)", "proportion White (WhiteShare)", "latitude/longitude du centroide (spatial info)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "per_capita_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare"
    response: "per_capita_income"
    predictors: ["UDG25", "PGD25", "Unemploy", "Age65p", "AgeU18", "PopDensity", "MaleShare", "BlackShare", "AsianShare", "WhiteShare"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "xgboost", "gamboost", "gam_spatial"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_nyc_tract_income_ssig`
- Dataset name: Tract-level and ZIP-level income (per-capita and median household), ACS 2015-2019 5-year via Census Reporter
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: What dictates income in New York City? SHAP analysis of income estimation based on Socio-economic and Spatial Information Gaussian Processes (SSIG)
- Paper DOI: 10.1057/s41599-023-01548-7
- Dataset DOI: none
- Source URL: https://api.censusreporter.org
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "per_capita_income, median_household_income ~ UDG25 + PGD25 + Unemploy + Age65p + AgeU18 + PopDensity + MaleShare + BlackShare + AsianShare + WhiteShare + latitude + longitude [Gaussian Process, noyau Matern-3/2, pas d'equation lineaire fermee -- SHAP utilise pour l'importance des variables]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Bai, Lam & Li (2023), Humanities and Social Sciences Communications 10:60, DOI 10.1057/s41599-023-01548-7 (SSIG model). Table 2 documente exactement les 10 variables socio-economiques utilisees ; le depot du papier n'est pas public (donnees sur demande), reconstruit depuis les sources publiques citees (ACS via Census Reporter, geometrie TIGER/Line), millesime ACS 2020-2024 5-year au lieu de 2015-2019 (cle API Census Bureau indisponible, decision utilisateur 2026-08-15, cf. README_nyc_tract_income.txt). Modele publie = Gaussian Process (noyau Matern-3/2) + SHAP, pas une regression lineaire ; formula_used est une variante continue executable sur les memes 10 predicteurs."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "millesime ACS 2020-2024 au lieu de 2015-2019 (cle API Census Bureau indisponible) ; N=2199 vs N=2117 publie, ecart du au millesime different ; formula_pub liste les 10 predicteurs exacts du papier mais le modele publie est un Gaussian Process + SHAP, pas une equation lineaire fermee"
  reason: "Y continu reel (per_capita_income / median_household_income, ACS), X = les 10 covariables socio-economiques exactes de Table 2 du papier (education, chomage, age, densite, sexe, race), coordonnees reelles des centroides de tract. Reconstruit depuis sources publiques (Census Reporter + TIGER/Line) car le depot du papier n'est pas public -- promu avec ecart de millesime documente."
```

- Decision: ready
- Manque principal: millesime ACS 2020-2024 au lieu de 2015-2019 (cle API Census Bureau indisponible) ; N=2199 vs N=2117 publie, ecart du au millesime different ; formula_pub liste les 10 predicteurs exacts du papier mais le modele publie est un Gaussian Process + SHAP, pas une equation lineaire fermee
- Raison: Y continu reel (per_capita_income / median_household_income, ACS), X = les 10 covariables socio-economiques exactes de Table 2 du papier (education, chomage, age, densite, sexe, race), coordonnees reelles des centroides de tract. Reconstruit depuis sources publiques (Census Reporter + TIGER/Line) car le depot du papier n'est pas public -- promu avec ecart de millesime documente.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 2199
- k variables: 21
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-74.243356, -73.7046105], y [40.4997874, 40.9096659]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Public Domain (U.S. Census Bureau data)
- License URL: https://censusreporter.org/topics/table-codes/
- License open: yes
- License evidence: Census Reporter site text (checked 2026-08-18): "Data on Census Reporter comes from the US Census Bureau and is not copyrighted." (Census Reporter's own added content is CC BY 4.0, but the fiche only uses the underlying Census Bureau data.)
- Reproducibility status: OK - loader R enregistre et reexecutable (`nyc_tract_income_ssig` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `nyc_tract_income_ssig` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`nyc_tract_income_ssig` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: What dictates income in New York City? SHAP analysis of income estimation based on Socio-economic and Spatial Information Gaussian Processes (SSIG)

