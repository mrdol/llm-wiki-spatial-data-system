---
title: paper_colombia_leptospirosis_risk
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_colombia_leptospirosis_risk.rds
  - DatasetFirst_10_5281_zenodo_17104058
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "[dataset-first, publication non resolue] Supplementary materials - Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach" (DOI unknown).

## Description du jeu de donnees

- Topic: epidemiologie spatiale / leptospirose en Colombie
- Observation unit: municipalite colombienne
- Observed population: municipalites de Colombie (931 univoques), risque relatif spatial issu d'un modele BYM
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: none (cross-sectional)
- Source description: [dataset-first, publication non resolue] Supplementary materials - Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.17104058
- Source URL: https://doi.org/10.5281/zenodo.17104058
- Local raw dir: `data/raw/papers/DatasetFirst_10_5281_zenodo_17104058/`
- Local sf output: `data/final_datasets/sf/paper_colombia_leptospirosis_risk.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `RR`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `mean_annual_temp_c`, `annual_precip_mm`, `MannKendall`, `emerging_trend`
- Candidate X count in local artifact: 4
- Candidate X typology: continuous, categorical
- Published X variables from paper: MannKendall (statistique de tendance temporelle de Mann-Kendall par municipalite, meme modele), emerging_trend (indicateur binaire de tendance emergente, distinct du signe de MannKendall -- verifie empiriquement non redondant, 35% de desaccord de signe), mean_annual_temp_c (temperature annuelle moyenne, normale climatique CHELSA V2.1 1981-2010, degres C), annual_precip_mm (precipitation annuelle totale, normale climatique CHELSA V2.1 1981-2010, mm) -- proxy de la pluviometrie identifiee par le papier comme le determinant environnemental le plus important
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `key`, `shapeName`, `Municipality`, `significance_95`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `RR` | `numeric` | continuous | [0.005, 5.961] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `colombia_leptospirosis_risk`, la ou les reponses `RR` viennent du loader papier et/ou des preuves de l article `[dataset-first, publication non resolue] Supplementary materials - Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach`. Les covariables X retenues sont `MannKendall`, `emerging_trend`, `mean_annual_temp_c`, `annual_precip_mm`. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`key`, `shapeName`, `Municipality`, `significance_95`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `mean_annual_temp_c` | `numeric` | continuous | 0% |
| `annual_precip_mm` | `numeric` | continuous | 0% |
| `MannKendall` | `numeric` | continuous | 0% |
| `emerging_trend` | `numeric` | binary | 0% |

### Formule - niveau publication

- formula_pub: monthly_incidence ~ rainfall + temperature + overflooding + confondants_sociodemographiques [modele bayesien hierarchique BYM spatio-temporel, 180 mois (2007-2021), tous les municipalites colombiennes ; 'Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach', Journal of Public Health/Taylor & Francis, doi:10.1080/09581596.2025.2578588. La pluviometrie (rainfall) est identifiee comme le determinant environnemental le plus important apres ajustement pour les confondants socio-economiques/environnementaux et la structure spatiale. RR (risque relatif spatial) et la statistique de Mann-Kendall (tendance temporelle emergente) sont les deux SORTIES du modele BYM, pas des variables d'entree]
- x_terms_pub: MannKendall (statistique de tendance temporelle de Mann-Kendall par municipalite, meme modele), emerging_trend (indicateur binaire de tendance emergente, distinct du signe de MannKendall -- verifie empiriquement non redondant, 35% de desaccord de signe), mean_annual_temp_c (temperature annuelle moyenne, normale climatique CHELSA V2.1 1981-2010, degres C), annual_precip_mm (precipitation annuelle totale, normale climatique CHELSA V2.1 1981-2010, mm) -- proxy de la pluviometrie identifiee par le papier comme le determinant environnemental le plus important
- y_term_pub: RR (risque relatif spatial de leptospirose par municipalite, effet spatial estime du modele BYM du papier)
- Reference publication: REVISE x2 (session 2026-08-16) : (1) recherche bibliographique demandee par l'utilisateur -- papier identifie avec un haut degre de confiance -- 'Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach', doi:10.1080/09581596.2025.2578588. Correspondance structurelle exacte confirmee : le papier utilise un test de Mann-Kendall pour identifier les tendances emergentes de risque spatio-temporel ET un modele hierarchique bayesien BYM produisant des cartes de risque relatif spatial (RR) par municipalite, sur exactement 180 mois (2007-2021), ce qui correspond exactement aux 180 colonnes 'month 1' a 'month 180' de la feuille '1. iar_lepto' du fichier Sup_materials_lepto.xlsx local. Selon le resume de l'article, le vrai modele est incidence mensuelle ~ pluviometrie + temperature + inondation (overflooding), la pluviometrie etant le determinant environnemental le plus important. (2) CORRECTION METHODOLOGIQUE (signalee par l'utilisateur, session 2026-08-16) : p_value retiree des covariables -- la significativite d'un test statistique n'est pas une variable explicative independante, elle mesure l'incertitude sur MannKendall lui-meme (correlation empirique MannKendall~p_value = 0.70, confirmant leur non-independance), meme famille d'erreur que la circularite deja corrigee pour antarctic_biodiversity_completeness. emerging_trend conservee : verifiee empiriquement NON redondante avec le signe de MannKendall (35% de desaccord de signe dans les donnees reelles, cf. table de contingence). COVARIABLES CLIMATIQUES REELLES AJOUTEES (recherche demandee par l'utilisateur) : mean_annual_temp_c et annual_precip_mm, normales climatiques CHELSA V2.1 1981-2010 (https://chelsa-climate.org, licence CC-BY-4.0, lecture directe via GDAL /vsicurl/ sans telechargement du raster mondial complet), extraites par moyenne zonale sur les polygones municipaux geoBoundaries deja utilises pour la geometrie -- proxy legitime et verifie geographiquement coherent (temperature 7.8-28.5 degres C, precipitation 399-6553 mm/an sur les 931 municipalites, plages plausibles pour la Colombie) de la pluviometrie/temperature identifiees par le papier comme determinants principaux -- CE SONT DES NORMALES CLIMATIQUES (moyennes 1981-2010), PAS les covariables mensuelles exactes du modele BYM original (qui utiliserait des donnees IDEAM/CHIRPS mensuelles alignees sur la periode 2007-2021 exacte du papier) ; approximation documentee, pas une reconstruction des vraies donnees d'entree du papier. Texte integral du papier toujours non accessible (Taylor & Francis HTTP 403, PubMed cookie-gated). Geometrie : jointe par nom de municipalite normalise a la couche ADM2 publique geoBoundaries (source officielle DANE, CC BY 4.0, COL/ADM2, 1122 unites) ; 987/1036 municipalites uniques appariees par nom (95.3%), puis 65 noms ambigus (homonymes entre departements colombiens) retires -- N final=931 municipalites univoques, aucune supplementaire perdue lors de la jointure climatique (0 NA climat/mm2 sur les 931). package_include laisse en manual_review : papier et structure confirmes, covariables climatiques reelles ajoutees mais restent des normales/proxy, pas les vraies donnees mensuelles du modele original.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: RR ~ MannKendall + emerging_trend + mean_annual_temp_c + annual_precip_mm
- x_terms_used: MannKendall, emerging_trend, mean_annual_temp_c, annual_precip_mm
- y_term_used: RR
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
    formula: "RR ~ MannKendall + emerging_trend + mean_annual_temp_c + annual_precip_mm"
    response: "RR (risque relatif spatial de leptospirose par municipalite, effet spatial estime du modele BYM du papier)"
    predictors: ["MannKendall (statistique de tendance temporelle de Mann-Kendall par municipalite, meme modele)", "emerging_trend (indicateur binaire de tendance emergente, distinct du signe de MannKendall -- verifie empiriquement non redondant, 35% de desaccord de signe)", "mean_annual_temp_c (temperature annuelle moyenne, normale climatique CHELSA V2.1 1981-2010, degres C)", "annual_precip_mm (precipitation annuelle totale, normale climatique CHELSA V2.1 1981-2010, mm) -- proxy de la pluviometrie identifiee par le papier comme le determinant environnemental le plus important"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "RR ~ MannKendall + emerging_trend + mean_annual_temp_c + annual_precip_mm"
    response: "RR"
    predictors: ["MannKendall", "emerging_trend", "mean_annual_temp_c", "annual_precip_mm"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gwr", "car_besag", "random_forest_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_colombia_leptospirosis_risk`
- Dataset name: Supplementary materials - Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: [dataset-first, publication non resolue] Supplementary materials - Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach
- Paper DOI: unknown
- Dataset DOI: 10.5281/zenodo.17104058
- Source URL: https://doi.org/10.5281/zenodo.17104058
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "monthly_incidence ~ rainfall + temperature + overflooding + confondants_sociodemographiques [modele bayesien hierarchique BYM spatio-temporel, 180 mois (2007-2021), tous les municipalites colombiennes ; 'Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach', Journal of Public Health/Taylor & Francis, doi:10.1080/09581596.2025.2578588. La pluviometrie (rainfall) est identifiee comme le determinant environnemental le plus important apres ajustement pour les confondants socio-economiques/environnementaux et la structure spatiale. RR (risque relatif spatial) et la statistique de Mann-Kendall (tendance temporelle emergente) sont les deux SORTIES du modele BYM, pas des variables d'entree]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "REVISE x2 (session 2026-08-16) : (1) recherche bibliographique demandee par l'utilisateur -- papier identifie avec un haut degre de confiance -- 'Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach', doi:10.1080/09581596.2025.2578588. Correspondance structurelle exacte confirmee : le papier utilise un test de Mann-Kendall pour identifier les tendances emergentes de risque spatio-temporel ET un modele hierarchique bayesien BYM produisant des cartes de risque relatif spatial (RR) par municipalite, sur exactement 180 mois (2007-2021), ce qui correspond exactement aux 180 colonnes 'month 1' a 'month 180' de la feuille '1. iar_lepto' du fichier Sup_materials_lepto.xlsx local. Selon le resume de l'article, le vrai modele est incidence mensuelle ~ pluviometrie + temperature + inondation (overflooding), la pluviometrie etant le determinant environnemental le plus important. (2) CORRECTION METHODOLOGIQUE (signalee par l'utilisateur, session 2026-08-16) : p_value retiree des covariables -- la significativite d'un test statistique n'est pas une variable explicative independante, elle mesure l'incertitude sur MannKendall lui-meme (correlation empirique MannKendall~p_value = 0.70, confirmant leur non-independance), meme famille d'erreur que la circularite deja corrigee pour antarctic_biodiversity_completeness. emerging_trend conservee : verifiee empiriquement NON redondante avec le signe de MannKendall (35% de desaccord de signe dans les donnees reelles, cf. table de contingence). COVARIABLES CLIMATIQUES REELLES AJOUTEES (recherche demandee par l'utilisateur) : mean_annual_temp_c et annual_precip_mm, normales climatiques CHELSA V2.1 1981-2010 (https://chelsa-climate.org, licence CC-BY-4.0, lecture directe via GDAL /vsicurl/ sans telechargement du raster mondial complet), extraites par moyenne zonale sur les polygones municipaux geoBoundaries deja utilises pour la geometrie -- proxy legitime et verifie geographiquement coherent (temperature 7.8-28.5 degres C, precipitation 399-6553 mm/an sur les 931 municipalites, plages plausibles pour la Colombie) de la pluviometrie/temperature identifiees par le papier comme determinants principaux -- CE SONT DES NORMALES CLIMATIQUES (moyennes 1981-2010), PAS les covariables mensuelles exactes du modele BYM original (qui utiliserait des donnees IDEAM/CHIRPS mensuelles alignees sur la periode 2007-2021 exacte du papier) ; approximation documentee, pas une reconstruction des vraies donnees d'entree du papier. Texte integral du papier toujours non accessible (Taylor & Francis HTTP 403, PubMed cookie-gated). Geometrie : jointe par nom de municipalite normalise a la couche ADM2 publique geoBoundaries (source officielle DANE, CC BY 4.0, COL/ADM2, 1122 unites) ; 987/1036 municipalites uniques appariees par nom (95.3%), puis 65 noms ambigus (homonymes entre departements colombiens) retires -- N final=931 municipalites univoques, aucune supplementaire perdue lors de la jointure climatique (0 NA climat/mm2 sur les 931). package_include laisse en manual_review : papier et structure confirmes, covariables climatiques reelles ajoutees mais restent des normales/proxy, pas les vraies donnees mensuelles du modele original."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "aucune publication n'a ete identifiee pour ce candidat dataset-first -- RR et MannKendall sont des sorties reelles du modele BYM du papier, mais formula_used (leur mise en relation) est une proposition du curateur ; geometrie jointe a une source externe (geoBoundaries) avec exclusion documentee de 65 noms de municipalites ambigus (homonymes inter-departementaux) ; package_include laisse en manual_review pour ces raisons"
  reason: "Y continu reel (RR, risque relatif spatial de leptospirose, sortie directe du modele BYM des auteurs), N=931 municipalites colombiennes univoques. Sup_materials_lepto.xlsx telecharge directement depuis Zenodo, pas une reconstruction. Geometrie jointe a la couche publique geoBoundaries COL/ADM2 (source officielle DANE), taux d'appariement verifie empiriquement, homonymes exclus plutot qu'approximes."
```

- Decision: ready
- Manque principal: aucune publication n'a ete identifiee pour ce candidat dataset-first -- RR et MannKendall sont des sorties reelles du modele BYM du papier, mais formula_used (leur mise en relation) est une proposition du curateur ; geometrie jointe a une source externe (geoBoundaries) avec exclusion documentee de 65 noms de municipalites ambigus (homonymes inter-departementaux) ; package_include laisse en manual_review pour ces raisons
- Raison: Y continu reel (RR, risque relatif spatial de leptospirose, sortie directe du modele BYM des auteurs), N=931 municipalites colombiennes univoques. Sup_materials_lepto.xlsx telecharge directement depuis Zenodo, pas une reconstruction. Geometrie jointe a la couche publique geoBoundaries COL/ADM2 (source officielle DANE), taux d'appariement verifie empiriquement, homonymes exclus plutot qu'approximes.

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
- N observations: 931
- k variables: 11
- T periods: 1
- Variable temporelle: n/a
- N/T profile: N_grand_T_petit

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-78.1859806069333, -66.996784940973], y [-3.60316595, 11.99163965]
- Time range: not applicable (cross-sectional dataset)
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`colombia_leptospirosis_risk` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `colombia_leptospirosis_risk` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`colombia_leptospirosis_risk` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: [dataset-first, publication non resolue] Supplementary materials - Spatiotemporal analysis of leptospirosis in Colombia from 2007 to 2021. An environmental health metrics approach

