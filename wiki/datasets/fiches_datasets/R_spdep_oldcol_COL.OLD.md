---
title: R_spdep_oldcol_COL.OLD
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_spdep_oldcol_COL.OLD.rds
tags: [dataset, r-package, spatial, point]
---

Dataset spatial issu du package R `spdep` (`oldcol`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `CRIME`, `HOVAL`
- Candidate Y typology: continuous
- Candidate X variables: `INC`, `OPEN`, `PLUMB`, `DISCBD`, `AREA_PL`, `PERIMETER`, `NSA`, `NSB`, `EW`, `CP`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `POLYID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `CRIME` | `numeric` | continuous | [0.1783, 68.892] | 0% |
| `HOVAL` | `numeric` | continuous | [17.9, 96.4] | 0% |


> Selection Y/X (claude-sonnet-4-6) : CRIME (taux de criminalité) et HOVAL (valeur des logements) sont les deux variables réponses classiques du dataset Columbus, largement utilisées comme cibles dans la littérature de spatial ML. INC, OPEN, PLUMB, DISCBD, AREA_PL, PERIMETER et les indicatrices binaires (NSA, NSB, EW, CP) constituent des covariables socio-économiques et géographiques pertinentes ; COLUMBUS./COLUMBUS.I/NEIG/NEIGNO sont des identifiants redondants, THOUS est une constante (1000 partout), et PERIM est un doublon exact de PERIMETER — tous ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `INC` | `numeric` | continuous | 0% |
| `OPEN` | `numeric` | continuous | 0% |
| `PLUMB` | `numeric` | continuous | 0% |
| `DISCBD` | `numeric` | continuous | 0% |
| `AREA_PL` | `numeric` | rate | 0% |
| `PERIMETER` | `numeric` | continuous | 0% |
| `NSA` | `numeric` | binary | 0% |
| `NSB` | `numeric` | binary | 0% |
| `EW` | `numeric` | binary | 0% |
| `CP` | `numeric` | binary | 0% |


### Formule — niveau publication

- formula_pub: CRIME ~ HOVAL + INC
- x_terms_pub: HOVAL, INC
- y_term_pub: CRIME
- Reference publication: Anselin, Luc (1988) Spatial Econometrics: Methods and Models. Dordrecht: Kluwer Academic, Table 12.1, p. 189.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: Python_geodatasets_spdata.columbus
- Note: n/a

### Formule — niveau systeme

- formula_used: CRIME ~ HOVAL + INC
- x_terms_used: HOVAL + INC
- y_term_used: CRIME

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spdep_oldcol_COL.OLD`
- Dataset name: spdep::oldcol
- Source family: r-package
- Source: package R `spdep`
- Source URL: https://CRAN.R-project.org/package=spdep
- Dataset DOI: none
- Publication DOI: pending
- Year: 2002

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "CRIME ~ HOVAL + INC"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Anselin, Luc (1988) Spatial Econometrics: Methods and Models. Dordrecht: Kluwer Academic, Table 12.1, p. 189."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 49
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [24.25, 51.24], y [24.96, 44.07] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL (>= 2)
- License URL: https://CRAN.R-project.org/package=spdep
- License open: yes
- Reproducibility status: available via package R `spdep`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `spdep`
