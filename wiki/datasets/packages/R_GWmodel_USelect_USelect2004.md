---
title: R_GWmodel_USelect_USelect2004
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_GWmodel_USelect_USelect2004.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `GWmodel` (`USelect`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `winner`
- Candidate Y typology: categorical
- Candidate X variables: `unemploy`, `pctcoled`, `PEROVER65`, `pcturban`, `WHITE`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `winner` | `factor` | categorical | None | 0% |


> Selection Y/X (claude-sonnet-4-6) : Dans ce dataset sur les élections américaines, `winner` (parti/candidat vainqueur par comté) est la variable réponse naturelle à modéliser. Les cinq variables socio-démographiques (taux de chômage, niveau d'éducation, part des +65 ans, urbanisation, proportion de blancs) sont des covariables explicatives classiques des comportements électoraux.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `unemploy` | `numeric` | continuous | 0% |
| `pctcoled` | `numeric` | continuous | 0% |
| `PEROVER65` | `numeric` | continuous | 0% |
| `pcturban` | `numeric` | continuous | 0% |
| `WHITE` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE
- x_terms_pub: unemploy + pctcoled + PEROVER65 + pcturban + WHITE
- y_term_pub: winner
- Reference publication: Robinson, A. C. (2013) Geovisualization of the 2004 Presidential Election. Penn State / National Institutes of Health (web resource)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: article
- Methode d'estimation: GWR (regression logistique/discriminante geographiquement ponderee)
- Correspondance Python/R: aucune identifiee
- Note: Formule deja presente (enrichissement anterieur) ; source de type ressource web non publiee en revue, coherente avec les colonnes reelles.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_USelect_USelect2004`
- Dataset name: GWmodel::USelect
- Source family: r-package
- Source: package R `GWmodel`
- Source URL: https://CRAN.R-project.org/package=GWmodel
- Dataset DOI: none
- Publication DOI: pending
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "winner ~ unemploy + pctcoled + PEROVER65 + pcturban + WHITE"
  equation_family: geographically_weighted
  model_family: "GWR (regression logistique/discriminante geographiquement ponderee)"
  source_type: full_paper
  source_ref: "Robinson, A. C. (2013) Geovisualization of the 2004 Presidential Election. Penn State / National Institutes of Health (web resource)"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 3111
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-124.209, -67.5544], y [25.5386, 48.8643] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=GWmodel
- License open: yes
- Reproducibility status: available via package R `GWmodel`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `GWmodel`
