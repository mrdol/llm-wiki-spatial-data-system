---
title: Zenodo 5534232 - Linear Pottery and Harris Figure 8 Supplement
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources:
  - data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl
tags:
  - dataset
  - zenodo
  - spatial
  - graph
  - archaeology
  - downloaded
---

Dataset candidat Zenodo contenant des fichiers supplementaires pour une figure associee a Linear Pottery and Harris.

## Identity

- Dataset ID: `zenodo_5534232`
- Dataset name: Supplementary data and files to Figure 8 of Eva Rosenstock, Linear Pottery and Harris (2022)
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/5534232
- Dataset DOI: `10.5281/zenodo.5534232`
- Title: Supplementary data and files to Figure 8 of Eva Rosenstock, Linear Pottery and Harris (2022)
- Year: 2022

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/5534232/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Download status: downloaded
- Files downloaded: 8
- Approximate total size: 1.49 MB

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata returned `cc-by-4.0`.

## Content Metadata

- Main file formats: GraphML, CSV, PDF, image, HMCX

### Variables

- Candidate Y variables: unknown before graph/data inspection
- Candidate Y typology: unknown
- Candidate X variables: graph attributes or stratigraphic variables, to verify
- Candidate X typology: unknown; possible categorical, identifier, temporal, and graph/spatial roles pending inspection
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates: [unknown]
  x_selected: []
  selection_source: data_inspection_pending
  selection_method: unknown
  target_y: unknown
  estimation_context: unknown
```

## Spatiotemporal

- Data type: spatial or spatio-temporal candidate
- Spatial signal: candidate archaeological or stratigraphic spatial/graph structure
- Temporal signal: inferred from stratigraphic/Harris context, to verify
- Structure: graph/network files plus tabular data
- N observations: unknown
- T periods: unknown
- N/T profile: unknown
- Spatial resolution: archaeological or stratigraphic graph unit, exact resolution unknown
- Temporal resolution: unknown
- Spatial extent: unknown before data/PDF inspection
- Time range: unknown before data/PDF inspection

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: unknown
  existing_model_or_equation: unknown
  evidence_source: title, files, and Zenodo metadata
```

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: `data/candidates/datasets/zenodo/5534232/`
- Reproducibility status: partial; supplementary files downloaded, executable workflow not inspected

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo record with DOI, explicit CC-BY-4.0 license, and all listed files downloaded."
  rigour_score: 3
  rigour_evidence: "Supplementary files are available, but modeling objective and variables require inspection."
  evidence_score: 4
  evidence_evidence: "DOI, license, landing URL, manifest, and local downloads are available."
  coherence_score: 4
  coherence_evidence: "Manifest and local files match the same Zenodo record."
  claim_discipline_score: 3
  claim_discipline_evidence: "The fiche keeps the record as candidate until data structure is inspected."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citations were not checked during this scraping run."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[quality_pedigree_schema_v1]]
- [[zenodo]]
- spatiotemporal data
