---
title: Python_geodatasets_geoda.nyc_neighborhoods
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_geodatasets_geoda.nyc_neighborhoods.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `geodatasets` (`nyc_neighborhoods`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `UEMPRATE`, `struggling`, `poor`, `poororstru`, `gini`
- Candidate Y typology: rate, count, categorical
- Candidate X variables: `poptot`, `popover18`, `popinlabou`, `households`, `hispanic`, `african`, `asian`, `european`, `otherethni`, `mixed`, `onlybachel`, `onlycolleg`, `onlyhighsc`, `onlymaster`, `onlydoctor`, `onlylessth`, `onlyprofes`, `lessthanhi`, `withssi`, `withsocial`, `withpubass`, `comm_15_29`, `comm_30_44`, `comm_45_59`, `comm_60_89`, `comm90plus`, `medianinco`, `medianage`, `HHsize`, `male`, `female`, `boroname`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `cartodb_id`, `borocode`, `ntacode`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `UEMPRATE` | `numeric` | rate | [0, 0.5698] | 0% |
| `struggling` | `integer` | count | [0, 27502] | 0% |
| `poor` | `integer` | count | [0, 36334] | 0% |
| `poororstru` | `integer` | count | [0, 63836] | 0% |
| `gini` | `character` | categorical | None | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les variables Y candidates sont des indicateurs socio-économiques synthétiques de vulnérabilité ou d'inégalité à expliquer spatialement (taux de chômage, pauvreté, précarité, indice de Gini). Les variables X candidates couvrent la structure démographique (population, âge, genre), la composition ethnique, le niveau d'éducation, les transferts sociaux, les temps de trajet domicile-travail, le revenu médian et la taille des ménages — toutes covariables explicatives classiques en spatial ML ; les colonnes purement nominatives (ntaname, field_1) et les sous-totaux redondants (popunemplo, maleunempl, etc. déjà résumés dans UEMPRATE) sont ignorés.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `poptot` | `integer` | count | 0% |
| `popover18` | `integer` | count | 0% |
| `popinlabou` | `integer` | count | 0% |
| `households` | `integer` | count | 0% |
| `hispanic` | `integer` | count | 0% |
| `african` | `integer` | count | 0% |
| `asian` | `integer` | count | 0% |
| `european` | `integer` | count | 0% |
| `otherethni` | `integer` | count | 0% |
| `mixed` | `integer` | count | 0% |
| `onlybachel` | `integer` | count | 0% |
| `onlycolleg` | `integer` | count | 0% |
| `onlyhighsc` | `integer` | count | 0% |
| `onlymaster` | `integer` | count | 0% |
| `onlydoctor` | `integer` | count | 0% |
| `onlylessth` | `integer` | count | 0% |
| `onlyprofes` | `integer` | count | 0% |
| `lessthanhi` | `integer` | count | 0% |
| `withssi` | `integer` | count | 0% |
| `withsocial` | `integer` | count | 0% |
| `withpubass` | `integer` | count | 0% |
| `comm_15_29` | `integer` | count | 0% |
| `comm_30_44` | `integer` | count | 0% |
| `comm_45_59` | `integer` | count | 0% |
| `comm_60_89` | `integer` | count | 0% |
| `comm90plus` | `integer` | count | 0% |
| `medianinco` | `character` | categorical | 0% |
| `medianage` | `character` | categorical | 0% |
| `HHsize` | `character` | categorical | 0% |
| `male` | `integer` | count | 0% |
| `female` | `integer` | count | 0% |
| `boroname` | `character` | categorical | 0% |


### Formule — niveau publication

- formula_pub: UEMPRATE~poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianinco
- x_terms_pub: poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianinco
- y_term_pub: UEMPRATE
- Reference publication: Analogie structurelle avec geoda.police / geoda.us_sdoh (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.police (POL~TAX+TRANS+INC+CRIME+UNEMP+OWNER+COLLEGE+WHITE+OUT) et geoda.us_sdoh : taux de chomage/pauvrete au niveau secteur explique par la composition demographique, educative et raciale -- domaine substantiellement identique (indicateur socioeconomique explique par composition de quartier).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_geodatasets_geoda.nyc_neighborhoods`
- Dataset name: geodatasets::nyc_neighborhoods
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
  existing_model_found: true
  equation_text: "UEMPRATE~poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianinco"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec geoda.police / geoda.us_sdoh (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 195
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-74.2295, -73.7091], y [40.5273, 40.8999] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

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
