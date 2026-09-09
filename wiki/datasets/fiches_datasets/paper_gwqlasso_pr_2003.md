---
title: paper_gwqlasso_pr_2003
type: dataset
created: 2026-09-08
updated: 2026-09-08
sources:
  - data/final_datasets/sf/paper_gwqlasso_pr_2003.rds
  - DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en
tags: [dataset, paper-derived, spatial, point]
---

Sous-ensemble (2003) du jeu panel principal [[paper_gwqlasso_pr]], decoupe le 2026-09-08 pour elargir le nombre de jeux de donnees benchmarkables sans casser la validite spatiale (memes 399 municipalites que le parent, geometrie/CRS identiques). Papier source : "An application of geographically weighted quantile lasso to weather index insurance design" (DOI 10.1590/1982-7849rac2022200387.en).

## Description du jeu de donnees

- Topic: agriculture_economic
- Observation unit: observation spatiale, municipalites de Parana (PR)
- Observed population: sous-ensemble temporel (2003) du dataset parent [[paper_gwqlasso_pr]] (N total parent = 17157) ; voir Bloc 4 pour le N exact de ce sous-ensemble
- Geographic context: Municipalites geocodees via reference publique IBGE (kelvins/Municipios-Brasileiros), CRS EPSG:4326.
- Temporal context: coupe transversale annuelle
- Source description: An application of geographically weighted quantile lasso to weather index insurance design
- Description source: paper_dataset_uses.json + lecture directe du papier (voir fiche parent [[paper_gwqlasso_pr]])
- Description confidence: medium
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Local raw dir: `data/raw/papers/DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en/`
- Local sf output: `data/final_datasets/sf/paper_gwqlasso_pr_2003.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Yield_kg_ha`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year`, `name_norm`, `precip_annual_mm`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous, categorical
- Published X variables from paper: SPI_1month
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `muni_lon`, `muni_lat`
- Identifier columns (excluded from X candidates): `Municipality`, `State`, `station_id`
- Variables inspected: yes (herite du parent [[paper_gwqlasso_pr]])
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Yield_kg_ha` | `numeric` | continuous | [916, 3700] | 8.5% |

> Selection Y/X (herite du parent) : Pour `paper_gwqlasso_pr_2003`, la reponse `Yield_kg_ha` et les covariables (`precip_annual_mm`) sont identiques a celles du jeu parent [[paper_gwqlasso_pr]] -- voir cette fiche pour la justification complete. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | count | 0% |
| `name_norm` | `character` | categorical | 0% |
| `precip_annual_mm` | `numeric` | continuous | 0.8% |

### Formule - niveau publication

- formula_pub: Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]
- x_terms_pub: SPI_1month
- y_term_pub: Yield_kg_ha
- Reference publication: Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Sous-ensemble (2003) du jeu parent [[paper_gwqlasso_pr]] -- meme formule, aucune modification.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule identique au parent [[paper_gwqlasso_pr]], verifiee par lecture directe du papier source. Decoupage temporel du 2026-09-08.

### Formule - niveau systeme

- formula_used: Yield_kg_ha ~ precip_annual_mm
- Recommended validation: N lignes=399; N spatial=399; T declare=1. Coupe transversale (T=1) -- pas de fuite temporelle possible au sein de cette coupe ; aucune coordonnee dupliquee (chaque municipalite apparait une fois).
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: precip_annual_mm
- y_term_used: Yield_kg_ha
- Note: Formule identique au parent [[paper_gwqlasso_pr]]. Decoupage temporel du 2026-09-08.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Yield_kg_ha ~ precip_annual_mm"
    response: "Yield_kg_ha"
    predictors: ["SPI_1month"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et la fiche parent paper_gwqlasso_pr."
    estimator_context: ["ols", "spatial_baseline"]
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
    formula: "Yield_kg_ha ~ precip_annual_mm + Year"
    response: "Yield_kg_ha"
    predictors: ["precip_annual_mm", "Year"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et la fiche parent paper_gwqlasso_pr."
    estimator_context: ["gwr", "quantile_regression", "lasso", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_gwqlasso_pr_2003`
- Dataset name: Rendement de soja et precipitation, municipalites de Parana -- sous-ensemble 2003
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: An application of geographically weighted quantile lasso to weather index insurance design
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Year: unknown
- Parent dataset: `paper_gwqlasso_pr` (sous-ensemble temporel -- ne pas compter comme source independante)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Sous-ensemble (2003) du jeu parent paper_gwqlasso_pr."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression lineaire standard, baseline generique pour reponse continue."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (mgcv), baseline non-lineaire generique pour reponse continue."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 399
- k variables: 9
- T periods: 1
- Variable temporelle: Year
- N/T profile: N_petit_T_petit
- Note N/T (session 2026-09-08) : Coupe transversale (2003) du panel principal [[paper_gwqlasso_pr]] -- decoupage decide par l'utilisateur pour elargir le nombre de jeux de donnees benchmarkables, pas un artefact systeme. T=1 est correct pour cette coupe (une seule annee). N spatial = 399 (toutes les municipalites du panel parent sont presentes, aucune coordonnee dupliquee au sein de cette coupe puisque chaque municipalite n'apparait qu'une fois par annee dans le panel equilibre).

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation (municipalite)
- Temporal resolution: 2003
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-54.5827, -48.3204], y [-26.4839, -22.5523]
- Time range: 2003 (variable: Year)
- CRS analyse recommande: 32722 (UTM Zone 22S (EPSG:32722)) - herite du parent

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: Herite du parent [[paper_gwqlasso_pr]] -- DataCite API record pour DOI 10.7910/DVN/UEZMJT.
- Reproducibility status: OK - genere par `code/r_catalog/split_gwqlasso.R` (session 2026-09-08) a partir du parent [[paper_gwqlasso_pr]] ; source brute tracee dans inst/kg/paper_dataset_uses.json (fiche parent).
- Code available: yes (`code/r_catalog/split_gwqlasso.R`)
- Repository: paper-derived (voir fiche parent [[paper_gwqlasso_pr]])

## Quality Control

- Schema: OK - fiche derivee du format Bloc 1-6 de la fiche parent [[paper_gwqlasso_pr]].
- Variables: OK - Y et X identiques au parent (herite).
- Formula: OK - formule identique au parent, executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326), herite du parent.
- Geometry: OK - type geometrique controle (POINT), 399 municipalites.
- Missing values: OK - Yield_kg_ha a 8.5% de NA (coherent avec le parent, placeholders textuels convertis en NA le 2026-09-08).
- Duplicates: OK - aucun doublon (coupe transversale, une ligne par municipalite).
- Reproducibility: OK - genere par script trace, source parent documentee.

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (continuous), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- [[paper_gwqlasso_pr]]
- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: An application of geographically weighted quantile lasso to weather index insurance design

## Curation documentée — 2026-09-08

Fiche generee par decoupage temporel du panel parent [[paper_gwqlasso_pr]] (coupe transversale annuelle 2003), sur decision explicite de l'utilisateur, pour elargir le nombre de jeux de donnees benchmarkables sans casser la validite spatiale (memes 399 municipalites que le parent, matrice W non degeneree). Le parent [[paper_gwqlasso_pr]] (panel complet, N=17157) est conserve tel quel.

En cours de curation : `Yield_kg_ha` a ete corrige en `numeric` le 2026-09-08 (etait `character` avec placeholders textuels "..."/"-" pour les valeurs manquantes dans le jeu parent) -- correction heritee automatiquement par ce sous-ensemble.

Provenance des corrections : audit du 2026-09-07/08, script `code/r_catalog/split_gwqlasso.R`.
