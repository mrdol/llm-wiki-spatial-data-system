---
title: R_gstat_pcb_pcb
type: dataset
created: 2026-08-15
updated: 2026-09-07
sources:
  - data/final_datasets/sf/R_gstat_pcb_pcb.rds
tags: [dataset, r-package, spatial, point]
---

PCB138 measurements in sediment at the NCP, which is the Dutch part of the North Sea

## Description du jeu de donnees

- Topic: dataset spatial spatio-temporel
- Observation unit: observation spatiale de type POINT
- Observed population: 216 enregistrements dans l’artefact local R_gstat_pcb_pcb.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [477952.45, 736018.82], y [5692380.66, 6132475.4]; CRS non renseigne, repere/unites a documenter.
- Temporal context: dimension temporelle structurelle detectee
- Source description: PCB138 measurements in sediment at the NCP, which is the Dutch part of the North Sea
- Description source: package R `gstat`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `PCB138`
- Candidate Y typology: continuous
- Candidate X variables: `year`, `coast`, `depth`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `PCB138` | `numeric` | continuous | [0.2, 21.1] | 0% |


> Selection Y/X (claude-sonnet-4-6) : PCB138 est la mesure de concentration en polluant, cible naturelle de modélisation spatiale/temporelle. Les covariables explicatives retenues sont l'année (tendance temporelle), la distance à la côte et la profondeur (facteurs environnementaux structurant la distribution des sédiments). Les colonnes 'yf' et 'T' sont exclues car redondantes avec 'year' (même plage de valeurs, encodages alternatifs de l'année).

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `coast` | `numeric` | continuous | 0% |
| `depth` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: pending - analyse geostatistique spatio-temporelle de PCB138 ; coast/depth sont des candidats plausibles de derive externe (universal kriging with external drift) mais aucune formule exacte confirmee dans la source (article non accessible en texte integral).
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Pebesma, E. J., and Duin, R. N. M. (2005). Spatial patterns of temporal change in North Sea sediment quality on different spatial scales.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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
    formula: "pending"
    response: "pending"
    predictors: []
    role: "paper_main_specification"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  ml_or_selected:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "ml_candidate_features"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_gstat_pcb_pcb`
- Dataset name: gstat::pcb
- Source family: r-package
- Source: package R `gstat` (version 2.1.6)
- Source URL: https://CRAN.R-project.org/package=gstat
- Dataset DOI: none
- Publication DOI: 10.1007/3-540-26535-x_31
- Year: 2003

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: n/a
  model_family: "n/a"
  source_type: none_found
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 216
- T periods: 7
- Variable temporelle: year
- N/T profile: N_moyen_T_moyen
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (216) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 171 ; panel NON EQUILIBRE (T par unite : min=1, mediane=1, max=3). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 171 unites spatiales distinctes, pas sur les 216 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.
- Temporal note: dimension temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [477952.45, 736018.82], y [5692380.66, 6132475.4] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: 32631
- CRS nom: WGS 84 / UTM zone 31N
- CRS analyse recommande: 32631 (deja en projection UTM zone 31N, meme region NCP que gstat::fulmar, directement utilisable)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2.0)
- License URL: https://CRAN.R-project.org/package=gstat
- License open: yes
- Reproducibility status: available via package R `gstat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "not_ready_missing_formula"
  benchmark_task: "not_current_regression_benchmark"
  package_include: "no"
  has_local_rds: true
  missing_items: "formule Y ~ X executable manquante"
  reason: "Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package."
```

- Decision: not_ready_missing_formula
- Manque principal: formule Y ~ X executable manquante
- Raison: Aucune formule systeme ou publication n est disponible pour ce jeu de donnees package.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2.0)).

## Related Pages

- Source: package R `gstat`

## Curation documentée — 2026-09-07

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

Verification 2026-09-15 (mode production de secours, tools::Rd_db("gstat")) : x/y confirmees "UTM zone 31" (EPSG:32631) dans la documentation. Publication DOI resolu (10.1007/3-540-26535-x_31, chapitre "Spatio-temporal mapping of sea floor sediment pollution in the North Sea", verifie via Crossref -- auteurs et pages 367-378 identiques a la reference deja citee dans la fiche, Pebesma & Duin 2005, seul le DOI manquait). AVERTISSEMENT D'USAGE (documentation officielle gstat::pcb) : les valeurs PCB138 ont subi des normalisations non documentees ni dans l'aide R ni dans l'article -- les auteurs demandent explicitement de contacter RIKZ avant toute utilisation hors reproduction de leur propre analyse. formula_pub reste a juste titre "pending" (aucune formule exacte confirmee, article non recupere en texte integral).
