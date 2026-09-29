---
title: Decisions sur les cas dataset-first telecharges a surveiller
type: analysis
created: 2026-09-04
updated: 2026-09-04
sources:
  - tmp/dataset_first_downloaded_content_check_2026-09-04.csv
tags: [datasets, dataset-first, audit]
---

# Decisions sur les cas dataset-first telecharges a surveiller

Source de controle : `tmp/dataset_first_downloaded_content_check_2026-09-04.csv`.

| DOI | Statut contenu | Decision pipeline | Note |
|---|---|---|---|
| `10.5061/dryad.n2z34tnb3` | `raster_product_only` | `raw_raster_product_pending_loader` | GeoTIFF prediction/prevalence products are present, but no observation-level Y/X table was found locally. |
| `10.5061/dryad.n4288` | `code_only` | `rejected_code_only_no_empirical_data` | Archive contains R/SQL/shell simulation scripts and README only; no empirical dataset file was found. |
| `10.5061/dryad.nh07v50` | `raster_covariates_only` | `raw_raster_covariates_pending_response_table` | Bathymetric/topographic GeoTIFF covariates are present, but no response/observation table was found locally. |
| `10.5061/dryad.tqjq2bvv2` | `code_only` | `rejected_code_only_no_empirical_data` | Zip archive contains scripts and an effectively empty Data folder; no usable data file was found. |
| `10.5281/zenodo.21130627` | `corrupt_or_nonstandard_archive` | `download_corrupt_redownload_required` | Local 2010.zip is not readable as ZIP/TAR and does not start with a standard ZIP signature; redownload is required. |
| `10.5281/zenodo.7352284` | `raster_product_only` | `raw_raster_product_pending_loader` | A single GeoTIFF peatland extent map is present; no linked publication or tabular Y/X benchmark table is available yet. |


## Related Pages

Aucune fiche wiki associee a ce rapport ; se referer aux sources listees en frontmatter.
