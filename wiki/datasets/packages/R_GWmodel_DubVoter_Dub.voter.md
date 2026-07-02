---
title: R_GWmodel_DubVoter_Dub.voter
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_GWmodel_DubVoter_Dub.voter.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `GWmodel` (`DubVoter`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `GenEl2004`
- Candidate Y typology: continuous
- Candidate X variables: `DiffAdd`, `LARent`, `SC1`, `Unempl`, `LowEduc`, `Age18_24`, `Age25_44`, `Age45_64`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `DED_ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `GenEl2004` | `numeric` | continuous | [27.9846, 72.9142] | 0% |


> Selection Y/X (claude-sonnet-4-6) : GenEl2004 représente le taux de participation (ou résultat) aux élections générales de 2004, variable de sortie typique des études de comportement électoral spatial. Les autres colonnes (mobilité résidentielle, location sociale, statut socio-économique, chômage, faible niveau d'éducation, tranches d'âge) sont des covariables socio-démographiques classiquement utilisées pour expliquer les variations spatiales du vote.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `DiffAdd` | `numeric` | continuous | 0% |
| `LARent` | `numeric` | continuous | 0% |
| `SC1` | `numeric` | continuous | 0% |
| `Unempl` | `numeric` | continuous | 0% |
| `LowEduc` | `numeric` | continuous | 0% |
| `Age18_24` | `numeric` | continuous | 0% |
| `Age25_44` | `numeric` | continuous | 0% |
| `Age45_64` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64
- x_terms_pub: DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64
- y_term_pub: GenEl2004
- Reference publication: Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GWR
- Correspondance Python/R: aucune identifiee
- Note: Formule deja presente (enrichissement anterieur enrich_web.py) et confirmee coherente avec les colonnes reelles du dataset ; jeu de donnees GWmodel classique (turnout electoral Dublin).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_GWmodel_DubVoter_Dub.voter`
- Dataset name: GWmodel::DubVoter
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
  equation_text: "GenEl2004~DiffAdd+LARent+SC1+Unempl+LowEduc+Age18_24+Age25_44+Age45_64"
  equation_family: geographically_weighted
  model_family: "GWR"
  source_type: software_documentation
  source_ref: "Kavanagh A (2006) Turnout or turned off? Electoral participation in Dublin in the early 21st Century. Journal of Irish Urban Studies, 3(2):1-24"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 322
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [300888.224, 328236.4395], y [220662.3518, 263404.7994] (CRS unknown)
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
