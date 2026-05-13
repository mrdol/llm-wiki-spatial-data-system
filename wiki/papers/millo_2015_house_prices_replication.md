---
title: Millo 2015 - House Prices USA R Replication
type: paper
created: 2026-05-12
updated: 2026-05-12
sources:
  - data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json
  - https://doi.org/10.1002/jae.2424
  - https://doi.org/10.15456/jae.2022321.0721257195
tags: [paper, dataset-source, spatiotemporal, econometrics, jae, replication-data, r, housing]
---

Paper source for an R-based replication package of a spatio-temporal US house-price model.

## Identity

- Paper ID: `millo_2015_house_prices_replication`
- Paper title: Narrow Replication of 'A Spatio-Temporal Model of House Prices in the USA' Using R
- Authors: Giovanni Millo
- Author count: 1
- Year: 2015
- Venue: Journal of Applied Econometrics
- Publisher / editor: Wiley / Journal of Applied Econometrics
- Publisher recognized: yes
- Paper DOI: `10.1002/jae.2424`
- Source URL: https://doi.org/10.1002/jae.2424

## Abstract

The paper narrowly replicates Holly, Pesaran and Yamagata's analysis of the US housing market using R instead of the original GAUSS routines. The replication is designed as a self-contained and reproducible analysis using public-domain user-level features, and it reproduces the main spatio-temporal house-price findings.

## Dataset Linkage

- Dataset linkage present: yes
- Linked dataset ID: `unknown_pending_curation`
- Linked dataset page: `not_created_yet`
- Dataset DOI: `not_applicable`
- Dataset/archive DOI: `10.15456/jae.2022321.0721257195`
- Dataset source URL: https://journaldata.zbw.eu/dataset/narrow-replication-of-a-spatiotemporal-model-of-house-prices-in-the-usa-using-r
- Repository URL: https://journaldata.zbw.eu/
- Data availability excerpt: ZBW lists files including readme, appendix PDF, R scripts, region files, BibTeX, and house-price data resources for the replication package.
- Linkage evidence: the ZBW archive page is explicitly titled as the replication package for this JAE article and exposes the replication files.

## Modeling Evidence

- Modeling evidence present: yes
- Model family: spatio-temporal panel econometrics
- Method evidence: replication of Holly, Pesaran and Yamagata's spatio-temporal house-price model.
- Spatial structure: US states or regions with spatial interactions.
- Temporal structure: house-price panel over time; original paper covers 1975-2003.

## Dataset Access Decision

- Access decision: high_priority_dataset_curation
- Reason: this is the cleanest operational route for the Holly et al. house-price dataset because it has a dataset/archive DOI and R replication files.
- Author-count exception: retained despite fewer than 4 authors because it is a recognized JAE replication paper with a resolvable paper DOI, resolvable dataset/archive DOI, R code, and explicit spatio-temporal modeling evidence.
- Do not download status: dataset package not downloaded in this paper-scraping phase.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_journal_plus_replication_archive
  provenance_score: 5
  provenance_evidence: "Paper DOI and ZBW replication-data DOI are recorded with visible code/data file inventory."
  rigour_score: 5
  rigour_evidence: "The paper explicitly focuses on reproducibility of a spatio-temporal econometric model."
  evidence_score: 5
  evidence_evidence: "ZBW page lists dataset/code resources and a DOI-backed replication package."
  coherence_score: 5
  coherence_evidence: "Paper, archive title, source paper, and modeling purpose align."
  claim_discipline_score: 4
  claim_discipline_evidence: "High priority, but dataset variables still require local inspection before confirmation."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation counts were not checked during this scrape."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[zbw_journal_data_archive]]
- [[spatial_econometrics_paper_dataset_scrape_2026_05_12]]
- [[spatiotemporal_data]]
- [[spatial_panel]]
