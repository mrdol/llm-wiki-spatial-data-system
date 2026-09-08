---
title: paper_chaco_bird_richness
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_chaco_bird_richness.rds
  - DataCite_2020_TradeOffsBetweenBiodiversity_10_1111_1365_266
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes" (DOI 10.1111/1365-2664.13699).

## Description du jeu de donnees

- Topic: ecologie agricole / compromis biodiversite-agriculture
- Observation unit: site de releve ornithologique
- Observed population: communautes d'oiseaux (197 especes), Chaco argentin, N=234 sites
- Geographic context: etendue sf: x [-64.898453, -60.38754], y [-28.06263, -22.0427812]
- Temporal context: 6 distinct periods (variable: year)
- Source description: Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1111/1365-2664.13699
- Dataset DOI: 10.5061/dryad.msbcc2fvt
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.msbcc2fvt
- Local raw dir: `data/raw/papers/DataCite_2020_TradeOffsBetweenBiodiversity_10_1111_1365_266/`
- Local sf output: `data/final_datasets/sf/paper_chaco_bird_richness.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `species_richness`
- Candidate Y typology: count
- Candidate X variables in local artifact: `use`, `cover`, `habitat.type`, `htype`, `year`, `season`, `month`, `date`, `julian.date`, `season.rain`, `day.time`, `daytime`, `mmdet`, `ierdet`, `yieldE`, `yieldP`, `yieldM`, `monthly.rain`, `annual.rain`, `aridity`, `forest_3km`, `forest_6km`, `forest_10km`
- Candidate X count in local artifact: 23
- Candidate X typology: categorical, continuous
- Published X variables from paper: yieldM, forest_6km, aridity
- Published X count: 3
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `site`, `source`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `species_richness` | `integer` | count | [0, 56] | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `chaco_bird_richness`, la ou les reponses `species_richness` viennent du loader papier et/ou des preuves de l article `Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes`. Les covariables X retenues sont `yieldM`, `forest_6km`, `aridity` ; 20 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lon`, `lat`), identifiants (`site`, `source`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready_panel_reduction; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `use` | `character` | categorical | 0% |
| `cover` | `character` | categorical | 0% |
| `habitat.type` | `character` | categorical | 0% |
| `htype` | `integer` | binary | 0% |
| `year` | `integer` | count | 0% |
| `season` | `character` | categorical | 0% |
| `month` | `character` | categorical | 0% |
| `date` | `character` | categorical | 0% |
| `julian.date` | `integer` | count | 0% |
| `season.rain` | `character` | categorical | 0% |
| `day.time` | `character` | categorical | 0% |
| `daytime` | `integer` | binary | 0% |
| `mmdet` | `integer` | binary | 0% |
| `ierdet` | `integer` | binary | 0% |
| `yieldE` | `numeric` | continuous | 0% |
| `yieldP` | `numeric` | continuous | 0% |
| `yieldM` | `numeric` | continuous | 0% |
| `monthly.rain` | `numeric` | continuous | 0% |
| `annual.rain` | `integer` | continuous | 0% |
| `aridity` | `numeric` | rate | 0% |
| `forest_3km` | `numeric` | continuous | 0% |
| `forest_6km` | `numeric` | continuous | 0% |
| `forest_10km` | `numeric` | continuous | 0% |

### Formule - niveau publication

- formula_pub: occupancy_ij ~ agricultural_intensity + woodland_extent + environmental_covariate + agricultural_intensity:woodland_extent [modele hierarchique bayesien d'occupation (detection/occupancy) par espece, 197 especes x 234 sites, avec 24 combinaisons de modeles testees (3 metriques d'intensite agricole: yieldE/yieldP/yieldM x 2 mesures d'etendue boisee: forest_6km/forest_10km OU 2 covariables environnementales: rainfall/aridity, avec termes d'interaction)]
- x_terms_pub: yieldM, forest_6km, aridity
- y_term_pub: richesse specifique d'oiseaux par site
- Reference publication: Macchi et al. (2020), Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes, Journal of Applied Ecology, doi:10.1111/1365-2664.13699. Le papier ajuste un modele hierarchique bayesien d'occupation par espece (197 especes, 234 sites du Chaco argentin) avec 3 metriques d'intensite agricole (meat/energy/profit yield), 2 mesures d'etendue boisee et 2 covariables environnementales (24 combinaisons de modeles, avec interactions). Ce modele par espece n'est pas reproductible directement (historiques de detection par espece non incluses dans ce depot). formula_used agrege les occurrences en richesse specifique par site (mesure communautaire standard) et utilise exactement les covariables reelles du papier (yieldM, forest_6km, aridity) au niveau site. Donnees brutes (covas_sitios_03012018.csv + species_sitios_03012018.csv) telechargees directement depuis Dryad (10.5061/dryad.msbcc2fvt) -- pas une reconstruction, N=234 sites, coordonnees reelles (Chaco argentin).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: species_richness ~ yieldM + forest_6km + aridity
- Recommended validation: N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: count
- x_terms_used: yieldM, forest_6km, aridity
- y_term_used: species_richness
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
    formula: "species_richness ~ yieldM + forest_6km + aridity"
    response: "richesse specifique d'oiseaux par site"
    predictors: ["yieldM", "forest_6km", "aridity"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "species_richness ~ yieldE + yieldP + yieldM + forest_6km + forest_10km + annual.rain + aridity"
    response: "species_richness"
    predictors: ["yieldE", "yieldP", "yieldM", "forest_6km", "forest_10km", "annual.rain", "aridity"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["random_forest", "xgboost", "gam_spatial", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_chaco_bird_richness`
- Dataset name: Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes
- Paper DOI: 10.1111/1365-2664.13699
- Dataset DOI: 10.5061/dryad.msbcc2fvt
- Source URL: https://datadryad.org/dataset/doi:10.5061/dryad.msbcc2fvt
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "occupancy_ij ~ agricultural_intensity + woodland_extent + environmental_covariate + agricultural_intensity:woodland_extent [modele hierarchique bayesien d'occupation (detection/occupancy) par espece, 197 especes x 234 sites, avec 24 combinaisons de modeles testees (3 metriques d'intensite agricole: yieldE/yieldP/yieldM x 2 mesures d'etendue boisee: forest_6km/forest_10km OU 2 covariables environnementales: rainfall/aridity, avec termes d'interaction)]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Macchi et al. (2020), Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes, Journal of Applied Ecology, doi:10.1111/1365-2664.13699. Le papier ajuste un modele hierarchique bayesien d'occupation par espece (197 especes, 234 sites du Chaco argentin) avec 3 metriques d'intensite agricole (meat/energy/profit yield), 2 mesures d'etendue boisee et 2 covariables environnementales (24 combinaisons de modeles, avec interactions). Ce modele par espece n'est pas reproductible directement (historiques de detection par espece non incluses dans ce depot). formula_used agrege les occurrences en richesse specifique par site (mesure communautaire standard) et utilise exactement les covariables reelles du papier (yieldM, forest_6km, aridity) au niveau site. Donnees brutes (covas_sitios_03012018.csv + species_sitios_03012018.csv) telechargees directement depuis Dryad (10.5061/dryad.msbcc2fvt) -- pas une reconstruction, N=234 sites, coordonnees reelles (Chaco argentin)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready_panel_reduction"
  benchmark_task: "grouped_or_temporal_validation_review"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  reason: "N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
```

- Decision: ready_panel_reduction
- Manque principal: N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Raison: N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready_panel_reduction"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 234
- k variables: 31
- T periods: 6
- Variable temporelle: year
- N/T profile: N_moyen_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (234) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 222 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=2). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 222 unites spatiales distinctes, pas sur les 234 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 6 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-64.898453, -60.38754], y [-28.06263, -22.0427812]
- Time range: 2009 to 2014 (variable: year)
- CRS analyse recommande: 32720 (UTM Zone 20S (EPSG:32720)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.5061/dryad.msbcc2fvt (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`chaco_bird_richness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `chaco_bird_richness` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`chaco_bird_richness` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Trade-offs between biodiversity and agriculture are moving targets in dynamic landscapes

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=234; T declare=6; variable temporelle declaree=year; repetitions de coordonnees controlees=12. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : count. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
