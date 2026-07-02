---
title: Zenodo_18421412_mountainfire
type: dataset
created: 2026-06-30
updated: 2026-06-30
sources:
  - data/final_datasets/sf/Zenodo_18421412_mountainfire.gpkg
tags: [dataset, zenodo, warehouse, spatial, temporal, point]
---

Panel spatio-temporel de severite des feux dans 6 systemes montagneux mondiaux (Alpes occidentales, Andes centrales, Alpes australiennes, hauts-plateaux est-africains, Himalaya central, Rocheuses centrales), 2013-2023, base sur Landsat 8/9 et ERA5-Land. Etude de panel examinant l'influence de la temperature et des precipitations sur la severite des feux (source: README du depot Zenodo).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du GeoPackage)

- Candidate Y variables: `dNBR`, `burn_severity_class`, `burned_binary`, `nbr_anomaly_zscore`
- Candidate Y typology: continuous, count, binary
- Candidate X variables: `year`, `temp_mean_C`, `temp_max_C`, `temp_range_C`, `precip_season_mm`, `pet_season_mm`, `water_balance_mm`, `precip_antecedent_mm`, `swe_preseason_mm`, `elevation_m`, `slope_deg`, `northness`, `eastness`, `tpi_500m`, `heat_load_index`, `landcover_class`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `pixel_id`
- Variables inspected: yes (auto — ingest_zenodo_18421412_mountainfire.py)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `dNBR` | `float64` | continuous | [-0.8653, 7.2046] | 0.0% |
| `burn_severity_class` | `int64` | count | [0, 4] | 0.0% |
| `burned_binary` | `int64` | binary | {0, 1} | 0.0% |
| `nbr_anomaly_zscore` | `float64` | continuous | [-2.8483, 96.8010] | 0.0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont les mesures directes de sévérité/occurrence des feux dérivées de Landsat (dNBR, burn_severity_class, burned_binary, nbr_anomaly_zscore), qui constituent les cibles naturelles de l'étude ; NBR_observed et NBR_predicted sont écartés car redondants avec dNBR. Les X candidates regroupent les forçages climatiques saisonniers et antécédents (température, précipitations, PET, bilan hydrique, enneigement) ainsi que les descripteurs topographiques statiques (élévation, pente, exposition, TPI, HLI) et le couvert terrestre, conformément à l'objectif d'expliquer la sévérité des feux ; year est inclus pour capturer la tendance temporelle du panel. Les colonnes region, fire_season_start, harmonic_rmse, total_observations et modis_burned_reference sont ignorées car administratives, méthodologiques ou redondantes.

#### Detail X

| Variable | Classe | Role X | NA (%) |
|---|---|---|---|
| `year` | `int64` | count | 0.0% |
| `temp_mean_C` | `float64` | continuous | 0.0% |
| `temp_max_C` | `float64` | continuous | 0.0% |
| `temp_range_C` | `float64` | continuous | 0.0% |
| `precip_season_mm` | `float64` | continuous | 0.0% |
| `pet_season_mm` | `float64` | continuous | 0.0% |
| `water_balance_mm` | `float64` | continuous | 0.0% |
| `precip_antecedent_mm` | `float64` | continuous | 0.0% |
| `swe_preseason_mm` | `float64` | continuous | 0.0% |
| `elevation_m` | `int64` | count | 0.0% |
| `slope_deg` | `float64` | continuous | 0.0% |
| `northness` | `float64` | continuous | 0.0% |
| `eastness` | `float64` | continuous | 0.0% |
| `tpi_500m` | `float64` | continuous | 0.0% |
| `heat_load_index` | `float64` | rate | 0.0% |
| `landcover_class` | `int64` | count | 0.0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending (README enonce l'intention "panel regression analysis examining how temperature and precipitation influence fire severity" mais ne donne pas la formule R exacte testee)

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Zenodo_18421412_mountainfire`
- Dataset name: Climate-Fire Relationships Across Global Mountain Systems: A Six-Continent Analysis
- Source family: zenodo-warehouse
- Source: Zenodo
- Source URL: https://zenodo.org/records/18421412
- Dataset DOI: 10.5281/zenodo.18421412
- Publication DOI: pending
- Year: 2026

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): regression
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 21466
- T periods: 11
- Variable temporelle: year
- N/T profile: N_grand_T_grand

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation (grille systematique 500m, resolution Landsat native 30m)
- Temporal resolution: annual (fire-season aggregates)
- Spatial extent: x [-107.9998, 149.4999], y [-37.4081, 47.0016] (EPSG:4326)
- Time range: 2013-2023
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CC-BY-4.0
- License URL: https://zenodo.org/records/18421412
- License open: yes
- Reproducibility status: available via Zenodo (donnees + code Google Earth Engine)
- Code available: yes (SM_Code_S1_GEE_Analysis.js)
- Repository: zenodo-warehouse

## Quality Control

Aucune anomalie detectee (NA% nul sur toutes les variables inspectees).

## Related Pages

- [[quality_pedigree_schema_v1]]
- [[zenodo]]
