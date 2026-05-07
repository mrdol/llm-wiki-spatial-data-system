---
title: INSEE - Chomage et halo autour du chomage series longues
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json, data/manifests/datasets/insee_emploi_chomage_population_active.json]
tags: [dataset, INSEE, labour-market, unemployment, France, temporal, open-license]
---

INSEE long-series labour-market table for unemployment and halo around unemployment, including an already downloaded CSV table by diploma, sex, and grouped age.

## Identity

- Dataset ID: `insee_chomage_halo_series_longues`
- Dataset name: Chomage et halo autour du chomage - series longues
- Source family: warehouse / national statistical source
- Source: INSEE
- Source URL: https://www.insee.fr/fr/statistiques/7625228
- Dataset DOI: none
- Title: Chomage et halo autour du chomage - Series longues
- Local predecessor ID: `insee_emploi_chomage_population_active`

## Source Access

- Publication page: https://www.insee.fr/fr/statistiques/7625228
- Download URL recorded locally: https://www.insee.fr/fr/statistiques/fichier/7625228/T304.csv
- Local download: `data/downloads/insee_t304_chomage_diplome.csv`
- Manifest: `data/manifests/datasets/insee_emploi_chomage_population_active.json`
- Download status: one CSV table already downloaded in previous run
- File format: CSV

## License Metadata

- License present: yes
- License name: `INSEE free reuse terms`
- License open: yes
- License evidence: INSEE conditions of use allow free reuse of publications and data on the site, including commercial reuse, subject to integrity and precise source attribution unless otherwise specified.

## Content Metadata

- Main file formats: CSV
- Downloaded table description: unemployment and unemployment rate in the ILO sense by highest diploma obtained, sex, and grouped age, annual average

### Variables

- Candidate Y variables: unemployment count, unemployment rate, halo indicators depending on table
- Candidate Y typology: count, rate
- Candidate X variables: year, diploma level, sex, grouped age, labour-market status categories
- Candidate X typology: temporal, categorical, identifier
- Variables inspected: manifest description only; CSV columns not inspected in this turn
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates:
    - year
    - diploma_level
    - sex
    - grouped_age
    - labour_market_status
  x_selected: []
  selection_source: metadata
  selection_method: data_inspection_pending
  target_y: unemployment_rate
  estimation_context: unknown
```

## Spatiotemporal

- Data type: temporal; spatial extension possible through localized unemployment sources but not pinned in this fiche
- Spatial signal: France national table; territorial variants exist but are not the downloaded table
- Temporal signal: long annual series
- Structure: time series with demographic-category cross-sections
- N observations: unknown before CSV inspection
- T periods: annual series, exact range pending CSV inspection
- N/T profile: N medium, T medium
- Spatial resolution: national France for downloaded table
- Temporal resolution: annual average
- Spatial extent: France
- Time range: unknown before CSV inspection

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: none
  modeling_task_hint: forecasting
  existing_model_or_equation: unknown
  evidence_source: INSEE publication page and local CSV manifest
```

## Reproducibility

- Code available: no code repository identified
- Repository: INSEE publication and CSV download
- Local data path: `data/downloads/insee_t304_chomage_diplome.csv`
- Reproducibility status: partial; one raw CSV table is already downloaded with URL, size, SHA-256, and timestamp in manifest

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: official_statistical_warehouse
  provenance_score: 4
  provenance_evidence: "INSEE publication page and local manifest identify the official source, raw CSV URL, local path, file size, and SHA-256."
  rigour_score: 4
  rigour_evidence: "The table is an official INSEE statistical result, but this fiche still needs direct CSV column inspection."
  evidence_score: 4
  evidence_evidence: "Local manifest records source URL, local download, format, description, size, checksum, and download timestamp."
  coherence_score: 4
  coherence_evidence: "The fiche maps the previous local manifest into the current AGENTS.md dataset format."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche does not overstate spatial suitability and separates national time-series evidence from localized unemployment variants."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation metrics were not checked for this official statistical table."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[insee]]
- [[france_unemployment_datasets_comparison]]
- variable typology
- [[quality_pedigree_schema_v1]]
