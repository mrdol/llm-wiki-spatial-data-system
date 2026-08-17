---
title: paper_mistletoe_bird_abundance
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_mistletoe_bird_abundance.rds
  - DataCite_2022_MistletoesCouldModerateDrought_10_1098_rspb_202
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback" (DOI 10.1098/rspb.2022.0358).

## Description du jeu de donnees

- Topic: ecologie / gui, secheresse et communautes d'oiseaux
- Observation unit: visite de site
- Observed population: communautes d'oiseaux forestiers, sud-est de l'Australie, N=9012 visites
- Geographic context: etendue sf: x [145.9136136, 151.90195], y [-36.6217744, -28.1728454]
- Temporal context: 5 distinct periods (variable: Season)
- Source description: Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1098/rspb.2022.0358
- Dataset DOI: 10.5061/dryad.76hdr7sxp
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.76hdr7sxp
- Local raw dir: `data/raw/papers/DataCite_2022_MistletoesCouldModerateDrought_10_1098_rspb_202/`
- Local sf output: `data/final_datasets/sf/paper_mistletoe_bird_abundance.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Total_abundance`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Season`, `total_live_mistletoe`, `total_dead_mistletoe`, `canopy_cover`, `shrub_cover`, `large_old_tree_total`
- Candidate X count in local artifact: 6
- Candidate X typology: continuous
- Published X variables from paper: total_live_mistletoe (abondance de gui vivant, log+1 transformee dans le papier), canopy_cover (couverture de canopee), shrub_cover (couverture arbustive), Season (saison de reproduction, interaction avec le gui), land_use, distance a l'eau, heure de releve (non retenus dans formula_used, disponibles dans l'artefact local)
- Published X count: 5
- Coordinates (x, y - excluded from X candidates): `Long`, `Lat`
- Identifier columns (excluded from X candidates): `Region`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Total_abundance` | `numeric` | continuous | [0, 226] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `mistletoe_bird_abundance`, la ou les reponses `Total_abundance` viennent du loader papier et/ou des preuves de l article `Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback`. Les covariables X retenues sont `total_live_mistletoe`, `total_dead_mistletoe`, `canopy_cover`, `shrub_cover`, `large_old_tree_total`, `Season`. Les coordonnees (`Long`, `Lat`), identifiants (`Region`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Season` | `integer` | count | 0% |
| `total_live_mistletoe` | `integer` | count | 0% |
| `total_dead_mistletoe` | `integer` | count | 0% |
| `canopy_cover` | `integer` | count | 0% |
| `shrub_cover` | `integer` | count | 0% |
| `large_old_tree_total` | `integer` | count | 0% |

### Formule - niveau publication

- formula_pub: TotalBirdAbundance ~ blossom_score + Season + noisy_miner_abundance + canopy_cover + shrub_cover + tree_species_composition + land_use + water_distance + survey_time + log1p(live_mistletoe_abundance) + live_mistletoe_abundance:Season [modele INLA GLMM avec effet aleatoire spatial SPDE (Matern), erreur de Poisson, effets aleatoires observateur/region, testant l'interaction mistletoe x saison de reproduction pour evaluer la moderation de la secheresse]
- x_terms_pub: total_live_mistletoe (abondance de gui vivant, log+1 transformee dans le papier), canopy_cover (couverture de canopee), shrub_cover (couverture arbustive), Season (saison de reproduction, interaction avec le gui), land_use, distance a l'eau, heure de releve (non retenus dans formula_used, disponibles dans l'artefact local)
- y_term_pub: Total_abundance (abondance totale d'oiseaux, toutes especes hors bruyant polyphonique noisy miner, par visite de site)
- Reference publication: Crates et al. (2022), Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback, Proceedings of the Royal Society B, doi:10.1098/rspb.2022.0358. Le papier ajuste des modeles INLA GLMM (erreur de Poisson, effet spatial SPDE/Matern, effets aleatoires observateur/region) sur l'abondance totale d'oiseaux, avec l'abondance de gui vivant (log+1) comme predicteur cle en interaction avec la saison de reproduction, pour tester si le gui attenue les impacts de la secheresse. formula_used retient les covariables de vegetation/gui reelles directement presentes dans le fichier de donnees (simplification en regression fixe, sans le terme spatial SPDE ni l'interaction). Donnees brutes (Bird_data.csv) telechargees directement depuis Dryad (10.5061/dryad.76hdr7sxp) -- pas une reconstruction, N=9012 visites de site (correspond exactement au chiffre publie dans le README), sud-est de l'Australie.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Crates et al. (2022), Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback, Proceedings of the Royal Society B, doi:10.1098/rspb.2022.0358. Le papier ajuste des modeles INLA GLMM (erreur de Poisson, effet spatial SPDE/Matern, effets aleatoires observateur/region) sur l'abondance totale d'oiseaux, avec l'abondance de gui vivant (log+1) comme predicteur cle en interaction avec la saison de reproduction, pour tester si le gui attenue les impacts de la secheresse. formula_used retient les covariables de vegetation/gui reelles directement presentes dans le fichier de donnees (simplification en regression fixe, sans le terme spatial SPDE ni l'interaction). Donnees brutes (Bird_data.csv) telechargees directement depuis Dryad (10.5061/dryad.76hdr7sxp) -- pas une reconstruction, N=9012 visites de site (correspond exactement au chiffre publie dans le README), sud-est de l'Australie.

### Formule - niveau systeme

- formula_used: Total_abundance ~ total_live_mistletoe + total_dead_mistletoe + canopy_cover + shrub_cover + large_old_tree_total + Season
- x_terms_used: total_live_mistletoe, total_dead_mistletoe, canopy_cover, shrub_cover, large_old_tree_total, Season
- y_term_used: Total_abundance
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Crates et al. (2022), Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback, Proceedings of the Royal Society B, doi:10.1098/rspb.2022.0358. Le papier ajuste des modeles INLA GLMM (erreur de Poisson, effet spatial SPDE/Matern, effets aleatoires observateur/region) sur l'abondance totale d'oiseaux, avec l'abondance de gui vivant (log+1) comme predicteur cle en interaction avec la saison de reproduction, pour tester si le gui attenue les impacts de la secheresse. formula_used retient les covariables de vegetation/gui reelles directement presentes dans le fichier de donnees (simplification en regression fixe, sans le terme spatial SPDE ni l'interaction). Donnees brutes (Bird_data.csv) telechargees directement depuis Dryad (10.5061/dryad.76hdr7sxp) -- pas une reconstruction, N=9012 visites de site (correspond exactement au chiffre publie dans le README), sud-est de l'Australie.

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
    formula: "Total_abundance ~ total_live_mistletoe + total_dead_mistletoe + canopy_cover + shrub_cover + large_old_tree_total + Season"
    response: "Total_abundance (abondance totale d'oiseaux, toutes especes hors bruyant polyphonique noisy miner, par visite de site)"
    predictors: ["total_live_mistletoe (abondance de gui vivant, log+1 transformee dans le papier)", "canopy_cover (couverture de canopee)", "shrub_cover (couverture arbustive)", "Season (saison de reproduction, interaction avec le gui)", "land_use, distance a l'eau, heure de releve (non retenus dans formula_used, disponibles dans l'artefact local)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Crates et al. (2022), Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback, Proceedings of the Royal Society B, doi:10.1098/rspb.2022.0358. Le papier ajuste des modeles INLA GLMM (erreur de Poisson, effet spatial SPDE/Matern, effets aleatoires observateur/region) sur l'abondance totale d'oiseaux, avec l'abondance de gui vivant (log+1) comme predicteur cle en interaction avec la saison de reproduction, pour tester si le gui attenue les impacts de la secheresse. formula_used retient les covariables de vegetation/gui reelles directement presentes dans le fichier de donnees (simplification en regression fixe, sans le terme spatial SPDE ni l'interaction). Donnees brutes (Bird_data.csv) telechargees directement depuis Dryad (10.5061/dryad.76hdr7sxp) -- pas une reconstruction, N=9012 visites de site (correspond exactement au chiffre publie dans le README), sud-est de l'Australie."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Total_abundance ~ total_live_mistletoe + total_dead_mistletoe + canopy_cover + shrub_cover + large_old_tree_total + Season + Region"
    response: "Total_abundance"
    predictors: ["total_live_mistletoe", "total_dead_mistletoe", "canopy_cover", "shrub_cover", "large_old_tree_total", "Season", "Region"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Crates et al. (2022), Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback, Proceedings of the Royal Society B, doi:10.1098/rspb.2022.0358. Le papier ajuste des modeles INLA GLMM (erreur de Poisson, effet spatial SPDE/Matern, effets aleatoires observateur/region) sur l'abondance totale d'oiseaux, avec l'abondance de gui vivant (log+1) comme predicteur cle en interaction avec la saison de reproduction, pour tester si le gui attenue les impacts de la secheresse. formula_used retient les covariables de vegetation/gui reelles directement presentes dans le fichier de donnees (simplification en regression fixe, sans le terme spatial SPDE ni l'interaction). Donnees brutes (Bird_data.csv) telechargees directement depuis Dryad (10.5061/dryad.76hdr7sxp) -- pas une reconstruction, N=9012 visites de site (correspond exactement au chiffre publie dans le README), sud-est de l'Australie."
    estimator_context: ["gam_spatial", "random_forest", "xgboost", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_mistletoe_bird_abundance`
- Dataset name: Mistletoes could moderate drought impacts on woodland birds, but are themselves susceptible to drought-induced dieback
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback
- Paper DOI: 10.1098/rspb.2022.0358
- Dataset DOI: 10.5061/dryad.76hdr7sxp
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.76hdr7sxp
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "TotalBirdAbundance ~ blossom_score + Season + noisy_miner_abundance + canopy_cover + shrub_cover + tree_species_composition + land_use + water_distance + survey_time + log1p(live_mistletoe_abundance) + live_mistletoe_abundance:Season [modele INLA GLMM avec effet aleatoire spatial SPDE (Matern), erreur de Poisson, effets aleatoires observateur/region, testant l'interaction mistletoe x saison de reproduction pour evaluer la moderation de la secheresse]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Crates et al. (2022), Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback, Proceedings of the Royal Society B, doi:10.1098/rspb.2022.0358. Le papier ajuste des modeles INLA GLMM (erreur de Poisson, effet spatial SPDE/Matern, effets aleatoires observateur/region) sur l'abondance totale d'oiseaux, avec l'abondance de gui vivant (log+1) comme predicteur cle en interaction avec la saison de reproduction, pour tester si le gui attenue les impacts de la secheresse. formula_used retient les covariables de vegetation/gui reelles directement presentes dans le fichier de donnees (simplification en regression fixe, sans le terme spatial SPDE ni l'interaction). Donnees brutes (Bird_data.csv) telechargees directement depuis Dryad (10.5061/dryad.76hdr7sxp) -- pas une reconstruction, N=9012 visites de site (correspond exactement au chiffre publie dans le README), sud-est de l'Australie."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis Dryad, N=9012 identique au chiffre publie dans le README ; formula_used omet le terme spatial SPDE et l'interaction mistletoe x saison du modele complet, disponible en X supplementaires (Season deja inclus)"
  reason: "Y continu/comptage reel (abondance totale d'oiseaux), N=9012 visites de site avec coordonnees reelles (sud-est de l'Australie), covariables de gui et de vegetation exactement celles du papier (memes noms de colonnes). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la reponse et les predicteurs (question 2 du papier)."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis Dryad, N=9012 identique au chiffre publie dans le README ; formula_used omet le terme spatial SPDE et l'interaction mistletoe x saison du modele complet, disponible en X supplementaires (Season deja inclus)
- Raison: Y continu/comptage reel (abondance totale d'oiseaux), N=9012 visites de site avec coordonnees reelles (sud-est de l'Australie), covariables de gui et de vegetation exactement celles du papier (memes noms de colonnes). CSV original telecharge directement depuis Dryad, pas une reconstruction. Papier lu integralement (TEI) pour confirmer la reponse et les predicteurs (question 2 du papier).

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
- N observations: 9012
- k variables: 13
- T periods: 5
- Variable temporelle: Season
- N/T profile: N_grand_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (9012) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 1218 ; panel NON EQUILIBRE (T par unite : min=1, mediane=8, max=13). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 1218 unites spatiales distinctes, pas sur les 9012 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 5 distinct periods (variable: Season)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [145.9136136, 151.90195], y [-36.6217744, -28.1728454]
- Time range: 2016 to 2020 (variable: Season)
- CRS analyse recommande: 32755 (UTM Zone 55S (EPSG:32755)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`mistletoe_bird_abundance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `mistletoe_bird_abundance` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`mistletoe_bird_abundance` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Mistletoes could moderate drought impacts on birds, but are themselves susceptible to drought-induced dieback

