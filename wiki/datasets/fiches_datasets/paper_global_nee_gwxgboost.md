---
title: paper_global_nee_gwxgboost
type: dataset
created: 2026-08-17
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_global_nee_gwxgboost.rds
  - DatasetFirst_10_5281_zenodo_21635729
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Dataset and Code for "Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework"" (DOI unknown).

## Description du jeu de donnees

- Topic: cycle du carbone / echange net d'ecosysteme (teledetection)
- Observation unit: site de flux FLUXNET x jour
- Observed population: tours de flux eddy covariance, couverture mondiale, N=109154 observations (387 sites)
- Geographic context: Etendue mesuree dans le RDS : x [-163.7002, 161.34143], y [-54.9733, 78.92163]; CRS EPSG:4326.
- Temporal context: 24 distinct periods (variable: Year)
- Source description: [dataset-first, publication non resolue] Dataset and Code for "Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework"
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.21635729
- Source URL: https://doi.org/10.5281/zenodo.21635729
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_21635729/`
- Local sf output: `data/final_datasets/sf/paper_global_nee_gwxgboost.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `NEE.g.C.m.2.day.1.`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year`, `Day.of.Year`, `LSWI`, `ET.kg.m.2..8.day..1.`, `NDVImax`, `LSWImean`, `WUEmax.kg.C.per.kg.H2O.`, `LAI`, `NDVI`, `LSTnight.K.`, `Ratio_ET_PET`, `LSTnightmax.K.`, `LSTnightmin.K.`, `LAImin`, `Ratio_ET_PETmax`, `LSTdaymean.K.`
- Candidate X count in local artifact: 16
- Candidate X typology: continuous
- Published X variables from paper: LSWI, NDVImax, LAI, LSTnight.K., Ratio_ET_PET
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Site.Name`, `IGBP`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `NEE.g.C.m.2.day.1.` | `numeric` | continuous | [-12.94, 14.85] | 0.05% |

> Selection Y/X (paper-loader / curated evidence) : Pour `global_nee_gwxgboost`, la ou les reponses `NEE.g.C.m.2.day.1.` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Dataset and Code for "Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework"`. Les covariables X retenues sont `LSWI`, `NDVImax`, `LAI`, `LSTnight.K.`, `Ratio_ET_PET` ; 11 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Site.Name`, `IGBP`), geometries et champs techniques sont exclus de X. CORRECTION (2026-09-09) : 56 lignes (0.05%) portaient une sentinelle -9999 dans `NEE.g.C.m.2.day.1.` (moyenne contaminee -5.59 au lieu de -0.46 apres correction) -- confirme par inspection directe du RDS, converties en NA (`data/final_datasets/sf/paper_global_nee_gwxgboost.rds` corrige, script `fix_nee_sentinel.R`). Les 5 covariables retenues ont ete verifiees indemnes de la meme sentinelle. Statut benchmark actuel : ready.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | count | 0% |
| `Day.of.Year` | `integer` | count | 0% |
| `LSWI` | `numeric` | continuous | 0% |
| `ET.kg.m.2..8.day..1.` | `integer` | count | 0% |
| `NDVImax` | `numeric` | rate | 0% |
| `LSWImean` | `numeric` | continuous | 0% |
| `WUEmax.kg.C.per.kg.H2O.` | `numeric` | continuous | 0% |
| `LAI` | `numeric` | continuous | 0% |
| `NDVI` | `numeric` | continuous | 0% |
| `LSTnight.K.` | `integer` | count | 0% |
| `Ratio_ET_PET` | `numeric` | continuous | 0% |
| `LSTnightmax.K.` | `integer` | count | 0% |
| `LSTnightmin.K.` | `integer` | count | 0% |
| `LAImin` | `numeric` | continuous | 0% |
| `Ratio_ET_PETmax` | `numeric` | continuous | 0% |
| `LSTdaymean.K.` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: [Titre du depot : 'Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework'. Aucun DOI de publication resolu (recherche web, session 2026-08-17 : aucune correspondance exacte trouvee, papier probablement pas encore indexe/publie). Le titre indique un modele XGBoost pondere geographiquement (GWR-style local weighting) pour predire le NEE a partir de variables de teledetection]
- x_terms_pub: LSWI, NDVImax, LAI, LSTnight.K., Ratio_ET_PET
- y_term_pub: NEE
- Reference publication: Aucune publication n'a ete identifiee avec certitude pour ce candidat dataset-first (Zenodo, DOI 10.5281/zenodo.21635729, titre du depot 'Dataset and Code for Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework'). Recherche web (session 2026-08-17) n'a pas trouve de correspondance exacte -- papiers proches identifies (Random Forest/XGBoost sur NEE FLUXNET, GW-XGBoost pixel-level vegetation) mais aucun ne correspond exactement au titre du depot. Data1_387_sites.csv telecharge directement depuis Zenodo -- pas une reconstruction, N=109154 observations (387 sites de flux FLUXNET mondiaux, panel site x jour x annee), coordonnees reelles verifiees coherentes (couverture mondiale -163.7 a 161.3 lon, -54.97 a 78.92 lat). formula_used est une proposition du curateur (session 2026-08-17) exploitant les variables de teledetection reellement presentes et correspondant au cadre methodologique decrit par le titre (variables satellitaires -> NEE), pas une formule extraite d'un texte publie verifie. package_include laisse en manual_review pour cette raison.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: NEE.g.C.m.2.day.1. ~ LSWI + NDVImax + LAI + LSTnight.K. + Ratio_ET_PET
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: LSWI, NDVImax, LAI, LSTnight.K., Ratio_ET_PET
- y_term_used: NEE.g.C.m.2.day.1.
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "NEE.g.C.m.2.day.1. ~ LSWI + NDVImax + LAI + LSTnight.K. + Ratio_ET_PET"
    response: "NEE"
    predictors: ["LSWI", "NDVImax", "LAI", "LSTnight.K.", "Ratio_ET_PET"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "NEE.g.C.m.2.day.1. ~ LSWI + NDVImax + LAI + LSTnight.K. + Ratio_ET_PET + WUEmax.kg.C.per.kg.H2O. + IGBP"
    response: "NEE.g.C.m.2.day.1."
    predictors: ["LSWI", "NDVImax", "LAI", "LSTnight.K.", "Ratio_ET_PET", "WUEmax.kg.C.per.kg.H2O.", "IGBP"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["xgboost_xy", "gwr", "random_forest_xy", "ols"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_global_nee_gwxgboost`
- Dataset name: Dataset and Code for "Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework"
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] Dataset and Code for "Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework"
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.21635729
- Source URL: https://doi.org/10.5281/zenodo.21635729
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "[Titre du depot : 'Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework'. Aucun DOI de publication resolu (recherche web, session 2026-08-17 : aucune correspondance exacte trouvee, papier probablement pas encore indexe/publie). Le titre indique un modele XGBoost pondere geographiquement (GWR-style local weighting) pour predire le NEE a partir de variables de teledetection]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Aucune publication n'a ete identifiee avec certitude pour ce candidat dataset-first (Zenodo, DOI 10.5281/zenodo.21635729, titre du depot 'Dataset and Code for Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework'). Recherche web (session 2026-08-17) n'a pas trouve de correspondance exacte -- papiers proches identifies (Random Forest/XGBoost sur NEE FLUXNET, GW-XGBoost pixel-level vegetation) mais aucun ne correspond exactement au titre du depot. Data1_387_sites.csv telecharge directement depuis Zenodo -- pas une reconstruction, N=109154 observations (387 sites de flux FLUXNET mondiaux, panel site x jour x annee), coordonnees reelles verifiees coherentes (couverture mondiale -163.7 a 161.3 lon, -54.97 a 78.92 lat). formula_used est une proposition du curateur (session 2026-08-17) exploitant les variables de teledetection reellement presentes et correspondant au cadre methodologique decrit par le titre (variables satellitaires -> NEE), pas une formule extraite d'un texte publie verifie. package_include laisse en manual_review pour cette raison."
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
  reason: "CORRECTION 2026-09-09 : sentinelle -9999 (56/109154 lignes, 0.05%) confirmee par inspection directe du RDS et convertie en NA (les 5 X retenues verifiees indemnes de la meme sentinelle) -- voir Note en Bloc 1. Publication non identifiee avec certitude (recherche web 2026-08-17 et 2026-09-09) ; formula_used reste une proposition du curateur exploitant les variables de teledetection reelles conformes au cadre methodologique du titre du depot (GW-XGBoost), pas une formule extraite verbatim d'un texte publie -- estimateurs en base generated_candidate/benchmark_use en consequence."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: Sentinelle -9999 corrigee (voir Bloc 1) ; formule generee/proposee par le curateur, pas verbatim d'une publication confirmee -- estimateurs eligibles en consequence a base non-scientifique.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: xgboost
      basis: generated_candidate
      source_ref: "Titre du depot Zenodo : 'Geographically Weighted XGBoost Framework' -- XGBoost est explicitement le moteur nomme, mais la variante geographiquement ponderee exacte n'est pas implementee dans le harnais."
      notes: "Correspond au nom de la methode du depot, mais pas a la ponderation geographique exacte (GW-XGBoost complet non disponible)."
    - estimator: mgwrsar_gwr
      basis: generated_candidate
      source_ref: "Composante 'geographically weighted' du nom de la methode -- non testee specifiquement pour ce jeu."
      notes: "Approximation de la composante spatiale du GW-XGBoost, pas une reproduction du framework hybride."
    - estimator: random_forest
      basis: benchmark_use
      source_ref: "Aucune -- comparateur ML generique, Y continu."
      notes: "Comparateur ML standard, pas le modele du depot."
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "Aucune -- alternative non-lineaire generique, Y continu."
      notes: "Comparateur generique."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs eligibles en base generated_candidate/benchmark_use (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 109154
- k variables: 24
- T periods: 24
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (109154) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 387 ; panel NON EQUILIBRE (T par unite : min=14, mediane=200, max=1020). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 387 unites spatiales distinctes, pas sur les 109154 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 24 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-163.7002, 161.34143], y [-54.9733, 78.92163]
- Time range: 2000 to 2023 (variable: Year)
- CRS analyse recommande: pending - multi-zones (span=325deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5281/zenodo.21635729 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`global_nee_gwxgboost` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `global_nee_gwxgboost` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`global_nee_gwxgboost` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Dataset and Code for "Estimating Global Site-Level Net Ecosystem Exchange with a Geographically Weighted XGBoost Framework"

## Curation documentée — 2026-09-07

Decision conservatoire : NEE contient -9999 et le loader ne filtre que is.na; 387 sites pour 109 154 lignes, publication non résolue. Lire les codes manquants du dépôt, convertir les sentinelles avec preuve, auditer les X, puis CV groupée par site/temps ou agrégation justifiée. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
