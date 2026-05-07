---
title: Zenodo 18421412 - Climate-Fire Relationships Across Global Mountain Systems
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl]
tags: [dataset, zenodo, spatial, temporal, climate, fire, downloaded]
---

Dataset candidat Zenodo sur les relations climat-feu dans plusieurs systemes montagneux mondiaux.

## Identity

- Dataset ID: `zenodo_18421412`
- Dataset name: Data and Code for: Climate-Fire Relationships Across Global Mountain Systems: A Six-Continent Analysis
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/18421412
- Dataset DOI: `10.5281/zenodo.18421412`
- Title: Data and Code for: Climate-Fire Relationships Across Global Mountain Systems: A Six-Continent Analysis
- Year: 2026

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/18421412/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Download status: downloaded
- Files downloaded: 8
- Approximate total size: 99.45 MB

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata returned `cc-by-4.0`.

## Content Metadata

- Main file formats: CSV, JavaScript, Markdown

### Variables

- Candidate Y variables: unknown before data inspection
- Candidate Y typology: unknown
- Candidate X variables: climate and fire variables likely present in CSV files, to verify by inspection
- Candidate X typology: unknown; expected temporal, spatial, and continuous climate/fire variables pending inspection
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

- Data type: spatio-temporal candidate
- Spatial signal: global mountain systems with regional files
- Temporal signal: filenames indicate 2013-2023
- Structure: likely spatio-temporal panel or repeated regional observations
- N observations: unknown
- T periods: unknown
- N/T profile: unknown
- Spatial resolution: mountain system / regional unit, exact resolution unknown before data inspection
- Temporal resolution: unknown; filenames indicate annual or multi-year material for 2013-2023
- Spatial extent: global mountain systems across six continents
- Time range: 2013-2023 indicated by filenames, to verify in data

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: unknown
  existing_model_or_equation: unknown
  evidence_source: dataset title and downloaded files only
```

## Reproducibility

- Code available: yes, JavaScript and Markdown files are listed in downloaded material
- Repository: unknown
- Local data path: `data/candidates/datasets/zenodo/18421412/`
- Reproducibility status: partial; data and code downloaded, but execution workflow not inspected

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo record with DOI, explicit CC-BY-4.0 license, and downloaded CSV/code files."
  rigour_score: 3
  rigour_evidence: "Documentation and code are present, but methods and variables still require inspection."
  evidence_score: 4
  evidence_evidence: "DOI, license, landing URL, manifest, and local downloads are available."
  coherence_score: 4
  coherence_evidence: "Manifest and local download directory point to the same Zenodo record."
  claim_discipline_score: 3
  claim_discipline_evidence: "The fiche does not infer estimator suitability before variable inspection."
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
