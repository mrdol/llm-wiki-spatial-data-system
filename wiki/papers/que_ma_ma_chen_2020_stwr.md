---
title: Que et al. 2020 - STWR v1.0
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/A spatiotemporal weighted regression model for nontationarity.pdf
  - corpus/papers/tei/A spatiotemporal weighted regression model for nontationarity.tei.xml
  - doi:10.5194/gmd-13-6149-2020
tags: [paper, stwr, gwr, spatio-temporal, formula, benchmark, grobid]
---

# Que et al. 2020 - STWR v1.0

This paper proposes spatiotemporal weighted regression (STWR), a local
regression model designed for nonstationarity in both space and time.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: present in `corpus/papers/tei/`
- KG node: `paper:doi:10.5194/gmd-13-6149-2020`
- Incremental extraction: parsed into `.kg/extracted/zz_incremental_tei_*`

## Extracted Method

- Main method: [[stwr]]
- Parent methods: [[gwr]], GTWR-style space-time local regression
- Calibration: weighted least squares with spatio-temporal kernel weights
- Key controls: spatial bandwidth, temporal distance-decay parameter and
  spatio-temporal kernel definition
- Optimization evidence: the TEI contains sections on bandwidth selection,
  parameter estimation, and a reasonable search range for optimization.

## Extracted Formulas

The TEI detected formulas for:

- GWR coefficient estimation;
- temporal distance decay;
- spatio-temporal kernel weights;
- STWR calibration;
- AIC/AICc-style goodness-of-fit criteria;
- one empirical model form with precipitation, temperature and height.

Curated empirical model signal:

```math
y_i = \beta_0 + \beta_1 \mathrm{ppt}_i + \beta_2 \mathrm{tmean}_i + \beta_3 \mathrm{height}_i + \varepsilon_i
```

This curated formula should be checked against the PDF before being treated as
a final benchmark formula.

## Extracted Datasets

Confirmed empirical application:

- precipitation isotope data, especially `delta2H`, for the northeastern
  United States;
- climate and elevation covariates;
- three-day empirical prediction/application design.

Data/code availability extracted from TEI:

- Zenodo archive: `https://doi.org/10.5281/zenodo.3637689`
- isotope source: `https://wateriso.utah.edu/waterisotopes/pages/spatial_db/SPATIAL_DB.html`
- precipitation and temperature source: `https://prism.oregonstate.edu`
- elevation source: `https://topotools.cr.usgs.gov/gmted_viewer/viewer.htm`

Weak automatic KG matches:

- `AER::Mortgage`
- `MASS::Cars93`
- `spaMM::welding`

These appear to be extraction noise and should not be treated as validated
datasets for this paper.

## Hyperparameters And Metrics

Hyperparameters/signals:

- spatial bandwidth;
- temporal distance decay;
- spatio-temporal kernel parameters;
- nearest-neighbor search range for bandwidth optimization.

Metrics/comparisons:

- CV score;
- AIC/AICc;
- comparison with OLS, GWR, GTWR and STWR in simulations and real-world data.

## Code Or Repository

The Python source code of STWR v1.0, experiment data and case-study notebooks
are archived on Zenodo:

- `https://doi.org/10.5281/zenodo.3637689`

## Reuse For The Project

This paper is a high-priority source for:

- spatio-temporal local regression benchmark design;
- distinguishing spatial-only GWR from space-time local models;
- extracting hyperparameter-search evidence from paper sections;
- building dataset records that store response, covariates, spatial coordinates
  and temporal index.

## Related Pages

- [[stwr]]
- [[gwr]]
- [[spatiotemporal_data]]
- [[spatial_regression]]
