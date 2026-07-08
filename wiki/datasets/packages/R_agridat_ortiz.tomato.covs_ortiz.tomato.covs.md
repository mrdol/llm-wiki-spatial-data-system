---
title: R_agridat_ortiz.tomato.covs_ortiz.tomato.covs
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_agridat_ortiz.tomato.covs_ortiz.tomato.covs.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `agridat` (`ortiz.tomato.covs`).

## Bloc 1 â€” Formule et variables

### Variables (niveau systeme â€” inspection directe du sf)

- Candidate Y variables: `Day`, `T`
- Candidate Y typology: count
- Candidate X variables: `Dha`, `Driv`, `ExK`, `ExN`, `ExP`, `Irr`, `K`, `MeT`, `MnT`, `MxT`, `OM`, `P`, `pH`, `Prec`, `Trim`
- Candidate X typology: continuous, categorical
- Coordinates (x, y â€” excluded from X candidates): `Lat`, `Long`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto â€” export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Day` | `integer` | count | [264, 1463] | 0% |
| `T` | `integer` | count | [264, 1463] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Dans un contexte agro-environnemental tomate, Day (durÃ©e en jours, e.g. jours Ã  maturitÃ©) et T (tempÃ©rature cumulÃ©e/somme thermique, plage identique Ã  Day ce qui suggÃ¨re une variable phÃ©nologique cible) sont les rÃ©ponses plausibles ; les variables pÃ©dologiques (K, P, pH, OM, ExK, ExN, ExP), climatiques (MeT, MnT, MxT, Prec) et de gestion culturale (Irr, Trim, Driv, Dha) constituent les covariables explicatives naturelles. La colonne env (factor environnement) est ignorÃ©e car c'est un identifiant de site.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Dha` | `integer` | count | 0% |
| `Driv` | `integer` | binary | 0% |
| `ExK` | `integer` | count | 0% |
| `ExN` | `integer` | count | 0% |
| `ExP` | `integer` | count | 0% |
| `Irr` | `integer` | binary | 0% |
| `K` | `numeric` | continuous | 0% |
| `MeT` | `integer` | count | 0% |
| `MnT` | `integer` | count | 0% |
| `MxT` | `integer` | count | 0% |
| `OM` | `numeric` | continuous | 0% |
| `P` | `integer` | count | 0% |
| `pH` | `integer` | count | 0% |
| `Prec` | `integer` | count | 0% |
| `Trim` | `integer` | binary | 0% |


### Formule â€” niveau publication

- formula_pub: env*gen~env*cov
- x_terms_pub: env*cov
- y_term_pub: env*gen
- Reference publication: cran.r-project.org/web/packages/agridat/agridat.pdf (catalogue officiel)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: PLS
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule â€” niveau systeme

- formula_used: env*gen~env*cov
- x_terms_used: env*cov
- y_term_used: env*gen
## Bloc 2 â€” Identification et DOI

- Dataset ID: `R_agridat_ortiz.tomato.covs_ortiz.tomato.covs`
- Dataset name: agridat::ortiz.tomato.covs
- Source family: r-package
- Source: package R `agridat`
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2011

## Bloc 3 â€” Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "env*gen~env*cov"
  equation_family: unknown
  model_family: "PLS"
  source_type: software_documentation
  source_ref: "cran.r-project.org/web/packages/agridat/agridat.pdf (catalogue officiel)"
  confidence: high
```

## Bloc 4 â€” Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 18
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 â€” Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [9.2, 89.3], y [2, 36.3] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending â€” CRS source non geographique ou inconnu

## Bloc 6 â€” Reproductibilite

- License present: yes
- License name: MIT + file LICENSE
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent â€” lookup EPSG necessaire.

## Related Pages

- Source: package R `agridat`
