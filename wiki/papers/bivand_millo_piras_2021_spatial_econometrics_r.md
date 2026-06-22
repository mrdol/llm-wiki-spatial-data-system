---
title: Bivand, Millo and Piras 2021 - Software for Spatial Econometrics in R
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/A Review of Software for Spatial Econometrics in R.pdf
  - corpus/papers/tei/A Review of Software for Spatial Econometrics in R.tei.xml
  - doi:10.3390/math9111276
tags: [paper, r, spatial-econometrics, software, sar, sem, sdm, spatial-panel, grobid]
---

# Bivand, Millo and Piras 2021 - Software for Spatial Econometrics in R

This review maps the development and implementation of spatial econometric
methods in R, including cross-sectional and panel models.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: present in `corpus/papers/tei/`
- KG node: `paper:doi:10.3390/math9111276`
- Incremental extraction: parsed into `.kg/extracted/zz_incremental_tei_*`

## Extracted Method

- Main family: [[spatial_regression]]
- Spatial panel component: [[spatial_panel]]
- Software focus: R packages for spatial econometrics
- Method signals: SAR, SEM, SDM, SARAR, GMM, ML estimation, impacts,
  cross-sectional models and spatial panel data models.

## Extracted Formulas

The TEI detected formulas for:

- general spatial econometric model structure;
- spatial lag model;
- spatial error model;
- spatial Durbin-style specifications;
- SARAR-style formulations;
- log-likelihood and determinant terms;
- spatial panel model variants.

Curated umbrella signal:

```math
y = X\beta + \lambda Wy + WX\gamma + u,\quad u = \rho Mu + \varepsilon
```

This paper is a methodological/software review, so formulas are reference
material rather than one single empirical benchmark formula.

## Extracted Datasets And Packages

Package signals extracted by the KG:

- `MASS`
- `plm`
- `spData`
- `splm`

Dataset/example signals:

- `HistData::Jevons`
- `MASS::Insurance`
- `plm::RiceFarms`
- `spData::used.cars`
- `splm::Insurance`
- `splm::RiceFarms`

These should be interpreted as software/example routes, not necessarily as the
central datasets of the review.

## Hyperparameters And Metrics

The paper is not primarily a predictive benchmark paper. It is useful for:

- estimator families;
- estimation routes such as ML and GMM;
- model interpretation via direct/indirect impacts;
- spatial weights and specification choices.

## Code Or Repository

Code/data repository extracted from TEI:

- `https://github.com/rsbivand/BMP21_data`

The paper also points to CRAN as the software distribution route:

- `https://cran.r-project.org`

For this project, it is a strong bridge between papers, R packages, example
datasets and estimator implementation routes.

## Reuse For The Project

This paper should support:

- the R spatial econometrics software map;
- estimator fiches for SAR/SEM/SDM/SARAR and spatial panel models;
- dataset-source tracing through R packages and replication material.

## Related Pages

- [[spatial_regression]]
- [[spatial_panel]]
- [[r_software_datasets]]
