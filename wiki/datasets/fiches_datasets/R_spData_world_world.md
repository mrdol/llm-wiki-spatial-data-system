---
title: R_spData_world_world
type: dataset
created: 2026-08-15
updated: 2026-09-15
sources:
  - data/final_datasets/sf/R_spData_world_world.rds
tags: [dataset, r-package, spatial, point]
---

The object loaded is a ‘sf’ object containing a world map data from Natural Earth with a few variables from World Bank

## Description du jeu de donnees

- Topic: economie/demographie mondiale par pays
- Observation unit: pays (177 pays/territoires)
- Observed population: 177 pays du monde, donnees Natural Earth + variables socio-economiques World Bank (2014)
- Geographic context: Etendue mesuree dans le RDS : x [-110.243807777161, 177.97594930137], y [-76.60511625, 79.958143]; CRS EPSG:4326 (geometrie active et source, toutes deux WGS84 -- ce jeu de donnees est nativement non projete, aucune reprojection necessaire).
- Temporal context: aucune variable temporelle structurelle detectee (photographie 2014)
- Source description: The object loaded is a 'sf' object containing a world map data from Natural Earth with a few variables from World Bank
- Description source: package R `spData`
- Description confidence: high (verifie par inspection directe R et documentation reelle du package, 2026-09-15)

> Note de fidelite (2026-09-15) : la source native est un jeu de POLYGONES (MULTIPOLYGON, 177 pays, EPSG:4326). Le .rds conserve les deux geometries conformement a la methodologie documentee du pipeline sf (code/r_catalog/guide_objets_sf.md, section 3-5) : `geom_origine` (MULTIPOLYGON, EPSG:4326, verifie) et `geom_point` (POINT, meme CRS EPSG:4326 -- aucune reprojection necessaire ici puisque la source etait deja en WGS84, contrairement a DubVoter/USelect/nz). `Type de geometrie: POINT` (Bloc 5) decrit la geometrie active par defaut, pas une perte d'information.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `lifeExp`, `gdpPercap`, `pop`
- Candidate Y typology: continuous
- Candidate X variables: `area_km2`, `continent`, `region_un`, `subregion`, `type`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `lifeExp` | `numeric` | continuous | [50.621, 83.5878] | 5.6% |
| `gdpPercap` | `numeric` | continuous | [597.1352, 120860.0676] | 9.6% |
| `pop` | `numeric` | continuous | [56295, 1364270000] | 5.6% |


> Selection Y/X (claude-sonnet-4-6) : lifeExp, gdpPercap et pop sont des variables quantitatives de résultat classiquement modélisées en économie et démographie spatiale. area_km2, continent, region_un, subregion et type sont des caractéristiques structurelles des pays utilisables comme covariables explicatives ; iso_a2 et name_long sont des identifiants/libellés ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `area_km2` | `numeric` | continuous | 0% |
| `continent` | `character` | categorical | 0% |
| `region_un` | `character` | categorical | 0% |
| `subregion` | `character` | categorical | 0% |
| `type` | `character` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: lifeExp ~ area_km2 + continent + region_un + subregion + type
- Formula used evidence: generated_system_formula
- Selected Y evidence: Ligne Detail Y correspondant a formula_used; les autres reponses candidates ne pilotent pas cette tache.
- Selected Y typology: continuous
- x_terms_used: area_km2 + continent + region_un + subregion + type
- y_term_used: lifeExp

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
    formula: "lifeExp ~ area_km2 + continent + region_un + subregion + type"
    response: "lifeExp"
    predictors: ["area_km2", "continent", "region_un", "subregion", "type"]
    role: "ml_candidate_features"
    source_type: "generated_system_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["random_forest", "xgboost", "gamboost", "spboost"]
    status: "generated"
```

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spData_world_world`
- Dataset name: spData::world
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
  equation_text: "lifeExp ~ area_km2 + continent + region_un + subregion + type"
  equation_family: regression_candidate
  model_family: "regression_candidate"
  source_type: generated_system_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 177
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-110.2438, 177.9759], y [-76.6051, 79.9581] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending — etendue continentale/mondiale (span=288.2deg) -- projection nationale non pertinente ; privilegier une projection equal-area continentale ou mondiale (ex: Albers equal-area continental, Behrmann/Mollweide pour une couverture mondiale)

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
  benchmark_status: "almost_ready_generated_formula"
  benchmark_task: "regression_spatial_generated_formula"
  package_include: "manual_review"
  has_local_rds: true
  missing_items: "valider la formule generee avant inclusion automatique dans le package"
  reason: "La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee."
```

- Decision: almost_ready_generated_formula
- Manque principal: valider la formule generee avant inclusion automatique dans le package
- Raison: La formule est executable et le support spatial existe, mais elle provient d une proposition systeme plutot que d une source scientifique confirmee.


## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie ; recherche menee dans "Geocomputation with R" (reference principale utilisant ce jeu de donnees), aucune formule de regression trouvee (usage cartographique/pedagogique uniquement).
- CRS: OK - CRS renseigne dans le Bloc 5 (4326), coherent entre geometrie active et source (aucune reprojection necessaire).
- Geometry: OK - Type de geometrie POINT dans le .rds local (geometrie active) ; source native MULTIPOLYGON (177 pays) preservee dans geom_origine, conversion documentee comme deliberee (voir note de fidelite).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CC0).

## Related Pages

- Source: package R `spData`

## Curation documentée — 2026-09-07

Verification 2026-09-15 (mode production de secours, tools::Rd_db("spData") + inspection directe du .rds + recherche dans corpus/papers/tei/Geocomputation-with-R.tei.xml) : source confirmee MULTIPOLYGON (177 pays, EPSG:4326), non native POINT -- note de fidelite ajoutee (geom_origine preserve, geom_point derive via st_point_on_surface() ; pas de reprojection necessaire ici car la source est deja WGS84, a la difference de nz/DubVoter/USelect). Recherche de formule menee dans "Geocomputation with R", l'ouvrage qui utilise le plus ce jeu de donnees dans notre corpus : lifeExp/gdpPercap n'y servent qu'a des exemples de manipulation/cartographie/Shiny, jamais a un modele de regression -- formula_pub reste honnetement "pending", aucune formule fabriquee.

## Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending -- verification 2026-09-15 : recherche dans "Geocomputation with R" (Lovelace, Nowosad & Muenchow), l'ouvrage de reference qui utilise le plus ce jeu de donnees dans le corpus (corpus/papers/tei/Geocomputation-with-R.tei.xml, 10 occurrences de lifeExp, 3 de gdpPercap). Dans tous les cas, ces variables ne servent qu'a des exemples de manipulation de donnees, filtrage, cartographie (tmap/mapview/leaflet) et une application Shiny de demonstration ("lifeApp") -- jamais a un modele de regression. Aucune formule publiee trouvee pour ce jeu de donnees -- "pending" reste honnete, non fabrique.
