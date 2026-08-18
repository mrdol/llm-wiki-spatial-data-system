---
title: paper_covid_sociodemographic_risk
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_covid_sociodemographic_risk.rds
  - DatasetFirst_10_5061_dryad_4j0zpc8j1
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality" (DOI 10.1101/2023.07.21.23292785).

## Description du jeu de donnees

- Topic: epidemiologie / mortalite COVID-19 et facteurs sociodemographiques
- Observation unit: comte (county), Etats-Unis continentaux
- Observed population: 3068 comtes CONUS, deces cumules COVID-19 ajustes a la population au 2022-04-27
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1101/2023.07.21.23292785
- Dataset DOI: 10.5061/dryad.4j0zpc8j1
- Source URL: https://doi.org/10.5061/dryad.4j0zpc8j1
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_4j0zpc8j1/`
- Local sf output: `data/final_datasets/sf/paper_covid_sociodemographic_risk.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `death_rate_per_100k`, `cumulative_deaths`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `STATE_FIPS`, `CNTY_FIPS`, `RPL_THEME1`, `RPL_THEME2`, `RPL_THEME3`, `RPL_THEME4`, `pct_voted_biden_2020`, `population_density`, `broadband_access`, `Age_over_65`, `vaccination_pct_apr2022`, `size`, `Obesity`, `Unemployed`, `Diabetes`, `Food_Insecurity`, `Associations`, `Uninsured_Adults`
- Candidate X count in local artifact: 18
- Candidate X typology: categorical, continuous
- Published X variables from paper: RPL_THEME1-4 (les 4 themes CDC SVI 2018 : statut socio-economique, composition menage/handicap, statut minoritaire/langue, logement/transport), pct_voted_biden_2020 (pourcentage de vote democrate 2020, proxy ideologie politique), vaccination_pct_apr2022 (taux de vaccination au 2022-04-27), population_density, Obesity, Unemployed, Uninsured_Adults, Associations, Diabetes, Food_Insecurity (CDC County Health Rankings), broadband_access, Age_over_65
- Published X count: 7
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `FIPS`, `NAME`, `STATE_NAME`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `death_rate_per_100k` | `numeric` | continuous | [0, 1359.5166] | 0% |
| `cumulative_deaths` | `numeric` | continuous | [0, 31951] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `covid_sociodemographic_risk`, la ou les reponses `death_rate_per_100k`, `cumulative_deaths` viennent du loader papier et/ou des preuves de l article `Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality`. Les covariables X retenues sont `RPL_THEME1`, `RPL_THEME2`, `RPL_THEME3`, `RPL_THEME4`, `pct_voted_biden_2020`, `vaccination_pct_apr2022`, `population_density`, `Obesity`, `Unemployed`, `Uninsured_Adults`, `Associations`, `Diabetes`, `Food_Insecurity`, `broadband_access`, `Age_over_65` ; 3 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`FIPS`, `NAME`, `STATE_NAME`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `STATE_FIPS` | `character` | categorical | 0% |
| `CNTY_FIPS` | `character` | categorical | 0% |
| `RPL_THEME1` | `numeric` | continuous | 0% |
| `RPL_THEME2` | `numeric` | rate | 0% |
| `RPL_THEME3` | `numeric` | rate | 0% |
| `RPL_THEME4` | `numeric` | rate | 0% |
| `pct_voted_biden_2020` | `numeric` | rate | 0% |
| `population_density` | `numeric` | continuous | 0% |
| `broadband_access` | `numeric` | continuous | 0% |
| `Age_over_65` | `integer` | count | 0% |
| `vaccination_pct_apr2022` | `numeric` | continuous | 0.4% |
| `size` | `numeric` | continuous | 0% |
| `Obesity` | `numeric` | rate | 0% |
| `Unemployed` | `numeric` | rate | 0% |
| `Diabetes` | `numeric` | rate | 0% |
| `Food_Insecurity` | `numeric` | rate | 0% |
| `Associations` | `numeric` | rate | 0% |
| `Uninsured_Adults` | `numeric` | rate | 0% |

### Formule - niveau publication

- formula_pub: death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65 [approche 1 : regression multilineaire de Poisson par region HHS + niveau national (10 modeles) ; approche 2 : Geographically Weighted Random Forest (GWRF), technique novatrice du papier, ajustee separement pour 3 vagues pandemiques (Alpha/Delta/Omicron)]
- x_terms_pub: RPL_THEME1-4 (les 4 themes CDC SVI 2018 : statut socio-economique, composition menage/handicap, statut minoritaire/langue, logement/transport), pct_voted_biden_2020 (pourcentage de vote democrate 2020, proxy ideologie politique), vaccination_pct_apr2022 (taux de vaccination au 2022-04-27), population_density, Obesity, Unemployed, Uninsured_Adults, Associations, Diabetes, Food_Insecurity (CDC County Health Rankings), broadband_access, Age_over_65
- y_term_pub: death_rate_per_100k (deces cumules COVID-19 par comte, ajustes a la population, coupe transversale au 2022-04-27)
- Reference publication: Seamon, E., Ridenhour, B.J., Miller, C.R. & Johnson-Leung, J. (2023), Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality, medRxiv, doi:10.1101/2023.07.21.23292785. Shapefile UScounties_conus.shp + 8 fichiers de covariables CSV telecharges directement depuis Dryad (10.5061/dryad.4j0zpc8j1, repo GitHub du papier archive sur Dryad) -- pas une reconstruction, jointure sur FIPS via data/raw/papers/DatasetFirst_10_5061_dryad_4j0zpc8j1/build_county_covid_table.py (script documente, aucune valeur inventee). Les 15 covariables correspondent exactement a la Table 1 du papier. Le papier ajuste 3 modeles distincts par vague pandemique (Alpha/Delta/Omicron) plus un modele national/regional Poisson -- ce loader utilise une coupe transversale unique en fin de periode commune aux sources (deces cumules + vaccination au 2022-04-27) plutot que de reproduire les 3 vagues separement, reduction de perimetre assumee et documentee.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65
- x_terms_used: RPL_THEME1, RPL_THEME2, RPL_THEME3, RPL_THEME4, pct_voted_biden_2020, vaccination_pct_apr2022, population_density, Obesity, Unemployed, Uninsured_Adults, Associations, Diabetes, Food_Insecurity, broadband_access, Age_over_65
- y_term_used: death_rate_per_100k
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

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
    formula: "death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65"
    response: "death_rate_per_100k (deces cumules COVID-19 par comte, ajustes a la population, coupe transversale au 2022-04-27)"
    predictors: ["RPL_THEME1-4 (les 4 themes CDC SVI 2018 : statut socio-economique, composition menage/handicap, statut minoritaire/langue, logement/transport)", "pct_voted_biden_2020 (pourcentage de vote democrate 2020, proxy ideologie politique)", "vaccination_pct_apr2022 (taux de vaccination au 2022-04-27)", "population_density", "Obesity, Unemployed, Uninsured_Adults, Associations, Diabetes, Food_Insecurity (CDC County Health Rankings)", "broadband_access", "Age_over_65"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65"
    response: "death_rate_per_100k"
    predictors: ["RPL_THEME1", "RPL_THEME2", "RPL_THEME3", "RPL_THEME4", "pct_voted_biden_2020", "vaccination_pct_apr2022", "population_density", "Obesity", "Unemployed", "Uninsured_Adults", "Associations", "Diabetes", "Food_Insecurity", "broadband_access", "Age_over_65"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["spatial_random_forest", "gwr", "random_forest", "poisson_regression", "xgboost"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_covid_sociodemographic_risk`
- Dataset name: Data from: Predictive spatial modeling of sociodemographic risk for COVID-19 mortality
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality
- Paper DOI: 10.1101/2023.07.21.23292785
- Dataset DOI: 10.5061/dryad.4j0zpc8j1
- Source URL: https://doi.org/10.5061/dryad.4j0zpc8j1
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "death_rate_per_100k ~ RPL_THEME1 + RPL_THEME2 + RPL_THEME3 + RPL_THEME4 + pct_voted_biden_2020 + vaccination_pct_apr2022 + population_density + Obesity + Unemployed + Uninsured_Adults + Associations + Diabetes + Food_Insecurity + broadband_access + Age_over_65 [approche 1 : regression multilineaire de Poisson par region HHS + niveau national (10 modeles) ; approche 2 : Geographically Weighted Random Forest (GWRF), technique novatrice du papier, ajustee separement pour 3 vagues pandemiques (Alpha/Delta/Omicron)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Seamon, E., Ridenhour, B.J., Miller, C.R. & Johnson-Leung, J. (2023), Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality, medRxiv, doi:10.1101/2023.07.21.23292785. Shapefile UScounties_conus.shp + 8 fichiers de covariables CSV telecharges directement depuis Dryad (10.5061/dryad.4j0zpc8j1, repo GitHub du papier archive sur Dryad) -- pas une reconstruction, jointure sur FIPS via data/raw/papers/DatasetFirst_10_5061_dryad_4j0zpc8j1/build_county_covid_table.py (script documente, aucune valeur inventee). Les 15 covariables correspondent exactement a la Table 1 du papier. Le papier ajuste 3 modeles distincts par vague pandemique (Alpha/Delta/Omicron) plus un modele national/regional Poisson -- ce loader utilise une coupe transversale unique en fin de periode commune aux sources (deces cumules + vaccination au 2022-04-27) plutot que de reproduire les 3 vagues separement, reduction de perimetre assumee et documentee."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous_rate"
  package_include: "yes"
  has_local_rds: true
  missing_items: "coupe transversale unique (fin de periode 2022-04-27) au lieu des 3 vagues pandemiques separees (Alpha/Delta/Omicron) modelisees individuellement dans le papier -- reduction de perimetre documentee, pas une reconstruction ; 2-3% de NA par covariable (comtes tres peu peuples exclus par les sources CDC), non imputes"
  reason: "Y continu reel (death_rate_per_100k), les 15 covariables exactes de la Table 1 du papier, geometrie polygonale originale (UScounties_conus.shp), N=3068 comtes CONUS. Shapefile + CSV telecharges directement depuis le depot Dryad du papier (archive GitHub complete), jointure documentee sur FIPS via script trace (build_county_covid_table.py), aucune valeur inventee. Papier lu integralement (TEI) pour confirmer la formule et les deux approches d'estimation (Poisson regional + Geographically Weighted Random Forest)."
```

- Decision: ready
- Manque principal: coupe transversale unique (fin de periode 2022-04-27) au lieu des 3 vagues pandemiques separees (Alpha/Delta/Omicron) modelisees individuellement dans le papier -- reduction de perimetre documentee, pas une reconstruction ; 2-3% de NA par covariable (comtes tres peu peuples exclus par les sources CDC), non imputes
- Raison: Y continu reel (death_rate_per_100k), les 15 covariables exactes de la Table 1 du papier, geometrie polygonale originale (UScounties_conus.shp), N=3068 comtes CONUS. Shapefile + CSV telecharges directement depuis le depot Dryad du papier (archive GitHub complete), jointure documentee sur FIPS via script trace (build_county_covid_table.py), aucune valeur inventee. Papier lu integralement (TEI) pour confirmer la formule et les deux approches d'estimation (Poisson regional + Geographically Weighted Random Forest).

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
- N observations: 3068
- k variables: 25
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-124.21016217461, -67.5538878536346], y [25.53896375, 48.86434775]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: pending - multi-zones (span=56.7deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.4j0zpc8j1 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`covid_sociodemographic_risk` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `covid_sociodemographic_risk` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`covid_sociodemographic_risk` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality

