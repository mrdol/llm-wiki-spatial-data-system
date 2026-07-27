---
title: R_ade4_julliot_julliot
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_ade4_julliot_julliot.rds
tags: [dataset, r-package, spatial, point]
---

This data set gives the spatial distribution of seeds (quadrats counts) of seven species in the understorey of tropical rainforest.

## Description du jeu de donnees

- Topic: dataset spatial spatial
- Observation unit: observation spatiale de type POINT
- Observed population: pending
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: This data set gives the spatial distribution of seeds (quadrats counts) of seven species in the understorey of tropical rainforest.
- Description source: package R `ade4`
- Description confidence: medium

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

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: Julliot, C. (1992). Utilisation des ressources alimentaires par le singe hurleur roux, _Alouatta seniculus_ (Atelidae, Primates), en Guyane : impact de la dissémination des graines sur la régénération forestière. Thèse de troisième cycle, Université de Tours.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: n/a

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
  model_family: "n/a"
  source_type: unknown
  source_ref: "Julliot, C. (1992). Utilisation des ressources alimentaires par le singe hurleur roux, _Alouatta seniculus_ (Atelidae, Primates), en Guyane : impact de la dissémination des graines sur la régénération forestière. Thèse de troisième cycle, Université de Tours."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 160
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1
- Temporal note: aucune variable temporelle structurelle detectee

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

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: WARN - Y identifiee, mais X non identifiees automatiquement.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL (>= 2)).

## Related Pages

- Source: package R `ade4`
