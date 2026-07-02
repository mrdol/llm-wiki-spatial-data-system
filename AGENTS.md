# LLM Wiki - Agent Operating Manual

Read `CONTEXT.md` first — it defines all project terms (fiche, sf, N/T,
typologies Y/X, bandwidth, pipeline, eval scores, estimateurs, agents).

This file defines how agents should work inside `llm-wiki-karpathy`.
Read it before making durable changes.

The project combines several working layers:

- dataset catalogs built from selected sources
- a scientific corpus of papers, books, PDFs, TEI files, and bibliographic records
- package and web documentation used as evidence
- a knowledge graph linking papers, datasets, variables, formulas, methods and packages
- a validated wiki for human-readable synthesis

Dataset discovery has three source families:

1. R/Python package datasets.
2. Open datasets linked to scientific papers in spatial statistics, spatial econometrics,
   and spatio-temporal modeling.
3. Spatial and spatio-temporal datasets from data banks and portals.

The R/Python package route is the first source currently explored. It is not
the only source family.

The current strategy is KG-first:

```text
raw source -> curated corpus -> KG extraction/query -> wiki synthesis
```

The KG is the first place to check for existing structured knowledge. The wiki
is the stable narrative layer. The two layers feed each other:

```text
corpus evidence -> KG relations -> wiki pages -> improved KG rules -> better wiki pages
```

Do not treat either layer as final truth by itself. The KG is structured
evidence. The wiki is validated interpretation.

---

## Core Priority

For dataset, paper, package, formula, or method questions, work in this order:

1. Query the local KG.
2. Read the relevant wiki page only if the KG is incomplete or the answer needs synthesis.
3. Read the corpus source linked by the KG or wiki.
4. Use local scripts/MCP search when the KG and wiki are insufficient.
5. Use web search only when local evidence is missing, stale, or the user asks for external verification.

This order is intended to reduce repeated context loading and avoid expensive
full-file reads when a KG query can answer the question.

Useful KG commands:

```powershell
python tools\kg\07_export_agent_index.py stats
python tools\kg\07_export_agent_index.py search lsl
python tools\kg\07_export_agent_index.py explain dataset:r:spdatalarge:lsl
python tools\kg\07_export_agent_index.py papers-for-dataset lsl
python tools\kg\07_export_agent_index.py formulas-for lsl
```

Use `tools/kg/run_all.py` to rebuild the KG after source changes:

```powershell
python tools\kg\run_all.py
```

For targeted paper ingestion, prefer the incremental route:

```powershell
python tools\kg\ingest_papers.py --pdf "article.pdf" --title "short title"
```

This route runs GROBID only for missing TEI files, parses only new or stale TEI
extractions, rebuilds `graph.sqlite` once, and appends `wiki/log.md`.

Use GROBID only when new or changed PDFs need TEI extraction:

```powershell
python tools\kg\run_all.py --run-grobid
```

---

## Layer Responsibilities

## Base LLM Wiki Architecture

The wiki remains the durable human-readable knowledge layer. The KG is now the
first structured access layer, but it does not replace the base llm-wiki
architecture.

Core wiki structure:

```text
wiki/
  index.md                master catalog of wiki pages
  log.md                  append-only chronological activity log
  overview.md             high-level synthesis
  glossary.md             terminology and definitions
  datasets/               one page per validated or documented dataset
  sources/
    warehouses/           data banks and portals
    software/             package/API/software dataset sources
    literature/           scientific-paper or journal routes to datasets
  concepts/               data and methodological concepts
  metadata/               schemas, rules, conventions
  estimators/             stable estimator reference fiches
  papers/                 paper fiches when papers provide dataset/model evidence
  software/               software/package/library fiches
  analyses/
    metadata/             enriched metadata profiles for confirmed datasets
    discovery/            candidate lists, search traces, ranking outputs
    modeling/
      estimations/        fitted-model summaries and estimator comparisons
      predictions/        predictions and forecast diagnostics
      cross_validation/   validation protocols, folds, leakage checks, results
```

Entity routing:

| Type | Location | Purpose |
|---|---|---|
| Dataset | `wiki/datasets/` | Dataset description and metadata |
| Source: warehouse | `wiki/sources/warehouses/` | Data bank or portal |
| Source: software | `wiki/sources/software/` | Package/API/software data route |
| Source: literature | `wiki/sources/literature/` | Paper/journal route to datasets |
| Paper | `wiki/papers/` | Scientific paper with dataset/model evidence |
| Concept | `wiki/concepts/` | Data or methodological concept |
| Metadata | `wiki/metadata/` | Schema, rule, convention |
| Estimator | `wiki/estimators/` | Stable estimator fiche |
| Software | `wiki/software/` | Package or library fiche |
| Analysis | `wiki/analyses/` | Synthesized output or pipeline result |

Create subdirectories if needed, but do not duplicate existing pages.

---

## Page Format

Every durable wiki page must have YAML frontmatter:

```yaml
---
title: <page title>
type: dataset | source | paper | concept | metadata | estimator | software | analysis
created: YYYY-MM-DD
updated: YYYY-MM-DD
sources: [list of source filenames, DOI URLs, manifests, or corpus paths]
tags: [relevant tags]
---
```

Then include:

1. One-line summary.
2. Structured body with headings, lists or tables.
3. Evidence or uncertainty notes when relevant.
4. Related pages using `[[page-name]]`.

---

## Dataset Metadata Requirements

Each dataset page or dataset metadata profile should include, when available:

- dataset name;
- source family and source URL;
- paper DOI and dataset/archive DOI, kept separate;
- variables, including candidate `Y`, candidate `X`, selected `X`;
- variable roles: response, covariate, coordinate, geometry, identifier, time;
- variable types: continuous, binary, count, rate, proportion, categorical,
  ordinal, duration, spatial, temporal, lagged, imputed, unknown;
- data type: spatial, spatio-temporal, panel, cross-section, raster, areal,
  point, trajectory;
- `N`, `T`, spatial extent, time range, spatial and temporal resolution;
- formula or model evidence if a paper, code, package documentation, README, or
  metadata source defines one;
- reproducibility evidence: code, repository, supplements, examples;
- licence and reuse constraints;
- quality pedigree and review status when the page supports project decisions.

---

## Scientific Paper Ingestion Policy

Ingest scientific papers into the wiki or paper manifests only when they satisfy
the project data-discovery purpose.

A paper is eligible when it provides both:

- access information for a spatial or spatio-temporal dataset, such as dataset
  DOI, repository landing page, supplementary data link, data availability
  statement, archive identifier, or enough explicit metadata to identify the
  dataset source;
- modeling evidence behind the dataset, such as regression, spatial model,
  spatio-temporal model, forecast, simulation, point process, interpolation,
  machine learning model, validation protocol, formula, or code.

Default prioritization also favors:

- at least four named authors;
- recognized publisher, journal, data journal, book, conference, or official
  scientific repository.

If a paper has fewer than four authors, keep it in review unless it has strong
evidence: resolvable dataset/archive DOI, replication package or repository, and
explicit spatial or spatio-temporal modeling evidence.

Do not ingest papers that only mention a theme, geography, estimator, or dataset
name without a usable dataset access route.

Do not download datasets during paper discovery unless the user explicitly asks
for dataset scraping. First store paper DOI, title, authors, year, venue,
dataset DOI/access link, data availability excerpt, and modeling evidence in a
manifest or paper fiche.

---

### 1. Root `raw/`

`raw/` is immutable. It is a read-only staging/archive area.

Allowed:

- inspect files
- compare with corpus
- recommend promotion to `corpus/`

Forbidden unless the user explicitly asks:

- create files under `raw/`
- edit files under `raw/`
- delete, rename, move, or normalize files under `raw/`

### 2. `corpus/`

`corpus/` is the curated source layer. It is the modifiable raw layer.

Use:

```text
corpus/bib/references.bib
corpus/papers/raw_pdf/
corpus/papers/tei/
corpus/web_md/
corpus/sources.yml
```

Put validated PDFs, TEI files, web notes, Rmd files, and bibliographic records
there. Corpus material is evidence, not final interpretation.

### 3. KG Layer

The KG structures the project.

Stable definitions live in:

```text
inst/kg/
```

Generated outputs live in:

```text
.kg/
```

Do not edit generated `.kg/` artifacts manually. Rebuild them with scripts.

Important generated files:

```text
.kg/graph.sqlite
.kg/extracted/*.jsonl
.kg/summaries/*.md
```

Typical node types:

- Paper
- Dataset
- Formula
- Method
- Section
- Citation
- Author
- RPackage
- PythonPackage
- DocumentationPage
- Variable
- ResponseVariable
- Covariate
- CoordinateVariable
- GeometryColumn
- TimeVariable
- IdentifierVariable

Typical relations:

- `USES_DATASET`
- `PROVIDES_DATASET`
- `DOCUMENTED_BY`
- `HAS_VARIABLE`
- `HAS_RESPONSE`
- `HAS_COVARIATE`
- `HAS_COORDINATE`
- `HAS_GEOMETRY`
- `HAS_TIME`
- `HAS_IDENTIFIER`
- `SHOWS_FORMULA`
- `HAS_FORMULA`
- `HAS_SECTION`
- `HAS_AUTHOR`
- `CITES`
- `MENTIONS_METHOD`
- `USES_PACKAGE`

### 4. Wiki

`wiki/` is the validated synthesis layer.

Do not update wiki pages just because extraction found a signal. Update the wiki
only when the user asks for durable synthesis or when the evidence has been
checked enough to stabilize a claim.

The wiki should explain:

- what is known
- what is inferred
- what remains uncertain
- which corpus/KG evidence supports the statement

---

## Dataset Discovery Sources

Package datasets are only the first source family.

The larger project has three source families:

1. R/Python package datasets.
2. Open scientific datasets linked to papers in spatial statistics,
   spatial econometrics, and spatio-temporal modeling.
3. Spatial and spatio-temporal datasets from data banks and portals.

The package route is currently prioritized because it is more controlled and
easier to connect to package documentation, examples, formulas, and papers.
Do not describe it as the only route.

---

## KG And Wiki Feedback Loop

Use this loop when improving the project:

1. Put validated source material in `corpus/`.
2. Extract structured evidence into the KG.
3. Query the KG for datasets, formulas, methods, packages, and papers.
4. If the KG relation is wrong, improve the extraction rule or source metadata.
5. If the KG relation is reliable, use it to update or create wiki synthesis.
6. If wiki review clarifies a concept, dataset role, or formula, encode that
   clarification back into KG rules, manifests, or source metadata.

The KG reduces repeated reading. The wiki improves interpretation quality.

---

## Package Dataset Documentation

For R package datasets, documentation is generated by:

```text
Code_scrapping/r_catalog/render_r_dataset_rd_docs.R
```

Expected outputs:

```text
wiki/datasets/r_package_docs/<package>/<package>.md
wiki/datasets/r_package_docs/<package>/refman.md
wiki/datasets/r_package_docs/<package>/topics/<dataset>.md
data/manifests/datasets/software_r_rd_documentation_index.csv
```

Use:

```r
source("Code_scrapping/r_catalog/render_r_dataset_rd_docs.R")
render_dataset_doc("spDataLarge", "lsl")
render_dataset_docs(c("spData", "spDataLarge", "agridat"))
render_package("spDataLarge")
render_package("spDataLarge", refman = TRUE)
```

Meaning:

- `<package>.md` summarizes the package/library itself.
- `topics/<dataset>.md` stores dataset help pages.
- `refman.md` stores the full package manual when requested.

Do not confuse:

- package/library help
- dataset help
- full refman
- KG extraction from those files

---

## Variable And Formula Policy

Always distinguish:

- all variables available in a dataset
- response variables used by a model
- covariates used by a model
- coordinates
- geometry columns
- identifiers
- time variables

It is normal for a variable to appear both as `HAS_VARIABLE` and
`HAS_RESPONSE` or `HAS_COVARIATE`.

Example:

```text
HAS_VARIABLE: lslpts
HAS_RESPONSE: lslpts
```

This means `lslpts` exists in the dataset and is also used as the response in a
documented formula.

Do not invent a regression formula. Formula links must come from one of:

- package documentation
- web/book documentation
- TEI section evidence
- code examples
- manually audited paper-dataset metadata

If a formula is inferred from damaged GROBID output, mark it as an inference in
the KG props and keep it reviewable.

---

## Papers And Bibliography

JabRef/BibDesk manage:

```text
corpus/bib/references.bib
```

Their role:

- citation key
- title
- authors
- year
- DOI
- venue
- local PDF path
- URL
- keywords/groups

JabRef/BibDesk are not the KG. They identify papers. The KG links papers to
datasets, formulas, methods, variables, packages, sections, and citations.

Keep paper DOI, dataset DOI, and archive DOI separate.

Do not maintain citation-count fields by default.

Do not use unauthorized paper download routes. Use legal sources only:

- publisher/institutional access available to the user
- Crossref
- Unpaywall
- OpenAlex
- DataCite
- Zenodo
- Figshare
- GitHub
- journal repositories
- author repositories
- official project pages

---

## GROBID

GROBID converts scientific PDFs:

```text
corpus/papers/raw_pdf/<paper>.pdf
corpus/papers/tei/<paper>.tei.xml
```

Use GROBID for PDFs. Do not use it for sources already available as HTML,
Markdown, Rmd, package documentation, or bookdown pages. Put those in
`corpus/web_md/` or package documentation outputs.

TEI is extraction, not truth. Important claims must be checked against source
context before entering the wiki.

---

## Answering User Questions

Use KG-first reasoning:

1. Query the KG.
2. If the KG is enough, answer from it and mention the relation path.
3. If the KG is incomplete, read linked wiki/corpus files.
4. If a KG relation is wrong, explain the extraction weakness and fix the rule
   when the user asks for implementation.
5. If current external facts are needed, use web verification.

When explaining KG output, translate relation names:

- `DOCUMENTED_BY`: where the source documentation is
- `HAS_VARIABLE`: variables present in the dataset
- `HAS_RESPONSE`: variable used as model response
- `HAS_COVARIATE`: variables used as predictors/covariates
- `SHOWS_FORMULA`: formula or model expression found in evidence
- `USES_DATASET`: paper or source uses this dataset
- `PROVIDES_DATASET`: package provides this dataset

---

## Wiki Update Policy

Do not touch `wiki/` unless the user asks for wiki edits or the task explicitly
requires stable documentation.

Before updating wiki pages:

1. Query the KG.
2. Read the evidence source.
3. Check if an existing wiki page should be updated instead of creating a new one.
4. Keep the edit minimal.
5. Update `wiki/index.md` and `wiki/log.md` only when meaningful durable pages
   are added or changed.

---

## Workflows

### Ingest

When the user says `ingest <source>`:

1. Read or inspect the source from the correct layer:
   - `raw/` is read-only;
   - validated sources belong in `corpus/`;
   - generated KG files are rebuilt, not edited manually.
2. Discuss key takeaways with the user and ask 1-3 clarifying questions if the
   source role, dataset link, formula, or target page is ambiguous.
3. Extract structured evidence into the KG when possible: paper, dataset,
   package, formula, method, variable, source and documentation relations.
4. Query the KG to check whether the entity already exists.
5. Create a summary page in `wiki/sources/`, `wiki/papers/`,
   `wiki/software/`, or `wiki/analyses/` as appropriate.
6. Identify affected wiki pages and update them.
7. Create new entity pages when warranted: dataset, paper, source, software,
   concept, estimator, formula note, or analysis.
8. Update `wiki/glossary.md` with any new or refined terms.
9. Update `wiki/index.md` with new pages and changed summaries.
10. Update `wiki/overview.md` if the source shifts the project picture.
11. Append an entry to `wiki/log.md`:

```markdown
## [YYYY-MM-DD] ingest | <source title>
Pages created: ...
Pages updated: ...
KG updates: ...
Key additions: ...
```

A single ingest may touch 5-15 wiki pages. That is expected. Keep unrelated
changes out of the operation.

### Search

When information is missing:

1. Query the KG first.
2. Use `mcp__dataset_search` for local catalog search.
3. Use `Code_scrapping/pipeline_lit/` for paper discovery if the target is
   scientific literature.
4. Use `Code_scrapping/pipeline_portals/` if the target is a data bank or portal.
5. Use web search only when local evidence is missing, stale, or the user asks
   for external verification.
6. Store useful search traces in manifests or `wiki/analyses/discovery/` when
   the result will guide future work.

### Query

When the user asks a question:

1. Query the KG first.
2. Read `wiki/index.md` to identify relevant wiki pages if the KG is incomplete
   or synthesis is needed.
3. Read only the relevant pages and linked corpus evidence.
4. Synthesize a clear answer with citations to KG relations, wiki pages, or
   corpus sources.
5. Ask: "Should I file this answer as a wiki page?" If yes, save it to
   `wiki/analyses/` or the appropriate durable page.
6. Append a log entry:

```markdown
## [YYYY-MM-DD] query | <question summary>
KG nodes consulted: ...
Pages consulted: ...
Output filed: yes/no - <filename if yes>
```

### Exploratory Dataset Discovery

When the user asks for dataset discovery without a specific topic:

1. Start from the three source families:
   - R/Python package datasets;
   - scientific papers with open spatial/ST data;
   - data banks and portals.
2. Prioritize datasets with spatial or spatio-temporal structure, clear
   metadata, documented variables, reproducible access and modeling evidence.
3. For each candidate, identify:
   - source family;
   - source page or corpus record;
   - dataset access route;
   - license;
   - spatial/time structure;
   - candidate `Y` and `X`;
   - formula/model evidence.
4. Store candidate traces in manifests or `wiki/analyses/discovery/`.
5. Do not clean, transform, or download large datasets unless explicitly asked.
6. Do not run evaluation/test layers unless explicitly asked.

### Lint

When the user says `lint the wiki`:

1. Read `wiki/index.md`, then scan all relevant wiki pages.
2. Use the KG to identify weakly connected concepts, datasets, papers, formulas
   and KG/wiki disagreements.
3. Report on:
   - contradictions between pages;
   - stale claims superseded by newer sources;
   - orphan pages with no inbound links;
   - concepts mentioned but lacking their own page;
   - missing cross-references that should exist;
   - terms used inconsistently across pages;
   - KG relations that contradict wiki interpretation.
4. Propose fixes and ask which ones to apply.
5. Append a log entry:

```markdown
## [YYYY-MM-DD] lint
Issues found: ...
Fixes applied: ...
KG/wiki changes: ...
```

---

## MCP And Local Tools

Prefer local tools before broad searches:

- `tools/kg/07_export_agent_index.py` for KG queries
- `tools/kg/run_all.py` for KG rebuilds
- `mcp__dataset_search` for dataset registry search
- `mcp__headroom` for context compression or rough token estimates
- `mcp__rtk` for compact command output
- `mcp__codebase_memory` for codebase symbols and architecture
- `rg` for fast file and text search

Do not treat MCP output as final truth. It is evidence to inspect.

---

## Token And Cost Discipline

Reduce context usage by default:

- query KG before reading large files
- read summaries before full sources
- use `rg` to locate evidence before opening files
- use `.kg/summaries/` before raw TEI when possible
- compress long terminal outputs with `mcp__rtk` or `mcp__headroom`
- avoid re-reading unchanged corpus files

Agents may estimate text size with local tooling when useful, but do not invent
exact token costs. If exact token accounting is not available in the interface,
say so plainly.

---

## Protected Areas

Do not modify unless explicitly requested:

```text
raw/
LLM-wiki-Assessment/
.eval/
eval/
```

Do not edit generated `.kg/` files manually.

---

## Session Start Checklist

At the start of a session:

1. Read `AGENTS.md`.
2. Read `wiki/index.md` to orient yourself.
3. Read the last 5 entries in `wiki/log.md` to understand recent activity.
4. Check `git status`.
5. Query the KG if the task concerns datasets, papers, formulas, methods,
   packages, or wiki synthesis.
6. Ask the user what they want to do: ingest, query, lint, or something else.
7. Inspect relevant scripts before editing code or pipelines.

---

## Core Principle

Use this reasoning order:

```text
KG first -> source evidence -> metadata -> variable roles -> model evidence -> wiki synthesis
```

For dat
