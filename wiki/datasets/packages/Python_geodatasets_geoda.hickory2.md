---
title: Python_geodatasets_geoda.hickory2
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.hickory2.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`hickory2`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `INDEX`, `PCTCSE`, `PCTGRO`, `PCTIME`, `EMP01`, `PAY01`
- Candidate Y typology: count, continuous
- Candidate X variables: `POP2001`, `EST98`, `EMP98`, `PAY98`, `EST01`, `MAN98`, `MAN98_12`, `MAN98_39`, `MAN01`, `MAN01_12`, `MAN01_39`, `OFF98`, `OFF98_12`, `OFF98_39`, `OFF01`, `OFF01_12`, `OFF01_39`, `INFO98`, `INFO98_12`, `INFO98_39`, `INFO01`, `INFO01_12`, `INFO01_39`, `NUMSEC`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `CBSA_CODE`, `ID`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `INDEX` | `integer` | count | [3, 31] | 0% |
| `PCTCSE` | `numeric` | continuous | [-67.93, 16.65] | 0% |
| `PCTGRO` | `numeric` | continuous | [-64.43, 16.47] | 0% |
| `PCTIME` | `numeric` | continuous | [-2.67, 1.29] | 0% |
| `EMP01` | `integer` | count | [17, 31254] | 0% |
| `PAY01` | `integer` | count | [408, 901471] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont les indicateurs synthétiques de dynamique économique locale (INDEX, PCTCSE=variation établissements, PCTGRO=croissance emploi, PCTIME, EMP01, PAY01) qui sont des mesures de résultats à expliquer. Les X candidates sont les counts sectoriels (manufacturing, office, info) par zone et période, la population, le nombre d'établissements et d'emplois de base (1998), et le nombre de secteurs (NUMSEC), qui sont des caractéristiques structurelles explicatives ; les colonnes US-level à variance nulle (MAN98US, etc.) sont ignorées car constantes et non informatives.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `POP2001` | `integer` | count | 0% |
| `EST98` | `integer` | count | 0% |
| `EMP98` | `integer` | count | 0% |
| `PAY98` | `integer` | count | 0% |
| `EST01` | `integer` | count | 0% |
| `MAN98` | `integer` | count | 0% |
| `MAN98_12` | `integer` | count | 0% |
| `MAN98_39` | `integer` | count | 0% |
| `MAN01` | `integer` | count | 0% |
| `MAN01_12` | `integer` | count | 0% |
| `MAN01_39` | `integer` | count | 0% |
| `OFF98` | `integer` | count | 0% |
| `OFF98_12` | `integer` | count | 0% |
| `OFF98_39` | `integer` | count | 0% |
| `OFF01` | `integer` | count | 0% |
| `OFF01_12` | `integer` | count | 0% |
| `OFF01_39` | `integer` | count | 0% |
| `INFO98` | `integer` | count | 0% |
| `INFO98_12` | `integer` | count | 0% |
| `INFO98_39` | `integer` | count | 0% |
| `INFO01` | `integer` | count | 0% |
| `INFO01_12` | `integer` | count | 0% |
| `INFO01_39` | `integer` | count | 0% |
| `NUMSEC` | `integer` | count | 0% |


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
- Note: Aucune regression canonique documentee retrouvee dans la litterature ou la documentation du package pour ce jeu de donnees lors de la recherche manuelle exhaustive (web + sources primaires). [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : PCTIME/etablissements d'entreprise par secteur -- aucun bon candidat de la banque ne couvre ce domaine.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.hickory2`
- Dataset name: geodatasets::hickory2
- Source family: python-package
- Source: package Python `geodatasets`
- Source URL: https://pypi.org/project/geodatasets/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2023

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
- N observations: 29
- T periods: 1
- Variable temporelle: none
- N/T profile: N_petit_T_1

> **Correction metadonnees (Tache 2, juillet 2026)** — PCTIME comptait autant de valeurs uniques que de lignes (T=N=29) — signature typique d'une variable continue prise a tort pour un axe temporel repete ; coupe transversale de census tracts.
## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-81.9791, -80.9651], y [35.4773, 36.0738] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32617 (UTM Zone 17N (EPSG:32617)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/geodatasets/
- License open: yes
- Reproducibility status: available via package Python `geodatasets`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package Python `geodatasets`
