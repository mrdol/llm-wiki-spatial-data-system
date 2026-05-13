---
title: Zenodo 15501267 - Data for IMF By Paper
type: dataset
created: 2026-05-06
updated: 2026-05-12
sources:
  - data/manifests/datasets/zenodo_15501267_evidence_2026_05_12.json
  - data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl
  - data/manifests/runs/rejected_2026_05_12_network_recheck.json
tags: [dataset, zenodo, spatial, temporal, netcdf, simulation, downloaded]
---

Dataset candidat Zenodo associe a un papier sur les effets de IMF By dans la thermosphere moyenne.

## Identity

- Dataset ID: `zenodo_15501267`
- Dataset name: Data for IMF By paper
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/15501267
- Dataset DOI: `10.5065/j0yy-wf53`
- Title: Data for IMF By paper
- Year: 2021
- DOI traceability note: Zenodo record `15501267` returns `10.5065/j0yy-wf53` as the dataset DOI through the official API. The DOI is not a `10.5281/zenodo.*` DOI, but it is the authoritative DOI exposed by the Zenodo record.
- Linked paper DOI: `10.1029/2021JA029816`

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/15501267/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Evidence manifest: `data/manifests/datasets/zenodo_15501267_evidence_2026_05_12.json`
- Download status: downloaded
- Files downloaded: 1 NetCDF file
- Approximate downloaded size: 100.93 MB
- Confirmed record files: `tiegcmdataforfigureby.nc`, `218_xuguang.xml`

## Source Traceability

- Authoritative record checked: https://zenodo.org/api/records/15501267
- Network status on 2026-05-12: `200 OK`
- Matching source record in local JSONL: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`, line `5`
- Matching local record ID: `15501267`
- Non-matching record to ignore for this fiche: `18421412`, line `1` of the same JSONL, about Climate-Fire relationships.
- Traceability conclusion: the fiche identity, dataset DOI and local NetCDF file match Zenodo record `15501267`; previous mismatch reports came from reading another record in the same multi-record manifest.

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata returned `cc-by-4.0`.

## Content Metadata

- Main file formats: NetCDF, XML

### Variables

- Candidate Y variables: `dON2`, neutral wind components (`UN*`, `VN*`), neutral temperature (`TN*`), Joule heating (`QJOULE*`)
- Candidate Y typology: continuous
- Candidate X variables: grid dimensions `dim1`, `dim2`, `dim3`, IMF scenario labels embedded in variable names (`realIMF`, `0By`, `10By`)
- Candidate X typology: spatial, temporal, continuous, categorical, unknown
- Variables inspected: yes, NetCDF dimensions and variable names inspected
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: 3 grid axes plus scenario labels embedded in variable names
  x_candidates: [dim1, dim2, dim3, realIMF, 0By, 10By]
  x_selected: []
  selection_source: data inspection
  selection_method: unknown
  target_y: thermosphere_or_ionosphere_simulation_outputs
  estimation_context: simulation_modeling
```

## Spatiotemporal

- Data type: spatio-temporal simulation candidate
- Spatial signal: NetCDF simulation data
- Temporal signal: simulation period implied by associated paper and NetCDF structure, to inspect
- Structure: multidimensional NetCDF simulation array
- N observations: variable-dependent; 2D fields are `144 * 288 = 41472` grid cells, 3D `dON2` is `288 * 144 * 288 = 11943936` cells before missing-value filtering
- T periods: one NetCDF dimension has length 288, but axis semantics are not named in file metadata
- N/T profile: gridded simulation output; exact N/T interpretation requires paper or XML inspection
- Spatial resolution: unnamed model grid dimensions `dim1=288`, `dim2=144`, `dim3=288`
- Temporal resolution: unknown; file lacks named time coordinate in inspected NetCDF metadata
- Spatial extent: thermosphere/ionosphere simulation domain, exact extent pending inspection
- Time range: geomagnetically quiet period at solar minimum, exact dates pending paper/NetCDF inspection

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: 10.1029/2021JA029816
  paper_title: The Effects of IMF By on the Middle Thermosphere During a Geomagnetically Quiet Period at Solar Minimum
  paper_year: 2022
  abstract_available: true
  modeling_task_hint: simulation_modeling
  existing_model_or_equation: TIE-GCM simulation outputs; exact governing equation not extracted from paper
  evidence_source: Zenodo related_identifiers and inspected NetCDF variables
```

## Linked Papers

- Paper title: The Effects of IMF By on the Middle Thermosphere During a Geomagnetically Quiet Period at Solar Minimum
- Paper DOI: `10.1029/2021JA029816`
- Year: 2022
- Link evidence: Zenodo `related_identifiers` marks this DOI as `isCitedBy` with resource type `publication-article`.

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: `data/candidates/datasets/zenodo/15501267/`
- Reproducibility status: partial; NetCDF data downloaded, simulation code/workflow not inspected

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo record with DOI, explicit CC-BY-4.0 license, downloaded NetCDF file, and linked paper DOI."
  rigour_score: 4
  rigour_evidence: "Associated peer-reviewed paper metadata and abstract were found; model details require full paper or NetCDF inspection."
  evidence_score: 4
  evidence_evidence: "Dataset DOI, publication DOI, license, landing URL, single-record evidence manifest, JSONL line 5, local NetCDF file, and NetCDF variable inspection are available."
  coherence_score: 4
  coherence_evidence: "Evidence manifest, Zenodo API, local JSONL line 5, local downloaded file, and linked paper metadata are coherent."
  claim_discipline_score: 3
  claim_discipline_evidence: "The fiche keeps modeling evidence at simulation level and does not infer equations from the abstract alone."
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
