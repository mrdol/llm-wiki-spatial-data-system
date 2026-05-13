---
title: Zenodo 10476054 - STEHME and HOLSEA Norway Sea-Level Files
type: dataset
created: 2026-05-06
updated: 2026-05-12
sources:
  - data/manifests/datasets/zenodo_10476054_evidence_2026_05_12.json
  - data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl
  - data/manifests/runs/rejected_2026_05_12_network_recheck.json
tags: [dataset, zenodo, spatial, temporal, netcdf, sea-level, downloaded]
---

Dataset candidat Zenodo contenant des fichiers STEHME et HOLSEA pour des dynamiques holocenes de niveau marin en Norvege.

## Identity

- Dataset ID: `zenodo_10476054`
- Dataset name: STEHME files & HOLSEA spreadsheet for Creel et al. 2022 and Balascio et al. 2023 sea-level studies in Norway
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/10476054
- Dataset DOI: `10.5281/zenodo.10476054`
- Concept DOI: `10.5281/zenodo.6330205`
- Title: STEHME files & HOLSEA spreadsheet for Creel et al. 2022 and Balascio et al. 2023 sea-level studies in Norway
- Year: 2024
- Linked paper DOI: `10.1016/j.quascirev.2022.107422`
- Linked paper DOI: `10.1002/jqs.3604`

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/10476054/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Evidence manifest: `data/manifests/datasets/zenodo_10476054_evidence_2026_05_12.json`
- Download status: partially downloaded under size filter
- Files downloaded: 2 NetCDF files
- Approximate downloaded size: 25.18 MB
- Confirmed record files: `stehme_std_ts_230721.csv`, `stehme_mean_ts_230721.csv`, `stehme_mean_230721.nc`, `stehme_2std_230721.nc`

## Source Traceability

- Authoritative record checked: https://zenodo.org/api/records/10476054
- Network status on 2026-05-12: `200 OK`
- Matching source record in local JSONL: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`, line `4`
- Matching local record ID: `10476054`
- Non-matching record to ignore for this fiche: `18421412`, line `1` of the same JSONL, about Climate-Fire relationships.
- Traceability conclusion: the fiche identity matches Zenodo record `10476054`; previous mismatch reports came from reading another record in the same multi-record manifest.

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata returned `cc-by-4.0`.

## Content Metadata

- Main file formats: NetCDF, CSV available on record

### Variables

- Candidate Y variables: `rsl` relative sea-level surface, sea-level uncertainty surface
- Candidate Y typology: continuous
- Candidate X variables: `age`, `lat`, `lon`
- Candidate X typology: temporal, spatial, continuous
- Variables inspected: yes, two downloaded NetCDF files inspected
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: 3
  x_candidates: [age, lat, lon]
  x_selected: []
  selection_source: data inspection
  selection_method: author selection
  target_y: rsl
  estimation_context: STEHME spatiotemporal sea-level model outputs
```

## Spatiotemporal

- Data type: spatio-temporal candidate
- Spatial signal: northern Norway / Lofoten and Vesteralen archipelagos
- Temporal signal: Holocene sea-level dynamics
- Structure: NetCDF age-by-latitude-by-longitude gridded model outputs plus CSV time-series files on the record
- N observations: 9828 grid cells per time slice before missing-value filtering (`91 lat * 108 lon`)
- T periods: 160 age slices
- N/T profile: N large, T medium
- Spatial resolution: 91 latitude values by 108 longitude values; latitude range 56.73137614678899-72.4937614678899, longitude range 2.62697247706422-40.45
- Temporal resolution: 100-year age steps
- Spatial extent: northern Norway, including Lofoten and Vesteralen archipelagos
- Time range: age 0-15900

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: [10.1016/j.quascirev.2022.107422, 10.1002/jqs.3604]
  paper_title: [Postglacial relative sea level change in Norway, Refining Holocene sea-level dynamics for the Lofoten and Vesteralen archipelagos northern Norway]
  paper_year: [2022, 2024]
  modeling_task_hint: spatiotemporal_regression
  existing_model_or_equation: spatiotemporal empirical hierarchical model ensemble outputs; exact equation not extracted
  evidence_source: Zenodo description, linked paper metadata, and inspected NetCDF files
```

## Linked Papers

- Paper title: Postglacial relative sea level change in Norway
- Paper DOI: `10.1016/j.quascirev.2022.107422`
- Journal: Quaternary Science Reviews
- Year: 2022
- Link evidence: Zenodo title and data availability statement link the STEHME/HOLSEA files to Creel et al. 2022.

- Paper title: Refining Holocene sea-level dynamics for the Lofoten and Vesteralen archipelagos, northern Norway: Implications for prehistoric human-environment interactions
- Paper DOI: `10.1002/jqs.3604`
- Journal: Journal of Quaternary Science
- Year: 2024
- Link evidence: Zenodo title and publication metadata identify the Balascio et al. paper.

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: `data/candidates/datasets/zenodo/10476054/`
- Reproducibility status: partial; NetCDF files downloaded under size filter, spreadsheet material still requires access/inspection

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo record with DOI, explicit CC-BY-4.0 license, and downloaded NetCDF files."
  rigour_score: 3
  rigour_evidence: "Dataset is linked to published sea-level studies and exposes NetCDF spatiotemporal model outputs; model equation still requires paper-level extraction."
  evidence_score: 5
  evidence_evidence: "Dataset DOI, concept DOI, linked paper DOIs, license, landing URL, single-record evidence manifest, JSONL line, and local NetCDF inspection are available."
  coherence_score: 4
  coherence_evidence: "Evidence manifest, Zenodo API, local JSONL line 4, and local NetCDF files match Zenodo record 10476054."
  claim_discipline_score: 3
  claim_discipline_evidence: "The fiche does not claim direct estimator suitability before NetCDF inspection."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citations were not checked during this scraping run."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[quality_pedigree_schema_v1]]
- [[zenodo]]
- [[spatiotemporal_data]]
