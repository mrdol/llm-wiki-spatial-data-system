# MGWR Documentation

## Source

- Title: Multiscale Geographically Weighted Regression (MGWR)
- Documentation: https://mgwr.readthedocs.io/
- Project: PySAL mgwr
- Source family: Python package documentation, geographically weighted models
- Corpus status: entrypoint registered

## Role In The KG

This source links the Python `mgwr` package to GWR, MGWR, bandwidth selection,
and model inference.

## Topics

- GWR
- MGWR
- multiscale bandwidths
- local multicollinearity
- process spatial heterogeneity
- Python implementation

## Extraction Targets

- packages: mgwr, PySAL
- methods: GWR, MGWR
- datasets: Georgia example if documented
- formulas/examples: constructor signatures and model parameters
- evidence: package-method-dataset links

## Notes For Future KG Extraction

Important API pages include `mgwr.gwr.GWR`, `mgwr.gwr.MGWR`,
`mgwr.sel_bw.Sel_BW`, and `mgwr.kernels.Kernel`.
