---
title: Behrens Ertur Koch 2012 - Dual Gravity
type: paper
created: 2026-05-12
updated: 2026-05-12
sources:
  - data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json
  - https://doi.org/10.1002/jae.1231
  - https://doi.org/10.15456/jae.2022320.0727751571
tags: [paper, dataset-source, spatial, econometrics, jae, replication-data, trade]
---

Paper source for interregional trade-flow data with spatial gravity modeling and a replication archive.

## Identity

- Paper ID: `behrens_ertur_koch_2012_dual_gravity`
- Paper title: 'Dual' Gravity: Using Spatial Econometrics to Control for Multilateral Resistance
- Authors: Kristian Behrens; Cem Ertur; Wilfried Koch
- Author count: 3
- Year: 2012
- Venue: Journal of Applied Econometrics
- Publisher / editor: Wiley / Journal of Applied Econometrics
- Publisher recognized: yes
- Paper DOI: `10.1002/jae.1231`
- Source URL: https://doi.org/10.1002/jae.1231

## Abstract

The paper proposes a quantity-based dual gravity equation with cross-sectional interdependence and spatially lagged error terms. It applies spatial econometric estimation to Canada-US trade data and shows that modeling spatial interdependence directly reduces estimated border effects by capturing multilateral resistance.

## Dataset Linkage

- Dataset linkage present: yes
- Linked dataset ID: `unknown_pending_curation`
- Linked dataset page: `not_created_yet`
- Dataset DOI: `not_applicable`
- Dataset/archive DOI: `10.15456/jae.2022320.0727751571`
- Dataset source URL: https://data.gesis.org/datasearchkg/Dataset/10.15456/jae.2022320.0727751571
- Repository URL: https://journaldata.zbw.eu/
- Data availability excerpt: GESIS/ZBW metadata lists a replication-data record titled "'DUAL' GRAVITY USING SPATIAL ECONOMETRICS TO CONTROL FOR MULTILATERAL RESISTANCE" with download access.
- Linkage evidence: the GESIS/ZBW archive DOI resolves to a replication-data record for the same JAE article and title.

## Modeling Evidence

- Modeling evidence present: yes
- Model family: spatial gravity model
- Method evidence: dual gravity equation, spatial autoregressive moving average specification, spatially lagged errors.
- Spatial structure: Canada-US regional trade flows and cross-flow interdependence.
- Temporal structure: exact time dimension requires archive inspection.

## Dataset Access Decision

- Access decision: candidate_for_dataset_curation
- Reason: paper DOI, archive DOI, trade-flow dataset route, and explicit spatial model evidence are present.
- Author-count exception: retained despite fewer than 4 authors because it has a recognized JAE venue, resolvable paper DOI, resolvable dataset/archive DOI, and explicit spatial modeling evidence.
- Do not download status: dataset package not downloaded in this paper-scraping phase.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_journal_plus_replication_archive
  provenance_score: 5
  provenance_evidence: "Journal of Applied Econometrics article DOI and ZBW/GESIS archive DOI are recorded."
  rigour_score: 5
  rigour_evidence: "The paper has explicit spatial econometric gravity modeling and applied trade data."
  evidence_score: 4
  evidence_evidence: "Dataset archive metadata are present; package files remain uninspected."
  coherence_score: 5
  coherence_evidence: "Article title, authors, DOI, and replication-data metadata align."
  claim_discipline_score: 4
  claim_discipline_evidence: "Modeling relevance is strong; variable inventory awaits archive inspection."
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
- [[spatial_panel]]
