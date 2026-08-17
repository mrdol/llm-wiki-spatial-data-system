---
title: paper_gwqlasso_rs
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_gwqlasso_rs.rds
  - DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "An application of geographically weighted quantile lasso to weather index insurance design" (DOI 10.1590/1982-7849rac2022200387.en).

## Description du jeu de donnees

- Topic: agriculture_economic
- Observation unit: observation spatiale du dataset "Rendement de soja et precipitation, municipalites de Mato Grosso (decoupe depuis le depot brut complet 3-Etats)"
- Observed population: GWQLasso (Geographically Weighted Quantile Lasso) pour la conception d'assurance indicielle meteo, rendement de soja vs SPI (Standardized Precipitation Index)
- Geographic context: Municipalites geocodees via reference publique IBGE (kelvins/Municipios-Brasileiros), CRS EPSG:4326.
- Temporal context: 43 distinct periods (variable: Year)
- Source description: An application of geographically weighted quantile lasso to weather index insurance design
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Local raw dir: `data/raw/papers/DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en/`
- Local sf output: `data/final_datasets/sf/paper_gwqlasso_rs.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Yield_kg_ha`
- Candidate Y typology: categorical
- Candidate X variables in local artifact: `Year`, `name_norm`, `precip_annual_mm`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous, categorical
- Published X variables from paper: SPI_1month (Standardized Precipitation Index, 1 mois, derive de la precipitation quotidienne par ajustement de loi gamma)
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `muni_lon`, `muni_lat`
- Identifier columns (excluded from X candidates): `Municipality`, `State`, `station_id`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Yield_kg_ha` | `character` | categorical | n/a | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `gwqlasso_rs`, la ou les reponses `Yield_kg_ha` viennent du loader papier et/ou des preuves de l article `An application of geographically weighted quantile lasso to weather index insurance design`. Les covariables X retenues sont `precip_annual_mm` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`muni_lon`, `muni_lat`), identifiants (`Municipality`, `State`, `station_id`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | count | 0% |
| `name_norm` | `character` | categorical | 0% |
| `precip_annual_mm` | `numeric` | continuous | 7.3% |

### Formule - niveau publication

- formula_pub: Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]
- x_terms_pub: SPI_1month (Standardized Precipitation Index, 1 mois, derive de la precipitation quotidienne par ajustement de loi gamma)
- y_term_pub: Yield_kg_ha (rendement du soja, kg/ha, niveau municipal)
- Reference publication: Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Meme depot/methodologie que gwqlasso_pr (voir cette entree et README_source.txt) -- decoupe Rio Grande do Sul du meme jeu de donnees brutes complet (1030 municipalites/3 Etats).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Yield_kg_ha ~ precip_annual_mm
- x_terms_used: precip_annual_mm
- y_term_used: Yield_kg_ha
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Yield_kg_ha ~ precip_annual_mm"
    response: "Yield_kg_ha (rendement du soja, kg/ha, niveau municipal)"
    predictors: ["SPI_1month (Standardized Precipitation Index, 1 mois, derive de la precipitation quotidienne par ajustement de loi gamma)"]
    role: "simple_baseline"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
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
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gwr", "quantile_regression", "lasso", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_gwqlasso_rs`
- Dataset name: Rendement de soja et precipitation, municipalites de Mato Grosso (decoupe depuis le depot brut complet 3-Etats)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: An application of geographically weighted quantile lasso to weather index insurance design
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Meme depot/methodologie que gwqlasso_pr (voir cette entree et README_source.txt) -- decoupe Rio Grande do Sul du meme jeu de donnees brutes complet (1030 municipalites/3 Etats)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "precip_annual_mm est un proxy simplifie (station la plus proche, total annuel) du SPI 1-mois publie, pas une reproduction exacte -- 7% de precip_annual_mm manquant ; N=21371, Etat (Rio Grande do Sul) hors du perimetre geographique exact decrit dans l'abstract du papier (Parana uniquement) -- promu a package_include='yes' apres validation utilisateur (session 2026-08-16, groupe A)"
  reason: "Y continu reel (Yield_kg_ha), municipalites geocodees via reference IBGE publique, precipitation reelle jointe par station la plus proche. Decoupe Etat depuis le depot brut complet sur decision utilisateur 2026-08-15."
```

- Decision: ready
- Manque principal: precip_annual_mm est un proxy simplifie (station la plus proche, total annuel) du SPI 1-mois publie, pas une reproduction exacte -- 7% de precip_annual_mm manquant ; N=21371, Etat (Rio Grande do Sul) hors du perimetre geographique exact decrit dans l'abstract du papier (Parana uniquement) -- promu a package_include="yes" apres validation utilisateur (session 2026-08-16, groupe A)
- Raison: Y continu reel (Yield_kg_ha), municipalites geocodees via reference IBGE publique, precipitation reelle jointe par station la plus proche. Decoupe Etat depuis le depot brut complet sur decision utilisateur 2026-08-15.

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

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 21371
- k variables: 12
- T periods: 43
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (21371) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 497 ; panel EQUILIBRE (chaque unite a exactement T=43 observations). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 497 unites spatiales distinctes, pas sur les 21371 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 43 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-57.5497, -49.7333], y [-33.6866, -27.1607]
- Time range: 1974 to 2016 (variable: Year)
- CRS analyse recommande: 32722 (UTM Zone 22S (EPSG:32722)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`gwqlasso_rs` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `gwqlasso_rs` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`gwqlasso_rs` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: An application of geographically weighted quantile lasso to weather index insurance design

