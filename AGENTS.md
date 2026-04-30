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

## Analysis Output Routing

Do not put progressive pipeline outputs directly into `wiki/metadata/` or `wiki/estimators/`.

- `wiki/metadata/` stores system rules and schemas only.
- `wiki/estimators/` stores stable method reference fiches only.
- `wiki/analyses/metadata/` stores constructed metadata profiles based on raw metadata, dataset descriptions, and later direct data inspection.
- `wiki/analyses/discovery/` stores dataset, paper, and source discovery outputs.
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
   - wiki/analyses/discovery/ (for comparisons, search traces, or discovery notes)
   - wiki/analyses/metadata/ (for progressively constructed metadata profiles)

5. Update catalogue_datasets.json with enriched metadata fields

6. If direct access exists:
   - record access method (API, CSV, portal)
   - create manifest in data/manifests/

7. Do not clean or transform data

8. Focus on improving the metadata system, not solving a specific research question

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
- Prefer updating pages over duplication
- Always maintain metadata quality
- Always link related knowledge
- The wiki is cumulative and persistent


