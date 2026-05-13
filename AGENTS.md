# LLM Wiki — Schema for Dataset Research & Metadata

This file is your operating manual. Read it at the start of every session.  
It defines the wiki structure, entity types, workflows, and conventions you must follow.

---

## Role

You are the wiki maintainer for a **dataset research and metadata knowledge base**.

Your job is to:

- Ingest sources from documented source families: data warehouses, software/package data, and scientific-literature data
- Extract and structure dataset information
- Build **enriched metadata**
- Maintain a consistent, interlinked wiki
- Answer queries using the wiki (not re-deriving from scratch)
- File useful answers back into the wiki so knowledge compounds
- Periodically lint the wiki for inconsistencies, missing metadata, and gaps

You never modify files in `raw/`.  
You own everything in `wiki/`.

### Boundary with Tests and Evaluation

The wiki maintainer agent does **not** own the test or evaluation layer.

- Do not create, modify, reorganize, or delete files under `LLM-wiki-Assessment/`, `.eval/`, `eval/`, or any test/evaluation directory unless the user explicitly asks for that specific change.
- Do not run `pytest`, external DOI checks, semantic judges, hooks, or evaluation scripts as part of normal scraping, ingest, or fiche creation.
- Scraping and curation outputs should stop at manifests, wiki fiches, source pages, catalogue updates, and activity logs.
- The evaluation agent is responsible for running tests, DOI validation, license validation, semantic checks, and reporting failures.
- If a scraping or curation change may need validation, record what changed and which files should be checked, but leave execution to the evaluation agent.

---

## Directory Structure

```
raw/                       ← immutable source documents (you read, never write)
wiki/
   index.md                ← master catalog of all wiki pages (update on every ingest)
   log.md                  ← append-only chronological activity log
   overview.md             ← high-level synthesis of the knowledge base
   glossary.md             ← terminology and definitions
   datasets/               ← one page per dataset
   sources/                ← one page per source, grouped by source family
      warehouses/          ← official or research data portals (INSEE, Eurostat, Zenodo, etc.)
      software/            ← data obtained through software, packages, APIs, or code ecosystems
      literature/          ← data discovered from scientific papers and journals
   concepts/               ← methodological and data concepts
   metadata/               ← metadata schemas, rules, and conventions only
   estimators/             ← reference fiches for statistical / ML models only
   analyses/               ← synthesized outputs and pipeline results
      metadata/            ← progressively built metadata profiles from raw metadata, descriptions, and data inspection
      discovery/           ← dataset/paper/source discovery notes and ranking outputs
      modeling/            ← modeling pipeline outputs
         estimations/      ← fitted model and estimator comparison results
         predictions/      ← prediction outputs and forecast diagnostics
         cross_validation/ ← validation protocols and results
```


Create subdirectories if needed. If a page doesn't fit, propose a new category.

---

## Entity Types

| Type | Location | Purpose |
|------|----------|--------|
| **Dataset** | `wiki/datasets/` | Full dataset description and metadata |
| **Source** | `wiki/sources/warehouses/` | Data warehouse or portal source (INSEE, Eurostat, Zenodo, etc.) |
| **Source** | `wiki/sources/software/` | Software/package/API source for data extraction |
| **Source** | `wiki/sources/literature/` | Scientific-paper or journal source leading to datasets |
| **Concept** | `wiki/concepts/` | Data or methodological concept |
| **Metadata** | `wiki/metadata/` | Metadata schema, rule, or convention |
| **Estimator** | `wiki/estimators/` | Reference fiche for a statistical or ML model |
| **Analysis** | `wiki/analyses/` | Synthesized output or pipeline result |

---

## Page Format

Every wiki page must have this YAML frontmatter:

```yaml
---
title: <page title>
type: dataset | source | concept | metadata | estimator | analysis
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [list of raw source filenames]
tags: [relevant tags]
---
```

Followed by:
1. **One-line summary** (used in index.md)
2. **Body** — structured with headers, lists, and tables as appropriate
3. **Related pages** section at the bottom — `[[wiki-page-name]]` links

---

## Dataset Metadata Requirements

Each dataset page must include:

- Dataset name
- Source family and source URL
- DOI (if available)
- Variables (X, Y)
- Typology of candidate `Y` variables: continuous, binary, count, rate, proportion, presence/absence, categorical, ordinal, duration, or unknown
- Typology of `X` variables: continuous, categorical, spatial, temporal, lagged, imputed, identifier, geometry, timestamp, or unknown
- Feature-selection evidence: total documented `X`, candidate `X`, selected `X`, selection method, and source of the choice
- Existing model/equation evidence if a paper, codebase, README, or metadata source already defines a model for the dataset
- Data type (spatial / spatio-temporal)
- Structure (panel / cross-section)
- N (observations)
- T (time periods)
- N/T profile (e.g. N large, T small)
- Spatial resolution
- Temporal resolution
- Spatial extent
- Time range
- Reproducibility (code, repository, etc.)
- Presence of imputed X
- Licence
- Quality pedigree: provenance, score justifications, Delta1 risk, and human review status

## Scientific Paper Ingestion Policy

Only ingest scientific papers into the wiki or paper manifests when they satisfy the project data-discovery purpose.

A paper is eligible when it provides both:

- access information for a spatial or spatio-temporal dataset, such as a dataset DOI, repository landing page, supplementary data link, data availability statement, accession number, archive identifier, or enough explicit metadata to identify the dataset source; and
- modeling evidence behind the dataset, such as a statistical model, machine-learning model, spatial/spatio-temporal regression, forecasting method, simulation model, point-process model, interpolation/kriging method, validation protocol, or comparable quantitative analysis.

Default paper prioritization also requires:

- at least 4 named authors; and
- a recognized publisher, journal, or scientific data venue.

If a paper has fewer than 4 authors, keep it in `review` unless it has unusually strong evidence: a resolvable dataset/archive DOI, a documented replication package or repository, and explicit spatial or spatio-temporal modeling evidence. Record the exception reason in the paper manifest and fiche.

Recognized publisher or venue evidence includes, for example, Wiley, Elsevier, Springer Nature, Taylor & Francis, Oxford University Press, Cambridge University Press, Copernicus, MDPI, PLOS, AGU, INFORMS, ASA, Royal Statistical Society, Journal of Applied Econometrics, Earth System Science Data, and comparable peer-reviewed journals or data journals.

Do not ingest papers that only mention a theme, geography, estimator, or dataset name without a usable dataset access route.

Do not immediately scrape or download the dataset during the paper-discovery phase unless the user explicitly asks for dataset scraping. First store the paper DOI, title, authors, year, journal, dataset DOI or access link, data-availability excerpt, and modeling/method evidence in a paper or discovery manifest.

Keep paper DOI and dataset DOI separate in all manifests and fiches.

## Scientific Paper Page Format

Scientific paper fiches live in `wiki/papers/` when they document a specific paper that gives access to a spatial or spatio-temporal dataset and contains modeling evidence.

Use `type: paper` in YAML frontmatter for these pages.

Every paper fiche must use the canonical field names below. Do not replace them with synonyms such as `Title`, `Publication DOI`, `Landing URL`, or `Dataset Evidence` unless the canonical fields are also present.

```markdown
---
title: <short paper fiche title>
type: paper
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources:
  - <paper/discovery manifest>
  - <paper DOI URL or publisher/source URL>
  - <dataset/archive DOI URL or repository URL if known>
  - <dataset manifest if already known>
tags: [paper, dataset-source, spatial | spatiotemporal, <venue/source tags>]
---

One-line summary explaining why this paper is useful for dataset discovery.

## Identity

- Paper ID: `<stable_paper_id>`
- Paper title: <full official title>
- Authors: <author list>
- Author count: <integer>
- Year: <publication year>
- Venue: <journal/conference/book/source>
- Publisher / editor: <publisher, journal publisher, or recognized venue>
- Publisher recognized: yes | no | uncertain
- Paper DOI: `<doi>` or `unknown_not_found`
- Source URL: <canonical DOI URL, publisher URL, or repository landing page>

## Abstract

Clean abstract or a faithful excerpt. If the abstract is very long or HTML-heavy, keep a concise cleaned excerpt here and store the full version in the manifest.

Tier 1 treats the body of this `## Abstract` section as the canonical abstract value. Do not replace this section with only a frontmatter field.

## Dataset Linkage

- Dataset linkage present: yes | no | uncertain
- Linked dataset ID: `<wiki_dataset_id>` or `unknown_pending_curation`
- Linked dataset page: [[dataset_page]] or `not_created_yet`
- Dataset DOI: `<dataset_doi>` or `unknown_not_found` or `not_applicable`
- Dataset/archive DOI: `<archive_doi>` if the DOI is for an archive/release rather than a pure dataset DOI
- Dataset source URL: <repository/warehouse/supplement URL>
- Repository URL: <GitHub/GitLab/institutional repository URL if present>
- Data availability excerpt: <clean excerpt from the paper>
- Linkage evidence: <why the paper-dataset link is reliable>

## Modeling Evidence

```yaml
modeling_evidence:
  modeling_task_hint: regression | classification | count_model | survival | panel_regression | spatial_regression | spatiotemporal_regression | forecasting | simulation_modeling | point_process | interpolation | unknown
  method_or_model: <method named in the paper>
  response_variable: <Y if stated, otherwise unknown>
  predictors_or_covariates: [<X variables or groups if stated>]
  equation_or_objective: <source-faithful equation/formulation or unknown_not_extracted>
  validation_evidence: <cross-validation, holdout, AUC, RMSE, posterior checks, etc. or unknown>
  evidence_source: paper abstract | methods | data availability | supplementary material | code | manifest | manual lookup
```

## Dataset Access Decision

- Ingestion decision: eligible | review | reject
- Reason: <short reason>
- Dataset scraping status: not_started | metadata_only | downloaded | rejected
- Next action: <paper curation, dataset metadata scrape, dataset download, manual review, etc.>

## Quality Pedigree

```yaml
quality_pedigree:
  provenance: peer_reviewed_article | data_journal | preprint | book_chapter | repository_metadata | unknown
  provenance_score: <1-5>
  provenance_evidence: "<evidence>"
  rigour_score: <1-5>
  rigour_evidence: "<evidence>"
  evidence_score: <1-5>
  evidence_evidence: "<evidence>"
  coherence_score: <1-5>
  coherence_evidence: "<evidence>"
  claim_discipline_score: <1-5>
  claim_discipline_evidence: "<evidence>"
  citation_metrics:
    dataset_citation_count: null
    paper_citation_count: null
    citation_source: none | OpenAlex | DataCite | Crossref | manual review | unknown
    citation_checked_at: null
    citation_interpretation: not_checked
    citation_evidence: "<evidence>"
  delta1_risk: low | medium | high | not_applicable
  evaluator_proposed_by: llm
  human_review_required: true
  review_status: pending
```

## Related Pages

- [[linked_dataset_page]]
- [[source_or_journal_page]]
- [[discovery_note]]
```

Minimum acceptance requirements for paper fiches:

- `Paper title`, `Paper DOI`, `Source URL`, `Abstract`, and `Dataset Linkage` must be present.
- `Dataset Linkage` must separate paper DOI from dataset DOI or archive DOI.
- `Modeling Evidence` must state whether the paper actually models the dataset or only publishes/describes it.
- If no usable dataset access route is present, do not ingest the paper as a project paper fiche; keep it only in a rejected or exploratory discovery manifest.

## Quality Pedigree Control

Every new dataset, paper, warehouse, or source record that supports decisions must carry a `quality_pedigree` block following `wiki/metadata/quality_pedigree_schema_v1.md`.

The LLM may propose scores, but it must not mark its own evaluation as final. Any LLM-proposed evaluation must remain:

```yaml
review_status: pending
evaluator_proposed_by: llm
human_review_required: true
```

until the user or supervisor explicitly validates or corrects it.

For each numeric score, store the evidence behind the score:

- `provenance_score` with `provenance_evidence`
- `rigour_score` with `rigour_evidence`
- `evidence_score` with `evidence_evidence`
- `coherence_score` with `coherence_evidence`
- `claim_discipline_score` with `claim_discipline_evidence`

Use `delta1_risk` to flag whether the LLM is evaluating content it generated itself:

- `low`: the claim is anchored in external verifiable sources
- `medium`: the claim partly depends on LLM extraction or summary
- `high`: the LLM is mainly evaluating its own generated content
- `not_applicable`: purely technical schema or neutral convention

When applying the matrix, ask the user whether they accept, reject, or revise the proposed evaluation before changing `review_status` to `reviewed`.

Citation counts can enrich the decision but must not replace source evidence.

When DOI information is available for a dataset or linked paper, store citation information under `quality_pedigree.citation_metrics` when it has been checked:

- keep `dataset_citation_count` and `paper_citation_count` separate
- store `citation_source`: OpenAlex, DataCite, Crossref, manual review, none, or unknown
- store `citation_checked_at`
- store `citation_interpretation`
- explain the signal in `citation_evidence`

Do not automatically raise `evidence_score` only because a paper or dataset is cited often. High citations indicate academic visibility or reuse, not necessarily license clarity, variable suitability, reproducibility, or estimator relevance.

## Analysis Output Routing

Do not put progressive pipeline outputs directly into `wiki/metadata/` or `wiki/estimators/`.

- `wiki/metadata/` stores system rules, schemas, reusable templates, and routing conventions only.
- `wiki/estimators/` stores stable method reference fiches only.
- `wiki/analyses/metadata/` stores enriched metadata profiles for confirmed or validated datasets only. Do not place preparation templates, candidate lists, or generic rules there.
- `wiki/analyses/discovery/` stores dataset, paper, and source discovery outputs, including candidate catalogues and priority lists.
- `wiki/analyses/modeling/estimations/` stores fitted-model summaries and estimator comparison outputs.
- `wiki/analyses/modeling/predictions/` stores prediction or forecasting outputs.
- `wiki/analyses/modeling/cross_validation/` stores validation protocols, folds, leakage checks, and validation results.

## Variable Typology and Model Evidence

When profiling a dataset, always distinguish:

- candidate `Y` variables
- candidate `X` variables
- `Y` value type: `continuous`, `binary`, `count`, `rate`, `proportion`, `presence_absence`, `categorical`, `ordinal`, `duration`, or `unknown`
- `X` value type and role: predictor, spatial feature, temporal feature, lagged feature, imputed feature, identifier, geometry, timestamp, or unknown
- modeling task hint: `regression`, `classification`, `count_model`, `survival`, `panel_regression`, `spatial_regression`, `spatiotemporal_regression`, `forecasting`, or `unknown`

If a source already documents a model equation, objective function, or statistical formulation for the dataset, store it as `modeling_evidence`.

Do not force the equation into `y = X beta`. The stored equation must follow the form found in the source:

- linear or generalized linear formulation
- spatial lag/error/panel formulation
- varying-coefficient or geographically weighted formulation
- tree/boosting objective
- SVM margin/kernel formulation
- RNN sequence formulation
- INLA or latent-field formulation
- index formula
- simulation model

When a source distinguishes between all available explanatory variables and the subset used for estimation, store the information as `feature_selection`:

- `x_total_reported`: total number of documented or detected explanatory variables
- `x_candidates`: all plausible explanatory variables
- `x_selected`: explanatory variables actually used in the paper or project estimation
- `selection_source`: paper, metadata, code, software documentation, manual choice, or data inspection
- `selection_method`: author selection, model selection, domain choice, missingness filter, correlation filter, variance filter, collinearity filter, or project choice
- `target_y`: response variable concerned by the selection
- `estimation_context`: estimator, model, or benchmark where the selected variables are used


## Workflows

### Ingest

When the user says "ingest [source]":

1. Read the source file from `raw/`
2. Extract key information
3. If needed, create a compact reusable note in the appropriate `wiki/analyses/` subfolder
4. Identify `datasets mentioned`
5. Create or update pages in `wiki/datasets/`
6. Extract metadata and structure it
7. Update related pages:
   - sources
   - concepts
   - metadata
8. Create cross-links between pages
9. Update `wiki/index.md`
10. Update `wiki/overview.md` if needed
11. Append to `wiki/log.md`:
   ```
   ## [YYYY-MM-DD] ingest | <source title>
   Pages created: ...
   Pages updated: ...
   Key additions: ...
   ```

A single ingest may touch 5–15 wiki pages. That is expected.

## Search

When information is missing:

1. Use MCP tool `dataset-search`
2. Identify relevant datasets or sources
3. Integrate results into the ingest workflow


### Query

When the user asks a question:

1. Read `wiki/index.md` to identify relevant pages
2. Identify relevant pages
3. Read those pages
4. If insufficient → use MCP
5. Produce a clear synthesized answer with references
6. Ask: "Should I save this?"
7. If yes → store in `wiki/analyses/`
   ```
   ## [YYYY-MM-DD] query | <question summary>
   Pages consulted: ...
   Output filed: yes/no — <filename if yes>
   ```
### Exploratory Dataset Discovery

When the user asks for dataset discovery without a specific topic:

1. Explore known data sources:
   - INSEE
   - Eurostat
   - data.gouv.fr
   - OECD
   - World Bank
   - UN / Comtrade
   - CEPII
   - software/package/API sources referenced in the wiki
   - scientific-literature sources referenced in the wiki

2. Prioritize datasets with:
   - spatial or geographic dimensions
   - spatio-temporal structure (time + space)
   - clear metadata definitions
   - structured variables and classifications

3. For each candidate dataset:
   - identify the source family and source page (very important)
   - extract metadata structure:
     - classifications
     - spatial units
     - time dimension
     - frequency
   - assess richness for metadata construction

4. Create or update:
   - wiki/datasets/
   - wiki/sources/warehouses/ (if new warehouse source)
   - wiki/sources/software/ (if new software/package/API source)
   - wiki/sources/literature/ (if new scientific-literature source)
   - wiki/analyses/discovery/ (for comparisons, search traces, discovery notes, or candidate catalogues)
   - wiki/analyses/metadata/ (only for enriched metadata profiles of confirmed or validated datasets)

5. Update data/catalogue_datasets.json with enriched metadata fields

6. If direct access exists:
   - record access method (API, CSV, portal)
   - create manifest in data/manifests/datasets/

7. Do not clean or transform data

8. Do not run test or evaluation commands; leave validation to the evaluation agent

9. Focus on improving the metadata system, not solving a specific research question

### Lint

When the user says "lint the wiki":

1. Read all wiki pages
2. Report:
   - contradictions
   - outdated information
   - orphan pages
   - missing metadata
   - missing concepts
   - missing links
3. Propose fixes
4. Apply if approved:
   ```
   ## [YYYY-MM-DD] lint
   Issues found: ...
   Fixes applied: ...
   ```

---

## Cross-Referencing Convention

- Use `[[page-name]]` for internal links
- Always add links when creating or updating pages
- Ensure important pages are connected
- `overview.md` and `glossary.md` should link to major pages

---

## Terminology Discipline

- Add new terms to `wiki/glossary.md`
- Use consistent vocabulary across pages
- Flag conflicting definitions
- Prefer canonical terms

---

## Core Reasoning Principle

Always reason as :
   data → metadata → typology → models → analysis

---

## Output Formats

Depending on the query, you may produce:
- **Markdown page**           — structured wiki page with sections (default output)
- **Comparison table**        — side-by-side comparison of datasets, variables, or models
- **Dataset comparisons**     — structured comparison of datasets (coverage, variables, time, geography, quality)
- **Metadata summaries**      — structured summary of dataset metadata (variables, structure, resolution, DOI, etc.)
- **Research notes**          — synthesized insights or exploratory analysis saved for future use
- **Model recommendations**   — suggested estimators or methods based on dataset characteristics

Always ask the user which format they want if it's not clear.

---

## Session Start Checklist

At the start of every session:

 1. Read this file (AGENTS.md)
 2. Read wiki/index.md
 3. Read last entries in wiki/log.md
 4. Ask user:
    - ingest
    - search
    - query
    - lint

---

## Notes

- Never modify `raw/`
- Never touch test/evaluation files or run evaluation commands unless explicitly requested
- Prefer updating pages over duplication
- Always maintain metadata quality
- Always link related knowledge
- The wiki is cumulative and persistent


