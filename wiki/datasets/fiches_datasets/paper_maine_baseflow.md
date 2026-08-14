---
title: paper_maine_baseflow
type: dataset
created: 2026-08-12
updated: 2026-08-12
sources:
  - data/final_datasets/sf/paper_maine_baseflow.rds
  - DataCite_2021_ModelEstimatedBaseflowFor_10_1002_rra_3835
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA" (DOI 10.1002/rra.3835).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale du dataset "Spatial Coverage for Estimated Baseflow for Streams Containing Endangered Atlantic Salmon in Maine, USA (version 1.1, June 2022)"
- Observed population: Modèle de régression pour estimer le débit de base (baseflow) dans les cours d'eau du Maine
- Geographic context: etendue sf: x [337043.4434, 659017.6324], y [4773100.5419, 5144797.4945]
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

- Candidate Y variables: `AUGAVGBF`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `From_Node`, `To_Node`, `DASQMI`, `SANDGRAVAF`, `JULYAVPRE`, `OOB_DA`, `OOB_JULYAV`, `OOB_SANDGR`, `OOB_WARNIN`, `REGULATED`
- Candidate X count in local artifact: 10
- Candidate X typology: continuous, categorical
- Published X variables from paper: SANDGRAVAF, JULYAVPRE
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `GNIS_Name`, `ReachCode`, `NHDPlusID`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `AUGAVGBF` | `numeric` | continuous | [0.09, 1.34] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `maine_baseflow`, la ou les reponses `AUGAVGBF` viennent du loader papier et/ou des preuves de l article `Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA`. Les covariables X retenues sont `SANDGRAVAF`, `JULYAVPRE` ; 8 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`GNIS_Name`, `ReachCode`, `NHDPlusID`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `From_Node` | `numeric` | continuous | 0% |
| `To_Node` | `numeric` | continuous | 0% |
| `DASQMI` | `numeric` | continuous | 0% |
| `SANDGRAVAF` | `numeric` | continuous | 0% |
| `JULYAVPRE` | `numeric` | continuous | 0% |
| `OOB_DA` | `numeric` | binary | 0% |
| `OOB_JULYAV` | `numeric` | binary | 0% |
| `OOB_SANDGR` | `numeric` | binary | 0% |
| `OOB_WARNIN` | `numeric` | binary | 0% |
| `REGULATED` | `numeric` | binary | 0% |

### Formule - niveau publication

- formula_pub: AUGAVGBF ~ SANDGRAVAF + JULYAVPRE [BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE, Eq. 1 p.1258]
- x_terms_pub: SANDGRAVAF, JULYAVPRE
- y_term_pub: AUGAVGBF
- Reference publication: Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). DASQMI (surface du bassin) sert uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele publie. REGULATED n'apparait dans aucune equation du texte -- c'est un attribut d'exclusion de bassins regules herite du shapefile NHDPlus (section 2.1: 'basins ... minimal human alterations such as dams or withdrawals'), pas une covariable de regression. Les champs OOB_* sont des indicateurs de validation out-of-bag et restent exclus de X.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-12). Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). DASQMI (surface du bassin) sert uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele publie. REGULATED n'apparait dans aucune equation du texte -- c'est un attribut d'exclusion de bassins regules herite du shapefile NHDPlus (section 2.1: 'basins ... minimal human alterations such as dams or withdrawals'), pas une covariable de regression. Les champs OOB_* sont des indicateurs de validation out-of-bag et restent exclus de X.

### Formule - niveau systeme

- formula_used: AUGAVGBF ~ SANDGRAVAF + JULYAVPRE
- x_terms_used: SANDGRAVAF, JULYAVPRE
- y_term_used: AUGAVGBF
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-12). Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). DASQMI (surface du bassin) sert uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele publie. REGULATED n'apparait dans aucune equation du texte -- c'est un attribut d'exclusion de bassins regules herite du shapefile NHDPlus (section 2.1: 'basins ... minimal human alterations such as dams or withdrawals'), pas une covariable de regression. Les champs OOB_* sont des indicateurs de validation out-of-bag et restent exclus de X.

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
    formula: "AUGAVGBF ~ SANDGRAVAF + JULYAVPRE"
    response: "AUGAVGBF"
    predictors: ["SANDGRAVAF", "JULYAVPRE"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). DASQMI (surface du bassin) sert uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele publie. REGULATED n'apparait dans aucune equation du texte -- c'est un attribut d'exclusion de bassins regules herite du shapefile NHDPlus (section 2.1: 'basins ... minimal human alterations such as dams or withdrawals'), pas une covariable de regression. Les champs OOB_* sont des indicateurs de validation out-of-bag et restent exclus de X."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "AUGAVGBF ~ DASQMI + SANDGRAVAF + JULYAVPRE + REGULATED"
    response: "AUGAVGBF"
    predictors: ["DASQMI", "SANDGRAVAF", "JULYAVPRE", "REGULATED"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "Superset genere par le systeme a partir des champs numeriques/binaires disponibles dans le shapefile local (Maine_Mean_August_Baseflow.shp), au-dela des 2 predicteurs de l'equation publiee -- DASQMI et REGULATED n'ont pas de statut de covariable confirme par le papier, a traiter comme features ML exploratoires seulement."
    estimator_context: ["random_forest", "xgboost", "gamboost"]
    status: "generated"
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
  equation_text: "AUGAVGBF ~ SANDGRAVAF + JULYAVPRE [BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE, Eq. 1 p.1258]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Lombard, Dudley, Collins, Saunders & Atkinson (2021), River Research and Applications, DOI 10.1002/rra.3835, Eq. (1) p.1258: BFaug = -0.006765 + 0.0010074*AQ + 0.0001033*JULAVEPRE (AQ = pourcentage d'aquiferes sable/gravier du bassin, JULAVEPRE = precipitation moyenne de juillet). DASQMI (surface du bassin) sert uniquement a normaliser la reponse (baseflow par km2, section 2.3), ce n'est pas une covariable du modele publie. REGULATED n'apparait dans aucune equation du texte -- c'est un attribut d'exclusion de bassins regules herite du shapefile NHDPlus (section 2.1: 'basins ... minimal human alterations such as dams or withdrawals'), pas une covariable de regression. Les champs OOB_* sont des indicateurs de validation out-of-bag et restent exclus de X."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "geometrie source LINESTRING (reseau hydrographique) ; deja convertie en POINT (geom_point, st_point_on_surface) dans l'artefact local via build_unified_sf(), famille geom_family='ligne' geree nativement -- pas un blocage"
  reason: "AUGAVGBF et covariables NHDPlus (SANDGRAVAF, JULYAVPRE) confirmees par l'equation publiee (Eq.1 p.1258). Y continu, X defendables, artefact local deja en POINT et utilisable -- promu sans revue manuelle (2026-08-12)."
```

- Decision: ready
- Manque principal: geometrie source LINESTRING (reseau hydrographique) ; deja convertie en POINT (geom_point, st_point_on_surface) dans l'artefact local via build_unified_sf(), famille geom_family='ligne' geree nativement -- pas un blocage
- Raison: AUGAVGBF et covariables NHDPlus (SANDGRAVAF, JULYAVPRE) confirmees par l'equation publiee (Eq.1 p.1258). Y continu, X defendables, artefact local deja en POINT et utilisable -- promu sans revue manuelle (2026-08-12).

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors, coordinates/geometry and required W are executable in the local artifact"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 42449
- k variables: 16
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 26919
- CRS nom: NAD83 / UTM zone 19N
- Spatial extent: x [337043.4434, 659017.6324], y [4773100.5419, 5144797.4945]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

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
- CRS: OK - CRS renseigne dans le Bloc 5 (26919).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: GNIS_Name (NA=32.2%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`maine_baseflow` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Model estimated baseflow for streams with endangered Atlantic Salmon in Maine, USA

