---
title: Zenodo 15781610 - Environmental Kuznets Curve - Poland NUTS2 and NUTS3
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: []
tags: [dataset, zenodo, spatial, panel, poland, nuts2, nuts3, environment, ekc, geojson, excel]
---

Données régionales polonaises aux niveaux NUTS2 et NUTS3 (Excel + GeoJSON) pour tester la courbe de Kuznets environnementale avec une structure spatiale explicite.

## Identity

- Dataset ID: `zenodo_15781610`
- Dataset name: Data at NUTS2 and NUTS3 level for Poland to confirm the Environmental Kuznets Curve
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/15781610
- Dataset DOI: `10.5281/zenodo.15781610`
- Year: 2025

## Source Access

- Files available:
  - `Dataset_NUTS2.xlsx` (0.05 MB) — panel data NUTS2
  - `Dataset_NUTS3.xlsx` (0.12 MB) — panel data NUTS3
  - `Dataset_NUTS_RG_01M_2024_4326_LEVL_2.geojson` (16.69 MB) — geometries NUTS2
  - `Dataset_NUTS_RG_01M_2024_4326_LEVL_3.geojson` (27.33 MB) — geometries NUTS3
- Download status: not yet downloaded

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata.

## Content Metadata

- Main file formats: Excel (XLSX) + GeoJSON
- Notable: GeoJSON geometries explicitly join the tabular data to spatial units — W matrix construction is straightforward from the geometries

### Variables

- Candidate Y variables: environmental indicator (emissions, pollution, or ecological footprint — to inspect in Excel file)
- Candidate Y typology: continuous
- Candidate X variables: GDP per capita or income, population density, industrial structure, possibly urbanisation rate, energy intensity (standard EKC regressors — to confirm by inspection)
- Candidate X typology: continuous, spatial
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates: [gdp_per_capita, population_density, industrial_structure, urbanisation_rate, energy_intensity]
  x_selected: []
  selection_source: domain_knowledge_ekc
  selection_method: domain_choice
  target_y: environmental_indicator
  estimation_context: spatial_regression_ekc
```

## Spatiotemporal

- Data type: spatial panel
- Spatial signal: NUTS2 (16 regions) and NUTS3 (73 subregions) with explicit GeoJSON geometries for W construction
- Temporal signal: panel dimension present (years — exact range to confirm by inspection of Excel file)
- Structure: panel (NUTS regions × years)
- N observations: 16 (NUTS2) / 73 (NUTS3)
- T periods: unknown before inspection
- N/T profile: N very small (NUTS2) to small (NUTS3), T unknown — potential small-N spatial panel
- Spatial resolution: NUTS2 or NUTS3 (two separate datasets)
- Temporal resolution: annual (standard for EKC regional analyses)
- Spatial extent: Poland (national)
- Time range: unknown before inspection

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: spatial_regression
  existing_model_or_equation: "Environmental Kuznets Curve: E = f(GDP, GDP^2, controls) with spatial autocorrelation; possible SAR or SEM formulation at regional level"
  evidence_source: Zenodo title, keywords, and standard EKC literature
```

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: not yet downloaded
- Reproducibility status: Excel + GeoJSON available on Zenodo; analysis scripts not confirmed

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo DOI-backed record with cc-by-4.0. Provides both tabular (Excel) and spatial (GeoJSON) files. NUTS geometries sourced from Eurostat 2024 release."
  rigour_score: 3
  rigour_evidence: "Keywords and title clearly state EKC and NUTS level. Variable content requires inspection of Excel to confirm Y and X. N very small at NUTS2 (16 regions)."
  evidence_score: 4
  evidence_evidence: "DOI, landing URL, four files with sizes documented. GeoJSON files are large and likely the official Eurostat NUTS 2024 polygons."
  coherence_score: 4
  coherence_evidence: "Two spatial granularities (NUTS2, NUTS3) with matching geometries. Structure is coherent with a regional panel EKC study."
  claim_discipline_score: 4
  claim_discipline_evidence: "Fiche keeps variable content as unknown pending inspection. EKC modeling task is inferred from standard literature, not from inspected data."
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
- [[spatial_heterogeneity]]
- [[spboost]]
- [[mgwrsar]]
