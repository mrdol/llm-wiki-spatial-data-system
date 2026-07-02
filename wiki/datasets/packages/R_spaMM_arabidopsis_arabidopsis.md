---
title: R_spaMM_arabidopsis_arabidopsis
type: dataset
created: 2026-06-30
updated: 2026-07-01
sources:
  - data/final_datasets/sf/R_spaMM_arabidopsis_arabidopsis.rds
tags: [dataset, r-package, spatial, point]
---

For 948 “accessions” from European Arabidopsis thaliana populations, this data set merges the genotypic information at four single nucleotide polymorphisms (SNP) putatively involved in adaptation to climate (Fournier-Level et al, 2011, Table 1), with 13 climatic variables from Hancock et al. (2011).

## Bloc 1 — Formule et variables

### Variables (niveau systeme — inspection directe du sf)

- Candidate Y variables: `pos1046738`, `pos5510910`, `pos6235221`, `pos8132698`
- Candidate Y typology: binary
- Candidate X variables: `seasonal`, `tempWarmest`, `tempColdest`, `preciWettest`, `preciDriest`, `preciCV`, `PAR_SPRING`, `growingL`, `conseqCold`, `conseqFrFree`, `RelHumidSp`, `dayLSp`, `aridity`
- Candidate X typology: continuous
- Coordinates (x, y — excluded from X candidates): `LAT`, `LONG`, `X`, `Y`
- Identifier columns (excluded from X candidates): none detected
- Variables inspected: yes (auto — export_sf_metadata.R)
- Presence of imputed X: unknown

#### Detail Y

| Variable | Classe R | Typologie Y | Plage | NA (%) |
|---|---|---|---|---|
| `pos1046738` | `numeric` | binary | {0, 1} | 0% |
| `pos5510910` | `numeric` | binary | {0, 1} | 0% |
| `pos6235221` | `numeric` | binary | {0, 1} | 0% |
| `pos8132698` | `numeric` | binary | {0, 1} | 0% |


> Note doc : response is binary so ‘method="PQL/L"’ seems warranted (see

> Selection Y/X (claude-sonnet-4-6) : Les quatre SNPs binaires (pos*) sont les variables réponses naturelles dans un contexte d'association génotype-environnement (landscape genomics), où l'on cherche à expliquer la variation allélique par des pressions de sélection climatiques. Les 13 variables climatiques (température, précipitations, PAR, humidité, aridité, etc.) constituent les covariables explicatives; la colonne T est exclue car sa plage est identique à dayLSp, suggérant une redondance ou une erreur de données.

#### Detail X

| Variable | Classe R | Role X | NA (%) |
|---|---|---|---|
| `seasonal` | `integer` | count | 0% |
| `tempWarmest` | `integer` | count | 0% |
| `tempColdest` | `integer` | count | 0% |
| `preciWettest` | `integer` | count | 0% |
| `preciDriest` | `integer` | count | 0% |
| `preciCV` | `integer` | count | 0% |
| `PAR_SPRING` | `numeric` | continuous | 0% |
| `growingL` | `integer` | count | 0% |
| `conseqCold` | `numeric` | continuous | 0% |
| `conseqFrFree` | `numeric` | continuous | 0% |
| `RelHumidSp` | `numeric` | continuous | 0% |
| `dayLSp` | `numeric` | continuous | 0% |
| `aridity` | `numeric` | continuous | 0% |


### Formule — niveau publication

- formula_pub: cbind(pos1046738, 1-pos1046738) ~ seasonal + Matern(1|LAT+LONG)
- x_terms_pub: seasonal + Matern(1|LAT+LONG)
- y_term_pub: cbind(pos1046738, 1-pos1046738)
- Reference publication: Fournier-Level A. et al. (2011) A map of local adaptation in Arabidopsis thaliana. Science 334: 86-89. DOI:10.1126/science.1209271

### Statut regression canonique (mission recherche manuelle, juillet 2026)

- Statut: bon candidat
- Niveau de preuve: verbatim
- Methode d'estimation: GLMM binomial geostatistique (Matern), genomique du paysage
- Correspondance Python/R: aucune identifiee
- Note: Formule deja presente (enrichissement anterieur), coherente avec le DOI Bloc 2 ; meme structure applicable aux 3 autres SNP binaires du dataset.

### Formule — niveau systeme

- formula_used: pending
- x_terms_used: pending
- y_term_used: pending

## Bloc 2 — Identification et DOI

- Dataset ID: `R_spaMM_arabidopsis_arabidopsis`
- Dataset name: spaMM::arabidopsis
- Source family: r-package
- Source: package R `spaMM` (version 4.6.65)
- Source URL: https://CRAN.R-project.org/package=spaMM
- Dataset DOI: none
- Publication DOI: 10.1126/science.1209271
- Year: 2013

## Bloc 3 — Typologie des modeles

- Modele niveau 1 (tache): pending
- Modele niveau 2 (famille): pending
- Modele niveau 3 (variante): pending

```yaml
modeling_evidence:
  existing_model_found: true
  equation_text: "cbind(pos1046738, 1-pos1046738) ~ seasonal + Matern(1|LAT+LONG)"
  equation_family: generalized_linear
  model_family: "GLMM binomial geostatistique (Matern), genomique du paysage"
  source_type: software_documentation
  source_ref: "Fournier-Level A. et al. (2011) A map of local adaptation in Arabidopsis thaliana. Science 334: 86-89. DOI:10.1126/science.1209271"
  confidence: high
```

## Bloc 4 — Typologie des donnees

- Data type: spatial
- Structure: coupe_transversale
- N observations: 948
- T periods: 1
- Variable temporelle: none
- N/T profile: N_grand_T_1

## Bloc 5 — Resolution et etendue

- Spatial resolution: point observation
- Temporal resolution: not applicable (cross-sectional dataset)
- Spatial extent: x [-13.4811, 77], y [29.2144, 65.25] (CRS unknown)
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

WARN: CRS absent — lookup EPSG necessaire.

## Related Pages

- Source: package R `spaMM`
