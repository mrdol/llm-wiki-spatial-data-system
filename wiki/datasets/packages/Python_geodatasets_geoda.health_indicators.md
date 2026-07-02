---
title: Python_geodatasets_geoda.health_indicators
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.health_indicators.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`health_indicators`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Infan_Rate`, `TeenB_Rate`, `BirthRate`, `Cance_ites`, `Diabe_ated`, `LungCancer`, `Strok_ease`, `Assau_cide`, `Tuber_osis`, `Child_ning`
- Candidate Y typology: continuous
- Candidate X variables: `Below_evel`, `Unemp_ment`, `NoHig_loma`, `PerCa_come`, `Dependency`, `Crowd_sing`, `Prena_ster`, `Prete_rths`, `LowBi_ight`, `Gener_Rate`, `shape_area`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Infan_Rate` | `numeric` | continuous | [1.5, 22.6] | 0% |
| `TeenB_Rate` | `numeric` | continuous | [1.3, 116.9] | 0% |
| `BirthRate` | `numeric` | continuous | [9.4, 22.4] | 0% |
| `Cance_ites` | `numeric` | continuous | [120.1, 291.5] | 0% |
| `Diabe_ated` | `numeric` | continuous | [26.8, 119.1] | 0% |
| `LungCancer` | `numeric` | continuous | [15.9, 89.6] | 0% |
| `Strok_ease` | `numeric` | continuous | [22, 99.1] | 0% |
| `Assau_cide` | `numeric` | continuous | [0, 70.3] | 0% |
| `Tuber_osis` | `numeric` | continuous | [0, 22.7] | 0% |
| `Child_ning` | `numeric` | continuous | [0, 605.9] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des taux de mortalité, morbidité ou comportements de santé (mortalité infantile, cancer, diabète, violence, etc.) typiquement modélisés comme outcomes dans les études d'épidémiologie spatiale. Les variables X candidates sont des déterminants socio-économiques (pauvreté, chômage, revenu, éducation, dépendance, surpeuplement) et des indicateurs de santé maternelle/périnatale qui servent classiquement de covariables explicatives ; les colonnes purement administratives (area_num, comm_area) et les doublons apparents (Gonor_ales/Gono_les_1, Chil_ing_1, Firea_ated, Breas_ales, Color_ncer, Prost_ales) sont écartés ou relégués selon le contexte.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Below_evel` | `numeric` | continuous | 0% |
| `Unemp_ment` | `numeric` | continuous | 0% |
| `NoHig_loma` | `numeric` | continuous | 0% |
| `PerCa_come` | `integer` | count | 0% |
| `Dependency` | `numeric` | continuous | 0% |
| `Crowd_sing` | `numeric` | continuous | 0% |
| `Prena_ster` | `integer` | count | 0% |
| `Prete_rths` | `numeric` | continuous | 0% |
| `LowBi_ight` | `integer` | count | 0% |
| `Gener_Rate` | `integer` | count | 0% |
| `shape_area` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: LungCancer~Below_evel+Unemp_ment+NoHig_loma+PerCa_come+Dependency+Crowd_sing
- x_terms_pub: Below_evel+Unemp_ment+NoHig_loma+PerCa_come+Dependency+Crowd_sing
- y_term_pub: LungCancer
- Reference publication: Analogie structurelle avec geoda.us_sdoh (SDOH) (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS/GWR
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.us_sdoh (bon candidat, YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime) : indicateur de sante publique au niveau secteur explique par des determinants sociaux (pauvrete, education, chomage, revenu), domaine substantiellement identique (sante publique et determinants sociaux). 

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.health_indicators`
- Dataset name: geodatasets::health_indicators
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
  equation_text: "LungCancer~Below_evel+Unemp_ment+NoHig_loma+PerCa_come+Dependency+Crowd_sing"
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
