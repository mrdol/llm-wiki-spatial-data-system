---
title: R_GWmodel_LondonHP_londonhp
type: dataset
created: 2026-08-15
updated: 2026-09-16
sources:
  - data/final_datasets/sf/R_GWmodel_LondonHP_londonhp.rds
tags: [dataset, r-package, spatial, point]
---

A house price data set with 18 hedonic variables for London in 2001.

## Description du jeu de donnees

- Topic: immobilier / prix des logements
- Observation unit: logement, transaction immobiliere ou zone residentielle selon la documentation source
- Observed population: marche immobilier documente par le package source
- Geographic context: Etendue mesuree dans le RDS : x [507399.99999999965, 552300.0000000005], y [159400.00000000081, 194900.000000001]; CRS EPSG:27700.
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: A house price data set with 18 hedonic variables for London in 2001.
- Description source: package R `GWmodel`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PURCHASE`
- Candidate Y typology: continuous
- Candidate X variables: `FLOORSZ`, `TYPEDETCH`, `TPSEMIDTCH`, `TYPETRRD`, `TYPEBNGLW`, `TYPEFLAT`, `BLDPWW1`, `BLDPOSTW`, `BLD60S`, `BLD70S`, `BLD80S`, `BLD90S`, `BLDINTW`, `BATH2`, `BEDS2`, `GARAGE1`, `CENTHEAT`, `UNEMPLOY`, `PROF`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PURCHASE` | `numeric` | continuous | [45000, 567500] | 0% |

> Correction 2026-09-15 (mode production de secours, tools::Rd_db("GWmodel")) : la ligne "Note doc" precedente etait tronquee/corrompue (bug d'extraction automatique) et a ete retiree.

> Selection Y/X (claude-sonnet-4-6) : PURCHASE (prix d'achat) est la variable réponse naturelle d'un modèle hédonique de prix immobiliers. Toutes les autres colonnes sont des attributs hédoniques du logement (surface, type, époque de construction, équipements) ou des indicateurs socio-économiques du voisinage (chômage, proportion de professions libérales), qui constituent des covariables explicatives classiques dans ce type de modèle.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `FLOORSZ` | `numeric` | continuous | 0% |
| `TYPEDETCH` | `integer` | binary | 0% |
| `TPSEMIDTCH` | `integer` | binary | 0% |
| `TYPETRRD` | `integer` | binary | 0% |
| `TYPEBNGLW` | `integer` | binary | 0% |
| `TYPEFLAT` | `integer` | binary | 0% |
| `BLDPWW1` | `integer` | binary | 0% |
| `BLDPOSTW` | `integer` | binary | 0% |
| `BLD60S` | `integer` | binary | 0% |
| `BLD70S` | `integer` | binary | 0% |
| `BLD80S` | `integer` | binary | 0% |
| `BLD90S` | `integer` | binary | 0% |
| `BLDINTW` | `integer` | binary | 0% |
| `BATH2` | `integer` | binary | 0% |
| `BEDS2` | `integer` | binary | 0% |
| `GARAGE1` | `integer` | binary | 0% |
| `CENTHEAT` | `integer` | binary | 0% |
| `UNEMPLOY` | `numeric` | rate | 0% |
| `PROF` | `numeric` | rate | 0% |

### Formule — niveau publication

- formula_pub: PURCHASE ~ FLOORSZ + PROF + BATH2
- x_terms_pub: FLOORSZ, PROF, BATH2
- y_term_pub: PURCHASE
- Reference publication: Lu, B., Charlton, M., Harris, P., Fotheringham, A.S. (2014) Geographically weighted regression with a non-Euclidean distance metric: a case study using hedonic house price data. International Journal of Geographical Information Science, 28(4): 660-681, DOI 10.1080/13658816.2013.865739

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: verbatim
- Methode d'estimation: procedure "pseudo stepwise" OLS/GWR decrite en Section 4.2.1 du papier (selection ascendante par AICc)
- Correspondance Python/R: aucune identifiee
- Note: Citation verbatim retrouvee dans le texte integral du papier (corpus/papers/tei/Geographicallyweightedregressionwithanon-Euclideandistance.tei.xml, section "Hedonic variable selection") : "a model with FLOORSZ as the hedonic variable produces the lowest AICc for the first round of bivariate regressions... for the regressions with two hedonic variables, a model with FLOORSZ and PROF produces the lowest AICc... (i.e. first FLOORSZ, then PROF, then BATH2, etc., which is the order given in the legend)." Confirme exactement formula_pub. Correction 2026-09-15 : le champ "Correspondance Python/R" citait a tort R_GWmodel_LondonBorough_londonborough, qui n'est pas une fiche existante ni une correspondance Python/R (LondonBorough est un fichier de contours administratifs du meme package GWmodel, utilise uniquement pour l'affichage cartographique).

### Formule — niveau systeme

- formula_used: PURCHASE ~ FLOORSZ + PROF + BATH2
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: FLOORSZ, PROF, BATH2
- y_term_used: PURCHASE

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "PURCHASE ~ FLOORSZ + PROF + BATH2"
    response: "PURCHASE"
    predictors: ["FLOORSZ, PROF, BATH2"]
    role: "simple_baseline"
    source_type: "scientific_publication_or_package_documentation"
    source_ref: "Lu, B., Charlton, M., Harris, P., Fotheringham, A.S. (2014) Geographically weighted regression with a non-Euclidean distance metric: a case study using hedonic house price data. International Journal of Geographical Information Science, 28(4): 660-681, DOI 10.1080/13658816.2013.865739"
    estimator_context: ["linear_regression", "kriging_auxiliary", "spatial_baseline"]
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

- Dataset ID: `R_GWmodel_LondonHP_londonhp`
- Dataset name: GWmodel::LondonHP
- Source family: r-package
- Source: package R `GWmodel` (version 2.4.1)
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: 10.1080/13658816.2013.865739
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PURCHASE ~ FLOORSZ + PROF + BATH2"
  equation_family: regression
  model_family: "formule publication confirmee et utilisee"
  source_type: scientific_publication_or_package_documentation
  source_ref: "Lu, B., Charlton, M., Harris, P., Fotheringham, A.S. (2014) Geographically weighted regression with a non-Euclidean distance metric: a case study using hedonic house price data. International Journal of Geographical Information Science, 28(4): 660-681"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 316
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee ; verification 2026-09-15 (tools::Rd_db("GWmodel")) : la documentation du package mentionne 372 observations, mais l'objet reellement charge par data(LondonHP) et le .rds local n'en comptent que 316 (verifie directement via nrow()) -- N observations reflete l'artefact local reel, pas le chiffre de la documentation.

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [507400, 552300], y [159400, 194900] (EPSG:27700)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 27700
- CRS nom: OSGB36 / British National Grid
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique. (EPSG:27700, OSGB36 / British National Grid)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_spatial_package_formula"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Formule issue d une publication/documentation package, reponse numerique, covariables locales et support spatial disponibles.

## Estimator eligibility

```yaml
estimator_eligibility:
  - estimator: ols
    basis: scientific_evidence
    source_ref: "Lu, Charlton, Harris & Fotheringham (2014), IJGIS."
    notes: "Hedonic house price reference model used as global baseline."
  - estimator: gam_spatial
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful smooth spatial baseline for the London house price data."
  - estimator: mgwrsar_gwr
    basis: scientific_evidence
    source_ref: "Lu, Charlton, Harris & Fotheringham (2014), IJGIS."
    notes: "LondonHP is a direct GWR hedonic house price case study."
  - estimator: mgwrsar_mgwr
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful for multiscale local coefficient tests."
  - estimator: MGWRSAR_0_kc_kv
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful for mixed stationary/non-stationary MGWRSAR tests without SAR autocorrelation."
  - estimator: MGWRSAR_1_kc_kv
    basis: benchmark_use
    source_ref: "spatialtidymodels package benchmark metadata."
    notes: "Useful for mixed stationary/non-stationary MGWRSAR tests with SAR autocorrelation."
```


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: OK - CRS renseigne dans le Bloc 5 (27700).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `GWmodel`

## Curation documentée — 2026-09-07

Verification 2026-09-15 (mode production de secours) : lecture directe du texte integral du papier Lu et al. (2014) disponible dans le corpus (corpus/papers/tei/Geographicallyweightedregressionwithanon-Euclideandistance.tei.xml, section 4.2.1 "Global regressions"/"Hedonic variable selection") confirme verbatim l'ordre d'inclusion des variables (FLOORSZ, puis PROF, puis BATH2) deja retenu dans formula_pub -- Niveau de preuve releve de "publication" a "verbatim". Ligne "Note doc" tronquee supprimee. Champ "Correspondance Python/R" corrige (citait a tort une fiche R_GWmodel_LondonBorough_londonborough qui n'existe pas). N observations (316) verifie coherent avec l'objet R reellement charge par data(LondonHP), bien que la documentation du package mentionne 372 -- ecart documente honnetement plutot que silencieusement ignore.

Correction 2026-09-16 (mode production de secours) : le champ 'CRS analyse recommande' affirmait a tort que le CRS source etait non geographique/inconnu alors qu'il etait deja renseigne juste au-dessus -- corrige (voir le champ lui-meme pour le texte actuel).
