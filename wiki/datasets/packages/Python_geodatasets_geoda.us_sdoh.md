---
title: Python_geodatasets_geoda.us_sdoh
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.us_sdoh.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`us_sdoh`).

## Bloc 1 â€” Formule et variables

### Variables (niveau systeme â€” inspection directe du sf)

- Candidate Y variables: `SDOH_CL`, `ep_pov`, `ep_unin`, `ep_unem`
- Candidate Y typology: count, continuous
- Candidate X variables: `ep_pci`, `ep_nohs`, `ep_sngp`, `ep_lime`, `ep_crow`, `ep_nove`, `rntov30p_1`, `ep_minrty`, `ep_age65`, `ep_age17`, `ep_disabl`, `X1_SES`, `X2_MOB`, `X3_URB`, `X4_MICA`
- Candidate X typology: continuous
- Coordinates (x, y â€” excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto â€” export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `SDOH_CL` | `integer` | count | [1, 7] | 0% |
| `ep_pov` | `numeric` | continuous | [0, 100] | 0% |
| `ep_unin` | `numeric` | continuous | [0, 100] | 0% |
| `ep_unem` | `numeric` | continuous | [0, 100] | 0% |


> Selection Y/X (claude-sonnet-4-6) : SDOH_CL (cluster de dÃ©terminants sociaux de santÃ©) est la cible synthÃ©tique naturelle du dataset ; ep_pov, ep_unem et ep_unin sont des indicateurs de vulnÃ©rabilitÃ© sociale frÃ©quemment modÃ©lisÃ©s comme variables rÃ©ponse. Les variables ep_* restantes (capital humain, dÃ©mographie, logement) ainsi que les composantes factorielles X1â€“X4 constituent des covariables explicatives pertinentes ; les colonnes FIPS/codes gÃ©ographiques sont ignorÃ©es car purement administratives.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ep_pci` | `numeric` | continuous | 0% |
| `ep_nohs` | `numeric` | continuous | 0% |
| `ep_sngp` | `numeric` | continuous | 0% |
| `ep_lime` | `numeric` | continuous | 0% |
| `ep_crow` | `numeric` | continuous | 0% |
| `ep_nove` | `numeric` | continuous | 0% |
| `rntov30p_1` | `numeric` | continuous | 0% |
| `ep_minrty` | `numeric` | continuous | 0% |
| `ep_age65` | `numeric` | continuous | 0% |
| `ep_age17` | `numeric` | continuous | 0% |
| `ep_disabl` | `numeric` | continuous | 0% |
| `X1_SES` | `numeric` | continuous | 0% |
| `X2_MOB` | `numeric` | continuous | 0% |
| `X3_URB` | `numeric` | continuous | 0% |
| `X4_MICA` | `numeric` | continuous | 0% |


### Formule â€” niveau publication

- formula_pub: YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime(+W*YPLL)
- x_terms_pub: Advantage+Mobility+Opportunity+MICA+Violent_crime(+W*YPLL)
- y_term_pub: YPLL
- Reference publication: Kolak et al. (2020), DOI:10.1001/jamanetworkopen.2019.19928

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS/SAR
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule â€” niveau systeme

- formula_used: YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime(+W*YPLL)
- x_terms_used: Advantage+Mobility+Opportunity+MICA+Violent_crime(+W*YPLL)
- y_term_used: YPLL
## Bloc 2 â€” Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.us_sdoh`
- Dataset name: geodatasets::us_sdoh
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

## Bloc 3 â€” Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "YPLL~Advantage+Mobility+Opportunity+MICA+Violent_crime(+W*YPLL)"
  equation_family: spatial_lag
  model_family: "OLS/SAR"
  source_type: software_documentation
  source_ref: "Kolak et al. (2020), DOI:10.1001/jamanetworkopen.2019.19928"
  confidence: high
```

## Bloc 4 â€” Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 71901
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 â€” Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.6106, -67.0143], y [24.5494, 48.987] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: pending â€” multi-zones (span=57.6deg) -- projection nationale recommandee

## Bloc 6 â€” Reproductibilite

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
