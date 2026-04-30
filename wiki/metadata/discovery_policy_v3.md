---
title: Discovery Policy v3
type: metadata
created: 2026-04-22
updated: 2026-04-22
sources: []
tags: [metadata, discovery, search, ranking, license, doi, papers]
---

Discovery policy for the architecture stage that adds license-aware, paper-linked, and DOI-aware prioritization to dataset search.

## Scope

The discovery layer now ranks dataset candidates using documented signals from the registry.

It must support prioritization for:

- spatial and spatio-temporal usefulness
- metadata richness
- open or reusable licenses
- papers with published data
- DOI-linked traceability between datasets and papers

## Ranking Signals

### Spatial and Spatio-temporal Signal

Positive signals include:

- coordinates
- parcel, commune, IRIS, NUTS, country-pair, or bilateral support
- explicit time dimension
- annual, monthly, daily, or event-level timing
- repeated cross-sections, panels, or event records

### Metadata Richness Signal

Positive signals include:

- explicit variables
- classification systems
- access modes
- reproducibility notes
- documented warehouse roles
- structured license metadata
- DOI fields
- explicit dataset-paper links

### License Signal

The search layer should distinguish:

- `open`
- `reusable_with_conditions`
- `restricted`
- `unknown`

License-aware logic must also distinguish whether the license is explicitly documented.

- `explicit_license_present: true` means the exact legal license name is documented
- `explicit_license_present: false` means only generic wording or no wording is present

Search should never infer a precise legal license from vague portal wording. If the exact license is not pinned:

- `exact_name` remains `null`
- `category` remains `unknown`
- `is_open` remains `null`
- `allows_reuse` remains `null`

Only exact documented license evidence may be used to classify whether a dataset is open and allows reuse.

### Estimator Plausibility Signal

The registry must support dataset-level assessment of allowed estimators.

Positive signals include:

- at least one candidate estimator from the allowlist
- explicit justification for each candidate estimator
- evidence_basis tied to documented dataset structure

Discovery must not treat a dataset as estimator-compatible unless that assessment is present.

### Paper and DOI Signal

Positive signals include:

- `identity.dataset_doi`
- `identity.publication_doi`
- linked paper records
- linked datasets from paper records
- paper metadata indicating published data

## Search Behavior

Default search should remain text-relevant, but ranking may boost records with:

- better spatial or spatio-temporal structure
- richer metadata structure
- clearer reuse rights
- stronger DOI or paper traceability

When the query contains terms such as `license`, `open`, `reusable`, `paper`, `doi`, `publication`, `spatial`, `territorial`, or `metadata`, the corresponding signal should receive stronger weight.

## Non-Inference Rule

The discovery layer must not:

- invent missing DOIs
- invent linked papers
- invent licenses
- infer an exact legal license from generic access wording
- classify `open` or `allows_reuse` without explicit license evidence
- infer that a paper has published data without explicit evidence
- infer that a dataset is legally reusable if the official page has not been pinned
- infer estimator plausibility without a documented dataset-level justification

## Related Pages

- [[catalog_registry_schema_v3]]
- [[restricted_estimator_policy_v1]]
- [[metadata_oriented_dataset_discovery_warehouses_2026_04_22]]
