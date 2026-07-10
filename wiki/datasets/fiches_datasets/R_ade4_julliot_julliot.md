---
title: R_ade4_julliot_julliot
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/R_ade4_julliot_julliot.rds
tags: [dataset, r-package, spatial, point]
---

This data set gives the spatial distribution of seeds (quadrats counts) of seven species in the understorey of tropical rainforest.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `Pouteria_torta`, `Minquartia_guianensis`, `Quiina_obovata`, `Chrysophyllum_lucentifolium`, `Parahancornia_fasciculata`, `Virola_michelii`, `Pourouma_spp`
- Candidate Y typology: binary, count
- Candidate X variables: not identified by LLM classification — manual review required
- Candidate X typology: unknown
- Coordinates (x, y — excluded from X candidates): `x`, `y`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `Pouteria_torta` | `integer` | binary | {0, 1} | 0% |
| `Minquartia_guianensis` | `integer` | count | [0, 7] | 0% |
| `Quiina_obovata` | `integer` | count | [0, 12] | 0% |
| `Chrysophyllum_lucentifolium` | `integer` | count | [0, 14] | 0% |
| `Parahancornia_fasciculata` | `integer` | binary | {0, 1} | 0% |
| `Virola_michelii` | `integer` | count | [0, 15] | 0% |
| `Pourouma_spp` | `integer` | count | [0, 9] | 0% |


> **ade4** - Donnees ecologiques multivariees. La variable reponse Y et la formule sont a definir manuellement selon l'etude ciblee (ordination, RDA, etc.).

> Selection Y/X (claude-sonnet-4-6) : Toutes les colonnes représentent des comptages (ou présence/absence) de graines d'espèces végétales dans des quadrats, ce qui en fait des variables réponse naturelles pour modéliser la distribution spatiale de chaque espèce. Dans un cadre multi-espèces, chaque espèce peut alternativement servir de covariable explicative pour prédire une autre espèce (co-occurrences, interactions), donc toutes sont candidates à la fois en Y et en X selon l'espèce cible choisie.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| — | — | aucun candidat | — |


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
- Note: Package ade4 = ordination multivariee (ACP/RDA/CCA) ; structure de donnees confirmee a 5 reprises independantes (doubs/avijons/oribatid/mafragh/jv73) comme non adaptee a une regression canonique a variable dependante unique. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Y = abondances de 7 especes d'arbres, aucune covariable environnementale identifiee -- table d'abondance ecologique typique ade4, pas de regression a cible unique exploitable.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_ade4_julliot_julliot`
- Dataset name: ade4::julliot
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
- N observations: 160
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [1, 20], y [0, 15] (CRS unknown)
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
