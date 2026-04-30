---
title: R Python Scraping Bridge Policy v1
type: metadata
created: 2026-04-30
updated: 2026-04-30
sources: []
tags: [metadata, scraping, r, python, reticulate]
---

Policy for calling the existing Python scraping system from R.

## Purpose

The project should not rewrite every warehouse or scientific-portal scraper in R.

The existing Python scripts remain the source of truth for scraping behavior. R should provide orchestration wrappers that call those scripts and return their command output.

## Rule

For scraping workflows:

1. Keep the Python CLI scripts under `pipeline_portals/python/` and `pipeline_lit/`.
2. Add R wrappers under `R/scraping/`.
3. Prefer `system2()` for existing `argparse` scripts.
4. Use `reticulate` only if a Python scraper is later refactored into importable functions.
5. Do not duplicate scraper logic in R unless a specific source has no Python implementation.

## R Entry Point

Use:

`R/scraping/python_scraper_bridge.R`

This file exposes:

- `run_python_script()`
- `run_portal_scraper()`
- `run_portal_plan()`
- `run_portal_jobs()`
- `run_literature_plan()`

## Supported Portal Sources

- `zenodo`
- `figshare`
- `dataverse`
- `dryad`
- `world_bank`
- `eurostat`
- `oecd`
- `un_comtrade`
- `data_gouv`
- `insee`
- `cepii`

## Related Pages

- [[r_estimator_implementation_policy_v1]]
- [[discovery_policy_v3]]
- [[r_software_datasets]]
- [[python_software_datasets]]
