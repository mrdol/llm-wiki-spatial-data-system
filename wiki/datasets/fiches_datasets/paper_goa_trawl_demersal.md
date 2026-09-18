---
title: paper_goa_trawl_demersal
type: dataset
created: 2026-09-14
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_goa_trawl_demersal.rds
  - DatasetFirst_10_5061_dryad_j3t86
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill" (DOI 10.1093/icesjms/fsx079).

## Description du jeu de donnees

- Topic: halieutique / communautes demersales et impact ecologique
- Observation unit: trait de chalut (station-annee)
- Observed population: communautes de poissons demersaux, Golfe d'Alaska, releves triennaux/biennaux 1984-2011, N=9213 traits
- Geographic context: Etendue mesuree dans le RDS : x [-169.96897, -132.6795], y [52.426, 60.3205]; CRS EPSG:4326.
- Temporal context: 12 distinct periods (variable: Year)
- Source description: Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1093/icesjms/fsx079
- Dataset DOI: 10.5061/dryad.j3t86
- Source URL: https://doi.org/10.5061/dryad.j3t86
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_j3t86/`
- Local sf output: `data/final_datasets/sf/paper_goa_trawl_demersal.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Atheresthesstomias`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year`, `BottomDepth`, `BottomTemp`, `SurfTemp`, `log.BottomDepth`, `log.BottomDepth2`
- Candidate X count in local artifact: 6
- Candidate X typology: unknown, continuous
- Published X variables from paper: log(BottomDepth) centre, terme lineaire et quadratique (seule covariable fixe utilisee par le papier pour tous les modeles d'occurrence et de CPUE positive)
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `Lon`, `Lat`
- Identifier columns (excluded from X candidates): `Station`, `Stratum`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Atheresthesstomias` | `numeric` | continuous | [0, 6639.2201] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `goa_trawl_demersal`, la ou les reponses `Atheresthesstomias` viennent du loader papier et/ou des preuves de l article `Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill`. Les covariables X retenues sont `log.BottomDepth`, `log.BottomDepth2` ; 4 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Lon`, `Lat`), identifiants (`Station`, `Stratum`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | unknown | 0% |
| `BottomDepth` | `integer` | unknown | 0% |
| `BottomTemp` | `numeric` | continuous | 16.2% |
| `SurfTemp` | `numeric` | continuous | 0% |
| `log.BottomDepth` | `numeric` | continuous | 0.1% |
| `log.BottomDepth2` | `numeric` | continuous | 0.1% |

### Formule - niveau publication

- formula_pub: logit(p_it(s)) = X_t(s)*beta_i + e_it(s) [GLMM binomial pour la probabilite d'occurrence + sous-modele positif pour la CPUE conditionnelle, avec effets fixes log(profondeur) lineaire+quadratique et effets aleatoires spatio-temporels autoregressifs (AR1) par espece ; e_it(s) capture la correlation spatiale residuelle par annee de releve, non reproductible sans re-estimer le modele complet]
- x_terms_pub: log(BottomDepth) centre, terme lineaire et quadratique (seule covariable fixe utilisee par le papier pour tous les modeles d'occurrence et de CPUE positive)
- y_term_pub: CPUE de fletan a dents fines (Atheresthes stomias, arrowtooth flounder), espece la plus frequemment capturee du jeu de donnees (8270/9213 traits non-nuls)
- Reference publication: Shelton et al. (2017), Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill, ICES Journal of Marine Science, doi:10.1093/icesjms/fsx079. Le papier ajuste un GLMM binomial (occurrence) + modele positif (CPUE|presence) avec log(profondeur) lineaire/quadratique comme seule covariable fixe, et des effets aleatoires spatio-temporels AR1 par espece (equation 1-2 du texte). Ces effets aleatoires ne sont pas reproductibles sans re-estimer le modele INLA complet ; formula_used retient la partie effets fixes exacte du papier (log-profondeur lineaire+quadratique) comme regression continue de base. Donnees brutes (goa_trawl_albers.csv, table station x annee x espece) telechargees directement depuis Dryad (10.5061/dryad.j3t86) -- pas une reconstruction, N=9213 traits de chalut, Golfe d'Alaska, 1984-2011. BottomTemp/SurfTemp sont des covariables reelles supplementaires du meme fichier, ajoutees uniquement a la variante ml_or_selected.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formule - niveau systeme

- formula_used: Atheresthesstomias ~ log.BottomDepth + log.BottomDepth2
- License evidence: DataCite API record for DOI 10.5061/dryad.j3t86 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Recommended validation: N lignes=9213; T declare=12; variable temporelle declaree=Year; repetitions de coordonnees controlees=1. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: log.BottomDepth, log.BottomDepth2
- y_term_used: Atheresthesstomias
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Atheresthesstomias ~ log.BottomDepth + log.BottomDepth2"
    response: "CPUE de fletan a dents fines (Atheresthes stomias, arrowtooth flounder), espece la plus frequemment capturee du jeu de donnees (8270/9213 traits non-nuls)"
    predictors: ["log(BottomDepth) centre, terme lineaire et quadratique (seule covariable fixe utilisee par le papier pour tous les modeles d'occurrence et de CPUE positive)"]
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
    formula: "Atheresthesstomias ~ log.BottomDepth + log.BottomDepth2 + BottomTemp + SurfTemp"
    response: "Atheresthesstomias"
    predictors: ["log.BottomDepth", "log.BottomDepth2", "BottomTemp", "SurfTemp"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gam_spatial", "random_forest", "random_forest_xy", "xgboost", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_goa_trawl_demersal`
- Dataset name: Data from: Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill
- Paper DOI: 10.1093/icesjms/fsx079
- Dataset DOI: 10.5061/dryad.j3t86
- Source URL: https://doi.org/10.5061/dryad.j3t86
- Year: 2017

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "logit(p_it(s)) = X_t(s)*beta_i + e_it(s) [GLMM binomial pour la probabilite d'occurrence + sous-modele positif pour la CPUE conditionnelle, avec effets fixes log(profondeur) lineaire+quadratique et effets aleatoires spatio-temporels autoregressifs (AR1) par espece ; e_it(s) capture la correlation spatiale residuelle par annee de releve, non reproductible sans re-estimer le modele complet]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Shelton et al. (2017), Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill, ICES Journal of Marine Science, doi:10.1093/icesjms/fsx079. Le papier ajuste un GLMM binomial (occurrence) + modele positif (CPUE|presence) avec log(profondeur) lineaire/quadratique comme seule covariable fixe, et des effets aleatoires spatio-temporels AR1 par espece (equation 1-2 du texte). Ces effets aleatoires ne sont pas reproductibles sans re-estimer le modele INLA complet ; formula_used retient la partie effets fixes exacte du papier (log-profondeur lineaire+quadratique) comme regression continue de base. Donnees brutes (goa_trawl_albers.csv, table station x annee x espece) telechargees directement depuis Dryad (10.5061/dryad.j3t86) -- pas une reconstruction, N=9213 traits de chalut, Golfe d'Alaska, 1984-2011. BottomTemp/SurfTemp sont des covariables reelles supplementaires du meme fichier, ajoutees uniquement a la variante ml_or_selected."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Y/X/formula_used deja resolus ; estimateurs generiques (continuous) ajoutes en revue de lot du 2026-09-09.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: ols
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Regression lineaire standard, baseline generique pour reponse continue."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "GAM (mgcv), baseline non-lineaire generique pour reponse continue."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Revue en lot du 2026-09-09 -- voir Note ci-dessous."
      notes: "Alternative ML non-parametrique generique, Y continu."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 9213
- k variables: 14
- T periods: 12
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (9213) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 9212 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=2). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 9212 unites spatiales distinctes, pas sur les 9213 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 12 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-169.96897, -132.6795], y [52.426, 60.3205]
- Time range: 1984 to 2011 (variable: Year)
- CRS analyse recommande: pending — multi-zones (span=37.3deg) -- etendue compatible avec un grand pays/une region ; verifier qu'une projection nationale/regionale existe et convient a cette zone avant de l'utiliser, sinon envisager une projection continentale equal-area

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`goa_trawl_demersal` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `goa_trawl_demersal` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`goa_trawl_demersal` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatio-temporal models reveal subtle changes to demersal communities following the Exxon Valdez oil spill

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=9213; T declare=12; variable temporelle declaree=Year; repetitions de coordonnees controlees=1. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
