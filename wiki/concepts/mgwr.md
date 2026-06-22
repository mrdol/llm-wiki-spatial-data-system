---
title: Multiscale Geographically Weighted Regression
type: concept
created: 2026-06-02
updated: 2026-06-04
sources:
  - Fotheringham, Yang and Kang 2017, doi:10.1080/24694452.2017.1352480
  - Wu, Ren, Hu and Du 2018, doi:10.1080/13658816.2018.1545158
  - Oshan et al. 2019, doi:10.3390/ijgi8060269
tags: [concept, spatial, gwr, mgwr, multiscale, bandwidth]
---

MGWR extends GWR by allowing each coefficient to have its own spatial scale.

## Definition

```math
y_i = \beta_0(s_i; b_0) + \sum_j \beta_j(s_i; b_j)x_{ij} + \epsilon_i
```

Each `b_j` is a bandwidth associated with one coefficient. This makes MGWR a
method for studying both spatial heterogeneity and scale.

## Display Formula

In classical GWR, one can write the local model as:

```math
y_i = \beta_0(\mathbf{s}_i) + \sum_{j=1}^{p}\beta_j(\mathbf{s}_i)x_{ij} + \varepsilon_i
```

where `y_i` is the observed response at location `i`,
`\mathbf{s}_i = (u_i, v_i)` are the spatial coordinates, `x_{ij}` is the value
of covariate `j` for observation `i`, and `\beta_j(\mathbf{s}_i)` is a local
coefficient varying across space.

MGWR generalizes this model by assigning a specific bandwidth to each
coefficient:

```math
y_i = \beta_0(\mathbf{s}_i; b_0) + \sum_{j=1}^{p}\beta_j(\mathbf{s}_i; b_j)x_{ij} + \varepsilon_i
```

where `b_j` is the bandwidth associated with covariate `j`.

## Modeling Relevance

MGWR is relevant when different predictors plausibly act at different spatial
scales. It is more informative than GWR when bandwidths differ substantially
between covariates, but it is also more expensive and sensitive to local
collinearity.

## Spatio-Temporal Extension

[[mgtwr]] extends the multiscale idea to spatio-temporal data by allowing
covariate-specific spatial and temporal bandwidths. The current corpus evidence
is [[wu_ren_hu_du_2018_mgtwr]], which applies MGTWR to Shenzhen housing prices
and compares HPM, MGWR, GTWR and MGTWR.

## KG Relations To Expect

- `Method IMPLEMENTED_BY Package`
- `Estimator USES_HYPERPARAMETER Bandwidth`
- `Formula USES_COVARIATE Covariate`
- `Dataset DOCUMENTED_BY DocumentationPage`
- `Paper USES_METHOD Method`

## Related Pages

- [[gwr]]
- [[mgwr]]
- [[mgtwr]]
- [[svc]]
- [[spatial_heterogeneity]]
