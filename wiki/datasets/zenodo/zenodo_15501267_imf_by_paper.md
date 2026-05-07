---
title: Zenodo 15501267 - Data for IMF By Paper
type: dataset
created: 2026-05-06
updated: 2026-05-06
sources: [data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl]
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

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/15501267/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Download status: downloaded
- Files downloaded: 1 NetCDF file
- Approximate downloaded size: 100.93 MB

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata returned `cc-by-4.0`.

## Content Metadata

- Main file formats: NetCDF, XML

### Variables

- Candidate Y variables: thermosphere or ionosphere simulation outputs, to inspect
- Candidate Y typology: continuous or unknown pending NetCDF inspection
- Candidate X variables: spatial coordinates, time, IMF By scenario variables, to inspect
- Candidate X typology: spatial, temporal, continuous, timestamp, or unknown pending inspection
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates: [unknown]
  x_selected: []
  selection_source: data_inspection_pending
  selection_method: unknown
  target_y: thermosphere_or_ionosphere_output_unknown
  estimation_context: simulation_modeling
```

## Spatiotemporal

- Data type: spatio-temporal simulation candidate
- Spatial signal: NetCDF simulation data
- Temporal signal: simulation period implied by associated paper and NetCDF structure, to inspect
- Structure: likely multidimensional spatio-temporal simulation array
- N observations: unknown
- T periods: unknown
- N/T profile: unknown
- Spatial resolution: simulation grid, exact resolution pending NetCDF inspection
- Temporal resolution: simulation timestep, exact resolution pending NetCDF inspection
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
  existing_model_or_equation: unknown
```

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
  evidence_evidence: "Dataset DOI, publication DOI, license, landing URL, manifest, local file, and paper abstract are available."
  coherence_score: 4
  coherence_evidence: "Manifest, local downloaded file, and linked paper metadata are coherent."
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
- spatiotemporal data
