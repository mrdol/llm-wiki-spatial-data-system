---
title: R_agridat_usgs.herbicides_usgs.herbicides
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_agridat_usgs.herbicides_usgs.herbicides.rds
tags: [dataset, r-package, spatial, point]
---

Concentrations of selected herbicides and degradation products determined by laboratory method analysis code GCS for water samples collected from 51 streams in nine Midwestern States, 2002.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `atrazine`, `acetochlor`, `alachlor`, `cyanazine`, `flufenacet`, `CIAT`, `CEAT`, `CAM`
- Candidate Y typology: categorical
- Candidate X variables: `sampletype`, `date`, `hour`, `ametryn`, `T`
- Candidate X typology: categorical, continuous
- Coordinates (x, y — excluded from X candidates): `long`, `lat`, `X`, `Y`
- Identifier columns (excluded from X candidates): `usgsid`, `dimethenamid`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `atrazine` | `factor` | categorical | None | 0% |
| `acetochlor` | `factor` | categorical | None | 0% |
| `alachlor` | `factor` | categorical | None | 0% |
| `cyanazine` | `factor` | categorical | None | 0% |
| `flufenacet` | `factor` | categorical | None | 0% |
| `CIAT` | `factor` | categorical | None | 0% |
| `CEAT` | `factor` | categorical | None | 0% |
| `CAM` | `factor` | categorical | None | 0% |


> Selection Y/X (claude-sonnet-4-6) : Les concentrations d'herbicides et de leurs produits de dégradation (atrazine, acetochlor, alachlor, cyanazine, flufenacet, CIAT, CEAT, CAM) sont les variables réponses naturelles dans un contexte de surveillance de qualité des eaux. Les modalités d'échantillonnage (sampletype, date, hour) ainsi que d'autres mesures chimiques (ametryn, T) constituent des covariables explicatives plausibles ; les colonnes identifiantes ou géographiques (mapnum, site, city) sont ignorées.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `sampletype` | `factor` | categorical | 0% |
| `date` | `factor` | categorical | 0% |
| `hour` | `integer` | count | 0% |
| `ametryn` | `factor` | categorical | 0% |
| `T` | `factor` | categorical | 0% |


### Formule — niveau publication

- formula_pub: pending
- x_terms_pub: pending
- y_term_pub: pending
- Reference publication: None.

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: atrazine ~ sampletype + date + hour + ametryn + T
- x_terms_used: sampletype + date + hour + ametryn + T
- y_term_used: atrazine

## Bloc 2 — Identification et DOI

- Dataset ID: `R_agridat_usgs.herbicides_usgs.herbicides`
- Dataset name: agridat::usgs.herbicides
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
  existing_model_found: false
  equation_text: "null"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "None."
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatio-temporel
- Structure: panel
- N observations: 184
- T periods: 62
- Variable temporelle: date
- N/T profile: N_moyen_T_grand

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: pending inspection
- Spatial extent: x [82.5786, 97.1772], y [38.0922, 45.4069] (CRS unknown)
- Time range: pending inspection
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: PENDING - formule publication non encore etablie.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `agridat`
