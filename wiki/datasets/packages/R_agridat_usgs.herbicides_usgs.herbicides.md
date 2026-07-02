---
title: R_agridat_usgs.herbicides_usgs.herbicides
type: dataset
created: 2026-06-30
updated: 2026-07-01
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

- formula_pub: log(DetectFreq)~log(UsageAgricole)+log(DemiVieSol)+log(Koc)+log(ProfondeurPuits)
- x_terms_pub: log(UsageAgricole)+log(DemiVieSol)+log(Koc)+log(ProfondeurPuits)
- y_term_pub: log(DetectFreq)
- Reference publication: USGS WRIR 98-4245, water.usgs.gov/nawqa/pnsp/pubs/wrir984245/

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: article
- Methode d'estimation: Regression multiple log-log
- Correspondance Python/R: aucune identifiee
- Note: ATTENTION (correction 2026-07-02, suite REJECTED Tier 2 score 0.42) -- formula_pub decrit
  le modele agrege publie dans le rapport source (USGS WRIR 98-4245), construit sur des
  variables derivees/agregees (frequence de detection, usage agricole, demi-vie sol, Koc,
  profondeur de puits) qui NE SONT PAS des colonnes de ce fichier brut agridat::usgs.herbicides
  (celui-ci contient des concentrations individuelles par herbicide et par echantillon : atrazine,
  acetochlor, alachlor, etc.). La formule est fidele a la source (niveau publication) mais n'est
  pas directement calculable sur ce fichier brut sans agregation prealable non documentee ici --
  c'est attendu et coherent avec le niveau de preuve 'article' (formule tiree d'une source
  tierce), a ne pas confondre avec 'formula_used' (niveau systeme, qui reste pending).

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

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
  existing_model_found: true
  equation_text: "log(DetectFreq)~log(UsageAgricole)+log(DemiVieSol)+log(Koc)+log(ProfondeurPuits)"
  equation_family: unknown
  model_family: "Regression multiple log-log"
  source_type: full_paper
  source_ref: "USGS WRIR 98-4245, water.usgs.gov/nawqa/pnsp/pubs/wrir984245/"
  confidence: medium
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
- License name: MIT + file LICENSE
- License URL: https://CRAN.R-project.org/package=agridat
- License open: yes
- Reproducibility status: available via package R `agridat`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `agridat`
