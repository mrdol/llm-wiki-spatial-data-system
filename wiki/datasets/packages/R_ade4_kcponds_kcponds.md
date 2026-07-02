---
title: R_ade4_kcponds_kcponds
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_ade4_kcponds_kcponds.rds
tags: [dataset, r-package, spatial, point]
---

This data set contains informations about 33 ponds in De Maten reserve (Genk, Belgium).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `chla`, `divMI`, `denMI`, `O2`, `secchi`
- Candidate Y typology: count, continuous
- Candidate X variables: `depth`, `area`, `cond`, `pH`, `Fe`, `N`, `TP`, `EM`, `FM`, `SM`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `chla` | `integer` | count | [8, 301] | 0% |
| `divMI` | `numeric` | continuous | [1, 7.6] | 0% |
| `denMI` | `integer` | count | [1, 110] | 0% |
| `O2` | `numeric` | continuous | [2.6, 9.6] | 0% |
| `secchi` | `integer` | count | [20, 100] | 0% |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Les variables biologiques et écologiques intégratrices (chlorophylle a, diversité et densité des macroinvertébrés, oxygène dissous, transparence Secchi) sont des réponses typiques de l'état trophique ou écologique des étangs. Les variables physico-chimiques (profondeur, superficie, conductivité, pH, fer, azote, phosphore total) ainsi que les métriques de végétation (EM, FM, SM) constituent des covariables explicatives de ces réponses.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `depth` | `integer` | count | 0% |
| `area` | `numeric` | continuous | 0% |
| `cond` | `integer` | count | 0% |
| `pH` | `numeric` | continuous | 0% |
| `Fe` | `numeric` | continuous | 0% |
| `N` | `integer` | count | 0% |
| `TP` | `integer` | count | 0% |
| `EM` | `integer` | count | 0% |
| `FM` | `integer` | count | 0% |
| `SM` | `integer` | count | 0% |


### Formule — niveau publication

- formula_pub: none (aucune regression canonique documentee -- recherche manuelle exhaustive menee)
- x_terms_pub: none
- y_term_pub: none
- Reference publication: none (aucune source verifiable retrouvee)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: mauvais candidat
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Package ade4 = ordination multivariee (ACP/RDA/CCA) ; structure de donnees confirmee a 5 reprises independantes (doubs/avijons/oribatid/mafragh/jv73) comme non adaptee a une regression canonique a variable dependante unique. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Regression limnologique plausible en interne (chla~TP notamment) mais aucun bon candidat de la banque ne couvre les ecosystemes lacustres/etangs -- analogie externe jugee trop faible sans reference comparable dans la banque.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_ade4_kcponds_kcponds`
- Dataset name: ade4::kcponds
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
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "unknown"
  source_type: unknown
  source_ref: "null"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 33
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [50.3, 961.65], y [121.8212, 359.6003] (CRS unknown)
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
