---
title: Python_geodatasets_geoda.phoenix_acs
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.phoenix_acs.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`phoenix_acs`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `inc`, `pop_dens`, `renter_rt`, `vac_hsu_rt`
- Candidate Y typology: continuous
- Candidate X variables: `ALAND10`, `AWATER10`, `pop`, `white_rt`, `black_rt`, `hisp_rt`, `fem_nh_rt`, `hsu`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `inc` | `numeric` | continuous | [1492, 111744] | 0% |
| `pop_dens` | `numeric` | continuous | [0.0047, 904.6753] | 0% |
| `renter_rt` | `numeric` | continuous | [0, 53.9407] | 0% |
| `vac_hsu_rt` | `numeric` | continuous | [0, 70.1965] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables socio-économiques et de marché du logement (revenu médian, densité de population, taux de locataires, taux de vacance) constituent des cibles naturelles pour des modèles prédictifs spatiaux. Les caractéristiques physiques du territoire (surfaces), démographiques (population totale, composition ethnique/raciale, part des femmes hors hispanique) et le stock de logements servent de covariables explicatives ; les colonnes d'erreur de mesure (inc_error, pct_error, l_pct_err) et les identifiants/libellés géographiques (GEOID10, NAMELSAD10) sont écartés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ALAND10` | `numeric` | continuous | 0% |
| `AWATER10` | `numeric` | continuous | 0% |
| `pop` | `numeric` | continuous | 0% |
| `white_rt` | `numeric` | continuous | 0% |
| `black_rt` | `numeric` | continuous | 0% |
| `hisp_rt` | `numeric` | continuous | 0% |
| `fem_nh_rt` | `numeric` | continuous | 0% |
| `hsu` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: inc~white_rt+black_rt+hisp_rt+pop_dens+fem_nh_rt
- x_terms_pub: white_rt+black_rt+hisp_rt+pop_dens+fem_nh_rt
- y_term_pub: inc
- Reference publication: Analogie structurelle avec geoda.us_sdoh / geoda.police (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.police (POL~TAX+TRANS+INC+CRIME+UNEMP+OWNER+COLLEGE+WHITE+OUT) et geoda.us_sdoh : taux de chomage/pauvrete au niveau secteur explique par la composition demographique, educative et raciale -- domaine substantiellement identique (indicateur socioeconomique explique par composition de quartier).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.phoenix_acs`
- Dataset name: geodatasets::phoenix_acs
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
  equation_text: "inc~white_rt+black_rt+hisp_rt+pop_dens+fem_nh_rt"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec geoda.us_sdoh / geoda.police (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 985
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-113.1163, -110.5784], y [32.5242, 33.9764] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32612 (UTM Zone 12N (EPSG:32612)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
