---
title: R_surveillance_hagelloch_hagelloch.df
type: dataset
created: 2026-07-10
updated: 2026-07-10
sources:
  - data/final_datasets/sf/R_surveillance_hagelloch_hagelloch.df.rds
tags: [dataset, r-package, spatial, point]
---

Data on the 188 cases in the measles outbreak among children in the German city of Hagelloch (near Tübingen) 1861. The data were originally collected by Dr. Albert Pfeilsticker (1863) and augmented and re-analysed by Dr. Heike Oesterle (1992). This dataset is used to illustrate the ‘twinSIR’ model class in ‘vignette("twinSIR")’.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `tPRO`, `tERU`, `tDEAD`, `SI`, `PR`, `TD`, `TM`
- Candidate Y typology: continuous, count
- Candidate X variables: `AGE`, `SEX`, `CL`, `C`, `CA`, `NI`, `GE`, `x.loc`, `y.loc`, `tI`, `tR`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `tPRO` | `numeric` | continuous | [0.735, 86.6883] | 0% |
| `tERU` | `numeric` | continuous | [4.1978, 89.5452] | 0% |
| `tDEAD` | `numeric` | continuous | [19.5168, 59.8635] | 93.6% |
| `SI` | `integer` | count | [0, 16] | 0% |
| `PR` | `integer` | count | [0, 13] | 0% |
| `TD` | `integer` | count | [1, 11] | 58% |
| `TM` | `numeric` | continuous | [38.3, 41.5] | 58% |


> Note doc : number of cases in family

> **Note** - Version spatiale : 1 ligne par cas individuel (N=188). Complementaire a `hagelloch`, version spatio-temporelle (N=70 500).

> Selection Y/X (claude-sonnet-4-6) : Les variables temporelles d'événements épidémiques (dates/temps de prodrome, éruption, décès) et les indicateurs de sévérité (SI, PR, TD, TM) sont des cibles naturelles pour modéliser la dynamique de l'épidémie. Les caractéristiques individuelles (âge, sexe, classe scolaire, complication, quartier, génération) et spatiales (x.loc, y.loc) ainsi que les temps d'entrée en phase infectieuse (tI, tR) constituent des covariables explicatives plausibles ; PN, FN, HN, IFTO, NAME sont ignorés car purement identificateurs/administratifs.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `AGE` | `numeric` | continuous | 0% |
| `SEX` | `factor` | categorical | 5.9% |
| `CL` | `factor` | categorical | 0% |
| `C` | `factor` | categorical | 0% |
| `CA` | `integer` | count | 0% |
| `NI` | `integer` | count | 0% |
| `GE` | `integer` | count | 0% |
| `x.loc` | `numeric` | continuous | 0% |
| `y.loc` | `numeric` | continuous | 0% |
| `tI` | `numeric` | continuous | 0% |
| `tR` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: ~ household + cox(AGE)
- x_terms_pub: household, cox(AGE)
- y_term_pub: pending
- Reference publication: Neal PJ, Roberts GO (2004) Statistical inference and model selection for the 1861 Hagelloch measles epidemic. Biostatistics, 5(2), 249–261

### Statut regression canonique

- Statut: pending
- Niveau de preuve: n/a
- Methode d'estimation: n/a
- Correspondance Python/R: aucune identifiee
- Note: Formule systeme proposee automatiquement pour benchmark spatial ; ne pas confondre avec une formule publiee.
### Formule — niveau systeme

- formula_used: tPRO ~ AGE + SEX + CL + C + CA + NI + GE + x.loc
- x_terms_used: AGE + SEX + CL + C + CA + NI + GE + x.loc
- y_term_used: tPRO

## Bloc 2 — Identification et DOI

- Dataset ID: `R_surveillance_hagelloch_hagelloch.df`
- Dataset name: surveillance::hagelloch
- Source family: r-package
- Source: package R `surveillance` (version 1.25.0)
- Source URL: https://CRAN.R-project.org/package=surveillance
- Dataset DOI: none
- Publication DOI: 10.1093/biostatistics/5.2.249
- Year: 2005

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: false
  equation_text: "~ household + cox(AGE)"
  equation_family: unknown
  model_family: "n/a"
  source_type: unknown
  source_ref: "Neal PJ, Roberts GO (2004) Statistical inference and model selection for the 1861 Hagelloch measles epidemic. Biostatistics, 5(2), 249–261"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 188
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [7.5, 280], y [5, 240] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: GPL-2
- License URL: https://CRAN.R-project.org/package=surveillance
- License open: yes
- Reproducibility status: available via package R `surveillance`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: WARN - variables avec NA > 20% : DEAD (NA=93.6%), TD (NA=58%), TM (NA=58%), tDEAD (NA=93.6%).
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (GPL-2).

## Related Pages

- Source: package R `surveillance`
