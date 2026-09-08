---
title: paper_gwqlasso_mt
type: dataset
created: 2026-08-16
updated: 2026-09-07
sources:
  - data/final_datasets/sf/paper_gwqlasso_mt.rds
  - DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "An application of geographically weighted quantile lasso to weather index insurance design" (DOI 10.1590/1982-7849rac2022200387.en).

## Description du jeu de donnees

- Topic: agriculture_economic
- Observation unit: observation spatiale du dataset "Rendement de soja et precipitation, municipalites de Mato Grosso (decoupe depuis le depot brut complet 3-Etats)"
- Observed population: GWQLasso (Geographically Weighted Quantile Lasso) pour la conception d'assurance indicielle meteo, rendement de soja vs SPI (Standardized Precipitation Index)
- Geographic context: Municipalites geocodees via reference publique IBGE (kelvins/Municipios-Brasileiros), CRS EPSG:4326.
- Temporal context: 43 distinct periods (variable: Year)
- Source description: An application of geographically weighted quantile lasso to weather index insurance design
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Local raw dir: `data/raw/papers/DataCite_2022_GeographicallyWeightedQuantileLasso_10_1590_1982_7849rac2022200387_en/`
- Local sf output: `data/final_datasets/sf/paper_gwqlasso_mt.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `Yield_kg_ha`
- Candidate Y typology: continuous (corrige 2026-09-08, voir note en fin de fiche)
- Candidate X variables in local artifact: `Year`, `name_norm`, `precip_annual_mm`
- Candidate X count in local artifact: 3
- Candidate X typology: continuous, categorical
- Published X variables from paper: SPI_1month
- Published X count: 1
- Coordinates (x, y - excluded from X candidates): `muni_lon`, `muni_lat`
- Identifier columns (excluded from X candidates): `Municipality`, `State`, `station_id`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Yield_kg_ha` | `numeric` | continuous | [600, 4500] | 55.8% |

> Selection Y/X (paper-loader / curated evidence) : Pour `gwqlasso_mt`, la ou les reponses `Yield_kg_ha` viennent du loader papier et/ou des preuves de l article `An application of geographically weighted quantile lasso to weather index insurance design`. Les covariables X retenues sont `precip_annual_mm` ; 2 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`muni_lon`, `muni_lat`), identifiants (`Municipality`, `State`, `station_id`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready_panel_reduction; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Year` | `integer` | count | 0% |
| `name_norm` | `character` | categorical | 0% |
| `precip_annual_mm` | `numeric` | continuous | 5.3% |

### Formule - niveau publication

- formula_pub: Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]
- x_terms_pub: SPI_1month
- y_term_pub: Yield_kg_ha
- Reference publication: Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Meme depot/methodologie que gwqlasso_pr (voir cette entree et README_source.txt) -- decoupe Mato Grosso du meme jeu de donnees brutes complet (1030 municipalites/3 Etats).

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formule - niveau systeme

- formula_used: Yield_kg_ha ~ precip_annual_mm
- Recommended validation: N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous (corrige 2026-09-08)
- x_terms_used: precip_annual_mm
- y_term_used: Yield_kg_ha
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Voir 'Reference publication' ci-dessus pour la citation complete et la justification methodologique.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "Yield_kg_ha ~ precip_annual_mm"
    response: "Yield_kg_ha"
    predictors: ["SPI_1month"]
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
    formula: "Yield_kg_ha ~ precip_annual_mm + Year"
    response: "Yield_kg_ha"
    predictors: ["precip_annual_mm", "Year"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Voir Bloc 1 - Formule et variables > Reference publication, et Bloc 3 - modeling_evidence.source_ref, pour la citation complete."
    estimator_context: ["gwr", "quantile_regression", "lasso", "random_forest"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_gwqlasso_mt`
- Dataset name: Rendement de soja et precipitation, municipalites de Mato Grosso (decoupe depuis le depot brut complet 3-Etats)
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: An application of geographically weighted quantile lasso to weather index insurance design
- Paper DOI: 10.1590/1982-7849rac2022200387.en
- Dataset DOI: 10.7910/DVN/UEZMJT
- Source URL: https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:10.7910/DVN/UEZMJT
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Yield_kg_ha ~ SPI_1month [Geographically Weighted Quantile LASSO (GWQLasso), regression quantile geographiquement ponderee avec selection de variables Lasso]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Miquelluti, D.L., Ozaki, V.A. & Miquelluti, D.J. (2022), Revista de Administracao Contemporanea 26(3): e200387, doi:10.1590/1982-7849rac2022200387.en. Meme depot/methodologie que gwqlasso_pr (voir cette entree et README_source.txt) -- decoupe Mato Grosso du meme jeu de donnees brutes complet (1030 municipalites/3 Etats)."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready_panel_reduction"
  benchmark_task: "grouped_or_temporal_validation_review"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  reason: "N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
```

- Decision: ready_panel_reduction
- Manque principal: N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.
- Raison: N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready_panel_reduction"
  eligible_estimators: []
  conditionally_eligible_estimators: []
  ineligible_reason: "N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification."
  rule: "Revue de la tache avant selection des routes; aucune promotion automatique."
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 6063
- k variables: 12
- T periods: 43
- Variable temporelle: Year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (6063) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 141 ; panel EQUILIBRE (chaque unite a exactement T=43 observations). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 141 unites spatiales distinctes, pas sur les 6063 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 43 distinct periods (variable: Year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-61.4697, -50.514], y [-17.8241, -9.46121]
- Time range: 1974 to 2016 (variable: Year)
- CRS analyse recommande: 32721 (UTM Zone 21S (EPSG:32721)) - calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 - Reproductibilite

- License present: yes
- License name: Creative Commons Zero v1.0 Universal
- License URL: https://creativecommons.org/publicdomain/zero/1.0/legalcode
- License open: yes
- License evidence: DataCite API record for DOI 10.7910/dvn/uezmjt (checked 2026-08-18): rightsList = 'Creative Commons Zero v1.0 Universal'.
- Reproducibility status: OK - loader R enregistre et reexecutable (`gwqlasso_mt` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `gwqlasso_mt` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`gwqlasso_mt` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.


## Correction typologie Y -- 2026-09-08

Bug corrige : `Yield_kg_ha` etait stocke en `character` avec des valeurs numeriques valides mais aussi des placeholders de donnee manquante encodes en texte (`"..."`, `"-"`), ce qui declenchait a tort une classification 'categorical' (Plage: n/a) au lieu de 'continuous'. Conversion en `numeric` (placeholders -> NA) appliquee au RDS local le 2026-09-08 : 2678/6063 valeurs valides, plage [600, 4500] kg/ha. `Candidate Y typology`, `Detail Y` et `Selected Y typology` ci-dessus sont mis a jour en consequence ; `formula_used`/`x_terms_used` restaient deja corrects (aucune dependance a la typologie erronee).

## ATTENTION -- ce jeu de donnees a ete decoupe en sous-fiches, NE PAS supprimer

Ce panel complet a ete decoupe en 29 fiches (session 2026-09-08) de granularite plus fine (coupes annuelles
et/ou sous-panels groupes), pour elargir le nombre de jeux de donnees deja benchmarkables
sans casser la validite spatiale. **Le parent ET tous les enfants doivent etre conserves** --
ce ne sont pas des doublons :
- Le PARENT (cette fiche) est le panel complet, utile pour toute analyse necessitant
  l'integralite des unites spatiales x periodes ensemble (ex. modele spatial-panel avec
  effets fixes, methode Elhorst 2010).
- Chaque ENFANT est un sous-ensemble temporel du meme panel (voir la liste ci-dessous),
  utile individuellement comme jeu de donnees benchmarkable supplementaire (coupe
  transversale ou sous-panel reduit selon le cas).

Si un futur agent (LLM ou humain) envisage de supprimer l'une de ces fiches en pensant
qu'elle fait doublon avec une autre, VERIFIER D'ABORD cette note et la fiche
`wiki/eval_queue.md` / les sessions d'audit du 2026-09-07/08 avant toute suppression.

Sous-fiches (29 fiches (session 2026-09-08)) :
- [[paper_gwqlasso_mt_1989]]
- [[paper_gwqlasso_mt_1990]]
- [[paper_gwqlasso_mt_1991]]
- [[paper_gwqlasso_mt_1992]]
- [[paper_gwqlasso_mt_1993]]
- [[paper_gwqlasso_mt_1994]]
- [[paper_gwqlasso_mt_1995]]
- [[paper_gwqlasso_mt_1996]]
- [[paper_gwqlasso_mt_1997]]
- [[paper_gwqlasso_mt_1998]]
- [[paper_gwqlasso_mt_1999]]
- [[paper_gwqlasso_mt_2000]]
- [[paper_gwqlasso_mt_2001]]
- [[paper_gwqlasso_mt_2002]]
- [[paper_gwqlasso_mt_2003]]
- [[paper_gwqlasso_mt_2004]]
- [[paper_gwqlasso_mt_2005]]
- [[paper_gwqlasso_mt_2006]]
- [[paper_gwqlasso_mt_2007]]
- [[paper_gwqlasso_mt_2008]]
- [[paper_gwqlasso_mt_2009]]
- [[paper_gwqlasso_mt_2010]]
- [[paper_gwqlasso_mt_2011]]
- [[paper_gwqlasso_mt_2012]]
- [[paper_gwqlasso_mt_2013]]
- [[paper_gwqlasso_mt_2014]]
- [[paper_gwqlasso_mt_2015]]
- [[paper_gwqlasso_mt_2016]]
- [[paper_gwqlasso_mt_pre1989]]

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: An application of geographically weighted quantile lasso to weather index insurance design

## Curation documentée — 2026-09-07

Decision conservatoire : N lignes=6063; T declare=43; variable temporelle declaree=Year; repetitions de coordonnees controlees=5922. Grouper les observations du meme site/immeuble/individu dans un seul fold, et respecter la chronologie si l’objectif est prospectif. Le split aleatoire par ligne n’est pas valide sans justification. La fiche et les donnees sont conservees ; aucune suppression ni promotion.

Typologie de la reponse selectionnee : categorical. Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.
