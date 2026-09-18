---
title: paper_swiss_heat_exposure
type: dataset
created: 2026-09-14
updated: 2026-09-16
sources:
  - data/final_datasets/sf/paper_swiss_heat_exposure.rds
  - DatasetFirst_10_5281_zenodo_16923676
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Modelling the spatially varying nonlinear effects of heat exposure" (DOI 10.1093/jrsssa/qnaf208).

## Description du jeu de donnees

- Topic: sante environnementale / mortalite liee a la chaleur
- Observation unit: commune x jour
- Observed population: population 65+, communes suisses (N=2145), panel journalier 2011-2022
- Geographic context: Etendue mesuree dans le RDS : x [2487218.9645969365, 2825377.7997474237], y [1076471.472803228, 1294284.2639934118]; CRS CH1903+ / LV95 + LN02 height.
- Temporal context: 12 distinct periods (variable: year)
- Source description: Modelling the spatially varying nonlinear effects of heat exposure
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1093/jrsssa/qnaf208
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
- Candidate X typology: categorical, continuous, unknown
- Published X variables from paper: temperature (temperature quotidienne), temperature_lag1/2/3 (temperature des 3 jours precedents), greenspace (indice d'espace vert communal -- confirme comme facteur de disparite spatiale par le resume officiel), urbanicity (statut urbain/rural de la commune)
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): geometrie sf `geom_point` (POINT)
- Identifier columns (excluded from X candidates): `id_region`, `region`, `KANTONSNUM`, `id_doy`, `id_year`, `daily_date`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `deaths` | `numeric` | count | [0, 12] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `swiss_heat_exposure`, la ou les reponses `deaths` viennent du loader papier et/ou des preuves de l article `Modelling the spatially varying nonlinear effects of heat exposure`. Les covariables X retenues sont `temperature`, `temperature_lag1`, `temperature_lag2`, `temperature_lag3`, `greenspace`, `urbanicity` ; 14 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (geometrie sf `geom_point` (POINT)), identifiants (`id_region`, `region`, `KANTONSNUM`, `id_doy`, `id_year`, `daily_date`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready; la promotion package reste conditionnee au bloc benchmark_readiness.

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
| `dom` | `integer` | unknown | 0% |
| `dow` | `numeric` | continuous | 0% |
| `temperature_lag03` | `numeric` | continuous | 0% |
| `week` | `numeric` | continuous | 0% |
| `holiday` | `numeric` | binary | 0% |
| `day` | `integer` | unknown | 0% |
| `canton_deaths` | `numeric` | continuous | 0% |
| `weight` | `numeric` | rate | 0% |
| `deaths_sim` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: deaths ~ f(temperature, nonlinear, spatially-varying) [modele bayesien BYM2 avec effets non-lineaires spatialement variables -- Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Mortalite toutes causes en Suisse, disparites spatiales de mortalite liee a la chaleur expliquees principalement par la structure d'age de la population, les espaces verts et les vulnerabilites liees a l'exposition a la chaleur (resume officiel)]
- x_terms_pub: temperature (temperature quotidienne), temperature_lag1/2/3 (temperature des 3 jours precedents), greenspace (indice d'espace vert communal -- confirme comme facteur de disparite spatiale par le resume officiel), urbanicity (statut urbain/rural de la commune)
- y_term_pub: deaths (nombre quotidien de deces, population 65 ans et plus, par commune)
- Reference publication: Papier identifie via recherche web (session 2026-08-17 ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022). CORRECTION (2026-09-09) : le depot Zenodo n'a pas de README expliquant deaths vs deaths_sim ; verification faite en lisant le code de replication des auteurs (repository GitHub associe, fxinyichen/SwissHeat_svc, script '1. SH_model_12.R') : la reponse du modele BYM2 publie est bien deaths (deaths_sim sert a autre chose, jamais utilise comme y). Le script confirme aussi un offset log(population) -- absent de la formule precedente -- desormais ajoute. Modele publie complet (non reproduit ici) : Poisson avec offset log(population), factor(dow), factor(holiday), 4 termes de base temperature (splines DLNM), effet aleatoire jour-de-l'annee (RW2), effet aleatoire annee (iid), effet spatial regional BYM2, et 4 coefficients spatialement variables pour la temperature (BYM2 x spline). formula_used simplifie ce modele en regression additive standard (sans les effets spatialement variables ni les effets aleatoires temporels), approximation documentee, pas la specification exacte. package_include laisse en manual_review pour cette raison.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-17), reponse (deaths vs deaths_sim) et offset log(population) confirmes le 2026-09-09 par lecture directe du code de replication des auteurs.

### Formule - niveau systeme

- formula_used: deaths ~ offset(log(population)) + temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity
- License evidence: DataCite API record for DOI 10.5281/zenodo.16923676 (checked 2026-08-18): rightsList = 'Creative Commons Attribution 4.0 International'.
- benchmark_task_note: deaths denombre les deces; verifier la provenance distincte de deaths_sim et le panel commune/jour.
- Selected Y evidence: deaths denombre les deces; verifier la provenance distincte de deaths_sim et le panel commune/jour.
- Selected Y typology: count
- x_terms_used: temperature, temperature_lag1, temperature_lag2, temperature_lag3, greenspace, urbanicity
- y_term_used: deaths
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
    formula: "deaths ~ offset(log(population)) + temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity"
    response: "deaths (nombre quotidien de deces, population 65 ans et plus, par commune)"
    predictors: ["temperature (temperature quotidienne)", "temperature_lag1/2/3 (temperature des 3 jours precedents)", "greenspace (indice d'espace vert communal -- confirme comme facteur de disparite spatiale par le resume officiel)", "urbanicity (statut urbain/rural de la commune)"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "mgwrsar_gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "deaths ~ offset(log(population)) + temperature + temperature_lag1 + temperature_lag2 + temperature_lag3 + greenspace + urbanicity + holiday + dow"
    response: "deaths"
    predictors: ["population", "temperature", "temperature_lag1", "temperature_lag2", "temperature_lag3", "greenspace", "urbanicity", "holiday", "dow"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["bym2", "car_besag", "gam_spatial", "gwr", "random_forest_xy"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_swiss_heat_exposure`
- Dataset name: Modelling the Spatially Varying Non-Linear Effects of Heat Exposure
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Modelling the spatially varying nonlinear effects of heat exposure
- Paper DOI: 10.1093/jrsssa/qnaf208
- Dataset DOI: 10.5281/zenodo.16923676
- Source URL: https://doi.org/10.5281/zenodo.16923676
- Year: 2025

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
  source_ref: "Papier identifie via recherche web (session 2026-08-17 ; KG mis a jour le 2026-09-14 -- paper_doi/paper_title, precedemment non resolus malgre la citation deja identifiee) : Chen, Blangiardo, Gascoigne & Konstantinoudis (2025), 'Modelling the spatially varying nonlinear effects of heat exposure', Journal of the Royal Statistical Society Series A, doi:10.1093/jrsssa/qnaf208 (preprint arXiv:2502.20745). Le papier ajuste un modele bayesien BYM2 avec effets non-lineaires spatialement variables (pas une regression lineaire classique) sur la mortalite toutes causes en Suisse. RDS originaux (data_60_open.rds, panel deces population 65+ ; Swiss_new_open.rds, geometrie communale + NDVI/greenspace) telecharges directement depuis Zenodo -- pas une reconstruction, N=2368080 (panel 2145 communes x ~1104 jours, 2011-2022). CORRECTION (2026-09-09) : le depot Zenodo n'a pas de README expliquant deaths vs deaths_sim ; verification faite en lisant le code de replication des auteurs (repository GitHub associe, fxinyichen/SwissHeat_svc, script '1. SH_model_12.R') : la reponse du modele BYM2 publie est bien deaths (deaths_sim sert a autre chose, jamais utilise comme y). Le script confirme aussi un offset log(population) -- absent de la formule precedente -- desormais ajoute. Modele publie complet (non reproduit ici) : Poisson avec offset log(population), factor(dow), factor(holiday), 4 termes de base temperature (splines DLNM), effet aleatoire jour-de-l'annee (RW2), effet aleatoire annee (iid), effet spatial regional BYM2, et 4 coefficients spatialement variables pour la temperature (BYM2 x spline). formula_used simplifie ce modele en regression additive standard (sans les effets spatialement variables ni les effets aleatoires temporels), approximation documentee, pas la specification exacte. package_include laisse en manual_review pour cette raison."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_count"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucun blocage automatique detecte"
  reason: "CORRECTION 2026-09-09 : typologie corrigee (count, pas continuous -- deaths est deja correctement type 'count' dans Detail Y et Selected Y typology, seul le resume Candidate Y typology etait obsolete). Reponse (deaths, pas deaths_sim) et offset (log(population), absent avant) confirmes en lisant le script de replication des auteurs (fxinyichen/SwissHeat_svc). Le modele publie exact (BYM2 spatialement variable) reste hors de portee du harnais -- estimateurs generiques (gam_spatial, xgboost) en base benchmark_use."
```

- Decision: ready
- Manque principal: aucun blocage automatique detecte
- Raison: CORRECTION 2026-09-09 : typologie corrigee (count, pas continuous -- deaths est deja correctement type 'count' dans Detail Y et Selected Y typology, seul le resume Candidate Y typology etait obsolete). Reponse (deaths, pas deaths_sim) et offset (log(population), absent avant) confirmes en lisant le script de replication des auteurs (fxinyichen/SwissHeat_svc). Le modele publie exact (BYM2 spatialement variable) reste hors de portee du harnais -- estimateurs generiques (gam_spatial, xgboost) en base benchmark_use.

## Estimator eligibility

```yaml
estimator_eligibility:
  eligible_estimators:
    - estimator: gam_spatial
      basis: benchmark_use
      source_ref: "mgcv::gam supporte nativement offset() + famille Poisson -- estimateur le plus proche du modele BYM2 publie (non reproduit exactement, pas de terme spatialement variable dans le harnais)."
      notes: "Approximation generique du modele publie (Poisson, offset log(population)), sans les effets spatialement variables BYM2 ni les effets aleatoires temporels (jour-de-l'annee, annee)."
    - estimator: xgboost
      basis: benchmark_use
      source_ref: "Aucune -- comparateur ML generique, objectif Poisson possible, offset a gerer manuellement (non natif)."
      notes: "Comparateur ML, pas le modele publie."
  conditionally_eligible_estimators: []
  ineligible_reason: "n/a -- estimateurs generiques eligibles (voir eligible_estimators)."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 2368080
- k variables: 30
- T periods: 12
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (2368080) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 2145 ; panel EQUILIBRE (chaque unite a exactement T=1104 observations). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 2145 unites spatiales distinctes, pas sur les 2368080 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation (support reel : commune, panel commune x jour)
- Temporal resolution: 12 distinct periods (variable: year)
- CRS EPSG: unknown
- CRS nom: CH1903+ / LV95 + LN02 height
- Spatial extent: x [2487218.96459694, 2825377.79974742], y [1076471.47280323, 1294284.26399341]
- Time range: 2011 to 2022 (variable: year)
- CRS analyse recommande: aucune reprojection necessaire -- CRS deja projete et metrique. EPSG:2056 (CH1903+ / LV95, confirme via epsg.io -- correspond exactement au nom deja renseigne ci-dessus).

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Attribution 4.0 International
- License URL: https://creativecommons.org/licenses/by/4.0/legalcode
- License open: yes
- Reproducibility status: OK - loader R enregistre et reexecutable (`swiss_heat_exposure` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `swiss_heat_exposure` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - Statut 'resolu' documente et intentionnel (voir Bloc 1 > Statut regression canonique > Note) ; ne pas retraiter sans revue.
- CRS: WARN - CRS absent du sf source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`swiss_heat_exposure` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Modelling the spatially varying nonlinear effects of heat exposure

## Curation documentée — 2026-09-07

Decision conservatoire : deaths est un comptage 0–12, mais typologie continuous; panel 2 368 080 lignes, 2 145 communes. Modèle BYM2 simplifié et colonnes deaths_sim/weight présentes. Vérifier deaths versus deaths_sim dans les deux RDS bruts et la notice, exposition population et dépendance temporelle; garder en revue. Ne pas inventer une version continue. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. deaths denombre les deces; verifier la provenance distincte de deaths_sim et le panel commune/jour.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Correction 2026-09-16 (mode production de secours) : le champ 'CRS analyse recommande' affirmait a tort que le CRS source etait non geographique/inconnu alors qu'il etait deja renseigne juste au-dessus -- corrige (voir le champ lui-meme pour le texte actuel).
