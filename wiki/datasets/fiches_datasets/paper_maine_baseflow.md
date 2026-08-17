---
title: paper_maine_baseflow
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_maine_baseflow.rds
  - DataCite_2021_ModelEstimatedBaseflowFor_10_1002_rra_3835
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA" (DOI 10.1002/rra.3835).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale du dataset "Spatial Coverage for Estimated Baseflow for Streams Containing Endangered Atlantic Salmon in Maine, USA (version 1.1, June 2022)"
- Observed population: ModÃ¨le de rÃ©gression pour estimer le dÃ©bit de base (baseflow) dans les cours d'eau du Maine
- Geographic context: etendue sf: x [-70.9797222, -67.725], y [43.3791667, 46.1430556]
- Temporal context: none (cross-sectional)
- Source description: Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1002/rra.3835
- Dataset DOI: 10.5066/p9krsnu7
- Source URL: https://www.sciencebase.gov/catalog/item/620408c1d34e622189de5ad6
- Local raw dir: `data/raw/papers/DataCite_2021_ModelEstimatedBaseflowFor_10_1002_rra_3835/`
- Local sf output: `data/final_datasets/sf/paper_maine_baseflow.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `aug_baseflow_m3s_km2`
- Candidate Y typology: rate
- Candidate X variables in local artifact: `drainage_area_km2`, `pct_sand_gravel_aquifer`, `july_precip_mm`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous
- Published X variables from paper: pct_sand_gravel_aquifer, july_precip_mm
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `dec_long`, `dec_lat`
- Identifier columns (excluded from X candidates): `id`, `site_no`, `streamgage_name_paper`, `streamgage_name_usgs`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `aug_baseflow_m3s_km2` | `numeric` | rate | [0.0014, 0.0116] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `maine_baseflow`, la ou les reponses `aug_baseflow_m3s_km2` viennent du loader papier et/ou des preuves de l article `Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA`. Les covariables X retenues sont `pct_sand_gravel_aquifer`, `july_precip_mm` ; 1 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`dec_long`, `dec_lat`), identifiants (`id`, `site_no`, `streamgage_name_paper`, `streamgage_name_usgs`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `drainage_area_km2` | `numeric` | continuous | 0% |
| `pct_sand_gravel_aquifer` | `numeric` | continuous | 0% |
| `july_precip_mm` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: aug_baseflow_m3s_km2 ~ pct_sand_gravel_aquifer + july_precip_mm [BFaug = -0.006765 + 0.0001074*AQ + 0.0001033*JULAVEPRE, Eq. 1 p.1258]
- x_terms_pub: pct_sand_gravel_aquifer, july_precip_mm
- y_term_pub: aug_baseflow_m3s_km2
- Reference publication: Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0001074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). CORRIGE le 2026-08-15 : le loader utilisait auparavant le shapefile Dryad/ScienceBase (Maine_Mean_August_Baseflow.shp, 42449 troncons NHDPlus), qui n'est PAS la table d'apprentissage du papier mais la carte de PREDICTION du modele applique a tout le reseau hydrographique de l'Etat (section 2.4 'Mapping') -- ce qui avait fait passer la fiche package_include=yes a tort sur un produit de prediction, pas 42449 observations independantes. Le loader lit maintenant table1_gage_stations.csv, transcription de la vraie Table 1 (p.1257, N=31 stations de jaugeage USGS reelles utilisees pour calibrer le modele) + coordonnees recuperees via l'API USGS NWIS Site Service pour les 31 numeros de station publics (voir README_table1_gage_stations.txt dans le dossier raw). DASQMI (surface du bassin) servait uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele -- non repris dans le loader.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: aug_baseflow_m3s_km2 ~ pct_sand_gravel_aquifer + july_precip_mm
- x_terms_used: pct_sand_gravel_aquifer, july_precip_mm
- y_term_used: aug_baseflow_m3s_km2
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
    formula: "aug_baseflow_m3s_km2 ~ pct_sand_gravel_aquifer + july_precip_mm"
    response: "aug_baseflow_m3s_km2"
    predictors: ["pct_sand_gravel_aquifer", "july_precip_mm"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
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

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_maine_baseflow`
- Dataset name: Spatial Coverage for Estimated Baseflow for Streams Containing Endangered Atlantic Salmon in Maine, USA (version 1.1, June 2022)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA
- Paper DOI: 10.1002/rra.3835
- Dataset DOI: 10.5066/p9krsnu7
- Source URL: https://www.sciencebase.gov/catalog/item/620408c1d34e622189de5ad6
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "aug_baseflow_m3s_km2 ~ pct_sand_gravel_aquifer + july_precip_mm [BFaug = -0.006765 + 0.0001074*AQ + 0.0001033*JULAVEPRE, Eq. 1 p.1258]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0001074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). CORRIGE le 2026-08-15 : le loader utilisait auparavant le shapefile Dryad/ScienceBase (Maine_Mean_August_Baseflow.shp, 42449 troncons NHDPlus), qui n'est PAS la table d'apprentissage du papier mais la carte de PREDICTION du modele applique a tout le reseau hydrographique de l'Etat (section 2.4 'Mapping') -- ce qui avait fait passer la fiche package_include=yes a tort sur un produit de prediction, pas 42449 observations independantes. Le loader lit maintenant table1_gage_stations.csv, transcription de la vraie Table 1 (p.1257, N=31 stations de jaugeage USGS reelles utilisees pour calibrer le modele) + coordonnees recuperees via l'API USGS NWIS Site Service pour les 31 numeros de station publics (voir README_table1_gage_stations.txt dans le dossier raw). DASQMI (surface du bassin) servait uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele -- non repris dans le loader."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "N=31 seulement (petit echantillon, cf. table1_gage_stations.csv) ; les 2 predicteurs sont exactement ceux de l'equation publiee, aucune covariable ML additionnelle disponible"
  reason: "CORRIGE le 2026-08-15 : le loader utilisait a tort le shapefile de PREDICTION (42449 troncons NHDPlus, sortie du modele applique a tout l'Etat, section 2.4 du papier), pas une table d'apprentissage -- la fiche etait promue package_include=yes sur cette base erronee. Reconstruit avec la vraie table de calibration (Table 1 p.1257, N=31 stations de jaugeage USGS reelles, coordonnees recuperees via l'API USGS NWIS pour les numeros de station publics). Y continu (aug_baseflow_m3s_km2), X = les 2 predicteurs exacts de l'equation publiee (Eq.1 p.1258), coordonnees reelles -- promu a nouveau apres correction."
```

- Decision: ready
- Manque principal: N=31 seulement (petit echantillon, cf. table1_gage_stations.csv) ; les 2 predicteurs sont exactement ceux de l'equation publiee, aucune covariable ML additionnelle disponible
- Raison: CORRIGE le 2026-08-15 : le loader utilisait a tort le shapefile de PREDICTION (42449 troncons NHDPlus, sortie du modele applique a tout l'Etat, section 2.4 du papier), pas une table d'apprentissage -- la fiche etait promue package_include=yes sur cette base erronee. Reconstruit avec la vraie table de calibration (Table 1 p.1257, N=31 stations de jaugeage USGS reelles, coordonnees recuperees via l'API USGS NWIS pour les numeros de station publics). Y continu (aug_baseflow_m3s_km2), X = les 2 predicteurs exacts de l'equation publiee (Eq.1 p.1258), coordonnees reelles -- promu a nouveau apres correction.

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
- N observations: 31
- k variables: 12
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_petit_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-70.9797222, -67.725], y [43.3791667, 46.1430556]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32619 (UTM Zone 19N (EPSG:32619)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`maine_baseflow` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `maine_baseflow` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`maine_baseflow` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA

