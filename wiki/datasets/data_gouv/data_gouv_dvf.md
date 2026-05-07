---
title: Data.gouv - Demandes de valeurs foncieres
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json]
tags: [dataset, data.gouv, DVF, property, cadastral, spatio-temporal, France, open-license, personal-data-risk]
---

Official raw DVF dissemination from DGFiP for property transactions over the latest five-year window.

## Identity

- Dataset ID: `data_gouv_dvf`
- Dataset name: Demandes de valeurs foncieres
- Source family: warehouse / open data portal
- Source: data.gouv.fr
- Source URL: https://www.data.gouv.fr/datasets/demandes-de-valeurs-foncieres
- Dataset DOI: none
- Title: Demandes de valeurs foncieres
- Producer: DGFiP
- Latest metadata update observed: 2026-04-07 modification timestamp in data.gouv.fr API

## Source Access

- API metadata URL: https://www.data.gouv.fr/api/1/datasets/demandes-de-valeurs-foncieres/
- Manifest: `data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json`
- Access type: open
- Download status: metadata-only; large yearly archives not downloaded in this turn
- Main resources: yearly `txt.zip` files for 2021-2025, each roughly 65-87 MB
- Documentation resources: FAQ, conditions of use, descriptive notice, personal-data information PDF

## License Metadata

- License present: yes
- License name: `Licence Ouverte / Open Licence version 2.0` (`lov2`)
- License open: yes, with personal-data reuse constraints documented by the producer
- License evidence: data.gouv.fr API returned `license: lov2` and `access_type: open`; dataset description warns against re-identification and external search-engine indexing.

## Content Metadata

- Main file formats: TXT.ZIP, PDF documentation

### Variables

- Candidate Y variables: `valeur_fonciere`, `surface_reelle_bati`, `surface_terrain`, `nombre_lots`, `nombre_pieces_principales`
- Candidate Y typology: continuous, count
- Candidate X variables: mutation date, nature of mutation, address fields, commune/departement codes, parcel identifiers, local type, land-use fields
- Candidate X typology: continuous, categorical, spatial, temporal, identifier, timestamp
- Variables inspected: official description and documentation list; yearly files not downloaded in this turn
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates:
    - date_mutation
    - nature_mutation
    - code_commune
    - code_departement
    - id_parcelle
    - type_local
    - nature_culture
    - surface_reelle_bati
    - surface_terrain
  x_selected: []
  selection_source: metadata
  selection_method: data_inspection_pending
  target_y: valeur_fonciere
  estimation_context: unknown
```

## Spatiotemporal

- Data type: spatio-temporal
- Spatial signal: cadastral parcel, commune, department, and territory exclusions documented by producer
- Temporal signal: yearly files and mutation dates; semiannual replacement updates in April and October
- Structure: transaction-level event data; panel only after aggregation by spatial unit and period
- N observations: unknown before file inspection
- T periods: 2021-2025 yearly resource window in API metadata; daily mutation dates inside files
- N/T profile: N very large, T medium
- Spatial resolution: parcel, commune, department
- Temporal resolution: transaction date and annual resource files
- Spatial extent: France metropolitan territory and DOM-TOM, excluding Alsace, Moselle, and Mayotte per dataset description
- Time range: 2021-01-01 to 2025-12-31 in API metadata

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: none
  modeling_task_hint: spatiotemporal_regression
  existing_model_or_equation: unknown
  evidence_source: data.gouv.fr metadata and official documentation links only
```

## Reproducibility

- Code available: no code repository identified
- Repository: data.gouv.fr resource hosting
- Local data path: not downloaded in this turn
- Reproducibility status: direct yearly archives and documentation are available; use requires legal controls around personal data

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: official_open_data_portal
  provenance_score: 4
  provenance_evidence: "The dataset is the official DGFiP DVF publication hosted on data.gouv.fr with API metadata and direct yearly archive resources."
  rigour_score: 4
  rigour_evidence: "The dataset includes official documentation, conditions of use, and standardized annual resource files, but local data inspection remains pending."
  evidence_score: 4
  evidence_evidence: "Official API metadata captured license, access type, temporal coverage, resource URLs, and documentation URLs."
  coherence_score: 4
  coherence_evidence: "The fiche follows the API metadata and the previously stored local manifest for DVF."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche preserves personal-data restrictions and does not claim direct modeling readiness before file inspection."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation metrics were not checked for this official administrative dataset."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[data_gouv]]
- spatiotemporal data
- [[data_leakage]]
- [[quality_pedigree_schema_v1]]
