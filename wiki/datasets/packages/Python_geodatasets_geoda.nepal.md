---
title: Python_geodatasets_geoda.nepal
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.nepal.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nepal`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `povindex`, `depecprov`, `pcinc`, `pcincppp`, `ad_illit`, `ad_ilgt50`, `nosafh20`, `lif40`, `malkids`
- Candidate Y typology: continuous, count, binary
- Candidate X variables: `population`, `schlppop`, `schoolcnt`, `kids1_5`, `pcincmp`, `TOTCAMT`, `TOTDAMT`, `EDUCAMT`, `HEALTCAMT`, `WATCAMT`, `TRANCAMT`, `ENGYCAMT`, `AGCAMT`, `SOCCAMT`, `EDUDAMT`, `HEALTDAMT`, `WATDAMT`, `TRANDAMT`, `ENGYDAMT`, `AGDAMT`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `lon`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): `id`, `schlpkid`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `povindex` | `numeric` | continuous | [16.5, 49.26] | 0% |
| `depecprov` | `numeric` | continuous | [14.84, 51.76] | 0% |
| `pcinc` | `integer` | count | [301, 1959] | 0% |
| `pcincppp` | `integer` | count | [487, 3166] | 0% |
| `ad_illit` | `numeric` | continuous | [15.96, 66.11] | 0% |
| `ad_ilgt50` | `integer` | binary | {0, 1} | 0% |
| `nosafh20` | `numeric` | continuous | [2.14, 48.12] | 0% |
| `lif40` | `numeric` | continuous | [3.31, 14.48] | 0% |
| `malkids` | `numeric` | continuous | [16.2, 65.7] | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables socio-économiques et de bien-être (pauvreté, revenu par tête, illettrisme, malnutrition, accès à l'eau) constituent des cibles naturelles pour des modèles spatiaux d'estimation du développement humain au Népal. Les montants de commitments et disbursements par secteur (santé, éducation, eau, transport, énergie, agriculture, etc.), ainsi que la population et la densité scolaire, forment des covariables explicatives plausibles reflétant l'investissement public et la structure démographique locale ; les colonnes purement administratives (name_1, name_2, district) sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `population` | `integer` | count | 0% |
| `schlppop` | `numeric` | continuous | 0% |
| `schoolcnt` | `integer` | count | 0% |
| `kids1_5` | `integer` | count | 0% |
| `pcincmp` | `integer` | count | 0% |
| `TOTCAMT` | `integer` | count | 0% |
| `TOTDAMT` | `integer` | count | 0% |
| `EDUCAMT` | `integer` | count | 0% |
| `HEALTCAMT` | `integer` | count | 0% |
| `WATCAMT` | `integer` | count | 0% |
| `TRANCAMT` | `integer` | count | 0% |
| `ENGYCAMT` | `integer` | count | 0% |
| `AGCAMT` | `integer` | count | 0% |
| `SOCCAMT` | `integer` | count | 0% |
| `EDUDAMT` | `integer` | count | 0% |
| `HEALTDAMT` | `integer` | count | 0% |
| `WATDAMT` | `integer` | count | 0% |
| `TRANDAMT` | `integer` | count | 0% |
| `ENGYDAMT` | `integer` | count | 0% |
| `AGDAMT` | `integer` | count | 0% |


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
- Note: Variables invoquees dans certaines pistes de recherche confirmees absentes du fichier reel distribue par GeoDa. [Revue Tache 4 (2026-07-02) : aucune analogie structurelle pertinente identifiee avec un bon candidat existant -- statut inchange plutot que forcer un rapprochement faible.] Raison : Le constat initial (variables invoquees absentes du fichier reel) est respecte par prudence ; ne pas reproposer une formule sur les memes bases sans revalidation independante.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.nepal`
- Dataset name: geodatasets::nepal
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
- N observations: 75
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [80.285, 87.922], y [26.583, 30.026] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32645 (UTM Zone 45N (EPSG:32645)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
