---
title: Li 2022 - SHAP and XGBoost for spatial effects
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/Extracting spatial effects from machine learning model using local interpretation method_SHAP and XGBoost.pdf
  - corpus/papers/tei/Extracting spatial effects from machine learning model using local interpretation method_SHAP and XGBoost.tei.xml
  - doi:10.1016/j.compenvurbsys.2022.101845
tags: [paper, xgboost, shap, mgwr, slm, spatial, benchmark, grobid]
---

# Li 2022 - SHAP and XGBoost for Spatial Effects

This paper studies how local interpretation methods, especially SHAP values,
can extract spatial effects from machine-learning models such as XGBoost and
compare them with spatial statistical models.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: present in `corpus/papers/tei/`
- KG node: `paper:doi:10.1016/j.compenvurbsys.2022.101845`
- Incremental extraction: parsed into `.kg/extracted/zz_incremental_tei_*`

## Extracted Method

- Main ML method: [[gradient_boosted_trees]] / XGBoost
- Interpretation method: [[shap_spatial_effects]]
- Spatial comparison models: spatial lag model (SLM), [[mgwr]]
- Other automatic method signals: random forest, GAM, spatial autocorrelation,
  spatial heterogeneity and spatial regression.

## Extracted Formulas

The TEI detected formulas for SHAP-style local decomposition and spatial-model
comparisons. The paper also produced formula-like dataset signals, but several
are automatic matches from examples and should not be treated as validated
model formulas without PDF review.

## Extracted Datasets

Confirmed empirical application:

- ride-hailing service demand in Chicago;
- urban covariates used for demand modeling.

Weak automatic KG matches:

- `AER::Fatalities`
- `AER::Guns`
- `geodatasets::cincinnati`
- `geodatasets::nyc_neighborhoods`
- `HistData::Quarrels`
- `libpysal::Cincinnati`
- `libpysal::NYC Neighborhoods`
- `libpysal::NYC Socio-Demographics`

These are not confirmed empirical datasets for the paper.

## Hyperparameters And Metrics

Hyperparameters/signals:

- XGBoost model tuning;
- local SHAP decomposition;
- spatial weights in SLM comparison;
- MGWR bandwidths in spatial heterogeneity comparison.

Metrics/comparisons:

- comparison of SHAP-explained machine learning with SLM for spatial
  autocorrelation;
- comparison with MGWR for spatial heterogeneity;
- simulation design plus empirical Chicago application.

## Code Or Repository

Code/data repository extracted from TEI:

- `https://github.com/Ziqi-Li/SHAP_spatial_data_paper`

This repository can become a strong source for dataset, formula and benchmark
reconstruction.

## Reuse For The Project

This paper is useful for:

- linking machine-learning baselines to spatial model interpretation;
- documenting XGBoost/SHAP as a comparison route against SLM and MGWR;
- testing whether model interpretation outputs can be represented in the KG as
  method evidence rather than only estimator evidence.

## Related Pages

- [[gradient_boosted_trees]]
- [[shap_spatial_effects]]
- [[mgwr]]
- [[spatial_regression]]
- [[spatial_autocorrelation]]
