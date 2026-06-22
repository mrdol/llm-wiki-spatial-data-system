# GWmodel documentation

## Source

- Title: GWmodel3 documentation
- Website: https://gwmodel-lab.github.io/GWmodel3/
- Basic GWR tutorial: https://gwmodel-lab.github.io/GWmodel3/articles/tutorial-01-gwr-basic.html
- Local Rmd already in corpus: `corpus/web_md/tutorial-01-gwr-basic.Rmd`
- Source family: package documentation, R package, geographically weighted models
- Corpus status: entrypoint registered

## Role In The KG

This source links GWmodel/GWmodel3 package functions to datasets, model
formulas, and geographically weighted methods.

## Topics

- GWR
- MGWR
- GTWR
- robust GWR
- local PCA
- bandwidth selection
- local coefficients
- diagnostics

## Extraction Targets

- packages: GWmodel, GWmodel3
- datasets: LondonHP and other package examples
- methods: GWR, GTWR, MGWR, geographically weighted models
- formulas: model formulas shown in tutorials
- evidence: package function -> dataset -> formula -> method

## Known Model Example

The basic GWR tutorial uses `LondonHP` with:

```r
PURCHASE ~ FLOORSZ + UNEMPLOY + PROF
```

This should become a KG relation between `Dataset:GWmodel::LondonHP`,
`RPackage:GWmodel3`, `Method:GWR`, and a `Formula` node.
