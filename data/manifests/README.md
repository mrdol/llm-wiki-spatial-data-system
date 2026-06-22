# Manifests

Machine-readable traces for source access and ingestion checks.

This directory is intentionally small:

- `datasets/`: dataset access manifests and software-distributed dataset catalogs. Start with `datasets/README.md` to locate the primary workbook and exclusion registry.
- `papers/`: paper and reference-book access manifests, including DOI, publisher/source URLs, abstract metadata, and download evidence when allowed.
- `runs/`: execution traces, batch-download manifests, failed attempts, and machine registries that are not dataset or paper records.

Do not store raw data, cleaned data, PDFs, or wiki fiches here. Use `wiki/` for human-readable fiches and analyses, `data/catalogue_datasets.json` for the enriched index, and `data/downloads/` or `raw/` for downloaded source files according to project policy.
