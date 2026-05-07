---
title: Dryad bk3j9kdfk - Benthic Invertebrate Trophic Networks
type: dataset
created: 2026-05-07
updated: 2026-05-07
sources: [data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl]
tags: [dataset, dryad, spatial, temporal, trophic-networks, baltic-sea, cc0]
---

Dryad dataset for temporal and spatial changes in benthic invertebrate trophic networks along a richness gradient.

## Identity

- Dataset ID: `dryad_bk3j9kdfk`
- Dataset name: Temporal and spatial changes in benthic invertebrate trophic networks along a taxonomic richness gradient
- Source family: warehouse / research repository
- Source: Dryad
- Source URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.bk3j9kdfk
- Dataset DOI: `10.5061/dryad.bk3j9kdfk`
- Year: 2022

## Source Description

> The source description states that trophic networks were constructed from biodiversity monitoring data and known trophic links to compare benthic invertebrate networks over space and time. It covers 20 years of monitoring data across the Swedish Baltic Sea coast and Skagerrak, comparing 1980-1989 with 2010-2019.

- Description source: Dryad API metadata
- Description URL: https://datadryad.org/stash/dataset/doi:10.5061/dryad.bk3j9kdfk
- Full description stored in: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Description captured at: 2026-05-07

## Source Access

- Manifest: `data/manifests/datasets/dryad_3_spatial_2026_05_07.jsonl`
- Download status: metadata scraped; file URLs captured, files not downloaded in this ingest
- Files listed: 2
- Main file formats: XLSX, TXT
- File URLs:
  - https://datadryad.org/api/v2/files/1524100/download
  - https://datadryad.org/api/v2/files/1524096/download
- Approximate total size: 0.73 MB

## License Metadata

- License present: yes
- License name: `CC0-1.0`
- License URL: https://spdx.org/licenses/CC0-1.0.html
- License open: yes
- License evidence: Dryad API record returned the SPDX CC0-1.0 license URL.

## Content Metadata

### Variables

- Candidate Y variables: species richness, food-web metrics, network horizontal diversity, network vertical diversity, stability metrics, trophic links
- Candidate Y typology: continuous, count, rate, unknown
- Candidate X variables: time period, coastal basin, monitoring location, species/taxon identifiers, trophic-link attributes
- Candidate X typology: spatial, temporal, categorical, identifier, continuous, unknown
- Variables inspected: no
- Presence of imputed X: unknown

### Feature Selection Evidence

```yaml
feature_selection:
  x_total_reported: unknown
  x_candidates: [time_period, coastal_basin, monitoring_location, species_taxon, trophic_link_attributes]
  x_selected: []
  selection_source: source_description
  selection_method: author_selection
  target_y: trophic_network_metrics
  estimation_context: food_web_metric_comparison
```

## Spatiotemporal

- Data type: spatio-temporal
- Spatial signal: Swedish coast of the Baltic Sea and Skagerrak; basins include Skagerrak, Bothnian Sea, Baltic Proper and Bornholm Basin
- Temporal signal: 1980-1989 and 2010-2019 monitoring periods
- Structure: monitoring data grouped by basin/location and time period
- N observations: unknown before XLSX inspection
- T periods: 20 monitoring years described, with two decade windows
- N/T profile: N unknown, T medium
- Spatial resolution: basin, coast, or monitoring station level pending file inspection
- Temporal resolution: annual monitoring records or decade windows pending file inspection
- Spatial extent: Swedish Baltic Sea coast and Skagerrak
- Time range: 1980-1989 and 2010-2019

## Modeling Evidence

```yaml
modeling_evidence:
  paper_doi: unknown
  modeling_task_hint: unknown
  existing_model_or_equation: food-web metrics compared over space and time
  evidence_source: Dryad source description
```

## Reproducibility

- Code available: unknown
- Repository: Dryad
- Local data path: none; file URLs captured only
- Reproducibility status: partial; dataset DOI, license, file URLs and README are available, but file/schema inspection is pending

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: research_repository
  provenance_score: 4
  provenance_evidence: "Dryad record provides DOI, source description, CC0 license, README and file-level metadata."
  rigour_score: 3
  rigour_evidence: "The source description documents monitoring data, spatial basins and temporal windows, but file variables are not inspected."
  evidence_score: 4
  evidence_evidence: "DOI, landing URL, license URL, manifest and file download URLs are captured."
  coherence_score: 4
  coherence_evidence: "The Dryad title, description and files consistently describe benthic trophic-network data."
  claim_discipline_score: 4
  claim_discipline_evidence: "The fiche records network metrics and spatio-temporal structure without inferring a model equation."
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "Citation metrics were not checked during this scraping run."
  delta1_risk: low
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[dryad]]
- spatiotemporal data
- [[quality_pedigree_schema_v1]]
