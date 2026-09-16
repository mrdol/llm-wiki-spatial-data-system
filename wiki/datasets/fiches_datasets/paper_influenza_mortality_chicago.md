---
title: paper_influenza_mortality_chicago
type: dataset
created: 2026-09-14
updated: 2026-09-16
sources:
  - data/final_datasets/sf/paper_influenza_mortality_chicago.rds
  - DataCite_2016_DisparitiesInInfluenzaMortality_10_1073_pnas_161
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918" (DOI 10.1073/pnas.1612838113).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale du dataset "Data from: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918"
- Observed population: Analyse spatiotemporelle de la mortalité grippale à Chicago en 1918 avec modèles Poisson GEE ; facteurs sociodémographiques (illettrisme, propriété, chômage) ; clustering spatiotemporel ; correspond au périmètre health / mortality / epidemiology / spatial autocorrelation / urban studies
- Geographic context: etendue sf: x [343002.47984075, 366885.347685765], y [555447.603044471, 594646.045600259]
- Temporal context: 7 distinct periods (variable: week)
- Source description: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1073/pnas.1612838113
- Dataset DOI: 10.5061/dryad.48nv3
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.48nv3
- Local raw dir: `data/raw/papers/DataCite_2016_DisparitiesInInfluenzaMortality_10_1073_pnas_161/`
- Local sf output: `data/final_datasets/sf/paper_influenza_mortality_chicago.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `counts`
- Candidate Y typology: unknown
- Candidate X variables in local artifact: `week`, `pop`, `Gross_acres`, `illit`, `illit.r`, `den.r`, `unemployed.pct`, `ho.pct`, `agecat1`, `agecat2`, `agecat3`, `agecat4`, `agecat5`, `agecat6`, `agecat7`
- Candidate X count in local artifact: 15
- Candidate X typology: unknown, continuous
- Published X variables from paper: illit, den.r, unemployed.pct, ho.pct, agecat1, agecat2, agecat3, agecat4, agecat5, agecat6, agecat7
- Published X count: 11
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `GISJOIN`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `counts` | `integer` | count | [0, 31] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `influenza_mortality_chicago`, la ou les reponses `counts` viennent du loader papier et/ou des preuves de l article `Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918`. Les covariables X retenues sont `illit`, `den.r`, `unemployed.pct`, `ho.pct`, `agecat1`, `agecat2`, `agecat3`, `agecat4`, `agecat5`, `agecat6`, `agecat7` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`GISJOIN`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `week` | `integer` | unknown | 0% |
| `pop` | `integer` | unknown | 0% |
| `Gross_acres` | `numeric` | continuous | 0% |
| `illit` | `integer` | unknown | 0% |
| `illit.r` | `numeric` | rate | 0% |
| `den.r` | `numeric` | continuous | 0% |
| `unemployed.pct` | `numeric` | rate | 0% |
| `ho.pct` | `numeric` | rate | 0% |
| `agecat1` | `integer` | unknown | 0% |
| `agecat2` | `integer` | unknown | 0% |
| `agecat3` | `integer` | unknown | 0% |
| `agecat4` | `integer` | unknown | 0% |
| `agecat5` | `integer` | unknown | 0% |
| `agecat6` | `integer` | unknown | 0% |
| `agecat7` | `integer` | unknown | 0% |

### Formule - niveau publication

- formula_pub: counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7, offset=pop
- x_terms_pub: illit, den.r, unemployed.pct, ho.pct, agecat1, agecat2, agecat3, agecat4, agecat5, agecat6, agecat7
- y_term_pub: counts
- Reference publication: Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7
- License evidence: DataCite API record for DOI 10.5061/dryad.48nv3 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Recommended validation: N lignes=3472; T declare=7; variable temporelle declaree=week; repetitions de coordonnees controlees=2976. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: illit, den.r, unemployed.pct, ho.pct, agecat1, agecat2, agecat3, agecat4, agecat5, agecat6, agecat7
- y_term_used: counts
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

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
    formula: "counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7"
    response: "counts"
    predictors: ["illit", "den.r", "unemployed.pct", "ho.pct", "agecat1", "agecat2", "agecat3", "agecat4", "agecat5", "agecat6", "agecat7"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
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

- Dataset ID: `paper_influenza_mortality_chicago`
- Dataset name: Data from: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918
- Paper DOI: 10.1073/pnas.1612838113
- Dataset DOI: 10.5061/dryad.48nv3
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.48nv3
- Year: 2016 (annee de depot Dryad/DataCite, non verifiee comme annee de publication de l'article -- voir Reference publication)

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "counts ~ illit + den.r + unemployed.pct + ho.pct + agecat1 + agecat2 + agecat3 + agecat4 + agecat5 + agecat6 + agecat7, offset=pop"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Grantz, Rane, Salje, Glass, Schachterle & Cummings (2016), PNAS, DOI 10.1073/pnas.1612838113; tracts.csv (Dryad 10.5061/dryad.48nv3) documente un panel tract x semaine (496 tracts x 7 semaines) avec deces (counts), population (pop, exposition) et covariables sociodemographiques ; jointure verifiee a la geometrie via GISJOIN du shapefile IL_tract_a.shp."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_count_spatiotemporal"
  package_include: "yes"
  has_local_rds: true
  missing_items: "structure panel tract x semaine (T=7) documentee ; a surveiller si le schema de CV du package suppose des observations independantes"
  reason: "counts, offset pop, covariables sociodemographiques et geometrie polygone (jointure GISJOIN verifiee) tous confirmes ; structure spatio-temporelle (496 tracts x 7 semaines). Y defendable (count + offset), X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12)."
```

- Decision: ready
- Manque principal: structure panel tract x semaine (T=7) documentee ; a surveiller si le schema de CV du package suppose des observations independantes
- Raison: counts, offset pop, covariables sociodemographiques et geometrie polygone (jointure GISJOIN verifiee) tous confirmes ; structure spatio-temporelle (496 tracts x 7 semaines). Y defendable (count + offset), X defendables, artefact local utilisable -- promu sans revue manuelle (2026-08-12).

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
- N observations: 3472
- k variables: 20
- T periods: 7
- Variable temporelle: week
- N/T profile: N_moyen_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (3472) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 496 ; panel EQUILIBRE (chaque unite a exactement T=7 observations). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 496 unites spatiales distinctes, pas sur les 3472 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 7 distinct periods (variable: week)
- CRS EPSG: 26971
- CRS nom: NAD83 / Illinois East
- Spatial extent: x [343002.47984075, 366885.347685765], y [555447.603044471, 594646.045600259]
- Time range: 1 to 7 (variable: week)
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique. (EPSG:26971, NAD83 / Illinois East) (correction 2026-09-16, mode production de secours : le texte precedent affirmait a tort "CRS source non geographique ou inconnu" alors que le CRS est deja connu et renseigne ci-dessus -- incoherence interne du meme type que celle corrigee sur paper_banff_stream_temperature.)

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`influenza_mortality_chicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `influenza_mortality_chicago` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (26971).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`influenza_mortality_chicago` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Disparities in influenza mortality and transmission related to sociodemographic factors within Chicago in the pandemic of 1918

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=3472; T declare=7; variable temporelle declaree=week; repetitions de coordonnees controlees=2976. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
