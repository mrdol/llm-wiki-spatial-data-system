---
title: paper_gwqlasso_mt_2010
type: dataset
created: 2026-09-08
updated: 2026-09-08
sources:
  - data/final_datasets/sf/paper_gwqlasso_mt_2010.rds
  - DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en
tags: [dataset, paper-derived, spatial, point]
---

Sous-ensemble (2010) du jeu panel principal [[paper_gwqlasso_mt]], decoupe le 2026-09-08 pour elargir le nombre de jeux de donnees benchmarkables sans casser la validite spatiale (memes 141 municipalites que le parent, geometrie/CRS identiques). Papier source : "An application of geographically weighted quantile lasso to weather index insurance design" (DOI 10.1590/1982-7849rac2022200387.en).

## Description du jeu de donnees

- Topic: agriculture_economic
- Observation unit: observation spatiale, municipalites de Mato Grosso (MT)
- Observed population: sous-ensemble temporel (2010) du dataset parent [[paper_gwqlasso_mt]] (N total parent = 6063) ; voir Bloc 4 pour le N exact de ce sous-ensemble
- Geographic context: Municipalites geocodees via reference publique IBGE (kelvins/Municipios-Brasileiros), CRS EPSG:4326.
- Temporal context: coupe transversale annuelle
- Source description: An application of geographically weighted quantile lasso to weather index insurance design
- Description source: paper_dataset_uses.json + lecture directe du papier (voir fiche parent [[paper_gwqlasso_mt]])
- Description confidence: medium
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Local raw dir: `data/raw/papers/DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en/`
- Local sf output: `data/final_datasets/sf/paper_gwqlasso_mt_2010.rds`

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
- Variables inspected: yes (herite du parent [[paper_gwqlasso_mt]])
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Yield_kg_ha` | `numeric` | continuous | [1919, 3536] | 31.9% |

> Selection Y/X (herite du parent) : Pour `paper_gwqlasso_mt_2010`, la reponse `Yield_kg_ha` et les covariables (`precip_annual_mm`) sont identiques a celles du jeu parent [[paper_gwqlasso_mt]] -- voir cette fiche pour la justification complete. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | count | 0% |
| `name_norm` | `character` | categorical | 0% |
| `precip_annual_mm` | `numeric` | continuous | 9.9% |

### Formule - niveau publication

- formula_pub: Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]
- x_terms_pub: SPI_1month
- y_term_pub: Yield_kg_ha
- Reference publication: Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Sous-ensemble (2010) du jeu parent [[paper_gwqlasso_mt]] -- meme formule, aucune modification.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule identique au parent [[paper_gwqlasso_mt]], verifiee par lecture directe du papier source. Decoupage temporel du 2026-09-08.

### Formule - niveau systeme

- formula_used: Yield_kg_ha ~ precip_annual_mm
- Recommended validation: N lignes=141; N spatial=141; T declare=1. Coupe transversale (T=1) -- pas de fuite temporelle possible au sein de cette coupe ; aucune coordonnee dupliquee (chaque municipalite apparait une fois).
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: precip_annual_mm
- y_term_used: Yield_kg_ha
- Note: Formule identique au parent [[paper_gwqlasso_mt]]. Decoupage temporel du 2026-09-08.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Yield_kg_ha ~ precip_annual_mm"
    response: "Yield_kg_ha"
    predictors: ["SPI_1month"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et la fiche parent paper_gwqlasso_mt."
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
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et la fiche parent paper_gwqlasso_mt."
    estimator_context: ["gwr", "quantile_regression", "lasso", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_gwqlasso_mt_2010`
- Dataset name: Rendement de soja et precipitation, municipalites de Mato Grosso -- sous-ensemble 2010
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: An application of geographically weighted quantile lasso to weather index insurance design
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Year: unknown
- Parent dataset: `paper_gwqlasso_mt` (sous-ensemble temporel -- ne pas compter comme source independante)

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
  source_ref: "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Sous-ensemble (2010) du jeu parent paper_gwqlasso_mt."
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
- N observations: 141
- k variables: 9
- T periods: 1
- Variable temporelle: Year
- N/T profile: N_petit_T_petit
- Note N/T (session 2026-09-08) : Coupe transversale (2010) du panel principal [[paper_gwqlasso_mt]] -- decoupage decide par l'utilisateur pour elargir le nombre de jeux de donnees benchmarkables, pas un artefact systeme. T=1 est correct pour cette coupe (une seule annee). N spatial = 141 (toutes les municipalites du panel parent sont presentes, aucune coordonnee dupliquee au sein de cette coupe puisque chaque municipalite n'apparait qu'une fois par annee dans le panel equilibre).

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation (municipalite)
- Temporal resolution: 2010
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-61.4697, -50.514], y [-17.8241, -9.4612]
- Time range: 2010 (variable: Year)
- CRS analyse recommande: 32721 (UTM Zone 21S (EPSG:32721)) - herite du parent

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: Herite du parent [[paper_gwqlasso_mt]] -- DataCite API record pour DOI 10.7910/DVN/UEZMJT.
- Reproducibility status: OK - genere par `code/r_catalog/split_gwqlasso.R` (session 2026-09-08) a partir du parent [[paper_gwqlasso_mt]] ; source brute tracee dans inst/kg/paper_dataset_uses.json (fiche parent).
- Code available: yes (`code/r_catalog/split_gwqlasso.R`)
- Repository: paper-derived (voir fiche parent [[paper_gwqlasso_mt]])

## Quality Control

- Schema: OK - fiche derivee du format Bloc 1-6 de la fiche parent [[paper_gwqlasso_mt]].
- Variables: OK - Y et X identiques au parent (herite).
- Formula: OK - formule identique au parent, executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326), herite du parent.
- Geometry: OK - type geometrique controle (POINT), 141 municipalites.
- Missing values: OK - Yield_kg_ha a 31.9% de NA (coherent avec le parent, placeholders textuels convertis en NA le 2026-09-08).
- Duplicates: OK - aucun doublon (coupe transversale, une ligne par municipalite).
- Reproducibility: OK - genere par script trace, source parent documentee.

## Note -- promotion en lot (2026-09-09)

Formule, reponse et covariables deja resolues (Y/X/formula_used complets avant cette passe). Seul le bloc 'Estimator eligibility' etait vide -- rempli ici avec les estimateurs generiques adaptes a la typologie Y (continuous), sur decision explicite de l'utilisateur de revoir en lot les fiches 'manual_review' deja completes. Base 'scientific_evidence' reservee aux cas ou le texte de la fiche documente deja une methode precise ; sinon 'benchmark_use'/'generated_candidate' (pas de surinterpretation de la methode publiee).

## Related Pages

- [[paper_gwqlasso_mt]]
- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: An application of geographically weighted quantile lasso to weather index insurance design

## Curation documentée — 2026-09-08

Fiche generee par decoupage temporel du panel parent [[paper_gwqlasso_mt]] (coupe transversale annuelle 2010), sur decision explicite de l'utilisateur, pour elargir le nombre de jeux de donnees benchmarkables sans casser la validite spatiale (memes 141 municipalites que le parent, matrice W non degeneree). Le parent [[paper_gwqlasso_mt]] (panel complet, N=6063) est conserve tel quel.

En cours de curation : `Yield_kg_ha` a ete corrige en `numeric` le 2026-09-08 (etait `character` avec placeholders textuels "..."/"-" pour les valeurs manquantes dans le jeu parent) -- correction heritee automatiquement par ce sous-ensemble.

Provenance des corrections : audit du 2026-09-07/08, script `code/r_catalog/split_gwqlasso.R`.
