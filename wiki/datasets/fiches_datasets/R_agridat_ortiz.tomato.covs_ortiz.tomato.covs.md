---
title: R_agridat_ortiz.tomato.covs_ortiz.tomato.covs
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_agridat_ortiz.tomato.covs_ortiz.tomato.covs.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `agridat` (`ortiz.tomato.covs`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Day`, `T`
- Candidate Y typology: count
- Candidate X variables: `Dha`, `Driv`, `ExK`, `ExN`, `ExP`, `Irr`, `K`, `MeT`, `MnT`, `MxT`, `OM`, `P`, `pH`, `Prec`, `Trim`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `Lat`, `Long`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Day` | `integer` | count | [264, 1463] | 0% |
| `T` | `integer` | count | [264, 1463] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Dans un contexte agro-environnemental tomate, Day (durée en jours, e.g. jours à maturité) et T (température cumulée/somme thermique, plage identique à Day ce qui suggère une variable phénologique cible) sont les réponses plausibles ; les variables pédologiques (K, P, pH, OM, ExK, ExN, ExP), climatiques (MeT, MnT, MxT, Prec) et de gestion culturale (Irr, Trim, Driv, Dha) constituent les covariables explicatives naturelles. La colonne env (factor environnement) est ignorée car c'est un identifiant de site.

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


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: Day ~ Dha + Driv + ExK + ExN + ExP + Irr + K + MeT
- x_terms_used: Dha + Driv + ExK + ExN + ExP + Irr + K + MeT
- y_term_used: Day

### Formules candidates — niveau systeme

- formula_candidate_1: Day ~ Dha + Driv + ExK + ExN + ExP + Irr + K + MeT
- formula_candidate_2: Day ~ Dha + Driv + ExK + ExN

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_ortiz.tomato.covs_ortiz.tomato.covs`
- Dataset name: agridat::ortiz.tomato.covs
- Source family: r-package
- Source: package R `agridat`
- Source URL: https://CRAN.R-project.org/package=agridat
- Dataset DOI: none
- Publication DOI: pending
- Year: 2011

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 18
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [9.2, 89.3], y [2, 36.3] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `agridat`
