# Geocomputation with R

## Source

- Title: Geocomputation with R
- Authors: Robin Lovelace, Jakub Nowosad, Jannes Muenchow
- Online version: https://r.geocompx.org
- Related PDF in corpus: `corpus/papers/raw_pdf/Geocomputation with R - Lovelace Nowosad Muenchow.pdf`
- Source family: web documentation, bookdown, R spatial ecosystem
- Corpus status: entrypoint registered

## Role In The KG

This source is a major reference for modern spatial data processing in R.
It should be used to connect concepts, packages, datasets, examples, and
modeling workflows.

## Topics

- sf
- terra
- vector data
- raster data
- mapping
- spatial machine learning
- spatial cross-validation
- package datasets used in examples

## Extraction Targets

- concepts: geocomputation, spatial data, vector/raster workflows
- packages: sf, terra, tmap, spData, spDataLarge
- datasets: examples used in chapters
- formulas/examples: especially chapters using model formulas or validation
- evidence: links between dataset, package, method, and code example

## Notes For Future KG Extraction

Prioritize chapters that contain explicit datasets or model examples. For
`spDataLarge::lsl`, the relevant chapter is the spatial cross-validation page:
https://r.geocompx.org/spatial-cv.html
