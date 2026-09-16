---
title: Data paper draft - Software-distributed spatial and spatio-temporal datasets
type: analysis
created: 2026-07-20
updated: 2026-07-20
sources:
  - README.md
  - CONTEXT.md
  - AGENTS.md
  - data/manifests/datasets/software_catalog_combined.RData
  - data/Final_datasets/sf/catalogue_sf_index.RData
  - data/Final_datasets/sf/catalogue_sf_metadata_audit.RData
  - code/r_catalog/extract_r_software_datasets.R
  - code/r_catalog/create_r_software_catalog.R
  - code/r_catalog/build_sf_datasets.R
  - code/r_catalog/audit_sf_crs_time.R
  - code/r_catalog/render_r_dataset_rd_docs.R
  - code/python_catalog/extract_python_software_datasets.py
  - code/python_catalog/create_python_software_catalog.py
  - tools/kg/04_extract_dataset_catalogs.py
  - .kg/graph.sqlite
tags: [datapaper, software-datasets, spatial, spatiotemporal, r, python, sf, knowledge-graph]
---

# Data paper draft - Software-distributed spatial and spatio-temporal datasets

Working title:

> A curated catalogue and harmonized `sf` layer of spatial and spatio-temporal datasets distributed through R and Python software packages

## 1. Contribution to state clearly

This data paper should describe the first source family of the project: spatial and spatio-temporal datasets distributed through R and Python software packages. The contribution is not a single dataset. It is a curated, traceable and partially harmonized data bank that connects:

- software packages and embedded/example datasets;
- catalogue records with variable roles, spatial structure, temporal hints and modelling relevance;
- local tabular/spatial exports;
- standardized R `sf` objects when geometry is directly constructible;
- documentation pages, formula signals, paper references and KG relations.

The paper should present this source family as a controlled first layer of a broader spatial data-bank construction strategy. It must not claim that software packages are the final or only source of the project. The broader project also covers datasets linked to scientific papers and datasets from institutional/research repositories.

## 2. Current data-paper scope

The current software catalogue contains 1,178 records from 43 source packages:

| Field | Current value |
|---|---:|
| Catalogue records | 1,178 |
| R records | 946 |
| Python records | 232 |
| Unique `record_id` values | 1,178 |
| Source packages | 43 |

Current final categories:

| Category | Records |
|---|---:|
| Bons candidats spatial | 157 |
| Spatial simple | 255 |
| ML non spatial | 566 |
| Declasser auxiliaire | 200 |

Spatial and metadata signals in the catalogue:

| Signal | Yes | No | Missing/blank |
|---|---:|---:|---:|
| Geometry present | 384 | 794 | 0 |
| Coordinate columns present | 182 | 996 | 0 |
| Datetime signal | 34 | 946 | 198 |
| Referenced paper signal | 344 | 230 | 604 |

The harmonized `sf` index currently contains 120 attempted spatial conversions, including 111 usable objects and 9 rejected conversions.

| `sf` index field | Current value |
|---|---:|
| Total index entries | 120 |
| Usable `sf` objects | 111 |
| Rejected conversions | 9 |
| R-origin entries | 63 |
| Python-origin entries | 57 |
| Point geometries | 52 |
| Polygon geometries | 59 |
| Missing geometry family in rejected rows | 9 |

Response typing in the `sf` index:

| Response type | Entries |
|---|---:|
| comptage | 53 |
| continu | 20 |
| discret | 4 |
| proportion | 2 |
| inconnu | 32 |
| missing/rejected | 9 |

Formula/model evidence in the current `sf` index remains sparse: only 2 entries currently have `has_formule_modele = TRUE`. This is a major limitation and a priority for the next curation pass.

## 3. Data sources

### 3.1 R software sources

The R route targets packages used in spatial statistics, spatial econometrics, geostatistics, spatial panels, epidemiology, ecology, agronomy and spatial data handling. The current package list includes, among others:

- `spdep`, `spatialreg`, `spData`, `spDataLarge`, `sphet`, `spse`;
- `GWmodel`, `mgwrsar`, `spgwr`, `gstat`, `sp`, `sf`, `sfdep`;
- `plm`, `splm`, `spacetime`, `surveillance`, `STRbook`;
- `SpatialEpi`, `spatstat`, `spatstat.data`, `CARBayes`, `CARBayesST`;
- `spaMM`, `vegan`, `ade4`, `dismo`, `MASS`, `HistData`, `AER`, `agridat`, `rgeoboundaries`, `giscoR`.

The R extraction pipeline combines CRAN/R-Forge/r-universe source archives, `data/` objects embedded in packages, Rd documentation, and package-level documentation links.

### 3.2 Python software sources

The Python route targets packages that distribute benchmark datasets or example data relevant to spatial modelling:

- `geodatasets`, especially GeoDa and `spData` keys;
- `libpysal` and PySAL satellite packages;
- `spreg`, `esda`, `mgwr`, `giddy`, `pointpats`, `segregation`;
- `geosnap`, `momepy`, `geopandas`, `PyGeoDa`, `OSMnx`, `Pyrosm`, `cenpy`;
- `xarray`, `movingpandas`, `scikit-mobility`.

The Python extraction route exports local copies where possible, mainly CSV and GeoJSON for vector data, with additional NetCDF, parquet or support tables for packages such as `xarray` and `geosnap`.

## 4. Collection and preparation workflow

The pipeline can be described as a reproducible staged workflow:

```text
R/Python package sources
-> dataset inventory
-> local extraction/export when possible
-> variable and metadata inspection
-> candidate Y/X, coordinate, geometry, identifier and time detection
-> software catalogue classification
-> R/Python deduplication and harmonization
-> conversion of spatial candidates to R sf objects
-> CRS and temporal audits
-> Markdown documentation pages and KG extraction
-> wiki synthesis and benchmark selection
```

The central implementation files are:

| Pipeline component | Main files |
|---|---|
| R extraction | `code/r_catalog/extract_r_software_datasets.R` |
| R catalogue construction | `code/r_catalog/create_r_software_catalog.R`, `code/r_catalog/Inspection_of_each_dataset.R` |
| R documentation rendering | `code/r_catalog/render_r_dataset_rd_docs.R` |
| Python extraction | `code/python_catalog/extract_python_software_datasets.py` |
| Python catalogue construction | `code/python_catalog/create_python_software_catalog.py`, `code/python_catalog/Inspection_of_each_python_dataset.py` |
| R/Python catalogue comparison | `code/r_catalog/compare_r_python_catalogs.R` |
| `sf` conversion | `code/r_catalog/build_sf_datasets.R` |
| CRS and temporal audit | `code/r_catalog/audit_sf_crs_time.R` |
| KG extraction | `tools/kg/04_extract_dataset_catalogs.py` |

## 5. Metadata model

Each catalogue record is identified by a stable `record_id` and currently stores 39 fields, including:

- source identity: `source_language`, `package`, `dataset_name`, `source_entry`, `source_url`;
- local access: `local_files`;
- dimensions: `n`, `k`;
- variables: `variables`, `analytical_variables`, `metadata_variables`;
- exclusions from modelling covariates: `identifier_variables`, coordinate and geometry fields;
- modelling candidates: `candidate_y_variables`, `candidate_x_variables`, `formula_text`;
- spatial/temporal signals: `has_geometry`, `has_coordinates`, `coordinate_columns`, `has_datetime`, `datetime_columns`;
- literature evidence: `has_referenced_paper`, `paper_doi`, `paper_title`, `paper_formula_or_equation`, `paper_evidence_status`;
- curation fields: `final_category`, `duplicate_group`, `duplicate_status`, `information_score`.

The paper must emphasize the distinction between:

- a catalogue record;
- a dataset candidate;
- a usable `sf` object;
- a final benchmark dataset.

This distinction is essential because the KG currently separates broad `DatasetCatalogRecord` nodes from validated `Dataset` and `DatasetArtifact` nodes.

## 6. Harmonized `sf` layer

The `sf` preparation pipeline converts directly spatial records into standardized R objects. For each usable record, it attempts to:

- load the original R object or local Python-exported file;
- coerce the object to `sf`;
- identify the original geometry family;
- preserve the original geometry as `geom_origine`;
- derive a point geometry when needed for modelling workflows;
- extract point coordinates;
- retain candidate response and covariate metadata;
- record CRS fields and projection status;
- store a local `.rds` artifact under `data/Final_datasets/sf/`.

The present `sf` layer is a harmonized working layer, not a claim that every record is ready for every estimator. CRS validity, temporal interpretation, variable roles and model formula evidence remain separate validation dimensions.

## 7. Validation and quality controls

### 7.1 CRS audit

The CRS audit reviewed 51 usable `sf` objects where the CRS was absent or insufficiently explicit. The audit uses a conservative evidence order:

1. CRS inherited from an existing geometry column;
2. CRS inherited from the original source object;
3. sidecar `.prj` file;
4. explicit CRS in package documentation;
5. coordinate semantics plus plausible longitude/latitude bounding box;
6. bounding box alone, rejected as insufficient evidence.

Current CRS audit results:

| CRS confidence verdict | Entries |
|---|---:|
| eleve | 5 |
| moyen | 7 |
| faible | 7 |
| inconnu | 30 |
| revue | 1 |
| rejete | 1 |

The audit confirms that a plausible longitude/latitude bounding box is not enough to assign EPSG:4326 automatically.

### 7.2 Temporal audit

The temporal audit reviewed 26 records initially marked as having a temporal variable. Current results:

| Temporal verdict | Entries |
|---|---:|
| confirme | 7 |
| confirme_T_a_reconstruire | 1 |
| faux_positif | 16 |
| faux_positif_T_structure_large | 1 |
| faux_positif_degres_jours | 1 |

This is a central methodological point for the data paper: automatic detection of temporal columns produces false positives and must be audited against column semantics and documentation.

### 7.3 Knowledge graph consistency

The local KG is used as a structured evidence layer linking packages, datasets, variables, formulas, documentation pages and artifacts. Current KG stats from `tools/kg/07_export_agent_index.py stats`:

| KG layer | Count |
|---|---:|
| Nodes | 37,512 |
| Edges | 39,944 |
| DatasetCatalogRecord | 1,108 |
| Dataset | 211 |
| DatasetArtifact | 111 |
| DatasetCandidate | 9 |
| Dataset with local artifact | 111 |
| Catalog/candidate promotion links | 120 |

The data paper should use these numbers carefully. Catalogue rows and final usable datasets are not the same object type.

## 8. Data records and availability section to write

The future manuscript should describe the deposited artifacts as:

- catalogue manifests under `data/manifests/datasets/`;
- software extraction outputs under `data/downloads/software/`;
- harmonized `sf` objects under `data/Final_datasets/sf/`;
- documentation pages under `wiki/datasets/r_package_docs/` and `wiki/datasets/fiches_datasets/`;
- KG database and extracted relations under `.kg/` if these are intended to be part of the reproducibility deposit.

Before external publication, decide what can be deposited legally. Some local files are derived from package datasets and must respect upstream package licences. The publication package should probably deposit:

- metadata catalogues;
- code and reproducibility scripts;
- links/provenance to upstream packages;
- derived `sf` objects only when licence-compatible;
- checksums or manifests for local artifacts.

## 9. Scientific narrative for the introduction

Suggested framing:

Spatial and spatio-temporal modelling papers often rely on a small set of recurring benchmark datasets, but these datasets are scattered across software packages, manuals, examples and teaching material. Their metadata are heterogeneous: response variables may be implicit, coordinate fields may be mixed with covariates, CRS information may be absent, and temporal structure may be confused with identifiers, periods or wide-format attributes. The project addresses this by building a curated software-derived data bank that makes these examples findable, comparable and reusable for estimator benchmarking.

The key scientific contribution is therefore a metadata and harmonization layer over existing software-distributed datasets, not a new field survey.

## 10. Proposed manuscript structure

1. Title
2. Abstract
3. Background and motivation
4. Source scope and inclusion criteria
5. Data collection methods
6. Metadata schema and curation rules
7. Harmonization into `sf` objects
8. CRS, temporal and modelling-evidence validation
9. Data records
10. Technical validation
11. Usage notes for spatial and spatio-temporal benchmarking
12. Limitations
13. Code availability
14. Data availability and licensing
15. Author contributions, competing interests, acknowledgements

## 11. Critical limitations to state honestly

- The present layer is strongest for software-distributed benchmark data, not yet for institutional portals or paper-linked replication archives.
- Formula/model evidence is still incomplete in the harmonized `sf` index.
- Several records have geometry but insufficient CRS evidence.
- Automatic temporal detection produced many false positives.
- Some package datasets are auxiliary maps, contours or lookup tables rather than model-ready observations.
- R/Python duplicates must be treated at conceptual level without deleting useful language-specific access routes.
- Legal redistribution must be checked package by package before depositing derived files.

## 12. Immediate next tasks before a submission-ready data paper

1. Freeze a versioned release of the software catalogue and `sf` layer.
2. Export publication-ready flat tables from the `.RData` objects.
3. Produce checksums for deposited files.
4. Complete licence fields for all source packages and local artifacts.
5. Expand formula/model evidence beyond the two currently confirmed `sf` entries.
6. Resolve or explicitly flag the 30 unknown CRS cases.
7. Rebuild `T` for the confirmed temporal records that require reconstruction.
8. Decide whether `.kg/graph.sqlite` is a deposited research object or an internal traceability artifact.
9. Add a reproducibility script that rebuilds all reported tables from a clean checkout.
10. Choose the target data journal and adapt section names to its template.

