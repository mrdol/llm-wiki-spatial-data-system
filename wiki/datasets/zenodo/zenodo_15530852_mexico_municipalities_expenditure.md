---
title: Zenodo 15530852 - Public Expenditure Spillovers - Mexican Municipalities Panel
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: []
tags: [dataset, zenodo, spatial, panel, mexico, municipalities, fiscal, econometrics, downloaded]
---

Panel de 860 municipalités mexicaines (2000-2021) avec variables fiscales, socioéconomiques et spatiales pour l'étude des spillovers de dépenses publiques.

## Identity

- Dataset ID: `zenodo_15530852`
- Dataset name: Dataset for the paper "Evidence of Public Expenditure Spillovers in Mexico: Measuring Spatial Interactions Among Municipalities"
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/15530852
- Dataset DOI: `10.5281/zenodo.15530852`
- Year: 2025

## Source Access

- Download URL: https://zenodo.org/records/15530852/files/MUNICIPIOS_19.2.dta
- File format: Stata DTA
- Approximate size: 14 MB
- Download status: not yet downloaded

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata.

## Content Metadata

- Main file format: Stata DTA (`MUNICIPIOS_19.2.dta`)

### Variables

- Candidate Y variables: total expenditure per capita, capital formation per capita, subsidies per capita, service expenditure per capita
- Candidate Y typology: continuous
- Candidate X variables: household income, employment rate, political alignment, migration rate, federal transfers per capita, local taxation, population density, reelection eligibility, spatially lagged expenditure variables
- Candidate X typology: continuous, categorical, lagged, spatial
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates: [household_income, employment_rate, political_alignment, migration_rate, federal_transfers_pc, local_taxation, population_density, reelection_eligibility, spatially_lagged_expenditure]
  x_selected: []
  selection_source: paper_description
  selection_method: author_selection
  target_y: total_expenditure_pc
  estimation_context: spatial_panel_regression
```

## Spatiotemporal

- Data type: spatial panel
- Spatial signal: municipalities as spatial units with spatially lagged variables (W matrix implied)
- Temporal signal: annual observations 2000-2021
- Structure: panel (balanced, N=860 municipalities, T=22 years)
- N observations: 860
- T periods: 22
- N/T profile: N large, T moderate — standard spatial panel setup
- Spatial resolution: municipality (municipio)
- Temporal resolution: annual
- Spatial extent: Mexico (national, 860 municipalities)
- Time range: 2000-2021

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: spatial_panel_regression
  existing_model_or_equation: "spatial panel model with spatially lagged dependent variable and/or spatially lagged regressors (SAR / SDM family); interjurisdictional spillovers in public expenditure"
  evidence_source: Zenodo description
```

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: not yet downloaded
- Reproducibility status: data available on Zenodo; code availability not confirmed

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo DOI-backed record with cc-by-4.0 license. Dataset supports a peer-reviewed paper on spatial econometrics."
  rigour_score: 4
  rigour_evidence: "Description explicitly documents N=860, T=22, fiscal and spatial lag variables, and the econometric context. Well-structured Stata file."
  evidence_score: 4
  evidence_evidence: "DOI, landing page, and direct download URL available. File format and size documented."
  coherence_score: 4
  coherence_evidence: "Description is internally consistent: panel structure, variable roles, and spatial lag context all align."
  claim_discipline_score: 4
  claim_discipline_evidence: "Fiche faithfully reflects Zenodo description without extrapolation. Variables and structure stated, not inferred."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citations not checked at scraping time."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[zenodo]]
- spatiotemporal data
- spatial panel
- [[spatial_autocorrelation]]
- [[spboost]]
- [[mgwrsar]]
