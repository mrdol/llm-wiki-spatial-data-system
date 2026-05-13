---
title: Discovery Policy v3
type: metadata
created: 2026-04-22
updated: 2026-05-13
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

### Paper Authorship and Publisher Signal

Default paper scraping should prioritize records with:

- `author_count >= 4`
- a recognized publisher, journal, or scientific data venue
- explicit paper DOI
- explicit dataset/archive DOI or repository access route
- explicit modeling evidence

Recognized publisher or venue evidence includes, for example:

- Wiley
- Elsevier
- Springer Nature
- Taylor & Francis
- Oxford University Press
- Cambridge University Press
- Copernicus
- MDPI
- PLOS
- AGU
- INFORMS
- ASA
- Royal Statistical Society
- Journal of Applied Econometrics
- Earth System Science Data
- comparable peer-reviewed journals or data journals

If `author_count < 4`, the candidate should normally remain in `review`. It may still be retained when all of the following are present:

- resolvable paper DOI
- resolvable dataset/archive DOI or explicit repository package
- explicit spatial or spatio-temporal modeling evidence
- clear explanation of the exception in the manifest or fiche

## Search Behavior

Default search should remain text-relevant, but ranking may boost records with:

- better spatial or spatio-temporal structure
- richer metadata structure
- clearer reuse rights
- stronger DOI or paper traceability

When the query contains terms such as `license`, `open`, `reusable`, `paper`, `doi`, `publication`, `spatial`, `territorial`, or `metadata`, the corresponding signal should receive stronger weight.

## Paper Candidacy Status

Chaque fiche paper doit porter un champ `candidacy_status` dans sa section `## Dataset Access Decision`. Ce champ gouverne la façon dont la discovery layer traite le papier.

| Valeur | Signification | Comportement discovery |
|---|---|---|
| `modeling_candidate` | Au moins un estimateur autorisé est plausible et documenté | Inclus dans les requêtes de candidature à la modélisation |
| `reference_only` | Aucun estimateur autorisé plausible, mais le papier ou le dataset a une valeur documentaire (géométries, glossaire, référentiel) | Conservé dans le wiki, exclu des requêtes de candidature à la modélisation |
| `rejected` | Aucune valeur pour le projet, ni modélisation ni référence | Peut être supprimé ou archivé |

### Règles d'application

- Un papier avec `at_least_one_allowed_estimator_plausible: false` doit avoir `candidacy_status: reference_only` ou `rejected`, jamais `modeling_candidate`.
- Un papier avec `at_least_one_allowed_estimator_plausible: true` doit avoir `candidacy_status: modeling_candidate`.
- Un papier non encore évalué (`estimator_assessment_status: pending`) doit laisser `candidacy_status` absent ou à `pending`.
- La discovery layer doit ignorer les papiers `reference_only` dans tout classement ou recommandation de datasets pour la modélisation.
- Les papiers `reference_only` restent consultables et peuvent être liés depuis des fiches dataset comme sources de définitions ou de géométries de référence.

## Non-Inference Rule

The discovery layer must not:

- invent missing DOIs
- invent linked papers
- invent licenses
- infer an exact legal license from generic access wording
- classify `open` or `allows_reuse` without explicit license evidence
- infer that a paper has published data without explicit evidence
- infer publisher recognition without a named publisher, journal, or venue
- infer that a dataset is legally reusable if the official page has not been pinned
- infer estimator plausibility without a documented dataset-level justification

## Related Pages

- [[catalog_registry_schema_v3]]
- [[restricted_estimator_policy_v1]]
- [[metadata_oriented_dataset_discovery_warehouses_2026_04_22]]
