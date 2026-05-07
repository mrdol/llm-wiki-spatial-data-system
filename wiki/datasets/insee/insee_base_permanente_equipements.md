---
title: INSEE - Base permanente des equipements
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json, data/manifests/datasets/insee_base_permanente_equipements.json]
tags: [dataset, INSEE, BPE, territorial, spatial, spatio-temporal, equipment, France, open-license]
---

Annual INSEE territorial database of public-facing equipment and services with commune, IRIS, supra-communal, and coordinate-level metadata.

## Identity

- Dataset ID: `insee_base_permanente_equipements`
- Dataset name: Base permanente des equipements
- Source family: warehouse / national statistical source
- Source: INSEE
- Source URL: https://www.insee.fr/fr/metadonnees/source/serie/s1161
- Dataset DOI: none
- Title: Base permanente des equipements
- Latest millesime observed: 2024
- Publication observed: 2026-04-28 for BPE 2024 access page

## Source Access

- Metadata page: https://www.insee.fr/fr/metadonnees/source/serie/s1161
- Access page: https://www.insee.fr/fr/metadonnees/source/operation/s2216/bases-donnees-ligne
- Manifest: `data/manifests/datasets/france_official_datasets_metadata_2026_05_06.json`
- Download status: metadata-only in this turn
- Access mode: downloadable CSV, API, and explorer according to the BPE 2024 access page

## License Metadata

- License present: yes
- License name: `Licence Ouverte / Open License` for INSEE catalogue datasets
- License open: yes
- License evidence: INSEE catalogue documentation states that statistical datasets are made available under Licence Ouverte / Open License; INSEE reuse terms also allow free reuse with source attribution unless otherwise specified.

## Content Metadata

- Main file formats: CSV, API, explorer; older manifests mention DBF for earlier millesimes
- Equipment scope: 229 equipment/service types in 2024
- Domain count: 7 major domains

### Variables

- Candidate Y variables: equipment counts, equipment presence indicators, service availability measures
- Candidate Y typology: count, binary, presence_absence
- Candidate X variables: equipment type, domain, range grouping, commune code, IRIS code, supra-communal zoning, coordinates, annual millesime, complementary domain variables
- Candidate X typology: categorical, spatial, temporal, identifier, geometry
- Variables inspected: source metadata and BPE access-page description; downloaded files not inspected in this turn
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates:
    - equipment_type
    - equipment_domain
    - commune_code
    - iris_code
    - coordinates
    - zoning
    - millesime
    - complementary_domain_variables
  x_selected: []
  selection_source: metadata
  selection_method: data_inspection_pending
  target_y: equipment_count_or_presence
  estimation_context: unknown
```

## Spatiotemporal

- Data type: spatio-temporal territorial inventory
- Spatial signal: commune, IRIS, supra-communal zoning, and coordinate-level localization
- Temporal signal: annual BPE millesimes at 1 January
- Structure: repeated annual cross-sections; panel possible after harmonizing geography and equipment types
- N observations: unknown before file inspection
- T periods: annual millesimes; latest observed BPE 2024
- N/T profile: N large, T medium
- Spatial resolution: commune, IRIS, supra-communal zoning, coordinates
- Temporal resolution: annual snapshot at 1 January
- Spatial extent: France
- Time range: annual series; exact historical range to confirm from downloaded products

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: none
  modeling_task_hint: count_model
  existing_model_or_equation: unknown
  evidence_source: INSEE source and access pages only
```

## Reproducibility

- Code available: no code repository identified
- Repository: INSEE website, API, and catalogue
- Local data path: not downloaded in this turn
- Reproducibility status: strong official metadata and access routes; file-level schema inspection pending

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: official_statistical_warehouse
  provenance_score: 4
  provenance_evidence: "INSEE official metadata and BPE 2024 access pages document the source, scope, access routes, domains, equipment types, and geography."
  rigour_score: 4
  rigour_evidence: "BPE is an official statistical source built from administrative sources and documented by INSEE, but file-level variables remain to inspect."
  evidence_score: 4
  evidence_evidence: "Local manifest records official metadata and access URLs; web verification confirmed current BPE 2024 metadata."
  coherence_score: 4
  coherence_evidence: "The fiche is coherent with the existing INSEE source page and previous BPE manifest."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche distinguishes metadata evidence from data inspection and keeps N, imputation, and model equation pending."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation metrics were not checked for this official statistical dataset."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[insee]]
- spatiotemporal data
- spatial panel
- [[quality_pedigree_schema_v1]]
