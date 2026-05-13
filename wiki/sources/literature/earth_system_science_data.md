---
title: Earth System Science Data
type: source
created: 2026-05-11
updated: 2026-05-11
sources:
  - data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.jsonl
tags:
  - source
  - literature
  - journal
  - dataset-source
---

Scientific literature source used to identify peer-reviewed data papers and datasets with strong documentation.

## Identity

- Source ID: `earth_system_science_data`
- Source family: literature / data journal
- Publisher route: Copernicus
- Use in this wiki: find papers that explicitly define, document, or publish reusable datasets.

## Current Evidence

- Paper captured: [[iturbide_2020_ipcc_regions]]
- Dataset identified: [[zenodo_3998463_ipcc_atlas_regions]]
- Discovery manifest: `data/manifests/papers/paper_linked_dataset_candidates_2026_05_11.jsonl`

## Selection Value

- ESSD is useful for the source-of-data approach because records often include dataset descriptions, DOI links, repository URLs, and method sections explaining data construction.
- For this run, the selected article provides both scientific context and direct repository/archive links.

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: scientific_literature_source
  provenance_score: 5
  provenance_evidence: "The source is used through DOI-backed paper metadata and explicit repository links captured by the scraping run."
  rigour_score: 4
  rigour_evidence: "Data-paper venue with strong documentation norms; individual paper quality still requires record-level review."
  evidence_score: 4
  evidence_evidence: "At least one paper and linked dataset have been captured with DOI and manifest evidence."
  coherence_score: 4
  coherence_evidence: "The source page is linked to the paper, dataset fiche, and discovery manifest."
  claim_discipline_score: 4
  claim_discipline_evidence: "The source is treated as a discovery route, not as automatic proof that every linked dataset is ready for modeling."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation metrics were not checked for the source page."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[iturbide_2020_ipcc_regions]]
- [[zenodo_3998463_ipcc_atlas_regions]]
