---
title: Wu, Ren, Hu and Du 2018 - Multiscale Geographically and Temporally Weighted Regression
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/Chao Wu, Fu Ren, Wei Hu & Qingyun Du_2018_MGTWR.pdf
  - corpus/papers/tei/Chao Wu, Fu Ren, Wei Hu & Qingyun Du_2018_MGTWR.tei.xml
  - doi:10.1080/13658816.2018.1545158
tags: [paper, mgtwr, mgwr, gtwr, spatio-temporal, housing-prices, benchmark, formula, grobid]
---

# Wu, Ren, Hu and Du 2018 - MGTWR

This paper extends GTWR into multiscale geographically and temporally weighted
regression (MGTWR), allowing covariates to operate at different spatial and
temporal bandwidths.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: generated in `corpus/papers/tei/`
- KG node: `paper:doi:10.1080/13658816.2018.1545158`
- KG source: `grobid_tei`

## Extracted Method

- Main method: [[mgtwr]]
- Parent methods: [[mgwr]], GTWR, [[gwr]]
- Modeling family: local spatio-temporal varying-coefficient regression
- Calibration route: back-fitting algorithm
- Scale controls: variable-specific spatial and temporal bandwidths

The KG detected method signals for GWR, MGWR, hedonic price model, spatial
regression, spatial heterogeneity and spatio-temporal data.

## Extracted Formulas

The TEI extraction detected 24 formulas. Important formula families include:

- GTWR model using space-time coordinates `(u_i, v_i, t_i)`;
- spatio-temporal distance with spatial and temporal scaling factors;
- Gaussian spatio-temporal kernel;
- AICc criterion;
- MGTWR additive/vector form with covariate-specific bandwidths;
- back-fitting convergence criteria;
- simulation data-generating model.

The current `formulas-for MGTWR` command does not yet surface these formulas,
because the extractor stores them as paper formulas rather than method-indexed
formula relations. The formulas are present in the paper node as `HAS_FORMULA`
relations.

## Curated Formula For Wiki Rendering

GTWR:

```math
y_i = \beta_0(u_i, v_i, t_i) + \sum_{j=1}^{p}\beta_j(u_i, v_i, t_i)x_{ij} + \varepsilon_i
```

MGTWR:

```math
y_i =
\beta_0(u_i, v_i, t_i; b^S_0, b^T_0)
+ \sum_{j=1}^{p}
\beta_j(u_i, v_i, t_i; b^S_j, b^T_j)x_{ij}
+ \varepsilon_i
```

This curated formula block is intended for readable wiki display. It should be
kept separate from raw GROBID formula strings stored in the KG.

## Extracted Dataset And Variables

Empirical case study:

- Shenzhen housing prices;
- years 2010-2017;
- response: housing price / average price in Yuan per square meter;
- structural covariates: `FEE`, `GREEN`, `PLOT`, `PARKING`;
- locational covariates: `CBD`, `DC`, `RAIL STATION`, `METRO`, `BUS`;
- neighbourhood covariates: `PARK`, `HOSPITAL`, `PSCHOOL`, `MSCHOOL`, `MIXEDNESS`, `RW-L`, `POPULATION`.

The paper also uses a simulation experiment with a regular spatio-temporal
lattice and known coefficient surfaces.

## Benchmark Signals

The paper compares:

- GTWR vs MGTWR in simulation;
- HPM, MGWR, GTWR and MGTWR in the Shenzhen empirical analysis.

Reported benchmark indicators include:

- `R2`;
- adjusted `R2`;
- `RSS`;
- `RMSE`;
- `AICc`;
- estimated spatial bandwidths;
- estimated temporal bandwidths.

## Reuse For The Project

This paper is important for the second source family of the project: scientific
papers that provide or describe reusable spatial/spatio-temporal benchmark
datasets. It is also useful for formalizing what an ideal dataset fiche should
store: response, covariates, coordinates/time, formula, benchmark models and
evaluation metrics.

## Related Pages

- [[mgtwr]]
- [[mgwr]]
- [[gwr]]
- [[spatiotemporal_data]]
- [[spatial_regression]]
