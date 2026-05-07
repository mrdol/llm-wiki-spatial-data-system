---
title: Dryad v41ns1rvb - Forest Loss in the Cordillera Administrative Region
type: dataset
created: 2026-05-07
updated: 2026-05-07
sources: [data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl]
tags: [dataset, dryad, spatial, spatiotemporal, forest-loss, remote-sensing, cc0]
---

Dryad dataset for spatio-temporal forest-loss analysis in the Cordillera Administrative Region, Philippines.

## Identity

- Dataset ID: `dryad_v41ns1rvb`
- Dataset name: Spatio-temporal analysis of remotely sensed forest loss data in the Cordillera Administrative Region, Philippines
- Source family: warehouse / research repository
- Source: Dryad
- Source URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.v41ns1rvb
- Dataset DOI: `10.5061/dryad.v41ns1rvb`
- Year: 2021

## Source Description

> The Cordillera Administrative Region in the Philippines is described as a remaining forest frontier and watershed region. The source description states that the dataset supports analysis of spatial and temporal forest-loss patterns, relationships between forest loss and seven independent variables, and use of Hansen Global Forest Change data from 2001 to 2019.

- Description source: Dryad API metadata
- Description URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.v41ns1rvb
- Full description stored in: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Description captured at: 2026-05-07

## Source Access

- Manifest: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Download status: metadata scraped; file URL captured, file not downloaded in this ingest
- Files listed: 1
- Main file format: XLSX
- File URL: https://datadryad.org/api/v2/files/1141211/download
- Approximate total size: 0.01 MB

## License Metadata

- License present: yes
- License name: `CC0-1.0`
- License URL: https://spdx.org/licenses/CC0-1.0.html
- License open: yes
- License evidence: Dryad API record returned the SPDX CC0-1.0 license URL.

## Content Metadata

### Variables

- Candidate Y variables: forest loss area, annual deforestation rate, forest-loss detection/extent
- Candidate Y typology: continuous, rate, count
- Candidate X variables: forest cover, agricultural areas, built-up areas, road network, socio-economic variables, time/year, administrative or spatial units
- Candidate X typology: spatial, temporal, continuous, categorical, identifier, timestamp, unknown
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: 7
  x_candidates: [forest_cover, agricultural_areas, built_up, road_network, socio_economic_data, spatial_unit, year]
  x_selected: []
  selection_source: source_description
  selection_method: author_selection
  target_y: forest_loss
  estimation_context: correlation_analysis
```

## Spatiotemporal

- Data type: spatio-temporal
- Spatial signal: Cordillera Administrative Region, Philippines; watershed/province/region context
- Temporal signal: Hansen Global Forest Change period 2001-2019
- Structure: likely regional or administrative spatial units observed across years
- N observations: unknown before XLSX inspection
- T periods: 19 years indicated by source description, pending file inspection
- N/T profile: N unknown, T medium
- Spatial resolution: administrative or forest-cover analysis units, exact unit pending file inspection
- Temporal resolution: annual forest-loss observations
- Spatial extent: Cordillera Administrative Region, Philippines
- Time range: 2001-2019

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: spatiotemporal_regression
  existing_model_or_equation: Pearson correlation coefficient between forest loss and seven independent variables
  evidence_source: Dryad source description
```

## Reproducibility

- Code available: unknown
- Repository: Dryad
- Local data path: none; file URL captured only
- Reproducibility status: partial; dataset DOI, license, file URL and description are available, but direct XLSX inspection is pending

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Dryad record provides DOI, source description, CC0 license, and file-level metadata."
  rigour_score: 3
  rigour_evidence: "The description documents source data, period and correlation variables, but the XLSX schema was not inspected."
  evidence_score: 4
  evidence_evidence: "DOI, landing URL, license URL, manifest and file download URL are captured."
  coherence_score: 4
  coherence_evidence: "The Dryad title, description, file metadata and fiche consistently describe forest-loss analysis in CAR, Philippines."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche limits variable and model claims to what Dryad metadata states and marks file inspection as pending."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation metrics were not checked during this scraping run."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[dryad]]
- spatiotemporal data
- [[quality_pedigree_schema_v1]]
