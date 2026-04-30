---
title: Verification of missing raw endpoints for UN Comtrade and OECD ITCS
type: analysis
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [analysis, downloads, manifests, endpoints, trade, comtrade, oecd, eurostat]
---

Verification note for the remaining trade-dataset acquisition gaps after the first raw-download pass on 2026-04-22.

## Scope

- Datasets checked:
  - [[un_comtrade_merchandise_trade]]
  - [[oecd_itcs]]
  - [[eurostat_comext_itg]]

## Verified Outcome

- [[eurostat_comext_itg]] now has a verified raw endpoint and a downloaded file:
  - endpoint: `https://ec.europa.eu/eurostat/api/dissemination/statistics/1.0/data/ext_st_eu27_2020sitc?lang=EN`
  - local file: `data/downloads/eurostat_comext_itg_ext_st_eu27_2020sitc.json`
- [[un_comtrade_merchandise_trade]] still does not have a verified raw endpoint in the project, even after checking official UNSD and Comtrade references.
- [[oecd_itcs]] still does not have a verified raw endpoint in the project, even after checking official OECD publication and SDMX references.

## Evidence by Dataset

### Eurostat Comext ITG

- Official Eurostat API guidance confirms that Comext datasets use a dedicated dissemination service.
- The tested JSON endpoint returned live machine-readable dataset content on 2026-04-22.
- This is sufficient to document one operational raw endpoint for the Comext family without guessing additional table codes.

### UN Comtrade

- Official references consulted:
  - UNSD API catalogue
  - legacy UN Comtrade API portal URL referenced by UNSD
  - UN Comtrade explorer about page
  - UNSD methodology and record-layout pages
- A current `comtradeplus` API candidate endpoint was tested directly on 2026-04-22.
- Result:
  - HTTP `200`
  - content type `text/html`
  - response body was the Comtrade web application shell, not raw JSON or CSV trade records
- Conclusion:
  - the project can now document the official API references and the tested candidate
  - but it cannot yet claim a verified raw download endpoint for UN Comtrade in this environment

### OECD ITCS

- Official references consulted:
  - OECD ITCS publication portal
  - OECD Data Explorer API documentation
  - OECD public SDMX dataflow registry
  - OECD archive SDMX dataflow registry
- Results:
  - the ITCS publication page returned `403` in this environment
  - no exact `ITCS` dataflow was identified in the official public or archive SDMX registries that were tested
- Conclusion:
  - the project can now document the official OECD API and registry entry points
  - but it cannot yet claim a verified raw ITCS endpoint from those official sources

## Download Status After This Pass

### Newly confirmed in this pass

- [[eurostat_comext_itg]]

### Still unresolved for raw acquisition

- [[un_comtrade_merchandise_trade]]
- [[oecd_itcs]]

## Practical Interpretation

- The trade-download backlog is no longer generic:
  - [[eurostat_comext_itg]] is operational
  - [[un_comtrade_merchandise_trade]] is blocked by unresolved live API behavior
  - [[oecd_itcs]] is blocked by unresolved mapping between the documented publication and a machine-readable SDMX dataflow
- Future work should focus on:
  - obtaining an official current UN Comtrade API example that returns raw records outside the application shell
  - locating an official OECD ITCS dataflow or bulk file reference that is explicitly tied to the discontinued series

## Related Pages

- [[un_comtrade_merchandise_trade]]
- [[oecd_itcs]]
- [[eurostat_comext_itg]]
- [[metadata_oriented_dataset_discovery_warehouses_2026_04_22]]
- [[dataset_ranking_metadata_spatial_download_priority_2026_04_22]]
