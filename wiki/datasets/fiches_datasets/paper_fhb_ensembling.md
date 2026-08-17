---
title: paper_fhb_ensembling
type: dataset
created: 2026-08-16
updated: 2026-08-16
sources:
  - data/final_datasets/sf/paper_fhb_ensembling.rds
  - DatasetFirst_10_5061_dryad_fn2z34trv
tags: [dataset, paper-derived, spatial, point]
---

Dataset spatial converti en sf a partir des donnees brutes du papier "Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models" (DOI 10.1371/journal.pcbi.1008831).

## Description du jeu de donnees

- Topic: phytopathologie / prevision d'epidemies de fusariose de l'epi
- Observation unit: essai varietal (site x annee)
- Observed population: essais de ble/orge sur 80 sites du centre-est/centre des Etats-Unis, 1982-2015
- Geographic context: Dataset-first discovery via Dryad/Zenodo keyword search (see tools/harvest_dataset_first.py DEFAULT_QUERIES); coordinates, geometry or W must still be verified from the downloaded data files before any fiche is written.
- Temporal context: 32 distinct periods (variable: year)
- Source description: Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models
- Description source: paper_dataset_uses.json + lecture directe du papier
- Description confidence: medium
- Paper DOI: 10.1371/journal.pcbi.1008831
- Dataset DOI: 10.5061/dryad.fn2z34trv
- Source URL: https://doi.org/10.5061/dryad.fn2z34trv
- Local raw dir: `data/raw/papers/DatasetFirst_10_5061_dryad_fn2z34trv/`
- Local sf output: `data/final_datasets/sf/paper_fhb_ensembling.rds`

## Bloc 1 - Formule et variables

### Variables (niveau systeme - inspection directe du sf)

- Candidate Y variables: `S`, `Class`
- Candidate Y typology: continuous, categorical
- Candidate X variables in local artifact: `year`, `type`, `resist`, `corn`, `T.A.1`, `T.A.2`, `T.A.3`, `T.A.4`, `T.A.5`, `D.A.1`, `D.A.2`, `D.A.3`, `P.A.1`, `P.A.2`, `P.A.3`, `P.A.4`, `P.A.5`, `RH.A.1`, `RH.A.2`, `RH.A.3`, `VPD.A.1`, `VPD.A.2`, `VPD.A.3`, `VPD.A.4`, `VPD.A.5`, `TDD.A.1`, `TDD.A.2`, `TDD.A.3`, `TDD.A.4`, `TDD.A.5`, `TDD.A.6`, `RH.G80.CHD.1`, `RH.G80.CHD.2`, `RH.G80.CHD.3`, `RH.G90.CHD.1`, `RH.G90.CHD.2`, `RH.G90.CHD.3`, `T.G30.CHD.1`, `T.G30.CHD.2`, `T.G30.CHD.3`, `TRH.15T30nRHG80.CHD.1`, `TRH.15T30nRHG80.CHD.2`, `TRH.15T30nRHG80.CHD.3`, `TRH.15T30nRHG90.CHD.1`, `TRH.15T30nRHG90.CHD.2`, `TRH.15T30nRHG90.CHD.3`, `TRH.20T25nRHG85.CHD.1`, `TRH.5T30nRHG75.CHD.1`, `TRH.5T30nRHG75.CHD.2`, `TRH.5T30nRHG75.CHD.3`, `TRH.9T30nRHG90.CHD.1`, `TRH.9T30nRHG90.CHD.2`, `VPD.L11.CHD.1`, `VPD.L11.CHD.2`, `VPD.L635.CHD.1`, `VPD.L635.CHD.2`, `RH.G70.CD.1`, `RH.G70.CD.2`, `RH.G70.CD.3`, `T.14T22.CD.1`, `T.14T22.CD.2`, `VPD.L6.CD.1`, `VPD.L6.CD.2`, `VPD.L6.CD.3`, `T.MINMAXDIFF.1`, `T.MINMAXDIFF.2`, `RH.MINMAXDIFF.1`, `RH.MINMAXDIFF.2`, `RH.MINMAXDIFF.3`, `P.MINMAXDIFF.1`, `D.MINMAXDIFF.1`, `D.MINMAXDIFF.2`, `D.MINMAXDIFF.3`, `VPD.MINMAXDIFF.1`, `VPD.MINMAXDIFF.2`, `VPD.MINMAXDIFF.3`, `TDD.MINMAXDIFF.1`, `TDD.MINMAXDIFF.2`, `TDD.MINMAXDIFF.3`, `T.SD.1`, `T.SD.2`, `T.SD.3`, `D.SD.1`, `D.SD.2`, `D.SD.3`, `P.SD.1`, `VPD.SD.1`, `VPD.SD.2`, `VPD.SD.3`, `VPD.SD.4`, `RH.SD.1`, `RH.SD.2`, `TDD.SD.1`, `TDD.SD.2`, `TDD.SD.3`, `TDD.SD.4`, `MT7`, `T157`, `T15307`, `RH7`, `RH907`, `TRH907`, `TRH807`, `MT10`, `T1510`, `T153010`, `RH10`, `RH9010`, `RH8010`, `TRH9010`, `TRH8010`, `INT3`, `VPD.A.PRE5.12H`, `VPD.L20.PRE5.12H`, `VPD.L45.PRE5.12H`, `VPD.A.PRE7.12H`, `VPD.L20.PRE7.12H`, `VPD.L45.PRE7.12H`, `VPD.A.PRE10.12H`, `VPD.L20.PRE10.12H`, `VPD.L45.PRE10.12H`, `VPD.A.PRE14.12H`, `VPD.L20.PRE14.12H`, `VPD.L45.PRE14.12H`, `VPD.A.PRE15.12H`, `VPD.L20.PRE15.12H`, `VPD.L45.PRE15.12H`, `VPD.A.POST5.12H`, `VPD.L20.POST5.12H`, `VPD.L45.POST5.12H`, `VPD.A.POST7.12H`, `VPD.L20.POST7.12H`, `VPD.L45.POST7.12H`, `VPD.A.POST10.12H`, `VPD.L20.POST10.12H`, `VPD.L45.POST10.12H`, `VPD.A.POST14.12H`, `VPD.L20.POST14.12H`, `VPD.L45.POST14.12H`, `VPD.A.POST15.12H`, `VPD.L20.POST15.12H`, `VPD.L45.POST15.12H`, `DD.A.PRE5.12H`, `DD.L1.PRE5.12H`, `DD.A.PRE7.12H`, `DD.L1.PRE7.12H`, `DD.A.PRE10.12H`, `DD.L1.PRE10.12H`, `DD.A.PRE14.12H`, `DD.L1.PRE14.12H`, `DD.A.PRE15.12H`, `DD.L1.PRE15.12H`, `DD.A.POST5.12H`, `DD.L1.POST5.12H`, `DD.A.POST7.12H`, `DD.L1.POST7.12H`, `DD.A.POST10.12H`, `DD.L1.POST10.12H`, `DD.A.POST14.12H`, `DD.L1.POST14.12H`, `DD.A.POST15.12H`, `DD.L1.POST15.12H`, `RH.A.PRE5.12H`, `RH.A.PRE5.24H`, `RH.G80.PRE5.12H`, `RH.G90.PRE5.12H`, `RH.A.PRE7.12H`, `RH.G80.PRE7.12H`, `RH.G90.PRE7.12H`, `RH.A.PRE10.12H`, `RH.A.PRE10.24H`, `RH.G80.PRE10.12H`, `RH.G90.PRE10.12H`, `RH.A.PRE14.12H`, `RH.A.PRE14.24H`, `RH.G80.PRE14.12H`, `RH.G90.PRE14.12H`, `RH.A.PRE15.12H`, `RH.A.PRE15.24H`, `RH.G80.PRE15.12H`, `RH.G90.PRE15.12H`, `RH.A.POST5.12H`, `RH.A.POST5.24H`, `RH.G80.POST5.12H`, `RH.G90.POST5.12H`, `RH.A.POST7.12H`, `RH.A.POST7.24H`, `RH.G80.POST7.12H`, `RH.G90.POST7.12H`, `RH.A.POST10.12H`, `RH.G80.POST10.12H`, `RH.G90.POST10.12H`, `RH.A.POST14.12H`, `RH.A.POST14.24H`, `RH.G80.POST14.12H`, `RH.G90.POST14.12H`, `RH.A.POST15.12H`, `RH.A.POST15.24H`, `RH.G80.POST15.12H`, `RH.G90.POST15.12H`, `T.A.PRE5.24H`, `T.9T30.PRE5.24H`, `T.15T30.PRE5.24H`, `T.L9.PRE5.24H`, `T.L15.PRE5.24H`, `T.G30.PRE5.24H`, `T.A.PRE7.24H`, `T.9T30.PRE7.24H`, `T.L9.PRE7.24H`, `T.L15.PRE7.24H`, `T.G30.PRE7.24H`, `T.A.PRE10.24H`, `T.9T30.PRE10.24H`, `T.15T30.PRE10.24H`, `T.L9.PRE10.24H`, `T.L15.PRE10.24H`, `T.G30.PRE10.24H`, `T.A.PRE14.24H`, `T.9T30.PRE14.24H`, `T.15T30.PRE14.24H`, `T.L9.PRE14.24H`, `T.L15.PRE14.24H`, `T.G30.PRE14.24H`, `T.A.PRE15.24H`, `T.9T30.PRE15.24H`, `T.15T30.PRE15.24H`, `T.L9.PRE15.24H`, `T.L15.PRE15.24H`, `T.G30.PRE15.24H`, `T.A.POST5.24H`, `T.9T30.POST5.24H`, `T.15T30.POST5.24H`, `T.L9.POST5.24H`, `T.L15.POST5.24H`, `T.G30.POST5.24H`, `T.A.POST7.24H`, `T.9T30.POST7.24H`, `T.15T30.POST7.24H`, `T.L9.POST7.24H`, `T.L15.POST7.24H`, `T.G30.POST7.24H`, `T.9T30.POST10.24H`, `T.L9.POST10.24H`, `T.L15.POST10.24H`, `T.G30.POST10.24H`, `T.A.POST14.24H`, `T.9T30.POST14.24H`, `T.15T30.POST14.24H`, `T.L9.POST14.24H`, `T.L15.POST14.24H`, `T.G30.POST14.24H`, `T.A.POST15.24H`, `T.9T30.POST15.24H`, `T.15T30.POST15.24H`, `T.L9.POST15.24H`, `T.L15.POST15.24H`, `T.G30.POST15.24H`, `TRH.9T30nRHG80.PRE5.12H`, `TRH.9T30nRHG90.PRE5.12H`, `TRH.15T30nRHG80.PRE5.12H`, `TRH.15T30nRHG90.PRE5.12H`, `TRH.9T30nRHG80.PRE7.12H`, `TRH.9T30nRHG90.PRE7.12H`, `TRH.15T30nRHG80.PRE7.12H`, `TRH.15T30nRHG90.PRE7.12H`, `TRH.9T30nRHG80.PRE10.12H`, `TRH.9T30nRHG90.PRE10.12H`, `TRH.15T30nRHG80.PRE10.12H`, `TRH.15T30nRHG90.PRE10.12H`, `TRH.9T30nRHG80.PRE14.12H`, `TRH.9T30nRHG90.PRE14.12H`, `TRH.15T30nRHG80.PRE14.12H`, `TRH.15T30nRHG90.PRE14.12H`, `TRH.9T30nRHG80.PRE15.12H`, `TRH.9T30nRHG90.PRE15.12H`, `TRH.15T30nRHG80.PRE15.12H`, `TRH.15T30nRHG90.PRE15.12H`, `TRH.9T30nRHG80.POST5.12H`, `TRH.9T30nRHG90.POST5.12H`, `TRH.15T30nRHG80.POST5.12H`, `TRH.15T30nRHG90.POST5.12H`, `TRH.9T30nRHG80.POST7.12H`, `TRH.9T30nRHG90.POST7.12H`, `TRH.15T30nRHG80.POST7.12H`, `TRH.15T30nRHG90.POST7.12H`, `TRH.9T30nRHG80.POST10.12H`, `TRH.9T30nRHG90.POST10.12H`, `TRH.15T30nRHG80.POST10.12H`, `TRH.15T30nRHG90.POST10.12H`, `TRH.9T30nRHG80.POST14.12H`, `TRH.9T30nRHG90.POST14.12H`, `TRH.15T30nRHG80.POST14.12H`, `TRH.15T30nRHG90.POST14.12H`, `TRH.9T30nRHG80.POST15.12H`, `TRH.9T30nRHG90.POST15.12H`, `TRH.15T30nRHG80.POST15.12H`, `TRH.15T30nRHG90.POST15.12H`, `TRH.9T30nRHG80.PRE5.24H`, `TRH.9T30nRHG90.PRE5.24H`, `TRH.15T30nRHG80.PRE5.24H`, `TRH.15T30nRHG90.PRE5.24H`, `TRH.9T30nRHG80.PRE7.24H`, `TRH.9T30nRHG90.PRE7.24H`, `TRH.9T30nRHG80.PRE10.24H`, `TRH.9T30nRHG90.PRE10.24H`, `TRH.15T30nRHG80.PRE10.24H`, `TRH.15T30nRHG90.PRE10.24H`, `TRH.9T30nRHG80.PRE14.24H`, `TRH.9T30nRHG90.PRE14.24H`, `TRH.15T30nRHG80.PRE14.24H`, `TRH.15T30nRHG90.PRE14.24H`, `TRH.9T30nRHG80.PRE15.24H`, `TRH.9T30nRHG90.PRE15.24H`, `TRH.15T30nRHG80.PRE15.24H`, `TRH.15T30nRHG90.PRE15.24H`, `TRH.9T30nRHG80.POST5.24H`, `TRH.9T30nRHG90.POST5.24H`, `TRH.15T30nRHG80.POST5.24H`, `TRH.15T30nRHG90.POST5.24H`, `TRH.9T30nRHG80.POST7.24H`, `TRH.9T30nRHG90.POST7.24H`, `TRH.15T30nRHG80.POST7.24H`, `TRH.15T30nRHG90.POST7.24H`, `TRH.9T30nRHG80.POST10.24H`, `TRH.9T30nRHG90.POST10.24H`, `TRH.9T30nRHG80.POST14.24H`, `TRH.9T30nRHG90.POST14.24H`, `TRH.15T30nRHG80.POST14.24H`, `TRH.15T30nRHG90.POST14.24H`, `TRH.9T30nRHG80.POST15.24H`, `TRH.9T30nRHG90.POST15.24H`, `TRH.15T30nRHG80.POST15.24H`, `TRH.15T30nRHG90.POST15.24H`, `sq.T.A.PRE7.24H`, `wc`
- Candidate X count in local artifact: 335
- Candidate X typology: continuous, categorical
- Published X variables from paper: resist (4 niveaux de resistance varietale : VS/S/MS/MR), wc (type ble : sw=printemps, wwc=hiver+residus mais, wwnoc=hiver sans residus mais), corn (presence de residus de mais dans la parcelle), 340 variables meteo candidates (temperature, point de rosee, pression, humidite relative, deficit de pression de vapeur -- Section 2.1 de FHBEnsemblesCode.html), differentes selon chacun des 39 modeles de base
- Published X count: 4
- Coordinates (x, y - excluded from X candidates): `lon`, `lat`
- Identifier columns (excluded from X candidates): `id`, `state`, `location`
- Variables inspected: yes (auto - generate_fiches_papers.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `S` | `numeric` | continuous | [0, 86.18] | 0% |
| `Class` | `character` | categorical | n/a | 0% |

> Selection Y/X (paper-loader / curated evidence) : Pour `fhb_ensembling`, la ou les reponses `S`, `Class` viennent du loader papier et/ou des preuves de l article `Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models`. Les covariables X retenues sont `resist`, `wc`, `corn`, `type` ; 331 autres colonnes candidates restent listees dans Detail X mais ne sont pas retenues dans formula_used. Les coordonnees (`lon`, `lat`), identifiants (`id`, `state`, `location`), geometries et champs techniques sont exclus de X. Statut benchmark actuel : ready ; la promotion package reste conditionnee au bloc benchmark_readiness.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `year` | `integer` | count | 0% |
| `type` | `character` | categorical | 0% |
| `resist` | `character` | categorical | 0% |
| `corn` | `integer` | binary | 0.4% |
| `T.A.1` | `numeric` | continuous | 0% |
| `T.A.2` | `numeric` | continuous | 0% |
| `T.A.3` | `numeric` | continuous | 0% |
| `T.A.4` | `numeric` | continuous | 0% |
| `T.A.5` | `numeric` | continuous | 0% |
| `D.A.1` | `numeric` | continuous | 0% |
| `D.A.2` | `numeric` | continuous | 0% |
| `D.A.3` | `numeric` | continuous | 0% |
| `P.A.1` | `numeric` | continuous | 0% |
| `P.A.2` | `numeric` | continuous | 0% |
| `P.A.3` | `numeric` | continuous | 0% |
| `P.A.4` | `numeric` | continuous | 0% |
| `P.A.5` | `numeric` | continuous | 0% |
| `RH.A.1` | `numeric` | continuous | 0% |
| `RH.A.2` | `numeric` | continuous | 0% |
| `RH.A.3` | `numeric` | continuous | 0% |
| `VPD.A.1` | `numeric` | continuous | 0% |
| `VPD.A.2` | `numeric` | continuous | 0% |
| `VPD.A.3` | `numeric` | continuous | 0% |
| `VPD.A.4` | `numeric` | continuous | 0% |
| `VPD.A.5` | `numeric` | continuous | 0% |
| `TDD.A.1` | `numeric` | continuous | 0% |
| `TDD.A.2` | `numeric` | continuous | 0% |
| `TDD.A.3` | `numeric` | continuous | 0% |
| `TDD.A.4` | `numeric` | continuous | 0% |
| `TDD.A.5` | `numeric` | continuous | 0% |
| `TDD.A.6` | `numeric` | continuous | 0% |
| `RH.G80.CHD.1` | `integer` | count | 0% |
| `RH.G80.CHD.2` | `integer` | count | 0% |
| `RH.G80.CHD.3` | `integer` | count | 0% |
| `RH.G90.CHD.1` | `integer` | count | 0% |
| `RH.G90.CHD.2` | `integer` | count | 0% |
| `RH.G90.CHD.3` | `integer` | count | 0% |
| `T.G30.CHD.1` | `integer` | count | 0% |
| `T.G30.CHD.2` | `integer` | count | 0% |
| `T.G30.CHD.3` | `integer` | count | 0% |
| `TRH.15T30nRHG80.CHD.1` | `integer` | count | 0% |
| `TRH.15T30nRHG80.CHD.2` | `integer` | count | 0% |
| `TRH.15T30nRHG80.CHD.3` | `integer` | count | 0% |
| `TRH.15T30nRHG90.CHD.1` | `integer` | count | 0% |
| `TRH.15T30nRHG90.CHD.2` | `integer` | count | 0% |
| `TRH.15T30nRHG90.CHD.3` | `integer` | count | 0% |
| `TRH.20T25nRHG85.CHD.1` | `integer` | count | 0% |
| `TRH.5T30nRHG75.CHD.1` | `integer` | count | 0% |
| `TRH.5T30nRHG75.CHD.2` | `integer` | count | 0% |
| `TRH.5T30nRHG75.CHD.3` | `integer` | count | 0% |
| `TRH.9T30nRHG90.CHD.1` | `integer` | count | 0% |
| `TRH.9T30nRHG90.CHD.2` | `integer` | count | 0% |
| `VPD.L11.CHD.1` | `integer` | count | 0% |
| `VPD.L11.CHD.2` | `integer` | count | 0% |
| `VPD.L635.CHD.1` | `integer` | count | 0% |
| `VPD.L635.CHD.2` | `integer` | count | 0% |
| `RH.G70.CD.1` | `integer` | count | 0% |
| `RH.G70.CD.2` | `integer` | count | 0% |
| `RH.G70.CD.3` | `integer` | count | 0% |
| `T.14T22.CD.1` | `integer` | count | 0% |
| `T.14T22.CD.2` | `integer` | count | 0% |
| `VPD.L6.CD.1` | `integer` | count | 0% |
| `VPD.L6.CD.2` | `integer` | count | 0% |
| `VPD.L6.CD.3` | `integer` | count | 0% |
| `T.MINMAXDIFF.1` | `numeric` | continuous | 0% |
| `T.MINMAXDIFF.2` | `numeric` | continuous | 0% |
| `RH.MINMAXDIFF.1` | `numeric` | continuous | 0% |
| `RH.MINMAXDIFF.2` | `numeric` | continuous | 0% |
| `RH.MINMAXDIFF.3` | `numeric` | continuous | 0% |
| `P.MINMAXDIFF.1` | `numeric` | continuous | 0% |
| `D.MINMAXDIFF.1` | `numeric` | continuous | 0% |
| `D.MINMAXDIFF.2` | `numeric` | continuous | 0% |
| `D.MINMAXDIFF.3` | `numeric` | continuous | 0% |
| `VPD.MINMAXDIFF.1` | `numeric` | continuous | 0% |
| `VPD.MINMAXDIFF.2` | `numeric` | continuous | 0% |
| `VPD.MINMAXDIFF.3` | `numeric` | continuous | 0% |
| `TDD.MINMAXDIFF.1` | `numeric` | continuous | 0% |
| `TDD.MINMAXDIFF.2` | `numeric` | continuous | 0% |
| `TDD.MINMAXDIFF.3` | `numeric` | continuous | 0% |
| `T.SD.1` | `numeric` | continuous | 0% |
| `T.SD.2` | `numeric` | continuous | 0% |
| `T.SD.3` | `numeric` | continuous | 0% |
| `D.SD.1` | `numeric` | continuous | 0% |
| `D.SD.2` | `numeric` | continuous | 0% |
| `D.SD.3` | `numeric` | continuous | 0% |
| `P.SD.1` | `numeric` | continuous | 0% |
| `VPD.SD.1` | `numeric` | continuous | 0% |
| `VPD.SD.2` | `numeric` | rate | 0% |
| `VPD.SD.3` | `numeric` | rate | 0% |
| `VPD.SD.4` | `numeric` | rate | 0% |
| `RH.SD.1` | `numeric` | continuous | 0% |
| `RH.SD.2` | `numeric` | continuous | 0% |
| `TDD.SD.1` | `numeric` | continuous | 0% |
| `TDD.SD.2` | `numeric` | continuous | 0% |
| `TDD.SD.3` | `numeric` | continuous | 0% |
| `TDD.SD.4` | `numeric` | continuous | 0% |
| `MT7` | `numeric` | continuous | 0% |
| `T157` | `integer` | count | 0% |
| `T15307` | `integer` | count | 0% |
| `RH7` | `numeric` | continuous | 0% |
| `RH907` | `integer` | count | 0% |
| `TRH907` | `integer` | count | 0% |
| `TRH807` | `integer` | count | 0% |
| `MT10` | `numeric` | continuous | 0% |
| `T1510` | `integer` | count | 0% |
| `T153010` | `integer` | count | 0% |
| `RH10` | `numeric` | continuous | 0% |
| `RH9010` | `integer` | count | 0% |
| `RH8010` | `integer` | count | 0% |
| `TRH9010` | `integer` | count | 0% |
| `TRH8010` | `integer` | count | 0% |
| `INT3` | `integer` | count | 0% |
| `VPD.A.PRE5.12H` | `numeric` | continuous | 0% |
| `VPD.L20.PRE5.12H` | `integer` | count | 0% |
| `VPD.L45.PRE5.12H` | `integer` | count | 0% |
| `VPD.A.PRE7.12H` | `numeric` | continuous | 0% |
| `VPD.L20.PRE7.12H` | `integer` | count | 0% |
| `VPD.L45.PRE7.12H` | `integer` | count | 0% |
| `VPD.A.PRE10.12H` | `numeric` | continuous | 0% |
| `VPD.L20.PRE10.12H` | `integer` | count | 0% |
| `VPD.L45.PRE10.12H` | `integer` | count | 0% |
| `VPD.A.PRE14.12H` | `numeric` | continuous | 0% |
| `VPD.L20.PRE14.12H` | `integer` | count | 0% |
| `VPD.L45.PRE14.12H` | `integer` | count | 0% |
| `VPD.A.PRE15.12H` | `numeric` | continuous | 0% |
| `VPD.L20.PRE15.12H` | `integer` | count | 0% |
| `VPD.L45.PRE15.12H` | `integer` | count | 0% |
| `VPD.A.POST5.12H` | `numeric` | continuous | 0% |
| `VPD.L20.POST5.12H` | `integer` | count | 0% |
| `VPD.L45.POST5.12H` | `integer` | count | 0% |
| `VPD.A.POST7.12H` | `numeric` | continuous | 0% |
| `VPD.L20.POST7.12H` | `integer` | count | 0% |
| `VPD.L45.POST7.12H` | `integer` | count | 0% |
| `VPD.A.POST10.12H` | `numeric` | continuous | 0% |
| `VPD.L20.POST10.12H` | `integer` | count | 0% |
| `VPD.L45.POST10.12H` | `integer` | count | 0% |
| `VPD.A.POST14.12H` | `numeric` | continuous | 0% |
| `VPD.L20.POST14.12H` | `integer` | count | 0% |
| `VPD.L45.POST14.12H` | `integer` | count | 0% |
| `VPD.A.POST15.12H` | `numeric` | continuous | 0% |
| `VPD.L20.POST15.12H` | `integer` | count | 0% |
| `VPD.L45.POST15.12H` | `integer` | count | 0% |
| `DD.A.PRE5.12H` | `numeric` | continuous | 0% |
| `DD.L1.PRE5.12H` | `integer` | count | 0% |
| `DD.A.PRE7.12H` | `numeric` | continuous | 0% |
| `DD.L1.PRE7.12H` | `integer` | count | 0% |
| `DD.A.PRE10.12H` | `numeric` | continuous | 0% |
| `DD.L1.PRE10.12H` | `integer` | count | 0% |
| `DD.A.PRE14.12H` | `numeric` | continuous | 0% |
| `DD.L1.PRE14.12H` | `integer` | count | 0% |
| `DD.A.PRE15.12H` | `numeric` | continuous | 0% |
| `DD.L1.PRE15.12H` | `integer` | count | 0% |
| `DD.A.POST5.12H` | `numeric` | continuous | 0% |
| `DD.L1.POST5.12H` | `integer` | count | 0% |
| `DD.A.POST7.12H` | `numeric` | continuous | 0% |
| `DD.L1.POST7.12H` | `integer` | count | 0% |
| `DD.A.POST10.12H` | `numeric` | continuous | 0% |
| `DD.L1.POST10.12H` | `integer` | count | 0% |
| `DD.A.POST14.12H` | `numeric` | continuous | 0% |
| `DD.L1.POST14.12H` | `integer` | count | 0% |
| `DD.A.POST15.12H` | `numeric` | continuous | 0% |
| `DD.L1.POST15.12H` | `integer` | count | 0% |
| `RH.A.PRE5.12H` | `numeric` | continuous | 0% |
| `RH.A.PRE5.24H` | `numeric` | continuous | 0% |
| `RH.G80.PRE5.12H` | `integer` | count | 0% |
| `RH.G90.PRE5.12H` | `integer` | count | 0% |
| `RH.A.PRE7.12H` | `numeric` | continuous | 0% |
| `RH.G80.PRE7.12H` | `integer` | count | 0% |
| `RH.G90.PRE7.12H` | `integer` | count | 0% |
| `RH.A.PRE10.12H` | `numeric` | continuous | 0% |
| `RH.A.PRE10.24H` | `numeric` | continuous | 0% |
| `RH.G80.PRE10.12H` | `integer` | count | 0% |
| `RH.G90.PRE10.12H` | `integer` | count | 0% |
| `RH.A.PRE14.12H` | `numeric` | continuous | 0% |
| `RH.A.PRE14.24H` | `numeric` | continuous | 0% |
| `RH.G80.PRE14.12H` | `integer` | count | 0% |
| `RH.G90.PRE14.12H` | `integer` | count | 0% |
| `RH.A.PRE15.12H` | `numeric` | continuous | 0% |
| `RH.A.PRE15.24H` | `numeric` | continuous | 0% |
| `RH.G80.PRE15.12H` | `integer` | count | 0% |
| `RH.G90.PRE15.12H` | `integer` | count | 0% |
| `RH.A.POST5.12H` | `numeric` | continuous | 0% |
| `RH.A.POST5.24H` | `numeric` | continuous | 0% |
| `RH.G80.POST5.12H` | `integer` | count | 0% |
| `RH.G90.POST5.12H` | `integer` | count | 0% |
| `RH.A.POST7.12H` | `numeric` | continuous | 0% |
| `RH.A.POST7.24H` | `numeric` | continuous | 0% |
| `RH.G80.POST7.12H` | `integer` | count | 0% |
| `RH.G90.POST7.12H` | `integer` | count | 0% |
| `RH.A.POST10.12H` | `numeric` | continuous | 0% |
| `RH.G80.POST10.12H` | `integer` | count | 0% |
| `RH.G90.POST10.12H` | `integer` | count | 0% |
| `RH.A.POST14.12H` | `numeric` | continuous | 0% |
| `RH.A.POST14.24H` | `numeric` | continuous | 0% |
| `RH.G80.POST14.12H` | `integer` | count | 0% |
| `RH.G90.POST14.12H` | `integer` | count | 0% |
| `RH.A.POST15.12H` | `numeric` | continuous | 0% |
| `RH.A.POST15.24H` | `numeric` | continuous | 0% |
| `RH.G80.POST15.12H` | `integer` | count | 0% |
| `RH.G90.POST15.12H` | `integer` | count | 0% |
| `T.A.PRE5.24H` | `numeric` | continuous | 0% |
| `T.9T30.PRE5.24H` | `integer` | count | 0% |
| `T.15T30.PRE5.24H` | `integer` | count | 0% |
| `T.L9.PRE5.24H` | `integer` | count | 0% |
| `T.L15.PRE5.24H` | `integer` | count | 0% |
| `T.G30.PRE5.24H` | `integer` | count | 0% |
| `T.A.PRE7.24H` | `numeric` | continuous | 0% |
| `T.9T30.PRE7.24H` | `integer` | count | 0% |
| `T.L9.PRE7.24H` | `integer` | count | 0% |
| `T.L15.PRE7.24H` | `integer` | count | 0% |
| `T.G30.PRE7.24H` | `integer` | count | 0% |
| `T.A.PRE10.24H` | `numeric` | continuous | 0% |
| `T.9T30.PRE10.24H` | `integer` | count | 0% |
| `T.15T30.PRE10.24H` | `integer` | count | 0% |
| `T.L9.PRE10.24H` | `integer` | count | 0% |
| `T.L15.PRE10.24H` | `integer` | count | 0% |
| `T.G30.PRE10.24H` | `integer` | count | 0% |
| `T.A.PRE14.24H` | `numeric` | continuous | 0% |
| `T.9T30.PRE14.24H` | `integer` | count | 0% |
| `T.15T30.PRE14.24H` | `integer` | count | 0% |
| `T.L9.PRE14.24H` | `integer` | count | 0% |
| `T.L15.PRE14.24H` | `integer` | count | 0% |
| `T.G30.PRE14.24H` | `integer` | count | 0% |
| `T.A.PRE15.24H` | `numeric` | continuous | 0% |
| `T.9T30.PRE15.24H` | `integer` | count | 0% |
| `T.15T30.PRE15.24H` | `integer` | count | 0% |
| `T.L9.PRE15.24H` | `integer` | count | 0% |
| `T.L15.PRE15.24H` | `integer` | count | 0% |
| `T.G30.PRE15.24H` | `integer` | count | 0% |
| `T.A.POST5.24H` | `numeric` | continuous | 0% |
| `T.9T30.POST5.24H` | `integer` | count | 0% |
| `T.15T30.POST5.24H` | `integer` | count | 0% |
| `T.L9.POST5.24H` | `integer` | count | 0% |
| `T.L15.POST5.24H` | `integer` | count | 0% |
| `T.G30.POST5.24H` | `integer` | count | 0% |
| `T.A.POST7.24H` | `numeric` | continuous | 0% |
| `T.9T30.POST7.24H` | `integer` | count | 0% |
| `T.15T30.POST7.24H` | `integer` | count | 0% |
| `T.L9.POST7.24H` | `integer` | count | 0% |
| `T.L15.POST7.24H` | `integer` | count | 0% |
| `T.G30.POST7.24H` | `integer` | count | 0% |
| `T.9T30.POST10.24H` | `integer` | count | 0% |
| `T.L9.POST10.24H` | `integer` | count | 0% |
| `T.L15.POST10.24H` | `integer` | count | 0% |
| `T.G30.POST10.24H` | `integer` | count | 0% |
| `T.A.POST14.24H` | `numeric` | continuous | 0% |
| `T.9T30.POST14.24H` | `integer` | count | 0% |
| `T.15T30.POST14.24H` | `integer` | count | 0% |
| `T.L9.POST14.24H` | `integer` | count | 0% |
| `T.L15.POST14.24H` | `integer` | count | 0% |
| `T.G30.POST14.24H` | `integer` | count | 0% |
| `T.A.POST15.24H` | `numeric` | continuous | 0% |
| `T.9T30.POST15.24H` | `integer` | count | 0% |
| `T.15T30.POST15.24H` | `integer` | count | 0% |
| `T.L9.POST15.24H` | `integer` | count | 0% |
| `T.L15.POST15.24H` | `integer` | count | 0% |
| `T.G30.POST15.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE5.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE5.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE5.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE5.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE7.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE7.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE7.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE7.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE10.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE10.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE10.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE10.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE14.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE14.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE14.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE14.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE15.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE15.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE15.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE15.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST5.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST5.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST5.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST5.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST7.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST7.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST7.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST7.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST10.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST10.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST10.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST10.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST14.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST14.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST14.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST14.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST15.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST15.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST15.12H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST15.12H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE5.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE5.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE5.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE5.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE7.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE7.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE10.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE10.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE10.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE10.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE14.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE14.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE14.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE14.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.PRE15.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.PRE15.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.PRE15.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.PRE15.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST5.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST5.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST5.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST5.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST7.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST7.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST7.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST7.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST10.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST10.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST14.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST14.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST14.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST14.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG80.POST15.24H` | `integer` | count | 0% |
| `TRH.9T30nRHG90.POST15.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG80.POST15.24H` | `integer` | count | 0% |
| `TRH.15T30nRHG90.POST15.24H` | `integer` | count | 0% |
| `sq.T.A.PRE7.24H` | `numeric` | continuous | 0% |
| `wc` | `character` | categorical | 0% |

### Formule - niveau publication

- formula_pub: Class ~ resist + wc + [sous-ensemble de variables meteo, variable selon le modele] [39 modeles de regression logistique de base (M1-M39), issus de 4 papiers anterieurs (DeWolf 2003, Shah 2013/2014/2019) + 20 nouveaux modeles, ensembles via vote souple, moyenne ponderee, et stacking (ridge/lasso/elastic-net) -- le papier evalue l'ensembling de modeles simples mais fortement correles]
- x_terms_pub: resist (4 niveaux de resistance varietale : VS/S/MS/MR), wc (type ble : sw=printemps, wwc=hiver+residus mais, wwnoc=hiver sans residus mais), corn (presence de residus de mais dans la parcelle), 340 variables meteo candidates (temperature, point de rosee, pression, humidite relative, deficit de pression de vapeur -- Section 2.1 de FHBEnsemblesCode.html), differentes selon chacun des 39 modeles de base
- y_term_pub: Class (classification binaire epidemie/non-epidemie de fusariose de l'epi, seuil sur S) ; S (indice de severite FHB continu, %, 0-100) disponible comme variante continue directement dans les donnees
- Reference publication: Shah, D.A., De Wolf, E.D., Paul, P.A. & Madden, L.V. (2021), Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models, PLOS Computational Biology 17(3): e1008831, doi:10.1371/journal.pcbi.1008831 -- DOI corrige manuellement le 2026-08-16 (le lien isCitedBy du depot pointait par erreur vers un papier de methodologie anterieur de 2013, pas le papier source ; verifie via le README du depot FHBEnsemblesReadMe.txt + recherche web). EnsemblesMainData.csv (999 observations, panel non-equilibre de 80 sites x jusqu'a 32 ans, 1982-2015) telecharge directement depuis Dryad (10.5061/dryad.fn2z34trv, isCitedBy le papier de methodologie) -- pas une reconstruction. Le depot ne contient aucune coordonnee (verifie: ni CSV, ni script Rmd) ; les 80 couples (state, location) ont ete geocodes via l'API publique Nominatim/OpenStreetMap (69/80 resolus, 14 lignes exclues faute de correspondance, jamais de coordonnee inventee). formula_used se limite aux covariables categorielles bien documentees (resist/wc/corn/type) plutot qu'a l'un des 39 modeles meteo specifiques du papier, puisqu'il n'existe pas 'une' formule unique -- les 340 variables meteo candidates restent disponibles dans l'artefact local pour toute selection de variables ulterieure.

### Statut regression canonique

- Statut: resolu
- Niveau de preuve: publication
- Methode d estimation: formule publication confirmee et utilisee
- Correspondance Python/R: aucune identifiee
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Shah, D.A., De Wolf, E.D., Paul, P.A. & Madden, L.V. (2021), Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models, PLOS Computational Biology 17(3): e1008831, doi:10.1371/journal.pcbi.1008831 -- DOI corrige manuellement le 2026-08-16 (le lien isCitedBy du depot pointait par erreur vers un papier de methodologie anterieur de 2013, pas le papier source ; verifie via le README du depot FHBEnsemblesReadMe.txt + recherche web). EnsemblesMainData.csv (999 observations, panel non-equilibre de 80 sites x jusqu'a 32 ans, 1982-2015) telecharge directement depuis Dryad (10.5061/dryad.fn2z34trv, isCitedBy le papier de methodologie) -- pas une reconstruction. Le depot ne contient aucune coordonnee (verifie: ni CSV, ni script Rmd) ; les 80 couples (state, location) ont ete geocodes via l'API publique Nominatim/OpenStreetMap (69/80 resolus, 14 lignes exclues faute de correspondance, jamais de coordonnee inventee). formula_used se limite aux covariables categorielles bien documentees (resist/wc/corn/type) plutot qu'a l'un des 39 modeles meteo specifiques du papier, puisqu'il n'existe pas 'une' formule unique -- les 340 variables meteo candidates restent disponibles dans l'artefact local pour toute selection de variables ulterieure.

### Formule - niveau systeme

- formula_used: S ~ resist + wc + corn + type
- x_terms_used: resist, wc, corn, type
- y_term_used: S
- Note: Formule/reference verifiee par lecture directe du papier source (session du 2026-08-16). Shah, D.A., De Wolf, E.D., Paul, P.A. & Madden, L.V. (2021), Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models, PLOS Computational Biology 17(3): e1008831, doi:10.1371/journal.pcbi.1008831 -- DOI corrige manuellement le 2026-08-16 (le lien isCitedBy du depot pointait par erreur vers un papier de methodologie anterieur de 2013, pas le papier source ; verifie via le README du depot FHBEnsemblesReadMe.txt + recherche web). EnsemblesMainData.csv (999 observations, panel non-equilibre de 80 sites x jusqu'a 32 ans, 1982-2015) telecharge directement depuis Dryad (10.5061/dryad.fn2z34trv, isCitedBy le papier de methodologie) -- pas une reconstruction. Le depot ne contient aucune coordonnee (verifie: ni CSV, ni script Rmd) ; les 80 couples (state, location) ont ete geocodes via l'API publique Nominatim/OpenStreetMap (69/80 resolus, 14 lignes exclues faute de correspondance, jamais de coordonnee inventee). formula_used se limite aux covariables categorielles bien documentees (resist/wc/corn/type) plutot qu'a l'un des 39 modeles meteo specifiques du papier, puisqu'il n'existe pas 'une' formule unique -- les 340 variables meteo candidates restent disponibles dans l'artefact local pour toute selection de variables ulterieure.

### Formules candidates

```yaml
formula_candidates:
  univariate:
    formula: "pending"
    response: "pending"
    predictors: []
    role: "simple_baseline"
    source_type: "none_found"
    source_ref: "pending"
    estimator_context: []
    status: "unavailable"

  multivariate_constrained:
    formula: "S ~ resist + wc + corn + type"
    response: "Class (classification binaire epidemie/non-epidemie de fusariose de l'epi, seuil sur S) ; S (indice de severite FHB continu, %, 0-100) disponible comme variante continue directement dans les donnees"
    predictors: ["resist (4 niveaux de resistance varietale : VS/S/MS/MR)", "wc (type ble : sw=printemps, wwc=hiver+residus mais, wwnoc=hiver sans residus mais)", "corn (presence de residus de mais dans la parcelle)", "340 variables meteo candidates (temperature, point de rosee, pression, humidite relative, deficit de pression de vapeur -- Section 2.1 de FHBEnsemblesCode.html), differentes selon chacun des 39 modeles de base"]
    role: "paper_main_specification"
    source_type: "scientific_publication"
    source_ref: "Shah, D.A., De Wolf, E.D., Paul, P.A. & Madden, L.V. (2021), Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models, PLOS Computational Biology 17(3): e1008831, doi:10.1371/journal.pcbi.1008831 -- DOI corrige manuellement le 2026-08-16 (le lien isCitedBy du depot pointait par erreur vers un papier de methodologie anterieur de 2013, pas le papier source ; verifie via le README du depot FHBEnsemblesReadMe.txt + recherche web). EnsemblesMainData.csv (999 observations, panel non-equilibre de 80 sites x jusqu'a 32 ans, 1982-2015) telecharge directement depuis Dryad (10.5061/dryad.fn2z34trv, isCitedBy le papier de methodologie) -- pas une reconstruction. Le depot ne contient aucune coordonnee (verifie: ni CSV, ni script Rmd) ; les 80 couples (state, location) ont ete geocodes via l'API publique Nominatim/OpenStreetMap (69/80 resolus, 14 lignes exclues faute de correspondance, jamais de coordonnee inventee). formula_used se limite aux covariables categorielles bien documentees (resist/wc/corn/type) plutot qu'a l'un des 39 modeles meteo specifiques du papier, puisqu'il n'existe pas 'une' formule unique -- les 340 variables meteo candidates restent disponibles dans l'artefact local pour toute selection de variables ulterieure."
    estimator_context: ["ols", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
    status: "confirmed"

  ml_or_selected:
    formula: "S ~ resist + wc + corn + type"
    response: "S"
    predictors: ["resist", "wc", "corn", "type"]
    role: "ml_candidate_features"
    source_type: "scientific_publication"
    source_ref: "Shah, D.A., De Wolf, E.D., Paul, P.A. & Madden, L.V. (2021), Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models, PLOS Computational Biology 17(3): e1008831, doi:10.1371/journal.pcbi.1008831 -- DOI corrige manuellement le 2026-08-16 (le lien isCitedBy du depot pointait par erreur vers un papier de methodologie anterieur de 2013, pas le papier source ; verifie via le README du depot FHBEnsemblesReadMe.txt + recherche web). EnsemblesMainData.csv (999 observations, panel non-equilibre de 80 sites x jusqu'a 32 ans, 1982-2015) telecharge directement depuis Dryad (10.5061/dryad.fn2z34trv, isCitedBy le papier de methodologie) -- pas une reconstruction. Le depot ne contient aucune coordonnee (verifie: ni CSV, ni script Rmd) ; les 80 couples (state, location) ont ete geocodes via l'API publique Nominatim/OpenStreetMap (69/80 resolus, 14 lignes exclues faute de correspondance, jamais de coordonnee inventee). formula_used se limite aux covariables categorielles bien documentees (resist/wc/corn/type) plutot qu'a l'un des 39 modeles meteo specifiques du papier, puisqu'il n'existe pas 'une' formule unique -- les 340 variables meteo candidates restent disponibles dans l'artefact local pour toute selection de variables ulterieure."
    estimator_context: ["logistic_regression", "random_forest", "gwr", "stacking_ensemble"]
    status: "executable_continuous_variant"
```

## Bloc 2 - Identification et DOI

- Dataset ID: `paper_fhb_ensembling`
- Dataset name: Data from: Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models
- Source family: paper-derived
- Source: papier scientifique (voir Paper DOI)
- Paper title: Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models
- Paper DOI: 10.1371/journal.pcbi.1008831
- Dataset DOI: 10.5061/dryad.fn2z34trv
- Source URL: https://doi.org/10.5061/dryad.fn2z34trv
- Year: unknown

## Bloc 3 - Typologie des modeles

- Modele niveau 1 (tache): regression / modele spatial (voir formula_pub)
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "Class ~ resist + wc + [sous-ensemble de variables meteo, variable selon le modele] [39 modeles de regression logistique de base (M1-M39), issus de 4 papiers anterieurs (DeWolf 2003, Shah 2013/2014/2019) + 20 nouveaux modeles, ensembles via vote souple, moyenne ponderee, et stacking (ridge/lasso/elastic-net) -- le papier evalue l'ensembling de modeles simples mais fortement correles]"
  equation_family: paper_empirical_or_dataset_specific
  model_family: spatial_or_paper_specific_regression
  source_type: scientific_publication_or_package_documentation
  source_ref: "Shah, D.A., De Wolf, E.D., Paul, P.A. & Madden, L.V. (2021), Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models, PLOS Computational Biology 17(3): e1008831, doi:10.1371/journal.pcbi.1008831 -- DOI corrige manuellement le 2026-08-16 (le lien isCitedBy du depot pointait par erreur vers un papier de methodologie anterieur de 2013, pas le papier source ; verifie via le README du depot FHBEnsemblesReadMe.txt + recherche web). EnsemblesMainData.csv (999 observations, panel non-equilibre de 80 sites x jusqu'a 32 ans, 1982-2015) telecharge directement depuis Dryad (10.5061/dryad.fn2z34trv, isCitedBy le papier de methodologie) -- pas une reconstruction. Le depot ne contient aucune coordonnee (verifie: ni CSV, ni script Rmd) ; les 80 couples (state, location) ont ete geocodes via l'API publique Nominatim/OpenStreetMap (69/80 resolus, 14 lignes exclues faute de correspondance, jamais de coordonnee inventee). formula_used se limite aux covariables categorielles bien documentees (resist/wc/corn/type) plutot qu'a l'un des 39 modeles meteo specifiques du papier, puisqu'il n'existe pas 'une' formule unique -- les 340 variables meteo candidates restent disponibles dans l'artefact local pour toute selection de variables ulterieure."
  confidence: medium
```

## Benchmark readiness

```yaml
benchmark_readiness:
  benchmark_status: "ready"
  benchmark_task: "regression_continuous"
  package_include: "yes"
  has_local_rds: true
  missing_items: "aucune coordonnee dans le depot source -- 69/80 localites geocodees via Nominatim/OpenStreetMap (API publique, pas invente), 14/999 lignes exclues faute de correspondance ; formula_used limitee aux covariables categorielles documentees (resist/wc/corn/type), les 340 variables meteo candidates du papier restent dans l'artefact local mais ne sont pas fixees dans une formule unique (39 modeles de base competing dans le papier, pas une specification canonique)"
  reason: "Y continu reel (S, severite FHB %), panel spatio-temporel non-equilibre reel (80 sites x jusqu'a 32 ans), N=985 apres geocodage. CSV original telecharge directement depuis Dryad (isCitedBy le papier de methodologie), pas une reconstruction. Papier correctement identifie apres correction d'une erreur d'attribution du pipeline (isCitedBy pointait vers un papier anterieur), lu integralement (TEI) pour confirmer le cadre d'ensembling de 39 modeles de regression logistique."
```

- Decision: ready
- Manque principal: aucune coordonnee dans le depot source -- 69/80 localites geocodees via Nominatim/OpenStreetMap (API publique, pas invente), 14/999 lignes exclues faute de correspondance ; formula_used limitee aux covariables categorielles documentees (resist/wc/corn/type), les 340 variables meteo candidates du papier restent dans l'artefact local mais ne sont pas fixees dans une formule unique (39 modeles de base competing dans le papier, pas une specification canonique)
- Raison: Y continu reel (S, severite FHB %), panel spatio-temporel non-equilibre reel (80 sites x jusqu'a 32 ans), N=985 apres geocodage. CSV original telecharge directement depuis Dryad (isCitedBy le papier de methodologie), pas une reconstruction. Papier correctement identifie apres correction d'une erreur d'attribution du pipeline (isCitedBy pointait vers un papier anterieur), lu integralement (TEI) pour confirmer le cadre d'ensembling de 39 modeles de regression logistique.

## Estimator eligibility

```yaml
estimator_eligibility:
  status: "ready"
  eligible_estimators: ["ols", "gam_spatial", "gamboost", "random_forest", "random_forest_xy", "xgboost", "xgboost_xy", "sar_lag", "sem_error", "sdm_mixed", "gwr"]
  conditionally_eligible_estimators: []
  ineligible_reason: ""
  rule: "paper fiches are eligible only when response, predictors and coordinates/geometry are executable in the local artifact; local W is optional when it can be reconstructed by the benchmark from spatial support, and blocking only for source-specific non-geographic W"
```

## Bloc 4 - Typologie des donnees

- Data type: spatio-temporel
- Structure: panel_ou_series
- N observations: 985
- k variables: 345
- T periods: 32
- Variable temporelle: year
- N/T profile: N_grand_T_grand
- Note N/T (session 2026-08-17, verification directe du `.rds`) : "N observations" (985) est le nombre total de lignes du panel, pas le nombre d'unites spatiales distinctes. N spatial reel (geometries distinctes) = 66 ; panel NON EQUILIBRE (T par unite : min=1, mediane=5, max=101). Pour tout estimateur spatial explicite (SAR/GWR/BYM/CAR) necessitant une matrice de voisinage W, construire W sur les 66 unites spatiales distinctes, pas sur les 985 lignes du panel -- sinon des coordonnees dupliquees degenerent le calcul de voisinage/distance.

## Bloc 5 - Resolution et etendue

- Type de geometrie: POINT
- Spatial resolution: point observation
- Temporal resolution: 32 distinct periods (variable: year)
- CRS EPSG: 4326
- CRS nom: WGS 84
- Spatial extent: x [-101.296273, -75.3858753], y [32.0784804, 48.7744263]
- Time range: 1982 to 2015 (variable: year)
- CRS analyse recommande: pending - multi-zones (span=25.9deg) -- projection nationale recommandee

## Bloc 6 - Reproductibilite

- License present: unknown
- License name: unknown
- License URL: unknown
- License open: unknown
- Reproducibility status: OK - loader R enregistre et reexecutable (`fhb_ensembling` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.
- Code available: yes (loader `fhb_ensembling` dans `code/r_catalog/build_sf_datasets_papers.R`)
- Repository: paper-derived (voir `inst/kg/paper_dataset_uses.json`)

## Quality Control

- Schema: OK - fiche rendue au format Bloc 1-6 par `generate_fiches_papers.R`.
- Variables: OK - Y et X identifiees depuis le loader (row$candidate_y_variables / colonnes restantes).
- Formula: OK - formule publication renseignee et formula_used executable.
- CRS: OK - CRS renseigne dans le Bloc 5 (4326).
- Geometry: OK - type geometrique controle (POINT).
- Missing values: OK - aucune variable avec NA > 20% detectee.
- Duplicates: OK - aucun doublon exact retenu pour cette fiche.
- Reproducibility: OK - loader R enregistre et reexecutable (`fhb_ensembling` dans build_sf_datasets_papers.R) ; source brute tracee dans inst/kg/paper_dataset_uses.json.

## Related Pages

- [[paper_dataset_ingestion_pipeline_2026-08]]
- Source: Accuracy in the prediction of disease epidemics when ensembling simple but highly correlated models

