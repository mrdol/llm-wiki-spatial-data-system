---
title: paper_alps_floristic_legacy
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_alps_floristic_legacy.rds
  - DatasetFirst_10_5061_dryad_w9ghx3g12
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps" (DOI 10.1600/036364425x17466502618876).

## Description du jeu de donnees

- Topic: biogeographie / heritage glaciaire de la flore alpine
- Observation unit: cellule de grille
- Observed population: flore vasculaire des Alpes europeennes, N=509 cellules
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1600/036364425x17466502618876
- Dataset DOI: 10.5061/dryad.w9ghx3g12
- Source URL: https://doi.org/10.5061/dryad.w9ghx3g12
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_w9ghx3g12/`
- Local sf output: `data/final_datasets/sf/paper_alps_floristic_legacy.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Standardised_SR`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Elev_mean`, `Elev_sd`, `Slope_deg`, `Precip_total`, `Nunatak_distance`, `Periph_refugia_distance`, `Refugia_distance_all`, `Deglac`, `Temp_annual`, `Paleo_temp`, `Pet`, `Velocity_med`, `Bedrock_class`, `n`, `S.obs`, `SC`, `Tamme_mean`, `n_tamme`, `Ses_pd`, `Phylo_endem`
- Candidate X count in local artifact: 20
- Candidate X typology: continuous, categorical
- Published X variables from paper: Nunatak_distance (distance aux refuges glaciaires de haute altitude), Refugia_distance_all (distance a tous les refuges peripheriques), Deglac (temps depuis la deglaciation), Elev_mean (elevation moyenne), Precip_total (precipitation totale), Temp_annual (temperature annuelle), Pet (evapotranspiration potentielle)
- Published X count: 7
- Coordinates (x, y - excluded from X candidates): `coords.X`, `coords.Y`
- Identifier columns (excluded from X candidates): `Code`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Standardised_SR` | `numeric` | continuous | [46.5, 891.67] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `alps_floristic_legacy`, la ou les reponses `Standardised_SR` viennent du loader papier et/ou des preuves de l article `The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps`. Les covariables X retenues sont `Nunatak_distance`, `Refugia_distance_all`, `Deglac`, `Elev_mean`, `Precip_total`, `Temp_annual`, `Pet` ; 13 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`coords.X`, `coords.Y`), identifiants (`Code`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Elev_mean` | `numeric` | continuous | 0% |
| `Elev_sd` | `numeric` | continuous | 0% |
| `Slope_deg` | `numeric` | continuous | 0% |
| `Precip_total` | `numeric` | continuous | 0% |
| `Nunatak_distance` | `numeric` | continuous | 0% |
| `Periph_refugia_distance` | `numeric` | continuous | 0% |
| `Refugia_distance_all` | `numeric` | continuous | 0% |
| `Deglac` | `numeric` | continuous | 0% |
| `Temp_annual` | `numeric` | continuous | 0% |
| `Paleo_temp` | `numeric` | continuous | 0% |
| `Pet` | `numeric` | continuous | 0% |
| `Velocity_med` | `numeric` | continuous | 0% |
| `Bedrock_class` | `character` | categorical | 0% |
| `n` | `integer` | count | 0% |
| `S.obs` | `integer` | count | 0% |
| `SC` | `numeric` | rate | 0% |
| `Tamme_mean` | `numeric` | continuous | 0% |
| `n_tamme` | `integer` | count | 0% |
| `Ses_pd` | `numeric` | continuous | 0% |
| `Phylo_endem` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: S.obs/Standardised_SR ~ Nunatak_distance + Refugia_distance_all + Deglac + Elev_mean + Precip_total + Temp_annual + Pet + Bedrock_class [modele de richesse specifique standardisee expliquee par la distance aux refuges glaciaires (nunataks/refugia peripheriques), le temps depuis la deglaciation, et les variables climatiques/topographiques actuelles, sur une grille de cellules des Alpes europeennes]
- x_terms_pub: Nunatak_distance (distance aux refuges glaciaires de haute altitude), Refugia_distance_all (distance a tous les refuges peripheriques), Deglac (temps depuis la deglaciation), Elev_mean (elevation moyenne), Precip_total (precipitation totale), Temp_annual (temperature annuelle), Pet (evapotranspiration potentielle)
- y_term_pub: Standardised_SR (richesse specifique vegetale standardisee par cellule de grille, echantillonnage complet effort-standardise)
- Reference publication: Auteurs, The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps, Systematic Botany, doi:10.1600/036364425x17466502618876. Le papier explique les patrons de richesse specifique et de diversite phylogenetique vegetale des Alpes par la distance aux refuges glaciaires post-Pleistocene, le temps depuis la deglaciation et les variables climatiques actuelles, sur une grille de cellules echantillonnee. Donnees brutes (Supplementary_data_legacy.csv) telechargees directement depuis Dryad (10.5061/dryad.w9ghx3g12) -- pas une reconstruction, N=509 cellules avec coordonnees reelles (Alpes europeennes).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Standardised_SR ~ Nunatak_distance + Refugia_distance_all + Deglac + Elev_mean + Precip_total + Temp_annual + Pet
- x_terms_used: Nunatak_distance, Refugia_distance_all, Deglac, Elev_mean, Precip_total, Temp_annual, Pet
- y_term_used: Standardised_SR
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "Standardised_SR ~ Nunatak_distance + Refugia_distance_all + Deglac + Elev_mean + Precip_total + Temp_annual + Pet"
    response: "Standardised_SR (richesse specifique vegetale standardisee par cellule de grille, echantillonnage complet effort-standardise)"
    predictors: ["Nunatak_distance (distance aux refuges glaciaires de haute altitude)", "Refugia_distance_all (distance a tous les refuges peripheriques)", "Deglac (temps depuis la deglaciation)", "Elev_mean (elevation moyenne)", "Precip_total (precipitation totale)", "Temp_annual (temperature annuelle)", "Pet (evapotranspiration potentielle)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Standardised_SR ~ Nunatak_distance + Refugia_distance_all + Deglac + Elev_mean + Precip_total + Temp_annual + Pet + Slope_deg + Velocity_med"
    response: "Standardised_SR"
    predictors: ["Nunatak_distance", "Refugia_distance_all", "Deglac", "Elev_mean", "Precip_total", "Temp_annual", "Pet", "Slope_deg", "Velocity_med"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_alps_floristic_legacy`
- Dataset name: Data from: The limited legacy of post-glacial recolonization in the floristic patterns of the European Alps
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps
- Paper DOI: 10.1600/036364425x17466502618876
- Dataset DOI: 10.5061/dryad.w9ghx3g12
- Source URL: https://doi.org/10.5061/dryad.w9ghx3g12
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "S.obs/Standardised_SR ~ Nunatak_distance + Refugia_distance_all + Deglac + Elev_mean + Precip_total + Temp_annual + Pet + Bedrock_class [modele de richesse specifique standardisee expliquee par la distance aux refuges glaciaires (nunataks/refugia peripheriques), le temps depuis la deglaciation, et les variables climatiques/topographiques actuelles, sur une grille de cellules des Alpes europeennes]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Auteurs, The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps, Systematic Botany, doi:10.1600/036364425x17466502618876. Le papier explique les patrons de richesse specifique et de diversite phylogenetique vegetale des Alpes par la distance aux refuges glaciaires post-Pleistocene, le temps depuis la deglaciation et les variables climatiques actuelles, sur une grille de cellules echantillonnee. Donnees brutes (Supplementary_data_legacy.csv) telechargees directement depuis Dryad (10.5061/dryad.w9ghx3g12) -- pas une reconstruction, N=509 cellules avec coordonnees reelles (Alpes europeennes)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis Dryad, N=509 cellules identique au depot source"
  reason: "Y continu reel (richesse specifique standardisee), N=509 cellules avec coordonnees reelles (Alpes europeennes), covariables de distance aux refuges glaciaires, temps de deglaciation et climat exactement celles du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via les relatedWorks Dryad (Systematic Botany)."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis Dryad, N=509 cellules identique au depot source
- Raison: Y continu reel (richesse specifique standardisee), N=509 cellules avec coordonnees reelles (Alpes europeennes), covariables de distance aux refuges glaciaires, temps de deglaciation et climat exactement celles du papier. CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier identifie via les relatedWorks Dryad (Systematic Botany).

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
- N observations: 509
- k variables: 26
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [5.0445002, 15.6342734], y [43.7220926, 48.0024233]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32632 (UTM Zone 32N (EPSG:32632)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.w9ghx3g12 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`alps_floristic_legacy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `alps_floristic_legacy` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`alps_floristic_legacy` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: The Limited Legacy of Post-Glacial Recolonization in the Floristic Patterns of the European Alps

