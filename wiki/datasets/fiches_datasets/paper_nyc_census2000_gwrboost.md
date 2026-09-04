---
title: paper_nyc_census2000_gwrboost
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_nyc_census2000_gwrboost.rds
  - GeoDaLab_2017_NYCCensus2000_geodacenter_data_and_lab
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "GWRBoost: A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships" (DOI 10.48550/arXiv.2212.05814).

## Description du jeu de donnees

- Topic: socio-economic
- Observation unit: observation spatiale du dataset "NYC education data set (NYC-Census-2000, GeoDa Lab)"
- Observed population: Section 4
- Geographic context: Geometrie polygonale originale (blocs de recensement NYC 2000), CRS NAD83 / New York Long Island (ftUS), EPSG:2263.
- Temporal context: none (cross-sectional)
- Source description: GWRBoost: A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.48550/arXiv.2212.05814
- Dataset DOI: none
- Source URL: https://geodacenter.github.io/data-and-lab/data/nyc_2000Census.zip
- Local raw dir: `data/raw/papers/GeoDaLab_2017_NYCCensus2000_geodacenter_data_and_lab/`
- Local sf output: `data/final_datasets/sf/paper_nyc_census2000_gwrboost.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `mean_inc`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `YOUTH_DROP`, `PER_MNRTY`, `HS_DROP`, `COL_DEGREE`, `PER_ASIAN`, `PER_WHITE`, `PER_BLACK`, `Shape_Leng`, `Shape_Area`, `NP_CT`, `pop1619`, `dropout`, `enrollhs`, `PER_PRV_SC`, `PER_PUB_SC`, `over3`, `notenroll`, `over3enr`, `pubsch`, `pub_pk`, `pub_k8`, `pub_hs`, `pub_col`, `privsch`, `priv_pk`, `priv_k8`, `priv_hs`, `priv_col`, `over25`, `subhs`, `hs`, `somecol`, `college`, `master`, `prof`, `phd`, `white`, `black`, `asian`, `sub18`, `GENDER_PAR`, `male`, `female`, `SCHOOL_CT`, `popdens`, `population`
- Candidate X count in local artifact: 46
- Candidate X typology: continuous
- Published X variables from paper: sub18 (population <18 ans), PER_PRV_SC (% eleves ecole privee), YOUTH_DROP (% decrocheurs 16-19 ans), HS_DROP (% decrocheurs lycee >25 ans), COL_DEGREE (% bachelor+ >25 ans), SCHOOL_CT (nombre d'ecoles)
- Published X count: 6
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `POLY_ID`, `CTLabel`, `BoroCode`, `BoroName`, `CT2000`, `BoroCT2000`, `NTACode`, `NTANAme`, `PUMA`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mean_inc` | `numeric` | continuous | [0, 188697] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `nyc_census2000_gwrboost`, la ou les reponses `mean_inc` viennent du loader papier et/ou des preuves de l article `GWRBoost: A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships`. Les covariables X retenues sont `sub18`, `PER_PRV_SC`, `YOUTH_DROP`, `HS_DROP`, `COL_DEGREE`, `SCHOOL_CT` ; 40 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`POLY_ID`, `CTLabel`, `BoroCode`, `BoroName`, `CT2000`, `BoroCT2000`, `NTACode`, `NTANAme`, `PUMA`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `YOUTH_DROP` | `numeric` | rate | 0% |
| `PER_MNRTY` | `numeric` | rate | 0% |
| `HS_DROP` | `numeric` | rate | 0% |
| `COL_DEGREE` | `numeric` | rate | 0% |
| `PER_ASIAN` | `numeric` | rate | 0% |
| `PER_WHITE` | `numeric` | rate | 0% |
| `PER_BLACK` | `numeric` | rate | 0% |
| `Shape_Leng` | `numeric` | continuous | 0% |
| `Shape_Area` | `numeric` | continuous | 0% |
| `NP_CT` | `numeric` | continuous | 0% |
| `pop1619` | `numeric` | continuous | 0% |
| `dropout` | `numeric` | continuous | 0% |
| `enrollhs` | `numeric` | continuous | 0% |
| `PER_PRV_SC` | `numeric` | rate | 0% |
| `PER_PUB_SC` | `numeric` | rate | 0% |
| `over3` | `numeric` | continuous | 0% |
| `notenroll` | `numeric` | continuous | 0% |
| `over3enr` | `numeric` | continuous | 0% |
| `pubsch` | `numeric` | continuous | 0% |
| `pub_pk` | `numeric` | continuous | 0% |
| `pub_k8` | `numeric` | continuous | 0% |
| `pub_hs` | `numeric` | continuous | 0% |
| `pub_col` | `numeric` | continuous | 0% |
| `privsch` | `numeric` | continuous | 0% |
| `priv_pk` | `numeric` | continuous | 0% |
| `priv_k8` | `numeric` | continuous | 0% |
| `priv_hs` | `numeric` | continuous | 0% |
| `priv_col` | `numeric` | continuous | 0% |
| `over25` | `numeric` | continuous | 0% |
| `subhs` | `numeric` | continuous | 0% |
| `hs` | `numeric` | continuous | 0% |
| `somecol` | `numeric` | continuous | 0% |
| `college` | `numeric` | continuous | 0% |
| `master` | `numeric` | continuous | 0% |
| `prof` | `numeric` | continuous | 0% |
| `phd` | `numeric` | continuous | 0% |
| `white` | `numeric` | continuous | 0% |
| `black` | `numeric` | continuous | 0% |
| `asian` | `numeric` | continuous | 0% |
| `sub18` | `numeric` | continuous | 0% |
| `GENDER_PAR` | `numeric` | continuous | 0% |
| `male` | `numeric` | continuous | 0% |
| `female` | `numeric` | continuous | 0% |
| `SCHOOL_CT` | `numeric` | continuous | 0% |
| `popdens` | `numeric` | continuous | 0% |
| `population` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT [GWR/GWRBoost, Table 2-3 : OLS R2=0.557, GWR R2=0.825, GWRBoost R2=0.882]
- x_terms_pub: sub18 (population <18 ans), PER_PRV_SC (% eleves ecole privee), YOUTH_DROP (% decrocheurs 16-19 ans), HS_DROP (% decrocheurs lycee >25 ans), COL_DEGREE (% bachelor+ >25 ans), SCHOOL_CT (nombre d'ecoles)
- y_term_pub: mean_inc (revenu moyen par bloc de recensement)
- Reference publication: Wang, Huang, Yin, Bao, Zhou & Gao (2022), arXiv:2212.05814 (GWRBoost, preprint). Section 4.3 'Empirical case study' cite explicitement le jeu de donnees et son URL (https://geodacenter.github.io/data-and-lab//NYC-Census-2000), Table 2 documente les 6 variables independantes exactes + mean_inc en reponse, Table 3-4 rapportent les resultats OLS/GWR/GWRBoost. Shapefile telecharge directement depuis GeoDa Lab -- N=2216 identique au papier, pas une reconstruction. Les 49 autres colonnes du shapefile (race, scolarisation detaillee, sexe, densite) ne font pas partie du cas d'etude publie.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT
- x_terms_used: sub18, PER_PRV_SC, YOUTH_DROP, HS_DROP, COL_DEGREE, SCHOOL_CT
- y_term_used: mean_inc
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
    formula: "mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT"
    response: "mean_inc (revenu moyen par bloc de recensement)"
    predictors: ["sub18 (population <18 ans)", "PER_PRV_SC (% eleves ecole privee)", "YOUTH_DROP (% decrocheurs 16-19 ans)", "HS_DROP (% decrocheurs lycee >25 ans)", "COL_DEGREE (% bachelor+ >25 ans)", "SCHOOL_CT (nombre d'ecoles)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT"
    response: "mean_inc"
    predictors: ["sub18", "PER_PRV_SC", "YOUTH_DROP", "HS_DROP", "COL_DEGREE", "SCHOOL_CT"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "random_forest", "xgboost", "gamboost"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_nyc_census2000_gwrboost`
- Dataset name: NYC education data set (NYC-Census-2000, GeoDa Lab)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: GWRBoost: A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships
- Paper DOI: 10.48550/arXiv.2212.05814
- Dataset DOI: none
- Source URL: https://geodacenter.github.io/data-and-lab/data/nyc_2000Census.zip
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "mean_inc ~ sub18 + PER_PRV_SC + YOUTH_DROP + HS_DROP + COL_DEGREE + SCHOOL_CT [GWR/GWRBoost, Table 2-3 : OLS R2=0.557, GWR R2=0.825, GWRBoost R2=0.882]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Wang, Huang, Yin, Bao, Zhou & Gao (2022), arXiv:2212.05814 (GWRBoost, preprint). Section 4.3 'Empirical case study' cite explicitement le jeu de donnees et son URL (https://geodacenter.github.io/data-and-lab//NYC-Census-2000), Table 2 documente les 6 variables independantes exactes + mean_inc en reponse, Table 3-4 rapportent les resultats OLS/GWR/GWRBoost. Shapefile telecharge directement depuis GeoDa Lab -- N=2216 identique au papier, pas une reconstruction. Les 49 autres colonnes du shapefile (race, scolarisation detaillee, sexe, densite) ne font pas partie du cas d'etude publie."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- shapefile original du papier telecharge directement (pas une reconstruction), N=2216 identique"
  reason: "Y continu reel (mean_inc), X = les 6 covariables exactes de Table 2 du papier, geometrie polygonale originale (blocs de recensement NYC 2000). Dataset telecharge directement depuis la source citee par le papier (GeoDa Lab), aucun ecart de millesime ni reconstruction -- meilleure fidelite possible."
```

- Decision: ready
- Manque principal: aucun -- shapefile original du papier telecharge directement (pas une reconstruction), N=2216 identique
- Raison: Y continu reel (mean_inc), X = les 6 covariables exactes de Table 2 du papier, geometrie polygonale originale (blocs de recensement NYC 2000). Dataset telecharge directement depuis la source citee par le papier (GeoDa Lab), aucun ecart de millesime ni reconstruction -- meilleure fidelite possible.

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
- N observations: 2216
- k variables: 58
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 2263
- CRS nom: NAD83 / New York Long Island (ftUS)
- Spatial extent: x [917606.095578856, 1065983.98587788], y [124324.53717341, 271806.815124512]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- License evidence: manual_review - checked https://geodacenter.github.io/data-and-lab/ (2026-08-18), no license/terms-of-use statement found on the GeoDa Center data-and-lab page for this file; underlying data is derived from US Census 2000 (public domain) but the GeoDa Center repackaging itself states no explicit reuse terms.
- Reproducibility status: OK - loader R enregistre et reexecutable (`nyc_census2000_gwrboost` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `nyc_census2000_gwrboost` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (2263).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`nyc_census2000_gwrboost` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: GWRBoost: A geographically weighted gradient boosting method for explainable quantification of spatially-varying relationships

