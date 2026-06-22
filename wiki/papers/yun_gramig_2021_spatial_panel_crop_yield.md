---
title: Yun and Gramig 2021 - Spatial Panel Models of Crop Yield Response to Weather
type: paper
created: 2026-06-04
updated: 2026-06-04
sources:
  - corpus/bib/references.bib
  - corpus/papers/raw_pdf/div-class-title-spatial-panel-models-of-crop-yield-response-to-weather-econometric-specification-strategies-and-prediction-performance.pdf
  - corpus/papers/tei/div-class-title-spatial-panel-models-of-crop-yield-response-to-weather-econometric-specification-strategies-and-prediction-performance.tei.xml
  - doi:10.1017/aae.2021.29
tags: [paper, spatial-panel, crop-yield, weather, econometrics, benchmark, grobid]
---

# Yun and Gramig 2021 - Spatial Panel Crop Yield Models

This paper studies econometric specification strategies and prediction
performance for spatial panel models of crop yield response to weather.

## KG Ingest Status

- BibTeX entry: present in `corpus/bib/references.bib`
- PDF: present in `corpus/papers/raw_pdf/`
- GROBID TEI: present in `corpus/papers/tei/`
- KG node: `paper:doi:10.1017/aae.2021.29`
- Incremental extraction: parsed into `.kg/extracted/zz_incremental_tei_*`

## Extracted Method

- Main method family: [[spatial_panel]]
- Related method signals: [[spatial_regression]], [[spatiotemporal_data]],
  spatial autocorrelation
- Model family: non-spatial panel regression and spatial econometric panel
  specifications for crop-yield response.

## Extracted Formulas

The TEI detected formulas for:

- non-spatial panel regression;
- spatial econometric crop-yield specifications;
- spatial aggregation in weather;
- spatial correlation in weather and yields;
- heat exposure bins.

The formula extractor did not surface clean `SHOWS_FORMULA` relations for this
paper, so formulas should be validated manually from the PDF before being
promoted to benchmark formulas.

## Extracted Datasets

Confirmed empirical application:

- crop yield response to weather;
- county/region panel structure;
- weather variables including precipitation and heat exposure bins.

Repository/data signal:

- GitHub repository extracted from TEI:
  `https://github.com/ysd2004/spatialcropyieldJAAE`
- supplementary material route:
  `https://doi.org/10.1017/aae.2021.29`

Weak automatic KG matches:

- `MASS::Insurance`
- `splm::Insurance`

These are likely software/example noise and not the paper's empirical dataset.

## Hyperparameters And Metrics

Hyperparameters/signals:

- spatial weights matrix;
- panel fixed/random effect choice;
- weather aggregation and heat-bin specification;
- spatial lag/error/panel specification choices.

Metrics/comparisons:

- 14 competing panel regression models;
- in-sample, out-of-sample and bootstrapped out-of-sample prediction;
- SSE;
- RMSE;
- APC;
- RMPE;
- Welch tests for out-of-sample prediction accuracy;
- estimation-result comparison between non-spatial and spatial panel models.

## Code Or Repository

Code/data repository extracted from TEI:

- `https://github.com/ysd2004/spatialcropyieldJAAE`

The repository should be inspected for exact variable roles, especially yields,
weather variables, soil covariates and spatially lagged variables.

## Reuse For The Project

This paper is useful for:

- the scientific-paper-with-open-data source family;
- spatial panel benchmark construction;
- comparing specification strategy and prediction performance rather than only
  in-sample fit.

## Related Pages

- [[spatial_panel]]
- [[spatiotemporal_data]]
- [[spatial_regression]]
- [[spatial_autocorrelation]]
