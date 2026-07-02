---
title: R_surveillance_hagelloch_hagelloch
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_surveillance_hagelloch_hagelloch.rds
tags: [dataset, r-package, spatial, point]
---

Data on the 188 cases in the measles outbreak among children in the German city of Hagelloch (near Tübingen) 1861. The data were originally collected by Dr. Albert Pfeilsticker (1863) and augmented and re-analysed by Dr. Heike Oesterle (1992). This dataset is used to illustrate the ‘twinSIR’ model class in ‘vignette("twinSIR")’.

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `event`, `Revent`
- Candidate Y typology: binary
- Candidate X variables: `start`, `stop`, `atRiskY`, `AGE`, `SEX`, `CL`, `household`, `nothousehold`, `c1`, `c2`
- Candidate X typology: continuous, categorical
- Coordinates (x, y — excluded from X candidates): `X`, `Y`
- Identifier columns (excluded from X candidates): `id`
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `event` | `numeric` | binary | {0, 1} | 0% |
| `Revent` | `numeric` | binary | {0, 1} | 0% |


> Note doc : number of cases in family

> **Note** - Version spatio-temporelle : 188 cas individuels x plusieurs pas de temps (N=70 500 lignes). Complementaire a `hagelloch.df`, version spatiale pure (N=188).

> Selection Y/X (claude-sonnet-4-6) : Dans un modèle twinSIR d'épidémie, 'event' (nouvelle infection) et 'Revent' (rétablissement) sont les variables réponse naturelles de l'analyse de survie/point process ; les covariables explicatives incluent l'âge, le sexe, la classe scolaire (CL), le nombre de contacts intra- et extra-ménage (household, nothousehold), les compteurs spatiaux de voisinage (c1, c2), ainsi que les variables de fenêtre temporelle (start, stop) et l'indicateur de risque (atRiskY) typiques du format counting-process. BLOCK, x.loc et y.loc sont des identifiants/coordonnées déjà exclus en amont ou redondants.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `start` | `numeric` | continuous | 0% |
| `stop` | `numeric` | continuous | 0% |
| `atRiskY` | `numeric` | binary | 0% |
| `AGE` | `numeric` | continuous | 0% |
| `SEX` | `factor` | categorical | 5.9% |
| `CL` | `factor` | categorical | 0% |
| `household` | `numeric` | continuous | 0% |
| `nothousehold` | `numeric` | continuous | 0% |
| `c1` | `numeric` | continuous | 0% |
| `c2` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: ~ household + cox(AGE)
- x_terms_pub: household + cox(AGE)
- y_term_pub: 
- Reference publication: Neal PJ, Roberts GO (2004) Statistical inference and model selection for the 1861 Hagelloch measles epidemic. Biostatistics, 5(2), 249-261. DOI:10.1093/biostatistics/5.2.249

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: twinSIR (modele de survie / processus de comptage pour epidemie)
- Correspondance Python/R: R_surveillance_hagelloch_hagelloch.df
- Note: Formule deja presente (enrichissement anterieur), coherente avec le DOI Bloc 2 ; version spatio-temporelle (N=70500) complementaire de hagelloch.df.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_surveillance_hagelloch_hagelloch`
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
  existing_model_found: true
  equation_text: "~ household + cox(AGE)"
  equation_family: simulation_model
  model_family: "twinSIR (modele de survie / processus de comptage pour epidemie)"
  source_type: software_documentation
  source_ref: "Neal PJ, Roberts GO (2004) Statistical inference and model selection for the 1861 Hagelloch measles epidemic. Biostatistics, 5(2), 249-261. DOI:10.1093/biostatistics/5.2.249"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 70500
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

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

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `surveillance`
