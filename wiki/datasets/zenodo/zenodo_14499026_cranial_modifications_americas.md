---
title: Zenodo 14499026 - Cranial Modifications in the Americas
type: dataset
created: 2026-05-06
updated: 2026-05-12
sources:
  - data/manifests/datasets/zenodo_14499026_evidence_2026_05_12.json
  - data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl
  - data/manifests/runs/rejected_2026_05_12_network_recheck.json
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
- Concept DOI: `10.5281/zenodo.14499025`
- Title: Analytical Dataset and R Code for Manuscript "Intentional cranial modifications in the Americas - the temporal and spatial patterns of potential transmissions and cultural innovations"
- Year: 2026
- Linked paper DOI: `10.1016/j.isci.2026.115643`

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/14499026/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Evidence manifest: `data/manifests/datasets/zenodo_14499026_evidence_2026_05_12.json`
- Download status: downloaded
- Files downloaded: 5
- Approximate total size: 86.89 MB
- Confirmed files: `Final Points Data Americas 21 May 2025.csv`, `Final Code ICM Paper 21 May 2025.R`, `Read Me 16 Dec 2024.docx`, `Window Coordinates.zip`, `Data for Margins Plot 27 May 2025.csv`

## Source Traceability

- Authoritative record checked: https://zenodo.org/api/records/14499026
- Network status on 2026-05-12: `200 OK`
- Matching source record in local JSONL: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`, line `3`
- Matching local record ID: `14499026`
- Non-matching record to ignore for this fiche: `18421412`, line `1` of the same JSONL, about Climate-Fire relationships.
- Traceability conclusion: the fiche identity matches Zenodo record `14499026`; previous mismatch reports came from reading another record in the same multi-record manifest.

## License Metadata

- License present: yes
- License name: `cc-by-sa-4.0`
- License open: yes, with share-alike condition
- License evidence: Zenodo record metadata returned `cc-by-sa-4.0`.

## Content Metadata

- Main file formats: CSV, R, DOCX, ZIP

### Variables

- Candidate Y variables: `oldbp`, `midbp`, `icm`
- Candidate Y typology: continuous, categorical
- Candidate X variables: `x`, `y`, `country`, `contin`, `countryn`, `region`, ICM subtype and derived spatial windows
- Candidate X typology: spatial, temporal, categorical, identifier, continuous
- Variables inspected: yes, CSV headers and R code inspected
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: 10 raw CSV columns
  x_candidates: [id, x, y, oldbp, midbp, icm, country, contin, countryn, region]
  x_selected: [x, y, oldbp, icm]
  selection_source: data inspection
  selection_method: author selection
  target_y: oldbp_or_icm
  estimation_context: spatiotemporal point-pattern analysis, Moran test, spatial error regression, empirical Bayesian kriging
```

## Spatiotemporal

- Data type: spatio-temporal candidate
- Spatial signal: Americas point data and window coordinates
- Temporal signal: title explicitly mentions temporal patterns
- Structure: spatial point table with temporal and cultural attributes plus R analysis workflow
- N observations: 2048 raw CSV rows; linked iScience paper reports n=1772 after analytical filtering
- T periods: continuous/dated years BP, not a regular panel T
- N/T profile: cross-sectional spatiotemporal event points, not a regular N-by-T panel
- Spatial resolution: archaeological site or sampled individual/location, exact unit pending inspection
- Temporal resolution: years BP fields `oldbp` and `midbp`
- Spatial extent: Americas
- Time range: at least 50-10000 years BP in inspected raw CSV; paper summary describes at least 10000 years

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: 10.1016/j.isci.2026.115643
  paper_title: Intentional cranial modifications in the Americas - the temporal and spatial patterns of potential transmissions and cultural innovations
  paper_year: 2026
  modeling_task_hint: spatiotemporal_regression
  existing_model_or_equation: empirical Bayesian kriging surfaces, point-pattern analysis, Moran test, and spatial error regression in R code; exact paper formula not extracted
  evidence_source: Zenodo title, downloaded R code, local CSV, and iScience article metadata
```

## Linked Papers

- Paper title: Intentional cranial modifications in the Americas - the temporal and spatial patterns of potential transmissions and cultural innovations
- Paper DOI: `10.1016/j.isci.2026.115643`
- Journal: iScience
- Year: 2026
- Link evidence: Zenodo record title says the files are for this manuscript; ScienceDirect and author profile expose the DOI.

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
  rigour_evidence: "R code, documentation, paper DOI, and local CSV headers are present; full workflow interpretation still requires human review."
  evidence_score: 5
  evidence_evidence: "Dataset DOI, paper DOI, license, landing URL, single-record evidence manifest, local downloads, CSV row count, and R code signals are available."
  coherence_score: 4
  coherence_evidence: "Evidence manifest, Zenodo API, local JSONL line 3, files, and fiche identify the same Zenodo record and local directory."
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
- [[spatiotemporal_data]]
- [[variable_typology]]
