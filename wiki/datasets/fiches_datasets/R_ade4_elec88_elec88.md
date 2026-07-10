---
title: R_ade4_elec88_elec88
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_ade4_elec88_elec88.rds
tags: [dataset, r-package, spatial, point]
---

This data set gives the results of the presidential election in France in 1988 for each department and all the candidates.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Mitterand`, `Le.Pen`
- Candidate Y typology: continuous
- Candidate X variables: `Chirac`, `Barre`, `Lajoinie`, `Waechter`, `Juquin`, `Laguillier`, `Boussel`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Mitterand` | `numeric` | continuous | [24.4, 44.5] | 0% |
| `Le.Pen` | `numeric` | continuous | [5.9, 26.4] | 0% |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Dans un contexte de spatial ML sur des résultats électoraux, les scores de Mitterand (vainqueur, 1er tour) et Le.Pen (candidat à forte dimension spatiale bien documentée) sont les cibles les plus pertinentes à modéliser. Les scores des autres candidats servent de covariables explicatives capturant la structure politique locale de chaque département.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `Chirac` | `numeric` | continuous | 0% |
| `Barre` | `numeric` | continuous | 0% |
| `Lajoinie` | `numeric` | continuous | 0% |
| `Waechter` | `numeric` | continuous | 0% |
| `Juquin` | `numeric` | continuous | 0% |
| `Laguillier` | `numeric` | continuous | 0% |
| `Boussel` | `numeric` | rate | 0% |


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
- Note: Package ade4 = ordination multivariee (ACP/RDA/CCA) ; structure de donnees confirmee a 5 reprises independantes (doubs/avijons/oribatid/mafragh/jv73) comme non adaptee a une regression canonique a variable dependante unique. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Parts de vote par candidat (Mitterand/Le Pen en Y, autres candidats en X) -- donnees compositionnelles sommant a 100%, colinearite structurelle qui invalide une regression covariable classique.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_ade4_elec88_elec88`
- Dataset name: ade4::elec88
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
- N observations: 94
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [125766.738, 983954.9249], y [1732913.6375, 2610853.4112] (CRS unknown)
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
