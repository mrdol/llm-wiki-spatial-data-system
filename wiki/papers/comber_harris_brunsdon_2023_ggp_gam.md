---
title: Comber, Harris and Brunsdon 2023 - Geographical Gaussian Process GAM
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/Multiscale spatially varying coefficient modelling using a Geographical Gaussian Process GAM.pdf
  - corpus/papers/tei/Multiscale spatially varying coefficient modelling using a Geographical Gaussian Process GAM.tei.xml
  - doi:10.1080/13658816.2023.2270285
tags: [paper, ggp-gam, gam, mgwr, svc, spatial, benchmark, grobid]
---

# Comber, Harris and Brunsdon 2023 - GGP-GAM

This paper proposes a geographical Gaussian process GAM (GGP-GAM) for
multiscale spatially varying coefficient modeling and compares it with MGWR.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: present in `corpus/papers/tei/`
- KG node: `paper:doi:10.1080/13658816.2023.2270285`
- Incremental extraction: parsed into `.kg/extracted/zz_incremental_tei_*`

## Extracted Method

- Main method: [[geographical_gaussian_process_gam]]
- Related methods: [[generalized_additive_models]], [[mgwr]], [[gwr]]
- Modeling family: spatially varying coefficient model using GAM smooths and
  Gaussian-process spatial structure
- Comparison target: MGWR

## Extracted Formulas

The TEI detected formula families for:

- GAM additive predictors;
- Gaussian process smooth terms;
- spatially varying coefficient representation;
- simulated coefficient surfaces;
- MGWR comparison form.

Curated model signal:

```math
y_i = \beta_0(\mathbf{s}_i) + \sum_{j=1}^{p}\beta_j(\mathbf{s}_i)x_{ij} + \varepsilon_i
```

In this paper, the spatially varying functions are represented through a
GAM/Gaussian-process construction rather than through local kernel regression.

## Extracted Datasets

Confirmed empirical application:

- UK Brexit referendum case study;
- census and voting covariates;
- spatial units for UK electoral/administrative geography.
- data extracted from the `parlitools` R package;
- package documentation route: `https://docs.evanodell.com/parlitools/`.

Weak automatic KG matches:

- `HistData::Jevons`
- `MASS::shuttle`
- `SpatialEpi::scotland`

These are weak automatic matches and should be manually checked before being
used as dataset evidence.

## Hyperparameters And Metrics

Hyperparameters/signals:

- GAM smooth structure;
- Gaussian-process spatial basis/smoothing controls;
- MGWR bandwidths in the comparison model.

Metrics/comparisons:

- AIC;
- adjusted `R2`;
- MAE;
- simulation comparison with standard MGWR;
- empirical comparison on Brexit voting data.

## Code Or Repository

Code/data repository extracted from TEI:

- `https://github.com/lexcomber/GGP-GAM`

## Reuse For The Project

This paper is useful for:

- comparing local-kernel SVC methods with GAM/Gaussian-process alternatives;
- connecting [[gam]] and [[mgwr]] in the estimator wiki;
- designing benchmark records where the same empirical dataset can compare
  MGWR and smooth spatial coefficient models.

## Related Pages

- [[geographical_gaussian_process_gam]]
- [[generalized_additive_models]]
- [[mgwr]]
- [[gwr]]
- [[spatial_heterogeneity]]
