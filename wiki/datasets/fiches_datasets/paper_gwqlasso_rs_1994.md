---
title: paper_gwqlasso_rs_1994
type: dataset
created: 2026-09-08
updated: 2026-09-08
sources:
  - data/final_datasets/sf/paper_gwqlasso_rs_1994.rds
  - DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en
tags: [dataset, paper-derived, spatial, point]
---

Sous-ensemble (1994) du jeu panel principal [[paper_gwqlasso_rs]], decoupe le 2026-09-08 pour elargir le nombre de jeux de donnees benchmarkables sans casser la validite spatiale (memes 497 municipalites que le parent, geometrie/CRS identiques). Papier source : "An application of geographically weighted quantile lasso to weather index insurance design" (DOI 10.1590/1982-7849rac2022200387.en).

## Description du jeu de donnees

- Topic: agriculture_economic
- Observation unit: observation spatiale, municipalites de Rio Grande do Sul (RS)
- Observed population: sous-ensemble temporel (1994) du dataset parent [[paper_gwqlasso_rs]] (N total parent = 21371) ; voir Bloc 4 pour le N exact de ce sous-ensemble
- Geographic context: Municipalites geocodees via reference publique IBGE (kelvins/Municipios-Brasileiros), CRS EPSG:4326.
- Temporal context: coupe transversale annuelle
- Source description: An application of geographically weighted quantile lasso to weather index insurance design
- Description source: paper_dataset_uses.json + lecture directe du papier (voir fiche parent [[paper_gwqlasso_rs]])
- Description confidence: medium
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Local raw dir: `data/raw/papers/DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en/`
- Local sf output: `data/final_datasets/sf/paper_gwqlasso_rs_1994.rds`

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
- Variables inspected: yes (herite du parent [[paper_gwqlasso_rs]])
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Yield_kg_ha` | `numeric` | continuous | [600, 2667] | 31.8% |

> Selection Y/X (herite du parent) : Pour `paper_gwqlasso_rs_1994`, la reponse `Yield_kg_ha` et les covariables (`precip_annual_mm`) sont identiques a celles du jeu parent [[paper_gwqlasso_rs]] -- voir cette fiche pour la justification complete. Statut benchmark actuel : manual_review; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | count | 0% |
| `name_norm` | `character` | categorical | 0% |
| `precip_annual_mm` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]
- x_terms_pub: SPI_1month
- y_term_pub: Yield_kg_ha
- Reference publication: Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Sous-ensemble (1994) du jeu parent [[paper_gwqlasso_rs]] -- meme formule, aucune modification.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule identique au parent [[paper_gwqlasso_rs]], verifiee par lecture directe du papier source. Decoupage temporel du 2026-09-08.

### Formule - niveau systeme

- formula_used: Yield_kg_ha ~ precip_annual_mm
- Recommended validation: N lignes=497; N spatial=497; T declare=1. Coupe transversale (T=1) -- pas de fuite temporelle possible au sein de cette coupe ; aucune coordonnee dupliquee (chaque municipalite apparait une fois).
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: precip_annual_mm
- y_term_used: Yield_kg_ha
- Note: Formule identique au parent [[paper_gwqlasso_rs]]. Decoupage temporel du 2026-09-08.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Yield_kg_ha ~ precip_annual_mm"
    response: "Yield_kg_ha"
    predictors: ["SPI_1month"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et la fiche parent paper_gwqlasso_rs."
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
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et la fiche parent paper_gwqlasso_rs."
    estimator_context: ["gwr", "quantile_regression", "lasso", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_gwqlasso_rs_1994`
- Dataset name: Rendement de soja et precipitation, municipalites de Rio Grande do Sul -- sous-ensemble 1994
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: An application of geographically weighted quantile lasso to weather index insurance design
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Year: unknown
- Parent dataset: `paper_gwqlasso_rs` (sous-ensemble temporel -- ne pas compter comme source independante)

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
  source_ref: "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Sous-ensemble (1994) du jeu parent paper_gwqlasso_rs."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "manual_review"
  benchmark_task: "grouped_or_temporal_validation_review"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "Coupe transversale annuelle (T=1), derivee du panel parent paper_gwqlasso_rs. Aucune promotion automatique -- revue manuelle standard comme les autres coupes annuelles deja en place (ex. famille Coree)."
  reason: "Coupe transversale derivee du panel parent paper_gwqlasso_rs, decoupage decide par l-utilisateur (2026-09-08) pour elargir le nombre de jeux de donnees benchmarkables."
```

- Decision: manual_review
- Manque principal: Revue manuelle standard (nouvelle fiche derivee, 2026-09-08).
- Raison: Coupe transversale derivee du panel parent paper_gwqlasso_rs, decoupage du 2026-09-08.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "Nouvelle fiche derivee (decoupage du 2026-09-08) -- revue manuelle standard avant selection des routes, comme pour toute nouvelle fiche."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 497
- k variables: 9
- T periods: 1
- Variable temporelle: Year
- N/T profile: N_petit_T_petit
- Note N/T (session 2026-09-08) : Coupe transversale (1994) du panel principal [[paper_gwqlasso_rs]] -- decoupage decide par l'utilisateur pour elargir le nombre de jeux de donnees benchmarkables, pas un artefact systeme. T=1 est correct pour cette coupe (une seule annee). N spatial = 497 (toutes les municipalites du panel parent sont presentes, aucune coordonnee dupliquee au sein de cette coupe puisque chaque municipalite n'apparait qu'une fois par annee dans le panel equilibre).

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation (municipalite)
- Temporal resolution: 1994
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-57.5497, -49.7333], y [-33.6866, -27.1607]
- Time range: 1994 (variable: Year)
- CRS analyse recommande: 32722 (UTM Zone 22S (EPSG:32722)) - herite du parent

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: Herite du parent [[paper_gwqlasso_rs]] -- DataCite API record pour DOI 10.7910/DVN/UEZMJT.
- Reproducibility status: OK - genere par `code/r_catalog/split_gwqlasso.R` (session 2026-09-08) a partir du parent [[paper_gwqlasso_rs]] ; source brute tracee dans inst/kg/paper_dataset_uses.json (fiche parent).
- Code available: yes (`code/r_catalog/split_gwqlasso.R`)
- Repository: paper-derived (voir fiche parent [[paper_gwqlasso_rs]])

## Quality Control

- Schema: OK - fiche derivee du format Bloc 1-6 de la fiche parent [[paper_gwqlasso_rs]].
- Variables: OK - Y et X identiques au parent (herite).
- Formula: OK - formule identique au parent, executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326), herite du parent.
- Geometry: OK - type geometrique controle (POINT), 497 municipalites.
- Missing values: OK - Yield_kg_ha a 31.8% de NA (coherent avec le parent, placeholders textuels convertis en NA le 2026-09-08).
- Duplicates: OK - aucun doublon (coupe transversale, une ligne par municipalite).
- Reproducibility: OK - genere par script trace, source parent documentee.

## Related Pages

- [[paper_gwqlasso_rs]]
- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: An application of geographically weighted quantile lasso to weather index insurance design

## Curation documentée — 2026-09-08

Fiche generee par decoupage temporel du panel parent [[paper_gwqlasso_rs]] (coupe transversale annuelle 1994), sur decision explicite de l'utilisateur, pour elargir le nombre de jeux de donnees benchmarkables sans casser la validite spatiale (memes 497 municipalites que le parent, matrice W non degeneree). Le parent [[paper_gwqlasso_rs]] (panel complet, N=21371) est conserve tel quel.

En cours de curation : `Yield_kg_ha` a ete corrige en `numeric` le 2026-09-08 (etait `character` avec placeholders textuels "..."/"-" pour les valeurs manquantes dans le jeu parent) -- correction heritee automatiquement par ce sous-ensemble.

Provenance des corrections : audit du 2026-09-07/08, script `code/r_catalog/split_gwqlasso.R`.
