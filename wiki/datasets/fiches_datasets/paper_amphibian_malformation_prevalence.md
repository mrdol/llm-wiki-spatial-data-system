---
title: paper_amphibian_malformation_prevalence
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_amphibian_malformation_prevalence.rds
  - DataCite_2010_MultipleStressorsAndThe_10_1890_09_0879_
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Multiple stressors and the cause of amphibian abnormalities" (DOI 10.1890/09-0879.1).

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale du dataset "Data from: Multiple stressors and the cause of amphibian abnormalities"
- Observed population: RÃ©gression logistique pour prÃ©dire anomalies chez grenouilles en Alaska ; 21 zones humides avec coordonnÃ©es ; variables contaminants, prÃ©dateurs, parasites ; comparaison de modÃ¨les AIC ; 33 citations
- Geographic context: etendue sf: x [-151.37911, -150.00838], y [60.20227, 60.78709]
- Temporal context: none (cross-sectional)
- Source description: Multiple stressors and the cause of amphibian abnormalities
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1890/09-0879.1
- Dataset DOI: 10.5061/dryad.sq72d
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.sq72d
- Local raw dir: `data/raw/papers/DataCite_2010_MultipleStressorsAndThe_10_1890_09_0879_/`
- Local sf output: `data/final_datasets/sf/paper_amphibian_malformation_prevalence.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `prevalence_abnormal`, `prevalence_skel_ab`, `prevalence_eye_ab`, `prevalence_surf_ab`, `prevalence_bleeding_inj`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `n_frogs`, `ROADDISTANCE`, `RoadType`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous, categorical
- Published X variables from paper: ROADDISTANCE
- Published X count: 0
- Coordinates (x, y - excluded from X candidates): `LONGITUDE`, `LATITUDE`
- Identifier columns (excluded from X candidates): `SITE`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `prevalence_abnormal` | `numeric` | continuous | [1.8182, 31.0345] | 0% |
| `prevalence_skel_ab` | `numeric` | continuous | [0, 15.5172] | 0% |
| `prevalence_eye_ab` | `numeric` | continuous | [0, 8.6957] | 0% |
| `prevalence_surf_ab` | `numeric` | continuous | [0, 23.6] | 0% |
| `prevalence_bleeding_inj` | `numeric` | continuous | [0, 24] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `amphibian_malformation_prevalence`, la ou les reponses `prevalence_abnormal`, `prevalence_skel_ab`, `prevalence_eye_ab`, `prevalence_surf_ab`, `prevalence_bleeding_inj` viennent du loader papier et/ou des preuves de l article `Multiple stressors and the cause of amphibian abnormalities`. Les covariables X retenues sont `ROADDISTANCE` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`LONGITUDE`, `LATITUDE`), identifiants (`SITE`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `n_frogs` | `integer` | count | 0% |
| `ROADDISTANCE` | `integer` | count | 40.7% |
| `RoadType` | `character` | categorical | 40.7% |

### Formule - niveau publication

- formula_pub: skeletal_abnormality_prevalence ~ dragonfly_abundance + organic_contaminants + inorganic_contaminants [regression logistique individuelle + selection AIC, Reeves et al. 2010 ; X publies (predateurs, contaminants, UVB, temperature) non presents dans le depot Dryad brut]
- x_terms_pub: ROADDISTANCE
- y_term_pub: prevalence_abnormal
- Reference publication: Reeves et al. (2010), Ecological Monographs 80(3):423-440, DOI 10.1890/09-0879.1 ; verifie le 2026-08-13 sur le texte integral (corpus/papers/raw_pdf/Reeves2010Multiple.pdf, remplace ce jour apres correction d'un PDF errone). Le Table 1 de l'article publie une prevalence de malformations par site (2004-2006, seuil >=50 metamorphes) et documente aussi la distance a la route et le type de route par site (colonnes 'Distance to road (km)'/'Road type', memes champs que RoadsInfo.csv). Les autres X du modele logistique publie (dragonflies, contaminants organiques/inorganiques, UVB, temperature) ne sont PAS dans le depot Dryad 10.5061/dryad.sq72d telecharge (celui-ci contient les donnees individuelles FrogAbnormalities.csv, les coordonnees SiteLocations.csv et RoadsInfo.csv, pas les mesures de contaminants/predateurs/UVB par site). prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab sont agreges depuis 9011 individus (2000-2012, fenetre plus large que 2004-2006 dans le papier) en reprenant le seuil de fiabilite n>=50 du Table 1. Le texte de l'introduction du papier motive explicitement ROADDISTANCE/RoadType comme covariable pertinente ('abnormality frequency was higher... at road-accessible sites', Reeves et al. 2008 cite dans l'intro).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: prevalence_abnormal ~ ROADDISTANCE + RoadType [X partiel : seul le sous-ensemble route/contamination humaine du papier est present dans le depot brut, disponible pour 32/54 sites]
- x_terms_used: ROADDISTANCE
- y_term_used: prevalence_abnormal
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "prevalence_abnormal ~ ROADDISTANCE + RoadType [X partiel : seul le sous-ensemble route/contamination humaine du papier est present dans le depot brut, disponible pour 32/54 sites]"
    response: "prevalence_abnormal"
    predictors: ["ROADDISTANCE"]
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

- Dataset ID: `paper_amphibian_malformation_prevalence`
- Dataset name: Data from: Multiple stressors and the cause of amphibian abnormalities
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Multiple stressors and the cause of amphibian abnormalities
- Paper DOI: 10.1890/09-0879.1
- Dataset DOI: 10.5061/dryad.sq72d
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.sq72d
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "skeletal_abnormality_prevalence ~ dragonfly_abundance + organic_contaminants + inorganic_contaminants [regression logistique individuelle + selection AIC, Reeves et al. 2010 ; X publies (predateurs, contaminants, UVB, temperature) non presents dans le depot Dryad brut]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Reeves et al. (2010), Ecological Monographs 80(3):423-440, DOI 10.1890/09-0879.1 ; verifie le 2026-08-13 sur le texte integral (corpus/papers/raw_pdf/Reeves2010Multiple.pdf, remplace ce jour apres correction d'un PDF errone). Le Table 1 de l'article publie une prevalence de malformations par site (2004-2006, seuil >=50 metamorphes) et documente aussi la distance a la route et le type de route par site (colonnes 'Distance to road (km)'/'Road type', memes champs que RoadsInfo.csv). Les autres X du modele logistique publie (dragonflies, contaminants organiques/inorganiques, UVB, temperature) ne sont PAS dans le depot Dryad 10.5061/dryad.sq72d telecharge (celui-ci contient les donnees individuelles FrogAbnormalities.csv, les coordonnees SiteLocations.csv et RoadsInfo.csv, pas les mesures de contaminants/predateurs/UVB par site). prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab sont agreges depuis 9011 individus (2000-2012, fenetre plus large que 2004-2006 dans le papier) en reprenant le seuil de fiabilite n>=50 du Table 1. Le texte de l'introduction du papier motive explicitement ROADDISTANCE/RoadType comme covariable pertinente ('abnormality frequency was higher... at road-accessible sites', Reeves et al. 2008 cite dans l'intro)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "X limite a ROADDISTANCE/RoadType (32/54 sites, NA ailleurs) -- les contaminants/predateurs/UVB du modele publie ne sont pas dans le depot Dryad brut ; version continue derivee du Y binaire individuel, pas une reproduction exacte du Table 1 de l'article (fenetre temporelle plus large, 2000-2012 vs 2004-2006)"
  reason: "Y continu et defendable (prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab agreges depuis 9011 individus, seuil n>=50/site repris du Table 1 de Reeves et al. 2010), coordonnees reelles (SiteLocations.csv), X partiel mais reel et motive par le papier (ROADDISTANCE/RoadType), artefact local utilisable -- promu le 2026-08-13 apres correction du PDF errone et telechargement complet du depot Dryad (85 fichiers, dont FrogAbnormalities.csv absent du telechargement initial partiel)."
```

- Decision: ready
- Manque principal: X limite a ROADDISTANCE/RoadType (32/54 sites, NA ailleurs) -- les contaminants/predateurs/UVB du modele publie ne sont pas dans le depot Dryad brut ; version continue derivee du Y binaire individuel, pas une reproduction exacte du Table 1 de l'article (fenetre temporelle plus large, 2000-2012 vs 2004-2006)
- Raison: Y continu et defendable (prevalence_abnormal/prevalence_skel_ab/prevalence_eye_ab agreges depuis 9011 individus, seuil n>=50/site repris du Table 1 de Reeves et al. 2010), coordonnees reelles (SiteLocations.csv), X partiel mais reel et motive par le papier (ROADDISTANCE/RoadType), artefact local utilisable -- promu le 2026-08-13 apres correction du PDF errone et telechargement complet du depot Dryad (85 fichiers, dont FrogAbnormalities.csv absent du telechargement initial partiel).

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
- N observations: 54
- k variables: 13
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-151.37911, -150.00838], y [60.20227, 60.78709]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32605 (UTM Zone 5N (EPSG:32605)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.sq72d (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`amphibian_malformation_prevalence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `amphibian_malformation_prevalence` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20%: ROADDISTANCE (NA=40.7%), RoadType (NA=40.7%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`amphibian_malformation_prevalence` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Multiple stressors and the cause of amphibian abnormalities

