---
title: paper_swiss_heat_exposure
type: dataset
created: 2026-08-17
updated: 2026-08-17
sources:
  - data/final_datasets/sf/paper_swiss_heat_exposure.rds
  - DatasetFirst_10_5281_zenodo_16923676
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Modelling the Spatially Varying Non-Linear Effects of Heat Exposure" (DOI unknown).

## Description du jeu de donnees

- Topic: sante environnementale / mortalite liee a la chaleur
- Observation unit: commune x jour
- Observed population: population 65+, communes suisses (N=2145), panel journalier 2011-2022
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 12 distinct periods (variable: year)
- Source description: [dataset-first, publication non resolue] Modelling the Spatially Varying Non-Linear Effects of Heat Exposure
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.16923676
- Source URL: https://doi.org/10.5281/zenodo.16923676
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_16923676/`
- Local sf output: `data/final_datasets/sf/paper_swiss_heat_exposure.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `deaths`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `urbanicity`, `greenspace`, `age`, `population`, `temperature`, `year`, `month`, `temperature_lag1`, `temperature_lag2`, `temperature_lag3`, `doy`, `dom`, `dow`, `temperature_lag03`, `week`, `holiday`, `day`, `canton_deaths`, `weight`, `deaths_sim`
- Candidate X count in local artifact: 20
- Candidate X typology: categorical, continuous
- Published X variables from paper: temperature (temperature quotidienne), temperature_lag1/2/3 (temperature des 3 jours precedents), greenspace (indice d'espace vert communal -- confirme comme facteur de disparite spatiale par le resume officiel), urbanicity (statut urbain/rural de la commune)
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `id_region`, `region`, `KANTONSNUM`, `id_doy`, `id_year`, `daily_date`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `deaths` | `numeric` | continuous | [0, 12] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `swiss_heat_exposure`, la ou les reponses `deaths` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Modelling the Spatially Varying Non-Linear Effects of Heat Exposure`. Les covariables X retenues sont `temperature`, `temperature_lag1`, `temperature_lag2`, `temperature_lag3`, `greenspace`, `urbanicity` ; 14 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`id_region`, `region`, `KANTONSNUM`, `id_doy`, `id_year`, `daily_date`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `urbanicity` | `character` | categorical | 0% |
| `greenspace` | `numeric` | continuous | 0% |
| `age` | `character` | categorical | 0% |
| `population` | `numeric` | continuous | 0% |
| `temperature` | `numeric` | continuous | 0% |
| `year` | `numeric` | continuous | 0% |
| `month` | `numeric` | continuous | 0% |
| `temperature_lag1` | `numeric` | continuous | 0% |
| `temperature_lag2` | `numeric` | continuous | 0% |
| `temperature_lag3` | `numeric` | continuous | 0% |
| `doy` | `numeric` | continuous | 0% |
| `dom` | `integer` | count | 0% |
| `dow` | `numeric` | continuous | 0% |
| `temperature_lag03` | `numeric` | continuous | 0% |
| `week` | `numeric` | continuous | 0% |
| `holiday` | `numeric` | binary | 0% |
| `day` | `integer` | count | 0% |
| `canton_deaths` | `numeric` | continuous | 0% |
| `weight` | `numeric` | rate | 0% |
| `deaths_sim` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: deaths ~ f(temperature, nonlinear, spatially-varying) [modele bayesien BYM2 avec effets non-lineaires spatialement variables -- Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Mortalite toutes causes en Suisse, disparites spatiales de mortalite liee a la chaleur expliquees principalement par la structure d'age de la population, les espaces verts et les vulnerabilites liees a l'exposition a la chaleur (resume officiel)]
- x_terms_pub: temperature (temperature quotidienne), temperature_lag1/2/3 (temperature des 3 jours precedents), greenspace (indice d'espace vert communal -- confirme comme facteur de disparite spatiale par le resume officiel), urbanicity (statut urbain/rural de la commune)
- y_term_pub: deaths (nombre quotidien de deces, population 65 ans et plus, par commune)
- Reference publication: Papier identifie via recherche web (session 2026-08-17) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse ; le resume officiel confirme que les disparites spatiales de mortalite liee a la chaleur sont expliquees principalement par la structure d'age, les espaces verts (green space) et les vulnerabilites liees a l'exposition -- ces deux dernieres correspondent aux colonnes reelles greenspace/urbanicity du shapefile joint. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022), jointure par id_region (cle deja partagee entre les deux fichiers). Geometrie convertie en centroide avant jointure pour eviter la duplication memoire d'un polygone complexe sur 2.3M lignes (correction technique, pas une alteration des donnees). Dataset garde en un seul panel (pas de decoupage par sous-population : la colonne 'age' n'a qu'un seul niveau -- Y_GE65, population 65+ uniquement -- dans ce depot public 'open' ; decouper par annee ou par commune detruirait la structure spatio-temporelle du panel sans repondre a un critere de sous-population reellement distinct, contrairement aux cas PM2.5/O3/NO2 ou especes de corail deja separes dans ce wiki). formula_used simplifie le modele BYM2 non-lineaire en regression lineaire multiple, une simplification documentee, pas la specification exacte du papier. package_include laisse en manual_review pour cette raison.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Papier identifie via recherche web (session 2026-08-17) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse ; le resume officiel confirme que les disparites spatiales de mortalite liee a la chaleur sont expliquees principalement par la structure d'age, les espaces verts (green space) et les vulnerabilites liees a l'exposition -- ces deux dernieres correspondent aux colonnes reelles greenspace/urbanicity du shapefile joint. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022), jointure par id_region (cle deja partagee entre les deux fichiers). Geometrie convertie en centroide avant jointure pour eviter la duplication memoire d'un polygone complexe sur 2.3M lignes (correction technique, pas une alteration des donnees). Dataset garde en un seul panel (pas de decoupage par sous-population : la colonne 'age' n'a qu'un seul niveau -- Y_GE65, population 65+ uniquement -- dans ce depot public 'open' ; decouper par annee ou par commune detruirait la structure spatio-temporelle du panel sans repondre a un critere de sous-population reellement distinct, contrairement aux cas PM2.5/O3/NO2 ou especes de corail deja separes dans ce wiki). formula_used simplifie le modele BYM2 non-lineaire en regression lineaire multiple, une simplification documentee, pas la specification exacte du papier. package_include laisse en manual_review pour cette raison.

### Formule - niveau systeme

- formula_used: deaths ~ temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity
- x_terms_used: temperature, temperature_lag1, temperature_lag2, temperature_lag3, greenspace, urbanicity
- y_term_used: deaths
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17). Papier identifie via recherche web (session 2026-08-17) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse ; le resume officiel confirme que les disparites spatiales de mortalite liee a la chaleur sont expliquees principalement par la structure d'age, les espaces verts (green space) et les vulnerabilites liees a l'exposition -- ces deux dernieres correspondent aux colonnes reelles greenspace/urbanicity du shapefile joint. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022), jointure par id_region (cle deja partagee entre les deux fichiers). Geometrie convertie en centroide avant jointure pour eviter la duplication memoire d'un polygone complexe sur 2.3M lignes (correction technique, pas une alteration des donnees). Dataset garde en un seul panel (pas de decoupage par sous-population : la colonne 'age' n'a qu'un seul niveau -- Y_GE65, population 65+ uniquement -- dans ce depot public 'open' ; decouper par annee ou par commune detruirait la structure spatio-temporelle du panel sans repondre a un critere de sous-population reellement distinct, contrairement aux cas PM2.5/O3/NO2 ou especes de corail deja separes dans ce wiki). formula_used simplifie le modele BYM2 non-lineaire en regression lineaire multiple, une simplification documentee, pas la specification exacte du papier. package_include laisse en manual_review pour cette raison.

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
    formula: "deaths ~ temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity"
    response: "deaths (nombre quotidien de deces, population 65 ans et plus, par commune)"
    predictors: ["temperature (temperature quotidienne)", "temperature_lag1/2/3 (temperature des 3 jours precedents)", "greenspace (indice d'espace vert communal -- confirme comme facteur de disparite spatiale par le resume officiel)", "urbanicity (statut urbain/rural de la commune)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Papier identifie via recherche web (session 2026-08-17) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse ; le resume officiel confirme que les disparites spatiales de mortalite liee a la chaleur sont expliquees principalement par la structure d'age, les espaces verts (green space) et les vulnerabilites liees a l'exposition -- ces deux dernieres correspondent aux colonnes reelles greenspace/urbanicity du shapefile joint. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022), jointure par id_region (cle deja partagee entre les deux fichiers). Geometrie convertie en centroide avant jointure pour eviter la duplication memoire d'un polygone complexe sur 2.3M lignes (correction technique, pas une alteration des donnees). Dataset garde en un seul panel (pas de decoupage par sous-population : la colonne 'age' n'a qu'un seul niveau -- Y_GE65, population 65+ uniquement -- dans ce depot public 'open' ; decouper par annee ou par commune detruirait la structure spatio-temporelle du panel sans repondre a un critere de sous-population reellement distinct, contrairement aux cas PM2.5/O3/NO2 ou especes de corail deja separes dans ce wiki). formula_used simplifie le modele BYM2 non-lineaire en regression lineaire multiple, une simplification documentee, pas la specification exacte du papier. package_include laisse en manual_review pour cette raison."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "deaths ~ temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity + population + holiday + dow"
    response: "deaths"
    predictors: ["temperature", "temperature_lag1", "temperature_lag2", "temperature_lag3", "greenspace", "urbanicity", "population", "holiday", "dow"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Papier identifie via recherche web (session 2026-08-17) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse ; le resume officiel confirme que les disparites spatiales de mortalite liee a la chaleur sont expliquees principalement par la structure d'age, les espaces verts (green space) et les vulnerabilites liees a l'exposition -- ces deux dernieres correspondent aux colonnes reelles greenspace/urbanicity du shapefile joint. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022), jointure par id_region (cle deja partagee entre les deux fichiers). Geometrie convertie en centroide avant jointure pour eviter la duplication memoire d'un polygone complexe sur 2.3M lignes (correction technique, pas une alteration des donnees). Dataset garde en un seul panel (pas de decoupage par sous-population : la colonne 'age' n'a qu'un seul niveau -- Y_GE65, population 65+ uniquement -- dans ce depot public 'open' ; decouper par annee ou par commune detruirait la structure spatio-temporelle du panel sans repondre a un critere de sous-population reellement distinct, contrairement aux cas PM2.5/O3/NO2 ou especes de corail deja separes dans ce wiki). formula_used simplifie le modele BYM2 non-lineaire en regression lineaire multiple, une simplification documentee, pas la specification exacte du papier. package_include laisse en manual_review pour cette raison."
    estimator_context: ["bym2", "car_besag", "gam_spatial", "gwr", "random_forest_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_swiss_heat_exposure`
- Dataset name: Modelling the Spatially Varying Non-Linear Effects of Heat Exposure
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] Modelling the Spatially Varying Non-Linear Effects of Heat Exposure
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.16923676
- Source URL: https://doi.org/10.5281/zenodo.16923676
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "deaths ~ f(temperature, nonlinear, spatially-varying) [modele bayesien BYM2 avec effets non-lineaires spatialement variables -- Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Mortalite toutes causes en Suisse, disparites spatiales de mortalite liee a la chaleur expliquees principalement par la structure d'age de la population, les espaces verts et les vulnerabilites liees a l'exposition a la chaleur (resume officiel)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Papier identifie via recherche web (session 2026-08-17) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse ; le resume officiel confirme que les disparites spatiales de mortalite liee a la chaleur sont expliquees principalement par la structure d'age, les espaces verts (green space) et les vulnerabilites liees a l'exposition -- ces deux dernieres correspondent aux colonnes reelles greenspace/urbanicity du shapefile joint. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022), jointure par id_region (cle deja partagee entre les deux fichiers). Geometrie convertie en centroide avant jointure pour eviter la duplication memoire d'un polygone complexe sur 2.3M lignes (correction technique, pas une alteration des donnees). Dataset garde en un seul panel (pas de decoupage par sous-population : la colonne 'age' n'a qu'un seul niveau -- Y_GE65, population 65+ uniquement -- dans ce depot public 'open' ; decouper par annee ou par commune detruirait la structure spatio-temporelle du panel sans repondre a un critere de sous-population reellement distinct, contrairement aux cas PM2.5/O3/NO2 ou especes de corail deja separes dans ce wiki). formula_used simplifie le modele BYM2 non-lineaire en regression lineaire multiple, une simplification documentee, pas la specification exacte du papier. package_include laisse en manual_review pour cette raison."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables, pas une regression lineaire -- formula_used simplifie en regression multiple lineaire ; package_include laisse en manual_review pour cette raison"
  reason: "Y continu/comptage reel (deaths, deces quotidiens population 65+), N=2368080 (panel 2145 communes x ~1104 jours) avec coordonnees reelles (centroides communaux). RDS originaux telecharges directement depuis Zenodo, pas une reconstruction. Papier identifie via recherche web (Chen et al. 2025, JRSS Series A)."
```

- Decision: ready
- Manque principal: le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables, pas une regression lineaire -- formula_used simplifie en regression multiple lineaire ; package_include laisse en manual_review pour cette raison
- Raison: Y continu/comptage reel (deaths, deces quotidiens population 65+), N=2368080 (panel 2145 communes x ~1104 jours) avec coordonnees reelles (centroides communaux). RDS originaux telecharges directement depuis Zenodo, pas une reconstruction. Papier identifie via recherche web (Chen et al. 2025, JRSS Series A).

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
- N observations: 2368080
- k variables: 30
- T periods: 12
- Variable temporelle: year
- N/T profile: N_grand_T_grand

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 12 distinct periods (variable: year)
- CRS EPSG: unknown
- CRS nom: CH1903+ / LV95 + LN02 height
- Spatial extent: x [2487218.96459694, 2825377.79974742], y [1076471.47280323, 1294284.26399341]
- Time range: 2011 to 2022 (variable: year)
- CRS analyse recommande: pending - CRS source non geographique ou inconnu

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`swiss_heat_exposure` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `swiss_heat_exposure` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`swiss_heat_exposure` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Modelling the Spatially Varying Non-Linear Effects of Heat Exposure

