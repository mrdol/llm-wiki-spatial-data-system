---
title: ZBW Journal Data Archive
type: source
source_family: warehouse
created: 2026-05-12
updated: 2026-05-12
sources:
  - https://journaldata.zbw.eu/
tags: [source, warehouse, zbw, journal-data-archive, replication-data, doi]
---

Repository for journal replication packages in economics and management. In this project it is used as a paper-linked dataset source when a peer-reviewed paper has a replication-data DOI, downloadable files, code, and a citation back to the article.

## Scope

- Replication datasets for published journal articles.
- Dataset/archive DOIs using the `10.15456` prefix.
- Code and data files linked to Journal of Applied Econometrics papers.
- Paper-to-dataset traceability through article citation metadata.

## Local Use

- Store paper discovery manifests in `data/manifests/papers/`.
- Store paper fiches in `wiki/papers/` only when the paper and replication package jointly satisfy the spatial or spatio-temporal modeling criteria.
- Keep paper DOI and dataset/archive DOI separate.

## Quality Notes

ZBW is strong for provenance and reproducibility because it links replication packages to published articles. It does not by itself validate that the variables fit the project modeling target; local data inspection is still required before a dataset becomes confirmed.

## Related Pages

- [[quality_pedigree_schema_v1]]
- [[candidate_dataset]]
- [[modeling_evidence]]
