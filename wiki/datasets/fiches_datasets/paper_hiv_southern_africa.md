---
title: paper_hiv_southern_africa
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_hiv_southern_africa.rds
  - DataCite_2024_SpatialDistributionHIVSouthernAfrica_10_1371_journal_pone_0301850
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial distribution and determinants of HIV high burden in the Southern African sub-region" (DOI 10.1371/journal.pone.0301850).

## Description du jeu de donnees

- Topic: public_health
- Observation unit: observation spatiale du dataset "DHS cluster-level HIV prevalence (NEG/POS/TOT/PER) with GPS coordinates, 6 Southern African countries"
- Observed population: Regression multivariable + autocorrelation spatiale (LISA/hotspot) sur la prevalence VIH par cluster DHS dans 6 pays d'Afrique australe (Malawi 2015, Mozambique 2015, Namibie 2013, Afrique du Sud 2017, Zambie 2018, Zimbabwe 2015)
- Geographic context: Coordonnees GPS reelles des clusters DHS (LATNUM/LONGNUM), CRS EPSG:4326.
- Temporal context: 4 distinct periods (variable: DHSYEAR)
- Source description: Spatial distribution and determinants of HIV high burden in the Southern African sub-region
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1371/journal.pone.0301850
- Dataset DOI: 10.25413/sun.26976469
- Source URL: https://figshare.com/s/33e95ee4594a7c146e3b
- Local raw dir: `data/raw/papers/DataCite_2024_SpatialDistributionHIVSouthernAfrica_10_1371_journal_pone_0301850/`
- Local sf output: `data/final_datasets/sf/paper_hiv_southern_africa.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `PER`
- Candidate Y typology: count
- Candidate X variables in local artifact: `DHSYEAR`, `URBAN_RURA`, `NEG`, `POS`, `TOT`
- Candidate X count in local artifact: 5
- Candidate X typology: continuous, categorical
- Published X variables from paper: URBAN_RURA (classification urbain/rural du cluster), country (6 pays d'Afrique australe), DHSYEAR (annee d'enquete DHS, 2013-2018), region administrative ADM1
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `LONGNUM`, `LATNUM`
- Identifier columns (excluded from X candidates): `DHSID`, `country`, `region`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PER` | `integer` | count | [0, 100] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `hiv_southern_africa`, la ou les reponses `PER` viennent du loader papier et/ou des preuves de l article `Spatial distribution and determinants of HIV high burden in the Southern African sub-region`. Les covariables X retenues sont `URBAN_RURA` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LONGNUM`, `LATNUM`), identifiants (`DHSID`, `country`, `region`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `DHSYEAR` | `integer` | count | 0% |
| `URBAN_RURA` | `character` | categorical | 0% |
| `NEG` | `integer` | count | 0% |
| `POS` | `integer` | count | 0% |
| `TOT` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: PER ~ URBAN_RURA + country + DHSYEAR [regression multivariable, plus autocorrelation spatiale (LISA/hotspot) sur PER par pays]
- x_terms_pub: URBAN_RURA (classification urbain/rural du cluster), country (6 pays d'Afrique australe), DHSYEAR (annee d'enquete DHS, 2013-2018), region administrative ADM1
- y_term_pub: PER (taux de positivite VIH par cluster DHS, %)
- Reference publication: Adetokunboh, O.O. & Are, E.B. (2024), PLoS ONE 19(4): e0301850, doi:10.1371/journal.pone.0301850. Le depot figshare (10.25413/sun.26976469, mirroir https://figshare.com/s/33e95ee4594a7c146e3b) ne contient QUE les donnees geographiques agregees par cluster DHS (NEG/POS/TOT/PER + coordonnees + URBAN_RURA) utilisees pour l'analyse d'autocorrelation spatiale (LISA/hotspot par pays). La regression multivariable complete du papier (determinants: divorce, age, ISTs recentes) utilise des microdonnees DHS individuelles (DHS Individual Recode) qui necessitent un enregistrement separe aupres du DHS Program et ne sont PAS incluses dans ce depot -- formula_used se limite donc aux covariables reellement presentes dans les donnees locales.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: PER ~ URBAN_RURA + country
- x_terms_used: URBAN_RURA
- y_term_used: PER
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
    formula: "PER ~ URBAN_RURA + country"
    response: "PER (taux de positivite VIH par cluster DHS, %)"
    predictors: ["URBAN_RURA (classification urbain/rural du cluster)", "country (6 pays d'Afrique australe)", "DHSYEAR (annee d'enquete DHS, 2013-2018)", "region administrative ADM1"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "PER ~ URBAN_RURA + country + DHSYEAR"
    response: "PER"
    predictors: ["URBAN_RURA", "country", "DHSYEAR"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gwr", "car", "random_forest", "logistic_binomial_POS_TOT"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_hiv_southern_africa`
- Dataset name: DHS cluster-level HIV prevalence (NEG/POS/TOT/PER) with GPS coordinates, 6 Southern African countries
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial distribution and determinants of HIV high burden in the Southern African sub-region
- Paper DOI: 10.1371/journal.pone.0301850
- Dataset DOI: 10.25413/sun.26976469
- Source URL: https://figshare.com/s/33e95ee4594a7c146e3b
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "PER ~ URBAN_RURA + country + DHSYEAR [regression multivariable, plus autocorrelation spatiale (LISA/hotspot) sur PER par pays]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Adetokunboh, O.O. & Are, E.B. (2024), PLoS ONE 19(4): e0301850, doi:10.1371/journal.pone.0301850. Le depot figshare (10.25413/sun.26976469, mirroir https://figshare.com/s/33e95ee4594a7c146e3b) ne contient QUE les donnees geographiques agregees par cluster DHS (NEG/POS/TOT/PER + coordonnees + URBAN_RURA) utilisees pour l'analyse d'autocorrelation spatiale (LISA/hotspot par pays). La regression multivariable complete du papier (determinants: divorce, age, ISTs recentes) utilise des microdonnees DHS individuelles (DHS Individual Recode) qui necessitent un enregistrement separe aupres du DHS Program et ne sont PAS incluses dans ce depot -- formula_used se limite donc aux covariables reellement presentes dans les donnees locales."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_rate"
  package_include: "yes"
  has_local_rds: true
  missing_items: "regression multivariable complete du papier (divorce, age, ISTs) necessite les microdonnees DHS individuelles (DHS Individual Recode), non incluses dans le depot public et non re-telechargeables sans enregistrement DHS Program separe -- formula_used se limite aux covariables cluster-level reellement presentes (URBAN_RURA, country, DHSYEAR)"
  reason: "Y continu reel (PER, taux de positivite VIH par cluster DHS, %), coordonnees GPS reelles des clusters (LATNUM/LONGNUM), N=3347 sur 6 pays d'Afrique australe (2013-2018). Depot recupere via mirroir figshare cite explicitement dans le papier (Data Availability Statement), pas une reconstruction."
```

- Decision: ready
- Manque principal: regression multivariable complete du papier (divorce, age, ISTs) necessite les microdonnees DHS individuelles (DHS Individual Recode), non incluses dans le depot public et non re-telechargeables sans enregistrement DHS Program separe -- formula_used se limite aux covariables cluster-level reellement presentes (URBAN_RURA, country, DHSYEAR)
- Raison: Y continu reel (PER, taux de positivite VIH par cluster DHS, %), coordonnees GPS reelles des clusters (LATNUM/LONGNUM), N=3347 sur 6 pays d'Afrique australe (2013-2018). Depot recupere via mirroir figshare cite explicitement dans le papier (Data Availability Statement), pas une reconstruction.

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
- N observations: 3347
- k variables: 14
- T periods: 4
- Variable temporelle: DHSYEAR
- N/T profile: N_grand_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (3347) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 3338 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=10). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 3338 unites spatiales distinctes, pas sur les 3347 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 4 distinct periods (variable: DHSYEAR)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [0, 40.704213], y [-34.463232, 0]
- Time range: 2013 to 2018 (variable: DHSYEAR)
- CRS analyse recommande: pending - multi-zones (span=40.7deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`hiv_southern_africa` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `hiv_southern_africa` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`hiv_southern_africa` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial distribution and determinants of HIV high burden in the Southern African sub-region

