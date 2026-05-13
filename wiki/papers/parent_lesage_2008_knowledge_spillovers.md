---
title: Parent and LeSage 2008 - Knowledge Spillovers
type: paper
created: 2026-05-12
updated: 2026-05-12
sources:
  - data/manifests/papers/spatial_econometrics_paper_dataset_scrape_2026_05_12.json
  - https://doi.org/10.1002/jae.981
  - https://doi.org/10.15456/jae.2022319.0719212236
tags: [paper, dataset-source, spatial, econometrics, jae, replication-data, patents]
---

Paper source for a European regional patent-spillover dataset with Bayesian CAR modeling and a replication archive.

## Identity

- Paper ID: `parent_lesage_2008_knowledge_spillovers`
- Paper title: Using the variance structure of the conditional autoregressive spatial specification to model knowledge spillovers
- Authors: Olivier Parent; James P. LeSage
- Author count: 2
- Year: 2008
- Venue: Journal of Applied Econometrics
- Publisher / editor: Wiley / Journal of Applied Econometrics
- Publisher recognized: yes
- Paper DOI: `10.1002/jae.981`
- Source URL: https://doi.org/10.1002/jae.981

## Abstract

The paper studies knowledge spillovers from patent activity across European regions. It uses a Bayesian hierarchical model where region-specific latent effects are structured through connectivity matrices reflecting geographical, technological, and other proximity relations. The empirical application covers patent activity for 323 regions in nine European countries.

## Dataset Linkage

- Dataset linkage present: yes
- Linked dataset ID: `unknown_pending_curation`
- Linked dataset page: `not_created_yet`
- Dataset DOI: `not_applicable`
- Dataset/archive DOI: `10.15456/jae.2022319.0719212236`
- Dataset source URL: https://data.gesis.org/datasearchkg/Dataset/10.15456/jae.2022319.0719212236
- Repository URL: https://journaldata.zbw.eu/
- Data availability excerpt: GESIS/ZBW metadata lists a replication-data record for the paper, with download access and the archive DOI.
- Linkage evidence: the GESIS/ZBW archive metadata identifies the replication package with the same paper title, authors, and JAE article DOI.

## Modeling Evidence

- Modeling evidence present: yes
- Model family: Bayesian spatial econometrics
- Method evidence: conditional autoregressive variance structure and Bayesian hierarchical model.
- Spatial structure: European regions linked by geographic and technological proximity.
- Temporal structure: exact time structure requires archive inspection.

## Dataset Access Decision

- Access decision: candidate_for_dataset_curation
- Reason: paper DOI, archive DOI, regional spatial structure, and explicit model evidence are present.
- Author-count exception: retained despite fewer than 4 authors because it has a recognized JAE venue, resolvable paper DOI, resolvable dataset/archive DOI, and explicit spatial modeling evidence.
- Do not download status: dataset package not downloaded in this paper-scraping phase.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_journal_plus_replication_archive
  provenance_score: 5
  provenance_evidence: "Journal of Applied Econometrics article DOI and ZBW/GESIS archive metadata are recorded."
  rigour_score: 5
  rigour_evidence: "The paper documents a Bayesian CAR-style spatial model and European regional patent application."
  evidence_score: 4
  evidence_evidence: "Paper and dataset metadata were found; file-level content remains uninspected."
  coherence_score: 5
  coherence_evidence: "The archive citation, title, authors, and article DOI match."
  claim_discipline_score: 4
  claim_discipline_evidence: "Variable-level suitability remains pending until package inspection."
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
