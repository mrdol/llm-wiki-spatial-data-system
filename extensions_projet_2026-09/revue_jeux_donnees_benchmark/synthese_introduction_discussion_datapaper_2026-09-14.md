# Synthèse réutilisable pour le data paper

Date : 14 septembre 2026  
Base : lecture intégrale des onze articles complémentaires et comparaison consignée dans `lecture_integrale_et_comparaison_2026-09-14.md`.

Les passages ci-dessous sont rédigés en anglais pour pouvoir être repris dans le manuscrit. Les citations auteur–année devront être reliées aux clés BibTeX définitives lors de l'intégration LaTeX.

## Proposition pour l'introduction

Benchmark data resources serve different but complementary functions. General-purpose collections such as PMLB reduce access and preprocessing costs by distributing heterogeneous tabular datasets through a common interface and a validated metadata structure (Romano et al., 2022). OpenML goes further by defining a benchmark task as a dataset combined with a target, an evaluation procedure, fixed data splits, and a performance measure, and by grouping such tasks into reusable and versioned suites (Bischl et al., 2021). Execution frameworks such as AMLB add another layer by recording software versions, computational constraints, predictions, failures, and inference costs (Gijsbers et al., 2024). Studies of TableShift, TabZilla, and TabReD further show that benchmark conclusions depend on dataset selection, task difficulty, feature construction, and the scientific meaning of train-test partitions; in particular, replacing temporal or out-of-domain splits with random partitions can alter both measured performance and method rankings (Gardner et al., 2023; McElfresh et al., 2023; Rubachev et al., 2025).

Spatial data repositories already provide strong precedents for scientific documentation. CAMELS-US documents the sources, units, derivation procedures, spatial variability, and limitations of catchment attributes for 671 basins (Addor et al., 2017). LamaH-CE extends this approach to multiple basin delineations, hourly and daily time series, quality indicators, and an explicit hydrological network (Klingler et al., 2021). Caravan harmonizes seven regional resources into a globally standardized and extensible collection of 6,830 catchments, while preserving processing code and indicators of geometric and source-related uncertainty (Kratzert et al., 2023). These resources demonstrate that detailed spatial provenance and reusable processing pipelines are already attainable. Their focus is domain-specific scientific data provision rather than a common cross-domain specification of statistical responses, published model formulas, spatial weights, and executable benchmark tasks.

We present a provenance-aware, cross-domain spatial data bank designed to connect these functions. The resource brings together spatial objects distributed through statistical software and datasets linked to empirical publications under a common metadata structure. It records the analytical roles and provenance of responses, covariates, coordinates, geometries, temporal indices, and spatial weights; distinguishes published formulas from curator-defined benchmark specifications; and preserves maturity states separating a documented catalogue entry, a locally available artifact, an admitted benchmark task, and an executed benchmark run. For datasets with repeated observations, parent panels remain identifiable when cross-sectional derivatives are distributed. A separately defined benchmark core can be consumed by the companion `spatialtidymodels` package only after explicit artifact, specification, and quality checks.

The contribution is therefore neither the first spatial data repository nor a claim that existing repositories lack spatial documentation. It is the combination of cross-domain coverage, source-to-formula provenance, explicit representation of spatial modeling objects, maturity-aware curation, and a controlled bridge from dataset records to reproducible statistical tasks. This design follows the lifecycle perspective of Datasheets for Datasets and the machine-actionable provenance, licensing, and identifier requirements of the FAIR principles (Gebru et al., 2021; Wilkinson et al., 2016).

## Proposition pour la discussion

The comparison with existing resources clarifies both the scope and the limits of the data bank. PMLB and OpenML provide stronger precedents for standardized interfaces, schema validation, task identifiers, fixed splits, and reusable runs. CAMELS-US, LamaH-CE, and Caravan provide stronger domain-specific precedents for variable-level provenance, uncertainty discussion, physical plausibility checks, multiple spatial supports, network structure, and community extension. The present resource does not replace these systems. Its role is to make heterogeneous spatial datasets from multiple scientific domains inspectable through a shared analytical vocabulary and to retain the evidence needed to turn a selected record into a reproducible spatial-regression or spatial-machine-learning task.

This positioning has practical consequences. First, catalogue size is not an estimate of benchmark size: only records passing artifact, specification, and quality gates belong to the executable core. Second, a benchmark task must be represented separately from its source dataset because response choice, formula, spatial weights, prediction target, data split, and metric define a particular scientific use. Third, an executed run is a further object that must retain software versions, computational budget, fold-level predictions, warnings, failures, and timeout decisions. This separation prevents bibliographic discovery, data availability, benchmark eligibility, and empirical comparison from being conflated.

The review also changes how spatial validation should be presented. TableShift and TabReD show that partitions encode deployment assumptions and can change method rankings. Spatial blocking, temporal holdout, interpolation, extrapolation to new regions, and forecasting for known units therefore cannot be treated as interchangeable resampling options. Each task must state its target population and intended transfer setting. Similarly, parent spatio-temporal panels should not be represented only by annual cross-sections when the temporal structure is relevant; the relationship between the parent panel and derived slices must remain explicit.

Several limitations remain. Metadata depth is uneven across sources, published formulas and original spatial-weight matrices are not always recoverable, and some records are documented candidates rather than executable tasks. Cross-domain harmonization necessarily preserves more heterogeneity than a single-domain resource such as CAMELS or Caravan. The current release should therefore avoid claims of exhaustive coverage, universal benchmark readiness, superiority over established repositories, or definitive estimator rankings. Its value lies in traceable curation and in making the boundary between available data and defensible benchmark use explicit.

Future releases should expose the core metadata through a validated machine-readable schema, assign stable identifiers to datasets, tasks, suites, and runs, strengthen variable-level lineage, and publish frozen split and execution manifests for the admitted benchmark core. These developments would combine lessons from PMLB and OpenML with the spatial and uncertainty documentation exemplified by the hydrological data papers, while retaining the cross-domain scope of the present bank.

## Formulation courte de la contribution

> This work contributes a provenance-aware bridge between heterogeneous spatial data records and executable benchmark tasks. It combines cross-domain coverage with explicit lineage for responses, covariates, geometries, temporal structure, spatial weights, and published model specifications, while keeping catalogue entries, admitted tasks, benchmark suites, and executed runs as distinct objects.

## Revendications à éviter

- “No existing repository documents spatial data correctly.”
- “This is the first spatial benchmark data bank.”
- “All catalogued datasets are benchmark-ready.”
- “The bank replaces domain repositories such as CAMELS or Caravan.”
- “The current release establishes a general ranking of spatial estimators.”

