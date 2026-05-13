---
title: Ertur and Koch 2007 - Growth Spatial Externalities
type: paper
created: 2026-05-12
updated: 2026-05-12
sources:
  - data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json
  - https://doi.org/10.1002/jae.963
  - https://doi.org/10.15456/jae.2022319.0717374828
tags: [paper, dataset-source, spatial, econometrics, jae, replication-data]
---

Paper source for a spatial econometrics growth dataset with a ZBW replication archive.

## Identity

- Paper ID: `ertur_koch_2007_growth_spatial_externalities`
- Paper title: Growth, technological interdependence and spatial externalities: theory and evidence
- Authors: Cem Ertur; Wilfried Koch
- Author count: 2
- Year: 2007
- Venue: Journal of Applied Econometrics
- Publisher / editor: Wiley / Journal of Applied Econometrics
- Publisher recognized: yes
- Paper DOI: `10.1002/jae.963`
- Source URL: https://doi.org/10.1002/jae.963

## Abstract

The paper presents a theoretical growth model that accounts for technological interdependence and spatial externalities between economies. It estimates a spatially augmented Solow model and a locally linear spatial autoregressive specification to study convergence and country-specific spillover effects.

## Dataset Linkage

- Dataset linkage present: yes
- Linked dataset ID: `unknown_pending_curation`
- Linked dataset page: `not_created_yet`
- Dataset DOI: `not_applicable`
- Dataset/archive DOI: `10.15456/jae.2022319.0717374828`
- Dataset source URL: https://doi.org/10.15456/jae.2022319.0717374828
- Repository URL: https://journaldata.zbw.eu/
- Data availability excerpt: ZBW lists a replication data record for the article with TXT and MATLAB files and a dataset/archive DOI.
- Linkage evidence: the ZBW archive DOI resolves as a replication-data record for the same article title, authors, and paper DOI.

## Modeling Evidence

- Modeling evidence present: yes
- Model family: spatial growth econometrics
- Method evidence: spatially augmented Solow model; locally linear spatial autoregressive specification.
- Spatial structure: cross-economy spatial externalities and technology interdependence.
- Temporal structure: growth/convergence setting; exact panel shape requires archive inspection.

## Dataset Access Decision

- Access decision: candidate_for_dataset_curation
- Reason: paper DOI, ZBW archive DOI, spatial modeling evidence, and replication files are all present.
- Author-count exception: retained despite fewer than 4 authors because it has a recognized JAE venue, resolvable paper DOI, resolvable dataset/archive DOI, and explicit spatial modeling evidence.
- Do not download status: dataset package not downloaded in this paper-scraping phase.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_journal_plus_replication_archive
  provenance_score: 5
  provenance_evidence: "Journal of Applied Econometrics article DOI and ZBW archive DOI are both recorded."
  rigour_score: 4
  rigour_evidence: "The paper contains explicit spatial growth modeling; archive files still need inspection."
  evidence_score: 4
  evidence_evidence: "Metadata were scraped from DOI/RePEc/ZBW search results; package contents were not downloaded."
  coherence_score: 4
  coherence_evidence: "Paper title, article DOI, archive DOI, and modeling description are coherent."
  claim_discipline_score: 4
  claim_discipline_evidence: "Dataset suitability for local modeling remains pending until file and variable inspection."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation counts were not checked during this scrape."
  delta1_risk: medium
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[zbw_journal_data_archive]]
- [[spatial_econometrics_paper_dataset_scrape_2026_05_12]]
- [[modeling_evidence]]
- [[candidate_dataset]]
