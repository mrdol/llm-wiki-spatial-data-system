---
title: Zenodo 5534232 - Linear Pottery and Harris Figure 8 Supplement
type: dataset
created: 2026-05-06
updated: 2026-05-12
sources:
  - data/manifests/datasets/zenodo_5534232_evidence_2026_05_12.json
  - data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl
  - data/manifests/runs/rejected_2026_05_12_network_recheck.json
tags:
  - dataset
  - zenodo
  - spatial
  - graph
  - archaeology
  - downloaded
---

Dataset candidat Zenodo contenant des fichiers supplementaires pour une figure associee a Linear Pottery and Harris.

## Identity

- Dataset ID: `zenodo_5534232`
- Dataset name: Supplementary data and files to Figure 8 of Eva Rosenstock, Linear Pottery and Harris (2022)
- Source family: warehouse / research repository
- Source: Zenodo
- Source URL: https://zenodo.org/records/5534232
- Dataset DOI: `10.5281/zenodo.5534232`
- Concept DOI: `10.5281/zenodo.5534231`
- Title: Supplementary data and files to Figure 8 of Eva Rosenstock, Linear Pottery and Harris (2022)
- Year: 2022
- Linked publication DOI: `unknown_not_found`
- Linked publication note: identified as a 2022 book chapter or Festschrift contribution, but no DOI was found during lookup.

## Source Access

- Local download directory: `data/candidates/datasets/zenodo/5534232/`
- Manifest: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`
- Evidence manifest: `data/manifests/datasets/zenodo_5534232_evidence_2026_05_12.json`
- Download status: downloaded
- Files downloaded: 8
- Approximate total size: 1.49 MB
- Confirmed files: `Ulm-Eggingen_Strat_collapsed.graphml`, `Ulm-Eggingen_Strat_uncollapsed.graphml`, `Ulm-Eggingen_Strat_uncollapsed.csv`, `Ulm-Eggingen_Strat.hmcx`, `Ulm-Eggingen_Strat_collapsed.pdf`, `Ulm-Eggingen_Strat_uncollapsed.pdf`, `Ulm-Eggingen_Strat_collapsed.csv`, `Figure_08.jpg`

## Source Traceability

- Authoritative record checked: https://zenodo.org/api/records/5534232
- Network status on 2026-05-12: `200 OK`
- Matching source record in local JSONL: `data/manifests/datasets/zenodo_5_downloaded_2026_05_06.jsonl`, line `2`
- Matching local record ID: `5534232`
- Non-matching record to ignore for this fiche: `18421412`, line `1` of the same JSONL, about Climate-Fire relationships.
- Traceability conclusion: the fiche identity matches Zenodo record `5534232`; previous mismatch reports came from reading another record in the same multi-record manifest.

## License Metadata

- License present: yes
- License name: `cc-by-4.0`
- License open: yes
- License evidence: Zenodo record metadata returned `cc-by-4.0`.

## Content Metadata

- Main file formats: GraphML, CSV, PDF, image, HMCX

### Variables

- Candidate Y variables: no conventional response variable documented in the supplementary record
- Candidate Y typology: unknown
- Candidate X variables: `ID`, `TYPE`, `NAME`, `DESCRIPTION`, `LAYER`, `VALID`, `ABOVE`, `BELOW`, `EARLIER`, `LATER`, `CONTEMPORARY`, `PARENT`, `CHILDREN`
- Candidate X typology: identifier, categorical, temporal, unknown
- Variables inspected: yes, CSV headers and GraphML node/edge counts inspected
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: 13 CSV fields plus GraphML node/edge structure
  x_candidates: [ID, TYPE, NAME, DESCRIPTION, LAYER, VALID, ABOVE, BELOW, EARLIER, LATER, CONTEMPORARY, PARENT, CHILDREN]
  x_selected: []
  selection_source: data inspection
  selection_method: project choice
  target_y: not_applicable
  estimation_context: archaeological stratigraphic graph supplement
```

## Spatiotemporal

- Data type: graph / archaeological stratigraphic sequence; spatio-temporal candidate only by archaeological context
- Spatial signal: site/stratigraphic graph structure for Ulm-Eggingen
- Temporal signal: Harris matrix relative ordering fields (`ABOVE`, `BELOW`, `EARLIER`, `LATER`, `CONTEMPORARY`)
- Structure: graph/network files plus tabular data
- N observations: 149 GraphML nodes and 218 GraphML edges in inspected uncollapsed file
- T periods: not a regular panel; relative stratigraphic sequence rather than calendar time series
- N/T profile: graph sequence, not a panel
- Spatial resolution: archaeological stratigraphic unit
- Temporal resolution: relative stratigraphic ordering
- Spatial extent: Ulm-Eggingen site
- Time range: Linear Pottery context; exact calendar range not extracted from the supplementary files

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown_not_found
  paper_title: "Linear Pottery and Harris: A Case Study in the Spatio-Temporal Logic of Archaeological Sites"
  paper_year: 2022
  modeling_task_hint: unknown
  existing_model_or_equation: Harris matrix / stratigraphic graph supplement; no statistical model equation found in dataset metadata
  evidence_source: Zenodo metadata, local CSV headers, local GraphML inspection, author publication list
```

## Linked Publication

- Publication title: Linear Pottery and Harris: A Case Study in the Spatio-Temporal Logic of Archaeological Sites
- Publication DOI: `unknown_not_found`
- Publication type: book chapter or Festschrift contribution
- Year: 2022
- Link evidence: Zenodo title names the contribution and author publication list confirms the 2022 item, but no DOI was found during network lookup.

## Reproducibility

- Code available: unknown
- Repository: unknown
- Local data path: `data/candidates/datasets/zenodo/5534232/`
- Reproducibility status: partial; supplementary files downloaded, executable workflow not inspected

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Zenodo record with DOI, explicit CC-BY-4.0 license, and all listed files downloaded."
  rigour_score: 3
  rigour_evidence: "Supplementary graph and tabular files are available and inspected at header/node level, but no statistical model objective is documented."
  evidence_score: 4
  evidence_evidence: "Dataset DOI, concept DOI, license, landing URL, single-record evidence manifest, local downloads, CSV headers, and GraphML node/edge counts are available."
  coherence_score: 4
  coherence_evidence: "Evidence manifest, Zenodo API, local JSONL line 2, local files, and fiche identify the same Zenodo record."
  claim_discipline_score: 3
  claim_discipline_evidence: "The fiche keeps the record as candidate until data structure is inspected."
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
