---
title: paper_red_deer_topdown
type: dataset
created: 2026-08-15
updated: 2026-08-15
sources:
  - data/final_datasets/sf/paper_red_deer_topdown.rds
  - DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "unknown" (DOI unknown).

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: a preciser depuis le papier source
- Geographic context: etendue sf: x [-8.25, 43.45], y [37, 64.54]
- Temporal context: 29 distinct periods (variable: Year_publ)
- Source description: unknown
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: none
- Source URL: unknown
- Local raw dir: `data/raw/papers/DataCite_2023_NumericalTopdownEffectsOn_10_5061_dryad_0cfxpnw7w/`
- Local sf output: `data/final_datasets/sf/paper_red_deer_topdown.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Deer_density`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `Year_publ`, `hunting`, `Human_influence_index`, `Forest_integrity`, `Bear_presence`, `Wolf_presence`, `Lynx_presence`, `Nr_predators`, `Predation`, `IUCN_Catergory`, `Biogeographic`, `NDVI`, `NPP`, `Prec_all_year`, `Prec_summer`, `Min_Temp_summer`, `Min_Temp_winter`, `NDSI_Snow_Cover`, `Tree_canopy_cover`, `Palmer_drought_summer`
- Candidate X count in local artifact: 20
- Candidate X typology: continuous, categorical
- Published X variables from paper: NPP (productivite primaire nette), Bear_presence/Wolf_presence/Lynx_presence (presence des 3 grands carnivores), hunting (chasse par l'homme), Human_influence_index (indice d'influence humaine), IUCN_Catergory (statut de protection du site), Prec_all_year (precipitation annuelle), Min_Temp_summer/Min_Temp_winter (temperatures minimales), NDSI_Snow_Cover (indice de couverture neigeuse), Tree_canopy_cover (% couverture forestiere), Palmer_drought_summer (indice de secheresse de Palmer)
- Published X count: 10
- Coordinates (x, y - excluded from X candidates): `Longitude`, `Latitude`
- Identifier columns (excluded from X candidates): `Country`, `Study_area`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Deer_density` | `numeric` | continuous | [0.03, 44.64] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `red_deer_topdown`, la ou les reponses `Deer_density` viennent du loader papier et/ou des preuves de l article `unknown`. Les covariables X retenues sont `NPP`, `Bear_presence`, `Wolf_presence`, `Lynx_presence`, `hunting`, `Human_influence_index`, `IUCN_Catergory`, `Prec_all_year`, `Min_Temp_summer`, `Min_Temp_winter`, `NDSI_Snow_Cover`, `Tree_canopy_cover`, `Palmer_drought_summer` ; 7 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`Longitude`, `Latitude`), identifiants (`Country`, `Study_area`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year_publ` | `integer` | count | 0% |
| `hunting` | `integer` | binary | 1.1% |
| `Human_influence_index` | `numeric` | continuous | 0.6% |
| `Forest_integrity` | `numeric` | continuous | 0.7% |
| `Bear_presence` | `integer` | binary | 0% |
| `Wolf_presence` | `integer` | binary | 0% |
| `Lynx_presence` | `integer` | binary | 0% |
| `Nr_predators` | `integer` | count | 0% |
| `Predation` | `character` | categorical | 0% |
| `IUCN_Catergory` | `character` | categorical | 0% |
| `Biogeographic` | `character` | categorical | 0% |
| `NDVI` | `numeric` | rate | 0% |
| `NPP` | `numeric` | continuous | 0% |
| `Prec_all_year` | `numeric` | continuous | 0% |
| `Prec_summer` | `numeric` | continuous | 0% |
| `Min_Temp_summer` | `numeric` | continuous | 0% |
| `Min_Temp_winter` | `numeric` | continuous | 0% |
| `NDSI_Snow_Cover` | `numeric` | continuous | 0% |
| `Tree_canopy_cover` | `numeric` | continuous | 0% |
| `Palmer_drought_summer` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer [Generalized Additive Model (GAM), effets top-down numeriques sur le cerf elaphe]
- x_terms_pub: NPP (productivite primaire nette), Bear_presence/Wolf_presence/Lynx_presence (presence des 3 grands carnivores), hunting (chasse par l'homme), Human_influence_index (indice d'influence humaine), IUCN_Catergory (statut de protection du site), Prec_all_year (precipitation annuelle), Min_Temp_summer/Min_Temp_winter (temperatures minimales), NDSI_Snow_Cover (indice de couverture neigeuse), Tree_canopy_cover (% couverture forestiere), Palmer_drought_summer (indice de secheresse de Palmer)
- y_term_pub: Deer_density (densite de cerf elaphe, Cervus elaphus)
- Reference publication: van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse).

### Formule - niveau systeme

- formula_used: Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer
- x_terms_used: NPP, Bear_presence, Wolf_presence, Lynx_presence, hunting, Human_influence_index, IUCN_Catergory, Prec_all_year, Min_Temp_summer, Min_Temp_winter, NDSI_Snow_Cover, Tree_canopy_cover, Palmer_drought_summer
- y_term_used: Deer_density
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-15). van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse).

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
    formula: "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer"
    response: "Deer_density (densite de cerf elaphe, Cervus elaphus)"
    predictors: ["NPP (productivite primaire nette)", "Bear_presence/Wolf_presence/Lynx_presence (presence des 3 grands carnivores)", "hunting (chasse par l'homme)", "Human_influence_index (indice d'influence humaine)", "IUCN_Catergory (statut de protection du site)", "Prec_all_year (precipitation annuelle)", "Min_Temp_summer/Min_Temp_winter (temperatures minimales)", "NDSI_Snow_Cover (indice de couverture neigeuse)", "Tree_canopy_cover (% couverture forestiere)", "Palmer_drought_summer (indice de secheresse de Palmer)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse)."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer"
    response: "Deer_density"
    predictors: ["NPP", "Bear_presence", "Wolf_presence", "Lynx_presence", "hunting", "Human_influence_index", "Prec_all_year", "Min_Temp_summer", "Min_Temp_winter", "NDSI_Snow_Cover", "Tree_canopy_cover", "Palmer_drought_summer"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse)."
    estimator_context: ["gam_spatial", "random_forest", "xgboost"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_red_deer_topdown`
- Dataset name: unknown
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: unknown
- Paper DOI: unknown
- Dataset DOI: none
- Source URL: unknown
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Deer_density ~ NPP + Bear_presence + Wolf_presence + Lynx_presence + hunting + Human_influence_index + IUCN_Catergory + Prec_all_year + Min_Temp_summer + Min_Temp_winter + NDSI_Snow_Cover + Tree_canopy_cover + Palmer_drought_summer [Generalized Additive Model (GAM), effets top-down numeriques sur le cerf elaphe]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "van Beeck Calkoen, S.T.S., Kuijper, D.P.J., Apollonio, M., Blondel, L., Dormann, C.F., Storch, I. & Heurich, M. (2023), Numerical top-down effects on red deer (Cervus elaphus) are mainly shaped by humans rather than large carnivores across Europe, Journal of Applied Ecology, doi:10.1111/1365-2664.14526. CSV telecharge directement depuis Dryad (10.5061/dryad.0cfxpnw7w, API OAuth) -- pas une reconstruction, N=534 sites d'etude identique au depot source (Data_SvBC_RedDeer.csv). README.md du depot documente exactement les variables : recherche litterature (annee, pays, zone d'etude, latitude, longitude, densite, chasse) + facteurs additionnels (productivite primaire nette, presence de grands carnivores, indice d'influence humaine, statut de protection, couverture forestiere, indice de secheresse de Palmer, indice de couverture neigeuse)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun -- CSV original telecharge directement depuis Dryad (pas une reconstruction), N=534 identique au depot source"
  reason: "Y continu reel (Deer_density), X = 10+ covariables environnementales/humaines exactes decrites dans le README du depot et le papier, coordonnees reelles (Latitude/Longitude) pour 534 sites d'etude dans 28 pays europeens. CSV telecharge directement depuis Dryad via API OAuth, N identique au depot source. Promu package_include=yes le 2026-08-15 (decision utilisateur explicite) : le domaine ecologie n'est pas un motif de blocage en soi, coherent avec les autres datasets ecologie-regression-continue deja promus dans le corpus."
```

- Decision: ready
- Manque principal: aucun -- CSV original telecharge directement depuis Dryad (pas une reconstruction), N=534 identique au depot source
- Raison: Y continu reel (Deer_density), X = 10+ covariables environnementales/humaines exactes decrites dans le README du depot et le papier, coordonnees reelles (Latitude/Longitude) pour 534 sites d'etude dans 28 pays europeens. CSV telecharge directement depuis Dryad via API OAuth, N identique au depot source. Promu package_include=yes le 2026-08-15 (decision utilisateur explicite) : le domaine ecologie n'est pas un motif de blocage en soi, coherent avec les autres datasets ecologie-regression-continue deja promus dans le corpus.

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
- N observations: 534
- k variables: 28
- T periods: 29
- Variable temporelle: Year_publ
- N/T profile: N_grand_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 29 distinct periods (variable: Year_publ)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-8.25, 43.45], y [37, 64.54]
- Time range: 1987 to 3000 (variable: Year_publ)
- CRS analyse recommande: pending - multi-zones (span=51.7deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`red_deer_topdown` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `red_deer_topdown` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`red_deer_topdown` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: unknown

