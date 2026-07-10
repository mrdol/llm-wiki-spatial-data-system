---
title: R_ade4_irishdata_irishdata
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_ade4_irishdata_irishdata.rds
tags: [dataset, r-package, spatial, point]
---

This data set contains geographical informations about 25 counties of Ireland.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `sales`, `car`, `radio`
- Candidate Y typology: continuous
- Candidate X variables: `T0.10`, `T10.50`, `Tup50`, `cow`, `other`, `pig`, `sheep`, `town.pop`, `single.man`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `sales` | `numeric` | continuous | [28, 78] | 0% |
| `car` | `numeric` | continuous | [17, 49] | 0% |
| `radio` | `numeric` | continuous | [56, 200] | 0% |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Les variables 'sales', 'car' et 'radio' représentent des indicateurs socio-économiques de résultat (ventes, taux de possession de voitures, d'équipements radio) typiquement modélisés comme variables réponses dans des analyses spatiales irlandaises. Les variables de structure foncière/agricole (T0.10, T10.50, Tup50 = tailles de fermes, cow, pig, sheep, other = cheptels), démographiques (town.pop, single.man) constituent des covariables explicatives naturelles du contexte territorial des comtés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `T0.10` | `numeric` | continuous | 0% |
| `T10.50` | `numeric` | continuous | 0% |
| `Tup50` | `numeric` | continuous | 0% |
| `cow` | `numeric` | continuous | 0% |
| `other` | `numeric` | continuous | 0% |
| `pig` | `numeric` | continuous | 0% |
| `sheep` | `numeric` | continuous | 0% |
| `town.pop` | `numeric` | continuous | 0% |
| `single.man` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: sales~cow+other+pig+sheep+T0.10+T10.50+Tup50+town.pop
- x_terms_pub: cow+other+pig+sheep+T0.10+T10.50+Tup50+town.pop
- y_term_pub: sales
- Reference publication: Analogie structurelle avec R_agridat_wallace.iowaland_wallace.iowaland (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Contrairement aux autres jeux ade4 (ordination multivariee sans cible unique), irishdata a une cible Y claire (ventes/consommation par comte) et des covariables socioeconomiques/agricoles explicites (tranches de revenu, cheptel, population urbaine) -- structure comparable a wallace.iowaland (bon candidat, valeur economique rurale ~ composition agricole).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_ade4_irishdata_irishdata`
- Dataset name: ade4::irishdata
- Source family: r-package
- Source: package R `ade4` (version 1.7.24)
- Source URL: https://CRAN.R-project.org/package=ade4
- Dataset DOI: none
- Publication DOI: pending
- Year: 2002

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "sales~cow+other+pig+sheep+T0.10+T10.50+Tup50+town.pop"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec R_agridat_wallace.iowaland_wallace.iowaland (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 25
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [38.75, 191.6667], y [29.5, 237.5] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=ade4
- License open: yes
- Reproducibility status: available via package R `ade4`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `ade4`
