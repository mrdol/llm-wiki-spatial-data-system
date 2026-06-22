---
title: Arribas-Bel, Patino and Duque 2017 - Living Environment Deprivation
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/Remote sensing-based measurement of leaving environment depravation.pdf
  - corpus/papers/tei/Remote sensing-based measurement of leaving environment depravation.tei.xml
  - doi:10.1371/journal.pone.0176684
tags: [paper, remote-sensing, spatial-regression, random-forest, gradient-boosting, benchmark, grobid]
---

# Arribas-Bel, Patino and Duque 2017 - Living Environment Deprivation

This paper studies remote-sensing-based measurement of Living Environment
Deprivation (LED), comparing classical spatial modeling and machine-learning
approaches.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: present in `corpus/papers/tei/`
- KG node: `paper:doi:10.1371/journal.pone.0176684`
- Incremental extraction: parsed into `.kg/extracted/zz_incremental_tei_*`

## Extracted Method

- Baseline model: linear regression
- Spatial model: spatial lag / spatial linear model
- Machine-learning models: random forest and gradient boost regressor
- Related KG signals: [[spatial_regression]], [[spatial_autocorrelation]],
  [[gradient_boosted_trees]], random forest

## Extracted Formulas

The TEI detected four formulas. Curated formulas from the detected sections:

Conceptual feature model:

```math
LED = f(LC, SP, TX, ST)
```

Baseline linear model:

```math
LED = \alpha + \beta LC + \gamma SP + \delta TX + \zeta ST + \varepsilon
```

Spatial linear model:

```math
LED = \alpha + \rho W LED + \beta LC + \gamma SP + \delta TX + \zeta ST + \varepsilon
```

## Extracted Datasets

Confirmed empirical application:

- Liverpool case study;
- remote-sensing features;
- Living Environment Deprivation target;
- spatial units and derived land-cover/spectral/texture/structure variables.

The KG did not detect a clean package dataset relation for this paper, which is
reasonable because this is a paper/repository route rather than an R package
dataset.

## Hyperparameters And Metrics

Hyperparameters/signals:

- spatial weights matrix in the spatial lag model;
- random forest tuning;
- gradient boosting tuning;
- remote-sensing feature groups.

Metrics/comparisons:

- model performance section compares baseline linear model, spatial model,
  random forest and gradient boosting;
- interpretation section supports feature-importance style analysis.

## Code Or Repository

Code/data repository extracted from TEI:

- `https://github.com/darribas/satellite_led_liverpool`

## Reuse For The Project

This paper is useful for:

- integrating machine-learning baselines with spatial regression baselines;
- documenting a paper-to-open-data route outside package datasets;
- representing remote-sensing covariate groups in dataset metadata.

## Related Pages

- [[spatial_regression]]
- [[gradient_boosted_trees]]
- [[spatial_autocorrelation]]
