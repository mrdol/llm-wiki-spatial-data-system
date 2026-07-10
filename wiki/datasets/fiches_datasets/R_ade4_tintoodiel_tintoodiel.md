---
title: R_ade4_tintoodiel_tintoodiel
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_ade4_tintoodiel_tintoodiel.rds
tags: [dataset, r-package, spatial, point]
---

This data set contains informations about geochemical characteristics of heavy metal pollution in surface sediments of the Tinto and Odiel river estuary (south-western Spain).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Cu`, `Zn`, `Pb`, `Fe2O3`
- Candidate Y typology: continuous
- Candidate X variables: `SiO2`, `Al2O3`, `CaO`, `MgO`, `Na2`, `K2O`, `MnO`, `TiO2`, `P2O5`, `LOI`, `mud`, `Ba`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Cu` | `numeric` | continuous | [1.02, 946] | 0% |
| `Zn` | `numeric` | continuous | [1.1, 977] | 0% |
| `Pb` | `numeric` | continuous | [1.01, 837] | 0% |
| `Fe2O3` | `numeric` | continuous | [2.01, 32.4] | 0% |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Les métaux lourds Cu, Zn, Pb (et Fe2O3 comme proxy de contamination ferreuse) sont les variables cibles naturelles d'une étude de pollution géochimique en sédiments estuariens. Les oxydes majeurs (SiO2, Al2O3, CaO, etc.), LOI, mud (granulométrie) et Ba (élément trace naturel/fond géochimique) constituent des covariables explicatives reflétant la composition minéralogique, la texture sédimentaire et le contexte géochimique de fond.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `SiO2` | `numeric` | continuous | 0% |
| `Al2O3` | `numeric` | continuous | 0% |
| `CaO` | `numeric` | continuous | 0% |
| `MgO` | `numeric` | continuous | 0% |
| `Na2` | `numeric` | continuous | 0% |
| `K2O` | `numeric` | continuous | 0% |
| `MnO` | `numeric` | rate | 0% |
| `TiO2` | `numeric` | continuous | 0% |
| `P2O5` | `numeric` | continuous | 0% |
| `LOI` | `numeric` | continuous | 0% |
| `mud` | `numeric` | continuous | 0% |
| `Ba` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: log(Zn)~SiO2+Al2O3+CaO+MgO+mud
- x_terms_pub: SiO2+Al2O3+CaO+MgO+mud
- y_term_pub: log(Zn)
- Reference publication: Analogie structurelle avec R_gstat_meuse.all_meuse.all (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Meme domaine substantiel que meuse.all (bon candidat) : pollution en metaux lourds de sediments (estuaire Tinto-Odiel, Espagne) expliquee par la composition geochimique -- contrairement aux 17 autres jeux ade4 (ordination multivariee sans cible unique), celui-ci a une cible Y claire (metaux lourds) et des covariables geochimiques explicites, structure compatible avec une regression classique plutot qu'une ordination.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_ade4_tintoodiel_tintoodiel`
- Dataset name: ade4::tintoodiel
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
  equation_text: "log(Zn)~SiO2+Al2O3+CaO+MgO+mud"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec R_gstat_meuse.all_meuse.all (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 52
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [28.125, 488.8194], y [36.1667, 737.9722] (CRS unknown)
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
