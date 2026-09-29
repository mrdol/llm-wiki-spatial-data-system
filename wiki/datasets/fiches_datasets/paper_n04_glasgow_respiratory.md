---
title: paper_n04_glasgow_respiratory
type: dataset
created: 2026-09-24
updated: 2026-09-23
sources:
  - data/final_datasets/sf/paper_n04_glasgow_respiratory.rds
  - N04_greater_glasgow_respiratory
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Statistical Inferences and Predictions for Areal Data and Spatial Data Fusion with Hausdorff-Gaussian Processes" (DOI 10.1007/s13253-025-00720-7).

## Description du jeu de donnees

- Topic: Public health
- Observation unit: observation spatiale du dataset "Greater Glasgow and Clyde respiratory hospitalization SMR, 134 Intermediate Zones"
- Observed population: 134 Intermediate Zones north of the River Clyde in Greater Glasgow, Scotland, respiratory hospital admissions in 2010
- Geographic context: 134 areal units (Intermediate Zones), official British National Grid polygons (EPSG:27700). Spatial dependence in the paper is modeled via Hausdorff distance between polygon boundaries (HGP), or via polygon adjacency graphs (DAGAR/BYM) -- not via a simple centroid-based kNN/distance-threshold W.
- Temporal context: none (cross-sectional)
- Source description: Statistical Inferences and Predictions for Areal Data and Spatial Data Fusion with Hausdorff-Gaussian Processes
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: high
- Paper DOI: 10.1007/s13253-025-00720-7
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=CARBayesdata
- Local raw dir: `data/raw/papers/N04_greater_glasgow_respiratory/`
- Local sf output: `data/final_datasets/sf/paper_n04_glasgow_respiratory.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `observed`, `SMR`
- Candidate Y typology: unknown, continuous
- Candidate X variables in local artifact: `name`, `expected`, `incomedep`
- Candidate X count in local artifact: 3
- Candidate X typology: categorical, continuous
- Published X variables from paper: incomedep
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `easting`, `northing`
- Identifier columns (excluded from X candidates): `IZ`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `observed` | `integer` | unknown | [23, 174] | 0% |
| `SMR` | `numeric` | continuous | [0.3186, 1.6332] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `n04_glasgow_respiratory`, la ou les reponses `observed`, `SMR` viennent du loader papier et/ou des preuves de l article `Statistical Inferences and Predictions for Areal Data and Spatial Data Fusion with Hausdorff-Gaussian Processes`. Les covariables X retenues sont `incomedep` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`easting`, `northing`), identifiants (`IZ`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : needs_manual_review ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `name` | `character` | categorical | 0% |
| `expected` | `numeric` | continuous | 0% |
| `incomedep` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: observed ~ incomedep [Poisson, log link, offset = log(expected), spatial effect HGP/DAGAR/BYM]
- x_terms_pub: incomedep
- y_term_pub: observed (hospitalisations respiratoires observees)
- Reference publication: Cunha Godoy, L.D., Prates, M.O. & Yan, J. (2026) (auteurs confirmes via recherche bibliographique le 2026-09-23 ; l'extraction GROBID du TEI etait corrompue -- 'Lucas Da'/'Cunha Godoy'/'L D Cunha Godoy' sont un seul et meme auteur mal segmente), Statistical Inferences and Predictions for Areal Data and Spatial Data Fusion with Hausdorff-Gaussian Processes, Journal of Agricultural, Biological and Environmental Statistics, doi:10.1007/s13253-025-00720-7. Le papier propose le Hausdorff-Gaussian Process (HGP), un effet aleatoire spatial dont la fonction de correlation depend de la DISTANCE DE HAUSDORFF entre polygones (pas la distance euclidienne entre centroides ni une matrice de voisinage classique), applique ici (Section 5.1, texte integral lu) au comptage d'hospitalisations respiratoires 2010 pour les 134 IZ au nord de la Clyde : modele Y(s_i)|X_i,Z(s_i) ~ Poisson, lien log, intercept, covariable x_i=incomedep, offset E_i=expected (Eq. 3 du papier). Le HGP homoscedastique utilise une correlation exponentielle puissance (PEC) a lissage nu=0.7 fixe, portee pratique rho estimee a 2.25 (IC95% 0.159-6.948). DEUX MODELES COMPARATEURS SONT REELLEMENT AJUSTES sur ce meme jeu (pas seulement cites) : DAGAR (Datta et al. 2019, graphe d'adjacence oriente, decomposition de Cholesky) et BYM (Besag-York-Mollie, convolution ICAR+iid sur une matrice de precision d'adjacence) -- Table 2 du papier rapporte les estimations posterieures des trois modeles (LOOIC : HGP=1081.0, DAGAR=1081.9, BYM=1089.3 ; HGP legerement meilleur mais 'none of the models delivered a remarkably better fit'). AUCUN des trois (HGP/DAGAR/BYM) n'est implemente dans spatialtidymodels -- BYM/ICAR est explicitement hors perimetre dans wiki/estimators/inla.md faute de matrice d'adjacence dans le corpus ; ce jeu (polygones GGHB.IZ) pourrait justement en fournir une via spdep::poly2nb(), piste notee pour une session future, non traitee ici.

### Statut regression canonique

- Statut: generated_system_formula
- Niveau de preuve: system_generated
- Methode d estimation: formule systeme generee (formula_pub confirmee mais non reprise telle quelle -- voir Note ci-dessous)
- Correspondance Python/R: aucune identifiee
- Note: `expected` est une exposition utilisee comme offset logarithmique, et `name` est un libelle d'unite spatiale; aucun des deux n'est une covariable X. Le harnais courant ne reproduit ni le HGP fonde sur la distance de Hausdorff, ni DAGAR, ni BYM.

### Formule - niveau systeme

- formula_used: observed ~ incomedep
- W matrix: construite le 2026-09-23 (exception deliberee a la regle habituelle du projet, decision utilisateur) -- data/final_datasets/weights/paper_n04_glasgow_respiratory_W.rds, contiguite reine (spdep::poly2nb) sur les 134 polygones IZ, 1 composante connexe, aucune unite isolee, row-standardized. Infrastructure prete pour un futur estimateur BYM/ICAR/DAGAR (aucun n'existe encore dans spatialtidymodels -- voir wiki/estimators/inla.md) ; PAS consommee par le harnais actuel, et non verifiee contre la matrice d'adjacence exacte des auteurs (ni CARBayesdata ni le papier N04 ne la publient).
- x_terms_used: incomedep
- y_term_used: observed
- Note: Reference et decision de curation conservees dans FORMULA_OVERRIDES; cette regeneration ne constitue pas une nouvelle lecture du papier. Distinguer la specification publiee de la formule utilisee.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "observed ~ incomedep"
    response: "observed (hospitalisations respiratoires observees)"
    predictors: ["incomedep"]
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
    formula: "observed ~ incomedep"
    response: "observed"
    predictors: ["incomedep"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["hausdorff_gaussian_process", "dagar", "bym", "poisson_log_offset"]
    status: "manual_review_offset_and_unimplemented_spatial_effect"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_n04_glasgow_respiratory`
- Dataset name: Greater Glasgow and Clyde respiratory hospitalization SMR, 134 Intermediate Zones
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Statistical Inferences and Predictions for Areal Data and Spatial Data Fusion with Hausdorff-Gaussian Processes
- Paper DOI: 10.1007/s13253-025-00720-7
- Dataset DOI: none
- Source URL: https://cran.r-project.org/package=CARBayesdata
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "observed ~ incomedep [Poisson, log link, offset = log(expected), spatial effect HGP/DAGAR/BYM]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Cunha Godoy, Prates & Yan (2026), Statistical Inferences and Predictions for Areal Data and Spatial Data Fusion with Hausdorff-Gaussian Processes, DOI 10.1007/s13253-025-00720-7, equation (3) et application Greater Glasgow."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "needs_manual_review"
  benchmark_task: "unknown"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "statut benchmark non encore curate"
  reason: "Aucune decision explicite encodee pour n04_glasgow_respiratory."
```

- Decision: needs_manual_review
- Manque principal: statut benchmark non encore curate
- Raison: Aucune decision explicite encodee pour n04_glasgow_respiratory.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "needs_manual_review"
  eligible_estimators: []
  conditionally_eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy"]
  ineligible_reason: "manual review required before package promotion"
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 134
- k variables: 10
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_moyen_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 27700
- CRS nom: OSGB36 / British National Grid
- Spatial extent: x [237055.690180012, 270311.134584829], y [662402.00015, 685336.99975]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`n04_glasgow_respiratory` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `n04_glasgow_respiratory` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formula_pub confirmee et verifiee (voir Reference publication) ; formula_used est une approximation generee distincte, explicitement etiquetee comme telle (voir Bloc 1 > Statut regression canonique > Note).
- CRS: OK - CRS renseigne dans le Bloc 5 (27700).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`n04_glasgow_respiratory` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Statistical Inferences and Predictions for Areal Data and Spatial Data Fusion with Hausdorff-Gaussian Processes
