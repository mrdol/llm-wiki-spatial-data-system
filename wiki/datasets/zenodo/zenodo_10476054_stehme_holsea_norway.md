---
title: Zenodo 10476054 - STEHME and HOLSEA Norway Sea-Level Files
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl]
tags: [dataset, zenodo, spatial, temporal, netcdf, sea-level, downloaded]
---

Dataset candidat Zenodo contenant des fichiers STEHME et HOLSEA pour des dynamiques holocenes de niveau marin en Norvege.

## Identity

- Dataset ID: `zenodo_10476054`
- Dataset name: STEHME files & HOLSEA spreadsheet for Creel et al. 2022 and Balascio et al. 2023 sea-level studies in Norway
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/10476054
- Dataset DOI: `10.5281/zenodo.10476054`
- Title: STEHME files & HOLSEA spreadsheet for Creel et al. 2022 and Balascio et al. 2023 sea-level studies in Norway
- Year: 2024

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/10476054/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Download status: partially downloaded under size filter
- Files downloaded: 2 NetCDF files
- Approximate downloaded size: 25.18 MB

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata returned `cc-by-4.0`.

## Content Metadata

- Main file formats: NetCDF, CSV available on record

### Variables

- Candidate Y variables: sea-level or sea-level uncertainty variables, to inspect
- Candidate Y typology: continuous or unknown pending NetCDF/spreadsheet inspection
- Candidate X variables: spatial coordinates, time/depth/index variables, to inspect
- Candidate X typology: spatial, temporal, continuous, identifier, geometry, or unknown pending inspection
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
  target_y: sea_level_or_uncertainty_unknown
  estimation_context: unknown
```

## Spatiotemporal

- Data type: spatio-temporal candidate
- Spatial signal: northern Norway / Lofoten and Vesteralen archipelagos
- Temporal signal: Holocene sea-level dynamics
- Structure: gridded or indexed NetCDF data plus spreadsheet material
- N observations: unknown
- T periods: unknown
- N/T profile: unknown
- Spatial resolution: NetCDF grid or sea-level site index, exact resolution pending inspection
- Temporal resolution: Holocene time/depth index, exact resolution pending inspection
- Spatial extent: northern Norway, including Lofoten and Vesteralen archipelagos
- Time range: Holocene, exact range pending inspection

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: unknown
  existing_model_or_equation: unknown
  evidence_source: title and downloaded NetCDF files
```

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: `data/candidates/datasets/zenodo/10476054/`
- Reproducibility status: partial; NetCDF files downloaded under size filter, spreadsheet material still requires access/inspection

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo record with DOI, explicit CC-BY-4.0 license, and downloaded NetCDF files."
  rigour_score: 3
  rigour_evidence: "Dataset appears linked to published sea-level studies, but DOI links and variables require inspection."
  evidence_score: 4
  evidence_evidence: "DOI, license, landing URL, manifest, and local NetCDF downloads are available."
  coherence_score: 4
  coherence_evidence: "Manifest and local files match Zenodo record 10476054."
  claim_discipline_score: 3
  claim_discipline_evidence: "The fiche does not claim direct estimator suitability before NetCDF inspection."
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
