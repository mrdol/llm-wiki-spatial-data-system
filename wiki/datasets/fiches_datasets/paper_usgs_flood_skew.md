---
title: paper_usgs_flood_skew
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_usgs_flood_skew.rds
  - DataCite_2021_MethodsForEstimatingRegional_10_3133_sir20215
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "unknown" (DOI unknown).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: a preciser depuis le papier source
- Geographic context: etendue sf: x [1419075, 1871925], y [1870974.8125, 2537880]
- Temporal context: 70 distinct periods (variable: BegYear)
- Source description: unknown
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: none
- Source URL: unknown
- Local raw dir: `data/raw/papers/DataCite_2021_MethodsForEstimatingRegional_10_3133_sir20215/`
- Local sf output: `data/final_datasets/sf/paper_usgs_flood_skew.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `UnbiasSkew`, `EMAskew`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `LAT_GAGE`, `LNG_GAGE`, `DRNAREA`, `DRAIN_SQKM`, `BSLDEM100M`, `ELEV`, `COMPRAT`, `LC06FOREST`, `LC06WATER`, `PERMAVE`, `PRECPRIS00`, `NumPks`, `PksNotUsed`, `GagedPks`, `HistPks`, `BegYear`, `EndYear`, `HistPeriod`, `PILFthresh`, `PILFs`, `KENTAU`, `PVALUE`, `SENSLOPE`, `EMAmean`, `EMAStDev`, `MSEskew`, `MSEskewSYS`, `PRL`, `residual`
- Candidate X count in local artifact: 29
- Candidate X typology: continuous, categorical
- Published X variables from paper: DRAIN_SQKM (superficie du bassin versant, km2), LAT_CENT/LONG_CENT (centroide du bassin), BSLDEM100M (pente moyenne du bassin), ELEV (elevation), COMPRAT (ratio de compacite), LC06FOREST (% couverture forestiere), LC06WATER (% couverture en eau), PERMAVE (permeabilite moyenne du sol), PRECPRIS00 (precipitation moyenne)
- Published X count: 9
- Coordinates (x, y - excluded from X candidates): `LONG_CENT`, `LAT_CENT`
- Identifier columns (excluded from X candidates): `IndexNo`, `site_no`, `station_nm`, `state_cd`, `huc_cd`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `UnbiasSkew` | `numeric` | continuous | [-1.65, 1.66] | 0% |
| `EMAskew` | `numeric` | continuous | [-1.41, 1.553] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `usgs_flood_skew`, la ou les reponses `UnbiasSkew`, `EMAskew` viennent du loader papier et/ou des preuves de l article `unknown`. Les covariables X retenues sont `DRAIN_SQKM`, `BSLDEM100M`, `ELEV`, `COMPRAT`, `LC06FOREST`, `LC06WATER`, `PERMAVE`, `PRECPRIS00` ; 21 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LONG_CENT`, `LAT_CENT`), identifiants (`IndexNo`, `site_no`, `station_nm`, `state_cd`, `huc_cd`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `LAT_GAGE` | `numeric` | continuous | 0% |
| `LNG_GAGE` | `numeric` | continuous | 0% |
| `DRNAREA` | `numeric` | continuous | 0% |
| `DRAIN_SQKM` | `numeric` | continuous | 0% |
| `BSLDEM100M` | `numeric` | continuous | 0% |
| `ELEV` | `numeric` | continuous | 0% |
| `COMPRAT` | `numeric` | continuous | 0% |
| `LC06FOREST` | `numeric` | continuous | 0% |
| `LC06WATER` | `numeric` | continuous | 0% |
| `PERMAVE` | `numeric` | continuous | 0% |
| `PRECPRIS00` | `numeric` | continuous | 0% |
| `NumPks` | `numeric` | continuous | 0% |
| `PksNotUsed` | `numeric` | continuous | 0% |
| `GagedPks` | `numeric` | continuous | 0% |
| `HistPks` | `numeric` | continuous | 0% |
| `BegYear` | `numeric` | continuous | 0% |
| `EndYear` | `numeric` | continuous | 0% |
| `HistPeriod` | `numeric` | continuous | 0% |
| `PILFthresh` | `character` | categorical | 0% |
| `PILFs` | `numeric` | continuous | 0% |
| `KENTAU` | `numeric` | continuous | 0% |
| `PVALUE` | `numeric` | rate | 0% |
| `SENSLOPE` | `numeric` | continuous | 0% |
| `EMAmean` | `numeric` | continuous | 0% |
| `EMAStDev` | `numeric` | rate | 0% |
| `MSEskew` | `numeric` | rate | 0% |
| `MSEskewSYS` | `numeric` | rate | 0% |
| `PRL` | `numeric` | continuous | 0% |
| `residual` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00 [Bayesian Weighted Least Squares / Bayesian Generalized Least Squares (B-WLS/B-GLS), asymetrie regionale des crues annuelles de pointe]
- x_terms_pub: DRAIN_SQKM (superficie du bassin versant, km2), LAT_CENT/LONG_CENT (centroide du bassin), BSLDEM100M (pente moyenne du bassin), ELEV (elevation), COMPRAT (ratio de compacite), LC06FOREST (% couverture forestiere), LC06WATER (% couverture en eau), PERMAVE (permeabilite moyenne du sol), PRECPRIS00 (precipitation moyenne)
- y_term_pub: UnbiasSkew (asymetrie regionale non biaisee des debits de pointe annuels)
- Reference publication: Veilleux, A.G. & Wagner, D.M. (2021), Methods for estimating regional skewness of annual peak flows in parts of eastern New York and Pennsylvania, based on data through water year 2013, USGS Scientific Investigations Report 2021-5015, doi:10.3133/sir20215015. Shapefile HU02basins.shp telecharge directement depuis ScienceBase (10.5066/p9pgal0d, item enfant 5ea08b8e82cefae35a13fe2b) -- pas une reconstruction, N=183 stations de jaugeage identique au depot source. UnbiasSkew = estimation finale non biaisee de l'asymetrie regionale (methode EMA + correction B-WLS/B-GLS documentee dans le rapport) ; les 10 caracteristiques de bassin correspondent exactement aux variables independantes decrites dans le rapport (drainage area, centroid, slope, elevation, compactness, land cover, permeability, precipitation).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00
- x_terms_used: DRAIN_SQKM, BSLDEM100M, ELEV, COMPRAT, LC06FOREST, LC06WATER, PERMAVE, PRECPRIS00
- y_term_used: UnbiasSkew
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
    formula: "UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00"
    response: "UnbiasSkew (asymetrie regionale non biaisee des debits de pointe annuels)"
    predictors: ["DRAIN_SQKM (superficie du bassin versant, km2)", "LAT_CENT/LONG_CENT (centroide du bassin)", "BSLDEM100M (pente moyenne du bassin)", "ELEV (elevation)", "COMPRAT (ratio de compacite)", "LC06FOREST (% couverture forestiere)", "LC06WATER (% couverture en eau)", "PERMAVE (permeabilite moyenne du sol)", "PRECPRIS00 (precipitation moyenne)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00"
    response: "UnbiasSkew"
    predictors: ["DRAIN_SQKM", "LAT_CENT", "LONG_CENT", "BSLDEM100M", "ELEV", "COMPRAT", "LC06FOREST", "LC06WATER", "PERMAVE", "PRECPRIS00"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["bayesian_wls", "bayesian_gls", "ols", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_usgs_flood_skew`
- Dataset name: unknown
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: unknown
- Paper DOI: unknown
- Dataset DOI: none
- Source URL: unknown
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "UnbiasSkew ~ DRAIN_SQKM + LAT_CENT + LONG_CENT + BSLDEM100M + ELEV + COMPRAT + LC06FOREST + LC06WATER + PERMAVE + PRECPRIS00 [Bayesian Weighted Least Squares / Bayesian Generalized Least Squares (B-WLS/B-GLS), asymetrie regionale des crues annuelles de pointe]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Veilleux, A.G. & Wagner, D.M. (2021), Methods for estimating regional skewness of annual peak flows in parts of eastern New York and Pennsylvania, based on data through water year 2013, USGS Scientific Investigations Report 2021-5015, doi:10.3133/sir20215015. Shapefile HU02basins.shp telecharge directement depuis ScienceBase (10.5066/p9pgal0d, item enfant 5ea08b8e82cefae35a13fe2b) -- pas une reconstruction, N=183 stations de jaugeage identique au depot source. UnbiasSkew = estimation finale non biaisee de l'asymetrie regionale (methode EMA + correction B-WLS/B-GLS documentee dans le rapport) ; les 10 caracteristiques de bassin correspondent exactement aux variables independantes decrites dans le rapport (drainage area, centroid, slope, elevation, compactness, land cover, permeability, precipitation)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- shapefile original telecharge directement depuis ScienceBase (pas une reconstruction), N=183 identique au depot source"
  reason: "Y continu reel (UnbiasSkew), X = les 10 caracteristiques de bassin exactes du rapport USGS, geometrie polygonale originale (bassins versants). Dataset telecharge directement depuis la source officielle (ScienceBase), aucune reconstruction. Verifie manuellement le 2026-08-15 sur demande explicite de l'utilisateur avant promotion."
```

- Decision: ready
- Manque principal: aucun -- shapefile original telecharge directement depuis ScienceBase (pas une reconstruction), N=183 identique au depot source
- Raison: Y continu reel (UnbiasSkew), X = les 10 caracteristiques de bassin exactes du rapport USGS, geometrie polygonale originale (bassins versants). Dataset telecharge directement depuis la source officielle (ScienceBase), aucune reconstruction. Verifie manuellement le 2026-08-15 sur demande explicite de l'utilisateur avant promotion.

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
- N observations: 183
- k variables: 41
- T periods: 70
- Variable temporelle: BegYear
- N/T profile: N_moyen_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : verification empirique montre qu'il n'y a AUCUNE repetition de geometrie (N spatial = N observations exactement) malgre la classification 'Structure: panel_ou_series' / 'Data type: spatio-temporel' ci-dessus -- chaque ligne correspond a un lieu unique. Ce n'est donc pas un panel au sens statistique (pas de correlation intra-unite a modeliser), plutot une coupe transversale avec une covariable/dimension temporelle associee a chaque point distinct.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 70 distinct periods (variable: BegYear)
- CRS EPSG: unknown
- CRS nom: USA_Contiguous_Albers_Equal_Area_Conic_USGS_version
- Spatial extent: x [1419075, 1871925], y [1870974.8125, 2537880]
- Time range: 1829 to 1977 (variable: BegYear)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- License evidence: manual_review - Paper DOI and Source URL are both marked "unknown" in this fiche, so no source page exists to check a license against (2026-08-18), despite the "usgs" name suggesting a U.S. Geological Survey origin. Resolving this requires first identifying the source paper/dataset, which is out of scope for a license lookup alone.
- Reproducibility status: OK - loader R enregistre et reexecutable (`usgs_flood_skew` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `usgs_flood_skew` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`usgs_flood_skew` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: unknown

