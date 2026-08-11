---
title: paper_waste_site
type: dataset
created: 2026-08-10
updated: 2026-08-10
sources:
  - data/final_datasets/sf/paper_waste_site.rds
  - DataCite_2021_SystematicVariationInWaste_10_1007_s10640_0
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer" (DOI 10.1007/s10640-021-00536-2).

## Description du jeu de donnees

- Topic: economie environnementale / prix hedoniques
- Observation unit: estimation d'etude (meta-regression)
- Observed population: etudes de prix immobiliers residentiels a proximite de sites de dechets
- Geographic context: a preciser depuis l'etendue spatiale (voir Bloc 5)
- Temporal context: 26 distinct periods (variable: year_publish)
- Source description: Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1007/s10640-021-00536-2
- Dataset DOI: 10.7910/dvn/828wud
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/828WUD
- Local raw dir: `data/raw/papers/DataCite_2021_SystematicVariationInWaste_10_1007_s10640_0/`
- Local sf output: `data/final_datasets/sf/paper_waste_site.rds`

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `elas`
- Candidate Y typology: continuous
- Candidate X variables: `author`, `title`, `weight (sample_reuse)`, `second coding`, `year_publish`, `publish`, `element`, `site_cat`, `site_m`, `region`, `subnational state / district`, `NPL`, `active`, `job`, `cleanup_stage`, `HDI_subnational`, `HDI_national`, `GDP_p.c._national_2010_USD`, `data_year`, `time`, `sample`, `dist_mean`, `p_mean`, `converter_dich`, `sales`, `sale_ind`, `demoecon`, `log_log`, `num_sig_var`, `num_expl`, `num_struc`, `num_nb`, `num_env`, `oth_disamen`, `oth_amen`, `access`, `industry`, `miles_km`, `OLS`, `DF`, `ß`, `SE`, `t-value`, `p-value`, `sig`, `sig_level`, `sign`, `time_dummy`, `time_cont`, `time_disc`, `direction`, `interaction`, `spatial`, `elas_SE`, `comments`, `further comments`
- Candidate X count: 56
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): none detected
- Identifier columns (excluded from X candidates): `ID_Study`, `ID_Est`, `ID_Uni`, `ID_regress`, `iso_a2`, `country`
- Variables inspected: yes (auto — generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `elas` | `numeric` | continuous | [-2.0938, 1.762] | 0% |

> Selection Y/X (paper-loader/curated evidence) : Pour `waste_site`, la ou les reponses `elas` viennent du loader papier et/ou des preuves de l article `Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer`. Les covariables X retenues sont `author`, `title`, `weight (sample_reuse)`, `second coding`, `year_publish`, `publish`, `element`, `site_cat`, `site_m`, `region`, `subnational state / district`, `NPL` ; 44 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (les coordonnees detectees), identifiants (`ID_Study`, `ID_Est`, `ID_Uni`, `ID_regress`, `iso_a2`, `country`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : not_ready_current_package ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `author` | `character` | categorical | 0% |
| `title` | `character` | categorical | 0% |
| `weight (sample_reuse)` | `numeric` | rate | 0% |
| `second coding` | `numeric` | binary | 0% |
| `year_publish` | `numeric` | continuous | 0% |
| `publish` | `numeric` | binary | 0% |
| `element` | `character` | categorical | 0% |
| `site_cat` | `character` | categorical | 0% |
| `site_m` | `numeric` | binary | 0% |
| `region` | `character` | categorical | 0% |
| `subnational state / district` | `character` | categorical | 14.6% |
| `NPL` | `numeric` | continuous | 0% |
| `active` | `numeric` | continuous | 0% |
| `job` | `numeric` | continuous | 0% |
| `cleanup_stage` | `numeric` | continuous | 0% |
| `HDI_subnational` | `character` | categorical | 0% |
| `HDI_national` | `character` | categorical | 0% |
| `GDP_p.c._national_2010_USD` | `character` | categorical | 0% |
| `data_year` | `character` | categorical | 0% |
| `time` | `character` | categorical | 0% |
| `sample` | `numeric` | continuous | 0% |
| `dist_mean` | `character` | categorical | 0% |
| `p_mean` | `character` | categorical | 0% |
| `converter_dich` | `numeric` | continuous | 0% |
| `sales` | `character` | categorical | 0% |
| `sale_ind` | `numeric` | binary | 0% |
| `demoecon` | `numeric` | binary | 0% |
| `log_log` | `numeric` | binary | 0% |
| `num_sig_var` | `character` | categorical | 0% |
| `num_expl` | `numeric` | continuous | 0% |
| `num_struc` | `character` | categorical | 0% |
| `num_nb` | `character` | categorical | 0% |
| `num_env` | `character` | categorical | 0% |
| `oth_disamen` | `numeric` | binary | 0% |
| `oth_amen` | `numeric` | binary | 0% |
| `access` | `numeric` | binary | 0% |
| `industry` | `numeric` | binary | 0% |
| `miles_km` | `numeric` | binary | 0% |
| `OLS` | `numeric` | binary | 0% |
| `DF` | `numeric` | continuous | 0% |
| `ß` | `character` | categorical | 0% |
| `SE` | `character` | categorical | 0% |
| `t-value` | `numeric` | continuous | 0% |
| `p-value` | `character` | categorical | 0% |
| `sig` | `numeric` | binary | 0% |
| `sig_level` | `character` | categorical | 0% |
| `sign` | `character` | categorical | 0% |
| `time_dummy` | `numeric` | binary | 0% |
| `time_cont` | `numeric` | binary | 0% |
| `time_disc` | `numeric` | binary | 0% |
| `direction` | `numeric` | binary | 0% |
| `interaction` | `numeric` | binary | 0% |
| `spatial` | `numeric` | binary | 0% |
| `elas_SE` | `numeric` | continuous | 0% |
| `comments` | `character` | categorical | 71.8% |
| `further comments` | `character` | categorical | 86.2% |

### Formule — niveau publication

- formula_pub: elas ~ meta-regression (WLS/REML) sur 727 estimations, correction du biais de publication (PET-PEESE)
- x_terms_pub: author, title, weight (sample_reuse), second coding, year_publish, publish, element, site_cat, site_m, region, subnational state / district, NPL
- y_term_pub: elas
- Reference publication: Schutt (2021), Environmental and Resource Economics 78:381-416 — meta-analyse d'hedonic pricing (727 estimations, 83 etudes) de l'effet des sites de dechets sur les prix immobiliers residentiels ; 'elas' = elasticite/taille d'effet corrigee du biais de publication.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Schutt (2021), Environmental and Resource Economics 78:381-416 — meta-analyse d'hedonic pricing (727 estimations, 83 etudes) de l'effet des sites de dechets sur les prix immobiliers residentiels ; 'elas' = elasticite/taille d'effet corrigee du biais de publication.

### Formule — niveau systeme

- formula_used: elas ~ author + title + weight (sample_reuse) + second coding + year_publish + publish + element + site_cat + site_m + region + subnational state / district + NPL + ... (44 covariables au total, voir Candidate X variables)
- x_terms_used: author, title, weight (sample_reuse), second coding, year_publish, publish, element, site_cat, site_m, region, subnational state / district, NPL
- y_term_used: elas
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-10). Schutt (2021), Environmental and Resource Economics 78:381-416 — meta-analyse d'hedonic pricing (727 estimations, 83 etudes) de l'effet des sites de dechets sur les prix immobiliers residentiels ; 'elas' = elasticite/taille d'effet corrigee du biais de publication.

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
    formula: "elas ~ author + title + weight (sample_reuse) + second coding + year_publish + publish + element + site_cat + site_m + region + subnational state / district + NPL + ... (44 covariables au total, voir Candidate X variables)"
    response: "elas"
    predictors: ["author", "title", "weight (sample_reuse)", "second coding", "year_publish", "publish", "element", "site_cat", "site_m", "region", "subnational state / district", "NPL"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Schutt (2021), Environmental and Resource Economics 78:381-416 — meta-analyse d'hedonic pricing (727 estimations, 83 etudes) de l'effet des sites de dechets sur les prix immobiliers residentiels ; 'elas' = elasticite/taille d'effet corrigee du biais de publication."
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

- Dataset ID: `paper_waste_site`
- Dataset name: Replication Data for: Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer
- Paper DOI: 10.1007/s10640-021-00536-2
- Dataset DOI: 10.7910/dvn/828wud
- Source URL: https://dataverse.harvard.edu/citation?persistentId=doi:10.7910/DVN/828WUD
- Year: unknown

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "elas ~ meta-regression (WLS/REML) sur 727 estimations, correction du biais de publication (PET-PEESE)"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Schutt (2021), Environmental and Resource Economics 78:381-416 — meta-analyse d'hedonic pricing (727 estimations, 83 etudes) de l'effet des sites de dechets sur les prix immobiliers residentiels ; 'elas' = elasticite/taille d'effet corrigee du biais de publication."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_current_package"
  benchmark_task: "meta_regression"
  package_include: "no"
  has_local_rds: true
  missing_items: "traiter comme meta-analyse, pas comme observations spatiales"
  reason: "Les lignes sont des estimations d'etudes, pas des observations geographiques elementaires."
```

- Decision: not_ready_current_package
- Manque principal: traiter comme meta-analyse, pas comme observations spatiales
- Raison: Les lignes sont des estimations d'etudes, pas des observations geographiques elementaires.

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 727
- k variables: 66
- T periods: 26
- Variable temporelle: year_publish
- N/T profile: N_grand_T_grand

## Bloc 5 — Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 26 distinct periods (variable: year_publish)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-110.243807777161, 138.348867052897], y [-28.40852405, 62.2748813]
- Time range: 1975 to 2019 (variable: year_publish)
- CRS analyse recommande: pending — multi-zones (span=248.6deg) -- projection nationale recommandee

## Bloc 6 — Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`waste_site` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `waste_site` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee (verifiee par lecture directe du papier).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: comments (NA=71.8%), further comments (NA=86.2%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`waste_site` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Systematic Variation in Waste Site Effects on Residential Property Values: A Meta-Regression Analysis and Benefit Transfer

