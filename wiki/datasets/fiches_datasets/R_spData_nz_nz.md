---
title: R_spData_nz_nz
type: dataset
created: 2026-08-15
updated: 2026-09-15
sources:
  - data/final_datasets/sf/R_spData_nz_nz.rds
tags: [dataset, r-package, spatial, point]
---

Polygons representing the 16 regions of New Zealand (2018). See <https://en.wikipedia.org/wiki/Regions_of_New_Zealand> for a description of these regions and <https://www.stats.govt.nz> for information on the data source

## Description du jeu de donnees

- Topic: demographie/socio-economie regionale (Nouvelle-Zelande)
- Observation unit: region administrative de Nouvelle-Zelande (16 regions, 2018)
- Observed population: les 16 regions de Nouvelle-Zelande (recensement/statistiques 2018)
- Geographic context: Etendue mesuree dans le RDS : x [167.948793773008, 177.907383233388], y [-45.449626495693, -35.43905422096]; CRS EPSG:4326 (geometrie active, point). Geometrie source native : MULTIPOLYGON, EPSG:2193 (NZGD2000 / New Zealand Transverse Mercator) -- verifie par inspection directe du .rds.
- Temporal context: aucune variable temporelle structurelle detectee (photographie 2018)
- Source description: Polygons representing the 16 regions of New Zealand (2018). See <https://en.wikipedia.org/wiki/Regions_of_New_Zealand> for a description of these regions and <https://www.stats.govt.nz> for information on the data source
- Description source: package R `spData`
- Description confidence: high (verifie par inspection directe R et documentation reelle du package, 2026-09-15)

> Note de fidelite (2026-09-15) : la source native est un jeu de POLYGONES (MULTIPOLYGON, 16 regions, EPSG:2193) ; le .rds conserve les deux geometries conformement a la methodologie documentee du pipeline sf (code/r_catalog/guide_objets_sf.md, section 3-5) : `geom_origine` (MULTIPOLYGON, EPSG:2193, verifie) et `geom_point` (POINT, EPSG:4326, point garanti a l'interieur du polygone via `st_point_on_surface()`). Rien n'est perdu ; `Type de geometrie: POINT` (Bloc 5) decrit la geometrie active par defaut.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Population`, `Median_income`, `Sex_ratio`
- Candidate Y typology: continuous
- Candidate X variables: `Land_area`, `Island`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R ; correction 2026-09-15, verification tools::Rd_db("spData"))
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Population` | `numeric` | continuous | [32400, 1657200] | 0% |
| `Median_income` | `integer` | continuous | [23400, 32700] | 0% |
| `Sex_ratio` | `numeric` | continuous | [0.9238, 1.0139] | 0% |

> Correction 2026-09-15 (mode production de secours, tools::Rd_db("spData")) : `Median_income` etait a tort typee "count" ; c'est un revenu median en NZD (grandeur monetaire continue, classe R `integer` uniquement car sans decimales dans la source), meme confusion "integer -> count" que celle deja identifiee sur d'autres fiches spData (ex. R_spData_house_house).

> Selection Y/X (claude-sonnet-4-6) : Population, Median_income et Sex_ratio sont des indicateurs socio-économiques ou démographiques plausibles comme variables réponse à modéliser spatialement. Land_area et Island (Nord/Sud) sont des covariables explicatives naturelles capturant la taille et la localisation géographique des régions ; Name est ignoré car purement administratif.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Land_area` | `numeric` | continuous | 0% |
| `Island` | `character` | categorical | 0% |

### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending -- verification 2026-09-15 : recherche dans "Geocomputation with R" (Lovelace, Nowosad & Muenchow), l'ouvrage de reference qui utilise le plus ce jeu de donnees dans le corpus (corpus/papers/tei/Geocomputation-with-R.tei.xml). `Median_income` n'y apparait que dans des exemples de cartographie (choroplethe tmap, cartogramme continu `cartogram_cont()`), jamais dans un modele de regression. Aucune formule publiee trouvee pour ce jeu de donnees -- "pending" reste honnete, non fabrique.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: Population ~ Land_area + Island
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: Land_area + Island
- y_term_used: Population

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
    formula: "Population ~ Land_area + Island"
    response: "Population"
    predictors: ["Land_area", "Island"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_nz_nz`
- Dataset name: spData::nz
- Source family: r-package
- Source: package R `spData` (version 2.3.4)
- Source URL: https://CRAN.R-project.org/package=spData
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "Population ~ Land_area + Island"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 16
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [167.9488, 177.9074], y [-45.4496, -35.4391] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32759 (UTM Zone 59S (EPSG:32759)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC0
- License URL: https://CRAN.R-project.org/package=spData
- License open: yes
- Reproducibility status: available via package R `spData`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "almost_ready_small_n"
  benchmark_task: "regression_spatial_small_sample"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "valider un schema CV adapte aux petits echantillons"
  reason: "La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs."
```

- Decision: almost_ready_small_n
- Manque principal: valider un schema CV adapte aux petits echantillons
- Raison: La formule et les covariables sont executables, mais l echantillon est petit pour une comparaison robuste d estimateurs.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes. Correction 2026-09-15 : Median_income reclassee "count" -> "continuous".
- Formula: PENDING - formule publication non encore etablie ; recherche menee dans "Geocomputation with R" (reference principale utilisant ce jeu de donnees), aucune formule de regression trouvee (usage cartographique uniquement).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326) pour la geometrie active ; geometrie source native EPSG:2193 (NZTM) documentee en Description.
- Geometry: OK - Type de geometrie POINT dans le .rds local (geometrie active) ; source native MULTIPOLYGON (16 regions) preservee dans geom_origine, conversion documentee comme deliberee (voir note de fidelite).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`

## Curation documentée — 2026-09-07

Verification 2026-09-15 (mode production de secours, tools::Rd_db("spData") + inspection directe du .rds + recherche dans corpus/papers/tei/Geocomputation-with-R.tei.xml) : source confirmee MULTIPOLYGON (16 regions, EPSG:2193 NZTM), non native POINT -- note de fidelite ajoutee (geom_origine preserve, geom_point derive via st_point_on_surface()). Median_income reclassee de "count" vers "continuous" (revenu monetaire, pas un denombrement). Recherche de formule menee dans "Geocomputation with R" (Lovelace, Nowosad & Muenchow), l'ouvrage qui utilise le plus ce jeu de donnees dans notre corpus : Median_income n'y sert qu'a des exemples de cartographie (choroplethe, cartogramme), jamais a un modele de regression -- formula_pub reste honnetement "pending", aucune formule fabriquee.
