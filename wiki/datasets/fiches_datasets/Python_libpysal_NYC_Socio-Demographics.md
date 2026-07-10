---
title: Python_libpysal_NYC_Socio-Demographics
type: dataset
created: 2026-06-30
updated: 2026-07-02
sources:
  - data/final_datasets/sf/Python_libpysal_NYC_Socio-Demographics.rds
tags: [dataset, python-package, spatial, point]
---

Dataset spatial issu du package Python `libpysal` (`NYC Socio-Demographics`).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `UNEMP_RATE`, `poor`, `struggling`, `poororstru`, `gini`, `medianinco`, `popdty`
- Candidate Y typology: rate, count, categorical, continuous
- Candidate X variables: `poptot`, `popover18`, `popinlabou`, `households`, `african`, `hispanic`, `asian`, `european`, `mixed`, `american`, `pacific`, `otherethni`, `onlylessth`, `onlyhighsc`, `onlycolleg`, `onlybachel`, `onlymaster`, `onlyprofes`, `onlydoctor`, `lessthanhi`, `highschool`, `college`, `bachelor`, `master`, `doctorate`, `male`, `female`, `withssi`, `withsocial`, `withpubass`, `comm_5less`, `comm_5_14`, `comm_15_29`, `comm_30_44`, `comm_45_59`, `comm_60_89`, `com_90plus`, `medianage`, `medianagem`, `medianagef`, `shape_area`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `cartodb_id`, `ntacode`, `geo_geoid`, `borocode`, `tractid`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `UNEMP_RATE` | `numeric` | rate | [0, 1] | 0% |
| `poor` | `integer` | count | [0, 4928] | 0% |
| `struggling` | `integer` | count | [0, 5484] | 0% |
| `poororstru` | `integer` | count | [0, 10084] | 0% |
| `gini` | `character` | categorical | None | 0% |
| `medianinco` | `character` | categorical | None | 0% |
| `popdty` | `numeric` | continuous | [0, 211401.2] | 0% |


> Selection Y/X (claude-sonnet-4-6) : UNEMP_RATE est la cible naturelle en tant que taux normalisé [0,1], mais poor, struggling, poororstru, gini et medianinco sont aussi des réponses socio-économiques plausibles ; popdty (densité de population) peut servir de variable dépendante spatiale. Les covariables X couvrent la structure démographique (population totale, âge, sexe), la composition ethnique, le niveau d'éducation, les aides sociales et les temps de trajet domicile-travail, qui sont des déterminants classiques des inégalités et du chômage. Les colonnes purement administratives (codes géographiques, noms de lieux, identifiants géométriques) sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `poptot` | `integer` | count | 0% |
| `popover18` | `integer` | count | 0% |
| `popinlabou` | `integer` | count | 0% |
| `households` | `integer` | count | 0% |
| `african` | `integer` | count | 0% |
| `hispanic` | `integer` | count | 0% |
| `asian` | `integer` | count | 0% |
| `european` | `integer` | count | 0% |
| `mixed` | `integer` | count | 0% |
| `american` | `integer` | count | 0% |
| `pacific` | `integer` | count | 0% |
| `otherethni` | `integer` | count | 0% |
| `onlylessth` | `integer` | count | 0% |
| `onlyhighsc` | `integer` | count | 0% |
| `onlycolleg` | `integer` | count | 0% |
| `onlybachel` | `integer` | count | 0% |
| `onlymaster` | `integer` | count | 0% |
| `onlyprofes` | `integer` | count | 0% |
| `onlydoctor` | `integer` | count | 0% |
| `lessthanhi` | `integer` | count | 0% |
| `highschool` | `integer` | count | 0% |
| `college` | `integer` | count | 0% |
| `bachelor` | `integer` | count | 0% |
| `master` | `integer` | count | 0% |
| `doctorate` | `integer` | count | 0% |
| `male` | `integer` | count | 0% |
| `female` | `integer` | count | 0% |
| `withssi` | `integer` | count | 0% |
| `withsocial` | `integer` | count | 0% |
| `withpubass` | `integer` | count | 0% |
| `comm_5less` | `integer` | count | 0% |
| `comm_5_14` | `integer` | count | 0% |
| `comm_15_29` | `integer` | count | 0% |
| `comm_30_44` | `integer` | count | 0% |
| `comm_45_59` | `integer` | count | 0% |
| `comm_60_89` | `integer` | count | 0% |
| `com_90plus` | `integer` | count | 0% |
| `medianage` | `character` | categorical | 0% |
| `medianagem` | `character` | categorical | 0% |
| `medianagef` | `character` | categorical | 0% |
| `shape_area` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: UNEMP_RATE~poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianage
- x_terms_pub: poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianage
- y_term_pub: UNEMP_RATE
- Reference publication: Analogie structurelle avec geoda.police / geoda.us_sdoh (banque interne, mission 2026-07)

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: candidat par analogie -- non verifie
- Niveau de preuve: analogie
- Methode d'estimation: OLS
- Correspondance Python/R: aucune identifiee
- Note: CANDIDAT PAR ANALOGIE -- non verifie. Analogie structurelle avec geoda.police (POL~TAX+TRANS+INC+CRIME+UNEMP+OWNER+COLLEGE+WHITE+OUT) et geoda.us_sdoh : taux de chomage/pauvrete au niveau secteur explique par la composition demographique, educative et raciale -- domaine substantiellement identique (indicateur socioeconomique explique par composition de quartier). NOTE ADDITIONNELLE : ce dataset partage un schema quasi identique (memes noms de colonnes Y et X) avec Python_geodatasets_geoda.nyc_neighborhoods -- probable quasi-doublon intra-Python (memes donnees NYC sous deux packages), a verifier separement de la question d'analogie.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `Python_libpysal_NYC_Socio-Demographics`
- Dataset name: libpysal::NYC Socio-Demographics
- Source family: python-package
- Source: package Python `libpysal`
- Source URL: https://pypi.org/project/libpysal/
- Dataset DOI: none
- Publication DOI: pending
- Year: 2017

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "UNEMP_RATE~poptot+hispanic+african+onlyhighsc+onlybachel+withpubass+medianage"
  equation_family: linear
  model_family: "OLS"
  source_type: unknown
  source_ref: "Analogie structurelle avec geoda.police / geoda.us_sdoh (banque interne, mission 2026-07)"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 2166
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-74.2397, -73.705], y [40.5024, 40.9127] (EPSG:4326)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: 4326
- CRS nom: WGS 84
- CRS analyse recommande: 32618 (UTM Zone 18N (EPSG:32618)) — calcul auto depuis centroide bbox -- normalisation WGS84 uniquement

## Bloc 6 — Reproductibilite

- License present: yes
- License name: BSD 3-Clause
- License URL: https://pypi.org/project/libpysal/
- License open: yes
- Reproducibility status: available via package Python `libpysal`
- Code available: yes (package examples and vignettes)
- Repository: python-package

## Quality Control

Aucune anomalie detectee.

## Related Pages

- Source: package Python `libpysal`
