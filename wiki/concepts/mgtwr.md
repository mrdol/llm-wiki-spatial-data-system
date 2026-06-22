---
title: Multiscale Geographically and Temporally Weighted Regression
type: concept
created: 2026-06-04
updated: 2026-06-04
sources:
  - Wu, Ren, Hu and Du 2018, doi:10.1080/13658816.2018.1545158
  - Fotheringham, Yang and Kang 2017, doi:10.1080/24694452.2017.1352480
tags: [concept, mgtwr, mgwr, gtwr, spatio-temporal, bandwidth]
---

# Multiscale Geographically and Temporally Weighted Regression

MGTWR extends GTWR by allowing each relationship to operate at its own spatial
and temporal scale. It is the spatio-temporal analogue of the multiscale idea in
[[mgwr]].

## Definition

The model keeps the local weighted-regression logic of GWR/GTWR, but assigns
covariate-specific spatial and temporal bandwidths. A generic representation is:

```math
y_i = \beta_0(u_i, v_i, t_i) + \sum_k \beta_k(u_i, v_i, t_i; b^S_k, b^T_k)x_{ik} + \epsilon_i
```

where `(u_i, v_i, t_i)` are space-time coordinates and `b^S_k`, `b^T_k` are
covariate-specific spatial and temporal bandwidths.

## Display Formula

GTWR can be written as:

```math
y_i = \beta_0(u_i, v_i, t_i) + \sum_{j=1}^{p}\beta_j(u_i, v_i, t_i)x_{ij} + \varepsilon_i
```

where `(u_i, v_i, t_i)` represents the spatial and temporal coordinates of
observation `i`.

MGTWR extends this logic by allowing each explanatory variable to have its own
spatial and temporal scale:

```math
y_i =
\beta_0(u_i, v_i, t_i; b^S_0, b^T_0)
+ \sum_{j=1}^{p}
\beta_j(u_i, v_i, t_i; b^S_j, b^T_j)x_{ij}
+ \varepsilon_i
```

where `b^S_j` is the spatial bandwidth and `b^T_j` is the temporal bandwidth
associated with covariate `j`.

## Modeling Relevance

MGTWR is relevant when:

- observations have explicit spatial coordinates and time;
- the response is continuous;
- covariates plausibly act at different spatial and temporal scales;
- the goal is to interpret local spatio-temporal coefficient variation.

## Evidence In The Current Corpus

The primary corpus paper is [[wu_ren_hu_du_2018_mgtwr]], which applies MGTWR to
Shenzhen housing prices and compares HPM, MGWR, GTWR and MGTWR.

## Related Pages

- [[mgwr]]
- [[gwr]]
- [[spatiotemporal_data]]
- [[spatial_regression]]
- [[wu_ren_hu_du_2018_mgtwr]]
