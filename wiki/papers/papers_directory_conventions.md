---
title: Papers Directory Conventions
type: metadata
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [metadata, papers, directory, conventions]
---

Conventions for paper support in the wiki architecture without inventing paper records.

## Purpose

The `wiki/papers/` directory is reserved for one page per documented paper once a paper has been explicitly ingested or otherwise documented in the project.

## Current Rule

- Do not create paper records until the paper metadata are documented.
- Architecture pages and directory conventions may live here before the first paper record exists.
- Paper pages should support DOI traceability and links to datasets, source pages, manifests, and related analyses.

## Raw and Manifest Conventions

- Preferred raw-paper directory: `raw/papers/`
- Current repository also contains a legacy folder: `raw/paper/`
- Because `AGENTS.md` forbids modification of `raw/`, the architecture documents the preferred `raw/papers/` target without changing the raw layer in this update.
- Paper access manifests belong in `data/manifests/papers/`

## Future Paper Page Requirements

Paper pages should eventually include:

- paper title
- publication DOI
- authors
- year
- venue
- whether published data are available
- whether dataset DOI is documented
- linked dataset pages
- linked source pages under `wiki/sources/literature/` or `wiki/sources/warehouses/`

## Related Pages

- [[catalog_registry_schema_v3]]
- [[discovery_policy_v3]]
