---
title: Jin Lee Yang 2024 - Spatial Moments Employment Growth
type: paper
created: 2026-05-12
updated: 2026-05-12
sources:
  - data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json
  - https://doi.org/10.1002/jae.3046
  - https://doi.org/10.15456/jae.2024045.0850271337
tags: [paper, dataset-source, spatial, econometrics, jae, replication-data, employment]
---

Paper source for US county employment-growth data with spatial econometric modeling and a recent replication archive.

## Identity

- Paper ID: `jin_lee_yang_2024_spatial_moments_employment`
- Paper title: Best linear and quadratic moments for spatial econometric models with an application to spatial interdependence patterns of employment growth in US counties
- Authors: Fei Jin; Lung-fei Lee; Kai Yang
- Author count: 3
- Year: 2024
- Venue: Journal of Applied Econometrics
- Publisher / editor: Wiley / Journal of Applied Econometrics
- Publisher recognized: yes
- Paper DOI: `10.1002/jae.3046`
- Source URL: https://doi.org/10.1002/jae.3046

## Abstract

The paper develops best linear and quadratic moments for generalized method of moments estimation in cross-sectional network and spatial econometric models. It applies the method to a high-order spatial autoregressive model with spatial errors and demonstrates spatial interdependence patterns in US county employment growth.

## Dataset Linkage

- Dataset linkage present: yes
- Linked dataset ID: `unknown_pending_curation`
- Linked dataset page: `not_created_yet`
- Dataset DOI: `not_applicable`
- Dataset/archive DOI: `10.15456/jae.2024045.0850271337`
- Dataset source URL: https://doi.org/10.15456/jae.2024045.0850271337
- Repository URL: https://journaldata.zbw.eu/
- Data availability excerpt: ZBW lists a replication archive for the JAE article with TXT and ZIP resources and a DOI-backed data/code package.
- Linkage evidence: the archive DOI is associated with the same JAE paper title and provides the data/code package for the employment-growth application.

## Modeling Evidence

- Modeling evidence present: yes
- Model family: spatial GMM / spatial autoregressive model
- Method evidence: best linear and quadratic GMM moments; high-order spatial autoregressive model with spatial errors.
- Spatial structure: US county spatial interdependence.
- Temporal structure: employment growth application; exact time definition requires archive inspection.

## Dataset Access Decision

- Access decision: high_priority_dataset_curation
- Reason: recent JAE article, explicit dataset/archive DOI, US county spatial application, and clear spatial model.
- Author-count exception: retained despite fewer than 4 authors because it has a recognized JAE venue, resolvable paper DOI, resolvable dataset/archive DOI, and explicit spatial modeling evidence.
- Do not download status: dataset package not downloaded in this paper-scraping phase.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_journal_plus_replication_archive
  provenance_score: 5
  provenance_evidence: "Recent JAE article DOI and ZBW archive DOI are both recorded."
  rigour_score: 5
  rigour_evidence: "The method and empirical application are explicitly spatial econometric."
  evidence_score: 5
  evidence_evidence: "The ZBW listing exposes a DOI-backed data/code package for the paper."
  coherence_score: 5
  coherence_evidence: "Paper metadata, dataset archive, and application domain are consistent."
  claim_discipline_score: 4
  claim_discipline_evidence: "Variable-level metadata remain pending until archive inspection."
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
- [[modeling_evidence]]
- [[spatial_autocorrelation]]
