# Curated Advanced Spatial Data Science Sources

## Source

- Origin: user-provided curated bibliography
- Corpus status: synthesis entrypoint
- Purpose: group the web and PDF resources selected for the spatial/ST dataset KG

## Included Web Sources

| Source | Local fiche | Main role |
|---|---|---|
| Geocomputation with R | `geocomputation_with_r.md` | R spatial workflows, spData/spDataLarge examples |
| Spatial Data Science with Applications in R | `spatial_data_science_r.md` | sf, stars, spatial statistics, spatio-temporal data |
| Hands-On Spatial Data Science with R | `hands_on_spatial_data_science_r.md` | ESDA, Moran, LISA, spatial regression |
| Spatial Data Science with R and terra | `rspatial_terra.md` | terra, raster/vector, remote sensing |
| Geographic Data Science with R | `geographic_data_science_with_r.md` | environmental and ecological spatial modeling |
| Spatial Statistics for Data Science | `spatial_statistics_for_data_science_moraga.md` | spatial statistics, INLA, disease mapping |
| GWR4 Manual | `gwr4_manual.md` | historical GWR software and diagnostics |
| MGWR Documentation | `mgwr_documentation.md` | Python MGWR/GWR package documentation |
| GWmodel3 Documentation | `gwmodel_docs.md` | R GWmodel/GWmodel3 formulas and datasets |
| GAMs in R | `gams_in_r_course.md` | GAMs, mgcv, spatial smooths |
| From the Bottom of the Heap | `from_the_bottom_of_the_heap.md` | practical mgcv/GAM interpretation |

## KG Use

These sources should support relations of the form:

```text
Source -> mentions -> Concept
Source -> documents -> Package
Source -> uses -> Dataset
Source -> shows -> Formula
Formula -> implements/illustrates -> Method
Dataset -> appears_in -> Source
```

## Priority

1. Extract datasets and formulas from GWmodel3 and Geocomputation with R.
2. Extract spatial/ST data structures from Spatial Data Science with Applications in R.
3. Extract statistical model concepts from Moraga and the GAM resources.
4. Extract package-method links from MGWR, GWR4, and rspatial/terra.
