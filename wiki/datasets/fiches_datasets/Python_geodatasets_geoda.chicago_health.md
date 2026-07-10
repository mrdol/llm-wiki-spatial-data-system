---
title: Python_geodatasets_geoda.chicago_health
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.chicago_health.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`chicago_health`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `BirthRate`, `LoBirthR`, `PretBrth`, `TeenBirth`, `InfntMR`, `Assault`, `FirearmM`, `CancerAll`, `LungCancer`, `DiabetM`, `Stroke`, `BrstCancr`, `Colorect`, `ProstateC`, `ChlBLLS`, `GonorrF`, `GonorrM`, `Tuberc`, `VlntCrRt`, `PropCrRt`, `COIave`, `HISave`, `SESave`
- Candidate Y typology: continuous, count, rate
- Candidate X variables: `Pop2014`, `PopChng`, `PopMP`, `PopFP`, `Under5P`, `Under18P`, `Over65P`, `Wht14P`, `Blk14P`, `AS14P`, `Hisp14P`, `Oth14P`, `AI14P`, `NHP14P`, `PerCInc14`, `Pov14`, `field_37`, `ChldPov14`, `Pov50P`, `Pov125P`, `Pov150P`, `Pov185P`, `Pov200P`, `NoHS14`, `HSGrad14`, `SmClg14`, `ClgGrad14`, `Unemp14`, `LaborFrc`, `Hlitave`, `FertRate`, `PrenScrn`, `shape_area`, `TRACTCnt`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `ComAreaID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `BirthRate` | `numeric` | continuous | [9.4, 22.4] | 0% |
| `LoBirthR` | `integer` | count | [3, 19] | 0% |
| `PretBrth` | `numeric` | continuous | [5, 17.5] | 0% |
| `TeenBirth` | `numeric` | continuous | [1.3, 116.9] | 0% |
| `InfntMR` | `numeric` | continuous | [1.5, 22.6] | 0% |
| `Assault` | `numeric` | continuous | [0, 70.3] | 0% |
| `FirearmM` | `numeric` | continuous | [1, 70.3] | 0% |
| `CancerAll` | `numeric` | continuous | [120.1, 291.5] | 0% |
| `LungCancer` | `numeric` | continuous | [15.9, 89.6] | 0% |
| `DiabetM` | `numeric` | continuous | [26.8, 119.1] | 0% |
| `Stroke` | `numeric` | continuous | [22, 99.1] | 0% |
| `BrstCancr` | `numeric` | continuous | [7.6, 54.7] | 0% |
| `Colorect` | `numeric` | continuous | [8.6, 39.4] | 0% |
| `ProstateC` | `numeric` | continuous | [0, 92.9] | 0% |
| `ChlBLLS` | `numeric` | continuous | [0, 605.9] | 0% |
| `GonorrF` | `numeric` | continuous | [0, 3193.3] | 0% |
| `GonorrM` | `numeric` | continuous | [0, 2545.7] | 0% |
| `Tuberc` | `numeric` | continuous | [0, 22.7] | 0% |
| `VlntCrRt` | `numeric` | rate | [0.0042, 0.0979] | 0% |
| `PropCrRt` | `numeric` | rate | [0.0059, 0.1355] | 0% |
| `COIave` | `numeric` | continuous | [-1.3459, 0.7586] | 0% |
| `HISave` | `numeric` | continuous | [17.9579, 64.1595] | 0% |
| `SESave` | `numeric` | continuous | [30.6037, 64.4447] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les colonnes Y candidates regroupent les indicateurs de santé publique (mortalité, morbidité, taux de naissance, maladies, crimes violents) qui sont des résultats à expliquer/prédire dans un contexte de santé communautaire. Les colonnes X candidates couvrent les déterminants sociaux, démographiques, économiques et éducatifs qui servent classiquement de covariables explicatives ; les colonnes de comptages bruts redondants avec leurs équivalents en pourcentage/taux ont été prioritairement remplacés par ces derniers, et les libellés géographiques purement administratifs (community) ont été ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Pop2014` | `integer` | count | 0% |
| `PopChng` | `numeric` | continuous | 0% |
| `PopMP` | `numeric` | continuous | 0% |
| `PopFP` | `numeric` | continuous | 0% |
| `Under5P` | `numeric` | continuous | 0% |
| `Under18P` | `numeric` | continuous | 0% |
| `Over65P` | `numeric` | continuous | 0% |
| `Wht14P` | `numeric` | continuous | 0% |
| `Blk14P` | `numeric` | continuous | 0% |
| `AS14P` | `numeric` | continuous | 0% |
| `Hisp14P` | `numeric` | continuous | 0% |
| `Oth14P` | `numeric` | continuous | 0% |
| `AI14P` | `numeric` | continuous | 0% |
| `NHP14P` | `numeric` | rate | 0% |
| `PerCInc14` | `integer` | count | 0% |
| `Pov14` | `integer` | count | 0% |
| `field_37` | `numeric` | continuous | 0% |
| `ChldPov14` | `integer` | count | 0% |
| `Pov50P` | `numeric` | continuous | 0% |
| `Pov125P` | `numeric` | continuous | 0% |
| `Pov150P` | `numeric` | continuous | 0% |
| `Pov185P` | `numeric` | continuous | 0% |
| `Pov200P` | `numeric` | continuous | 0% |
| `NoHS14` | `integer` | count | 0% |
| `HSGrad14` | `integer` | count | 0% |
| `SmClg14` | `integer` | count | 0% |
| `ClgGrad14` | `integer` | count | 0% |
| `Unemp14` | `integer` | count | 0% |
| `LaborFrc` | `integer` | count | 0% |
| `Hlitave` | `numeric` | continuous | 0% |
| `FertRate` | `integer` | count | 0% |
| `PrenScrn` | `integer` | count | 0% |
| `shape_area` | `numeric` | continuous | 0% |
| `TRACTCnt` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: LungCancer~PerCInc14+Pov14+NoHS14+Unemp14+VlntCrRt
- x_terms_pub: PerCInc14+Pov14+NoHS14+Unemp14+VlntCrRt
- y_term_pub: LungCancer
- Reference publication: Analogie structurelle avec geoda.us_sdoh (SDOH) (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS/GWR
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.us_sdoh (bon candidat, YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime) : indicateur de sante publique au niveau secteur explique par des determinants sociaux (pauvrete, education, chomage, revenu), domaine substantiellement identique (sante publique et determinants sociaux). Meme ville (Chicago) que us_sdoh.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.chicago_health`
- Dataset name: geodatasets::chicago_health
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
  equation_text: "LungCancer~PerCInc14+Pov14+NoHS14+Unemp14+VlntCrRt"
  equation_family: geographically_weighted
  model_family: "OLS/GWR"
  source_type: unknown
  source_ref: "Analogie structurelle avec geoda.us_sdoh (SDOH) (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 77
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-87.9047, -87.535], y [41.6655, 42.0105] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32616 (UTM Zone 16N (EPSG:32616)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package Python `geodatasets`
