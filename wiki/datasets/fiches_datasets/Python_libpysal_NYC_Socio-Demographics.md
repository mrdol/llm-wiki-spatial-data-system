---
title: Python_libpysal_NYC_Socio-Demographics
type: dataset
created: 2026-07-10
updated: 2026-07-10
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

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: pending

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: UNEMP_RATE ~ poptot + popover18 + popinlabou + households + african + hispanic + asian + european
- x_terms_used: poptot + popover18 + popinlabou + households + african + hispanic + asian + european
- y_term_used: UNEMP_RATE

### Formules candidates — niveau systeme

- formula_candidate_1: UNEMP_RATE ~ poptot + popover18 + popinlabou + households + african + hispanic + asian + european
- formula_candidate_2: UNEMP_RATE ~ poptot + popover18 + popinlabou + households

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
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "null"
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

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (BSD 3-Clause).

## Related Pages

- Source: package Python `libpysal`
