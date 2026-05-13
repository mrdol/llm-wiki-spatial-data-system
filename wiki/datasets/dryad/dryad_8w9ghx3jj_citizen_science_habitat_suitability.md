---
title: Dryad 8w9ghx3jj - Citizen Science Habitat Suitability Modelling
type: dataset
created: 2026-05-07
updated: 2026-05-12
sources:
  - data/manifests/datasets/dryad_8w9ghx3jj_evidence_2026_05_12.json
  - data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl
  - data/manifests/runs/rejected_2026_05_12_dryad_8w9ghx3jj_files_recheck.json
tags: [dataset, dryad, spatial, temporal, species-distribution, habitat-suitability, regression, cc0]
---

Dryad dataset comparing citizen-science opportunistic reporting and systematic protocols for habitat suitability modelling in Sweden.

## Identity

- Dataset ID: `dryad_8w9ghx3jj`
- Dataset name: Data from: Assessing the usefulness of Citizen Science Data for habitat suitability modelling: opportunistic reporting versus sampling based on a systematic protocol
- Source family: warehouse / research repository
- Source: Dryad
- Source URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.8w9ghx3jj
- Dataset DOI: `10.5061/dryad.8w9ghx3jj`
- Year: 2021
- Linked paper DOI: `10.1111/ddi.13128`
- Linked paper: Assessing the usefulness of citizen science data for habitat suitability modelling: Opportunistic reporting versus sampling based on a systematic protocol

## Source Description

> The source description states that the dataset compares opportunistic reporting with systematic protocol data for modelling species distributions. It covers eight forest bird species across Sweden during 2000-2013 and uses logistic regression, AUC, spatial prediction congruence, inferred absences and sampling-bias checks.

- Description source: Dryad API metadata
- Description URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.8w9ghx3jj
- Full description stored in: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Description captured at: 2026-05-07

## Source Access

- Manifest: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Evidence manifest: `data/manifests/datasets/dryad_8w9ghx3jj_evidence_2026_05_12.json`
- Network recheck manifest: `data/manifests/runs/rejected_2026_05_12_dryad_8w9ghx3jj_files_recheck.json`
- Download status: metadata scraped; file URLs captured, files not downloaded in this ingest
- Files listed: 16
- Main file format: CSV
- Approximate total size: 30.18 MB
- First file URL: https://datadryad.org/api/v2/files/372529/download

## Source Traceability

- Authoritative record checked: https://datadryad.org/api/v2/datasets/doi%3A10.5061%2Fdryad.8w9ghx3jj
- Authoritative version-files endpoint checked: https://datadryad.org/api/v2/versions/75134/files
- Network status on 2026-05-12: `200 OK`
- Matching source record in local JSONL: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`, line `3`
- Matching local record ID: `doi:10.5061/dryad.8w9ghx3jj`
- Non-matching record to ignore for this fiche: `doi:10.5061/dryad.v41ns1rvb`, line `1` of the same JSONL, about Philippine forest loss.
- Traceability conclusion: the fiche identity matches the Dryad DOI and the line 3 record; previous mismatch reports came from reading another record in the same multi-record manifest.

## License Metadata

- License present: yes
- License name: `CC0-1.0`
- License URL: https://spdx.org/licenses/CC0-1.0.html
- License open: yes
- License evidence: Dryad API record returned the SPDX CC0-1.0 license URL.

## Content Metadata

### Variables

- Candidate Y variables: species presence/absence, habitat suitability, predictive performance metrics, AUC
- Candidate Y typology: binary, continuous, rate
- Candidate X variables: species, reporting protocol, spatial predictors, environmental predictors, inferred absences, time period
- Candidate X typology: spatial, temporal, categorical, continuous, imputed, identifier
- Variables inspected: no
- Presence of imputed X: yes, inferred absences are described by the source

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates: [species, reporting_protocol, spatial_predictors, environmental_predictors, inferred_absences, time_period]
  x_selected: [reporting_protocol, spatial_predictors, environmental_predictors, inferred_absences, time_period]
  selection_source: metadata
  selection_method: author selection
  target_y: species_presence_absence_or_habitat_suitability
  estimation_context: logistic_regression_species_distribution_models
```

## Spatiotemporal

- Data type: spatial / spatio-temporal
- Spatial signal: Sweden, nationwide habitat-suitability modelling and spatial predictions
- Temporal signal: 2000-2013
- Structure: species-by-protocol tabular files, likely repeated observations across space and time
- N observations: unknown before CSV inspection
- T periods: 14 years indicated by source description, pending file inspection
- N/T profile: N likely large, T medium
- Spatial resolution: occurrence or sampling/reporting locations, exact unit pending CSV inspection
- Temporal resolution: observation/reporting period pending CSV inspection
- Spatial extent: Sweden
- Time range: 2000-2013

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: 10.1111/ddi.13128
  paper_title: Assessing the usefulness of citizen science data for habitat suitability modelling: Opportunistic reporting versus sampling based on a systematic protocol
  paper_year: 2020
  modeling_task_hint: classification
  existing_model_or_equation: logistic regression for species distribution / habitat suitability models
  evidence_source: Dryad source description and article metadata
```

## Linked Papers

- Paper title: Assessing the usefulness of citizen science data for habitat suitability modelling: Opportunistic reporting versus sampling based on a systematic protocol
- Paper DOI: `10.1111/ddi.13128`
- Journal: Diversity and Distributions
- Year: 2020
- Link evidence: Dryad record is titled as data from this article; publisher metadata and bibliographic pages expose the DOI.

## Reproducibility

- Code available: unknown
- Repository: Dryad
- Local data path: none; file URLs captured only
- Reproducibility status: partial; dataset DOI, license, file URLs and modeling description are available, but CSV/schema inspection is pending

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Dryad record provides DOI, source description, CC0 license, and 16 CSV file records."
  rigour_score: 4
  rigour_evidence: "The source description documents study aim, location, period, species-distribution modelling method, validation metric and protocol comparison."
  evidence_score: 4
  evidence_evidence: "Dataset DOI, linked paper DOI, landing URL, license URL, single-record evidence manifest, file download URLs and model evidence are captured."
  coherence_score: 4
  coherence_evidence: "The title, description, DOI, JSONL line 3, evidence manifest and 16 Dryad files consistently describe citizen-science habitat suitability data."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche records logistic-regression evidence from the source and keeps exact variable/schema inspection pending."
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
- [[spatiotemporal_data]]
- [[quality_pedigree_schema_v1]]
