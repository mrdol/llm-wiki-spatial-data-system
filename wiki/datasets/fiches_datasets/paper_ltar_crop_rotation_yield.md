---
title: paper_ltar_crop_rotation_yield
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_ltar_crop_rotation_yield.rds
  - DatasetFirst_10_6078_d1h409
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America" (DOI 10.1016/j.oneear.2020.02.007).

## Description du jeu de donnees

- Topic: agronomie / diversification des rotations de cultures et rendement
- Observation unit: parcelle-annee
- Observed population: 11 experiences de rotation de mais de long terme, Amerique du Nord (Etats-Unis et Canada), 1959-2016
- Geographic context: Etendue mesuree dans le RDS : x [-103.1, -76.9], y [39, 44.4]; CRS EPSG:4326.
- Temporal context: 58 distinct periods (variable: year)
- Source description: Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1016/j.oneear.2020.02.007
- Dataset DOI: 10.6078/d1h409
- Source URL: https://doi.org/10.6078/d1h409
- Local raw dir: `data/raw/papers/DatasetFirst_10_6078_d1h409/`
- Local sf output: `data/final_datasets/sf/paper_ltar_crop_rotation_yield.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `yield_kg_ha`
- Candidate Y typology: continuous
- Candidate X variables in local artifact: `year`, `system`, `tillage`, `fertilization`
- Candidate X count in local artifact: 4
- Candidate X typology: continuous, categorical
- Published X variables from paper: system, tillage, fertilization, year
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `site_lon`, `site_lat`
- Identifier columns (excluded from X candidates): `X`, `site`, `site_name`, `plot`, `block`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `yield_kg_ha` | `numeric` | continuous | [0, 20481.2] | 0.9% |

> Selection Y/X (paper-loader / curated evidence) : Pour `ltar_crop_rotation_yield`, la ou les reponses `yield_kg_ha` viennent du loader papier et/ou des preuves de l article `Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America`. Les covariables X retenues sont `system`, `tillage`, `fertilization`, `year`. Les coordonnees (`site_lon`, `site_lat`), identifiants (`X`, `site`, `site_name`, `plot`, `block`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready_panel_reduction; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `system` | `character` | categorical | 0% |
| `tillage` | `character` | categorical | 0% |
| `fertilization` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: maize_yield ~ RCI (indice de complexite rotationnelle) x year (effet d'interaction, modele bayesien hierarchique par site) [le papier synthetise 11 experiences de rotation de cultures de long terme en Amerique du Nord (347 site-annees) pour montrer que la diversification des rotations ameliore les rendements de mais, notamment sous conditions stressantes]
- x_terms_pub: system, tillage, fertilization, year
- y_term_pub: yield_kg_ha
- Reference publication: Macchi et al. (2020), Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America, One Earth, doi:10.1016/j.oneear.2020.02.007. Le papier synthetise 11 experiences de rotation de mais de long terme (347 site-annees, 1959-2016) et modelise le rendement en fonction d'un indice de diversite rotationnelle (RCI) et de son interaction avec le temps, dans un cadre bayesien hierarchique par site. formula_used utilise les covariables de conception experimentale directement presentes dans le fichier de donnees (systeme de rotation, travail du sol, fertilisation), une simplification documentee du RCI calcule par le papier a partir du systeme. Coordonnees des 11 sites lues directement dans le Tableau 1 du papier (lat/lon publies, pas une estimation ni un geocodage approximatif) : Akron CO (40.2,-103.1), Brookings SD (44.4,-96.8), Lamberton MN (44.2,-95.3), Mead NE (41.1,-96.5), Woodslee ON (42.2,-82.7), Hoytville OH (41.2,-83.8), Hickory Corners MI (42.4,-85.4), Elora ON (43.6,-80.4), Wooster OH (40.8,-81.9), Rock Springs PA (40.7,-78.0), Beltsville MD (39.0,-76.9). Donnees brutes (ltar.data.csv) telechargees directement depuis Dryad (10.6078/d1h409) via l'API avec token OAuth (la premiere tentative de harvest avait signale a tort 'aucun fichier trouve', corrige en session 2026-08-16) -- pas une reconstruction, N=11970 parcelle-annees.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: yield_kg_ha ~ system + tillage + fertilization + year
- Recommended validation: N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: system, tillage, fertilization, year
- y_term_used: yield_kg_ha
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
    formula: "yield_kg_ha ~ system + tillage + fertilization + year"
    response: "yield_kg_ha"
    predictors: ["system", "tillage", "fertilization", "year"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "yield_kg_ha ~ system + tillage + fertilization + year + site"
    response: "yield_kg_ha"
    predictors: ["system", "tillage", "fertilization", "year", "site"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["ols", "gam_spatial", "random_forest", "gwr"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_ltar_crop_rotation_yield`
- Dataset name: Long-term evidence shows crop-rotation diversification increases agricultural resilience to adverse growing conditions in North America
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America
- Paper DOI: 10.1016/j.oneear.2020.02.007
- Dataset DOI: 10.6078/d1h409
- Source URL: https://doi.org/10.6078/d1h409
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "maize_yield ~ RCI (indice de complexite rotationnelle) x year (effet d'interaction, modele bayesien hierarchique par site) [le papier synthetise 11 experiences de rotation de cultures de long terme en Amerique du Nord (347 site-annees) pour montrer que la diversification des rotations ameliore les rendements de mais, notamment sous conditions stressantes]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Macchi et al. (2020), Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America, One Earth, doi:10.1016/j.oneear.2020.02.007. Le papier synthetise 11 experiences de rotation de mais de long terme (347 site-annees, 1959-2016) et modelise le rendement en fonction d'un indice de diversite rotationnelle (RCI) et de son interaction avec le temps, dans un cadre bayesien hierarchique par site. formula_used utilise les covariables de conception experimentale directement presentes dans le fichier de donnees (systeme de rotation, travail du sol, fertilisation), une simplification documentee du RCI calcule par le papier a partir du systeme. Coordonnees des 11 sites lues directement dans le Tableau 1 du papier (lat/lon publies, pas une estimation ni un geocodage approximatif) : Akron CO (40.2,-103.1), Brookings SD (44.4,-96.8), Lamberton MN (44.2,-95.3), Mead NE (41.1,-96.5), Woodslee ON (42.2,-82.7), Hoytville OH (41.2,-83.8), Hickory Corners MI (42.4,-85.4), Elora ON (43.6,-80.4), Wooster OH (40.8,-81.9), Rock Springs PA (40.7,-78.0), Beltsville MD (39.0,-76.9). Donnees brutes (ltar.data.csv) telechargees directement depuis Dryad (10.6078/d1h409) via l'API avec token OAuth (la premiere tentative de harvest avait signale a tort 'aucun fichier trouve', corrige en session 2026-08-16) -- pas une reconstruction, N=11970 parcelle-annees."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready_panel_reduction"
  benchmark_task: "grouped_or_temporal_validation_review"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective."
  reason: "N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective."
```

- Decision: ready_panel_reduction
- Manque principal: N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective.
- Raison: N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready_panel_reduction"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 11970
- k variables: 14
- T periods: 58
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (11970) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 11 ; panel NON EQUILIBRE (T par unite : min=228, mediane=704, max=2863). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 11 unites spatiales distinctes, pas sur les 11970 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 58 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-103.1, -76.9], y [39, 44.4]
- Time range: 1959 to 2016 (variable: year)
- CRS analyse recommande: pending - multi-zones (span=26.2deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.6078/d1h409 (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`ltar_crop_rotation_yield` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `ltar_crop_rotation_yield` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`ltar_crop_rotation_yield` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Long-Term Evidence Shows that Crop-Rotation Diversification Increases Agricultural Resilience to Adverse Growing Conditions in North America

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=11970; T declare=58; variable temporelle declaree=year; repetitions de coordonnees controlees=11959. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. Unite : parcelle-annee, 11 sites et 58 annees declarees; grouper par site/parcelle et separer les annees pour une validation prospective. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : continuous. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
