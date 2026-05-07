---
title: Zenodo 15627695 - Fiscal Spillovers in Property Tax Revenues - Mexican Municipalities
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: []
tags: [dataset, zenodo, spatial, panel, mexico, municipalities, fiscal, property-tax, dynamic-spatial, econometrics]
---

Panel non balancé de municipalités mexicaines (2001-2019) avec revenus de taxe foncière, revenus municipaux totaux et retards spatiaux pour l'estimation de modèles économétriques spatiaux dynamiques.

## Identity

- Dataset ID: `zenodo_15627695`
- Dataset name: Dataset for the paper "Fiscal Spillovers in Property Tax Revenues: Evidence from Mexican Municipalities"
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/15627695
- Dataset DOI: `10.5281/zenodo.15627695`
- Year: 2025

## Source Access

- Download URL: https://zenodo.org/records/15627695/files/panel.csv
- File format: CSV
- Approximate size: 8.77 MB
- Download status: not yet downloaded

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata.

## Content Metadata

- Main file format: CSV (`panel.csv`)

### Variables

- Candidate Y variables: property tax revenues per capita, property tax effort ratio
- Candidate Y typology: continuous
- Candidate X variables: total municipal income, lagged taxation ratios, spatially lagged property tax revenues, spatially lagged income variables
- Candidate X typology: continuous, lagged, spatial
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates: [total_municipal_income, lagged_taxation_ratio, spatial_lag_property_tax, spatial_lag_income]
  x_selected: []
  selection_source: paper_description
  selection_method: author_selection
  target_y: property_tax_revenues_pc
  estimation_context: dynamic_spatial_econometric_model
```

## Spatiotemporal

- Data type: spatial panel
- Spatial signal: municipalities as spatial units; spatially lagged variables explicitly included (W matrix implied)
- Temporal signal: annual observations 2001-2019; lagged regressors confirm temporal dimension
- Structure: panel (unbalanced, municipalities × years)
- N observations: unknown before inspection (approximately 1,000-2,500 municipality-year pairs)
- T periods: 19
- N/T profile: N moderate-large, T moderate — suited to dynamic spatial panel estimators
- Spatial resolution: municipality (municipio)
- Temporal resolution: annual
- Spatial extent: Mexico (national scope, subset of municipalities)
- Time range: 2001-2019

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: spatial_panel_regression
  existing_model_or_equation: "dynamic spatial econometric model; spatial lag or SDM with lagged dependent variable; interjurisdictional tax competition / yardstick competition"
  evidence_source: Zenodo description
```

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: not yet downloaded
- Reproducibility status: CSV available on Zenodo; code and estimation scripts not confirmed

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo DOI-backed record with cc-by-4.0 license. CSV format directly usable. Supports a peer-reviewed spatial econometrics paper."
  rigour_score: 4
  rigour_evidence: "Description explicitly documents unbalanced panel structure, T=19, fiscal variables, and spatial lag context for dynamic spatial econometric estimation."
  evidence_score: 4
  evidence_evidence: "DOI, direct CSV download URL, file size documented. Open license confirmed."
  coherence_score: 4
  coherence_evidence: "Panel structure, variable roles (Y=property tax revenues, X=income, lags, spatial lags), and econometric context are coherent."
  claim_discipline_score: 4
  claim_discipline_evidence: "Fiche stays within Zenodo description. N not stated explicitly; marked as unknown for inspection."
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
- [[zenodo_15530852_mexico_municipalities_expenditure]]
