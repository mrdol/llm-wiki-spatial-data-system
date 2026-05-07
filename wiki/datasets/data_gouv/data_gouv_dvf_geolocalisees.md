---
title: Data.gouv - Demandes de valeurs foncieres geolocalisees
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json]
tags: [dataset, data.gouv, DVF, geospatial, property, spatio-temporal, France, open-license]
---

Geolocated DVF derivative with normalized property-transaction fields, parcel identifiers, commune codes, dates, and WGS-84 coordinates.

## Identity

- Dataset ID: `data_gouv_dvf_geolocalisees`
- Dataset name: Demandes de valeurs foncieres geolocalisees
- Source family: warehouse / open data portal
- Source: data.gouv.fr
- Source URL: https://www.data.gouv.fr/datasets/demandes-de-valeurs-foncieres-geolocalisees
- Dataset DOI: none
- Title: Demandes de valeurs foncieres geolocalisees
- Producer: Etalab / data.gouv.fr derivative from DGFiP DVF
- Latest metadata update observed: 2026-05-06 API timestamp

## Source Access

- API metadata URL: https://www.data.gouv.fr/api/1/datasets/demandes-de-valeurs-foncieres-geolocalisees/
- Manifest: `data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json`
- Access type: open
- Download status: metadata-only; large files not downloaded in this turn
- Main resource: `dvf.csv.gz`, approximately 523.25 MB
- CSV directory: https://files.data.gouv.fr/geo-dvf/latest/csv/

## License Metadata

- License present: yes
- License name: `Licence Ouverte / Open Licence version 2.0` (`lov2`)
- License open: yes
- License evidence: data.gouv.fr API returned `license: lov2` and `access_type: open`.

## Content Metadata

- Main file formats: CSV, CSV.GZ, URL documentation

### Variables

- Candidate Y variables: `valeur_fonciere`, `surface_reelle_bati`, `surface_terrain`, `nombre_lots`, `nombre_pieces_principales`
- Candidate Y typology: continuous, count
- Candidate X variables: `date_mutation`, `nature_mutation`, `code_commune`, `code_departement`, `id_parcelle`, `type_local`, `nature_culture`, `longitude`, `latitude`, address and lot fields
- Candidate X typology: continuous, categorical, spatial, temporal, identifier, geometry, timestamp
- Variables inspected: schema extracted from data.gouv.fr dataset description, not from downloaded data file
- Presence of imputed X: unknown; geocoding and normalization are documented, but imputation status was not inspected

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
    - longitude
    - latitude
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
- Spatial signal: WGS-84 latitude/longitude, parcel identifier, commune and department codes
- Temporal signal: `date_mutation`, semiannual updates, API temporal coverage 2020-07-01 to 2025-12-31
- Structure: transaction-level event data, usable as repeated spatial cross-sections or panel after aggregation
- N observations: unknown before file inspection
- T periods: daily event dates; aggregate T depends on chosen temporal grouping
- N/T profile: N very large, T medium
- Spatial resolution: parcel, commune, department, coordinate point
- Temporal resolution: transaction date
- Spatial extent: France, data.gouv API zone `country:fr`
- Time range: 2020-07-01 to 2025-12-31 in API metadata

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: none
  modeling_task_hint: spatiotemporal_regression
  existing_model_or_equation: unknown
  evidence_source: data.gouv.fr metadata and schema description only
```

## Reproducibility

- Code available: no code repository identified
- Repository: data.gouv.fr resource hosting
- Local data path: not downloaded
- Reproducibility status: strong metadata traceability; raw file download is direct but large

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: official_open_data_portal
  provenance_score: 4
  provenance_evidence: "data.gouv.fr API identifies the dataset, producer route, open access type, license, resources, temporal coverage, and landing page."
  rigour_score: 3
  rigour_evidence: "The schema is documented and derived from official DGFiP DVF, but the generated geocoding layer and data values were not inspected locally."
  evidence_score: 4
  evidence_evidence: "Official API metadata, landing page, resource URLs, license, and temporal coverage were captured in the local manifest."
  coherence_score: 4
  coherence_evidence: "The fiche fields match the API metadata and the previous local manifest for this dataset."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche flags file inspection, imputation status, N, and model equation as pending instead of inferring them."
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
- variable typology
- [[quality_pedigree_schema_v1]]
