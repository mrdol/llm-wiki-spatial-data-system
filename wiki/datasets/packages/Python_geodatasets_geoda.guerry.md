---
title: Python_geodatasets_geoda.guerry
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.guerry.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`guerry`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Crm_prs`, `Crm_prp`, `Litercy`, `Suicids`, `Lottery`, `Infants`
- Candidate Y typology: continuous
- Candidate X variables: `Wealth`, `Commerc`, `Clergy`, `Donatns`, `Prsttts`, `Distanc`, `Area`, `Pop1831`, `Desertn`, `Instrct`, `MainCty`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Crm_prs` | `numeric` | continuous | [5883, 37014] | 0% |
| `Crm_prp` | `numeric` | continuous | [1368, 20235] | 0% |
| `Litercy` | `numeric` | continuous | [12, 74] | 0% |
| `Suicids` | `numeric` | continuous | [3460, 163241] | 0% |
| `Lottery` | `numeric` | continuous | [1, 86] | 0% |
| `Infants` | `numeric` | continuous | [2660, 62486] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des outcomes sociaux mesurés (criminalité, suicide, illettrisme, infanticide, jeux de loterie) typiquement modélisés dans la littérature Guerry comme variables réponse. Les variables X candidates sont des indicateurs structurels, économiques ou démographiques (richesse, commerce, clergé, dons, prostitution, distance, superficie, population, désertion, instruction, type de ville) servant de covariables explicatives ; les colonnes purement administratives ou géographiques (dept, Region, Dprtmnt) et les doublons en rang (Crm_prn, Infntcd, Dntn_cl) sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Wealth` | `numeric` | continuous | 0% |
| `Commerc` | `numeric` | continuous | 0% |
| `Clergy` | `numeric` | continuous | 0% |
| `Donatns` | `numeric` | continuous | 0% |
| `Prsttts` | `numeric` | continuous | 0% |
| `Distanc` | `numeric` | continuous | 0% |
| `Area` | `numeric` | continuous | 0% |
| `Pop1831` | `numeric` | continuous | 0% |
| `Desertn` | `numeric` | continuous | 0% |
| `Instrct` | `numeric` | continuous | 0% |
| `MainCty` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: Crime_pers ~ Region+Literacy+Donations+Infants+Suicides
- x_terms_pub: Region+Literacy+Donations+Infants+Suicides
- y_term_pub: Crime_pers
- Reference publication: cran.r-project.org/web/packages/Guerry/vignettes/guerry-multivariate.html

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.guerry`
- Dataset name: geodatasets::guerry
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
  equation_text: "Crime_pers ~ Region+Literacy+Donations+Infants+Suicides"
  equation_family: linear
  model_family: "OLS"
  source_type: software_documentation
  source_ref: "cran.r-project.org/web/packages/Guerry/vignettes/guerry-multivariate.html"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 85
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-3.8198, 7.5352], y [42.6247, 50.5342] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32631 (UTM Zone 31N (EPSG:32631)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
