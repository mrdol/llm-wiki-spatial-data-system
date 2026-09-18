---
title: Python_geodatasets_spdata.eire
type: dataset
created: 2026-08-15
updated: 2026-09-18
sources:
  - data/final_datasets/sf/Python_geodatasets_spdata.eire.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`eire`).

## Description du jeu de donnees

- Topic: Donnees de python-package : Python_geodatasets_spdata.eire
- Observation unit: observation spatiale de type POINT
- Observed population: 26 enregistrements dans l’artefact local Python_geodatasets_spdata.eire.rds; unite declaree : observation spatiale de type POINT. Le nombre de lignes n’est pas le nombre de sites independants.
- Geographic context: Etendue mesuree dans le RDS : x [-10.113712, -6.265457], y [52.268993, 54.725978]; CRS WGS 84 (corrige le 2026-09-18 -- correspond maintenant a la vraie etendue geographique de l'Irlande, voir Bloc 5 > CRS note).
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: Dataset spatial issu du package Python `geodatasets` (`eire`).
- Description source: package Python `geodatasets`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `INCOME`, `POPCHG`, `RETSALE`
- Candidate Y typology: continuous
- Candidate X variables: `A`, `towns`, `pale`, `size`, `ROADACC`, `OWNCONS`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `INCOME` | `numeric` | continuous | [5297, 164631] | 0% |
| `POPCHG` | `numeric` | continuous | [60, 142] | 0% |
| `RETSALE` | `numeric` | continuous | [1885, 89424] | 0% |


> Selection Y/X (claude-sonnet-4-6) : INCOME, POPCHG et RETSALE sont des variables socio-économiques classiquement utilisées comme cibles dans des modèles spatiaux (revenus, croissance démographique, ventes au détail). Les autres variables numériques (superficie A, taux d'urbanisation towns, indicateur historique pale, taille size, accessibilité routière ROADACC, occupation des logements OWNCONS) constituent des covariables explicatives plausibles ; la colonne names est ignorée car purement administrative.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `A` | `numeric` | continuous | 0% |
| `towns` | `numeric` | rate | 0% |
| `pale` | `numeric` | binary | 0% |
| `size` | `numeric` | continuous | 0% |
| `ROADACC` | `numeric` | continuous | 0% |
| `OWNCONS` | `numeric` | continuous | 0% |


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

- formula_used: A ~ towns + pale
- CRS note: Corrige le 2026-09-18 : le point actif (geom_point) etait auparavant derive (st_point_on_surface) sur une geometrie faussement etiquetee WGS84 alors que ses coordonnees sont en realite en UTM zone 30 (ellipsoide Airy, unites km -- confirme via la doc officielle du package, wiki/datasets/r_package_docs/spData/topics/eire.md : 'polygons... in eire.polys.utm (coordinates in km, projection UTM zone 30)'). Le calcul spherique (moteur s2) applique a tort a ces valeurs (ex. y~5885) produisait un point derive incoherent (bbox precedent : x[-101.79,125.29] y[-70.3,72.45], span=227.1deg). CRS_OVERRIDES fixe desormais la vraie definition PROJ4 (+proj=utm +zone=30 +ellps=airy +units=km) avant derivation du point, puis reprojette en 4326. La nouvelle etendue x[-10.11,-6.27] y[52.27,54.73] correspond exactement a l'Irlande reelle.
- x_terms_used: towns + pale
- y_term_used: A

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
    formula: "A ~ towns + pale"
    response: "A"
    predictors: ["towns", "pale"]
    role: "paper_main_specification"
    source_type: "published_or_manual_formula"
    source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

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

- Dataset ID: `Python_geodatasets_spdata.eire`
- Dataset name: geodatasets::eire
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "A ~ towns + pale"
  equation_family: regression
  model_family: "regression"
  source_type: published_or_manual_formula
  source_ref: "data/manifests/datasets/proposed_formula_used_audit.csv"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 26
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_petit
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-10.113712, -6.265457], y [52.268993, 54.725978] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT (source native : MULTIPOLYGON, preservee dans `geom_origine` ; geometrie active derivee via `st_point_on_surface()` ou equivalent, methodologie documentee dans code/r_catalog/guide_objets_sf.md section 3-5 -- rien n'est perdu, correction 2026-09-16 apres verification via tools/verify_fiche_crs.py)
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32629 (UTM Zone 29N (EPSG:32629)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement (corrige le 2026-09-18, voir CRS note)

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

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
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `geodatasets`

## Curation documentée — 2026-09-07

Provenance des corrections : audit du 2026-09-07, inspection du RDS et sources indiquees dans cette fiche. Regeneration : code/r_catalog/dataset_curation.py et dataset_curation_overrides.json.

## Curation documentée — 2026-09-18

Correction CRS (2026-09-18) : le point actif (geom_point) de ce jeu etait derive d'une geometrie de polygone faussement etiquetee WGS84 (EPSG:4326), alors que les coordonnees d'origine sont en realite en UTM zone 30 (ellipsoide Airy, unites km). Preuve : (1) la documentation officielle du package (wiki/datasets/r_package_docs/spData/topics/eire.md) precise explicitement 'polygons of the 26 counties are provided as a multipart polylist in eire.polys.utm (coordinates in km, projection UTM zone 30)' ; (2) le GeoJSON source brut telecharge par notre pipeline (data/downloads/software/python_datasets/geojson/geodatasets__spdata_eire.geojson) n'a aucun CRS declare (crs=null) et des coordonnees de polygone (ex. 240.62, 5885.61) a l'echelle exacte de cette definition UTM. Le point derive (st_point_on_surface) etait calcule via le moteur spherique s2 de sf sur ces valeurs interpretees a tort comme des degres, produisant un resultat geometriquement incoherent (bbox precedent x[-101.79,125.29] y[-70.3,72.45], span=227.1deg -- sans rapport avec la vraie Irlande). Correction : CRS_OVERRIDES (code/r_catalog/build_sf_datasets.R) applique maintenant la definition PROJ4 reelle (+proj=utm +zone=30 +ellps=airy +units=km) et la reprojection en 4326 AVANT toute derivation geometrique. Nouvelle etendue verifiee x[-10.11,-6.27] y[52.27,54.73] : correspond exactement a l'etendue reelle de l'Irlande (POWO/geographie generale : environ -10.5 a -6 de longitude, 51.4 a 55.4 de latitude).
