---
title: Ranking of newly documented datasets by metadata richness and spatial usefulness
type: analysis
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [analysis, ranking, metadata, spatial, spatio-temporal, download-priority, warehouses]
---

Review note on the 2026-04-22 dataset and warehouse additions, with ranked priorities for metadata work and future raw acquisition.

## Scope Reviewed

- Dataset pages reviewed:
  - [[insee_base_permanente_equipements]]
  - [[data_gouv_dvf_geolocalisees]]
  - [[world_bank_world_development_indicators]]
  - [[un_comtrade_merchandise_trade]]
  - [[oecd_itcs]]
  - [[eurostat_comext_itg]]
  - [[cepii_baci]]
- Warehouse pages reviewed:
  - [[insee]]
  - [[data_gouv]]
  - [[world_bank]]
  - [[un_comtrade]]
  - [[oecd]]
  - [[eurostat]]
  - [[cepii]]

## Review Summary

### Dataset Pages

- The seven dataset pages are structurally solid: they all carry the required frontmatter, a one-line summary, explicit source or warehouse attribution, metadata sections, and related links.
- The strongest pages are [[data_gouv_dvf_geolocalisees]], [[insee_base_permanente_equipements]], [[world_bank_world_development_indicators]], and [[cepii_baci]] because they document variables, classifications, spatial units, time structure, access conditions, limitations, and reproducibility with relatively little ambiguity.
- The weakest page in the reviewed set is [[oecd_itcs]] because several key fields remain approximate rather than pinned down:
  - `N`
  - exact time window
  - exact live access route
- [[eurostat_comext_itg]] and [[un_comtrade_merchandise_trade]] are strong metadata pages, but both still describe families of dissemination routes rather than one single operational extraction target.

### Warehouse Pages

- The warehouse pages are consistent and useful as orientation pages.
- [[insee]], [[eurostat]], [[world_bank]], [[un_comtrade]], and [[cepii]] already communicate a clear warehouse role in the catalog.
- [[data_gouv]] is correctly framed as a dissemination layer rather than a single producer, which is important for future metadata design.
- The main weakness across warehouse pages is thinness:
  - most do not yet separate `portal`, `API`, `bulk download`, and `documentation` access modes explicitly
  - most do not yet document upstream versus downstream roles in enough detail for automated acquisition planning

## Ranking 1: Metadata Richness

This ranking emphasizes explicit schema depth, classification structure, reproducibility, lineage, and clarity of access metadata.

| Rank | Dataset | Why it ranks here |
|---|---|---|
| 1 | [[world_bank_world_development_indicators]] | Richest documented metadata stack in the reviewed set: indicator codes, topic taxonomy, country metadata, region and income classifications, API dimensions, downloadable files, and strong reproducibility. |
| 2 | [[un_comtrade_merchandise_trade]] | Extremely strong on classification governance, record layout, methodology, bilateral geography, quantity units, and correspondence tables. |
| 3 | [[cepii_baci]] | Excellent metadata for lineage and versioning: explicit annual files, HS revision windows, bundled country and product metadata, and clear upstream relationship to Comtrade. |
| 4 | [[eurostat_comext_itg]] | Strong multi-classification and mixed-frequency metadata, but the exact operational dataset path is less fixed than BACI or WDI. |
| 5 | [[data_gouv_dvf_geolocalisees]] | Very rich field-level schema and administrative normalization metadata, but classification governance is narrower than in the major trade or WDI systems. |
| 6 | [[insee_base_permanente_equipements]] | Strong thematic and spatial metadata, but less broad in lineage, versioning, and machine-query metadata than the top five. |
| 7 | [[oecd_itcs]] | Useful and well documented conceptually, but the page currently remains less specific on extraction route, exact time scope, and volume than the others. |

## Ranking 2: Spatial / Spatio-temporal Usefulness

This ranking emphasizes usable geography, spatial granularity, temporal explicitness, and the practical value of the dataset for building spatio-temporal methods or metadata.

| Rank | Dataset | Why it ranks here |
|---|---|---|
| 1 | [[data_gouv_dvf_geolocalisees]] | Best combination of fine spatial granularity and event time: parcel identifiers, commune and department codes, coordinates, and transaction dates. |
| 2 | [[insee_base_permanente_equipements]] | Excellent subnational spatial utility: commune, Iris, coordinates, annual cadence, and clear thematic territorial structure. |
| 3 | [[un_comtrade_merchandise_trade]] | Global bilateral geography with long time depth and monthly or annual resolution makes it one of the strongest non-local spatio-temporal panels. |
| 4 | [[cepii_baci]] | Very strong bilateral product-year panel with global reach, but annual-only resolution puts it slightly below Comtrade. |
| 5 | [[eurostat_comext_itg]] | Strong bilateral geography and mixed temporal granularity, but more regionally bounded than Comtrade or BACI. |
| 6 | [[world_bank_world_development_indicators]] | Useful global country-year panel, but spatial support is limited to country and aggregate-region level. |
| 7 | [[oecd_itcs]] | Still useful, but narrower geography, annual-only timing, and less exhaustive spatial coverage reduce its priority for spatial or spatio-temporal work. |

## Top 3 Priority Candidates for Raw Download

These are the three best download priorities if the next step is to acquire raw files for metadata engineering. This is a prioritization only; no download is being recommended in this note as an immediate action.

| Priority | Dataset | Why it should be downloaded first |
|---|---|---|
| 1 | [[insee_base_permanente_equipements]] | Best first raw target for subnational spatial metadata work in France: multiple spatial supports, annual recurrence, strong official documentation, and clear file formats (`csv`, `dbf`). |
| 2 | [[data_gouv_dvf_geolocalisees]] | Best first raw target for event-level geospatial metadata: parcel keys, coordinates, administrative codes, and rolling temporal coverage make it highly reusable for spatial pipelines. |
| 3 | [[cepii_baci]] | Best first non-French macro-scale raw target: direct versioned archives, bundled metadata files, explicit annual segmentation, and strong lineage make acquisition and cataloging cleaner than more diffuse trade-family sources. |

## Why These 3 Beat the Others for Download Priority

- [[insee_base_permanente_equipements]] beats country-level datasets because it offers the richest mix of territorial scales within one official source.
- [[data_gouv_dvf_geolocalisees]] beats [[world_bank_world_development_indicators]] because parcel-level and coordinate-level geometry is much more valuable for spatial metadata system design than country-year support alone.
- [[cepii_baci]] beats [[un_comtrade_merchandise_trade]] and [[eurostat_comext_itg]] for near-term download priority because its raw acquisition path is cleaner:
  - fixed archive structure
  - explicit versioning
  - bundled metadata files
  - less ambiguity about which raw object should be acquired first
- [[world_bank_world_development_indicators]] remains a top metadata-reference page, but it is not a top-3 raw-download priority because its spatial granularity is comparatively coarse.
- [[oecd_itcs]] is last on both rankings because the page still does not define one precise operational extraction target.

## Recommended Interpretation

- If the objective is `metadata schema design`, start from [[world_bank_world_development_indicators]], [[un_comtrade_merchandise_trade]], and [[cepii_baci]].
- If the objective is `spatial and spatio-temporal method building`, start from [[data_gouv_dvf_geolocalisees]] and [[insee_base_permanente_equipements]].
- If the objective is `clean future raw acquisition`, [[cepii_baci]] is the safest large international first download, while [[insee_base_permanente_equipements]] and [[data_gouv_dvf_geolocalisees]] are the safest French spatial first downloads.

## Related Pages

- [[metadata_oriented_dataset_discovery_warehouses_2026_04_22]]
- [[dataset_catalog_schema_v2]]
- [[insee_base_permanente_equipements]]
- [[data_gouv_dvf_geolocalisees]]
- [[world_bank_world_development_indicators]]
- [[un_comtrade_merchandise_trade]]
- [[cepii_baci]]
- [[eurostat_comext_itg]]
- [[oecd_itcs]]
