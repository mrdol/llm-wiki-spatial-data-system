---
title: paper_rocha_agricultural_technology_brazil
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_rocha_agricultural_technology_brazil.rds
  - DataCite_2019_AgriculturalTechnologyAdoptionAnd_10_1080_1747423x
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Agricultural technology adoption and land use: evidence for Brazilian municipalities" (DOI 10.1080/1747423x.2019.1707312).

## Description du jeu de donnees

- Topic: agriculture / adoption technologique et usage des sols
- Observation unit: municipalite bresilienne
- Observed population: municipalites agricoles du Bresil
- Geographic context: etendue sf: x [-73.4961129845113, -32.418909344047], y [-33.650002, 4.7159435]
- Temporal context: none (cross-sectional)
- Source description: Agricultural technology adoption and land use: evidence for Brazilian municipalities
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1080/1747423x.2019.1707312
- Dataset DOI: 10.6084/m9.figshare.11492220
- Source URL: https://tandf.figshare.com/articles/Agricultural_technology_adoption_and_land_use_evidence_for_Brazilian_municipalities/11492220
- Local raw dir: `data/raw/papers/DataCite_2019_AgriculturalTechnologyAdoptionAnd_10_1080_1747423x/`
- Local sf output: `data/final_datasets/sf/paper_rocha_agricultural_technology_brazil.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `SOY`
- Candidate Y typology: rate
- Candidate X variables in local artifact: `MUNICíPIO`, `SEM_ACENTO`, `MUNICíPI0`, `REGIãO`, `MESO_IBG0`, `MICRO_IB0`, `MESO_IBG1`, `MICRO_IB1`, `AREA_97`, `SEDE`, `SEDE0`, `Z1`, `Z6`, `CODCOMP`, `COF`, `CHE`, `COC`, `CAN`, `BEA`, `MAI`, `PER`, `TL`, `PT`, `FT`, `TDJF`, `TMAM`, `TJJA`, `TSON`, `PDJF`, `PMAM`, `PJJA`, `PSON`, `COOX`, `COOY`, `DAMZ`, `DCAA`, `DCER`, `DPMP`, `DPTN`, `DMATL`, `K`, `H`, `ZTPRC`, `ZTCAN`, `ZTBEA`, `ZTMAI`, `ZTSOY`, `ZTCOC`, `ZTCOF`, `ZTCHE`, `ZTLT`, `ZTPT`, `ZTFT`, `ZTIMP`
- Candidate X count in local artifact: 54
- Candidate X typology: categorical, continuous
- Published X variables from paper: TDJF, TMAM, TJJA, TSON, PDJF, PMAM, PJJA, PSON, DAMZ, DCAA, DCER, DPMP, DPTN, DMATL
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `LONG`, `LATI`
- Identifier columns (excluded from X candidates): `MUN`, `COD6`, `COD7`, `UF`, `UF_IBGE`, `MESO_IBGE`, `MICRO_IBGE`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `SOY` | `numeric` | rate | [0, 0.7] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `rocha_agricultural_technology_brazil`, la ou les reponses `SOY` viennent du loader papier et/ou des preuves de l article `Agricultural technology adoption and land use: evidence for Brazilian municipalities`. Les covariables X retenues sont `TDJF`, `TMAM`, `TJJA`, `TSON`, `PDJF`, `PMAM`, `PJJA`, `PSON`, `DAMZ`, `DCAA`, `DCER`, `DPMP`, `DPTN`, `DMATL` ; 40 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LONG`, `LATI`), identifiants (`MUN`, `COD6`, `COD7`, `UF`, `UF_IBGE`, `MESO_IBGE`, `MICRO_IBGE`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `MUNICíPIO` | `character` | categorical | 0% |
| `SEM_ACENTO` | `character` | categorical | 0% |
| `MUNICíPI0` | `character` | categorical | 0% |
| `REGIãO` | `character` | categorical | 0% |
| `MESO_IBG0` | `character` | categorical | 0% |
| `MICRO_IB0` | `character` | categorical | 0% |
| `MESO_IBG1` | `character` | categorical | 0% |
| `MICRO_IB1` | `character` | categorical | 0% |
| `AREA_97` | `numeric` | continuous | 0% |
| `SEDE` | `numeric` | continuous | 0% |
| `SEDE0` | `numeric` | continuous | 0% |
| `Z1` | `numeric` | continuous | 0% |
| `Z6` | `numeric` | continuous | 0% |
| `CODCOMP` | `character` | categorical | 0% |
| `COF` | `numeric` | rate | 0% |
| `CHE` | `numeric` | rate | 0% |
| `COC` | `numeric` | rate | 0% |
| `CAN` | `numeric` | rate | 0% |
| `BEA` | `numeric` | rate | 0% |
| `MAI` | `numeric` | rate | 0% |
| `PER` | `numeric` | continuous | 0% |
| `TL` | `numeric` | rate | 0% |
| `PT` | `numeric` | rate | 0% |
| `FT` | `numeric` | rate | 0% |
| `TDJF` | `numeric` | continuous | 0% |
| `TMAM` | `numeric` | continuous | 0% |
| `TJJA` | `numeric` | continuous | 0% |
| `TSON` | `numeric` | continuous | 0% |
| `PDJF` | `numeric` | continuous | 0% |
| `PMAM` | `numeric` | continuous | 0% |
| `PJJA` | `numeric` | continuous | 0% |
| `PSON` | `numeric` | continuous | 0% |
| `COOX` | `numeric` | continuous | 0% |
| `COOY` | `numeric` | continuous | 0% |
| `DAMZ` | `numeric` | binary | 0% |
| `DCAA` | `numeric` | binary | 0% |
| `DCER` | `numeric` | binary | 0% |
| `DPMP` | `numeric` | binary | 0% |
| `DPTN` | `numeric` | binary | 0% |
| `DMATL` | `numeric` | binary | 0% |
| `K` | `numeric` | continuous | 0% |
| `H` | `numeric` | continuous | 0% |
| `ZTPRC` | `numeric` | continuous | 0% |
| `ZTCAN` | `numeric` | continuous | 0% |
| `ZTBEA` | `numeric` | continuous | 0% |
| `ZTMAI` | `numeric` | continuous | 0% |
| `ZTSOY` | `numeric` | continuous | 0% |
| `ZTCOC` | `numeric` | continuous | 0% |
| `ZTCOF` | `numeric` | continuous | 0% |
| `ZTCHE` | `numeric` | continuous | 0% |
| `ZTLT` | `numeric` | continuous | 0% |
| `ZTPT` | `numeric` | continuous | 0% |
| `ZTFT` | `numeric` | continuous | 0% |
| `ZTIMP` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: SOY ~ TDJF + TMAM + TJJA + TSON + PDJF + PMAM + PJJA + PSON + DAMZ + DCAA + DCER + DPMP + DPTN + DMATL
- x_terms_pub: TDJF, TMAM, TJJA, TSON, PDJF, PMAM, PJJA, PSON, DAMZ, DCAA, DCER, DPMP, DPTN, DMATL
- y_term_pub: SOY
- Reference publication: Formule importee depuis inst/kg/paper_dataset_uses.json (curation papier/DataCite). Agricultural technology adoption and land use: evidence for Brazilian municipalities

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule importee depuis inst/kg/paper_dataset_uses.json (curation papier/DataCite). Agricultural technology adoption and land use: evidence for Brazilian municipalities

### Formule - niveau systeme

- formula_used: SOY ~ TDJF + TMAM + TJJA + TSON + PDJF + PMAM + PJJA + PSON + DAMZ + DCAA + DCER + DPMP + DPTN + DMATL
- x_terms_used: TDJF, TMAM, TJJA, TSON, PDJF, PMAM, PJJA, PSON, DAMZ, DCAA, DCER, DPMP, DPTN, DMATL
- y_term_used: SOY
- Note: Formule importee depuis inst/kg/paper_dataset_uses.json (curation papier/DataCite). Agricultural technology adoption and land use: evidence for Brazilian municipalities

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
    formula: "SOY ~ TDJF + TMAM + TJJA + TSON + PDJF + PMAM + PJJA + PSON + DAMZ + DCAA + DCER + DPMP + DPTN + DMATL"
    response: "SOY"
    predictors: ["TDJF", "TMAM", "TJJA", "TSON", "PDJF", "PMAM", "PJJA", "PSON", "DAMZ", "DCAA", "DCER", "DPMP", "DPTN", "DMATL"]
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

- Dataset ID: `paper_rocha_agricultural_technology_brazil`
- Dataset name: Agricultural technology adoption and land use: evidence for Brazilian municipalities
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Agricultural technology adoption and land use: evidence for Brazilian municipalities
- Paper DOI: 10.1080/1747423x.2019.1707312
- Dataset DOI: 10.6084/m9.figshare.11492220
- Source URL: https://tandf.figshare.com/articles/Agricultural_technology_adoption_and_land_use_evidence_for_Brazilian_municipalities/11492220
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "SOY ~ TDJF + TMAM + TJJA + TSON + PDJF + PMAM + PJJA + PSON + DAMZ + DCAA + DCER + DPMP + DPTN + DMATL"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Formule importee depuis inst/kg/paper_dataset_uses.json (curation papier/DataCite). Agricultural technology adoption and land use: evidence for Brazilian municipalities"
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_rate"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CRS confirme WGS84 le 2026-08-15"
  reason: "Y continu/rate, covariables climatiques/distances et geometrie municipale sont disponibles; formule locale disponible dans le KG. CRS verifie le 2026-08-15 : le shapefile source (land_kr.shp) n'a pas de .prj, mais la bounding box (x:[-73.99,-32.38], y:[-33.75,5.27]) correspond exactement a l'etendue geographique du Bresil en degres decimaux (pas une projection metrique) -- WGS84 confirme par la geometrie elle-meme, coherent avec un shapefile municipal IBGE standard non documente."
```

- Decision: ready
- Manque principal: aucun -- CRS confirme WGS84 le 2026-08-15
- Raison: Y continu/rate, covariables climatiques/distances et geometrie municipale sont disponibles; formule locale disponible dans le KG. CRS verifie le 2026-08-15 : le shapefile source (land_kr.shp) n'a pas de .prj, mais la bounding box (x:[-73.99,-32.38], y:[-33.75,5.27]) correspond exactement a l'etendue geographique du Bresil en degres decimaux (pas une projection metrique) -- WGS84 confirme par la geometrie elle-meme, coherent avec un shapefile municipal IBGE standard non documente.

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
- N observations: 5507
- k variables: 66
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-73.4961129845113, -32.418909344047], y [-33.650002, 4.7159435]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=41.1deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`rocha_agricultural_technology_brazil` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `rocha_agricultural_technology_brazil` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`rocha_agricultural_technology_brazil` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Agricultural technology adoption and land use: evidence for Brazilian municipalities

