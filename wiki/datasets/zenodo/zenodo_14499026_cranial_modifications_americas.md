---
title: Zenodo 14499026 - Cranial Modifications in the Americas
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl]
tags: [dataset, zenodo, spatial, temporal, archaeology, r-code, downloaded]
---

Dataset analytique et code R pour etudier les motifs spatiaux et temporels de modifications craniennes intentionnelles dans les Ameriques.

## Identity

- Dataset ID: `zenodo_14499026`
- Dataset name: Analytical Dataset and R Code for Manuscript "Intentional cranial modifications in the Americas - the temporal and spatial patterns of potential transmissions and cultural innovations"
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/14499026
- Dataset DOI: `10.5281/zenodo.14499026`
- Title: Analytical Dataset and R Code for Manuscript "Intentional cranial modifications in the Americas - the temporal and spatial patterns of potential transmissions and cultural innovations"
- Year: 2026

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/14499026/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Download status: downloaded
- Files downloaded: 5
- Approximate total size: 86.89 MB

## License Metadata

- License present: yes
- License name: `cc-by-sa-4.0`
- License open: yes, with share-alike condition
- License evidence: Zenodo record metadata returned `cc-by-sa-4.0`.

## Content Metadata

- Main file formats: CSV, R, DOCX, ZIP

### Variables

- Candidate Y variables: unknown before data inspection
- Candidate Y typology: unknown
- Candidate X variables: archaeological, location, time-window, or cultural variables likely present
- Candidate X typology: unknown; expected spatial, temporal, categorical, identifier, and possibly continuous variables pending inspection
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
- Spatial signal: Americas point data and window coordinates
- Temporal signal: title explicitly mentions temporal patterns
- Structure: likely spatial points with temporal/cultural attributes
- N observations: 1722, extracted from metadata regex
- T periods: unknown
- N/T profile: N moderate, T unknown
- Spatial resolution: archaeological site or sampled individual/location, exact unit pending inspection
- Temporal resolution: archaeological time windows, exact resolution pending inspection
- Spatial extent: Americas
- Time range: unknown before data/DOCX/R inspection

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: unknown
  existing_model_or_equation: unknown
  evidence_source: title, R code, README/DOCX, and downloaded data
```

## Reproducibility

- Code available: yes, R code is included in downloaded material
- Repository: unknown
- Local data path: `data/candidates/datasets/zenodo/14499026/`
- Reproducibility status: partial; data and R code downloaded, workflow not inspected

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo record with DOI, explicit CC-BY-SA-4.0 license, data files, README/DOCX, and R code."
  rigour_score: 4
  rigour_evidence: "R code and documentation are present, but the model formulation still requires inspection."
  evidence_score: 4
  evidence_evidence: "DOI, license, landing URL, manifest, local downloads, and N estimate are available."
  coherence_score: 4
  coherence_evidence: "Manifest, files, and fiche identify the same Zenodo record and local directory."
  claim_discipline_score: 3
  claim_discipline_evidence: "The fiche does not infer the model equation before reading the R code and documentation."
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
- variable typology
