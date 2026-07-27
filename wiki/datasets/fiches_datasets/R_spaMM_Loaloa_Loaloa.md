---
title: R_spaMM_Loaloa_Loaloa
type: dataset
created: 2026-07-23
updated: 2026-07-23
sources:
  - data/final_datasets/sf/R_spaMM_Loaloa_Loaloa.rds
tags: [dataset, r-package, spatial, point]
---

This data set describes prevalence of infection by the nematode _Loa loa_ in North Cameroon, 1991-2001. This is a superset of the data discussed by Diggle and Ribeiro (2007) and Diggle et al. (2007). The study investigated the relationship between altitude, vegetation indices, and prevalence of the parasite.

## Description du jeu de donnees

- Topic: sante publique / epidemiologie spatiale
- Observation unit: individu, cas sanitaire ou unite spatiale de sante
- Observed population: population sanitaire documentee par le package source
- Geographic context: a preciser depuis la documentation, l'article ou l'etendue spatiale
- Temporal context: aucune variable temporelle structurelle detectee
- Source description: This data set describes prevalence of infection by the nematode _Loa loa_ in North Cameroon, 1991-2001. This is a superset of the data discussed by Diggle and Ribeiro (2007) and Diggle et al. (2007). The study investigated the relationship between altitude, vegetation indices, and prevalence of the parasite.
- Description source: package R `spaMM`
- Description confidence: medium

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `npos`
- Candidate Y typology: continuous
- Candidate X variables: `ntot`, `maxNDVI`, `seNDVI`, `elev1`, `elev2`, `elev3`, `elev4`, `maxNDVI1`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `longitude`, `latitude`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `npos` | `numeric` | continuous | [0, 162] | 0% |


> Selection Y/X (claude-sonnet-4-6) : npos (nombre de cas positifs à Loa loa) est la variable réponse naturelle pour modéliser la prévalence de l'infection, éventuellement avec ntot comme offset (taille de l'échantillon). Les variables d'altitude (elev1–elev4) et de végétation (maxNDVI, seNDVI, maxNDVI1) sont les covariables explicatives conformément à l'objectif déclaré de l'étude.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `ntot` | `numeric` | continuous | 0% |
| `maxNDVI` | `numeric` | rate | 0% |
| `seNDVI` | `numeric` | rate | 0% |
| `elev1` | `numeric` | continuous | 0% |
| `elev2` | `numeric` | continuous | 0% |
| `elev3` | `numeric` | continuous | 0% |
| `elev4` | `numeric` | continuous | 0% |
| `maxNDVI1` | `numeric` | rate | 0% |


### Formule — niveau publication

- formula_pub: cbind(npos, ntot-npos) ~ elev1 + elev2 + elev3 + elev4 + maxNDVI1 + seNDVI + Matern(1|longitude+latitude)
- x_terms_pub: elev1, elev2, elev3, elev4, maxNDVI1, seNDVI, Matern(1|longitude+latitude)
- y_term_pub: cbind(npos, ntot-npos)
- Reference publication: Diggle P.J., Thomson M.C., Christensen O.F., Rowlingson B., Obsomer V., Gardon J., Wanji S., Takougang I., Enyong P., Kamgno J., Remme J.H., Boussinesq M., Molyneux D.H. (2007) Spatial modelling and the prediction of Loa loa risk: decision making under uncertainty. Annals of Tropical Medicine and Parasitology, 101(6), 499–509

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d'estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule issue de la publication ou documentation scientifique et retenue comme formule systeme.

### Formule — niveau systeme

- formula_used: cbind(npos, ntot-npos) ~ elev1 + elev2 + elev3 + elev4 + maxNDVI1 + seNDVI + Matern(1|longitude+latitude)
- x_terms_used: elev1, elev2, elev3, elev4, maxNDVI1, seNDVI, Matern(1|longitude+latitude)
- y_term_used: cbind(npos, ntot-npos)

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spaMM_Loaloa_Loaloa`
- Dataset name: spaMM::Loaloa
- Source family: r-package
- Source: package R `spaMM` (version 4.6.65)
- Source URL: https://CRAN.R-project.org/package=spaMM
- Dataset DOI: none
- Publication DOI: 10.1179/136485907X229121
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "cbind(npos, ntot-npos) ~ elev1 + elev2 + elev3 + elev4 + maxNDVI1 + seNDVI + Matern(1|longitude+latitude)"
  equation_family: unknown
  model_family: "formule publication confirmee et utilisee"
  source_type: unknown
  source_ref: "Diggle P.J., Thomson M.C., Christensen O.F., Rowlingson B., Obsomer V., Gardon J., Wanji S., Takougang I., Enyong P., Kamgno J., Remme J.H., Boussinesq M., Molyneux D.H. (2007) Spatial modelling and the prediction of Loa loa risk: decision making under uncertainty. Annals of Tropical Medicine and Parasitology, 101(6), 499–509"
  confidence: low
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 197
- T periods: 1
- Variable temporelle: none
- N/T profile: N_moyen_T_1
- Temporal note: aucune variable temporelle structurelle detectee

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [8.0043, 15.1361], y [3.35, 6.878] (CRS unknown)
- Time range: not applicable (cross-sectional dataset)
- Type de geometrie: POINT
- CRS EPSG: unknown [lookup required]
- CRS nom: unknown
- CRS analyse recommande: pending — CRS source non geographique ou inconnu

## Bloc 6 — Reproductibilite

- License present: yes
- License name: CeCILL-2
- License URL: https://CRAN.R-project.org/package=spaMM
- License open: yes
- Reproducibility status: available via package R `spaMM`
- Code available: yes (package examples and vignettes)
- Repository: r-package

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches.py`.
- Variables: OK - Y, X, coordonnees et identifiants sont separes.
- Formula: OK - formule publication renseignee.
- CRS: WARN - CRS absent du `.rds` source et non resolu automatiquement.
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - source package et licence renseignes (CeCILL-2).

## Related Pages

- Source: package R `spaMM`
