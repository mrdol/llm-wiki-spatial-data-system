---
title: Dryad 8w9ghx3jj - Citizen Science Habitat Suitability Modelling
type: dataset
created: 2026-05-07
updated: 2026-05-07
sources: [data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl]
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

## Source Description

> The source description states that the dataset compares opportunistic reporting with systematic protocol data for modelling species distributions. It covers eight forest bird species across Sweden during 2000-2013 and uses logistic regression, AUC, spatial prediction congruence, inferred absences and sampling-bias checks.

- Description source: Dryad API metadata
- Description URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.8w9ghx3jj
- Full description stored in: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Description captured at: 2026-05-07

## Source Access

- Manifest: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Download status: metadata scraped; file URLs captured, files not downloaded in this ingest
- Files listed: 16
- Main file format: CSV
- Approximate total size: 30.18 MB
- First file URL: https://datadryad.org/api/v2/files/372529/download

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
  x_selected: []
  selection_source: source_description
  selection_method: author_selection
  target_y: species_distribution_or_habitat_suitability
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
  paper_doi: unknown
  modeling_task_hint: classification
  existing_model_or_equation: logistic regression for species distribution / habitat suitability models
  evidence_source: Dryad source description
```

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
  evidence_evidence: "DOI, landing URL, license URL, manifest, file download URLs and model evidence are captured."
  coherence_score: 4
  coherence_evidence: "The title, description and files consistently describe citizen-science habitat suitability data."
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
- spatiotemporal data
- [[quality_pedigree_schema_v1]]
