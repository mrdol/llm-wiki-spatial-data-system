---
title: Fotheringham, Yang and Kang 2017 - Multiscale Geographically Weighted Regression
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/fotheringham2017_Wenbai Yang, and Wei Kang.pdf
  - corpus/papers/tei/fotheringham2017_Wenbai Yang, and Wei Kang.tei.xml
  - doi:10.1080/24694452.2017.1352480
tags: [paper, mgwr, gwr, spatial, benchmark, formula, grobid]
---

# Fotheringham, Yang and Kang 2017 - MGWR

This paper introduces multiscale geographically weighted regression (MGWR), a
GWR extension where different coefficients can operate at different spatial
bandwidths.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: generated in `corpus/papers/tei/`
- KG node: `paper:doi:10.1080/24694452.2017.1352480`
- KG source: `grobid_tei`

## Extracted Method

- Main method: [[mgwr]]
- Related methods detected by KG: [[gwr]], [[spatial_heterogeneity]], [[generalized_additive_models]]
- Calibration route: back-fitting algorithm
- Core hyperparameter: coefficient-specific spatial bandwidth vector
- Comparison baselines: global regression, GWR, SGWR and SVC-style models

## Extracted Formulas

The TEI extraction detected 26 formulas. Important formula families include:

- GWR form with one spatial bandwidth;
- MGWR form with parameter-specific bandwidths;
- SGWR form with global and local predictors;
- AICc expression used in bandwidth search;
- back-fitting / GAM-style additive form.

The formula extraction is useful as a KG signal, but the mathematical notation
should be checked in the PDF before being copied into validated estimator docs.

## Curated Formula For Wiki Rendering

Classical GWR:

```math
y_i = \beta_0(\mathbf{s}_i) + \sum_{j=1}^{p}\beta_j(\mathbf{s}_i)x_{ij} + \varepsilon_i
```

MGWR:

```math
y_i = \beta_0(\mathbf{s}_i; b_0) + \sum_{j=1}^{p}\beta_j(\mathbf{s}_i; b_j)x_{ij} + \varepsilon_i
```

This curated formula block is intended for readable wiki display. It should be
kept separate from raw GROBID formula strings stored in the KG.

## Extracted Datasets And Benchmarks

The paper uses:

- two simulated datasets with known parameter surfaces;
- one empirical Irish famine dataset.

Benchmark signals:

- GWR vs MGWR comparison;
- RSS and RMSE-style diagnostics;
- bandwidth-vector recovery;
- runtime comparison across repeated simulation runs.

Automatic KG detection also produced `AER::Guns` and `gstat::sic2004` as
possible dataset mentions. These are weak automatic matches and should not be
treated as validated datasets for this paper without manual verification.

## Package Or Software Signal

The TEI mentions Python implementation context. The current KG also detected
`gstat` as a package mention, but this should be treated as weak evidence until
the package/software context is manually reviewed.

## Reuse For The Project

This is a high-priority reference for:

- the canonical MGWR estimator page;
- benchmark design based on simulated spatial parameter surfaces;
- extraction of response/covariate/formula evidence from spatial regression papers;
- comparison between single-bandwidth and multiscale local models.

## Related Pages

- [[mgwr]]
- [[gwr]]
- [[mgtwr]]
- [[spatial_heterogeneity]]
- [[generalized_additive_models]]
