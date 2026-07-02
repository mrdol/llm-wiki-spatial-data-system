---
title: R_agridat_gartner.corn_gartner.corn
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_agridat_gartner.corn_gartner.corn.rds
tags: [dataset, r-package, spatial, point]
---

Yield monitor data from a corn field in Minnesota

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `mass`, `moist`
- Candidate Y typology: continuous
- Candidate X variables: `dist`, `elev`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `mass` | `numeric` | continuous | [0, 48.99] | 0% |
| `moist` | `numeric` | continuous | [14.9, 19.3] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Dans un yield monitor de maïs, 'mass' (masse récoltée) est la variable réponse principale (rendement), et 'moist' (humidité du grain) est une seconde cible agronomique d'intérêt. 'elev' (élévation topographique) et 'dist' (distance parcourue) sont des covariables spatiales explicatives pertinentes ; 'time' et 'T' semblent redondants (même plage), et 'seconds' a une variance quasi nulle (3-4s), rendant ces trois colonnes inutiles comme features.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `dist` | `integer` | count | 0% |
| `elev` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: yield~elevation
- x_terms_pub: elevation
- y_term_pub: yield
- Reference publication: Rakshit et al. (2020), Field Crops Research 255:107783

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: article
- Methode d'estimation: GWR
- Correspondance Python/R: aucune identifiee
- Note: n/a

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_gartner.corn_gartner.corn`
- Dataset name: agridat::gartner.corn
- Source family: r-package
- Source: package R `agridat` (version 1.26)
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
  existing_model_found: true
  equation_text: "yield~elevation"
  equation_family: geographically_weighted
  model_family: "GWR"
  source_type: full_paper
  source_ref: "Rakshit et al. (2020), Field Crops Research 255:107783"
  confidence: medium
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 4949
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

> **Correction metadonnees (Tache 2, juillet 2026)** — `time` est un horodatage GPS par point de mesure du moniteur de rendement (yield monitor), pas un axe temporel repete (confirme par wiki/datasets/r_package_docs/agridat/topics/gartner.corn.md : 'GPS time, in seconds', une seule campagne de recolte le 5 nov. 2011). T=N=4949 etait le signal de la meme erreur de profilage que sur home_sales/chicagoSDOH.
## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-93.9784, -93.9735], y [43.921, 43.9273] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: MIT + file LICENSE
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

> **Licence des donnees vs. licence du package (Tache 2)** — La licence ci-dessus (MIT + file LICENSE) couvre le code du package `agridat`. Les donnees elles-memes sont distribuees sous une licence distincte : "Used via license: Creative Commons BY-SA 3.0." (source: University of Minnesota Precision Agriculture Center, cf. wiki/datasets/r_package_docs/agridat/topics/gartner.corn.md).

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `agridat`
